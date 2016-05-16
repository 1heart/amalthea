function [A] = matrix_maker_rect(varargin)

x = varargin{1};
y = 0;

if nargin == 1
  y = x;
else
  y = varargin{2};
end

A = zeros(x, y);

for i = 1:x;
  for j = 1:y;
    A(i,j) = abs(i - j);
  end
end


