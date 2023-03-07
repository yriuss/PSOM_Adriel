% Marcondes Ricarte

function [data] = plotSamplesSingle(data, dataFilter, labels, indexes, Model, folder)

    if strcmp(Model.flag.plotSamplesForLayer,'yes')
        [row,col] = size(data);
        
        for i=1:row
            i
            name = ['logs\plot\' Model.database '\layer_1\' folder '\sample_' int2str(i) '.png'];
            if exist(name) == 0
                indexesSelect = find(indexes == labels(i));
                stem(data(i,:), 'LineStyle', ':', 'MarkerSize',1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                hold on
                stem(dataFilter(i,:), 'MarkerSize', 1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                stem(indexesSelect,data(i,indexesSelect), 'LineStyle', ':', 'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                stem(indexesSelect,dataFilter(i,indexesSelect), 'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                hold off

                saveas( gcf, name); 
            end;
        
        end;
    end;
    
end