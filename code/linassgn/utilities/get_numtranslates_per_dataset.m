function [numTranslatesCell] = get_numtranslates_per_dataset(wdeSet)

startLevel = wdeSet.startLevel; stopLevel = wdeSet.stopLevel; wName = wdeSet.wName; sampleSupport = wdeSet.sampleSupp;

scalingTransRX    = translationRange(sampleSupport(1,:), wName, startLevel);
scalingShiftValsX = [scalingTransRX(1):scalingTransRX(2)];
scalingTransRY    = translationRange(sampleSupport(2,:), wName, startLevel);
scalingShiftValsY = [scalingTransRY(1):scalingTransRY(2)];
numXTranslations = length(scalingShiftValsX);
numYTranslations = length(scalingShiftValsY);
numTranslates = [numXTranslations numYTranslations];
numTranslatesCell = {numTranslates};

if ~wdeSet.onlyScaling
  for j = startLevel:stopLevel
    waveletTransRX    = translationRange(sampleSupport(1,:), wName, j);
    waveletShiftValsX = [waveletTransRX(1):waveletTransRX(2)];
    waveletTransRY    = translationRange(sampleSupport(2,:), wName, j);
    waveletShiftValsY = [waveletTransRY(1):waveletTransRY(2)];

    % Set up wavelet basis grid for each translate
    numXTranslations_multires = length(waveletShiftValsX);
    numYTranslations_multires = length(waveletShiftValsY);
    numTranslates = [numXTranslations_multires numYTranslations_multires];

    for i = 1:3 % 3 mother wavelets per res level, for 2d only
      numTranslatesCell = [numTranslatesCell numTranslates];
    end
  end
end

end
