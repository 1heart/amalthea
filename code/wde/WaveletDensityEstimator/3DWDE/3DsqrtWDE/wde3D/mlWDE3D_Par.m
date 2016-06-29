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
function [coeffs, coeffsIdx, iter] = mlWDE3D_Par(samps, wdeSet, varargin)
                                                 
                                                 
alpha = 2;                                                 
% % Error checking and defaults                      
% if(~exist('wdeSet.wName'))
%     wdeSet.wName = 'db1';
% end
% if(~ischar(wdeSet.wName))
%     error('Please enter charater code for wavelet type!');
% end
% % Did they enter a valid wavelet name?
% waveSupport(wdeSet.wName);
% 
% if(~exist('wdeSet.startLevel'))
%     wdeSet.startLevel = 0;
% end
% 
% if(~exist('wdeSet.stopLevel'))
%     wdeSet.stopLevel = 5;
% end
% 
% if(wdeSet.startLevel > wdeSet.stopLevel)
%     error('The start level cannot be greater than the stop level!');
% end

% if(isempty(varargin(1)))
%     scalingOnly = 1;
% else
%     scalingOnly = cell2mat(varargin(1));
% end

% Get the support for the samples.  The wavelet coverage is designed such
% that it puts one full support of the wavelet past end of the sample
% support and one full support of the wavelet before the beginning of the
% sample support.
% if(isempty(varargin(2)))
%     sampleSupport = sampSupport(samps);
% else
%     sampleSupport = cell2mat(varargin(2));
% end

% initType = {'hist'};
initType = {wdeSet.initType};
initDir = '';
% % Get the initalization type.
% if(isempty(varargin(4)))
% %     initType = 'level';
%     initType = 'hist';
% else
%     initType = varargin(4);
% end

% if(isempty(varargin(5)))
%     initDir = '';
% else
%     initDir = varargin(5);
% end

scalingOnly = 1;
% initType = {'hist'};
stInitCoeff = tic;
% currInitCoeffs = @initializeCoefficients;
currInitCoeffs = @initializeCoefficientsOpt;
% Initialize the coefficients for gradient descent.
[coeffs, coeffsIdx] = currInitCoeffs(samps,...
                    wdeSet.startLevel, wdeSet.stopLevel, ...
                     wdeSet.sampleSupp, wdeSet.wName, scalingOnly,...
                     initType, initDir);

% [coeffs_test, coeffsIdx_test] = initializeCoefficientsOpt(samps,...
%                     wdeSet.startLevel, wdeSet.stopLevel, ...
%                      wdeSet.sampleSupp, wdeSet.wName, scalingOnly,...
%                      initType, initDir);
% disp(norm(sum(coeffs) - sum(coeffs_test)));
% disp(norm((coeffs) - (coeffs_test)));

stopStInitCoeff = toc(stInitCoeff);
disp(['Time in initializeCoefficients: ' num2str(stopStInitCoeff)]);



% Initialize a positive definite matrix to approximate the 
% Hessian of the Lagrangian.                    
% approxHessian    = initializeApproxHessian(samps, wName, scalingStartLevel,...
%                                            waveletStopLevel, coeffs, coeffsIdx, ...
%                                            scalingOnly, sampleSupport);                                        
% 
% invApproxHessian = inv(approxHessian);
% Optimization varialbes
% 
% if(isempty(varargin(3)))
%     maxIter = 400;
% else
%     maxIter = cell2mat(varargin(3)) ;
% end
maxIter = 400;
iter    = 0;
gradTol = 1e-4;
direction = 99999;

% %%%%% Mark inserted code. 
startTime = tic;
% 
% %%%%%
% currNLL = @negativeLogLikelihood;
currNLL = @negativeLogLikelihoodOpt;
% Get initial value of the negative loglikelihood cost function
[currCost, currGrad] = currNLL(samps,...
    wdeSet.wName, wdeSet.startLevel, wdeSet.stopLevel, coeffs, ...
                coeffsIdx, scalingOnly, wdeSet.sampleSupp, alpha);

% %%%%% Mark inserted code. 
stopTime = toc(startTime);
disp(['Time in negativeLogLikelihood: ' num2str(stopTime)]);% 

% 
% %%%%%
                                         
