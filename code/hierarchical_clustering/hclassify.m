function [c] = hclassify(T, Q)

% HCLASSIFY
% Given a mean-tree T and query Q,
%   return the indices that correspond to the lowest leaf's ids.

if (size(T.children) == 0)
  c = T.ids;
else
  dists = arrayfun(@(currT) sphere_norm(currT.mean, Q), T.children);
  [minDist, minIndex] = min(dists);
  c = hclassify(T.children(minIndex), Q);
end

end
