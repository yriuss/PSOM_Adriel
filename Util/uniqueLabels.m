% Marcondes Ricarte

function [labels] = uniqueLabels(sData,classes)

    labels = cell(classes,1);
    len = length(sData.labels);
    count = 1;
    for i=1:len
        if any(strcmp(labels,sData.labels(i)))==0 
            labels(count) = sData.labels(i);
            count = count + 1;
        end;
    end;

end