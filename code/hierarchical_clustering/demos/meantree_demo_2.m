% -------------------------------------------------------------------------
% Script: spherical_k_means_demo
% Author:   Mark Moyou (mmoyou@my.fit.edu)
%       Yixin Lin (yixin1996@gmail.com)
%       Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This illustrates a hierarchical-clustering tree by
%   recursively drawing lines to the tree's children.
%   This also traces a traversal to a leaf, pausing at every step.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

colors = [
88 140 115;
242 227 148;
242 174 114;
217 100 89;
140 70 70;
] / 255;
colormap(colors);



numClusters = 5;
numPoints = 10;
kappa = 200; % concentration parameter
numRuns = 1;
[dataMatrix, meanMatrix, memMatrix] = random_spherical_data(numClusters, numPoints, kappa);

T = meantree(dataMatrix);
% [T C] = meantree2(dataMatrix);

graph = 1;

if graph
% Graph transparent sphere
  [sx, sy, sz] = sphere;
  surface(sx,sy,sz,'FaceColor', zeros(3,1)+1,'EdgeColor',zeros(3,1)+0.8);
  hold on;

% Graph data
  scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),50,memMatrix, 'filled'); % clustered points
  % hold on;
  % scatter3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),100,'k','x'); % true means
  % hold on;
  draw_tree(T);

end

redraw = @() draw_tree(T);

traversal = [];
curr = T;
while 1 % Traverse the tree
  traversal = [traversal curr];
  if isequal(curr.children, []) break; end; % If no more children, stop
  curr = randsample(curr.children, 1); % Pick a child to traverse down
end;

for i = 2:length(traversal) % Print the traversal
  prev = traversal(i-1); curr = traversal(i);
  circline(prev.mean, curr.mean, [1 0 0]);
  disp(['starting level: ' num2str(i)]);
  pause;
end;

