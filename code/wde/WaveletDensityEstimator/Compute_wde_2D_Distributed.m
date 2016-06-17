% Loads and sets everything up
% WDE_2D Test Driver
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
% 
% % Parallel pool.
% numWorkers = 2;
% if (isempty(gcp('nocreate')))
%     parpool('local', numWorkers);
%     clc;
% else
%     workers = gcp('nocreate');
%     if (workers.NumWorkers < numWorkers)
%         delete(workers);
%         workers = parpool('local', numWorkers);
%         clc
%     end
% end

% Load the wde parameters. 
wdeSet = wde2DParameters_Test();

% -------------------------------------------------------------------------
dataSetFold = 'Brown'; % Brown, MPEG7, MPEG7, SweedishLeaf

% Brown_2D_ns99, Animal_All, mpeg7Aligned, mpeg7NoAligned
shapeName = 'Brown_2D_ns99'; % Shape file name. 

wdeSet.wName       = 'sym4'; %
wdeSet.startLevel  = 3;

partNum = 2;
minInd = 1 ;
maxInd = 99 ;
wdeSet.minInd = minInd;
wdeSet.maxInd = maxInd;
wdeSet.partNum = partNum;
% -------------------------------------------------------------------------

saveFold = ['../ShapeCoefficients/', dataSetFold];
% saveFoldExtra = 'Z:/Users/mmoyou/Experiments/Wasserstein/ShapeCoefficientsWholeDataset/';
% saveFoldExtra = [saveFoldExtra, dataSetFold, '/'];
shapeFold = ['../Datasets/', dataSetFold, '/']; % Shape file folder. 

saveFiles = 1;
plotOrigShape = 1;

wdeSet.stopLevel   = 4; %testing resolution levels

% The variable name should be shapeCell. 
load([shapeFold, shapeName]); % Load the shape file. 

% Get the number of categories. 
% numShapes = size(shapeCell,1);
numShapes = numel(minInd : maxInd);

shapeCell = shapeCell(minInd : maxInd,:);

% Initialize a cell to hold the coefficients and densities. The third 
% column are the parameters.
wdeCell = cell(numShapes,3);
wdeCell{1,3} = wdeSet;

startTimeOverall = tic;
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
h = waitbar(0,'Computing coefficients and densities per category.');










% Loop through the shapes, resize them approriately, and estimate the
% coeffients and densities and store them. 
for i = 1 : 1
    % Progress updates
    waitbar(i/numShapes, h);
    disp(['Running shape ', num2str(i)]);
    
    currSh = shapeCell{i,1}; % Current category. 

    % Resize the shape.
    currSh = resizeShapesToSquareGrid(currSh, abs(wdeSet.xMin));

    % Plots shape
     if (plotOrigShape == 1)
         plot2DShape(currSh, 'r.');
     end

    % Compute the coefficients and densities. 
    [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currSh, wdeSet);

    wdeCell{i,1} = coeffs(:,end); 
    wdeCell{i,2} = pdf;
            
end

stopStartTimeOverall = toc(startTimeOverall);
disp(['Time looping over shapes: ', num2str(stopStartTimeOverall)]);

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

if (saveFiles == 1)
    save([saveFold, shapeName '_Coeffs_r6_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel), '_p', num2str(partNum)], 'wdeCell');
    % save([saveFoldExtra, shapeName '_Coeffs_r6_' wdeSet.wName '_res_'...
        % num2str(wdeSet.startLevel), '_p', num2str(partNum)], 'wdeCell');
    disp('Files saved successfully');
end
    
