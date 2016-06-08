%--------------------------------------------------------------------------
% Function:    eval_unsupervised_kmean
% Description: Evaluates model-to-mean retrieval by clustering.
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

function result = eval_unsupervised_kmeans(D, L, currMetrics, DEBUG, DISPLAY)

numRuns = 1; % Number of runs for k-means

[n d] = size(D);
uniqueLabels = unique(L);
numLabels = length(uniqueLabels);

% Cluster with the number of true categories
[best_x,best_f,mem,empty,loop]=SPKmeans(D,numLabels,numRuns);

distMatrix = nan(n);
% Create a distance matrix
% 	such that the distances between points
% 	are 0 if they are in the same class, and
% 	are >0 if they aren't.
for i = 1:n
  distMatrix(i,:) = abs(mem - mem(i));
end

% Run all the currMetrics on the distance matrix,
% 	and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  result = [result; map];
end

end
