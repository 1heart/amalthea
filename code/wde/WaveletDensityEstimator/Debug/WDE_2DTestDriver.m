% WDE_2D Test Driver
clear; clc; close all;

cd('C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\WaveletDensityEstimator\');
addpath('.\waveCommon\');
addpath('.\wde2D\');

saveFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\ShapeCoefficients\';
shapeFold = []; % Shape file folder. 
shapeName = 'MPEG7AlignedFD'; % Shape file name. 
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

% Loop through the shapes, resize them approriately, and estimate the
% coeffients and densities and store them. 
for i = 1 : numCat
    
    currCat = shapeCell{i,1}; % Current category. 
    tempCellCoeff = cell(numShPerCat,1);
    tempCellPdf = cell(numShPerCat,1);
    tempCellName = cell(numShPerCat,1);
    
    for j = 1 : numShPerCat
       
        currSh = currCat{j,1};     % Current shape. 
                
        % Resize the shape.
        currSh = resizeShapesToSquareGrid(currSh, abs(wdeSet.xMin));
        
        plot2DShape(currSh, 'r.');
        
        % Compute the coefficients and densities. 
        [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currSh, wdeSet);
        
        tempCellCoeff{j,1} = coeffs(:,end);
%         tempCell{j,2} = pdf;
        tempCellPdf{j,1} = pdf;
        
        tempCellName{j,1} = currCat{j,2}; % Current shape name. 
    end
    
    wdeCell{i,1} = [tempCellCoeff, tempCellPdf];
    wdeCell{i,2} = tempCellName;
end

save([saveFold, shapeName '_Coeffs_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel)], 'wdeCell');
    