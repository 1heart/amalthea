
%--------------------------------------------------------------------------
%  Function:    createSrings
% Description:  evaluates the tensor prod vectors 
%
% Inputs:
%    dim                       - sample dimension
%     a                        - variable to be created

% 
% Outputs:
%   str                        - a string of variables

%   
% Usage:
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [str] = createSrings(dim,a)

for i = 1 : dim
    eval([ a num2str(i) '=[];']);
end
str = '';

% multi Index
for j = 1:dim
    str = [str a num2str(j) ','];                      
end
str(end) = [];