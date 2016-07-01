function [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(samps, wdeSet)
% Computes coefficients
[coeffs, coeffsIdx] = mlWDE2D(samps, wdeSet.wName, wdeSet.startLevel, ...
    wdeSet.stopLevel, wdeSet.onlyScaling, wdeSet.sampleSupp,...
    wdeSet.iterations,'hist',[]);
            
% Epsilon check for converegence of coefficients on hypersphere. 
coeffHypCoor = sum(coeffs(:,end).^2);
normCoeffHypCheck = abs(1 - coeffHypCoor);
epsCheck = 1e-6;
if (normCoeffHypCheck > epsCheck) % Normalize the vector. 
    disp('Did not converge');
    D = norm(coeffs(:,end))^2;
    coeffs(:,end) = coeffs(:,end)/sqrt(D);
end

% Plot square root density
sp = plotWDE(wdeSet.densityPts, wdeSet.sampleSupp, wdeSet.wName,....
             wdeSet.startLevel, wdeSet.stopLevel, coeffs(:,end),...
             coeffsIdx, wdeSet.onlyScaling,...
             wdeSet.x1Grid, wdeSet.x2Grid, wdeSet.wdePlotting);   

pdf = sp.^2;
pdf = pdf + max(pdf(:))*wdeSet.scaleFac;
pdf = pdf/sum(pdf(:));