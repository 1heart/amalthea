%--------------------------------------------------------------------------
% Function:    sphere_dist_linassgn
% Description: 	Takes the spherical distance between two points after
% 					after linearly assigning one to match the other
% 					as closely as possible.
% 
% Inputs: 
%
%	x,y 			- Vectors of points on the hypersphere
% 
%	distMatrix		- The Euclidean distance between the points that each
% 						dimension of the hypersphere represents
%
% 	lambda 			- The weighting of the distance matrix on the final result
%
% Outputs
% 
%	d 		 		- The spherical distance between
% 						the two points after linear assignment
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

function d = sphere_dist_linassgn(x, y, distMatrix, lambda)

if (~isvector(x) || ~isvector(y)) error('Not vector inputs!'); end;
if (~isequal(length(x), length(y))) error('Not equal size vectors!'); end;
n = length(x);
if (~isequal(size(distMatrix), [n n])) error('Distance matrix not nxn!'); end;
% Make vectors column vectors
if (size(x,2) ~= 1) x = x'; end;
if (size(y,2) ~= 1) y = y'; end;

C = -(x * y') + lambda * D; % Construct cost matrix
[rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
d = sphere_norm(x(rowsol), y); % Take the distance between y and the modified x

end
