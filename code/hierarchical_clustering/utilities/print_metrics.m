% -------------------------------------------------------------------------
% Script: print_metrics
% Author: 	Mark Moyou (mmoyou@my.fit.edu)
% 			Yixin Lin (yixin1996@gmail.com)
% 			Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This prints the metrics associated with a metric object
% 				(defined in run_metrics.m)
% Usage: This is used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------
prefix = 'results/';

result_vars = {'brown_123'  'brown_125' 'mpeg7_123' 'mpeg7_125'  'shrec11_123'  'shrec11_125'};

metrics = {
	'avg_dcg',
	'avg_e_measure',
	'avg_f_measure',
	'avg_first_tier',
	'avg_nearest_neighbor',
	'avg_second_tier',
	'mean_avg_precision',
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
