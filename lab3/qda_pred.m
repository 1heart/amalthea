function Labels_pred = qda_pred(X_test, A_hat, b_hat, c_hat)

% X_test is NxD matrix. Samples are the rows. 
% -------------------------------------------------------------------------

val = diag(X_test * A_hat * X_test');

Labels_pred = 0.5 * (sign(val' + b_hat' * X_test' + c_hat )) + 1.5;
