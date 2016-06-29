function scalVals = updateTheScalingVector(sample,smaLlatticelinIndx,translatesPerSamp,phiVect,startLevel,wavelet)

t1 = translatesPerSamp(:,1);
t2 = translatesPerSamp(:,2);
t3 = translatesPerSamp(:,3);

samp1 = sample(1);
samp2 = sample(2);
samp3 = sample(3);

load(['waveCommon\' wavelet 'Tables.mat'], 'supp', 'phi', 'psi'); 

phiVect1 = interpolationFun(samp1,t1,supp,phi,startLevel); 
phiVect2 = interpolationFun(samp2,t2,supp,phi,startLevel); 
phiVect3 = interpolationFun(samp3,t3,supp,phi,startLevel); 


updCoeff = phiVect1.*phiVect2.*phiVect3;

zeroTempCoeffVect = zeros(1,length(phiVect));
% Updating the coefficients 
%allCoeffUpd(linearIndOfRelevantTran) = updCoeff ;
zeroTempCoeffVect(smaLlatticelinIndx) = updCoeff ;
scalVals = zeroTempCoeffVect;

%phiVect = phiVect + zeroTempCoeffVect;

%phiVect = phiVect + tensorProd;



% 
% updCoeff = (2^(startLevel / 2)^dim)*tensorProdVect';
% allCoeffUpd = scalCoeff;