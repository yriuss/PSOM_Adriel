% Marcondes Ricarte

Classes = 407;

if Classes == 4
    data = 'database\data4Classes.txt';
    label = 'database\labels4.txt';
    load database\labelsNames4.mat
    row = 953;
    col = 1069;
elseif Classes == 8
    data = 'database\data8Classes.txt';
    label = 'database\labels8.txt';
    load database\labelsNames8.mat
elseif Classes == 62
    data = 'database\data67Classes.txt';
    label = 'database\labels67.txt';
    load database\labelsNames8.mat
elseif Classes == 407
    data = 'database\data407Classes.txt';
    label = 'database\labels407.txt';
    load database\labelsNames407.mat
end;

data = load(data);
label = load(label) + 1; %Shift na classes
[fi c] = hist(label,Classes);



[row,col] = size(data);
disp('Samples:');
disp(row);
disp('Objects:');
disp(col);
disp('Classes:');
disp(Classes);
disp('Percentual zero (0-1):');
1-(sum(data(:)==0)/(row*col))
disp('MinObjectForSample');
objectForSample = sum((data>0 == 1)');
min(objectForSample)
disp('MaxObjectForSample');
max(objectForSample)
disp('MeanObjectForSample');
mean(objectForSample)
disp('stdObjectForSample');
std(objectForSample)
[f c] = hist(label,Classes);
disp('minClass');
min(f)
disp('maxClass');
max(f)
disp('meanClass');
mean(f)
disp('stdClass');
std(f)

[f c] = hist(objectForSample,max(objectForSample));


sum(f(1:20))/sum(f)

%%%%%% plot
size = 2;
font = 14;

x = 0.12;
y = 0.06;
mx = 0.1;
my = 0.1;
f1(f1 == 0) = NaN;
f2(f2 == 0) = NaN;
f3(f3 == 0) = NaN;
f4(f4 == 0) = NaN;
subtightplot(2,4,1,[x,y],mx,my), stem(f1,'filled','markersize',size), xlabel({'Categoria', '(a)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([0 5 0 800]);
subtightplot(2,4,2,[x,y],mx,my), stem(f2,'filled','markersize',size), xlabel({'Categoria', '(b)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([0 9 0 1000]);
subtightplot(2,4,3:4,[x,y],mx,my), stem(f3,'filled','markersize',size), xlabel({'Categoria', '(c)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([0 63 0 400]);
subtightplot(2,4,5:8,[x,y],mx,my), stem(f4,'filled','markersize',size), xlabel({'Categoria', '(d)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([0 410 0 2500]);



%%%%%% plot
size = 2;
font = 14;

x = 0.12;
y = 0.06;
mx = 0.1;
my = 0.1;
f1(f1 == 0) = NaN;
f2(f2 == 0) = NaN;
f3(f3 == 0) = NaN;
f4(f4 == 0) = NaN;
subtightplot(2,2,1,[x,y],mx,my), stem(f1,'filled','markersize',size), xlabel({'Quantidade de tipos de objetos', '(a)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([1 80 0 120]);
subtightplot(2,2,2,[x,y],mx,my), stem(f2,'filled','markersize',size), xlabel({'Quantidade de tipos de objetos', '(b)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([1 80 0 160]);
subtightplot(2,2,3,[x,y],mx,my), stem(f3,'filled','markersize',size), xlabel({'Quantidade de tipos de objetos', '(c)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([1 80 0 250]);
subtightplot(2,2,4,[x,y],mx,my), stem(f4,'filled','markersize',size), xlabel({'Quantidade de tipos de objetos', '(d)'},'FontSize', font), ylabel('Quantidade de amostras','FontSize', font), axis([1 80 0 1100]);


