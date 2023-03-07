% Marcondes Ricarte

function [sMaps] = plotDebugWinners(Model, sMaps)


    if strcmp(Model.flag.plotDebugWinners,'yes')
        
        if Model.multiple.trainlen(1,1) == 10 
            indexesPlot = [1 (2:11)];
        elseif Model.multiple.trainlen(1,1) == 20
            indexesPlot = [1 (3:2:21)];
        elseif Model.multiple.trainlen(1,1) == 50 
            indexesPlot = [1 (6:5:51)];
        end;
        
        nameDir = [Model.dir.debug 'model_' int2str(Model.multiple.index)];
        if exist(nameDir,'dir') == 0
            mkdir(nameDir);
        end;
        
        % Acurracy
        name = [nameDir '\acurracy.png'];
        if exist(name) == 0
            plot([0:Model.multiple.trainlen(1,1)],Model.test.debug.acurracyTrain,...
                [0:Model.multiple.trainlen(1,1)],Model.test.debug.acurracyTest,...
                [0:Model.multiple.trainlen(1,1)],Model.test.debug.acurracyDensityTrain,...
                [0:Model.multiple.trainlen(1,1)],Model.test.debug.acurracyDensityTest),...
                title(['Model ' int2str(Model.multiple.index)]),
                xlabel('Epochs'),
                ylabel('Accuracy'),
                legend('Train','Test', 'Density Train','Density  Test')
                axis([0 Model.multiple.trainlen(1,1) 0 1]);
            saveas(gcf, name); 
        end;        
        
        
        % Unlearning frequency
        trainLen = Model.multiple.trainlen(1,1);
        name = [nameDir '\unlearningFrequency.png'];        
        if exist(name) == 0
            plot(1:trainLen,Model.test.debug.meanFrequencyUnlearned,...
                1:trainLen,Model.test.debug.stdFrequencyUnlearned,...
                1:trainLen,Model.test.debug.maxFrequencyUnlearned),...
                title(['Model ' int2str(Model.multiple.index)]), ...
                xlabel('Epochs'), ...
                ylabel('Unlearning frequency'), ...
                 legend('mean','std','max'),...
                axis([1 Model.multiple.trainlen(1,1) 0 1]);
            saveas(gcf, name); 
        end;

        
        % Change/epochs
        trainLen = Model.multiple.trainlen(1,1);
        name = [nameDir '\changeEpochs.png'];
        top = max([Model.test.debug.matchesTrain(2:trainLen), Model.test.debug.matchesTest(2:trainLen), ...
            Model.test.debug.matchesDensityTrain(2:trainLen), Model.test.debug.matchesDensityTest(2:trainLen)]);
        if exist(name) == 0
            plot(1:trainLen,Model.test.debug.matchesTrain,...
                1:trainLen,Model.test.debug.matchesTest,...
                1:trainLen,Model.test.debug.matchesDensityTrain,...
                1:trainLen,Model.test.debug.matchesDensityTest),...
                title(['Model ' int2str(Model.multiple.index)]), ...
                xlabel('Epochs'), ...
                ylabel('Rate change'), ...
                 legend('Train','Test','Density Train','Density Test'),...
                axis([2 (Model.multiple.trainlen(1,1)) 0 top]);
            saveas(gcf, name); 
        end;


        % winnersHit train
        trainLen = Model.multiple.trainlen(1,1);
        top = 0;
        for i = 1:Model.numClasses
            for j=1:trainLen+1
                if top < max(Model.test.debug.histogramTrain{j}{i}.hits) 
                    top = max(Model.test.debug.histogramTrain{j}{i}.hits);
                end;
            end;
        end;
        for i = 1:Model.numClasses
            
            nameWinnersHitDir = [nameDir '\winnersHit\train'];
            if exist(nameWinnersHitDir,'dir') == 0
                mkdir(nameWinnersHitDir);
            end;            
            
            name = [nameWinnersHitDir '\category_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j=indexesPlot
                    k = k + 1;
                    subplot(4,3,k)
                    stem(Model.test.debug.histogramTrain{j}{i}.hits, 'MarkerSize',1),...
                        title(['Epoch ' int2str(j-1)]),
                        xlabel('Nodes'),
                        ylabel('Victories'),
                        axis([0 65 0 top]);
                end;  
                saveas(gcf, name);
                close(gcf);
            end;
        end;
        
        
        % winnersHit test
        trainLen = Model.multiple.trainlen(1,1);
        for i = 1:Model.numClasses
            for j=indexesPlot
                if top < max(Model.test.debug.histogramTest{j}{i}.hits) 
                    top = max(Model.test.debug.histogramTest{j}{i}.hits);
                end;
            end;
        end;    
        for i = 1:Model.numClasses
            
            nameWinnersHitDir = [nameDir '\winnersHit\test'];
            if exist(nameWinnersHitDir,'dir') == 0
                mkdir(nameWinnersHitDir);
            end;            
            
            name = [nameWinnersHitDir '\category_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j=indexesPlot
                    k = k + 1;
                    subplot(4,3,k)
                    stem(Model.test.debug.histogramTest{j}{i}.hits, 'MarkerSize',1),...
                        title(['Epoch ' int2str(j-1)]),
                        xlabel('Nodes'),
                        ylabel('Victories'),
                        axis([0 65 0 top]);
                end;  
                saveas(gcf, name);
                close(gcf);
            end;
        end;
        
        
        
        % winnersError train
        trainLen = Model.multiple.trainlen(1,1);
        for i = 1:Model.numClasses
            for j=1:trainLen+1
                if top < max(Model.test.debug.histogramTrain{j}{i}.error) 
                    top = max(Model.test.debug.histogramTrain{j}{i}.error);
                end;
            end;
        end;
        for i = 1:Model.numClasses
            
            nameWinnersHitDir = [nameDir '\winnersError\train'];
            if exist(nameWinnersHitDir,'dir') == 0
                mkdir(nameWinnersHitDir);
            end;            
            
            name = [nameWinnersHitDir '\category_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j=indexesPlot
                    k = k + 1;
                    subplot(4,3,k)
                    stem(Model.test.debug.histogramTrain{j}{i}.error, 'MarkerSize',1),...
                        title(['Epoch ' int2str(j-1)]),
                        xlabel('Nodes'),
                        ylabel('Victories'),
                        axis([0 65 0 top]);
                end;  
                saveas( gcf, name);
                close(gcf);
            end;
        end;
        
        
        % winnersError test
        trainLen = Model.multiple.trainlen(1,1);
        for i = 1:Model.numClasses
            for j=1:trainLen+1
                if top < max(Model.test.debug.histogramTest{j}{i}.error) 
                    top = max(Model.test.debug.histogramTest{j}{i}.error);
                end;
            end;
        end;
        for i = 1:Model.numClasses
            
            nameWinnersHitDir = [nameDir '\winnersError\test'];
            if exist(nameWinnersHitDir,'dir') == 0
                mkdir(nameWinnersHitDir);
            end;            
            
            name = [nameWinnersHitDir '\category_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j=indexesPlot
                    k = k + 1;
                    subplot(4,3,k)
                    stem(Model.test.debug.histogramTest{j}{i}.error, 'MarkerSize',1),...
                        title(['Epoch ' int2str(j-1)]),
                        xlabel('Nodes'),
                        ylabel('Victories'),
                        axis([0 65 0 top]);
                end;  
                saveas( gcf, name);
                close(gcf);
            end;
        end;
        
        
        %ratioBMUs train
        trainLen = Model.multiple.trainlen(1,1);
        nameWinnersHitDir = [nameDir '\ratioBMUs'];
        if exist(nameWinnersHitDir,'dir') == 0
            mkdir(nameWinnersHitDir);
        end;            

        name = [nameWinnersHitDir '\train.png'];
        top = 0;
        for j=1:trainLen+1
            if top < max(Model.test.debug.ratioBMUsTrain(j,:)) 
                top = max(Model.test.debug.ratioBMUsTrain(j,:));
            end;
        end;
        if exist(name) == 0
            figure('units','normalized','outerposition',[0 0 1 1])
            k = 0;
            for j=indexesPlot
                k = k + 1;
                subplot(4,3,k)
                stem(Model.test.debug.ratioBMUsTrain(j,:), 'MarkerSize',1, 'Color', 'red'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Nodes'),
                    ylabel('Victories'),
                    axis([0 length(Model.test.debug.ratioBMUsTrain(j,:)) 0 top]);
                hold on
                subplot(4,3,k)
                indexes = find(Model.test.debug.ratioBMUsTrain(j,:) < 1);
                stem(indexes, Model.test.debug.ratioBMUsTrain(j,indexes), 'MarkerSize',1, 'Color', 'blue'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Samples'),
                    ylabel('Ratio'),
                    axis([0 length(Model.test.debug.ratioBMUsTrain(j,:)) 0 top]);
                hold off
            end;  
            saveas( gcf, name);
            close(gcf);
        end;
       
        
        
        %ratioBMUs test
        trainLen = Model.multiple.trainlen(1,1);
        nameWinnersHitDir = [nameDir '\ratioBMUs'];
        if exist(nameWinnersHitDir,'dir') == 0
            mkdir(nameWinnersHitDir);
        end;            

        name = [nameWinnersHitDir '\test.png'];
        top = 0;
        for j=1:trainLen+1
            if top < max(Model.test.debug.ratioBMUsTest(j,:)) 
                top = max(Model.test.debug.ratioBMUsTest(j,:));
            end;
        end;
        if exist(name) == 0
            figure('units','normalized','outerposition',[0 0 1 1])
            k = 0;
            for j=indexesPlot
                k = k + 1;
                subplot(4,3,k)
                stem(Model.test.debug.ratioBMUsTest(j,:), 'MarkerSize',1, 'Color', 'red'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Nodes'),
                    ylabel('Victories'),
                    axis([0 length(Model.test.debug.ratioBMUsTest(j,:)) 0 top]);
                hold on
                subplot(4,3,k)
                indexes = find(Model.test.debug.ratioBMUsTest(j,:) < 1);
                stem(indexes, Model.test.debug.ratioBMUsTest(j,indexes), 'MarkerSize',1, 'Color', 'blue'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Samples'),
                    ylabel('Ratio'),
                    axis([0 length(Model.test.debug.ratioBMUsTest(j,:)) 0 top]);
                hold off
            end;
            saveas( gcf, name);
            close(gcf);
        end;
            
    

    

        %ratioBMUs density train
        trainLen = Model.multiple.trainlen(1,1);
        nameWinnersHitDir = [nameDir '\densityRatioBMUs'];
        if exist(nameWinnersHitDir,'dir') == 0
            mkdir(nameWinnersHitDir);
        end;            

        name = [nameWinnersHitDir '\train.png'];
        top = 0;
        for j=1:trainLen+1
            if top < max(Model.test.debug.ratioBMUsDensityTrain(j,:)) 
                top = max(Model.test.debug.ratioBMUsDensityTrain(j,:));
            end;
        end;
        if exist(name) == 0
            figure('units','normalized','outerposition',[0 0 1 1])
            k = 0;
            for j=indexesPlot
                k = k + 1;
                subplot(4,3,k)
                stem(Model.test.debug.ratioBMUsDensityTrain(j,:), 'MarkerSize',1, 'Color', 'red'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Nodes'),
                    ylabel('Victories'),
                    axis([0 length(Model.test.debug.ratioBMUsDensityTrain(j,:)) 0 top]);
                hold on
                subplot(4,3,k)
                indexes = find(Model.test.debug.ratioBMUsDensityTrain(j,:) < 1);
                stem(indexes, Model.test.debug.ratioBMUsDensityTrain(j,indexes), 'MarkerSize',1, 'Color', 'blue'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Samples'),
                    ylabel('Ratio'),
                    axis([0 length(Model.test.debug.ratioBMUsDensityTrain(j,:)) 0 top]);
                hold off
            end;  
            saveas( gcf, name);
            close(gcf);
        end;


        %ratioBMUs density test
        trainLen = Model.multiple.trainlen(1,1);
        nameWinnersHitDir = [nameDir '\densityRatioBMUs'];
        if exist(nameWinnersHitDir,'dir') == 0
            mkdir(nameWinnersHitDir);
        end;            

        name = [nameWinnersHitDir '\test.png'];
        top = 0;
        for j=1:trainLen+1
            if top < max(Model.test.debug.ratioBMUsDensityTest(j,:)) 
                top = max(Model.test.debug.ratioBMUsDensityTest(j,:));
            end;
        end;
        if exist(name) == 0
            figure('units','normalized','outerposition',[0 0 1 1])
            k = 0;
            for j=indexesPlot
                k = k + 1;
                subplot(4,3,k)
                stem(Model.test.debug.ratioBMUsDensityTest(j,:), 'MarkerSize',1, 'Color', 'red'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Nodes'),
                    ylabel('Victories'),
                    axis([0 length(Model.test.debug.ratioBMUsDensityTest(j,:)) 0 top]);
                hold on
                subplot(4,3,k)
                indexes = find(Model.test.debug.ratioBMUsDensityTest(j,:) < 1);
                stem(indexes, Model.test.debug.ratioBMUsDensityTest(j,indexes), 'MarkerSize',1, 'Color', 'blue'),...
                    title(['Epoch ' int2str(j-1)]),
                    xlabel('Samples'),
                    ylabel('Ratio'),
                    axis([0 length(Model.test.debug.ratioBMUsDensityTest(j,:)) 0 top]);
                hold off
            end;  
            saveas( gcf, name);
            close(gcf);
        end;    
    
        

        
        
        %ratioBMUs time
        trainLen = Model.multiple.trainlen(1,1);
        nameWinnersHitDir = [nameDir];
        if exist(nameWinnersHitDir,'dir') == 0
            mkdir(nameWinnersHitDir);
        end;            

        name = [nameWinnersHitDir '\ratioErrorEpochs.png'];
        for j=1:trainLen+1
            ratioMeanTrain(j) = mean(Model.test.debug.ratioBMUsTrain(j,Model.test.debug.ratioBMUsTrain(j,:) < 1));
            ratioMeanTest(j) = mean(Model.test.debug.ratioBMUsTest(j,Model.test.debug.ratioBMUsTest(j,:) < 1));
        end;
        if exist(name) == 0
            %figure('units','normalized','outerposition',[0 0 1 1])
            plot([0:Model.multiple.trainlen(1,1)], ratioMeanTrain, ...
                [0:Model.multiple.trainlen(1,1)], ratioMeanTest),...
                title(['Model' int2str(Model.multiple.index)]),
                xlabel('Epochs'),
                ylabel('Ratio Mean'),
                legend('Train', 'Test'),
                axis([0 (Model.multiple.trainlen(1,1)) 0.8 1]);
            saveas( gcf, name);
            %close(gcf);
        end;
        
    
    
    end;
end