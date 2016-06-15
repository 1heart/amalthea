% Optimial Transport with Entropic Regularization
% Drive file to execute tests.
close all; clc; clear; clear functions;

getd = @(p)path(p,path);
getd('.\WDE\wde2D');
getd('.\WDE\waveCommon');


% Data location.
dataDir = 'C:\FIT\Research\DataSets\MPEG7Shapes\scale10AlignedFullDB\';

shapeCat = 'butterfly';
shapeNum = '17';
shapeDir = ['.\Figures\' shapeCat shapeNum '\'];

mkdir(shapeDir);

load([dataDir shapeCat '.mat']);
eval(['shapePts = ' shapeCat shapeNum ';']);
% Scale down the points.
scaleFac = .1;
s1 = scaleFac*shapePts;

% Apply affine transformation to shape.
rotAng = 90;
rotAng = (rotAng/180)*pi;
A = [cos(rotAng) -sin(rotAng); sin(rotAng) cos(rotAng)];

%A = rand(2,2);
%load affineTx_1;
load savedView;
s2 = (A*s1')';% + repmat([1.2 1.2],size(s1,1),1); 
s1 = s1 ;%+ repmat([-1 -1],size(s1,1),1); 

figure;
plot(s1(:,1),s1(:,2),'bo');
%print(gcf,'-dpng',[shapeDir 'origShape_1_' shapeCat '_' shapeNum '_.png']);
figure;
plot(s2(:,1),s2(:,2),'rs');
%print(gcf,'-dpng',[shapeDir 'origShape_2_' shapeCat '_' shapeNum '_.png']);


% Define convergence threshold and other free parameters.
convgThresh = 1e-4;
maxIter     = 1000;
iter        = 0;
costDiff    = 9e9;
numGridPts  = 100;
scaleFac    = .02;
useGmms     = 1;
numTSteps   = 10;

% Estimate the densities.
gamma       = 1e-1;
% WDE free parameters
wName       = 'sym4';

startLevel  = 3;
stopLevel   = startLevel;
onlyScaling = 1;
iterations  =  15;
wdePlotting = 0;
delta          = .05;
xMin           = -2.5;
xMax           = 2.5;
yMin           = -2.5;
yMax           = 2.5;
sampleSupp     = [xMin xMax;yMin yMax];
supportVals    = [xMin:delta:xMax];
[x1Grid x2Grid]  = meshgrid(supportVals,supportVals);
densityPts     = [x1Grid(:) x2Grid(:)];

% Reconstruct the densities
numDensities = 2;

% Store densities in a NxNxK matrix.
numGridPts = size(x1Grid,1);
allDensities = zeros(numGridPts,numGridPts,numDensities);
disp('Starting density reconstruction');
tic;
for p = 1 : numDensities
    eval(['samps = s' num2str(p) ';']);
    [coeffs, coeffsIdx] = mlWDE2D(samps, wName, startLevel, ...
                              stopLevel, onlyScaling, sampleSupp, iterations,'hist',[]);
    D = norm(coeffs(:,end))^2;
    coeffs(:,end) = coeffs(:,end)/sqrt(D);
    sp=plotWDE(densityPts, sampleSupp, wName, startLevel, stopLevel, coeffs(:,end), coeffsIdx,...
       onlyScaling, x1Grid, x2Grid,wdePlotting);
    pdf = sp.^2;
    pdf = pdf + max(pdf(:))*scaleFac;
    pdf = pdf/sum(pdf(:));
    allDensities(:,:,p) = pdf;
end
disp('End density reconstruction');
toc;

%load shapeDensitiesButter19;

numDensities        = size(allDensities,3);

% % Compute cost matrix.  Use distance between grid locations as cost.
% costMat   = pdist2(x,x).^2;
% gibbsCost = exp(-costMat/gamma);

% Setup the computation of the cost kernel as a convolution.
n         = ceil(numGridPts*.95); % width of the convolution kernel; set it too small and barycenter will vanish, too large and it over smooths. should set scale factor almost to 1.
t         = linspace(-n/(2*numGridPts),n/(2*numGridPts),n)';
g         = exp(-t.^2 / gamma);
gibbsCost = @(c,g)conv2(conv2(c, g, 'same')', g, 'same')';


%hold on;
%cPs = 3;
%rPs = ceil(numTSteps/cPs);

%subplot(rPs,cPs,1);
figure;
surf(x1Grid,x2Grid,allDensities(:,:,1)); shading interp; %alpha(.5);
colormap(jet); view([azS elS]);
%print(gcf,'-dpng',[shapeDir 'origDensity_1_' shapeCat '_' shapeNum '_.png']);
set(gcf,'WindowStyle','docked');

%subplot(rPs,cPs,rPs*cPs);
figure;
surf(x1Grid,x2Grid,allDensities(:,:,2)); shading interp; %alpha(.5);
view([azS elS]);
%print(gcf,'-dpng',[shapeDir 'origDensity_2_' shapeCat '_' shapeNum '_.png']);
set(gcf,'WindowStyle','docked');
%freezeColors;

% Calculate the barycenter.
t2 = linspace(0,1,numTSteps);
cnt = 0;
for tStep = t2
    cnt = cnt + 1;
    % Weights for barycenter.
    lambda = [1-tStep tStep]';
    iter   = 0;
    disp(['t-Step: ' num2str(tStep)]);
    % Initialize alternating projection vectors.
    v = ones(numGridPts,numGridPts,numDensities);
    u = v;
    gamma = 1e-4; 
    g     = exp(-t.^2 / gamma);
    % Calculate the barycenter.
    while ((costDiff > convgThresh) && (iter < maxIter))
%         if(mod(iter,floor(maxIter/6))==0)
%             if(iter==0)
%                 ;
%             else
%                 gamma = gamma*.1;
%                 g     = exp(-t.^2 / gamma);
%             end
%         end
        
        % Step 1: Projection for the fixed marginals constraints, i.e. the
        % columns sum of the k-th coupling (aka transport or joint) should be  
        % the k-th density.
        for p = 1 : numDensities
            u(:,:,p) = allDensities(:,:,p) ./ (gibbsCost(v(:,:,p),g));
        end

        % Step 2: Projection for the equal marginals constraints, i.e. the row
        % sum of each of the k couplings (aka transport or joint) should be the
        % barycenter density.
        barycenterDensity = zeros(numGridPts);
        for p = 1 : numDensities
            barycenterDensity = barycenterDensity + lambda(p) * log( max(eps, v(:,:,p) .* (gibbsCost(u(:,:,p),g)) ) );
        end
        barycenterDensity = exp(barycenterDensity);

        % Step 3: Update the marginals to be equal to the barycenter.
        for p = 1 : numDensities
            v(:,:,p) = barycenterDensity ./ (gibbsCost(u(:,:,p),g));
        end

        % Put in cost calculation.

        iter = iter + 1;
    end
    
    %subplot(rPs,cPs,cnt);
    figure;
    surf(x1Grid,x2Grid,barycenterDensity); shading interp; view(0,90);
    colormap(jet);
    if(cnt < 10)
        tStepStr = ['0' num2str(cnt)];
    else
        tStepStr = num2str(cnt);
    end
    print(gcf,'-dpng',[shapeDir 'baryCentDef_' shapeCat '_' shapeNum 'tStep_' tStepStr '_.png']);
    set(gcf,'WindowStyle','docked');
    pause(.25);
end
%h2 = plot(x,pdf1,':g','Linewidth',2);
%h3 = plot(x,pdf2,':r','Linewidth',2);
%legend([h1 h2 h3],{'Barycenter';'p_1(x)';'p_2(x)'});