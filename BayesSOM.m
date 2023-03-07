
function [accurracyTrain, accurracyTest] = BayesSOM(Model, DeepSOM, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r,MaxIteration,logliklihoodThreshold)


k = Model.multiple.numMap(layer);
intailization_strategy = 3;
relevanceBayes = 0;

for cat = 1:Model.numClasses
    if layer == 1
        x = SamplesTrain.data(train_labels == cat,:);
    else
        x = DeepSOM{cat,layer-1}.BMUsValuesTrain(train_labels == cat,:);
    end;
    
    if strcmp(Model.multiple.distanceType{layer},'relevance_sub_variance') && relevanceBayes ==  1
        x = DeepSOM{cat,layer}.relevance(1,:) .* x;
        codebook = DeepSOM{cat,layer}.relevance(1,:) .* DeepSOM{cat,layer}.sMap.codebook;
    else
        codebook = DeepSOM{cat,layer}.sMap.codebook;
    end;
    
    sizeX = size(x,1);
    
    membership=0;
    sses = []
    vect = 0;

    P(1,1) = NaN;
    i = 1;
    count = 1;
    while isnan(P(1,1)) && count < 3
        [means_init,converiances_init] = intialization_step(intailization_strategy,x,k,i,codebook);
        % run GaussianMixtureLearning update E and M step until convergence reached or max iteration reached...
        [means,converiances,P,log_p_self,liklihood,P_absolute] = GaussianMixtureLearning(x,means_init,converiances_init,k,i,MaxIteration,logliklihoodThreshold);
        means_init_tracker{i} = means_init;
        means_tracker{i} = means;
        converiances_tracker{i} = converiances;
        log_p_self_tracker{i}=log_p_self;
        vect(i) = log_p_self(end)
        P_tracker{i} = P;
        count = count + 1;
        if count == 3
            [row,col]= size(P);
            P = zeros(row,col);
        end

    end;
        


    for dataType = 1:2

        if dataType == 1
            if layer == 1
                x = SamplesTrain.data;
            else
                x = DeepSOM{cat,layer-1}.BMUsValuesTrain;
            end;            
        else
            if layer == 1
                x = SamplesTest.data;
            else
                x = DeepSOM{cat,layer-1}.BMUsValuesTest;
            end;  
        end;
        
        if strcmp(Model.multiple.distanceType{layer},'relevance_sub_variance')  && relevanceBayes ==  1
            x = DeepSOM{cat,layer}.relevance(1,:) .* x;
        end;

        sizeX = size(x,1);
        [~,~,P,~,~] = GaussianMixtureLearningAll(x,means,converiances{1,2},liklihood,k,i); 
    
        [maxLog,idx] = max(vect);
        P_tracker{idx} = P;
           
        [maxLog,idx] = max(vect);
        best_P =  P_tracker{idx};

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        

        for j=1:sizeX
            maxVal = max(best_P(j,:));          

            if dataType == 1
                maxValTotalTrain(cat,j) = maxVal;
            else
                maxValTotalTest(cat,j) = maxVal;    
            end;
        end

    end;
end;

[~,indexesTrain] = max(maxValTotalTrain);
accurracyTrain = sum(indexesTrain == train_labels)/length(indexesTrain == train_labels);

[~,indexesTest] = max(maxValTotalTest);
accurracyTest = sum(indexesTest == test_labels)/length(indexesTest == test_labels);


 
    

end