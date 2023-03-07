% marcondes ricarte

clear all;

load('digits.mat')
x = Model.test.layer{2}.scoreTestOld;
y = Model.test.layer{2}.scoreTest;

[p,h,stats] = ranksum(x,y); 
p % diferentes



load('ionosphere_std.mat');
x = Model.test.layer{2}.scoreTestOld;
load('ionosphere_cosine.mat');
y = Model.test.layer{2}.scoreTest;

[p,h,stats] = ranksum(x,y);
p % iguais


load('iris.mat')
x = Model.test.layer{2}.scoreTestOld;
y = Model.test.layer{2}.scoreTest;

[p,h,stats] = ranksum(x,y); 
p % iguais



load('Scenes_15.mat')
x = Model.test.layer{2}.scoreTestOld;
y = Model.test.layer{2}.scoreTest;

[p,h,stats] = ranksum(x,y); 
p % diferentes