
%--------------------------------------------------------------------------
% Function:    getheTensorProd
% Description: Calculates the basis functions.
%
% Inputs:
%   indices           - linear index of each position
%   sample            - the N x D data
%   supp              - the sample support
%   phi               - scaling basis function
%   startLevel        - Starting level for the the father wavelet
%                       (i.e. scaling function).
%   dim               - sample dimension
%   dims              - total size of the translate lattice
%   transCel          - translate vectors at each dimension.


%   wavelet           - Name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets. 
%   domain            - sample support domain.
% Outputs:
%    coefficients     - sample coefficients after update
%   
% Usage: This function is used to calculate the coefficients for batch
% density estimation.
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------

function[ coefficients ] = getheTensorProd( indices,sample,...
                               supp,phi,startLevel,...
                               dim,dims,transCel,domain )

waveletFlag = 0;
 for i = 1 : dim
    eval(['tr',num2str(i),'= transCel{i,1};']);
 end

% create vector to hold the indexes
[str1] = createSrings(dim,'idx');

% Initialize the count of the sample
sampleCount = [];

% Initialize the size of the coefficients
coefficients = zeros(1,length(indices));

% Access the sample, one a the time
for j = 1:length(sample)
    % each row vector of the sample
    samp = sample(j,:);
    sampleCount = [sampleCount;samp];
    numbSamp = size(sampleCount,1)
    
    %1 select the relvant translates neededed for reconstructing the
    %sample!  EXPENSIVE PROCESS!!!! TOO SLOW!
    
    [ coefficients,...
        indexofRelevantTrans,...
        linearIndOfRelevantTrans,...
        sampleLattice,...
        remeBerBigTrans ] = accessLatticePointsOnline( dim,...
                               dims,indices,...
                               transCel,samp,...
                               startLevel,...
                               waveletFlag,...
                               coefficients,...
                               supp,phi );
    
    %2 checking if translates matches and retain inedxes
     %CheckUniqIndexces = [ sampleLattice,remeBerBigTrans,linearIndOfRelevantTrans' ];
    
    % the corresponding coefficients to the sublattice of the one sample
    [ coeffMatrixForm,correspCoeff ] = selectRelevantCoefficients(coefficients,...
              indexofRelevantTrans,linearIndOfRelevantTrans,sampleLattice);   
    
  
    %3 update the coefficients based on relevant translates
    [ coefficients ] = estimatingCoeffs( samp,...
                                            domain,...
                                            startLevel,...
                                            coefficients,...
                                            waveletFlag,...
                                            sampleLattice,...
                                            indexofRelevantTrans,...
                                            linearIndOfRelevantTrans,...
                                            correspCoeff,...
                                            supp,phi );
    %
    %
    %
end