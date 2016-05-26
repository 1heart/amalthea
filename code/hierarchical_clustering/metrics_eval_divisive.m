function results = metrics_eval_divisive(D, metrics)

[n d] = size(D);
T = meantree(D);

% Distance matrix
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

for i = 1:length(metrics)
  metric = metrics(i);
  currResult = metric(distMatrix);
end

end
