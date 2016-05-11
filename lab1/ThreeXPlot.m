a = 2;
b = 100;


N = 1:b
results = zeros(2, b);

for i = a:b
  curr = ThreeX(i);
  % Max value
  results(1, i) = curr(2);
  % Number of steps until 1
  results(2, i) = curr(3);
end

figure
title('Plot of N vs. number of steps taken')
xlabel('N')
ylabel('Number of steps')
plot(N, results(1, :))


figure
title('Plot of N vs. number maximum value attained')
xlabel('N')
ylabel('Maximum value obtained')
plot(N, results(2, :))


figure
title('Plot of number of steps vs. maximum value')
xlabel('Number of steps')
ylabel('Maximum value')
scatter(results(2, :), results(1, :))

