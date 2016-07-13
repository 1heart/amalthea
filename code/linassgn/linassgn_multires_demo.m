datasets = getDatasets({
  'mpeg_7_haar_multires'
});
get_dists_for_datasets;
ds = datasets{1};

lambda = 1000;
a = 1; b = 451;
viewangles = [180 85];
curr_colormap = jet;
n_levels = length(ds.multires_i);

x = ds.data(a,:)';
y = ds.data(b,:)';

for res_level = 1:size(ds.multires_i,1)
  nTrans = ds.numTranslatesCell{res_level};
  curr_range = ds.multires_i(res_level, 1):ds.multires_i(res_level, 2);
  x_curr = x(curr_range); y_curr = y(curr_range);
  warped_img = linassgn_warp(x_curr, y_curr, ds.distMatrices{res_level}, lambda);

  offset = (res_level - 1) * 3;

  subplot(n_levels,3,offset + 1);
  reshaped_x = reshape(x_curr, nTrans);
  surf(reshaped_x); shading interp; colormap(curr_colormap); grid off; ; view(viewangles);

  subplot(n_levels,3,offset + 2);
  reshaped_warp = reshape(warped_img, nTrans);
  surf(reshaped_warp); shading interp; colormap(curr_colormap); grid off; ; view(viewangles);

  subplot(n_levels,3,offset + 3);
  reshaped_y = reshape(y_curr, nTrans);
  surf(reshaped_y); shading interp; colormap(curr_colormap); grid off; ; view(viewangles);

end

