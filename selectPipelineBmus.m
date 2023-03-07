% Marcondes Ricarte

function [dataTrain] = selectPipelineBmus(dataTrain, msize, Model)

    if strcmp(Model.pipelineExec,'single')
        fator = Model.single.fator;
    elseif strcmp(Model.pipelineExec,'multiple')
        fator = Model.multiple.fator(Model.i, Model.j);
    end;

    [classLength, dlen] = size(dataTrain);
    if strcmp(Model.multiple.filterType, 'local')
        dataTrainSort = zeros(classLength, dlen);
        index = zeros(classLength, dlen);
        for i=1:classLength
            [dataTrainSort(i,:), index(i,:)] = sort(dataTrain(i,:),'descend');
        end;
        dataTrainOutput = zeros(classLength, dlen);
        counts = [];
        for i=1:classLength
            floor = mean(dataTrainSort(i,:)) + fator * std(dataTrainSort(i,:));
            count = 0;
            for j=1:msize
                if dataTrain(i,j) > floor 
                    dataTrainOutput(i,j) = dataTrain(i,j);
                    count = count + 1;
                end;
            end;
            counts = [counts count];
        end;
        dataTrain = dataTrainOutput;
    elseif strcmp(Model.multiple.filterType, 'local_percentual')
        dataTrainOutput = zeros(classLength, dlen);
        counts = [];
        for i=1:classLength
            floor = fator * max(dataTrain(i,:));
            count = 0;
            for j=1:msize
                if dataTrain(i,j) > floor 
                    dataTrainOutput(i,j) = dataTrain(i,j);
                    count = count + 1;
                end;
            end;
            counts = [counts count];
        end;                
    end;
    dataTrain = dataTrainOutput;
    
end