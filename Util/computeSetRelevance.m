% Marcondes Ricarte

function [Model, DeepSOM] = computeSetRelevance(Model, DeepSOM, layer, train_labels, test_labels, r)

    
    % Set Ratio
    if r == 1
        Model.test.layer{layer+1}.scores.setRel = [];
        Model.test.layer{layer+1}.scores.setBiggerRatioRel = [];
        Model.test.layer{layer+1}.scores.setSmallerRatioRel = [];
        Model.test.layer{layer+1}.scores.setVarianceDistanceCatRel = [];
        Model.test.layer{layer+1}.scores.setVarianceDistanceAllRel = []; 
        Model.test.layer{layer+1}.scores.setVarianceDistanceCatSecondRuleRel = [];
        Model.test.layer{layer+1}.scores.setVarianceDistanceAllSecondRuleRel = [];
    end;

    [~,  ~, Model.test.layer{layer+1}.scores.setRel] = ...
        computeSetSaturationRelevance(Model, DeepSOM, layer, train_labels, test_labels, r, Model.test.layer{layer+1}.scores.setRel);   
    [~,  ~, Model.test.layer{layer+1}.scores.setBiggerRatioRel] = ...
        computeSetRatioRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'bigger', r, Model.test.layer{layer+1}.scores.setBiggerRatioRel);
    [~,  ~, Model.test.layer{layer+1}.scores.setSmallerRatioRel] = ...
        computeSetRatioRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'smaller', r, Model.test.layer{layer+1}.scores.setSmallerRatioRel);
    [~,  ~, Model.test.layer{layer+1}.scores.setVarianceDistanceCatRel] = ...
        computeSetVarianceDistanceRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'category','no', r, Model.test.layer{layer+1}.scores.setVarianceDistanceCatRel);
    [~,  ~, Model.test.layer{layer+1}.scores.setVarianceDistanceAllRel] = ...
        computeSetVarianceDistanceRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'all','no', r,  Model.test.layer{layer+1}.scores.setVarianceDistanceAllRel);
    [~,  ~, Model.test.layer{layer+1}.scores.setVarianceDistanceCatSecondRuleRel] = ...
        computeSetVarianceDistanceRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'category','relevance', r, Model.test.layer{layer+1}.scores.setVarianceDistanceCatSecondRuleRel);
    [~,  ~, Model.test.layer{layer+1}.scores.setVarianceDistanceAllSecondRuleRel] = ...
        computeSetVarianceDistanceRelevance(Model, DeepSOM, layer, train_labels, test_labels, 'all','relevance', r, Model.test.layer{layer+1}.scores.setVarianceDistanceAllSecondRuleRel);

    
end
