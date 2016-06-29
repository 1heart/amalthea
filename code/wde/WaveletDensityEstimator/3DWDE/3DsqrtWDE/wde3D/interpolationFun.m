
%--------------------------------------------------------------------------
% Function:    interpolationFun
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
function phiVect = interpolationFun(sample,eachTranslateVect,supp,phi,startLevel)

%for j = 1:length(eachTranslateVect)
scalEval = 2^startLevel*sample - eachTranslateVect;
% Reshape the above matrix into a column vector.
scalEval = scalEval(:); 
% Performing interpolation to find the value of the sample evaluated at the
% wavelet. 
intpScalSamp = 2^(startLevel/2)*interp1(supp,phi,scalEval,'v5cubic');
% Setting all values outside the support to zero.
intpScalSamp(isnan(intpScalSamp)) = 0;
% Reshape back to a matrix of size(sample x k).
%intpScalSamp = reshape(intpScalSamp, numSamps, numScalCoeff);
phiVect = intpScalSamp;
%end