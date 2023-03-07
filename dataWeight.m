%dataResults = 

label_1 = {{'ones'},{'mult'}};
label_2 = {{'no'},{'max_pipeline'},{'sum_pipeline'},{'max_attributes'},{'sum_attributes'}};

[lenData,~] = size(data);


for i = 1:2
    countResults = 1;
    for j = 1:5
        for k = 1:lenData
            count = 1;
            if strcmp(data{k,1},label_1{1,i}) && strcmp(data{k,2},label_2{1,j})
                dataResults(countResults,1) = data{count,17};
                dataResults(countResults,1) = data{count,18};
                dataResults(countResults,1) = data{count,19};
                dataResults(countResults,1) = data{count,20};
            else
                count = count + 1;
            end;
            countResults = countResults + 1;
        end;
    end;
end;