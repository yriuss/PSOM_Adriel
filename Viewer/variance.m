clear all;

load('relevance_debug.mat')
 
layer = 1;
type = 3;

for i = 1:3
    [relevanceSort(i,:), indexes(i,:)] = sort(relevanceTrainTest{layer+1}(i,:),'ascend')
end;


if type == 1
    dim = 4200;
    y = 0.1;
elseif type == 2
    indexes = indexes(:,1:1680);
    relevanceSort = relevanceSort(:,1:1680);

    for i= 1:3
        for j = 1:1680 
            relevanceBinary(i, indexes(1,j)) = 1;
        end;
    end;

    relevanceTrainTestCompress = [];
    relevanceTrainCompress = []; 
    relevanceTestCompress = [];
    relevanceTestErrorCompress = [];
    relevanceWinnerCompress = [];
    for i = 1:3
        for j = 1:4200
            if relevanceBinary(i,j) == 1
                relevanceTrainTestCompress(i,j) = relevanceTrainTest{layer+1}(i,j);
                relevanceTrainCompress(i,j) = relevanceTrain{layer+1}(i,j);
                relevanceTestCompress(i,j) = relevanceTest{layer+1}(i,j);
                relevanceTestErrorCompress(i,j) = relevanceTestError{layer+1}(i,j);
                relevanceWinnerCompress(i,j) = relevanceWinner{layer+1}(i,j);
            end;
        end;
    end;

    relevanceTrainTest{layer+1} = relevanceTrainTestCompress;
    relevanceTrain{layer+1} = relevanceTrainCompress;
    relevanceTest{layer+1} = relevanceTestCompress;
    relevanceTestError{layer+1} = relevanceTestErrorCompress;
    relevanceWinner{layer+1} = relevanceWinnerCompress;

    dim = 1680;
    y = 0.05;
    
elseif type == 3
    
    for i = 1:3
        [~, indexesTrainTest(i,:)] = sort(relevanceTrainTest{layer+1}(i,:),'ascend');
        [~, indexesWinner(i,:)] = sort(relevanceWinner{layer+1}(i,:),'ascend');
        for j = 1:4200
            if j <= 1680
                relevanceTrainTestBinary{layer+1}(i, indexesTrainTest(i,j)) = 1;
                relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 1;
            else
                relevanceTrainTestBinary{layer+1}(i, indexesTrainTest(i,j)) = 0;
                relevanceWinnerBinary{layer+1}(i, indexesWinner(i,j)) = 0;
            end;
        end;
    end;
    
    for i = 1:3
        relevanceBinary(i,:) = (relevanceTrainTestBinary{layer+1}(i, :) ~= relevanceWinnerBinary{layer+1}(i, :)) & (relevanceTrainTestBinary{layer+1}(i, :) == 1) ;
    end;
    

    for i = 1:3
        relevanceTrainTestCompress{i} = [];
        relevanceTrainCompress{i} = []; 
        relevanceTestCompress{i} = [];
        relevanceTestErrorCompress{i} = [];
        relevanceWinnerCompress{i} = [];
        for j = 1:4200
            if relevanceBinary(i,j) == 1
                relevanceTrainTestCompress{i} = [relevanceTrainTestCompress{i} relevanceTrainTest{layer+1}(i,j)];
                relevanceTrainCompress{i} = [relevanceTrainCompress{i} relevanceTrain{layer+1}(i,j)];
                relevanceTestCompress{i} = [relevanceTestCompress{i} relevanceTest{layer+1}(i,j)];
                relevanceTestErrorCompress{i} = [relevanceTestErrorCompress{i} relevanceTestError{layer+1}(i,j)];
                relevanceWinnerCompress{i} = [relevanceWinnerCompress{i} relevanceWinner{layer+1}(i,j)];
            end;
        end;
    end;

% %     relevanceTrainTest{layer+1} = relevanceTrainTestCompress;
% %     relevanceTrain{layer+1} = relevanceTrainCompress;
% %     relevanceTest{layer+1} = relevanceTestCompress;
% %     relevanceTestError{layer+1} = relevanceTestErrorCompress;
% %     relevanceWinner{layer+1} = relevanceWinnerCompress;

    for i = 1:3
        dim(i) = sum(relevanceBinary(1,:));
    end;
    y = 0.02;
end;    
    

