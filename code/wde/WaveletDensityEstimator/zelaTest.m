%% negativeLogLikelihood
clc;
clear;
close all;

load('test');

[n, d] = size(scalingShiftValsX);
coeffsTest = reshape(coeffs, [d,d]);
tic
xIndex = find(x <= 7 & x >= 0);
yIndex = find( y <= 7 & y >= 0);
scalValsMat = 2^startLevel*kron(father(x(xIndex)), father((y(yIndex))));

scalValsMat = reshape(scalValsMat, [length(yIndex),length(xIndex)]);
scalingBasisTest = coeffsTest(yIndex, xIndex).*scalValsMat;
scalingSumTest = sum(sum(scalingBasisTest));

toc
%%
tic
scalVals  = 2^startLevel*kron(father(x),father(y));
scalingBasis = coeffs(coeffsIdx(1,1):coeffsIdx(1,2))'.*scalVals;
scalingSum   = sum(scalingBasis);
toc

%% initializeCoefficients
load('test');

[n, d] = size(scalingShiftValsX);
tic
tempScalsValsSumTest = zeros(d,d);
xIndex = find(x <= 7 & x >= 0);
yIndex = find( y <= 7 & y >= 0);
scalValsMat = 2^startLevel*kron(father(x(xIndex)), father((y(yIndex))));
scalValsMat = reshape(scalValsMat, [length(yIndex),length(xIndex)]);
scalingBasisTest = scalValsMat./sqrtPEachSamp(s);

tempScalsValsSumTest(yIndex,xIndex) = tempScalsValsSumTest(yIndex,xIndex) + scalingBasisTest;

toc

%%
tic
tempScalValsSum = zeros(numSamps, coeffsIdx(1,2));
scalVals  = 2^startLevel*kron(father(x),father(y));
scalingBasis = scalVals./sqrtPEachSamp(s);

tempScalValsSum(s,:) = scalingBasis;

toc
%%
