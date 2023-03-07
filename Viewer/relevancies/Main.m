% Marcondes Ricarte

clear all;

dataset = 'ionosphere';  % '15_Scenes', 'iris', 'ionosphere', 'motion_tracking'

if strcmp(dataset, 'iris')
    load('dataTrain_iris.mat');
    load('relevanciesGRLVQ.mat');
    categories = 3;
    selected = 2;
    markerSize = 5;
elseif strcmp(dataset, '15_Scenes')
    load('dataTrain_15_Scenes.mat');    
    categories = 15;
    selected = 20;
    markerSize = 1;
elseif strcmp(dataset, 'ionosphere')
    load('dataTrain_ionosphere.mat');
    load('relevanciesGRLVQIonosphere.mat');
    categories = 2;
    selected = 5;
    markerSize = 1;
elseif strcmp(dataset, 'motion_tracking')
    load('dataTrain_motion_tracking.mat');
    categories = 6;
    selected = 10;
    markerSize = 1;
end;



dataTrain = SamplesTrain.data;
[samples, dim] = size(dataTrain);



for cat = 1:categories
    means(cat,:) = mean(dataTrain(train_labels==cat,:));
    relevancies(cat,:) = 1 - var(dataTrain(train_labels==cat,:));
end


relevanciesMean = mean(relevancies);
%corrcoef(relevancies)
relevaciesVar = var(relevancies);

for cat = 1:categories
    distancies(cat,:) = zeros(1,dim);
    correlations = corrcoef(relevancies);
    relevanciesDiff(cat,:) = abs( relevancies(cat,:) - relevanciesMean );
    for cat2 = 1:categories
        if cat ~= cat2
            distancies(cat,:) = distancies(cat,:) + abs(relevancies(cat,:) - relevancies(cat2,:) );            
        end;        
    end;
    distancies(cat,:) = distancies(cat,:) / (categories - 1);
end;

maxValue = max(means(:));
minRelevancies = min(relevancies(:));
minRelevanciesGRLVQ = min(relevanciesGRLVQ);
maxDistance = max(distancies(:));
maxRelevanciesVar = max(relevaciesVar);



