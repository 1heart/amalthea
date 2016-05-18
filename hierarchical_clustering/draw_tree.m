function [] = draw_tree(D, T)

numChildren = size(T.children, 2);
scatter3(T.mean(1), T.mean(2), T.mean(3), 25, 'r', 'x');
for i = 1:numChildren
  curr = T.children(i);
  plot3([T.mean(1); curr.mean(1)], [T.mean(2); curr.mean(2)], [T.mean(3); curr.mean(3)]);
  hold on;
  draw_tree(D, curr);
end

end
