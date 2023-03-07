%Cap4
%DownSampling example
font = 16;

t = 0:.00025:1;
x = sin(2*pi*30*t) + sin(2*pi*60*t);
y = decimate(x,4);

subplot 121
stem(0:120,x(1:121),'filled','markersize',3)
grid on
xlabel ('(a) Sinal','FontSize', font),ylabel ('Original','FontSize', font)

subplot 122
stem(0:30,y(1:31),'filled','markersize',3)
grid on
xlabel ('(b) Sinal','FontSize', font),ylabel ('Sub Amostragem','FontSize', font)


%DownSampling database 
clear;
size = 2;
font = 12;

data = 'database\data4Classes.txt';
label = 'database\labels4.txt';
load database\labelsNames4.mat

data = load(data);
label = load(label) + 1; %Shift na classes

load labelMe4Compresion40
load outputLayer\deepSOMDataMultiLabel4
SamplesTrain = SamplesTrain';

subplot(2,2,1);
A = data(400,:);
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(a) Tipo de Objetos Original','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 1200 0 4])
title('Exemplo de Escritório','FontSize', font);

subplot(2,2,2);
A = SamplesTrainCompression(400,:);
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(b) Agrupamento de Objetos','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 40 0 4])
title('Exemplo de Escritório','FontSize', font);


subplot(2,2,3);
A = data(700,:);
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(c) Tipo de Objetos Original','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 1200 0 4])
title('Exemplo de Banheiro','FontSize', font);

subplot(2,2,4);
A = SamplesTrainCompression(700,:);
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(d) Agrupamento de Objetos','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 40 0 4])
title('Exemplo de Banheiro','FontSize', font);




% plot agrupamento fixo por categoria
% 
% data = 'database\data4Classes.txt';
% label = 'database\labels4.txt';
% load database\labelsNames4.mat
% 
% data = load(data);
% label = load(label) + 1; %Shift na classes
% 
% load labelMe4Compresion40
% load deepSOMDataMultLabel4
% SamplesTrain = SamplesTrain';
% 
% subplot(2,2,1);
% plot(data(400,:));
% xlabel '(a) Tipo de Objetos Original',ylabel 'Quantidade de Objetos'
% axis([0 1200 0 1.5])
% title('Exemplo de Escritório');
% 
% subplot(2,2,2);
% plot(SamplesTrainCompression(400,:));
% xlabel '(b) Agrupamento de Objetos',ylabel 'Quantidade de Objetos'
% axis([0 40 0 1.5])
% title('Exemplo de Escritório');
% 
% 
% subplot(2,2,3);
% plot(data(700,:));
% xlabel '(c) Tipo de Objetos Original',ylabel 'Quantidade de Objetos'
% axis([0 1200 0 3])
% title('Exemplo de Banheiro');
% 
% subplot(2,2,4);
% plot(SamplesTrainCompression(700,:));
% xlabel '(d) Agrupamento de Objetos',ylabel 'Quantidade de Objetos'
% axis([0 40 0 3])
% title('Exemplo de Banheiro');


% agrupamento fixo por categoria novo

data = 'database\data4Classes.txt';
label = 'database\labels4.txt';
load database\labelsNames4.mat

data = load(data);
label = load(label) + 1; %Shift na classes

load outputLayer\clusterHardLabel4
SamplesTrain = SamplesTrain';

size = 2;
font = 12;

subplot(4,4,1:3);
A = mean(data(label == 1,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(a) Tipo de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 2])

subplot(4,4,5:7);
A = mean(data(label == 2,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(c) Tipo de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 2])

subplot(4,4,9:11);
A = mean(data(label == 3,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(e) Tipo de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 2])

subplot(4,4,13:15);
A = mean(data(label == 4,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(g) Tipo de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 2])

subplot(4,4,4);
A = mean(SamplesTrain(label == 1,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(b) Agrupamento de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 41 0 2])

subplot(4,4,8);
A = mean(SamplesTrain(label == 2,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(d) Agrupamento de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 41 0 2])

subplot(4,4,12);
A = mean(SamplesTrain(label == 3,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(f) Agrupamento de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 41 0 2])

