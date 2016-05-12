% Task 2 (c)
clear; clc; close all;

% Load the training data (userdata.mat). 
load('userdata.mat');

% Load the test data. 
testDataName = 'X_test101.mat';
load(testDataName);

% Train the LDA classifier using the user data. 
[A_hat, b_hat, c_hat] = qda_train(Patterns, Labels);

% Classify the training data. 
Labels_pred = qda_pred(X_test, A_hat, b_hat, c_hat);


f1 = figure; movegui(f1,'north');
% Display the testing data with predicted labels on the top. 

% Get class labels from the predicted test data.

% Display the training data to reflect the true colors. 


