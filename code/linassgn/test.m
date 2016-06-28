n = 500;
% costMatrix = round(rand(n) * 1000);

x = (1:n)';
y = randperm(n)';
costMatrix = x * y';

disp(['Number of unique elements: ' num2str(length(unique(costMatrix)))]);
curr = lapjv(costMatrix); old = lapjv_old(costMatrix);
if ~isequal(curr, old)
  disp('Old value is not equal to new value!');
  normedDiff = norm(curr - old);
  disp(['Normed difference is ' num2str(normedDiff)]);
end
