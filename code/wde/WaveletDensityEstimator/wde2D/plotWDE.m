%--------------------------------------------------------------------------
% Function:    plotWDE
% Description: Plots WDE for the given coefficients.
%
% Inputs:
%   densityPts        - 2xN matrix of values where we want to evaluate the
%                       density.
%   sampleSupport     - 2x2 matrix where the 1st row has [xMin xMax] and
%                       2nd row has [yMin yMax].
%   wName             - name of wavelet to use for density approximation.
%                       Use matlab naming convention for wavelets.
%                       Default: 'db1' - Haar
%   startLevel        - starting level for the the father wavelet
%                       (i.e. scaling function).  
%   stopLevel         - last level for mother wavelet scaling.  The start
%                       level is same as the father wavelet's.
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
%   scalingOnly       - flag indicating if we only want to use scaling
%                       functions for the density estimation.
%
% Outputs:
%   sqrtP             - Estimate of the square root of the density.
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
function sqrtP = plotWDE(supportVals, sampleSupport, wName, startLevel, stopLevel,...
                         coeffs, coeffsIdx, scalingOnly, varargin)

numSamps      = length(supportVals);

% Determine if we need to count up or down.
if(startLevel <= stopLevel)
    inc = 1;
else
    inc = -1;
end

scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];

% Set up correct basis functions.
[father, mother] = basisFunctions(wName);
waveSupp = waveSupport(wName);

% Set up scaling basis grid for each translate
numXTranslations = length(scalingShiftValsX);
numYTranslations = length(scalingShiftValsY);
numTranslations = numXTranslations * numYTranslations;

x = bsxfun(@minus, (2^startLevel)*supportVals(:,1), scalingShiftValsX);
y = bsxfun(@minus, (2^startLevel)*supportVals(:,2), scalingShiftValsY);

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

fatherValsPerPoint = bsxfun(@times, scalValsPerPoint, coeffs(coeffsIdx(1,1):coeffsIdx(1,2))');
fatherValsPerPoint = sum(fatherValsPerPoint,2);


waveletValsPerPoint = [];
motherValsPerPoint = 0;
if(~scalingOnly)
    
    for j = startLevel:inc:stopLevel
        waveletTransRX    = translationRange(sampleSupport(1,:), wName, j);
        waveletShiftValsX = [waveletTransRX(1):waveletTransRX(2)];
        waveletTransRY    = translationRange(sampleSupport(2,:), wName, j);
        waveletShiftValsY = [waveletTransRY(1):waveletTransRY(2)];

        % Set up wavelet basis grid for each translate
        numXTranslations_multires = length(waveletShiftValsX);
        numYTranslations_multires = length(waveletShiftValsY);
        %                   waveletBasisGrid = zeros(numXTranslations_multires,numYTranslations_multires);
        numTranslations_multires = numXTranslations_multires * numYTranslations_multires;
        
        % Gives back new sample points (x,y) along each translate K
        x = bsxfun(@minus, (2^j)*supportVals(:,1), waveletShiftValsX);
        y = bsxfun(@minus, (2^j)*supportVals(:,2), waveletShiftValsY);
        
        % For each translate, sample values (x,y) that live under wavelet's support --> 1
        valid_x = (x >= waveSupp(1) & x <= waveSupp(2));
        valid_y = (y >= waveSupp(1) & y <= waveSupp(2));
        
        waveletValsPerPoint1 = zeros(numSamps,numTranslations_multires);
        waveletValsPerPoint2 = zeros(numSamps,numTranslations_multires);
        waveletValsPerPoint3 = zeros(numSamps,numTranslations_multires);
        
        for i = 1:numYTranslations_multires
            % Find where points x and y exist together or intersect --> 1
            intersections = bsxfun(@times, valid_x(:,i), valid_y);
            
            % Sample indices are represented by rows.
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
            
            % Save father wavelet values
            newyTranlateIndex = translateIndex + (i-1) * numXTranslations_multires;
            linearIndex = sub2ind(size(waveletValsPerPoint1), sampleIndex, newyTranlateIndex);
            
            waveletValsPerPoint1(linearIndex) = motherWav1;
            waveletValsPerPoint2(linearIndex) = motherWav2;
            waveletValsPerPoint3(linearIndex) = motherWav3;
            
        end % for i = 1:numYTranslations_multires
        
        waveletValsPerPoint = [waveletValsPerPoint waveletValsPerPoint1 waveletValsPerPoint2 waveletValsPerPoint3];
        
    end % for = j startLevel:inc:stopLevel
    
    motherValsPerPoint = bsxfun(@times, waveletValsPerPoint, coeffs(coeffsIdx(2,1):end)');
    motherValsPerPoint = sum(motherValsPerPoint,2);
    
end % if(~scalingOnly)

basisValPerPoint = fatherValsPerPoint + motherValsPerPoint;

% Reshape p to fit the domain.
xGrid = cell2mat(varargin(1));
yGrid = cell2mat(varargin(2));
sqrtP = reshape(basisValPerPoint,size(xGrid));


if(isempty(varargin(3)))
    wdePlotting = 1;
else
    wdePlotting = cell2mat(varargin(3));
end

if(wdePlotting)
    f1 = figure; movegui(f1,'east');
    surf(xGrid,yGrid,sqrtP); shading flat;
    colormap gray;
    axis off;
    title(['${\sqrt{p(x)}}$ WDE'],'Fontsize', 14,'Interpreter', 'latex');
    f2 = figure; movegui(f2,'west');
    surf(xGrid,yGrid,sqrtP.^2); shading flat;
    colormap gray;
    axis off;
    title(['p(x) WDE'],'Fontsize', 14);
end
