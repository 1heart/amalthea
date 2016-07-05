% -------------------------------------------------------------------------
% Script: Testing3DWDE_Par (Par is parallel).
% Date: Wednesday 16th March, 2016. 
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver computes the 3D square root wavelet density
%              coefficients and densities of 3D data. These coefficients 
%              are then used in a shape matching framework.
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
clear; clc; close all; 

addpath(genpath('..\..\..\3DWDE'));
addpath('C:\Users\mmoyou\Documents\MATLAB\Wasserstein\Plotting_Code');

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
% -------------------------- DEFINING VARIABLES -------------------------

wdeSet = wde3DParameters_Test();

% ----------------LOADING DATA AND FILENAMES FOR SAVING--------------------

% Shape folder to load the shapes from. The variable should be shapeCell. 
shFileFolder = 'C:\Users\mmoyou\Documents\MATLAB\Wasserstein\Datasets\3D\SHREC10_NonRigid_WTM\'; % Shape file folder.
origShFn = 'SHREC10_Or_PN'; % Original shape file name.
fileInfo = whos('-file', [shFileFolder origShFn]);
load([shFileFolder origShFn]); % Load shape data. 
eval(['shapeCell = ' fileInfo.name ';']);

% Saving data. 
saveFoldLocal = 'C:\Users\mmoyou\Documents\MATLAB\Wasserstein\ShapeCoefficients\SH10\';
saveFoldExternal = 'Z:\Users\mmoyou\Experiments\Wasserstein\ShapeCoefficientsWholeDataset\SH10\';
saveFlag = 1;
saveExternally = 1;
shNameToSave = 'SHREC10_Or_PN'; % Shape name to save.

% Convert the vector to a string and replace the white spaces with
% underscores.
t1 = vectorToString(wdeSet.eftc); 

% Used to save the files.
shNameToSave = [shNameToSave,'_3D', '_WT_', wdeSet.wName, '_RL_'...
                num2str(wdeSet.startLevel), '_Tr_' t1]; 

wdeSet.shNameToSave = shNameToSave;
% ----------------------- COMPUTE COEFFICIENTS ----------------------------

wdeCell = computeCoefficientsV2_Par(shapeCell, wdeSet);                            

% ----------------------- SAVE VARIABLES ----------------------------------
if (saveFlag == 1)
    save([saveFoldLocal, shNameToSave] , 'wdeCell');
    if (saveExternally == 1)
        save([saveFoldExternal, shNameToSave], 'wdeCell');
    end
end

                            









