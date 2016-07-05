%--------------------------------------------------------------------------
% Function:    ComputeCoefficients
% Description: This function computes the wavelet coefficients for the GPS 
%              coordinates on 3D shapes.
% 
% Inputs:
%
%   startLevel   - Start level resolution.
%
%   stopLevel    - Stopping level resolution.
%
%   domain       - Domain on which the density function will be estimated.
%
%   shapeData    - Data stored in a cell. 
%
%   wName        - Wavelet basis function name. 
%
%   foldName     - Folder name to save the coefficients in.
% 
%   fileName     - File name to save the coefficients to. 
% 
%   eftc         - A vector of positions which tells what eigenfunctions to
%                  compute.
%
%   iterations   - Number of iterations to run the density estimator for.
%
%   erVal        - Error value for recomputing the density estimate.
% 
% Outputs:
%   
%   coeffCell    - Cell containing the coefficients of the shapes.
%
%   coeffMat     - Matrix containing the coefficients stacked as columns in
%                 a matrix.
%
%   lcfv         - Length of the coefficient vector or number of
%                  coefficients.
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Monday 16th December, 2013. 
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function [coeffCell, coeffMat, lcfv, convCheck] = ...
       computeCoefficientsV3(shapeData, foldName, fileName)
                                
                    wde3DParams.startLevel, wde3DParams.stopLevel,...
                    wde3DParams.wde3DParams.domain, wde3DParams.wName,...
                    wde3DParams.eftc, wde3DParams.iterations,erThr

nts = max(size(shapeData)); % Number of total shapes.                                 
                                
% Initialize cell array to hold the coefficients of the for the 
% coefficients of the chosen eigenfunctions.
coeffCell = cell(nts,1); 

% Create a vector to track which shapes did not converge. A value of 1
% means that the WDE did not converge.
convCheck = zeros(nts,1);
% erVal = 1e-7;
exIter = 10; % Extra iterations to compute the density with. 

% File name to save for coefficients
fileNameToSaveCf = ['scft_' fileName];  

% Filename to save the coefficients under.
fileNameToSaveCoeff = [foldName fileNameToSaveCf '_WT_' wde3DParams.wName,...
                        '_RL_' num2str(wde3DParams.startLevel)];

efwb = waitbar(0, 'Estimating Coefficients');
% Loop through the shapes and compute the coefficients.
for i = 1 : nts    
    
        waitbar(i/nts);
        
        % Eigenfunctions of the current shape. 
        efcs = shapeData{i,1};

        % Chosen eigenfunction data. 
        nmcefd = efcs(:,wde3DParams.eftc);

        % Calulate the coefficients of the chosen eigenfunctions.
        [coeffCell{i}, convCheck(i)] = shapeToCoefficients(nmcefd, wName,...
                                        wde3DParams.startLevel, wde3DParams.stopLevel, wde3DParams.domain,...
                                        wde3DParams.erThr, wde3DParams.iterations); 
        
        % If the density did not converge.
        if (convCheck(i) == 1)
            % Calulate the coefficients of the chosen eigenfunctions.
            [coeffCell{i}, convCheck(i)] = shapeToCoefficients(nmcefd, wName,...
                                        wde3DParams.startLevel, wde3DParams.stopLevel, wde3DParams.domain,...
                                        wde3DParams.erThr, (wde3DParams.iterations + exIter));
        end  
end
delete(efwb);
                    
save([fileNameToSaveCoeff '.mat'], 'coeffCell', 'wde3DParams.startLevel', 'wName', 'convCheck');
                      

