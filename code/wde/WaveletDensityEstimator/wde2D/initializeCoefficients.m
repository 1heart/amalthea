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
function [coeffs, coeffsIdx, scalValsPerPoint, waveletValsPerPoint] = initializeCoefficients(samps, startLevel, stopLevel,...
    sampleSupport, wName,...
    scalingOnly, initType, varargin)

coeffsIdx = coefficientIndex(startLevel, stopLevel,...
    sampleSupport, wName,...
    scalingOnly);
switch(lower(initType{1}))
    case 'level'
        % For 2D multires. analysis for each translation pair (k1,k2) we also get
        % 3 combinations of the mother and father wavelet. So this will increase
        % the number of coefficients by a factor of 3 for each pair translation
        % values.  This is only on the wavelet summation not on the scaling.
        numBasisPerTransPair = 3;
        
        % Get the number of translations for the scaling function of the start
        % level.  For 2D we need to get translations in both x & y directions.
        numTransX = diff(translationRange(sampleSupport(1,:), wName, startLevel))+1;
        numTransY = diff(translationRange(sampleSupport(2,:), wName, startLevel))+1;
        
        % Assign equal weights to the scaling coefficients.
        c = (1/2^startLevel)*(ones(numTransX*numTransY,1));
        
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
                c         = [c;cTmp];
            end
        end
        
        % Add some random noise to coeffs to stop the log zero error in nll
        % function.
        c = c + .5*rand(size(c,1),1);
        
        % Normalize the coefficients so that sum of squares of the coefficients is
        % 1.
        coeffs = c/norm(c);
        
        

        
        
    case 'hist'
        % Determine if we need to count up or down
        if(startLevel <= stopLevel)
            inc = 1;
        else
            inc = -1;
        end
        if(isempty(cell2mat(varargin(1))))
            error('Need samps to estimate histogram');
        else
            samps =  cell2mat(varargin(1));
        end
        % Get histogram of the samples and the corresponding sqrt of
        % density value for each sample.
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
        
        [binCounts,idx] = hist3c(samps,bins);
        % Normalize the bins and take sqrt.
        sqrtP         = sqrt(binCounts./sum(binCounts(:)));
        sqrtPEachSamp = sqrtP(sub2ind(size(sqrtP),idx(:,1),idx(:,2)));
        numSamps      = length(samps);
        
        % Translation range for the starting level scaling function.
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
        scalingBasisGrid = zeros(numXTranslations,numYTranslations);
        numTranslations = numXTranslations * numYTranslations;
        
        % OPTIMIZATION FOUR: Single loop along translations
        % Gives back new sample points (x,y) along each translate K
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

        % Calculate coefficients
        scalVals = bsxfun(@rdivide, scalValsPerPoint, sqrtPEachSamp);
        scalingBasisGrid = sum(scalVals,1);
        scalingBasisGrid = scalingBasisGrid';
    
        waveletValsPerPoint = [];

        % MULTIRES OPTIMIZATION ---------------------------------------------------------------------------------------------
        if(~scalingOnly)
            
            
            for j = startLevel:inc:stopLevel
                waveletTransRX    = translationRange(sampleSupport(1,:), wName, j);
                waveletShiftValsX = [waveletTransRX(1):waveletTransRX(2)];
                waveletTransRY    = translationRange(sampleSupport(2,:), wName, j);
                waveletShiftValsY = [waveletTransRY(1):waveletTransRY(2)];
                
                % Set up wavelet basis grid for each translate
                numXTranslations_multires = length(waveletShiftValsX);
                numYTranslations_multires = length(waveletShiftValsY);
                %         			waveletBasisGrid = zeros(numXTranslations_multires,numYTranslations_multires);
                numTranslations_multires = numXTranslations_multires * numYTranslations_multires;
                
                % Gives back new sample points (x,y) along each translate K
                x = bsxfun(@minus, (2^j)*samps(:,1), waveletShiftValsX);
                y = bsxfun(@minus, (2^j)*samps(:,2), waveletShiftValsY);
                
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
            
            wavVals = bsxfun(@rdivide, waveletValsPerPoint, sqrtPEachSamp);
            waveletBasisGrid = sum(wavVals,1);
            waveletBasisGrid = waveletBasisGrid';
            
        end % if(~scalingOnly)
        % -----------------------------------------------------------------------------------------------------------------
        
        
        if(~scalingOnly)
            c = (1/numSamps)*[scalingBasisGrid;waveletBasisGrid];
        else
            c = (1/numSamps)*scalingBasisGrid;
        end
        coeffs = c/norm(c);
        
        
        
    case 'histWDE'
        initDensityDir = char(varargin{1});
        strIdx=strfind(initDensityDir,'/');
        densityNames = initDensityDir(strIdx(3)+1:strIdx(4)-1);
        wFamName   = initDensityDir(strIdx(2)+1:strIdx(3)-1);
        % Load the another families coefficients.
        load([initDensityDir 'mdlTest_' densityNames '_j0Lv_' num2str(startLevel) ...
            '_OS_' num2str(scalingOnly) '_' wavFamName],'coeffs');
        db1Coeffs = coeffs(:,end);
        clear coeffs;
        
        transXDb1   = translationRange(sampleSupport(1,:), wFamName, startLevel);
        transYDb1   = translationRange(sampleSupport(2,:), wFamName, startLevel);
        transX      = translationRange(sampleSupport(1,:), wName, startLevel);
        transY      = translationRange(sampleSupport(2,:), wName, startLevel);
        
        wSupportDb1 = waveSupport(wFamName);
        wSupport    = waveSupport(wName);
        
        % Get end point of basis support for the current level.
        basisEndPtDb1 = wSupportDb1(2)/2^startLevel;
        basisEndPt    = wSupport(2)/2^startLevel;
        
        % Get the centroid position of the basis for the current level.
        basisCenterDb1 = basisEndPtDb1/2;
        basisCenter = basisEndPt/2;
        
        % Now get the position of all the basis for all the translation values.
        basisLocsXDb1 = [transXDb1(1):transXDb1(2)]'*(1/2^startLevel)+basisCenterDb1;
        basisLocsYDb1 = [transYDb1(1):transYDb1(2)]'*(1/2^startLevel)+basisCenterDb1;
        basisLocsX = [transX(1):transX(2)]'*(1/2^startLevel)+basisCenter;
        basisLocsY = [transY(1):transY(2)]'*(1/2^startLevel)+basisCenter;
        
        % Interpolate to coefficients for this family.
        c = interp2(basisLocsXDb1,basisLocsYDb1,db1Coeffs',basisLocsX,basisLocsY,'spline');
        coeffs = c/norm(c);
    case 'eig'
        %goodSampsIdx  = find((samps(:,1)>0) & (samps(:,2)>0));
        numSamps      = size(samps,1); %length(goodSampsIdx);%
        numLevels     = length(startLevel:stopLevel);
        % Calculate the arithmetic mean of the outer product.
        numTrans  = coeffsIdx(end);%length(scalingShiftVals);
        outerProd = zeros(numTrans);
        
        % Translation range for the starting level scaling function.  Need both x
        % and y values since 2D.
        scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
        scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
        scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
        scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];
        
        
        % Set up correct basis functions.
        [father, mother] = basisFunctions(wName);
        
        scalingSum        = 0;
        waveletSum        = 0;
        
        % Determine if we need to count up or down.
        if(startLevel <= stopLevel)
            inc = 1;
        else
            inc = -1;
        end
        
        % Calculate the loglikelihood.
        for s = 1 : numSamps
            % Get (x,y) value of the sample.
            %samps(goodSampsIdx(s),1); sampY = samps(goodSampsIdx(s),2);
            sampX = samps(s,1); sampY = samps(s,2);
            
            % Compute father value for all scaled and translated samples
            % over our entire 2D sampling grid.
            x         = 2^startLevel*sampX - scalingShiftValsX;
            y         = 2^startLevel*sampY - scalingShiftValsY;
            
            % Using kronecker prodcut to get combination of all shift values.
            % Will result in:
            % f(x1)*f(y1),f(x1)f(y2),f(x1)f(y3),...f(x2)f(y1),...f(xN)f(yM)
            % Also note we don't need the (1/2) factor in normalization because we
            % are multiplying 2 basis functions together so the factor cancels.
            scalVals  = 2^startLevel*kron(father(x),father(y));
            
            % Incorporate the mother basis if necessary.
            if(~scalingOnly)
                mothVals = [];
                % Loop over all the levels to evaluate the wavelet basis.
                for j = startLevel :inc:stopLevel
                    transRX    = translationRange(sampleSupport(1,:), wName, j);
                    shiftValsX = [transRX(1):transRX(2)];
                    transRY    = translationRange(sampleSupport(2,:), wName, j);
                    shiftValsY = [transRY(1):transRY(2)];
                    x          = 2^j*sampX - shiftValsX;
                    y          = 2^j*sampY - shiftValsY;
                    
                    % Need to 3 different combinations for 2D wavelets. The entire
                    % grid of translations is put in a 1xM vector for each of
                    % combinations.  The kron is traversing the grid from the lower
                    % left to the upper right order.  This is the same ordering as
                    % what you would get from doing [xx, yy] = meshgrid(-5:5,-4:4);
                    % followed by putting points in a matrix pts = [xx(:) yy(:)];
                    mothVals1  = 2^j*kron(father(x),mother(y));
                    mothVals2  = 2^j*kron(mother(x),father(y));
                    mothVals3  = 2^j*kron(mother(x),mother(y));
                    
                    mothVals   = [mothVals mothVals1 mothVals2 mothVals3];
                end
            end % if(~scalingOnly)
            
            if(~scalingOnly)
                outerProd = outerProd + [scalVals mothVals]'*([scalVals mothVals]);
            else
                outerProd = outerProd + scalVals'*scalVals;
            end
        end % for s = 1 : numSamps
        
        arithMean = (1/numSamps)*outerProd;
        
        [eigVec,eigVals]=eigs(arithMean);
        coeffs = eigVec(:,1);
        coeffs = coeffs.*sign(coeffs);
    otherwise
        error('Unsupported initialization type!');
end
