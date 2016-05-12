% Task 1 (c)
clear; clc; close all;

% Load the training data (userdata.mat). 
load('userdata.mat');

% Load the test data. 
testDataName = 'X_test101.mat';
load(testDataName);

% Train the LDA classifier using the user data. 
[b_hat, c_hat] = lda_train(Patterns, Labels);

% Classify the training data. 
Labels_pred = lda_pred(X_test, b_hat, c_hat);

% Get the indices of labels for the classes in testing.
    % Class 1 label indices testing. 
    % Class 2 label indices testing. 

% Display the testing data with predicted labels in the north. 


% Get the indices of labels for the classes in testing.
    % Class 1 label indices training. 
    % Class 2 label indices training. 

% Display the training data with colored true labels. 

