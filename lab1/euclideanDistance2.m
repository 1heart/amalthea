function [A] = euclideanDistance2(X)
X = X';
n = size(X, 2);

Y = repmat(X, n, 1);
Z = repmat(X(:), 1, n);
A = euclideanDistance(Y, Z)
end
