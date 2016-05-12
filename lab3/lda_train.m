function [b_hat, c_hat] = lda_train(X, labels)

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
C = zeros(d, 2);

for i = 1:numL
  X_i{i} = X(labels == uniqueL(i), :);
  means{i} = mean(X_i{i});
  p{i} = sum(labels == uniqueL(i)) / n;
  C_i{i} = cov(X_i{i});
  C = C + (p{i} * C_i{i});
end

invC = inv(C);
b_hat = invC * (means{1}' - means{2}');
c_hat = log(p{1} / p{2}) + 0.5 * (means{1} * invC * means{1}' - means{2} * invC * means{2}');
