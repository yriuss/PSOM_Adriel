
root = 'D:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\Results\plot\layer_3\'; 
database = 'full'; % ['toy,'full']
type = 'train'; % ['train','test']
if strcmp(type,'train')
    num = 1500;
elseif strcmp(type,'test')
    num = 1650;
end;
method = [{'baseline_without_filter'},{'baseline_std_filter'},{'unlearn_without_filter'},{'unlearn_std_filter'},{'unlearn_threshold_without_filter'},{'cross_without_filter'},{'cross_std_filter'}];

coord = [40 48 780 290];

for i = 1:num
    i
    img1 = imread([root database '\' method{1} '\' type '\sample_' int2str(i) '.png']);
    img2 = imread([root database '\' method{2} '\' type '\sample_' int2str(i) '.png']);
    img3 = imread([root database '\' method{3} '\' type '\sample_' int2str(i) '.png']);
    img4 = imread([root database '\' method{4} '\' type '\sample_' int2str(i) '.png']);
    img5 = imread([root database '\' method{5} '\' type '\sample_' int2str(i) '.png']);
    img6 = imread([root database '\blank.png']);
    img7 = imread([root database '\' method{6} '\' type '\sample_' int2str(i) '.png']);
    img8 = imread([root database '\' method{7} '\' type '\sample_' int2str(i) '.png']);    
    img1 = imcrop(img1,coord);
    img2 = imcrop(img2,coord);
    img3 = imcrop(img3,coord);
    img4 = imcrop(img4,coord);
    img5 = imcrop(img5,coord);
    img6 = imcrop(img6,coord);
    img7 = imcrop(img7,coord);
    img8 = imcrop(img8,coord);
    imgRow1 = cat(2,img1,img2);
    imgRow2 = cat(2,img3,img4);
    imgRow3 = cat(2,img5,img6);
    imgRow4 = cat(2,img7,img8);
    imgFull = cat(1,imgRow1,imgRow2,imgRow3,imgRow4);
    imgFull = insertText(imgFull, [770 20], ['Sample ' int2str(i)]);
    imgFull = insertText(imgFull, [350 20], 'baseline_without_filter');
    imgFull = insertText(imgFull, [1150 20], 'baseline_std_filter');
    imgFull = insertText(imgFull, [350 310], 'unlearn_without_filter');
    imgFull = insertText(imgFull, [1150 310], 'unlearn_std_filter');
    imgFull = insertText(imgFull, [350 600], 'unlearn_threshold_without_filter');
    imgFull = insertText(imgFull, [1150 600], 'unlearn_threshold_std_filter');
    imgFull = insertText(imgFull, [350 890], 'cross_without_filter');
    imgFull = insertText(imgFull, [1150 890], 'cross_std_filter');
    imshow(imgFull);
    saveas( gcf, [root database '\resume\' type '\sample_' int2str(i) '.png']); 
end;



% % for i = 1:num
% %     img1 = imread([root database '\' method{1} '\' type '\sample_' int2str(i) '.png']);
% %     img2 = imread([root database '\' method{2} '\' type '\sample_' int2str(i) '.png']);
% %     img3 = imread([root database '\' method{3} '\' type '\sample_' int2str(i) '.png']);
% %     img4 = imread([root database '\' method{4} '\' type '\sample_' int2str(i) '.png']);
% %     img5 = imread([root database '\' method{5} '\' type '\sample_' int2str(i) '.png']);
% %     img6 = imread([root database '\' method{6} '\' type '\sample_' int2str(i) '.png']);
% %     img1 = imcrop(img1,coord);
% %     img2 = imcrop(img2,coord);
% %     img3 = imcrop(img3,coord);
% %     img4 = imcrop(img4,coord);
% %     img5 = imcrop(img5,coord);
% %     img6 = imcrop(img6,coord);    
% %     imgRow1 = cat(2,img1,img2);
% %     imgRow2 = cat(2,img3,img4);
% %     imgRow3 = cat(2,img5,img6);
% %     imgFull = cat(1,imgRow1,imgRow2,imgRow3);
% %     imgFull = insertText(imgFull, [780 20], ['Sample ' int2str(i)]);
% %     imgFull = insertText(imgFull, [350 20], 'baseline_without_filter');
% %     imgFull = insertText(imgFull, [1150 20], 'baseline_std_filter');
% %     imgFull = insertText(imgFull, [350 310], 'unlearn_without_filter');
% %     imgFull = insertText(imgFull, [1150 310], 'unlearn_std_filter');
% %     imgFull = insertText(imgFull, [350 600], 'cross_without_filter');
% %     imgFull = insertText(imgFull, [1150 600], 'cross_std_filter');
% %     imshow(imgFull);
% %     saveas( gcf, [root database '\resume\' type '\sample_' int2str(i) '.png']); 
% % end;



