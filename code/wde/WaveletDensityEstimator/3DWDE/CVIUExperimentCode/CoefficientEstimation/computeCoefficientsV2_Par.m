%--------------------------------------------------------------------------
% Function:    ComputeCoefficientsV2_Par
% Description: This function computes the scaling and wavelet coefficients
%               
% 
% Inputs:
%
% 
% 
% Outputs:
%   
%   wdeCell      - Wavelet density estimation cell. The first column stores
%                  the coefficients of each shape the second column stores
%                  the corresponding density.
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Wednesday 16th March, 2016.
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function wdeCell = computeCoefficientsV2_Par(shapeData, wdeSet)

nts = max(size(shapeData)); % Number of total shapes.                                 
                                
% Initialize cell array to hold the coefficients of the for the 
% coefficients of the chosen eigenfunctions.
wdeCell = cell(nts,3);
wdeCell{1,3} = wdeSet;

convCheck = zeros(nts,2);

% efwb = waitbar(0, 'Estimating Coefficients');
% Loop through the shapes and compute the coefficients.
% for i = 1 : nts
for i = 1 : 1  
    
        % waitbar(i/nts, efwb);
        
        efcs = shapeData{i,1}; % Eigenfunctions of the current shape.        
        chosenData = efcs(:, wdeSet.eftc); % Chosen eigenfunction data. 
        
        chosenData = resizeShapesToSquareGrid(chosenData, abs(wdeSet.xMin));
        
        % plot3DShape(chosenData, 'c.');
        
        % Calulate the coefficients of the chosen eigenfunctions.
        [wdeCell{i,1}, wdeCell{i,2}, convCheck(i,:)] = shapeToCoefficientsAndDensity(...
                                        chosenData, wdeSet);
        
        save tempWdeCell wdeCell convCheck;
end
% delete(efwb);
                    