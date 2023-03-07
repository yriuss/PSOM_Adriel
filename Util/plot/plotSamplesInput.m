% Marcondes Ricarte

function [data] = plotSamplesInput(data, Model, folder)

    if strcmp(Model.flag.plotSamplesForLayer,'yes')
        [row,col] = size(data);
        
        for i=1:row
            i
            name = ['logs\plot\' Model.database '\input\' folder '\sample_' int2str(i) '.png'];
            if exist(name) == 0
                stem(data(i,:), 'MarkerSize',1, 'Color', 'blue'), xlabel('Attributes'), ylabel('Values'), title(['Sample ' int2str(i)]), axis([0 (col+1) 0 1])
                saveas( gcf, name); 
            end;
        
        end;
    end;
    
end