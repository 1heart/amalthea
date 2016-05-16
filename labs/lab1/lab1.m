%% Exercise 1, 2

total = 0;
n = 1000;

for i = 1:n
  total = total + i;
end

% disp(total)

%% Exercise 3

total = 0;
n = 400;

for i = 1:n
  total = total + i^2;
end

% disp(total)

%% Exercise 4

total = 0;
n = 249;

for i = 1:n
  total = total + (i * (i + 1));
end

%% Exercise 5, 6

% disp(total)

total = 1;
n = 10;

for i = 1:n
  total = total * i;
end

% disp(total)

%% Exercise 7

total = 0;
n = 10;

for i = 1:n
  total = total + i^i;
end

% disp(total)

%% Exercise 8

total = 1;
n = 10;

for i = 1:n
  total = total + (1 / factorial(i));
  % disp(total);
end

%% Exercise 9

total = 0;
n = 300;

for i = 1:n
  total = total + i;
  if (i / 20) == round(i/20)
    % disp(i);
  end
end

%% Exercise 10, 11

n = 8;

A = zeros(n);

for i = 1:n;
  for j = 1:n;
    % A(i,j) = abs(i - j);
    A(i,j) = abs(j - i - 1);
  end
end

disp(A);

%% Exercise 12

n = 0;
total = 0;

while total < 1000000
  n = n + 1;
  total = total + n;
end

% disp(n)

%% Exercise 14.1

x = randn(100, 1);

%% Exercise 14.2

B = randi(201, 100, 1) - 101;

%% Exercise 14.3

for i = size(B)
  if B(i) < 0
    B(i) = 0;
  end
end

%% Exercise 14.4

TrueLabel = round(rand(100, 1));
TrueLabel = TrueLabel - (TrueLabel == 0);
GenLabel = round(rand(100, 1));
GenLabel = GenLabel - (GenLabel == 0);

incorrect = abs(TrueLabel - GenLabel) / 2;
correct = ones(size(TrueLabel)) - numIncorrect;
numIncorrect = sum(incorrect);
numCorrect = sum(correct);



