% Marcondes Ricarte

function [sMap] = plotMapUnique(Model, sMap)

    if strcmp(Model.flagPlotMaps,'yes')
     surf(sMap.codebook)
     xlabel('atributos')
     ylabel('nodos')
     saveas( gcf,[Model.dir.layer1 Model.dir.categories 'fig_som_exec_' num2str(Model.test.iterator) '.png']);
    end;        
     
end