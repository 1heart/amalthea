%--------------------------------------------------------------------------
% Script: mlWDE2DDriver
% Description: Main driver file for maximum likelihood based wavelet 
%              density estimation (WDE). (Specific to 2D estimation)
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
% a Nx2 matrix of bivariate samples.  Examples include:
% tri1, tri2, tri3
% bi1, bi2, bi3, bi4
% asymmClaw, asymmDblClaw 
% kurtotic
% corrGauss, uncorrGauss
% quad
% skewed
load inputMAT/tri3;
scatter(samps(:,1),samps(:,2));
title('Sample data for density estimation','Fontsize',14);

% Pick wavelet family.  Currently supports:
%   db1-10, e.g. 'db2', Note: 'db1' is Haar
%   coif1-5, e.g. 'coif4'
%   sym4-10, e.g. 'sym4'
wName       = 'sym4';

% Starting resolution level.
startLevel  = 1;
% Stopping resolution level.  This would be used if the one wants a
% multiresolution level version of the density.  The current optimization
% technique does not converge well for multiresolution representations.  It
% is recommended to only use a single resolution.  In some cases, the Haar
% basis does converge for multiresolution so you can change the family to
% 'db1' and then test different stopping levels.
stopLevel   = startLevel;
% Flag indicating that we only want to use scaling functions.  If you
% are using multiresolution then this should be set to 0.
onlyScaling = 0;
% Number of optimization iterations.  There is also an internal error
% criterion that breaks the optimization if the change in the gradient
% between consecutive iterations drops below 1e-4
iterations  =  15;
% Plots the estimated density.
wdePlotting = 1;

% Define domain of sample support.
% Step size.  Smaller step size provides better plots but a longer time
% perform the density evaluation and plot.
delta          = .1;
xMin           = -4;
xMax           = 4;
yMin           = -4;
yMax           = 4;
sampleSupp     = [xMin xMax;yMin yMax];
supportVals    = [xMin:delta:xMax];
[xGrid yGrid]  = meshgrid(supportVals,supportVals);
densityPts     = [xGrid(:) yGrid(:)];

% Estimate the density.  The returned 'coeffs' has the set of coefficients
% for each of the optimization iterations.  The last column is the most
% recent.
[coeffs, coeffsIdx] = mlWDE2D(samps, wName, startLevel, ...
                              stopLevel, onlyScaling, sampleSupp, iterations,'hist',[]);
                          
% Plot over our defined domain.  The returned 'sp' variable contains the
% square root of the density evaluated over the specifined support domain. The
% density is recoved simply by executing p=sp.^2;
sp=plotWDE(densityPts, sampleSupp, wName, startLevel, stopLevel, coeffs(:,end), coeffsIdx,...
        onlyScaling, xGrid, yGrid,wdePlotting);
    
% The examples in the inputMAT directory have analytic true densities we can
% use for comparison.  The ture density were created with the domain step
% size of .01.
if(exist('gmmTruth','var'))
    trueDelta = .01;
    supportVals    = [xMin:trueDelta:xMax];
    [trueXGrid trueYGrid]  = meshgrid(supportVals,supportVals);
    figure;
    surf(trueXGrid,trueYGrid,gmmTruth); shading flat;
    title('True density','Fontsize',14);
end

% Get the value of the density at desired points.
pnts = [3 3;1 1];
wdeVals = eval2DWDE(pnts, sampleSupp, wName, startLevel, stopLevel,...
                         coeffs(:,end), coeffsIdx, onlyScaling);
