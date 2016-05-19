function [ ro2 ] = exp_map(ro1, gamma)

gmu = norm(gamma);
ro2 = cos(gmu) * ro1 + sin(gmu) * gamma / gmu;

end
