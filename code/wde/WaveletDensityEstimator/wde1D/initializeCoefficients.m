%--------------------------------------------------------------------------
% Function:    initializeCoefficients
% Description: Initialize coefficents for gradient descent.  Give equal
%              priority to all translations of wavelets within a level.
%              Higher levels have more priority.  
%
% Inputs:
%   startLevel        - starting level for the the father wavelet
%                       (i.e. scaling function).  
%   stopLevel         - last level for mother wavelet scaling.  The start
%                       level is same as the father wavelet's.
%   sampleSupport     - 2x1 vector containing the sample support.
%   wName             - 3 to 4 charater code name of wavelet for density 
%                       approximation.
%   scalingOnly       - flag indicating if we only want to use scaling
%                       functions for the density estimation.
%
% Outputs:
%   coeffs            - Nx1 vector of coefficients for the basis functions.
%                       N depends on the number of levels and translations.
%   coeffsIdx         - Lx2 matrix containing the start and stop index
%                       locations of the coeffients for each level in the
%                       coefficient vector.  L is the number of levels.
%                       For example, the set of coefficients for the
%                       starting level can be obtained from the
%                       coefficients vector as:
%                       coeffs(coeffsIdx(1,1):coeffsIdx(1,2),1)
%
% Usage:
%
% Authors(s):
%   Adrian M. Peter
%
% Reference:
% A. Peter and A. Rangarajan, “Maximum likelihood wavelet density estimation 
% with applications to image and shape matching,” IEEE Trans. Image Proc., 
% vol. 17, no. 4, pp. 458–468, April 2008.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Copyright (C) 2009 Adrian M. Peter (adrian.peter@gmail.com)
%
%     This file is part of the WDE package.
%
%     The source code is provided under the terms of the GNU General 
%     Public License as published by the Free Software Foundation version 2 
%     of the License.
%
%     WDE package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with WDE package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%     USA
%--------------------------------------------------------------------------
function [coeffs coeffsIdx] = initializeCoefficients(startLevel, stopLevel,...
                                                     sampleSupport, wName,...
                                                     scalingOnly, initType, ...
                                                     varargin)
% Get the number of translations for the scaling function of the start
% level.
numTrans = diff(translationRange(sampleSupport, wName, startLevel))+1;

% Determine if we need to count up or down
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end

% Setup the coeffsIdx.  Don't really need this, but leaving in there just
% to be consistent with the original code.
coeffsIdx = [1 numTrans];
if(~scalingOnly)
    for j = startLevel :inc:stopLevel
        % At the start level, we have the same number of wavelet and
        % scaling function coefficients.
        if(j == startLevel)
            numCoeffs = numTrans;
        else
            % Have to readjust number of translations for new level.
            numTrans = diff(translationRange(sampleSupport, wName, j))+1;            
        end        
        coeffsIdx = [coeffsIdx;coeffsIdx(end)+1 coeffsIdx(end)+numTrans];
    end
end
        
switch(lower(initType))
    case 'rand'
        % Assign equal weights to the scaling coefficients.
        c = (1/2^startLevel)*(ones(numTrans,1));
        %coeffsIdx = [1 numTrans];

        % Assign wavelet coefficients
        if(~scalingOnly)
            for j = startLevel :inc:stopLevel
                % At the start level, we have the same number of wavelet and
                % scaling function coefficients.
                if(j == startLevel)
                    cTmp = (1/2^j)*(ones(numTrans,1));
                else
                    % Have to readjust number of translations for new level.
                    numTrans = diff(translationRange(sampleSupport, wName, j))+1;
                    cTmp     = (1/2^j)*(ones(numTrans,1));
                end
                c         = [c;cTmp];
                %coeffsIdx = [coeffsIdx;coeffsIdx(end)+1 coeffsIdx(end)+length(cTmp)];
            end
        end
        % Add some random noise to coeffs to stop the log zero error in nll
        % function.
        c = c + .5*rand(size(c,1),1);
    case 'hist'
        if(isempty(cell2mat(varargin(1))))
            error('Need samps to estimate histogram');
        else
            samps =  cell2mat(varargin(1));
        end
        % Get histogram of the samples and the corresponding sqrt of
        % density value for each sample.        
        if(isempty(cell2mat(varargin(2))))
            % Use Freedman-Diaconis rule to calculate the optimal bin width.
            h = 2*iqr(samps)*length(samps)^(-1/3);
            bins = [min(samps):h:max(samps)+h];
        else
            bins =  cell2mat(varargin(2));
        end
        [binCounts,idx] = histc(samps,bins);
        % Normalize the bins and take sqrt.
        sqrtP         = sqrt(binCounts./sum(binCounts));
        sqrtPEachSamp = sqrtP(idx);
        numSamps      = length(samps);
        % Set up correct basis functions.
        [father, mother] = basisFunctions(wName);
        scalValsSum      = 0;
        mothValsSum      = 0;
        % Translation range for the starting level scaling function.
        scalingTransR    = translationRange(sampleSupport, wName, startLevel);
        scalingShiftVals = [scalingTransR(1):scalingTransR(2)];
        
        % Calculate the coefficient estimates based on the histogram
        for s = 1 : numSamps
            % Compute father value for all scaled and translated samples.
            x         = 2^startLevel*samps(s)- scalingShiftVals;
            scalVals  = 2^(startLevel/2)*father(x);
            % Divide the basis by the sqrt hist.
            scalingBasis = scalVals./sqrtPEachSamp(s);
            
            % Incorporate the mother basis if necessary.
            if(~scalingOnly)
                mothVals = [];
                % Loop over all the levels to evaluate the wavelet basis.
                for j = startLevel :inc:stopLevel
                    transR    = translationRange(sampleSupport, wName, j);
                    shiftVals = [transR(1):transR(2)];
                    x         = 2^j*samps(s)- shiftVals;
                    mothVals  = [mothVals 2^(j/2)*mother(x)];
                end 
                % Multiply by the weights.
                wavBasis = mothVals./sqrtPEachSamp(s);                
            end % if(~scalingOnly)
            
            scalValsSum = scalValsSum + scalingBasis;
            if(~scalingOnly)
                mothValsSum = mothValsSum + wavBasis;
            end
        end % for s = 1 : numSamps
        c = (1/numSamps)*[scalValsSum'];
        if(~scalingOnly)
            c = (1/numSamps)*[scalValsSum';mothValsSum'];
        end        
    otherwise 
        error('Unsupported initialization type!');
end

% Normalize the coefficients so that sum of squares of the coefficients is
% 1.
coeffs = c/norm(c);

