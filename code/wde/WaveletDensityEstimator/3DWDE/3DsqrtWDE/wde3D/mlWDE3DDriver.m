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

% GENERATE SYNTHETIC DATA
%==========================================================================
% N = 3000;
% sigma = eye(3);
% mu =[0 0 0];
% temp = generateBivarNormalDist(N,sigma,mu);
% 
% % preprocessing: find the domain 
% [sample, domain] = preProcessing(temp);
%==========================================================================

% ------------------ WAVELET DENSITY ESTIMATION VARIABLES -----------------
%
% Variables other than the samples.
% Pick wavelet family.  Currently supports:
%   db1-10, e.g. 'db2', Note: 'db1' is Haar
%   coif1-5, e.g. 'coif4'
%   sym4-10, e.g. 'sym4'
wName = 'db1'; % wavelet name (format: string). 
startLevel = 0; %refers to the j0 values.

% Use all translates  ( relevantTrans = 1 for relevant translates: however 
% the process is somehow slow due to lot of for loops). 
relevantTrans = 2;

% Variables that are not needed for shape matching.
stopLevel = 2; % refers to the J value. 

% Flag indicating that we only want to use scaling functions.  If you
% are using multiresolution then this should be set to 0.
onlyScaling = 1;

% Number of optimization iterations.  There is also an internal error
% criterion that breaks the optimization if the change in the gradient
% between consecutive iterations drops below 1e-4
iterations  =  15;

% -------------------------- LOADING DATA ---------------------------------
%
% Domain is a 3x2 matrix. The domain is set to [-1 1] for shape matching.
% This helps reduce the computational time in estimating the coefficients.
% Sample is a Nx3 matrix. 
% Dim = 3 in this case. 

xlb = -1;   % x lower bound.
xub = 1;    % x upper bound.
ylb = -1;   % y lower bound.
yub = 1;    % y upper bound.
zlb = -1;   % z lower bound.
zub = 1;    % z upper bound.

domain = [xlb, xub; ylb, yub; zlb, zub]; % Domain for x,y,z.

shapeFileName = 'ShapeCoseg.mat'; % Shape file name. 
load(shapeFileName); % Load shape data.  % Variable is shapeData.
nc = size(shapeData,1); % Number of categories. 
nst = shapeData{1,4}; % Number of shapes total. 



catNum = 1;
shapeNum = 1;

shapeCat = shapeData{catNum};
sample = shapeCat{shapeNum,1}; % Chosen shape.

% dimension of the sample
dim = size(sample,2); 

% -------------------------------------------------------------------------



% Estimate the density.  The returned 'coeffs' has the set of coefficients
% for each of the optimization iterations.  The last column is the most
% recent.                                          
[coeffs, coeffsIdx] = mlWDE3D(sample,relevantTrans, wName, startLevel, ...
             stopLevel, onlyScaling, domain, iterations,'level',[]);  
                                                            
% Uncomment this section if you want to normalize coefficients.
% Check if coefficients converged.  If not they can be easily normalized.
if(norm(coeffs(:,end))~= 1)
    disp('Coefficients did not converge to 1.  Renormalizing manually!'); 
    D = norm(coeffs(:,end))^2;
    disp(['Off by ' num2str(abs(1-D)) ]);
    coeffs(:,end) = coeffs(:,end)/sqrt(D);
end  

sum(coeffs(:,end).^2)
