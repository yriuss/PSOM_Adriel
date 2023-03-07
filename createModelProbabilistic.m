% Marcondes Ricarte

function Models = createModelProbabilistic(Model,classes, index)

    
    PSOMType = 'tsom'; % {'tsom', 'pbsom'}
    layer = Model.numLayer + 1;
    
    % tsom
    numSteps = [300]; %[100 300]; %[100 300 500 700 1000];
  
        
    % pbsom
    sigmaIni = [0.9];%[0.9 0.7 0.5];
    sigmaMin = [0.1];%[0.1 0.05];
    sigmaStep = [0.2];%[0.2 0.15 0.1 0.05];    
    numNeuron = repmat([3],classes,1);
 
    
    lenNumSteps = length(numSteps);
    lenNumNeuron = length(numNeuron);
    lenSigmaIni = length(sigmaIni);
    lenSigmaMin = length(sigmaMin);
    lenSigmaStep = length(sigmaStep);    
    [~,lenNumNeuron] = size(numNeuron);
    
    
    index = 1;
    if strcmp(PSOMType, 'tsom')
        for i = 1:lenNumSteps
            for j = 1:lenNumNeuron
                Models{index} = Model;
                Models{index}.probabilistic.index = index;
                Models{index}.probabilistic.PSOMType = PSOMType;
                Models{index}.probabilistic.numSteps = numSteps(i);
                Models{index}.probabilistic.numNeuron = numNeuron(:,j);
                index = index + 1;
            end;
        end;
    elseif strcmp(PSOMType, 'pbsom')
        for i = 1:lenNumNeuron
            for j = 1:lenSigmaIni
                for k = 1:lenSigmaMin
                    for m = 1:lenSigmaStep
                        Models{index} = Model;
                        Models{index}.probabilistic.index = index;
                        Models{index}.probabilistic.PSOMType = PSOMType;
                        Models{index}.probabilistic.sigmaIni = sigmaIni(j);
                        Models{index}.probabilistic.sigmaMin = sigmaMin(k);
                        Models{index}.probabilistic.sigmaStep = sigmaStep(m);
                        Models{index}.probabilistic.numNeuron = numNeuron(:,i);
                        index = index + 1;
                    end;
                end;
            end;
        end;
    end;
end