function T = meantree2(D)

numChild = 2;
[n d] = size(D);


C = {};
C{1}.means = D;
C{1}.children = {};
for i = 1:size(D,1)
  C{1}.children{i} = [];
end

C = meantree2_recurse(D, C, numChild);

T = meantree2_nodify(C, size(C,2), 1);

end
