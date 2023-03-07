% Marcondes Ricarte

function [Model, DeepSOM] = computeSubSOM(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r)

DeepSOMBegin = DeepSOM;
epochsGlobal = [10 100 500]; %[10 100 500 1000];
alphaGlobal = [0.01 0.001 0.0001] ; %[0.01 0.001 0.0001 0.00001] ;
relevance = {'no','no','no','no','no'}; % 'no', 'yes'
relevanceNorm = {'no'}; %{'no','yes'};
confuseNode = 'matrix'; % 'matrix', 'cosine' 
samplesTrainType = 'samplesNode'; % 'samplesNode', 'samplesNodeCosPair'
if  strcmp(confuseNode,'matrix')
    thresholdGlobal = [0];
elseif  strcmp(confuseNode,'cosine')
    thresholdGlobal = [0.80:0.05:0.90];
end;

resultsTrain = [];
resultsTest = [];
indexLog = 1;

for relevanceNormIt = 1:length(relevanceNorm)
for epochIt = 1:length(epochsGlobal)
for alphaIt = 1:length(alphaGlobal)
for thresholdIt = 1:length(thresholdGlobal)    

DeepSOM = DeepSOMBegin;    
epochs = epochsGlobal(epochIt);
alphaBegin = alphaGlobal(alphaIt);
alphaEnd = 0.01 * alphaGlobal(alphaIt);
tau = (alphaEnd - alphaBegin) / (epochs-1);
alpha = tau * ([1:epochs] - 1) + alphaBegin; 


