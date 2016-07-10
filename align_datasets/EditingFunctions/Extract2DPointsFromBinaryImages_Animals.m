% Extract shape points. 
% Usage: To extract the 2D points from binary images. 
clear; clc; close all;

% Shape image folder. 
shapeImFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\ShapeDatabases\2D\AnimalDataset_Bai\animal\';

saveFold = 'C:\Users\mmoyou\Documents\MATLAB\CurrentResearch\ShapeDatabases\2D\AnimalDataset_Bai\ExtractedPoints\';
saveNameOverall = 'Animal_';
% Extenstion to search for.
extToSearchFor = 'bmp';

dirContCat = dir(shapeImFold);
numCatplus2 = size(dirContCat,1);

% % Get the contents of the folder. 
% dirCont = dir([shapeImFold, '*.' extToSearchFor]);

% % Get the number of images in the folder. 
% numImages = size(dirCont,1);

shapePointIntVal = 255;
plotShapeAndImage = 1;
saveFile = 0;

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
% Loop through the images and extract the shape points. 
for i = 3 : numCatplus2
        
    % Get the information in the current category. 
    currCatInfo = dir([shapeImFold, dirContCat(i+2).name, '\*.tif']);
    
    % Number of individual images.
    numIndIm = size(currCatInfo,1);
    
    shapeCell = cell(numIndIm,1);
    
    for k = 33 : numIndIm
    
        disp(num2str(k));
        % Get the current image. 
        currIm = imread([shapeImFold, dirContCat(i+2).name, '\', currCatInfo(k).name]);
        currIm = double(currIm);
        
        saveName = [saveNameOverall,dirContCat(i+2).name];
        % Check the number of unique intensity values contained in the image.
        % If there are more than two then the image is not truly binary. 
        unqIntVals = unique(currIm(:));
        numUnqIntVals = length(unqIntVals);

        if (numUnqIntVals == 2)
            
%             intValBackGround = currIm(1,1);
%             
%             imshow(currIm);
%             % If it is equal to two, then make sure the lower value is set to zero
%             % and the upper value is set to 255. 
% %             minUnqIntVal = min(unqIntVals);
%             currIm(currIm == intValBackGround) = 0;
% 
%             maxUnqIntVal = max(unqIntVals);
%             currIm(currIm ~= intValBackGround) = 255;
            
%             % If it is equal to two, then make sure the lower value is set to zero
%             % and the upper value is set to 255. 
            minUnqIntVal = min(unqIntVals);
            currIm(currIm == minUnqIntVal) = 0;

            maxUnqIntVal = max(unqIntVals);
            currIm(currIm == maxUnqIntVal) = 255;
            
            if (currIm(1,1) == shapePointIntVal)
                % Check in the image that is not equal to the background
                % intensity. 
                objInd = currIm ~= shapePointIntVal;
                backGroundInd = currIm == shapePointIntVal;
                
                currIm(objInd) = shapePointIntVal;
                
                if (shapePointIntVal == 255)
                    backGroundIntVal = 0;
                else 
                    backGroundIntVal = 255;
                end
                
                currIm(backGroundInd) = backGroundIntVal;
            
%                 imshow(currIm);
            end
        end

        if (numUnqIntVals > 2)

            minUnqIntVal = min(unqIntVals);
            currIm(currIm == minUnqIntVal) = 0;

            currIm(currIm > minUnqIntVal) = 255;
        end

        % Find the positions where the points are equal to the desired
        % intensity level.
        [x,y] = find(currIm == shapePointIntVal);

        figure(f1);
        if (plotShapeAndImage == 1)
            numPlots = 6;
    %         subplot(1,numPlots,4); plot2DShape([x,y],'c.');
            subplot(1,numPlots,2); imshow(currIm);
            title(num2str(k));
        end

    %     BW = im2bw(currIm);
        BW = currIm;
        CC = bwconncomp(BW);
        S = regionprops(CC,'Centroid');
        centroids = cat(1, S.Centroid);

        if (plotShapeAndImage == 1)
            subplot(1,numPlots,6); 
            imshow(BW);
        end

        if (CC.NumObjects > 1)

            numPixels = cellfun(@numel,CC.PixelIdxList);
            [biggest,idx] = max(numPixels);

            aveNumPixels = mean(numPixels);
            idx = numPixels < aveNumPixels;
            indVec = 1 : length(idx);
            indVec = indVec(idx);

            numIdx = sum(idx);
            for j = 1 : numIdx

                BW(CC.PixelIdxList{indVec(j)}) = 0;
            end

            if (plotShapeAndImage == 1)
                subplot(1,numPlots,3); imshow(BW);
                hold on
                plot(centroids(:,1),centroids(:,2), 'r*');
                hold off

                 subplot(1,numPlots,4); plot2DShape([x,y],'c.'); hold on;
                plot(centroids(:,1),centroids(:,2), 'r*');
        %         plot(centroids(:,1),centroids(:,2), 'r*')
                hold off;

                subplot(1,numPlots,1); imshow(BW);
            end

            [x,y] = find(BW == shapePointIntVal);

            if (plotShapeAndImage == 1)
                subplot(1,numPlots,5); plot2DShape([x,y],'c.');
                pause(0.2);
            end
        end

    %     pause(0.1);
        shapeCell{k,1} = [x,y];
        
        clf;
    end % for j = 1 : numIndIm.
    
    plotExperimentShapesFromACell(shapeCell,1,84);
    
    if (saveFile == 1)
        save([saveFold, saveName],'shapeCell');
    end
    
end % for i = 1 : numCatplus2.
    
% plotExperimentShapesFromACell(shapeCell,0,1);

