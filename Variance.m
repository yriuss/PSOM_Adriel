clear all;

dataset = 'atributos';
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
    load('dataInicialAtributos.mat');
    %load('relevance_debug.mat', 'Model');
    load('relevance_debug_attributes_new.mat');    
    dimY = 0.15;     
end;


load('DeepSOM.mat')

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
        if j <= round( 0.4*4200 )
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
    [sum(relevanceBestTrainTest{layer+1}(i,:))/4200]
end;

for i = 1:Model.multiple.numToyProblem
    [sum(relevanceBestTrainTest{layer+1}(i,1:3200))/3200 sum(relevanceBestTrainTest{layer+1}(i,3201:4000))/800 sum(relevanceBestTrainTest{layer+1}(i,4001:4200))/200]
end;


%%%%%%%%%%%%%%%%%%%%%%%% search best attibutes in train variance %%%%

percent = [0.01:0.01:1.00];

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 1;
            else
                relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 0;
            end;
        end;
        matchBestTrainTestWithTrain(i,k) = sum(relevanceWinnerBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:))/4200;
    end;
end;


suptitle(['Atributos discriminantes na vari?ncia Train'] )
subplot(3,1,1)
stem(100*percent, 100*matchBestTrainTestWithTrain(i,:), 'MarkerSize', 1)
axis([0 100 0 8])
xlabel('% atributos')
ylabel('% atributos discriminantes')
title('Categoria 1')
subplot(3,1,2)
stem(100*percent, 100*matchBestTrainTestWithTrain(i,:), 'MarkerSize', 1)
axis([0 100 0 8])
xlabel('% atributos')
ylabel('% atributos discriminantes')
title('Categoria 2')
subplot(3,1,3)
stem(100*percent, 100*matchBestTrainTestWithTrain(i,:), 'MarkerSize', 1)
axis([0 100 0 8])
xlabel('% atributos')
ylabel('% atributos discriminantes')
title('Categoria 3')
set(gcf, 'Position', get(0, 'Screensize'));
saveas( gcf, ['discriminantesTrain.png']); 


%%%%%%%%%%%%%%%%%%%%%%%% sele??o de vari?ncias e m?dias Train+Test %%%%%%%%%

