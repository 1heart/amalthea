function gridPts = generateGridPts(xBounds, yBounds, numPoints)

% gridPts = generateGridPts(xBounds, yBounds, numPoints)
% xBounds is [xmin, xmax]
% yBounds is [ymin, ymax]
% numPoints is [number of points in x direction, number of points in y direction]

% Use linspace to generate points between the x bounds. 
xPoints = linspace(xBounds(1), xBounds(2), numPoints(1)); 

% Use linspace to generate points between the y bounds. 
yPoints = linspace(yBounds(1), yBounds(2), numPoints(2)); 

% Use meshgrid to generate the grid points. 
[X,Y] = meshgrid(xPoints,yPoints);

% Vectorize the X and Y from meshgrid to get Nx2 grid data. 
gridPts = [X(:), Y(:)];