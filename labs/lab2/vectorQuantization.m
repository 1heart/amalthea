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

[m n] = size(I);
mNew = m / blockSize(1);
nNew = m / blockSize(2);

C = mat2cell(I, blockSize(1) + zeros(mNew, 1), blockSize(2) + zeros(nNew, 1));
X = zeros(size(C, 1), blockSize(1) * blockSize(2));
iter = 1;
for i = 1:size(C,1)
  for j = 1:size(C, 2)
    curr = C{i, j};
    X(iter, :) = curr(:)';
    iter = iter + 1;
  end
end
size(X)

[idx, C, sumD, D] = mykmeans(X, k, blockSize);
avgImg = arrayfun(@(x) mean(C(x)), idx);
compressed = reshape(avgImg, mNew, nNew);
compressed = round(compressed);

compressed=compressed-min(compressed(:)); % shift data such that the smallest element of A is 0
compressed=compressed/max(compressed(:)); % normalize the shifted data to 1 
compressed=compressed';


end

