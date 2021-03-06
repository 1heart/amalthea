%--------------------------------------------------------------------------
% Function:    initializeCoefficients
% Description: Initialize coefficents for gradient descent.  Give equal
%              priority to all translations of wavelets within a level.
%              Higher levels have more priority.
%
% Inputs:
%   samps             - Nx1 vector of 1D samples to use for density
%                       estimation.
%   startLevel        - starting level for the the father wavelet
%                       (i.e. scaling function).
%   stopLevel         - last level for mother wavelet scaling.  The start
%                       level is same as the father wavelet's.
%   sampleSupport     - 2x1 vector containing the sample support.
%   wName             - 3 to 4 charater code name of wavelet for density
%                       approximation.
%   scalingOnly       - flag indicating if we only want to use scaling
%                       functions for the density estimation.
%   initType          - Type of initialization:
%                       priority - weights coarser level coefficients
%                                  more.
%                       eig - solves eigen value problem for by treating
%                             ml as arithmetic mean. (NOT WORKING)
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
%                       NOTE: This will be (L+1)x2 whenever we use more
%                             than just scaling coefficients.
%
% Usage:
%
% Authors(s):
%   Adrian M. Peter
%
% Reference:
% A. Peter and A. Rangarajan, �Maximum likelihood wavelet density estimation
% with applications to image and shape matching,� IEEE Trans. Image Proc.,
% vol. 17, no. 4, pp. 458�468, April 2008.
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
function [coeffs, coeffsIdx, scalValsPerPoint, waveletValsPerPoint] = initializeCoefficients(samps, startLevel, stopLevel,...
    sampleSupport, wName,...
    scalingOnly, initType, varargin)

% Calculate coefficients index
coeffsIdx = coefficientIndex(startLevel, stopLevel,...
    sampleSupport, wName,...
    scalingOnly);

