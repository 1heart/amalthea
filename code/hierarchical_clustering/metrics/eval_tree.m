function result = eval_tree(D, L, currMetrics, tree_constructor, DEBUG, DISPLAY)
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

% Run all the currMetrics on the distance matrix, and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(currMetrics)
  currMetric = currMetrics{i};
  map = currMetric(distMatrix, L, DISPLAY);
  result = [result; map];
end

end