if type == 3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % traintest 
    subplot(5,3,1)
    stem(relevanceTrainTestCompress{1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Train+Test cat 1')

    subplot(5,3,2)
    stem(relevanceTrainTestCompress{2}(1,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Train+Test cat 2')

    % % subplot(5,3,3)
    % % stem(relevanceTrainTest{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Train+Test cat 3')

    % train
    subplot(5,3,4)
    stem(relevanceTrainCompress{1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Train cat 1')

    subplot(5,3,5)
    stem(relevanceTrainCompress{2}(1,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Train cat 2')

    % % subplot(5,3,6)
    % % stem(relevanceTrain{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Train cat 3')


    %test
    subplot(5,3,7)
    stem(relevanceTestCompress{1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Test cat 1')

    subplot(5,3,8)
    stem(relevanceTestCompress{2}(1,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Test cat 2')

    % % subplot(5,3,9)
    % % stem(relevanceTest{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Test cat 3')

    %test
    subplot(5,3,10)
    stem(relevanceTestErrorCompress{1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Test Errado cat 1')

    subplot(5,3,11)
    stem(relevanceTestErrorCompress{2}(1,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Test Errado cat 2')

    % % subplot(5,3,12)
    % % stem(relevanceTestError{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Test Errado cat 3')

    %test
    subplot(5,3,13)
    stem(relevanceWinnerCompress{1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Vencedor cat 1')

    subplot(5,3,14)
    stem(relevanceWinnerCompress{2}(1,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Vencedor cat 2')

    % % subplot(5,3,15)
    % % stem(relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Vencedor cat 3')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % traintest 
    subplot(4,3,1)
    stem(relevanceTrainTest{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 1')

    subplot(4,3,2)
    stem(relevanceTrainTest{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 2')

    subplot(4,3,3)
    stem(relevanceTrainTest{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 3')

    %vencedor
    subplot(4,3,4)
    stem(relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 1')

    subplot(4,3,5)
    stem(relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 2')

    subplot(4,3,6)
    stem(relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 3')

    %traintest-vencedor
    subplot(4,3,7)
    stem(relevanceTrainTest{layer+1}(1,:)-relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 1')

    subplot(4,3,8)
    stem(relevanceTrainTest{layer+1}(2,:)-relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 2')

    subplot(4,3,9)
    stem(relevanceTrainTest{layer+1}(3,:)-relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 3')

    %traintest-vencedor (zoom)
    subplot(4,3,10)
    stem(relevanceTrainTest{layer+1}(1,:)-relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 1 (zoom)')

    subplot(4,3,11)
    stem(relevanceTrainTest{layer+1}(2,:)-relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 2 (zoom)')

    subplot(4,3,12)
    stem(relevanceTrainTest{layer+1}(3,:)-relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 3 (zoom)')    
    


elseif type == 1 || type == 2 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % traintest 
    subplot(5,3,1)
    stem(relevanceTrainTest{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Train+Test cat 1')

    subplot(5,3,2)
    stem(relevanceTrainTest{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Train+Test cat 2')

    % % subplot(5,3,3)
    % % stem(relevanceTrainTest{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Train+Test cat 3')

    % train
    subplot(5,3,4)
    stem(relevanceTrain{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Train cat 1')

    subplot(5,3,5)
    stem(relevanceTrain{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Train cat 2')

    % % subplot(5,3,6)
    % % stem(relevanceTrain{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Train cat 3')


    %test
    subplot(5,3,7)
    stem(relevanceTest{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Test cat 1')

    subplot(5,3,8)
    stem(relevanceTest{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Test cat 2')

    % % subplot(5,3,9)
    % % stem(relevanceTest{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Test cat 3')

    %test
    subplot(5,3,10)
    stem(relevanceTestError{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Test Errado cat 1')

    subplot(5,3,11)
    stem(relevanceTestError{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Test Errado cat 2')

    % % subplot(5,3,12)
    % % stem(relevanceTestError{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Test Errado cat 3')

    %test
    subplot(5,3,13)
    stem(relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim(1) 0 y])
    title('Variância Vencedor cat 1')

    subplot(5,3,14)
    stem(relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim(2) 0 y])
    title('Variância Vencedor cat 2')

    % % subplot(5,3,15)
    % % stem(relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    % % axis([0 dim(3) 0 y])
    % % title('Variância Vencedor cat 3')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % traintest 
    subplot(4,3,1)
    stem(relevanceTrainTest{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 1')

    subplot(4,3,2)
    stem(relevanceTrainTest{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 2')

    subplot(4,3,3)
    stem(relevanceTrainTest{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Train+Test cat 3')

    %vencedor
    subplot(4,3,4)
    stem(relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 1')

    subplot(4,3,5)
    stem(relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 2')

    subplot(4,3,6)
    stem(relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 3')

    %traintest-vencedor
    subplot(4,3,7)
    stem(relevanceTrainTest{layer+1}(1,:)-relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 1')

    subplot(4,3,8)
    stem(relevanceTrainTest{layer+1}(2,:)-relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 2')

    subplot(4,3,9)
    stem(relevanceTrainTest{layer+1}(3,:)-relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 y])
    title('Variância Vencedor cat 3')

    %traintest-vencedor (zoom)
    subplot(4,3,10)
    stem(relevanceTrainTest{layer+1}(1,:)-relevanceWinner{layer+1}(1,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 1 (zoom)')

    subplot(4,3,11)
    stem(relevanceTrainTest{layer+1}(2,:)-relevanceWinner{layer+1}(2,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 2 (zoom)')

    subplot(4,3,12)
    stem(relevanceTrainTest{layer+1}(3,:)-relevanceWinner{layer+1}(3,:), 'MarkerSize',1)
    axis([0 dim 0 0.01])
    title('Variância Vencedor cat 3 (zoom)')
end;