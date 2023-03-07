% Marcondes Ricarte

function [dataTrain, dataTest, DeepSOM, Model] = filterAndPropagate(Model, SamplesTrain, SamplesTest, dataTrain, dataTest, DeepSOM, i, j, r, numNeuron)


    if strcmp(Model.multiple.prototype(i),'no') && ~(strcmp(Model.multiple.distanceType(i),'relevance_prototype') || strcmp(Model.multiple.distanceType(i),'relevance_active') || strcmp(Model.multiple.distanceType(i),'relevance_mirror'))
        if strcmp(Model.multiple.filterType, 'global') || strcmp(Model.multiple.filterType, 'global_attenuate') ...
                || strcmp(Model.multiple.filterType, 'global_attenuate_for_pipeline') 
            Model.i = j;
            Model.j = i;
            [~, maxIndexDensity] = ...
                max(Model.test.layer{i+1}.meanAcurracyDensityTest);
            [dataTrainFilter] = selectGlobalBmus( dataTrain, numNeuron, Model,Model.test.layer{i+1}.indexesWinnersTrain{r}(maxIndexDensity,:),i); 
            [dataTestFilter] = selectGlobalBmus( dataTest, numNeuron, Model,Model.test.layer{i+1}.indexesWinnersTest{r}(maxIndexDensity,:),i); 
            for k = 1:Model.multiple.numToyProblem 
                DeepSOM{k,i}.BMUsValuesTrain = dataTrainFilter(:,((k-1)*numNeuron)+1:(k*numNeuron));
                DeepSOM{k,i}.BMUsValuesTest = dataTestFilter(:,((k-1)*numNeuron)+1:(k*numNeuron));
            end;
        elseif strcmp(Model.multiple.filterType, 'local') || strcmp(Model.multiple.filterType, 'local_percentual')
            if strcmp(Model.multiple.filterType, 'local')
                for j=1:Model.multiple.numToyProblem
                    Model.i = j;
                    Model.j = i;
                    [DeepSOM{j,i}.BMUsValuesTrain] = ...
                        selectPipelineBmus(DeepSOM{j,i}.BMUsValuesTrain, numNeuron, Model);
                    [DeepSOM{j,i}.BMUsValuesTest] = ...
                        selectPipelineBmus(DeepSOM{j,i}.BMUsValuesTest, numNeuron, Model);
                end;
            elseif strcmp(Model.multiple.filterType, 'local_percentual')
                for j=1:numClass
                    Model.i = j;
                    Model.j = i;
                    [DeepSOM{j,i}.BMUsValuesTrain] = ...
                        selectPipelineBmus(DeepSOM{j,i}.BMUsValuesTrain, numNeuron, Model);
                    [DeepSOM{j,i}.BMUsValuesTest] = ...
                        selectPipelineBmus(DeepSOM{j,i}.BMUsValuesTest, numNeuron, Model);
                end;
            end;

            dataTrainFilter = [];
            dataConvolutionTrainFilter = [];
            dataTestFilter = [];
            for k = 1:Model.multiple.numToyProblem
                dataTrainFilter = [dataTrainFilter DeepSOM{k,i}.BMUsValuesTrain];
                dataTestFilter = [dataTestFilter DeepSOM{k,i}.BMUsValuesTest];
            end;

        end;
        dataTrain = dataTrainFilter;
        dataTest = dataTestFilter;  
    elseif ~strcmp(Model.multiple.prototype(i),'no')
        dataTrain = [];
        dataTest = [];
        if strcmp(Model.multiple.prototype(i),'standard')
            if i == 1
                for k = 1:Model.multiple.numToyProblem 
                    distPrototypes = pdist2(SamplesTrain.data,DeepSOM{k,i}.sMap.codebook);
                    [~,indexesPrototypes] = min(distPrototypes');
                    DeepSOM{k,i}.BMUsValuesTrain = DeepSOM{k,i}.sMap.codebook(indexesPrototypes,:);
                    distPrototypes = pdist2(SamplesTest.data,DeepSOM{k,i}.sMap.codebook);
                    [~,indexesPrototypes] = min(distPrototypes');
                    DeepSOM{k,i}.BMUsValuesTest = DeepSOM{k,i}.sMap.codebook(indexesPrototypes,:);
                end;
                dataTrain = [dataTrain DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTrain];
                dataTest = [dataTest DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTest];                
            else
                for k = 1:Model.multiple.numToyProblem 
                    distPrototypes = pdist2(DeepSOM{k,i-1}.BMUsValuesTrain, DeepSOM{k,i}.sMap.codebook);
                    [~,indexesPrototypes] = min(distPrototypes');
                    DeepSOM{k,i}.BMUsValuesTrain = DeepSOM{k,i}.sMap.codebook(indexesPrototypes,:);
                    distPrototypes = pdist2(DeepSOM{k,i-1}.BMUsValuesTest, DeepSOM{k,i}.sMap.codebook);
                    [~,indexesPrototypes] = min(distPrototypes');
                    DeepSOM{k,i}.BMUsValuesTest = DeepSOM{k,i}.sMap.codebook(indexesPrototypes,:);                  
                end;
                dataTrain = [dataTrain DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTrain];
                dataTest = [dataTest DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTest];                  
            end;
        elseif strcmp(Model.multiple.prototype(i),'bestSum')
            range = Model.multiple.prototypeRange(i);
            for k = 1:Model.multiple.numToyProblem 
                if i ~= 1
                    SamplesTrain.data = DeepSOM{k,i-1}.BMUsValuesTrain;
                    SamplesTest.data = DeepSOM{k,i-1}.BMUsValuesTest;
                end;                
                activationPrototypes = som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTrain, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'prototype',i); %SamplesTrain.data;
                distPrototypes = DeepSOM{k,i}.BMUsValuesTrain; %%som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTrain, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'euclidian',i); %SamplesTrain.data;
                [prototypeWeights,prototypesIndexes] = sort(distPrototypes','descend');
                prototypesIndexes = prototypesIndexes';
                prototypeWeights = prototypeWeights';
                prototypeSumWeights = sum(prototypeWeights(:,1:range)');
                prototypeWeights = prototypeWeights(:,1:range)./repmat(prototypeSumWeights',1,range);
                [rowWeights,colWeights] = size(SamplesTrain.data);
                [~,colCodebook] = size(DeepSOM{k,i}.sMap.codebook);
                DeepSOM{k,i}.BMUsValuesTrain = zeros(rowWeights, colWeights);
                for k2 = 1:Model.multiple.prototypeRange(i)                        
                    DeepSOM{k,i}.BMUsValuesTrain = DeepSOM{k,i}.BMUsValuesTrain + repmat(prototypeWeights(:,k2),1,colCodebook).*DeepSOM{k,i}.sMap.codebook(prototypesIndexes(:,k2),:);
                end;

                activationPrototypes = som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTest, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'prototype',i); %SamplesTrain.data;
                distPrototypes = DeepSOM{k,i}.BMUsValuesTest; %%som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTest, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'euclidian',i); %SamplesTrain.data;
                [prototypeWeights,prototypesIndexes] = sort(distPrototypes','descend');
                prototypesIndexes = prototypesIndexes';
                prototypeWeights = prototypeWeights';
                prototypeSumWeights = sum(prototypeWeights(:,1:range)');
                prototypeWeights = prototypeWeights(:,1:range)./repmat(prototypeSumWeights',1,range);
                [rowWeights,colWeights] = size(SamplesTest.data);
                [~,colCodebook] = size(DeepSOM{k,i}.sMap.codebook);
                DeepSOM{k,i}.BMUsValuesTest = zeros(rowWeights, colWeights);
                for k2 = 1:Model.multiple.prototypeRange(i)                        
                    DeepSOM{k,i}.BMUsValuesTest = DeepSOM{k,i}.BMUsValuesTest + repmat(prototypeWeights(:,k2),1,colCodebook).*DeepSOM{k,i}.sMap.codebook(prototypesIndexes(:,k2),:);
                end;
                dataTrain = [dataTrain DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTrain];
                dataTest = [dataTest DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTest];    
            end;            
        elseif strcmp(Model.multiple.prototype(i),'n_prototypes')
            range = Model.multiple.prototypeRange(i);
            for k = 1:Model.multiple.numToyProblem 
                if i ~= 1
                    SamplesTrain.data = DeepSOM{k,i-1}.BMUsValuesTrain;
                    SamplesTest.data = DeepSOM{k,i-1}.BMUsValuesTest;
                end;                
                
                distPrototypes = DeepSOM{k,i}.BMUsValuesTrain; 
                [prototypeWeights,prototypesIndexes] = sort(distPrototypes','descend');
                prototypesIndexes = prototypesIndexes';
% %                 prototypeWeights = prototypeWeights';
% %                 prototypeSumWeights = sum(prototypeWeights(:,1:range)');
% %                 prototypeWeights = prototypeWeights(:,1:range)./repmat(prototypeSumWeights',1,range);
% %                 [rowWeights,colWeights] = size(SamplesTrain.data);
% %                 [~,colCodebook] = size(DeepSOM{k,i}.sMap.codebook);
                DeepSOM{k,i}.BMUsValuesTrain = [];
                for k2 = 1:Model.multiple.prototypeRange(i)
                    DeepSOM{k,i}.BMUsValuesTrain{k2} = DeepSOM{k,i}.sMap.codebook(prototypesIndexes(:,k2),:);
                end;
                
                activationPrototypes = som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTrain, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'euclidian',i); 
                activationPrototypes = sort(activationPrototypes','descend');
                activationPrototypes = activationPrototypes';
                Model.multiple.weights{k,i+1} = activationPrototypes(:,1:Model.multiple.prototypeRange(i));
                sumActivationPrototypes = sum(Model.multiple.weights{k,i+1}');
                Model.multiple.weights{k,i+1} = Model.multiple.weights{k,i+1}./repmat(sumActivationPrototypes',1,Model.multiple.prototypeRange(i));

                %activationPrototypes = som_bmusdeep(DeepSOM{k,i}.sMap, SamplesTest, 'ALL',k,Model.multiple.sigmaAtive(i), Model, [], 'prototype',i); 
                distPrototypes = DeepSOM{k,i}.BMUsValuesTest; 
                [prototypeWeights,prototypesIndexes] = sort(distPrototypes','descend');
                prototypesIndexes = prototypesIndexes';
% %                 prototypeWeights = prototypeWeights';
% %                 prototypeSumWeights = sum(prototypeWeights(:,1:range)');
% %                 prototypeWeights = prototypeWeights(:,1:range)./repmat(prototypeSumWeights',1,range);
% %                 [rowWeights,colWeights] = size(SamplesTest.data);
% %                 [~,colCodebook] = size(DeepSOM{k,i}.sMap.codebook);
                DeepSOM{k,i}.BMUsValuesTest = [];
                for k2 = 1:Model.multiple.prototypeRange(i)                        
                    DeepSOM{k,i}.BMUsValuesTest{k2} = DeepSOM{k,i}.sMap.codebook(prototypesIndexes(:,k2),:);
                end;
                dataTrain = [dataTrain DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTrain];
                dataTest = [dataTest DeepSOM{Model.multiple.numToyProblem,i}.BMUsValuesTest];    
            end;
    elseif strcmp(Model.multiple.prototype(i),'prototype_pipeline_winner') || strcmp(Model.multiple.prototype(i),'prototype_sample_pipeline_winner') ...
            || strcmp(Model.multiple.prototype(i),'prototype_sample_all')

        lenTrain = length(Model.test.layer{i+1}.indexesWinnersTrain{r}(1,:));
        lenTest = length(Model.test.layer{i+1}.indexesWinnersTest{r}(1,:));
        if i == 1
            for k = 1:Model.multiple.numToyProblem 
                DeepSOM{k,i}.BMUsValuesTrain = SamplesTrain.data;
                DeepSOM{k,i}.BMUsValuesTest = SamplesTest.data;
            end;
        else
            for k = 1:Model.multiple.numToyProblem 
                DeepSOM{k,i}.BMUsValuesTrain = DeepSOM{k,i-1}.BMUsValuesTrain;
                DeepSOM{k,i}.BMUsValuesTest = DeepSOM{k,i-1}.BMUsValuesTest;
            end;            
        end;
        for k = 1:lenTrain
            category = Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k);
            if strcmp(Model.multiple.distanceType{1,i},'relevance_sub_variance')
                distPrototypes = sum( (DeepSOM{category, i}.relevance .* (((DeepSOM{category,i}.BMUsValuesTrain (k,:) - DeepSOM{category, i}.sMap.codebook)).^2))' );
            else
                distPrototypes = pdist2(DeepSOM{category,i}.BMUsValuesTrain(k,:),DeepSOM{category, i}.sMap.codebook);
            end;
            [~,indexesPrototypes] = min(distPrototypes');
            if strcmp(Model.multiple.prototype(i),'prototype_pipeline_winner')
                DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) = DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
            elseif strcmp(Model.multiple.prototype(i),'prototype_sample_pipeline_winner')
                % unitario
                DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) = ...
                    (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) + ...
                    Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
                % relevance
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) = ...
% %                         DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) + ...
% %                         Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.relevance(indexesPrototypes, :) .* ...
% %                         (DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.sMap.codebook(indexesPrototypes,:) - DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :)  );                    
            elseif strcmp(Model.multiple.prototype(i),'prototype_sample_all') 
                for m = 1:Model.multiple.numToyProblem 
                    distPrototypes = pdist2(SamplesTrain.data(k,:),DeepSOM{m, i}.sMap.codebook);
                    [~,indexesPrototypes] = min(distPrototypes');
                    DeepSOM{m, i}.BMUsValuesTrain(k, :) = ...
                        (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{m, i}.BMUsValuesTrain(k, :) + ...
                        Model.multiple.updatePrototype(i+1) * DeepSOM{m, i}.sMap.codebook(indexesPrototypes,:);
                end;
            end;
        end;
        for k = 1:lenTest
            category = Model.test.layer{i+1}.indexesWinnersTest{r}(1,k);
            if strcmp(Model.multiple.distanceType{1,i},'relevance_sub_variance')
                distPrototypes = sum( (DeepSOM{category, i}.relevance .* (((DeepSOM{category,i}.BMUsValuesTest (k,:) - DeepSOM{category, i}.sMap.codebook)).^2))' );
            else
                distPrototypes = pdist2(DeepSOM{category,i}.BMUsValuesTest(k,:),DeepSOM{category, i}.sMap.codebook);
            end;
            [~,indexesPrototypes] = min(distPrototypes');
            if strcmp(Model.multiple.prototype(i),'prototype_pipeline_winner')
                DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) = DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
            elseif strcmp(Model.multiple.prototype(i),'prototype_sample_pipeline_winner')
                % unitario
                DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) = ...
                    (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) + ...
                    Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
                % relevance
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) = ...
% %                         DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) + ...
% %                         Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.relevance(indexesPrototypes, :) .* ...
% %                         (DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.sMap.codebook(indexesPrototypes,:) - DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :)  );                    

            elseif strcmp(Model.multiple.prototype(i),'prototype_sample_all') 
                distPrototypes = pdist2(SamplesTest.data(k,:),DeepSOM{m, i}.sMap.codebook);
                [~,indexesPrototypes] = min(distPrototypes');
                DeepSOM{m, i}.BMUsValuesTest(k, :) = ...
                    (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{m, i}.BMUsValuesTest(k, :) + ...
                    Model.multiple.updatePrototype(i+1) * DeepSOM{m, i}.sMap.codebook(indexesPrototypes,:);                    
            end;
        end;            
        for k = 1:Model.multiple.numToyProblem 
            dataTrain = [dataTrain DeepSOM{k,i}.BMUsValuesTrain];
            dataTest = [dataTest DeepSOM{k,i}.BMUsValuesTest];
        end;
% %         else
% %             for k = 1:Model.multiple.numToyProblem 
% %                 DeepSOM{k,i}.BMUsValuesTrain = DeepSOM{k,i-1}.BMUsValuesTrain;
% %                 DeepSOM{k,i}.BMUsValuesTest = DeepSOM{k,i-1}.BMUsValuesTest;
% %             end;
% %             for k = 1:lenTrain
% %                 category = Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k);
% %                 if strcmp(Model.multiple.distanceType{1,i},'relevance_sub_variance')
% %                     distPrototypes = sum( (DeepSOM{category,i}.relevance .* ((( DeepSOM{category, i-1}.BMUsValuesTrain(k,:) - DeepSOM{category, i}.sMap.codebook)).^2) )' );
% %                 else
% %                     distPrototypes = pdist2(SamplesTrain.data(k,:),DeepSOM{category, i}.sMap.codebook);
% %                 end;
% %                 [~,indexesPrototypes] = min(distPrototypes');
% %                 if strcmp(Model.multiple.prototype(i),'prototype_pipeline_winner')
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) = DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
% %                 elseif strcmp(Model.multiple.prototype(i),'prototype_sample_pipeline_winner')
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) = ...
% %                         (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.BMUsValuesTrain(k, :) + ...
% %                         Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTrain{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
% %                 elseif strcmp(Model.multiple.prototype(i),'prototype_sample_all')
% %                     for m = 1:Model.multiple.numToyProblem 
% %                         distPrototypes = pdist2(DeepSOM{m,i}.BMUsValuesTrain(k,:),DeepSOM{m, i}.sMap.codebook);
% %                         [~,indexesPrototypes] = min(distPrototypes');
% %                         DeepSOM{m, i}.BMUsValuesTrain(k, :) = ...
% %                             (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{m, i}.BMUsValuesTrain(k, :) + ...
% %                             Model.multiple.updatePrototype(i+1) * DeepSOM{m, i}.sMap.codebook(indexesPrototypes,:);
% %                     end;                    
% %                 end;
% %             end;
% %             for k = 1:lenTest
% %                 category = Model.test.layer{i+1}.indexesWinnersTest{r}(1,k);
% %                 if strcmp(Model.multiple.distanceType{1,i},'relevance_sub_variance')
% %                     distPrototypes = sum( (DeepSOM{category,i}.relevance .* ((( DeepSOM{category, i-1}.BMUsValuesTest(k,:) - DeepSOM{category, i}.sMap.codebook)).^2) )' );
% %                 else
% %                     distPrototypes = pdist2(SamplesTest.data(k,:),DeepSOM{category, i}.sMap.codebook);
% %                 end;
% %                 [~,indexesPrototypes] = min(distPrototypes');
% %                 if strcmp(Model.multiple.prototype(i),'prototype_pipeline_winner')
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) = DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
% %                 elseif strcmp(Model.multiple.prototype(i),'prototype_sample_pipeline_winner')
% %                     DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) = ...
% %                         (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.BMUsValuesTest(k, :) + ...
% %                         Model.multiple.updatePrototype(i+1) * DeepSOM{Model.test.layer{i+1}.indexesWinnersTest{r}(1,k), i}.sMap.codebook(indexesPrototypes,:);
% %                 elseif strcmp(Model.multiple.prototype(i),'prototype_sample_all')
% %                     for m = 1:Model.multiple.numToyProblem 
% %                         distPrototypes = pdist2(DeepSOM{m,i}.BMUsValuesTest(k,:),DeepSOM{m, i}.sMap.codebook);
% %                         [~,indexesPrototypes] = min(distPrototypes');
% %                         DeepSOM{m, i}.BMUsValuesTest(k, :) = ...
% %                             (1-Model.multiple.updatePrototype(i+1)) * DeepSOM{m, i}.BMUsValuesTest(k, :) + ...
% %                             Model.multiple.updatePrototype(i+1) * DeepSOM{m, i}.sMap.codebook(indexesPrototypes,:);
% %                     end;                      
% %                 end;
% %             end;            
% %             for k = 1:Model.multiple.numToyProblem 
% %                 dataTrain = [dataTrain DeepSOM{k,i}.BMUsValuesTrain];
% %                 dataTest = [dataTest DeepSOM{k,i}.BMUsValuesTest];
% %             end;               
        end;             
    else 
        dataTrainFilter = dataTrain;
        dataTestFilter = dataTest;
        dataTrain = dataTrainFilter;
        dataTest = dataTestFilter;              
    end;
        
end