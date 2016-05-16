I = imread('lena.jpg');
compressed = vectorQuantization(I, 4, [2, 2]);
imwrite(compressed, 'lena_out.jpg');
