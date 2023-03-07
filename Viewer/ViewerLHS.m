%types = 1;
%typesName = ['normalize'];

layer = 2;

if layer == 1
    data(strcmp(data(:,1),'attributes_all_with_test'),1) = num2cell(1); 
    data(strcmp(data(:,1),'attributes_selected_with_test'),1) = num2cell(2); 
else
    data(strcmp(data(:,1),'no'),1) = num2cell(1);
    data(strcmp(data(:,1),'attributes_selected'),1) = num2cell(2);
    data(strcmp(data(:,1),'attributes'),1) = num2cell(3);
        data(strcmp(data(:,1),'attributes_selected_global'),1) = num2cell(4);
    data(strcmp(data(:,1),'attributes_global'),1) = num2cell(5);
end

%data(strcmp(data(:,1),'attributes'),1) = num2cell(3);
%data(strcmp(data(:,1),'saturation'),1) = num2cell(4);

data(strcmp(data(:,2),'random'),2) = num2cell(1);
data(strcmp(data(:,2),'mean_random'),2) = num2cell(2);

dataSelected = data(cell2mat(data(:,18)) > 0.70,:);    
data = dataSelected;

% % dataSelected = data(cell2mat(data(:,5)) > 1,:);    
% % data = dataSelected;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dataMax, dataMaxIndex] = max(cell2mat(data(:,18))); 

subplot(7,2,1);
scatter(cell2mat(data(:,8)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,8)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Épocas')
subplot(7,2,2);
scatter(cell2mat(data(:,11)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,11)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Vizinhaça')
subplot(7,2,3);
scatter(cell2mat(data(:,9)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,9)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Aprendizado Inicial')
subplot(7,2,4);
scatter(cell2mat(data(:,10)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,10)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Aprendizado Final')
% % subplot(7,2,5);
% % scatter(cell2mat(data(:,5)),cell2mat(data(:,18)), 20);
% % hold on;
% % scatter(cell2mat(data(dataMaxIndex,5)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
% % hold off;
% % title('Set Relevance')
subplot(7,2,8);
scatter(cell2mat(data(:,1)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,1)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Normalização')
subplot(7,2,9);
scatter(cell2mat(data(:,12)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,12)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('composição')
% % subplot(7,2,10);
% % scatter(cell2mat(data(:,4)),cell2mat(data(:,18)), 20);
% % hold on;
% % scatter(cell2mat(data(dataMaxIndex,4)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
% % hold off;
% % title('inicio da janela - etapa 1')
% % subplot(7,2,11);
% % scatter(cell2mat(data(:,11)),cell2mat(data(:,18)), 20);
% % hold on;
% % scatter(cell2mat(data(dataMaxIndex,11)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
% % hold off;
% % title('tamanho da janela - etapa 1')
subplot(7,2,12);
scatter(cell2mat(data(:,2)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,2)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Update Relevance')
subplot(7,2,13);
scatter(cell2mat(data(:,3)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,3)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Fator Std ponto de corte')
subplot(7,2,14);
scatter(cell2mat(data(:,4)),cell2mat(data(:,18)), 20);
hold on;
scatter(cell2mat(data(dataMaxIndex,4)),cell2mat(data(dataMaxIndex,18)), 20, 'r');
hold off;
title('Fator Std ponto de corte 2')
