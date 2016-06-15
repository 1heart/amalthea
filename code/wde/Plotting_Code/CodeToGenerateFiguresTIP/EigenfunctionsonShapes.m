% Eigenfunctions on Shapes TIP Figure 2.

clc; close all; 

clear;

% Change directory to main shape directory. 
cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');

% Load the SHREC 11 shape data. 
shFileName = '.\PamiShapeFiles\SHREC11.mat';
load(shFileName);

% Load the SHRECC 11 eigenfunction data.
eigShName = '.\EigenFunctionsForShapes\SHREC11Pami_rInf_GPS_nefc_6_NMA_ms';
load(eigShName);

sv = shapeData; % Source variable. 
eigData = allGpsCoorNmAll; % Eigenfunction data.s

imFold = 'C:\Users\mmoyou\Google Drive\Journal Paper Research\Figures\';

%% Armadillo E1 43/61 (Shape number).
sn = 43;
ef = 1;
efAr = eigData{sn};
h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
view(104,90);
zoom(1.4);
% light('Position',[ -35 -4 30],'Style','infinite');
light('Position',[ 1 0 1],'Style','infinite');
lighting phong;
% print([imFold 'Armadillo_EF1' '.eps' ],'-depsc');
% 
% 
% %% Armadillo E2 43/61 (Shape number).
% sn = 43;
% ef = 2;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(104,90);
% zoom(1.4);
% light('Position',[- 10 0 0],'Style','infinite');
% lighting phong;
% print([imFold 'Armadillo_EF2' '.eps' ],'-depsc');
% 
% %% Armadillo E5 43/61 (Shape number).
% sn = 43;
% ef = 5;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(104,90);
% zoom(1.4);
% light('Position',[ -35 -4 30],'Style','infinite');
% lighting phong;
% print([imFold 'Armadillo_EF5' '.eps' ],'-depsc');
% 
% %% Centaur E1 153/158 (Shape number).
% sn = 153;
% ef = 1;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(100,-78);
% zoom(1.4);
% light('Position',[ 35 4 -30],'Style','infinite');
% lighting phong;
% print([imFold 'Centaur_EF1' '.eps' ],'-depsc');
% 
% %% Centaur E2 153/158 (Shape number).
% sn = 153;
% ef = 2;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(100,-78);
% zoom(1.4);
% light('Position',[ 35 4 -30],'Style','infinite');
% lighting phong;
% print([imFold 'Centaur_EF2' '.eps' ],'-depsc');
% 
% %% Centaur E5 153/158 (Shape number).
% sn = 153;
% ef = 5;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(100,-78);
% zoom(1.4);
% light('Position',[ 35 4 -30],'Style','infinite');
% lighting phong;
% print([imFold 'Centaur_EF5' '.eps' ],'-depsc');
% 
% %% Gorilla E1 270 (Shape number).
% sn = 270;
% ef = 1;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(-87,90);
% zoom(1.2);
% light('Position',[ -10 -20 30],'Style','infinite');
% % lighting gourad;
% lighting phong;
% print([imFold 'Gorilla_EF1' '.eps' ],'-depsc');
% 
% %% Gorilla E2 270 (Shape number).
% sn = 270;
% ef = 2;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(-87,90);
% zoom(1.2);
% light('Position',[ -10 -20 30],'Style','infinite');
% % lighting gourad;
% lighting phong;
% print([imFold 'Gorilla_EF2' '.eps' ],'-depsc');
% 
% %% Gorilla E5 270 (Shape number).
% sn = 270;
% ef = 5;
% efAr = eigData{sn};
% h = showPerVertexFunction(sv{sn,1}, sv{sn,2}, efAr(:,ef));
% view(-87,90);
% zoom(1.2);
% light('Position',[ 110 -20 30],'Style','infinite');
% % lighting gourad;
% lighting phong;
% print([imFold 'Gorilla_EF5' '.eps' ],'-depsc');


