%--------------------------------------------------------------------------
% Function:    meantree
% Description: Constructs a divisive hierarchical tree.
% 
% Inputs: 
%
% D                 - An nxd matrix of data points.
%
% DEBUG             - Boolean for printing debug statements (default = 0).
%
% branchingFactor   - The branching factor for the tree (default = 2).
%
% ids               - The ids that correspond to each data point in D.
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

function T = meantree(D, DEBUG, branchingFactor, ids)

[n d] = size(D);

if nargin < 2; DEBUG = 0; end;
if nargin < 3; branchingFactor = 2; end;
if nargin < 4; ids = 1:n; end;

if length(branchingFactor) > 1
  % If you pass in a vector of form [2 b_1 b_2...],
  % you can specify the branching at each level
  % i.e. the first element is a pointer to the rest
  % of the elements in the array, which is incremented at each level
  ptr = branchingFactor(1);
  branchingFactor(1) = ptr + 1;
  currBF = branchingFactor(min(ptr, length(branchingFactor)));
else
  currBF = branchingFactor;
end

persistent numSoFar;
persistent numTotal;

if DEBUG == 1
  numSoFar = 0;
  numTotal = 2 * n - 1;
  DEBUG = 2;
end;

% Base case: set the default values for the leaves
T.num = size(D, 1);
T.children = [];
T.mean = sum(D,1);
T.mean = T.mean / norm(T.mean);
T.ids = ids;

if DEBUG
  numSoFar = numSoFar + 1;
  textprogressbar('calculating meantree: ');
  textprogressbar(100 * numSoFar / numTotal);
  textprogressbar(' ');
end;

% If there's only one data point left (at leaf), return.
if n == 1; return; end;

currBF = min(T.num, currBF);
[means, loss_val, categories, empty, loop] = SPKmeans(D, currBF, 1, 'rand');

for i = 1:currBF
  currIDs = find(categories == i);

  % If there are no points in the cluster, skip it
  if length(currIDs) == 0; continue; end; 
  % If all the points are in the cluster, stop
  if length(currIDs) == n; break; end;

  currD = D(currIDs, :);
  currIDs = ids(currIDs);
  % Recurse
  T.children = [T.children meantree(currD, DEBUG, branchingFactor, currIDs)];
end

end
