clear all;

dataset = 'atributos';
datasetSize = 15; % 3,15

if strcmp(dataset,'comNorm')
    load('dataInicial.mat');
    load('relevance_debug.mat')
    dimY = 0.15;
elseif strcmp(dataset,'semNorm')
    load('dataInicialSemNorm.mat');
    dimY = 0.0005;
elseif strcmp(dataset,'global')
    load('dataInicialGlobal.mat');
    dimY = 0.15;    
elseif strcmp(dataset,'amostras')
    load('dataInicialAmostras.mat');
    dimY = 0.15;
elseif strcmp(dataset,'atributosIndependente')
    load('dataInicialAtributosIndependente.mat');
    dimY = 0.15;
elseif strcmp(dataset,'atributosTrain')
    load('dataInicialAtributosTrain.mat');
    dimY = 0.15; 
elseif strcmp(dataset,'atributos')
    if datasetSize == 3
        load('dataInicialAtributos.mat');
        load('relevance_debug_attributes_new.mat');  
        load('DeepSOM.mat')
        threshold = 0.4;
    elseif datasetSize == 15
        load('dataInicialAtributos_15.mat');
        load('relevance_debug_15.mat'); 
        threshold = 0.3;
    end;
    dimY = 0.15;     
end;




dimX = 4200;


testErrorIndexes = Model.test.layer{1,2}.macthesDensityTest{1,1}(1,:) == 0;

winnerTrainIndexes =  Model.test.layer{1,2}.macthesDensityTrain{1,1}(1,:) == 1;
winnerTestIndexes =  Model.test.layer{1,2}.macthesDensityTest{1,1}(1,:) == 1;



%%%%%%%%%%%%%%%%%%%%%%% relevance best %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

layer = 1;  

for i = 1:Model.multiple.numToyProblem
    [relevanceTrainTestSort{layer+1}(i,:), indexesTrainTest(i,:)] = sort(relevanceTrainTest{layer+1}(i,:),'ascend');
    [relevanceWinnerSort{layer+1}(i,:), indexesWinner(i,:)] = sort(relevanceTrain{layer+1}(i,:),'ascend');
end;

for i = 1:Model.multiple.numToyProblem
    for j = 1:4200 
        if j <= round( threshold*4200 )
            relevanceTrainTestBinary{layer+1}(i, indexesTrainTest(i,j)) = 1;
            relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 1;
        else
            relevanceTrainTestBinary{layer+1}(i, indexesTrainTest(i,j)) = 0;
            relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 0;
        end;
    end;
end;

for i = 1:Model.multiple.numToyProblem
    relevanceBestTrainTest{layer+1}(i,:) = (relevanceTrainTestBinary{layer+1}(i,:) ~=  relevanceWinnerBinary{layer+1}(i,:)) & relevanceTrainTestBinary{layer+1}(i,:) == 1;
    relevanceBestWinner{layer+1}(i,:) = (relevanceTrainTestBinary{layer+1}(i,:) ~=  relevanceWinnerBinary{layer+1}(i,:)) & relevanceWinnerBinary{layer+1}(i,:) == 1;    
end;

for i = 1:Model.multiple.numToyProblem
    best(i) =  [sum(relevanceBestTrainTest{layer+1}(i,:))/4200]
end;

for i = 1:Model.multiple.numToyProblem
    [sum(relevanceBestTrainTest{layer+1}(i,1:3200))/3200 sum(relevanceBestTrainTest{layer+1}(i,3201:4000))/800 sum(relevanceBestTrainTest{layer+1}(i,4001:4200))/200]
end;



%%%%%%%%%%%%%%%%%%%%%%%%%  medias 42000 %%%%%%%%%%%%%%%%%%%


type = {'variance','covar','var_var','var_global','covar_global','frequency'}; %{'variance','mean','product_mean','cof_var_mean','product_cof_var_mean','var_mean','product_var_mean','covar','product_covar','cof_covar','product_cof_covar'};
label = {'Variância','Covariância','Variância das Variâncias entre Pipelines','Variância Global','Covariância Global','Frequência'};

