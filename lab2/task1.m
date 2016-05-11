D = meas(:, 3:4);
gscatter(D(:,1), D(:,2), species,'rgb','osd');
kmeans(D, 3);


