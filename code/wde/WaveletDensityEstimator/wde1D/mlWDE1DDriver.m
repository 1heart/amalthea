%--------------------------------------------------------------------------
% Script: mlWDE1DDriver
% Description: Main driver file for maximum likelihood based wavelet 
%              density estimation (WDE). (Specific to 1D estimation)
% Usage: Run this file in Matlab
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

close all; clc; clear; 

% Add path to wavlet tables.
path('../waveCommon',path);

% Load the input points.  All example points in the inputMAT directory have
% a Nx1 matrix of uivariate samples.  Examples include:
% gaussian
% tri
% outlier            
% kurtoticUni, skewedUni, strongSkewedUni        
% claw, asymmClaw, dblClaw, asymmDblClaw
% bi, separatedBi, skewedBi      
load inputMAT/claw;

plot(samps, 'o');
title('Sample data for density estimation','Fontsize',14);

% Pick wavelet family.  Currently supports:
%   db1-10, e.g. 'db2', Note: 'db1' is Haar
%   coif1-5, e.g. 'coif4'
%   sym4-10, e.g. 'sym4'
wName = 'sym4';

% Starting resolution level.
startLevel  = 2;
% Stopping resolution level.  This would be used if the one wants a
% multiresolution level version of the density.  The current optimization
% technique does not converge well for multiresolution representations.  It
% is recommended to only use a single resolution.  In some cases, the Haar
% basis does converge for multiresolution so you can change the family to
% 'db1' and then test different stopping levels.
stopLevel   = startLevel;
% Flag indicating that we only want to use scaling functions.  If you
% are using multiresolution then this should be set to 0.
onlyScaling = 1;
% Number of optimization iterations.  There is also an internal error
% criterion that breaks the optimization if the change in the gradient
% between consecutive iterations drops below 1e-4.
iterations  =  15;
% Plots the estimated density.
wdePlotting = 1;

% Define domain of sample support.
% Step size.  Smaller step size provides better plots but a longer time
% to perform the density evaluation and plot.
delta          = .01;
xMin           = -3.5;
xMax           = 3.5;
sampleSupp     = [xMin xMax];
densityPts     = [xMin:delta:xMax];

% Intialization type for coefficients.
initType = 'hist';
bins     = [];

% Estimate the density.  The returned 'coeffs' has the set of coefficients
% for each of the optimization iterations.  The last column is the most
% recent.
[coeffs, coeffsIdx] = mlWDE1D(samps, wName, startLevel, ...
                              stopLevel, onlyScaling, sampleSupp,iterations, initType, bins);

% % Uncomment this section if you want to normalize coefficients.
% % Check if coefficients converged.  If not they can be easily normalized.
% if(norm(coeffs(:,end))~=1)
%     disp('Coefficients did not converge to 1.  Renormalizing manually!');
%     D = norm(coeffs(:,end))^2;
%     disp(['Off by ' num2str(abs(1-D)) ]);
%     coeffs(:,end) = coeffs(:,end)/sqrt(D);
% end

% Plot over our defined domain.  The returned 'sp' variable contains the
% square root of the density evaluated over the specifined support domain. The
% density is recoved simply by executing p=sp.^2;
sp=plotWDE(densityPts, sampleSupp, wName, startLevel, stopLevel, coeffs(:,end), coeffsIdx, onlyScaling, wdePlotting);

% The examples in the inputMAT directory have analytic true densities we can
% use for comparison.  The ture density were created with the domain step
% size of .01.
if(exist('gmmTruth','var'))
    trueDelta = .01;
    trueXGrid    = [xMin:trueDelta:xMax];
    figure;
    hold on;
    h2=plot(trueXGrid,gmmTruth,':g','Linewidth',2);
    h1=plot(densityPts,sp.^2,'r');
    legend([h1 h2],{'Estimated density';'True density'});
    hold off;
    title('WDE Comparison','Fontsize',14);
end

% Get the value of the density at desired points.
pnts = [3;1];
wdeVals = eval1DWDE(pnts, sampleSupp, wName, startLevel, stopLevel,...
                         coeffs(:,end), coeffsIdx, onlyScaling);
