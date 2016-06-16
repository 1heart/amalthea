%--------------------------------------------------------------------------
% Function:    sphere_dist
% Description: Finds the distance (angle) between two vectors on a unit hypersphere.
% 
% Inputs: 
%
%	x,y 		- Vectors on the unit hypersphere.
% 
% Outputs
% 
%	theta 		- The angle between the two vectors.
%
% Usage: Used in hierarchical clustering on the unit hypersphere.
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

function [theta] = sphere_dist(x,y)
theta = acos(dot(x,y));
end
