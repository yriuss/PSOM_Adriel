
subplot(2,3,1)
stem(DeepSOM{1,layer-1}.BMUsValuesTrain(1,:)) % amostras pipeline correto

subplot(2,3,2)
stem(DeepSOM{1,layer-1}.BMUsValuesConvolutionTrain(1,:)) % amostras pipeline correto

subplot(2,3,3)
stem(DeepSOM{1,layer}.sMap.codebook(13,:)) % codebook pipeline correto

subplot(2,3,4)
stem(DeepSOM{12,layer-1}.BMUsValuesTrain(1,:)) % amostras pipeline correto

subplot(2,3,5)
stem(DeepSOM{12,layer-1}.BMUsValuesConvolutionTrain(1,:)) % amostras pipeline correto

subplot(2,3,6)
stem(DeepSOM{12,layer}.sMap.codebook(7,:)) % codebook pipeline correto


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

len = 1500;
catLen = 100;

matDist = zeros(len,len);
for x = 1:len
    for y = 1:len
        matDist(x,y) = sqrt(sum((DeepSOM{1,1}.BMUsValuesTrain(x,:) - DeepSOM{1,1}.BMUsValuesTrain(y,:)).^2)); 
    end;
end;


for x = 1:15
    for y = 1:15
        rangeX = (((x-1)*catLen)+1):(x*catLen);
        rangeY = (((y-1)*catLen)+1):(y*catLen);
        matDistMean(x,y) = mean(mean(matDist(rangeX,rangeY)));
        matDistMin(x,y) = min(min(matDist(rangeX,rangeY)));
        matDistMax(x,y) = max(max(matDist(rangeX,rangeY)));
    end;
end;    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stem(max(dataTrain), 'MarkerSize',1, 'Color', 'blue')
hold on
stem(mean(dataTrain), 'MarkerSize',1, 'Color', 'green')
stem(min(dataTrain), 'MarkerSize',1, 'Color', 'red')
hold off
legend('max','mean','min')
xlabel('nodes')
xlabel('activation')


stem(max(dataTest), 'MarkerSize',1, 'Color', 'blue')
hold on
stem(mean(dataTest), 'MarkerSize',1, 'Color', 'green')
stem(min(dataTest), 'MarkerSize',1, 'Color', 'red')
hold off
legend('max','mean','min')
xlabel('nodes')
xlabel('activation')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stem(max(dataTrain(1:100,:)), 'MarkerSize',1, 'Color', 'blue')
hold on
stem(mean(dataTrain(1:100,:)), 'MarkerSize',1, 'Color', 'green')
stem(min(dataTrain(1:100,:)), 'MarkerSize',1, 'Color', 'red')
hold off
legend('max','mean','min')
xlabel('nodes')
ylabel('activation')


stem(max(dataTrain(101:200,:)), 'MarkerSize',1, 'Color', 'blue')
hold on
stem(mean(dataTrain(101:200,:)), 'MarkerSize',1, 'Color', 'green')
stem(min(dataTrain(101:200,:)), 'MarkerSize',1, 'Color', 'red')
hold off
legend('max','mean','min')
xlabel('nodes')
ylabel('activation')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for x = 1:15
    range = (((x-1)*catLen)+1):(x*catLen);
    stem(max(dataTrain(range,:)), 'MarkerSize',1, 'Color', 'blue')
    hold on
    stem(mean(dataTrain(range,:)), 'MarkerSize',1, 'Color', 'green')
    stem(min(dataTrain(range,:)), 'MarkerSize',1, 'Color', 'red')
    hold off
    legend('max','mean','min')
    xlabel('nodes')
    ylabel('activation')
    axis([1 960 0 1])
    saveas(gcf, ['cat_norm' int2str(x) '.png']);
end;
