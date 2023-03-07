% Marcondes Ricarte

function [sMap] = plotWinners(Model, sMap, munits, classes, flagSave)

    if strcmp(Model.flagPlotWinners,'yes')
        winMax = max(sMap.winners);
        [valueMax indexesMax] = max(sMap.victoriesEpochs');
        [valueMin indexesMin] = min(sMap.victoriesEpochs');
        valueSum = sum(sMap.victoriesEpochs(:));
        invalid = (valueMax == 0);
        for  c=1:munits
            if  invalid(c) == 1
                indexesMax(c) = 0;
            end;
        end;
        cmap = getColors(classes);
        stem(sMap.winners,'MarkerSize',1),xlabel('nodos'), ylabel('vitórias'), title(['Separabilidade: ' num2str(100*sum(valueMax)/valueSum) ' %']), axis([0 (munits+1) 0 winMax]);
        hold on
        for c=1:classes
            indexesCurrent = find(indexesMax == c);
            if length(indexesCurrent) > 0
                stem(indexesCurrent, sMap.winners(indexesCurrent),'MarkerSize',1, 'Color', cmap(c,:)),xlabel('nodos'), ylabel('vitórias'), title(['Separabilidade: ' num2str(100*sum(valueMax)/valueSum) ' %']), axis([0 (munits+1) 0 winMax]);
            end;
        end;
        hold off

        if strcmp(flagSave,'yes')
            if strcmp(Model.pipeline,'mult')
                dirLayer = GetLayerDir(Model,Model.j); 
                saveas( gcf, [dirLayer Model.dir.winners 'winners_epochs_1_category_' int2str(Model.i) '.png']);  
            elseif strcmp(Model.pipeline,'single')
                dirLayer = Model.dir.layer1;
                saveas( gcf, [dirLayer Model.dir.winners 'winners_epochs_1_exec_' num2str(Model.test.iterator) '.png']);
            end;
        end;
    end;

end