function [dataMatrix, meanMatrix] = random_spherical_data(numClusters, numPoints, kappa)

addpath('../CircStat2012a');
addpath('../SPKmeans');

% Kappa is "concentration parameter"

dataMatrix = [];
meanMatrix = [];
for i = 1:numClusters
    mean1 = rand_angle(); mean2 = rand_angle();
    angles = [circ_vmrnd(mean1, kappa, numPoints) circ_vmrnd(mean2, kappa, numPoints)];
    [x ,y, z] = sph2cart(angles(:,1), angles(:, 2), 1);
    [muX, muY, muZ] = sph2cart(mean1, mean2, 1);
    meanMatrix = [meanMatrix; muX, muY, muZ];
    dataMatrix = [dataMatrix; [x y z]];
end

end
