% Marcondes Ricarte

function [relevance, Model, DeepSOM, SamplesTrain, SamplesTest] = computeRelevance(Model, DeepSOM, layer, SamplesTrain, SamplesTest, train_labels, test_labels)
    
    epsilon = 0.0001;
    for i =  1:Model.multiple.numToyProblem
        trainLabelsFilter(train_labels == i) = i;
        testLabelsFilter(test_labels == i) = i;
        if layer ~= 0
            [len dim(i)] = size(DeepSOM{i,layer}.BMUsValuesTrain);
        else
            [len dim(i)] = size(SamplesTrain.data);
        end;
    end;


    if strcmp(Model.multiple.distanceType{layer+1},'relevance_variance')
        if strcmp(Model.multiple.inputPrototype{layer},'no')
            if strcmp(Model.multiple.variancePipeline{layer},'lonely')
                if strcmp(Model.multiple.relevanceSelect{layer},'train_pipeline')
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        relevance{layer+1}{i} = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ); %var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)] );                
                    end;   
                elseif strcmp(Model.multiple.relevanceSelect{layer},'traintest')
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        selectedTest = find(test_labels == i);
                        relevance{layer+1}{i} = var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:) ] ); %var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)] );                
                    end;     
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner')
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        relevance{layer+1}{i} = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));  
                    end;
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = var( dataTrain );  
                    end;
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_var_means_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = var( dataTrain );  
                    end;    
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_covar_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = sum(abs(cov( dataTrain )));  
                    end; 
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_covar_means_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = sum(abs(cov( dataTrain )));  
                    end;                    
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_covar_neg_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = abs(sum(cov( dataTrain )));  
                    end;  
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_covar_means_neg_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain = [dataTrain; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}{i} = abs(sum(cov( dataTrain )));  
                    end;                         
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner_std_means_inter')
                    dataTrain = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        dataTrain =  [dataTrain; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:))];                        
                    end;    
                    for i = 1:Model.multiple.numToyProblem
                        means = mean(dataTrain);
                        stds = std(dataTrain);
                        relevance{layer+1}{i} = max(abs(dataTrain-means))./stds;  
                    end;                         
                elseif strcmp(Model.multiple.relevanceSelect{layer},'traintest-train')
                     for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        selectedTest = find(test_labels == i);
                        relevance1{layer+1}(i,:) = var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:) ]);
                        relevance2{layer+1}(i,:) = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) );  
                    end;
                elseif strcmp(Model.multiple.relevanceSelect{layer},'train-traintest')
                     for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        selectedTest = find(test_labels == i);
                        relevance1{layer+1}(i,:) = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) );
                        relevance2{layer+1}(i,:) = var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:) ]);
                         
                    end;                      
                end;
                if ~strcmp(Model.multiple.relevanceSelect{layer},'traintest-train') && ~strcmp(Model.multiple.relevanceSelect{layer},'train-traintest')
                    for i = 1:Model.multiple.numToyProblem
                        if strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                            [relevanceSort{layer+1}{i}, indexes{i}] = sort(relevance{layer+1}{i},'descend');
                        else strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                            [relevanceSort{layer+1}{i}, indexes{i}] = sort(relevance{layer+1}{i},'ascend');
                        end;
                    end;
                else
                    for i = 1:Model.multiple.numToyProblem
                        if strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                            [relevanceSort1{layer+1}(i,:), indexes1(i,:)] = sort(relevance1{layer+1}(i,:),'descend');
                            [relevanceSort2{layer+1}(i,:), indexes2(i,:)] = sort(relevance2{layer+1}(i,:),'descend');
                        else strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                            [relevanceSort1{layer+1}(i,:), indexes1(i,:)] = sort(relevance1{layer+1}(i,:),'ascend');
                            [relevanceSort2{layer+1}(i,:), indexes2(i,:)] = sort(relevance2{layer+1}(i,:),'ascend');
                        end;
                    end;                    
                end;
                if ~strcmp(Model.multiple.relevanceSelect{layer},'traintest-train')  && ~strcmp(Model.multiple.relevanceSelect{layer},'train-traintest')
                    for i = 1:Model.multiple.numToyProblem
                        if strcmp(Model.multiple.relevancePercentFlag{layer},'percent')
                            for j = 1:dim(i)                            
                                if j <= round( (1- Model.multiple.relevancePercent{1,layer+1}(i)  )*dim(i) )
                                    relevanceBinary{layer+1}{i}(1, indexes{i}(1,j)) = 1;
                                else
                                    relevanceBinary{layer+1}{i}(1, indexes{i}(1,j)) = 0;
                                end;
                            end;
                        elseif strcmp(Model.multiple.relevancePercentFlag{layer},'statistic')
                            if ~strcmp(Model.multiple.relevanceStatistic,'band_mean-std_mean+var') & ~strcmp(Model.multiple.relevanceStatistic,'band_mean-std_mean+var_fator')
                                if strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                                    lenAttributes(i) =  sum( relevance{layer+1}{i} < mean(relevance{layer+1}{i}) + Model.multiple.relevancePercent{1,layer+1}(i) * std(relevance{layer+1}{i}) );                                 
                                elseif strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                                    lenAttributes(i) =  sum( relevance{layer+1}{i} > mean(relevance{layer+1}{i}) + Model.multiple.relevancePercent{1,layer+1}(i) * std(relevance{layer+1}{i}) );                         
                                end;
                                if lenAttributes(i) == 0
                                    lenAttributes(i) = 1;
                                end;
                                for j = 1:dim(i)                            
                                    if j <= lenAttributes(i)
                                        relevanceBinary{layer+1}{i}(1, indexes{i}(1,j)) = 1;
                                    else
                                        relevanceBinary{layer+1}{i}(1, indexes{i}(1,j)) = 0;
                                    end;
                                end;   
                            else
% %                                 filter1 = (relevance{layer+1}{i} > mean(relevance{layer+1}{i}) + Model.multiple.relevancePercent{1,layer+1}(i) * std(relevance{layer+1}{i}) );                                 
% %                                 filter2 = (relevance{layer+1}{i} < mean(relevance{layer+1}{i}) + Model.multiple.relevancePercent2{1,layer+1}(i) * std(relevance{layer+1}{i}) ); 
% %                                 relevanceBinary{layer+1}{i} = filter1 & filter2;
                                   
                                    if (Model.multiple.relevancePercent{1,layer+1}(i)+Model.multiple.relevancePercent2{1,layer+1}(i)-1) > dim(i)  
                                        Model.multiple.relevancePercent2{1,layer+1}(i) = dim(i) - Model.multiple.relevancePercent{1,layer+1}(i);
                                    end;
                                    relevanceBinary{layer+1}{i} = zeros(1,dim(i));
                                    relevanceBinary{layer+1}{i}(1, indexes{i}(1,  ...
                                        Model.multiple.relevancePercent{1,layer+1}(i):Model.multiple.relevancePercent{1,layer+1}(i)+Model.multiple.relevancePercent2{1,layer+1}(i) -1 )) = 1;                                    
                                    %%%%%%%
