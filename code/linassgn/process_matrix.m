function [M] = process_matrix(M)

M = M - min(M(:));
M = round(M * 1e6./ max(M(:)));

% histogram(M)

end
