%--------------------------------------------------------------------------
% Function:    karcher_mean
% Description: Computes the Karcher (geodesic) mean between points on a sphere.
% 
% Inputs: 
%
% D         - An nxd matrix of points on a sphere.
% 
% Outputs
% 
% M         - Mean of the points.
%
% Usage: Used in the affine invariance framework.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%   Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function [ M ] = karcher_mean(D)

epsilon = 0.01; % Minimum amount of change

[n d] = size(D);

M = D(1,:); % Initial estimate is just the first point

iter = 0;
first = 1; % First-iteration-only boolean

while 1
  iter = iter + 1;
  newG = zeros(1, d); % Construct the mean of the log-mapped points
  for i = 1:n
    newG = newG + log_map(M, D(i,:));
  end
  newG = newG / n;

  if first % Set G equal to the first mean
    first = 0; % Not the first iteration anymore
    G = newG;
  else
    if norm(G - newG) < epsilon % Break if change < epsilon
      break;
    else
      G = newG; % Otherwise, update G
    end
  end
  M = exp_map(M, G); % Map it back onto the hypersphere
end

end
