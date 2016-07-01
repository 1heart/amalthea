SAVE_PATH = './results/';
LAMBDAS = [0];
% LAMBDAS = [0 1e-2 1e-4 1e-6 1e-8];
% DATASET_NAMES = {...
%   'mpeg_7_haar_singleres', 'mpeg_7_haar_multires',...
%   'mpeg_7_sym4_singleres', 'mpeg_7_sym4_singlres'};
DATASET_NAMES = {'brown_123'};
if ~exist('datasets')
  datasets = getDatasets(DATASET_NAMES, '~/amalthea/data/');
  get_dists_for_datasets;
end


for i = 1:length(datasets)
  ds = datasets{i};
  numShapesPerCategory = ds.dimensions(2);
  for lambda = LAMBDAS
    curr_dist_func = @(x_i, X_j) sphere_dist_linassgn_mtx(x_i, X_j, ds.distMatrices, lambda, ds.coeffsIdx);
    pairwise_dists = squareform(pdist(ds.data, curr_dist_func));
    save([SAVE_PATH ds.name '_lambda_' num2str(lambda) '_pdists'], 'pairwise_dists');
    bullseye_val = bullsEyeScore(pairwise_dists, ds.labels, numShapesPerCategory);
    save([SAVE_PATH ds.name '_lambda_' num2str(lambda) '_bullseye'], 'bullseye_val');
  end
end

