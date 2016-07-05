%--------------------------------------------------------------------------
% Function:    getDensity
% Description: Calculates the probability density function.
%
% Inputs:
%   domain            - Domain over which to calculate the density
%                       function.
%   density           - density values 
%  discretization    - Value that the support of the density is
%                       discretized by. 
%  sample             - the data sample
% Outputs:
%  density            - density values on the lattice
%
% Usage:
%
% Authors(s):
%   Eddy Ihou(ihouk2002@my.fit.edu)
%   Mark Moyou(mmoyou@my.fit.edu)

%--------------------------------------------------------------------------

function [densityr] = density3DPlot(X1,X2,X3,density,r)

% plotDomain = (domain(1): discretization : domain(2));
% [X,Y,Z] = meshgrid(plotDomain ,plotDomain,plotDomain);

figure (30) % square root of the density
% reshape density
densityr = reshape(density,size(X1,1),size(X1,2),size(X1,3));
% density
r = (max(densityr(:))-min(densityr(:)))/5;
p = patch(isosurface(X1,X2,X3,densityr,r));
isonormals(X1,X2,X3,densityr,p)

set(p,'FaceColor','red','EdgeColor','none');
daspect([1,1,1])
view(3); axis tight
camlight
xlabel('x coordinate')
ylabel('y coordinate')
zlabel('z cordinate')
grid on
grid on
xlabel('x coordinate')
title(['${\sqrt{p(x)}}$ WDE'],'Fontsize', 14,'Interpreter', 'latex');

%========================================================================== 

figure (31) % density squarred plot
p1 = patch(isosurface(X1,X2,X3,densityr.^2,r));
r = (((max(densityr(:))-min(densityr(:)))))/25;
isonormals(X1,X2,X3,densityr.^2,p1)

set(p1,'FaceColor','green','EdgeColor','none');
daspect([1,1,1])
view(3); axis tight
camlight
xlabel('x coordinate')
ylabel('y coordinate')
zlabel('z cordinate')
grid on
grid on
xlabel('x coordinate')

title(['p(x) WDE'],'Fontsize', 14);
%==========================================================================
clear density