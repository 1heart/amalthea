function [groupLabel, centroids] = kmeans(D, k, maxIter)

hold on

[m, n] = size(D);
epsilon = 0.001;

result = zeros(m, 1);
centroids = datasample(D, k, 'Replace', false);
disp(centroids(3))

for iter = 1:maxIter
  labels = cell(k, 1);
  for i = 1:k
    labels{i} = [];
  end
  for i = 1:m
    curr = D(i, :);
    centroidDists = [];
    for j = 1:k
      centroidDists(j) = sum((curr - centroids(j,:)).^2);
    end
    [minVal, minIndex] = min(centroidDists);
    labels{minIndex} = [labels{minIndex}, curr'];
  end
  newCentroids = [];
  for i = 1:k
    newCentroids = [newCentroids, mean(labels{i}, 2)];
  end

  newCentroids = newCentroids';

  diff = sum((centroids - newCentroids).^2);
  if (diff < epsilon)
    break;
  end

  centroids = newCentroids;
  gscatter(centroids(:, 1), centroids(:, 2), 1:k, 'ymc', 'osd');
end

gscatter(centroids(:, 1), centroids(:, 2), 1:k, 'kkk', 'osd');

hold off

groupLabel = labels;

end
