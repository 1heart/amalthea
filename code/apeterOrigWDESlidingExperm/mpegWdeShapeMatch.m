%--------------------------------------------------------------------------
% Function:    wdeShapeMatch
% Description: Wavelet density estimation (WDE) based shape matching.
%              Optional parameters are indicated as such in the parameter
%              descriptions.
%
% Inputs:
%   shapeNames        - charater cell array with list of shape names.  This
%                       should vary among the mat files that have the
%                       stored shape information.
%   namePrefix        - any character string that needs to put before each
%                       shape file name.
%   namePostfix       - any character string that needs to put after each
%                       shape file name.
%   lambda            - importance weighting for Eulcidean distance matrix
%                       used to penalize large swaps during linear
%                       assignment. If lambda=0 there will not be a
%                       penalty. (optional)
%   outputDir         - string specifying the output directory to write mat
%                       files generated during matching process. (optional)
%                       If you leave it blank it assumes there is a
%                       subdirectory called 'outputMAT'.
%   testID            - unique character identifier for the current test.
%                       This will be incorporated into the output file 
%                       names. (optional).
%                       If you leave it blank the defaults is:
%                           testAT<date-time-stamp>
% Outputs:
%   matchMatrixLA     - numShape x numShapes symmetric matrix with all the
%                       the pairwise matching distances.  The distances are
%                       computed after solving a linear assignment problem
%                       between wavelet coefficients.
%   matchMatrix       - numShape x numShapes symmetric matrix with all the
%                       the pairwise matching distances.  These are the 
%                       distances without using linear assignment. 

%   Also saves each pairwise match test data in a mat file in the specified
%   output directory.
%
% Usage:
%
% Authors(s):
%   Adrian M. Peter and Anand Rangarajan
%--------------------------------------------------------------------------
function [matchingResultsLA matchingResultsEU matchingResults matchingResultsDT] = wdeShapeMatch(shapeNames,...
                                                     namePrefix, namePostfix,...
                                                     lambda, outputDir, testID, startShape, endShape,...
                                                     inputFileName, outputFileName)

if(~exist('lambda'))
    lambda = 5e-4;
end

if(~exist('outputDir'))
    outputDir = './outputMAT/';
end

if(~exist('testID'))
    testID = timeStamp;
end

if(lambda == 0)    
    addWeights = 0; % Flag to signal use of weights.
else
    addWeights = 1;
end

% Remove '.' from lambda for creating unique file name.
lamS = num2str(lambda,'%.3e');
lamS(findstr(lamS,'.'))='_';

% Get the numer of shapes.
numShapes    = length(shapeNames);

perturbCosts = 0; % Flag to perturb cost matrix to break symmetry. 
                  % (FIX: May have to just scale.)      

% Create a cell arry to store all the results for each shape.
matchingResults   = cell(numShapes,2);
matchingResultsLA = cell(numShapes,2);
matchingResultsEU = cell(numShapes,2);
matchingResultsDT = cell(numShapes,2);
% Call function to get cell array of all the necessary Euclidean distance
% matrices for the different levels.  We will have to load only one of the
% shape mat files since all of them are required to have the same level of
% decompositions.
shapeFile = [namePrefix shapeNames{1} namePostfix];
[distMats basesLocs] = distMatsAcrossLevels(shapeFile);

load(shapeFile,'startLevel','stopLevel','coeffsIdx');
numLevels = (stopLevel-startLevel)+1;

if( (numLevels == 1) && (size(coeffsIdx,1)==1) )
    scalingOnly = 1;
else
    scalingOnly = 0;
end