% %                                     selectedTrain = find(train_labels == i);
% %                                     selectedTest = find(test_labels == i);
% %                                     relevanceBest{layer+1}{i} = var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:) ] ); %var( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)] );
% %                                     [relevanceBestSort{layer+1}{i}, indexesBest{i}] = sort(relevanceBest{layer+1}{i},'ascend');
% %                                     for j = 1:dim(i)                            
% %                                         if j <= round( (1- 0.6) * dim(i) )
% %                                             relevanceBestBinary{layer+1}{i}(1, indexesBest{i}(1,j)) = 1;
% %                                         else
% %                                             relevanceBestBinary{layer+1}{i}(1, indexesBest{i}(1,j)) = 0;
% %                                         end;
% %                                     end;
% %                                     %relevanceBinary{layer+1}{i} = relevanceBinary{layer+1}{i} &  relevanceBestBinary{layer+1}{i};
% %                                     relevanceBinary{layer+1}{i} = relevanceBinary{layer+1}{i} &  ~relevanceBestBinary{layer+1}{i};
                                    %%%%%%%%
                            end;
                        end;
                    end;
                    
                    if ~strcmp(Model.multiple.relevanceStatistic2{layer},'no')
                        for i = 1:Model.multiple.numToyProblem
                            if strcmp(Model.multiple.relevanceStatistic2{layer},'mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'mean_std_fator') || ...
                               strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean_std_fator') || ...     
                               strcmp(Model.multiple.relevanceStatistic2{layer},'var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'var_mean_std_fator') || ...
                               strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean_std_fator') || ...
                               strcmp(Model.multiple.relevanceStatistic2{layer},'covar_intra') ||  strcmp(Model.multiple.relevanceStatistic2{layer},'var') || ...
                               strcmp(Model.multiple.relevanceStatistic2{layer},'covar_neg_intra') || strcmp(Model.multiple.relevanceStatistic2{layer},'covar_inter') || ...
                               strcmp(Model.multiple.relevanceStatistic2{layer},'covar_neg_inter')
                                selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                                if strcmp(Model.multiple.relevanceStatistic2{layer},'mean') 
                                    relevance2{layer+1}{i} = mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'var') 
                                    relevance2{layer+1}{i} = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));     
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean')
                                    relevance2{layer+1}{i} = var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)).*mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'covar_intra')
                                    relevance2temp{layer+1}{i} = sum(abs(cov( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,find(relevanceBinary{layer+1}{i}))))); 
                                    relevance2{layer+1}{i} = NaN*zeros(1,dim(i));
                                    position = find(relevanceBinary{layer+1}{i});
                                    for k = 1:length(position)                                        
                                        relevance2{layer+1}{i}(1,position(1,k)) = relevance2temp{layer+1}{i}(1,k);                                        
                                    end;
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'covar_neg_intra')
                                    relevance2temp{layer+1}{i} = sum(cov( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,find(relevanceBinary{layer+1}{i})))); 
                                    relevance2{layer+1}{i} = NaN*zeros(1,dim(i));
                                    position = find(relevanceBinary{layer+1}{i});
                                    for k = 1:length(position)                                        
                                        relevance2{layer+1}{i}(1,position(1,k)) = relevance2temp{layer+1}{i}(1,k);
                                    end;
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'covar_inter')
                                    dataTrain = [];
                                    for k = 1:Model.multiple.numToyProblem
                                        dataTrain = [dataTrain; DeepSOM{k,layer}.BMUsValuesTrain(selectedTrain,:) ];
                                    end;
                                    relevance2{layer+1}{i} = sum(abs (cov( dataTrain )));
                                elseif strcmp(Model.multiple.relevanceStatistic2{layer},'covar_neg_inter')
                                    dataTrain = [];
                                    for k = 1:Model.multiple.numToyProblem
                                        dataTrain = [dataTrain; DeepSOM{k,layer}.BMUsValuesTrain(selectedTrain,:) ];
                                    end;
                                    relevance2{layer+1}{i} = sum(cov( dataTrain ));                                    
                                end;
                            elseif strcmp(Model.multiple.relevanceStatistic2{layer},'coef_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'coef_var_mean_std_fator') || ...
                              strcmp(Model.multiple.relevanceStatistic2{layer},'product_coef_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_coef_var_mean_std_fator')
                                selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                                relevance2{layer+1}{i} = relevance{layer+1}{i}./mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));
                            end;
                            if strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean_std_fator') ||...
                              strcmp(Model.multiple.relevanceStatistic2{layer},'coef_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'coef_var_mean_std_fator') || ...
                              strcmp(Model.multiple.relevanceStatistic2{layer},'product_coef_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_coef_var_mean_std_fator')     
                                for j = 1:length(relevanceBinary{layer+1}{i})
                                    if relevanceBinary{layer+1}{i}(1,j) == 0
                                        relevance2{layer+1}{i}(1,j)  = NaN;
                                    end;
                                end;
                            elseif strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean_std_fator')
                                for j = 1:Model.multiple.numToyProblem
                                    selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == j) & (trainLabelsFilter == j)  );
                                    means(j,:) = mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)); 
                                end;
                                relevance2{layer+1}{i} = var(means); 
                                for j = 1:length(relevanceBinary{layer+1}{i})
                                    if relevanceBinary{layer+1}{i}(1,j) == 0
                                        relevance2{layer+1}{i}(1,j)  = NaN;
                                    end;
                                end;  
                                
                            end;
                            if strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_mean_std_fator') || ...
                                    strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean') || strcmp(Model.multiple.relevanceStatistic2{layer},'product_var_mean_std_fator')
                                relevance2mean{layer+1}{i} = relevance2{layer+1}{i};
                                relevance2{layer+1}{i} = relevance{layer+1}{i} .* relevance2{layer+1}{i};
                            end;
                            
                            relevance2{layer+1}{i}(1,find(relevanceBinary{layer+1}{i} == 0)) = NaN;
                            [relevance2sort{layer+1}{i}, indexes2{i}] = sort(relevance2{layer+1}{i},'ascend');
                            relevance2Binary{layer+1}{i} = zeros(1,dim(i));  
                            if (Model.multiple.relevancePercent3{1,layer+1}(i)+Model.multiple.relevancePercent4{1,layer+1}(i)-1) > Model.multiple.relevancePercent2{1,layer+1}(i)
                                Model.multiple.relevancePercent4{1,layer+1}(i) = Model.multiple.relevancePercent2{1,layer+1}(i) - Model.multiple.relevancePercent3{1,layer+1}(i);
                            end;
                            relevance2Binary{layer+1}{i}(1, indexes2{i}(1,  ...
                                Model.multiple.relevancePercent3{1,layer+1}(i):Model.multiple.relevancePercent3{1,layer+1}(i)+Model.multiple.relevancePercent4{1,layer+1}(i) -1 )) = 1;                                 
                            relevanceBinary{layer+1}{i}(1,:) = relevance2Binary{layer+1}{i}(1,:);
                        end;                    
                    end;
                    
                else
                    for i = 1:Model.multiple.numToyProblem
                        for j = 1:dim 
                            if j <= round( (1- Model.multiple.relevancePercent{1,layer+1}(i)  )*dim(i) )
                                relevanceBinary1{layer+1}{i}(1, indexes1(i,j)) = 1;
                                relevanceBinary2{layer+1}{i}(1, indexes2(i,j)) = 1;
                            else
                                relevanceBinary1{layer+1}{i}(1, indexes1(i,j)) = 0;
                                relevanceBinary2{layer+1}{i}(1, indexes2(i,j)) = 0;
                            end;
                        end;
                    end;
                    for i = 1:Model.multiple.numToyProblem
                        relevanceBinary{layer+1}{i}(1, :) = ( relevanceBinary1{layer+1}{i}(1, :) ~= relevanceBinary2{layer+1}{i}(1, :) ) & relevanceBinary1{layer+1}{i}(1, :) == 1;
                    end;
                end;
                
                %%%%%%
                for i = 1:Model.multiple.numToyProblem  
                    if strcmp(Model.multiple.relevanceStatistic2{layer},'no')
                        relevancenNorm{layer+1}{i} = relevance{layer+1}{i}(1,find(relevanceBinary{layer+1}{i}));
                    else
                        relevancenNorm{layer+1}{i} = relevance2{layer+1}{i}(1,find(relevanceBinary{layer+1}{i}));
                    end;
                    relevanceMin(i) = min(relevancenNorm{layer+1}{i});
                    relevanceMax(i) = max(relevancenNorm{layer+1}{i});
                    relevancenNorm{layer+1}{i} = 1 - (relevancenNorm{layer+1}{i}-relevanceMin(i)) / (relevanceMax(i) - relevanceMin(i) );
                    relevanceSum(i) = sum(relevancenNorm{layer+1}{i} );
                    relevancenNorm{layer+1}{i} = relevancenNorm{layer+1}{i}/relevanceSum(i);     
                end;
                %%%%%%
                
                relevanceOriginal = relevance; 
                relevance = relevanceBinary;

                for i = 1:Model.multiple.numToyProblem                    
                    BMUsValuesTrain = [];
                    BMUsValuesTest = [];
                    Model.multiple.relevanceAttributesActives{layer+1}{i} = [];
                    Model.multiple.relevanceAttributesActivesMagnitude{layer+1}{i} = [];
                    index = 1;
                    for j = 1:dim(i)
                        if relevance{layer+1}{i}(1,j) == 1
                            BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                            BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                            Model.multiple.relevanceAttributesActives{layer+1}{i} = ...
                                [Model.multiple.relevanceAttributesActives{layer+1}{i} Model.multiple.relevanceAttributesActives{layer}{i}(j)];
                            Model.multiple.relevanceAttributesActivesMagnitude{layer+1}{i} = ...
                                [Model.multiple.relevanceAttributesActivesMagnitude{layer+1}{i} relevanceOriginal{1,layer+1}{i}(1,j)];
                            index = index + 1;
                        end;
                    end;
                    DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                    DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;
                    [~,dimFilter] = size(BMUsValuesTrain);
                    relevanceFilter{layer+1}{i}(1,:) = ones(1,dimFilter); 
                end;
                relevance{layer+1} = relevanceFilter{layer+1};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
