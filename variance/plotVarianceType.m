clear all;

dataset = 'vgg';

if strcmp(dataset,'wine')
    load('data_plot_wine.mat')
    worst1 = 12;
    worst2 = 13;    
elseif strcmp(dataset,'sift')    
    load('data_plot_15scenes_sift.mat')
    worst1 = 4199;
    worst2 = 4200;
elseif strcmp(dataset,'vgg')    
    load('data_plot_15scenes_vgg.mat')
    worst1 = 4095;
    worst2 = 4096;            
end;

layer = 1;

better1 = 1;
better2 = 2;


type = 'inter_pipeline_binary'; % 'intra', 'inter_pipeline', 'inter_pipeline_binary'
mult = 'yes'; % 'no', 'yes'
norm = 'yes'; % 'no', 'yes'


colors = {rgb('Red'), rgb('Pink'), rgb('Orange'), rgb('Yellow'), rgb('Brown'), ...
    rgb('Green'), rgb('Blue'), rgb('Purple'), rgb('Gray'), rgb('Black'), ...
    rgb('DarkOliveGreen'), rgb('MidnightBlue'), rgb('Violet'), rgb('DarkMagenta'), rgb('RosyBrown')};

% Sub-Intra
% % if strcmp(type,'sub_intra') 
% %     dataTrain = [];
% %     for i = 1:Model.multiple.numToyProblem
% %         selectedTrain = find( (train_labels == i) );
% %         dataTrain{i} =  [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];        
% %         intra(i,:) = 1 - var(dataTrain{i}); 
% %         [sorts(i,:),varianceSortIndexes(i,:)] = sort(intra(i,:),'descend');
% %     end;
% % end;

% Intra
if strcmp(type,'intra') ||  strcmp(mult,'yes')
    dataTrain = [];
    for i = 1:Model.multiple.numToyProblem
        selectedTrain = find( (train_labels == i)  );
        dataTrain{i} =  [DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)];        
        intra(i,:) = 1 - var(dataTrain{i}); 
        [sorts(i,:),varianceSortIndexes(i,:)] = sort(intra(i,:),'descend');
    end;
end;

%inter_pipeline
if strcmp(type,'inter_pipeline')
    for i = 1:Model.multiple.numToyProblem
         dataTrain{i} = [];
        for j = 1:Model.multiple.numToyProblem
            selectedTrain = find( (train_labels == j)  );
            dataTrain{i} =  [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:))]; 
        end;
        inter(i,:) = var(dataTrain{i});
        [sorts(i,:),varianceSortIndexes(i,:)] = sort(inter(i,:),'descend');
    end;    
end;


%inter_pipeline_binary
if strcmp(type,'inter_pipeline_binary')
    dataTrain = [];
    dataTrainCat = [];
    for i = 1:Model.multiple.numToyProblem
        dataTrain{i} = [];                    
        for j = 1:Model.multiple.numToyProblem
            selectedTrain = find( (train_labels == j)  );
            if i ~= j
                dataTrain{i} = [dataTrain{i}; mean(DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:)) ];     
            else
                selectedTrain = find( train_labels == j );
                dataTrainCat{i} = DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain,:);
            end;
        end;
        inter(i,:) = varBinary(dataTrain{i}, mean(dataTrainCat{i}));
        [sorts(i,:),varianceSortIndexes(i,:)] = sort(inter(i,:),'descend');
    end;  
end;


% mult(intra, inter_pipeline)
if strcmp(mult,'yes')
    for i = 1:Model.multiple.numToyProblem
        if strcmp(norm,'no')
            variance = inter(i,:) .* intra(i,:);
        elseif strcmp(norm,'yes')
            interMin = min(inter(i,:));
            interMax = max(inter(i,:));
            interNorm = (inter(i,:) - interMin)/(interMax - interMin);
            intraMin = min(intra(i,:));
            intraMax = max(intra(i,:));
            intraNorm = (intra(i,:) - intraMin)/(intraMax - intraMin);  
            variance = interNorm .* intraNorm;
        end;
        [sorts(i,:),varianceSortIndexes(i,:)] = sort(variance,'descend');
    end;
end;


% plot better
for pipeline = 1:Model.multiple.numToyProblem
    for category = 1:Model.multiple.numToyProblem
        category
        selectedTrain = find( (train_labels == category)  );
        scatter( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain, varianceSortIndexes(pipeline,better1) ), ...
            DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain, varianceSortIndexes(pipeline,better2) ), ... 
            [], colors{category}, 'LineWidth', 2 );
        if category == 1
            hold on;
        end;
    end;
    hold off;
    title(['Better - Pipeline ' int2str(pipeline)])
    hold off;
    set(gcf, 'Position', get(0, 'Screensize'));
    legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15')
    saveas(gcf, ['Better - Pipeline ' int2str(pipeline) '.png'])
end;


% plot worst
for pipeline = 1:Model.multiple.numToyProblem
    for category = 1:Model.multiple.numToyProblem
        selectedTrain = find( (train_labels == category)  );
        scatter( DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain, varianceSortIndexes(pipeline,worst1) ), ...
            DeepSOM{i,layer}.BMUsValuesTrain(selectedTrain, varianceSortIndexes(pipeline,worst2) ), ... 
            [], colors{category}, 'LineWidth', 2  );
        if category == 1
            hold on;
        end;
    end;
    title(['Worst - Pipeline ' int2str(pipeline)])
    hold off;
    set(gcf, 'Position', get(0, 'Screensize'));
    legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15')
    saveas(gcf, ['Worst - Pipeline ' int2str(pipeline) '.png']);    
end;



