%--------------------------------------------------------------------------
% Function:    eval_tree
% Description: Given a hierarchical tree constructor,
%   construct the tree and run metrics on it
% 
% Inputs: 
%
% D                      - A nxd dataMatrix.
%
% L                      - The true labels that correspond to each data point in D.
%
% tree_constructor       - The function handle that constructs the tree.
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

function metricObject = eval_tree(D, L, currMetrics, tree_constructor, DEBUG, DISPLAY)
% Takes in a nxd data matrix D, true labels L, a cell array of metric function handles, and a tree constructor
% and returns a struct with fields equal to the results of the currMetrics

[n d] = size(D);
T = tree_constructor(D, DEBUG);

% Construct distance matrix
distMatrix = zeros(n);

if DEBUG textprogressbar('Retrieving tree: '); end;
for i = 1:n
  if DEBUG textprogressbar(100 * i / n); end;
  [ids dists] = t_retrieve(T, D(i,:), n);

  % Construct a distance measure based on order:
  % If an element e is at position j, then it has
  % j distance from the query shape
  for j = 1:n
    distMatrix(i, ids(j)) = j;
  end
end
if DEBUG textprogressbar(' done.'); end;

% Run all the currMetrics on the distance matrix, and set the metricObject's fields equal to the results of the metric
metricObject = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  metricObject = [metricObject; map];
end

end
