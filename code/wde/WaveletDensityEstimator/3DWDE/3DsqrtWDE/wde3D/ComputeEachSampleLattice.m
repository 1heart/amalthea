function [sampleLattice] = ComputeEachSampleLattice(vect,supp,startLevel,coefficients,transCel)
%
dim = length(vect);
% generate the string for the lattice of the translates
[str] = createSrings(dim,'d');

% Acess the output of the ngrid
[st] = createSrings(dim,'X');
% evaluate the rectangular grid in N-D space using ndgrid

for i = 1: dim
    % access each sample value ( as a feature )
    eachSample = vect(i);
    % call translateschecking Function
    relevantKs(i,:) = translatesChecking1(eachSample,supp,startLevel,coefficients,transCel{i,1});
    eval(['d' num2str(i),' = relevantKs(i,:);']);
end

eval(['[',st,'] = meshgrid(',str,');']); % WATCH OUT FOR THE N GRID IT IS DIFFERENT FROM MESHGRID

%eval(['[',st,'] = ndgrid(',str,');']); % WATCH OUT FOR THE N GRID IT IS DIFFERENT FROM MESHGRID
 % 
[str0] = createSrings(dim,'n');
 % create the grid for point "vect"
for j = 1: dim
    eval(['n' num2str(j),' = X',num2str(j),'(:);']);
end
 
  eval(['sampleLattice',' =','[' str0,'];'])
  
  %VERY IMPORTANT!!!!!!!!!!!!!!
  % Watch out : if u use meshgrid at the begining of your code  for
  % setting the tranaltes tarnsCel u have to stick with it till the ned
  % because mesgrid and ndgrid gives different lattice setting