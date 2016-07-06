% load('~/amalthea/data/MPEG7APCoeffs');
% coeffs = coeffCell(:,1);
% n = length(coeffs);
% d = length(coeffs{1});
% D = zeros(n,d);
% for i = 1:n
%   coeff = coeffs{i};
%   D(i,:) = coeff';
% end
% datasets = getDatasets({'mpeg7_123'});
% L = datasets{1}.labels;

a = getDatasets('mpeg_7_haar_singleres');
D = a{1}.data; L = a{1}.labels;
[n d] = size(D);

pairwise_dists = acos(D * D');
count = 0; total = n * (n-1) / 2;
bullsEyeScore(pairwise_dists, L, 20)



