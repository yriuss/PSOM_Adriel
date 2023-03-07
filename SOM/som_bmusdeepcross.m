% Marcondes Ricarte

function [BMUsValues] = som_bmusdeepcross(Model, DeepSOM, layer, i, type, sigmaAtive)

    if strcmp(type,'train')
        [lenSamples,~] = size(DeepSOM{1,layer-1}.BMUsValuesTrain);
    elseif strcmp(type,'test')
        [lenSamples,~] = size(DeepSOM{1,layer-1}.BMUsValuesTest);
    end;    
    lenMaps = Model.multiple.numToyProblem;  

    BMUsValuesTemp = [];
    BMUsValues = [];
    [lenMap,~] = size(DeepSOM{i,layer}.sMap.codebook);
    for j = 1:lenSamples
        BMUsValuesTemp = [];
        for k = 1:lenMaps
            for k2 = 1:lenMaps
                indexes = ((k-1)*lenMap)+1:(k*lenMap);
                if strcmp(type,'train')
                    for m = 1:lenMap
                        distTemp(m) = sum((DeepSOM{k,layer}.sMap.codebook(m,:) - DeepSOM{k2,layer-1}.BMUsValuesTrain(j,:)).^2);  
                    end;                    
                elseif strcmp(type,'test')
                    for m = 1:lenMap
                        distTemp(m) = sum((DeepSOM{k,layer}.sMap.codebook(m,:) - DeepSOM{k2,layer-1}.BMUsValuesTest(j,:)).^2);  
                    end;
                end;
                BMUsValuesTemp = [BMUsValuesTemp exp(-sqrt(distTemp/sigmaAtive))];
            end;
        end;
        BMUsValues = [BMUsValues; BMUsValuesTemp];
    end;    
end

