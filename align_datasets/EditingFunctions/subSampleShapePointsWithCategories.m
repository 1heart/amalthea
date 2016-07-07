% Compute convex hull on shapes to reduce the number of points
clear; clc; close all; 


shFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\Wasserstein\Datasets\SweedishLeaf\';
shName = 'SweedishLeaf_Points';

load([shapeFold, shName]);

% ts = shapeCell{11,1};
boundVal = 0.99;
numSubPoints = 4000;

f1 = figure; movegui(f1, 'east');
f2 = figure; movegui(f2, 'west');
numShapes = size(shapeCell,1);
tempShapeCell = cell(numShapes,1);

for i = 1 : numShapes
    
    ts = shapeCell{i,1};
    numShapePoints = size(ts,1);
    
    % If the number of points is above this then subsample the shape. 
    if (numShapePoints > numSubPoints)

        tsx = ts(:,1); % Get the x coordinates. 
        tsy = ts(:,2); % Get the y coordinates. 
        k = boundary(ts(:,1),ts(:,2), boundVal);
        numBoundPts = length(k); % Number of boundary pts. 

        pointInd = 1 : numShapePoints; % Get the number of points in the shape. 
        boundInd = pointInd(k); % Pull out the boundary indices. 

        % If the number of boundary points is less than the total then get
        % the remaining points from the interior. 
        if (numBoundPts < numSubPoints)
            
            pointInd(boundInd) = []; % Get rid of boundary points. 
            randVec = randperm(length(pointInd)); 
            
            % Number of sub points interior.
            numSubPointsInt = numSubPoints - numBoundPts;

            intPointsSubInd = pointInd(randVec(1:numSubPointsInt));

            newtsx = [tsx(k); tsx(intPointsSubInd)];
            newtsy = [tsy(k); tsy(intPointsSubInd)];
            tempShapeCell{i,1} = [newtsx, newtsy];

            figure(f1); plot2DShape(ts, 'r.');
            figure(f2); plot2DShape([newtsx, newtsy], 'r.');

            pause(0.1);

            clf(f1);
            clf(f2);
        else
            tempShapeCell{i,1} = [tsx(k), tsy(k)];
            
        end % if (numBoundPts < numSubPoints)
    else
        tempShapeCell{i,1} = ts;
    end % if (numShapePoints > numSubPoints)
    
end % for i = 1 : numShapes

saveName = [shName, 'Sub'];
shapeCell = tempShapeCell;
save([shFold, saveName], 'shapeCell');
