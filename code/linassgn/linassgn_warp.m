%--------------------------------------------------------------------------
% Function:    linassgn_warp
% Description: 	Warps two images as closely as possible for a given set of lambda.
% Inputs: 
%
%	x,y 			- Images of the same size.
% 
%	distMatrix		- A cell array of the Euclidean distance between pairs of points.
%
% 	lambdas 			- The weightings of the distance matrix on the final results, e.g. [0 0.0001 0.001 0.01 0.1]
% 	DISP  - A boolean to return the results or not.
%
% Outputs
%
%	new_xs - A cell array of the warped images.
%
% Usage: Used in hierarchical retrieval on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%	Yixin Lin - yixin1996@gmail.com
% 	Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function [new_xs] = linassgn_warp(source, target, distMatrix, lambdas, DISP)

if ~isequal(size(source), size(target)) error('Two images not equal!'); end;
if ~isvector(lambdas) error('Lambda not a vector!'); end;
if size(distMatrix,1) ~= size(distMatrix,2) error('Distance matrix not square!'); end;
if (nargin < 5) DISP = 1; end;
if (DISP) figure; end;

[m n] = size(source); k = length(lambdas);
x = source(:); y = target(:);
new_xs = {};

for i = 1:k
  lambda = lambdas(i);
  C = -(x * y') + lambda * distMatrix; % Construct cost matrix
  [rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
  x_new = x(rowsol); % Find reconstructed shape
  img = reshape(x_new, [m n]);
  new_xs = [new_xs img];

  if DISP
    subplot(2, k, i);
    imshow(img);
    title(['Lambda = ' num2str(lambda)]);
  end
end

if DISP
  subplot(2, k, k + 1);
  imshow(source);
  title('Source');
  subplot(2, k, k + 2);
  imshow(target);
  title('Target');
end

end
