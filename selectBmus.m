% Marcondes Ricarte

function BMUsValues = selectBmus(BMUsValues, msize, Model)

if strcmp(Model.pipelineExec,'single')
    fator = Model.single.fator;
elseif strcmp(Model.pipelineExec,'multiple')
    fator = Model.multiple.fator(Model.i, Model.j);
end;

if strcmp(Model.single.filter,'yes')

    [values index] = max(BMUsValues');
    [classLength dlen] = size(BMUsValues); 

    BMUsValuesSort = zeros(classLength, dlen);
    index = zeros(classLength, dlen);
    for i=1:classLength
        [BMUsValuesSort(i,:), index(i,:)] = sort(BMUsValues(i,:),'descend');
    end;
    BMUsValuesOutput = zeros(classLength, dlen);
    counts = [];

    for i=1:classLength
        floor = mean(BMUsValuesSort(i,:)) + fator * std(BMUsValuesSort(i,:));
        count = 0;
        for j=1:msize 
            if BMUsValues(i,j) > floor 
                BMUsValuesOutput(i,j) = BMUsValues(i,j);
                count = count + 1;
            end;
        end;
        if count == 0
            BMUsValuesOutput(i,index(i,1)) = BMUsValuesSort(i,1);
            count = 1;
        end;
        counts = [counts count];
    end;
    BMUsValues = BMUsValuesOutput;   
    
end;