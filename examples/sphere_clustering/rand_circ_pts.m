function [X, Y, Z] = rand_circ_pts(theta1, theta2, kappa, n, r)

addpath('circ_stat_2012a);

rand_pts = [circ_vmrnd(theta1, kappa, n) circ_vmrnd(theta2, kappa, n)];
[x, y, z] = sph2cart(rand_pts(:, 1), rand_pts(:, 2), r);

end
