function analyticDerivOfMultiGaussian(domain,r,discretization)

%[analyDensty, gaussDist]
%=analyticDerivativeOfGaussian(domain,truth,sample);call

% alpha=1;
% 
%sample = linspace(domain(1),domain(2),length(x));
domain1 = domain(1,:);
domain2 = domain(2,:);
domain3 = domain(3,:);

% sample1 = linspace(domain1(1),domain1(2),200);
% sample2 = linspace(domain2(1),domain2(2),200);
% sample3 = linspace(domain3(1),domain3(2),200);



sample1 = (domain1(1):discretization:domain1(2));
sample2 = (domain2(1):discretization:domain2(2));
sample3 = (domain3(1):discretization:domain3(2));



[X, Y, Z]= meshgrid(sample1,sample2,sample3);
W = [X(:),Y(:),Z(:)];

x1 = (W(:,1)-mean(W(:,1)))/std(W(:,1));
x2 = (W(:,2)-mean(W(:,2)))/std(W(:,2));
x3 = (W(:,3)-mean(W(:,3)))/std(W(:,3));


dim = 3;
mu = mean([x1 x2 x3]);
sigma = cov([x1 x2 x3]);

W(:,1) = x1;
W(:,2) = x2;
W(:,3) = x3;

Constant = (1/((2*pi)^(3/2)*(det(eye(3)))^(.5)));

F1 = -2*W(:,1).*exp(-.5*(W(:,1).^2 + W(:,2).^2 + W(:,3).^2));
F2 = -2*W(:,2).*exp(-.5*(W(:,1).^2 + W(:,2).^2 + W(:,3).^2));
F3 = -2*W(:,3).*exp(-.5*(W(:,1).^2 + W(:,2).^2 + W(:,3).^2));

dFx = Constant*F1;
dFy = Constant*F2;
dFz = Constant*F3;

  figure (2)% here r small will make it good de
    % % reshape density
    dFx= reshape(dFx,size(X,1),size(X,2),size(X,3));
     r = (max(dFx(:))- min(dFx(:)))/8;
     %r = mean(dFx(:))/100;
%     maxOfTrueDensity = max(dFx(:));
    p = patch(isosurface(X,Y,Z,dFx,r));
    isonormals(X,Y,Z,dFx,p);

    set(p,'FaceColor','blue','EdgeColor','none');
    daspect([1,1,1])
    view(3); axis tight
    camlight

    xlabel('x coordinate')
    ylabel('y coordinate')
    zlabel('z cordinate')
    title ([num2str(dim),'D plot of the true derivative of density w.r.t X'])
    grid on
    xlabel('x coordinate')  
figure (3)


    % % reshape density
    dFy= reshape(dFy,size(X,1),size(X,2),size(X,3));
     r = (max(dFy(:))- min(dFy(:)))/8;
%     maxOfTrueDensity = max(dFx(:));
    p = patch(isosurface(X,Y,Z,dFy,r));
    isonormals(X,Y,Z,dFy,p);

    set(p,'FaceColor','green','EdgeColor','none');
    daspect([1,1,1])
    view(3); axis tight
    camlight

    xlabel('x coordinate')
    ylabel('y coordinate')
    zlabel('z cordinate')
    title ([num2str(dim),'D plot of the true derivative of density w.r.t Y'])
    grid on
    xlabel('x coordinate')  

figure (4)
    % % reshape density
    dFz = reshape(dFz,size(X,1),size(X,2),size(X,3));
 r = (max(dFz(:))-min(dFz(:)))/8;
%     maxOfTrueDensity = max(dFx(:));
    p = patch(isosurface(X,Y,Z,dFz,r));
    isonormals(X,Y,Z,dFz,p);

    set(p,'FaceColor','red','EdgeColor','none');
    daspect([1,1,1])
    view(3); axis tight
    camlight

    xlabel('x coordinate')
    ylabel('y coordinate')
    zlabel('z cordinate')
    title ([num2str(dim),'D plot of the true derivative of density w.r.t Z'])
    grid on
    xlabel('x coordinate')  











% 
% 
% 
% 
% if alpha ==1
% mu = mean(W);
% sigma = cov(W);
% % n = min (sample);
% % M = m;
% % mu = 0;
% % sigma = 1;
% 
% % for i = 1:length(W)
% %     x = W(i,:)
% % N = (-1/(sqrt(sigma)*sqrt(2*pi)))*(W - mu)'*inv(sigma)*(W - mu)
% % gPrime = N.*exp((-.5)*(((sample-mu).^2)./sigma));
% % end
% 
% 
% 
% figure (20)
% 
% plot(sample ,gPrime,'.b')
% xlabel('support size')
% ylabel('functions amplitude')
% title('Analytic implementation of gaussian distri derivative')
% grid on
% 
% 
% NN = (1/(sqrt(sigma)*sqrt(2*pi)));
% gGauss = NN.*exp((-.5)*(((sample-mu).^2)./sigma));
% 
% figure (21)
% 
% plot(sample ,gGauss,'r')
% xlabel('support size')
% ylabel('functions amplitude')
% title('Analytic implementation of gaussian dist')
% grid on
% else
%     
% gPrime = 3*sample.^2; 
%  
% figure (20)
% 
% plot(sample ,gPrime)
% xlabel('support size')
% ylabel('functions amplitude')
% title('Analytic implementation of gaussian dist derivative')
% grid on
%  
%  
% gGauss = sample.^3;
% plot(sample ,gGauss,'r')
% xlabel('support size')
% ylabel('functions amplitude')
% title('Analytic implementation of gaussian dist')
% grid on
% 
%     
% end


