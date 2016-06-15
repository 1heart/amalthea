% -------------------------------------------------------------------------
% Script: datasetShapesTIP
% Date: Sunday 23rd March, 2014.
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver displays and saves the images from the datasets
%              used in the TIP paper.
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
 clc; close all;
 cd('C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\DataSetup');
 
 
% clear;
% % Load the data.
% sfnSH11 = '.\PamiShapeFiles\SHREC11.mat';
% load(sfnSH11);
% sv11 = shapeData; clear shapeData;
% 
% sfnSH12 = '.\ICPRShapeFiles\SHREC12ICPR.mat';
% load(sfnSH12);
% sv12 = shapeData; clear shapeData;
% 
% sfnSH10 = '.\PamiShapeFiles\SHREC10Final.mat';
% load(sfnSH10);
% sv10 = shapeData; clear shapeData;
% 
sfnSHCos = '.\ICPRShapeFiles\COSEG_ICPR.mat';
load(sfnSHCos);
svCos = shapeData; clear shapeData;
imFold = 'C:\Users\mmoyou\Google Drive\Journal Paper Research\Figures\';

%% SHREC10.

% sn = 10;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(107,0);
% zoom(2.1);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_11' '.eps' ],'-depsc');
% 
% sn = 11;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(73,-16);
% zoom(2.1);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_12' '.eps' ],'-depsc');
% 
% sn = 23;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(71,-6);
% zoom(2.1);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_21' '.eps' ],'-depsc');
% 
% sn = 26;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(102,2);
% zoom(2);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_22' '.eps' ],'-depsc');
% 
% sn = 81;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(-17,10);
% zoom(4.5);
% light('Position',[ -1 -0.5 0],'Style','infinite');
% print([ imFold 'SH10_31' '.eps' ],'-depsc');
% 
% sn = 89;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(66,-2);
% zoom(3.2);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_32' '.eps' ],'-depsc');
% 
% sn = 136;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(1,90);
% zoom(1.2);
% light('Position',[ 1 0.5 0],'Style','infinite');
% print([ imFold 'SH10_41' '.eps' ],'-depsc');
% 
% sn = 140;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(-75,6);
% zoom(31);
% light('Position',[ -1 -0.5 0],'Style','infinite');
% print([ imFold 'SH10_42' '.eps' ],'-depsc');
% 
% sn = 163;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(114,-44);
% zoom(2.3);
% light('Position',[ 1 0.5 -10],'Style','infinite');
% print([ imFold 'SH10_51' '.eps' ],'-depsc');
% 
% sn = 165;
% col = [1 0.2 0];
% h = showMeshwCol(sv10{sn,1},sv10{sn,2},col);
% view(61,-4);
% zoom(2.1);
% light('Position',[ 1 -0.5 0],'Style','infinite');
% print([ imFold 'SH10_52' '.eps' ],'-depsc');






% %% SHREC 11.
% sn = 1;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(-102,90);
% zoom(1.4);
% light('Position',[ -1 0.5 0],'Style','infinite');
% % print([ imFold 'SH11_11' '.eps' ],'-depsc');
% outfilename = [ imFold 'SH11_11Test' '.eps'];
% printpdf(gcf,outfilename);
% 
% sn = 7;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(-282,90);
% zoom(1.4);
% light('Position',[ -1 0.5 0],'Style','infinite');
% % print([ imFold 'SH11_12' '.eps' ],'-depsc');
% outfilename = [ imFold 'SH11_12Test' '.eps'];
% printpdf(gcf,outfilename);

% sn = 104;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(-15,90);
% zoom(1.4);
% print([ imFold 'SH11_21' '.eps' ],'-depsc');
% 
% sn = 112;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(-20,90);
% zoom(1.5);
% print([ imFold 'SH11_22' '.eps' ],'-depsc');
% 
% sn = 183;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(7,90);
% zoom(1.4);
% light('Position',[ -1 0.5 0],'Style','infinite');
% print([ imFold 'SH11_31' '.eps' ],'-depsc');
% 
% sn = 186;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(7,90);
% zoom(1.4);
% light('Position',[ -1 0.5 0],'Style','infinite');
% print([ imFold 'SH11_32' '.eps' ],'-depsc');
% 
% sn = 543;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(153,90);
% zoom(1.6);
% light('Position',[ -1 0.5 0],'Style','infinite');
% print([ imFold 'SH11_41' '.eps' ],'-depsc');
% 
% sn = 548;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% view(61,-86);
% zoom(1.8);
% light('Position',[ -1 -0.5 -2],'Style','infinite');
% print([ imFold 'SH11_42' '.eps' ],'-depsc');
% 
% sn = 485;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% % view(61,-86);
% zoom(1);
% light('Position',[ -1 -0.5 -2],'Style','infinite');
% print([ imFold 'SH11_51' '.eps' ],'-depsc');
% % 
% sn = 493;
% col = [0.4 1 1];
% h = showMeshwCol(sv11{sn,1},sv11{sn,2},col);
% zoom(1);
% light('Position',[ -1 -0.5 -2],'Style','infinite');
% print([ imFold 'SH11_52' '.eps' ],'-depsc');

% %% SHREC 12.
% 
% sn = 38;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_11' '.eps' ],'-depsc');
% 
% sn = 34;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_12' '.eps' ],'-depsc');
% 
% sn = 112;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% view(4,0);
% zoom(1.2);
% print([ imFold 'SH12_21' '.eps' ],'-depsc');
% 
% sn = 113;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_22' '.eps' ],'-depsc');
% 
% sn = 52;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_31' '.eps' ],'-depsc');
% 
% sn = 57;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_32' '.eps' ],'-depsc');
% 
% sn = 67;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_41' '.eps' ],'-depsc');
% 
% sn = 65;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_42' '.eps' ],'-depsc');
% 
% sn = 82;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_51' '.eps' ],'-depsc');
% 
% sn = 83;
% col = [0.4 1 0.2];
% h = showMeshwCol(sv12{sn,1},sv12{sn,2},col);
% print([ imFold 'SH12_52' '.eps' ],'-depsc');
%% SHAPE COSEG
% sn = 26;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([ imFold 'COS11' '.eps' ],'-depsc');
% 
% sn = 27;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS12' '.eps' ],'-depsc');
% 
% sn = 40;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS21' '.eps' ],'-depsc');
% 
% sn = 44;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS22' '.eps' ],'-depsc');
% 
% sn = 51;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS31' '.eps' ],'-depsc');
% 
sn = 52;
col = [1 0 1];
h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
print([imFold 'COS32' '.eps' ],'-depsc');
% 
% sn = 62;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS41' '.eps' ],'-depsc');
% 
% sn = 63;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS42' '.eps' ],'-depsc');
% 
% sn = 77;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS51' '.eps' ],'-depsc');
% 
% sn = 81;
% col = [1 0 1];
% h = showMeshwCol(svCos{sn,1},svCos{sn,2},col);
% print([imFold 'COS52' '.eps' ],'-depsc');


% outfilename = [ imFold 'TEST' '.eps'];
% printpdf(gcf,outfilename);
% 
