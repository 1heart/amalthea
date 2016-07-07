DEBUG = 1;
datasets = getDatasets({'mpeg7_123'});
branchingFactors = [10 7 5 2 2];
% datasets = getDatasets({'shrec11_125'});
% branchingFactors = [30];

D = datasets{1}.data;
[n d] = size(D);
L = datasets{1}.labels;

T = meantree_supervised(D, branchingFactors, 1:n);

distMatrix = zeros(n);
if DEBUG textprogressbar('Retrieving tree: '); end;
for i = 1:n
  if DEBUG textprogressbar(100 * i / n); end;
  [ids dists] = t_retrieve(T, D(i,:), n);
  for j = 1:n
    distMatrix(i, ids(j)) = j;
  end
end
if DEBUG textprogressbar(' done.'); end;
metricObject = metrics_shrec(distMatrix, L, 1);

