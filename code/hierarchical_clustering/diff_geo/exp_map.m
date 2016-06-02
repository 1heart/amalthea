function [ ro2 ] = exp_map(ro1, gamma)

gmu = norm(gamma);
ro2 = cos(gmu) * ro1 + sin(gmu) * gamma / gmu;

if isnan(ro2)
  ro2 = ro1;
end

end
