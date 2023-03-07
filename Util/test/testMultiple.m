% Marcondes Ricarte

function [score, confuseMatrix, compare] = testMultiple(Model, DeepSOM, Samples, labels, type)
    
    score = 0;
    layer = Model.j;
    [lenSamples,~] = size(Samples.data);
    lenMaps = length(DeepSOM);
    
    %minDistSampleMap = zeros(lenSamples,lenMaps);
    distMeanTotal = [];
    for i = 1:lenMaps
        [lenMap,~] = size(DeepSOM{i,layer}.sMap.codebook);
        dist = [];
        for j = 1:lenSamples
            for k = 1:lenMap            
                if layer == 1
                    dist(j,k) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - Samples.data(j,:)).^2));
                else
                    if type == 1 % train
                        if layer == 2 && strcmp(Model.multiple.trainUnlearnType2,'cross') 
                            dist(j,k) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{i,layer-1}.BMUsValuesTrain(j,:)).^2));    
                            for m = 1:lenMaps
                                distTemp(m) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{m,layer-1}.BMUsValuesTrain(j,:)).^2));  
                            end;
                            distMean(j,k) = min(distTemp); %min(distTemp);
                        else
                            dist(j,k) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{i,layer-1}.BMUsValuesTrain(j,:)).^2));
                        end;
                    elseif type == 2 % test
                        if layer == 2 && strcmp(Model.multiple.trainUnlearnType2,'cross') 
                            dist(j,k) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{i,layer-1}.BMUsValuesTest(j,:)).^2));    
                            for m = 1:lenMaps
                                distTemp(m) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{m,layer-1}.BMUsValuesTest(j,:)).^2));  
                            end;
                            distMean(j,k) = min(distTemp); %mean(distTemp);
                        else
                            dist(j,k) = sqrt(sum((DeepSOM{i,layer}.sMap.codebook(k,:) - DeepSOM{i,layer-1}.BMUsValuesTest(j,:)).^2));
                        end;
                    end;
                end;
            end;            
        end;
        minDistSampleMap(:,i) = min(dist')';
        meanDistSampleMap(:,i) = mean(dist')';
        if layer == 2 && strcmp(Model.multiple.trainUnlearnType2,'cross') 
            distMeanTotal = [distMeanTotal distMean];
            meanDistMeanSampleMap(:,i) = min(distMean')';
        end;
    end;
    
    [distSampleMap, indexSampleMap] = min(minDistSampleMap');
    if layer == 2 && strcmp(Model.multiple.trainUnlearnType2,'cross') 
        [distMeanSampleMap, indexMeanSampleMap] = min(meanDistMeanSampleMap');
        %indexSampleMap = indexMeanSampleMap;
    end;
    
    confuseMatrix = zeros(lenMaps,lenMaps);
    for i = 1:lenSamples
         confuseMatrix(strmatch(Samples.labels(i), labels, 'exact'),indexSampleMap(i)) = ...
             confuseMatrix(strmatch(Samples.labels(i), labels, 'exact'),indexSampleMap(i)) + 1;
         compare(i) = (strmatch(Samples.labels(i), labels, 'exact') == indexSampleMap(i));
    end;
    score = sum(diag(confuseMatrix))/lenSamples; % diag(confuseMatrix)'./sum(confuseMatrix')
    imagesc(confuseMatrix./repmat(sum(confuseMatrix)',1,lenMaps))
    colorbar;
end