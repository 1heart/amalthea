%--------------------------------------------------------------------------
% Function:    plot2DShapeAndSave
% Description: This functions plots a 2D shape and saves the figure in eps
%              format. Its original use is meant for shape analysis on the
%              MPEG7 dataset. 
%
% Inputs:
%
%   shape         - 2D shape with x,y points stores in the columns. 
%	
%   colorVec      - Color vector for the shape.
%
%   fileName      - Filename to store the file. 
%
%   saveImFlag    - Save image flag. 1 - on. 0 - off. 
% 
% Outputs:
%   
%   figHand       - Handle to the figure. 
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Tuesday 24th June, 2014. 
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function figHand = plot2DShapeAndSave(shape, colorVec, fileName, saveImFlag)

figHand = figure;
plot(shape(:,1),shape(:,2),'o',...
    'LineWidth',2,...
    'MarkerSize',2,...
    'Color', colorVec);
%     'MarkerFaceColor',colorVec);
axis square;
axis off;
set(figHand, 'WindowStyle', 'docked');
if (saveImFlag == 1)
    saveFigureToEPS(fileName, figHand);
end