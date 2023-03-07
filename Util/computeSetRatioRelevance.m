% Marcondes Ricarte

function [Model, DeepSOM, scores] = computeSetRatioRelevance(Model, DeepSOM, layer, train_labels, test_labels, order, r, scores)

    nodes = zeros(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    [~,dim] = size(DeepSOM{1,layer-1}.BMUsValuesTrain);
    nodeFlag = zeros(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    nodesAccount = ones(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
    epochMax = max(Model.multiple.setRelevance);
    epochCompute = 1;
    
    if dim < epochMax
        epochMax = dim;
    end;    
    
   
    for pipeline = 1:Model.multiple.numToyProblem
        nodesAccount = ones(Model.multiple.numToyProblem, Model.multiple.numMap(layer));
        nodePipelineFlag{pipeline} = zeros(Model.multiple.numMap(layer),dim);
    end;    
    for epoch = 1:epochMax
        for pipeline = 1:Model.multiple.numToyProblem
            nodesDimensionAcount{pipeline} = zeros(Model.multiple.numMap(layer),dim);
        end;
 

        for k=1:length(train_labels)
            % correct
            category = train_labels(k);
            x = DeepSOM{category,layer-1}.BMUsValuesTrain(k,:);
            Dx = (DeepSOM{category,layer}.sMap.codebook(:,:) - x);
            distance =  sum( (DeepSOM{category,layer}.relevance') .* (Dx'.^2) ) ;             
            [~,nodeCorrect(k)] = min(distance);
            % incorrect
            distanceErrorTrain = [];
            nodesErrorPipeline = [];
            category = train_labels(k);
            for k2=1:Model.multiple.numToyProblem
                x = DeepSOM{k2,layer-1}.BMUsValuesTrain(k,:);
                Dx = (DeepSOM{k2,layer}.sMap.codebook(:,:) - x);
                distance =  sum( (DeepSOM{k2,layer}.relevance') .* (Dx'.^2) ) ;                
                if k2 ~= train_labels(1,k)
                    [distanceErrorTrain] = [distanceErrorTrain min(distance)];
                    [~,node] = min(distance);
                    nodesErrorPipeline = [nodesErrorPipeline node];                    
                else
                    distanceErrorTrain = [distanceErrorTrain 1000];
                    nodesErrorPipeline = [nodesErrorPipeline 0];
                end;
            end;
            [~,pipelineError(k)] = min(distanceErrorTrain);
            nodesError(k) = nodesErrorPipeline(pipelineError(k));
            
            relevanceCorrect = DeepSOM{train_labels(k),layer}.relevance(nodeCorrect(k),:);
            relevanceIncorrect = DeepSOM{pipelineError(k),layer}.relevance(nodesError(k),:);
            ratioRelevance = relevanceCorrect./ relevanceIncorrect;
            ratioRelevance(find(nodePipelineFlag{train_labels(k)}(nodeCorrect(k),:))) = NaN;
            if strcmp(order,'bigger')                
                [~,maxRatioRelevanceIndex] = nanmax(ratioRelevance);
            elseif strcmp(order,'smaller')
                [~,maxRatioRelevanceIndex] = nanmin(ratioRelevance);               
            end;
            nodesDimensionAcount{train_labels(1,k)}(nodeCorrect(k),maxRatioRelevanceIndex) = ...
                nodesDimensionAcount{train_labels(1,k)}(nodeCorrect(k),maxRatioRelevanceIndex) + 1;
        end;   
        
        for pipeline = 1:Model.multiple.numToyProblem
            nodesAtive{pipeline} = sum(nodesDimensionAcount{pipeline}')';
        end;
        
        for pipeline = 1:Model.multiple.numToyProblem
            for node = 1:Model.multiple.numMap(layer)
                for attributes = 1:dim
                    if nodePipelineFlag{pipeline}(node,attributes) == 1
                        nodesDimensionAcount{pipeline}(node,attributes) = 1000;
                    end;
                end;
            end;
        end;
        
        for pipeline=1:Model.multiple.numToyProblem
            [nodesDimensionAcountSort{pipeline},~] = sort(nodesDimensionAcount{pipeline}','descend');
            nodesDimensionAcountSort{pipeline} = nodesDimensionAcountSort{pipeline}';
            [~,nodesDimensionAcountSortIndexes{pipeline}] = sort(nodesDimensionAcount{pipeline}','descend');
            nodesDimensionAcountSortIndexes{pipeline} = nodesDimensionAcountSortIndexes{pipeline}';            
        end;        
        
        for pipeline = 1:Model.multiple.numToyProblem
            for node = 1:Model.multiple.numMap(layer)
                if nodesAtive{pipeline}(node,1) > 0 
                    DeepSOM{pipeline,layer}.relevance(node, nodesDimensionAcountSortIndexes{pipeline}(node, nodesAccount(pipeline,node)  ) ) = 1;
                    nodePipelineFlag{pipeline}(node, nodesDimensionAcountSortIndexes{pipeline}(node, nodesAccount(pipeline,node)  ) ) = 1;
                    nodesAccount(pipeline,node) = nodesAccount(pipeline,node) + 1;                    
                end;
            end;
        end;
        
       [epochCompute, scores] = evaluateRelevance(Model, DeepSOM, layer, train_labels, test_labels, [], r, epoch, epochCompute, scores);
            
    end;
    
end
    