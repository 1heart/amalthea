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
  wdeSet = datasets{i}.wdeSet;
  numTranslatesCell = get_numtranslates_per_dataset(datasets{i}.wdeSet);
  datasets{i} = setfield(datasets{i}, 'numTranslatesCell', numTranslatesCell);
  ptr = 1; multires_i = [];
  for j = 1:length(numTranslatesCell)
    inc = prod(numTranslatesCell{j});
    multires_i = [multires_i; ptr (ptr + inc - 1)];
    ptr = ptr + inc;
  end
  datasets{i} = setfield(datasets{i}, 'multires_i', multires_i);
  datasets{i} = setfield(datasets{i}, 'coeffsIdx', multires_i);
  wdeSet.coeffsIdx = multires_i;
  datasets{i} = setfield(datasets{i}, 'wdeSet', wdeSet);
   distMatrices = {};
  for j = 1:length(numTranslatesCell)
    distMatrices = [distMatrices construct_dist_matrix(numTranslatesCell{j})];
  end
  % distMatrices = euclidDistsBetwCoeffs(wdeSet);
  datasets{i} = setfield(datasets{i}, 'distMatrices', distMatrices);
end
