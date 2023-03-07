% Marcondes Ricarte

function [Model, DeepSOM, scores] = computeSetSaturationRelevance(Model, DeepSOM, layer, train_labels, test_labels, r, scores)

    nodes = zeros(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    [~,dim] = size(DeepSOM{1,layer-1}.BMUsValuesTrain);
    nodeFlag = zeros(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    nodesAccount = ones(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    epochMax = max(Model.multiple.setRelevance);
    epochCompute = 1;
    DeepSOMCopy = DeepSOM;
    
    if dim < epochMax
        epochMax = dim;
    end;
    
    % Set Maior
    for epoch = 1:epochMax         
        nodes = zeros(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
        for sample = 1:length(train_labels)
            category = train_labels(sample);
            x = DeepSOM{category,layer-1}.BMUsValuesTrain(sample,:);
            Dx = (DeepSOM{category,layer}.sMap.codebook(:,:) - x);
            [~,node] =  min(sum( (DeepSOM{category,layer}.relevance') .* (Dx'.^2) ) );
            nodes(category, node) = 1;
        end;


        for pipeline = 1:Model.multiple.numToyProblem
            for node = 1:Model.multiple.numMap(layer)
                if nodes(pipeline,node) == 1
                    [~,relevanceSort] = sort(DeepSOM{pipeline,layer}.relevance(node,:),'descend');
                    DeepSOM{pipeline,layer}.relevance(node,relevanceSort(nodesAccount(pipeline,node))) = 1;
                    nodesAccount(pipeline,node) = nodesAccount(pipeline,node) + 1;
                end;
            end;
        end;   
            
        
       [epochCompute, scores] = evaluateRelevance(Model, DeepSOM, layer, train_labels, test_labels, [], r, epoch, epochCompute, scores);
        
    end;

end