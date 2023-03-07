% Marcondes Ricarte

function [data] = plotDebugBMUs(data, dataDensity, labels, Model, folder, step)

    if strcmp(Model.flag.plotDebugBMUs,'yes')
        [len,dim] = size(data{1});
        
        if Model.multiple.trainlen(1,1) == 10 
            indexesPlot = [1 (2:11)];            
        elseif Model.multiple.trainlen(1,1) == 20
            indexesPlot = [1 (3:2:21)];
        elseif Model.multiple.trainlen(1,1) == 50 
            indexesPlot = [1 (6:5:51)];
        end;
        
        % standard
        for i=1:len
            i
            index = labels(i);
            name = ['logs\debug\' Model.database '\plot\standard\' folder '\sample_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j = indexesPlot                    
                    k = k + 1;
                    subplot(4,3,k)    
                    stem(data{j}(i,:), 'MarkerSize',1), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])
                    hold on
                    range = [((index-1)*step+1):(index*step)];
                    stem(range,data{j}(i,range), 'MarkerSize',1, 'Color', 'red'), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])
                    [top, topIndex] = max(data{j}(i,:));                    
                    stem(topIndex,data{j}(i,topIndex), 'MarkerSize',1, 'Color', 'green'), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])    
                    hold off
                end;
                saveas(gcf, name); 
                close(gcf);
            end;
        
        end;
        
        % density
        [len,dim] = size(dataDensity{1});
        for i=1:len
            i
            index = labels(i);
            name = ['logs\debug\' Model.database '\plot\density\' folder '\sample_' int2str(i) '.png'];
            if exist(name) == 0
                figure('units','normalized','outerposition',[0 0 1 1])
                k = 0;
                for j = indexesPlot                    
                    k = k + 1;
                    subplot(4,3,k)    
                    stem(dataDensity{j}(i,:), 'MarkerSize',1), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])
                    hold on
                    stem(index,dataDensity{j}(i,index), 'MarkerSize',1, 'Color', 'red'), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])
                    [top, topIndex] = max(dataDensity{j}(i,:));                    
                    stem(topIndex,dataDensity{j}(i,topIndex), 'MarkerSize',1, 'Color', 'green'), 
                        xlabel('Nodes'), 
                        ylabel('Activation'), 
                        title(['Epoch ' int2str(j-1)]), 
                        axis([0 (dim+1) 0 1])    
                    hold off
                end;
                saveas(gcf, name); 
                close(gcf);
            end;
        
        end;
        
    end;   
    
end