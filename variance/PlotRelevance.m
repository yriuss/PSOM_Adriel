% Marcondes Ricarte

clear all;


color = {'blue', 'green', 'red'};

path = ['results']; % ['logs\results\15_Scenes\single', 'logs\results\LabelMe_8\single']
files = what(path);
len = length(files.mat);

layer = 2;

data = [];
for j = 1:len
    j
    for k = 1:10
        means = [];
        load([path,'\',char(files.mat(j))]);
        for i = 1:3
            [node,dim] = size(Model.multiple.experiments{1, k}.relevance{i,layer});
            nodeActive = [];
            for m = 1:node
                if sum( Model.multiple.experiments{1, k}.relevance{i,layer}(m,:) == ones(1,dim) ) ~= dim
                    nodeActive = [nodeActive m];
                end;
            end;
            means =  [means mean(Model.multiple.experiments{1, k}.relevance{i,layer}(nodeActive,:)') ];
        end;
        dataParam(k,1) = std(means);
        dataParam(k,2) = Model.test.layer{1,layer+1}.meanTest; %mean(diag(Model.multiple.experiments{1, k}.confuseMatrixTest));
    end;
    data = [data; mean(dataParam)];
end;

maxScore = max(data(:,2));
indexesMax = find(data(:,2) == maxScore);
c=polyfit(data(:,1) , data(:,2), 1);
yn=polyval(c,data(:,1));
plot(data(:,1),data(:,2),'.',data(:,1),yn);
hold on
plot(data(indexesMax,1) , data(indexesMax,2), '.', 'color', 'red')
xlabel('std(sum(relevance))')
xlabel('score')
title('exp(1-sub-intra) - cut intra')

