function [] = draw_tree(T)

n = length(T.ids);
numLevels = max(1,ceil(log2(2*n-1)));
% color = ([1 0.5 1]./numLevels);
color = 0.3 + zeros(1,3);

numChildren = size(T.children, 2);
if n > 1
  scatter3(T.mean(1), T.mean(2), T.mean(3), 25, color, 'filled');
end
for i = 1:numChildren
  curr = T.children(i);
  circline(T.mean, curr.mean, color);
  hold on;
  draw_tree(curr);
end

end
