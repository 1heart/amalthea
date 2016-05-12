% 2016 Amalthea Classification Lab.
% Task 1 (c). 

clear; clc; close all;
xmin = -10;
xmax = 10; 
ymin = -10;
ymax = 10; 

numPointsX = 101; 
numPointsY = 101; 

xPoints = linspace(xmin,xmax,numPointsX);
yPoints = linspace(ymin,ymax,numPointsY);

[X,Y] = meshgrid(xPoints,yPoints);

X_test = [X(:), Y(:)];

saveName = 'X_test';
save([saveName, num2str(numPointsX)], 'X_test');