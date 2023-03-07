% Marcondes Ricarte

function [means] = plotDistributionCategoryUnique(label, Model, sMap, means, numClass, NumMap)

    if strcmp(Model.flagPlotDistributions,'yes')
        ceilMeans = max(means(:));
        cmap = getColors(numClass);
        [valueMax indexesMax] = max(sMap.victories');
        invalid = (valueMax == 0);
        for  c=1:Model.numMap
            if  invalid(c) == 1
                indexesMax(c) = 0;
            end;
        end;
        for j=1:numClass                
            indexesMetric = find(indexesMax == j);
            acurracy = nanmean(means(j,indexesMetric))/nanmean(means(j,:));
            if numClass == 8
                subplot(4,2,j)
            elseif numClass == 15
                subplot(4,4,j)
            end;
            stem(means(j,:),'MarkerSize',1), xlabel('nodos'), ylabel('ativação'), title(['categoria ' num2str(j)]), axis([0 NumMap 0 ceilMeans]);                
            hold on
            for c=1:numClass            
                indexesCurrent = find(indexesMax == c);
                stem(indexesCurrent, means(j,indexesCurrent),'MarkerSize',1, 'Color', cmap(c,:)), xlabel('nodos'), ylabel('ativação'), title([num2str(j) ': ' num2str(acurracy)],'Color', cmap(j,:)), axis([0 NumMap 0 ceilMeans]);
            end;
            hold off
        end;
        saveas( gcf,[Model.dir.layer1 Model.dir.categories  label '_all_categories.png']);
    end;
            
end