% Marcondes Ricarte

function [acurracy,dataMean,ratioBMUs,matches,index,indexesWinners,errorMatrix,correctNodes,incorrectNodes,pipelineCorrectOrder, errorMatrixSamples, correctNodeGlobalOrder, correctNodesTotal, incorrectNodesTotal] = debugMeanWinners(Model, data, layer, munits, labels, order, indexSample)


    correctNodes = [];
    incorrectNodes = [];
    errorMatrixSamples= [];
    correctNodeGlobalOrder = [];
    correctNodesTotal = [];
    incorrectNodesTotal = [];
    
    if strcmp(Model.multiple.flagToyProblem,'yes')
        numClass = Model.multiple.numToyProblem;
    else
        numClass = Model.numClasses;
    end;
    
    for k = 1:numClass
        for k2 = 1:numClass
            errorMatrix{k,k2} = zeros(1,munits);
        end;
    end;    
    


    for j = 1:1%munits
        dataMean = [];
        for k = 1:numClass
            range = [((k-1)*munits)+1:(k*munits)];
            dataSelect = data(:,range);
            dataSelect2 = sort(dataSelect',order);
            if j ~= 1
                dataMean(:,k) = mean(dataSelect2(1:j,:))';
            else
                dataMean(:,k) = dataSelect2(1,:)';
            end;
        end;    

        dataMean = dataMean(:,1:numClass);
        [len, dim] = size(dataMean);
        count = 0;

        if ~exist('indexSample')
            range = 1:len;
        else
            range = indexSample;
        end;       
        
        for k = range
            if labels(k) <= numClass %strmatch(sData.labels(k), labels, 'exact') <= numClass
                category(k) = labels(k);
                [~, index] = sort(dataMean(k,:),order);
                detected(k) = index(1);
                correctBMUs(k) = dataMean(k,category(k));
                if category(k) ~= index(1)
                    incorrectBMUs(k) = dataMean(k,index(1));
                elseif category(k) == index(1)            
                    incorrectBMUs(k) = dataMean(k,index(2));
                end;
                count = count + 1;
                
                if (j == 1) 
                    pipelineCorrectOrder(k) =  find( index == category(k) );
                end;           
                
                globalOrder = sort(data(k,:),'descend');
                correctNodeGlobal = find(globalOrder == correctBMUs(k) );

                correctNodeGlobalOrder(k) = correctNodeGlobal(1) ;

                 
                if (j == 1) & (category(k) ~= detected(k))
                    % active
                    for cat = 1:numClass
                        range = [( (category(k) -1)*munits)+1:( category(k) * munits)];
                        threshold = max(data(k,range));                        
                        range = [( (cat -1)*munits)+1:( cat * munits)];
                        nodes = data(k,range);
                        errorMatrixSamples{k}(:,cat) = (nodes > threshold)';
                    end;
                    % virtual_centers                    
% %                     threshold = max(dataMean(k,category(k)));
% %                     range = [(( detected(k) -1)*munits)+1:( detected(k) *munits)];
% %                     nodes = data(k,range) > threshold;
% %                     errorMatrix{category(k),detected(k)}(1,nodes) = 1;
                    % samples
                    range = [((category(k)-1)*munits)+1:(category(k)*munits)];
                    dataSelect = data(:,range);                    
                    [~, node] = max(dataSelect(k,:));%                    
                    correctNodes = [correctNodes node];                     
                    range = [((detected(k)-1)*munits)+1:(detected(k)*munits)];
                    dataSelect = data(:,range);                    
                    [~, node] = max(dataSelect(k,:));%                    
                    incorrectNodes = [incorrectNodes node]; 
                    %errorMatrix{category(k),detected(k)}(1,nodes) = errorMatrix{category(k),detected(k)}(1,nodes) + 1;
                end;
                range = [((category(k)-1)*munits)+1:(category(k)*munits)];
                dataSelect = data(:,range);                    
                [~, node] = max(dataSelect(k,:));                    
                correctNodesTotal = [correctNodesTotal node]; 
                range = [((detected(k)-1)*munits)+1:(detected(k)*munits)];
                dataSelect = data(:,range);                    
                [~, node] = max(dataSelect(k,:));             
                if (category(k) ~= detected(k))
                    incorrectNodesTotal = [incorrectNodesTotal node];   
                else
                    incorrectNodesTotal = [incorrectNodesTotal 0];   
                end;
            end;
        end;

        acurracy(j) = sum(detected == category)/count;
        matches(j,:) = (detected == category);
        indexesWinners(j,:) = detected;
        ratioBMUs(j,:) = correctBMUs - incorrectBMUs;
    end;    

end