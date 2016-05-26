D = [1 0 0; 0 1 0; 0 0 1;];

eval_tree_type_funcs = {};
metrics = {};

metric_results = [];

for i = 1:length(eval_tree_type_funcs)
  curr_eval_func = eval_tree_type_funcs{i};
  metric_results = [metric_results curr_eval_funcs(D, metrics)];
end

