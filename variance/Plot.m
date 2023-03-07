type = 'means' ; % 'all', 'means' 
epsilon = 0.001;

dataTrain = [];
for i = 1:Model.multiple.numToyProblem
    selectedTrain = find( train_labels == i );
    if strcmp(type,'all')
        dataTrain = [dataTrain; DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:) ];    
    elseif strcmp(type,'means')
        dataTrain = [dataTrain; mean(DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:)) ];    
    end;
end;
for i = 1:Model.multiple.numToyProblem
    variance{i} = var(dataTrain);
end;


dataTrain = [];
for i = 1:Model.multiple.numToyProblem
    dataTrain{i} = [];
    for j = 1:Model.multiple.numToyProblem
        selectedTrain = find( train_labels == j );
        if strcmp(type,'all')
            dataTrain{i} = [dataTrain{i}; DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:) ];  
        elseif strcmp(type,'means')
            dataTrain{i} = [dataTrain{i}; mean(DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:)) ];   
        end;            
    end;
    variancePipeline{i} = var(dataTrain{i});
end   


dataTrain = [];
for i = 1:Model.multiple.numToyProblem
    dataTrain{i} = [];
    dataTrainCat = [];
    for j = 1:Model.multiple.numToyProblem
        if i ~= j
            selectedTrain = find( train_labels == j );
            if strcmp(type,'all')
                dataTrain{i} = [dataTrain{i}; DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:) ];     
            elseif strcmp(type,'means')
                dataTrain{i} = [dataTrain{i}; mean(DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:)) ];  
            end;
        else
            selectedTrain = find( train_labels == j );
            dataTrainCat = DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:);
        end;
    end;
    varianceBinary{i} = varBinary(dataTrain{i}, mean(dataTrainCat));
end;   

%plotVariance(variance, variancePipeline, varianceBinary, 0.5);
plotVariance(variance, variancePipeline, varianceBinary, 0.1, 4096, 1000);



% norm
for i = 1:Model.multiple.numToyProblem
    minDataTrain = min(variance{i});
    maxDataTrain = max(variance{i});
    variance{i} = (variance{i} - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);    
    minDataTrain = min(variancePipeline{i} );
    maxDataTrain = max(variancePipeline{i} );
    variancePipeline{i} = (variancePipeline{i}  - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);
    minDataTrain = min(varianceBinary{i} );
    maxDataTrain = max(varianceBinary{i} );
    varianceBinary{i} = (varianceBinary{i}  - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);    
end



%% plot
plotVariance(variance, variancePipeline, varianceBinary, 1, 4096, 1000);


% norm
% % for i = 1:Model.multiple.numToyProblem
% %     minDataTrain = min(variance{i});
% %     maxDataTrain = max(variance{i});
% %     variance{i} = (variance{i} - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);    
% %     minDataTrain = min(variancePipeline{i} );
% %     maxDataTrain = max(variancePipeline{i} );
% %     variancePipeline{i} = (variancePipeline{i}  - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);
% %     minDataTrain = min(varianceBinary{i} );
% %     maxDataTrain = max(varianceBinary{i} );
% %     varianceBinary{i} = (varianceBinary{i}  - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon);    
% % end;



% mult
dataTrain = [];
for i = 1:Model.multiple.numToyProblem
    selectedTrain = find( (train_labels == i)  );
    dataTrain{i} =  [DeepSOM{i,layer-1}.BMUsValuesTrain(selectedTrain,:)];  
    varianceIntra{i} = 1 - var( dataTrain{i} );
end;   

for i = 1:Model.multiple.numToyProblem
    minDataTrain = min(varianceIntra{i} );
    maxDataTrain = max(varianceIntra{i} );
    varianceIntra{i} = (varianceIntra{i}  - minDataTrain + epsilon)/(maxDataTrain - minDataTrain + epsilon); 
    
    varianceNorm{i} = variance{i} .* varianceIntra{i};
    variancePipelineNorm{i} = variancePipeline{i} .*  varianceIntra{i};
    varianceBinaryNorm{i} = varianceBinary{i} .* varianceBinary{i};
end;;


%% plot mult
plotVariance(varianceNorm, variancePipelineNorm, varianceBinaryNorm,  1, 4096, 1000);



% norm_max
for i = 1:Model.multiple.numToyProblem
    varianceNormMax{i} = variance{i} .* varianceIntra{i};
    variancePipelineNormMax{i} = variancePipeline{i} .*  varianceIntra{i};
    varianceBinaryNormMax{i} = varianceBinary{i} .* varianceBinary{i};
end;;


for i = 1:Model.multiple.numToyProblem
    varianceNormMax{i} = varianceNormMax{i}/sum(varianceNormMax{i});
    variancePipelineNormMax{i} = variancePipelineNormMax{i}/sum(variancePipelineNormMax{i});
    varianceBinaryNormMax{i} = varianceBinaryNormMax{i}/sum(varianceBinaryNormMax{i});
end;;

%% plot mult
plotVariance(varianceNormMax, variancePipelineNormMax, varianceBinaryNormMax,  0.003, 4096, 1000);

