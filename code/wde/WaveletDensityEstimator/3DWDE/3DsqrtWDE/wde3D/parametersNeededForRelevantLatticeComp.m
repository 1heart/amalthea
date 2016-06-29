function [indices,dim,dims,transCel,domain,str1,sampleCount,coefficients,phiVect,waveletFlag,supp,phi,psi] = parametersNeededForRelevantLatticeComp(tr1,tr2,tr3,wavelet)

%-------------------------------------------------------------------------              
load(['waveCommon\' wavelet 'Tables.mat'], 'supp', 'phi', 'psi'); 
dim = 3;
n1 = length(tr1);
n2 = length(tr2);
n3 = length(tr3);
indices = 1:n1*n2*n3; % linear index
dims =[ n1, n2 n3];   % size of the lattice
transCel{1,1} = tr1;
transCel{2,1} = tr2;
transCel{3,1} = tr3;
domain = rand(dim );% it is unused
waveletFlag = 0;
%
 for i = 1 : dim
    eval(['tr',num2str(i),'= transCel{i,1};']);
 end
 
%tr1;tr2;tr3;
% create vector to hold the indexes
[str1] = createSrings(dim,'idx');

% Initialize the count of the sample
sampleCount = [];

% Initialize the size of the coefficients
coefficients = zeros(1,length(indices)); % 
phiVect = zeros(1,length(indices)); %
%--------------------------------------------------------------------------