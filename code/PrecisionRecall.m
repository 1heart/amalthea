%   Goal is to plot a recall vs. precision graph. Lets start with one array
%   as the submitted results of our algorithm
%trueCat = [ 1 2 1 3 2 3 1 3 2 ];
%dist = [ 0.1 0.4 0.2 0.7 0.5 0.3 0.8 0.9 0.6 ];
%queryClass = 1;
%shCat = 3;
%dist = [ 0.1 0.4 0.2 0.7 0.5 0.3 0.8 0.9 0.6;
%         0.4 0.1 0.6 0.5 0.2 0.7 0.8 0.9 0.3 ];

function [precisionRecallObj] = PrecisionRecall(dist, trueCat)

uniqueCat = unique(trueCat);
shapes_cat = hist(trueCat, uniqueCat);
precision = zeros();
for j = 1:size(dist,1)
    queryShape = trueCat(j);
    [~, sortedInd] = sort(dist(j,:));
    sortedCat = trueCat(sortedInd);

    p_points = find(sortedCat == queryShape);

    for i = 1:length(p_points)
        p(i) = i/p_points(i);
        precision(j,i) = p(i);
    end
end
recall = [1:shapes_cat]./shapes_cat
precision = mean(precision)

precision_32 = precision(:,1:32);
recall_32 = recall(:,1:32);
eMeasure = 1 - (2/((1/precision_32)+(1/recall_32)));


keySet = {'Precision Values', 'Recall Values', 'E-Measure'};
valueSet = {precision, recall, eMeasure};
precisionRecallObj = containers.Map(keySet, valueSet);



end

