%--------------------------------------------------------------------------
% Function:    preProcessing
% Description: gets domain of the sample 
%
% Inputs:      
%   sample            - sample data
% Outputs:
%   sample            - Vector of numbers or single sample.   
%   domain            - Domain bounds of the density function.

% Usage: This function is needed for online density estimation to take
%        place.
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [sample,domain]= preProcessing(sample)
minVect = min(sample);
maxVect = max(sample);
minDomain = floor(minVect);
maxDomain = ceil(maxVect);
domain = [minDomain', maxDomain'];

