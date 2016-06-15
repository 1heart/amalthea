% -------------------------------------------------------------------------
% Script: run_metrics
% Author:   Mark Moyou (mmoyou@my.fit.edu)
%       Yixin Lin (yixin1996@gmail.com)
%       Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This driver runs the metrics on
%   different types of trees construction methods.
% Usage:
%   This program is used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

DEBUG = 1;    % Boolean if printing out values
SAVE = 0;     % Boolean for saving the results to subdirectory 'results/'
DISPLAY = 1;  % Boolean for displaying the results of the metrics

% Method headers for tree constructors
tree_constructors = {
  @meantree, %  Divisive tree
  @meantree2, % Agglomerative tree
  @link_tree, % MATLAB linkage tree
};
nontree_evals = {
  @eval_supervised_mean_retrieval % Model-to-mean evaluation
  @eval_unsupervised_kmeans % Model-to-mean evaluation
};
% Method headers for the types of metrics being ran
use_metrics = {
  @metrics_shrec,
  % @metrics1, (deprecated)
  % @metrics2, (deprecated)
};

% Load the datasets if necessary
if ~exist('datasets') datasets = getDatasets; end;

%% Run metrics on datasets

metric_results = {};

for i = 1:length(datasets)
  curr = datasets{i}; % Grab the current dataset struct object
  metric_result = {};
  for j = 1:length(tree_constructors) % Run eval_tree using for each tree constructor
    metric_result{j} = eval_tree(curr.data, curr.labels, use_metrics, tree_constructors{j}, DEBUG, DISPLAY);
  end
  for j = 1:length(nontree_evals) % Run the nontree evaluation
    curr_evaluator = nontree_evals{j};
    metric_result{length(metric_result) + 1} = curr_evaluator(curr.data, curr.labels, use_metrics, 0, 1);
  end
  metric_results{i} = metric_result;
  if SAVE % Save the results if necessary
    eval([curr.name ' = metric_results{' num2str(i) '};']);
    save(strcat('results/', curr.name), curr.name);
  end
end
