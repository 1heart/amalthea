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

DISP = 1;

% Circle square demo
m = 36; n = 36;
circle = imread('images/circle.jpg');
circle = double(rgb2gray(imresize(circle, [m n]))) ./ 255.0;
square = imread('images/square.jpg');
square = double(rgb2gray(imresize(square, [m n]))) ./ 255.0;

distMatrix = construct_dist_matrix([m n]);
lambdas = [0 0.0001 0.001 0.01 0.1];

linassgn_warp(circle, square, distMatrix, lambdas, DISP);

