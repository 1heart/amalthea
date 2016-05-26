function T = link_tree(D)

[n d] = size(D);


% Find pairwise distances
pairdists = zeros(n,n);
for i = 1:n
  for j = i+1:n
    curr = sphere_norm(D(i,:), D(j,:));
    pairdists(i,j) = curr; pairdists(j,i) = curr;
  end
end

% Find linkage
Z = linkage(pairdists);

% Build tree structure

% Get initial nodes
nodes = [];
for i = 1:n
  nodes(i).num = 1;
  nodes(i).children = [];
  nodes(i).mean = D(i,:);
  nodes(i).ids = [i];
end

% Merge nodes
for i = 1:size(Z,1)
  curr = struct;
  curr.children = [nodes(Z(i,1)) nodes(Z(i,2))];
  curr.num = 0;
  curr.ids = [];
  curr.mean = zeros(1,d);
  for j = 1:size(curr.children,2)
    curr.num = curr.num + curr.children(j).num;
    curr.ids = [curr.ids curr.children(j).ids];
    curr.mean = curr.mean + curr.children(j).mean;
  end
  curr.mean = curr.mean / norm(curr.mean);
  nodes(size(nodes,2) + 1) = curr;
end

% Return last node
T = nodes(size(nodes,2));

end
