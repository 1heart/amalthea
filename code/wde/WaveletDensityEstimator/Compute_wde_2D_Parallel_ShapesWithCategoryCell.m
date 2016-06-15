% WDE_2D Test Driver
clear; clc; close all;

% currDirName = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\WaveletDensityEstimator\';
% try 
%     cd(currDirName);
% catch
%     error(['Change the currDirName variable to the Wavelet Density Estimation',...
%             'folder and re-run the code, the path can be relative or ',...
%             'absolute']);
% end

addpath('.\waveCommon\');
addpath('.\wde2D\');
addpath('..\Datasets\');
addpath('..\Hypersphere_Code\');
addpath('..\Plotting_Code\');
addpath('..\RetrievalMetrics_Code\');
addpath('..\ShapeCoefficients\');
addpath('..\ShapeProcessing_Code\');


% % Start the parallel pool or use open one, to use the max number of cores.
% cores = feature('numCores'); % Number of cores the machine has
% if (isempty(gcp('nocreate')))
%     workers = parpool(cores);
%     clc;
% else
%     workers = gcp;
%     % Checks if the pool is utilizing all cores
%     if (workers.NumWorkers < cores)
%         delete(workers);
%         workers = parpool(cores);
%         clc;
%     end
% end

saveFold = '..\ShapeCoefficients\MPEG7NoAlignedDatabase\';
saveFoldExtra = 'Z:\Users\mmoyou\Experiments\Wasserstein\ShapeCoefficientsWholeDataset\';
saveFoldCat = '..\ShapeCoefficients\MPEG7NoAligned_Categories\';
saveFoldCatExtra = 'Z:\Users\mmoyou\Experiments\Wasserstein\ShapeCoefficientsCategories\MPEG9NoAligned\';


shapeFold = '..\Datasets\MPEG7\'; % Shape file folder. 
shapeName = 'MPEG7NoAlignedFD'; % Shape file name. 
saveFiles = 1;
saveCat = 1;
plotOrigShape = 0;

% The variable name should be shapeCell. 
load([shapeFold, shapeName]); % Load the shape file. 

% Load the wde parameters. 
wdeSet = wde2DParameters_Test();

% Get the number of categories. 
numCat = size(shapeCell,1);

% Get the number of shapes per category. 
numShPerCat = 20;

% Initialize a cell to hold the coefficients and densities. The third 
% column are the parameters.
wdeCell = cell(numCat,3);
wdeCell{1,3} = wdeSet;

% Debugging.
% numCat = 1;
% numShPerCat = 1;

startTimeOverall = tic;
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
h = waitbar(0,'Computing coefficients and densities per category.');
% Loop through the shapes, resize them approriately, and estimate the
% coeffients and densities and store them. 
for i = 1 : numCat
    waitbar(i/numCat, h);
    
    currCat = shapeCell{i,1}; % Current category. 
    tempCellCoeff = cell(numShPerCat,1);
    tempCellPdf = cell(numShPerCat,1);
    tempCellName = cell(numShPerCat,1);
    
    stCat = tic;
    for j = 1 : numShPerCat
       
        disp(['Running shape ', num2str(j)]);
        currSh = currCat{j,1};     % Current shape. 
                
        % Resize the shape.
        currSh = resizeShapesToSquareGrid(currSh, abs(wdeSet.xMin));
        
        if (plotOrigShape == 1)
            plot2DShape(currSh, 'r.');
        end
        
        % Compute the coefficients and densities. 
        [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currSh, wdeSet);
        
        % Save the coefficients of the last iteration.
        tempCellCoeff{j,1} = coeffs(:,end); 
        tempCellPdf{j,1} = pdf;           % Save the density.
        tempCellName{j,1} = currCat{j,2}; % Current shape name. 
    end
    
    stopstCat = toc(stCat);
    disp(stopstCat);
    
    wdeCell{i,1} = [tempCellCoeff, tempCellPdf];
    wdeCell{i,2} = tempCellName;
    
    catCell = cell(1,3);
    catCell{1,1} = [tempCellCoeff, tempCellPdf];
    catCell{1,2} = shapeCell{i,2};
    catCell{1,3} = wdeSet;
    
    if (saveCat == 1)
        save([saveFoldCat, shapeName '_Coeffs_Cat_',shapeCell{i,2},...
             '_', wdeSet.wName '_res_', num2str(wdeSet.startLevel)], 'catCell');
         
        save([saveFoldCatExtra, shapeName '_Coeffs_Cat_',shapeCell{i,2},...
             '_', wdeSet.wName '_res_', num2str(wdeSet.startLevel)], 'catCell');
    end
    
end
stopStartTimeOverall = toc(startTimeOverall);
disp(stopStartTimeOverall);

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

if (saveFiles == 1)
    save([saveFold, shapeName '_Coeffs_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel)], 'wdeCell');
    save([saveFoldExtra, shapeName '_Coeffs_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel)], 'wdeCell');
end
    