function plotExperimentEigVecFromACell(shapeCell, pauseFlag, startNum,...
                                       evTriplet, varargin)
% plotExperimentEigVecFromACell(shapeCell, pauseFlag, startNum,...
%                                        evTriplet, varargin)

% Get the number of base shapes and instances. 
[numBaseShapes, ~] = size(shapeCell);

% Choose a base shape to determine the dimensions whether 2D or 3D.
[~, nDim] = size(shapeCell{1,1});

% Make figure full screen.
f1 = figure('units','normalized','outerposition',[0 0 1 1]); 

% loop through the shapes and plot the shapes in a subplot. 
for i = startNum : numBaseShapes
% for i = 0 : 75: numBaseShapes
    
    cs = shapeCell{i,1};
    cs = cs(:,evTriplet);

    figure(f1);
    
    if (nDim == 2)
        plot(cs(:,1), cs(:,2), 'r.');
    else
        plot3(cs(:,1), cs(:,2), cs(:,3), 'r.');
    end
    
    title(['Shape number : ' num2str(i)]);
    
    if (pauseFlag == 1)
        pause;
    else
        if (~isempty(varargin))
            pause(varargin{1});
        else
            pause(0.1);
        end
    end
    
    
    clf;
end
close(f1);        