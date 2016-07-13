lambda = 1000;


datasets = getDatasets('mpeg_7_haar_singleres');
get_dists_for_datasets;
ds = datasets{1};
D = ds.data;
L = ds.labels;
[n d] = size(D);

a = D(1,:)'; b = D(2,:)'; c = D(21,:)';

for i = 1: n
  for j = i+1:n
    source = D(i,:)'; target = D(j,:)';
    ours = sphere_dist_linassgn(source, target, ds.distMatrices, lambda);
    his = wde2DSlidingDist(source, target, ds.wdeSet, lambda);
    disp(norm(ours - his));
  end
end

