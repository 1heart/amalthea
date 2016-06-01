colors = [
88 140 115;
242 227 148;
242 174 114;
217 100 89;
140 70 70;
] / 255;
colormap(colors);



numClusters = 5;
numPoints = 10;
kappa = 200; % concentration parameter
numRuns = 1;
[dataMatrix, meanMatrix, memMatrix] = random_spherical_data(numClusters, numPoints, kappa);

T = meantree(dataMatrix);
% [T C] = meantree2(dataMatrix);

graph = 1;

if graph
% Graph transparent sphere
  [sx, sy, sz] = sphere;
  surface(sx,sy,sz,'FaceColor', zeros(3,1)+1,'EdgeColor',zeros(3,1)+0.8);
  hold on;

% Graph data
  scatter3(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),50,memMatrix, 'filled'); % clustered points
  % hold on;
  % scatter3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),100,'k','x'); % true means
  % hold on;
  draw_tree(T);

end

