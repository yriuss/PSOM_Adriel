% Marcondes Ricarte

clear all;

load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\PSOM\dataInicial.mat');
load('D:\Mestrado\Dissertação\Projeto\trunk\Matlab\logs\maps\15_Scenes\backup\standard_unlearn_norm\sMaps_layer_5_single_1_fator_1_multiple_1_fator_1_test_1.mat');

layer = 4;


munits = Model.multiple.numMap(layer);


dataOutputTrain = [DeepSOM{1,layer}.BMUsValuesTrain(1:300,:) DeepSOM{2,layer}.BMUsValuesTrain(1:300,:) DeepSOM{3,layer}.BMUsValuesTrain(1:300,:)];
dataOutputTest = [DeepSOM{1,layer}.BMUsValuesTest(1:330,:) DeepSOM{2,layer}.BMUsValuesTest(1:330,:) DeepSOM{3,layer}.BMUsValuesTest(1:330,:)];

centers = [DeepSOM{1,layer}.sMap.codebook; DeepSOM{2,layer}.sMap.codebook; DeepSOM{3,layer}.sMap.codebook];
[units,dim] = size(centers);

[activeTrain, indexesTrain] = max(dataOutputTrain');
[activeTest, indexesTest] = max(dataOutputTest');



[frequencyTrain ~] = hist(indexesTrain,units);
[frequencyTest ~] = hist(indexesTest,units);

nodesCategoryTrain = zeros(1,3);
nodesCategoryTest = zeros(1,3);
step = units/3;
for i =1:3
    nodesCategoryTrain(i) = nodesCategoryTrain(i) + sum(frequencyTrain((((i-1)*step)+1):((i*step))) > 0);
    nodesCategoryTest(i) = nodesCategoryTest(i) + sum(frequencyTest((((i-1)*step)+1):((i*step))) > 0);
end;

totalNodesTrain = sum(nodesCategoryTrain);
totalNodesTest = sum(nodesCategoryTest);

nodesActiveTrain =  find(frequencyTrain > 0);
nodesActiveTest =  find(frequencyTest > 0);

matchesTrain = Model.test.layer{layer+1}.macthesDensityTrain{1,1}(1,:);
matchesTest = Model.test.layer{layer+1}.macthesDensityTest{1,1}(1,:);

matchesCayegoryTrain{1} = find(matchesTrain(1:10)==0);
matchesCayegoryTrain{2} = find(matchesTrain(11:200)==0)+100;
matchesCayegoryTrain{3} = find(matchesTrain(201:300)==0)+200;
matchesCayegoryTest{1} = find(matchesTest(1:110)==0);
matchesCayegoryTest{2} = find(matchesTest(111:220)==0)+110;
matchesCayegoryTest{3} = find(matchesTest(221:330)==0)+220;


sDataTrain = [5*ones(100,1); 5*ones(100,1); 5*ones(100,1)];
cDataTrain = [repmat([1 0 0],100,1); repmat([0 1 0],100,1); repmat([0 0 1],100,1)];
sDataTest = [5*ones(110,1); 5*ones(110,1); 5*ones(110,1)];
cDataTest = [repmat([1 0 0],110,1); repmat([0 1 0],110,1); repmat([0 0 1],110,1)];
sCentersTrain = [50*ones(nodesCategoryTrain(1),1); 50*ones(nodesCategoryTrain(2),1); 50*ones(nodesCategoryTrain(3),1)];
cCentersTrain = [repmat([1 0 0],nodesCategoryTrain(1),1); repmat([0 1 0],nodesCategoryTrain(2),1); repmat([0 0 1],nodesCategoryTrain(3),1)];
sCentersTest = [50*ones(nodesCategoryTest(1),1); 50*ones(nodesCategoryTest(2),1); 50*ones(nodesCategoryTest(3),1)];
cCentersTest = [repmat([1 0 0],nodesCategoryTest(1),1); repmat([0 1 0],nodesCategoryTest(2),1); repmat([0 0 1],nodesCategoryTest(3),1)];






%%%%%%%%%%%%%%%%%% Second Graphic Train

distTrain = 1./activeTrain;
distTest = 1./activeTest;

distTrain(distTrain == Inf) = 1.1;
distTrain = distTrain.^0.01;
distTest = distTest.^0.01;


minDist = min([distTrain distTest]);
maxDist = max([distTrain distTest]);
distTrain = (distTrain-minDist*ones(1,300))./(maxDist*ones(1,300)-minDist*ones(1,300));
distTest = (distTest-minDist*ones(1,330))./(maxDist*ones(1,330)-minDist*ones(1,330));
% % distTrain = -log( (distTrain-minDist*ones(1,300))./(maxDist*ones(1,300)-minDist*ones(1,300))  );
% % distTest = -log ( (distTest-minDist*ones(1,330))./(maxDist*ones(1,330)-minDist*ones(1,330))  );



centers2DTrain{1} = [2*(1:munits)' zeros(munits,1)];
centers2DTrain{2} = [2*(1:munits)' 2*ones(munits,1) ];
centers2DTrain{3} = [2*(1:munits)' 4*ones(munits,1) ];

scatter(centers2DTrain{1}(:,1),centers2DTrain{1}(:,2),150,'red');
hold on;
scatter(centers2DTrain{2}(:,1),centers2DTrain{2}(:,2),150,'green');
scatter(centers2DTrain{3}(:,1),centers2DTrain{3}(:,2),150,'blue');

for i = 1:300
    i
    if i <= 100
        category = 1;        
    elseif i > 100 && i <= 200        
        category = 2;
    elseif i > 200
        category = 3;
    end;
    
    if indexesTrain(i) <= munits
        indexCodebook = indexesTrain(i);
    elseif indexesTrain(i) > munits && indexesTrain(i) <= 2*munits        
        indexCodebook = indexesTrain(i)-munits;
    elseif indexesTrain(i) > 2*munits        
        indexCodebook = indexesTrain(i)-2*munits;
    end;
    
    if layer == 1
        u = SamplesTrain.data(i,:);
    else
        u = DeepSOM{category,layer-1}.BMUsValuesTrain(i,:);
    end;
    v = DeepSOM{category,layer}.sMap.codebook(indexCodebook,:);
    %ThetaInDegrees(i) = atan2d(norm(cross(u,v)),dot(u,v));
    
    CosTheta(i) = dot(u,v)/(norm(u)*norm(v));
    ThetaInDegrees(i) = acosd(CosTheta(i));
    
end;

minCos = min(ThetaInDegrees);
maxCos = max(ThetaInDegrees);
ThetaInDegrees = (ThetaInDegrees-minCos*ones(1,300))./(maxCos*ones(1,300)-minCos*ones(1,300));
ThetaInDegrees = 360*ThetaInDegrees;



for i = 1:300
    i
    if indexesTrain(i) <= munits
        y_base = 0;
        indexCodebook = indexesTrain(i);
    elseif indexesTrain(i) > munits && indexesTrain(i) <= 2*munits        
        y_base = 2;
        indexCodebook = indexesTrain(i) - munits;
    elseif indexesTrain(i) > 2*munits        
        y_base = 4;
        indexCodebook = indexesTrain(i) - 2*munits;
    end; 
    
     if i <= 100
        color = 'red';
    elseif i > 100 && i <= 200        
        color = 'green';
    elseif i > 200
        color = 'blue';
    end;
     
    x = distTrain(i)*cosd(ThetaInDegrees(i));
    y = distTrain(i)*sind(ThetaInDegrees(i));
% %     if matchesTrain(i) == 1
% %         scatter(x+(2*indexCodebook),y+y_base,10,color); %scatter(distTest(i)+(2*indexCodebook),CosTheta(i)+y,36,color);
% %     else
% %         scatter(x+(2*indexCodebook),y+y_base,10,'*',color); %scatter(distTest(i)+(2*indexCodebook),CosTheta(i)+y,'*',color);
% %     end;
    %%if strcmp(color,'blue') && indexesTrain(i) <= 64 
    %%    a =1;
    %%else
        scatter(x+(2*indexCodebook),y+y_base,10,color);
    %%end;
end;
title(['Train - layer ' num2str(layer)])
xlabel('Polar')
hold off;





%%%%%%%%%%%%%%%%%%%%%%%%%% Test  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


centers2DTrain{1} = [2*(1:munits)' zeros(munits,1)];
centers2DTrain{2} = [2*(1:munits)' 2*ones(munits,1) ];
centers2DTrain{3} = [2*(1:munits)' 4*ones(munits,1) ];

scatter(centers2DTrain{1}(:,1),centers2DTrain{1}(:,2),150,'red');
hold on;
scatter(centers2DTrain{2}(:,1),centers2DTrain{2}(:,2),150,'green');
scatter(centers2DTrain{3}(:,1),centers2DTrain{3}(:,2),150,'blue');

for i = 1:330
    if i <= 110
        category = 1;        
    elseif i > 110 && i <= 220        
        category = 2;
    elseif i > 220
        category = 3;
    end;
    
    if indexesTest(i) <= munits
        indexCodebook = indexesTest(i);
    elseif indexesTest(i) > munits && indexesTest(i) <= 2*munits        
        indexCodebook = indexesTest(i)-munits;
    elseif indexesTest(i) > 2*munits        
        indexCodebook = indexesTest(i)-2*munits;
    end;
    
    if layer == 1
        u = SamplesTest.data(i,:);
    else
        u = DeepSOM{category,layer-1}.BMUsValuesTest(i,:);
    end;
    v = DeepSOM{category,layer}.sMap.codebook(indexCodebook,:);
    CosTheta(i) = dot(u,v)/(norm(u)*norm(v));
    ThetaInDegrees(i) = acosd(CosTheta(i));
end;

minCos = min(ThetaInDegrees);
maxCos = max(ThetaInDegrees);
ThetaInDegrees = (ThetaInDegrees-minCos*ones(1,330))./(maxCos*ones(1,330)-minCos*ones(1,330));
ThetaInDegrees = 360*ThetaInDegrees;



for i = 1:330
    i
    if indexesTest(i) <= munits
        y_base = 0;
        indexCodebook = indexesTest(i);
    elseif indexesTest(i) > munits && indexesTest(i) <= 2*munits        
        y_base = 2;
        indexCodebook = indexesTest(i) - munits;
    elseif indexesTest(i) > 2*munits        
        y_base = 4;
        indexCodebook = indexesTest(i) - 2*munits;
    end; 
    
     if i <= 110
        color = 'red';
    elseif i > 110 && i <= 220        
        color = 'green';
    elseif i > 220
        color = 'blue';
    end;
     
    x = distTest(i)*cosd(ThetaInDegrees(i));
    y = distTest(i)*sind(ThetaInDegrees(i));
% %     if matchesTest(i) == 1
% %         scatter(x+(2*indexCodebook),y+y_base,10,color); %scatter(distTest(i)+(2*indexCodebook),CosTheta(i)+y,36,color);
% %     else
% %         scatter(x+(2*indexCodebook),y+y_base,10,'*',color); %scatter(distTest(i)+(2*indexCodebook),CosTheta(i)+y,'*',color);
% %     end;
    scatter(x+(2*indexCodebook),y+y_base,10,color);
end;
title(['Test - layer ' num2str(layer)])
xlabel('Polar')
hold off;




