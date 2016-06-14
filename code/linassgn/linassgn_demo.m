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

m = 36; n = 36;
circle = rgb2gray(imresize(imread('images/circle.jpg'), [m n]));
circle = double(circle);
circle = circle ./ 255.0;
square = rgb2gray(imresize(imread('images/square.jpg'), [m n]));
square = double(square);
square = square./ 255.0 ;
distMatrix = construct_dist_matrix([m n]);

lambdas = [0 0.0001 0.001 0.01 0.1];

x = circle(:); y = square(:);

figure;

for i = 1:length(lambdas)
  lambda = lambdas(i);
  C = -(x * y') + lambda * distMatrix; % Construct cost matrix
  [rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
  x_new = x(rowsol); % Find reconstructed shape
  img = reshape(x_new, [m n]);

  subplot(2, length(lambdas), i);
  imshow(img);
  title(['Lambda = ' num2str(lambda)]);
end

subplot(2, length(lambdas), length(lambdas) + 1);
imshow(circle);
title('Source (circle)');
subplot(2, length(lambdas), length(lambdas) + 2);
imshow(square);
title('Target (square)');

