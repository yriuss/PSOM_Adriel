% Marcondes Ricarte

function DeepSOM = convolution(Model, DeepSOM, labels, layer)
   
    len = length(labels);
    for i = 1:len
        for j = 1:Model.numClasses
            if j ~= labels(i)
                DeepSOM{j,layer}.BMUsValuesConvolutionTrain(i,:) = ...
                        DeepSOM{labels(i),layer}.BMUsValuesTrain(i,:) .* DeepSOM{j,layer}.BMUsValuesTrain(i,:);  % sem SQRT               
% %                 DeepSOM{j,layer}.BMUsValuesConvolutionTrain(i,:) = ...
% %                     sqrt(DeepSOM{labels(i),layer}.BMUsValuesTrain(i,:) .* DeepSOM{j,layer}.BMUsValuesTrain(i,:));
            else
                DeepSOM{j,layer}.BMUsValuesConvolutionTrain(i,:) = DeepSOM{j,layer}.BMUsValuesTrain(i,:);
            end;
        end;
    end;

end