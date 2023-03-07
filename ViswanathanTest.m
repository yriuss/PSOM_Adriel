% Marcondes Ricarte

clear all

load model.mat %models\modelPeel_Database8Label_Map6x6_Dim20_Steps100K.mat

data = 'database\data4Classes.txt';
label = 'database\labels4.txt';
Classes = 4;
PercentualTest = 0.5;
Replacement = 0;
PSOM = 1; %Kmeans = 0, TSOM = 1, PbSOM = 2, GHPSOG = 3.

Labels = load(label)';

Test(Model,Model.Samples,Model.NumRowsMap,Model.NumColsMap, Labels, Classes, PercentualTest, PSOM);