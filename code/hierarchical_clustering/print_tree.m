function [] = print_tree(T, level)

if nargin < 2
  level = 0;
end

for i = 1:size(T.mean,2)
  fprintf(repmat(' ', 1, level * 4));
  fprintf(num2str(T.mean(i)));
  fprintf('\n');
end
fprintf('\n');

children = T.children;
for i = 1:size(children,2)
  print_tree(children(i), level + 1);
end

end
