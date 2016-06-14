function [] = linassgn_warp(source, target, distMatrix, lambdas, DISP)

if ~isequal(size(source), size(target)) error('Two images not equal!'); end;
if ~isvector(lambdas) error('Lambda not a vector!'); end;
if size(distMatrix,1) ~= size(distMatrix,2) error('Distance matrix not square!'); end;
if (nargin < 5) DISP = 1; end;
if (DISP) figure; end;

[m n] = size(source); k = length(lambdas);
x = source(:); y = target(:);

for i = 1:k
  lambda = lambdas(i);
  C = -(x * y') + lambda * distMatrix; % Construct cost matrix
  [rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
  x_new = x(rowsol); % Find reconstructed shape
  img = reshape(x_new, [m n]);

  if DISP
    subplot(2, k, i);
    imshow(img);
    title(['Lambda = ' num2str(lambda)]);
  end
end

if DISP
  subplot(2, k, k + 1);
  imshow(source);
  title('Source');
  subplot(2, k, k + 2);
  imshow(target);
  title('Target');
end

end
