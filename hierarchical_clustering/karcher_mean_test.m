D = rand(5,4);

for i = 1:size(D,1)
  D(i,:) = D(i,:)/norm(D(i,:));
end

result = karcher_mean(D, 0.01);

