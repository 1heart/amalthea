tree_constructors = {@meantree, @meantree2, @link_tree};
metrics = {@precision_recall};

datasets = {};
labels = {};

datasets{1} = [1 0 0; 0 1 0; 0 0 1;];
labels{1} = [1; 1; 2;];

metric_results = {};

for i = 1:length(datasets)
  D = datasets{i};
  L = labels{i};
  metric_result = {};
  for j = 1:length(tree_constructors)
    metric_result{j} = eval_tree(D, L, metrics, tree_constructors{j});
  end
  metric_results{i} = metric_result;
end


