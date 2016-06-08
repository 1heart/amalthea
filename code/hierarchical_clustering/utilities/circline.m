% Copied and modified from http://www.mathworks.com/matlabcentral/newsreader/view_thread/277881
% Code by Roger Stafford

function [] = circline(v1, v2, color)

if nargin < 3
  color = [0 0 0];
end

if size(v1,1) == 1 v1 = v1'; end;
if size(v2,1) == 1 v2 = v2'; end;

x0 = 0; y0 = 0; z0 = 0;
 r = norm(v1); % The radius
 v3 = cross(cross(v1,v2),v1); % v3 lies in plane of v1 & v2 and is orthog. to v1
 v3 = r*v3/norm(v3); % Make v3 of length r
 % Let t range through the inner angle between v1 and v2
 t = linspace(0,atan2(norm(cross(v1,v2)),dot(v1,v2))); 
 v = v1*cos(t)+v3*sin(t); % v traces great circle path, relative to center
 plot3(v(1,:)+x0,v(2,:)+y0,v(3,:)+z0, 'Color',color) % Plot it in 3D
end
