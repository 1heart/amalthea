function [ M ] = karcher_mean(D, kappa)

first = 1;
eps = 0.01;

[n d] = size(D);
M = D(1,:);

iter = 0;

while 1
  iter = iter + 1;
  newGamma = zeros(1, d);
  for i = 1:n
    newGamma = newGamma + log_map(M, D(i,:));
  end
  newGamma = newGamma * kappa / n;

  if first
    first = 0;
    gamma = newGamma;
  else
    if norm(gamma - newGamma) < eps
      break;
    end
  end
  M = exp_map(M, gamma);
end

end
