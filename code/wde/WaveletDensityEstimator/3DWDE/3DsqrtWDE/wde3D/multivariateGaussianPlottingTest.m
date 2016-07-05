clear; clc; close all;

%% 2D Density. 

mu = [0,0];
sigma = eye(2);

xlb = -2;
xub = 2; 
ylb = -2;
yub = 2;

numxPoints = 25;
numyPoints = 25;

xPoints = linspace(xlb, xub, numxPoints);
yPoints = linspace(ylb, yub, numyPoints);

[X, Y] = meshgrid(xPoints, yPoints);

data = [X(:), Y(:)];

p = mvnpdf(data, mu, sigma);

surf(X,Y, reshape(p,size(X)));
xlabel('x');
ylabel('y');

%% 3D Density. 


mu = [0,0,0];
sigma = eye(3);

xlb = -2;
xub = 2; 
ylb = -2;
yub = 2;
zlb = -2;
zub = 2;

numxPoints = 25;
numyPoints = 25;
numzPoints = 25;

xPoints = linspace(xlb, xub, numxPoints);
yPoints = linspace(ylb, yub, numyPoints);
zPoints = linspace(ylb, yub, numzPoints);

[X, Y, Z] = meshgrid(xPoints, yPoints, zPoints);

data = [X(:), Y(:), Z(:)];

p = mvnpdf(data, mu, sigma);

figure;
isovalue = 0;
psurf = patch(isosurface(X, Y, Z, reshape(p,size(X)), isovalue));
isonormals(X, Y, Z, reshape(p,size(X)), psurf);

% surf(X,Y,Z, reshape(p,size(X)));
% xlabel('x');
% ylabel('y');
% ylabel('z');