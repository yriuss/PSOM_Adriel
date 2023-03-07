% Marcondes Ricarte

function [dataOutput] = selectGlobalBmus(data, msize, Model, indexes, layer)


    fator = Model.multiple.fator(Model.i, Model.j);
    if strcmp(Model.multiple.filterType, 'global_attenuate_for_pipeline')
        fatorBase = Model.multiple.fatorBase(Model.j);
    end;
    
    if strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;
    
    if strcmp(Model.multiple.filterType, 'global')
        [samples,attributes] = size(data);
        step = attributes/Model.numClasses;
        for i = 1:Model.numClasses
            dataMean(:,i) = mean(data(:,((i-1)*step+1):(i*step))')';
        end;

        [values index] = max(dataMean');

        dataOutput = zeros(samples, attributes);
        counts = [];

        for i=1:samples
            floor = values(i);
            count = 0;
            for j=1:attributes  % TODO: Otimizar
                if data(i,j) > floor 
                    dataOutput(i,j) = data(i,j);
                    count = count + 1;
                end;
            end;
            counts = [counts count];
        end;   
    elseif strcmp(Model.multiple.filterType, 'global_attenuate')
        [samples,attributes] = size(data);
        step = attributes/numClass;
        indexes = [];
        for i=1:samples
            for j = 1:numClass
                top(i,j) = max(data(i,((j-1)*step+1):(j*step))); 
            end;
        end;
        [~,indexes] = max(top');
        
        dataOutput = fator*data;
        for i=1:samples
            dataOutput(i,((indexes(i)-1)*step+1):((indexes(i)*step))') = data(i,((indexes(i)-1)*step+1):((indexes(i)*step))');
        end;

    elseif strcmp(Model.multiple.filterType, 'global_attenuate_for_pipeline')    
        [samples,attributes] = size(data);
        step = attributes/Model.numClasses;
        for i=1:samples
            for j = 1:Model.numClasses
                maxPipeline(i,j) = max(data(i,((j-1)*step+1):(j*step))); %max(DeepSOM{j,Model.j}.BMUsValuesTrain(i,:));
                meanPipeline(i,j) = mean(data(i,((j-1)*step+1):(j*step)));
            end;
        end;
        [~,indexes] = max(maxPipeline');
                
        dataOutput = data;
        for i=1:samples
            gaps = [];
            index = indexes(i);
            for j = 1:Model.numClasses
                if index ~= j
                    gaps(j) = fator * mean(data(i,((index-1)*step+1):(index*step))) / mean(data(i,((j-1)*step+1):(j*step)));
                    if gaps(j) > fator | gaps(j) < fatorBase    
                        gaps(j) = fatorBase;
                    end;
                else
                    gaps(j) = 1;
                end;
            end;
            for j = 1:Model.numClasses
                dataOutput(i,((j-1)*step+1):(j*step)) = gaps(j) * data(i,((j-1)*step+1):(j*step));
            end;    
                
        end;
    end;
end