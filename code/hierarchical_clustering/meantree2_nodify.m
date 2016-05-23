function T = meantree2_nodify(C, l, index)

T.mean = C{l}.means(index,:);
T.children = [];
if l == 1
  T.num = 1;
  T.ids = [index];
  return;
end

T.num = 0;
T.ids = [];
childPointers = C{l}.children{index};
for i = 1:size(childPointers,2)
  child = meantree2_nodify(C, l-1, childPointers(i));
  T.num = T.num + child.num;
  T.ids = [T.ids child.ids];
  T.children = [T.children child];
  T.children
end

end
