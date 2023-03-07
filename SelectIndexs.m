% Marcondes Ricarte

function selected = SelectIndexs(SamplesTrain, class)

selected = [];
indexs = strcmp(class,SamplesTrain.labels);
[colIndex, rowIndex] = size(indexs);
for j=1:colIndex
    if indexs(j) == 1
        selected = [selected; j];
    end;
end;
