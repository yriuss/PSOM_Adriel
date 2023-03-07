% Marcondes Ricarte

function [DeepSOM] = plotDataDebug(DeepSOM, Model, SamplesTrain, SamplesTest, Ms, type, layer, numNeuron, epoch)

%load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\dataInicial.mat');
%load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\logs\maps\15_Scenes\backup\standard\sMaps_layer_5_single_1_fator_1_multiple_1_fator_1_test_1.mat');


for i =1:3
    DeepSOM{i,layer}.sMap.codebook =  Ms{i}.M;
    if layer == 1
        dataSamplesTrain.data = SamplesTrain.data;
        dataSamplesTest.data = SamplesTest.data;           
    else
        dataSamplesTrain.data = DeepSOM{i,layer-1}.BMUsValuesTrain;
        dataSamplesTest.data = DeepSOM{i,layer-1}.BMUsValuesTest;     
    end;
    DeepSOM{i,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{i,layer}.sMap, dataSamplesTrain, 'ALL',i,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(i),layer);
    DeepSOM{i,layer}.BMUsValuesTest = som_bmusdeep(DeepSOM{i,layer}.sMap, dataSamplesTest, 'ALL',i,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(i),layer);
end;



dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
dataTest = concatPipelines(Model, DeepSOM, layer, 'test', Model.multiple.numToyProblem);   
[acurracyDensityTrain(1,:),~,~,macthesDensityTrain{1},~,indexesWinnersTrain{1}] = ... 
    debugMeanWinners(Model, SamplesTrain, dataTrain, layer, numNeuron, Model.train_labels,'descend');
[acurracyDensityTest(1,:),~,~,macthesDensityTest{1},~,indexesWinnersTest{1}] = ...
    debugMeanWinners(Model, SamplesTest, dataTest, layer, numNeuron, Model.test_labels,'descend');

acceptTrain =  sum(macthesDensityTrain{1}(1,:))/ length(macthesDensityTrain{1}(1,:));
acceptTest =  sum(macthesDensityTest{1}(1,:))/ length(macthesDensityTest{1}(1,:));

dataset = {'train','test'};
%type = 'pca'; % polar,x1x2,pca

%layer = 1;

if layer == 1
    x1 = 4001;
    x2 = 4002;
elseif layer == 2
    x1 = 1;
    x2 = 32;
elseif layer == 3 
    x1 = 1;
    x2 = 16;
elseif layer ==4
    x1 = 1;
    x2 = 8;    
end;



munits = Model.multiple.numMap(layer);

indexesTrain = [];
indexesTest = [];
for i = 1:3
    indexesTrain( ((i-1)*100)+1 : (i*100)) = i;
    indexesTest( ((i-1)*110)+1 : (i*110)) = i;
end;


