%--------------------------------------------------------------------------
% Function:    log_map
% Description: In the Karcher mean,
%	takes a point and maps it to the tangent space of another point.
% 
% Inputs: 
%
%	ro1 		- Point that the tangent space is tangent to.
%
%	ro2 		- Point being mapped to the tangent space.
% 
% Outputs
% 
%	gamma 		- Point on the tangent space.
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
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function [ gamma ] = log_map(ro1, ro2)

ro_tilde = ro2 - dot(ro2, ro1) * ro1;
gamma = ro_tilde / norm(ro_tilde) * acos(dot(ro1, ro2));
if isnan(gamma)
  gamma = zeros(size(gamma));
end

end
