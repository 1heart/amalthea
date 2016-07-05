% -------------------------------------------------------------------------
% Script: get_dists_for_datasets
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This shows how to get the distance matrices for each dataset.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

if ~exist('datasets') error('Datasets does not exist!'); end;

for i = 1:length(datasets)
  numTranslatesCell = get_numtranslates_per_dataset(datasets{i}.wdeSet);
  datasets{i} = setfield(datasets{i}, 'numTranslatesCell', numTranslatesCell);
  distMatrices = {};
  for j = 1:length(numTranslatesCell)
    distMatrices = [distMatrices construct_dist_matrix(numTranslatesCell{i})];
  end
  datasets{i} = setfield(datasets{i}, 'distMatrices', distMatrices);
end
