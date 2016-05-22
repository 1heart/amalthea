function [theta] = sphere_norm(x,y)
theta = acos(sum(x.*y));
end
