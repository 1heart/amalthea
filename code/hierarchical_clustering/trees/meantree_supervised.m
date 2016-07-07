function [T] = meantree_supervised(D, branchingFactors, ids)

[n d] = size(D);

% Base case: set the default values for the leaves
T.ids = ids;
T.num = n;
T.children = [];
T.mean = sum(D,1);
T.mean = T.mean / norm(T.mean);

if n == 1; return; end;
if (length(branchingFactors) == 0)
  currBF = n;
else
  currBF = branchingFactors(1);
end
currBF = min(T.num, currBF);

numPerChild = ceil(n / currBF);

ptr = 1;
for i = 1:currBF
  start = ptr;
  stop = min(n, start + numPerChild - 1);
  T.children = [T.children meantree_supervised(D(start:stop, :), branchingFactors(2:end), ids(start:stop))];
  ptr = ptr + numPerChild;
end

end
