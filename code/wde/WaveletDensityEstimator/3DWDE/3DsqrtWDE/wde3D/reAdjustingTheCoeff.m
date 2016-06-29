
%--------------------------------------------------------------------------
%  Function:    reAdjustingTheCoeff
% Description:  re-adjust the size of the coefficients 
%
% Inputs:
%   allCoeffUpd                - sample coefficients

%   indexofRelevantTrans       - relevant translates indexes
 
%   linearIndOfRelevantTran    - linear indexing of the translate in the
%                                latice
%    updCoeff                  - sample lattice 
%    dim                       - sample dimesion
%    scalCoeff                 -  scaling coefficients
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
function [ Matr, coefficients ] = reAdjustingTheCoeff(allCoeffUpd,...
                                  indexofRelevantTrans,...
                                  linearIndOfRelevantTran,...
                                  updCoeff,dim,scalCoeff)
% create variables to hold the indexes
[str11] = createSrings(dim,'idx');
%
for j = 1: length(updCoeff)
    indexx = indexofRelevantTrans{j,1};%3D position based on the big matrix
     for i = 1: dim
         eval(['idx',num2str(i),' = indexx(i);'])
     end
     
     % Acess the coefficient values using Lattice indexing
    linearInd = linearIndOfRelevantTran(j); % linear position based on the big matrix
    eval(['Matr','(',str11,') = updCoeff(j);']);
end

% create a zero vector of size 
zeroTempCoeffVect = zeros(1,length(allCoeffUpd));
% Updating the coefficients 
%allCoeffUpd(linearIndOfRelevantTran) = updCoeff ;
zeroTempCoeffVect(linearIndOfRelevantTran) = updCoeff ;
coefficients = allCoeffUpd + zeroTempCoeffVect;
