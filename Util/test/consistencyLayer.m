% Marcondes Ricarte

clear all;

database = '15_Scenes'; % {'LabelMe_8', '15_Scenes'} 

load(['logs\debug\' database '\output_psom_' int2str(3)]);
layer{1}.train_labels = train_labels;
layer{1}.train_predict = IndexesTrain;
layer{1}.test_labels = test_labels;
layer{1}.test_predict = IndexesTest;

load(['logs\debug\' database '\output_psom_' int2str(4)]);
layer{2}.train_labels = train_labels;
layer{2}.train_predict = IndexesTrain;
layer{2}.test_labels = test_labels;
layer{2}.test_predict = IndexesTest;

load(['logs\debug\' database '\output_psom_' int2str(5)]);
layer{3}.train_labels = train_labels;
layer{3}.train_predict = IndexesTrain;
layer{3}.test_labels = test_labels;
layer{3}.test_predict = IndexesTest;


[lenTrain] = length(layer{1}.train_predict); 
[lenTest] = length(layer{1}.test_predict); 

sum(layer{1}.train_predict == layer{2}.train_predict)/lenTrain
sum(layer{1}.test_predict == layer{2}.test_predict)/lenTest

sum(layer{1}.train_predict == layer{3}.train_predict)/lenTrain
sum(layer{1}.test_predict == layer{3}.test_predict)/lenTest