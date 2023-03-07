% Marcondes Ricarte

clear all;

database = '15_Scenes'; % ['15_Scenes', 'LabelMe_8']  
type = 'multiple'; % ['multiple','probabilistic']
layer = 3; % multiple




if strcmp(type,'single')
    path = ['logs\results\' database '\single']; % ['logs\results\15_Scenes\single', 'logs\results\LabelMe_8\single']
elseif strcmp(type,'multiple')
    path = ['logs\results\' database '\multiple'];
elseif strcmp(type,'probabilistic')
    path = ['logs\results\' database '\probabilistic'];
end;
files = what(path);
len = length(files.mat);


if strcmp(type,'multiple')
    col = 20;
    data = cell(len, col);
    for i = 1:len
        i
        strFator = ['['];
        strFatorBase = ['['];
        load([path,'\',char(files.mat(i))]);
        data(i,1) = num2cell(Model.multiple.index);
        inicializeMode = Model.multiple.inicializeMode;
        data(i,4) = cellstr(Model.single.normalizeType);
        data(i,5) = num2cell(Model.single.fatorFilter);
        data(i,7) = num2cell(Model.multiple.numMap(layer));
        data(i,8) = num2cell(Model.multiple.trainlen(layer));
        data(i,9) = num2cell(Model.multiple.a(layer));
        data(i,10) = num2cell(Model.multiple.aMin(layer));
        data(i,11) = num2cell(Model.multiple.window(layer));
        data(i,12) = cellstr(Model.multiple.learningMode);
        data(i,13) = num2cell(Model.multiple.unlearnedRate(layer));
        data(i,14) = num2cell(Model.multiple.unlearnedRateCrossCorrect(layer));
        data(i,15) = cellstr( [ num2str(Model.multiple.relevancePercent{1,layer}(1)) ' ' num2str(Model.multiple.relevancePercent{1,layer}(2)) ' ' num2str(Model.multiple.relevancePercent{1,layer}(3)) ] ); %;
%        data(i,16) = cellstr(Model.multiple.relevancePercent{i,layer+1}); %Model.multiple.sigmaAtive(layer)
        data(i,17) = num2cell(Model.test.layer{layer+1}.meanTest);
        data(i,18) = num2cell(sum(Model.test.layer{layer+1}.macthesDensityTest{1,1}(1,find(Model.test_labels == 1)))/110);
        data(i,19) = num2cell(sum(Model.test.layer{layer+1}.macthesDensityTest{1,1}(1,find(Model.test_labels == 2)))/110);
        data(i,20) = num2cell(sum(Model.test.layer{layer+1}.macthesDensityTest{1,1}(1,find(Model.test_labels == 3)))/110);
        data(i,21) = cellstr(char(files.mat(i)));
        
    end;

end;



subplot(3,1,1)
%scatter( cell2mat(data(:,16)),cell2mat(data(:,18)));
xlabel('Relevância')
ylabel('Score')
title('Categoria 1')
subplot(3,1,2)
scatter(cell2mat(data(:,16)),cell2mat(data(:,19)));
xlabel('Relevância')
ylabel('Score')
title('Categoria 2')
subplot(3,1,3)
scatter(cell2mat(data(:,16)),cell2mat(data(:,20)));
xlabel('Relevância')
ylabel('Score')
title('Categoria 3')