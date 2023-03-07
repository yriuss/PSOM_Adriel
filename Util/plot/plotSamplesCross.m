% Marcondes Ricarte

function [data] = plotSamplesCross(data, labels, Model, folder, step, layer)

    if layer == 3 & strcmp(Model.multiple.flagToyProblem,'yes') %layer +1
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;
    steps = numClass*step;

    if strcmp(Model.flag.plotSamplesForLayer,'yes')
        [row,col] = size(data);
        if numClass == 3
            fontsize = 6;
            if strcmp(folder,'train')
                row = 300;
            elseif strcmp(folder,'test')
                row = 330; 
            end;
        elseif  numClass == 15
            fontsize = 8;
            if strcmp(folder,'train')
                row = 1500;
            elseif strcmp(folder,'test')
                row = 1650; 
            end;
        end;
            
        for i=1:row
            i
            name = ['logs\plot\' Model.database '\layer_' int2str(layer) '\' folder '\sample_' int2str(i) '.png'];
            if exist(name) == 0
                [~,maxData] = max(data(i,:));
                stem(data(i,:),'MarkerSize',1, 'Color', 'blue'), xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                hold on
                rangeTotal = []; 
                if numClass == 3
                    for j=1:numClass
                        if j ~= labels(i)
                            if j == 1 % TODO
                                range = 1:16;
                            elseif j == 2
                                range = 65:80;
                            elseif j == 3
                                range = 129:144;
                            end;
                            rangeTotal = [rangeTotal range];
                        end;                    
                    end;
                elseif  numClass == 15
                    for j=1:numClass
                        if j ~= labels(i)
                            range = ((j-1)*step+1)+((j-1)*steps) : (j*step)+((j-1)*steps);  
                            rangeTotal = [rangeTotal range];
                        end;                    
                    end;                    
                end;
                stem(rangeTotal,data(i,rangeTotal),'MarkerSize',1, 'Color', 	[0.9290, 0.6940, 0.1250]),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                stem(((labels(i)-1)*steps)+1:(labels(i)*steps),data(i,((labels(i)-1)*steps)+1:(labels(i)*steps)),'MarkerSize',1, 'Color', 'yellow'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                stem((((labels(i)-1)*step)+((labels(i)-1)*steps)+1):(((labels(i)-1)*step)+((labels(i)-1)*steps)+step),data(i,(((labels(i)-1)*step)+((labels(i)-1)*steps)+1):(((labels(i)-1)*step)+((labels(i)-1)*steps)+step)),'MarkerSize',1, 'Color', 'red'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                stem(maxData,data(i,maxData), 'MarkerSize',1, 'Color', 'green'),  xlabel('Nodes'), ylabel('Activation'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                legend({'Other','Incorrect direct pipeline','Correct cross pipeline','Correct direct pipeline','BMU'},'FontSize',fontsize)
                hold off
                if  numClass == 15
                    set(gcf, 'Position', get(0, 'Screensize'));
                end;
                saveas( gcf,name);            
            end;
        end;
    end;
    
end