clc;
clear;
close all;

pointColor = 'brkcyg';


% Prompt user to generate new data or use last ones
use_previously_saved_data = ' ';
while (use_previously_saved_data ~= 'y') & (use_previously_saved_data ~= 'n')
    use_previously_saved_data = lower(input('Use previously saved data? (y/n)', 's'));
end

if use_previously_saved_data == 'n'
    
    saveFileName = [];
    while(isempty(saveFileName == 1))
        saveFileName = input('Please enter filename to save without quotes: ', 's');
    end
    
    % Ask user about number of classes
    C = 0;
    while (floor(C) < 1) | (floor(C) > 6)
        C = floor(input('Enter number of classes (1-6):'));
    end
    
    % Setup figure to specify data points
    f1 = figure; movegui(f1,'east');
    hold on
    set(gcf, 'Color', 'w');
    axis equal
    axis([-10.0 10.0 -10.0 10.0])
    grid on
    xlabel('x_1')
    ylabel('x_2')
    title('Data')
    
    % Specify new data points
    Patterns = [];
    Labels = [];
    for c = 1 : C
        
        clc
        txt = sprintf('Press RETURN key to stop entering class %d smaples.', c);
        disp(txt)
        
        while 1
            
            [x, y] = ginput(1);
            
            if isempty(x)
                break
            end
            
            Patterns = [ Patterns; x y ];
            Labels = [Labels; c];
            plot(x, y, [pointColor(c) '.'], 'MarkerSize', 30);
            
        end
        
    end % c-loop
    
    % Save generated data
    clc
%     save userdata Patterns Labels
    save(saveFileName, 'Patterns', 'Labels');
%     disp('Data saved in user_data.mat.')
    disp(['Data saved in ', saveFileName, '.mat.'])
    
else
    
    % Setup figure to specify data points
    f1 = figure; movegui(f1,'east');
    hold on
    set(gcf, 'Color', 'w');
    axis equal
    axis([-10.0 10.0 -10.0 10.0])
    grid on
    xlabel('x_1')
    ylabel('x_2')
    title('Data')
   
    % if use_previously_saved_data == 'y'
    % load previous data set
    load user_data
    
    N = size(Patterns, 1);
    
    for n = 1 : N
        plot(Patterns(n,1), Patterns(n,2), [pointColor(Labels(n)) '.'], 'MarkerSize', 30);
    end
end