% %                 for i = 1:Model.multiple.numToyProblem
% %                     relevance{1,layer+1}{i} = (relevance{1,layer+1}{i} ./ sum(relevance{1,layer+1}{i}'))';
% %                 end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i = 1:Model.multiple.numToyProblem
                    relevance{layer+1}{i} = relevancenNorm{layer+1}{i}'; 
                end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 for i = 1:Model.multiple.numToyProblem
% %                     weights = exp(-[1:1:dimFilter]/(dimFilter/4)); 
% %                     varVector = var(DeepSOM{i,layer}.BMUsValuesTrain);
% %                     [~,orderVector] = sort(varVector);
% %                     for j = 1:dimFilter                        
% %                         relevance{layer+1}{i}(1,orderVector(1,j)) = weights(1,j);
% %                     end;
% %                 end;   
% %                 relevance{layer+1} = relevance{layer+1}'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %relevance{layer+1} = relevance{layer+1}'; 

            elseif strcmp(Model.multiple.variancePipeline{layer},'all')    
                if strcmp(Model.multiple.relevanceSelect{layer},'train_pipeline')
                    data = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        selectedTest = find(test_labels == i);
                        data = [data; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)]; %[data; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)];                                
                    end;
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}(i,:) = var(data);
                    end;
                elseif strcmp(Model.multiple.relevanceSelect{layer},'winner')
                    data = []; 
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(  (Model.test.layer{1,layer+1}.indexesWinnersTrain{1,1}(1,:) == i) & (trainLabelsFilter == i)  );
                        data = [data DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];                 
                    end;              
                    for i = 1:Model.multiple.numToyProblem 
                        relevance{layer+1}(i,:) = var(data); 
                    end;
                end;
                for i = 1:Model.multiple.numToyProblem
                    if strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                        [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'descend');
                    else strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                        [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'ascend');
                    end;
                end;
                for i = 1:Model.multiple.numToyProblem
                    for j = 1:dim 
                        if j <= round( (1-Model.multiple.relevancePercent(1,layer+1))*dim )
                            relevanceBinary{layer+1}(i, indexes(i,j)) = 1;
                        else
                            relevanceBinary{layer+1}(i, indexes(i,j)) = 0;
                        end;
                    end;
                end;
                relevance = relevanceBinary;        
                %%%%%%
                for i = 1:Model.multiple.numToyProblem
                    for j = 1:Model.multiple.numToyProblem
                        relevancePipelineSimilarity{layer+1}(i,j) = sum(relevance{layer+1}(i,:) == relevance{layer+1}(j,:)) / dim;
                    end;            
                end;
                Model.test.relevancePipelineSimilarity = relevancePipelineSimilarity;
                for i = 1:Model.multiple.numToyProblem
                    BMUsValuesTrain = [];
                    BMUsValuesTest = [];
                    index = 1;
                    for j = 1:dim
                        if relevance{layer+1}(i,j) == 1
                            BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                            BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                            index = index + 1;
                        end;
                    end;
                    DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                    DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;
                    [~,dimFilter] = size(BMUsValuesTrain);
                    relevanceFilter{layer+1}(i,:) = ones(1,dimFilter); 
                end;
                relevance{layer+1} = relevanceFilter{layer+1};
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                relevance{layer+1} = relevance{layer+1}';
            elseif strcmp(Model.multiple.variancePipeline{layer},'all_centers')    
                if strcmp(Model.multiple.relevanceSelect{layer},'yes')
                    centers = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = find(train_labels == i);
                        selectedTest = find(test_labels == i);
                        centers = [centers; mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ) ]; %[centers; mean( [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)] ) ];                                
                    end;
                    for i = 1:Model.multiple.numToyProblem
                        relevance{layer+1}(i,:) = var(centers);
                    end;
                elseif strcmp(Model.multiple.relevanceSelect{layer},'no')
                    data = [];
                    centers = [];
                    for i = 1:Model.multiple.numToyProblem
                        selectedTrain = [];
                        selectedTest = [];
                        for j = 1:Model.multiple.numToyProblem
                            selectedTrain = [selectedTrain find(train_labels == j) ];
                            selectedTest = [selectedTest find(test_labels == j) ];                    
                        end;
                        centers = [centers; mean( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ) ]; %[centers; mean( [ DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:); DeepSOM{i,layer}.BMUsValuesTest(selectedTest,:)] ) ];                
                    end;              
                    for i = 1:Model.multiple.numToyProblem 
                        relevance{layer+1}(i,:) = var(centers); 
                    end;
                end;
                for i = 1:Model.multiple.numToyProblem
                    if strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                        [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'descend');
                    else strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                        [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'ascend');
                    end;
                end;
                for i = 1:Model.multiple.numToyProblem
                    for j = 1:dim 
                        if j <= round( (1-Model.multiple.relevancePercent(1,layer+1))*dim )
                            relevanceBinary{layer+1}(i, indexes(i,j)) = 1;
                        else
                            relevanceBinary{layer+1}(i, indexes(i,j)) = 0;
                        end;
                    end;
                end;
                relevance = relevanceBinary;        
                %%%%%%
                for i = 1:Model.multiple.numToyProblem
                    for j = 1:Model.multiple.numToyProblem
                        relevancePipelineSimilarity{layer+1}(i,j) = sum(relevance{layer+1}(i,:) == relevance{layer+1}(j,:)) / dim;
                    end            
                end;
                Model.test.relevancePipelineSimilarity = relevancePipelineSimilarity;
                for i = 1:Model.multiple.numToyProblem
                    BMUsValuesTrain = [];
                    BMUsValuesTest = [];
                    index = 1;
                    for j = 1:dim
                        if relevance{layer+1}(i,j) == 1
                            BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                            BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                            index = index + 1;
                        end;
                    end;
                    DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                    DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;
                    [~,dimFilter] = size(BMUsValuesTrain);
                    relevanceFilter{layer+1}(i,:) = ones(1,dimFilter); 
                end;
                relevance{layer+1} = relevanceFilter{layer+1};
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                relevance{layer+1} = relevance{layer+1}';                
            end;
        elseif strcmp(Model.multiple.inputPrototype{layer},'yes')
            if strcmp(Model.multiple.variancePipeline{layer},'lonely') 
                for i = 1:Model.multiple.numToyProblem
                    relevance{layer+1}(i,:) = var( DeepSOM{i,layer}.sMap.codebook);
                end;   
            elseif strcmp(Model.multiple.variancePipeline{layer},'all')
                data = [];
                for i = 1:Model.multiple.numToyProblem
                    data = [data; DeepSOM{i,layer}.sMap.codebook ];
                end;
                for i = 1:Model.multiple.numToyProblem
                    relevance{layer+1}(i,:) = var(data);
                end;
            end;
            for i = 1:Model.multiple.numToyProblem
                if strcmp(Model.multiple.relevanceOrder{layer}, 'high')
                    [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'descend');
                else strcmp(Model.multiple.relevanceOrder{layer}, 'low')
                    [relevanceSort{layer+1}(i,:), indexes(i,:)] = sort(relevance{layer+1}(i,:),'ascend');
                end;
            end;
            for i = 1:Model.multiple.numToyProblem
                for j = 1:dim 
                    if j <= round( (1-Model.multiple.relevancePercent(1,layer+1))*dim )
                        relevanceBinary{layer+1}(i, indexes(i,j)) = 1;
                    else
                        relevanceBinary{layer+1}(i, indexes(i,j)) = 0;
                    end;
                end;
            end;
            relevance = relevanceBinary;
            %%%%%%
            for i = 1:Model.multiple.numToyProblem
                for j = 1:Model.multiple.numToyProblem
                    relevancePipelineSimilarity{layer+1}(i,j) = sum(relevance{layer+1}(i,:) == relevance{layer+1}(j,:)) / dim;
                end;            
            end;
            Model.test.relevancePipelineSimilarity = relevancePipelineSimilarity;        
            for i = 1:Model.multiple.numToyProblem
                BMUsValuesTrain = [];
                BMUsValuesTest = [];
                Codebook = [];
                index = 1;
                for j = 1:dim
                    if relevance{layer+1}(i,j) == 1
                        BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                        BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                        Codebook = [Codebook DeepSOM{i,layer}.sMap.codebook(:,j) ];
                        index = index + 1;
                    end;
                end;
                DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;
                DeepSOM{i,layer}.sMap.codebook = Codebook;
                [~,dimFilter] = size(BMUsValuesTrain);
                relevanceFilter{layer+1}(i,:) = ones(1,dimFilter); 
            end;
            relevance{layer+1} = relevanceFilter{layer+1};
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            relevance{layer+1} = relevance{layer+1}'; 
       
        end;
        
    elseif strcmp(Model.multiple.distanceType{layer+1},'relevance_sub_variance') || strcmp(Model.multiple.distanceType{layer+1},'euclidian')
        relevance = []; % compatibility        

            
        if ~strcmp(Model.multiple.relevanceCut{layer+1},'no')
            if strcmp(Model.multiple.relevanceCut{layer+1},'inter') || strcmp(Model.multiple.relevanceCut{layer+1},'inter-intra')
                dataTrain = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    if layer == 0
                        dataTrain =  [dataTrain; SamplesTrain.data(selectedTrain,:)];
                    else
                        dataTrain =  [dataTrain; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];      
                    end;
                end;
            elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_means')
                dataTrain = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    dataTrain =  [dataTrain; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:))];                        
                end;
            elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_pipeline')               
                for i = 1:Model.multiple.numToyProblem
                     dataTrain{i} = [];
                    for j = 1:Model.multiple.numToyProblem
                        selectedTrain = find( (trainLabelsFilter == j)  );
                        dataTrain{i} =  [dataTrain{i}; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)]; 
                    end;
                end;                       
            elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_means_pipeline')               
                for i = 1:Model.multiple.numToyProblem
                     dataTrain{i} = [];
                    for j = 1:Model.multiple.numToyProblem
                        selectedTrain = find( (trainLabelsFilter == j)  );
                        dataTrain{i} =  [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:))]; 
                    end;
                end;
            elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_prototypes')
                dataTrain = [];
                for cat = 1:Model.multiple.numToyProblem
                    [samples,~] = size(DeepSOM{cat,layer}.BMUsValuesTrain);                      
                    for j = 1:samples
                        if layer == 0
                            x = sdataTrain.data(j,:);
                        else
                            x = DeepSOM{cat,layer}.BMUsValuesTrain(j,:);
                        end;
                        Dx = (DeepSOM{cat,layer}.sMap.codebook(:,:) - x);
                        [~,winnerNode{cat}(1,j)] =  min(sum( (DeepSOM{cat,layer}.relevance') .* (Dx'.^2) ) );
                    end;
                    temp = zeros(1,Model.multiple.numMap(layer) );
                    for j = 1:length(winnerNode{cat})
                        if train_labels(1,j) == cat
                            temp(1,winnerNode{cat}(j)) = temp(1,winnerNode{cat}(j)) + 1; 
                        end;  
                    end;
                    winnerNodeFrequency{cat} = temp;
                    dataTrain = [dataTrain; DeepSOM{cat,layer}.sMap.codebook(winnerNodeFrequency{cat} > 1,:) ];
                end;                                    
           elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_pipeline_binary') || strcmp(Model.multiple.relevanceCut{layer+1},'inter_means_pipeline_binary')               
                dataTrain = [];
                dataTrainCat = [];
                for i = 1:Model.multiple.numToyProblem
                    dataTrain{i} = [];                    
                    for j = 1:Model.multiple.numToyProblem
                        if i ~= j
                            selectedTrain = find( train_labels == j );
                            if strcmp(Model.multiple.relevanceCut{layer+1},'inter_pipeline_binary')
                                dataTrain{i} = [dataTrain{i}; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ];     
                            elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_means_pipeline_binary')
                                dataTrain{i} = [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];  
                            end;
                        else
                            selectedTrain = find( train_labels == j );
                            dataTrainCat{i} = DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:);
                        end;
                    end;                   
                end;                
            elseif  strcmp(Model.multiple.relevanceCut{layer+1},'intra')
                dataTrain = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    if layer == 0 
                        dataTrain{i} =  [SamplesTrain.data(selectedTrain,:)];
                    else
                        dataTrain{i} =  [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];                        
                    end;
                end;   
            elseif  strcmp(Model.multiple.relevanceCut{layer+1},'intra_relevance_1')
                dataTrain = [];
                union = zeros(1,dim(1));
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    dataTrain{i} = [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];
                end;  
            elseif  strcmp(Model.multiple.relevanceCut{layer+1},'mult')
                dataTrainInter = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    dataTrainInter =  [dataTrainInter; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];                        
                end;            
                dataTrain = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain =  (trainLabelsFilter == i)  ;
                    dataTrain{i} =  [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];        
                end; 
            end;
            % select delete
            for i = 1:Model.multiple.numToyProblem
                

                if  strcmp(Model.multiple.relevanceCut{layer+1},'inter')  || strcmp(Model.multiple.relevanceCut{layer+1},'inter-intra') ||  strcmp(Model.multiple.relevanceCut{layer+1},'inter_means')
                    DeepSOM{i,layer+1}.relevance = var( dataTrain );
                elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_means_pipeline') || strcmp(Model.multiple.relevanceCut{layer+1},'inter_pipeline')
                    DeepSOM{i,layer+1}.relevance = var( dataTrain{i} );
                elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_prototypes')  
                    DeepSOM{i,layer+1}.relevance = var( dataTrain );                    
                elseif strcmp(Model.multiple.relevanceCut{layer+1},'inter_pipeline_binary') || strcmp(Model.multiple.relevanceCut{layer+1},'inter_means_pipeline_binary')  
                     DeepSOM{i,layer+1}.relevance = varBinary(dataTrain{i}, mean(dataTrainCat{i}));
                elseif strcmp(Model.multiple.relevanceCut{layer+1},'intra')
                    DeepSOM{i,layer+1}.relevance = 1 - var( dataTrain{i} );
                elseif  strcmp(Model.multiple.relevanceCut{layer+1},'intra_relevance_1')
                    DeepSOM{i,layer+1}.relevance = 1 - var( dataTrain{i} );
                    union(i,:) = (DeepSOM{i,layer+1}.relevance == 1);
                elseif strcmp(Model.multiple.relevanceCut{layer+1},'mult')
                    inter = var( dataTrainInter );
                    intra = 1 - var( dataTrain{i} );
                    interMin = min(inter);
                    interMax = max(inter);
                    interNorm = (inter - interMin)/(interMax - interMin);
                    intraMin = min(intra);
                    intraMax = max(intra);
                    intraNorm = (intra - intraMin)/(intraMax - intraMin);  
                    DeepSOM{i,layer+1}.relevance = interNorm .* intraNorm;
                end;
                relevanceMean = mean(DeepSOM{i,layer+1}.relevance);
                relevanceStd = std(DeepSOM{i,layer+1}.relevance);
                relevanceThreshold = relevanceMean + Model.multiple.relevanceFatorStd * relevanceStd;
                DeepSOM{i,layer+1}.relevanceAtive(1,find(DeepSOM{i,layer+1}.relevance < relevanceThreshold)) = 0;
                DeepSOM{i,layer+1}.relevanceAtive(1,find(DeepSOM{i,layer+1}.relevance >= relevanceThreshold)) = 1;                
                ativeSum(1,i) = sum(DeepSOM{i,layer+1}.relevanceAtive);
                if ativeSum(1,i) == 0 
                    ativeSum(1,i) = 1;
                end;
            end;

            threshold = max(ativeSum);
            Model.multiple.setRelevance = Model.multiple.setRelevance(Model.multiple.setRelevance <= threshold);
            for i = 1:Model.multiple.numToyProblem
                [~,relevanceSortIndexes] = sort(DeepSOM{i,layer+1}.relevance,'descend');
                for j = 1:length(relevanceSortIndexes)
                    if j <= threshold
                        DeepSOM{i,layer+1}.relevanceAtive(1,relevanceSortIndexes(1,j)) = 1;
                    else
                        DeepSOM{i,layer+1}.relevanceAtive(1,relevanceSortIndexes(1,j)) = 0;
                    end;
                end;
            end;
            
            if   strcmp(Model.multiple.relevanceCut{layer+1},'intra_relevance_1')
                for i = 1:Model.multiple.numToyProblem
                     DeepSOM{i,layer+1}.relevanceAtive = (sum(union) > 0);
                end;
            end;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % delete
            for i = 1:Model.multiple.numToyProblem                    
                BMUsValuesTrain = [];
                BMUsValuesTest = [];
                relevancies = [];
                index = 1;
                len = length(DeepSOM{i,layer+1}.relevanceAtive);
                for j = 1:len % same length
                    if DeepSOM{i,layer+1}.relevanceAtive(1,j) == 1
                        if layer == 0 
                            if i == 1
                                BMUsValuesTrain = [BMUsValuesTrain SamplesTrain.data(:,j) ];
                                BMUsValuesTest = [BMUsValuesTest SamplesTest.data(:,j) ];
                                relevancies = [relevancies DeepSOM{i,layer+1}.relevance(:,j) ]; 
                            end;
                        else
                            BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                            BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                            relevancies = [relevancies DeepSOM{i,layer+1}.relevance(:,j) ];
                        end;
                        index = index + 1;
                        
                    end;
                end;
                if layer == 0 
                    if i == 1
                        SamplesTrain.data = BMUsValuesTrain;
                        SamplesTest.data = BMUsValuesTest;
                    end;
                else
                    DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                    DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;                    
                end;
                DeepSOM{i,layer+1}.relevance = relevancies;
                dim(i) = sum(DeepSOM{i,layer+1}.relevanceAtive);         
                Model.multiple.attributes(i) = dim(i);
            end;


            if  strcmp(Model.multiple.relevanceCut{layer+1},'inter-intra')
                dataTrain = [];
                for i = 1:Model.multiple.numToyProblem
                    selectedTrain = find( (trainLabelsFilter == i)  );
                    dataTrain{i} =  [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];        
                end;


                for i = 1:Model.multiple.numToyProblem
                    DeepSOM{i,layer+1}.relevanceAtive = [];
                    DeepSOM{i,layer+1}.relevance = 1 - var( dataTrain{i} );
                    relevanceMean = mean(DeepSOM{i,layer+1}.relevance);
                    relevanceStd = std(DeepSOM{i,layer+1}.relevance);            
                    relevanceThreshold = relevanceMean - Model.multiple.relevanceFatorStd2 * relevanceStd;
                    DeepSOM{i,layer+1}.relevanceAtive(1,find(DeepSOM{i,layer+1}.relevance < relevanceThreshold)) = 0;
                    DeepSOM{i,layer+1}.relevanceAtive(1,find(DeepSOM{i,layer+1}.relevance >= relevanceThreshold)) = 1;
                    ativeSum(1,i) = sum(DeepSOM{i,layer+1}.relevanceAtive);
                end;

                threshold = max(ativeSum);
                for i = 1:Model.multiple.numToyProblem
                    [~,relevanceSortIndexes] = sort(DeepSOM{i,layer+1}.relevance,'descend');
                    for j = 1:length(relevanceSortIndexes)
                        if j <= threshold
                            DeepSOM{i,layer+1}.relevanceAtive(1,relevanceSortIndexes(1,j)) = 1;
                        else
                            DeepSOM{i,layer+1}.relevanceAtive(1,relevanceSortIndexes(1,j)) = 0;
                        end;
                    end;
                end;

                % delete
                for i = 1:Model.multiple.numToyProblem                    
                    BMUsValuesTrain = [];
                    BMUsValuesTest = [];
                    relevancies = [];
                    index = 1;
                    for j = 1:dim(i)
                        if DeepSOM{i,layer+1}.relevanceAtive(1,j) == 1
                            BMUsValuesTrain = [BMUsValuesTrain DeepSOM{i,layer}.BMUsValuesTrain(:,j) ];
                            BMUsValuesTest = [BMUsValuesTest DeepSOM{i,layer}.BMUsValuesTest(:,j) ];
                            relevancies = [relevancies DeepSOM{i,layer+1}.relevance(:,j) ];
                            index = index + 1;
                        end;
                    end;
                    DeepSOM{i,layer}.BMUsValuesTrain = BMUsValuesTrain;
                    DeepSOM{i,layer}.BMUsValuesTest = BMUsValuesTest;
                    DeepSOM{i,layer+1}.relevance = relevancies;
                end;

            end;
            

            
        end;
        
        
        % relevance initial
        if strcmp(Model.multiple.relevanceInicialize{layer+1}, 'no')
            for i = 1:Model.multiple.numToyProblem
                if layer ~= 0
                    [~,dim] = size(DeepSOM{i,layer}.BMUsValuesTrain); 
                else
                    [~,dim] = size(SamplesTrain.data); 
                end;
                DeepSOM{i,layer+1}.relevanceAtive = ones(1,dim); 
                if strcmp(Model.multiple.relevanceNorm{layer+1},'sum')  || strcmp(Model.multiple.relevanceNorm{layer+1},'max_sum')
                    DeepSOM{i,layer+1}.relevance = ones(Model.multiple.numMap(layer+1),dim); %ones(Model.multiple.numMap(layer+1),dim)/dim; 
                else
                    DeepSOM{i,layer+1}.relevance = ones(Model.multiple.numMap(layer+1),dim);
                end;
            end;
        elseif strcmp(Model.multiple.relevanceInicialize{layer+1}, 'yes')
            dataTrain = [];
    
            for i = 1:Model.multiple.numToyProblem
                if layer ~= 0
                    [~,dim] = size(DeepSOM{i,layer}.BMUsValuesTrain); 
                else
                    [~,dim] = size(SamplesTrain.data); 
                end;    
                DeepSOM{i,layer+1}.relevanceAtive = ones(1,dim);                         
                selectedTrain = find( (trainLabelsFilter == i)  );
                if strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline') || strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline')  
                    if strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline')
                        dataTrain{i} = [];
                        for j = 1:Model.multiple.numToyProblem
                            selectedTrain = find( (trainLabelsFilter == j)  );
                            dataTrain{i} =  [dataTrain{i}; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)]; 
                        end;
                    elseif  strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline')
                        dataTrain{i} = [];
                            for j = 1:Model.multiple.numToyProblem
                                selectedTrain = find( (trainLabelsFilter == j)  );
                                dataTrain{i} =  [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:))]; 
                            end;
                        end;
                elseif strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline_binary') || strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline_binary')               
                    dataTrain = [];
                    dataTrainCat = [];
                    for i = 1:Model.multiple.numToyProblem
                        dataTrain{i} = [];                    
                        for j = 1:Model.multiple.numToyProblem
                            if i ~= j
                                selectedTrain = find( train_labels == j );
                                if strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline_binary')
                                    dataTrain{i} = [dataTrain{i}; DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:) ];     
                                elseif strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline_binary')
                                    dataTrain{i} = [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];  
                                end;
                            else
                                selectedTrain = find( train_labels == j );
                                dataTrainCat{i} = DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:);
                            end;
                        end;                   
                    end;  
                end;   
            end;
            for i = 1:Model.multiple.numToyProblem
                selectedTrain = find( (trainLabelsFilter == i)  );
                selectedTest = find( (testLabelsFilter == i)  );
                if strcmp(Model.multiple.relevanceSortType{1,layer+1},'no') 
                    if layer == 0
                        DeepSOM{i,layer+1}.relevance = 1 - var( SamplesTrain.data(selectedTrain,:) );
                    else
                        DeepSOM{i,layer+1}.relevance = 1 - var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));
                    end;
                      
                    if strcmp(Model.multiple.transformFunction{1,layer+1},'sigmoid')
                        DeepSOM{i,layer+1}.relevance = sigmoid(DeepSOM{i,layer+1}.relevance, 0.5, Model.multiple.transformFunctionParam); 
                    elseif strcmp(Model.multiple.transformFunction{1,layer+1},'sigmoid_adaptative')
                        DeepSOM{i,layer+1}.relevance = sigmoid(DeepSOM{i,layer+1}.relevance, mean(DeepSOM{i,layer+1}.relevance), Model.multiple.transformFunctionParam); 
                    elseif strcmp(Model.multiple.transformFunction{1,layer+1},'exp')
                        DeepSOM{i,layer+1}.relevance = exp(Model.multiple.transformFunctionParam *(DeepSOM{i,layer+1}.relevance - 1) );                         
                    end;
                    
                elseif strcmp(Model.multiple.relevanceSortType{1,layer+1},'mult')
                    if strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline') || strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline')  
                        inter = var(dataTrain{i});
                    elseif strcmp(Model.multiple.relevanceSelect{layer+1},'inter_pipeline_binary') || strcmp(Model.multiple.relevanceSelect{layer+1},'inter_means_pipeline_binary')               
                        inter = varBinary(dataTrain{i}, mean(dataTrainCat{i}));
                    end;
                    intra = 1 - var( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:));
                    subInterMin = min(inter);
                    subInterMax = max(inter);
                    inter = (inter-subInterMin+epsilon)/(subInterMax-subInterMin+epsilon);    
                    intraMin = min(intra);
                    intraMax = max(intra);
                    intra = (intra-intraMin+epsilon)/(intraMax-intraMin+epsilon);
                    DeepSOM{i,layer+1}.relevance = inter .* intra;
                end;

                if strcmp(Model.multiple.relevanceNorm{1,layer+1},'max') || strcmp(Model.multiple.relevanceNorm{1,layer+1},'max_sum')
                    relevanceMin = nanmin(DeepSOM{i,layer+1}.relevance);
                    relevanceMax = nanmax(DeepSOM{i,layer+1}.relevance);
                    DeepSOM{i,layer+1}.relevance = ((DeepSOM{i,layer+1}.relevance-relevanceMin+epsilon)./(relevanceMax-relevanceMin+epsilon));
                end;
                if  strcmp(Model.multiple.relevanceNorm{1,layer+1},'max_sum') % || strcmp(Model.multiple.relevanceNorm{1,layer+1},'sum')
                    relevanceSum = nansum(DeepSOM{i,layer+1}.relevance);
                    DeepSOM{i,layer+1}.relevance = DeepSOM{i,layer+1}.relevance/relevanceSum;                    
                end;
                DeepSOM{i,layer+1}.relevance = repmat(DeepSOM{i,layer+1}.relevance,Model.multiple.numMap(layer+1),1) ;
            end;            
        end;

        if strcmp(Model.multiple.transformFunction{1,layer+1},'linear') || strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_global') || ...
           strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_pipeline') || strcmp(Model.multiple.transformFunction{1,layer+1},'linear_pipeline') 
            minRelevances = [];
            maxRelevances = [];
            relevanceGlobal = [];
            if strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_pipeline')  || strcmp(Model.multiple.transformFunction{1,layer+1},'linear_pipeline')
                for i = 1:Model.multiple.numToyProblem
                    minRelevanceGlobal(i,:) = min(DeepSOM{i,layer+1}.relevance);
                    meanRelevanceGlobal(i,:) = mean(DeepSOM{i,layer+1}.relevance);
                    stdRelevanceGlobal(i,:) = std(DeepSOM{i,layer+1}.relevance);
                    maxRelevanceGlobal(i,:) = max(DeepSOM{i,layer+1}.relevance);                          
                end;
              
            else
                relevanceGlobal = [];
                for i = 1:Model.multiple.numToyProblem
                    relevanceGlobal = [relevanceGlobal; DeepSOM{i,layer+1}.relevance];
                end;
                minRelevanceGlobal = min(relevanceGlobal);
                meanRelevanceGlobal = mean(relevanceGlobal);
                stdRelevanceGlobal = std(relevanceGlobal);
                maxRelevanceGlobal = max(relevanceGlobal);
            end;
            if strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_global') || ...
               strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_pipeline')
                minRelevanceGlobal = meanRelevanceGlobal + Model.multiple.transformFunctionCutStd * stdRelevanceGlobal;
            end;
            [nodes,~] = size(DeepSOM{i,layer+1}.relevance);
            if strcmp(Model.multiple.transformFunction{1,layer+1},'linear') || ...
               strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_global')
                for i = 1:Model.multiple.numToyProblem
                    DeepSOM{i,layer+1}.relevance = (DeepSOM{i,layer+1}.relevance - minRelevanceGlobal) ./ repmat((maxRelevanceGlobal - minRelevanceGlobal),nodes,1);
                    DeepSOM{i,layer+1}.relevance(DeepSOM{i,layer+1}.relevance < 0) = 0;
                    DeepSOM{i,layer+1}.relevance(isnan(DeepSOM{i,layer+1}.relevance)) = 1;
                end;
            elseif strcmp(Model.multiple.transformFunction{1,layer+1},'linear_cut_std_pipeline')
