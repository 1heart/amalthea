function [ normalizedX, meanFace ] = normalizeData(X)
%NORMALIZEDATA Perform normalization of the matrix X
%   X is assumed to be [n x m] matrix, where m is the number of images and
%   n is the size of the image resized as a column vector. The function
%   will substract the mean image , meanFace, from  every column and divide
%   each column by the variance of its column. ( see pdf for details)
%
%
%   Input:
%
%   X           -       [n x m] unnormalized data matrix, m - number of
%       images, n - image reshaped as a column vector
%   
%   Output:
%
%   normalizedX -       [n x m] normalized data matrix (substracted mean,
%       divided by the variance)
%   meanFace    -       [n x 1] vector which is a mean face from the X matrix
%
%   author: Ivan Bogun

% your code here

[m n] = size(X);

meanFace = mean(X);

normalizedX = X;
normalizedX = bsxfun(@minus, normalizedX, meanFace);
variances = sum(normalizedX.^2, 2) / n;
normalizedX = bsxfun(@rdivide, normalizedX, sqrt(variances));

end

