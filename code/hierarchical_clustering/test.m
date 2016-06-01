%%%% Test results of random permutations
% numCategories = 70; numShapesPerCategory = 20;

% n = 1400; d = 13000;

% distMatrix = nan(n);
% for i = 1:n
%   distMatrix(i,:) = randperm(n);
% end

% trueLabels = kron(1:numCategories, ones(1,numShapesPerCategory))';

% metrics_shrec(distMatrix, trueLabels, 1);

%% Test t_retrieve on small dataset

% n = 4;
% D = [1 0 0; 1 0 0; 0 1 0; 0 1 0;];
% T = meantree(D);
% [ids dists] = t_retrieve(T, D(3,:), 4)

%% Test t_retrieve on larger dataset

% n = 1400; d = 14000;
% D = normr(rand(n,d));
% T = meantree(D, 1);

%% Test perfect retrieval

numCategories = 70;
numShapesPerCategory = 20;
n = numCategories * numShapesPerCategory;
trueLabels = kron(1:numCategories, ones(1,numShapesPerCategory))';
distMatrix = nan(n);
for i = 1:n
  trueLabel = trueLabels(i);
  distMatrix(i,:) = abs(trueLabels - trueLabel);
end
metrics_shrec(distMatrix, trueLabels, 1);

