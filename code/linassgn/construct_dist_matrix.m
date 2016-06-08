%--------------------------------------------------------------------------
% Function:    construct_dist_matrix
% Description: Constructs a distance matrix of every point
% 	to every other point in a rectangular prism.
% 
% Inputs: 
%
%	numTranslates 	- A vector of the dimensions of a rectangular prism
% 						2D: [x y], 3D: [x y z])
% 
% Outputs
% 
%	distMatrix 		- A distance matrix for every pair of points inside the prism
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

function distMatrix = construct_dist_matrix(numTranslates)
% Given 

d = length(numTranslates); % Number of dimensions
if (d > 3) error('Too many dimensions in numTranslates array!'); end;
if (d < 3) numTranslates(3) = 1; end;

% Create every point on the prism
[xs, ys, zs] = ndgrid(1:numTranslates(1),1:numTranslates(2), 1:numTranslates(3));

% Vectorize the points on the prism
pts = [xs(:), ys(:), zs(:)];

% Construct the distance matrix by computing the distance between every point
% 	and reshaping it into a square matrix
distMatrix = squareform(pdist(pts));

end
