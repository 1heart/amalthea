%--------------------------------------------------------------------------
% Function:    mlWDE2D
% Description: Maximum likelihood based wavelet density estimation (WDE).
%              (Specific to 2D estimation)
% Inputs:
%   samps             - Nx2 matrix of 2D samples to use for density
%                       estimation.  The first column is x and second y.
%   wName             - name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets.
%                       Default: 'db1' - Haar
%   scalingStartLevel - starting level for the the father wavelet
%                       (i.e. scaling function).
%                       Default: 0
%   waveletStopLevel  - last level for mother wavelet scaling.  The start
%                       level is same as the father wavelet's.
%                       Default: 5
%   varargin          - various parameters.
%
% Outputs:
%   coeffs            - coefficients for the basis functions per
%                       iteration of the optimization.
%   coeffsIdx         - Lx2 matrix containing the start and stop index
%                       locations of the coeffients for each level in the
%                       coefficient vector.  L is the number of levels.
%                       For example, the set of coefficients for the
%                       starting level at the 1st iteration can be obtained
%                       from the coefficient vector as:
%                       coeffs(coeffsIdx(1,1):coeffsIdx(1,2),1)
%                       NOTE: This will be (L+1)x2 whenever we use more
%                             than just scaling coefficients.
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
function [coeffs, coeffsIdx] = mlWDE2D(samps, wName, scalingStartLevel, ...
    waveletStopLevel, varargin)

% Error checking and defaults
if(~exist('wName'))
    wName = 'db1';
end
if(~ischar(wName))
    error('Please enter charater code for wavelet type!');
end

% Checks for valid wavelet name
waveSupport(wName);

if(~exist('scalingStartLevel'))
    scalingStartLevel = 0;
end

if(~exist('waveletStopLevel'))
    waveletStopLevel = 5;
end

if(scalingStartLevel > waveletStopLevel)
    error('The start level cannot be greater than the stop level!');
end

if(isempty(varargin(1)))
    scalingOnly = 1;
else
    scalingOnly = cell2mat(varargin(1));
end

% Get the support for the samples.  The wavelet coverage is designed such
% that it puts one full support of the wavelet past end of the sample
% support and one full support of the wavelet before the beginning of the
% sample support.
if(isempty(varargin(2)))
    sampleSupport = sampSupport(samps);
else
    sampleSupport = cell2mat(varargin(2));
end

% Get the initalization type.
if(isempty(varargin(4)))
    initType = 'level';
else
    initType = varargin(4);
end
if(isempty(varargin(5)))
    bins = [];
else
    bins = cell2mat(varargin(5));
end

stInitCoeff = tic;
% Calculate initial coefficients for gradient descent and
% pass scaling and wavelet values for negativeLoglikelihood
[coeffs, coeffsIdx, scalValsPerPoint, waveletValsPerPoint] = ...
    initializeCoefficients(samps, scalingStartLevel, waveletStopLevel, ...
    sampleSupport, wName, scalingOnly,initType, ...
    samps, bins);
stopInitCoeff = toc(stInitCoeff);
disp(['Time in initializeCoefficients: ', num2str(stopInitCoeff)]);

% Optimization variables
if(isempty(varargin(3)))
    maxIter = 400;
else
    maxIter = cell2mat(varargin(3));
end

stNegLog = tic;
% Calculate initial negative loglikelihood cost function value
[currCost, currGrad] = negativeLogLikelihood(samps, coeffs,coeffsIdx,...
    scalingOnly, scalValsPerPoint, waveletValsPerPoint);
stopNegLog = toc(stNegLog);
disp(['Time in negativeLogLikelihood: ', num2str(stopNegLog)]);

% Stores cost function value, direction, and gradient
nllTrack     = currCost;
directionTrack     = [];
gradientNTrack   = [];

iter    = 0;
gradTol = 1e-4;
direction = 99999;

% Start gradient descent
t0         = clock;
while( (iter<maxIter) && (norm(direction) >= gradTol))
    iter = iter + 1;
    
    disp(['Iteration ' num2str(iter) ': nll = ' num2str(currCost)]);
    disp(['              Gradient Norm = ' num2str(norm(currGrad))]);
    gradientNTrack = [gradientNTrack norm(currGrad)];
    
    % Direction is computed from the modified Newton update.
    % This assumes the Hessian of the Lagrangian is postive definite
    % over the entire space, which is true our case.
    gradOfConstraints = 2*coeffs(:,iter);
    sumSqOfCoeffs     = norm(coeffs(:,iter))^2;
    invTerm           = 4/(gradOfConstraints'*gradOfConstraints);
   
    % Put in this temporay fix b/c for high starting values that identMat
    % was casuing an out of memory error.  Can just comment this out and
    % uncomment the original temp1 below.
    tempMat           = -gradOfConstraints*(invTerm)*gradOfConstraints'*(.25);
    for n = 1:size(tempMat,1)
        tempMat(n,n)=1+tempMat(n,n);
    end
    temp1             = -(.25)*(tempMat)*currGrad;    temp2             = (.25)*gradOfConstraints*invTerm*(sumSqOfCoeffs-1);
    direction         = temp1-temp2;
    disp(['              Direction = ' num2str(norm(direction))]);
    
    % Optimial solution point (should equal one)
    lambda            = invTerm*((sumSqOfCoeffs-1)-gradOfConstraints'*(.25)*currGrad);
    disp(['              lambda    = ' num2str(lambda)]);
    
    % Update the coefficents using the modified Newton update.
    coeffs(:,iter+1) = coeffs(:,iter) + direction;
    
    % Calculates the update cost and gradient estimate
    [currCost, currGrad] = negativeLogLikelihood(samps, coeffs(:,iter+1), coeffsIdx,...
        scalingOnly, scalValsPerPoint, waveletValsPerPoint);
    
    % Additional check to see if we want to break out early.
    nllTrack = [nllTrack currCost];
    directionTrack = [directionTrack norm(direction)];
    
end % while( (iter<maxIter) & (norm(currGrad) >= gradTol))

% Displays time stamps
sec = etime(clock,t0);
if(sec <= 60)
    disp(['Program execution took: ' num2str(sec) ' seconds.'])
elseif((sec > 60) && (sec <= 3600))
    disp(['Program execution took: ' num2str(sec/60) ' minutes.'])
else
    disp(['Program execution took: ' num2str(sec/3600) ' hours.'])
end
