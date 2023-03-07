% Marcondes Ricarte

function [Model, DeepSOM, scores] = computeSetVarianceDistanceRelevance(Model, DeepSOM, layer, train_labels, test_labels, dataSelected, secondRule, r, scores)

    [~,dim] = size(DeepSOM{1,layer-1}.BMUsValuesTrain);
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
            for node = 1:Model.multiple.numMap(layer)
                if strcmp(dataSelected,'category')
                    distances{pipeline, node} = mean( abs (DeepSOM{pipeline,layer-1}.BMUsValuesTrain(find(train_labels==pipeline),:) - DeepSOM{pipeline,layer}.relevance(node,:)  ) );
                elseif strcmp(dataSelected,'all')
                    distances{pipeline, node} = mean( abs (DeepSOM{pipeline,layer-1}.BMUsValuesTrain - DeepSOM{pipeline,layer}.relevance(node,:)  ) );
                end;
            end;
        end;
        
        for pipeline = 1:Model.multiple.numToyProblem
            for node = 1:Model.multiple.numMap(layer)
                if strcmp(secondRule,'relevance')
                    meanRelevance = mean(DeepSOM{pipeline,layer}.relevance(node, find(nodePipelineFlag{pipeline}(node,:) == 0)  ));
                    ativeRelevance = (DeepSOM{pipeline,layer}.relevance(node,:) <= meanRelevance) & (nodePipelineFlag{pipeline}(node,:) == 0);
                    distances{pipeline, node} = ativeRelevance.*distances{pipeline, node};
                end;
                [~,distanceSort{pipeline, node}] = sort(distances{pipeline, node}, 'descend' );
                flag = 0;
                for attributes = 1:dim
                    if flag == 0 
                        if nodePipelineFlag{pipeline}(node,distanceSort{pipeline, node}(attributes)) == 0
                            DeepSOM{pipeline,layer}.relevance(node,distanceSort{pipeline, node}(attributes) ) = 0;
                            nodePipelineFlag{pipeline}(node,distanceSort{pipeline, node}(attributes)) = 1;
                            flag = 1;
                        end;
                    end;
                end;
            end;
        end;  
        
      [epochCompute, scores] = evaluateRelevance(Model, DeepSOM, layer, train_labels, test_labels, [], r, epoch, epochCompute, scores);
          
    end;
    
end
    