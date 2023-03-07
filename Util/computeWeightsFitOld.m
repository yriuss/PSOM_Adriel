% Marcondes Ricarte

function [Model, DeepSOM] = computeWeightsFit(Model, DeepSOM, layer, train_labels, test_labels, r)

    numClass = Model.multiple.numToyProblem;

    alpha = 0.01;
    
    for j = 1:100
    
        for pipeline = 1:Model.multiple.numToyProblem
            dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
            dataSamplesTest.data = DeepSOM{pipeline,layer-1}.BMUsValuesTest;               
            DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
            DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
        end;

        dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
        dataTest = concatPipelines(Model, DeepSOM, layer, 'test', Model.multiple.numToyProblem);   

        [acurracyDensityTrain,~,~,macthesDensityTrain,~,indexesWinnersTrain] = ... 
            debugMeanWinners(Model, dataTrain, layer, Model.multiple.numMap(layer), train_labels,'descend');
        [acurracyDensityTest,~,~,macthesDensityTest,~,indexesWinnersTest] = ...
            debugMeanWinners(Model, dataTest, layer, Model.multiple.numMap(layer), test_labels,'descend');

        acurracyDensityEpochsTrain(j) = acurracyDensityTrain(1);
        acurracyDensityEpochsTest(j) = acurracyDensityTest(1);
        
        confuseMatrixTrain{j} = zeros(numClass,numClass);
        for k=1:length(macthesDensityTrain(1,:))
             confuseMatrixTrain{j}(train_labels(1,k), indexesWinnersTrain(1,k)) = ...
                 confuseMatrixTrain{j}(train_labels(1,k), indexesWinnersTrain(1,k)) + 1;                     
        end;
        sumTrain = sum(confuseMatrixTrain{j}')';
        confuseMatrixTrain{j} = confuseMatrixTrain{j}./repmat(sumTrain,1,numClass);

% %         confuseMatrixTest{j} = zeros(numClass,numClass);
% %         for k=1:length(macthesDensityTest(1,:))
% %              confuseMatrixTest{j}(test_labels(r,k), indexesWinnersTest(1,k)) = ...
% %                  confuseMatrixTest{j}(test_labels(r,k), indexesWinnersTest(1,k)) + 1;                     
% %         end;
% %         sumTest = sum(confuseMatrixTest{j}')';
% %         confuseMatrixTest{j} = confuseMatrixTest{j}./repmat(sumTest,1,numClass);     

        for k = 1:Model.multiple.numToyProblem
            confuseMatrixTrain{j}(k,k) = 0;
            virtualCenters(k,:) = mean(DeepSOM{k,layer}.sMap.codebook);
        end;

        maximum = max(max(confuseMatrixTrain{j}));
        %[iMax,jMax] = find(confuseMatrixTrain{j}==maximum);
        
% %         search = 0;
% %         for iMaxTemp = 1:Model.multiple.numToyProblem
% %             for jMaxTemp = 1:Model.multiple.numToyProblem
% %                 if confuseMatrixTrain{j}(iMaxTemp,jMaxTemp) == maximum & search == 0
% %                     search = 1;
% %                     iMax = iMaxTemp;   
% %                     jMax = jMaxTemp;                      
% %                 end;
% %             end;            
% %         end;
% % 
% %         iMaxLog(j) = iMax;
% %         jMaxLog(j) = jMax;
% % 
% %         %Unlearn
% %         DeepSOMEpochs{j} = DeepSOM;
% %         indexesWinnersTrainEpochs{j} = indexesWinnersTrain;
% %         indexesWinnersTestEpochs{j} = indexesWinnersTest;
% %         macthesDensityTrainEpochs{j} = macthesDensityTrain;
% %         macthesDensityTestEpochs{j} = macthesDensityTest;
% %         % aproximação
% %         DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,2}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
% %         % afastamento       
% %         %DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,2}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));
% % 
% %         
        
        alpha = 0.001;
        search = 1;
        for iMaxTemp = 1:Model.multiple.numToyProblem
            for jMaxTemp = 1:Model.multiple.numToyProblem
                if confuseMatrixTrain{j}(iMaxTemp,jMaxTemp) > 0
                    iMaxTotal(search) = iMaxTemp;   
                    jMaxTotal(search) = jMaxTemp;     
                    search = search + 1;                    
                end;                
            end;            
        end;


        %Unlearn
        DeepSOMEpochs{j} = DeepSOM;
        indexesWinnersTrainEpochs{j} = indexesWinnersTrain;
        indexesWinnersTestEpochs{j} = indexesWinnersTest;
        macthesDensityTrainEpochs{j} = macthesDensityTrain;
        macthesDensityTestEpochs{j} = macthesDensityTest;
        
        order = randperm(length(iMaxTotal));
        
        for k = 1:length(iMaxTotal)
            iMax = iMaxTotal(order(k));
            jMax = jMaxTotal(order(k));
            % aproximação
            DeepSOM{iMax,layer}.sMap.codebook = DeepSOM{iMax,2}.sMap.codebook + alpha * DeepSOM{iMax,2}.relevance .* (virtualCenters(jMax,:) - virtualCenters(iMax,:)); 
            % afastamento       
            % DeepSOM{jMax,layer}.sMap.codebook = DeepSOM{jMax,2}.sMap.codebook - alpha * DeepSOM{jMax,2}.relevance .* (virtualCenters(iMax,:) - virtualCenters(jMax,:));        
        end;
        
    end;
    
    [~,indexTrainMax] = max(acurracyDensityEpochsTrain);
    
% %     [maxval,~] = max(acurracyDensityEpochsTrain);
% %     indexTrainMax = find(acurracyDensityEpochsTrain==maxval,1,'last');
    
    DeepSOM = DeepSOMEpochs{indexTrainMax};
    
    Model.test.layer{layer+1}.scoreTrainOld(r) = Model.test.layer{layer+1}.scoreTrain(r);
    Model.test.layer{layer+1}.scoreTestOld(r) = Model.test.layer{layer+1}.scoreTest(r);
    
    Model.test.layer{layer+1}.scoreTrain(r) = acurracyDensityEpochsTrain(indexTrainMax);
    Model.test.layer{layer+1}.scoreTest(r) = acurracyDensityEpochsTest(indexTrainMax);
    
    Model.test.layer{layer+1}.indexesWinnersTrain{r} = indexesWinnersTrainEpochs{indexTrainMax};
    Model.test.layer{layer+1}.indexesWinnersTest{r} = indexesWinnersTestEpochs{indexTrainMax};
    
    Model.test.layer{layer+1}.macthesDensityTrain{r} = macthesDensityTrainEpochs{indexTrainMax};
    Model.test.layer{layer+1}.macthesDensityTest{r} = macthesDensityTestEpochs{indexTrainMax};    
end