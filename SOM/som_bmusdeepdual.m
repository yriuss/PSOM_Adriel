% Marcondes Ricarte

function [BMUsValues] = som_bmusdeepdual(sMap, SamplesTrain, class, print, sigmaAtive)

if strcmp(class, 'ALL') 
    X = SamplesTrain.data;
else    
    X = SamplesTrain.data(strcmp(SamplesTrain.labels,class),:);
end;    

[rowX, colX] = size(X);
[rowCodebook, colCodebook] = size(sMap.codebook);
BMUsValues = zeros(rowX,rowCodebook); 

for i = 1:rowX
    x = X(i,:);
    
    Dist = zeros(rowCodebook,1); 
    if sum(x) ~= 0
        for j = 1:rowCodebook %otimizar processo 
             Dist(j,:) = nansum(sum((sMap.codebookDual(j,:) - x).^2));
        end;
        BMUsValues(i,:) = exp(-sqrt(Dist/sigmaAtive)'); %BMUsValues = [BMUsValues; exp(-sqrt(Dist)')];    
    else
        BMUsValues(i,:) = zeros(1, rowCodebook); %BMUsValues = [BMUsValues; zeros(1, rowCodebook)];
    end;    
end;

