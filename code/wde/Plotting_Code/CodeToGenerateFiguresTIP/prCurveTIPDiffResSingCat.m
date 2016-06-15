% -------------------------------------------------------------------------
% Script: prCurveTIPDiffResSingCat
% Date: Friday 21st March, 2014.
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver loads the precision and recall data, then plots
%              a precision-recall curve over a particular dataset for a 
%              particular category and varies the wavelet and resolution 
%              level used.
% 
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
clear; clc; close all; 
cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');

% Folder to save the image. 
imFold = 'C:\Users\mmoyou\Google Drive\Journal Paper Research\Figures\';

% Name to save the image under.
imName = 'prCurveTIPSh11WavResOnCat';

% Change the directory to the data directory.
cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup\TIPResults');

% Load the evaluation data for a dataset. 
load('datFile_scft_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db4_RL_3_nsem20')
db4r3 = emCell; clear emCell;

load('datFile_scft_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db1_RL_3_nsem20');
db1r3 = emCell; clear emCell;

load('datFile_scft_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db4_RL_2_nsem20');
db4r2 = emCell; clear emCell;

load('datFile_scft_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db2_RL_3_nsem20');
db2r3 = emCell; clear emCell;

load('datFile_scft_SHREC11Pami_rInf_GPS_nefc_6_NMA_ms_1_2_5_WT_db2_RL_2_nsem20');
db2r2 = emCell; clear emCell;

% Pull out the precision and recall category data. 
cdb1r3 = db1r3{14,1};
cdb2r2 = db2r2{14,1};
cdb2r3 = db2r3{14,1};
cdb4r2 = db4r2{14,1};
cdb4r3 = db4r3{14,1};
recVals = db1r3{17,1};

cols = lines(5); % Colors for lines.
cols2 = hsv(20); % Colors for lines.
numCat = size(cdb1r3,1); % Number of categories.

% Markers for plots. 
markerCell = cell(5,1);
markerCell{1} = 'v';
markerCell{2} = 'x';
markerCell{3} = '*';
markerCell{4} = 's';
markerCell{5} = 'o';

% Legend plots.
legCell = cell(5,1);
legCell{1} = 'Haar R3';
legCell{2} = 'DB2 R2';
legCell{3} = 'DB2 R3';
legCell{4} = 'DB4 R2';
legCell{5} = 'DB4 R3';

% Plot values.
h = figure;
lw = 1.5;
ms = 10;
cv = [1 4 6 7]; % Category vector.
numCatPlot = numel(cv);

titleCell = cell(numCatPlot,1);
titleCell{1} = {'Alien '; '' };
titleCell{2} = {'Bird1' ; ''};
titleCell{3} = {'Camel';''};
titleCell{4} = {'Cat';''};

% File name to save image. 
fileNameToSaveIms = [imFold imName];
% for i = 1 : numCat
for i = 1 : numCatPlot
   
    disp(['Category ' num2str(i)]);
    
    % Haar R3.
    subplot(2,2,i);
    hold on;
%     plot(recVals, normalizePrecRecCurve(cdb1r3{i,1}), markerCell{1}, 'Color', cols(1*50,:),...
%         'MarkerSize',ms, 'LineStyle', '-',...
%           'LineWidth', lw);
% 
%     % DB2 R2.
%     plot(recVals, normalizePrecRecCurve(cdb2r2{i,1}), markerCell{2}, 'Color', cols(2*50,:),...
%         'MarkerSize',ms, 'LineStyle', '-',...
%           'LineWidth', lw);
%       
%     % DB2 R3.
%     plot(recVals, normalizePrecRecCurve(cdb2r3{i,1}), markerCell{3}, 'Color', cols(3*50,:),...
%         'MarkerSize',ms, 'LineStyle', '-',...
%           'LineWidth', lw);
%       
%     % DB4 R2.
%     plot(recVals, normalizePrecRecCurve(cdb4r2{i,1}), markerCell{4}, 'Color', cols(4*50+50,:),...
%         'MarkerSize',ms, 'LineStyle', '-',...
%           'LineWidth', lw);
%       
%     % DB4 R3.
%     plot(recVals, normalizePrecRecCurve(cdb4r3{i,1}), markerCell{5}, 'Color', cols(5*50,:),...
%         'MarkerSize',ms, 'LineStyle', '-',...
%           'LineWidth', lw);
    % db1r3.
    plot(recVals, normalizePrecRecCurve(cdb1r3{cv(i),1}), markerCell{1}, 'Color', cols(1,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);

    % DB2 R2.
    plot(recVals, normalizePrecRecCurve(cdb2r2{cv(i),1}), markerCell{2}, 'Color', cols(2,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);
      
    % DB2 R3.
    plot(recVals, normalizePrecRecCurve(cdb2r3{cv(i),1}), markerCell{3}, 'Color', cols(3,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);
      
    % DB4 R2.
    plot(recVals, normalizePrecRecCurve(cdb4r2{cv(i),1}), markerCell{4}, 'Color', cols2(4,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);
      
    % DB4 R3.
    plot(recVals, normalizePrecRecCurve(cdb4r3{cv(i),1}), markerCell{5}, 'Color', cols(5,:),...
        'MarkerSize',ms, 'LineStyle', '-',...
          'LineWidth', lw);
    
    normalizePrecRecCurve(cdb1r3{cv(i),1})
    normalizePrecRecCurve(cdb2r2{cv(i),1})
    normalizePrecRecCurve(cdb2r3{cv(i),1})
    normalizePrecRecCurve(cdb4r2{cv(i),1})
    normalizePrecRecCurve(cdb4r3{cv(i),1})
    
    g = 1  
      
      
      
    % Add a legend
    xyLabSize = 8;
    xyFontSize = 9;
    axeslw = 20;  
    plotLineWidth = 2.5;
    titleSize = 18;
    
    yVal = 0.80;
    ylim([yVal 1]);
    discret = 0.05;
    set(gca, 'YTick', (yVal :discret : 1));
    xlim([0 1]);    

    % set(findobj(gca,'type','line'),'linew',1.4)
    set(gca,{'linew'},{plotLineWidth})
    set(gca, 'YGrid','on');
    set(gca,'FontSize',xyFontSize);
    set(findobj(gca,'Type','text'),'FontSize',axeslw);
    title(titleCell{i}, 'fontsize', titleSize, 'fontweight', 'b');
    xlabel('Recall', 'fontsize', xyLabSize, 'fontweight','b');
    ylabel('Precision', 'fontsize', xyLabSize, 'fontweight','b');
    set(gca,'FontWeight','bold');

end

legFontSize = 13;
leg = legend(legCell, 'Location', 'Best' );

LEG = findobj(leg,'type','text');
set(LEG,'FontSize',legFontSize);

dveps = saveFigureToEPS(fileNameToSaveIms, gcf);

% % Saving the figures.
% fileNameToSaveIms = [imFold imName];
% 
% % Save the precision and recall plot as a png.
% dvpng = saveFigToImage(fileNameToSaveIms, gcf, 'png');
% 
% % Save the precision and recall plot as a fig.
% dvfig = saveFigToImage(fileNameToSaveIms, gcf, 'fig');
% 
% % Save the precision and recall plot as an eps.
% dveps = saveFigureToEPS(fileNameToSaveIms, gcf);

