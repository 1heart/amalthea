% -------------------------------------------------------------------------
% Script: linassgn_demo
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This shows how to get the distance matrices for each dataset.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

if ~exist('datasets') datasets = getDatasets; end;

for i = 1:length(datasets)
  curr = datasets{i};
  numTranslates = [];
  % Get the number of translations for the scaling function of the start level for each dimension.
  for j = 1:size(curr.sampleSupp,1)
    numTranslates = [numTranslates diff(translationRange(curr.sampleSupp(j,:), curr.wName, curr.startLevel))+1];
  end

  datasets{i} = setfield(datasets{i}, 'numTranslates', numTranslates);
  datasets{i} = setfield(datasets{i}, 'distMatrix', construct_dist_matrix(numTranslates));
end
