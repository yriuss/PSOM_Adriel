% Marcondes Ricarte

clear all;

database = '15_Scenes'; % ['15_Scenes', 'LabelMe_8']  
type = 'multiple'; % ['multiple','probabilistic']
layer = 3; % multiple



if strcmp(type,'single')
    path = ['logs\results\' database '\single']; % ['logs\results\15_Scenes\single', 'logs\results\LabelMe_8\single']
elseif strcmp(type,'multiple')
    path = ['logs\results\' database '\multiple'];
elseif strcmp(type,'probabilistic')
    path = ['logs\results\' database '\probabilistic'];
end
files = what(path);
len = length(files.mat);



if strcmp(type,'multiple')
    col = 20;
    data = cell(len, col);
    for i = 1:len
        i
        strFator = ['['];
        strFatorBase = ['['];
        load([path,'\',char(files.mat(i))]);
        data(i,1) = cellstr(Model.multiple.relevanceType(layer));
        data(i,2) = cellstr(Model.multiple.normalizeRelevance(layer));
        data(i,3) = num2cell(Model.multiple.batch(layer));
        data(i,4) = cellstr(Model.multiple.normalizeType{layer-1});
        data(i,5) = num2cell(Model.multiple.prototypeRange(layer-1));
        data(i,6) = cellstr(Model.multiple.relevanceFunction(layer));
        data(i,7) = num2cell(Model.multiple.numMap(layer));
        data(i,8) = num2cell(Model.multiple.trainlen(layer));
        data(i,9) = num2cell(Model.multiple.a(layer));
        data(i,10) = num2cell(Model.multiple.aMin(layer));
        data(i,11) = num2cell(Model.multiple.window(layer));
        data(i,12) = cellstr(Model.multiple.learningMode);
        data(i,13) = num2cell(Model.multiple.unlearnedRate(layer));
        data(i,14) = num2cell(Model.multiple.unlearnedRateCrossCorrect(layer));
        data(i,15) = num2cell(Model.multiple.sigmaAtive(1)); %num2cell(Model.multiple.limitWinners(layer));
        data(i,16) = num2cell(Model.multiple.sigmaAtive(2));
        data(i,17) = cellstr([num2str(Model.multiple.sigmaAtive(1)) ' ' num2str(Model.multiple.sigmaAtive(2))]); %Model.multiple.sigmaAtive(layer)
        
        
        data(i,18) = num2cell(Model.test.layer{layer}.meanTest);
        data(i,19) = num2cell(Model.test.layer{layer}.stdTest);
        data(i,20) = num2cell(Model.test.layer{layer}.meanTrain);
        data(i,21) = num2cell(Model.test.layer{layer}.stdTrain);
        lenDensity = length(Model.test.layer{layer}.meanAcurracyDensityTest);        
        [~, maxIndexDensity] = ...
            max(Model.test.layer{layer}.meanAcurracyDensityTest(2:lenDensity));
        maxIndexDensity = maxIndexDensity + 1;
        data(i,22) = num2cell(maxIndexDensity);
        data(i,23) = num2cell(Model.test.layer{layer}.meanAcurracyDensityTest(maxIndexDensity));
        data(i,24) = num2cell(Model.test.layer{layer}.stdAcurracyDensityTest(maxIndexDensity));
        data(i,25) = num2cell(Model.test.layer{layer}.meanAcurracyDensityTrain(maxIndexDensity));
        data(i,26) = num2cell(Model.test.layer{layer}.stdAcurracyDensityTrain(maxIndexDensity));
        
        data(i,27) = num2cell(Model.test.layer{layer+1}.meanTest);
        data(i,28) = num2cell(Model.test.layer{layer+1}.stdTest);
        data(i,29) = num2cell(Model.test.layer{layer+1}.meanTrain);
        data(i,30) = num2cell(Model.test.layer{layer+1}.stdTrain);
        lenDensity = length(Model.test.layer{layer+1}.meanAcurracyDensityTest);        
        [~, maxIndexDensity] = ...
            max(Model.test.layer{layer+1}.meanAcurracyDensityTest(2:lenDensity));
        maxIndexDensity = maxIndexDensity + 1;
        data(i,31) = num2cell(maxIndexDensity);
        data(i,32) = num2cell(Model.test.layer{layer+1}.meanAcurracyDensityTest(maxIndexDensity));
        data(i,33) = num2cell(Model.test.layer{layer+1}.stdAcurracyDensityTest(maxIndexDensity));
        data(i,34) = num2cell(Model.test.layer{layer+1}.meanAcurracyDensityTrain(maxIndexDensity));
        data(i,35) = num2cell(Model.test.layer{layer+1}.stdAcurracyDensityTrain(maxIndexDensity)); 
        
        data(i,36) = cellstr(char(files.mat(i)));
        
      
    end;
end;