% Marcondes Ricarte

function [acurracy,matches,indexesWinners] = debugLocalWinners(Model, sData, data, dataDual, layer, munits, labels, order, fator)


    if (layer == 2 || layer == 3) & strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;

    for j = 1:munits
        dataMean = [];
        for k = 1:numClass
            range = [((k-1)*munits)+1:(k*munits)];
            dataSelect = data(:,range);
            dataSelectDual = dataDual(:,range);
            dataSelect2 = sort(dataSelect','descend');
            dataSelectDual2 = sort(dataSelectDual',order);
            if j ~= 1
                dataMean(:,k) = mean(dataSelect2(1:j,:))';
                dataMeanDual(:,k) = mean(dataSelectDual2(1:j,:))';
            else
                dataMean(:,k) = dataSelect2(1,:)';
                dataMeanDual(:,k) = dataSelectDual2(1,:)';                
            end;
        end;    

        dataMean = dataMean(:,1:numClass);
        dataMeanDual = dataMeanDual(:,1:numClass);
        dataMean = dataMean - fator*dataMeanDual;
        [len, dim] = size(dataMean);
        count = 0;
        for k = 1:len
            if labels(k) <= numClass 
                category(k) = labels(k);
                [~, index] = sort(dataMean(k,:),'descend');
                detected(k) = index(1);
                count = count + 1;
            end;
        end;
        
        acurracy(j) = sum(detected == category)/count;
        matches(j,:) = (detected == category);
        indexesWinners(j,:) = detected;
    end;

end