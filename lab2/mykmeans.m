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
end

