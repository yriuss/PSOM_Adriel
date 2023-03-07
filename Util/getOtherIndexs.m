function [indexs] = getOtherIndexs(category, DeepSOM)

    indexs = [];
    len = length(DeepSOM);
    for i=1:len
        if i ~= category
            indexs = [indexs; DeepSOM{i}.indexsTrain];
        end;
    end;

end