subplot(4,4,16);
A = mean(SamplesTrain(label == 4,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(h) Agrupamento de Objetos','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 41 0 2])


% SOM por categoria novo
clear;
font = 14;

label = 'database\labels4.txt';
label = load(label) + 1; %Shift na classes

load outputLayer\SOMDataLabelMe4
SamplesTrain = SamplesTrain';

size = 2;
h1 = 0.1;
h2 = 0.4;

subplot(4,1,1);
A = mean(SamplesTrain(label == 1,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ({'Atributos saída do SOM Raso','(a)'},'FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,1,2);
A = mean(SamplesTrain(label == 2,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ({'Atributos saída do SOM Raso','(b)'},'FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,1,3);
A = mean(SamplesTrain(label == 3,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ({'Atributos saída do SOM Raso','(c)'},'FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,1,4);
A = mean(SamplesTrain(label == 4,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ({'Atributos saída do SOM Raso','(d)'},'FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])



% deepsom por categoria novo
clear;
font = 14;

label = 'database\labels4.txt';
label = load(label) + 1; %Shift na classes

load outputLayer\layer4classes
data = SamplesTrain.data;

load outputLayer\deepSOMDataMultLabel4
SamplesTrain = SamplesTrain';

size = 2;
h1 = 0.1;
h2 = 0.6;

subplot(4,4,1:3);
A = mean(data(label == 1,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(a) Atributos único pipeline','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 h1])

subplot(4,4,5:7);
A = mean(data(label == 2,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(c) Atributos único pipeline','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 h1])

subplot(4,4,9:11);
A = mean(data(label == 3,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(e) Atributos único pipeline','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 h1])

subplot(4,4,13:15);
A = mean(data(label == 4,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(g) Atributos único pipeline','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 1100 0 h1])

subplot(4,4,4);
A = mean(SamplesTrain(label == 1,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(b) Atributos múltiplos pipelines','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,4,8);
A = mean(SamplesTrain(label == 2,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(d) Atributos múltiplos pipelines','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,4,12);
A = mean(SamplesTrain(label == 3,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(f) Atributos múltiplos pipelines','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])

subplot(4,4,16);
A = mean(SamplesTrain(label == 4,:));
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(h) Atributos múltiplos pipelines','FontSize', font),ylabel ('Média','FontSize', font)
axis([0 17 0 h2])


%%% BMUs Exemplo DeepSOM
clear;
load BMUsExampleSOM

size = 2;
h = 0.4;
index  = 3;
font = 14; 

subplot(2,3,1);
A = BMUsValues(index,:);
plot(A);
xlabel ({'Nodos','(a)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 16 0 h])

subplot(2,3,2);
C = BMUsValuesOutput(index,:);
plot(C);
xlabel ({'Nodos','(b)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 16 0 h])

subplot(2,3,3);
B = BMUsValuesSort(index,:);
plot(B);
xlabel ({'Nodos','(c)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 16 0 h])



%%% BMUs Exemplo SOM
clear;
load BMUsExampleSOM

size = 2;
h = 0.4;
index  = 3;
font = 14; 

subplot(2,3,1);
A = BMUsValues(index,:);
plot(A);
xlabel ({'Nodos','(a)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 1024 0 h])

subplot(2,3,2);
C = BMUsValuesOutput(index,:);
plot(C);
xlabel ({'Nodos','(b)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 1024 0 h])

subplot(2,3,3);
B = BMUsValuesSort(index,:);
plot(B);
xlabel ({'Nodos','(c)'},'FontSize', font),ylabel ('Ativações dos nodos','FontSize', font)
axis([0 1024 0 h])



% cap4 - DeepSOM database saída da rede por exemplo
clear;
font = 14;

data = 'database\data4Classes.txt';
label = 'database\labels4.txt';
load database\labelsNames4.mat

data = load(data);
label = load(label) + 1; %Shift na classes

load layer4classes
SamplesTrainLayer1 = SamplesTrain.data;
load outputLayer\deepSOMDataMultLabel4
SamplesTrain = SamplesTrain';


size = 2;
subplot(2,3,1);
A = data(400,:);
A(A == 0) = NaN;
stem(A,'filled','markersize',size);
xlabel ('(a) Tipo de Objetos Original','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 1200 0 3])
title('Exemplo de Escritório','FontSize', font);

subplot(2,3,2);
B = SamplesTrainLayer1(400,:);
B(B == 0) = NaN;
stem(B,'filled','markersize',size);
xlabel ('(b) Saída do único pipeline','FontSize', font),ylabel ('Valor','FontSize', font)
axis([0 1024 0 3])
title('Exemplo de Escritório','FontSize', font);

subplot(2,3,3);
C = SamplesTrain(400,:);
C(C == 0) = NaN;
stem(C,'filled','markersize',size);
xlabel ('(c) Saída dos múltiplos pipelines','FontSize', font),ylabel ('Valor','FontSize', font)
axis([0 17 0 3])
title('Exemplo de Escritório','FontSize', font);

subplot(2,3,4);
D = data(700,:);
D(D == 0) = NaN;
stem(D,'filled','markersize',size);
xlabel ('(d) Tipo de Objetos Original','FontSize', font),ylabel ('Quantidade de Objetos','FontSize', font)
axis([0 1200 0 3])
title('Exemplo de Banheiro','FontSize', font);

subplot(2,3,5);
E = SamplesTrainLayer1(700,:);
E(E == 0) = NaN;
stem(E,'filled','markersize',size);
xlabel ('(e) Saída do único pipeline','FontSize', font),ylabel ('Valor','FontSize', font)
axis([0 1024 0 3])
title('Exemplo de Banheiro','FontSize', font);

subplot(2,3,6);
F = SamplesTrain(700,:);
F(F == 0) = NaN;
stem(F,'filled','markersize',size);
xlabel ('(f) Saída dos múltiplos pipelines','FontSize', font),ylabel ('Valor','FontSize', font)
axis([0 17 0 3])
title('Exemplo de Banheiro','FontSize', font);


% cap5 plot imagens
subplot(2,4,1), imshow('database\images\exampleKitchen.png'), xlabel('(a)');
subplot(2,4,2), imshow('database\images\exampleBedroom.png'), xlabel('(b)');
subplot(2,4,3), imshow('database\images\exampleBathroom.png'), xlabel('(c)');
subplot(2,4,4), imshow('database\images\exampleOffice.png'), xlabel('(d)');
subplot(2,4,5), imshow('database\images\exampleConferenceroom.png'), xlabel('(e)');
subplot(2,4,6), imshow('database\images\exampleCorridor.png'), xlabel('(f)');
subplot(2,4,7), imshow('database\images\exampleDiningroom.png'), xlabel('(g)');
subplot(2,4,8), imshow('database\images\exampleLivingroom.png'), xlabel('(h)');


% plot original array objects
%subtightplot

clear;
font = 14;
size = 2;

data = 'database\data8Classes.txt';
label = 'database\labels8.txt';
load database\labelsNames8.mat

data = load(data);
label = load(label) + 1; %Shift na classes

x = 0.10;
y = 0.04;
mx = 0.1;
my = 0.1;

A = data(67,:);
A(A == 0) = NaN;
B = data(106,:);
B(B == 0) = NaN;
C = data(167,:);
C(C == 0) = NaN;
D = data(1,:);
D(D == 0) = NaN;
E = data(215,:);
E(E == 0) = NaN;
F = data(227,:);
F(F == 0) = NaN;
G = data(1191,:);
G(G == 0) = NaN;
H = data(517,:);
H(H == 0) = NaN;
subtightplot(2,4,1,[x,y],mx,my), stem(A,'filled','markersize',size), xlabel({'Tipo de Objeto','(a)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,2,[x,y],mx,my), stem(B,'filled','markersize',size), xlabel({'Tipo de Objeto','(b)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,3,[x,y],mx,my), stem(C,'filled','markersize',size), xlabel({'Tipo de Objeto','(c)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,4,[x,y],mx,my), stem(D,'filled','markersize',size), xlabel({'Tipo de Objeto','(d)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,5,[x,y],mx,my), stem(E,'filled','markersize',size), xlabel({'Tipo de Objeto','(e)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,6,[x,y],mx,my), stem(F,'filled','markersize',size), xlabel({'Tipo de Objeto','(f)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,7,[x,y],mx,my), stem(G,'filled','markersize',size), xlabel({'Tipo de Objeto','(g)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);
subtightplot(2,4,8,[x,y],mx,my), stem(H,'filled','markersize',size), xlabel({'Tipo de Objeto','(h)'},'FontSize', font),ylabel('Frequência','FontSize', font), axis([1 1380 0 7]);


% Table Space Data


% plot original categories accept

clear all;
font = 14;

Classes = 4;
if Classes == 4
    k = 2;
    load logs\results\resume\resultsFilterLabelMe4
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoPbSOMLabelMe4
    %[a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoTSOMLabelMe4
    %[a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMLabelMe4
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMLabelMe4
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMLabelMe4
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMLabelMe4
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 8
    k = 2;
    load logs\results\resume\resultsFilterLabelMe8
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoPbSOMLabelMe8
    %[a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoTSOMLabelMe8
    %[a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMLabelMe8
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMLabelMe8
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMLabelMe8
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMLabelMe8
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 62
    k = 1;
    load logs\results\resume\resultsFilterRIS
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoPbSOMRIS
    %[a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoTSOMRIS
    %[a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMRIS
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMRIS
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMRIS
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMRIS
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 407
    k = 1;
    load logs\results\resume\resultsFilterSUN
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoPbSOMSUN
    %[a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    %load logs\results\resume\resultsFixoTSOMSUN
    %[a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMSUN
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMSUN
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMSUN
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMSUN
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
end;

size = 2;

x = 0.12;
y = 0.02;
mx = 0.1;
my = 0.1;

    
A = diag(data1);
A(A == 0) = NaN;
B = diag(data2);
B(B == 0) = NaN;
C = diag(data3);
C(C == 0) = NaN;
D = diag(data4);
D(D == 0) = NaN;
E = diag(data5);
E(E == 0) = NaN;
%F = diag(data6);
%F(F == 0) = NaN;
%G = diag(data7);
%G(G == 0) = NaN;

Classes = Classes + 1;
if Classes == 4 | Classes == 8
    subtightplot(5,1,1,[x,y],mx,my), stem(A,'filled','markersize',size), xlabel({'Category','(a)'}), ylabel('Accuracy'), axis([0 Classes 0 1]), set(gca, 'XTick', [0:1:Classes]);
    subtightplot(5,1,2,[x,y],mx,my), stem(B,'filled','markersize',size), xlabel({'Category','(b)'}), ylabel('Accuracy'), axis([0 Classes 0 1]), set(gca, 'XTick', [0:1:Classes]);
    subtightplot(5,1,3,[x,y],mx,my), stem(C,'filled','markersize',size), xlabel({'Category','(c)'}), ylabel('Accuracy'), axis([0 Classes 0 1]), set(gca, 'XTick', [0:1:Classes]);
    subtightplot(5,1,4,[x,y],mx,my), stem(D,'filled','markersize',size), xlabel({'Category','(d)'}), ylabel('Accuracy'), axis([0 Classes 0 1]), set(gca, 'XTick', [0:1:Classes]);
    subtightplot(5,1,5,[x,y],mx,my), stem(E,'filled','markersize',size), xlabel({'Category','(e)'}), ylabel('Accuracy'), axis([0 Classes 0 1]), set(gca, 'XTick', [0:1:Classes]);
else
    subtightplot(5,1,1,[x,y],mx,my), stem(A,'filled','markersize',size), xlabel({'Category','(a)'}), ylabel('Accuracy'), axis([0 Classes 0 1]);
    subtightplot(5,1,2,[x,y],mx,my), stem(B,'filled','markersize',size), xlabel({'Category','(b)'}), ylabel('Accuracy'), axis([0 Classes 0 1]);
    subtightplot(5,1,3,[x,y],mx,my), stem(C,'filled','markersize',size), xlabel({'Category','(c)'}), ylabel('Accuracy'), axis([0 Classes 0 1]);
    subtightplot(5,1,4,[x,y],mx,my), stem(D,'filled','markersize',size), xlabel({'Category','(d)'}), ylabel('Accuracy'), axis([0 Classes 0 1]);
    subtightplot(5,1,5,[x,y],mx,my), stem(E,'filled','markersize',size), xlabel({'Category','(e)'}), ylabel('Accuracy'), axis([0 Classes 0 1]);
end;



% plot Confuse Matrix

clear;
Classes = 407;
if Classes == 4
    k = 2;
    load logs\results\resume\resultsFilterLabelMe4
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoPbSOMLabelMe4
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoTSOMLabelMe4
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMLabelMe4
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMLabelMe4
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMLabelMe4
    [a b c d data6] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMLabelMe4
    [a b c d data7] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 8
    k = 2;
    load logs\results\resume\resultsFilterLabelMe8
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoPbSOMLabelMe8
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoTSOMLabelMe8
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMLabelMe8
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMLabelMe8
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMLabelMe8
    [a b c d data6] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMLabelMe8
    [a b c d data7] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 62
    k = 1;
    load logs\results\resume\resultsFilterRIS
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoPbSOMRIS
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoTSOMRIS
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMRIS
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMRIS
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMRIS
    [a b c d data6] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMRIS
    [a b c d data7] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
elseif Classes == 407
    k = 1;
    load logs\results\resume\resultsFilterSUN
    [a b c d data1] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoPbSOMSUN
    [a b c d data2] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsFixoTSOMSUN
    [a b c d data3] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMPbSOMSUN
    [a b c d data4] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsSOMTSOMSUN
    [a b c d data5] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepPbSOMSUN
    [a b c d data6] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
    load logs\results\resume\resultsDeepTSOMSUN
    [a b c d data7] = Statistics(Classes, ConfuseMatrixGlobal, MeanArray, MeansArray, confuse);
end;


imagesc(data7,[0,1]);   
colormap(flipud(gray));
colorbar


% RIS62
clear;
x = 0.08;
y = 0.01;
mx = 0.1;
my = 0.1;
subtightplot(2,4,1,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixFilterRIS62.png'), xlabel('(a)');
subtightplot(2,4,2,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixHardPbSOMRIS62.png'), xlabel('(b)');
subtightplot(2,4,3,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixHardTSOMRIS62.png'), xlabel('(c)');
subtightplot(2,4,4,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixSOMPbSOMRIS62.png'), xlabel('(d)');
subtightplot(2,,5,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixSOMTSOMRIS62.png'), xlabel('(e)');
subtightplot(2,3,4,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixDeepPbSOMRIS62.png'), xlabel('(f)');
subtightplot(2,3,5,[x,y],mx,my), imshow('logs\results\resume\confuseMatrix\confuseMatrixDeepTSOMRIS62.png'), xlabel('(g)');


% SUN407
clear;
x = 0.08;
y = 0.02;
mx = 0.1;
my = 0.1;
subtightplot(2,3,1,[x,y],mx,my), imshow('Results\ConfuseMatrix\confuseMatrixFilterSUN407.png'), xlabel('(a)');
subtightplot(2,3,2,[x,y],mx,my), imshow('Results\ConfuseMatrix\confuseMatrixHardPbSOMSUN407.png'), xlabel('(b)');
subtightplot(2,3,3,[x,y],mx,my), imshow('Results\ConfuseMatrix\confuseMatrixHardTSOMSUN407.png'), xlabel('(c)');
subtightplot(2,3,4,[x,y],mx,my), imshow('Results\ConfuseMatrix\confuseMatrixDeepPbSOMSUN407.png'), xlabel('(d)');
subtightplot(2,3,5,[x,y],mx,my), imshow('Results\ConfuseMatrix\confuseMatrixHardTSOMSUN407.png'), xlabel('(e)');

subtightplot(2,3,1,[x,y],mx,my), imshow('Results\ConfuseMatrix\blank.png'), xlabel('(a)');
subtightplot(2,3,2,[x,y],mx,my), imshow('Results\ConfuseMatrix\blank.png'), xlabel('(b)');
subtightplot(2,3,3,[x,y],mx,my), imshow('Results\ConfuseMatrix\blank.png'), xlabel('(c)');
subtightplot(2,3,4,[x,y],mx,my), imshow('Results\ConfuseMatrix\blank.png'), xlabel('(d)');
subtightplot(2,3,5,[x,y],mx,my), imshow('Results\ConfuseMatrix\blank.png'), xlabel('(e)');