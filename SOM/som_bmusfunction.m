% Marcondes Ricarte

function [DeepSOM] = som_bmusfunction(Model, DeepSOM, layer, type, step, BMUsValuesCross, labels, fator, func)

    if strcmp(type,'train')
        [row col] = size(DeepSOM{1,layer}.BMUsValuesTrain);
    elseif strcmp(type,'test')
        [row col] = size(DeepSOM{1,layer}.BMUsValuesTest);
    end;
    

    steps = step*Model.multiple.numToyProblem;
    
    if strcmp(func,'cross')
        if strcmp(type,'train')
            for i = 1: row
                for j = 1:Model.multiple.numToyProblem
                    DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) = zeros(1,step); 
                    for k = 1:Model.multiple.numToyProblem
                        indexes = ((j-1)*steps)+(k-1)*step+1:((j-1)*steps)+k*step;
                        if k == j
                            DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) = DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) + BMUsValuesCross(i,indexes);
                        else
                            DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) = DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) - fator * BMUsValuesCross(i,indexes);
                        end;
                    end;
                end;
            end;
        elseif strcmp(type,'test')
            for i = 1: row
                for j = 1:Model.multiple.numToyProblem
                    DeepSOM{j,layer}.BMUsValuesTest(i,1:step) = zeros(1,step); 
                    for k = 1:Model.multiple.numToyProblem
                        indexes = ((j-1)*steps)+(k-1)*step+1:((j-1)*steps)+k*step;
                        if k == j
                            DeepSOM{j,layer}.BMUsValuesTest(i,1:step) = DeepSOM{j,layer}.BMUsValuesTest(i,1:step) + BMUsValuesCross(i,indexes);
                        else
                            DeepSOM{j,layer}.BMUsValuesTest(i,1:step) = DeepSOM{j,layer}.BMUsValuesTest(i,1:step) - fator * BMUsValuesCross(i,indexes);
                        end;
                    end;
                end;
            end;
        end;
    elseif strcmp(func,'sub')
        if strcmp(type,'train')
            for i = 1: row
                for j = 1:Model.multiple.numToyProblem
                    indexes = (j-1)*step+1:j*step;
                    DeepSOM{j,layer}.BMUsValuesTrain(i,1:step) = BMUsValuesCross(i,indexes);
                end;
            end;
        elseif strcmp(type,'test')
            for i = 1: row
                for j = 1:Model.multiple.numToyProblem
                    indexes = (j-1)*step+1:j*step;
                    DeepSOM{j,layer}.BMUsValuesTest(i,1:step) = BMUsValuesCross(i,indexes);
                end;
            end;
        end;
    end;
end