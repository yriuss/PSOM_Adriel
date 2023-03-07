% Marcondes Ricarte

function dataLayer = parserDataLayer(type, Model, data, numToyProblem, correlation)

    if strcmp(type,'one')
        for i=1:Model.numLayer-1
            if i ~= Model.numLayer-1
                dataLayer(i) = 1;
            else
                dataLayer(i) = data;
            end;
        end;
    elseif  strcmp(type,'all_layers')
        for i=1:Model.numLayer-1
            dataLayer(i) = data;
        end;    
    elseif strcmp(type,'vector')
        len = length(data);
        dataLayer = [];
        for i=1:Model.numLayer-1
            if i ~= Model.numLayer-1
                dataLayer = [dataLayer ones(len,1)];
            else
                dataLayer = [dataLayer data];
            end;
        end;
    elseif strcmp(type,'vector_cell') && strcmp(correlation,'diferent')
        len = length(data);
        dataLayer = [];
        total = length(data{1}) * length(data{2}) * length(data{3});
        for i=1:Model.numLayer-1            
            if i ~= Model.numLayer-1
                for j=1:total
                    dataLayer{j,i} = [1 1 1];
                end;
            else
                count = 1;
                for m = 1:length(data{1})
                    for n = 1:length(data{2})
                        for p = 1:length(data{3})
                            dataLayer{count,i} = [data{1}(m) data{2}(n) data{3}(p) ];
                            count = count + 1;
                        end;
                    end;
                end
            end;
        
        end;
    elseif strcmp(type,'vector_cell') && strcmp(correlation,'equal')  
        len = length(data);
        dataLayer = [];
        total = length(data{1});
        for i=1:Model.numLayer-1
            for j=1:total
                if i ~= Model.numLayer-1
                    if numToyProblem == 3
                        dataLayer{j,i} = [1 1 1];
                    elseif numToyProblem == 15
                        dataLayer{j,i} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
                    elseif numToyProblem == 8
                        dataLayer{j,i} = [1 1 1 1 1 1 1 1];    
                    end;                        
                else
% %                     if numToyProblem == 3
% %                         dataLayer{j,i} = [data{1}(1,j) data{2}(1,j) data{2}(1,j) ];
% %                     elseif numToyProblem == 15
% %                         dataLayer{j,i} = [data{1}(1,j) data{2}(1,j) data{2}(1,j) data{1}(1,j) data{2}(1,j) data{2}(1,j) data{1}(1,j) data{2}(1,j) data{2}(1,j) ...
% %                             data{1}(1,j) data{2}(1,j) data{2}(1,j) data{1}(1,j) data{2}(1,j) data{2}(1,j)];
% %                     elseif numToyProblem == 67
% %                         dataLayer{j,i} = [];
% %                         for k=1:67
% %                             dataLayer{j,i} = [dataLayer{j,i} data{k}(1,j)];
% %                         end;
% %                     end;                      

                        dataLayer{j,i} = [];
                        for k=1:numToyProblem
                            dataLayer{j,i} = [dataLayer{j,i} data{k}(1,j)];
                        end;

                end;
            end;
        end;        
    end;
    
end