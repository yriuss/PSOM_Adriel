% Marcondes Ricarte

function [nearBegin] = fitEstimateCos(Model, DeepSOMBegin, SamplesTrain, SamplesTest, layer)


    DeepSOM = DeepSOMBegin;    
    
    [cosine, nearBegin] = calculateMatrixCos(Model, DeepSOM, layer);    

    threshold = Model.multiple.centersThreshold(layer); % TODO
    for len = 1:length(nearBegin.cat1)
        alpha1 = 0.0001;
        alpha2 = 0.9;     
        
        cat1 = nearBegin.cat1(len);
        cat2 = nearBegin.cat2(len);
        node1 = nearBegin.node1(len); 
        node2 = nearBegin.node2(len);

        cosineMatrix = cosine{cat1, cat2}; 
        cosineNodes = cosineMatrix(node1,node2);        
        
        while abs(alpha1 - alpha2) >  0.001
            alpha = (alpha1 + alpha2)/2;
            
            DeepSOM = DeepSOMBegin; 

            Dx = (DeepSOMBegin{cat1,layer}.sMap.codebook(node1,:) - DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:));         
            DeepSOM{cat2,layer}.sMap.codebook(node2,:) = DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:) ...
                - alpha * DeepSOMBegin{cat2,layer}.relevance(node2,:)  .* Dx; %Unlearn   

            Dx = (DeepSOMBegin{cat2,layer}.sMap.codebook(node2,:) - DeepSOMBegin{cat1,layer}.sMap.codebook(node1,:));         
            DeepSOM{cat1,layer}.sMap.codebook(node1,:) = DeepSOMBegin{cat1,layer}.sMap.codebook(node1,:) ...
                - alpha * DeepSOMBegin{cat1,layer}.relevance(node1,:)  .* Dx; %Unlearn        

            [cosine, near] = calculateMatrixCos(Model, DeepSOM, layer);
            cosineMatrix = cosine{cat1, cat2}; 
            cosineNodes = cosineMatrix(node1,node2);        


            if cosineNodes < threshold
                alpha2 = alpha;
            elseif cosineNodes > threshold
                alpha1 = alpha;
            end;  
        
        end;
        
        nearBegin.alpha(len) =  alpha1;
        
    end;


end