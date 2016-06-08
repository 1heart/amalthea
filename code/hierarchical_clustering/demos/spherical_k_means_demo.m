% -------------------------------------------------------------------------
% Script: spherical_k_means_demo
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This demonstrates spherical k-means by randomly constructing
% 	points from a von Mises distribution and comparing the resulting means.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

numClusters = 15;
numPoints = 10;
kappa = 100; % concentration parameter
numRuns = 1;
[dataMatrix, meanMatrix] = random_spherical_data(numClusters, numPoints, kappa);

[best_x,best_f,mem,empty,loop]=SPKmeans(dataMatrix,numClusters,numRuns);

% Graph transparent sphere
[sx, sy, sz] = sphere;
surface(sx,sy,sz,'FaceColor', 'none','EdgeColor',[0.8 0.8 0.8])
hold on;

% Graph data
scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),4,mem); % clustered points
scatter3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),100,'k','x'); % true means
scatter3(best_x(:,1), best_x(:,2), best_x(:,3), 100, 'r', 'x'); % estimated means

