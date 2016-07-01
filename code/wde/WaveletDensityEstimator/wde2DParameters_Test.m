function wdeSet = wde2DParameters_Test()

% Define convergence threshold and other free parameters.
wdeSet.convgThresh = 1e-4;
wdeSet.maxIter     = 1000;
wdeSet.iter        = 0;
wdeSet.costDiff    = 9e9;
wdeSet.numGridPts  = 100;
wdeSet.scaleFac    = .02;
wdeSet.useGmms     = 1;
wdeSet.numTSteps   = 10;

% Estimate the densities.
wdeSet.gamma       = 1e-1;

%  case {'db1';'db2';'db3';'db4';'db5';'db6';'db7';'db7';'db8';'db9';'db10'}
%     case 'dmey'   
%     case {'sym1';'sym2';'sym3';'sym4';'sym5';'sym6';'sym7';'sym7';'sym8';'sym9';'sym10'}
%     case {'coif1';'coif2';'coif3';'coif4';'coif5';'coif6';'coif7';'coif7';'coif8';'coif9';'coif10'}

% WDE free parameters
wdeSet.wName       = 'sym4'; %

wdeSet.startLevel  = 2; %jo resolution
wdeSet.stopLevel   = 3; %j resolution
wdeSet.onlyScaling = 0;
wdeSet.iterations  =  12;
wdeSet.wdePlotting = 1; % Plotting the density.

wdeSet.delta          = .05;

domVal = 1;
wdeSet.xMin           = -domVal;
wdeSet.xMax           = domVal;
wdeSet.yMin           = -domVal;
wdeSet.yMax           = domVal;

wdeSet.numDensPoints  = 100;
clc

wdeSet.sampleSupp     = [wdeSet.xMin, wdeSet.xMax; wdeSet.yMin, wdeSet.yMax];

wdeSet.supportValsX    = linspace(wdeSet.xMin, wdeSet.xMax, wdeSet.numDensPoints);
wdeSet.supportValsY    = linspace(wdeSet.yMin, wdeSet.yMax, wdeSet.numDensPoints);

[wdeSet.x1Grid, wdeSet.x2Grid]  = ... %x,y points for grid
    meshgrid(wdeSet.supportValsX, wdeSet.supportValsY); 

wdeSet.densityPts = [wdeSet.x1Grid(:) wdeSet.x2Grid(:)];
