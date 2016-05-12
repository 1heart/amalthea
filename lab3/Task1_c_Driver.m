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

numColors = 2;
colors = lines(numColors);

f1 = figure; movegui(f1, 'north');

class1IndTest = Labels_pred == 1;
class2IndTest = Labels_pred == 2;
plot(X_test(class1IndTest,1), X_test(class1IndTest, 2), '.', 'MarkerEdgeColor', colors(1,:));
hold on;
plot(X_test(class2IndTest,1), X_test(class2IndTest, 2), '.', 'MarkerEdgeColor', colors(2,:));
hold on;

class1IndTrain = Labels == 1;
class2IndTrain = Labels == 2;

plot(Patterns(class1IndTrain, 1), Patterns(class1IndTrain, 2), 'o', 'MarkerFaceColor', colors(1, :));
plot(Patterns(class2IndTrain, 1), Patterns(class2IndTrain, 2), 'o', 'MarkerFaceColor', colors(2, :));

% Get the indices of labels for the classes in testing.
    % Class 1 label indices testing. 
    % Class 2 label indices testing. 

% Display the testing data with predicted labels in the north. 


% Get the indices of labels for the classes in testing.
    % Class 1 label indices training. 
    % Class 2 label indices training. 

% Display the training data with colored true labels. 

