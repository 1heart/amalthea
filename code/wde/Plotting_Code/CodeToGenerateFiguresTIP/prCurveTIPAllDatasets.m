% -------------------------------------------------------------------------
% Script: prCurveTIPAllDatasets
% Date: Thursday 20th March, 2014.
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver loads the precision and recall data, then plots
%              a precision-recall curve for the best wavelet and resolution
%              level on the datasets.
% 
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
clear; clc; close all; 
cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');

% Folder to save the image. 
imFold = 'C:\Users\mmoyou\Google Drive\Journal Paper Research\Figures\';

% Name to save the image under.
imName = 'prCurveTIP';

cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup\JournalPaperResults');

% Load the precision and recall data for each dataset. 
load('datFile_sc_SHREC10Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db4_RL_3_nsem20');
sh10Data = emCell; clear emCell;

load('datFile_sc_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db1_RL_3_nsem20');
sh11Data = emCell; clear emCell;

load('datFile_sc_COSEG_GD_rInf_nefc_30_NMA_ms_1_2_5_WT_db2_RL_3_nsem12');
cosData = emCell; clear emCell;

load('datFile_sc_SHREC12ICPR_PN_1_2_5_GPS_NmAll_ms_WT_db1_RL_3_nsem10');
sh12Data = emCell; clear emCell;

% Pull out the precision and recall data. 
prSH11 = sh11Data{15,1};    % SHREC 11.
prSH10 = sh10Data{15,1};    % SHREC 10. 
prCos = cosData{15,1};      % COSEG.
prSH12 = sh12Data{15,1};    % SHREC 12.

% Largest recall range.
recRange = sh10Data{17,1};

% Interpolate the probabilities of COSEG and SHREC 12 to make the vectors
% equal to the size of SHREC 10 and 11. 
% Interpolated COSEG Precision data.
iprCos = interp1(cosData{17,1}, prCos, recRange, 'linear', 'extrap'); 
% Interpolated SHREC 12 Precision. 
iprSH12 = interp1(sh12Data{17,1}, prSH12, recRange, 'linear', 'extrap'); 

% Normalize the precision curves. 
prSH11 = normalizePrecRecCurve(prSH11);
prSH10 = normalizePrecRecCurve(prSH10);
iprCos = normalizePrecRecCurve(iprCos);
iprSH12 = normalizePrecRecCurve(iprSH12);

% Colors;
col = [1 0 1];
mt = 'o';
ls = '-';
lw = 1.45;
ms = 8;

% Plot the data
hold on;
% SHREC 12.
plot(recRange, iprSH12, 'Marker', 's', 'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw,'Color', [0 0 1]);

% SHREC 11.       
plot(recRange, prSH11, 'Marker', 'd', 'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw,'Color', [1 0 0]);

% SHREC 10.
plot(recRange, prSH10, 'Marker', 'v', 'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw,'Color', [0.2 0.6 0.2]);

% COSEG.      
plot(recRange, iprCos, 'Marker', 'x', 'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw,'Color', [1 0 1]);      

% Add a legend
set(gca, 'YTick', [0.85 :0.025 : 1]);
xlim([0 1]);    
ylim([0.85 1]);

% set(findobj(gca,'type','line'),'linew',0.5)
% set(gca,{'linew'},{1.5})

leg = legend('SHREC12 Haar R3', 'SHREC11 Haar R3','SHREC10 DB4 R3',...
         'COSEG DB2 R3', 'Location', 'SouthWest' );

LEG = findobj(leg,'type','text');
set(LEG,'FontSize',18)

set(findobj(gca,'type','line'),'linew',1.9)
set(gca,{'linew'},{2.1})
set(gca, 'YGrid','on');
set(gca,'FontSize',12);
set(findobj(gca,'Type','text'),'FontSize',20);

xlabel('Recall', 'fontsize', 16, 'fontweight','b');
ylabel('Precision', 'fontsize', 16, 'fontweight','b');
set(gca,'FontWeight','bold');

% Save the image.

% Saving the figures.
fileNameToSaveIms = [imFold 'SingMeanPRPLot_' imName];

% Save the precision and recall plot as a png.
dvpng = saveFigToImage(fileNameToSaveIms, gcf, 'png');

% Save the precision and recall plot as a fig.
dvfig = saveFigToImage(fileNameToSaveIms, gcf, 'fig');

% Save the precision and recall plot as an eps.
dveps = saveFigureToEPS(fileNameToSaveIms, gcf);


cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');
