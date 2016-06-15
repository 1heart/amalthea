function plot3DExperimentShapes(shapeCell)

% plotExperimentShapes(shapeCell)

% Get the number of base shapes and instances. 
[numBaseShapes, ~] = size(shapeCell);

% Choose a base shape to determine the dimensions whether 2D or 3D.
% [~, nDim] = size(shapeCell{1,1});

f1 = figure; 
movegui(f1, 'north');
% loop through the shapes and plot the shapes in a subplot. 
for i = 1 : numBaseShapes
    
    cs = shapeCell{i,1};
    plot3(cs(:,1), cs(:,2), cs(:,3), 'b.');
    title(num2str(i));
    pause;
    clf;
end
        