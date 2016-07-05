function [transCel,phiVect,supp,phi,psi] = relevantLatticeComputInitialization(tr1,tr2,tr3,wavelet)

%--------------------------------------------------------------------------              
load(['waveCommon\' wavelet 'Tables.mat'], 'supp', 'phi', 'psi'); 
%dim = 3;
n1 = length(tr1);
n2 = length(tr2);
n3 = length(tr3);
indices = 1:n1*n2*n3; % linear index
%dims =[ n1, n2 n3];   % size of the lattice
transCel{1,1} = tr1;
transCel{2,1} = tr2;
transCel{3,1} = tr3;
phiVect = zeros(1,length(indices)); 
%--------------------------------------------------------------------------