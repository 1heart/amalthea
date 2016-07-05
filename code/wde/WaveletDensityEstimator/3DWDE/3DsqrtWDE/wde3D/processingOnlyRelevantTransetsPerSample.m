%--------------------------------------------------------------------------
% Function:    accessEachTranslates
% Description: evaluates tensor prodiucts at each lattice translate
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
function  tensorProd = processingOnlyRelevantTransetsPerSample(oneSample,...
                                  startLevel,dim,dims,transCel,domain,...
                                  sampleCount,coefficients,waveletFlag,indices,supp,phi)
                              
  
                                          
% IMPORTANT TO FOLLOW THE COMMENT HERE!!!!!                              
% step1: Use the sample to compute its small support in terms of translates 
      % in the lattice. The lattice of each sample (created by the relevant
      % translets) should be smaller than the big lattice (using all the translates) 
      
% step2: save the the corresponding coordinates of each elt in the small lattice ( for each
       % sample)in the big lattice using linear indexing and ind2sub matlab
       % toolbox function
       

% step 1 and 2 are excecuted in this function
%---computeEachSampleLattice()
       
       
       
% step 3: compute and update the coefficients based on the relevant translates which are related
       % to each sample until all sample are used. The final coefficients vector
       % obtained divided by the total sample is the expectation of the bases
       % function. So instead of useing all the translates at once of compute the coefficients
       % of each sample we basically compute each sample relevant
       % translates and then evaluate the coefficient of the sample based
       % on that specific sample and so we update the coefficint vector
       % until all samples are used.
       
       % step2 is really important in norder to position the coefficients
       % correctly in the big lattice
       %-----updateCoefficientsPerSample()    
       
%--------------------------------------------------------------------------
coefficients = getheTensorProductsPerSample(indices,oneSample,supp,phi,...
 startLevel,dim,dims,transCel,domain,sampleCount,coefficients,waveletFlag);
%--------------------------------------------------------------------------
tensorProd =  coefficients;
