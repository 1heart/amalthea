%--------------------------------------------------------------------------
% Function:    link_tree
% Description: Constructs a hierarchical tree 
%   from the MATLAB implementation of hierarchical clustering (using linkage).
% 
% Inputs: 
%
% D                 - An nxd matrix of data points.
%
% DEBUG             - Boolean for printing debug statements (default = 0).
%
% Outputs
% 
% T                 - A hierarchical array struct with fields
%   T.num             = the total number of observations in T
%   T.children        = array of mean-trees
%   T.mean            = 1xd vector of the average of all of T's children's means
%   T.ids             = array of indices of the observations, if a leaf node
%
% Usage: Used in hierarchical tree clustering on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function T = link_tree(D, DEBUG)

if nargin < 2
  DEBUG = 0;
end

[n d] = size(D);

if DEBUG
  totalOps = n * (n-1) / 2;
  ops = 0;
  textprogressbar('calculating link_tree: ');
end;

% Find pairwise distances
pairdists = zeros(n,n);
for i = 1:n
  for j = i+1:n
    curr = sphere_dist(D(i,:), D(j,:));
    pairdists(i,j) = curr; pairdists(j,i) = curr;
    if DEBUG
      ops = ops + 1;
      textprogressbar(ops * 100 /totalOps );
    end
  end
end

pairdists = real(pairdists); % Only take the real values.

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

if DEBUG; textprogressbar(' done.'); end;

end
