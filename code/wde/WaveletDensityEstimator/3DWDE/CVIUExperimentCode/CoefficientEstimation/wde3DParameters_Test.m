function wdeSet = wde3DParameters_Test()

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
wdeSet.wName       = 'db4'; % )***

wdeSet.startLevel  = 3; % ***
wdeSet.stopLevel   = wdeSet.startLevel;
wdeSet.onlyScaling = 1;
wdeSet.iterations  =  100;
wdeSet.wdePlotting = 0; % Plotting the density.
wdeSet.erThr = 1e-8;           % Error tolerance in coefficient estimate. 
wdeSet.exIter = 10; % Extra iterations if coefficients don't converge.
wdeSet.maxIterWhile = 15;
wdeSet.initType = 'hist'; % Can be 'hist' or 'level'.

wdeSet.eftc = [1,2,3]; % Eigenfunctions to choose. ***

% wdeSet.delta          = .1;
wdeSet.numDensPoints  = 20;

wdeSet.xMin           = -1;
wdeSet.xMax           = -wdeSet.xMin;
wdeSet.yMin           = wdeSet.xMin;
wdeSet.yMax           = -wdeSet.xMin;
wdeSet.zMin           = wdeSet.xMin;
wdeSet.zMax           = -wdeSet.xMin;

wdeSet.sampleSupp     = [wdeSet.xMin, wdeSet.xMax;...
                         wdeSet.yMin, wdeSet.yMax;...
                         wdeSet.zMin, wdeSet.zMax];

wdeSet.supportValsX    = linspace(wdeSet.xMin, wdeSet.xMax, wdeSet.numDensPoints);
wdeSet.supportValsY    = linspace(wdeSet.yMin, wdeSet.yMax, wdeSet.numDensPoints);
wdeSet.supportValsZ    = linspace(wdeSet.zMin, wdeSet.zMax, wdeSet.numDensPoints);

[wdeSet.xGrid, wdeSet.yGrid, wdeSet.zGrid]  = ...
    meshgrid(wdeSet.supportValsX, wdeSet.supportValsY ,wdeSet.supportValsZ);

wdeSet.densityPts     = [wdeSet.xGrid(:) wdeSet.yGrid(:), wdeSet.zGrid(:)];
