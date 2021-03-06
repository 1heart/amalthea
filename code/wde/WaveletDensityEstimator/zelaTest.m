load('trueWorkSpace');
load('trueVar');
load('initialized');
load('neg');
%clc;

k_x = scalingShiftValsX;
k_y = scalingShiftValsY;
translations_x = length(k_x);
translations_y = length(k_y);
sumGrid = zeros(translations_x,translations_y);

%   OPTIMIZATION ONE ------------------------------------------------------
%   Double loop over translations rather than sample points
%   -----------------------------------------------------------------------
% optOne_time_start = tic;
% 
% for j = 1 : translations_y
%     
%     for i = 1 : translations_x
%         x = 2^startLevel * samps(:,1)' - k_x(i);
%         y = 2^startLevel * samps(:,2)' - k_y(j);
%         
%         valid_xIndex = find(x >= 0 & x <= 7);
%         valid_yIndex = find(y >= 0 & y <= 7);
%         
%         % These are the sample points that fall under translate i,j
%         valid_coord = intersect(valid_xIndex, valid_yIndex);
%         x = x(valid_coord);
%         y = y(valid_coord);
%         
%         if(isempty(valid_coord))
%             fatherWavOpt = 0;
%         else
%             fatherWav = 2^startLevel * (father(x) .* father(y));
%             fatherWavOpt = fatherWav ./ sqrtPEachSamp(valid_coord)';
%             fatherWavOpt = sum(fatherWavOpt);
%         end
%         sumGrid(i,j) =fatherWavOpt;
%     end
%     
% end
% sumGrid = sumGrid';
% sumGrid = reshape(sumGrid,[1,numel(sumGrid)]);
% 
% c_opt = (1/numSamps)*sumGrid';
% coeffs_opt = c_opt/norm(c_opt);
% 
% % Output of results
% optOne_time_stop = toc(optOne_time_start);
% accurate = isequal(coeffs_opt, coeffs);
% disp('OPTIMIZATION ONE');
% disp('Double loop over translations rather than sample points');
% disp(['Time Elapsed: ', num2str(optOne_time_stop)]);
% disp(['Equivalent to true coefficient results: ', num2str(accurate)]);
% 
% % Display coefficient graph
% coeffs_opt = reshape(coeffs_opt, translations_x, translations_y);
% surf(coeffs_opt);      
%   -----------------------------------------------------------------------






%   OPTIMIZATION TWO ------------------------------------------------------
%   Multiple seperate loops over translations.    
%   -----------------------------------------------------------------------
% 
% optTwo_time_start = tic;
% k_x_Samps = cell(translations_x,2);
% for i = 1:translations_x
%     
%     % find index of x points that live under specific wavelet
%     x = 2^startLevel * samps(:,1)' - k_x(i);
%     
%     valid_xIndex = find(x >= waveSupp(1) & x <= waveSupp(2));
%     
%     % stored k value with x coordinates that fall under it
%     k_x_Samps{i,1} = k_x(i);
%     k_x_Samps{i,2} = valid_xIndex;
% end
% 
% k_y_Samps = cell(translations_y,1);
% for i = 1:translations_y
%     y = 2^startLevel * samps(:,2)' - k_y(i);
%     
%     % find index of y points that live under specific wavelet
%     valid_yIndex = find(y >= waveSupp(1) & y <= waveSupp(2));
%     
%     % stored k value with x coordinates that fall under it
%     k_y_Samps{i,1} = k_y(i);
%     k_y_Samps{i,2} = valid_yIndex;
% end
% 
% for i = 1:translations_x
%     for j = 1:translations_y
%         valid_coord = intersect(k_x_Samps{i,2}, k_y_Samps{j,2});
%         
%         if(isempty(valid_coord))
%             fatherWav = 0;
%         else
%             % valid coordinates under a translate
%             x = 2^startLevel * samps(valid_coord,1)' - k_x_Samps{i,1};
%             y = 2^startLevel * samps(valid_coord,2)' - k_y_Samps{j,1};
%             
%             fatherWav = 2^startLevel * (father(x) .* father(y));
%             fatherWav = fatherWav ./ sqrtPEachSamp(valid_coord)';
%             fatherWav = sum(fatherWav);
%         end
%         sumGrid(i,j) = fatherWav;
%     end
% end
% 
% sumGrid = sumGrid';
% sumGrid = reshape(sumGrid,[1,numel(sumGrid)]);
% 
% c_opt = (1/numSamps)*sumGrid';
% coeffs_opt = c_opt/norm(c_opt);
% 
% % Output of results
% optTwo_time_stop = toc(optTwo_time_start);
% accurate = isequal(coeffs_opt, coeffs);
% disp('OPTIMIZATION TWO');
% disp('Multiple seperate loops over translations');
% disp(['Time Elapsed: ', num2str(optTwo_time_stop)]);
% disp(['Equivalent to true coefficient results: ', num2str(accurate)]);
% 
% % Display coefficient graph
% coeffs_opt = reshape(coeffs_opt, translations_x, translations_y);
% surf(coeffs_opt);
%   -----------------------------------------------------------------------





