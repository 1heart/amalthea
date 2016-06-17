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
    tic
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
            
            if(isempty(valid_coord))
                scalingBasisOpt = 0;
            else
                fatherWav = 2^startLevel * (father(x) .* father(y));
                scalingBasisOpt = fatherWav ./ sqrtPEachSamp(valid_coord)';
                scalingBasisOpt = sum(scalingBasisOpt);
            end
            sumGrid(i,j) = scalingBasisOpt;
        end
        
    end
    sumGrid = sumGrid';
    sumGrid = reshape(sumGrid,[1,numel(sumGrid)]);
    
    c_opt = (1/numSamps)*sumGrid';
    coeffs_opt = c/norm(c);
    
    toc
    surf(sumGrid);











