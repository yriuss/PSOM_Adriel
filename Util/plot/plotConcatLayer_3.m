
%layer_3
% % database = 'train'; %['train','test']
% % rootInput = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_2\' database '\']; 
% % rootDual = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_3\dual\' database '\']; 
% % rootSub = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_3\sub\' database '\'];
% % rootResume = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\resume\' database '\'];
% % 
% % if strcmp(database,'train')
% %     num = 1500;
% % elseif  strcmp(database,'test')
% %     num = 1650;    
% % end;
% % 
% % if strcmp(database,'train')
% %     num = 300;
% % elseif  strcmp(database,'test')
% %     num = 330;    
% % end;
% % 
% % 
% % for i = 1:num
% %     i
% %     img0 = imread([rootInput '\sample_' int2str(i) '.png']);
% %     img1 = imread([rootDual '\sample_' int2str(i) '.png']);
% %     img2 = imread([rootSub '\sample_' int2str(i) '.png']);
% %     img0 = imresize(img0, 0.5);
% %     img1 = imresize(img1, 0.5);
% %     img2 = imresize(img2, 0.5);
% %     imgFull = cat(2,img0, img1,img2);
% %     imgFull = insertText(imgFull, [150 0], 'Input');
% %     imgFull = insertText(imgFull, [580 0], 'Dual');
% %     imgFull = insertText(imgFull, [1020 0], 'Sub');
% %     imshow(imgFull);
% %     saveas( gcf, [rootResume '\sample_' int2str(i) '.png']); 
% % end;



%layer_4
database = 'test'; %['train','test']
rootInput = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_4\input\' database '\']; 
rootDual = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_4\dual\' database '\']; 
rootSub = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_4\sub\' database '\'];
rootResume = ['C:\Users\Marcondes Ricarte\Desktop\debug\exp1\TOY\model_1\layer_4\resume\' database '\'];

% % if strcmp(database,'train')
% %     num = 1500;
% % elseif  strcmp(database,'test')
% %     num = 1650;    
% % end;

if strcmp(database,'train')
    num = 300;
elseif  strcmp(database,'test')
    num = 330;    
end;


for i = 1:num
    i
    img0 = imread([rootInput 'sample_' int2str(i) '.png']);
    img1 = imread([rootDual 'sample_' int2str(i) '.png']);
    img2 = imread([rootSub 'sample_' int2str(i) '.png']);
    img0 = imresize(img0, 0.5);
    img1 = imresize(img1, 0.5);
    img2 = imresize(img2, 0.5);
    imgFull = cat(2,img0, img1,img2);
    imgFull = insertText(imgFull, [150 0], 'Input');
    imgFull = insertText(imgFull, [580 0], 'Dual');
    imgFull = insertText(imgFull, [1020 0], 'Sub');
    imshow(imgFull);
    saveas( gcf, [rootResume '\sample_' int2str(i) '.png']); 
end;