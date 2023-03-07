% Marcondes Ricarte

function [sMaps] = plotMapMultiple(model, sMaps, n, i)

     dirLayer = GetLayerDir(model,i);

     surf(sMaps(n,i).sMap.codebook)
     xlabel('atributos')
     ylabel('nodos')
     saveas( gcf,[dirLayer model.dir.categories 'fig_som_category_' int2str(n) '.png']);

end