%--------------------------------------------------------------------------
% Function:    generateBivarNormalDist
% Description: generates normal distribution
%
% Inputs:
% N                   - size of the sample
% Outputs:
% temp                - sample
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%   Mark Moyou(mmoyou@my.fit.edu)
%   March 04,2013
%--------------------------------------------------------------------------
function temp = generateBivarNormalDist(N,SIGMA,MEAN)


% Generate four bivariate normal distributions with specified means
% temp = mvnrnd([-3 0], SIGMA,N);
% temp(:,3:4) = mvnrnd([-3 0],SIGMA,N);
% temp(:,5:6) = mvnrnd([3 0], SIGMA, N);
% temp(:,7:8) = mvnrnd([6 0], SIGMA, N);

temp = mvnrnd(MEAN, SIGMA,N);