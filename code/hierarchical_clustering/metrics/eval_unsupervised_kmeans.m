function result = eval_unsupervised_kmeans(D, L, currMetrics, DEBUG, DISPLAY)

numRuns = 1;

[n d] = size(D);
uniqueLabels = unique(L);
numLabels = length(uniqueLabels);

[best_x,best_f,mem,empty,loop]=SPKmeans(D,numLabels,numRuns);

distMatrix = nan(n);
for i = 1:n
  distMatrix(i,:) = abs(mem - mem(i));
end

% Run all the currMetrics on the distance matrix, and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  result = [result; map];
end

end
