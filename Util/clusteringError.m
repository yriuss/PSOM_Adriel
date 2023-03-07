% Marcondes Ricarte

function evaluate = clusteringError(Model,  data, DeepSOM, layer, labels)
    
    for i = 1: Model.multiple.numToyProblem        
        w = DeepSOM{i,layer}.sMap.codebook;
        [lenW,~] = size(w);
        indexes = find(labels == i);
        nData = length(indexes);
        count = 1;
        for k = indexes
            x = data(k,:);
            d = pdist2(x, w);
            [values(count), clusters(count)] = min(d);
            count = count + 1;
        end;    
        clustersNum = zeros(1,lenW);
        clustersValue = zeros(1,lenW);
        for k = 1:lenW
            clustersNum(k) = sum(clusters == k);        
        end;
        for k = 1:nData
            clustersValue(clusters(k)) = clustersValue(clusters(k)) + values(k); 
        end;
        for k = 1:lenW
            if clustersNum(k) > 0
                clustersValue(k) = clustersValue(k)/clustersNum(k);
            else
                clustersValue(k) = NaN;
            end;
        end;
        for k = 1:lenW
            if clustersNum(k) > 0
                clustersValue(k) = clustersValue(k)/clustersNum(k);
            else
                clustersValue(k) = NaN;
            end;
        end;
        evaluate{i}.clustersValue = clustersValue;
        evaluate{i}.clustersNum = clustersNum;
        evaluate{i}.clusterActive = sum(clustersNum ~= 0);
        evaluate{i}.error = nanmean(clustersValue);
    end;

end