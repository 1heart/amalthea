clear all;
close all;
fclose all;

RANK_LISTS_DIR = 'C:\HELIN\0_SHREC_2015\CODES\RANK_LIST_FILES\random_alg\';

load query_labels_2015;
load target_labels_2015;

num_queries = size(query_labels_2015,1);
num_targets = size(target_labels_2015,1);
class_size = 20;

% arrange target labels for easy acces
target_labels_sorted = zeros(num_targets,1);
for t = 1:num_targets;
    target_name = target_labels_2015{t,1};
    target_no = str2num(target_name(2:end));
    target_label = str2num(target_labels_2015{t,2});
    target_labels_sorted(target_no) = target_label;
end;
clear target_name;
clear target_no;
clear target_label;

Retrieval_Statistics = struct('NearestNeighbor',{},'FirstTier',{},'SecondTier',{},'Emeasure',{},...
    'Fmeasure',{}, 'Precision', {}, 'Recall', {}, 'AveragePrecision', {},...
    'DiscountedCumulativeGain',{});

for query_no = 1:num_queries;
    
    query_name = ['RQ' sprintf('%05d',query_no)];
    filename = [RANK_LISTS_DIR query_name];
    
    query_label = str2num(query_labels_2015{query_no,2});
    
    fid = fopen(filename,'r');
    fline = fgetl(fid);
    q_name = strtok(fline);
    if not(isequal(q_name,query_name));
        error('Query name in rank list file does not match the filename');
    end;
    
    TS = textscan(fid, '%s %f');
    fclose(fid);
    
    target_rank_list_names = TS{1};
    target_model_scores = TS{2};
    
    if not(isequal(target_model_scores,sort(target_model_scores)));
        error('Target models are not listed in ascending score order');
    end;
    
    target_rank_list_no_s = zeros(num_targets,1);
    for t = 1:num_targets;
        target_name = target_rank_list_names{t};
        target_no = str2num(target_name(2:end));
        target_rank_list_no_s(t) = target_no;
    end;
    
    sorted_labels = target_labels_sorted(target_rank_list_no_s);
 
    matched_retrieved = sorted_labels == query_label;
    
    retSTATS = get_retrieval_statistics(matched_retrieved,class_size);
    
    Retrieval_Statistics(query_no) = retSTATS;
    
end;


% CALCULATE AVERAGE STATISTICS
Average_NN = mean([Retrieval_Statistics(:).NearestNeighbor]);
Average_FT = mean([Retrieval_Statistics(:).FirstTier]);
Average_ST = mean([Retrieval_Statistics(:).SecondTier]);
Average_E = mean([Retrieval_Statistics(:).Emeasure]);
Average_F = mean([Retrieval_Statistics(:).Fmeasure]);
Average_AP = mean([Retrieval_Statistics(:).AveragePrecision]);
Average_DCG = mean([Retrieval_Statistics(:).DiscountedCumulativeGain]);

Average_Precision_Curve = mean([Retrieval_Statistics(:).Precision],2);
Recall = [1:class_size]/class_size;

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

