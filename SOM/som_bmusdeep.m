% Marcondes Ricarte

function [BMUsValues] = som_bmusdeep(sMap, SamplesTrain, class, category, sigmaAtive, Model, matrixS,typeDistance,layer, relevance, index)

if strcmp(class, 'ALL') 
    X = SamplesTrain.data;
else    
    X = SamplesTrain.data(strcmp(SamplesTrain.labels,class),:);
end;    

[rowX, colX] = size(X);
[rowCodebook, colCodebook] = size(sMap.codebook);
BMUsValues = zeros(rowX,rowCodebook); %BMUsValues = []; 


if strcmp(typeDistance,'euclidian')
    if (layer == 1 || ~strcmp(cellstr(Model.multiple.prototype(layer-1)), 'n_prototypes') )
        for i = 1:rowX
            x = X(i,:);
            Dist = zeros(rowCodebook,1); %Dist = [];
            if sum(x) ~= 0
                for j = 1:rowCodebook %otimizar processo 
                     Dist(j,:) = sum(sum((sMap.codebook(j,:) - x).^2), 'omitnan');
                end;
                BMUsValues(i,:) = exp(-sqrt(Dist/sigmaAtive)');  
            else
                BMUsValues(i,:) = zeros(1, rowCodebook); 
            end;    
        end;
    else
        [rowX, colX] = size(X{1});
        BMUsValues = zeros(rowX,rowCodebook);
        for i = 1:rowX
            x = X{1}(i,:);
            Dist = zeros(rowCodebook,1); %Dist = [];
            if sum(x) ~= 0
                for j = 1:rowCodebook %otimizar processo 
                     Dist(j,:) = sum(sum((sMap.codebook(j,:) - x).^2), 'omitnan');
                end;
                BMUsValues(i,:) = exp(-sqrt(Dist/sigmaAtive)');  
            else
                BMUsValues(i,:) = zeros(1, rowCodebook); 
            end;    
        end;
    end;
elseif strcmp(typeDistance,'mahalanobis')
    matrixCov = nancov(sMap.codebook);
    matrixInv = pinv(matrixCov);
    for i = 1:rowX
        i
        x = X(i,:);

        Dist = zeros(rowCodebook,1); %Dist = [];
        if sum(x) ~= 0
            Dx = repmat(x,rowCodebook,1) - sMap.codebook;
            for itMatrix=1:rowCodebook
                Dist(itMatrix) = sqrt(Dx(itMatrix,:)*matrixInv*Dx(itMatrix,:)');
            end;
            BMUsValues(i,:) = exp(-sqrt(Dist/sigmaAtive)');  
        else
            BMUsValues(i,:) = zeros(1, rowCodebook); 
        end;    
    end;
elseif strcmp(typeDistance,'relevance_prototype')
    BMUsValues = zeros(rowX,colX);
    indexes = [];
    for i = 1:rowX        
        x = X(i,:);
        Dist = zeros(rowCodebook,1); %Dist = [];
        for j = 1:rowCodebook %otimizar processo 
             Dist(j,:) = sum(sum((sMap.codebook(j,:) - x).^2), 'omitnan');
        end;
        [~,index] = min(Dist);
        BMUsValues(i,:) = sMap.codebook(index,:);
        indexes = [indexes index];
    end;
elseif strcmp(typeDistance,'relevance_active') || strcmp(typeDistance,'relevance_variance')
    for i = 1:rowX
        x = X(i,:);
        Dist = zeros(rowCodebook,1);
        if sum(x) ~= 0
            for j = 1:rowCodebook 
                 Dist(j,:) = sum(sum( (Model.multiple.relevance{layer}{category}(:,1)') .* (sMap.codebook(j,:) - x).^2), 'omitnan');
            end;
            BMUsValues(i,:) = exp(-sqrt(Dist/sigmaAtive)');  
        else
            BMUsValues(i,:) = zeros(1, rowCodebook); 
        end;
    end;
elseif strcmp(typeDistance,'relevance_sub_variance')
    if ~exist('index')
        Dist = zeros(1,rowCodebook);
        BMUsValues = zeros(rowX,rowCodebook);
        codebook = sMap.codebook;
        for i = 1:rowX
            if strcmp(Model.multiple.distanceExpPosition,'extern')
              Dist = sum( (relevance .* ( (codebook - repmat(X(i,:),rowCodebook,1) ).^2 )  )' , 'omitnan') ;   
            elseif strcmp(Model.multiple.distanceExpPosition,'inside')
              Dist = sum( ( (relevance .*(codebook - repmat(X(i,:),rowCodebook,1) )).^Model.multiple.distanceExp )' , 'omitnan') ;
            end;             
            BMUsValues(i,:) = exp(-sqrt(Dist/1));
        end;   
    else
        Dist = zeros(1,rowCodebook);
        BMUsValues = zeros(rowX,rowCodebook);
        codebook = sMap.codebook;
        %Dist = sum( (relevance .* ( (codebook - repmat(X(index,:),rowCodebook,1) ).^2 )  )' ) ;
        if strcmp(Model.multiple.distanceExpPosition,'extern')
          Dist = sum( (relevance .* ( (codebook - repmat(X(index,:),rowCodebook,1) ).^2 )  )' , 'omitnan') ;   
        elseif strcmp(Model.multiple.distanceExpPosition,'inside')
          Dist = sum( ( (relevance .*(codebook - repmat(X(index,:),rowCodebook,1) )).^Model.multiple.distanceExp )' , 'omitnan') ;
        end;          
        BMUsValues(index,:) = exp(-sqrt(Dist/1));
    end;
   
elseif strcmp(typeDistance,'relevance_mirror') 
    BMUsValues = X;
elseif  strcmp(typeDistance,'prototype')
    BMUsValues = zeros(rowX,colX);
    indexes = [];
    for i = 1:rowX        
        x = X(i,:);
        Dist = zeros(rowCodebook,1); %Dist = [];
        for j = 1:rowCodebook %otimizar processo 
             Dist(j,:) = sum(sum((sMap.codebook(j,:) - x).^2), 'omitnan');
        end;
        [~,index] = min(Dist);
        BMUsValues(i,:) = sMap.codebook(index,:);
        indexes = [indexes index];
    end;    
else 
    disp('som_bmusdeep() error!');
end;