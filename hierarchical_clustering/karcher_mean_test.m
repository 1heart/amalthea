D = [1 0 0; 1 0 0]; % Same vectors
%D = [1 2 3; 2 1 3]; % Random vectors
%D = [0 1 0  ; 1 0 0]; % Orthogonal vectors
%D = [-1 0 0  ; 1 0 0]; % Opposite vectors
%D = rand(5,4); % Random vectors in higher dimensions


% Normalize data
for i = 1:size(D,1)
  D(i,:) = D(i,:)/norm(D(i,:));
end

other_mean = sum(D);
other_mean = other_mean / norm(other_mean);

result = karcher_mean(D, 1);

disp( [ 'Difference between normalized-sum mean and karcher mean: ' num2str(norm(result - other_mean)) ] )

