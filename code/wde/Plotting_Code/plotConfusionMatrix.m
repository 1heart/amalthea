function figHand = plotConfusionMatrix(trueLabels, predLabels, plotProp)

figHand = figure; 
tempMat = confusionmat(trueLabels, predLabels);
tempMat = bsxfun(@rdivide, tempMat, sum(tempMat));

[x,y] = meshgrid(1:size(tempMat,1));

imagesc(tempMat);
colormap(plotProp.colormapColor);
colorbar('southoutside', 'LineWidth',plotProp.colBarLineWidth,...
    'FontWeight','bold',...
    'FontSize',plotProp.colBarFontSize, 'FontAngle', 'italic');

% textStrings = num2str(tempMat(:), '%0.2f');
% textStrings = strtrim(cellstr(textStrings)); 
% hStrings = text(x(:), y(:), textStrings(:),...
%     'HorizontalAlignment', 'center'); 
% 
% midValue = mean(get(gca,'CLim'));
% textColors = repmat(tempMat(:) < midValue, 1,3);
% set(hStrings, {'Color'}, num2cell(textColors,2));
% set(hStrings, 'FontWeight','bold','FontSize',plotProp.matStringFontSize);
% set(hStrings, 'FontAngle','italic');

numCat = numel(unique(trueLabels));
catLabels = cellstr(num2str((1:numCat)'));

% set(gca, 'XTick', 1:numCat,...
%     'XTickLabel', catLabels,...
%     'YTick', 1:numCat,...
%     'YTickLabel', catLabels,...
%     'TickLength', [0 0], 'FontWeight','bold','FontSize',...
%     plotProp.axesFontSize,'XAxisLocation','top');

set(gca,'xticklabel',{[]});
set(gca,'yticklabel',{[]});

hold on;
[M,N] = size(tempMat);
M = M + 0.5;
N = N + 0.5;
a=1; 
b=1;
for k = 0.5:a:M
    x = [0.5 N]; 
    y = [k k];
    plot(x,y,'Color','black','LineStyle','-');
    set(findobj('Tag','MyGrid'),'Visible','on')
end
for k = 0.5:b:N 
    x = [k k]; 
    y = [0.5 M];
    plot(x,y,'Color','black','LineStyle','-');
    set(findobj('Tag','MyGrid'),'Visible','on')
end