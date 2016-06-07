% Get the number of translations for the scaling function of the start
% level.  For 2D we need to get translations in both x & y directions.
numTransX = diff(translationRange(sampleSupport(1,:), wName, startLevel))+1;
numTransY = diff(translationRange(sampleSupport(2,:), wName, startLevel))+1;