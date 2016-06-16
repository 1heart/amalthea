%--------------------------------------------------------------------------
% Function:    t_retrieve
% Description: Retrieves from a meantree by recursively concatenating
%               the closer and farther subproblems.
% 
% Inputs: 
%
% T                 - A meantree as specified in meantree.
%
% Q                 - A query shape.
%
% n                 - The number of shapes to retrieve.
%
% Outputs
% 
% ids               - The ids of the data, ordered from closest to farthest.
%
% dists             - The distances to the corresponding data points.
%
% Usage: Used in hierarchical tree clustering on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------


function [ ids dists ] = t_retrieve(T, Q, n)
% T_RETRIEVE
  % Given a tree T (see specification in meantree.m),
  % a query Q of the same dimension as the data in T,
  % and an optional number of elements returned n,
  % return the permutation of original data IDs ids,
  % and assigned distances dists

if nargin < 3
  n = 1;
end

% If children is a single treenode, or there are no children
if length(T.children) == 0
  ids = T.ids;
  dists = [ sphere_dist(T.mean, Q) ];
  return;
end

distsToChildren = arrayfun(@(x) sphere_dist(x.mean, Q), T.children);
[sortedDists, sortedIDs] = sort(distsToChildren);

numTotal = 0;
ids = []; dists = [];
% Grab each child in order of closeness, recurse, and add to the result
for i = 1:size(T.children, 2)
  currChild = T.children(sortedIDs(i));
  numTotal = numTotal + currChild.num;
  [childIDs childDists] = t_retrieve(currChild, Q, n);
  ids = [ids childIDs]; dists = [dists childDists];
  if numTotal >= n break; end;
end

if size(ids,2) > n
  ids = ids(1:n); dists = dists(1:n);
end;

end
