% -------------------------------------------------------------------------
% Script: karcher_mean_test
% Author:   Mark Moyou (mmoyou@my.fit.edu)
%       Yixin Lin (yixin1996@gmail.com)
%       Glizela Taino (glizentaino@gmail.com)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% Description: This tests the difference
%   between the Karcher mean and another approximation.
% Usage: Used in hierarchical clustering on the unit hypersphere.
% -------------------------------------------------------------------------

num_iter = 5;
data = cell(num_iter,1);
data_labels = cell(num_iter,1);

data{1, 1} = [1 0 0; 1 0 0; 1 0 0]; % Same vectors
data_labels{1,1} = '3 identical vectors';
data{2, 1} = [1 2 3; 2 1 3]; % Random vectors
data_labels{2,1} = 'Random vectors';
data{3, 1} = [0 1 0  ; 1 0 0]; % Orthogonal vectors
data_labels{3,1} = 'Orthogonal vectors';
data{4, 1} = [-1 0 0  ; 1 0 0]; % Opposite vectors
data_labels{4,1} = 'Opposite vectors';
data{5, 1} = rand(12,3); % Random vectors
data_labels{5,1} = 'Multiple random vectors';

graph = 1;

for iter = 1:num_iter
  D = data{iter,1};

  % Normalize data
  for i = 1:size(D,1)
    D(i,:) = D(i,:)/norm(D(i,:));
  end

  other_mean = sum(D);
  other_mean = other_mean / norm(other_mean);

  k_mean = karcher_mean(D);

  disp( ['Karcher mean: '])
  k_mean
  disp( ['Normalized-sum mean: '])
  other_mean

  disp( [ 'Difference between normalized-sum mean and karcher mean: ' num2str(norm(k_mean - other_mean)) ] )

  if graph
    figure;
    title(data_labels{iter,1});
    % Graph transparent sphere
    [sx, sy, sz] = sphere;
    surface(sx,sy,sz,'FaceColor', 'none','EdgeColor',[0.8 0.8 0.8])
    hold on;

    for i = 1:size(D,1)
      quiver3(0,0,0,D(i,1),D(i,2),D(i,3),'b');
    end
    quiver3(0,0,0,k_mean(1),k_mean(2),k_mean(3),'r');
    quiver3(0,0,0,other_mean(1),other_mean(2),other_mean(3),'g');
    hold off;
  end
end

