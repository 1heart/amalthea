if ~exist('datasets') error('Datasets does not exist!'); end;
get_dists_for_datasets;

lambdas = [0 1e-12 1e-8 1e-4 1e-2 1 2 3 10 ];

for i = 1:length(datasets)
  ds = datasets{i};
  numCats = ds.dimensions(1);
  numShapesPerCat = ds.dimensions(2);
  source = ds.data(1,:)';
  sameCategory = ds.data(2,:)';
  otherCategory = ds.data(numShapesPerCat + 1, :)';
  [bestLambda, bestDist] = optimize_lambda(source, sameCategory, otherCategory, distMatrices, lambdas, multires_i);
  datasets{i} = setfield(datasets{i}, 'bestLambda', bestLambda);
end


