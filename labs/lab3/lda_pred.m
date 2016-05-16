function Labels_pred = lda_pred(X_test, b_hat, c_hat)

% X_test is NxD matrix. Samples are the rows. 
% -------------------------------------------------------------------------

Labels_pred = 0.5 * (sign(b_hat' * X_test' + c_hat )) + 1.5;

