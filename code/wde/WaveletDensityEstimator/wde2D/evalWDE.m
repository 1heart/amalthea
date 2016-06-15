%--------------------------------------------------------------------------
% Function:    evalWDE
% Description: Evaluates the WDE at the given points.
%
% Inputs:
%   pnts              - Nx2 matrix of values where we want to evaluate the
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
%   wdeVals           - value of the probability density at the given 2D
%                       points.
%
% Usage:
%
% Authors(s):
%   Adrian M. Peter
%
% Reference:
% A. Peter and A. Rangarajan, “Maximum likelihood wavelet density estimation 
% with applications to image and shape matching,” IEEE Trans. Image Proc., 
% vol. 17, no. 4, pp. 458–468, April 2008.
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
function wdeVals = evalWDE(pnts, sampleSupport, wName, startLevel, stopLevel,...
                         coeffs, coeffsIdx, scalingOnly, varargin)

numSamps      = size(pnts,1);
numLevels     = length(startLevel:stopLevel);

% Translation range for the starting level scaling function.  Need both x
% and y values since 2D.
scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];

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
for s = 1 : numSamps
    % Get (x,y) value of the sample.
    sampX = pnts(s,1); sampY = pnts(s,2);
    
    % Compute father value for all scaled and translated samples 
    % over our entire 2D sampling grid.
    x         = 2^startLevel*sampX - scalingShiftValsX;
    y         = 2^startLevel*sampY - scalingShiftValsY;
    
    scalVals  = 2^startLevel*kron(father(x),father(y));
    
    % Weight the basis functions with the coefficients.
    scalingBasis = coeffs(coeffsIdx(1,1):coeffsIdx(1,2))'.*scalVals;
    scalingSum   = sum(scalingBasis);
    % Incorporate the mother basis if necessary.
    if(~scalingOnly)
        mothVals = [];
        % Loop over all the levels to evaluate the wavelet basis.
        for j = startLevel :inc:stopLevel
            transRX    = translationRange(sampleSupport(1,:), wName, j);
            shiftValsX = [transRX(1):transRX(2)];
            transRY    = translationRange(sampleSupport(2,:), wName, j);
            shiftValsY = [transRY(1):transRY(2)];
            x          = 2^j*sampX - shiftValsX;
            y          = 2^j*sampY - shiftValsY;
            mothVals1  = 2^j*kron(father(x),mother(y));
            mothVals2  = 2^j*kron(mother(x),father(y));
            mothVals3  = 2^j*kron(mother(x),mother(y));
            mothVals   = [mothVals mothVals1 mothVals2 mothVals3];
        end 
        % Multiply by the weights.
        wavBasis = coeffs(coeffsIdx(2,1):end)'.*mothVals;
        waveletSum  = sum(wavBasis);
    end % if(~scalingOnly)
    basisSumPerSample(s) = scalingSum + waveletSum;
end % for s = 1 : numSamps

wdeVals = basisSumPerSample.^2;
