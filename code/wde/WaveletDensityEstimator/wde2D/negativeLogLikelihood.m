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

numSamps      = size(samps,1);%length(goodSampsIdx);

% Translation range for the starting level scaling function.  Need both x
% and y values since 2D.
scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)]; %all the points from -59 to 52
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];

% Set up correct basis functions. Now that we have all the translation
% points from -59 < k < 52
[father, mother] = basisFunctions(wName); % makes function handlers for the specific type of wavelet
%   this function interpolates for every sample point


% waveletSum        = 0;
% loglikelihood     = 0;
loglikelihood     = zeros(numSamps,1);

% Determine if we need to count up or down.
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end
% Allocate zeros for the scaling function sum.
% scalValsSum = zeros(1,coeffsIdx(1,2));


if(~scalingOnly)
    % The remaining will be wavelet functions.
    mothValsSum = zeros(1,length(coeffsIdx(2,1):coeffsIdx(end,2)));
end

%%%%%%
translations = length(scalingShiftValsX);
scalValsSum = zeros(translations);

coeffs = reshape(coeffs', translations,translations);
%%%%%%

for s = 1 : numSamps
% for s = 1 : numSamps
    
    waveletSum = 0;
        
    % Get (x,y) value of the sample.
    %sampX = samps(goodSampsIdx(s),1); sampY = samps(goodSampsIdx(s),2);
    sampX = samps(s,1); sampY = samps(s,2); %This is always changing along sample points
    
    % Compute father value for all scaled and translated samples 
    % over our entire 2D sampling grid.
    x         = 2^startLevel*sampX - scalingShiftValsX; % This is the wavelet basis argument (x = 2^j x - k)
    y         = 2^startLevel*sampY - scalingShiftValsY;

    % Set sample support values
    xIndex = find(x <= 7 & x >= 0);
    yIndex = find( y <= 7 & y >= 0); 
    
    %loop through the elements in scalingShiftValsX to get back x
    %loop through k intergers to get back a sample point
    
    % Using kronecker prodcut to get combination of all shift values.
    % Will result in:
    % f(x1)*f(y1),f(x1)f(y2),f(x1)f(y3),...f(x2)f(y1),...f(xN)f(yM)
    % Also note we don't need the (1/2) factor in normalization because we
    % are multiplying 2 basis functions together so the factor cancels.
    scalVals  = 2^startLevel*kron(father(x(xIndex)),father(y(yIndex))); %if non zero, then is true and x falls under wavelete basis
    scalVals = reshape(scalVals, [length(yIndex), length(xIndex)]);

    % Weight the basis functions with the coefficients.
    scalingBasis = coeffs(yIndex,xIndex).*scalVals; %if scal vals are zero, then no coeff
    scalingSum   = sum(sum(scalingBasis));
    
%     % Incorporate the mother basis if necessary.
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
%             
%             % Need to 3 different combinations for 2D wavelets. The entire
%             % grid of translations is put in a 1xM vector for each of
%             % combinations.  The kron is traversing the grid from the lower
%             % left to the upper right order.  This is the same ordering as
%             % what you would get from doing [xx, yy] = meshgrid(-5:5,-4:4);
%             % followed by putting points in a matrix pts = [xx(:) yy(:)];
%             mothVals1  = 2^j*kron(father(x),mother(y));
%             mothVals2  = 2^j*kron(mother(x),father(y));
%             mothVals3  = 2^j*kron(mother(x),mother(y));
%             
%             mothVals   = [mothVals mothVals1 mothVals2 mothVals3];
%         end 
%         % Multiply by the weights.
%         wavBasis    = coeffs(coeffsIdx(2,1):end)'.*mothVals;
%         waveletSum  = sum(wavBasis);
%     end % if(~scalingOnly)
    
%     basisSumPerSample = scalingSum + waveletSum; % Dep. 
    basisSumPerSample = scalingSum; % Dep. 

%     loglikelihood     = loglikelihood + log(basisSumPerSample^2); % Dep.
    
    loglikelihood(s)  = log(basisSumPerSample^2); % Dep.   equation 15
    
    scalVals  = scalVals/basisSumPerSample;
    
    % For the gradient we keep summing this up for all samples.
%     scalValsSum = scalValsSum + scalVals;
    
    scalValsSum(yIndex,xIndex) = scalValsSum(yIndex,xIndex) + scalVals;

%     if(~scalingOnly)
%         mothVals    = mothVals/basisSumPerSample;
%         % Keep summing up for the gradient.
%         mothValsSum = mothValsSum + mothVals;
%     end
end % for s = 1 : numSamps

coeffs = reshape(coeffs.', [numel(coeffs),1]); 
scalValsSum = reshape(scalValsSum, [1, numel(scalValsSum)]);

%this is what tells 
currCost = -(1/numSamps)*sum(loglikelihood);    %equation 15 this is negative loglikelihood
% currCost = -(1/numSamps)*loglikelihood;

if(~scalingOnly)
    currGrad = -2*(1/numSamps)*[scalValsSum mothValsSum]';
else
    currGrad = -2*(1/numSamps)*[scalValsSum]';
end
