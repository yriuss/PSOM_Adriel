
dirLayer = [];
for k=1:3
    if k == 1
        data = dataView1;
        dirLayer = Model.dir.layer2;
    elseif k == 2
        data = dataView2;
        dirLayer = Model.dir.layer3;
    elseif k == 3
        data = dataView3;
        dirLayer = Model.dir.layer4;
    end;
    
    scores = zeros(numClass,numClass);
    for i = 1:numClass
        indexs = DeepSOM{i}.indexsTrain;
        for j = 1:numClass
            begin = (j-1)*Model.numMap(k)+1;
            final = j*Model.numMap(k);
            scores(i,j) = mean(mean(data(indexs,begin:final)));
        end;
    end;

    imagesc(scores)
    xlabel('categories')
    ylabel('categories')
    title(['Intensity: '  num2str(mean(diag(scores)))])
    colorbar;
    saveas( gcf,[dirLayer Model.dir.categories 'confuse_matrix_intensity.png']);
end;