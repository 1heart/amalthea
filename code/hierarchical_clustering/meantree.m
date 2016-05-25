function T = meantree(D, branchingFactor, ids)
% CREATE_MEAN_TREE
%   Given D, an nxd matrix of observations,
%   and L, an nx1 matrix of labels,
%   construct and return a mean-tree T (array struct) with fields
%     T.num       = the total number of observations in T
%     T.children  = array of mean-trees
%     T.mean      = 1xd vector of the average of all of T's children's means
%     T.ids       = array of indices of the observations, if a leaf node

[n d] = size(D);

if nargin < 2
  branchingFactor = 2;
end
if nargin < 3
  ids = 1:n;
end

T.num = size(D, 1);
T.children = [];
T.mean = sum(D,1);
T.mean = T.mean / norm(T.mean);
T.ids = ids;

if n == 1
  return;
end

branchingFactor = min(T.num, branchingFactor);
[means, loss_val, categories, empty, loop] = SPKmeans(D, branchingFactor, 1);

for i = 1:branchingFactor
  currIDs = find(categories == i);
  currD = D(currIDs, :);
  currIDs = ids(currIDs);
  T.children = [T.children meantree(currD, branchingFactor, currIDs)];
end

end
