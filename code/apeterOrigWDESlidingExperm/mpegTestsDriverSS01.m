%--------------------------------------------------------------------------
% Script:      wdeShapeMatchDriver
% Description: Wavelet density estimation (WDE) based shape matching.
%              This driver file is used to perform matching using wavelet
%              density representation of point set shapes.
% 
%
% Authors(s):
%   Adrian M. Peter and Anand Rangarajan
%--------------------------------------------------------------------------

close all; clc;
clear; 
% Location of wavelet functions for basis center calculations.
% path('../../../Papers/WDE/waveCommon/',path);
% path('../.',path);
addpath('~/amalthea/code/mark/Wasserstein/WaveletDensityEstimator/waveCommon');
addpath('~/amalthea/code/linassgn/linassgn_old');
% All of our shape categories.
shapeCat =  {'apple';'bat';'beetle';'bell';'bird';'bone';...
             'bottle';'brick';'butterfly';'camel';'car';'carriage';...
             'cattle';'cellular_phone';'chicken';'children';'chopper';...
             'classic';'comma';'crown';'cup';'deer';'device0';...
             'device1';'device2';'device3';'device4';'device5';...
             'device6';'device7';'device8';'device9';'dog';...
             'elephant';'face';'fish';'flatfish';'fly';'fork';...
             'fountain';'frog';'glas';'guitar';'hammer';'hat';...
             'hcircle';'heart';'horse';'horseshoe';'jar';'key';...
             'lizzard';'lmfish';'misk';'octopus';'pencil';...
             'personal_car';'pocket';'rat';'ray';'sea_snake';...
             'shoe';'spoon';'spring';'stef';'teddy';'tree';...
             'truck';'turtle';'watch'};
% Get the training indices. Randomly chosen 10% of total data.
%load mpegTrainsetIndices;
numShapes    = 1400;
shapesPerCat = 20;
shapeNames   = cell(numShapes,1);
startShape   = 1;
endShape     = 60;
subsetID     = 'SS01';
testID       = ['mpeg' subsetID 'SingLev'];
inputFileName  = ['costMatrix' subsetID '.cm'];
outputFileName = ['assignments' subsetID '.txt'];

for c = 1:length(shapeCat)
    for s = 1 : shapesPerCat
        if(s < 10)
            postFix = ['0' num2str(s)];
        else
            postFix = num2str(s);
        end
        shapeNames{(c-1)*shapesPerCat+s} = [shapeCat{c} '-' postFix];
    end
end    
numShapes  = length(shapeNames);

% Used to designate where the input shapes' MAT files are located as well
% as tacking on any other prefix codes in front of the shape name in the
% filename.
namePrefix   = ['./mpeg7ShapesDBSL1/'];

% Assign any postfix characters that come after the shape name in the MAT
% filenames.
wName        = 'db1';
namePostfix  = ['_' wName '_startLev_1'];

% Designates directory to write output MAT files.
outputDir    = ['./mpegResults/'];

% Matching parameters
lambda = 2250;  % Weights importance of distance in linear assignment.
% Remove '.' from lambda for creating unique file name.
lamS = num2str(lambda,'%.3e');
lamS(findstr(lamS,'.'))='_';

% Match shapes.
t0          = clock;  
eval(['[matchLA' subsetID ' matchEU' subsetID ' match' subsetID ' matchDT' subsetID '] = mpegWdeShapeMatch(shapeNames, namePrefix, namePostfix,'...
                                            'lambda, outputDir, testID, startShape, endShape, inputFileName, outputFileName);']);
sec = etime(clock,t0);
if(sec <= 60)
    disp(['Program execution took: ' num2str(sec) ' seconds.'])
elseif((sec > 60) && (sec <= 3600))
    disp(['Program execution took: ' num2str(sec/60) ' minutes.'])
else
    disp(['Program execution took: ' num2str(sec/3600) ' hours.'])
end

% Save
if(isdir(outputDir))
    save([outputDir testID namePostfix '_lambda_' lamS '.mat']);
else
    mkdir(outputDir)
    save([outputDir testID namePostfix '_lambda_' lamS '.mat']);
end

% View Results.
% load mpegTrainsetMatchLables;
% mpegShapeMatchViewResults([outputDir testID namePostfix '_lambda_' lamS '.mat'],0,mpegTrainingLables);