% %                 for i = 1:Model.multiple.numToyProblem
% %                     DeepSOM{i,layer+1}.relevance = (DeepSOM{i,layer+1}.relevance - repmat(minRelevanceGlobal(i,:),8,1)) ./ ...
% %                          repmat((maxRelevanceGlobal(i,:) - minRelevanceGlobal(i,:)),8,1);
% %                     DeepSOM{i,layer+1}.relevance(DeepSOM{i,layer+1}.relevance < 0) = 0;
% %                     DeepSOM{i,layer+1}.relevance(isnan(DeepSOM{i,layer+1}.relevance)) = 1;
% %                 end;                
            end;
            
            if  strcmp(Model.multiple.relevanceNorm{1,layer+1},'sum')
                for i = 1:Model.multiple.numToyProblem
                    relevanceSum = nansum(DeepSOM{i,layer+1}.relevance');
                    DeepSOM{i,layer+1}.relevance = DeepSOM{i,layer+1}.relevance ./ repmat(relevanceSum',1,dim) ;     
                end;
            end;            
            
        end;
      
        
    else
        
        for i = 1:Model.multiple.numToyProblem
            selected = find(labels == i);
            prototypeMean(i,:) = mean(DeepSOM{i,layer}.BMUsValuesTrain(selected,:));
        end;

        for i = 1:Model.multiple.numToyProblem
            count = 1;
            for j = 1:Model.multiple.numToyProblem
                if i ~= j
                    pipelinesDistance(i,count) = sqrt(sum((prototypeMean(i,:) - prototypeMean(j,:)).^2));
                    count = count + 1;
                end;
            end;
        end;

        for i = 1:Model.multiple.numToyProblem 
            pipelinesDistance(i,:) = pipelinesDistance(i,:)./max(pipelinesDistance(i,:));        
        end;

        pipelinesDistance = 1./pipelinesDistance;

        if strcmp(Model.multiple.relevanceType{layer},'ones')
            pipelinesDistance = ones(Model.multiple.numToyProblem,Model.multiple.numToyProblem-1);
        end;

        for i = 1:Model.multiple.numToyProblem
            count = 0;
            for j = 1:Model.multiple.numToyProblem            
                if i~= j
                    count = count + 1;
                    prototypeMatrix{i}(:,count) = abs(prototypeMean(i,:)' - prototypeMean(j,:)');
                end;
            end;
            if strcmp(Model.multiple.relevanceMatrixType{layer},'inv')
                 prototypeMatrix{i} = 1./prototypeMatrix{i};
            end;        
        end;

        if strcmp(Model.multiple.normalizeRelevance{layer},'no')
            for i = 1:Model.multiple.numToyProblem
                relevance{layer+1}(:,i) = prototypeMatrix{i}*(pipelinesDistance(i,:)');            
            end;        
        elseif strcmp(Model.multiple.normalizeRelevance{layer},'max_pipeline') || strcmp(Model.multiple.normalizeRelevance{layer},'sum_pipeline')
            for i = 1:Model.multiple.numToyProblem
                relevance{layer+1}(:,i) = prototypeMatrix{i}*(pipelinesDistance(i,:)');
                maxPipeline(i) = max(relevance{layer+1}(:,i));
                sumPipeline(i) = sum(relevance{layer+1}(:,i));
                if strcmp(Model.multiple.normalizeRelevance{layer},'max_pipeline')
                    relevance{layer+1}(:,i) = (relevance{layer+1}(:,i))./ maxPipeline(i);
                elseif strcmp(Model.multiple.normalizeRelevance{layer},'sum_pipeline')
                    relevance{layer+1}(:,i) = (relevance{layer+1}(:,i))./ sumPipeline(i);
                end;
            end;
        elseif strcmp(Model.multiple.normalizeRelevance{layer},'max_attributes') || strcmp(Model.multiple.normalizeRelevance{layer},'sum_attributes')
            for i = 1:Model.multiple.numToyProblem
                relevance{layer+1}(:,i) = prototypeMatrix{i}*(pipelinesDistance(i,:)');            
            end;  
            for i = 1:dim
                maxPipeline(i) = max(relevance{layer+1}(i,:));
                sumPipeline(i) = sum(relevance{layer+1}(i,:));
                if strcmp(Model.multiple.normalizeRelevance{layer},'max_attributes')
                    relevance{layer+1}(i,:) = (relevance{layer+1}(i,:))./ maxPipeline(i);
                elseif strcmp(Model.multiple.normalizeRelevance{layer},'sum_attributes')
                    relevance{layer+1}(i,:) = (relevance{layer+1}(i,:))./ sumPipeline(i);
                end;
            end;    
        end;

        if strcmp(Model.multiple.relevanceFunction{layer},'quantization')
            relevance{layer+1} = roundn(relevance{layer+1}, -1);
        elseif strcmp(Model.multiple.relevanceFunction{layer},'sigm')
            x = relevance{layer+1};
            relevance{layer+1} = sigmf(10*x,[2 5]);
        end;
    end

   
end