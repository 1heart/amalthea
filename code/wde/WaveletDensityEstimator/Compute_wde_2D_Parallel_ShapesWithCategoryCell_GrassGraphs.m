% WDE_GrassGraphs_2D
clear; clc; close all;


%% Paths.
% currDirName = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\WaveletDensityEstimator\';
% try 
%     cd(currDirName);
% catch
%     error(['Change the currDirName variable to the Wavelet Density Estimation',...
%             'folder and re-run the code, the path can be relative or ',...
%             'absolute']);
% end
% 
% addpath('.\waveCommon\');
% addpath('.\wde2D\');
% addpath('..\Datasets\');
% addpath('..\Hypersphere_Code\');
% addpath('..\Plotting_Code\');
% addpath('..\RetrievalMetrics_Code\');
% addpath('..\ShapeCoefficients\');
% addpath('..\ShapeProcessing_Code\');
% addpath('..\GrassGraphs\');

saveFoldDB = '..\ShapeCoefficients\MPEG7AlignedDatabase_GG\';
saveFoldCat = '..\ShapeCoefficients\MPEG7Aligned_Categories_GG\';
shapeFold = '..\Datasets\MPEG7\'; % Shape file folder. 
shapeName = 'MPEG7AlignedFD'; % Shape file name. 

%% Flags.
saveFilesDB     = 1; % Save the database file.
saveCat         = 1; % Save the categories.
plotOrigShape   = 1;
plotggEvec      = 1;
plotCurrEvec    = 1;

%% Variable setup.

% The variable name should be shapeCell. 
load([shapeFold, shapeName]); % Load the shape file. 

% Load the wde parameters. 
wdeSet = wde2DParameters_Test();
wdeSet.wdePlotting = 1;

% Get the number of categories. 
numCat = size(shapeCell,1);

% Get the number of shapes per category. 
numShPerCat = 20;

% Initialize a cell to hold the coefficients and densities. The third 
% column are the parameters.
wdeCell = cell(numCat,3);
wdeCell{1,3} = wdeSet;

% GrassGraph parameters. 
p = grassGraphsParams_2D_SingleShape;

% Debugging.
% numCat = 1;
% numShPerCat = 1;

signFlips = [1, 1;...
             1, -1;...
             -1, 1;...
             -1, -1];
numFlips = size(signFlips,1);

%% Processing.
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);
h = waitbar(0,'Computing coefficients and densities per category.');
% Loop through the shapes, resize them approriately, and estimate the
% coeffients and densities and store them. 
for i = 1 : numCat
    waitbar(i/numCat, h);
    
    currCat = shapeCell{i,1}; % Current category. 
    tempCellCoeff = cell(numShPerCat,numFlips); % Store the coeffs of the category.
    tempCellPdf = cell(numShPerCat,numFlips); % Store the pdfs of the category.
    tempCellName = cell(numShPerCat,1); % Store names of the category shapes.
    tempEigCell = cell(numShPerCat,2); % Store the eigenvectors and eigVals.
    
    % Loop through the shapes in the category.
    for j = 1 : numShPerCat
       
        disp(['Running shape ', num2str(j)]);
        currSh = currCat{j,1};     % Current shape. 
        
        if (plotOrigShape == 1)
            f1 = figure; movegui(f1,'west');
            plot2DShape(currSh, 'r.');
            title('Original Shape');
        end
        
        currSh = resizeShapesToSquareGrid(currSh,15); 
        
        % Compute the grass graphs coordinates. 
        [ggEvec, ggEvals] = grassGraphsCoordinates(currSh, p);
        
        if (plotggEvec == 1)
            f2 = figure; movegui(f2,'east');
            plot2DShape(ggEvec(:,1:2), 'r.');
            title('GrassGraph Coordinates.');
            
        end
        
        currEvec = resizeShapesToSquareGrid(ggEvec(:,1:2),abs(wdeSet.xMin)); 
        numFlips = 1;
        for k = 1 : numFlips
             
%             currEvec = bsxfun(@times, currEvec, signFlips(k,:));
            
            if (plotCurrEvec == 1)
                f4 = figure; movegui(f4, 'northeast');
                plot2DShape(currEvec, 'b.');
                title('GrassGraphs Scaled coordinates.')
            end

            % Compute the coefficients and densities. 
            [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currEvec, wdeSet);
        
            % Save the coefficients of the last iteration.1            tempCellCoeff{j,k} = coeffs(:,end); 
            tempCellPdf{j,k} = pdf;           % Save the density.
        end
        
        tempCellName{j,1} = currCat{j,2}; % Current shape name. 
        tempEigCell{j,1} = ggEvec; % Store the eigenvectors.
        tempEigCell{j,2} = ggEvals; % Store the eigenvalues. 
    end
    
    % Store the coefficients and the density over all the shapes. 
    wdeCell{i,1} = [tempCellCoeff, tempCellPdf, tempEigCell];
    wdeCell{i,2} = tempCellName;
    
    % Store the coefficient and the density per category. 
    catCell = cell(1,4);
    catCell{1,1} = [tempCellCoeff, tempCellPdf];
    catCell{1,2} = shapeCell{i,2};
    catCell{1,3} = wdeSet;
    catCell{1,4} = tempEigCell;
         
    if (saveCat == 1)
        save([saveFoldCat, shapeName '_GG_Coeffs_Cat_',shapeCell{i,2},...
             '_', wdeSet.wName '_res_', num2str(wdeSet.startLevel)], 'catCell');
    end
    
end
F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

if (saveFilesDB == 1)
    save([saveFoldDB, shapeName '_GG_Coeffs_' wdeSet.wName '_res_'...
        num2str(wdeSet.startLevel)], 'wdeCell');
end
    