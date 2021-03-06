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

% numCategories = 70;
% numShapesPerCategory = 20;
% n = numCategories * numShapesPerCategory;
% trueLabels = kron(1:numCategories, ones(1,numShapesPerCategory))';
% distMatrix = nan(n);
% for i = 1:n
%   trueLabel = trueLabels(i);
%   distMatrix(i,:) = abs(trueLabels - trueLabel);
% end
% metrics_shrec(distMatrix, trueLabels, 1);


%% Test good retrieval

DEBUG = 1;

kappas = [1 10 100 1000];
colors = ['k' 'r' 'b' 'g'];

for i = 1:length(kappas)
    numClusters = 4;
    kappa = kappas(i);
    currColor = colors(i);
    dist = 10;
    means1 = [0 1 2 3] * pi / dist;
    % means2 = [0 0 0 0];
    [D, meanMatrix, trueLabels] = random_spherical_data(numClusters, numPoints, kappa, means1, means2);
    n = numClusters * numPoints;
    memMatrix = trueLabels;
    dataMatrix = D;
    T = meantree(D, DEBUG);

    distMatrix = nan(n);

    textprogressbar('Calculating distance measure: ');
    for i = 1:n
      [ids dists] = t_retrieve(T, D(i,:), n);
      textprogressbar(100*i/n);

      % Construct a distance measure based on order:
      % If an element e is at position j, then it has
      % j distance from the query shape
      for j = 1:n
        distMatrix(i, ids(j)) = j;
    end
  end
  textprogressbar(' done.');

  metrics_shrec(distMatrix, trueLabels, 1, currColor);
end

% figure;

%   [sx, sy, sz] = sphere;
%     surface(sx,sy,sz,'FaceColor', zeros(3,1)+1,'EdgeColor',zeros(3,1)+0.8);

%     hold on;
%   scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),50,memMatrix, 'filled'); % clustered points
%   % draw_tree(T);


