costMatrix = round(rand(400) * 1000);
disp(['Number of unique elements: ' num2str(length(unique(costMatrix)))]);
curr = lapjv(costMatrix); old = lapjv_old(costMatrix);
if ~isequal(curr, old)
  disp('Old value is not equal to new value!');
  normedDiff = norm(curr - old);
  disp(['Normed difference is ' num2str(normedDiff)]);
end
