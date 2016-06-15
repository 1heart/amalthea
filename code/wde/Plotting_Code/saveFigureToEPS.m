%--------------------------------------------------------------------------
% Function:    saveImageEPS
% Description: This functions saves a Matlab figure in eps format. 
%
% Inputs:
%
%   fileName      - Filename that is used to save the file as. 
% 
%   figHand       - Figure handle to save. 
% 
% Outputs:
%   
%   dv            - Dummy variable. 
%
% Usage: Used in the 3D shape matching framework. 
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
%
% Date: Wednesday 27th November, 2013. 
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------
function dv = saveFigureToEPS(fileName, figHand)
% 
print('-depsc','-tiff','-r300',fileName);
saveas(figHand,fileName,'fig');


dv = [];