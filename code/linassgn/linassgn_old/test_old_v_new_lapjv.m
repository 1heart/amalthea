addpath('..'); startup;

n = 1000;
costMatrix = round(rand(n) * 1000);

% x = (1:n)';
% y = randperm(n)';
% costMatrix = x * y';

disp(['Number of unique elements: ' num2str(length(unique(costMatrix)))]);
curr = lapjv(costMatrix); old = lapjv_old(costMatrix);
if ~isequal(curr, old)
  disp('Curr permutation is not equal to the old permutation!');
  curr_idx = sub2ind(size(costMatrix), 1:n, curr);
  old_idx = sub2ind(size(costMatrix), 1:n, old);
  curr_sum = sum(costMatrix(curr_idx));
  old_sum = sum(costMatrix(old_idx));
  disp(['Curr sum: ' num2str(curr_sum)]);
  disp(['Old sum: ' num2str(old_sum)]);
  if curr_sum == old_sum
    disp('But the values are the same; both are valid permutations');
  end
end

