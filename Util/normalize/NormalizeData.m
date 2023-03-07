function [normalizeTrain,normalizeTest] = NormalizeData(Model, train, test, type, train_labels, test_labels)

    indexesTrain = [];
    indexesTest = [];
% %     for i = 1:Model.multiple.numToyProblem
% %         indexesTrain = [indexesTrain find(train_labels == i)];
% %         indexesTest = [indexesTest find(test_labels == i)];
% %     end;

    if strcmp(type,'samples')
        % train
        low = min(train');
        high = max(train');
        [row,col] = size(train);
        lowMatrix = repmat(low',1,col);
        highMatrix = repmat(high',1,col);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        %test
        low = min(test');
        high = max(test');
        [row,col] = size(test);
        lowMatrix = repmat(low',1,col);
        highMatrix = repmat(high',1,col);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
    elseif strcmp(type,'global')
        low = min( min(min(train)) ); %min([ min(min(train(indexesTrain,:))) min(min(test(indexesTest,:))) ]);
        high = max( max(max(train)) ); %max([ max(max(train(indexesTrain,:))) max(max(test(indexesTest,:))) ]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);        
    elseif strcmp(type,'attributes_selected_with_test')
        low = min([train; test]);
        high = max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
        % tratamento NAn
        [row,col] = size(train);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTrain(i,j))
                    normalizeTrain(i,j) = 0;
                end;
            end;
        end;
        [row,col] = size(test);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTest(i,j))
                    normalizeTest(i,j) = 0;
                end;
            end;
        end;        
    elseif strcmp(type,'attributes_selected') || strcmp(type,'attributes')
        low = min(train); %min([train; test]);
        high = max(train); %max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
        % tratamento NAn
        [row,col] = size(train);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTrain(i,j))
                    normalizeTrain(i,j) = 0;
                end;
            end;
        end;
        [row,col] = size(test);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTest(i,j))
                    normalizeTest(i,j) = 0;
                end;
            end;
        end;
    elseif strcmp(type,'attributes_z_score')
        means = mean(train(indexesTrain,:)); %min([train; test]);
        stds = std(train(indexesTrain,:)); %max([train; test]);
        % train
        [row,col] = size(train);
        meansMatrix = repmat(means,row,1);
        stdsMatrix = repmat(stds,row,1);
        normalizeTrain = (train-meansMatrix)./stdsMatrix ;
        % test
        [row,col] = size(test);
        meansMatrix = repmat(means,row,1);
        stdsMatrix = repmat(stds,row,1);
        normalizeTest = (test-meansMatrix)./stdsMatrix ;
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
        % tratamento NAn
        [row,col] = size(train);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTrain(i,j))
                    normalizeTrain(i,j) = 0;
                end;
            end;
        end;
        [row,col] = size(test);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTest(i,j))
                    normalizeTest(i,j) = 0;
                end;
            end;
        end;          
    elseif strcmp(type,'attributes_selected_old')
        low = min(train(indexesTrain,:)); %min([train; test]);
        high = max(train(indexesTrain,:)); %max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);    
    elseif strcmp(type,'attributes_all_with_test')
        low = min([train; test]);
        high = max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
    elseif strcmp(type,'attributes_all')
        low = min(train); %min([train; test]);
        high = max(train); %max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
    elseif strcmp(type,'attributes_independent')
        low = min(train(indexesTrain,:)); 
        high = max(train(indexesTrain,:)); 
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        low = min(test(indexesTest,:)); 
        high = max(test(indexesTest,:));         
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        [row,col] = size(train);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTrain(i,j))
                    normalizeTrain(i,j) = 0;
                end;
            end;
        end;
        [row,col] = size(test);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTest(i,j))
                    normalizeTest(i,j) = 0;
                end;
            end;
        end;        
    elseif strcmp(type,'attributes_train')
        low = min(train(indexesTrain,:)); 
        high = max(train(indexesTrain,:)); 
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test        
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);
        % saturation
        normalizeTrain(normalizeTrain > 1) = 1;
        normalizeTest(normalizeTest > 1) = 1;
        normalizeTrain(normalizeTrain < 0) = 0;
        normalizeTest(normalizeTest < 0) = 0;
        [row,col] = size(train);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTrain(i,j))
                    normalizeTrain(i,j) = 0;
                end;
            end;
        end;
        [row,col] = size(test);
        for i = 1:row
            for j = 1:col
                if isnan(normalizeTest(i,j))
                    normalizeTest(i,j) = 0;
                end;
            end;
        end;  
    elseif strcmp(type,'attributes_old')
        low = min(train); %min([train; test]);
        high = max(train); %max([train; test]);
        % train
        [row,col] = size(train);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTrain = (train-lowMatrix)./(highMatrix-lowMatrix);
        % test
        [row,col] = size(test);
        lowMatrix = repmat(low,row,1);
        highMatrix = repmat(high,row,1);
        normalizeTest = (test-lowMatrix)./(highMatrix-lowMatrix);            
    elseif strcmp(type,'attributes_max')
        high = max([train; test]);
        % train
        [row,col] = size(train);
        highMatrix = repmat(high,row,1);
        normalizeTrain = train./highMatrix;
        % test
        [row,col] = size(test);
        highMatrix = repmat(high,row,1);
        normalizeTest = test./highMatrix;
    elseif strcmp(type,'attributes_standard_deviation')
        meanData = mean([train; test]);
        stdData = std([train; test]);
        % train
        [row,col] = size(train);
        meanMatrix = repmat(meanData,row,1);
        stdMatrix = repmat(stdData,row,1);
        normalizeTrain = (train-meanMatrix)./stdMatrix;
        % test
        [row,col] = size(test);
        meanMatrix = repmat(meanData,row,1);
        stdMatrix = repmat(stdData,row,1);
        normalizeTest = (test-meanMatrix)./stdMatrix;
   elseif strcmp(type,'attributes_filter')        
        [normalizeTrain, normalizeTest] = filterDataSigma(Model, train, test); 
        [normalizeTrain, normalizeTest] = NormalizeData(Model, normalizeTrain, normalizeTest, 'attributes');
    elseif strcmp(type,'attributes_pos_filter')    
        [normalizeTrain, normalizeTest] = NormalizeData(Model, train, test, 'attributes');
        [normalizeTrain, normalizeTest] = filterDataSigma(Model, normalizeTrain, normalizeTest);     
    elseif strcmp(type,'attributes_samples_filter')    
        [normalizeTrain, normalizeTest] = NormalizeData(Model, train, test, 'attributes');
        trainc = normalizeTrain;
        testc = normalizeTest;
        trainc(trainc == 0) = NaN;
        testc(testc == 0) = NaN;
        trainValueMean = nanmean(trainc());
        testValueMean = nanmean(testc());
        [row, col] = size(train);
        for i = 1:row
            trainc(i,:) = (normalizeTrain(i,:) < trainValueMean(i)); 
        end;
        for i = 1:row
            for j = 1:col
                if trainc(i,j) == 1
                    train(i,j) = 0; 
                end;
            end;
        end;        
        [row, col] = size(test);
        for i = 1:row
            trainc(i,:) = (normalizeTest(i,:) < testValueMean(i)); 
        end;
        for i = 1:row
            for j = 1:col
                if testc(i,j) == 1
                    test(i,j) = 0; 
                end;
            end;
        end;
        [normalizeTrain, normalizeTest] = NormalizeData(Model, train, test, 'attributes');
    elseif strcmp(type,'attributes_norm_percentual_samples_filter')    
        [normalizeTrain, normalizeTest] = NormalizeData(Model, train, test, 'attributes');
        [normalizeTrain, normalizeTest] = filterDataPercentualSamples(Model, normalizeTrain, normalizeTest);
    elseif strcmp(type,'attributes_norm_percentual_attributes_filter')    %TODO
        [normalizeTrain, normalizeTest] = NormalizeData(Model, train, test, 'attributes');
        [normalizeTrain, normalizeTest] = filterDataPercentualAttributes(Model, normalizeTrain, normalizeTest);      
    elseif strcmp(type,'exp')
        [normalizeTrain, normalizeTest] = NormalizeData(train, test, 'attributes');
        normalizeTrain = normalizeTrain.^2;
        normalizeTest = normalizeTest.^2;        
    elseif strcmp(type,'no')
        normalizeTrain = train;
        normalizeTest = test;
    end;

end