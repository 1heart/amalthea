% WDE_2D Test Driver
clear; clc; close all;

currDirName = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\WaveletDensityEstimator\';
try 
    cd(currDirName);
catch
    error(['Change the currDirName variable to the Wavelet Density Estimation',...
            'folder and re-run the code, the path can be relative or ',...
            'absolute']);
end

addpath('.\waveCommon\');
addpath('.\wde2D\');
addpath('..\Datasets\');
addpath('..\Hypersphere_Code\');
addpath('..\Plotting_Code\');
addpath('..\RetrievalMetrics_Code\');
addpath('..\ShapeCoefficients\');
addpath('..\ShapeProcessing_Code\');

saveFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\ShapeCoefficients\SweedishLeaf\';

shapeFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\Datasets\Brown\'; % Shape file folder. 
shapeName = 'Brown_2D_ns99'; % Shape file name. 
saveFiles = 0;

% The variable name should be shapeCell. 
load([shapeFold, shapeName]); % Load the shape file. 

% Load the wde parameters. 
wdeSet = wde2DParameters_Test();

% Get the number of categories. 
numShapes = size(shapeCell,1);

% Initialize a cell to hold the coefficients and densities. The third 
% column are the parameters.
wdeCell = cell(numShapes,3);
wdeCell{1,3} = wdeSet;

startTimeOverall = tic;
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
h = waitbar(0,'Computing coefficients and densities per category.');
% Loop through the shapes, resize them approriately, and estimate the
% coeffients and densities and store them. 
for i = 1 : numShapes
    waitbar(i/numShapes, h);
    
    currSh = shapeCell{i,1}; % Current category. 
    
    % Resize the shape.
    currSh = resizeShapesToSquareGrid(currSh, abs(wdeSet.xMin));
    
    stTime = tic;
    % Compute the coefficients and densities. 
    [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currSh, wdeSet);
    stopTime = toc(stTime);
    disp(['Ind Shape Time : ' num2str(stopTime)]);
    
    wdeCell{i,1} = coeffs(:,end);
    wdeCell{i,2} = pdf;   
    
end
stopStartTimeOverall = toc(startTimeOverall);
disp(stopStartTimeOverall);

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

if (saveFiles == 1)
    save([saveFold, shapeName '_Coeffs_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel)], 'wdeCell');
end
    