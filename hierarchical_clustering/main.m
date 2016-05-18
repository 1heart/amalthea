addpath('../CircStat2012a');
addpath('../SPKmeans');

numClusters = 15;
numPoints = 10;
kappa = 100; % concentration parameter
[dataMatrix, meanMatrix] = random_spherical_data(numClusters, numPoints, kappa);

[best_x,best_f,mem,empty,loop]=SPKmeans(dataMatrix,numClusters,3, 'rand');

% Graph transparent sphere
[sx, sy, sz] = sphere;
surface(sx,sy,sz,'FaceColor', 'none','EdgeColor',[0.8 0.8 0.8])
hold on;

% Graph data
scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),4,mem); % clustered points
scatter3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),100,'k','x'); % true means
scatter3(best_x(:,1), best_x(:,2), best_x(:,3), 100, 'r', 'x'); % estimated means

