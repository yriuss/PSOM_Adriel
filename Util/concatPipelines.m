% Marcondes Ricarte

function [BMUsValues] = concatPipelines(Model, DeepSOM, layer, type,classes)


    if strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;

    BMUsValues = [];
    if strcmp(type,'train')
        for k = 1:numClass
            BMUsValues = [BMUsValues DeepSOM{k,layer}.BMUsValuesTrain];
        end;
    elseif strcmp(type,'test')
        for k = 1:numClass
            BMUsValues = [BMUsValues DeepSOM{k,layer}.BMUsValuesTest];
        end;
    elseif strcmp(type,'train_dual')
        for k = 1:numClass
            BMUsValues = [BMUsValues DeepSOM{k,layer}.BMUsValuesTrainDual];
        end;
    elseif strcmp(type,'test_dual')
        for k = 1:numClass
            BMUsValues = [BMUsValues DeepSOM{k,layer}.BMUsValuesTestDual];
        end;
    end;

end
