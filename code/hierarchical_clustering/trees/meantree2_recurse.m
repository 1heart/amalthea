%--------------------------------------------------------------------------
% Function:    meantree2_recurse
% Description: Constructs an agglomerative hierarchical tree in a cell array.
% 
% Inputs: 
%
% D                 - An nxd matrix of data points.
% C                 - The cell array being modified
%                       (levels arranged in leaves to root).
% numChild          - The number of nodes in the previous level
%
% DEBUG             - Boolean for printing debug statements (default = 0).
% 
% Outputs
% 
% C                 - The cell array after modification.
%
% Usage: Used in hierarchical tree clustering on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------


function [ C ] = meantree2_recurse(D, C, numChild, DEBUG)

[n d] = size(D);
l = size(C, 2);

persistent numSoFar;
persistent numTotal;

if DEBUG == 1
  numSoFar = 0;
  numTotal = n * 2 - 1;
  textprogressbar('calculating meantree2: ');
  textprogressbar(0);
  textprogressbar(' ');
  DEBUG = 2;
end

numClusters = floor(n / numChild);
[means, loss_val, categories, empty, loop] = SPKmeans(D, numClusters, 1, 'rand');

C{l+1}.means = means;

children = {};
for i = 1:size(means,1)
  children{i} = find(categories == i);
end

C{l+1}.children = children;

if DEBUG
  numSoFar = numSoFar + n;
  textprogressbar('calculating meantree2: ');
  textprogressbar(100 * numSoFar / numTotal);
  textprogressbar(' ');
end

if size(means, 1) ~= 1
  C = meantree2_recurse(means, C, numChild, DEBUG);
end

