function [bestLambda, bestDist] = optimize_lambda(source, sameCategory, otherCategory, distMatrices, lambdas, multires_i)

bestLambda = 0; bestDist = 0; 

for lambda = lambdas
  sameDist = sphere_dist_linassgn(source, sameCategory, distMatrices, lambda, multires_i);
  otherDist = sphere_dist_linassgn(source, otherCategory, distMatrices, lambda, multires_i);
  currDist = abs(sameDist - otherDist);
  if currDist > bestDist
    bestDist = currDist; bestLambda = lambda;
  end
end


end
