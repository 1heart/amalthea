%--------------------------------------------------------------------------
% Function:    meantree2_nodify
% Description: Reconstructs a recursive tree from the cell array representation.
% 
% Inputs: 
%
% C                 - A cell array (levels from leaves to root).
%
% l             	- The current level index of C.
% 
% index             - The indices in the original data matrix
% 						that correspond to the data points.
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


function T = meantree2_nodify(C, l, index)

T.mean = C{l}.means(index,:);
T.children = [];
if l == 1
  T.num = 1;
  T.ids = [index];
  return;
end

T.num = 0;
T.ids = [];
childPointers = C{l}.children{index};
for i = 1:size(childPointers,2)
  child = meantree2_nodify(C, l-1, childPointers(i));
  T.num = T.num + child.num;
  T.ids = [T.ids child.ids];
  T.children = [T.children child];
end

end
