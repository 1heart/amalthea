%--------------------------------------------------------------------------
% Function:    bullsEyeScore
% Description: This functions computes the bull's eye score for the MPEG 7
%              dataset.
%
% Inputs:
%
%   distMat       - Distance matrix containing the distance between each 
%                   shape and all the other shapes (unsorted). 
%	
%   trueLabels    - A vector that contains the category that each shape 
%                   belongs to.
%
%   nshpc         - Number of shapes per category.
% 
% Outputs:
%   
%   bes           - Bull's eye score. 
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Thursday 4th April, 2014.
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function bes = bullsEyeScore(distMat, trueLabels, nshpc)

numShapes = length(trueLabels); % Number of shapes in the database.

% Initialize vector to store the correct label count for each query shape. 
besVec = zeros(numShapes,1); % Second Tier value per shape. 

nscBes = 40; % Number of shapes to calculate the bull's eye score. 
if (numShapes < nscBes)
    nscBes = numShapes;
end

% Loop through each row in the distance matrix. 
for i = 1 : numShapes
    
    % Pull out the ith row from the distance matrix. 
    irDistMat = distMat(i,:);

    % Sort the distance vector. sirInd is sorted ith row index.
    [~, sirInd] = sort(irDistMat); 
    
    % Use the modified sort index to retrieve the right labels. 
	stLab = trueLabels(sirInd); % Sorted true labels.   
    
    % Get the top 40 retrieved labels.
    retLab = stLab(1:nscBes);
    
    % Count the number of retrieved labels in the top 40 are equal to the
    % query shape label. 
    besVec(i) = sum(retLab == trueLabels(i));
end
    
% Sum the total amount of correct labels and divide by (20 x 1400).    
bes = sum(besVec) / (nshpc*numShapes);