function result = eval_supervised_mean_retrieval(D, L, currMetrics, DEBUG, DISPLAY)

numRuns = 1;

[n d] = size(D);
uniqueLabels = unique(L);
numLabels = length(uniqueLabels);

means = nan(numLabels, d);
for i = 1:numLabels
  dataIndices = find(L == i);
  currMean = sum(D(dataIndices, :));
  currMean = currMean / norm(currMean);
  means(i,:) = currMean;
end

closestMeans = nan(n,1);
for i = 1:n
  minDist = inf;
  closestMean= 0;
  for j = 1:numLabels
    distToMean = sphere_norm(D(i,:), means(j,:));
    if distToMean < minDist
      minDist = distToMean;
      closestMean = j;
    end
  end
  closestMeans(i) = closestMean;
end

meanDists = zeros(numLabels);
for i = 1:numLabels
  for j = i+1:numLabels
    meanDists(i,j) = sphere_norm(means(i,:), means(j,:));
    meanDists(j,i) = meanDists(i,j);
  end
end

distMatrix = zeros(n);
for i = 1:n
  for j = i+1:n
    distMatrix(i,j) = meanDists(closestMeans(i), closestMeans(j));
    distMatrix(j,i) = distMatrix(i,j);
  end
end

% Run all the currMetrics on the distance matrix, and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  result = [result; map];
end



end
