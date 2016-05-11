function [result] = ThreeX(N)

maximum = N;
numsteps = 1;

% disp(N)

while N ~= 1
  numsteps = numsteps + 1;
  if mod(N, 2) == 0
    N = N / 2;
  else
    N = 3 * N + 1;
  end
  if N > maximum
    maximum = N;
  end
  % disp(N)
end

result = [N, maximum, numsteps];

end
