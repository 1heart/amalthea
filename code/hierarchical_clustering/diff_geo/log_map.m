function [ gamma ] = log_map(ro1, ro2)

ro_tilde = ro2 - dot(ro2, ro1) * ro1;
gamma = ro_tilde / norm(ro_tilde) * acos(dot(ro1, ro2));
if isnan(gamma)
  gamma = zeros(size(gamma));
end

end
