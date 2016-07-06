function dists = sphere_dist_linassgn_mtx(x, Y, distMatrices, lambdas, multires_i)

[n d] = size(Y);
dists = nan(n,1);
for i = 1:n
  dists(i) = sphere_dist_linassgn(x, Y(i,:), distMatrices, lambdas, multires_i);
end

end

