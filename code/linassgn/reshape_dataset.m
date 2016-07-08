function [dataset] = reshape_dataset(dataset, n)

dataset.data = dataset.data(1:n, :);
dataset.labels = dataset.labels(1:n, :);
dataset.dimensions(1) = n / dataset.dimensions(2);

end
