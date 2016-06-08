function distMatrix = constructDistMatrix(numTranslates)
% Given a vector of the dimensions of a rectangular prism (2D: [x y], 3D: [x y z]), return the distance matrix for every pair of points inside that prism.

d = length(numTranslates); % Number of dimensions
if (d > 3) error('Too many dimensions in numTranslates array!'); end;
if (d < 3) numTranslates(3) = 1; end;

[xs, ys, zs] = ndgrid(1:numTranslates(1),1:numTranslates(2), 1:numTranslates(3));
pts = [xs(:), ys(:), zs(:)];
distMatrix = squareform(pdist(pts));

end
