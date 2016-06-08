%--------------------------------------------------------------------------
% Function:    rand_angle
% Description: Returns a random angle between -pi and pi.
%
% Outputs
% 
%	out1 		- Example output 1.
%
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
function [theta] = rand_angle()
theta = 2*pi*rand - pi;
end
