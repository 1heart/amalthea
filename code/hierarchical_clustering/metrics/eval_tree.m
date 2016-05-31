function result = eval_tree(D, L, metrics, tree_constructor, DEBUG)
% Takes in a nxd data matrix D, true labels L, a cell array of metric function handles, and a tree constructor
% and returns a struct with fields equal to the results of the metrics

[n d] = size(D);
T = tree_constructor(D, DEBUG);

% Construct distance matrix
distMatrix = zeros(n);

for i = 1:n
  [ids dists] = t_retrieve(T, D(i,:), n);

  % Construct a distance measure based on order:
  % If an element e is at position j, then it has
  % j distance from the query shape
  for j = 1:n
    distMatrix(i, ids(j)) = j;
  end
end

% Run all the metrics on the distance matrix, and set the result's fields equal to the results of the metric
result = containers.Map;
for i = 1:length(metrics)
  metric = metrics{i};
  map = metric(distMatrix, L);
  result = [result; map];
end

end
