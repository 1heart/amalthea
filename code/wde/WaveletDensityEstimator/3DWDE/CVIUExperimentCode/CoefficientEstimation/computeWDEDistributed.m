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

% Parallel pool.
% numWorkers = 8;
% if (isempty(gcp('nocreate')))
%     parpool('local', numWorkers);
%     clc;
% else
%     workers = gcp('nocreate');
%     if (workers.NumWorkers < numWorkers)
%         delete(workers);
%         workers = parpool('local', n
%         clc
%     end
% end

addpath(genpath('../../../3DWDE'));
% addpath('C:/Users/mmoyou/Documents/MATLAB/Wasserstein/Plotting_Code');

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
% -------------------------- DEFINING VARIABLES -------------------------

wdeSet = wde3DParameters_Test();
% ----------------LOADING DATA AND FILENAMES FOR SAVING--------------------

partNum = 3;
minInd = 601;
maxInd = 900;

wdeSet.wName       = 'db4'; % )***
wdeSet.startLevel  = 2; % ***
lastExt = '';


expTypeFoldSaveLocal = '2DGL'; % 2DGL, 3DGL, 3DLBO

coeffDataSetFold = 'SH15'; % Animals, Brown, MPEG7Al, MPEG7NoAl, SweedishLeaf
coeffTypeFold = [wdeSet.wName, 'r', num2str(wdeSet.startLevel), lastExt];

% SHREC10_Or_PN_SSPts_GLEV_PQA_1_2_5
% SHREC11_Or_PN_SSPts_GLEV_PQA_1_2_5
% SHREC12ICPR_Or_PN_SSPts_GLEV_PQA_1_2_5
% SHREC15_WTM_Or_PN_SSPts_GLEV_PQA_1_2_5

% SHREC15_WTM_Or_PN_LBOEV_PQA_1_2_5
% SHREC12ICPR_Or_PN_LBOEV_PQA_1_2_5
% SHREC11_Or_PN_LBOEV_PQA_1_2_5
% SHREC10_Or_PN_Fix_LBOEV_PQA_1_2_5

% Animal_EV_PQA_1_2_5
% Brown_EV_PQA_1_2_5
% mpeg7Al_EV_PQA_1_2_5
% mpeg7NoAl_EV_PQA_1_2_5
% SwedLeaf_EV_PQA_1_2_5

origShFn = 'SHREC15_WTM_Or_PN'; % Original shape file name.

shNameToSave = 'SHREC15_WTM_Or_PN'; % Shape name to save.

%%

expFoldLocal = '~/Desktop/Folder/Wasserstein/ShapeCoefficients/'; 
expFoldLocal = '~/Desktop/Folder/Wasserstein/ShapeCoefficients/'; 

% Saving data. 
saveFoldLocal = [expFoldLocal, coeffDataSetFold, '/'];

% Shape folder to load the shapes from. The variable should be shapeCell. 
shFileFolder = '~/Desktop/Folder/Wasserstein/Datasets/3D/SHREC15_WTM/'; % Shape file folder.

% shFoldExternal = 'Z:/Users/mmoyou/Experiments/Wasserstein/ShapeCoefficientsWholeDataset/';
% saveFoldExternal = [shFoldExternal, coeffDataSetFold, '/'];

loadFileName = [shFileFolder, '/', origShFn];
fileInfo = whos('-file', loadFileName);
load(loadFileName); % Load shape data. 
eval(['shapeCell = ' fileInfo.name ';']);

saveFlag = 0;
saveExternally = 1;

% Used to save the files.
shNameToSave = [shNameToSave,'_3D_r1', '_WT_', wdeSet.wName, '_RL_'...
                num2str(wdeSet.startLevel), '_p', num2str(partNum)]; 

% ----------------------- COMPUTE COEFFICIENTS ----------------------------

shapeCell = shapeCell(minInd : maxInd,:);
wdeSet.stopLevel   = wdeSet.startLevel;

st = tic;
wdeCell = computeCoefficientsV2_Par(shapeCell, wdeSet);                            
stopTime = toc(st);
disp(['Computation time is : ' num2str(stopTime/60)]);
% ----------------------- SAVE VARIABLES ----------------------------------
if (saveFlag == 1)
    save([saveFoldLocal, shNameToSave] , 'wdeCell');
    if (saveExternally == 1)
        save([saveFoldExternal, shNameToSave], 'wdeCell');
    end
end
disp('Saved Files Successfully');
                            









