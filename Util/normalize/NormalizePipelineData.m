function [DeepSOM] = NormalizePipelineData(Model, DeepSOM, layer, type, train_labels, test_labels)


    tops = [];
    floors = [];
    selected = [];
    indexesTrain = [];
    indexesTest = [];
    for i = 1:Model.multiple.numToyProblem
        selected = [selected i];
    end;
    for i = 1:Model.multiple.numToyProblem
        indexesTrain = [indexesTrain find(train_labels == i)];
        indexesTest = [indexesTest find(test_labels == i)];
    end;

    if strcmp(type,'global_attributes')
        for i = 1:Model.multiple.numToyProblem
            tops = [tops; max(DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:))];
            floors = [floors; min(DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:))];
        end;
        top = max(tops);
        floor = max(floors);
        % train
        row = length(indexes);
        floorMatrix = repmat(floor,row,1);
        topMatrix = repmat(top,row,1);
        for i = 1:Model.multiple.numToyProblem
            DeepSOM{i,layer}.BMUsValuesTrain(indexes,:) = (DeepSOM{i,layer}.BMUsValuesTrain(indexes,:)-floorMatrix)./(topMatrix-floorMatrix);
        end;
        % test
        for i = 1:Model.multiple.numToyProblem
            DeepSOM{i,layer}.BMUsValuesTest(indexes,:) = (DeepSOM{i,layer}.BMUsValuesTest(indexes,:)-floorMatrix)./(topMatrix-floorMatrix);
        end;
    elseif strcmp(type,'attributes_selected')
        if ~strcmp(cellstr(Model.multiple.prototype(layer)), 'n_prototypes')
            topsPipeline = [];
            floorsPipeline = [];            
            for i = 1:Model.multiple.numToyProblem               
                %for j = 1:Model.multiple.numToyProblem
                    topsPipeline = [topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:)] )]; %[topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == i,:)] )];
                    floorsPipeline = [floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:)] )]; %[floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == i,:)] )];
                %end;
                tops = [tops; topsPipeline];
                floors = [floors; floorsPipeline];
                topsPipeline = [];
                floorsPipeline = [];
            end;
            % train
            row = length(indexesTrain);
            for i = 1:Model.multiple.numToyProblem
                floorMatrix = repmat(floors(i,:),row,1);
                topMatrix = repmat(tops(i,:),row,1);
                DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:) = (DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:)-floorMatrix)./(topMatrix-floorMatrix);
                [rowTrain, colTrain] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:));
                for k = 1:rowTrain
                    DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) > 1) ) = 1;
                    DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) < 0) ) = 0;
                    DeepSOM{i,layer}.BMUsValuesTrain(k, find(isnan(DeepSOM{i,layer}.BMUsValuesTrain(k,:))) ) = 0;
                end;
            end;
            % test
            row = length(indexesTest);
            for i = 1:Model.multiple.numToyProblem
                floorMatrix = repmat(floors(i,:),row,1);
                topMatrix = repmat(tops(i,:),row,1);
                DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:) = (DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:)-floorMatrix)./(topMatrix-floorMatrix);
                [rowTest, colTest] = size(DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:));
                for k = 1:rowTest
                    DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) > 1) ) = 1;
                    DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) < 0) ) = 0;
                    DeepSOM{i,layer}.BMUsValuesTest(k, find(isnan(DeepSOM{i,layer}.BMUsValuesTest(k,:))) ) = 0;
                end;               
            end;            
        else
            topsPipeline = [];
            floorsPipeline = [];            
            for i = 1:Model.multiple.numToyProblem               
                %for j = 1:Model.multiple.numToyProblem
                    for k = 1:Model.multiple.prototypeRange(layer)
                        topsPipeline = [topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain{k}(train_labels == i,:); DeepSOM{i,layer}.BMUsValuesTest{k}(test_labels == i,:)] )];
                        floorsPipeline = [floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain{k}(train_labels == i,:); DeepSOM{i,layer}.BMUsValuesTest{k}(test_labels == i,:)] )];
                    end;
                %end;
                tops = [tops; max(topsPipeline)];
                floors = [floors; min(floorsPipeline)];
                topsPipeline = [];
                floorsPipeline = [];
            end;
            % train
            row = length(indexesTrain);
            for i = 1:Model.multiple.numToyProblem
                for k = 1:Model.multiple.prototypeRange(layer)
                    floorMatrix = repmat(floors(i,:),row,1);
                    topMatrix = repmat(tops(i,:),row,1);
                    DeepSOM{i,layer}.BMUsValuesTrain{k}(indexesTrain,:) = (DeepSOM{i,layer}.BMUsValuesTrain{k}(indexesTrain,:)-floorMatrix)./(topMatrix-floorMatrix);
                    [rowTrain, colTrain] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:));
                    for k = 1:rowTrain
                        DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) > 1) ) = 1;
                        DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) < 0) ) = 0;
                    end;
                end;
            end;
            % test
            row = length(indexesTest);
            for i = 1:Model.multiple.numToyProblem
                for k = 1:Model.multiple.prototypeRange(layer)
                    floorMatrix = repmat(floors(i,:),row,1);
                    topMatrix = repmat(tops(i,:),row,1);
                    DeepSOM{i,layer}.BMUsValuesTest{k}(indexesTest,:) = (DeepSOM{i,layer}.BMUsValuesTest{k}(indexesTest,:)-floorMatrix)./(topMatrix-floorMatrix);
                    [rowTest, colTest] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTest,:));
                    for k = 1:rowTest
                        DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) > 1) ) = 1;
                        DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) < 0) ) = 0;
                    end;  
                end;
            end;
        end;
    elseif strcmp(type,'attributes_selected_global')
        topsPipeline = [];
        floorsPipeline = [];            
        for i = 1:Model.multiple.numToyProblem               
            topsPipeline = [topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:)] )];
            floorsPipeline = [floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain(train_labels == i,:)] )]; 
            tops = [tops; topsPipeline];
            floors = [floors; floorsPipeline];
            topsPipeline = [];
            floorsPipeline = [];
        end;
        % train
        row = length(indexesTrain);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(min(floors),row,1);
            topMatrix = repmat(max(tops),row,1);
            DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:) = (DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTrain, colTrain] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:));
            for k = 1:rowTrain
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) < 0) ) = 0;
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(isnan(DeepSOM{i,layer}.BMUsValuesTrain(k,:))) ) = 0;
            end;
        end;
        % test
        row = length(indexesTest);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(min(floors),row,1);
            topMatrix = repmat(max(tops),row,1);
            DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:) = (DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTest, colTest] = size(DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:));
            for k = 1:rowTest
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) < 0) ) = 0;
                DeepSOM{i,layer}.BMUsValuesTest(k, find(isnan(DeepSOM{i,layer}.BMUsValuesTest(k,:))) ) = 0;
            end;               
        end;                    
    elseif strcmp(type,'attributes')
        topsPipeline = [];
        floorsPipeline = [];            
        for i = 1:Model.multiple.numToyProblem               
            for j = 1:Model.multiple.numToyProblem
                topsPipeline = [topsPipeline; max( DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:) )  ]; %[topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == j,:)] )];
                floorsPipeline = [floorsPipeline; min( DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:) ) ]; %[floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == j,:)] )];
            end;
            tops = [tops; max(topsPipeline)];
            floors = [floors; min(floorsPipeline)];
            topsPipeline = [];
            floorsPipeline = [];
        end;
        % train
        row = length(indexesTrain);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(floors(i,:),row,1);
            topMatrix = repmat(tops(i,:),row,1);
            DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:) = (DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTrain, colTrain] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:));
            for k = 1:rowTrain
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) < 0) ) = 0;
                DeepSOM{i,layer}.BMUsValuesTrain(k, find( isnan(DeepSOM{i,layer}.BMUsValuesTrain(k,:))) ) = 0;
            end;
        end;
        % test
        row = length(indexesTest);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(floors(i,:),row,1);
            topMatrix = repmat(tops(i,:),row,1);
            DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:) = (DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTest, colTest] = size(DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:));
            for k = 1:rowTest
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) < 0) ) = 0;
                DeepSOM{i,layer}.BMUsValuesTest(k, find( isnan(DeepSOM{i,layer}.BMUsValuesTest(k,:))) ) = 0;
            end;               
        end;            
    elseif strcmp(type,'attributes_global')
        topsPipeline = [];
        floorsPipeline = [];            
        for i = 1:Model.multiple.numToyProblem               
            for j = 1:Model.multiple.numToyProblem
                topsPipeline = [topsPipeline; max([DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == j,:)] )];
                floorsPipeline = [floorsPipeline; min( [DeepSOM{i,layer}.BMUsValuesTrain(train_labels == j,:); DeepSOM{i,layer}.BMUsValuesTest(test_labels == j,:)] )];
            end;
            tops = [tops; max(topsPipeline)];
            floors = [floors; min(floorsPipeline)];
            topsPipeline = [];
            floorsPipeline = [];
        end;
        % train
        row = length(indexesTrain);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(min(floors),row,1);
            topMatrix = repmat(max(tops),row,1);
            DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:) = (DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTrain, colTrain] = size(DeepSOM{i,layer}.BMUsValuesTrain(indexesTrain,:));
            for k = 1:rowTrain
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTrain(k, find(DeepSOM{i,layer}.BMUsValuesTrain(k,:) < 0) ) = 0;
            end;
        end;
        % test
        row = length(indexesTest);
        for i = 1:Model.multiple.numToyProblem
            floorMatrix = repmat(min(floors),row,1);
            topMatrix = repmat(max(tops),row,1);
            DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:) = (DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:)-floorMatrix)./(topMatrix-floorMatrix);
            [rowTest, colTest] = size(DeepSOM{i,layer}.BMUsValuesTest(indexesTest,:));
            for k = 1:rowTest
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) > 1) ) = 1;
                DeepSOM{i,layer}.BMUsValuesTest(k, find(DeepSOM{i,layer}.BMUsValuesTest(k,:) < 0) ) = 0;
            end;               
        end;            
        
    elseif strcmp(type,'no')

    end;

end