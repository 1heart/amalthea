if ~exist('datasets') datasets = getDatasets; end;

for i = 1:length(datasets)
  curr = datasets{i};
  numTranslates = [];
  for j = 1:size(curr.sampleSupp,1)
    numTranslates = [numTranslates diff(translationRange(curr.sampleSupp(j,:), curr.wName, curr.startLevel))+1];
  end

  datasets{i} = setfield(datasets{i}, 'numTranslates', numTranslates);
  datasets{i} = setfield(datasets{i}, 'distMatrix', constructDistMatrix(numTranslates));
end
