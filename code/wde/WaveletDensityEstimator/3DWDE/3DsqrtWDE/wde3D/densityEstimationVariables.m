%--------------------------------------------------------------------------
% Function:    densityEstimationVariables
% Description: Stores all the variables needed for online density
%              estimation.
%
% Inputs:       No Inputs.
% Outputs:
%   sample            - Vector of numbers or single sample.   
%   wavelet           - Name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets.   
%   startLevel        - Starting level for the the father wavelet and
%                       mother wavelet. 
%   stopLevel         - Last level for mother wavelet scaling. The start
%                       level is same as the father wavelet's.
%   discretization    - Value that the support of the density is
%                       discretized by.                  
%   waveletFlag       - If this flag is on then density estimation is done     
%                       with scaling + wavelets. The default is density
%                       estimation with the scaling function only. 
%                       waveletFlag = 1; Wavelet is on. 
%                       waveletFlag = 0; Wavelet is off. Default is zero.
%   domain            - Domain bounds of the density function.
%   showPlots         - if showPlots == 1, then the density will be shown
%                       as the estimator is running.
% 
% Usage: This function is needed for online density estimation to take
%        place.
%
% Authors(s):
%   Mark Moyou(mmoyou@my.fit.edu)
%   Eddy Ihou(ihouk2002@my.fit.edu)

%--------------------------------------------------------------------------
function [sample,...
          wavelet,...
          startLevel,...
          stopLevel,...
          waveletFlag,...
          domain,...
          showPlots,mu,sigma,sampLenf,dim,isovalue]...
                     = densityEstimationVariables()

% % Load data.
% load('claw100000.mat', 'samps');
% % load('claw10000000.mat', 'samps');
% sample = samps;

% GENERATE SYNTHETIC DATA
%==========================================================================
% number of samples
N = 3000;
% N = 50;
% % Specific a covariance matrix
%   sigma = [.5 .05; .05 .5 ];
%   mu =[0 0];
sigma = eye(3);
%sigma = -5*[.5 .05 .3; .05 .5 .2; .7 .5 .2 ];
mu =[0 0 0];
temp = generateBivarNormalDist(N,sigma,mu);
% preprocessing
[sample,bounds] = preProcessing(temp);
domain = bounds;
%==========================================================================
%===========================================================================
% Variables other than the samples.
wavelet = 'db1'; % wavelet name (format string).
startLevel = 1; %refers to the j0 values.
stopLevel = 2; % refers to the J value.
waveletFlag = 0; % 1 - on ; 0 - off(default).
discretization = 0.5;
%discretization = .1;
%domain = [-3.5 3.5];
showPlots = 0; % if == 1 then plots will be shown.

% UPLOAD REAL DATA
%==========================================================================
%==========================================================================

% load('tri3.mat')
% sample = samps;
% sampleSupp  = [-4 4; -4 4];
% domain = [-4 4; -4 4];
% delta = 0.01;
% supportVals = [-4:delta:4];
% 
% [xx yy] = meshgrid(supportVals,supportVals);
% surf(xx,yy,gmmTruth);shading interp;
% 
% title ('2D plot of the true density')
% xlabel (' x coordinates')
% ylabel (' y coordinates')
% zlabel (' density values')

%==========================================================================
%==========================================================================
sampLenf = size(sample,1);
% dimension of the sample
dim = size(sample,2); 
isovalue = (max(sample(:))-min(sample(:)))/2; % parameter for plotting the isosurface level for 3D samples
 [isovalue]= trueDensityPlot( domain,discretization,mu,sigma,dim,isovalue );
% end
