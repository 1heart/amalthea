function [T C] = meantree2(D, DEBUG)
% MEANTREE2
% Hierarchical Agglomerative Clustering
% INPUTS:
%   D   = nxd matrix of observations
%
% OUTPUTS:
%   T.num       = the total number of observations in T
%   T.children  = array of mean-trees
%   T.mean      = 1xd vector of the average of all of T's children's means
%   T.ids       = array of indices of the observations, if a leaf node

if nargin < 2
  DEBUG = 0;
end

numChild = 2;
[n d] = size(D);


C = {};
C{1}.means = D;
C{1}.children = {};
for i = 1:size(D,1)
  C{1}.children{i} = [];
end

C = meantree2_recurse(D, C, numChild, DEBUG);

T = meantree2_nodify(C, size(C,2), 1);

end
