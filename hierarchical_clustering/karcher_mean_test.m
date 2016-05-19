%D = [0 1 0  ; 1 0 0];
D = rand(5,4);


for i = 1:size(D,1)
  D(i,:) = D(i,:)/norm(D(i,:));
end

other_mean = sum(D);
other_mean = other_mean / norm(other_mean);

result = karcher_mean(D, 1);

disp( [ 'Difference between normalized-sum mean and karcher mean: ' num2str(norm(result - other_mean)) ] )

