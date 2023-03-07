% Marcondes Ricarte

function [Model] = statisticsSetRelevance(Model, i)

     if strcmp(Model.multiple.freezeLayer{i},'no')  && strcmp(Model.multiple.flagRelevanceSet,'yes')

        [Model.test.layer{i+1}.scores.setRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setRel);
        
        [Model.test.layer{i+1}.scores.setBiggerRatioRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setBiggerRatioRel);
        
        [Model.test.layer{i+1}.scores.setSmallerRatioRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setSmallerRatioRel);
        
        [Model.test.layer{i+1}.scores.setVarianceDistanceCatRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setVarianceDistanceCatRel);
        
        [Model.test.layer{i+1}.scores.setVarianceDistanceAllRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setVarianceDistanceAllRel);
        
        [Model.test.layer{i+1}.scores.setVarianceDistanceCatSecondRuleRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setVarianceDistanceCatSecondRuleRel);
        
        [Model.test.layer{i+1}.scores.setVarianceDistanceAllSecondRuleRel] = statisticsBlockSetRelevance(Model, i, Model.test.layer{i+1}.scores.setVarianceDistanceAllSecondRuleRel);
        
     end;


end