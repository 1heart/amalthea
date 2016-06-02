function [dataMatrix, meanMatrix, memMatrix] = random_spherical_data(numClusters, numPoints, kappa, means1, means2)

if nargin <= 4
  means1 = nan(numClusters); means2 = nan(numClusters);
  for i = 1:numClusters
    means1(i) = rand_angle();
    means2(i) = rand_angle();
  end
end

if length(means1) ~= numClusters || length(means2) ~= numClusters
  error('Means vectors not the right length!');
end

% Kappa is "concentration parameter"

dataMatrix = [];
meanMatrix = [];
memMatrix = []; % membership matrix
for i = 1:numClusters
    mean1 = means1(i); mean2 = means2(i);
    angles = [circ_vmrnd(mean1, kappa, numPoints) circ_vmrnd(mean2, kappa, numPoints)];
    [x ,y, z] = sph2cart(angles(:,1), angles(:, 2), 1);
    [muX, muY, muZ] = sph2cart(mean1, mean2, 1);
    meanMatrix = [meanMatrix; muX, muY, muZ];
    dataMatrix = [dataMatrix; [x y z]];
    memMatrix = [memMatrix; (i + zeros(numPoints, 1))];
end

end
