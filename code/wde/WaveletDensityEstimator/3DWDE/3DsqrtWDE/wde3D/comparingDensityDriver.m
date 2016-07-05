%--------------------------------------------------------------------------
% Script: mlWDE3DDriver
% Description: Main driver file for maximum likelihood based wavelet 
%              density estimation (WDE). (Specific to 2D estimation)
% Usage: Run this file in Matlab
% Authors(s):
%   Adrian M. Peter & Eddy Koffi Ihou
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

load('secondRESULT_PartialDenstyWRTX.mat')
% initialization of parameters
%-------------------------------------------------------------------------
startLevel = 0;
wavelet = 'db6';
% [ sample,...
%     wavelet,...
%     startLevel,...
%     stopLevel,...
%     waveletFlag,...
%     domain,...
%     showPlots,mu,sigma,sampLenf,dim,isovalue ] = densityEstimationVariables();
%-------------------------------------------------------------------------
% Load the input points.  All example points in the inputMAT directory have
% a Nx2 matrix of bivariate samples.  Examples include:
% tri1, tri2, tri3
% bi1, bi2, bi3, bi4
% asymmClaw, asymmDblClaw 
% kurtotic
% corrGauss, uncorrGauss
% quad
% skewed

M = max(sample(:));
sample = sample/M;

domain1 = [floor(min(sample(:,1))), ceil(max(sample(:,1)))];
domain2 = [floor(min(sample(:,2))), ceil(max(sample(:,2)))];
domain3 = [floor(min(sample(:,3))), ceil(max(sample(:,3)))];

domain = [domain1;domain2;domain3];

dim = size(sample,2); 
isovalue = (max(sample(:))- min(sample(:)))/2; % parameter for plotting the isosurface level for 3D samples
 [isovalue]= trueDensityPlot( domain,discretization,mu,sigma,dim,isovalue );
%**************************************************************************
%load inputMAT/tri3;
% figure(2)
% scatter(samps(:,1),samps(:,2));
% title('Sample data for density estimation','Fontsize',14);
%**************************************************************************

% Pick wavelet family.  Currently supports:
%   db1-10, e.g. 'db2', Note: 'db1' is Haar
%   coif1-5, e.g. 'coif4'
%   sym4-10, e.g. 'sym4'
%wName       = 'sym4';

% ANALYTIC PARTIAL DERIVATIVE========================================================
%[dFx,dFy,dFz,W] = analyticSqrtDerivOfMultiGaussian(domain,isovalue,discretization,sample);\

wName       =  'db4';

% Starting resolution level.
%startLevel  = 0;
% Stopping resolution level.  This would be used if the one wants a
% multiresolution level version of the density.  The current optimization
% technique does not converge well for multiresolution representations.  It
% is recommended to only use a single resolution.  In some cases, the Haar
% basis does converge for multiresolution so you can change the family to
% 'db1' and then test different stopping levels.
%stopLevel   = startLevel;
% Flag indicating that we only want to use scaling functions.  If you
% are using multiresolution then this should be set to 0.
onlyScaling = 1;
% Number of optimization iterations.  There is also an internal error
% criterion that breaks the optimization if the change in the gradient
% between consecutive iterations drops below 1e-4
iterations  =  15;
% Plots the estimated density.
wdePlotting = 1;
%stopLevel=2;
% Define domain of sample support.
% Step size.  Smaller step size provides better plots but a longer time
% perform the density evaluation and plot.
%delta          = discretization;

delta          = .5;
sampleSuppWav = domain;

Xdomain1 = sampleSuppWav(1,:);
Ydomain2 = sampleSuppWav(2,:);
Zdomain3 = sampleSuppWav(3,:);

supportVals1  = [Xdomain1(1):delta:Xdomain1(2)];%
supportVals2  = [Ydomain2(1):delta:Ydomain2(2)];%
supportVals3  = [Zdomain3(1):delta:Zdomain3(2)];%
 
[xGrid,yGrid,zGrid] = meshgrid(supportVals1,supportVals2,supportVals3);%
densityPts     = [xGrid(:) yGrid(:) zGrid(:)];

% Estimate the density.  The returned 'coeffs' has the set of coefficients
% for each of the optimization iterations.  The last column is the most
% recent.                                          
[coeffs, coeffsIdx] = mlWDE3D(sample, wName, startLevel, ...
             stopLevel, onlyScaling, sampleSuppWav, iterations,'level',[]);  
         
                                                   
% Uncomment this section if you want to normalize coefficients.
% Check if coefficients converged.  If not they can be easily normalized.
if(norm(coeffs(:,end))~= 1)
    disp('Coefficients did not converge to 1.  Renormalizing manually!'); 
    D = norm(coeffs(:,end))^2;
    disp(['Off by ' num2str(abs(1-D)) ]);
    coeffs(:,end) = coeffs(:,end)/sqrt(D);
end                         
                          
% Plot over our defined domain.  The returned 'sp' variable contains the
% square root of the density evaluated over the specifined support domain. The
% density is recoved simply by executing p = sp.^2;   

densityVectLenf = length(densityPts);
sp = plotWDE(isovalue,densityPts, sampleSuppWav, wName, startLevel,...
                            stopLevel, coeffs(:,end), coeffsIdx,...
                            onlyScaling, xGrid, yGrid, zGrid, wdePlotting);
                        
    
% checking the surface sums up to 1 !!!!
% sumOfDensity = sum(sp.^2)*delta^dim;
%--------------------------------------------------------------------------    
% The examples in the inputMAT directory have analytic true densities we can
% use for comparison.  The ture density were created with the domain step
% size of .01.

% if(exist('gmmTruth','var')) % UPDATE THIS%----------------I closed it
%     trueDelta = .01;
%     supportVals    = [xMin:trueDelta:xMax];
%     [trueXGrid trueYGrid]  = meshgrid(supportVals,supportVals);
%     figure;
%     surf(trueXGrid,trueYGrid,gmmTruth); shading flat;
%     title('True density','Fontsize',14);
% end

%--------------------------------------------------------------------------
% Get the value of the density at desired points.
%pnts = [0 0 0];
pnts = sample;
wdeVals = eval3DWDE(pnts, sampleSuppWav, wName, startLevel, stopLevel,...
                         coeffs(:,end), coeffsIdx, onlyScaling);                     
                     
                     
 %plot3(sample(:,1),sample(:,2),sample(:,3),'*');
 
% DO THE PARTIALS 
 
 
