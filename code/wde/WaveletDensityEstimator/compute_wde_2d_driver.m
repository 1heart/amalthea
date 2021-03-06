diary('multires_2dwde');
% Script to run 2D Wavelet Density
clear; clc; close all;
warning off;
addpath('./waveCommon/');
addpath('./wde2D/');
addpath('../Datasets/');
addpath('../Hypersphere_Code/');
addpath('../Plotting_Code/');
addpath('../RetrievalMetrics_Code/');
addpath('../ShapeCoefficients/');
addpath('../ShapeProcessing_Code/');

% DATASET SETTINGS --------------------------------------------------------
% Brown, MPEG7, MPEG7, SweedishLeaf
DATASET_FOLDER = 'MPEG7'; 
% Brown_2D_ns99, Animal_All, mpeg7Aligned, mpeg7NoAligned
SHAPE_NAME = 'mpeg7Aligned'; 
% Load shape file 
SHAPE_FOLDER = ['../Datasets/', DATASET_FOLDER, '/'];
load([SHAPE_FOLDER, SHAPE_NAME]);
SAVE_FOLD = './saved_results/';

settingsArr = [];

% Haar
settingsArr = [settingsArr wde2DParameters_Test('db1', 4, 4, 1,1)];

% Haar multires
settingsArr = [settingsArr wde2DParameters_Test('db1', 2, 3, 0, 0.5)];

% Sym4
settingsArr = [settingsArr wde2DParameters_Test('sym4', 3, 3, 1, 1)];

% Sym4 multires
settingsArr = [settingsArr wde2DParameters_Test('sym4', 2, 3, 0, 0.5)];

for i = 1:length(settingsArr)
	currWdeSet = settingsArr(i);
	currWdeCell = compute_wde_2d_fun(shapeCell, currWdeSet, 1);
	CURR_SAVE_PATH = [SAVE_FOLD, SHAPE_NAME '_Coeffs_r6_' currWdeSet.wName '_res_'...
        num2str(currWdeSet.startLevel)];
    save(CURR_SAVE_PATH, 'currWdeCell');
end
diary off;
