% Marcondes Ricarte

function [SamplesTrain, Labels] = BalanceClasses(SamplesTrain, Labels, Classes)

disp('Balancing classes.')
[Frequency] = hist(Labels, Classes);
[ValueMax, IndexMax] = max(Frequency);

Fators = floor(1./(Frequency(1,:)/ValueMax)) - 1;

[rowSamplesTrain,colSamplesTrain] = size(SamplesTrain);
for i= 1:Classes
    Fator = Fators(1,i);
    Indexes = (Labels(:)==(i-1)); % Comparativo de Classe com o dados interno
    DataClasse = [];
    LabelsClasse = [];
    for j=1:colSamplesTrain
        if Indexes(j,1) == 1
            DataClasse = [DataClasse SamplesTrain(:,j)];
            LabelsClasse = [LabelsClasse (i-1)];
        end        
    end
    if Fator ~= 1
        for j=1:Fator
            SamplesTrain = [SamplesTrain DataClasse];
            Labels = [Labels LabelsClasse];
        end
    end
end


% Order
% [rowSamplesTrain,colSamplesTrain] = size(SamplesTrain);
% for i=1:colSamplesTrain
%     Index1 = randi(colSamplesTrain);
%     Index2 = randi(colSamplesTrain);
%     TempData = SamplesTrain(:,Index1);
%     TempLabels = Labels(:,Index1);
%     SamplesTrain(:,Index1) = SamplesTrain(:,Index2);
%     Labels(:,Index1) = Labels(:,Index2);
%     SamplesTrain(:,Index2) = TempData;
%     Labels(:,Index2) = TempLabels;
% end
% 

