function [wdeCell] = compute_wde_2d_fun(shapeCell, wdeSet, DISPLAY)

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

numShapes = size(shapeCell,1);

% Cell to store coefficients, densities, and parameters.
wdeCell = cell(numShapes,3);
wdeCell{1,3} = wdeSet;

h = waitbar(0,'Computing coefficients and densities per category.');

% Loop through shapes to estimate densities
for i = 1 : numShapes
	if(DISPLAY)
		waitbar(i/numShapes, h);
		disp(['Running shape ', num2str(i)]);
	end

    % Pull and resize shape
    currShape = shapeCell{i,1};
    currShape = resizeShapesToSquareGrid(currShape, abs(wdeSet.xMin));

    % Compute the coefficients and densities
    [coeffs, coeffsIdx, pdf] = mlWDE2DWrapper(currShape, wdeSet);

    % Store coefficients and densities
    wdeCell{i,1} = coeffs(:,end); 
    wdeCell{i,2} = pdf;
end

F = findall(0,'type','figure','tag','TMWWaitbar'); delete(F);

end
