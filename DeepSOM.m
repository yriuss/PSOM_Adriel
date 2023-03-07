% Marcondes Ricarte

function [dataTrain, dataTest, train_labels, test_labels, Model] = DeepSOM(numClass,Model)

    initLayer = 1;
    [fileNameTrain, fileNameTest] = DataFileNames(Model, 1);
    
    
    pipeline = Model.pipeline; 
    
    
    SamplesTrain = som_read_data(fileNameTrain);
    SamplesTest = som_read_data(fileNameTest);
    
    
    if strcmp(pipeline,'multiple') | strcmp(pipeline,'single_multiple')
        Model.pipelineExec = 'multiple';
        NumMap = Model.multiple.numMap;
        Layer = length(NumMap); 
        
        DeepSOM = cell(Layer,numClass);    
        sMaps = [];
         
       
        class = uniqueLabels(SamplesTrain, numClass);
       
        train_labels = [];
        test_labels = [];
        for i=1:(Model.numLayer-1)
    
            for r = 1:Model.multiple.numTest(i) 
                numNeuron = NumMap(i);
    
                if i <= 2 
                    [fileNameTrain, fileNameTest] = DataFileNames(Model, r);
    
                    SamplesTrain = som_read_data(fileNameTrain);
                    SamplesTest = som_read_data(fileNameTest);
    
                    classes = uniqueLabels(SamplesTrain, numClass);
                    
                    [row,col] = size(SamplesTrain.labels);
                    for j = 1:row 
                        train_labels(r,j) = strmatch(SamplesTrain.labels(j), class, 'exact'); 
                    end;
                    
                    
                    [row,col] = size(SamplesTest.labels);
                    for j = 1:row
                        test_labels(r,j) = strmatch(SamplesTest.labels(j), class, 'exact'); 
                    end;
    
    
                    [SamplesTrain.data,SamplesTest.data] = ...
                        NormalizeData(Model, SamplesTrain.data, SamplesTest.data, Model.single.normalizeType, train_labels(r,:), test_labels(r,:));      
                else
                    if strcmp(Model.multiple.datasetType,'one')
                        train_labels(r,:) = train_labels(1,:);
                        test_labels(r,:) = test_labels(1,:);
                    end;
                end;
                            
    
                save(['dataIris_' num2str(r) '.mat'], 'SamplesTrain', 'SamplesTest', 'train_labels', 'test_labels');
                if i > 1 && strcmp(Model.multiple.datasetType,'multi') %&&  strcmp(Model.multiple.freezeLayer{i},'no')     
                    name = [Model.dir.mapsMultiple, 'sMaps_layer_' num2str(i) '_single_' num2str(Model.single.index) '_fator_' ...
                        num2str(Model.single.indexFator) '_multiple_' num2str(1) ...
                        '_fator_' num2str(1) '_test_' num2str(r)  '.mat'];
                    load(name,'DeepSOM');
                end;
                
                
                if strcmp(Model.multiple.freezeLayer{i},'no')
                    name = [Model.dir.mapsMultiple, 'sMaps_layer_' num2str(i+1) '_single_' num2str(Model.single.index) '_fator_' ...
                        num2str(Model.single.indexFator) '_multiple_' num2str(Model.multiple.index) ...
                        '_fator_' num2str(Model.multiple.indexFator) '_test_' num2str(r)  '.mat'];
                else
                    if strcmp(Model.multiple.datasetType,'one')
                    name = [Model.dir.mapsMultiple, 'sMaps_layer_' num2str(i+1) '_single_' num2str(Model.single.index) '_fator_' ...
                        num2str(Model.single.indexFator) '_multiple_' '1' ...
                        '_fator_' num2str(Model.multiple.indexFator) '_test_' num2str(1)  '.mat'];  
                    elseif strcmp(Model.multiple.datasetType,'multi')
                    name = [Model.dir.mapsMultiple, 'sMaps_layer_' num2str(i+1) '_single_' num2str(Model.single.index) '_fator_' ...
                        num2str(Model.single.indexFator) '_multiple_' '1' ...
                        '_fator_' num2str(Model.multiple.indexFator) '_test_' num2str(r)  '.mat'];                      
                    end;
                end;
                
                if strcmp(Model.multiple.datasetType,'multi') %i > 1
                    
                    if i > 1
                        [dataTrain, dataTest, DeepSOM, Model] = filterAndPropagate(Model, SamplesTrain, SamplesTest, dataTrain, dataTest, DeepSOM, i-1, j, r, numNeuron);
                        [DeepSOM] = NormalizePipelineData(Model, DeepSOM, i-1, Model.multiple.normalizeType(i-1),train_labels(r,:),test_labels(r,:));
                    end;
                    if  i < (Model.numLayer) && (strcmp(Model.multiple.distanceType(i),'relevance_prototype') || strcmp(Model.multiple.distanceType(i),'relevance_active') ...
                            || strcmp(Model.multiple.distanceType(i),'relevance_mirror') || strcmp(Model.multiple.distanceType(i),'relevance_variance') ...
                            || strcmp(Model.multiple.distanceType(i),'relevance_sub_variance') || strcmp(Model.multiple.distanceType(i),'euclidian'))
                        [relevance, Model, DeepSOM, SamplesTrain, SamplesTest] = computeRelevance(Model, DeepSOM, i-1, SamplesTrain, SamplesTest, train_labels(r,:), test_labels(r,:));
    % %                     if ~strcmp(Model.multiple.distanceType(i),'relevance_sub_variance')
    % %                         Model.multiple.relevance{i} = relevance{1,i};
    % %                     end;
                    end;             
                end;
                
                if exist(name) == 0
                    if strcmp(Model.multiple.trainType,'single')
    
                    elseif strcmp(Model.multiple.trainType,'competition')
                            if i == 1
                                if  (strcmp(Model.multiple.distanceType(i),'relevance_prototype') || strcmp(Model.multiple.distanceType(i),'relevance_active')  || strcmp(Model.multiple.distanceType(i),'relevance_mirror') )
                                    for rel = 1:Model.multiple.numToyProblem
                                        DeepSOMBegin{rel,1}.BMUsValuesTrain = SamplesTrain.data; 
                                    end;
                                    relevance = computeRelevance(Model, DeepSOMBegin, i, train_labels(r,:));
                                    Model.multiple.relevance{i} = relevance{1,i+1};
                                    DeepSOMBegin = [];
                                end;   
                            end;
    
                            
                            disp('Train SOM...');
                            Model.i = 1;
                            Model.j = i;
                            Model.category = 1;
                            SamplesTrain.train_labels = train_labels(r,:);
                            SamplesTest.test_labels = test_labels(r,:);
                            [sMaps, Model] = som_make(SamplesTrain,'msize',[numNeuron 1],'algorithm','deep','init','randinit','model', Model,'dataTest',SamplesTest, 'DeepSOM', DeepSOM);
                             
                            if i == 1 % TODO
                                itClass = numClass; 
                            elseif i > 1
                                itClass = Model.multiple.numToyProblem
                            end;    
                            
                            for n = 1:Model.multiple.numToyProblem 
                                DeepSOM{n,i}.sMap = sMaps{n}.sMap;  
                                if strcmp(Model.multiple.distanceType{i},'relevance_sub_variance') 
                                    DeepSOM{n,i}.relevance = sMaps{n}.relevance;
                                    DeepSOM{n,i}.relevanceAtive = sMaps{n}.relevanceAtive;
                                elseif strcmp(Model.multiple.distanceType{i},'relevance_variance')    
                                    DeepSOM{n,i}.relevance = sMaps{n}.relevance;
                                end;
                            end;
                            
                            for n = 1:Model.multiple.numToyProblem
                                disp('Calculating BMUs...');
    
                                    if i == 1
                                        dataSamplesTrain = SamplesTrain;
                                        dataSamplesTest = SamplesTest;
                                    else
                                        dataSamplesTrain = SamplesTrain;
                                        dataSamplesTrain.data = DeepSOM{n,i-1}.BMUsValuesTrain;
                                        dataSamplesTest = SamplesTest;
                                        dataSamplesTest.data = DeepSOM{n,i-1}.BMUsValuesTest;
                                    end;
                                    
    
                                    if strcmp(Model.multiple.distanceType{i},'relevance_sub_variance')
                                        BMUsValuesTrain = som_bmusdeep(DeepSOM{n,i}.sMap, dataSamplesTrain, 'ALL',n,Model.multiple.sigmaAtive(i), Model,[],Model.multiple.distanceType(i),i,DeepSOM{n,i}.relevance);
                                        BMUsValuesTest = som_bmusdeep(DeepSOM{n,i}.sMap, dataSamplesTest, 'ALL',n,Model.multiple.sigmaAtive(i), Model,[],Model.multiple.distanceType(i),i,DeepSOM{n,i}.relevance);
                                    else
                                        BMUsValuesTrain = som_bmusdeep(DeepSOM{n,i}.sMap, dataSamplesTrain, 'ALL',n,Model.multiple.sigmaAtive(i), Model,[],Model.multiple.distanceType(i),i,[]);
                                        BMUsValuesTest = som_bmusdeep(DeepSOM{n,i}.sMap, dataSamplesTest, 'ALL',n,Model.multiple.sigmaAtive(i), Model,[],Model.multiple.distanceType(i),i,[]);
                                    end;
    
                                DeepSOM{n,i}.BMUsValuesTrain = BMUsValuesTrain;
                                DeepSOM{n,i}.BMUsValuesTest = BMUsValuesTest;
                            end;
                                                    
                            if  strcmp(Model.flag.plotDebugData,'yes')
                                plotDebugBMUs(Model.test.debug.dataTrain, Model.test.debug.dataDensityTrain, train_labels(r,:), Model, 'train', numNeuron);
                                plotDebugBMUs(Model.test.debug.dataTest,  Model.test.debug.dataDensityTest,test_labels(r,:), Model, 'test', numNeuron);
                            end;
                            
                            ans = []; %% free memory
                    end;
    
                    
                    if i > 2 % Delete data
                        for n = 1:Model.multiple.numToyProblem
                            DeepSOM{n,i-2}.BMUsValuesTrain = [];
                            DeepSOM{n,i-2}.BMUsValuesTest = [];
                        end;                            
                    end;                    
                    sizeDeepSOM = whos('DeepSOM');
                    if sizeDeepSOM.bytes < 1800000000 % 1.8 GB
                        save(name,'DeepSOM','Model');
                    else
                        save(name, 'DeepSOM', 'Model', '-v7.3');
                    end;
    
                else
                    if i == 1
                        load(name,'DeepSOM'); 
                        for n = 1:Model.multiple.numToyProblem
                            if strcmp(Model.multiple.flagToyProblem,'yes') % TODO
                                stdData = (std(SamplesTrain.data(1:300,:)).^2);
                            elseif strcmp(Model.multiple.flagToyProblem,'no')
                                stdData = (std(SamplesTrain.data).^2);
                            end;
                            if i == 1
                                [~,dim] = size(SamplesTrain.data); 
                            end;                      
    % %                         DeepSOM{n,i}.BMUsValuesTrain = som_bmusdeep(DeepSOM{n,i}.sMap, SamplesTrain, 'ALL',n,Model.multiple.sigmaAtive(i), Model, stdData,Model.multiple.distanceType(i),i,[] );
    % %                         DeepSOM{n,i}.BMUsValuesTest = som_bmusdeep(DeepSOM{n,i}.sMap, SamplesTest, 'ALL',n,Model.multiple.sigmaAtive(i), Model, stdData,Model.multiple.distanceType(i),i, [] );
                             DeepSOM{n,i}.BMUsValuesTrain = som_bmusdeep(DeepSOM{n,i}.sMap, SamplesTrain, 'ALL',n,Model.multiple.sigmaAtive(i), Model, stdData,Model.multiple.distanceType(i),i,DeepSOM{n,i}.relevance );
                             DeepSOM{n,i}.BMUsValuesTest = som_bmusdeep(DeepSOM{n,i}.sMap, SamplesTest, 'ALL',n,Model.multiple.sigmaAtive(i), Model, stdData,Model.multiple.distanceType(i),i, DeepSOM{n,i}.relevance );
                        end;
                    elseif i > 1
                        load(name,'DeepSOM');
                    end
                end;
                
               
    
                if i == 1 
                    dataTrain = concatPipelines(Model, DeepSOM, i, 'train', numClass);
                    dataTest = concatPipelines(Model, DeepSOM, i, 'test', numClass);
                elseif i > 1
                    dataTrain = concatPipelines(Model, DeepSOM, i, 'train', Model.multiple.numToyProblem);
                    dataTest = concatPipelines(Model, DeepSOM, i, 'test', Model.multiple.numToyProblem);  
                end;
    
                [~, col] = size(dataTrain);           
                Model.j = i;
    
                
                if i == 1 || ( (i > 1) && strcmp(Model.multiple.trainUnlearnType2,'standard'))
                    [Model.test.layer{i+1}.acurracyDensityTrain(r,:),~,~,Model.test.layer{i+1}.macthesDensityTrain{r},~,Model.test.layer{i+1}.indexesWinnersTrain{r}] = ... 
                        debugMeanWinners(Model, dataTrain, i, numNeuron, train_labels(r,:),'descend');
                    [Model.test.layer{i+1}.acurracyDensityTest(r,:),~,~,Model.test.layer{i+1}.macthesDensityTest{r},~,Model.test.layer{i+1}.indexesWinnersTest{r}] = ...
                        debugMeanWinners(Model, dataTest, i, numNeuron, test_labels(r,:),'descend');
                    Model.test.layer{i+1}.scoreTrain(r) = Model.test.layer{i+1}.acurracyDensityTrain(r,1);
                    Model.test.layer{i+1}.scoreTest(r) = Model.test.layer{i+1}.acurracyDensityTest(r,1);
                    
                   Model.test.layer{i+1}.dataTest{r} = dataTest;
                   plotSamples(dataTrain, train_labels(r,:), Model, 'train', numNeuron, i+1, r);
                   plotSamples(dataTest, test_labels(r,:), Model, 'test', numNeuron, i+1, r);                
                    
    
                    for k=1:Model.multiple.numToyProblem
                        for k2=1:Model.multiple.numToyProblem
                            matrixActivationsTrain{r}(k,k2) = mean(max(DeepSOM{k,i}.BMUsValuesTrain(find(train_labels(r,:)==k2),:)));
                            matrixActivationsTest{r}(k,k2) = mean(max(DeepSOM{k,i}.BMUsValuesTest(find(test_labels(r,:)==k2),:)));
                        end;
                    end;  
                    
                    %%%% update %%%%%
                    for k=1:length(train_labels(r,:))
                        activationCorrectTrain(k) = max(DeepSOM{train_labels(r,k),i}.BMUsValuesTrain(k,:));
                    end;
                 
                    for k=1:length(test_labels(r,:))
                        activationCorrectTest(k) = max(DeepSOM{test_labels(r,k),i}.BMUsValuesTest(k,:));
                    end;                
                    for k=1:length(train_labels(r,:))
                        activationsErrorTrain = [];
                        for k2=1:Model.multiple.numToyProblem                        
                            if k2 ~= train_labels(r,k)
                                activationsErrorTrain = [activationsErrorTrain max(DeepSOM{k2,i}.BMUsValuesTrain(k,:))];
                            end;
                        end;
                        activationErrorTrain(k) = max(activationsErrorTrain);
                    end;
                    for k=1:length(test_labels(r,:))
                        activationsErrorTest = [];
                        for k2=1:Model.multiple.numToyProblem   
                            try
                                if k2 ~= test_labels(r,k)
                                    activationsErrorTest = [activationsErrorTest max(DeepSOM{k2,i}.BMUsValuesTest(k,:))];
                                end;
                            catch exception
                               a = 1;
                            end;
                        end;
                        activationErrorTest(k) = max(activationsErrorTest);
                    end;      
                    Model.test.layer{i+1}.ratioActivationsTrain(r,:) = activationCorrectTrain./activationErrorTrain;
                    Model.test.layer{i+1}.ratioActivationsTest(r,:) = activationCorrectTest./activationErrorTest; 
                    %%%%%  update %%%%%%
                    
                    if r == 1
                        Model.test.layer{i+1}.meanConfuseMatrixTrain = zeros(numClass,numClass);
                        Model.test.layer{i+1}.meanConfuseMatrixTest = zeros(numClass,numClass);
                    end;
                    
                   
                    
                    Model.multiple.experiments{r}.confuseMatrixTrain = zeros(numClass,numClass);
                    for k=1:length(Model.test.layer{1,i+1}.macthesDensityTrain{1,1}(1,:))
                         Model.test.layer{i+1}.meanConfuseMatrixTrain(train_labels(r,k),Model.test.layer{1,i+1}.indexesWinnersTrain{1,r}(1,k)) = ...
                             Model.test.layer{i+1}.meanConfuseMatrixTrain(train_labels(r,k),Model.test.layer{1,i+1}.indexesWinnersTrain{1,r}(1,k)) + 1;
                         Model.multiple.experiments{r}.confuseMatrixTrain(train_labels(r,k),Model.test.layer{1,i+1}.indexesWinnersTrain{1,r}(1,k)) = ...
                             Model.multiple.experiments{r}.confuseMatrixTrain(train_labels(r,k),Model.test.layer{1,i+1}.indexesWinnersTrain{1,r}(1,k)) + 1;                     
                    end;
                    sumTrain = sum(Model.multiple.experiments{r}.confuseMatrixTrain')';
                    Model.multiple.experiments{r}.confuseMatrixTrain = Model.multiple.experiments{r}.confuseMatrixTrain./repmat(sumTrain,1,numClass);
                    
                    Model.multiple.experiments{r}.confuseMatrixTest = zeros(numClass,numClass);
                    for k=1:length(Model.test.layer{1,i+1}.macthesDensityTest{1,1}(1,:))
                         Model.test.layer{i+1}.meanConfuseMatrixTest(test_labels(r,k), Model.test.layer{1,i+1}.indexesWinnersTest{1,r}(1,k)) = ...
                             Model.test.layer{i+1}.meanConfuseMatrixTest(test_labels(r,k), Model.test.layer{1,i+1}.indexesWinnersTest{1,r}(1,k)) + 1;
                         Model.multiple.experiments{r}.confuseMatrixTest(test_labels(r,k), Model.test.layer{1,i+1}.indexesWinnersTest{1,r}(1,k)) = ...
                             Model.multiple.experiments{r}.confuseMatrixTest(test_labels(r,k), Model.test.layer{1,i+1}.indexesWinnersTest{1,r}(1,k)) + 1;
                    end;
                    sumTest = sum(Model.multiple.experiments{r}.confuseMatrixTest')';
                    Model.multiple.experiments{r}.confuseMatrixTest = Model.multiple.experiments{r}.confuseMatrixTest./repmat(sumTest,1,numClass);                
    
                    for k=1:Model.multiple.numToyProblem
                         if i > 1
                            Model.multiple.experiments{r}.relevance{k,i} = DeepSOM{k,i}.relevance;
                         end;
                    end;
                    
    
                    
                    
                    % Set sub-SOM
                    if i == (Model.numLayer-1)
    % %                    [Model,DeepSOM] = ...
    % %                         computeSubSOM(Model, DeepSOM, SamplesTrain, SamplesTest, i, train_labels(r,:), test_labels(r,:), r); 
    % %                    save(name,'DeepSOM','Model');
                    end;
                    
                    
                    % Set relevance
                    if strcmp(Model.multiple.freezeLayer{i},'no') && strcmp(Model.multiple.flagRelevanceSet,'yes')
    %                    [Model,~] = ...
    %                        computeSetRelevance(Model, DeepSOM, i, train_labels(r,:), test_labels(r,:), r);               
                    end;                
    
                end;    
                
            end;
    
            
            Model.test.layer{i+1}.meanRatioActivationsTrain = mean(mean(Model.test.layer{i+1}.ratioActivationsTrain'));
            Model.test.layer{i+1}.meanRatioActivationsTest = mean(mean(Model.test.layer{i+1}.ratioActivationsTest'));
            for r = 1:Model.multiple.numTest(i) 
                indexes = find(Model.test.layer{i+1}.ratioActivationsTrain(r,:) > 1);
                ratioCorrectActivationsTrain(r) = mean(Model.test.layer{i+1}.ratioActivationsTrain(r,indexes));
                indexes = find(Model.test.layer{i+1}.ratioActivationsTest(r,:) > 1);
                ratioCorrectActivationsTest(r) = mean(Model.test.layer{i+1}.ratioActivationsTest(r,indexes));                
                indexes = find(Model.test.layer{i+1}.ratioActivationsTrain(r,:) < 1);
                ratioErrorActivationsTrain(r) = mean(Model.test.layer{i+1}.ratioActivationsTrain(r,indexes));
                indexes = find(Model.test.layer{i+1}.ratioActivationsTest(r,:) < 1);
                ratioErrorActivationsTest(r) = mean(Model.test.layer{i+1}.ratioActivationsTest(r,indexes));            
            end;
            Model.test.layer{i+1}.meanRatioCorrectActivationsTrain = mean(ratioCorrectActivationsTrain, 'omitnan');
            Model.test.layer{i+1}.meanRatioCorrectActivationsTest = mean(ratioCorrectActivationsTest, 'omitnan');        
            Model.test.layer{i+1}.meanRatioErrorActivationsTrain = mean(ratioErrorActivationsTrain', 'omitnan');
            Model.test.layer{i+1}.meanRatioErrorActivationsTest = mean(ratioErrorActivationsTest, 'omitnan');
          
             Model.test.layer{i+1}.meanTrain = mean(Model.test.layer{i+1}.scoreTrain);   
             Model.test.layer{i+1}.stdTrain = std(Model.test.layer{i+1}.scoreTrain);
             Model.test.layer{i+1}.meanAcurracyDensityTrain = mean(Model.test.layer{i+1}.acurracyDensityTrain);
             Model.test.layer{i+1}.stdAcurracyDensityTrain = std(Model.test.layer{i+1}.acurracyDensityTrain);
             
             Model.test.layer{i+1}.meanTest = mean(Model.test.layer{i+1}.scoreTest);   
             Model.test.layer{i+1}.stdTest = std(Model.test.layer{i+1}.scoreTest);
             Model.test.layer{i+1}.meanAcurracyDensityTest = mean(Model.test.layer{i+1}.acurracyDensityTest);
             Model.test.layer{i+1}.stdAcurracyDensityTest = std(Model.test.layer{i+1}.acurracyDensityTest);
    
    % %          scoreSubNetworkTest = mean(Model.test.layer{1,i+1}.scoreSubNetworkTestLog );
    % %          [~,index] = max(scoreSubNetworkTest);
    % %          Model.test.layer{1,i+1}.meanScoreSubNetworkTrain = mean(Model.test.layer{1,i+1}.scoreSubNetworkTrainLog(:,index)' );
    % %          Model.test.layer{1,i+1}.stdScoreSubNetworkTrain = std(Model.test.layer{1,i+1}.scoreSubNetworkTrainLog(:,index)' );         
    % %          Model.test.layer{1,i+1}.meanScoreSubNetworkTest = mean(Model.test.layer{1,i+1}.scoreSubNetworkTestLog(:,index)' );
    % %          Model.test.layer{1,i+1}.stdScoreSubNetworkTest = std(Model.test.layer{1,i+1}.scoreSubNetworkTestLog(:,index)' );
    % %          for r = 1:Model.multiple.numTest(i) 
    % %             Model.test.layer{1,i+1}.indexesWinnersSubSOMTrain{r} =  Model.test.layer{1,i+1}.indexesWinnersSubSOMTrainLog{r}(index,:);
    % %             Model.test.layer{1,i+1}.indexesWinnersSubSOMTest{r} =  Model.test.layer{1,i+1}.indexesWinnersSubSOMTestLog{r}(index,:);
    % %          end;
             
             
             [Model] = statisticsSetRelevance(Model,i);
    
             
             Model.test.layer{i+1}.meanMatrixActivationsTrain = zeros(Model.multiple.numToyProblem,Model.multiple.numToyProblem);
             Model.test.layer{i+1}.meanMatrixActivationsTest = zeros(Model.multiple.numToyProblem,Model.multiple.numToyProblem);
             for k = 1:Model.multiple.numTest(i)
                 Model.test.layer{i+1}.meanMatrixActivationsTrain = Model.test.layer{i+1}.meanMatrixActivationsTrain + matrixActivationsTrain{k};
                 Model.test.layer{i+1}.meanMatrixActivationsTest = Model.test.layer{i+1}.meanMatrixActivationsTest + matrixActivationsTest{k};
             end;
             Model.test.layer{i+1}.meanMatrixActivationsTrain= Model.test.layer{i+1}.meanMatrixActivationsTrain/Model.multiple.numTest(i);
             Model.test.layer{i+1}.meanMatrixActivationsTest = Model.test.layer{i+1}.meanMatrixActivationsTest/Model.multiple.numTest(i);
             minActivations = min(Model.test.layer{i+1}.meanMatrixActivationsTrain(:));
             maxActivations = max(Model.test.layer{i+1}.meanMatrixActivationsTrain(:));
             Model.test.layer{i+1}.meanNormMatrixActivationsTrain = (Model.test.layer{i+1}.meanMatrixActivationsTrain-minActivations)/(maxActivations-minActivations);
             minActivations = min(Model.test.layer{i+1}.meanMatrixActivationsTest(:));
             maxActivations = max(Model.test.layer{i+1}.meanMatrixActivationsTest(:));
             Model.test.layer{i+1}.meanNormMatrixActivationsTest = (Model.test.layer{i+1}.meanMatrixActivationsTest-minActivations)/(maxActivations-minActivations);
             
            
            
             sumTrain = sum(Model.test.layer{i+1}.meanConfuseMatrixTrain')';
             Model.test.layer{i+1}.meanConfuseMatrixTrain = Model.test.layer{i+1}.meanConfuseMatrixTrain./repmat(sumTrain,1,numClass);
             sumTest = sum(Model.test.layer{i+1}.meanConfuseMatrixTest')';
             Model.test.layer{i+1}.meanConfuseMatrixTest = Model.test.layer{i+1}.meanConfuseMatrixTest./repmat(sumTest,1,numClass);        
    
    
        
    
             name = [Model.dir.resultsMultiple ...
                 'results_layer_' num2str(i+1) '_single_' num2str(Model.single.index) '_fator_' ...
                    num2str(Model.single.indexFator) '_multiple_' num2str(Model.multiple.index) ...
                    '_fator_' num2str(Model.multiple.indexFator) '.mat']; 
             if i == (Model.numLayer-1)   
                save(name,'Model');  
             end;
         
    
        end; 
            
    end;