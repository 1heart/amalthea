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



% Display the testing data with predicted labels on the top. 

% Get class labels from the predicted test data.

% Display the training data to reflect the true colors. 


