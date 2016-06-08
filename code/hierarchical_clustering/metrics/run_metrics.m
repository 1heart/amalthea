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

if ~exist('datasets') datasets = getDatasets; end;

%% Run metrics on datasets

metric_results = {};

for i = 1:length(datasets)
  curr = datasets{i};
  metric_result = {};
  for j = 1:length(tree_constructors)
    metric_result{j} = eval_tree(curr.data, curr.labels, use_metrics, tree_constructors{j}, DEBUG, DISPLAY);
  end
  for j = 1:length(nontree_evals)
    curr_evaluator = nontree_evals{j};
    metric_result = [metric_result curr_evaluator(curr.data, curr.labels, use_metrics, 0, 1)];
  end
  metric_results{i} = metric_result;
  if SAVE
    eval([curr.name ' = metric_results{' num2str(i) '};']);
    save(strcat('results/', curr.name), curr.name);
  end
end

