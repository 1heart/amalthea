% Use to display shapes and assignments during matching process.
%% Global Flags
titlesOn=1;
showAssign=1;
%% Display Target Shape
plotWDEShape([namePrefix shapeNames{s2} namePostfix],shape1,1);
if(titlesOn)
    title(['Target Shape (S1): ' shapeNames{s1}],'Fontsize',14);
end

%% Display Source Shape
plotWDEShape([namePrefix shapeNames{s2} namePostfix],shape2,1);
if(innerProd1 >= innerProd2)
    tempInnerProd = innerProd1;
else
    tempInnerProd = innerProd2;
end
if(titlesOn)
    title({['Source Shape (S2): ' shapeNames{s2}];...
           ['Inner Prod. = ' num2str(tempInnerProd) ', D_{NoLA} = ' num2str(shapeDist)]},'Fontsize',14);
end

%% Deformation C1
% Candiate 1 (C1) for source shape deformed to target shape using linear
% assignmet.
plotWDEShape([namePrefix shapeNames{s2} namePostfix],shape2C1,1);
if(titlesOn)
    title({[shapeNames{s2} ' Deformed to: ' shapeNames{s1} ' C1'];...
       ['\lambda = ' num2str(lambda) ', D_{LA} = ' num2str(shapeDistsLA(s2)) ', D_{EU} = ' num2str(shapeDistsEU(s2))];...
       ['Inner Prod. = ' num2str(innerProd1LA) ', Sum Eu Dist. = ' num2str(euclideanWeight)]},'Fontsize',14);
end
if(showAssign)
    showAssignment([namePrefix shapeNames{s2} namePostfix], shape2C1, basesLocs, saveCoeffsOrder1',lambda,1);
end
if(titlesOn)
    title({['Location assignments'];['\lambda = ' num2str(lambda)]},'Fontsize',14);
end
%% Deformation C2
% Candiate 2 (C2) for source shape deformed to target shape using linear
% assignmet.
plotWDEShape([namePrefix shapeNames{s2} namePostfix],shape2C2,1);
euclideanWeight2 = sum((sum((basesLocs-basesLocs(saveCoeffsOrder2,:)).^2,2)));
if(titlesOn)
    title({[shapeNames{s2} ' Deformed to: ' shapeNames{s1} ' C2'];...
       ['\lambda = ' num2str(lambda) ', D_{LA} = ' num2str(shapeDistsLA(s2)) ', D_{EU} = ' num2str(shapeDistsEU(s2))];...
       ['Inner Prod. = ' num2str(innerProd1LA) ', Sum Eu Dist. = ' num2str(euclideanWeight)]},'Fontsize',14);
end
if(showAssign)
    showAssignment([namePrefix shapeNames{s2} namePostfix], shape2C2, basesLocs, saveCoeffsOrder2',lambda,1);
end
if(titlesOn)
    title({['Location assignments'];['\lambda = ' num2str(lambda)]},'Fontsize',14);
end
