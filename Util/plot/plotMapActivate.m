% Marcondes Ricarte

function [map] = plotMapActivate(Model, map, score)

    if strcmp(Model.flagPlotMapActive,'yes')
     [row, col] = size(map);
     top =  max(map');
     map2 = map./repmat(top',1, col);
     imagesc(map2)
     xlabel('neurônios')
     ylabel('categorias')
     title(['taxa de acerto: '  num2str(100*score) '%'])
     colorbar;
     saveas( gcf,[Model.dir.layer1 Model.dir.winners 'map_neurons_categories_exec_' num2str(Model.test.iterator) '.png']);
    end;

end