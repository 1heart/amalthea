function [ M ] = karcher_mean(D, kappa)

first = 1;
eps = 0.01;

[n d] = size(D);
M = D(1,:);

iter = 0;

while 1
  iter = iter + 1;
  newG = zeros(1, d);
  for i = 1:n
    newG = newG + log_map(M, D(i,:));
  end
  newG = newG * kappa / n;

  if first
    first = 0;
    G = newG;
  else
    if norm(G - newG) < eps
      break;
    else
      G = newG;
    end
  end
  M = exp_map(M, G);
end

end
