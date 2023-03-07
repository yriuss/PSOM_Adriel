% Marcondes Ricarte

function [score, confuseMatrix] = som_deeptest(sMap, SamplesTest)

    [munits,~] = size(sMap.codebook);
    [rowData, colData] = size(SamplesTest.data);
    [rowCodebook, colCodebook] = size(sMap.codebook);     
    labels = unique(SamplesTest.labels); % order by alphabeth
    classes = length(labels);
    labels = uniqueLabels(SamplesTest,classes); 
    confuseMatrix = zeros(munits,classes);
    [valueMax indexesMax] = max(sMap.victories');
    invalid = (valueMax == 0);
    
    for  c=1:munits
        if  invalid(c) == 1
            indexesMax(c) = 0;
        end;
    end;
    
    for i = 1:rowData    
        x = SamplesTest.data(i,:);    
        for j = 1:rowCodebook 
             dist(j,:) = nansum(sqrt(sum((sMap.codebook(j,:) - x).^2)));
        end;
        [value, index] = min(dist);
        category = strmatch(SamplesTest.labels(i), labels, 'exact');
        confuseMatrix(index,category) = confuseMatrix(index,category) + 1; 
    end;
    
    %[corrects,~] = max(confuseMatrix');
    corrects = 0;
    for i = 1:munits
        if indexesMax(i) ~= 0
            corrects = corrects + confuseMatrix(i,indexesMax(i));
        end;
    end;
    score = corrects/sum(sum(confuseMatrix'));

end