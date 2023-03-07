
layer = 2;
for a = 1:8
    [row, col] = size(DeepSOM{a,layer}.BMUsValuesTrain);
    count = 0;
    for b = 1:row        
        if sum(DeepSOM{a,layer}.BMUsValuesTrain(b,:) ~= 0) == 0
            count = count + 1;
        end;
    end;
    counts(a) = count; 
end;
counts = counts/row;
mean(counts)