% %   OPTIMIZATION THREE --------------------------------------------------- 
% %   Loop over translates with a single parfor loop  
% %   ----------------------------------------------------------------------

    waveSupp = [0 7];
    optThree_time_start = tic;
    % Gives back all x values for each translate
    x2 = bsxfun(@minus, (2^startLevel)*samps(:,1), k_x);
    y2 = bsxfun(@minus, (2^startLevel)*samps(:,2), k_y);
    
    % Along each translate find values between 0 and 7 --> 1
    valid_x = (x2 >= waveSupp(1) & x2 <= waveSupp(2));
    valid_y = (y2 >= waveSupp(1) & y2 <= waveSupp(2));

    savedFatherWav = zeros(numSamps, 1);

    %I want to save cooresponding points with each translate
    
    for i = 1 : translations_x
       
        intersections = bsxfun(@times, valid_x(:,i), valid_y);
 
        [pointInd, transYInd] = find(intersections == 1);
        
        x = x2(pointInd,i);
        phi_x = father(x);
        
        y = y2(logical(intersections));
        phi_y = father(y);
        
        fatherWav = bsxfun(@times, 2^startLevel * phi_x, phi_y);
        fatherAlpha = fatherWav ./ sqrtPEachSamp(pointInd);

        fatherAlpha_per_trans = accumarray(transYInd, fatherAlpha);
        trans_index = unique(transYInd);

        fatherWav_per_trans = accumarray(pointInd, fatherWav);

        sumGrid(i,trans_index) = fatherAlpha_per_trans(trans_index);
        
        
        
        
        
        savedFatherWav(unique(pointInd)) = fatherWav_per_trans(unique(pointInd));
    end
    
    sumGrid = sumGrid';
    sumGrid = reshape(sumGrid,[1,numel(sumGrid)]);
    
    c_opt = (1/numSamps)*sumGrid';
    coeffs_opt = c_opt/norm(c_opt);
    
    % Output of results
    optThree_time_stop = toc(optThree_time_start);
    accurate = isequal(coeffs_opt, coeffsInitialized);
    disp('OPTIMIZATION THREE');
    disp('Loop over translates with a single loop');
    disp(['Time Elapsed: ', num2str(optThree_time_stop)]);
    disp(['Equivalent to true coefficient results: ', num2str(accurate)]);
    
    % Display coefficient graph
    coeffs_opt = reshape(coeffs_opt, translations_x, translations_y);
    surf(coeffs_opt)
    
    %testGrid = reshape(testGrid,24,24);
    
    fatherWaveGridAccurate = isequal(savedFatherWav, savedScalVals);
    disp(['Father basis grids are equal: ', num2str(fatherWaveGridAccurate)]);
    
    coeffs_father = coeffs_opt .* savedFatherWav;
    fatherTimesCoeffsAccurate = isequal(coeffs_father,multipliedScal);
    disp(['Alpha * phi accuracy is equal: ', num2str(fatherTimesCoeffsAccurate)]);
    
    coeffsInitialized = reshape(coeffsInitialized,24,24);
    
    isequal(coeffsInitialized,coeffsNeg)
    
%--------------------------------------------------------------------------
    
    
  


scalingBasis = coeffs_opt % times each point under the wavelet at kk;
scalingBasis = log(sum(scalingBasis)^2);
scalingBasis = sum(scalingBasis);


disp();


