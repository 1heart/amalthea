%--------------------------------------------------------------------------
% Function:    plotWDE
% Description: Plots WDE for the given coefficients.
%
% Inputs:
%   densityPts        - 2xN matrix of values where we want to evaluate the
%                       density.
%   sampleSupport     - 2x2 matrix where the 1st row has [xMin xMax] and
%                       2nd row has [yMin yMax].
%   wName             - name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets.
%                       Default: 'db1' - Haar
%   startLevel        - starting level for the the father wavelet
%                       (i.e. scaling function).  
%   stopLevel         - last level for mother wavelet scaling.  The start
%                       level is same as the father wavelet's.
%   coeffs            - Nx1 vector of coefficients for the basis functions.
%                       N depends on the number of levels and translations.
%   coeffsIdx         - Lx2 matrix containing the start and stop index
%                       locations of the coeffients for each level in the
%                       coefficient vector.  L is the number of levels.
%                       For example, the set of coefficients for the
%                       starting level can be obtained from the
%                       coefficients vector as:
%                       coeffs(coeffsIdx(1,1):coeffsIdx(1,2),1)
%                       NOTE: This will be (L+1)x2 whenever we use more
%                             than just scaling coefficients.
%   scalingOnly       - flag indicating if we only want to use scaling
%                       functions for the density estimation.
%
% Outputs:
%   sqrtP             - Estimate of the square root of the density.
%
% Usage:
%
% Authors(s):
%   Adrian M. Peter
%
% Reference:
% A. Peter and A. Rangarajan, �Maximum likelihood wavelet density estimation 
% with applications to image and shape matching,� IEEE Trans. Image Proc., 
% vol. 17, no. 4, pp. 458�468, April 2008.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Copyright (C) 2009 Adrian M. Peter (adrian.peter@gmail.com)
%
%     This file is part of the WDE package.
%
%     The source code is provided under the terms of the GNU General 
%     Public License as published by the Free Software Foundation version 2 
%     of the License.
%
%     WDE package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with WDE package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%     USA
%--------------------------------------------------------------------------

function sqrtP = plotWDE_Par(isovalue,supportVals, sampleSupport, wName, startLevel, stopLevel,...
                         coeffs, coeffsIdx, scalingOnly, varargin)

alpha = 2;
numSamps      = length(supportVals);
numLevels     = length(startLevel:stopLevel);

% Translation range for the starting level scaling function.  Need both x
% and y values since 2D.
scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];
scalingTransRZ = translationRange(sampleSupport(3,:), wName,startLevel);
scalingShiftValsZ = [scalingTransRZ(1):scalingTransRZ(2)];

% Set up correct basis functions.
[father, mother] = basisFunctions(wName);

scalingSum        = 0;
waveletSum        = 0;
basisSumPerSample = zeros(numSamps,1);

% Determine if we need to count up or down.
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end
% Calculate the loglikelihood.
numbOfSample = [];

if (alpha == 1)                             
                                
    [transCel,phiVect,supp] = relevantLatticeComputInitialization(scalingShiftValsX,...
                                    scalingShiftValsY,scalingShiftValsZ,wName) ;                                                                                    
end

st = tic; 

parfor s = 1 : numSamps
    % Get (x,y) value of the sample.
    %sampX = supportVals(s,1); sampY = supportVals(s,2);sampZ = supportVals(s,3);
    
    
    % Compute father value for all scaled and translated samples 
    %======================================================================
    
    wavelet = wName;
    oneSample = supportVals(s,:);  
    %====================================================================== 
    
    %---------------------------------------------------------------------
    %---------------------------------------------------------------------------                               
%     if alpha == 1 % Relevant translate
% 
%       %find the linear index of the sample   
%       [smaLlatticelinIndx,translatesPerSamp] = relevantTranslatesSchemePerSample(oneSample,supp,startLevel,transCel);
% 
%       %update phiVector
%       scalVals = updateTheScalingVector(oneSample,smaLlatticelinIndx,translatesPerSamp,phiVect,startLevel,wavelet);
% 
%     else % All translates at once
% 
%         scalVals  = accessAllTranslatesAndTensorProd(oneSample,wavelet,...
%                  scalingShiftValsX,scalingShiftValsY,scalingShiftValsZ,startLevel);
%     end                               
%---------------------------------------------------------------------------
    scalVals  = accessAllTranslatesAndTensorProd(oneSample,wavelet,...
        scalingShiftValsX,scalingShiftValsY,scalingShiftValsZ,startLevel); 
    
    % Weight the basis functions with the coefficients.
    scalingBasis = coeffs(coeffsIdx(1,1):coeffsIdx(1,2)).*scalVals;
    scalingSum   = sum(scalingBasis);
    % Incorporate the mother basis if necessary.
%     if(~scalingOnly)
%         mothVals = [];
%         % Loop over all the levels to evaluate the wavelet basis.
%         for j = startLevel :inc:stopLevel
%             transRX    = translationRange(sampleSupport(1,:), wName, j);
%             shiftValsX = [transRX(1):transRX(2)];
%             transRY    = translationRange(sampleSupport(2,:), wName, j);
%             shiftValsY = [transRY(1):transRY(2)];
%             x          = 2^j*sampX - shiftValsX;
%             y          = 2^j*sampY - shiftValsY;
%             mothVals1  = 2^j*kron(father(x),mother(y));
%             mothVals2  = 2^j*kron(mother(x),father(y));
%             mothVals3  = 2^j*kron(mother(x),mother(y));
%             mothVals   = [mothVals mothVals1 mothVals2 mothVals3];
%         end 
%         % Multiply by the weights.
%         wavBasis = coeffs(coeffsIdx(2,1):end)'.*mothVals;
%         waveletSum  = sum(wavBasis);
%     end % if(~scalingOnly)
%     basisSumPerSample(s) = scalingSum + waveletSum;
    basisSumPerSample(s) = scalingSum;
end % for s = 1 : numSamps
stopTime = toc(st);
disp(['Density Time Par: ', num2str(stopTime)]);

sqrtPVec = basisSumPerSample;

% Reshape p to fit the domain.
xGrid = cell2mat(varargin(1));
yGrid = cell2mat(varargin(2));
zGrid = cell2mat(varargin(3));

sqrtP = reshape(basisSumPerSample,size(xGrid));

if(isempty(varargin(3+1)))
    wdePlotting = 1;
else
    wdePlotting = cell2mat(varargin(3+1));
end

if(wdePlotting)
%     figure;
%     surf(xGrid,yGrid,sqrtP); shading flat;
%     title(['${\sqrt{p(x)}}$ WDE'],'Fontsize', 14,'Interpreter', 'latex');
%     figure;
%     surf(xGrid,yGrid,sqrtP.^2); shading flat;
%     title(['p(x) WDE'],'Fontsize', 14);
    
    [densityr] = density3DPlot(xGrid,yGrid,zGrid ,sqrtPVec,isovalue);
end

