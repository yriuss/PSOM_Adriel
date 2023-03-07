% Marcondes Ricarte

function [acurracy,histogram,ratioBMUs,matches, errorNoSupervisedCorrect, errorNoSupervisedAll] = debugWinners(Model, sData, Ms, munits, labels, DeepSOM)

    D = sData.data;
    if strcmp(Model.flag.plotDebugWinners,'yes')
        for k = 1:Model.numClasses
            histogram{k}.hits = zeros(munits,1);
            histogram{k}.error = zeros(munits,1);
        end;
        hits = 0;
        [lenD,~] = size(D);
        for k = 1:lenD
            x = D(k,:);
            known = ~isnan(x);                     % its known components          
            category(k) = strmatch(sData.labels(k), labels, 'exact'); 
            for k2 = 1:Model.numClasses
                Dx = (Ms{k2}.M(:,known) - x(:,known));
                Ms{k2}.Dx = Dx;
                dist = nansum( (DeepSOM{k2,1}.relevance') .* (Dx'.^2) ); %sum(Dx'.^2);
                [distMin(k2) indexesMin(k2)]  = min(dist);
            end;            
            
            errorNoSupervisedCorrect(k) = sqrt( sum( (D(k,:) - Ms{1,category(k)}.M( indexesMin(category(k)),:)).^2 ) );
            for k2 = 1:Model.numClasses
                errorNoSupervisedAll(k,k2) = sqrt( sum( (D(k,:) - Ms{1,k2}.M( indexesMin(k2),:)).^2 ) );
            end;
            
            [~, detected(k)] = min(distMin);
            correctBMUs(k) = exp(-sqrt(distMin(category(k))) / Model.multiple.sigmaAtive(1) );
            if category(k) ~= detected(k)
                incorrectBMUs(k) = exp(-sqrt(distMin(detected(k))) / Model.multiple.sigmaAtive(1) );
            elseif category(k) == detected(k)
                [~, index] = sort(distMin(:));
                incorrectBMUs(k) = exp(-sqrt(distMin(index(2))) / Model.multiple.sigmaAtive(1) ); %exp(-sqrt(distMin(index(2))/Model.multiple.sigmaAtive(1))');
            end;
            for k2 = 1:Model.numClasses                
                if category(k) == k2 & category(k) == detected(k)
                    bmu = indexesMin(k2);
                    histogram{k2}.hits(bmu) = ...
                        histogram{k2}.hits(bmu) + 1;
                elseif detected(k) == k2 & category(k) ~= detected(k)  
                    bmu = indexesMin(detected(k));
                    histogram{k2}.error(bmu) = ...
                        histogram{k2}.error(bmu) + 1;
                end;
            end;
        end;
        acurracy = sum(detected == category)/lenD;
        matches = (detected == category);
        ratioBMUs = correctBMUs./incorrectBMUs;
    end;
    
end