function relevantKs  = translatesChecking1(sample,supp,startLevel,coefficients,scalTranslates)

% the wavelet support bounds
% suppLowerBound = supp(1);
% suppUpperBound = supp(length(supp));
% 
% % checking the bounds of the translates
% translatesLowerBound = - suppUpperBound + (2^(startLevel))*sample;
% translatesUpperBound = - suppLowerBound + (2^(startLevel))*sample;
% 
% % new translates values ( the idea is to avoid looping over  the whole
% % translates for each sample )
% newTranslates = translatesLowerBound : translatesUpperBound;
%==================================================


% HERE WE COMPUTE THE RERELVANT TRANSLATEDS FOR ECAH SAMPLE
lowerSupp = min(supp);
upperSupp = max(supp);
scalCoeff = coefficients;    
%for i = 1 : length(sample)
    % Find the translate bounds that correspond to the sample. 
    kLowerBound = ceil(2^startLevel*sample - upperSupp);
    kUpperBound = floor(2^startLevel*sample - lowerSupp); 
    
    
    
    
    
    % Find the translates in the translate vector that correspond to the    
    % sample.
    lowerKIndex = find(scalTranslates == kLowerBound);
    upperKIndex = find(scalTranslates == kUpperBound);
    
    
    
    relevantKs = (scalTranslates(lowerKIndex) : scalTranslates(upperKIndex));
    % Find the corresponding coefficients. 
    
    
    
    %======================================================
%     correspCoeff = scalCoeff(lowerKIndex : upperKIndex);
%     % Perform interpolation across each translate and sample.
%     x = 2^startLevel*sample - relevantKs;
%     phiHere = interp1(supp, phi, x, 'v5cubic');
%     % Updating relevant coefficients.
%     updCoeff = (n / (n + 1))*correspCoeff + (1 / (n + 1))*2^(startLevel / 2)*phiHere;
%     allCoeffUpd = (n / (n + 1))*scalCoeff;
%     allCoeffUpd(lowerKIndex : upperKIndex) = updCoeff;
%     coefficients{1,1} = allCoeffUpd;
     %=================================================================





