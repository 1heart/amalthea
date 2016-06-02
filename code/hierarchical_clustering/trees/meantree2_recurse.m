function [ C ] = meantree2_recurse(D, C, numChild, DEBUG)

[n d] = size(D);
l = size(C, 2);

persistent numSoFar;
persistent numTotal;

if DEBUG == 1
  numSoFar = 0;
  numTotal = n * 2 - 1;
  textprogressbar('calculating meantree2: ');
  textprogressbar(0);
  textprogressbar(' ');
  DEBUG = 2;
end

numClusters = floor(n / numChild);
[means, loss_val, categories, empty, loop] = SPKmeans(D, numClusters, 1, 'rand');

C{l+1}.means = means;

children = {};
for i = 1:size(means,1)
  children{i} = find(categories == i);
end

C{l+1}.children = children;

if DEBUG
  numSoFar = numSoFar + n;
  textprogressbar('calculating meantree2: ');
  textprogressbar(100 * numSoFar / numTotal);
  textprogressbar(' ');
end

if size(means, 1) ~= 1
  C = meantree2_recurse(means, C, numChild, DEBUG);
end

