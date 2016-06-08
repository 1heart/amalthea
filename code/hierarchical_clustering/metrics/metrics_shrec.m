%--------------------------------------------------------------------------
% Function:    metrics_shrec
% Description: Runs SHREC metrics.
%   Adapted from MATLAB evaluation code from
%   http://www.itl.nist.gov/iad/vug/sharp/contest/2015/Range/results.html
% 
% Inputs: 
%
% distMatrix       - A pairwise distance matrix
%                     where d(i,j) == distance from point i to j
%
% trueLabels       - The true clusters each point is in.
% 
% Outputs
% 
% metricObject     - A map from 'metric' to a value.
%
% Usage: Used in hierarchical clustering on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function metricObject = metrics_shrec(distMatrix, trueLabels, DISPLAY, currColor)

% Default to not displaying data
if nargin < 4
  currColor = 'b';
end
if nargin < 3
  DISPLAY = 0;
end

[n m] = size(distMatrix);
if n ~= m
  error('Distance matrix not square!');
end

classes = unique(trueLabels);
countPerClass = histc(trueLabels, classes);

Retrieval_Statistics = struct('NearestNeighbor',{},'FirstTier',{},'SecondTier',{},'Emeasure',{},...
    'Fmeasure',{}, 'Precision', {}, 'Recall', {}, 'AveragePrecision', {},...
    'DiscountedCumulativeGain',{});

for i = 1:n
  dists = distMatrix(i,:);
  trueLabel = trueLabels(i);
  [dists, indicesByDists] = sort(dists);
  matched_retrieved = trueLabels(indicesByDists) == trueLabel;
  class_size = countPerClass(trueLabel);
  Retrieval_Statistics(i) = get_retrieval_statistics(matched_retrieved, class_size);
end

% Calculate average statistics
Average_NN = mean([Retrieval_Statistics(:).NearestNeighbor]);
Average_FT = mean([Retrieval_Statistics(:).FirstTier]);
Average_ST = mean([Retrieval_Statistics(:).SecondTier]);
Average_E = mean([Retrieval_Statistics(:).Emeasure]);
Average_F = mean([Retrieval_Statistics(:).Fmeasure]);
Average_AP = mean([Retrieval_Statistics(:).AveragePrecision]);
Average_DCG = mean([Retrieval_Statistics(:).DiscountedCumulativeGain]);

Average_Precision_Curve = mean([Retrieval_Statistics(:).Precision],2);
Recall = [1:class_size]/class_size;

% Display and graph the results
if DISPLAY
  display('Average retrieval statistics: ');
  display(['Nearest Neighbor: ' num2str(Average_NN)]);
  display(['First Tier: ' num2str(Average_FT)]);
  display(['Second Tier: ' num2str(Average_ST)]);
  display(['E-measure: ' num2str(Average_E)]);
  display(['F-measure: ' num2str(Average_F)]);
  display(['Average Precision: ' num2str(Average_AP)]); 
  display(['DiscountedCumulativeGain: ' num2str(Average_DCG)]);

  % plot(Recall,Average_Precision_Curve,'-o');
  plot(Recall,Average_Precision_Curve,strcat('-o',currColor));
  xlabel('Recall');
  ylabel('Precision');
  title('Precision-Recall Curve');
  hold on;
end

% Construct resulting map
keySet = {'avg_nearest_neighbor', 'avg_first_tier', 'avg_second_tier', 'avg_e_measure', 'avg_f_measure', 'mean_avg_precision', 'avg_dcg', 'avg_precision_curve', 'recall'};
valueSet = {Average_NN, Average_FT, Average_ST, Average_E, Average_F, Average_AP, Average_DCG, Average_Precision_Curve, Recall};
metricObject = containers.Map(keySet, valueSet);

end
