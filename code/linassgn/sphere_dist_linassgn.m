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
%	distMatrices		- A cell array of the Euclidean distance between the points that each
% 						dimension of the hypersphere represents, at each resolution level.
%
% 	lambdas 			- The weighting of the distance matrix on the final result
%
% 	multires_i        - An mx2 array of [start_i, end_i] that represent each
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

function d = sphere_dist_linassgn(x, y, distMatrices, lambdas, multires_i)

if (~isvector(x) || ~isvector(y)) error('Not vector inputs!'); end;
if (~isequal(length(x), length(y))) error('Not equal size vectors!'); end;
n = length(x);
if (nargin < 5) multires_i = [1 n]; end;
if (size(multires_i,2) ~= 2) error('Misformatted indices for multires!'); end;
if (size(x,2) ~= 1) x = x'; end; if (size(y,2) ~= 1) y = y'; end; % Make vectors column vectors

x_new = []; x_new_reverse = [];
% TODO: only do one linassgn
for res_level = 1:size(multires_i, 1)
  curr_range = multires_i(res_level, 1):multires_i(res_level, 2);
  x_curr = x(curr_range); y_curr = y(curr_range);
  x_new = [x_new; linassgn_warp(x_curr, y_curr, distMatrices{res_level}, lambdas)];
  x_new_reverse = [x_new_reverse; linassgn_warp(x_curr, y_curr, distMatrices{res_level}, lambdas)];
end

d = min(sphere_dist(x_new, y), sphere_dist(x_new_reverse, y)); % Take the distance between y and the modified x

end
