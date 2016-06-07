function d = sphere_dist_linassgn(x, y, distMatrix, lambda)

if (~isvector(x) || ~isvector(y)) error('Not vector inputs!'); end;
if (~isequal(length(x), length(y))) error('Not equal size vectors!'); end;
n = length(x);
if (~isequal(size(distMatrix), [n n])) error('Distance matrix not nxn!'); end;
% Make vectors column vectors
if (size(x,2) ~= 1) x = x'; end;
if (size(y,2) ~= 1) y = y'; end;

C = -(x * y') + lambda * D; % Construct cost matrix
[rowsol, cost] = lapjv(C); % Get best linear assignment from x to y
d = sphere_norm(x(rowsol), y); % Take the distance between y and the modified x

end
