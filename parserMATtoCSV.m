% script load data

clear all;

load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\database\15_Scenes_4200.mat');
disp('Concat train...');
train = [num2cell(train_data) classes(train_labels)];
disp('Concat test...');
test = [num2cell(test_data) classes(test_labels)];

disp('Write train xlsx...');
xlswrite('database\15_Scenes_4200_train.xlsx',train);
disp('Write test xlsx...');
xlswrite('database\15_Scenes_4200_test.xlsx',test);

