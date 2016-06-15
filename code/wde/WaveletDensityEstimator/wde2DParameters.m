function wdeSet = wde2DParameters()

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

% WDE free parameters
wdeSet.wName       = 'sym4';

wdeSet.startLevel  = 3;
wdeSet.stopLevel   = wdeSet.startLevel;
wdeSet.onlyScaling = 1;
wdeSet.iterations  =  15;
wdeSet.wdePlotting = 0;
wdeSet.delta          = .05;
wdeSet.xMin           = -2.5;
wdeSet.xMax           = 2.5;
wdeSet.yMin           = -2.5;
wdeSet.yMax           = 2.5;
wdeSet.sampleSupp     = [wdeSet.xMin, wdeSet.xMax; wdeSet.yMin, wdeSet.yMax];
wdeSet.supportVals    = [wdeSet.xMin : wdeSet.delta : wdeSet.xMax];
[wdeSet.x1Grid, wdeSet.x2Grid]  = meshgrid(supportVals,supportVals);
wdeSet.densityPts     = [wdeSet.x1Grid(:) wdeSet.x2Grid(:)];