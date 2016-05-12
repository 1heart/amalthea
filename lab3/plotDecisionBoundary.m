function plotDecisionBoundary(gridPts, predLabels)

% Generate a figure before using this function.
% Use the generateGridPts function to get gridPts.
% predLabels are the labels of the classified grid points. 

% Get the labels of the points corresponding to class 1 and class 2 from lda.
% Remember class 1 refers to class 2 in the original data and 2 to class 3.
class1IndGridLda = predLabels == 1;
class2IndGridLda = predLabels == 2;

% Plot the grid data and color according to the labels from lda. 
hold on; 
plot(gridPts(class1IndGridLda,1), gridPts(class1IndGridLda,2), 'r.');
plot(gridPts(class2IndGridLda,1), gridPts(class2IndGridLda,2), 'b.');