percent = [0.01:0.01:1.00];

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceTrainTestPercentBinary{layer+1}(i, indexesTrainTest(i,j)) = 1;
            else
                relevanceTrainTestPercentBinary{layer+1}(i, indexesTrainTest(i,j)) = 0;
            end;
        end;
        varianceMatchData{i,k} =  relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) ;
        varianceMatch(i,k) = sum(relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        varianceBestData(i,k) = mean( relevanceTrainTest{layer+1}(i, (relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        varianceNoBestData(i,k) = mean( relevanceTrainTest{layer+1}(i, (relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;
    end;
end;



for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        means(i,:) = mean([DeepSOM{i,1}.BMUsValuesTrain; DeepSOM{i,1}.BMUsValuesTest]);
        [ meansSort(i,:), indexes(i,:)] = sort(means(i,:),'descend');
        total = 0;
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                meanTrainTestPercentBinary{layer+1}(i, indexes(i,j)) = 1;
            else
                meanTrainTestPercentBinary{layer+1}(i, indexes(i,j)) = 0;
            end;            
        end;
        meanMatchData{i,k} = meanTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:);
        meanMatch(i,k) =  sum(meanTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        meanBestData(i,k) = mean( means(i, meanMatchData{i,k} ) );   % 7%
        meanNoBestData(i,k) = mean( means(i, find( meanTrainTestPercentBinary{layer+1}(i,:) ) ) ); % 33%   
        if isnan(meanBestData(i,k))
            meanBestData(i,k) = 0;
        end;
    end;  
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        %varianceMeanMatch(i,k) = sum(varianceMatchData{i,k} & meanMatchData{i,k})/4200;
        varianceMeanBest(i,k) = varianceBestData(i,k) * meanBestData(i,k);
        varianceMeanNoBest(i,k) = varianceNoBestData(i,k) * meanNoBestData(i,k);
    end;
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Intercategoria - categoria ' num2str(i)] )
    subplot(3,1,1)
    h = bar(100*percent, [varianceBestData(i,:);varianceNoBestData(i,:)]','FaceColor','flat');    
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.015])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncias')
    title('Por menores vari?ncias')
    subplot(3,1,2)
    h = bar(100*percent, [meanBestData(i,:);meanNoBestData(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.2])
    xlabel('% atributos')
    ylabel('magnitudade das m?dias')
    title('Por maiores m?dias')
    subplot(3,1,3)
    h = bar(100*percent, [varianceMeanBest(i,:);varianceMeanNoBest(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.001])
    xlabel('% atributos')
    ylabel('produto vari?ncia pelas m?dias')
    title('Por menores vari?ncias e maiores m?dias')
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['intercategoria_categoria_' num2str(i) '.png']); 
end;



%%%%%%%%%%%%%%%%%%%%%%%% sele??o de vari?ncias das m?dias Train+Test %%%%%%%%%


percent = [0.01:0.01:1.00];

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceTrainTestPercentBinary{layer+1}(i, indexesTrainTest(i,j)) = 1;
            else
                relevanceTrainTestPercentBinary{layer+1}(i, indexesTrainTest(i,j)) = 0;
            end;
        end;
        varianceMatchData{i,k} =  relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) ;
        varianceMatch(i,k) = sum(relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        varianceBestData(i,k) = mean( relevanceTrainTest{layer+1}(i, (relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        varianceNoBestData(i,k) = mean( relevanceTrainTest{layer+1}(i, (relevanceTrainTestPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;
    end;
end;

for i = 1:Model.multiple.numToyProblem
    means(i,:) = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:); DeepSOM{i,1}.BMUsValuesTest(Model.test_labels == i,:)] );
end;
for i = 1:Model.multiple.numToyProblem
    varianceMeans(i,:) = var(means);
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem 
        [ varianceMeansSort(i,:), indexes(i,:)] = sort(varianceMeans(i,:),'descend');
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                varianceMeansBinary{layer+1}(i, indexes(i,j)) = 1;
            else
                varianceMeansBinary{layer+1}(i, indexes(i,j)) = 0;
            end;
        end;
        meanMatchData{i,k} = varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:);
        meanMatch(i,k) =  sum(varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        meanBestData(i,k) = mean( varianceMeans(i, (varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        meanNoBestData(i,k) = mean( varianceMeans(i, (varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;        
    end;  
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        varianceMeanBest(i,k) = varianceBestData(i,k) * meanBestData(i,k);
        varianceMeanNoBest(i,k) = varianceNoBestData(i,k) * meanNoBestData(i,k);
    end;
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Intracategoria - categoria ' num2str(i)] )
    subplot(3,1,1)
    h = bar(100*percent, [varianceBestData(i,:);varianceNoBestData(i,:)]','FaceColor','flat');    
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.015])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncias')
    title('Por menores vari?ncias')
    subplot(3,1,2)
    h = bar(100*percent, [meanBestData(i,:);meanNoBestData(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.02])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncia das m?dias das m?dias')
    title('Por maiores m?dias')
    subplot(3,1,3)
    h = bar(100*percent, [varianceMeanBest(i,:);varianceMeanNoBest(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.00003])
    xlabel('% atributos')
    ylabel('produto vari?ncia pelas m?dias')
    title('produto  da variancias pelas vari?ncias das m?dias das m?dias')
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['intracategoria_categoria_' num2str(i) '.png']); 
end;


%%%%%%%%%%%%%%%%%%%%%%%%%  medias 42000 %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    for j = 1:4200        
         if j <= round( 0.4*4200 )
            meansFilter{layer+1}(i, indexesTrainTest(i,j)) = means(1,indexesTrainTest(i,j));
         else
            meansFilter{layer+1}(i, indexesTrainTest(i,j)) = 0;
            meansFilter{layer+1}(i, indexesTrainTest(i,j)) = NaN;
        end;
    end;    
    for j = 1:4200 
        if relevanceBestTrainTest{layer+1}(i,j) == 1
            meansBestFilter{layer+1}(i, j) = means(1,j);
        else
            meansBestFilter{layer+1}(i, j) = NaN;
        end;
    end;    
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Vari?ncia das m?dias - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(means(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), means(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(means(i,:))*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
    hold off    
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Todos dos atributos - media: ' num2str(mean(means(i,:))) '. min: ' num2str(min(means(i,:))) '. max: ' num2str(max(means(i,:))) '. std: ' num2str(std(means(i,:))) '. Percentual de atributos: 100%'  ] )    
    subplot(3,1,2)
    stem( meansFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), meansFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(means(i,:))*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Train-Test - media: ' num2str(nanmean(meansFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(meansFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(meansFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(meansFilter{layer+1}(i,:))) '. Percentual de atributos: 40%' ] )    
    subplot(3,1,3)
    stem( meansBestFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), meansBestFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(means(i,:))*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(meansBestFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(meansBestFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(meansBestFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(meansBestFilter{layer+1}(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(meansBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%'  ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['means_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% variancias das medias 42000  %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    for j = 1:4200        
         if j <= round( 0.4*4200 )
            varianceMeansFilter{layer+1}(i, indexesTrainTest(i,j)) = varianceMeans(1,indexesTrainTest(i,j));
         else
            varianceMeansFilter{layer+1}(i, indexesTrainTest(i,j)) = 0;
            varianceMeansFilter{layer+1}(i, indexesTrainTest(i,j)) = NaN;
        end;
    end;    
    for j = 1:4200 
        if relevanceBestTrainTest{layer+1}(i,j) == 1
            varianceMeansBestFilter{layer+1}(i, j) = varianceMeans(1,j);
        else
            varianceMeansBestFilter{layer+1}(i, j) = NaN;
        end;
    end;    
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Vari?ncia das m?dias - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(varianceMeans(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeans(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std
    hold off
    %axis([0 4200 0 0.06])
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Todos dos atributos - media: ' num2str(mean(varianceMeans(i,:))) '. min: ' num2str(min(varianceMeans(i,:))) '. max: ' num2str(max(varianceMeans(i,:))) '. std: ' num2str(std(varianceMeans(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( varianceMeansFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeansFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std 
    hold off
    %axis([0 4200 0 0.06])
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Train-Test - media: ' num2str(nanmean(varianceMeansFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(varianceMeansFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(varianceMeansFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(varianceMeansFilter{layer+1}(i,:))) '. Percentual de atributos: 40%' ] )    
    subplot(3,1,3)
    stem( varianceMeansBestFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeansBestFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std    
    hold off
    %axis([0 4200 0 0.06])
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(varianceMeansBestFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(varianceMeansBestFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(varianceMeansBestFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(varianceMeansBestFilter{layer+1}(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(varianceMeansBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%'  ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['variancia_das_medias_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% produto 42000  %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    product(i,:) = means(i,:) .* relevanceTrainTest{layer+1}(i,:);
    productFilter(i,:) = meansFilter{layer+1}(i,:) .* relevanceTrainTest{layer+1}(i,:);
    productBestFilter(i,:) = meansBestFilter{layer+1}(i,:) .* relevanceTrainTest{layer+1}(i,:);
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Produto - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(product(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), product(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std    
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Todos dos atributos - media: ' num2str(mean(product(i,:))) '. min: ' num2str(min(product(i,:))) '. max: ' num2str(max(product(i,:))) '. std: ' num2str(std(product(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( productFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Train-Test - media: ' num2str(nanmean(productFilter(i,:))) '. min: ' num2str(nanmin(productFilter(i,:))) '. max: ' num2str(nanmax(productFilter(i,:))) '. std: ' num2str(nanstd(productFilter(i,:))) '. Percentual de atributos: 40%' ] )    
    subplot(3,1,3)
    stem( productBestFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productBestFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(productBestFilter(i,:))) '. min: ' num2str(nanmin(productBestFilter(i,:))) '. max: ' num2str(nanmax(productBestFilter(i,:))) '. std: ' num2str(nanstd(productBestFilter(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(varianceMeansBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['produto_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% produto 42000 (pela variancia das m?dias) %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    product(i,:) = varianceMeans(i,:) .* relevanceTrainTest{layer+1}(i,:);
    productFilter(i,:) = varianceMeansFilter{layer+1}(i,:) .* relevanceTrainTest{layer+1}(i,:);
    productBestFilter(i,:) = varianceMeansBestFilter{layer+1}(i,:) .* relevanceTrainTest{layer+1}(i,:);
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Produto - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(product(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), product(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Todos dos atributos - media: ' num2str(mean(product(i,:))) '. min: ' num2str(min(product(i,:))) '. max: ' num2str(max(product(i,:))) '. std: ' num2str(std(product(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( productFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Train-Test - media: ' num2str(nanmean(productFilter(i,:))) '. min: ' num2str(nanmin(productFilter(i,:))) '. max: ' num2str(nanmax(productFilter(i,:))) '. std: ' num2str(nanstd(productFilter(i,:))) '. Percentual de atributos: 40%' ] )    
    subplot(3,1,3)
    stem( productBestFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productBestFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(productBestFilter(i,:))) '. min: ' num2str(nanmin(productBestFilter(i,:))) '. max: ' num2str(nanmax(productBestFilter(i,:))) '. std: ' num2str(nanstd(productBestFilter(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(productBestFilter(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['produto_categoria_' num2str(i) '.png']);        
end;



%%%%%%%%%%%%%%%%%%%%%%%% sele??o de vari?ncias e m?dias Train %%%%%%%%%

percent = [0.01:0.01:1.00];

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceTrainPercentBinary{layer+1}(i, indexesWinner(i,j)) = 1;
            else
                relevanceTrainPercentBinary{layer+1}(i, indexesWinner(i,j)) = 0;
            end;
        end;
        varianceMatchData{i,k} =  relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) ;
        varianceMatch(i,k) = sum(relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        varianceBestData(i,k) = mean( relevanceTrain{layer+1}(i, (relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        varianceNoBestData(i,k) = mean( relevanceTrain{layer+1}(i, (relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;
    end;
end;


for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        means(i,:) = mean([DeepSOM{i,1}.BMUsValuesTrain]);
        [ meansSort(i,:), indexes(i,:)] = sort(means(i,:),'descend');
        total = 0;
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                meanTrainPercentBinary{layer+1}(i, indexes(i,j)) = 1;
            else
                meanTrainPercentBinary{layer+1}(i, indexes(i,j)) = 0;
            end;            
        end;
        meanMatchData{i,k} = meanTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:);
        meanMatch(i,k) =  sum(meanTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        meanBestData(i,k) = mean( means(i, meanMatchData{i,k} ) );   % 7%
        meanNoBestData(i,k) = mean( means(i, find( meanTrainPercentBinary{layer+1}(i,:) ) ) ); % 33%   
        if isnan(meanBestData(i,k))
            meanBestData(i,k) = 0;
        end;
    end;  
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        %varianceMeanMatch(i,k) = sum(varianceMatchData{i,k} & meanMatchData{i,k})/4200;
        varianceMeanBest(i,k) = varianceBestData(i,k) * meanBestData(i,k);
        varianceMeanNoBest(i,k) = varianceNoBestData(i,k) * meanNoBestData(i,k);
    end;
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Intercategoria - categoria ' num2str(i)] )
    subplot(3,1,1)
    h = bar(100*percent, [varianceBestData(i,:);varianceNoBestData(i,:)]','FaceColor','flat');    
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.015])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncias')
    title('Por menores vari?ncias')
    subplot(3,1,2)
    h = bar(100*percent, [meanBestData(i,:);meanNoBestData(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.2])
    xlabel('% atributos')
    ylabel('magnitudade das m?dias')
    title('Por maiores m?dias')
    subplot(3,1,3)
    h = bar(100*percent, [varianceMeanBest(i,:);varianceMeanNoBest(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.001])
    xlabel('% atributos')
    ylabel('produto vari?ncia pelas m?dias')
    title('Por menores vari?ncias e maiores m?dias')
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['intercategoria_categoria_' num2str(i) '.png']); 
end;




%%%%%%%%%%%%%%%%%%%%%%%% sele??o de vari?ncias das m?dias Train %%%%%%%%%

percent = [0.01:0.01:1.00];

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceTrainPercentBinary{layer+1}(i, indexesWinner(i,j)) = 1;
            else
                relevanceTrainPercentBinary{layer+1}(i, indexesWinner(i,j)) = 0;
            end;
        end;
        varianceMatchData{i,k} =  relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) ;
        varianceMatch(i,k) = sum(relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        varianceBestData(i,k) = mean( relevanceTrain{layer+1}(i, (relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        varianceNoBestData(i,k) = mean( relevanceTrain{layer+1}(i, (relevanceTrainPercentBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;
    end;
end;

for i = 1:Model.multiple.numToyProblem
    means(i,:) = mean( [DeepSOM{i,1}.BMUsValuesTrain(Model.train_labels == i,:) ] );    
end;
for i = 1:Model.multiple.numToyProblem
    varianceMeans(i,:) = var(means);
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem 
        [ varianceMeansSort(i,:), indexes(i,:)] = sort(varianceMeans(i,:),'descend');
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                varianceMeansBinary{layer+1}(i, indexes(i,j)) = 1;
            else
                varianceMeansBinary{layer+1}(i, indexes(i,j)) = 0;
            end;
        end;
        meanMatchData{i,k} = varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:);
        meanMatch(i,k) =  sum(varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) )/4200;
        meanBestData(i,k) = mean( varianceMeans(i, (varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 1) ) );   % 7%
        meanNoBestData(i,k) = mean( varianceMeans(i, (varianceMeansBinary{layer+1}(i,:) & relevanceBestTrainTest{layer+1}(i,:) == 0) ) ); % 33%
        if isnan(varianceBestData(i,k))
            varianceBestData(i,k) = 0;
        end;        
    end;  
end;

for k = 1:length(percent)
    for i = 1:Model.multiple.numToyProblem
        varianceMeanBest(i,k) = varianceBestData(i,k) * meanBestData(i,k);
        varianceMeanNoBest(i,k) = varianceNoBestData(i,k) * meanNoBestData(i,k);
    end;
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Intracategoria - categoria ' num2str(i)] )
    subplot(3,1,1)
    h = bar(100*percent, [varianceBestData(i,:);varianceNoBestData(i,:)]','FaceColor','flat');    
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.015])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncias')
    title('Por menores vari?ncias')
    subplot(3,1,2)
    h = bar(100*percent, [meanBestData(i,:);meanNoBestData(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.020])
    xlabel('% atributos')
    ylabel('magnitudade das vari?ncia das m?dias das m?dias')
    title('Por maiores m?dias')
    subplot(3,1,3)
    h = bar(100*percent, [varianceMeanBest(i,:);varianceMeanNoBest(i,:)]','FaceColor','flat'); 
    for j = 1:100
        h(1).CData(j,:) = [1 0 0];
        h(2).CData(j,:) = [0 0 1];
    end;
    axis([0 100 0 0.00003])
    xlabel('% atributos')
    ylabel('produto vari?ncia pelas m?dias')
    title('produto  da variancias pelas vari?ncias das m?dias das m?dias')
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['intracategoria_categoria_' num2str(i) '.png']); 
end;


%%%%%%%%%%%%%%%%%%%%%%%%% variancias das medias 4200 (somente train) %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    for j = 1:4200        
         if j <= round( 0.72*4200 )
            meansFilter{layer+1}(i, indexesWinner(i,j)) = means(1,indexesWinner(i,j));
         else
            meansFilter{layer+1}(i, indexesWinner(i,j)) = 0;
            meansFilter{layer+1}(i, indexesWinner(i,j)) = NaN;
        end;
    end;    
    for j = 1:4200 
        if relevanceBestTrainTest{layer+1}(i,j) == 1
            meansBestFilter{layer+1}(i, j) = means(1,j);
        else
            meansBestFilter{layer+1}(i, j) = NaN;
        end;
    end;    
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Vari?ncia das m?dias - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(means(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), means(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(means)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Todos dos atributos - media: ' num2str(mean(means(i,:))) '. min: ' num2str(min(means(i,:))) '. max: ' num2str(max(means(i,:))) '. std: ' num2str(std(means(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( meansFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), meansFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(means)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Train-Test - media: ' num2str(nanmean(meansFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(meansFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(meansFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(meansFilter{layer+1}(i,:))) '. Percentual de atributos: 72%' ] )    
    subplot(3,1,3)
    stem( meansBestFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), meansBestFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(means)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(means(i,:))-std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(means(i,:))+std(means(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(meansBestFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(meansBestFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(meansBestFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(meansBestFilter{layer+1}(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(meansBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['means_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% variancias das medias 4200 (somente train) %%%%%%%%%%%%%%%%%%%

varianceMeansFilter{layer+1} = zeros(3,4200);
for i = 1:Model.multiple.numToyProblem    
    for j = 1:4200        
         if j <= round( 0.72*4200 )
            varianceMeansFilter{layer+1}(i, indexesWinner(i,j)) = varianceMeans(1,indexesWinner(i,j));
         else
            varianceMeansFilter{layer+1}(i, indexesWinner(i,j)) = 0;
            varianceMeansFilter{layer+1}(i, indexesWinner(i,j)) = NaN;
        end;
    end;    
    for j = 1:4200 
        if relevanceBestTrainTest{layer+1}(i,j) == 1
            varianceMeansBestFilter{layer+1}(i, j) = varianceMeans(1,j);
        else
            varianceMeansBestFilter{layer+1}(i, j) = NaN;
        end;
    end;    
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Vari?ncia das m?dias - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(varianceMeans(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeans(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Todos dos atributos - media: ' num2str(mean(varianceMeans)) '. min: ' num2str(min(varianceMeans)) '. max: ' num2str(max(varianceMeans)) '. std: ' num2str(std(varianceMeans)) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( varianceMeansFilter{layer+1}(i,:), 'MarkerSize', 1)
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeansFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Train-Test - media: ' num2str(nanmean(varianceMeansFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(varianceMeansFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(varianceMeansFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(varianceMeansFilter{layer+1}(i,:))) '. Percentual de atributos: 72%' ] )    
    subplot(3,1,3)
    stem( varianceMeansBestFilter{layer+1}(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), varianceMeansBestFilter{layer+1}(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(varianceMeans)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(varianceMeans(i,:))-std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(varianceMeans(i,:))+std(varianceMeans(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std  
    hold off
    xlabel('atributos')
    ylabel('Vari?ncia das m?dias')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(varianceMeansBestFilter{layer+1}(i,:))) '. min: ' num2str(nanmin(varianceMeansBestFilter{layer+1}(i,:))) '. max: ' num2str(nanmax(varianceMeansBestFilter{layer+1}(i,:))) '. std: ' num2str(nanstd(varianceMeansBestFilter{layer+1}(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(varianceMeansBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['variancia_das_medias_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% produto 42000  %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    product(i,:) = means(i,:) .* relevanceWinner{layer+1}(i,:);
    productFilter(i,:) = meansFilter{layer+1}(i,:) .* relevanceWinner{layer+1}(i,:);
    productBestFilter(i,:) = meansBestFilter{layer+1}(i,:) .* relevanceWinner{layer+1}(i,:);
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Produto - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(product(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), product(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Todos dos atributos - media: ' num2str(mean(product(i,:))) '. min: ' num2str(min(product(i,:))) '. max: ' num2str(max(product(i,:))) '. std: ' num2str(std(product(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( productFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Train-Test - media: ' num2str(nanmean(productFilter(i,:))) '. min: ' num2str(nanmin(productFilter(i,:))) '. max: ' num2str(nanmax(productFilter(i,:))) '. std: ' num2str(nanstd(productFilter(i,:))) '. Percentual de atributos: 72%' ] )    
    subplot(3,1,3)
    stem( productBestFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productBestFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(productBestFilter(i,:))) '. min: ' num2str(nanmin(productBestFilter(i,:))) '. max: ' num2str(nanmax(productBestFilter(i,:))) '. std: ' num2str(nanstd(productBestFilter(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(productBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['produto_categoria_' num2str(i) '.png']);        
end;


%%%%%%%%%%%%%%%%%%%%%%%%% produto 42000 (pela variancia das m?dias) %%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    product(i,:) = varianceMeans(i,:) .* relevanceWinner{layer+1}(i,:);
    productFilter(i,:) = varianceMeansFilter{layer+1}(i,:) .* relevanceWinner{layer+1}(i,:);
    productBestFilter(i,:) = varianceMeansBestFilter{layer+1}(i,:) .* relevanceWinner{layer+1}(i,:);
end;

for i = 1:Model.multiple.numToyProblem
    suptitle(['Produto - categoria ' num2str(i)] )
    subplot(3,1,1)
    stem(product(i,:), 'MarkerSize', 1)
    hold on
    stem(find(relevanceBestTrainTest{layer+1}(i,:)), product(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Todos dos atributos - media: ' num2str(mean(product(i,:))) '. min: ' num2str(min(product(i,:))) '. max: ' num2str(max(product(i,:))) '. std: ' num2str(std(product(i,:))) '. Percentual de atributos: 100%' ] )    
    subplot(3,1,2)
    stem( productFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1, 'Color', 'red')
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Train-Test - media: ' num2str(nanmean(productFilter(i,:))) '. min: ' num2str(nanmin(productFilter(i,:))) '. max: ' num2str(nanmax(productFilter(i,:))) '. std: ' num2str(nanstd(productFilter(i,:))) '. Percentual de atributos: 72%' ] )    
    subplot(3,1,3)
    stem( productBestFilter(i,:), 'MarkerSize', 1)
    hold on
    stem( find(relevanceBestTrainTest{layer+1}(i,:)), productBestFilter(i,find(relevanceBestTrainTest{layer+1}(i,:))), 'MarkerSize', 1)
    plot( 1:4200, mean(product)*ones(4200), 'k' )  %mean
    plot( 1:4200, (mean(product(i,:))-std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean-std
    plot( 1:4200, (mean(product(i,:))+std(product(i,:)))*ones(4200), 'k', 'LineStyle', '--' )  %mean+std      
    hold off
    xlabel('atributos')
    ylabel('produto')
    title(['Atributos Discriminantes - media: ' num2str(nanmean(productBestFilter(i,:))) '. min: ' num2str(nanmin(productBestFilter(i,:))) '. max: ' num2str(nanmax(productBestFilter(i,:))) '. std: ' num2str(nanstd(productBestFilter(i,:))) '. Percentual de atributos: ' num2str(100*((4200 - sum(isnan(productBestFilter{layer+1}(i,:) ) ) ) /4200 )) '%' ] )    
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, ['produto_categoria_' num2str(i) '.png']);        
end;








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot distribui??o das best
relevanceBest = relevanceBestTrainTest;
for i = 1:Model.multiple.numToyProblem
    atributesPipeline = find(relevanceBest{layer+1}(i,:));
    percent = [0.01:0.01:0.40];    
    [relevanceWinnerSort{layer+1}(i,:), indexesWinner(i,:)] = sort(relevanceTrain{layer+1}(i,:),'ascend');    
    for k = 1:length(percent)
        for j = 1:4200 
            if j <= round( percent(k)*4200 )
                relevanceWinnerBinary{layer+1}(i, indexesTrainTest(i,j)) = 1;
            else
                relevanceWinnerBinary{layer+1}(i, indexesTrainTest(i,j)) = 0;
            end;
        end;
        match(i,k) = sum((relevanceWinnerBinary{layer+1}(i, :) == relevanceBest{layer+1}(i, :)) & relevanceBest{layer+1}(i, :))/4200;
    end;    
end;

subplot(3,1,1)
stem(match(1,:), 'MarkerSize', 1)
axis([0 40 0 0.08])
xlabel('% atributos')
ylabel('%Percentual atributos discriminantes')
subplot(3,1,2)
stem(match(2,:), 'MarkerSize', 1)
axis([0 40 0 0.08])
xlabel('% atributos')
ylabel('% atributos discriminantes')
subplot(3,1,3)
stem(match(3,:), 'MarkerSize', 1)
axis([0 40 0 0.08])
xlabel('% atributos')
ylabel('% atributos discriminantes')
set(gcf, 'Position', get(0, 'Screensize'));
saveas( gcf, 'match.png'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:Model.multiple.numToyProblem
    for j = 1:Model.multiple.numToyProblem
        relevancePipelineSimilarity(i,j) = sum((relevanceBest{layer+1}(i,:) == relevanceBest{layer+1}(j,:)) & relevanceBest{layer+1}(i,:) == 1 )/ 4200;
    end;            
end;











% parameters
camada = 2;


%%%%%%%%%%%%%%%%%%%%%%%% Global %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = {'variancia','min','media','max'};

dimY = [0.03 0.01 0.10 1];
if strcmp(dataset,'comNorm')
    if camada == 1
        dimY = [0.15 0.01 0.4 1];
    elseif camada == 2
        dimY = [0.1 0.01 0.6 1];
    end;
elseif strcmp(dataset,'semNorm')
    dimY = [0.0005 0.01 0.01 0.2];
elseif strcmp(dataset,'global')
    dimY = [0.03 0.01 0.1 1];
elseif strcmp(dataset,'amostras')
    dimY = [0.2 0.04 0.5 1];    
elseif strcmp(dataset,'atributosIndependente')
    dimY = [0.2 0.01 0.5 1];
elseif strcmp(dataset,'atributosTrain')
    dimY = [0.2 0.13 0.5 1];
elseif strcmp(dataset,'atributos')
    dimY = [0.2 0.13 0.6 1];    
end;

for k = 1:length(operator)
    suptitle('Todas categorias')
    
    indexesPipelineTrain = [];
    indexesPipelineTest = [];
    for i = 1:3
        indexesPipelineTrain = [indexesPipelineTrain find(Model.train_labels == i)];
        indexesPipelineTest = [indexesPipelineTest find(Model.test_labels == i)];
    end;

    subplot(5,1,1)
    if strcmp(operator{k}, 'variancia')
        variance = var(SamplesTrain.data(indexesPipelineTrain,:));
    elseif strcmp(operator{k}, 'min')
        variance = min(SamplesTrain.data(indexesPipelineTrain,:));
    elseif strcmp(operator{k}, 'media')
        variance = mean(SamplesTrain.data(indexesPipelineTrain,:));
    elseif strcmp(operator{k}, 'max')
        variance = max(SamplesTrain.data(indexesPipelineTrain,:));
    end;    
    stem(variance, 'MarkerSize', 1)
    axis([0 dimX 0 dimY(k)])
    xlabel('Atributos')
    ylabel(operator{k})
    title(['Train [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

    subplot(5,1,2)
    if strcmp(operator{k}, 'variancia')
        variance = nanvar(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'min')
        variance = min(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'media')
        variance = mean(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'max')
        variance = max(SamplesTest.data(indexesPipelineTest,:));
    end;      
    stem(variance, 'MarkerSize', 1)
    axis([0 dimX 0 dimY(k)])
    xlabel('Atributos')
    ylabel(operator{k})
    title(['Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )
    
    subplot(5,1,3)
    if strcmp(operator{k}, 'variancia')
        variance = var(SamplesTrain.data(indexesPipelineTrain,:)) - var(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'min')
        variance = min(SamplesTrain.data(indexesPipelineTrain,:)) - min(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'media')
        variance = mean(SamplesTrain.data(indexesPipelineTrain,:)) - mean(SamplesTest.data(indexesPipelineTest,:));
    elseif strcmp(operator{k}, 'max')
        variance = max(SamplesTrain.data(indexesPipelineTrain,:)) - max(SamplesTest.data(indexesPipelineTest,:));
    end;      
    stem(variance, 'MarkerSize', 1)
    axis([0 dimX -dimY(k) dimY(k)])
    xlabel('Atributos')
    ylabel(operator{k})
    title(['(Train - Test) [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

    subplot(5,1,4)
    if strcmp(operator{k}, 'variancia')
        variance = var([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
    elseif strcmp(operator{k}, 'min')
        variance = min([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
    elseif strcmp(operator{k}, 'media')
        variance = mean([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
    elseif strcmp(operator{k}, 'max')
        variance = max([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
    end;
    stem(variance, 'MarkerSize', 1)
    axis([0 dimX 0 dimY(k)])
    xlabel('Atributos')
    ylabel(operator{k})
    title(['Train e Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

    subplot(5,1,5)
    if strcmp(operator{k}, 'variancia')
        variance = nanvar([SamplesTest.data(testErrorIndexes,:)]);
    elseif strcmp(operator{k}, 'min')
        variance = min([SamplesTest.data(testErrorIndexes,:)]);
    elseif strcmp(operator{k}, 'media')
        variance = mean([SamplesTest.data(testErrorIndexes,:)]);
    elseif strcmp(operator{k}, 'max')
        variance = max([SamplesTest.data(testErrorIndexes,:)]);
    end;
    stem(variance, 'MarkerSize', 1)
    axis([0 dimX 0 dimY(k)])
    xlabel('Atributos')
    ylabel(operator{k})
    title(['Test error [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

    set(gcf, 'Position', get(0, 'Screensize'));
    saveas( gcf, [operator{k} '_todas_categorias.png']); 
end;



%%%%%%%%%%%%%%%%%%%%%%%% Pipeline %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = {'variancia','min','media','max','div-variancia-media'};

dimY = [0.03 0.01 0.10 1];
if strcmp(dataset,'comNorm')
    if camada == 1
        dimY = [0.15 0.01 0.4 1 1];
    elseif camada == 2
        dimY = [0.1 0.01 0.6 1 1];
    end;
elseif strcmp(dataset,'semNorm')
    dimY = [0.0005 0.01 0.01 0.2];
elseif strcmp(dataset,'global')
    dimY = [0.03 0.01 0.1 1];
elseif strcmp(dataset,'amostras')    
    dimY = [0.2 0.04 0.5 1]; 
elseif strcmp(dataset,'atributosIndependente')
    dimY = [0.2 0.01 0.5 1];
elseif strcmp(dataset,'atributosTrain')
    dimY = [0.2 0.13 0.5 1];
elseif strcmp(dataset,'atributos')
    if camada == 1
        dimY = [0.2 0.13 0.6 1 1];
    elseif camada == 2
        dimY = [0.2 0.13 0.6 1 1];
    end;
end;

for k = 1:length(operator)
    for i = 1:3

        if camada > 1
            SamplesTrain.data = DeepSOM{i,camada-1}.BMUsValuesTrain;
            SamplesTest.data = DeepSOM{i,camada-1}.BMUsValuesTest;
        end;

        indexesPipelineTrain = find(Model.train_labels == i);
        indexesPipelineTest = find(Model.test_labels == i);

        suptitle(['Categoria ' num2str(i)] )

        subplot(5,1,1)
        if strcmp(operator{k}, 'variancia')
            variance = var(SamplesTrain.data(indexesPipelineTrain,:));
        elseif strcmp(operator{k}, 'min')
            variance = min(SamplesTrain.data(indexesPipelineTrain,:));
        elseif strcmp(operator{k}, 'media')
            variance = mean(SamplesTrain.data(indexesPipelineTrain,:));
        elseif strcmp(operator{k}, 'max')
            variance = max(SamplesTrain.data(indexesPipelineTrain,:));
        elseif strcmp(operator{k}, 'div-variancia-media')
            variance = var(SamplesTrain.data(indexesPipelineTrain,:))./mean(SamplesTrain.data(indexesPipelineTrain,:));    
        end;           
        stem(variance, 'MarkerSize', 1)
        axis([0 dimX 0 dimY(k)])
        xlabel('Atributos')
        ylabel(operator{k})
        title(['Train [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

        subplot(5,1,2)
        if strcmp(operator{k}, 'variancia')
            variance = var(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'min')
            variance = min(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'media')
            variance = mean(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'max')
            variance = max(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'div-variancia-media')
            variance = var(SamplesTest.data(indexesPipelineTest,:))./mean(SamplesTest.data(indexesPipelineTest,:));             
        end;  
        stem(variance, 'MarkerSize', 1)
        axis([0 dimX 0 dimY(k)])
        xlabel('Atributos')
        ylabel(operator{k})
        title(['Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

        subplot(5,1,3)
        if strcmp(operator{k}, 'variancia')
            variance = var(SamplesTrain.data(indexesPipelineTrain,:)) - var(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'min')
            variance = min(SamplesTrain.data(indexesPipelineTrain,:)) - min(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'media')
            variance = mean(SamplesTrain.data(indexesPipelineTrain,:)) - mean(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'max')
            variance = max(SamplesTrain.data(indexesPipelineTrain,:)) - max(SamplesTest.data(indexesPipelineTest,:));
        elseif strcmp(operator{k}, 'div-variancia-media')
            variance = var(SamplesTrain.data(indexesPipelineTrain,:))./mean(SamplesTrain.data(indexesPipelineTrain,:)) - ...
                var(SamplesTest.data(indexesPipelineTest,:))./mean(SamplesTest.data(indexesPipelineTest,:));             
        end;
        stem(variance, 'MarkerSize', 1)
        axis([0 dimX -dimY(k) dimY(k)])
        xlabel('Atributos')
        ylabel(operator{k})
        title(['Train - Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

        subplot(5,1,4)
        if strcmp(operator{k}, 'variancia')
            variance = var([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
        elseif strcmp(operator{k}, 'min')
            variance = min([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
        elseif strcmp(operator{k}, 'media')
            variance = mean([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
        elseif strcmp(operator{k}, 'max')
            variance = max([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);
        elseif strcmp(operator{k}, 'div-variancia-media')
            variance = var([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)])./ ...
                mean([SamplesTrain.data(indexesPipelineTrain,:); SamplesTest.data(indexesPipelineTest,:)]);          
        end;
        stem(variance, 'MarkerSize', 1)
        axis([0 dimX 0 dimY(k)])
        xlabel('Atributos')
        ylabel(operator{k})
        title(['Train e Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )
        
        subplot(5,1,5)
        if strcmp(operator{k}, 'variancia')
            variance = var([SamplesTest.data(testErrorIndexes,:)]);
        elseif strcmp(operator{k}, 'min')
            variance = min([SamplesTest.data(testErrorIndexes,:)]);
        elseif strcmp(operator{k}, 'media')
            variance = mean([SamplesTest.data(testErrorIndexes,:)]);
        elseif strcmp(operator{k}, 'max')
            variance = max([SamplesTest.data(testErrorIndexes,:)]);
        elseif strcmp(operator{k}, 'div-variancia-media')
            variance = var([SamplesTest.data(testErrorIndexes,:)])./mean([SamplesTest.data(testErrorIndexes,:)]);
        end;
        stem(variance, 'MarkerSize', 1)
        axis([0 dimX 0 dimY(k)])
        xlabel('Atributos')
        ylabel(operator{k})
        title(['Test error [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

        set(gcf, 'Position', get(0, 'Screensize'));
        saveas( gcf, [operator{k} '_categoria_' num2str(i) '.png']); 
    end;
end;



%%%%%%%%%%%%%%%%%%%%%%%% Pipeline relevance best %%%%%%%%%%%%%%%%%%%%%%%%%%
operator = {'variancia','min','media','max','div-variancia-media'};

dimY = [0.03 0.01 0.10 1];
if strcmp(dataset,'comNorm')
    if camada == 1
        dimY = [0.13 0.01 0.40 1 1];
    elseif camada == 2
        dimY = [0.04 0.01 0.3 1 1];
    end;
elseif strcmp(dataset,'semNorm')
    dimY = [0.0001 0.01 0.01 0.05];
elseif strcmp(dataset,'atributos')
    if camada == 1
        dimY = [0.13 0.01 0.40 1 1];
    elseif camada == 2
        dimY = [0.04 0.01 0.3 1 1];
    end;    
end;

for j =1:2
    for k = 1:length(operator)
        if j == 1
            relevanceBest = relevanceBestTrainTest;
        else
            relevanceBest = relevanceBestWinner;
        end;

        if camada > 1
            SamplesTrain.data = DeepSOM{i,camada-1}.BMUsValuesTrain;
            SamplesTest.data = DeepSOM{i,camada-1}.BMUsValuesTest;
        end;


        for i =1:3

            atributesPipeline = find(relevanceBest{layer+1}(i,:));
            dimX =  length(atributesPipeline);

            if dimX > 0 

                indexesPipelineTrain = find(Model.train_labels == i);
                indexesPipelineTest = find(Model.test_labels == i);

                suptitle([operator{k} ' - Categoria ' num2str(i)] )

                subplot(5,1,1)
                if strcmp(operator{k}, 'variancia')
                    variance = var(SamplesTrain.data(indexesPipelineTrain,atributesPipeline));
                elseif strcmp(operator(k), 'min')
                    variance = min(SamplesTrain.data(indexesPipelineTrain,atributesPipeline));
                elseif strcmp(operator(k), 'media')
                    variance = mean(SamplesTrain.data(indexesPipelineTrain,atributesPipeline));
                elseif strcmp(operator(k), 'max')
                    variance = max(SamplesTrain.data(indexesPipelineTrain,atributesPipeline));
                elseif strcmp(operator{k}, 'div-variancia-media')
                    variance = var(SamplesTrain.data(indexesPipelineTrain,atributesPipeline))./mean(SamplesTrain.data(indexesPipelineTrain,atributesPipeline));
                    variance(1,isnan(variance)) = 0; 
                end;
                stem(variance, 'MarkerSize', 1)
                axis([0 dimX 0 dimY(k)])
                xlabel('Atributos')
                ylabel(operator(k))
                title(['Train [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

                subplot(5,1,2)
                if strcmp(operator{k}, 'variancia')
                    variance = var(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'min')
                    variance = min(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'media')
                    variance = mean(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'max')
                    variance = max(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator{k}, 'div-variancia-media')
                    variance = var(SamplesTest.data(indexesPipelineTest,atributesPipeline))./mean(SamplesTest.data(indexesPipelineTest,atributesPipeline));                      
                    variance(1,isnan(variance)) = 0; 
                end;
                stem(variance, 'MarkerSize', 1)
                axis([0 dimX 0 dimY(k)])
                xlabel('Atributos')
                ylabel(operator(k))
                title(['Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

                subplot(5,1,3)
                if strcmp(operator{k}, 'variancia')
                    variance = var(SamplesTrain.data(indexesPipelineTrain,atributesPipeline)) - var(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'min')
                    variance = min(SamplesTrain.data(indexesPipelineTrain,atributesPipeline)) - min(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'media')
                    variance = mean(SamplesTrain.data(indexesPipelineTrain,atributesPipeline)) - mean(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator(k), 'max')
                    variance = max(SamplesTrain.data(indexesPipelineTrain,atributesPipeline)) - max(SamplesTest.data(indexesPipelineTest,atributesPipeline));
                elseif strcmp(operator{k}, 'div-variancia-media')
                    variance = var(SamplesTrain.data(indexesPipelineTrain,atributesPipeline))./mean(SamplesTrain.data(indexesPipelineTrain,atributesPipeline)) - ...
                        var(SamplesTest.data(indexesPipelineTest,atributesPipeline))./mean(SamplesTest.data(indexesPipelineTest,atributesPipeline));                      
                    variance(1,isnan(variance)) = 0; 
                end;
                stem(variance, 'MarkerSize', 1)
                axis([0 dimX -dimY(k) dimY(k)])
                xlabel('Atributos')
                ylabel(operator(k))
                title(['(Train - Test) [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )                
                
                
                subplot(5,1,4)
                if strcmp(operator{k}, 'variancia')
                    variance = var([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)]);
                elseif strcmp(operator(k), 'min')
                    variance = min([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)]);
                elseif strcmp(operator(k), 'media')
                    variance = mean([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)]);
                elseif strcmp(operator(k), 'max')
                    variance = max([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)]);
                elseif strcmp(operator{k}, 'div-variancia-media')
                    variance = var([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)])./ ...
                        mean([SamplesTrain.data(indexesPipelineTrain,atributesPipeline); SamplesTest.data(indexesPipelineTest,atributesPipeline)]);                     
                    variance(1,isnan(variance)) = 0; 
                end;                
                stem(variance, 'MarkerSize', 1)
                axis([0 dimX 0 dimY(k)])
                xlabel('Atributos')
                ylabel(operator(k))
                title(['Train e Test [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

                subplot(5,1,5)
                variance = var([SamplesTest.data(testErrorIndexes,atributesPipeline)])
                if strcmp(operator{k}, 'variancia')
                    variance = var([SamplesTest.data(testErrorIndexes,atributesPipeline)]);
                elseif strcmp(operator(k), 'min')
                    variance = min([SamplesTest.data(testErrorIndexes,atributesPipeline)]);
                elseif strcmp(operator(k), 'media')
                    variance = mean([SamplesTest.data(testErrorIndexes,atributesPipeline)]);
                elseif strcmp(operator(k), 'max')
                    variance = max([SamplesTest.data(testErrorIndexes,atributesPipeline)]);
                elseif strcmp(operator{k}, 'div-variancia-media')
                    variance = var([SamplesTest.data(testErrorIndexes,atributesPipeline)])./mean([SamplesTest.data(testErrorIndexes,atributesPipeline)]);                    
                    variance(1,isnan(variance)) = 0; 
                end;                
                stem(variance, 'MarkerSize', 1)
                axis([0 dimX 0 dimY(k)])
                xlabel('Atributos')
                ylabel(operator(k))
                title(['Test error [m?dia: ' num2str(mean(variance)) ', min: ' num2str(min(variance))  ', m?x: ' num2str(max(variance)) ', std: ' num2str(std(variance)) ']'] )

                set(gcf, 'Position', get(0, 'Screensize'));
                saveas( gcf, [operator{k} '_categoria_' num2str(i) '.png']); 
            end;

        end;
    end;
end;