
root = 'D:\Run\PSOM PLOT\logs\plot\15_Scenes'; 
type = 'test'; % ['train','test']
if strcmp(type,'train')
    num = 300;
    indexes = [301:400 401:500 1101:1200];
elseif strcmp(type,'test')
    num = 330;
    indexes = [331:440 441:550 1211:1320];
end;
layer = [{'input'},{'layer_2'},{'layer_3'},{'layer_4'},{'resume'}];

coord = [40 48 780 290];
coord2 = [40 48 780 290];

for i = 1:num
    i
    img1 = imread([root '\' layer{1} '\' type '\sample_' int2str(indexes(i)) '.png']);
    img2 = imread([root '\' layer{2} '\' type '\sample_' int2str(i) '.png']);
    img3 = imread([root '\' layer{3} '\' type '\sample_' int2str(i) '.png']);
    img4 = imread([root '\' layer{4} '\' type '\sample_' int2str(i) '.png']);
    img1 = imresize(img1,[291 781]);
    %img1 = imcrop(img1,coord);
    img2 = imcrop(img2,coord);
    img3 = imcrop(img3,coord);
    img4 = imcrop(img4,coord);
    imgRow1 = cat(2,img1,img2);
    imgRow2 = cat(2,img3,img4);
    imgFull = cat(1,imgRow1,imgRow2);
    imgFull = insertText(imgFull, [770 20], ['Sample ' int2str(indexes(i))]);
    imgFull = insertText(imgFull, [350 20], 'Input');
    imgFull = insertText(imgFull, [1150 20], 'Layer 1');
    imgFull = insertText(imgFull, [350 310], 'Layer 2');
    imgFull = insertText(imgFull, [1150 310], 'Layer 3');
    imshow(imgFull);
    saveas( gcf, [root '\' layer{5} '\' type '\sample_' int2str(i) '.png']); 
end;
