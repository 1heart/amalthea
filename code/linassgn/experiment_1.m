% -------------------------------------------------------------------------
% Script: experiment_1
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This runs experiments that compare sphere distance vs. sphere_dist_linassgn on supervised data.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------
if ~exist('datasets')
  dataset_names = { 'brown_123', 'brown_125'};
  datasets = getDatasets(dataset_names);
  get_dists_for_datasets;
  lambda = 1e-4;
end;

std_dist = @sphere_norm;

for i = 1:length(datasets)
  D = datasets{i}.data;
  L = datasets{i}.labels;
  linassgn_dist = @(x,y) sphere_dist_linassgn(x, y, datasets{i}.distMatrix, lambda);
  % std_result = eval_supervised_mean_retrieval(D,L, {@metrics_shrec}, 1, 1, std_dist);
  % save(['results/' datasets{i}.name '_std_result'], 'std_result');
  linassgn_result = eval_supervised_mean_retrieval(D,L, @metrics_shrec, 1, 1, linassgn_dist);
  save(['results/' datasets{i}.name '_linassgn_result'], 'linassgn_result');
end