for cat = 1:categories
    cat

    [~,maxIndexes] = sort(relevanciesGRLVQ, 'descend');
    [~,orderIndexes] = sort(relevanciesGRLVQ, 'descend');
    maxIndexes = maxIndexes(1,1:selected);

    subplot(4,1,1)
    stem(relevanciesGRLVQ, 'MarkerSize', markerSize)
    %hold on
    %stem(maxIndexes, relevanciesGRLVQ(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
    %hold off    
    ylabel('relevancies')
    xlabel('attributes')   
    title('relevancies GRLVQ')
    axis([0 dim+1 -1 1]) 

    subplot(4,1,2)
    stem(relevancies(cat,:), 'MarkerSize', markerSize)
    %hold on
    %stem(maxIndexes, relevancies(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
    %hold off
    ylabel('relevancies')
    xlabel('attributes')       
    title('1-variance')
    axis([0 dim+1 minRelevancies 1])

    subplot(4,1,3)
    stem(relevanciesGRLVQ(1,orderIndexes), 'MarkerSize', markerSize)
    %hold on
    %stem(maxIndexes, relevanciesGRLVQ(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
    %hold off    
    ylabel('relevancies')
    xlabel('attributes')   
    title('sort(relevancies GRLVQ)')
    axis([0 dim+1 -1 1]) 


    subplot(4,1,4)
    stem(relevancies(cat,orderIndexes), 'MarkerSize', markerSize)
    %hold on
    %stem(maxIndexes, relevancies(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
    %hold off
    ylabel('relevancies')
    xlabel('attributes')       
    title('sort(1-variance)')
    axis([0 dim+1 minRelevancies 1])

    sgtitle(['Cat ' num2str(cat)])

    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['plots\' dataset '\cat_ ' num2str(cat) '.png'])
end;









% % 
% % 
% % for cat = 1:categories
% %     cat
% % 
% %     [~,maxIndexes] = sort(relevaciesVar, 'descend');
% %     maxIndexes = maxIndexes(1,1:selected);
% % 
% %     subplot(2,1,1)
% %     stem(relevancies(cat,:), 'MarkerSize', markerSize)
% %     hold on
% %     stem(maxIndexes, relevancies(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
% %     hold off    
% %     ylabel('relevancies')
% %     xlabel('attributes')    
% %     axis([0 dim+1 minRelevancies 1]) 
% % 
% %     subplot(2,1,2)
% %     stem(relevaciesVar, 'MarkerSize', markerSize)
% %     hold on
% %     stem(maxIndexes, relevaciesVar(maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
% %     hold off
% %     ylabel('variance relevancies')
% %     xlabel('attributes')       
% %     axis([0 dim+1 0 maxRelevanciesVar])
% % 
% %     sgtitle(['Cat ' num2str(cat)])
% % 
% %     set(gcf, 'Position', get(0, 'Screensize'));
% %     saveas(gcf,['plots\' dataset '\cat_ ' num2str(cat) '.png'])
% % end;
% % 

% 
% for cat = 1:categories
% 
%     [~,maxIndexes] = sort(relevanciesDiff(cat,:), 'descend');
%     maxIndexes = maxIndexes(1,1:selected);
% 
%     subplot(categories,1,cat)
%     stem(relevanciesDiff(cat,:), 'MarkerSize', markerSize)
%     hold on
%     stem(maxIndexes, relevanciesDiff(cat,maxIndexes), 'MarkerSize', markerSize, 'Color', 'r')
%     hold off
%     ylabel('distance relevancies')
%     xlabel('attributes')       
%     axis([0 dim+1 0 maxDistance])
%  
%     sgtitle('distance relevancies')
% 
%     set(gcf, 'Position', get(0, 'Screensize'));
%     saveas(gcf,['plots\' dataset '\distanciesCategories.png'])
% end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % for cat = 1:categories
% %     cat
% % 
% %     [~,maxIndexes] = sort(distancies(cat,:), 'descend');
% %     maxIndexes = maxIndexes(1,1:selected);
% % 
% %     subplot(3,1,1)
% %     stem(means(cat,:), 'MarkerSize', 1)
% %     hold on
% %     stem(maxIndexes, means(cat,maxIndexes), 'MarkerSize', 1, 'Color', 'r')
% %     hold off       
% %     ylabel('mean')
% %     xlabel('attributes')
% %     axis([0 dim+1 0 maxValue]) 
% % 
% %     subplot(3,1,2)
% %     stem(relevancies(cat,:), 'MarkerSize', 1)
% %     hold on
% %     stem(maxIndexes, relevancies(cat,maxIndexes), 'MarkerSize', 1, 'Color', 'r')
% %     hold off    
% %     ylabel('relevancies')
% %     xlabel('attributes')    
% %     axis([0 dim+1 minRelevancies 1]) 
% % 
% %     subplot(3,1,3)
% %     stem(distancies(cat,:), 'MarkerSize', 1)
% %     hold on
% %     stem(maxIndexes, distancies(cat,maxIndexes), 'MarkerSize', 1, 'Color', 'r')
% %     hold off
% %     ylabel('distance relevancies')
% %     xlabel('attributes')       
% %     axis([0 dim+1 0 maxDistance])
% % 
% %     sgtitle(['Cat ' num2str(cat)])
% % 
% %     set(gcf, 'Position', get(0, 'Screensize'));
% %     saveas(gcf,['plots\' dataset '\cat_ ' num2str(cat) '.png'])
% % end;
% % 
% % 
% % 
% % for cat = 1:categories
% % 
% %     [~,maxIndexes] = sort(distancies(cat,:), 'descend');
% %     maxIndexes = maxIndexes(1,1:selected);
% % 
% %     subplot(categories,1,cat)
% %     stem(distancies(cat,:), 'MarkerSize', 1)
% %     hold on
% %     stem(maxIndexes, distancies(cat,maxIndexes), 'MarkerSize', 1, 'Color', 'r')
% %     hold off
% %     ylabel('distance relevancies')
% %     xlabel('attributes')       
% %     axis([0 dim+1 0 maxDistance])
% %  
% %     sgtitle('distance relevancies')
% % 
% %     set(gcf, 'Position', get(0, 'Screensize'));
% %     saveas(gcf,['plots\' dataset '\distanciesCategories.png'])
% % end;