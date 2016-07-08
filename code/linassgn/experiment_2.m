DISP = 1;
SAVE_PATH = './results/';
% LAMBDAS = [0];
% DATASET_NAMES = {'brown_123'};
% LAMBDAS = [0 1e-2 1e-4 1e-6 1e-8];
DATASET_NAMES = {...
  % 'mpeg_7_haar_singleres',...
  'mpeg_7_haar_multires',...
  % 'mpeg_7_sym4_singleres',...
  % 'mpeg_7_sym4_multires'...
  };
if ~exist('datasets')
  datasets = getDatasets(DATASET_NAMES, '~/amalthea/data/new_coeffs/');
  get_dists_for_datasets;
  get_optimized_lambda_for_datasets;
  % datasets{1} = reshape_dataset(datasets{1}, 120);
end

for i = 1:length(datasets)
  if (DISP) disp(['Starting dataset ' num2str(i)]); end;
  ds = datasets{i};
  [n d] = size(ds.data);
  numShapesPerCategory = ds.dimensions(2);
  % for lambda = LAMBDAS
  lambda = ds.bestLambda;
    if (DISP) disp(['Starting lambda ' num2str(lambda)]); end;
    pairwise_dists = zeros(n);
    count = 0; total = n * (n-1) / 2;
    curr_dist_func = @(x,Y) sphere_dist_linassgn_mtx(x, Y, ds.distMatrices, lambda, ds.multires_i);
    pairwise_dists = squareform(pdist(ds.data, curr_dist_func));
    % pairwise_dists = squareform(pdist(ds.data));
    save([SAVE_PATH ds.name '_lambda_' num2str(lambda) '_pdists'], 'pairwise_dists');
    bullseye_val = bullsEyeScore(pairwise_dists, ds.labels, numShapesPerCategory);
    save([SAVE_PATH ds.name '_lambda_' num2str(lambda) '_bullseye'], 'bullseye_val');
  % end
end

