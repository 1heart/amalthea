function [A] = matrix_maker_rect_pt6(x, y)
A = zeros(x, y);

for i = 1:x;
  for j = 1:y;
    A(i,j) = abs(i - j);
  end
end

A = sum(sum(A));


