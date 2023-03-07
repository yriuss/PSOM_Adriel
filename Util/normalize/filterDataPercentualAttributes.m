% Marcondes Ricarte

function [train, test] = filterDataPercentualAttributes(Model, train, test)

    data = [train; test];
    valueMax = max(data);
    % train
    [row,col] = size(train);    
    maxMatrix = repmat(valueMax,row,1);
    filteredTrain = train./maxMatrix;
    filteredTrain(filteredTrain < Model.single.fatorFilter) = 0;
    % test
    [row,col] = size(test);
    valueMax = max(test');
    maxMatrix = repmat(valueMax',1,col);
    filteredTest = test./maxMatrix;
    test(filteredTest < Model.single.fatorFilter) = 0;
end