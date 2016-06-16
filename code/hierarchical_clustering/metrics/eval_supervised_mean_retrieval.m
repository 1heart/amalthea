%--------------------------------------------------------------------------
% Function:    eval_supervised_mean_retrieval
% Description: Evaluates model-to-mean retrieval, given the correct classes.
% 
% Inputs: 
%
% D       - An nxd matrix of the datapoints.
%
% L                      - The true labels that correspond to each data point in D.
%
% DEBUG                  - Boolean if printing out values
%
% DISPLAY                - Boolean for displaying the results of the metrics
%
% Outputs
% 
% metricObject           - A map from 'metric' to a value.
%
% Usage: Used in hierarchical retrieval on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function result = eval_supervised_mean_retrieval(D, L, currMetrics, DEBUG, DISPLAY, distfunc)

if (nargin < 6) distfunc = @sphere_norm; end;

[n d] = size(D);
uniqueLabels = unique(L);
numLabels = length(uniqueLabels);

means = nan(numLabels, d); % Find the means for each cluster
for i = 1:numLabels
  dataIndices = find(L == i); % Find all points that belong to cluster i
  currMean = sum(D(dataIndices, :));
  currMean = currMean / norm(currMean);
  means(i,:) = currMean;
end

closestMeans = nan(n,1); % Find the closest mean for each point
for i = 1:n
  % Keep track of minimum distance and the closest mean
  minDist = inf; closestMean= 0;
  for j = 1:numLabels % Find the closest mean (label)
    distToMean = distfunc(D(i,:), means(j,:));
    if distToMean < minDist
      minDist = distToMean;
      closestMean = j;
    end
  end
  closestMeans(i) = closestMean;
end

meanDists = zeros(numLabels); % Find the pairwise distances between means
for i = 1:numLabels
  for j = i+1:numLabels
    meanDists(i,j) = distfunc(means(i,:), means(j,:));
    meanDists(j,i) = meanDists(i,j);
  end
end

% Find the distance matrix between each point
%   by using the distance between their closest means
distMatrix = zeros(n);
for i = 1:n
  for j = i+1:n
    distMatrix(i,j) = meanDists(closestMeans(i), closestMeans(j));
    distMatrix(j,i) = distMatrix(i,j);
  end
end

% Run all the currMetrics on the distance matrix
%   and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  result = [result; map];
end



end
