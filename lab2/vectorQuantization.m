function [ compressed ] = vectorQuantization( I,k,blockSize)
%VECTORQUANTIZATION Compress the image I 
%   Divide the matrix I into blocks of size  [blockSize x blockSize], 
%   cluster them into k clusters and replace each block with it's clusters 
%   centroid. You might assume that the size of I and blockSize will be a
%   powert of two. Resulting matrix should be of type uint8
%
%   I           - n x m matrix of representing grayscale image
%   k           - number of clusters
%   blockSize   - block size of the quantization
%
%   Output:
%   
%   compressed - compressed image using specified number of
%       clusters and blockSize
%
%   author: Ivan Bogun

% your code

end