for k = 1:length(dataset)
    if k == 1
        lenData = 300;
    else k == 2 
        lenData = 330;
    end
    %samples
    
    %% PCA
    if strcmp(type,'pca') && k == 1
        data = [];
        for i = 1:3
            if layer == 1
                data = [data; SamplesTrain.data(indexesTrain == i,:) ];
            else
                data = [data; DeepSOM{i,layer-1}.BMUsValuesTrain(indexesTrain == i,:) ];
            end;
        end;
        for i = 1:3
            if layer == 1
                data = [data; SamplesTest.data(indexesTest == i,:) ];
            else
                data = [data; DeepSOM{i,layer-1}.BMUsValuesTest(indexesTest == i,:) ];
            end;
        end;
        for i = 1:3
            data = [data; DeepSOM{i,layer}.sMap.codebook ];
        end;
        dataPCA = ExecutePCA(data',2)';
        
        if layer == 1
            SamplesTrain.data(indexesTrain == 1,1:2) = dataPCA(1:100,:);
            SamplesTrain.data(indexesTrain == 2,1:2) = dataPCA(101:200,:);
            SamplesTrain.data(indexesTrain == 3,1:2) = dataPCA(201:300,:);
            SamplesTest.data(indexesTest == 1,1:2) = dataPCA(301:410,:);
            SamplesTest.data(indexesTest == 2,1:2) = dataPCA(411:520,:);
            SamplesTest.data(indexesTest == 3,1:2) = dataPCA(521:630,:);
        else
            DeepSOM{1,layer-1}.BMUsValuesTrain(indexesTrain == 1,1:2) = dataPCA(1:100,:);
            DeepSOM{2,layer-1}.BMUsValuesTrain(indexesTrain == 2,1:2) = dataPCA(101:200,:);
            DeepSOM{3,layer-1}.BMUsValuesTrain(indexesTrain == 3,1:2) = dataPCA(201:300,:);
            DeepSOM{1,layer-1}.BMUsValuesTest(indexesTest == 1,1:2) = dataPCA(301:410,:);
            DeepSOM{2,layer-1}.BMUsValuesTest(indexesTest == 2,1:2) = dataPCA(411:520,:);
            DeepSOM{3,layer-1}.BMUsValuesTest(indexesTest == 3,1:2) = dataPCA(521:630,:);
        end;
        
        if layer == 1
            DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(631:662,:);
            DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(663:694,:);
            DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(695:726,:);
        elseif layer == 2
            DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(631:646,:);
            DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(647:662,:);
            DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(663:678,:);
        elseif  layer == 3     
            DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(631:638,:);
            DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(639:646,:);
            DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(647:654,:);           
        elseif  layer == 4     
            DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(631:634,:);
            DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(635:638,:);
            DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(639:642,:);  
        end;
        
    end;
    %%
    
    for i = 1:lenData
        if i <= 100
            category = 1;
             color = 'red';
        elseif i > 100 && i <= 200        
            category = 2;
             color = 'green';
        elseif i > 200
            category = 3;
             color = 'blue';
        end;

        if layer == 1
            x = SamplesTrain.data(i,:);
        else
            if k == 1
                x = DeepSOM{category,layer-1}.BMUsValuesTrain(i,:);
            else k == 2
                x = DeepSOM{category,layer-1}.BMUsValuesTest(i,:);
            end;
        end;

        normTrain(i) = norm(x);
        lenX = length(x);
        reference = zeros(lenX,1);
        reference(1) = 1;
        cosTheta(i) = dot(x,reference)/(norm(x)*norm(reference));
        senTheta(i) = sqrt( 1 - cosTheta(i)^2 );
        

        
        if strcmp(dataset{k},'train')
            correct = macthesDensityTrain{1,1}(1,:);
        elseif strcmp(dataset{k},'test')
            correct = macthesDensityTest{1,1}(1,:);
        end;
        
        if strcmp(type,'polar')
            if correct(i) == 1
                scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i), 20, color);
            else
                scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i), 20, color, '*');
            end;
        elseif strcmp(type,'x1x2')
            if correct(i) == 1
                scatter(x(x1), x(x2), 20, color);
            else
                scatter(x(x1), x(x2), 20, color, '*');
            end;  
        elseif strcmp(type,'pca')    
            if correct(i) == 1
                scatter(x(1), x(2), 20, color);
            else
                scatter(x(1), x(2), 20, color, '*');
            end;          
        end;
            
        %axis([0 6 0 6])
        hold on;    
    end;



    % centers
    for j = 1:3
        for i = 1:munits
            if j == 1
                category = 1;
                color = 'red';
            elseif j == 2        
                category = 2;
                 color = 'green';
            elseif j == 3
                category = 3;
                color = 'blue';
            end;

            x = DeepSOM{j,layer}.sMap.codebook(i,:);
            normCenter(i) = norm(x);
            lenData = length(x);
            reference = zeros(lenData,1);
            reference(1) = 1;
            cosTheta(i) = dot(x,reference)/(norm(x)*norm(reference));
            senTheta(i) = sqrt( 1 - cosTheta(i)^2 );
            if strcmp(type,'polar')
                scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i),  150, color);
            elseif strcmp(type,'x1x2')
                scatter(x(x1), x(x2), 150, color);
                if i > 1
                    line( [xOld(x1) x(x1)] , [xOld(x2) x(x2)] , 'Color', color);
                end;
                xOld = x;
            elseif strcmp(type,'pca')
                scatter(x(1), x(2), 150, color);
                if i > 1
                    line( [xOld(1) x(1)] , [xOld(2) x(2)] , 'Color', color);
                end;
                xOld = x;
            end;
            hold on;
        end;
    end;

    if strcmp(dataset{k},'train')
        title([dataset{k} ' - layer ' num2str(layer) ' - epoch ' num2str(epoch) ' - ' num2str(round(100*acceptTrain,2)) '%'  ])
    elseif strcmp(dataset{k},'test')
        title([dataset{k} ' - layer ' num2str(layer) ' - epoch ' num2str(epoch) ' - ' num2str(round(100*acceptTest,2)) '%'  ])
    end;
    %axis([0 0 4 10])
    %xlabel('Polar')
    hold off;
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, [Model.dir.plotData type  '\' dataset{k} '\epoch_' num2str(epoch) '.png' ] );
    
end;

