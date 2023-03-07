% Marcondes Ricarte

function [alpha, relevancesActives] = fitEstimate(Model, DeepSOMBegin, SamplesTrain, SamplesTest, layer, train_labels, test_labels, r, node, index, categoryError, nodeError, Dx, learnType, relevanceSelectionFunction)

    alpha = 0;
    alpha1 = 0.0001;
    alpha2 = 0.99;
    
    alpha1Log = [];
    alpha2Log = [];
    alpha3Log = [];
    
    [~,dim] = size(SamplesTrain.data);
    DeepSOM = DeepSOMBegin; 
    category = train_labels(index);   
    
    for pipeline = 1:Model.multiple.numToyProblem
        if layer == 1
            dataSamplesTrain.data = SamplesTrain.data;
        else
            dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
        end;
        DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance, index);            
    end;
    dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    relevanceUpdate = 'no'; % 'mean', 'mean_std'
    incorrectTarget = 'one'; % 'one', 'all'
    fator = 1;
    munits = Model.multiple.numMap(layer);
    type = 'relevance';  % 'relevance', 'distance';
    if strcmp(relevanceUpdate,'mean') || strcmp(relevanceUpdate,'mean_std')
% %         for cat = 1:Model.multiple.numToyProblem
% %             if layer == 1
% %                 relevances(cat,:) = 1 - var(SamplesTrain.data(train_labels == cat,:));
% %             else
% %                 relevances(cat,:) = 1 - var(DeepSOM{cat,layer-1}.BMUsValuesTrain(train_labels == cat,:));
% %             end;
% %         end;
        if strcmp(type,'relevance')
            if strcmp(incorrectTarget,'all') 
                for cat = 1:Model.multiple.numToyProblem
                    indexes = (cat-1)*munits + 1 : cat*munits;
                    [~,indexMax] = max(dataTrain(index,indexes)) ;
                    relevances(cat,:) =  DeepSOM{cat,layer}.relevance(indexMax,:);
                end;
            end;
            relevances(category,:) = DeepSOM{category,layer}.relevance(node,:);
            relevances(categoryError,:) = DeepSOM{categoryError,layer}.relevance(nodeError,:);
        elseif strcmp(type,'distance')
            if strcmp(incorrectTarget,'all') 
                for cat = 1:Model.multiple.numToyProblem
                    indexes = (cat-1)*munits + 1 : cat*munits;
                    [~,indexMax] = max(dataTrain(index,indexes)) ;
                    if layer == 1
                        relevances(cat,:) = 1 - abs( SamplesTrain.data(index,:) - DeepSOM{cat,layer}.sMap.codebook(indexMax,:) );
                    else
                        relevances(cat,:) = 1 - abs( DeepSOM{cat,layer-1}.BMUsValuesTrain(index,:) - DeepSOM{cat,layer}.sMap.codebook(indexMax,:) );
                    end;
                end;
            end;
            if layer == 1 
                relevances(category,:) = 1 - abs( SamplesTrain.data(index,:) - DeepSOM{category,layer}.sMap.codebook(node,:) ); 
                relevances(categoryError,:) = 1 -abs( SamplesTrain.data(index,:) - DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) );   
            else
                relevances(category,:) = 1 - abs( DeepSOM{category,layer-1}.BMUsValuesTrain(index,:) - DeepSOM{category,layer}.sMap.codebook(node,:) ); 
                relevances(categoryError,:) = 1 -abs( DeepSOM{categoryError,layer-1}.BMUsValuesTrain(index,:) - DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) );                   
            end;
        end;

        if  strcmp(relevanceUpdate,'mean')
            if strcmp(learnType, 'learn')
                relevancesCorrectMean = mean( relevances(category,:) );
            elseif strcmp(learnType, 'unlearn')
                relevancesCorrectMean = mean( relevances(categoryError,:) );
            end;
        elseif  strcmp(relevanceUpdate,'mean_std')
            if strcmp(learnType, 'learn')
                relevancesCorrectMean = mean( relevances(category,:) ) + fator * std( relevances(category,:) );
            elseif strcmp(learnType, 'unlearn')
                relevancesCorrectMean = mean( relevances(categoryError,:) ) + fator * std( relevances(categoryError,:) );
            end;
        end;
        if strcmp(learnType, 'learn')
            relevancesCorrect = (relevances(category,:) < relevancesCorrectMean);
        elseif strcmp(learnType, 'unlearn')
            relevancesCorrect = (relevances(categoryError,:) < relevancesCorrectMean);
        end;
        
        
        if  strcmp(relevanceUpdate,'mean')
            if strcmp(learnType, 'learn')
                if strcmp(incorrectTarget, 'one')
                    relevancesIncorrectMean = mean( relevances(categoryError,:) );
                elseif  strcmp(incorrectTarget, 'all')
                    for cat = 1:Model.multiple.numToyProblem
                        if cat ~= category
                            relevancesIncorrectMeans(cat) = mean( relevances(cat,:) );
                        end;
                    end;
                end;
            elseif strcmp(learnType, 'unlearn')
                if strcmp(incorrectTarget, 'one')
                    relevancesIncorrectMean = mean( relevances(category,:) );
                elseif  strcmp(incorrectTarget, 'all')
                    for cat = 1:Model.multiple.numToyProblem
                        if cat ~= categoryError
                            relevancesIncorrectMeans(cat) = mean( relevances(cat,:) );
                        end;
                    end;
                end;
            end;
        elseif  strcmp(relevanceUpdate,'mean_std')
            if strcmp(learnType, 'learn')
                if strcmp(incorrectTarget, 'one')
                    relevancesIncorrectMean = mean( relevances(categoryError,:) ) - fator * std( relevances(categoryError,:) );
                elseif  strcmp(incorrectTarget, 'all')
                    for cat = 1:Model.multiple.numToyProblem
                        if cat ~= category
                            relevancesIncorrectMeans(cat,:) = mean( relevances(cat,:) ) - fator * std( relevances(cat,:) );
                        end;
                    end;
                end;                
            elseif strcmp(learnType, 'unlearn')
                if strcmp(incorrectTarget, 'one')
                    relevancesIncorrectMean = mean( relevances(category,:) ) - fator * std( relevances(category,:) );
                elseif  strcmp(incorrectTarget, 'all')
                    for cat = 1:Model.multiple.numToyProblem
                        if cat ~= categoryError
                            relevancesIncorrectMeans(cat,:) = mean( relevances(cat,:) ) - fator * std( relevances(cat,:) );
                        end;
                    end;
                end; 
            end;
        end
        
        if strcmp(learnType, 'learn')
            if strcmp(incorrectTarget, 'one')
                relevancesIncorrect = (relevances(categoryError,:) > relevancesIncorrectMean);
            elseif  strcmp(incorrectTarget, 'all')            
                for cat = 1:Model.multiple.numToyProblem
                    if cat ~= category
                        relevancesIncorrects(cat,:) = (relevances(cat,:) > relevancesIncorrectMeans(cat));                   
                    end;
                end;
            end;      
        elseif strcmp(learnType, 'unlearn')
            if strcmp(incorrectTarget, 'one')
                relevancesIncorrect = (relevances(category,:) > relevancesIncorrectMean);
            elseif  strcmp(incorrectTarget, 'all')            
                for cat = 1:Model.multiple.numToyProblem
                    if cat ~= categoryError
                        relevancesIncorrects(cat,:) = (relevances(cat,:) > relevancesIncorrectMeans(cat));                   
                    end;
                end;
            end;              
        end;
        
        if strcmp(incorrectTarget, 'all')
            relevancesIncorrect = ones(1,dim);
            if strcmp(learnType, 'learn')
                for cat = 1:Model.multiple.numToyProblem
                    if cat ~= category
                         relevancesIncorrect = relevancesIncorrect .* relevancesIncorrects(cat,:);
                    end;
                end;
            elseif strcmp(learnType, 'unlearn')
                for cat = 1:Model.multiple.numToyProblem
                    if cat ~= categoryError
                         relevancesIncorrect = relevancesIncorrect .* relevancesIncorrects(cat,:);
                    end;
                end;                
            end;
        end;
        
        relevancesActives = relevancesCorrect & relevancesIncorrect;
    else
        [~,dim] = size(SamplesTrain.data);
        relevancesActives = ones(1,dim);
    end;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    correct3 = 0;
    while ((abs(alpha1 - alpha2) >  0.01 ) || (correct3 == 0)) && alpha1 < 0.98
        
       
        alpha3 = (alpha1 + alpha2)/2;              
        DeepSOM = DeepSOMBegin;     
        
   
        
        if strcmp(learnType,'learn')
            if strcmp(relevanceSelectionFunction{layer},'no')
                DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                    + alpha3 * relevancesActives .* DeepSOM{category,layer}.relevance(node,:)  .* Dx; %Learn 
            elseif strcmp(relevanceSelectionFunction{layer},'binary')
                DeepSOM{category,layer}.sMap.codebook(node,:) = DeepSOM{category,layer}.sMap.codebook(node,:) ...
                    + alpha3 * relevancesActives .* Dx; %Learn                 
            end;
        elseif strcmp(learnType,'unlearn')
            if strcmp(relevanceSelectionFunction{layer},'no')
                DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) = DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) ...
                    - alpha3 * relevancesActives .* DeepSOM{categoryError,layer}.relevance(nodeError,:)  .* Dx; %Unlearn 
            elseif strcmp(relevanceSelectionFunction{layer},'binary') 
                DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) = DeepSOM{categoryError,layer}.sMap.codebook(nodeError,:) ...
                    - alpha3 * relevancesActives .* Dx; %Unlearn 
            end;
        end;
        for pipeline = 1:Model.multiple.numToyProblem
            if layer == 1
                dataSamplesTrain.data = SamplesTrain.data;
            else
                dataSamplesTrain.data = DeepSOM{pipeline,layer-1}.BMUsValuesTrain;
            end;
            DeepSOM{pipeline,layer}.BMUsValuesTrain = som_bmusdeep(DeepSOM{pipeline,layer}.sMap, dataSamplesTrain, 'ALL',pipeline,Model.multiple.sigmaAtive(layer), Model,[],Model.multiple.distanceType(layer),layer,DeepSOM{pipeline,layer}.relevance, index);            
        end;
        dataTrain = concatPipelines(Model, DeepSOM, layer, 'train', Model.multiple.numToyProblem);
        
        
        
        

        range = (category-1)*munits + node;        
        maxCorrect = dataTrain(index, range);
        range = (categoryError-1)*munits + nodeError;
        scoreIndex = dataTrain(index, range);
         
        correct3 = maxCorrect > scoreIndex;
        alpha1Log = [alpha1Log alpha1];
        alpha2Log = [alpha2Log alpha2];
        alpha3Log = [alpha3Log alpha3];
        
        if correct3 == 0
            alpha1 = alpha3;
        elseif correct3 == 1
            alpha2 = alpha3;
        end;
        
    end;

    if alpha1 > 0.98        
        relevancesActives = ones(1,dim);  
        alpha = 0;
    else
        alpha = alpha2;
    end;
    
    
    
end