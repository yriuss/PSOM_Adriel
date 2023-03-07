% Marcondes Ricarte

function [data] = plotSamples(data, labels, Model, folder, step, layer, r)

    if strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;

    if min(min(data)) >= 0
        z = 0;
    else
        z = -1;
    end;

    if strcmp(Model.flag.plotSamplesForLayer,'yes')
        data = data(:,1:numClass*step);
        [row,col] = size(data);
        maxValue = max(max(data'));
        maxValue = ones(1,row);
        for i = 1:numClass
            dataMean(:,i) = mean(data(:,((i-1)*step+1):(i*step))')';
        end;
        
        [rowMean,colMean] = size(dataMean);
        
        for i=1:row
            if labels(i) <= numClass
                i
                name = ['logs\plot\' Model.database '\experiment_' int2str(r) '\layer_' int2str(layer-1) '\' folder '\sample_' int2str(i) '.png'];
                if exist(name) == 0
                    [~,maxData] = max(data(i,:));                    
                    stem(data(i,:), 'MarkerSize',1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z maxValue(i)])
                    hold on
                    stem((((labels(i)-1)*step)+1):(labels(i)*step),data(i,(((labels(i)-1)*step)+1):(labels(i)*step)), 'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z maxValue(i)])                 
                    stem(maxData,data(i,maxData), 'MarkerSize',1, 'Color', 'green'),  xlabel('Nodes'), ylabel('Activation'), title(['Layer ' int2str(layer-1)  ' - Sample ' int2str(i)]), axis([0 (col+1) z maxValue(i)])
                    hold off                    
                    saveas( gcf, name); 
                end;
            end;        
        end;
    end;
    
end