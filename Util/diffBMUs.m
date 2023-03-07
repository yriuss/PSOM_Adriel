% Marcondes Ricarte

function evaluate = diffBMUs(Model, data, layer, munits, labels)

   
    if (layer == 2 || layer == 3) & strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;

    dataMax = [];
    for k = 1:numClass
        range = [((k-1)*munits)+1:(k*munits)];
        dataMax(:,k) = max(data(:,range)')';
    end;    

    [len, dim] = size(dataMax);
    count = 0;
    diff = [];
    lost = [];
    for k = 1:len
        k
        [bmus,indexes] = sort(dataMax(k,:),'desc');
        indexLost = find(indexes==labels(k)) - 1;
        if indexes(1) == labels(k)
            diff(k) = NaN;
        else
            diff(k) = dataMax(k,indexes(1)) / dataMax(k,labels(k));
        end;
        if indexLost == 0
            lost(k) = NaN;
        else
            lost(k) = indexLost;
        end;
    end;


    for k = 1:numClass
        range = find(labels == k);
        diffCategory(1,k) = nanmean(diff(1,range));
        lostCategory(1,k) = nanmean(lost(1,range));
    end;   
    meanDiffCategory = nanmean(diff);
    meanLostCategory = nanmean(lost);  
    
    
    evaluate.diff = diff;
    evaluate.lost = lost;    
    evaluate.diffCategory = diffCategory;
    evaluate.lostCategory = lostCategory;
    evaluate.meanDiffCategory = meanDiffCategory;
    evaluate.meanLostCategory = meanLostCategory;
end