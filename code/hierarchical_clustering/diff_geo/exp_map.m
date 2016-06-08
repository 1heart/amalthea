%--------------------------------------------------------------------------
% Function:    exp_map
% Description: In the Karcher mean,
%	takes the log-mapped points on the tangent space,
% 	and return them to the original space
% 
% Inputs: 
%
%	ro1 		- Point that the tangent space is tangent to.
%
%	gamma 		- Point on the tangent space.
% 
% Outputs
% 
%	ro2 		- Point in the original space.
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

function [ ro2 ] = exp_map(ro1, gamma)

gmu = norm(gamma);
ro2 = cos(gmu) * ro1 + sin(gmu) * gamma / gmu;

if isnan(ro2)
  ro2 = ro1;
end

end
