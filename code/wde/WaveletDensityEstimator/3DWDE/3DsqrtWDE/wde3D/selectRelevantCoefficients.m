
%--------------------------------------------------------------------------
%  Function:    selectRelevantCoefficients
% Description: Calculates the translates based on the sample domain.
%
% Inputs:
%   coefficients               - sample coefficients

%   indexofRelevantTrans       - relevant translates indexes
 
%   linearIndOfRelevantTran    - linear indexing of the translate in the
%                              latice
%    sampleLattice             - sample lattice 
% 
% Outputs:
%   correspCoeff               - coefficients updated 
%   M                          - matrix representation of the coefficients
%                                updated
%   
% Usage: This function is used to calculate the coefficients for batch
% density estimation.
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [M,correspCoeff]= selectRelevantCoefficients(coefficients,indexofRelevantTrans,linearIndOfRelevantTran,sampleLattice)

scalCoeff = coefficients; 
dim = size(sampleLattice,2);
[str11] = createSrings(dim,'idx'); % the position of the small lattice cofficients 

for j = 1: length(sampleLattice)
    indexx = indexofRelevantTrans{j,1}; % N by dim matrix
     for i = 1: dim
    
         eval(['idx',num2str(i),' = indexx(i);'])
     end
    linearInd = linearIndOfRelevantTran(j);
    eval(['M','(',str11,')= scalCoeff(linearInd);']); % coefficients on the small lattice from the small translate
    correspCoeff(j) = scalCoeff(linearInd);
end
