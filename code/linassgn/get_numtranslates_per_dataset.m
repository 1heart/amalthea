function [numTranslatesCell] = get_numtranslates_per_dataset(wdeSet)

numTranslatesCell = {};
for j = wdeSet.startLevel:wdeSet.stopLevel
  numTranslates = [];
  for j = 1:size(wdeSet.sampleSupp,1)
    numTranslates = [numTranslates diff(translationRange(wdeSet.sampleSupp(j,:), wdeSet.wName, wdeSet.startLevel))+1];
  end
  numTranslatesCell = [numTranslatesCell numTranslates];
end

end
