function [smaLlatticelinIndx,latticeOfTranslatesPerSamp]= relevantTranslatesSchemePerSample(sample,supp,startLevel,scalTranslatesCel)


scalTrans1 = scalTranslatesCel{1};
scalTrans2 = scalTranslatesCel{2};
scalTrans3 = scalTranslatesCel{3};


n1 = length(scalTrans1);
n2 = length(scalTrans2);
n3 = length(scalTrans3);



samp1 = sample(1);
samp2 = sample(2);
samp3 = sample(3);


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
%=========================================================================
% HERE WE COMPUTE THE RERELVANT TRANSLATEDS FOR ECAH SAMPLE
lowerSupp = min(supp);
upperSupp = max(supp);

%scalCoeff = coefficients;    
%for i = 1 : length(sample)

                % IN THE FISRT FEATURE OF THE SAMPLE
%-------------------------------------------------------------------------
% Find the translate bounds that correspond to the sample. 
kLowerBound1 = ceil(2^startLevel*samp1 - upperSupp);
kUpperBound1 = floor(2^startLevel*samp1 - lowerSupp);    
% Find the translates in the translate vector that correspond to the    
% sample.
lowerKIndex1 = find(scalTrans1== kLowerBound1);
upperKIndex1 = find(scalTrans1== kUpperBound1);     
relevantKs1 = (scalTrans1(lowerKIndex1) : scalTrans1(upperKIndex1));

% get the linear Index corresponding to those translates relevantKs 
% Matlab wil associate 1 to to lowest big translate vector value and the length of the
% translate as the index of the last value of the big translate vector
% associated with the sample
indx1Lenf = length(scalTrans1);
indx1 = 1:indx1Lenf;

% the lowest translate value will be associated with the lowest index value
% therefore finding the index range associated with each feature of the
% sample will be the same as getting the index of the relevantks
%indx1OfSamp1 = relevantKs1;
indx1OfSamp1 = lowerKIndex1:upperKIndex1;
%--------------------------------------------------------------------------
    
                % IN THE SECOND FEATURE OF THE SAMPLE
%---------------------------------------------------------------------------
% Find the translate bounds that correspond to the sample. 
kLowerBound2 = ceil(2^startLevel*samp2 - upperSupp);
kUpperBound2 = floor(2^startLevel*samp2 - lowerSupp);    
% Find the translates in the translate vector that correspond to the    
% sample.
lowerKIndex2 = find(scalTrans2 == kLowerBound2);
upperKIndex2 = find(scalTrans2 == kUpperBound2);     
relevantKs2 = (scalTrans2(lowerKIndex2) : scalTrans2(upperKIndex2));

% get the linear Index corresponding to those translates relevantKs 
% Matlab wil associate 1 to to lowest big translate vector value and the length of the
% translate as the index of the last value of the big translate vector
% associated with the sample
indx2Lenf = length(scalTrans2);
indx2 = 1:indx2Lenf;

% the lowest translate value will be associated with the lowest index value
% therefore finding the index range associated with each feature of the
% sample will be the same as getting the index of the relevantks
%indx2OfSamp2 = relevantKs2;
indx2OfSamp2 = lowerKIndex2:upperKIndex2;
%--------------------------------------------------------------------------

                % IN THE THIRD FEATURE OF THE SAMPLE
%---------------------------------------------------------------------------
% Find the translate bounds that correspond to the sample. 
kLowerBound3 = ceil(2^startLevel*samp3 - upperSupp);
kUpperBound3 = floor(2^startLevel*samp3 - lowerSupp);    
% Find the translates in the translate vector that correspond to the    
% sample.
lowerKIndex3 = find(scalTrans3 == kLowerBound3);
upperKIndex3 = find(scalTrans3 == kUpperBound3);     
relevantKs3 = (scalTrans3(lowerKIndex3): scalTrans3(upperKIndex3));

% get the linear Index corresponding to those translates relevantKs 
% Matlab wil associate 1 to to lowest big translate vector value and the length of the
% translate as the index of the last value of the big translate vector
% associated with the sample
indx3Lenf = length(scalTrans3);
indx3 = 1:indx3Lenf;

% the lowest translate value will be associated with the lowest index value
% therefore finding the index range associated with each feature of the
% sample will be the same as getting the index of the relevantks
%indx3OfSamp3 = relevantKs3;
indx3OfSamp3 = lowerKIndex3:upperKIndex3;
%--------------------------------------------------------------------------

[X0,Y0,Z0] = meshgrid(indx1OfSamp1,indx2OfSamp2,indx3OfSamp3);

latticeOfIndexes = [X0(:),Y0(:),Z0(:)];

[X,Y,Z] = meshgrid(relevantKs1,relevantKs2,relevantKs3);
latticeOfTranslatesPerSamp = [X(:),Y(:),Z(:)];
%

% get the linear index
smaLlatticelinIndx = sub2ind([n1 n2 n3],latticeOfIndexes(:,1),latticeOfIndexes(:,2),latticeOfIndexes(:,3));

clear X0 Y0 Z0 X Y Z


