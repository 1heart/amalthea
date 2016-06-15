%--------------------------------------------------------------------------
% Function:    resizeShapesToSquareGrid
% Description: This functions normalizes 2D and 3D shapes into a square
%              grid with the size chosen by the user. 
% 
% Inputs: 
%
%   X           - Shape to be resized. NxD.
%   
%   gs          - Grid size for the positive axis. The shape will be fit to
%                 -gridSize to gridSize. 
%   
% Outputs:
%
%   resSh       - Resized shape. 
% 
% Usage: Used in the affine invariance framework.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Monday 30th March, 2015 (9:08pm). 
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function X = resizeShapesToSquareGrid(X, gs)

% Number of columns or dimensions.
nCols = size(X,2);

% Choose the domain for either 2D or 3D shapes. 
if (nCols == 2)
    domain = [-gs, gs; -gs, gs];
else
    domain = [-gs, gs; -gs, gs; -gs, gs];
end
    
% Loop through the columns.
for k = 1 : nCols

    cCol = X(:,k); % Pull the current column.
    mincCol = min(cCol); % Minimum in the kth coordinate.
    maxcCol = max(cCol); % Maximum in the kth coordinate.
    newMin = domain(k,1); % New minimum lower bound. 
    newMax = domain(k,2); % New maximin upper bound.

    % Normalize to new range.
    X(:,k) = ((cCol - mincCol)/(maxcCol - mincCol)) * (newMax - newMin) + newMin;                    
end