[cosine, near] = calculateMatrixCos(Model, DeepSOM, layer, thresholdGlobal(thresholdIt), 'full');    


    for pipeline = 1:Model.multiple.numToyProblem
        if layer == 1
            dataSamplesTrain.data = SamplesTrain.data;
            dataSamplesTest.data = SamplesTest.data;
            DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],'euclidian',layer,[]);
            DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],'euclidian',layer,[]);
        else
            dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
            dataSamplesTest.data = DeepSOM{pipeline,layer-1}.BMUsValuesTest;  
            DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
            DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);        
        end;

    end;

    dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
    dataTest = concatPipelines(Model, DeepSOM, layer, 'test', Model.multiple.numToyProblem);   

    [acurracyDensityTrain,~,ratioBMUsTrain,macthesDensityTrain,~,indexesWinnersTrain, errorMatrix,correctNodes,incorrectNodes,pipelineCorrectOrderTrain, errorMatrixSamplesTrain, correctNodeGlobalOrderTrain] = ... 
        debugMeanWinners(Model, dataTrain, layer, Model.multiple.numMap(layer), train_labels,'descend');
    [acurracyDensityTest,~,ratioBMUsTest,macthesDensityTest,~,indexesWinnersTest, errorMatrix,correctNodesTest,incorrectNodesTest,pipelineCorrectOrderTest, errorMatrixSamplesTest, correctNodeGlobalOrderTest] = ...
        debugMeanWinners(Model, dataTest, layer, Model.multiple.numMap(layer), test_labels,'descend');
    

    
    
    
    for cat = 1:Model.multiple.numToyProblem
        for node = 1: Model.multiple.numMap(layer)
            DeepSOM{cat,layer}.subNetwork{node}.samples = [];
            DeepSOM{cat,layer}.subNetwork{node}.categories = [];
            DeepSOM{cat,layer}.subNetwork{node}.match = [];
            DeepSOM{cat,layer}.subNetwork{node}.samplesTest = [];
            DeepSOM{cat,layer}.subNetwork{node}.categoriesTest = [];
            DeepSOM{cat,layer}.subNetwork{node}.matchTest = [];            
        end;
    end;
        
    for sample = 1:length(train_labels)
        cat = indexesWinnersTrain(sample);
        [~,nodeGlobal] = max(dataTrain(sample,:));
        node = mod(nodeGlobal, Model.multiple.numMap(layer));
        if node  == 0
            node = Model.multiple.numMap(layer);
        end;
        DeepSOM{cat,layer}.subNetwork{node}.samples = [DeepSOM{cat,1}.subNetwork{node}.samples sample]; 
        DeepSOM{cat,layer}.subNetwork{node}.categories = [DeepSOM{cat,layer}.subNetwork{node}.categories train_labels(sample)];
        DeepSOM{cat,layer}.subNetwork{node}.match = [DeepSOM{cat,layer}.subNetwork{node}.match macthesDensityTrain(sample)];
    end;
    
    
    for sample = 1:length(test_labels)
        cat = indexesWinnersTest(sample);
        [~,nodeGlobal] = max(dataTest(sample,:));
        node = mod(nodeGlobal, Model.multiple.numMap(layer));
        if node  == 0
            node = Model.multiple.numMap(layer);
        end;
        DeepSOM{cat,layer}.subNetwork{node}.samplesTest = [DeepSOM{cat,1}.subNetwork{node}.samplesTest sample]; 
        DeepSOM{cat,layer}.subNetwork{node}.categoriesTest = [DeepSOM{cat,layer}.subNetwork{node}.categoriesTest test_labels(sample)];
        DeepSOM{cat,layer}.subNetwork{node}.matchTest = [DeepSOM{cat,layer}.subNetwork{node}.matchTest macthesDensityTest(sample)];
    end;    
    
    if layer == 1
        [~,dim] = size(SamplesTrain.data);
    else
        [~,dim] = size(DeepSOM{cat,layer-1}.BMUsValuesTrain);
    end;

    nearCopy = near;
    for cat = 1:Model.multiple.numToyProblem
        for node = 1: Model.multiple.numMap(layer)
            near = nearCopy;
            if strcmp(confuseNode,'matrix')
                confuse = sum(DeepSOM{cat,layer}.subNetwork{node}.match == 0) > 0;
            elseif  strcmp(confuseNode,'cosine')
                indexes = find(near.cat1 == cat & near.node1 == node);
                if length(indexes) > 0
                    [maxScore, maxIndex] = max(near.score(indexes));
                    confuseCat = near.cat2(indexes(maxIndex));
                    confuseNodeIndex = near.node2(indexes(maxIndex));
                    confuse = 1;
                else
                    confuse = 0;
                end;
            end;
            if confuse
                DeepSOM{cat,layer}.subNetwork{node}.hasError = 1;
                if strcmp(samplesTrainType,'samplesNode')
                    samples = DeepSOM{cat,layer}.subNetwork{node}.samples;
                    categories = DeepSOM{cat,layer}.subNetwork{node}.categories;
                elseif strcmp(samplesTrainType,'samplesNodeCosPair')
                    samples = [DeepSOM{cat,layer}.subNetwork{node}.samples DeepSOM{confuseCat,layer}.subNetwork{confuseNodeIndex}.samples];
                    categories = [DeepSOM{cat,layer}.subNetwork{node}.categories DeepSOM{confuseCat,layer}.subNetwork{confuseNodeIndex}.categories];                    
                end;
                if strcmp(confuseNode,'matrix')
                    uniqueCategories = unique(categories);
                elseif  strcmp(confuseNode,'cosine')
                    uniqueCategories = [cat confuseCat];
                end;
                DeepSOM{cat,layer}.subNetwork{node}.codebook = zeros(Model.multiple.numToyProblem, 4096);
                DeepSOM{cat,layer}.subNetwork{node}.relevance = ones(Model.multiple.numToyProblem,4096);
                for cat2 = uniqueCategories
                    DeepSOM{cat,layer}.subNetwork{node}.codebook(cat2,:) = DeepSOM{cat,layer}.sMap.codebook(node,:);
                    if strcmp(relevance{layer},'no')
                        DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) = DeepSOM{cat,layer}.relevance(node,:);                        
                    elseif strcmp(relevance{layer},'yes')
                       indexesSamples =  samples(find(categories == cat2));
                       if layer == 1
                           if length(indexesSamples) > 1
                                DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) = 1 - var( SamplesTrain.data( indexesSamples ,:) );
                           else
                               indexesSamples = find(train_labels == cat2);
                               DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) = 1 - var( SamplesTrain.data( indexesSamples ,:) );
                           end;
                           if strcmp(relevanceNorm{relevanceNormIt},'yes')
                               DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) = ...
                                   DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) / mean(DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:));
                           end;
                       else
                           DeepSOM{cat,layer}.subNetwork{node}.relevance(cat2,:) = [];
                       end;
                    end;
                end;
                
                for epoch = 1:epochs
                    order = randperm(length(samples));

                    %%% debug %%%
                    indexLog = 1;
                    Dist = nansum(  ( DeepSOM{cat,layer}.subNetwork{node}.relevance .*  (( SamplesTrain.data( 424 ,:) - DeepSOM{cat,layer}.subNetwork{node}.codebook ).^2) )' )  ; % TODO
                    distLog{indexLog}(epoch, 1) = Dist(1,1);
                    distLog{indexLog}(epoch, 2) = Dist(1,5);
                    indexLog = indexLog + 1;                        
                    for debugSample = [474 494 519 540 543]                            
                    Dist = nansum(  ( DeepSOM{cat,layer}.subNetwork{node}.relevance .*  (( SamplesTest.data( debugSample ,:) - DeepSOM{cat,layer}.subNetwork{node}.codebook ).^2) )' )  ; % TODO
                    distLog{indexLog}(epoch, 1) = Dist(1,1);
                    distLog{indexLog}(epoch, 2) = Dist(1,5);
                    indexLog = indexLog + 1;
                    end;
                    %%%%%%%%%%%%%%                    
                    
                    for i = 1:length(samples)
                        indexSample = samples(order(i)); 
                        indexCat = categories(order(i));
                        
                        if layer == 1 
                            x = SamplesTrain.data( indexSample ,:);
                        else
                            x = []; %DeepSOM{category,layer-1}.BMUsValuesTrain( indexSample ,:);                  
                        end;
                        
                        Dx = (x - DeepSOM{cat,layer}.subNetwork{node}.codebook(indexCat,:) );  
                        
                       
                        DeepSOM{cat,layer}.subNetwork{node}.codebook(indexCat,:) = DeepSOM{cat,layer}.subNetwork{node}.codebook(indexCat,:) ...
                            + alpha(epoch) * DeepSOM{cat,layer}.subNetwork{node}.relevance(indexCat,:)  .* Dx; %Learn                             
                    end;
                end;
            
            else
                DeepSOM{cat,layer}.subNetwork{node}.hasError = 0;
            end;            
        end;
    end;
    near = nearCopy;
    
    
    samplesTrain = find(macthesDensityTrain == 0);
    for cat = 1:Model.multiple.numToyProblem
        for node = 1: Model.multiple.numMap(layer)
            if DeepSOM{cat,layer}.subNetwork{node}.hasError == 1
                samples = DeepSOM{cat,layer}.subNetwork{node}.samples;
                for sample = samples
                    if layer == 1 
                        x = SamplesTrain.data( sample ,:);
                    else
                        x = []; %DeepSOM{category,layer-1}.BMUsValuesTrain( indexSample ,:);                  
                    end;
                    Dist = nansum(  ( DeepSOM{cat,layer}.subNetwork{node}.relevance .*  (( x - DeepSOM{cat,layer}.subNetwork{node}.codebook ).^2) )' )  ; % TODO
                    [~,indexCat] = min(Dist);
                    indexesWinnersTrain(sample) = indexCat;
                end;
            end;
        end;
    end;
    resultsTrain = [resultsTrain sum(indexesWinnersTrain == train_labels)/ length(train_labels) ];
    
    
    samplesTest = find(macthesDensityTest == 0);
    for cat = 1:Model.multiple.numToyProblem
        for node = 1: Model.multiple.numMap(layer)
            if DeepSOM{cat,layer}.subNetwork{node}.hasError == 1
                samples = DeepSOM{cat,layer}.subNetwork{node}.samplesTest; 
                for sample = samples
                    if layer == 1 
                        x = SamplesTest.data( sample ,:);
                    else
                        x = []; %DeepSOM{category,layer-1}.BMUsValuesTrain( indexSample ,:);                  
                    end;
                    Dist = nansum(  ( DeepSOM{cat,layer}.subNetwork{node}.relevance .*  (( x - DeepSOM{cat,layer}.subNetwork{node}.codebook ).^2) )' )  ; % TODO
                    [~,indexCat] = min(Dist);
                    %['Sample: ' int2str(sample) '. indexesWinnersTest: ' int2str(indexesWinnersTest(sample)) '. new cat: ' int2str(indexCat)]
                    indexesWinnersTest(sample) = indexCat;
                end;
            end;
        end;
    end;
    resultsTest = [resultsTest sum(indexesWinnersTest == test_labels)/ length(test_labels) ];    

    

    Model.test.layer{1,layer+1}.indexesWinnersSubSOMTrainLog{r}(indexLog,:) = indexesWinnersTrain;
    Model.test.layer{1,layer+1}.indexesWinnersSubSOMTestLog{r}(indexLog,:) = indexesWinnersTest;
    indexLog = indexLog + 1;
    
end;
end;
end;
end;

    
    Model.test.layer{1,layer+1}.scoreSubNetworkTrainLog(r,:) = resultsTrain;
    Model.test.layer{1,layer+1}.scoreSubNetworkTestLog(r,:) = resultsTest;
    
end