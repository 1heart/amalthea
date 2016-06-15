clear; clc; close all;

a = [1,1,1,8,7,7,9, 4,5, 12,12]'

numRows = 100;
datax = repmat(a,numRows,1);
samps = [datax, datax, datax];


h1 = 2*iqr(samps(:,1))*length(samps(:,1))^(-1/3);
h2 = 2*iqr(samps(:,2))*length(samps(:,2))^(-1/3);
h3 = 2*iqr(samps(:,3))*length(samps(:,3))^(-1/3);
h  = max([h1,h2,h3]);
bins{1} = min(samps(:,1)) : h : max(samps(:,1))+h;
bins{2} = min(samps(:,2)) : h : max(samps(:,2))+h;
bins{3} = min(samps(:,3)) : h : max(samps(:,3))+h;

bins{1}

[N edges mid loc] = histcn(samps,bins{1}, bins{2}, bins{3});

indd = sub2ind(size(N), loc(:,1), loc(:,2), loc(:,3));

retCounts = N(indd);

nonZeroRetCounts = sum(retCounts == 0)
