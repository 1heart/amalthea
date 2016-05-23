function [ C ] = meantree2_recurse(D, C, numChild)

[n d] = size(D);
l = size(C, 2);

numClusters = floor(n / numChild);
[means, loss_val, categories] = SPKmeans(D, numClusters);

C{l+1}.means = means;

children = {};
for i = 1:size(means,1)
  children{i} = find(categories == i);
end

C{l+1}.children = children;

% This is a comment
if size(means, 1) ~= 1
  C = meantree2_recurse(means, C, numChild);
end

