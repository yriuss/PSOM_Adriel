% Marcondes Ricarte

function [dataFators] = mixFator(fatorM)

    [row, col] =  size(fatorM);
    for i = 1:col
        uniques{i}.unique = unique(fatorM(:,i));
    end;
    fators = [];
    dataFators = [];    
    for i = 1:length(uniques{1}.unique)
        for j = 1:length(uniques{2}.unique)
            for k = 1:length(uniques{3}.unique)
                for k2 = 1:length(uniques{4}.unique)
                    for k3 = 1:length(uniques{5}.unique)
                        fators = [uniques{1}.unique(i) uniques{2}.unique(j) uniques{3}.unique(k) uniques{4}.unique(k2) uniques{5}.unique(k3)];
                        dataFators = [dataFators; fators];
                    end;
                end;
            end;
        end;
    end;
end


