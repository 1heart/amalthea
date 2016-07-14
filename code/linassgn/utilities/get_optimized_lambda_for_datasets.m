if ~exist('datasets') error('Datasets does not exist!'); end;
% get_dists_for_datasets;

LAMBDAS = 10.^[0 1 2 3];
LAMBDAS = [0 LAMBDAS];

for i = 1:length(datasets)
  ds = datasets{i};
  numCats = ds.dimensions(1);
  numShapesPerCat = ds.dimensions(2);
  source = ds.data(1,:)';
  distMatrices = ds.distMatrices;
  multires_i = ds.multires_i;
  sameCategory = ds.data(2,:)';
  otherCategory = ds.data(numShapesPerCat + 1, :)';
  [bestLambda, bestDist] = optimize_lambda(source, sameCategory, otherCategory, distMatrices, LAMBDAS, multires_i);
  datasets{i} = setfield(datasets{i}, 'bestLambda', bestLambda);
end


