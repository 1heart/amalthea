function d = sphere_dist_linassgn(x, y, lambda)

if (~isvector(x) || ~isvector(y)) error('Not vector inputs!'); end;
if (~isequal(length(x), length(y))) error('Not equal size vectors!'); end;

% Make vectors column vectors
if size(x,1) == 1 x = x'; end;
if size(y,1) == 1 y = y'; end;

% Default lambda value = 1
if (nargin < 3) lambda = 1; end;
n = length(x);

% Create distance matrix
D = zeros(n);
for i = 1:n
  for j = 1:n
    D(i,j) = abs(i-j);
  end
end

% Create cost matrix

C = zeros(n);
for i = 1:n
  for j = i:n
    C(i,j) = abs(x(i) - y(j));
    C(j,i) = C(i,j);
  end
end

% C = x * y' + lambda * D;
C = C + lambda * D;
[rowsol, cost] = lapjv(C);

d = sphere_norm(x(rowsol), y);

end