% The only working version for histogram
switch(lower(initType{1}))
    case 'hist'
        
        % Determine if we need to increment up or down
        if(startLevel <= stopLevel)
            inc = 1;
        else
            inc = -1;
        end
        
        % Error checking and defaults
        if(isempty(cell2mat(varargin(1))))
            error('Need samps to estimate histogram');
        else
            samps =  cell2mat(varargin(1));
        end
        
        % Calculate histogram of samples and corresponding sqrt of
        % density value for each sample
        if(isempty(cell2mat(varargin(2))))
            % Use Freedman-Diaconis rule to calculate the optimal bin width.
            h1 = 2*iqr(samps(:,1))*length(samps(:,1))^(-1/3);
            h2 = 2*iqr(samps(:,2))*length(samps(:,2))^(-1/3);
            h  = max(h1,h2);
            bins{1} = min(samps(:,1)):h:max(samps(:,1))+h;
            bins{2} = min(samps(:,2)):h:max(samps(:,2))+h;
        else
            bins =  cell2mat(varargin(2));
        end
        
        % Normalize the bins and take sqrt
        [binCounts,idx] = hist3c(samps,bins);
        sqrtP = sqrt(binCounts./sum(binCounts(:)));
        sqrtPEachSamp = sqrtP(sub2ind(size(sqrtP),idx(:,1),idx(:,2)));
        numSamps      = length(samps);
        
        % Translation range for starting level scaling function
        scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
        scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
        scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
        scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];
        
        % Set up basis functions
        [father, mother] = basisFunctions(wName);
        waveSupp = waveSupport(wName);
        
        % Set up scaling basis grid for each translate
        numXTranslations = length(scalingShiftValsX);
        numYTranslations = length(scalingShiftValsY);
        numTranslations = numXTranslations * numYTranslations;
        
        % OPTIMIZATION FOUR: Single loop along translations
        % Gives back new sample points (x,y) along each translate
        x = bsxfun(@minus, (2^startLevel)*samps(:,1), scalingShiftValsX);
        y = bsxfun(@minus, (2^startLevel)*samps(:,2), scalingShiftValsY);
        
        % For each translate, sample values (x,y) that live under wavelet's support --> 1
        valid_x = (x >= waveSupp(1) & x <= waveSupp(2));
        valid_y = (y >= waveSupp(1) & y <= waveSupp(2));
        
        scalValsPerPoint = zeros(numSamps,numTranslations);
        
        % Loop along translations in x
        for i = 1 : numXTranslations
            
            % Find where points x and y exist together or intersect --> 1
            intersections = bsxfun(@times, valid_x(:,i), valid_y);
            
            % Sample indices are represented by rows.
            % Relevant y translations are represented by columns
            [sampleIndex, translateIndex] = find(intersections == 1);
            
            % Calculate father wavelet for relevant points that fall under current x translation
            x_at_translate = x(sampleIndex,i);
            father_x = father(x_at_translate);
            
            % Calculate father wavelet for relevant points that fall under all y translations
            y_at_translate = y(logical(intersections));
            father_y = father(y_at_translate);
            
            % Calculate the father wavelet for all relevant points that fall under current translations
            fatherWav = bsxfun(@times, 2^startLevel * father_x, father_y);
            
            % Save father wavelet values
            newyTranlateIndex = translateIndex + (i-1) * numXTranslations;
            linearIndex = sub2ind(size(scalValsPerPoint), sampleIndex, newyTranlateIndex);
            scalValsPerPoint(linearIndex) = fatherWav;
            
        end % for i = 1 : numXTranslations
        
        % Calculate scaling coefficients
        scalVals = bsxfun(@rdivide, scalValsPerPoint, sqrtPEachSamp);
        scalingBasisGrid = sum(scalVals,1);
        scalingBasisGrid = scalingBasisGrid';
        basisGrid = scalingBasisGrid;
        
        % MULTIRES COMPUTATION --------------------------------------------
        waveletValsPerPoint = [];
        if(~scalingOnly)
            
            % Increase resolution levels
            for j = startLevel:inc:stopLevel
                % Translation range for resolution levels wavelet function
                waveletTransRX    = translationRange(sampleSupport(1,:), wName, j);
                waveletShiftValsX = [waveletTransRX(1):waveletTransRX(2)];
                waveletTransRY    = translationRange(sampleSupport(2,:), wName, j);
                waveletShiftValsY = [waveletTransRY(1):waveletTransRY(2)];
                
                % Set up wavelet basis grid for each translate
                numXTranslations_multires = length(waveletShiftValsX);
                numYTranslations_multires = length(waveletShiftValsY);
                numTranslations_multires = numXTranslations_multires * numYTranslations_multires;
                
                % Gives back new sample points (x,y) along each translate 
                x = bsxfun(@minus, (2^j)*samps(:,1), waveletShiftValsX);
                y = bsxfun(@minus, (2^j)*samps(:,2), waveletShiftValsY);
                
                % For each translate, sample values (x,y) that live under wavelet's support --> 1
                valid_x = (x >= waveSupp(1) & x <= waveSupp(2));
                valid_y = (y >= waveSupp(1) & y <= waveSupp(2));
                
                waveletValsPerPoint1 = zeros(numSamps,numTranslations_multires);
                waveletValsPerPoint2 = zeros(numSamps,numTranslations_multires);
                waveletValsPerPoint3 = zeros(numSamps,numTranslations_multires);
                
                % Loop over translations in x
                for i = 1:numXTranslations_multires
                    % Find where points x and y exist together or intersect --> 1
                    intersections = bsxfun(@times, valid_x(:,i), valid_y);
                    
                    % Sample indices are represented by rows
                    % Relevant y translations are represented by columns
                    [sampleIndex, translateIndex] = find(intersections == 1);
                    
                    % Calculate father wavelet for relevant points that fall under current x translation
                    x_at_translate = x(sampleIndex,i);
                    mother_x = mother(x_at_translate);
                    father_x = father(x_at_translate);
                    
                    % Calculate father wavelet for relevant points that fall under all y translations
                    y_at_translate = y(logical(intersections));
                    mother_y = mother(y_at_translate);
                    father_y = father(y_at_translate);
                    
                    % Calculate the father wavelet for all relevant points that fall under current translations
                    motherWav1 = bsxfun(@times, 2^j * father_x, mother_y);
                    motherWav2 = bsxfun(@times, 2^j * mother_x, father_y);
                    motherWav3 = bsxfun(@times, 2^j * mother_x, mother_y);
                    
                    % Store father wavelet values
                    newyTranlateIndex = translateIndex + (i-1) * numXTranslations_multires;
                    linearIndex = sub2ind(size(waveletValsPerPoint1), sampleIndex, newyTranlateIndex);
                    
                    waveletValsPerPoint1(linearIndex) = motherWav1;
                    waveletValsPerPoint2(linearIndex) = motherWav2;
                    waveletValsPerPoint3(linearIndex) = motherWav3;
                    
                end % for i = 1:numXTranslations_multires
                
                % Store wavelet values for every resolution
                waveletValsPerPoint = [waveletValsPerPoint waveletValsPerPoint1 waveletValsPerPoint2 waveletValsPerPoint3];
                
            end % for = j startLevel:inc:stopLevel
            
            % Calculate wavelet coefficients
            wavVals = bsxfun(@rdivide, waveletValsPerPoint, sqrtPEachSamp);
            waveletBasisGrid = sum(wavVals,1);
            waveletBasisGrid = waveletBasisGrid';
            basisGrid = [scalingBasisGrid;waveletBasisGrid];
            
        end % if(~scalingOnly)
        
        % Calculate coefficients
        c = (1/numSamps)*basisGrid;
        coeffs = c/norm(c);
        
        
        
    otherwise
        error('Unsupported initialization type!');
end
