figure

subplot(3, 2, 1)
X = -5:0.1:5;
Y = arrayfun(@cos, -5:0.1:5);
scatter(X, Y);

subplot(3, 2, 2)
X = -5:0.1:5;
Y = X.^2 + 2*X - 1;
scatter(X, Y);


subplot(3, 2, 3)
X = -5:0.1:5;
Y = -5:0.1:5;
scatter(X, X.^2 + X*Y' + Y.^2)

subplot(3, 2, 4)
[X, Y] = meshgrid(-5:0.1:5);
Z = cos(abs(X) + abs(Y) .* (abs(X) + abs(Y)));
mesh(Z)

subplot(3, 2, 5)
[X, Y] = meshgrid(-5:0.1:5);
Z = cos(X)^2 + cos(Y)^2;
surf(Z);

subplot(3, 2, 6)
[X, Y] = meshgrid(-5:0.1:5);
Z = cos(X)^2 + sin(Y)^2;
surf(Z);
