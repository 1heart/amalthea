
%--------------------------------------------------------------------------
% Function:    computeTranslatesForEachDimension
% Description: Calculates the translates based on the sample domain.
%
% Inputs:
%   dim               - sample dimension
%   dims              - total size of the translate lattice
%   indices           - linear index of each position
%   transCel          - translate vectors at each dimension.
%   sample            - the N x D data
%   wavelet           - Name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets.
%   startLevel        - Starting level for the the father wavelet
%                       (i.e. scaling function).  
%   stopLevel         - Last level for mother wavelet scaling. The start
%                       level is same as the father wavelet's.
%   waveletFlag       - If this flag is on then density estimation is done     
%                       with scaling + wavelets. The default is density
%                       estimation with the scaling function only. 
%                       waveletFlag = 1; Wavelet is on. 
%                       waveletFlag = 0; Wavelet is off. 
%   domain            - sample support domain.
%   sampLenf          - sample  length
% Outputs:
%    coeffsCel        - coefficients stored in a cell
%   
% Usage: This function is used to calculate the coefficients for batch
% density estimation.
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [coeffsCel] = computingMultiDCoeffs(dim,dims,indices,transCel,sample,...
                                            wavelet,...
                                            startLevel,...
                                            stopLevel,...
                                            waveletFlag,domain,sampLenf)
                                        
                                        
                                        
% Load the scaling function and wavelet.
load(['waveCommon\' wavelet 'Tables.mat'], 'supp', 'phi', 'psi');

% Creating space to store coefficients and Set all coefficients to zero.
% Initialize the coefficients cell
coefficients = cell((stopLevel - startLevel + 2),2); % Creating coefficients cell.

% compute the coefficients sample by sample with update and return the
% final result
[coefficients] = getheTensorProd(indices,sample,supp,phi,...
                                      startLevel,dim,dims,transCel,domain);
                                                                   
% Compute the ND wavelet coefficients for the density estimation and put
% it in a Cell Array                                 
coeffsCel{1,1} = coefficients./sampLenf;                                
                                  