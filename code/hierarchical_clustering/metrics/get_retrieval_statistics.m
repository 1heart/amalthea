function retSTATS = get_retrieval_statistics(matched_retrieved,class_size)

num_retrieved = length(matched_retrieved);
cum_matched_retrieved = cumsum(matched_retrieved);

k = [1:num_retrieved];
k = k(:);

precision_k = cum_matched_retrieved./k;
recall_k = cum_matched_retrieved/class_size;

% Nearest neighbour
NN = matched_retrieved(1);

% First tier and Second tier
% K = |C| ? 1 for the first tier, and K = 2 *(|C| ? 1) for the second tier. 
FT = recall_k(class_size-1);
ST = recall_k(2*(class_size-1));


if num_retrieved >= 32
  % F and E measures at k = 32
  if not((precision_k(32) + recall_k(32))==0)
      Fmeasure = 2*precision_k(32)*recall_k(32)/(precision_k(32) + recall_k(32));
  else
      Fmeasure = 0;
  end;
else
  Fmeasure = nan;
end;

Emeasure = 1 - Fmeasure;

% Precision and Recall
precision = precision_k(matched_retrieved == 1);
recall = recall_k(matched_retrieved == 1);

% Average Precision
AveP = mean(precision);

% Discounted Cumulative Gain
DCG_k = matched_retrieved(1) + sum(matched_retrieved(2:end)./log2(k(2:end)));
DCG_max = 1 + sum(1./log2(k(2:class_size)));
DCG = DCG_k/DCG_max;

retSTATS = struct('NearestNeighbor',NN,'FirstTier',FT,'SecondTier',ST,'Emeasure',Emeasure,...
    'Fmeasure', Fmeasure, 'Precision', precision, 'Recall', recall, 'AveragePrecision', AveP,...
    'DiscountedCumulativeGain',DCG);

