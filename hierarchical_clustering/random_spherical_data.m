function [dataMatrix, meanMatrix, memMatrix] = random_spherical_data(numClusters, numPoints, kappa)

% Kappa is "concentration parameter"

dataMatrix = [];
meanMatrix = [];
memMatrix = []; % membership matrix
for i = 1:numClusters
    mean1 = rand_angle(); mean2 = rand_angle();
    angles = [circ_vmrnd(mean1, kappa, numPoints) circ_vmrnd(mean2, kappa, numPoints)];
    [x ,y, z] = sph2cart(angles(:,1), angles(:, 2), 1);
    [muX, muY, muZ] = sph2cart(mean1, mean2, 1);
    meanMatrix = [meanMatrix; muX, muY, muZ];
    dataMatrix = [dataMatrix; [x y z]];
    memMatrix = [memMatrix; (i + zeros(numPoints, 1))];
end

end
