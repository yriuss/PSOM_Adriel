% Marcondes Ricarte

function [scores] = plotConfuseMatrixPipeline(label, Model, DeepSOM, Layer, numClass, dataView1, dataView2, dataView3, dataView4)

    scores = [];
    
    if strcmp(Model.flagPlotConfuseMatrix,'yes')
        dirLayer = [];
        for k=1:Layer
            dirLayer = GetLayerDir(Model, k);
            if k == 1
                data = dataView1;
            elseif k == 2
                data = dataView2;
            elseif k == 3
                data = dataView3;
            elseif k == 4
                data = dataView4;    
            end;

            scores = zeros(numClass,numClass);
            for i = 1:numClass
                if strcmp(label, 'train')
                    indexs = DeepSOM{i}.indexsTrain;
                elseif strcmp(label, 'test')
                    indexs = DeepSOM{i}.indexsTest;
                end;
                for j = 1:numClass
                    begin = (j-1)*Model.numMap(k)+1;
                    final = j*Model.numMap(k);
                    scores(i,j) = mean(mean(data(indexs,begin:final)));
                end;
            end;

            imagesc(scores)
            xlabel('categories')
            ylabel('categories')
            title(['Intensity(diag/mean): '  num2str(mean(diag(scores))/mean(scores(:)))])
            colorbar;
            saveas( gcf,[dirLayer Model.dir.categories label '_confuse_matrix_intensity.png']);
        end;
    end;
    
end