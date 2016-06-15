function plotExperimentShapesFromACell(shapeCell, pauseFlag, startNum)
% plotExperimentShapesFromACell(shapeCell, pauseFlag, startNum)

% Get the number of base shapes and instances. 
[numBaseShapes, extraInfo] = size(shapeCell);

% Choose a base shape to determine the dimensions whether 2D or 3D.
[~, nDim] = size(shapeCell{1,1});


% Make figure full screen.
f1 = figure('units','normalized','outerposition',[0 0 1 1]); 

% loop through the shapes and plot the shapes in a subplot. 
for i = startNum : numBaseShapes
% for i = 0 : 75: numBaseShapes
    
    cs = shapeCell{i,1};

    figure(f1);
    title(['Shape number : ' num2str(i)]);

    if (nDim == 2)
        plot(cs(:,1), cs(:,2), 'r.');
    else
        plot3(cs(:,1), cs(:,2), cs(:,3), 'r.');
    end
    
    if (extraInfo > 1)
        title(['ShapeNum = ' num2str(i) '....' shapeCell{i,2}]);
    else
        title(['Shape number: ' num2str(i)]);
    end
    
    if (pauseFlag == 1)
        pause;
    else
        pause(0.1);
    end
    
    clf;
end
close(f1);        