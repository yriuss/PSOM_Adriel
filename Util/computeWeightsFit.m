% Marcondes Ricarte

function [Model, DeepSOM, train_labels, test_labels, SamplesTrain, SamplesTest] = computeWeightsFit(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r)

% %     %%%%
% %     train_labelsOld = train_labels;
% %     DeepSOMOld = DeepSOM;  
% %     train_labels = test_labels;
% %     for i = 1:15
% %         DeepSOM{i,layer-1}.BMUsValuesTrain = DeepSOM{i,layer-1}.BMUsValuesTest; 
% %     end;
% %     %%%%%


    matrizMode = {'cosseno_ranking', 'cosseno_ranking', 'cosseno_ranking', 'cosseno_ranking', 'cosseno_ranking'}; % 'worse', 'all_cut_weigth', 'matriz_cut_weigth', 'samples', 'samples_virtualcenters','cosseno', 'cosseno_one', 'cosseno_ranking', 'cosseno_worse_pair', 'cosseno_worse_two_pair'
    weigthsFitEquation = {'unlearn', 'unlearn', 'unlearn', 'unlearn', 'unlearn'}; % 'learn', 'unlearn', 'learn_unlearn', 'no'
    centerVirtualWeigthsFitEquation = {'no', 'no', 'no', 'no', 'no'}; % 'no' 'learn_incorrect'
    relevanceAtive = {'no', 'no', 'no', 'no', 'no'}; % 'yes', 'no'
    virtualCentersType = {'max', 'max', 'max', 'max', 'max'}; % 'mean', 'max'
    dataType = {'centers', 'centers', 'centers', 'centers', 'centers'}; % 'centers', 'data' 
    updateMode = {'seq','seq','seq','seq','seq'}; %'batch', 'seq'
    updateNodes = {'all','all', 'all','all','all'}; %'all', 'active', 'virtual_center'
    learnRate = {'decay','decay','decay','decay','decay'}; % 'static', 'decay', 'linear'
    unlearnType = {'anyCat','anyCat','anyCat','anyCat','anyCat'}; % 'oneCat', 'anyCat'
    fitEstimateMode = {'yes','yes','yes','yes','yes'}; % 'no', 'yes'
    orderCat = {'bigger','bigger','bigger','bigger','bigger'}; % 'smaller', 'bigger'
    prototypeRefinement = {'no','no','no','no','no'}; % 'no', 'yes'
    relevanceSelectionFunction =  {'no','no','no','no','no'}; % 'no', 'binary' 
    
    

    numClass = Model.multiple.numToyProblem;
    
    epochs = 200;
    alpha = Model.multiple.unlearnedRate(layer);
    catFindControl = 0;
    pairItMax = 3;
    pairIt = 0;
    pairControl = zeros(Model.multiple.numToyProblem, Model.multiple.numToyProblem);
    pairWithoutUpdateControl = zeros(Model.multiple.numToyProblem, Model.multiple.numToyProblem);
    pairCount = 0;
    
    iMaxLog = [];
    jMaxLog = [];
    

    
    trainTop = 0;
    updateEpoch = 1;
    Model.test.layer{layer+1}.errorNodeAnalisys.relevancesActives{r} = [];
    for j = 1:epochs

        
        if trainTop == 0
            if ~strcmp(matrizMode{layer}, 'cosseno_one') & ~strcmp(matrizMode{layer}, 'cosseno_ranking')
                if pairIt == pairItMax || updateEpoch == 0
                    pairIt = 0;
                    pairControl(catError1, catError2) = 1;
                    if sum(sum(confuseMatrixTrain{j-1} .* ~pairControl)) == 0
                        pairControl = zeros(Model.multiple.numToyProblem, Model.multiple.numToyProblem);
                        pairCount = pairCount + 1;
                    end;

                end;
                if  pairCount == 1
                    trainTop = 1;
                end;

                updateEpoch = 0;
            end;
        
        
            for pipeline = 1:Model.multiple.numToyProblem
                if layer == 1
                    dataSamplesTrain.data = SamplesTrain.data;
                    dataSamplesTest.data = SamplesTest.data;
                else
                    dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
                    dataSamplesTest.data = DeepSOM{pipeline,layer-1}.BMUsValuesTest;  
                end;
                if strcmp(Model.multiple.distanceType{layer},'relevance_sub_variance')
                    DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
                    DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);        
                else
                    DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,[]);
                    DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,[]);                            
                end;
            end;

            dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
            dataTest = concatPipelines(Model, DeepSOM, layer, 'test', Model.multiple.numToyProblem);   

            [acurracyDensityTrain,~,ratioBMUsTrain,macthesDensityTrain,~,indexesWinnersTrain, errorMatrix,correctNodes,incorrectNodes,pipelineCorrectOrderTrain, errorMatrixSamplesTrain, correctNodeGlobalOrderTrain, correctNodesTotal, incorrectNodesTotal] = ... 
                debugMeanWinners(Model, dataTrain, layer, Model.multiple.numMap(layer), train_labels,'descend');
            [acurracyDensityTest,~,ratioBMUsTest,macthesDensityTest,~,indexesWinnersTest, errorMatrix,correctNodesTest,incorrectNodesTest,pipelineCorrectOrderTest, errorMatrixSamplesTest, correctNodeGlobalOrderTest] = ...
                debugMeanWinners(Model, dataTest, layer, Model.multiple.numMap(layer), test_labels,'descend');
        end;

        acurracyDensityEpochsTrain(j) = acurracyDensityTrain(1);
        acurracyDensityEpochsTest(j) = acurracyDensityTest(1);
            
        
         if acurracyDensityTrain(1) == 1 %|| acurracyDensityEpochsTrain(j) < 0.85
            trainTop = 1;
        end;
        
        Model.test.layer{layer+1}.ratioBMUsLogTrain{r}(j,:) = ratioBMUsTrain(1,:);
        Model.test.layer{layer+1}.ratioBMUsLogTest{r}(j,:) = ratioBMUsTest(1,:);
        
        ratioBMUsLogTrain(j,:) = ratioBMUsTrain(1,:);
        ratioBMUsLogTest(j,:) = ratioBMUsTest(1,:);
       
        confuseMatrixTrain{j} = zeros(numClass,numClass);
        for k=1:length(macthesDensityTrain(1,:))
             confuseMatrixTrain{j}(train_labels(1,k), indexesWinnersTrain(1,k)) = ...
                 confuseMatrixTrain{j}(train_labels(1,k), indexesWinnersTrain(1,k)) + 1;                     
        end;
        sumTrain = sum(confuseMatrixTrain{j}')';
        confuseMatrixTrain{j} = confuseMatrixTrain{j}./repmat(sumTrain,1,numClass);
        confuseMatrixTrainTemp = confuseMatrixTrain{j};
        for k = 1:Model.multiple.numToyProblem
            confuseMatrixTrain{j}(k,k) = 0;
        end;


        confuseMatrixTest{j} = zeros(numClass,numClass);
        for k=1:length(macthesDensityTest(1,:))
             confuseMatrixTest{j}(test_labels(1,k), indexesWinnersTest(1,k)) = ...
                 confuseMatrixTest{j}(test_labels(1,k), indexesWinnersTest(1,k)) + 1;                     
        end;
        sumTest = sum(confuseMatrixTest{j}')';
        confuseMatrixTest{j} = confuseMatrixTest{j}./repmat(sumTest,1,numClass);  
        confuseMatrixTestTemp = confuseMatrixTest{j};
        for k = 1:Model.multiple.numToyProblem
            confuseMatrixTest{j}(k,k) = 0;
        end;


       if  strcmp(dataType,'centers')
            for k = 1:Model.multiple.numToyProblem
                confuseMatrixTrain{j}(k,k) = 0;
                virtualCenters{k,:} = DeepSOM{k,layer}.sMap.codebook;
            end;
       elseif strcmp(dataType,'data')
           for k = 1:Model.multiple.numToyProblem
               for k2 = 1:Model.multiple.numToyProblem
                   if k == k2
                       virtualCenters{k,k2} = mean(DeepSOM{k,layer}.sMap.codebook);
                   else
                        virtualCenters{k,k2} = mean( DeepSOM{k,layer-1}.BMUsValuesTrain(train_labels == k2,:) ); 
                   end;
               end;
           end;           
     
       end;
       [cosine, near] = calculateMatrixCos(Model, DeepSOM, layer,  Model.multiple.centersThreshold(layer), 'part');

        maximum = max(max(confuseMatrixTrain{j}));

        
     
        DeepSOMEpochs{j} = DeepSOM;            
        indexesWinnersTrainEpochs{j} = indexesWinnersTrain;
        indexesWinnersTestEpochs{j} = indexesWinnersTest;
        macthesDensityTrainEpochs{j} = macthesDensityTrain;
        macthesDensityTestEpochs{j} = macthesDensityTest;
        
        
        if trainTop == 0
            if strcmp(matrizMode{layer},'worse')
                search = 0;
                for iMaxTemp = 1:Model.multiple.numToyProblem
                    for jMaxTemp = 1:Model.multiple.numToyProblem
                        if confuseMatrixTrain{j}(iMaxTemp,jMaxTemp) == maximum & search == 0
                            search = 1;
                            iMax = iMaxTemp;   
                            jMax = jMaxTemp;                      
                        end;
                    end;            
                end;

                iMaxLog(j) = iMax;
                jMaxLog(j) = jMax;

                if  strcmp(dataType,'centers')    
                    if strcmp(weigthsFitEquation{layer},'learn')
                        DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
                    else strcmp(weigthsFitEquation{layer},'unlearn')      
                        DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
                    end;
                elseif strcmp(dataType,'data')
                     if strcmp(weigthsFitEquation{layer},'learn')
                        DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters{iMax,jMax} - virtualCenters{iMax,iMax}); 
                    else strcmp(weigthsFitEquation{layer},'unlearn')      
                        DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters{jMax,iMax} - virtualCenters{jMax,jMax});
                    end;               
                end;

            elseif strcmp(matrizMode{layer},'all')
                if Model.multiple.numToyProblem == 3
                    alpha = 0.01; % wine
                elseif Model.multiple.numToyProblem == 15    
                    alpha = 0.001; % 15scenes 
                end;
                search = 1;

                if sum(confuseMatrixTrain{j}(:))
                    for iMaxTemp = 1:Model.multiple.numToyProblem
                        for jMaxTemp = 1:Model.multiple.numToyProblem
                            if confuseMatrixTrain{j}(iMaxTemp,jMaxTemp) > 0
                                iMaxTotal(search) = iMaxTemp;   
                                jMaxTotal(search) = jMaxTemp;     
                                search = search + 1;                    
                            end;                
                        end;            
                    end;

                    order = randperm(length(iMaxTotal));

                    for k = 1:length(iMaxTotal)
                        iMax = iMaxTotal(order(k));
                        jMax = jMaxTotal(order(k));            
                        iMaxLog = [iMaxLog iMax];
                        jMaxLog = [jMaxLog jMax];

                        if  strcmp(dataType,'centers')    
                            if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
                            else strcmp(weigthsFitEquation{layer},'unlearn')      
                                DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
                            end;
                        elseif strcmp(dataType,'data')
                             if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters{iMax,jMax} - virtualCenters{iMax,iMax}); 
                            else strcmp(weigthsFitEquation{layer},'unlearn')      
                                DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters{jMax,iMax} - virtualCenters{jMax,jMax});
                            end;               
                        end;

                    end;

                    if strcmp(relevanceAtive{layer},'yes')
                        [Model, DeepSOM] = computeRelevanceEpochs(Model, DeepSOM, layer, [], [], train_labels, test_labels, Model.multiple.trainlen(layer,1), Model.multiple.trainlen(layer,1));
                    end

                end;


            elseif strcmp(matrizMode{layer},'matriz_cut_weigth') || strcmp(matrizMode{layer},'all_cut_weigth') 
                [~, dim] = size(virtualCenters);
                if Model.multiple.numToyProblem == 3
                    alpha = 0.1; % wine
                elseif Model.multiple.numToyProblem == 15  
                    if strcmp(learnRate,'static') 
                        alpha = 0.1 * ones(1,epochs); % 15scenes 
                    elseif strcmp(learnRate,'decay')
                        tau = - epochs/ log(0.001/0.1);
                        alpha = 0.1* exp(-[1:epochs]/tau);      
                    end;
                end;

                search = 1;            
                erros = [];
                indexes1 = [];
                indexes2 = [];

                if strcmp(matrizMode{layer},'matriz_cut_weigth')
                    for k = 1:Model.multiple.numToyProblem
                        [score, index] = max(confuseMatrixTrain{j}(k,:));
                        if score > 0
                            erros = [erros score];
                            indexes1 = [indexes1 k];
                            indexes2 = [indexes2 index];
                        end;                
                    end;
                elseif strcmp(matrizMode{layer},'all_cut_weigth')
                    for k = 1:Model.multiple.numToyProblem
                        for k2 = 1:Model.multiple.numToyProblem
                            [score, index] = max(confuseMatrixTrain{j}(k,k2));
                            if score > 0
                                erros = [erros score];
                                indexes1 = [indexes1 k];
                                indexes2 = [indexes2 k2];
                            end;                
                        end;
                    end;                
                end;

                if sum(confuseMatrixTrain{j}(:))
                    iMaxTotal = [];
                    jMaxTotal = [];
                    for k = 1:length(erros)
                        if erros(k) > mean(erros) + Model.multiple.centersThreshold(layer) * std(erros)
                            iMaxTotal(search) = indexes1(k);   
                            jMaxTotal(search) = indexes2(k);     
                            search = search + 1;                    
                        end;          
                    end;

                    Model.test.layer{layer+1}.iMaxTotal{r,j} = iMaxTotal;
                    Model.test.layer{layer+1}.jMaxTotal{r,j} = jMaxTotal;

                    order = randperm(length(iMaxTotal));

                    if length(iMaxTotal) > 0
                        if strcmp(updateMode, 'batch')
                            for k = 1:length(iMaxTotal)
                                iMax = iMaxTotal(order(k));
                                jMax = jMaxTotal(order(k));           
                                iMaxLog = [iMaxLog iMax];
                                jMaxLog = [jMaxLog jMax];

                                if strcmp(updateNodes{layer},'all') || strcmp(updateNodes{layer},'virtual_center') 
                                    active = ones(1,Model.multiple.numMap(layer));
                                elseif strcmp(updateNodes{layer},'active')
                                    active = errorMatrix{iMax,jMax};
                                end;                           

                                if strcmp(updateNodes,'virtual_center') 
                                    virtualCenters(iMax,:) = mean(DeepSOM{iMax,layer}.sMap.codebook);
                                    virtualCenters(jMax,:) = mean(DeepSOM{jMax,layer}.sMap.codebook( find(errorMatrix{iMax,jMax}),:));
                                end;


                                if strcmp(weigthsFitEquation{layer},'learn')
                                    DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + ...
                                        repmat(active',1,dim) .* ( alpha(j) * confuseMatrixTrain{j}(iMax, jMax) * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:))); 
                                else strcmp(weigthsFitEquation{layer},'unlearn')      
                                    DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - ...
                                        repmat(active',1,dim) .* ( alpha(j) * confuseMatrixTrain{j}(iMax, jMax) * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:)));
                                end;
                            end;                
                        elseif strcmp(updateMode, 'weigths_seq')
                            control = 1;
                            updates = zeros(1,length(iMaxTotal));
                            while control == 1
                                for k = 1:length(iMaxTotal)
                                    updateAtives(k) = ceil(confuseMatrixTrain{j}(iMaxTotal(k), jMaxTotal(k))/0.01) ~= updates(k);
                                end;
                                updateAtives = find(updateAtives == 1);
                                index  = randi(length(updateAtives));
                                index = updateAtives(index);

                                iMax = iMaxTotal(index);
                                jMax = jMaxTotal(index);           
                                iMaxLog = [iMaxLog iMax];
                                jMaxLog = [jMaxLog jMax];  

                                if strcmp(weigthsFitEquation{layer},'learn')
                                    DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha(j) * confuseMatrixTrain{j}(iMax, jMax) * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
                                else strcmp(weigthsFitEquation{layer},'unlearn')      
                                    DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha(j) * confuseMatrixTrain{j}(iMax, jMax) * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
                                end;
                                updates(index) = updates(index) + 1;

                                count = 0;
                                for k = 1:length(iMaxTotal)
                                    if ceil(confuseMatrixTrain{j}(iMaxTotal(k), jMaxTotal(k))/0.01) == updates(k)
                                        count = count + 1;
                                    end;
                                end;
                                if count == length(iMaxTotal)
                                    control = 0;
                                end;                        

                            end;
                        end;

                    end;

                    if strcmp(relevanceAtive{layer},'yes')
                        [Model, DeepSOM] = computeRelevanceEpochs(Model, DeepSOM, layer, [], [], train_labels, test_labels, Model.multiple.trainlen(layer,1), Model.multiple.trainlen(layer,1));
                    end

                end;            

            elseif strcmp(matrizMode{layer},'cosseno') || strcmp(matrizMode{layer},'cosseno_one') || strcmp(matrizMode{layer},'cosseno_ranking') || ...
                    strcmp(matrizMode{layer},'cosseno_worse_pair') || strcmp(matrizMode{layer},'cosseno_worse_two_pair')


% %                 if  strcmp(dataType,'centers')
% %                     for cat = 1:Model.multiple.numToyProblem
% %                         for cat2 = 1:Model.multiple.numToyProblem
% %                             if cat ~= cat2
% %                                 [cosine(cat,cat2), norm(cat,cat2)] = getCosineSimilarity(virtualCenters(cat,:), virtualCenters(cat2,:)); 
% %                             else
% %                                 cosine(cat,cat2) = 0;
% %                             end;
% %                             norm(cat,cat2) = 1;
% %                         end;
% %                     end;   
% %                 elseif  strcmp(dataType,'centers')
% % 
% %                 end;


                if strcmp(matrizMode{layer},'cosseno')
                    categoriesRand = [];
                    categoriesRand2 = [];
                    for cat = 1:Model.multiple.numToyProblem         
                        for cat2 = 1:Model.multiple.numToyProblem 
                            categoriesRand = [categoriesRand cat];
                        end;
                    end;
                    order = randperm( Model.multiple.numToyProblem^2 );
                    order2 = randperm( Model.multiple.numToyProblem^2 );
                    for k = 1:length(categoriesRand)         
                        cat = categoriesRand(order(k));
                        cat2 = categoriesRand(order2(k));
                        dist = mean( cosine{cat} ); %dist = max( cosine{cat} );
                        if cat ~= cat2 && dist(1,cat2) > Model.multiple.centersThreshold(layer)
                            iMaxLog = [iMaxLog cat];
                            jMaxLog = [jMaxLog cat2];                        
                            if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{cat,layer}.sMap.codebook = DeepSOM{cat,layer}.sMap.codebook + alpha * DeepSOM{cat,layer}.relevance .* (virtualCenters(cat2,:) - virtualCenters(cat,:));
                            elseif strcmp(weigthsFitEquation{layer},'unlearn')
                                DeepSOM{cat2,layer}.sMap.codebook = DeepSOM{cat2,layer}.sMap.codebook - alpha * DeepSOM{cat2,layer}.relevance .* (virtualCenters(cat,:) - virtualCenters(cat2,:));
                            end;
                        end;
                    end;         
                elseif strcmp(matrizMode{layer},'cosseno_one')
% %                     for cat = 1:Model.multiple.numToyProblem 
% %                         if strcmp(virtualCentersType{layer},'mean')
% %                             cossinePipeline(cat,:) = mean(cosine(cat,:));
% %                         elseif strcmp(virtualCentersType{layer},'max')
% %                             cossinePipeline(cat,:) = max(cosine(cat,:));    
% %                         end;
% %                         cossinePipeline(cat,cat) = 0;
% %                     end;
% % 
% %                     [maxval,~] = max(max(cossinePipeline));
% %                     for k = 1:Model.multiple.numToyProblem
% %                         for k2 = 1:Model.multiple.numToyProblem
% %                             if cossinePipeline(k,k2) == maxval
% %                                 iMax = k;
% %                                 jMax = k2;
% %                             end;
% %                         end;                    
% %                     end;
                    [~,indexMax] = max(near.score);
                    cat1 = near.cat1(indexMax);
                    cat2 = near.cat2(indexMax);
                    node1 = near.node1(indexMax);
                    node2 = near.node2(indexMax);

                    iMaxLog = [iMaxLog cat1];
                    jMaxLog = [jMaxLog cat2];   
                    DeepSOMCopy = DeepSOM;
                    if ~isempty(indexMax)
                        if strcmp(weigthsFitEquation{layer},'learn')
                            DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,layer}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:));
                        elseif strcmp(weigthsFitEquation{layer},'unlearn')
                            if strcmp(Model.multiple.distanceType{layer},'relevance_sub_variance')
                                DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOM{cat1,layer}.sMap.codebook(node1,:)  ...
                                    - alpha * DeepSOM{cat1,layer}.relevance(node1,:) .* (DeepSOMCopy{cat2,layer}.sMap.codebook(node2,:) - DeepSOM{cat1,layer}.sMap.codebook(node1,:) );
                                DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOM{cat2,layer}.sMap.codebook(node2,:)  ...
                                    - alpha * DeepSOM{cat2,layer}.relevance(node2,:) .* (DeepSOMCopy{cat1,layer}.sMap.codebook(node1,:) - DeepSOM{cat2,layer}.sMap.codebook(node2,:) );                        
                            elseif strcmp(Model.multiple.distanceType{layer},'euclidian')
                                DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOM{cat1,layer}.sMap.codebook(node1,:)  ...
                                    - alpha * (DeepSOMCopy{cat2,layer}.sMap.codebook(node2,:) - DeepSOM{cat1,layer}.sMap.codebook(node1,:) );
                                DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOM{cat2,layer}.sMap.codebook(node2,:)  ...
                                    - alpha * (DeepSOMCopy{cat1,layer}.sMap.codebook(node1,:) - DeepSOM{cat2,layer}.sMap.codebook(node2,:) );   
                            end;
                        end;
                    end;

                elseif strcmp(matrizMode{layer},'cosseno_ranking')
                    [~,indexSort] = sort(near.score,'descend');
                    for indexUpdate = 1:length(near.score)
                        cat1 = near.cat1(indexSort(indexUpdate));
                        cat2 = near.cat2(indexSort(indexUpdate));
                        node1 = near.node1(indexSort(indexUpdate));
                        node2 = near.node2(indexSort(indexUpdate));

                        iMaxLog = [iMaxLog cat1];
                        jMaxLog = [jMaxLog cat2];   
                        DeepSOMCopy = DeepSOM;
                        if ~isempty(indexSort)
                            if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,layer}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:));
                            elseif strcmp(weigthsFitEquation{layer},'unlearn')
                                if strcmp(Model.multiple.distanceType{layer},'relevance_sub_variance')
                                    DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOM{cat1,layer}.sMap.codebook(node1,:)  ...
                                        - alpha * DeepSOM{cat1,layer}.relevance(node1,:) .* (DeepSOMCopy{cat2,layer}.sMap.codebook(node2,:) - DeepSOM{cat1,layer}.sMap.codebook(node1,:) );
                                    DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOM{cat2,layer}.sMap.codebook(node2,:)  ...
                                        - alpha * DeepSOM{cat2,layer}.relevance(node2,:) .* (DeepSOMCopy{cat1,layer}.sMap.codebook(node1,:) - DeepSOM{cat2,layer}.sMap.codebook(node2,:) );                        
                                elseif strcmp(Model.multiple.distanceType{layer},'euclidian')
                                    DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOM{cat1,layer}.sMap.codebook(node1,:)  ...
                                        - alpha * (DeepSOMCopy{cat2,layer}.sMap.codebook(node2,:) - DeepSOM{cat1,layer}.sMap.codebook(node1,:) );
                                    DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOM{cat2,layer}.sMap.codebook(node2,:)  ...
                                        - alpha * (DeepSOMCopy{cat1,layer}.sMap.codebook(node1,:) - DeepSOM{cat2,layer}.sMap.codebook(node2,:) );   
                                end;
                            end;
                        end;
                    end;


                elseif strcmp(matrizMode{layer},'cosseno_worse_pair') || strcmp(matrizMode{layer},'cosseno_worse_two_pair')   

                    cossinePipeline = cosine;
                    maximum = max(max(cossinePipeline));
                    [iMax,jMax]=find(cossinePipeline==maximum);

                    cossinePipeline(iMax,jMax) = 0;
                    [score2_1,iMax2_1] = max( cossinePipeline(iMax(1),:) );

                    cossinePipeline(iMax,jMax) = 0;
                    [score2_2,iMax2_2] = max( cossinePipeline(jMax(1),:) );   

                    if score2_1 < score2_2 %score2_1 > score2_2
                        iMax = iMax(1);
                        jMax = jMax(1);
                    elseif score2_1 > score2_2 %score2_1 < score2_2    
                        jMaxTemp = iMax(1); %inverse
                        iMaxTemp = jMax(1);  
                        iMax = iMaxTemp;
                        jMax = jMaxTemp;
                    end;

                    iMaxLog = [iMaxLog iMax];
                    jMaxLog = [jMaxLog jMax];

                    if  strcmp(dataType,'centers')    
                        if strcmp(weigthsFitEquation{layer},'learn')
                            DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
                        else strcmp(weigthsFitEquation{layer},'unlearn')      
                            DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
                        end;
                    elseif strcmp(dataType,'data')
                         if strcmp(weigthsFitEquation{layer},'learn')
                            DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters{iMax,jMax} - virtualCenters{iMax,iMax}); 
                        else strcmp(weigthsFitEquation{layer},'unlearn')      
                            DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters{jMax,iMax} - virtualCenters{jMax,jMax});
                        end;               
                    end;        

                    if strcmp(matrizMode{layer},'cosseno_worse_two_pair')
                        iMax = jMax;
                        if score2_1 < score2_2 
                            jMax = iMax2_1;
                        elseif score2_1 > score2_2 
                            jMax = iMax2_2;
                        end;


                        iMaxLog = [iMaxLog iMax];
                        jMaxLog = [jMaxLog jMax];

                        if  strcmp(dataType,'centers')    
                            if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
                            else strcmp(weigthsFitEquation{layer},'unlearn')      
                                DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
                            end;
                        elseif strcmp(dataType,'data')
                             if strcmp(weigthsFitEquation{layer},'learn')
                                DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,layer}.relevance .* (virtualCenters{iMax,jMax} - virtualCenters{iMax,iMax}); 
                            else strcmp(weigthsFitEquation{layer},'unlearn')      
                                DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,layer}.relevance .* (virtualCenters{jMax,iMax} - virtualCenters{jMax,jMax});
                            end;               
                        end;                        
                    end;


                end;

                if strcmp(relevanceAtive{layer},'yes')
                    [Model, DeepSOM] = computeRelevanceEpochs(Model, DeepSOM, layer, [], [], train_labels, test_labels, Model.multiple.trainlen(layer,1), Model.multiple.trainlen(layer,1));
                end;   



            elseif  strcmp(matrizMode{layer},'samples') || strcmp(matrizMode{layer},'samples_virtualcenters')


                %%%%%%
                if strcmp(weigthsFitEquation{layer},'learn')
                    if Model.multiple.index == 1
                        beginAlpha1 = 0.1;
                        endAlpha1 = 0.01;
                    elseif Model.multiple.index == 2
                        beginAlpha1 = 0.1;
                        endAlpha1 = 0.001;
                    elseif Model.multiple.index == 3
                        beginAlpha1 = 0.05;
                        endAlpha1 = 0.005;
                    elseif Model.multiple.index == 4
                        beginAlpha1 = 0.05;
                        endAlpha1 = 0.0005;
                    elseif Model.multiple.index == 5
                        beginAlpha1 = 0.01;
                        endAlpha1 = 0.001;
                    elseif Model.multiple.index == 6
                        beginAlpha1 = 0.01;
                        endAlpha1 = 0.0001;                    
                    end;
                    beginAlpha2 = beginAlpha1;
                    endAlpha2 = endAlpha1;
                elseif  strcmp(weigthsFitEquation{layer},'unlearn') | strcmp(weigthsFitEquation{layer},'learn_unlearn') | strcmp(weigthsFitEquation{layer},'no')
                    if Model.multiple.index == 1
                        beginAlpha2 = 0.1;
                        endAlpha2 = 0.01;
                    elseif Model.multiple.index == 2
                        beginAlpha2 = 0.1;
                        endAlpha2 = 0.001;
                    elseif Model.multiple.index == 3
                        beginAlpha2 = 0.05;
                        endAlpha2 = 0.005;
                    elseif Model.multiple.index == 4
                        beginAlpha2 = 0.05;
                        endAlpha2 = 0.0005;
                    elseif Model.multiple.index == 5
                        beginAlpha2 = 0.01;
                        endAlpha2 = 0.001;
                    elseif Model.multiple.index == 6
                        beginAlpha2 = 0.01;
                        endAlpha2 = 0.0001;                    
                    end;
                    beginAlpha1 = 0.1 * beginAlpha2;
                    endAlpha1 = 0.1 * endAlpha2;                
                    if strcmp(unlearnType{layer},'anyCat')
                        beginAlpha2 = 0.1 * beginAlpha2;
                        endAlpha2 = 0.1 * endAlpha2;     
                        beginAlpha1 = beginAlpha2;
                        endAlpha1 = endAlpha2;                        
                    end;

                end;
                %%%%%%

                if Model.multiple.numToyProblem == 3
                    alpha = 0.01; % wine
                elseif Model.multiple.numToyProblem == 15  
                    if strcmp(learnRate,'static') 
                        alpha = 0.01 * ones(1,epochs); % 15scenes 
                    elseif strcmp(learnRate,'decay')
                        tau = - epochs/ log(endAlpha1/beginAlpha1);
                        alpha1 = beginAlpha1 * exp(-[1:epochs]/tau);  
                        tau = - epochs/ log(endAlpha2/beginAlpha2);
                        alpha2 = beginAlpha2 * exp(-[1:epochs]/tau);     
                    elseif strcmp(learnRate,'linear')
                        tau = (endAlpha1 - beginAlpha1) / (epochs-1);
                        alpha1 = tau * ([1:epochs] - 1) + beginAlpha1;  
                        tau = (endAlpha2 - beginAlpha2) / (epochs-1);
                        alpha2 = tau * ([1:epochs] - 1) + beginAlpha2;                      
                    end;
                end;           

                if catFindControl == 1
                    score = confuseMatrixTrain{j}(catError1, catError2);
                    if score == 0 || pairControl(catError1, catError2) == 1
                        catFindControl = 0;
                    end;
                end;

                if catFindControl == 0
                    findPair = 0;
                    confuseMatrixTrainTemp = confuseMatrixTrain{j};
                    while findPair == 0
                        if strcmp(orderCat,'bigger')
                            [M,I] = max(confuseMatrixTrainTemp(:));
                            [catError1, catError2] = ind2sub(size(confuseMatrixTrainTemp),I);
                        elseif strcmp(orderCat,'smaller')
                            [M,I] = min(confuseMatrixTrain{j}(:));
                            [catError1, catError2] = ind2sub(size(confuseMatrixTrainTemp),I);
                        end;
                        if pairControl(catError1, catError2) == 0
                            findPair = 1;
                        else
                            confuseMatrixTrainTemp(catError1, catError2) = 0;
                        end;
                    end;
                    errorSamples = find(macthesDensityTrain(1,:) == 0);
                    categories = train_labels(errorSamples); 
                    categoriesError = indexesWinnersTrain(errorSamples);
                    indexes = find(categories == catError1 & categoriesError == catError2);
                    errorSamples = errorSamples(indexes);
                    correctNodes = correctNodes(indexes);
                    incorrectNodes = incorrectNodes(indexes);
                    categories = categories(indexes); 
                    catFindControl = 1;
                elseif catFindControl == 1
                    errorSamples = find(macthesDensityTrain(1,:) == 0);
                    categories = train_labels(errorSamples); 
                    categoriesError = indexesWinnersTrain(errorSamples);
                    indexes = find(categories == catError1 & categoriesError == catError2);
                    errorSamples = errorSamples(indexes);
                    correctNodes = correctNodes(indexes);
                    incorrectNodes = incorrectNodes(indexes);
                    categories = categories(indexes);                  
                else
                    errorSamples = find(macthesDensityTrain(1,:) == 0);
                    categories = train_labels(errorSamples);                
                end;

                alpha1Log = [];
                errorSamplesLog{j} = errorSamples;
                order = randperm( length(errorSamples) );                
                for sample = 1:length(errorSamples)
                    if  strcmp(weigthsFitEquation{layer},'learn') | strcmp(weigthsFitEquation{layer},'learn_unlearn')
                        category = categories( order(sample) );
                        if layer == 1 
                            x = SamplesTrain.data( errorSamples(order(sample)) ,:);
                        else
                            x = DeepSOM{category,layer-1}.BMUsValuesTrain( errorSamples(order(sample)) ,:);                  
                        end;
                        node = correctNodes(order(sample));

                        if strcmp(updateMode{layer},'seq')
                            Dx = (x - DeepSOM{category,layer}.sMap.codebook( node,:) );  
                        elseif strcmp(updateMode{layer},'batch')
                            Dx = (x - DeepSOMEpochs{j}{category,layer}.sMap.codebook( node,:) );   
                        end;

                        if strcmp(fitEstimateMode{layer},'yes')
                            if strcmp(updateMode{layer},'seq')
                                [alpha1(j), relevancesActives] = fitEstimate(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, correctNodesTotal(errorSamples(order(sample))), errorSamples(order(sample)), indexesWinnersTrain( errorSamples(order(sample))), incorrectNodesTotal( errorSamples(order(sample)) ), Dx, 'learn', relevanceSelectionFunction );
                            elseif strcmp(updateMode{layer},'batch')
                                [alpha1(j), relevancesActives] = fitEstimate(Model, DeepSOMEpochs{j}, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, node, errorSamples(order(sample)), indexesWinnersTrain( errorSamples(order(sample))), Dx, 'learn', relevanceSelectionFunction );
                            end;
                        end;

                        if strcmp(relevanceSelectionFunction{layer},'no')
                            DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                    + alpha1(j) * relevancesActives .* DeepSOM{category,layer}.relevance(node,:)  .* Dx; %Learn 
                        elseif strcmp(relevanceSelectionFunction{layer},'binary')
                            DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                    + alpha1(j) * relevancesActives .* Dx; %Learn                             
                        end;
                                
                        if alpha1(j) > 0
                            updateEpoch = 1;                            
                        end;
                        alpha1Log(sample) = alpha1(j) > 0;
                        Model.test.layer{layer+1}.errorNodeAnalisys.relevancesActives{r} = ...
                            [Model.test.layer{layer+1}.errorNodeAnalisys.relevancesActives{r} sum(relevancesActives)];

                    end;

                    
                    if  strcmp(weigthsFitEquation{layer},'unlearn') | strcmp(weigthsFitEquation{layer},'learn_unlearn')
                        if strcmp(unlearnType{layer},'oneCat')
                            category = indexesWinnersTrain( 1, errorSamples(order(sample)) ); %categories( order(sample) );
                            if layer == 1 
                                x = SamplesTrain.data( errorSamples(order(sample)) ,:);
                            else
                                x = DeepSOM{category,layer-1}.BMUsValuesTrain( errorSamples(order(sample)) ,:);
                            end;
                            node = incorrectNodes(order(sample));
                            Dx = (x - DeepSOM{category,layer}.sMap.codebook( node,:) );  

                            DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                    - alpha2(j) * DeepSOM{category,layer}.relevance(node)  .* Dx; %Unlearn  
                            
                        elseif strcmp(unlearnType{layer},'anyCat')
                            alphaDebug{order(sample)} = zeros(Model.multiple.numMap(layer), Model.multiple.numToyProblem);
                            for category = 1:Model.multiple.numToyProblem
                                if sum( errorMatrixSamplesTrain{ errorSamples(order(sample)) }(:,category) ) > 0
                                    for node = 1:Model.multiple.numMap(layer)
                                        if errorMatrixSamplesTrain{ errorSamples(order(sample)) }(node,category) > 0
                                            if layer == 1 
                                                x = SamplesTrain.data( errorSamples(order(sample)) ,:);
                                            else 
                                                x = DeepSOM{category,layer-1}.BMUsValuesTrain( errorSamples(order(sample)) ,:);
                                            end;

                                            if strcmp(updateMode{layer},'seq')
                                                Dx = (x - DeepSOM{category,layer}.sMap.codebook( node,:) );  
                                            elseif strcmp(updateMode{layer},'batch')
                                                Dx = (x - DeepSOMEpochs{j}{category,layer}.sMap.codebook( node,:) );   
                                            end;

                                       
                                            
                                            if strcmp(fitEstimateMode{layer},'yes')
                                                if strcmp(updateMode{layer},'seq')
                                                    [alpha2(j), relevancesActives] = fitEstimate(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, correctNodesTotal(errorSamples(order(sample))), errorSamples(order(sample)), indexesWinnersTrain( errorSamples(order(sample))), node, Dx, 'unlearn', relevanceSelectionFunction );
                                                elseif strcmp(updateMode{layer},'batch')
                                                    [alpha2(j), relevancesActives] = fitEstimate(Model, DeepSOMEpochs{j}, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, node, errorSamples(order(sample)), category, Dx, 'unlearn', relevanceSelectionFunction);
                                                end;
                                            end;                                

                                            alphaDebug{order(sample)}(node,category)  = alpha2(j);

                                            if strcmp(relevanceSelectionFunction{layer},'no')
                                                DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                                        - alpha2(j) * relevancesActives .* DeepSOM{category,layer}.relevance(node,:)  .* Dx; %Unlearn  
                                            elseif strcmp(relevanceSelectionFunction{layer},'binary')
                                                DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                                        - alpha2(j) * relevancesActives .* Dx; %Unlearn                                                  
                                            end;
                                            
                                            if alpha2(j) > 0
                                                updateEpoch = 1;                            
                                            end;
                                            alpha2Log(sample) = alpha2(j) > 0;   
                                            Model.test.layer{layer+1}.errorNodeAnalisys.relevancesActives{r} = ...
                                                [Model.test.layer{layer+1}.errorNodeAnalisys.relevancesActives{r} sum(relevancesActives)];
                                            
                                        end;
                                    end;
                                end;    
                            end;                        
                        end;
                    end;


                    if  strcmp(centerVirtualWeigthsFitEquation{layer},'learn_incorrect')
                        category = indexesWinnersTrain( 1, errorSamples(order(sample)) ); %categories( order(sample) );
                        node = incorrectNodes(order(sample));
                        Dx = (virtualCenters(category,:) - DeepSOM{category,layer}.sMap.codebook( node,:) );  
                        if  layer == 1 
                            DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                + alpha2(j) .* Dx; %learn
                        else
                              DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                                + alpha2(j) * DeepSOM{category,layer}.relevance(node)  .* Dx; %learn  
                        end;
                    elseif  strcmp(centerVirtualWeigthsFitEquation{layer},'unlearn_incorrect')
                        correctCategory = categories( order(sample) );
                        incorrectCategory = indexesWinnersTrain( 1, errorSamples(order(sample)) ); %categories( order(sample) );
                        node = incorrectNodes(order(sample));
                        Dx = (virtualCenters(correctCategory,:) - DeepSOM{incorrectCategory,layer}.sMap.codebook( node,:) );  
                        if  layer == 1 
                            DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) = DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) ...
                                - alpha2(j) .* Dx; %learn
                        else
                            if strcmp(unlearnType{layer},'oneCat')
                              DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) = DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) ...
                                - alpha2(j) * DeepSOM{incorrectCategory,layer}.relevance(node)  .* Dx; %learn  
                            else  strcmp(unlearnType{layer},'anyCat')
                              DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) = DeepSOM{incorrectCategory,layer}.sMap.codebook(node,:) ...
                                - alpha2(j) * DeepSOM{incorrectCategory,layer}.relevance(node)  .* Dx; %learn                              
                            end;
                        end;    
                    end;

                end;
                
                
                
                if strcmp(prototypeRefinement{layer},'yes')
                    [near] = fitEstimateCos(Model, DeepSOM, SamplesTrain, SamplesTest, layer);
                    DeepSOMBegin = DeepSOM;
                    for len = 1:length(near.cat1)
                        cat1 = near.cat1(len);
                        cat2 = near.cat2(len);
                        node1 = near.node1(len); 
                        node2 = near.node2(len);  
                        alpha = near.alpha(len);

                        Dx = (DeepSOM{cat1,layer}.sMap.codebook(node1,:) - DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:));         
                        DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:) ...
                            - alpha * DeepSOMBegin{cat2,layer}.relevance(node2,:)  .* Dx; %Unlearn   

                        Dx = (DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:) - DeepSOMBegin{cat1,layer}.sMap.codebook(node1,:));         
                        DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOMBegin{cat1,layer}.sMap.codebook(node1,:) ...
                            - alpha * DeepSOMBegin{cat1,layer}.relevance(node1,:)  .* Dx; %Unlearn  
                    end;
                end;
                

                if strcmp(relevanceAtive{layer},'yes')  
                    if length(errorSamples) > 0
                        [Model, DeepSOM, winnerNode] = computeRelevanceEpochs(Model, DeepSOM, layer, [], [], train_labels, test_labels, Model.multiple.trainlen(layer,1), Model.multiple.trainlen(layer,1));
                    end;
                    Model.test.layer{layer+1}.winnerNodeLog{j} = winnerNode;
                end;   


            end;
        else
            alpha1EpochsLog(j) = 0 ;



            errorSamplesTest = find(macthesDensityTest(1,:) == 0);
            categoriesTest = test_labels(errorSamplesTest);        

            Model.test.layer{layer+1}.errorNodeAnalisys.train.correctNodes{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.train.correctCategories{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.train.incorrectNodes{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.train.incorrectCategories{r,j} = 0;  
            Model.test.layer{layer+1}.errorNodeAnalisys.test.correctNodes{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.correctCategories{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.incorrectNodes{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.incorrectCategories{r,j} = 0; 
            Model.test.layer{layer+1}.errorNodeAnalisys.train.pipelineCorrectOrder{r}(j,:) = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.pipelineCorrectOrder{r}(j,:) = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.train.errorMatrixSamples{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.errorMatrixSamples{r,j} = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.train.correctNodeGlobalOrder{r}(j,:) = 0;
            Model.test.layer{layer+1}.errorNodeAnalisys.test.correctNodeGlobalOrder{r}(j,:) = 0;

        end;      
        
 
        pairIt = pairIt + 1;
% %         alpha1EpochsLog(j) = sum(alpha1Log) / length(alpha1Log) ;
% %                
% %         
% %         %confuseMatrixTrain{j} = confuseMatrixTrainTemp;
% %         %confuseMatrixTest{j} = confuseMatrixTestTemp;
        
        errorSamplesTest = find(macthesDensityTest(1,:) == 0);
        categoriesTest = test_labels(errorSamplesTest);        
        
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.correctNodes{r,j} = correctNodes;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.correctCategories{r,j} = categories;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.incorrectNodes{r,j} = incorrectNodes;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.incorrectCategories{r,j} = indexesWinnersTrain( 1, errorSamples );  
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.correctNodes{r,j} = correctNodesTest;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.correctCategories{r,j} = categoriesTest;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.incorrectNodes{r,j} = incorrectNodesTest;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.incorrectCategories{r,j} = indexesWinnersTest( 1, errorSamplesTest ); 
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.pipelineCorrectOrder{r}(j,:) = pipelineCorrectOrderTrain;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.pipelineCorrectOrder{r}(j,:) = pipelineCorrectOrderTest;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.errorMatrixSamples{r,j} = errorMatrixSamplesTrain;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.errorMatrixSamples{r,j} = errorMatrixSamplesTest;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.train.correctNodeGlobalOrder{r}(j,:) = correctNodeGlobalOrderTrain;
% %         Model.test.layer{layer+1}.errorNodeAnalisys.test.correctNodeGlobalOrder{r}(j,:) = correctNodeGlobalOrderTest;
% %         %Model.test.layer{layer+1}.errorNodeAnalisys.train.activation{r,j} = dataTrain;
% %         %Model.test.layer{layer+1}.errorNodeAnalisys.test.activation{r,j} = dataTest;
% %         %Model.test.layer{layer+1}.errorNodeAnalisys.alpha{r,j} = alphaDebug;
        
    end;
        

    
    [~,indexTrainMax] = max(acurracyDensityEpochsTrain);
    
    DeepSOM = DeepSOMEpochs{indexTrainMax};
    
    Model.test.layer{layer+1}.scoreTrainOld(r) = Model.test.layer{layer+1}.scoreTrain(r);
    Model.test.layer{layer+1}.scoreTestOld(r) = Model.test.layer{layer+1}.scoreTest(r);
    
    Model.test.layer{layer+1}.scoreTrain(r) = acurracyDensityEpochsTrain(indexTrainMax);
    Model.test.layer{layer+1}.scoreTest(r) = acurracyDensityEpochsTest(indexTrainMax);
    
    Model.test.layer{layer+1}.indexesWinnersTrain{r} = indexesWinnersTrainEpochs{indexTrainMax};
    Model.test.layer{layer+1}.indexesWinnersTest{r} = indexesWinnersTestEpochs{indexTrainMax};
    
    Model.test.layer{layer+1}.macthesDensityTrain{r} = macthesDensityTrainEpochs{indexTrainMax};
    Model.test.layer{layer+1}.macthesDensityTest{r} = macthesDensityTestEpochs{indexTrainMax};    
    
    
    [~,indexTrainMax] = max(acurracyDensityEpochsTrain);
    Model.test.layer{layer+1}.scoreTrainFirstMax(r) = acurracyDensityEpochsTrain(indexTrainMax);
    Model.test.layer{layer+1}.scoreTestFirstMax(r) = acurracyDensityEpochsTest(indexTrainMax);
    
    
    [maxval,~] = max(acurracyDensityEpochsTrain);
    indexTrainMax = find(acurracyDensityEpochsTrain==maxval,1,'last');
    Model.test.layer{layer+1}.scoreTrainLastMax(r) = acurracyDensityEpochsTrain(indexTrainMax);
    Model.test.layer{layer+1}.scoreTestLastMax(r) = acurracyDensityEpochsTest(indexTrainMax);  
    
    Model.test.layer{layer+1}.iMaxLog{r} = iMaxLog;
    Model.test.layer{layer+1}.jMaxLog{r} = jMaxLog;
    
    Model.test.layer{layer+1}.scoreLogTrain{r} = acurracyDensityEpochsTrain;
    Model.test.layer{layer+1}.scoreLogTest{r} = acurracyDensityEpochsTest;
    
    Model.test.layer{layer+1}.scoreMaxGlobalTrain(r) = max(acurracyDensityEpochsTrain);
    Model.test.layer{layer+1}.scoreMaxGlobalTest(r) = max(acurracyDensityEpochsTest);
    
    Model.test.layer{layer+1}.confuseMatrixLogTrain{r} = confuseMatrixTrain;
    Model.test.layer{layer+1}.confuseMatrixLogTest{r} = confuseMatrixTest;
    
% %     %%%%
% %     train_labels = train_labelsOld;
% %     DeepSOM = DeepSOMOld;      
% %     %%%%%    
    
end