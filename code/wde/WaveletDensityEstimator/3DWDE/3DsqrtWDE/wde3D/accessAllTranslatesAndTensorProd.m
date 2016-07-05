%--------------------------------------------------------------------------
% Function:    accessAllTranslatesAndTensorProd
% Description: evaluates tensor prodiucts using all translates for each
% sample
%
% Inputs:


%   sample            - the N x D data
%   dim               - sample dimension
%   dims              - total size of the translate lattice
%   transCel          - translate vectors at each dimension.
%   indices           - linear index of each position
%   supp              - wavelet support
%   phi               - given scaling basis function
%   startLevel        - Starting level for the the father wavelet
%                       (i.e. scaling function).  
% Outputs:
%    eachIterationTensor        - scaling functions estimated ( tensor products )
%   
% Usage: 
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function  tensorProd = accessAllTranslatesAndTensorProd(sample,wavelet,...
                                                    tr1,tr2,tr3,startLevel)
                             
% create the meshgrid made from all possible translates 
[X, Y, Z] = meshgrid(tr1,tr2,tr3);
X4 = [X(:),Y(:),Z(:)];
t1 = X4(:,1);
t2 = X4(:,2);
t3 = X4(:,3);
% sample per dimension
samp1 = sample(:,1); % each colum
samp2 = sample(:,2); % 
samp3 = sample(:,3);%
                                                        
if strcmp(wavelet,'db1')   % using Haar : special case!
    % coresponding values in the support of the wavelets functions
   [father, mother] = basisFunctions(wavelet);  
    scalEvalX = 2^startLevel*samp1 - t1;
    scalEvalY = 2^startLevel*samp2 - t2;
    scalEvalZ = 2^startLevel*samp3 - t3;
    
    % interpolate the samples   
    phiVect1 = father(scalEvalX); 
    phiVect2 = father(scalEvalY);
    phiVect3 = father(scalEvalZ);  
    tensorProd = (2^(1.5*startLevel))*phiVect1.*phiVect2.*phiVect3;  
    
     return;
end
   
% Load the scaling function and wavelet.  with the suport
% this part is executed if the basis function is not Haar

load(['waveCommon/' wavelet 'Tables.mat'], 'supp', 'phi', 'psi');   
phiVect1 = interpolationFun(samp1,t1,supp,phi,startLevel); 
phiVect2 = interpolationFun(samp2,t2,supp,phi,startLevel); 
phiVect3 = interpolationFun(samp3,t3,supp,phi,startLevel); 

tensorProd = phiVect1.*phiVect2.*phiVect3;
    

clear X Y Z t1 t2 t3 X4

