D = [1 0 0; 0 1 0; 0 0 1;];
L = [1; 1; 2;];

tree_constructors = {@meantree, @meantree2, @link_tree};
metrics = {@precision_recall};

metric_results = {};

for i = 1:length(tree_constructors)
  metric_results{i} = eval_tree(D, L, metrics, tree_constructors{i});
end

