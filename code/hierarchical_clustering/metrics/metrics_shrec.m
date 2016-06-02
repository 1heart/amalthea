function metricObject = metrics_shrec(distMatrix, trueLabels, DISPLAY)

% Default to not displaying data
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

  plot(Recall,Average_Precision_Curve,'-o');
  xlabel('Recall');
  ylabel('Precision');
  title('Precision-Recall Curve');
end

% Construct resulting map
keySet = {'avg_nearest_neighbor', 'avg_first_tier', 'avg_second_tier', 'avg_e_measure', 'avg_f_measure', 'mean_avg_precision', 'avg_dcg', 'avg_precision_curve', 'recall'};
valueSet = {Average_NN, Average_FT, Average_ST, Average_E, Average_F, Average_AP, Average_DCG, Average_Precision_Curve, Recall};
metricObject = containers.Map(keySet, valueSet);

end
