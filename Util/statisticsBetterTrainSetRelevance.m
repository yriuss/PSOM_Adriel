% Marcondes Ricarte

function [meanScoreSetRelevanceTrain, meanScoreSetRelevanceTest, stdScoreSetRelevanceTrain, stdScoreSetRelevanceTest] = ...
    statisticsBetterTrainSetRelevance(Model, relevanceTrain, relevanceTest, i, type)

     if strcmp(type,'better_train')
         for k = 1:Model.multiple.numTest(i) 
            maxval = max(relevanceTrain(k,:));
            if ~isnan(maxval)
                indexTestSetRelevance(k) = find(relevanceTrain(k,:)==maxval,1,'last');
            else
              indexTestSetRelevance(k) = NaN;
            end
         end;
     elseif strcmp(type,'better_test')
         [~,indexTestSetRelevance] = max(relevanceTest');
     end;
     
     resultSelectTrain = [];
     resultSelectTest = [];
     for k = 1:Model.multiple.numTest(i)
         if ~isnan(indexTestSetRelevance(k)) || ~isnan(indexTestSetRelevance(k))
             resultSelectTrain = [resultSelectTrain relevanceTrain(k,indexTestSetRelevance(k))];
             resultSelectTest = [resultSelectTest relevanceTest(k,indexTestSetRelevance(k))];
         else
             resultSelectTrain = [resultSelectTrain NaN];
             resultSelectTest = [resultSelectTest NaN];             
         end;
     end;
     meanScoreSetRelevanceTrain = nanmean(resultSelectTrain);
     meanScoreSetRelevanceTest = nanmean(resultSelectTest);
     stdScoreSetRelevanceTrain = nanstd(resultSelectTrain);
     stdScoreSetRelevanceTest = nanstd(resultSelectTest); 

end