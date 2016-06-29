%                       with scaling + wavelets. The default is density
%                       estimation with the scaling function only. 
%                       waveletFlag = 1; Wavelet is on. 
%                       waveletFlag = 0; Wavelet is off.
%  scalTranslates     - Scaling function translate values. 
%  waveTranslates     - Wavelet translate values for each resolution. 
%
% Outputs:
%   coefficients      - Coefficients for constructing the density function.

% Usage: This function is used to update the coeffients used for the
%        density in online density estimation. The same coefficients ouput
%        vector can be used as an input vector.
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [coefficients] = estimatingCoeffs( sample,...
                                            densityDomain,...
                                            startLevel,...
                                            coefficients,...
                                            waveletFlag,...
                                            relevantKs,...
                                            indexofRelevantTrans,...
                                            linearIndOfRelevantTran,...
                                            correspCoeff,...
                                            supp,...
                                            phi )
                                                  
                                        
scalCoeff = coefficients;
tensorProdVect = 1;
dim = size(sample,2);

% since the correspCoeff can have the same lenf as the previous one but not
% from the same linear index translate vector we just compute updCoeff
% whihout adding correspCoeff. We will put updCoeff in a big matrix later
% in the next stage and then add those two vectors and so on




%  evalutae the scaling function using interpolation
for i = 1 : size(sample,1)
            for m = 1: dim
                x = 2^startLevel*sample(m) - relevantKs(:,m);
                phiHere = interp1(supp, phi, x, 'v5cubic');
                phiHere(isnan(phiHere))= 0;
                phii(m).val=phiHere;
                tensorProdVect = tensorProdVect.*phii(m).val;
            end
%updCoeff = correspCoeff + (2^(startLevel / 2)^dim)*tensorProdVect';
updCoeff = (2^(startLevel / 2)^dim)*tensorProdVect';
allCoeffUpd = scalCoeff;
    %position updCoeff into the big coeff vector
[ Matr,coefficients ] = reAdjustingTheCoeff( allCoeffUpd,...
indexofRelevantTrans,linearIndOfRelevantTran,updCoeff,dim,scalCoeff ); 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Scaling and wavelets.
    
    if (waveletFlag == 1)
        for j = startLevel : stopLevel   
            % Translates for resolution j.
            transOfResJ = waveTranslates{((j - startLevel) + 1),1};
            % Find the translate bounds that correspond to the sample. 
            kWaveLowerBound = ceil(2^j*sample(i) - upperSupp);
            kWaveUpperBound = floor(2^j*sample(i) - lowerSupp);
            % Find the translates in the translate vector that correspond to the    
            % sample.
            jWaveLowerKIndex = find(transOfResJ == kWaveLowerBound);
            jWaveUpperKIndex = find(transOfResJ == kWaveUpperBound);
            relevantWaveKs = (transOfResJ(jWaveLowerKIndex) : transOfResJ(jWaveUpperKIndex));
            % Current j coefficients.
            coeffIndVal = ((j - startLevel) + 2) ; % Only wavelet coefficients
            currWaveCoeff = coefficients{coeffIndVal,1};
            % Find the corresponding coefficients.
            corresWaveCoeff = currWaveCoeff(jWaveLowerKIndex : jWaveUpperKIndex); 
            % Perform interpolation with the psi wavelet.
            x = 2^j*sample(i) - relevantWaveKs;
            psiHere = interp1(supp, psi, x, 'v5cubic');
            % Update the relevant coefficients.
            updWaveCoeff = (n / (n + 1))*corresWaveCoeff + (1 / (n + 1))*2^(j / 2)*psiHere;
            currWaveCoeff = (n / (n + 1))*currWaveCoeff;
            currWaveCoeff(jWaveLowerKIndex : jWaveUpperKIndex) = updWaveCoeff;
            coefficients{coeffIndVal,1} = currWaveCoeff;     
        end % j = startLevel : stopLevel         
    end % (waveletFlag == 1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % i = 1 : length(sample)

end % estimateCoefficients()