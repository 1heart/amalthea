%--------------------------------------------------------------------------
% Function:    plotWDE
% Description: Plots WDE for the given coefficients.
%
% Inputs:
%   supportVal        - 1xN vector of values where we want to evaluate the
%                       density.
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
function sqrtP = plotWDE(supportVals, sampleSupport, wName, startLevel, stopLevel,...
                         coeffs, coeffsIdx, scalingOnly, wdePlotting)

numSamps      = length(supportVals);
numLevels     = length(startLevel:stopLevel);

% Translation range for the starting level scaling function.
scalingTransR    = translationRange(sampleSupport, wName, startLevel);
scalingShiftVals = [scalingTransR(1):scalingTransR(2)];

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
    % Compute father value for all scaled and translated samples.
    x         = 2^startLevel*supportVals(s)- scalingShiftVals;
    scalVals  = 2^(startLevel/2)*father(x);
    % Weight the basis functions with the coefficients.
    scalingBasis = coeffs(coeffsIdx(1,1):coeffsIdx(1,2))'.*scalVals;
    scalingSum   = sum(scalingBasis);
    % Incorporate the mother basis if necessary.
    if(~scalingOnly)
        mothVals = [];
        % Loop over all the levels to evaluate the wavelet basis.
        for j = startLevel :inc:stopLevel
            transR    = translationRange(sampleSupport, wName, j);
            shiftVals = [transR(1):transR(2)];
            x         = 2^j*supportVals(s)- shiftVals;
            mothVals  = [mothVals 2^(j/2)*mother(x)];
        end 
        % Multiply by the weights.
        wavBasis = coeffs(coeffsIdx(2,1):end)'.*mothVals;
        waveletSum  = sum(wavBasis);
    end % if(~scalingOnly)
    basisSumPerSample(s) = scalingSum + waveletSum;
end % for s = 1 : numSamps

sqrtP = basisSumPerSample;
if(wdePlotting)
    figure;
    plot(supportVals,sqrtP);
    title(['${\sqrt[2]{p(x)}}$ WDE'],'Fontsize', 14,'Interpreter', 'latex');
    figure;
    plot(supportVals,sqrtP.^2);
    title(['p(x) WDE'],'Fontsize', 14);
end