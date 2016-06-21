function [M] = process_matrix(M)

M = M - min(M(:));
M = M ./ max(M(:));
M = M * 1e4;
M = round(M);

histogram(M)

end
