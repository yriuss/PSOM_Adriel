% Marcondes Ricarte

function [epochCompute, scores] = ...
    evaluateRelevance(Model, DeepSOM, layer, train_labels, test_labels, order, r, epoch, epochCompute, scores)
    

        flagCompute =  sum(Model.multiple.setRelevance == epoch);
        
        if flagCompute        
            for pipeline = 1:Model.multiple.numToyProblem
                dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
                dataSamplesTest.data = DeepSOM{pipeline,layer-1}.BMUsValuesTest;               
                DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
                DeepSOM{pipeline,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTest, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance);
            end;

            dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
            dataTest = concatPipelines(Model, DeepSOM, layer, 'test', Model.multiple.numToyProblem);   

            [acurracyDensityTrain(epochCompute,:),~,~,~,~,~] = ... 
                debugMeanWinners(Model, dataTrain, layer, Model.multiple.numMap(layer), train_labels,'descend');
            [acurracyDensityTest(epochCompute,:),~,~,~,~,~] = ...
                debugMeanWinners(Model, dataTest, layer, Model.multiple.numMap(layer), test_labels,'descend');
            scores.scoreTrain(r,epochCompute) = acurracyDensityTrain(epochCompute,1);
            scores.scoreTest(r,epochCompute) = acurracyDensityTest(epochCompute,1);
            

            for k=1:length(train_labels)
                activationCorrectTrain(k) = max(DeepSOM{train_labels(1,k),layer}.BMUsValuesTrain(k,:));
            end;
            for k=1:length(test_labels)
                activationCorrectTest(k) = max(DeepSOM{test_labels(1,k),layer}.BMUsValuesTest(k,:));
            end;                
            for k=1:length(train_labels)
                activationsErrorTrain = [];
                for k2=1:Model.multiple.numToyProblem                        
                    if k2 ~= train_labels(1,k)
                        activationsErrorTrain = [activationsErrorTrain max(DeepSOM{k2,layer}.BMUsValuesTrain(k,:))];
                    end;
                end;
                activationErrorTrain(k) = max(activationsErrorTrain);
            end;
            for k=1:length(test_labels)
                activationsErrorTest = [];
                for k2=1:Model.multiple.numToyProblem                        
                    if k2 ~= test_labels(1,k)
                        activationsErrorTest = [activationsErrorTest max(DeepSOM{k2,layer}.BMUsValuesTest(k,:))];
                    end;
                end;
                activationErrorTest(k) = max(activationsErrorTest);
            end;  
            
            scores.ratioActivationsTrain(r,epochCompute) = mean( activationCorrectTrain./activationErrorTrain);
            scores.ratioActivationsTest(r,epochCompute) = mean( activationCorrectTest./activationErrorTest);
            
            ratioActivationsTrain = activationCorrectTrain./activationErrorTrain;
            ratioActivationsTest = activationCorrectTest./activationErrorTest;
            
            scores.ratioCorrectActivationsTrain(r,epochCompute)  = mean(ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 1 )  ));
            scores.ratioCorrectActivationsTest(r,epochCompute)  = mean(ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 1 )  ));             

            activations = ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 1 )  );
            scores.ratioCorrectCorrectActivationsTrain(r,epochCompute)  = mean( activations( find(activations >= 1) ) );
            activations = ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 1 )  );
            scores.ratioCorrectCorrectActivationsTest(r,epochCompute)  = mean( activations( find(activations >= 1) ) );            

            activations = ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 1 )  );
            scores.ratioCorrectErrorActivationsTrain(r,epochCompute)  = mean( activations( find(activations < 1) ) );
            activations = ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 1 )  );
            scores.ratioCorrectErrorActivationsTest(r,epochCompute)  = mean( activations( find(activations < 1) ) );             
            
            scores.ratioErrorActivationsTrain(r,epochCompute)  = mean(ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 0 )  ));
            scores.ratioErrorActivationsTest(r,epochCompute)  = mean(ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 0 )  ));         

            activations = ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 0 )  );
            scores.ratioErrorCorrectActivationsTrain(r,epochCompute)  = mean( activations( find(activations >= 1) ) );
            activations = ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 0 )  );
            scores.ratioErrorCorrectActivationsTest(r,epochCompute)  = mean( activations( find(activations >= 1) ) );            

            activations = ratioActivationsTrain( find(Model.test.layer{layer+1}.macthesDensityTrain{1,r}(1,:) == 0 )  );
            scores.ratioErrorErrorActivationsTrain(r,epochCompute)  = mean( activations( find(activations < 1) ) );
            activations = ratioActivationsTest( find(Model.test.layer{layer+1}.macthesDensityTest{1,r}(1,:) == 0 )  );
            scores.ratioErrorErrorActivationsTest(r,epochCompute)  = mean( activations( find(activations < 1) ) );             
            
            epochCompute = epochCompute + 1;
        end;           



end