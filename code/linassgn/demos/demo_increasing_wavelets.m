datasets = getDatasets('mpeg_7_haar_singleres');
get_dists_for_datasets;
ds = datasets{1};
viewangles = [180 55];
curr_colormap = pink;

curr = ds.data(1,:)';
curr = reshape(curr, ds.numTranslatesCell{1});
curr = fliplr(flipud(curr));
figure;
max_z = 5*max(curr(:));
for i = 1:10
  curr = curr .* 1.1;
  surf(curr); shading interp; colormap(curr_colormap); grid off; axis off; view(viewangles);
  zlim([0 max_z]);
  pause;
end

