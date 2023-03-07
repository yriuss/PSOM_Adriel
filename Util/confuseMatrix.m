% Marcondes Ricarte

clear all;

load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\logs\maps\15_Scenes\backup\standard_unlearn_norm\sMaps_layer_5_single_1_fator_1_multiple_1_fator_1_test_1.mat');

layer = 4;
category = 3;


for i =1:category  
    indexTrain( ((i-1)*100)+1:(i)*100 ) = i;
    indexTest( ((i-1)*110)+1:(i)*110 ) = i;
end;

[~,lenTrain] = size(Model.test.layer{2}.indexesWinnersTrain{1,1}(1,:));
[~,lenTest] = size(Model.test.layer{2}.indexesWinnersTest{1,1}(1,:));
for i = 1:layer
    i
    confuseMatrixTrain{i} = zeros(category,category);
    confuseMatrixTest{i} = zeros(category,category);
    for j = 1:lenTrain 
        confuseMatrixTrain{i}(indexTrain(1,j),Model.test.layer{i+1}.indexesWinnersTrain{1,1}(1,j)) = ... 
            confuseMatrixTrain{i}(indexTrain(1,j),Model.test.layer{i+1}.indexesWinnersTrain{1,1}(1,j)) + 1; 
    end;
    for j = 1:lenTest 
        confuseMatrixTest{i}(indexTest(1,j),Model.test.layer{i+1}.indexesWinnersTest{1,1}(1,j)) = ... 
            confuseMatrixTest{i}(indexTest(1,j),Model.test.layer{i+1}.indexesWinnersTest{1,1}(1,j)) + 1; 
    end;    
    confuseMatrixTrain{i} = confuseMatrixTrain{i}/100;
    confuseMatrixTest{i} = confuseMatrixTest{i}/110;
end;


