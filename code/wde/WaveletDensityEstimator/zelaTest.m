%% negativeLogLikelihood
clc;
clear;
close all;

% load('test');
% 
% [n, d] = size(scalingShiftValsX);
% coeffsTest = reshape(coeffs, [d,d]);
% tic
% xIndex = find(x <= 7 & x >= 0);
% yIndex = find( y <= 7 & y >= 0);
% scalValsMat = 2^startLevel*kron(father(x(xIndex)), father((y(yIndex))));
% 
% scalValsMat = reshape(scalValsMat, [length(yIndex),length(xIndex)]);
% scalingBasisTest = coeffsTest(yIndex, xIndex).*scalValsMat;
% scalingSumTest = sum(sum(scalingBasisTest));
% 
% toc
% %%
% tic
% scalVals  = 2^startLevel*kron(father(x),father(y));
% scalingBasis = coeffs(coeffsIdx(1,1):coeffsIdx(1,2))'.*scalVals;
% scalingSum   = sum(scalingBasis);
% toc
% 
% %% initializeCoefficients
% load('test');
% 
% [n, d] = size(scalingShiftValsX);
% tic
% tempScalsValsSumTest = zeros(d,d);
% xIndex = find(x <= 7 & x >= 0);
% yIndex = find( y <= 7 & y >= 0);
% scalValsMat = 2^startLevel*kron(father(x(xIndex)), father((y(yIndex))));
% scalValsMat = reshape(scalValsMat, [length(yIndex),length(xIndex)]);
% scalingBasisTest = scalValsMat./sqrtPEachSamp(s);
% 
% tempScalsValsSumTest(yIndex,xIndex) = tempScalsValsSumTest(yIndex,xIndex) + scalingBasisTest;
% 
% toc
% 
% %%
% tic
% tempScalValsSum = zeros(numSamps, coeffsIdx(1,2));
% scalVals  = 2^startLevel*kron(father(x),father(y));
% scalingBasis = scalVals./sqrtPEachSamp(s);
% 
% tempScalValsSum(s,:) = scalingBasis;
% 
% toc

    %%
    load('test');
    load('trueVars');
    clc;
    
    k_x = scalingShiftValsX;
    k_y = scalingShiftValsY;
    sumGrid = zeros(translations);
    for j = 1 : translations
        
        for i = 1 : translations
            x = 2^startLevel * samps(:,1)' - k_x(i);
            y = 2^startLevel * samps(:,2)' - k_y(j);
           
            valid_xIndex = find(x >= 0 & x <= 7);
            valid_yIndex = find(y >= 0 & y <= 7);
            
            % These are the sample points that fall under translate i,j
            valid_coord = intersect(valid_xIndex, valid_yIndex);
            x = x(valid_coord);
            y = y(valid_coord);
            relevantSamp_x = samps(valid_coord, 1);
            relevantSamp_y = samps(valid_coord,2);
            
            if(isempty(valid_coord))
                fatherWav = 0;
            else
                % fatherWav_3,(-3,-3)
                fatherWav = 2^startLevel * (father(x) .* father(y));
                fatherWav = sum(fatherWav);
            end
            sumGrid(i,j) = fatherWav;
        end
        
    end
    sumGrid = sumGrid';
    surf(sumGrid);












