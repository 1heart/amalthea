% -------------------------------------------------------------------------
% Script: spherical_k_means_demo
% Author:   Mark Moyou (mmoyou@my.fit.edu)
%       Yixin Lin (yixin1996@gmail.com)
%       Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This illustrates a hierarchical-clustering tree by
%   recursively drawing lines to the tree's children.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

numClusters = 15;
numPoints = 10;
kappa = 100; % concentration parameter
numRuns = 1;
[dataMatrix, meanMatrix, memMatrix] = random_spherical_data(numClusters, numPoints, kappa);

T = meantree(dataMatrix);
% [T C] = meantree2(dataMatrix);

graph = 0;

if graph
% Graph transparent sphere
  [sx, sy, sz] = sphere;
  surface(sx,sy,sz,'FaceColor', 'none','EdgeColor',[0.8 0.8 0.8]);
  hold on;

% Graph data
  scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),4,memMatrix); % clustered points
  hold on;
  scatter3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),100,'k','x'); % true means
  hold on;
  draw_tree(dataMatrix, T);

end

