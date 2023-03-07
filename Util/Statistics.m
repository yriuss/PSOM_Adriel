function [Mean, Std, better, confuse, ConfuseMatrixGlobalPercent, ConfuseMatrixGlobal] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse)

%Statictics
Std = nanstd(MeanArray);
Stds = [];
for i=1:Classes
    Stds = [Stds nanstd(MeansArray(i,:))];
end

for i=1:Classes
    ConfuseMatrixGlobalPercent(:,i) = ConfuseMatrixGlobal(:,i)/sum(ConfuseMatrixGlobal(:,i));
end

disp('Statistics.');
disp('Mean and Std:');
disp([nanmean(MeanArray)' Std']);

disp('Mean and Std Classes:');
disp([diag(ConfuseMatrixGlobalPercent) Stds']);

disp('ConfuseMatrixGlobal:');
disp(ConfuseMatrixGlobal);

disp('ConfuseMatrixGlobalPercent:');
disp(ConfuseMatrixGlobalPercent);

Mean = nanmean(MeanArray)'
Std = Std';


disp('Better:');
[better index] = max(MeanArray);
disp(better);

disp('Confuse Matrix:');
if Classes <= 8
    disp(confuse{index}.matrix);
end;

