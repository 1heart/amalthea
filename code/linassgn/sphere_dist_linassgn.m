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
%	distMatrix		- A cell array of the Euclidean distance between the points that each
% 						dimension of the hypersphere represents, at each resolution level.
%
% 	lambda 			- The weighting of the distance matrix on the final result
%
% 	multires_indices        - An mx2 array of [start_i, end_i] that represent each
%                                  segment of the vector that corresponds to each resolution level.
%                                  Defaults to [1 end].
%
% Outputs
% 
%	 		 		- The spherical distance between
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

function d = sphere_dist_linassgn(x, y, distMatrix, lambda, multires_indices)

if (~isvector(x) || ~isvector(y)) error('Not vector inputs!'); end;
if (~isequal(length(x), length(y))) error('Not equal size vectors!'); end;
n = length(x);
% Make vectors column vectors
if (size(x,2) ~= 1) x = x'; end;
if (size(y,2) ~= 1) y = y'; end;
if (nargin < 5) multires_indices = [1 length(x)]; end;

x_new = [];
for res_level = 1:size(multires_indices, 1)
  curri = multires_indices(res_level, :);
  curr_range = curri(1):curri(2);
  x_curr = x(curr_range); y_curr = y(curr_range);
  C = -(x_curr * y_curr') + lambda * distMatrix{res_level}; % Construct cost matrix
  [rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
  x_new = [x_new; x(rowsol)];
end

d = max(sphere_norm(x_new, y), sphere_norm(-x_new, y)); % Take the distance between y and the modified x

end
