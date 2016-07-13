if ~exist('datasets')
  datasets = getDatasets({
  'mpeg_7_haar_singleres',...
  %   % 'mpeg_7_haar_multires',...
  %   'mpeg_7_sym4_singleres',...
  %   % 'mpeg_7_sym4_multires'...
  }, '~/amalthea/data/new_coeffs/');
  get_dists_for_datasets;

  %getAdrianCoeffs;

  get_optimized_lambda_for_datasets;
end
ds = datasets{1};

numShapesPerCat = ds.dimensions(2);
numCategories = 35;
numShapes = 2;

indices = [];
for i = 1:numCategories
  start = (i - 1) * numShapesPerCat + 1;
  stop = start + numShapes - 1;
  indices = [indices start:stop];
end

D = ds.data(indices,:);
L = ds.labels(indices,:);

pairwise_dists = acos(D * D');
bs = bullsEyeScore(pairwise_dists, L, numShapes);
disp(['Benchmark: ' num2str(bs)]);

lambdas = [ 1  ds.bestLambda 0 ];

for lambda = lambdas
  curr_dist_func = @(x,Y) sphere_dist_linassgn_mtx(x, Y, ds.distMatrices, lambda, ds.multires_i);
  pairwise_dists = squareform(pdist(D, curr_dist_func));
  bs_linassgn = bullsEyeScore(pairwise_dists, L, numShapes);
  disp(['Linear assignment: lambda=' num2str(lambda) ', accuracy=' num2str(bs_linassgn)]);
end

