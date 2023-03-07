% Marcondes Ricarte

clear all;

datasets = {'iris', 'motion_tracking'};
categories = [3,6];
attributes = [4,561]

for dataset = 1:length(datasets)
    
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\instantaneous.mat']);
    DeepSOMInstantaneous = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\more.mat']);
    DeepSOMBigger = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\equals.mat']);
    DeepSOMEquals = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\smaller.mat']);
    DeepSOMSmaller = DeepSOM;

        
    for cat = 1:categories(dataset)

        for order = 1:2
        
            subplot(4,1,1)
            if order == 1
                stem(DeepSOMInstantaneous{1,1}.relevance(cat,:), 'MarkerSize', 1, 'LineWidth',2);
            elseif order == 2
                stem(sort(DeepSOMInstantaneous{1,1}.relevance(cat,:)), 'MarkerSize', 1, 'LineWidth',2);
            end;
            axis([0 (attributes(dataset)+1) 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos e taxa das relevâncias descorrelacionadas')
            subplot(4,1,2)
            if order == 1
                stem(DeepSOMBigger{1,1}.relevance(cat,:), 'MarkerSize', 1, 'LineWidth',2);
            elseif order == 2
                stem(sort(DeepSOMBigger{1,1}.relevance(cat,:)), 'MarkerSize', 1, 'LineWidth',2);
            end;            
            axis([0 (attributes(dataset)+1) 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos << taxa das relevâncias')     
            subplot(4,1,3)
            if order == 1
                stem(DeepSOMEquals{1,1}.relevance(cat,:), 'MarkerSize', 1, 'LineWidth',2);
            elseif order == 2
                stem(sort(DeepSOMEquals{1,1}.relevance(cat,:)), 'MarkerSize', 1, 'LineWidth',2);
            end;              
            axis([0 (attributes(dataset)+1) 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos == taxa das relevâncias')      
            subplot(4,1,4)
            if order == 1
                stem(DeepSOMSmaller{1,1}.relevance(cat,:), 'MarkerSize', 1, 'LineWidth',2);
            elseif order == 2
                stem(sort(DeepSOMSmaller{1,1}.relevance(cat,:)), 'MarkerSize', 1, 'LineWidth',2);
            end;             
            axis([0 (attributes(dataset)+1) 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos >> taxa das relevâncias')         
    
            sgtitle(['Cat ' num2str(cat) ])

            set(gcf, 'Position', get(0, 'Screensize'));
    
            if order == 1
                saveas(gcf, ['plots\' datasets{dataset} '\cat_' num2str(cat) '.png' ])
            elseif order == 2
                saveas(gcf, ['plots\' datasets{dataset} '\cat_sort_' num2str(cat) '.png' ])
            end;
        
        end;
    end;

end;