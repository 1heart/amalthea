% Task 4 

clear; clc; close all;

%% Part (a).

% Load the iris data.
dataName = 'non-linearDataSet_Task4';
load(dataName);

% Gamma value. 
gamma = 0.03; 

% Number of total samples. 
numTotSamps = size(Patterns,1);

% Get the class indices. 
class1Ind = Labels == 1;
class2Ind = Labels == 2;

%% Part (b).

% Separate the class data and class labels.
c1 = Patterns(class1Ind,:); % Class 1 data. 
c2 = Patterns(class2Ind,:); % Class 2 data. 
class1Labels = Labels(class1Ind); % Class 1 labels. 
class2Labels = Labels(class2Ind); % Class 2 labels.

% Choose a point from class 1 to be p1 and a point from class 2 to be p2. 

% Subtract p1 and p2 from class 1 data. 

% Subtract p1 and p2 from class 2 data. 

% Transform the data with p1. 

% Generate grid points with -8 < x < 10, -10 < y < 10, and numPoints = 100

% Train the LDA classifier using the transformed test data. 

% Transform the grid data with the Gaussian radial basis function. 

% Classify the grid data so the decision boundary can be plotted.  

% Plot the data in data in the original space with colors along with the 
% decision boundary back in the original space. 

% Generate grid points with 0 < x < 1, 0 < y < 1, and numPoints = 100

% Classify the grid data so the decision boundary can be plotted.  

% Plot the data in Patterns with colors. 
