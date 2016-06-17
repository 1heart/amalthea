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

SAVE = 1;
DEBUG = 1;
DISPLAY = 1;
% dataset_names = { 'brown_123', 'brown_125'};
dataset_names = { 'brown_125'};
lambda = 1e-4;

if ~exist('datasets')
  datasets = getDatasets(dataset_names, '/home/bitnami/amalthea/data/');
  get_dists_for_datasets;
end;

std_dist = @sphere_dist;

for i = 1:length(datasets)
  D = datasets{i}.data;
  L = datasets{i}.labels;
  linassgn_dist = @(x,y) sphere_dist_linassgn(x, y, datasets{i}.distMatrix, lambda);
  % std_result = eval_supervised_mean_retrieval(D,L, {@metrics_shrec}, DEBUG, DISPLAY, std_dist);
  % if (SAVE) save(['results/' datasets{i}.name '_std_result'], 'std_result'); end;
  linassgn_result = eval_supervised_mean_retrieval(D,L, @metrics_shrec, DEBUG, DISPLAY, linassgn_dist);
  if (SAVE) save(['results/' datasets{i}.name '_linassgn_result'], 'linassgn_result'); end;
end

