type = 'baseline';

% maps
for i = 1:classes
    subplot(4,4,i)
    surf(Ms{i}.M)
    zlim([0 1])
    xlabel('atributtes')
    ylabel('nodes')
    zlabel('activation')
    title(['Cat ' int2str(i) ', Min ' num2str(min(Ms{i}.M(:))) ', Max ' num2str(max(Ms{i}.M(:))) ])
end;
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf, ['maps_' type '.png'])


% train
for i = 1:classes
    for j = 1:classes
        subplot(4,4,j)
        range = ((j-1)*100)+1:j*100;
        surf(DeepSOM{i,1}.BMUsValuesTrain(range,:))
        zlim([0 1])
        xlabel('atributtes')
        ylabel('samples')
        zlabel('activation')
        title(['Cat ' int2str(j) ', Min ' num2str(min(min(DeepSOM{i,1}.BMUsValuesTrain(range,:)))) ', Max ' num2str(max(max(DeepSOM{i,1}.BMUsValuesTrain(range,:)))) ])
    end;
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf, ['data_train_' type '_pipeline' int2str(i) '.png'])
end;


% test
for i = 1:classes
    for j = 1:classes
        subplot(4,4,j)
        range = ((j-1)*110)+1:j*110;
        surf(DeepSOM{i,1}.BMUsValuesTest(range,:))
        zlim([0 1])
        xlabel('atributtes')
        ylabel('samples')
        zlabel('activation')
        title(['Cat ' int2str(j) ', Min ' num2str(min(min(DeepSOM{i,1}.BMUsValuesTest(range,:)))) ', Max ' num2str(max(max(DeepSOM{i,1}.BMUsValuesTest(range,:)))) ])
    end;
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf, ['data_test_' type '_pipeline' int2str(i) '.png'])
end;