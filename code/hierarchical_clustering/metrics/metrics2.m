function  [metricObj] = metrics2(distMatrix, trueLabels, DISPLAY)
[m, n] = size(distMatrix);
if m ~= n
    error('Distance matrix is not square!');
end

uniqueLabels = unique(trueLabels);
numPerLabel = hist(trueLabels, uniqueLabels);

% Cumulated gain: cumulated number of correct labels at each position
CG = zeros(1,n);
% Discounted cumulated gain: cumulated gain 
%   with a discount factor log_2(i)
DCG = zeros(1,n);
% Ideal discounted cumulated gain: the best possible
%   DCG (all relevant topics at the top) for the query
iDCG = zeros(1,n);
% Normalized discounted cumulated gain: the ratio between
%   the actual DCG and the the ideal DCG
nDCG = zeros(1,n);
% Nearest neighbor: if the closest predicted label is correct
NN = zeros(1,n);
% First tier: if the closest C labels are correct (C is the number of
% shapes per class)
FT = zeros(1,n);
% Second tier: if the closest 2C labels are correct
ST = zeros(1,n);

for i = 1:n
    trueLabel = trueLabels(i);
    distances = distMatrix(i,:);
    
    [~, sortedIndices] = sort(distances);
    sortedLabels = trueLabels(sortedIndices);
    
    currCGArr = cumsum(sortedLabels == trueLabel);
    CG(i) = sum(currCGArr);
    % ICGArr is what CGArr would be if every relevant datum is at the front
    %   Construct it in parallel with the actual order of retrieval
    currICGArr = cumsum(sort(sortedLabels == trueLabel, 'descend'));
    
    currDCGArr = zeros(1,n); currIDCGArr = zeros(1,n);
    currDCGArr(1) = currCGArr(1); currIDCGArr(1) = currCGArr(1);
    for j = 2:n
        currDCGArr(j) = currDCGArr(j-1) + (currCGArr(j) / log2(j));
        currIDCGArr(j) = currIDCGArr(j-1) + (currICGArr(j) / log2(j));
    end
    DCG(i) = sum(currDCGArr);
    iDCG(i) = sum(currIDCGArr);
    
    numInClass = numPerLabel(trueLabel);
    nDCG(i) = DCG(i) / iDCG(i);
    NN(i)=currCGArr(1);
    FT(i)=currCGArr(numInClass)/(numInClass);
    stNum = min([n 2*numInClass]);
    ST(i)=currCGArr(stNum)/stNum;
end

avgNDCG = mean(nDCG);
avgNN = mean(NN);
avgFT = mean(FT);
avgST = mean(ST);

keySet = {'avg_ndcg', 'avg_nearest_neighbor', 'avg_first_tier', 'avg_second_tier'};
valueSet = {avgNDCG, avgNN, avgFT, avgST};
metricObj = containers.Map(keySet, valueSet);

end
