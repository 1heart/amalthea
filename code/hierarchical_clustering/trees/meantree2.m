%--------------------------------------------------------------------------
% Function:    meantree2
% Description: Constructs an agglomerative hierarchical tree.
% 
% Inputs: 
%
% D                 - An nxd matrix of data points.
%
% DEBUG             - Boolean for printing debug statements (default = 0).
% 
% Outputs
% 
% T                 - A hierarchical array struct with fields
%   T.num             = the total number of observations in T
%   T.children        = array of mean-trees
%   T.mean            = 1xd vector of the average of all of T's children's means
%   T.ids             = array of indices of the observations, if a leaf node
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
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function [T C] = meantree2(D, DEBUG)

if nargin < 2; DEBUG = 0; end;

numChild = 2;
[n d] = size(D);

% Create a cell array of hierarchy of tree nodes, leaves to root
C = {};
C{1}.means = D;
C{1}.children = {};
for i = 1:size(D,1)
  C{1}.children{i} = [];
end
C = meantree2_recurse(D, C, numChild, DEBUG);

% Construct the tree
T = meantree2_nodify(C, size(C,2), 1);

end
