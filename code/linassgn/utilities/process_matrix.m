function [M] = process_matrix(M, a, b)

scale = 10000;
if nargin < 2
  scale = scale / max(M(:).^2);
else
  scale = scale / max([a(:).^2; b(:).^2]);
end

M = (M * scale);

% histogram(M)

end