for j = 1:length(type)
    for i = 1:Model.multiple.numToyProblem
        if strcmp(type{j},'covar') || strcmp(type{j},'variance') || strcmp(type{j},'var_mag') || strcmp(type{j},'var_var') || strcmp(type{j},'var_global') || strcmp(type{j},'covar_global') || ...
                strcmp(type{j},'frequency')
            if strcmp(type{j},'variance')
                dataTrainTest = relevanceTrainTest{layer+1}(i,:);
                dataTrain = relevanceTrain{layer+1}(i,:);
            elseif strcmp(type{j},'var_mag')
                means = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                dataTrainTest = mean(abs( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] - repmat(means,210,1)));                 
                means = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:)] );
                dataTrain = mean(abs([DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:)] - repmat(means,100,1)  ));
            elseif strcmp(type{j},'var_var')
                dataTrainTest = var(relevanceTrainTest{layer+1});              
                dataTrain = var(relevanceTrain{layer+1}); 
            elseif strcmp(type{j},'var_global')
                dataPipelineTrainTest = [];
                dataPipelineTrain = [];
                for k = 1:Model.multiple.numToyProblem
                    dataPipelineTrainTest = [dataPipelineTrainTest; DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{k,1}.BMUsValuesTest(Model.test_labels == k,:)] ;
                    dataPipelineTrain = [dataPipelineTrain; DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ];
                end;                
                dataTrainTest = var(dataPipelineTrainTest);              
                dataTrain = var(dataPipelineTrain);
            elseif strcmp(type{j},'covar_global')
                dataPipelineTrainTest = [];
                dataPipelineTrain = [];
                for k = 1:Model.multiple.numToyProblem
                    dataPipelineTrainTest = [dataPipelineTrainTest; DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{k,1}.BMUsValuesTest(Model.test_labels == k,:)] ;
                    dataPipelineTrain = [dataPipelineTrain; DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ];
                end;                
                dataTrainTest = sum(abs(cov(dataPipelineTrainTest)));              
                dataTrain = sum(abs(cov(dataPipelineTrain)));                
            elseif strcmp(type{j},'frequency')
                dataPipelineTrainTest = [];
                dataPipelineTrain = [];
                for k = 1:Model.multiple.numToyProblem
                    dataPipelineTrainTest = [dataPipelineTrainTest; SamplesTrain.data(Model.train_labels == k,:); SamplesTest.data(Model.test_labels == k,:)] ;
                    dataPipelineTrain = [dataPipelineTrain; SamplesTrain.data(Model.train_labels == k,:) ];
                end;
                dataPipelineTrainTest = (dataPipelineTrainTest > 0);
                dataPipelineTrain = (dataPipelineTrain > 0);
                [dataPipelineTrainTestRow,dataPipelineTrainTestCol] = size(dataPipelineTrainTest);
                [dataPipelineTrainRow,dataPipelineTrainCol] = size(dataPipelineTrain);
                dataTrainTest = sum(dataPipelineTrainTest)/dataPipelineTrainTestRow;             
                dataTrain = sum(dataPipelineTrain)/dataPipelineTrainRow;              
            elseif strcmp(type{j},'covar')
                dataTrainTest = sum( abs( cov( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] ) ) );
                dataTrain = sum( abs( cov( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) ) ) );    
            end;
            
            if strcmp(type{j},'variance')|| strcmp(type{j},'var_mag') || strcmp(type{j},'var_global') || strcmp(type{j},'covar') || strcmp(type{j},'covar_global') || strcmp(type{j},'frequency')
                [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest);
                [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain);  
            elseif strcmp(type{j},'var_var')
                [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest,'descend');
                [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain,'descend');                  
            end;
            
            [~,dataTrainTestSortVarIndexes] = sort(relevanceTrainTest{layer+1}(i,:));
            [~,dataTrainSortVarIndexes] = sort(relevanceTrain{layer+1}(i,:));
            
            for k = 1:4200
                dataTrainTestSortVar(1,k) = dataTrainTest(1,dataTrainTestSortVarIndexes(1,k));
                dataTrainSortVar(1,k) = dataTrain(1,dataTrainSortVarIndexes(1,k)); 
            end;
                        
            for k =1:4200
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1                  
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;                    
                end;
                
                
                if  relevanceTrainTestBinary{layer+1}(i,k) == 1 &  relevanceBestTrainTest{layer+1}(i,k) == 0  
                    goodTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    goodTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if  relevanceWinnerBinary{layer+1}(i,k) == 1 &  relevanceBestWinner{layer+1}(i,k) == 0   
                    goodTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    goodTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;
                end;
                
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSortVar(1, find(dataTrainTestSortVarIndexes == k) ) = 1;
                else
                    bestTrainTestSortVar(1, find(dataTrainTestSortVarIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainSortVar(1, find(dataTrainSortVarIndexes == k) ) = 1;
                else
                    bestTrainSortVar(1, find(dataTrainSortVarIndexes == k) ) = 0;                    
                end;
                
                if  relevanceTrainTestBinary{layer+1}(i,k) == 1 &  relevanceBestTrainTest{layer+1}(i,k) == 0  
                    goodTrainTestSortVar(1, find(dataTrainTestSortVarIndexes == k) ) = 1;
                else
                    goodTrainTestSortVar(1, find(dataTrainTestSortVarIndexes == k) ) = 0;
                end;
                if  relevanceWinnerBinary{layer+1}(i,k) == 1 &  relevanceBestWinner{layer+1}(i,k) == 0   
                    goodTrainSortVar(1, find(dataTrainSortVarIndexes == k) ) = 1;
                else
                    goodTrainSortVar(1, find(dataTrainSortVarIndexes == k) ) = 0;
                end;
                
            end;            
            
            maxValue = max(max([dataTrainTest; dataTrain]));
            minValue = min(min([dataTrainTest; dataTrain]));
            
        elseif strcmp(type{j},'mean') || strcmp(type{j},'product_mean')
            if strcmp(type{j},'mean')
                dataTrainTest = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                dataTrain = mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) );
            elseif strcmp(type{j},'product_mean')
                dataTrainTest = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] ).*relevanceTrainTest{layer+1}(i,:);
                dataTrain = mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) ).*relevanceTrain{layer+1}(i,:);                
            end;
            [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest, 'descend');
            [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain, 'descend');  
                        
            for k =1:4200
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;                    
                end;
            end;            
            
            for k = 1:Model.multiple.numToyProblem
                maxValues(k,:) =  mean( [dataTrainTest; dataTrain] );
            end;
            maxValue = max(max(maxValues));
            minValue = 0;
        elseif strcmp(type{j},'var_mean') || strcmp(type{j},'product_var_mean')
            if strcmp(type{j},'var_mean')
                for k = 1:Model.multiple.numToyProblem
                    meansTrainTest(k,:) = mean( [DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{k,1}.BMUsValuesTest(Model.test_labels == k,:)] );
                    meansTrain(k,:) = mean( DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) );
                end;
            elseif strcmp(type{j},'product_var_mean') 
                for k = 1:Model.multiple.numToyProblem
                    meansTrainTest(k,:) = mean( [DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{k,1}.BMUsValuesTest(Model.test_labels == k,:)] ) .* relevanceTrainTest{layer+1}(i,:);
                    meansTrain(k,:) = mean( DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ) .* relevanceTrain{layer+1}(i,:);
                end;                
            end;
            dataTrainTest = var(meansTrainTest);
            dataTrain = var(meansTrain);
            [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest, 'descend');
            [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain, 'descend');  
                        
            for k =1:4200
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;                    
                end;
            end;            
                        
            maxValue = max(max([dataTrainTest;dataTrain])); 
            minValue = 0;
                        
        elseif strcmp(type{j},'cof_var_mean') || strcmp(type{j},'product_cof_var_mean')
            if strcmp(type{j},'cof_var_mean')
                dataTrainTest = relevanceTrainTest{layer+1}(i,:)./mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                dataTrain = relevanceTrain{layer+1}(i,:)./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) );
            elseif strcmp(type{j},'product_cof_var_mean')
                dataTrainTest = (relevanceTrainTest{layer+1}(i,:).*relevanceTrainTest{layer+1}(i,:)) ./ mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                dataTrain = (relevanceTrain{layer+1}(i,:).*relevanceTrain{layer+1}(i,:))./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) )   ;                
            end;
            [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest, 'descend');
            [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain, 'descend');  
                        
            for k =1:4200
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;                    
                end;
            end;            
            
            for k = 1:Model.multiple.numToyProblem
                if strcmp(type{j},'cof_var_mean')
                    maxValues(k,:) =  max([relevanceTrainTest{layer+1}(i,:)./mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] ); ...
                        relevanceTrain{layer+1}(i,:)./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) ) ]);
                elseif strcmp(type{j},'product_cof_var_mean') 
                    maxValues(k,:) =  max([ (relevanceTrainTest{layer+1}(i,:).*relevanceTrainTest{layer+1}(i,:)) ./ mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] ) ...
                    (relevanceTrain{layer+1}(i,:).*relevanceTrain{layer+1}(i,:))./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) ) ]);
                end;
            end;
            maxValue = max(max(maxValues));
            minValue = 0;
        
        elseif strcmp(type{j},'product_covar') || strcmp(type{j},'cof_covar') || strcmp(type{j},'product_cof_covar')
            for k = 1:Model.multiple.numToyProblem
                if strcmp(type{j},'product_covar')
                    meansTrainTest(k,:) = sum( cov( [DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == k,:)] ) ).*relevanceTrainTest{layer+1}(k,:);
                    meansTrain(k,:) = sum( cov( DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ) ).*relevanceTrain{layer+1}(k,:);
                elseif strcmp(type{j},'cof_covar')
                    meansTrainTest(k,:) = sum( cov( [DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{k,1}.BMUsValuesTest(Model.test_labels == k,:)] ) ) ...
                        ./mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                    meansTrain(k,:) = sum( cov( DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ) ) ...
                        ./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) );
                elseif strcmp(type{j},'product_cof_covar')
                    meansTrainTest(k,:) = sum( cov( [DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == k,:)] ) ).*relevanceTrainTest{layer+1}(k,:)  ...
                        ./mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
                    meansTrain(k,:) = sum( cov( DeepSOM{k,1}.BMUsValuesTrain(Model.train_labels == k,:) ) ).*relevanceTrain{layer+1}(k,:)  ...
                        ./mean( DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) );                   
                end;
            end;
            dataTrainTest = meansTrainTest(i,:);
            dataTrain = meansTrain(i,:);
            [dataTrainTestSort, dataTrainTestSortIndexes] = sort(dataTrainTest);
            [dataTrainSort, dataTrainSortIndexes] = sort(dataTrain);  
            
            
            [~,dataTrainTestSortVarIndexes] = sort(relevanceTrainTest{layer+1}(i,:));
            [~,dataTrainSortVarIndexes] = sort(relevanceTrain{layer+1}(i,:));
            
            for k = 1:4200
                dataTrainTestSortVar(1,k) = dataTrainTest(1,dataTrainTestSortVarIndexes(1,k));
                dataTrainSortVar(1,k) = dataTrain(1,dataTrainSortVarIndexes(1,k)); 
            end;
            
            for k =1:4200
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 1;
                else
                    bestTrainTestSort(1, find(dataTrainTestSortIndexes == k) ) = 0;
                end;
                if relevanceBestTrainTest{layer+1}(i,k) == 1
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 1;
                else
                    bestTrainSort(1, find(dataTrainSortIndexes == k) ) = 0;                    
                end;
                
            end;            
            
            maxValues =  max( [meansTrainTest(i,:); meansTrain(i,:) ] );
            minValues =  min( [meansTrainTest(i,:); meansTrain(i,:) ] );
            
            maxValue = max(max(maxValues));            
            minValue = min(min(minValues));
        end;
        
        
        name = ['plot\' type{j} '\' 'categoria_' num2str(i) '.png'];
        if ~exist(name)
            set(gcf, 'Position', get(0, 'Screensize'));
            
            suptitle([label{j} ' - categoria ' num2str(i)] )

            subplot(2,1,1)
            stem(dataTrainTest, 'MarkerSize', 1)
            hold on 
            stem( find(relevanceTrainTestBinary{layer+1}(i,:)), dataTrainTest(1, find(relevanceTrainTestBinary{layer+1}(i,:) ) ), 'MarkerSize', 1, 'Color', 'green')
            stem( find(relevanceBestTrainTest{layer+1}(i,:)), dataTrainTest(1, find(relevanceBestTrainTest{layer+1}(i,:)) ), 'MarkerSize', 1, 'Color', 'red')
            plot( 1:4200, mean(dataTrainTest)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrainTest)-std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrainTest)+std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrainTest)-var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrainTest)+var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off    
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train+Test)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrainTest)) ...
                ' média-std: ' num2str(mean(dataTrainTest)-std(dataTrainTest)) ...
                ' média+std: ' num2str(mean(dataTrainTest)+std(dataTrainTest)) ...
                ' média-var: ' num2str(mean(dataTrainTest)-var(dataTrainTest)) ...  
                ' média+var: ' num2str(mean(dataTrainTest)+var(dataTrainTest)) ] )    


            subplot(2,1,2)
            stem(dataTrainTest, 'MarkerSize', 1)
            hold on
            stem( find(relevanceTrainTestBinary{layer+1}(i,:)), dataTrain(1, find(relevanceTrainTestBinary{layer+1}(i,:)) ), 'MarkerSize', 1, 'Color', 'green')
            stem( find(relevanceBestTrainTest{layer+1}(i,:)), dataTrain(1, find(relevanceBestTrainTest{layer+1}(i,:)) ), 'MarkerSize', 1, 'Color', 'red')
            plot( 1:4200, mean(dataTrain)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrain)-std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrain)+std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrain)-var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrain)+var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrain)) ...
                ' média-std: ' num2str(mean(dataTrain)-std(dataTrain)) ...
                ' média+std: ' num2str(mean(dataTrain)+std(dataTrain)) ...
                ' média-var: ' num2str(mean(dataTrain)-var(dataTrain)) ...  
                ' média+var: ' num2str(mean(dataTrain)+var(dataTrain)) ] )  

            %set(gcf, 'Position', get(0, 'Screensize'));
            if ~exist(['plot\' type{j}])
                mkdir(['plot\' type{j}])
            end;
            saveas( gcf, name);
        end;
        
        
        name = ['plot\' type{j} '\' 'sort_categoria_' num2str(i) '.png'];
        if ~exist(name)
            set(gcf, 'Position', get(0, 'Screensize'));
            suptitle([label{j} ' - categoria ' num2str(i)] )

            subplot(2,1,1)
            stem(dataTrainTestSort, 'MarkerSize', 1)
            hold on
            stem( find(goodTrainTestSort), dataTrainTestSort(1, find(goodTrainTestSort) ), 'MarkerSize', 1, 'LineWidth', 0.1, 'Color', 'green')
            stem( find(bestTrainTestSort), dataTrainTestSort(1, find(bestTrainTestSort) ), 'MarkerSize', 1, 'LineWidth', 0.1, 'Color', 'red')
            plot( 1:4200, mean(dataTrainTest)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrainTest)-std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrainTest)+std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrainTest)-var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrainTest)+var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off    
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train+Test)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrainTest)) ...
                ' média-std: ' num2str(mean(dataTrainTest)-std(dataTrainTest)) ...
                ' média+std: ' num2str(mean(dataTrainTest)+std(dataTrainTest)) ...
                ' média-var: ' num2str(mean(dataTrainTest)-var(dataTrainTest)) ...  
                ' média+var: ' num2str(mean(dataTrainTest)+var(dataTrainTest)) ] )    


            subplot(2,1,2)
            stem(dataTrainSort, 'MarkerSize', 1)
            hold on
            stem( find(goodTrainSort), dataTrainSort(1, find(goodTrainSort) ), 'MarkerSize', 1, 'LineWidth', 0.1, 'Color', 'green')
            stem( find(bestTrainSort), dataTrainSort(1, find(bestTrainSort) ), 'MarkerSize', 1, 'LineWidth', 0.1, 'Color', 'red')
            plot( 1:4200, mean(dataTrain)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrain)-std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrain)+std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrain)-var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrain)+var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrain)) ...
                ' média-std: ' num2str(mean(dataTrain)-std(dataTrain)) ...
                ' média+std: ' num2str(mean(dataTrain)+std(dataTrain)) ...
                ' média-var: ' num2str(mean(dataTrain)-var(dataTrain)) ...  
                ' média+var: ' num2str(mean(dataTrain)+var(dataTrain)) ] )  

            %set(gcf, 'Position', get(0, 'Screensize'));
            if ~exist(['plot\' type{j}])
                mkdir(['plot\' type{j}])
            end;
            saveas( gcf, name);
        end;
        
        
        name = ['plot\' type{j} '\' 'sort_var_categoria_' num2str(i) '.png'];
        if ~exist(name)
            set(gcf, 'Position', get(0, 'Screensize'));
            
            suptitle([label{j} ' - categoria ' num2str(i)] )

            subplot(2,1,1)
            stem(dataTrainTestSortVar, 'MarkerSize', 1)
            hold on
            stem( find(goodTrainTestSortVar), dataTrainTestSortVar(1, find(goodTrainTestSortVar) ), 'MarkerSize', 1, 'Color', 'green')
            stem( find(bestTrainTestSortVar), dataTrainTestSortVar(1, find(bestTrainTestSortVar) ), 'MarkerSize', 1, 'Color', 'red')
            plot( 1:4200, mean(dataTrainTest)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrainTest)-std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrainTest)+std(dataTrainTest))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrainTest)-var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrainTest)+var(dataTrainTest))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off    
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train+Test)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrainTest)) ...
                ' média-std: ' num2str(mean(dataTrainTest)-std(dataTrainTest)) ...
                ' média+std: ' num2str(mean(dataTrainTest)+std(dataTrainTest)) ...
                ' média-var: ' num2str(mean(dataTrainTest)-var(dataTrainTest)) ...  
                ' média+var: ' num2str(mean(dataTrainTest)+var(dataTrainTest)) ] )    


            subplot(2,1,2)
            stem(dataTrainSortVar, 'MarkerSize', 1)
            hold on
            stem( find(goodTrainSortVar), dataTrainSortVar(1, find(goodTrainSortVar) ), 'MarkerSize', 1, 'Color', 'green')
            stem( find(bestTrainSortVar), dataTrainSortVar(1, find(bestTrainSortVar) ), 'MarkerSize', 1, 'Color', 'red')
            plot( 1:4200, mean(dataTrain)*ones(4200), 'k' )  %mean
            plot( 1:4200, (mean(dataTrain)-std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
            plot( 1:4200, (mean(dataTrain)+std(dataTrain))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
            plot( 1:4200, (mean(dataTrain)-var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean-var
            plot( 1:4200, (mean(dataTrain)+var(dataTrain))*ones(4200), 'k', 'LineStyle', '-.' )  %mean+var        
            hold off
            axis([0 4200 minValue maxValue])
            xlabel('atributos dos dados (Train)')
            ylabel(label{j})
            title(['Todos dos atributos - media: ' num2str(mean(dataTrain)) ...
                ' média-std: ' num2str(mean(dataTrain)-std(dataTrain)) ...
                ' média+std: ' num2str(mean(dataTrain)+std(dataTrain)) ...
                ' média-var: ' num2str(mean(dataTrain)-var(dataTrain)) ...  
                ' média+var: ' num2str(mean(dataTrain)+var(dataTrain)) ] )  

            %set(gcf, 'Position', get(0, 'Screensize'));
            if ~exist(['plot\' type{j}])
                mkdir(['plot\' type{j}])
            end;
            saveas( gcf, name);
        end;        
        
        
    end;
end;