% Loop through all shapes and perform pairwise matching.
for s1 = startShape : endShape
    
    % Load the first shape.
    load([namePrefix shapeNames{s1} namePostfix]);
    
    matchingResults{s1,1}   = shapeNames{s1};
    matchingResultsLA{s1,1} = shapeNames{s1};
    matchingResultsEU{s1,1} = shapeNames{s1};
    matchingResultsDT{s1,1} = shapeNames{s1};
    shapeDists              = -99*ones(1,numShapes);
    shapeDistsLA            = -99*ones(1,numShapes);
    shapeDistsEU            = -99*ones(1,numShapes);
    shapeDistsDT            = -99*ones(1,numShapes);
    shape1                  = coeffs(:,end);
    
    for s2 = s1+1 : numShapes
        disp(['Matching ' shapeNames{s1} '(s1=' num2str(s1) ') and '...
             shapeNames{s2} '(s2=' num2str(s2) ')'])
        
        % Load other density to match.
        load([namePrefix shapeNames{s2} namePostfix]);
        shape2 = coeffs(:,end);
        
        % Go through all levels for the current shape pair and solve
        % assignment problem to get correct coefficient ordering.
        saveCoeffsOrder1 = [];
        saveCoeffsOrder2 = [];
        for j = 1 : numLevels
            costMatrix = [];
            % Need to get correct coefficient locations for wavelet basis
            % since there are 3 per x-y location.
            if(~scalingOnly)
                numCoeffsPerBasis = (coeffsIdx(j+1,2)-coeffsIdx(j+1,1)+1)/3;
                b1CoeffsIdxStart  = coeffsIdx(j+1,1);
                b1CoeffsIdxEnd    = coeffsIdx(j+1,1)+(numCoeffsPerBasis-1);
                b2CoeffsIdxStart  = b1CoeffsIdxEnd + 1;
                b2CoeffsIdxEnd    = b2CoeffsIdxStart+(numCoeffsPerBasis-1);
                b3CoeffsIdxStart  = b2CoeffsIdxEnd + 1;
                b3CoeffsIdxEnd    = b3CoeffsIdxStart+(numCoeffsPerBasis-1);
                if(b3CoeffsIdxEnd ~= coeffsIdx(j+1,2))
                    error(['Error calculating wavelet coefficient indices at level: '...
                           num2str(j+1)]);
                end
            end
                
            % This first level can have scaling and wavelet bases.
            if(j==1)
                s1ScalingCoeffs = shape1(coeffsIdx(j,1):coeffsIdx(j,2));
                s2ScalingCoeffs = shape2(coeffsIdx(j,1):coeffsIdx(j,2));
                % Create cost matrix as outer product of wavelet coefficients.
                costMatrix = s1ScalingCoeffs*s2ScalingCoeffs';
                % If wavelet coeffs are present need to add them to cost.
                if(~scalingOnly)
                    % Need to add 3 cost matrices together b/c we have 3
                    % wavelet coefficient per x-y grid location.
                    s1WaveletCoeffs1 = shape1(b1CoeffsIdxStart:b1CoeffsIdxEnd);
                    s2WaveletCoeffs1 = shape2(b1CoeffsIdxStart:b1CoeffsIdxEnd);
                    costMatrix       = costMatrix + s1WaveletCoeffs1*s2WaveletCoeffs1';
                    
                    s1WaveletCoeffs2 = shape1(b2CoeffsIdxStart:b2CoeffsIdxEnd);
                    s2WaveletCoeffs2 = shape2(b2CoeffsIdxStart:b2CoeffsIdxEnd);
                    costMatrix       = costMatrix + s1WaveletCoeffs2*s2WaveletCoeffs2';
                    
                    s1WaveletCoeffs3 = shape1(b3CoeffsIdxStart:b3CoeffsIdxEnd);
                    s2WaveletCoeffs3 = shape2(b3CoeffsIdxStart:b3CoeffsIdxEnd);
                    costMatrix       = costMatrix + s1WaveletCoeffs3*s2WaveletCoeffs3';
                end
            else % j>1
                s1WaveletCoeffs1 = shape1(b1CoeffsIdxStart:b1CoeffsIdxEnd);
                s2WaveletCoeffs1 = shape2(b1CoeffsIdxStart:b1CoeffsIdxEnd);
                costMatrix       = s1WaveletCoeffs1*s2WaveletCoeffs1';

                s1WaveletCoeffs2 = shape1(b2CoeffsIdxStart:b2CoeffsIdxEnd);
                s2WaveletCoeffs2 = shape2(b2CoeffsIdxStart:b2CoeffsIdxEnd);
                costMatrix       = costMatrix + s1WaveletCoeffs2*s2WaveletCoeffs2';

                s1WaveletCoeffs3 = shape1(b3CoeffsIdxStart:b3CoeffsIdxEnd);
                s2WaveletCoeffs3 = shape2(b3CoeffsIdxStart:b3CoeffsIdxEnd);
                costMatrix       = costMatrix + s1WaveletCoeffs3*s2WaveletCoeffs3';
            end % if(j==1)
            
            % Compute linear assignment.  We have to do it twice and see
            % which one maximizes the inner prodcut between the shape
            % coefficients.  (Shapes can have global sign difference
            % between them since they were estimated as sqrt of the
            % density.
            costScale = 10000/max([(shape1.^2)' (shape2.^2)']);
            %disp(['Scaling costmatrix by: ' num2str(costScale)]);
            costMatrix  = costScale*costMatrix;
            maximize    = 1;
            t0          = clock; 
            coeffOrder1 = linearAssignment(costMatrix, distMats{j}, lambda, addWeights, maximize, inputFileName, outputFileName);
            sec         = etime(clock,t0);
%             if(sec <= 60)
%                 disp(['LA1 took: ' num2str(sec) ' seconds.'])
%             elseif((sec > 60) && (sec <= 3600))
%                 disp(['LA1 took: ' num2str(sec/60) ' minutes.'])
%             else
%                 disp(['LA1 took: ' num2str(sec/3600) ' hours.'])
%             end
            
            if(length(coeffOrder1)~=size(costMatrix,1))
                error(['LA1 did not return proper ordering vector!']);
            end
            
            maximize    = 0;
            t0          = clock; 
            coeffOrder2 = linearAssignment(costMatrix, distMats{j}, lambda, addWeights, maximize, inputFileName, outputFileName);
            sec         = etime(clock,t0);
%             if(sec <= 60)
%                 disp(['LA2 took: ' num2str(sec) ' seconds.'])
%             elseif((sec > 60) && (sec <= 3600))
%                 disp(['LA2 took: ' num2str(sec/60) ' minutes.'])
%             else
%                 disp(['LA2 took: ' num2str(sec/3600) ' hours.'])
%             end
            if(length(coeffOrder2)~=size(costMatrix,1))
                error(['LA2 did not return proper ordering vector!']);
            end
            
            % Save the coefficient ordering.
            if(j==1)
                % When saving the wavelet coefficient ordering we need to
                % add the correct offset so all 3 basis per x-y location are
                % reordered properly.
                if(~scalingOnly)
                    saveCoeffsOrder1 = [saveCoeffsOrder1 (coeffOrder1+coeffsIdx(j,1))'...
                                        (coeffOrder1+b1CoeffsIdxStart)'...
                                        (coeffOrder1+b2CoeffsIdxStart)'...
                                        (coeffOrder1+b3CoeffsIdxStart)']; 
                    saveCoeffsOrder2 = [saveCoeffsOrder2 (coeffOrder2+coeffsIdx(j,1))'...
                                        (coeffOrder2+b1CoeffsIdxStart)'...
                                        (coeffOrder2+b2CoeffsIdxStart)'...
                                        (coeffOrder2+b3CoeffsIdxStart)']; 
                else
                    saveCoeffsOrder1 = [saveCoeffsOrder1 (coeffOrder1+coeffsIdx(j,1))'];
                    saveCoeffsOrder2 = [saveCoeffsOrder2 (coeffOrder2+coeffsIdx(j,1))'];
                end
            else
                saveCoeffsOrder1 = [saveCoeffsOrder1 (coeffOrder1+b1CoeffsIdxStart)'...
                                    (coeffOrder1+b2CoeffsIdxStart)'...
                                    (coeffOrder1+b3CoeffsIdxStart)']; 
                saveCoeffsOrder2 = [saveCoeffsOrder2 (coeffOrder2+b1CoeffsIdxStart)'...
                                    (coeffOrder2+b2CoeffsIdxStart)'...
                                    (coeffOrder2+b3CoeffsIdxStart)']; 
            end
            
        end % for j = 1 : numLevels
        
        % Get two candidate shape orderings.  Remember we have two
        % candidate orderings due to the possibility of have a global sign
        % difference between the shapes.
        shape2C1 = shape2(saveCoeffsOrder1);
        shape2C2 = shape2(saveCoeffsOrder2);
        
        % Get inner product for both candidates and pick the greater one.
        innerProd1LA = shape1'*shape2C1;
        innerProd2LA = shape1'*shape2C2;
        
        % Compute shape distance on the sphere.
        if(innerProd1LA >= innerProd2LA)
            shapeDist = acos(innerProd1LA);
            % Set up Euclidean distance weighting term.
            euclideanWeight = sum((sum((basesLocs-basesLocs(saveCoeffsOrder1,:)).^2,2)));
        else
            warining(['Inner product 2 with LA higher, ' num2str(innerProd2LA)]);
            shapeDist = acos(innerProd2LA);
            euclideanWeight = sum((sum((basesLocs-basesLocs(saveCoeffsOrder2,:)).^2,2)));
        end
               
        shapeDistsLA(s2) = shapeDist;
        
        % Also compute the penalized distance which includes the Euclidean
        % distance weighting.  FIX: This may actually have to be done using
        % the inner product plus the distance weight instead of the arc
        % length on the sphere as I am computing below.
        shapeDistsEU(s2) = shapeDist + lambda*euclideanWeight;
        
        % Record Euclidean distance.
        shapeDistsDT(s2) = euclideanWeight;
        
        % Compute distances without linear assignment.
        innerProd1 = shape1'*shape2;
        innerProd2 = -shape1'*shape2;
        
        % Compute shape distance on the sphere.
        if(innerProd1 >= innerProd2)
            shapeDist = acos(innerProd1);
        else
            warining(['Inner product 2 without LA higher, ' num2str(innerProd2LA)]);
            shapeDist = acos(innerProd2);
        end
               
        shapeDists(s2) = shapeDist;
        
        % Save this test run.
%         if(isdir(outputDir))
%             save([outputDir shapeNames{s1} '_VS_' shapeNames{s2} '_' wName '_lambda_' lamS '_' testID '.mat'], ...
%              'saveCoeffsOrder1', 'saveCoeffsOrder2', 'shapeDists', 'shape1','shape2',...
%              'distMats','lambda','coeffsIdx','innerProd1','innerProd2','shape2C1','shape2C2',...
%              'innerProd1LA','innerProd2LA','shapeDistsLA','shapeDistsEU','euclideanWeight');
%         else
%             mkdir(outputDir);
%             save([outputDir shapeNames{s1} '_VS_' shapeNames{s2} '_' wName '_lambda_' lamS '_' testID '.mat'], ...
%              'saveCoeffsOrder1', 'saveCoeffsOrder2', 'shapeDists', 'shape1','shape2',...
%              'distMats','lambda','coeffsIdx','innerProd1','innerProd2','shape2C1','shape2C2',...
%              'innerProd1LA','innerProd2LA','shapeDistsLA','shapeDistsEU','euclideanWeight');
%         end
    end % for s2 = s1+1 : numShapes  
    matchingResults{s1,2}   = shapeDists;
    matchingResultsLA{s1,2} = shapeDistsLA;
    matchingResultsEU{s1,2} = shapeDistsEU;
    matchingResultsDT{s1,2} = shapeDistsDT;
end % for s1 = 1 : numShapes

% matchMatrix   = [];
% matchMatrixLA = [];
% matchMatrixEU = [];
% matchMatrixDT = [];
% for s=1:numShapes
%     matchMatrix   = [matchMatrix;matchingResults{s,2}];
%     matchMatrixLA = [matchMatrixLA;matchingResultsLA{s,2}];
%     matchMatrixEU = [matchMatrixEU;matchingResultsEU{s,2}];
%     matchMatrixDT = [matchMatrixDT;matchingResultsDT{s,2}];
% end
% matchMatrix(matchMatrix==-99)=0;
% matchMatrixLA(matchMatrixLA==-99)=0;
% matchMatrixEU(matchMatrixEU==-99)=0;
% matchMatrixDT(matchMatrixDT==-99)=0;
% matchMatrix   = matchMatrix+matchMatrix';
% matchMatrixLA = matchMatrixLA+matchMatrixLA';
% matchMatrixEU = matchMatrixEU+matchMatrixEU';
% matchMatrixDT = matchMatrixDT+matchMatrixDT';
