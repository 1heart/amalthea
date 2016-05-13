list = dir('data/pict/');

rows = 50;
cols = 50;
data = zeros(rows * cols, length(list) - 2);

for i = 3:length(list)
  imgPath = strcat('data/pict/', list(i).name);
  img = imread(imgPath);
  I = imresize(double(img), [rows, cols]);
  I = double((I(:)));

  data(:, i - 2) = I;
end
data = data';
[V, D] = myPCA(data);
k = 3; % Number of eigenvectors to plot
for i = 1:k
  eigenvector = V(:, i);
  newImg = reshape(eigenvector, [rows cols]);
  newImg = newImg - min(newImg(:));
  newImg = newImg / max(newImg(:));
  figure, imshow(newImg);
end

