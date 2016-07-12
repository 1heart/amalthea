if ~exist('datasets')
  datasets = getDatasets({
    % 'mpeg_7_haar_singleres',...
    % 'mpeg_7_haar_multires',...
    'mpeg_7_sym4_singleres',...
    % 'mpeg_7_sym4_multires'...
  });
  get_dists_for_datasets;
  get_optimized_lambda_for_datasets;
end
ds = datasets{1};

numShapesPerCat = ds.dimensions(2);
numCategories = 10;
numShapes = 10;

indices = [];
for i = 1:numCategories
  start = (i - 1) * numShapesPerCat + 1;
  stop = start + numShapes - 1;
  indices = [indices start:stop];
end

D = ds.data(indices,:);
L = ds.labels(indices,:);
lambda = ds.bestLambda;

curr_dist_func = @(x,Y) sphere_dist_linassgn_mtx(x, Y, ds.distMatrices, lambda, ds.multires_i);

% pairwise_dists = squareform(pdist(D, curr_dist_func));
pairwise_dists = acos(D * D');

bullsEyeScore(pairwise_dists, L, numShapes)