nllTrack     = currCost;
coeffPlotFig = 2;
numCoeffs    = length(coeffs);
%identMat     = eye(length(coeffs));
dirTrack     = [];
gradNTrack   = [];
% Start gradient descent
t0         = clock;   
while( (iter < wdeSet.maxIterWhile) & (norm(direction) >= gradTol))
    iter = iter + 1;
    
    disp(['Iteration ' num2str(iter) ': nll = ' num2str(currCost)]);
    disp(['              Gradient Norm = ' num2str(norm(currGrad))]);
    gradNTrack = [gradNTrack norm(currGrad)];
    % Direction is computed from the modified Newton update.
    % This assumes the Hessian of the Lagrangian is postive definite
    % over the entire space, which is true our case.
    gradOfConstraints = 2*coeffs(:,iter);
    sumSqOfCoeffs     = norm(coeffs(:,iter))^2;
    %invTerm           = inv(gradOfConstraints'*invApproxHessian*gradOfConstraints);
    invTerm           = 4/(gradOfConstraints'*gradOfConstraints);
    %    temp1             = -invApproxHessian*(identMat-gradOfConstraints*(invTerm)*gradOfConstraints'*invApproxHessian)*currGrad;
    % Put in this temporay fix b/c for high starting values that identMat
    % was casuing an out of memory error.  Can just comment this out and
    % uncomment the original temp1 below.
    tempMat           = -gradOfConstraints*(invTerm)*gradOfConstraints'*(.25);
    
    tempMat(linspace(1,numel(tempMat),length(tempMat))) = diag(tempMat) + 1;
    
%     
% %     %%%%% Mark inserted code. 
%     startTimeTemp = tic;
% % 
% %     %%%%%
%     
%     tempMat2 = tempMat;
% 
%     % Change this %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mark
%     for n = 1:size(tempMat,1)
%         tempMat(n,n)=1+tempMat(n,n);
%     end
%     
%     %     %%%%% Mark inserted code. 
%     stopTimeTemp = toc(startTimeTemp);
%     disp(stopTimeTemp);
%     
%     
%     startTimeTemp2 = tic;
%     
%     tempMat2(linspace(1,numel(tempMat2),length(tempMat2))) = diag(tempMat2) + 1;
%     
%     stopTimeTemp2 = toc(startTimeTemp2);
%     disp(stopTimeTemp2);
%     norm(tempMat - tempMat2, 'fro')
    

% 
%     %%%%%
%     
%     tempMat2 = tempMat; 
%     %%%%%%%%%%%
%     startTimeTemp2 = tic;
%     tempMat2 = tempMat2 + diag( ones(size(tempMat2,1) ,1) );
%     
%     stopTimeTemp2 = toc(startTimeTemp2);
%     disp(stopTimeTemp2);
%     %%%%%%%%%%%%%%%%%%%%%%%%
    
%     norm(tempMat2 - tempMat, 'fro')
    
    temp1             = -(.25)*(tempMat)*currGrad;
    %temp1            = -(.25)*(identMat-gradOfConstraints*(invTerm)*gradOfConstraints'*(.25))*currGrad;
%    temp2             = invApproxHessian*gradOfConstraints*invTerm*(sumSqOfCoeffs-1);
    temp2             = (.25)*gradOfConstraints*invTerm*(sumSqOfCoeffs-1);
    direction         = temp1-temp2;
    lambda            = invTerm*((sumSqOfCoeffs-1)-gradOfConstraints'*(.25)*currGrad);
    disp(['              Direction = ' num2str(norm(direction))]);
    disp(['              lambda    = ' num2str(lambda)]);
    
%     figure(coeffPlotFig);
%     stem(coeffs(:,iter));
%     title(['Current coefficients at iter: ' num2str(iter)],'Fontsize',14);
%     pause(.5);
    % Update the coefficents using the modified Newton update.
    coeffs(:,iter+1) = coeffs(:,iter) + direction;
    
    % Get the update cost and gradient estimate.
    [currCost, currGrad] = currNLL(samps,...
                     wdeSet.wName, wdeSet.startLevel, wdeSet.stopLevel,...
                        coeffs(:,iter+1), coeffsIdx, scalingOnly,...
                        wdeSet.sampleSupp, alpha);
    
    % Additional check to see if we want to break out early.
    nllTrack = [nllTrack currCost];
    dirTrack = [dirTrack norm(direction)];
end % while( (iter<maxIter) & (norm(currGrad) >= gradTol))

sec = etime(clock,t0);
if(sec <= 60)
    disp(['Program execution took: ' num2str(sec) ' seconds.'])
elseif((sec > 60) & (sec <= 3600))
    disp(['Program execution took: ' num2str(sec/60) ' minutes.'])
else
    disp(['Program execution took: ' num2str(sec/3600) ' hours.'])
end
% save currentRunResults;
% figure;
% plot(nllTrack);
% title(['Negative log likelihood'],'Fontsize',14);
