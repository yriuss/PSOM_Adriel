
if layer ==1
    for j=1:3
        DeepSOM{j,2}.BMUsValuesTrain =  DeepSOM{j,1}.BMUsValuesTrain;
        DeepSOM{j,2}.BMUsValuesTest =  DeepSOM{j,1}.BMUsValuesTest;
        DeepSOM{j,2}.sMap.codebook =  DeepSOM{j,1}.sMap.codebook;
        DeepSOM{j,1}.BMUsValuesTrain = SamplesTrain.data;
        DeepSOM{j,1}.BMUsValuesTest = SamplesTest.data;
    end;
end;

if layer ==3
    for j=1:3
        DeepSOM{j,1}.BMUsValuesTrain = DeepSOM{j,2}.BMUsValuesTrain;
        DeepSOM{j,1}.BMUsValuesTest = DeepSOM{j,2}.BMUsValuesTest;
        DeepSOM{j,2}.BMUsValuesTrain =  DeepSOM{j,3}.BMUsValuesTrain;
        DeepSOM{j,2}.BMUsValuesTest =  DeepSOM{j,3}.BMUsValuesTest;
        DeepSOM{j,2}.sMap.codebook =  DeepSOM{j,3}.sMap.codebook;
    end;
end;



matchesTrain =  Model.test.layer{i+1}.macthesDensityTrain{r}(1,:);
matchesTest =  Model.test.layer{i+1}.macthesDensityTest{r}(1,:);
indexesTrain = Model.test.layer{i+1}.indexesWinnersTrain{r}(1,:);
indexesTest = Model.test.layer{i+1}.indexesWinnersTest{r}(1,:);
save('dataPlot.mat','DeepSOM', 'matchesTrain','matchesTest','indexesTrain','indexesTest')