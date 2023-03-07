function [ConfuseMatrixGlobal, MeanArray, MeansArray, ConfuseMatrix] = Metrics(Classes, Indexes, SamplesLabel, ConfuseMatrixGlobal, MeanArray, MeansArray)

[rowLabels, colLabels] = size(SamplesLabel);
Clustering = zeros(Classes, Classes);
for i=1:colLabels
    Clustering(Indexes(i),SamplesLabel(i)) = Clustering(Indexes(i),SamplesLabel(i)) + 1;
end
disp('Clustering table:');
disp(Clustering);

ClusteringPercent = zeros(Classes, Classes);
for i=1:Classes
    ClusteringPercent(:,i) = Clustering(:,i) / sum(Clustering(:,i));
end
disp('ClusteringPercent table:');
disp(ClusteringPercent);

[Maxima Indexes]=max(Clustering');

ConfuseMatrixGlobal = ConfuseMatrixGlobal + Clustering;

disp('Mean:');
Mean = sum(diag(Clustering))/sum(sum(Clustering));
disp(Mean);

Means = zeros(1, Classes);
for i =1:Classes
    Means(1,i) = Clustering(i,i)/sum(Clustering(:,i));
end
disp('Means:');
disp(Means);

ConfuseMatrix = zeros(Classes, Classes);
for i=1:Classes
    ConfuseMatrix(:,i) = Clustering(:,i)/sum(Clustering(:,i));
end

if Classes <= 8
    disp('Confuse Matrix:');
    disp(ConfuseMatrix);
end;

MeanArray = [MeanArray Mean];
MeansArray = [MeansArray Means'];

