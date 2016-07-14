
%% Get landmarks
clear;
close all; clc;
% Setup variables.
button = 1; 
x = []; 
y = [];
u = [];
setCnt  = 1;
pntCnt  = 0;
set1Pts = 0;
% Get the grid range from the user.
reply = input('Please enter the grid limits [xMin xMax yMin yMax]: ');
if isempty(reply)
    reply = [-1 1 -1 1];
end
gridLimits = reply;
% Get grid spacing from the user.
reply = input('Please enter the grid spacing: ');
if isempty(reply)
    reply = .5;
end
gridSpacing = reply;
% Get input points from user
figure, axis(gridLimits);
set(gca,'XTick',gridLimits(1):gridSpacing:gridLimits(2));
set(gca,'YTick',gridLimits(3):gridSpacing:gridLimits(4));
hold on; grid on;
title({'Please enter points using left mouse button. '; ...
       'Press right mouse button to finish the set.'}, 'Fontsize', 14);
xlabel('Landmarks');

lineStyle = '*r';
while ((button == 1) | (setCnt < 2))
    [tempX,tempY,button] = ginput(1);
    x = [x tempX];
    y = [y tempY];
    plot(x, y,lineStyle);
    pntCnt = pntCnt + 1;
    if(button ~= 1)
        % Don't count the last point for right clicking mouse
        x = x(1:end - 1);
        y = y(1:end - 1);
        pntCnt = pntCnt - 1;

        if(setCnt == 1)
            u = [x;y];
            set1Pts = pntCnt;
            pntCnt = 0;
            setCnt = setCnt + 1;
            x = []; y = [];
        end
    end
end

%% Shift points
v = u;
% Find all indicies of points in one grid cell.
%[idx1]=find((v(1,:)<=0)&(v(1,:)>=-.5)&(v(2,:)<=1)&(v(2,:)>=.5));
numPts = size(u,2);
% Shift down 
v=u;
shift1DLine = v - repmat([0;.5],1,numPts);
%v(:,idx1)=v(:,idx1)-repmat([0;.5],1,numPts);
%shift1DSquare = v;

% Find all indicies of points in one grid cell.
%[idx2]=find((v(1,:)<=-.5)&(v(1,:)>=-1)&(v(2,:)<=0)&(v(2,:)>=-.5));
%numPts = size(idx2,2);
% Shift right 
%v=u;
%v(:,idx2)=v(:,idx2)+repmat([.5;0],1,numPts);
%shift1RSquare = v;

%plot(shift1DSquare(1,:),shift1DSquare(2,:),'r*');
plot(shift1DLine(1,:),shift1DLine(2,:),'r*');
hold on;
plot(u(1,:),u(2,:),'sb');
hold off;
%figure;
%plot(shift1RSquare(1,:),shift1RSquare(2,:),'r*');
%hold on;
%plot(u(1,:),u(2,:),'sb');
%hold off;

%% Save landmarks
preShape = u';
save ./laTestShapes/line_80Pts preShape;
preShape = shift1DLine';
save ./laTestShapes/shift1DLine_80Pts preShape;
