%--------------------------------------------------------------------------
% Function:    draw_tree
% Description: Recurses through a hierarchical tree
% and draws connection the unit hypersphere.
% 
% Inputs: 
%
%	T 		- A hierarchical tree (see meantree for specification)
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

function [] = draw_tree(T)

n = length(T.ids);
numLevels = max(1,ceil(log2(2*n-1)));
% color = ([1 0.5 1]./numLevels);
color = 0.3 + zeros(1,3);

numChildren = size(T.children, 2);
if n > 1
  scatter3(T.mean(1), T.mean(2), T.mean(3), 25, color, 'filled');
end
for i = 1:numChildren
  curr = T.children(i);
  circline(T.mean, curr.mean, color);
  hold on;
  draw_tree(curr);
end

end
