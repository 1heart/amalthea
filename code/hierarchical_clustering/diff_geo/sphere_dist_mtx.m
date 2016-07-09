function [thetas] = sphere_dist_mtx(x,Y)
if ~isvector(x) error('x is not a vector!'); end;
if (size(x,1) ~= 1) x = x'; end;
Y = Y';
if (length(x) ~= size(Y,1)) error('Y is not the right shape!'); end;
thetas = acos(x * Y);
end
