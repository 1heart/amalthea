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

function [currCost, currGrad, currHessian] = negativeLogLikelihood(samps,...
    wName,...
    startLevel,...
    stopLevel,...
    coeffs,...
    coeffsIdx,...
    scalingOnly,...
    sampleSupport)

numSamps = size(samps,1);

% Translation range for the starting level scaling function.  Need both x
% and y values since 2D.
scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = scalingTransRX(1):scalingTransRX(2);
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = scalingTransRY(1):scalingTransRY(2);

% Set up correct basis functions. Now that we have all the translation
[father, mother] = basisFunctions(wName);
waveSupp = waveSupport(wName);

% Determine if we need to count up or down.
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end

%%%%%%
numXTranslations = length(scalingShiftValsX);
numYTranslations = length(scalingShiftValsY);
numTranslations = numXTranslations * numYTranslations;

% OPTIMIZATION THREE: Single loop along translations
% Gives back new sample points (x,y) along each translate K
x = bsxfun(@minus, (2^startLevel)*samps(:,1), scalingShiftValsX);
y = bsxfun(@minus, (2^startLevel)*samps(:,2), scalingShiftValsY);

% For each translate, sample values (x,y) that live under wavelet's support --> 1
valid_x = (x >= waveSupp(1) & x <= waveSupp(2));
valid_y = (y >= waveSupp(1) & y <= waveSupp(2));

scalValsPerPoint = zeros(numSamps,numTranslations);
loglikelihood = zeros(numSamps,1);
% Loop along translations in x
for i = 1 : numXTranslations
    % Find where points x and y exist together or intersect --> 1
    intersections = bsxfun(@times, valid_x(:,i), valid_y);
    
    % Sample indices are represented by rows.
    % Relevant y translations are represented by columns
    [sampleIndex, yTranslateIndex] = find(intersections == 1);
    
    % Calculate father wavelet for relevant points that fall under current x translation
    x_at_translate = x(sampleIndex,i);
    father_x = father(x_at_translate);
    
    % Calculate father wavelet for relevant points that fall under all y translations
    y_at_translate = y(logical(intersections));
    father_y = father(y_at_translate);
    
    % Calculate the father wavelet for all relevant points that fall under current translations
    fatherWav = 2^startLevel .* father_x .* father_y;
    
    newyTranlateIndex = yTranslateIndex + (i-1) * numXTranslations;
    linearIndex = sub2ind(size(scalValsPerPoint), sampleIndex, newyTranlateIndex);
    scalValsPerPoint(linearIndex) = fatherWav;
    
end % for i = 1 : translations_x

fatherValsPerPoint = bsxfun(@times, scalValsPerPoint, coeffs');
fatherValsPerPoint = sum(fatherValsPerPoint,2);
scalingBasisPerSample = bsxfun(@rdivide, scalValsPerPoint, fatherValsPerPoint);
scalValsSum = sum(scalingBasisPerSample,1);
loglikelihood = log(fatherValsPerPoint.^2);

currCost = -(1/numSamps)*sum(loglikelihood);

if(~scalingOnly)
    currGrad = -2*(1/numSamps)*[scalValsSum mothValsSum]';
else
    currGrad = -2*(1/numSamps)*[scalValsSum]';
end
