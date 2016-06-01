function [] = print_tree(T, level)

if nargin < 2
  level = 0;
end

prefix = repmat(' ', 1, level * 4);

for i = 1:size(T.mean,2)
  fprintf(prefix);
  fprintf(num2str(T.mean(i)));
  fprintf('\n');
end
fprintf(prefix);
fprintf('---\n');
for i = 1:size(T.ids,2)
  fprintf(prefix);
  fprintf(num2str(T.ids(i)));
  fprintf('\n');
end
fprintf('\n');

children = T.children;
for i = 1:size(children,2)
  print_tree(children(i), level + 1);
end

end
