% Script to run 2D Wavelet Density
clear; clc; close all;

warning off;
addpath('./waveCommon/');
addpath('./wde2D/');
addpath('../Datasets/');
addpath('../Hypersphere_Code/');
addpath('../Plotting_Code/');
addpath('../RetrievalMetrics_Code/');
addpath('../ShapeCoefficients/');
addpath('../ShapeProcessing_Code/');

% PARARMETERS SETTINGS ---------------------------------------------------- 
wdeSet = wde2DParameters_Test();

% DATASET SETTINGS --------------------------------------------------------
% Brown, MPEG7, MPEG7, SweedishLeaf
dataSetFold = 'MPEG7'; 

% Brown_2D_ns99, Animal_All, mpeg7Aligned, mpeg7NoAligned
shapeName = 'mpeg7Aligned'; 

% Set which shape index to start with
partNum = 2;
minInd = 251;
maxInd = 500;
wdeSet.minInd = minInd;
wdeSet.maxInd = maxInd;
wdeSet.partNum = partNum;

% Load shape file 
shapeFold = ['../Datasets/', dataSetFold, '/'];
load([shapeFold, shapeName]);

% SAVE SETTINGS -----------------------------------------------------------
saveFold = ['../ShapeCoefficients/', dataSetFold];
saveFiles = 0;

% OUTPUT DISPLAY SETTINGS -------------------------------------------------
% Show progress bar
dispLoading = 0;
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

% Show shape points
plotOrigShape = 1;

%--------------------------------------------------------------------------

% Pull shape info
numShapes = numel(minInd : maxInd);
shapeCell = shapeCell(minInd : maxInd,:);

% Cell to store coefficients, densities, and parameters.
wdeCell = cell(numShapes,3);
wdeCell{1,3} = wdeSet;

% Timestamp to estimate entire dataset
startTimeOverall = tic;

% Loop through shapes to estimate densities
for i = 1 : 1
    
    % Shows progress updates
    if(dispLoading)
        h = waitbar(0,'Computing coefficients and densities per category.');
        waitbar(i/numShapes, h);
        disp(['Running shape ', num2str(i)]);
    end

    % Pull and resize shape
    currShape = shapeCell{i,1};
    currShape = resizeShapesToSquareGrid(currShape, abs(wdeSet.xMin));
    
         % Plots current shape
     if (plotOrigShape)
         plot2DShape(currShape, 'r.');
     end

    % Compute the coefficients and densities
    [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currShape, wdeSet);

    % Store coefficients and densities
    wdeCell{i,1} = coeffs(:,end); 
    wdeCell{i,2} = pdf;
            
end % for i = 1 : numShapes

% Timestamp to estimate entire dataset
stopStartTimeOverall = toc(startTimeOverall);
disp(['Time looping over shapes: ', num2str(stopStartTimeOverall)]);

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

% Save probability density estimation data
if (saveFiles == 1)
    save([saveFold, shapeName '_Coeffs_r6_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel), '_p', num2str(partNum)], 'wdeCell');
    disp('Files saved successfully');
end
    
