function [A_hat, b_hat, c_hat] = qda_train(X, labels)

% X has the samples as rows, so is NxD. 
% Labels is a vector holding the corresponding class labels (column vector)
% -------------------------------------------------------------------------

[n d] = size(X);

uniqueL = unique(labels);
numL = length(uniqueL);

X_i = cell(numL, 1);
means = cell(numL, 1);
p = cell(numL, 1);
C_i = cell(numL, 1);

for i = 1:numL
  X_i{i} = X(labels == uniqueL(i), :);
  means{i} = mean(X_i{i});
  p{i} = sum(labels == uniqueL(i)) / n;
  C_i{i} = cov(X_i{i});
end

invC1 = inv(C_i{1});
invC2 = inv(C_i{2});
A_hat = 0.5 * (invC1 - invC2);
b_hat = invC1 * means{1}' - invC2 * means{2}';
c_hat = log(p{1} / p{2}) + 0.5 * (means{1} * invC1 * means{1}' - means{2} * invC2 * means{2}') + 0.5 * log(det(C_i{i}) / det(C_i{i}));




% Get the number of samples and dimensions in X using size. Do not use
% the length function because it is meant for vectors. Read to
% documentation of length to familiarize yourselves with this. 


% Get the unique values of the labels using the unique function.


% Get the number of unique labels. 


% Create a cell to store the index vectors for the labels. Create a column
% cell with the number of rows equal to the number of unique values of the
% labels. Hint: use the numel function to determine the number of unique
% labels once you have the labels vector. 


% Create a cell to store the covariance matrices of each class. 


% Create a vector to store the proportion values p of the samples. 


% Create a cell to store the mean vectors. Size is number of unique labels
% x 1.


% Loop through the unique labels and store the indices or index vector into
% the corresponding cell row. If you use the find function it will return 
% the exact indices into the labels vector. If you use logical indexing 
% such as "==" symbol (ignore the quotation marks) you get a binary vector
% the same length as the labels vector with 1's indicating the positions of 
% the current label. 
%for i = 1 : numUnqLabels
    
    % Current label. 
    
    
    % Get the indices corresponding to the current label. 
    
%end

% Loop through the number of classes (number of unique labels) and compute
% p_i and C_i for each class. To get p, if you used the find function to 
% find your unique labels, then you have to use the length or numel 
% function to determine the number of samples with that labels. If you used
% logical indexing then you can simply sum the index vector to get the
% labels. 
%for i = 1 : numUnqLabels
    
    % Get the data corresponding to label i. 
    
    
    % Compute the covariance matrix of the data and store.
    
    
    % Compute the proportion values for the ith data. 
    
    
    % Compute the mean of the data corresponding to the ith label and
    % store the mean vector. Make sure to store as a column vector. 
    
%end



% Compute A_hat.


% Compute b_hat 

% Compute c 
    
    
