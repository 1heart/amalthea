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
if strcmp(class(T.children), class(struct)) || length(T.children) == 0
  ids = T.ids;
  dists = [ sphere_norm(T.mean, Q) ];
  return;
end

distsToChildren = arrayfun(@(x) sphere_norm(x.mean, Q), T.children);
[sortedDists, sortedIDs] = sort(distsToChildren);

numTotal = 0;
ids = []; dists = [];
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
