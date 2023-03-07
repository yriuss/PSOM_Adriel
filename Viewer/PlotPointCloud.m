% Marcondes Ricarte

clear all;

load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\dataInicial.mat');
load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\logs\maps\15_Scenes\backup\prototype_variance\sMaps_layer_5_single_1_fator_1_multiple_1_fator_1_test_1_high.mat');


dataset = {'train','test'};
typeSet = {'x1x2','pca'}; % polar,x1x2,pca

layer = 4;


if layer == 1
    pipeline = 1
else
    pipeline = 3;
end;
    
if layer == 1
    x1 = 4001;
    x2 = 4002;
elseif layer == 2
    x1 = 1;
    x2 = 32;
elseif layer == 3 
    x1 = 1;
    x2 = 16;
elseif layer ==4
    x1 = 1;
    x2 = 8;    
end;



munits = Model.multiple.numMap(layer);

indexesTrain = [];
indexesTest = [];
for i = 1:3
    indexesTrain( ((i-1)*100)+1 : (i*100)) = i;
    indexesTest( ((i-1)*110)+1 : (i*110)) = i;
end;


for t = 1:length(typeSet)
    type = typeSet{t};
    for k = 1:length(dataset)
        if pipeline == 1 
            if k == 1
                lenData = 300;
            else k == 2 
                lenData = 330;
            end
        elseif pipeline == 3
            if k == 1
                lenData = 100;
            else k == 2 
                lenData = 110;
            end
        end;
        %samples

        %% PCA
        if strcmp(type,'pca') && k == 1
            data = [];
            for i = 1:3
                if layer == 1
                    data = [data; SamplesTrain.data(indexesTrain == i,:) ];
                else
                    for i2 = 1:3
                        data = [data; DeepSOM{i,layer-1}.BMUsValuesTrain(indexesTrain == i2,:) ];
                    end;
                end;
            end;
            for i = 1:3
                if layer == 1
                    data = [data; SamplesTest.data(indexesTest == i,:) ];
                else
                    for i2 = 1:3
                        data = [data; DeepSOM{i,layer-1}.BMUsValuesTest(indexesTest == i,:) ];
                    end;
                end;
            end;
            for i = 1:3
                data = [data; DeepSOM{i,layer}.sMap.codebook ];
            end;
            dataPCA = ExecutePCA(data',2)';

            if layer == 1
                SamplesTrain.data(indexesTrain == 1,1:2) = dataPCA(1:100,:);
                SamplesTrain.data(indexesTrain == 2,1:2) = dataPCA(101:200,:);
                SamplesTrain.data(indexesTrain == 3,1:2) = dataPCA(201:300,:);
                SamplesTest.data(indexesTest == 1,1:2) = dataPCA(301:410,:);
                SamplesTest.data(indexesTest == 2,1:2) = dataPCA(411:520,:);
                SamplesTest.data(indexesTest == 3,1:2) = dataPCA(521:630,:);
            else
                DeepSOM{1,layer-1}.BMUsValuesTrain(1:300,1:2) = dataPCA(1:300,:);
                DeepSOM{2,layer-1}.BMUsValuesTrain(1:300,1:2) = dataPCA(301:600,:);
                DeepSOM{3,layer-1}.BMUsValuesTrain(1:300,1:2) = dataPCA(601:900,:);
                DeepSOM{1,layer-1}.BMUsValuesTest(1:330,1:2) = dataPCA(901:1230,:);
                DeepSOM{2,layer-1}.BMUsValuesTest(1:330,1:2) = dataPCA(1231:1560,:);
                DeepSOM{3,layer-1}.BMUsValuesTest(1:330,1:2) = dataPCA(1561:1890,:);            
            end;

            if layer == 1
                DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(631:662,:);
                DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(663:694,:);
                DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(695:726,:);
            elseif layer == 2
                DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(1891:1906,:);
                DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(1907:1922,:);
                DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(1923:1938,:);  
            elseif  layer == 3     
                DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(1891:1898,:);
                DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(1899:1906,:);
                DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(1907:1914,:);         
            elseif  layer == 4     
                DeepSOM{1,layer}.sMap.codebook(:,1:2) = dataPCA(1891:1894,:);
                DeepSOM{2,layer}.sMap.codebook(:,1:2) = dataPCA(1895:1898,:);
                DeepSOM{3,layer}.sMap.codebook(:,1:2) = dataPCA(1899:1902,:);  
            end;

        end;



        for n =1:pipeline
            for m = 1:pipeline
                for i = ((n-1)*lenData)+1:(n*lenData)
                    if layer == 1
                        if i <= 100
                            category = 1;
                             color = 'red';
                        elseif i > 100 && i <= 200        
                            category = 2;
                             color = 'green';
                        elseif i > 200
                            category = 3;
                             color = 'blue';
                        end;
                    else
                        if m == 1
                            color = 'red';
                        elseif m == 2        
                            color = 'green';
                        elseif m == 3
                            color = 'blue';
                        end;
                    end;

                    if layer == 1
                        x = SamplesTrain.data(i,:);
                    else
                        if k == 1
                            x = DeepSOM{m,layer-1}.BMUsValuesTrain(i,:);
                        else k == 2
                            x = DeepSOM{m,layer-1}.BMUsValuesTest(i,:);
                        end;
                    end;

                    normTrain(i) = norm(x);
                    lenX = length(x);
                    reference = zeros(lenX,1);
                    reference(1) = 1;
                    cosTheta(i) = dot(x,reference)/(norm(x)*norm(reference));
                    senTheta(i) = sqrt( 1 - cosTheta(i)^2 );

                    if strcmp(dataset{k},'train')
                        correct = Model.test.layer{layer+1}.macthesDensityTrain{1,1}(1,:);
                    elseif strcmp(dataset{k},'test')
                        correct = Model.test.layer{layer+1}.macthesDensityTest{1,1}(1,:);
                    end;

                    if strcmp(type,'polar')
                        if correct(i) == 1
                            scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i), 20, color);
                        else
                            scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i), 20, color, '*');
                        end;
                    elseif strcmp(type,'x1x2')
                        if correct(i) == 1
                            scatter(x(x1), x(x2), 20, color);
                        else
                            scatter(x(x1), x(x2), 20, color, '*');
                        end;  
                    elseif strcmp(type,'pca')    
                        if correct(i) == 1
                            scatter(x(1), x(2), 20, color);
                        else
                            scatter(x(1), x(2), 20, color, '*');
                        end;          
                    end;

                    %axis([0 6 0 6])
                    hold on;    
                end;
            end;



            % centers
            for j = 1:3
                for i = 1:munits
                    if j == 1
                        category = 1;
                        color = 'red';
                    elseif j == 2        
                        category = 2;
                         color = 'green';
                    elseif j == 3
                        category = 3;
                        color = 'blue';
                    end;

                    x = DeepSOM{j,layer}.sMap.codebook(i,:);
                    normCenter(i) = norm(x);
                    lenX = length(x);
                    reference = zeros(lenX,1);
                    reference(1) = 1;
                    cosTheta(i) = dot(x,reference)/(norm(x)*norm(reference));
                    senTheta(i) = sqrt( 1 - cosTheta(i)^2 );
                    if strcmp(type,'polar')
                        scatter(norm(x)*cosTheta(i), norm(x)*senTheta(i),  150, color);
                    elseif strcmp(type,'x1x2')
                        scatter(x(x1), x(x2), 150, color);
                        if i > 1
                            line( [xOld(x1) x(x1)] , [xOld(x2) x(x2)] , 'Color', color);
                        end;
                        xOld = x;
                    elseif strcmp(type,'pca')
                        scatter(x(1), x(2), 150, color);
                        if i > 1
                            line( [xOld(1) x(1)] , [xOld(2) x(2)] , 'Color', color);
                        end;
                        xOld = x;
                    end;
                    hold on;
                end;
            end;

            title([dataset{k} ' - layer ' num2str(layer) ' - category ' num2str(n)])
            %axis([0 0 4 10])
            %xlabel('Polar')
            %legend('cat 1','cat 2','cat 3')
            set(gcf, 'Position', get(0, 'Screensize'));
            saveas( gcf, [ 'logs\plot_data_end\' type '\' dataset{k} '\layer_' num2str(layer) '_cat_' num2str(n) '_' dataset{k} '.png']  );
            hold off;

        end;

    end;

end;