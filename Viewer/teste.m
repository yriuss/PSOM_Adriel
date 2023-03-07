load('test_labels.mat')
result = ones(1,3); 
for j=1:10
    for i=1:44
        if (Model.test.layer{1,4}.macthesDensityTest{1,1}(1,i) == 0)
            result(1,test_labels(j,i)) = result(1,test_labels(j,i)) + 1;
        end;
    end;
end;