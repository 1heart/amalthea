% Deprecated

%   Goal is to plot a recall vs. precision graph. Let's start with one array
%   as the submitted results of our algorithm

function [precisionRecallObj] = metrics1(distanceMatrix, trueLabels, DISPLAY)

[m n] = size(distanceMatrix);

if m ~= n
  error('Distance matrix is not square!');
end

uniqueCategories = unique(trueLabels);
shapesPerCategory = hist(trueLabels, uniqueCategories);
precision = nan(size(distanceMatrix));
recall = nan(size(distanceMatrix));
avgRecall = nan(n,1);
avgPrecision = nan(n,1);

for i = 1:n
  trueLabel = trueLabels(i);
  [~, sortedInd] = sort(distanceMatrix(i,:));
  sortedCat = trueLabels(sortedInd);

  cumulativeCorrect = cumsum(sortedCat == trueLabel);
  precision(i,:) = cumulativeCorrect./[1:n]';
  recall(i,:) = cumulativeCorrect./shapesPerCategory(trueLabel);

  avgPrecision(i) = mean(precision(i,:));
end

meanAveragePrecision = mean(avgPrecision);

eMeasure32 = nan(n,1);
if n >= 32
  precision32 = precision(:,32);
  recall32 = recall(:,32);
  eMeasure32 = 1 - 2. / ((1./precision32) + (1./recall32));
end

avgEMeasure32 = mean(eMeasure32);

keySet = {'precision', 'recall', 'e_measure_32', 'avg_e_measure_32', 'mean_avg_precision'};
valueSet = {precision, recall, eMeasure32, avgEMeasure32, meanAveragePrecision};
precisionRecallObj = containers.Map(keySet, valueSet);

end

