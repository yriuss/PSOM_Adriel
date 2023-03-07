% Marcondes Ricarte

clear all;

datasets = {'iris', 'motion_tracking'};
categories = [3,6];


for dataset = 1:1%length(datasets)
    
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\instantaneous.mat']);
    DeepSOMInstantaneous = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\more.mat']);
    DeepSOMBigger = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\equals.mat']);
    DeepSOMEquals = DeepSOM;
    load(['C:\Doutorado\PSOM\Viewer\relevancies_dynamic\data\' datasets{dataset}  '\smaller.mat']);
    DeepSOMSmaller = DeepSOM;

        


    for cat = 1:length(categories)

        for order = 1:2
        
            subplot(4,1,1)
            if order == 1
                stem(DeepSOMInstantaneous{1,1}.relevance(categories(cat),:), 'MarkerSize', 1);
            elseif order == 2
                stem(sort(DeepSOMInstantaneous{1,1}.relevance(categories(cat),:)), 'MarkerSize', 1);
            end;
            axis([0 5 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos e taxa das relevâncias descorrelacionadas')
            subplot(4,1,2)
            stem(DeepSOMBigger{1,1}.relevance(categories(cat),:), 'MarkerSize', 1);   
            axis([0 5 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos << taxa das relevâncias')     
            subplot(4,1,3)
            stem(DeepSOMEquals{1,1}.relevance(categories(cat),:), 'MarkerSize', 1);   
            axis([0 5 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos == taxa das relevâncias')      
            subplot(4,1,4)
            stem(DeepSOMSmaller{1,1}.relevance(categories(cat),:), 'MarkerSize', 1);   
            axis([0 5 0 1])
            xlabel('Atributos')
            xlabel('Relevâncias')
            title('Taxa dos pesos >> taxa das relevâncias')         
    
            set(gcf, 'Position', [0 0 2000 500]);
    
            saveas(gcf, ['plots\' datasets{dataset} '\cat_' categories(cat) '.png' ])
        
        end;
    end;

end;