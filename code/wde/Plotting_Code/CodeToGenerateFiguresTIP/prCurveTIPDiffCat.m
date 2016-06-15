% -------------------------------------------------------------------------
% Script: prCurveTIPDiffCat
% Date: Thursday 20th March, 2014.
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver loads the precision and recall data, then plots
%              a precision-recall curve over a particular dataset at a set
%              resolution level and curves for each category.
% 
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
clear; clc; close all; 
cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');

% Folder to save the image. 
imFold = 'C:\Users\mmoyou\Google Drive\Journal Paper Research\Figures\';

% Name to save the image under.
imName = 'prCurveTIPCOSEGCategories';

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
prSH11 = sh11Data{14,1};    % SHREC 11.
prSH10 = sh10Data{14,1};    % SHREC 10. 
prCos = cosData{14,1};      % COSEG.
prSH12 = sh12Data{14,1};    % SHREC 12.

dataToPlot = prCos;
origData = cosData;

numCat = size(dataToPlot,1);
recVals = origData{17,1};
cols = lines(numCat +700);

markerCell = cell(8,1);
markerCell{1} = 'v';
markerCell{2} = 'x';
markerCell{3} = '*';
markerCell{4} = 's';
markerCell{5} = 'o';
markerCell{6} = 'd';
markerCell{7} = '^';
markerCell{8} = '+';

legCell = cell(8,1);
legCell{1} = 'Candelabra';
legCell{2} = 'Chairs';
legCell{3} = 'Fourleg';
legCell{4} = 'Goblets';
legCell{5} = 'Guitars';
legCell{6} = 'Irons';
legCell{7} = 'Lamps';
legCell{8} = 'Vases';

hold on;
% Colors;
col = [1 0 1];
mt = 'o';
ls = '-';
lw = 1.8;
ms = 15;


for i = 1 : numCat
    disp(normalizePrecRecCurve(dataToPlot{i,1}));
    plot(recVals, normalizePrecRecCurve(dataToPlot{i,1}), markerCell{i}, 'Color', cols(i+60,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);
      
     a = normalizePrecRecCurve(dataToPlot{i,1})
end

% Add a legend
yVal = 0.92;
ylim([yVal 1]);
set(gca, 'YTick', (yVal :0.01 : 1));
xlim([0 1]);    

leg = legend(legCell, 'Location', 'Best' );

LEG = findobj(leg,'type','text');
set(LEG,'FontSize',15)

% set(findobj(gca,'type','line'),'linew',1.4)
set(gca,{'linew'},{1.5})
set(gca, 'YGrid','on');
set(gca,'FontSize',12);
set(findobj(gca,'Type','text'),'FontSize',3);

xlabel('Recall', 'fontsize', 16, 'fontweight','b');
ylabel('Precision', 'fontsize', 16, 'fontweight','b');
set(gca,'FontWeight','bold');

% Saving the figures.
fileNameToSaveIms = [imFold imName];

% Save the precision and recall plot as a png.
dvpng = saveFigToImage(fileNameToSaveIms, gcf, 'png');

% Save the precision and recall plot as a fig.
dvfig = saveFigToImage(fileNameToSaveIms, gcf, 'fig');

% Save the precision and recall plot as an eps.
dveps = saveFigureToEPS(fileNameToSaveIms, gcf);

