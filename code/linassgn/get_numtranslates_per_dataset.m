function [numTranslatesCell] = get_numtranslates_per_dataset(wdeSet)

numTranslatesCell = {};
for i = wdeSet.startLevel:wdeSet.stopLevel
  numTranslates = [];
  for j = 1:size(wdeSet.sampleSupp,1)
    numTranslates = [numTranslates diff(translationRange(wdeSet.sampleSupp(j,:), wdeSet.wName, i))+1];
  end
  numTranslatesCell = [numTranslatesCell numTranslates];
end

end
