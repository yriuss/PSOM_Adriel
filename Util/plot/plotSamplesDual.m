% Marcondes Ricarte

function [data] = plotSamplesDual(data, dataDual, labels, Model, folder, step, layer)

    if (layer == 3 || layer == 4) & strcmp(Model.multiple.flagToyProblem,'yes') %layer +1
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

        
        for i=1:row
            if labels(i) <= numClass
                i
                name = ['logs\plot\' Model.database '\layer_' int2str(layer) '\' folder '\sample_' int2str(i) '.png'];
                if exist(name) == 0
                    [~,maxData] = max(data(i,:));
                    subplot(2,1,1)                    
                    stem(data(i,:), 'MarkerSize',1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    hold on
                    stem((((labels(i)-1)*step)+1):(labels(i)*step),data(i,(((labels(i)-1)*step)+1):(labels(i)*step)), 'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    stem(maxData,data(i,maxData), 'MarkerSize',1, 'Color', 'green'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    hold off


                    [~,maxData] = max(dataDual(i,:));
                    subplot(2,1,2)                    
                    stem(dataDual(i,:), 'MarkerSize',1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    hold on
                    stem((((labels(i)-1)*step)+1):(labels(i)*step),dataDual(i,(((labels(i)-1)*step)+1):(labels(i)*step)), 'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    stem(maxData,dataDual(i,maxData), 'MarkerSize',1, 'Color', 'green'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) z 1])
                    hold off
                    saveas( gcf, name); 
                end;
            end;        
        end;
    end;
    
end