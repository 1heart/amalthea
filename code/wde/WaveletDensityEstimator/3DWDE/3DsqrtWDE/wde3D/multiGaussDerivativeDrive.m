%multiGaussDerivatDrive


% % Load data.
% load('claw100000.mat', 'samps');
% % load('claw10000000.mat', 'samps');
% sample = samps;

% GENERATE SYNTHETIC DATA
%==========================================================================
% number of samples
N = 4000;
% N = 50;
% % Specific a covariance matrix
%   sigma = [.5 .05; .05 .5 ];
%   mu =[0 0];
sigma = eye(3);
%sigma = -5*[.5 .05 .3; .05 .5 .2; .7 .5 .2 ];
mu =[0 0 0];
temp = generateBivarNormalDist(N,sigma,mu);
% preprocessing
[sample,bounds] = preProcessingOfDerivative(temp);
domain = bounds;
%==========================================================================
%===========================================================================
% Variables other than the samples.
wavelet = 'db2'; % wavelet name (format string).
startLevel = 2; %refers to the j0 values.
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
[isovalue, densityr]= trueDensityPlotForDeriv( domain,discretization,mu,sigma,dim,isovalue );
 %close all
 
 
 analyticDerivOfMultiGaussian(domain,isovalue,discretization) ;
 
 
 
 
 % build the derivatives of the density wrt to x y and z
 
 
 
 
 
 
 