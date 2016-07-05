%--------------------------------------------------------------------------
% Function:    vectorToString
% Description: This function takes in a vector and returns a string with 
%              the numbers stored in the vector, separated by '_'.
% 
% Inputs:
%
%   v             - Vector to manipulate.
% 
% Outputs:
%
%   vstr          - Vector string.
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Sunday 1st December, 2013.
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
%--------------------------------------------------------------------------
function vstr = vectorToString(v)

% Creating string to store the values. 
vstr = num2str(v); % Convert vector to a string.
t2 = isspace(vstr); % Find the white spaces in the string. 
% vstr(t2) = '_'; % Place a '_' for in between the numbers for file saving.

ncis = numel(t2); % Number of characters including space. 

% Loop through and replace the first space with a 1 and delete the second
% space. 
oneCount = 0;
for i = 1 : ncis
    
    % Get the value of the current position in t2. If the value is 1 the 
    % first time then put in the underscore.
    cpv = t2(i);
    
    if (cpv == 1)
    
        oneCount = oneCount + 1;
        if (oneCount == 1)
            vstr(i) = '_';
        else 
            vstr(i) = '*';
            oneCount = 0;
        end
    end
end

vstr(vstr == '*') = [];
            
            
            
            
    
    