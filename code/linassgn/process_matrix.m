function [M] = process_matrix(M)

M = round(M * 1e4)/max(M(:).^2);

% histogram(M)

end
