% -------------------------------------------------------------------------
% Script: linassgn_demo
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This shows the effect that varying
%               lambda has on linear assignment.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

DISP = 1; % Display results boolean
lambdas = [0 1e-12 1e-8 1e-6 1e-4 0.01 0.1];

% Circle square demo
% m = 36; n = 36;
% circle = imread('images/circle.jpg');
% circle = double(rgb2gray(imresize(circle, [m n]))) ./ 255.0;
% square = imread('images/square.jpg');
% square = double(rgb2gray(imresize(square, [m n]))) ./ 255.0;

% distMatrix = construct_dist_matrix([m n]);

% linassgn_warp(circle, square, distMatrix, lambdas, DISP);

% MPEG7 datasets

prefix = '/Users/yixin/amalthea/data/';
load([prefix 'Coefficients/MPEG7_raw/apple.mat']);
load([prefix 'Coefficients/MPEG7_raw/bird.mat']);

m = 42; n = 42;
distMatrix = construct_dist_matrix([m n]);

imgs = { ...
  apple01, ...
  apple02, ...
  bird01, ...
};

for i = 1:length(imgs)
  curr = imgs{i};
  currMax = max(curr);
  imgs{i} = reshape(curr, [m n]) / currMax;
end

for i = 1:length(imgs)
  for j = i+1:length(imgs)
    linassgn_warp(imgs{i}, imgs{j}, distMatrix, lambdas, DISP);
  end
end

