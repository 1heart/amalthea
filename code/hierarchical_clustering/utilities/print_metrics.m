prefix = 'results/';

result_vars = {'brown_123'  'brown_125' 'mpeg7_123' 'mpeg7_125'  'shrec11_123'  'shrec11_125'};

% metrics = {'avg_e_measure_32', 'mean_avg_precision', 'avg_ndcg', 'avg_nearest_neighbor', 'avg_first_tier', 'avg_second_tier'};
metrics = {
'avg_dcg',
'avg_e_measure',
'avg_f_measure',
'avg_first_tier',
'avg_nearest_neighbor',
% 'avg_precision_curve',
'avg_second_tier',
'mean_avg_precision',
% 'recall'
};

for j = 1:length(result_vars)
  curr = result_vars{j};
  load(strcat(prefix, curr));
  metricObject = eval(curr);
  metricObject = metricObject{1};

  fprintf(strcat(curr, ': \n'));
  for i = 1:length(metrics)
    fprintf(metrics{i}); fprintf(': ');
    fprintf(num2str(metricObject(metrics{i}))); fprintf('. ');
  end
fprintf('\n');
end

