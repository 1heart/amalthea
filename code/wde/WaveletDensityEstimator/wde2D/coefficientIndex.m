%--------------------------------------------------------------------------
% Function:    coefficientIndex
% Description: Initialize coefficents indicies for different levels.  
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
% Outputs:
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
function coeffsIdx = coefficientIndex(startLevel, stopLevel,...
                                      sampleSupport, wName,...
                                      scalingOnly)

% For 2D multires. analysis for each translation pair (k1,k2) we also get
% 3 combinations of the mother and father wavelet. So this will increase
% the number of coefficients by a factor of 3 for each pair translation
% values.  This is only on the wavelet summation not on the scaling.
numBasisPerTransPair = 3;

% Get the number of translations for the scaling function of the start
% level.  For 2D we need to get translations in both x & y directions.
numTransX = diff(translationRange(sampleSupport(1,:), wName, startLevel))+1;
numTransY = diff(translationRange(sampleSupport(2,:), wName, startLevel))+1;

coeffsIdx = [1 numTransX*numTransY];

% Determine if we need to count up or down
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end

% Assign wavelet coefficients
if(~scalingOnly)
    for j = startLevel :inc:stopLevel
        % At the start level, we have the same number of wavelet and
        % scaling function coefficients.
        if(j == startLevel)
            cTmp = (1/2^j)*(ones(numTransX*numTransY*numBasisPerTransPair,1));
        else
            % Have to readjust number of translations for new level.
            numTransX = diff(translationRange(sampleSupport(1,:), wName, j))+1;
            numTransY = diff(translationRange(sampleSupport(2,:), wName, j))+1;
            cTmp      = (1/2^j)*(ones(numTransX*numTransY*numBasisPerTransPair,1));
        end
        coeffsIdx = [coeffsIdx;coeffsIdx(end)+1 coeffsIdx(end)+length(cTmp)];
    end
end