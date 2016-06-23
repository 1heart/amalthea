function [M] = process_matrix(M)

M = M - min(M(:));
M = round(M * 1e8./ max(M(:)));

% histogram(M)

end
