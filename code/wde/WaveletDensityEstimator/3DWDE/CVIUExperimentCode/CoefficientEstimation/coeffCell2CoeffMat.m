function coeffMat = coeffCell2CoeffMat(coeffCell)

nts = size(coeffCell,1);
% Length of coefficient vector.
cf1 = coeffCell{1,1};
lcfv = numel(cf1(:,1)); % Length of coefficient vector.

% Putting the cofficients into a matrix.
coeffMat = zeros(lcfv, nts);
for i = 1 : nts
    
    % Store the coefficients in a matrix. 
    coeffMat(:,i) = coeffCell{i};    
end  