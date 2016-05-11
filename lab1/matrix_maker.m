function [A] = matrix_maker(N)
A = zeros(N);

for i = 1:N;
  for j = 1:N;
    A(i,j) = abs(i - j);
  end
end


