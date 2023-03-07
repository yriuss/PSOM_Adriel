samples = [3 5 6 7 11 12 13 14 22];
for k = 1:8
    subplot(4,2,k)
    plot([1:21],Model1.test.debug.ratioBMUsTest(:,samples(k)), ...
    [1:21],Model2.test.debug.ratioBMUsTest(:,samples(k)), ...
    [1:21],Model3.test.debug.ratioBMUsTest(:,samples(k)), ...
    [1:21],Model4.test.debug.ratioBMUsTest(:,samples(k)), ...
    [1:21],Model5.test.debug.ratioBMUsTest(:,samples(k))), ...
    legend('sem','com1','com2','com3','com4'), axis([1 21 0.8 1.1])
end;


results = [];
error  = find(Model1.test.debug.ratioBMUsTest(21,:) < 1)
i = 0;
for k = error
    i = i + 1; 
    results(1,i) = Model1.test.debug.ratioBMUsTest(21,error(i));
    results(2,i) = Model2.test.debug.ratioBMUsTest(21,error(i));
    results(3,i) = Model3.test.debug.ratioBMUsTest(21,error(i));
    results(4,i) = Model4.test.debug.ratioBMUsTest(21,error(i));
    results(5,i) = Model5.test.debug.ratioBMUsTest(21,error(i));
end;
[valueMax indexMax] = max(results);
resultsFinal =  mean(results');
stem(resultsFinal), axis([0 6 0.9 1.0]);



clear all;
load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\logs\maps\15_Scenes\multiple\sMaps_layer_2_single_1_multiple_1_test_1_sem_desaprendizagem.mat');
Model1 = Model;
load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\logs\maps\15_Scenes\multiple\sMaps_layer_2_single_1_multiple_1_test_1_com_desaprendizagem_model_1.mat');
Model2 = Model;
load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\logs\maps\15_Scenes\multiple\sMaps_layer_2_single_1_multiple_1_test_1_com_desaprendizagem_model_2.mat');
Model3 = Model;
load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\logs\maps\15_Scenes\multiple\sMaps_layer_2_single_1_multiple_1_test_1_com_desaprendizagem_model_3.mat');
Model4 = Model;
load('C:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\logs\maps\15_Scenes\multiple\sMaps_layer_2_single_1_multiple_1_test_1_com_desaprendizagem_model_4.mat');
Model5 = Model;