% Marcondes Ricarte

function [score] = plotConfuseMatrixUnique(Model, sMap, numClass)

    if strcmp(Model.flagPlotConfuseMatrix,'yes')
     [victoriesMax, victoriesMaxIndex] = max(sMap.victories');
     victoriesSum = sum(sMap.victories');
     victoriesPercent = victoriesMax./victoriesSum;             
     victoriesMaxIndex(victoriesMax==0) = 0;
     confuse = sMap.victories'./repmat(victoriesSum,numClass,1);
     score = sum(victoriesMax)/sum(victoriesSum);
     imagesc(confuse)
     xlabel('nodos')
     ylabel('taxa de acerto da categoria')
     title(['taxa de acerto: '  num2str(100*score) '%'])
     colorbar;
     saveas( gcf,[Model.dir.layer1 Model.dir.winners 'confuse_matrix_category_exec_' num2str(Model.test.iterator) '.png']);
    end;

end