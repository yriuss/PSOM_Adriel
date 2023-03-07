% Marcondes Ricarte

function [SplitDataTrain] = SplitData(Classes, SamplesTrain, Labels)

    SplitDataTrain = [];
    for i=1:Classes
        SplitDataTrain{i}.data = SamplesTrain(Labels == i,:);   
    end;
end