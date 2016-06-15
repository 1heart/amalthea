% -------------------------------------------------------------------------
% Script: Show3DShape
% Date: Friday 29th November, 2013. 
% Author: Mark Moyou (mmoyou@my.fit.edu)
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% Description: This driver displays the shape from the directory chosen by 
%              the user. 
% Usage: This program is used in the 3D shape matching research framework.
% -------------------------------------------------------------------------
clear; clc; close all; 

% Add the path to the shape folder. 
% foldLoc = 'C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\Datasets\SHREC2010Pami';
foldLoc = 'C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\Datasets\SHREC12ICPR';

% foldLoc = 'C:\Users\mmoyou\Documents\MATLAB\3D Shape wavelet matching\Datasets\MCGILL Benchmark\McGillDBAll';
addpath(foldLoc);

dirInfo = dir(foldLoc); % Get directory information.

nShs = size(dirInfo,1); % Number of shapes in the directory.

% Loop through the shapes. 
for i = 3: nShs
    
%     disp(i-2)
       
    % File to Read.
    fn = dirInfo(i).name;
    disp(fn);
    
%     num = i - 3;
%     fn = ['b' num2str(num) '.off'];
%     disp(fn);
%     fn = [fn '.off'];
    % Read the mesh.
   
%     sh = loadoff(fn);
    
    
    [X, F] = readOff(fn);
    disp(size(X,1));

%     Plot the mesh. 
    y = showMesh(X ,F);
    title(fn);
%     title([fn ' shapeNum = ' num2str(num)]);
%     disp([fn ' shapeNum = ' num2str(num)]);
%     y = showMesh([sh.X sh.Y sh.Z], sh.TRIV);
    
    
    pause;
    
    clf;
    
end