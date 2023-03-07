% Marcondes Ricarte

function [train, test] = filterDataPercentualSamples(Model, train, test)

    % train
    [row,col] = size(train);
    valueMax = max(train');
    maxMatrix = repmat(valueMax',1,col);
    filteredTrain = train./maxMatrix;
    train(filteredTrain < Model.single.fatorFilter) = 0;
    % test
    [row,col] = size(test);
    valueMax = max(test');
    maxMatrix = repmat(valueMax',1,col);
    filteredTest = test./maxMatrix;
    test(filteredTest < Model.single.fatorFilter) = 0;
end


% 100*sum(exist(:) == 0)/(1500*4200)
% 100*sum(normalizeTrain(:) == 0)/(1500*4200)