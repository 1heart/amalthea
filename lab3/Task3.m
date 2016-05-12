% Task 3 
clear; clc; close all;

%% Part (a).

% Load the iris data.
dataName = 'iris.data.shuffled.mat';
load(dataName);

% Get the class label indices. 
    % Indices of class 1.
    % Indices of class 2.
    % Indices of class 3.

% Plot all the iris data with colors. 
f1 = figure; movegui(f1,'north');
hold on; 


%% Part (b).

% Separate the class data and class labels.


% Specify the number of training and testing samples in each class. 

% Get the x and y bounds on the new data to create data to plot the 
% decision boundary. Remember you need to use linspace and meshgrid to
% generate the gridpoints. 


% Number of points to generate on each axis in x.

% Number of points to generate on each axis in y.


% Use linspace to generate points between the x bounds. 

% Use linspace to generate points between the y bounds. 


% Use meshgrid to generate the grid points. 


% Vectorize the X and Y from meshgrid to get Nx2 grid data. 

% Train the classifier with the training data. You will have to get the
% labels of the points for the classes and create a new labels vector. 

% Train using LDA.


% Train using QDA.                              
                              
% Classify on the grid data just generated using LDA.
Labels_pred_lda = lda_pred(gridData, b_hat_lda, c_hat_lda);

% Classify on the grid data just generated using QDA.
Labels_pred_qda = qda_pred(gridData, A_hat, b_hat_qda, c_hat_qda);

% Plot the lda decision boundary. 
% Create and move the figure to the east.
f2 = figure; movegui(f2,'east');

% Plot the grid data with the colors according to the classfication labels.
% Display the testing data with predicted labels on the top. 

% Get the labels of the points corresponding to class 1 and class 2 from lda.
% Remember class 1 refers to class 2 in the original data and 2 to class 3.


% Plot the grid data and color according to the labels from lda. 

% Plot the true training data on top of this plot. 

% Create and move the figure to the west.
f3 = figure; movegui(f3,'west');

% Get the labels of the points corresponding to class 1 and class 2 from lda.
% Remember class 1 refers to class 2 in the original data and 2 to class 3.
% Plot the grid data and color according to the labels from lda. 
hold on; 
% Plot the true training data on top of this plot. 

%% Task (c)

% Create the hold out data and labels. 
           

% Predict the labels of the hold out set using LDA.
Labels_pred_lda_ho = lda_pred(holdOutData, b_hat_lda, c_hat_lda);

% Classify on the grid data just generated using QDA.
Labels_pred_qda_ho = qda_pred(holdOutData, A_hat, b_hat_qda, c_hat_qda);

% Compute lda and qda accuracy. Number of correct labels / numTotalLabels.

disp(['LDA accuracy is ' num2str(ldaAcc*100), '%']);
disp(['QDA accuracy is ' num2str(qdaAcc*100), '%']);
