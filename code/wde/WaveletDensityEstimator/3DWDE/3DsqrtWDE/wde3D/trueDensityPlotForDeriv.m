
%--------------------------------------------------------------------------
% Function:    trueDensityPlot
% Description: plots the true distribution
%
% Inputs:
%   domain            - Domain over which to calculate the density
%                       function.
%  discretization    - Value that the support of the density is
%                       discretized by. 
%   density           - density values 
%   mu                - mean
%   sigma             - covariance
%   dim               - sample dimension
%   r                 - isosurface  value

%  sample             - the data sample
% Outputs:             No outputs
%
% Usage:
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%--------------------------------------------------------------------------
function [r, densityr] = trueDensityPlotForDeriv(domain,discretization,mu,sigma,dim,r)

[st]= createSrings(dim,'do'); % input vect init
[str]= createSrings(dim,'X'); % output vector initaialization

for i = 1 : size(domain,1)
    dom = domain(i,:);
    eval(['do',num2str(i),'= dom(1):discretization:dom(end);'])
end

if dim == 2
    figure (1)
    [X1,X2] = meshgrid(do1, do2);
    X3 = [X1(:) X2(:)];
    % true density values
    p = mvnpdf(X3, mu,  sigma );
    % plot
    surf(X1,X2,reshape(p,size(X1,1),size(X1,2)));
    shading interp;

    %title ([num2str(dim),'D plot of the true density'])
    title(['true density'],'Fontsize', 14);
    xlabel (' x coordinate')
    ylabel (' y coordinate')
    zlabel (' density values')


end

if dim == 3 % r must be really really small
 
    %plotDomain = (domain(1): discretization : domain(2));
    [X1,X2,X3] = meshgrid(do1 ,do2,do3);
    X4 = [X1(:), X2(:), X3(:)];
    % true density values
    densityr = mvnpdf(X4, mu,  sigma );

    figure (1)
    % % reshape density
    densityr = reshape(densityr,size(X1,1),size(X1,2),size(X1,3));
   r = (max(densityr(:))-min(densityr(:)))/2;
   
   r = mean(densityr(:))/100000;
    maxOfTrueDensity = max(densityr(:))
    p = patch(isosurface(X1,X2,X3,densityr,r));
    isonormals(X1,X2,X3,densityr,p);

    set(p,'FaceColor','blue','EdgeColor','none');
    daspect([1,1,1])
    view(3); axis tight
    camlight

    xlabel('x coordinate')
    ylabel('y coordinate')
    zlabel('z cordinate')
    title ([num2str(dim),'D plot of the true density'])
    grid on
    xlabel('x coordinate')  
       
end
