%--------------------------------------------------------------------------
% Function:    negativeLogLikelihood
% Description: Calculates the negative log likelihood of the currents set
%              samples using the given coefficients for WDE. (2D specific)
%
% Inputs:
%   samps             - Nx2 matrix of 2D samples to use for density 
%                       estimation.  The first column is x and second y.
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
%   sampleSupport     - 2x2 matrix of the sample support.
%                       First row gives min x value and max x value
%                       Second row gives min y value and max y value
%
% Outputs:
%   currCost          - Negative log likelihood value over all samples.
%   currGrad          - Nx1 vector of gradient values for the log
%                       likelihood. N is the number of coefficients.
%   currHessian       - NxN Hessian matrix of the log likelihood.
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

function [currCost, currGrad] = negativeLogLikelihood(samps, coeffs,...
    coeffsIdx,...
    scalingOnly,...
    scalValsPerPoint, waveletValsPerPoint)

% OPTIMIZATION FOUR: Passed in scalValsPerPoint. Eliminated loops.
% Only performs operations.
numSamps = size(samps,1);
motherValsPerPoint = 0;

% Calculates cost function
fatherValsPerPoint = bsxfun(@times, scalValsPerPoint, coeffs(coeffsIdx(1,1):coeffsIdx(1,2))');
fatherValsPerPoint = sum(fatherValsPerPoint,2);

% Calculates cost function for multires
if(~scalingOnly)
    motherValsPerPoint = bsxfun(@times, waveletValsPerPoint, coeffs(coeffsIdx(2,1):end)');
    motherValsPerPoint = sum(motherValsPerPoint,2);
end

% Calculates cost function
basisValPerPoint = fatherValsPerPoint + motherValsPerPoint;
loglikelihood = log((basisValPerPoint).^2);
currCost = -(1/numSamps)*sum(loglikelihood);

% Calculates gradient
scalingBasisPerSample = bsxfun(@rdivide, scalValsPerPoint, basisValPerPoint);
scalValsSum = sum(scalingBasisPerSample,1);

% Calculates gradient for multires
if(~scalingOnly)
    waveletBasisPerSample = bsxfun(@rdivide, waveletValsPerPoint, basisValPerPoint);
    wavValsSum = sum(waveletBasisPerSample,1);
    currGrad = -2*(1/numSamps)*[scalValsSum wavValsSum]';
else
    % Calculates gradient
    currGrad = -2*(1/numSamps)*scalValsSum';
end
