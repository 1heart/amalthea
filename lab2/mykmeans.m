function [ idx,  C, sumD, D] = mykmeans( X,k, maxIterations)
%MYKMEANS Cluster the data, X, via k-means with given k
%   Cluster the [n x m] matrix X into k clusters. Resulting n x 1
%   matrix, idx, has to contain partition of the data into k clusters.
%
%   
%
%   Input:
%       X           -       n x m data matrix, Rows of X
%           correspond to points, columns correspond to variables.
%       k           -       number of clusters
%       maxIterations -     maximum number of iterations to perform
%
%   Output:
%
%       idx         -       n x 1 matrix containing labels of each data point 
%       C           -       k x m matrix with cluster centroids
%       sumD        -       k x 1 matrix which contains within-the-class
%           error
%       D           -       n x k matrix containing the distances of each
%           point to each cluster
%
%   
%   author: Ivan Bogun
%   


[m, n] = size(X);
epsilon = 0.001;

centroids = datasample(X, k, 'Replace', false);
idx = zeros(m, 1);

for iter = 1:maxIterations
  labels = cell(k, 1);
  for i = 1:k
    labels{i} = [];
  end
  for i = 1:m
    curr = X(i, :);
    centroidDists = [];
    for j = 1:k
      centroidDists(j) = sum((curr - centroids(j,:)).^2);
    end
    [minVal, minIndex] = min(centroidDists);
    labels{minIndex} = [labels{minIndex}, curr'];
    idx(i) = minIndex;
  end
  newCentroids = [];
  for i = 1:k
    newCentroids = [newCentroids, mean(labels{i}, 2)];
  end

  newCentroids = newCentroids';

  diff = sum((centroids - newCentroids).^2);
  if (diff < epsilon)
    break;
  end

  centroids = newCentroids;
end

C = centroids;
D = [];
for i = 1:k
  D = [D, sum(arrayfun(@(x) sqrt(sum((centroids(i,:) - x).^2)), X),2)];
end
sumD = sum(D);

end

