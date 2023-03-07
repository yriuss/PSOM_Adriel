% Marcondes Ricarte

function [Model, target] = filterBayes(Classes, dataTrain, labelTrain, dataTest, labelTest)

% Classes = 4; %Kmeans,TSOM, PbSOM
 if Classes == 4
      bias = 1;
%     data = 'database\data4Classes.txt';
%     label = 'database\labels4.txt';
 elseif Classes == 8
     bias = 0;
%     data = 'database\data8Classes.txt';
%     label = 'database\labels8.txt';
 elseif Classes == 66
     bias = 0;
%     data = 'database\data67Classes.txt';
%     label = 'database\labels67.txt';
 elseif Classes == 407
     bias = 0;
 end;



%SamplesTrain = load(data)';
[rowSamplesTrain, colSamplesTrain] = size(dataTrain);
%disp('Database original.');
%DatabaseStatistics(SamplesTrain);
%Labels = load(label)' + 1; %Shift na classes
SplitDataTrain = SplitData(Classes, dataTrain, labelTrain);


maxValues = [max(dataTrain(:)) max(dataTest(:))];
maxValue = max(maxValues);

%%% Algorithm Build Model
disp('Build model...');
Model = [];
for i=1:Classes
    Model{i}.frequency = [];
    Model{i}.p = [];
end;
for i=1:Classes
    i
    [rowSplitDataTrain, colSplitDataTrain] = size(SplitDataTrain{i}.data);
    Model{i}.frequency = zeros(rowSplitDataTrain,maxValue);
    for j=1:rowSplitDataTrain %num de objetos
        for k=1:colSplitDataTrain %num de imagens
            F = SplitDataTrain{i}.data(j,k);
            if F ~= 0
                Model{i}.frequency(j, F) =  Model{i}.frequency(j, F) + 1; 
            end
        end
    end
    Model{i}.frequency = Model{i}.frequency/colSplitDataTrain;
    Model{i}.p = colSplitDataTrain/colSamplesTrain;
end;

if Classes == 4
    Model{1}.p = Model{1}.p + 3.5;
    Model{2}.p = Model{2}.p + 0.6;
    Model{4}.p = Model{4}.p + 3; 
elseif Classes == 8
    Model{1}.p = Model{1}.p + 0.1;
    Model{2}.p = Model{2}.p + 0.1;
    Model{3}.p = Model{3}.p + 0.3;
    Model{5}.p = Model{5}.p + 0.1;
    Model{6}.p = Model{6}.p + 0.3;
    Model{8}.p = Model{8}.p + 0.3; 
end;


disp('Calculated Model...');
[rowSamplesTrain, colSamplesTrain] = size(dataTest);
SplitDataTrain = SplitData(Classes, dataTest, labelTest);
numerator = zeros(rowSamplesTrain,maxValue);
denominator = [];
score = zeros(1,Classes);
scores = [];
for i=1:Classes
    i
    if Classes == 4
        %SplitDataTrain{i}.frequency(SplitDataTrain{i}.frequency > 0) = 1; 
        Model{i}.frequency = log(Model{i}.frequency);
        Model{i}.frequency(isinf(Model{i}.frequency)) = 0;
        Model{i}.p = Model{i}.p + bias;
        %SplitDataTrain{i}.p(isinf(SplitDataTrain{i}.p)) = 0;
        denominator{i} = ((-Model{i}.frequency)/(Model{i}.p));
        %denominator{i} = -SplitDataTrain{i}.frequency;
    else
        %SplitDataTrain{i}.frequency(SplitDataTrain{i}.frequency > 0) = 1; 
        Model{i}.frequency = log(Model{i}.frequency);
        Model{i}.frequency(isinf(Model{i}.frequency)) = 0;
        %Model{i}.p = Model{i}.p + bias;
        %SplitDataTrain{i}.p(isinf(SplitDataTrain{i}.p)) = 0;
        %denominator{i} = ((-Model{i}.frequency)/(Model{i}.p));
        denominator{i} = sparse(-Model{i}.frequency);
        
    end;
end;

disp('Test..');
for j=1:colSamplesTrain
    j
    numerator = zeros(rowSamplesTrain,maxValue);
    for i=1:rowSamplesTrain 
        if dataTest(i,j) > 0
            numerator(i, dataTest(i,j)) = 1;
        end;
    end; 
    numerator = sparse(numerator);
    for i=1:Classes         
        try
            result = sparse(numerator./denominator{i});
        catch me
          me
        end;
        result(isnan(result)) = 0;
        result(isinf(result)) = 0;
        score(i) = sum(sum(result));
    end;
    scores = [scores; score];
    [value index] = max(score);
    target(j) = index;
end;

mean = sum(target == labelTest)/colSamplesTrain

confuse = zeros(Classes, Classes);
for i=1:colSamplesTrain
    confuse(labelTest(i), target(i)) = confuse(labelTest(i), target(i)) + 1; 
end;
for i=1:Classes
    confuse(i,:) = confuse(i,:)/sum(confuse(i,:));
end;
%confuse