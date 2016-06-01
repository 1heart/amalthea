DEBUG = 1;
SAVE = 0;
DISPLAY = 1;

tree_constructors = {
  @meantree,
  @meantree2,
  @link_tree,
};
use_metrics = {
  @metrics_shrec,
  @metrics1,
  @metrics2,
};

prefix = '/Users/yixin/amalthea/data/';
datasetPaths = {
  'Coefficients/Brown/db4r3/range_1_123/Brown_EV_PQA_1_2_3_3D_2r1__WT_db4_RL_3_p1.mat',
  'Coefficients/Brown/db4r3/range_1_125/Brown_PQA_1_2_5_r1_3D_WT_db4_RL_3_p1.mat',
  'Coefficients/MPEG7/db4r3/range_1_123/mpeg7Al_PQA_1_2_3_3D_2r1__WT_db4_RL_3.mat',
  'Coefficients/MPEG7/db4r3/range_1_125/mpeg7Al_PQA_1_2_5_3D_2r1__WT_db4_RL_3.mat',
  'Coefficients/SH11/db4r3/range_1_123/SHREC11_Or_PN_SSPts_GL_PQA_1_2_3_3D_2r1__WT_db4_RL_3.mat',
  'Coefficients/SH11/db4r3/range_1_125/SHREC11_Or_PN_SSPts_GL_PQA_1_2_5_3D_2r1__WT_db4_RL_3.mat',
};
datasetNames = {
  'brown_123',
  'brown_125',
  'mpeg7_123',
  'mpeg7_125',
  'shrec11_123',
  'shrec11_125',
};
datasetDimensions= { % [numCategories, numShapes/category]
  [9, 11],
  [9, 11],
  [70, 20],
  [70, 20],
  [30, 20]
  [30, 20]
};

if length(datasetPaths) ~= length(datasetDimensions)
  error('Not the same number of datasets as dimension vectors!');
end

%% Load datasets

datasets = {};
labels = {};
names = {};

% datasets{1} = [1 0 0; 0 1 0; 0 0 1;];
% labels{1} = [1; 1; 2;];

% datasets{1} = normr(rand(10,10));
% labels{1} = [1 1 2 2 3 3 4 4 5 5]';

for i = 1:length(datasetPaths)
  load(strcat(prefix, datasetPaths{i}));

  n = size(wdeCell,1); d = size(wdeCell{1,1}, 1); D = nan(n,d);
  for j = 1:n
    D(j,:) = wdeCell{j,1}';
  end
  datasets{i} = D;

  dimensions = datasetDimensions{i};
  numCategories = dimensions(1); numShapesPerCategory = dimensions(2);
  labels{i} = kron(1:numCategories, ones(1,numShapesPerCategory))';

  names{i} = datasetNames{i};
end

%% Run metrics on datasets

metric_results = {};

for i = 1:length(datasets)
  D = datasets{i};
  L = labels{i};
  metric_result = {};
  for j = 1:length(tree_constructors)
    metric_result{j} = eval_tree(D, L, use_metrics, tree_constructors{j}, DEBUG, DISPLAY);
  end
  metric_results{i} = metric_result;
  if SAVE
    eval([names{i} ' = metric_results{' num2str(i) '};']);
    save(strcat('results/', names{i}), names{i});
  end
end


