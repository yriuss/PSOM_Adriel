% Marcondes Ricarte

function [cosine, near] = calculateMatrixCos(Model, DeepSOM, layer, threshold, simetry)

    cosines = [];
    near.cat1 = [];
    near.cat2 = [];
    near.node1 = [];
    near.node2 = [];
    near.score = [];
    %threshold = Model.multiple.centersThreshold(layer);
    for k = 1:Model.multiple.numToyProblem
        for k2 = 1:Model.multiple.numToyProblem
            for k3 = 1:Model.multiple.numMap(layer)
                for k4 = 1:Model.multiple.numMap(layer)
                    if k == k2 & k <= k2 
                        cosine{k,k2}(k3,k4) = 0;
                    else
                        if strcmp(simetry, 'full')
                            cosine{k,k2}(k3,k4) = getCosineSimilarity( DeepSOM{k,layer}.sMap.codebook(k3,:), DeepSOM{k2,layer}.sMap.codebook(k4,:) );
                        elseif  strcmp(simetry, 'part')
                            if k3 >= k4
                                cosine{k,k2}(k3,k4) = 0;
                            else
                                cosine{k,k2}(k3,k4) = getCosineSimilarity( DeepSOM{k,layer}.sMap.codebook(k3,:), DeepSOM{k2,layer}.sMap.codebook(k4,:) );
                            end;                            
                        end;
                    end;
                    if cosine{k,k2}(k3,k4) > threshold
                        near.cat1 = [near.cat1 k];
                        near.cat2 = [near.cat2 k2];
                        near.node1 = [near.node1 k3];
                        near.node2 = [near.node2 k4];
                        near.score = [near.score cosine{k,k2}(k3,k4)];
                    end;
                end;
            end;
        end;
    end;

end
