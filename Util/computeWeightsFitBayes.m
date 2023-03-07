% Marcondes Ricarte

function [Model, DeepSOM, train_labels, test_labels, SamplesTrain, SamplesTest] = computeWeightsFitBayes(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r)


    [~,dim] = size(SamplesTrain.data);
    
    
    experiments = 20;
    if r == 1
        for exp = 1:experiments
            expoente = round(8 * rand()) + 2;
            params = round(40 * rand()) + 10;
            Model.bayes.params(exp) = params;
            Model.bayes.nodes(exp) = Model.multiple.numMap(layer); %round(8 * rand()) + 4;   
            %expoente = round(1 * rand()) + 1; %iris
            expoente = round(2 * rand()) + 1;
            Model.bayes.regularizationValue(exp) =  10^(-expoente) * rand() + 10^(-expoente-1);
        end;
    end;
    
     
    for exp = 1:experiments
        [r exp]

        
        [accuracyTrain(exp), accuracyTest(exp)] = BayesSOM(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, Model.bayes.params(exp), Model.bayes.regularizationValue(exp));

            
% %         parfor class = 1:Model.numClasses
% %             obj{class} = gmdistribution.fit(SamplesTrain.data(train_labels == class,:),Model.bayes.nodes(exp),'CovType','diagonal','SharedCov',true,'Regularize',Model.bayes.params(exp), 'RegularizationValue', Model.bayes.regularizationValue(exp)); % Fitting category1 to object 1
% %         end;
% %     
% %         output = [];
% %         for class = 1:Model.numClasses 
% %             output = [output pdf(obj{class},SamplesTrain.data)]; 
% %         end;
% %         [~,indexes] = max(output,[],2);
% %         accuracyTrain(exp) = sum(train_labels==indexes')/size(train_labels',1); 
% %     
% %     
% %         output = [];
% %         for class = 1:Model.numClasses 
% %             output = [output pdf(obj{class},SamplesTest.data)]; 
% %         end;
% %         [~,indexes] = max(output,[],2);
% %         accuracyTest(exp) = sum(test_labels==indexes')/size(test_labels',1);    
            


    end;

    Model.test.layer{layer+1}.scoreBayesTrain(r,:) = accuracyTrain;
    Model.test.layer{layer+1}.scoreBayesTest(r,:) = accuracyTest;        


end