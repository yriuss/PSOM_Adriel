% Marcondes Ricarte

function ModelCollection = createModelMultiple(Model,classes,index)

    if strcmp(Model.database,'wine')
        numTest = parserDataLayer('all_layers', Model, 10);
    elseif strcmp(Model.database,'ms_coco') 
        numTest = parserDataLayer('all_layers', Model, 1);    
    elseif strcmp(Model.database,'67_Indoors') 
        numTest = parserDataLayer('all_layers', Model, 3); 
    elseif strcmp(Model.database,'caltech_101') || strcmp(Model.database,'cifar_10') || strcmp(Model.database,'mnist') 
        numTest = parserDataLayer('all_layers', Model, 2);     
    elseif strcmp(Model.database,'digits')  || strcmp(Model.database,'usps') || strcmp(Model.database,'motion_tracking') || ...
            strcmp(Model.database,'sun_rgbd')
        numTest = parserDataLayer('all_layers', Model, 5);           
    else
        numTest = parserDataLayer('all_layers', Model, 10);
    end;
    datasetType = 'multi';

    
    stage = 'train'; % 'refinement','train'
    learningMode = 'standard'; % {'standard','unlearned'}
    trainType = 'competition'; % {'single','competition'}  
    trainUnlearnType = 'standard'; % {'standard','allWinnerUnlearnedRate','allWinnerUnlearnedConstant','bestWinnerAndNeighborhoodUnlearnedRate','winnerAndNeighborhoodLearned','noWinnerAndNoNeighborhood'}  
    trainUnlearnType2 = 'standard'; % {'standard', 'convolutional','convolutional_before','cross', 'unlearned', 'crossUnlearned','dual'}
    flagToyProblem = 'no'; %['no','yes']
    numToyProblem = classes; %3; %[3,15,67,8,3,2]
    flagToyProblemDificult = 'no'; %['no','yes']
    concatOutput = 'no'; % ['no','concat','concat_bmu','concat_subsampling','compress']
                 
    distanceType = {'relevance_sub_variance', 'relevance_sub_variance', 'relevance_sub_variance', 'relevance_sub_variance', 'relevance_sub_variance'};%{'euclidian', 'relevance_sub_variance', 'relevance_sub_variance_inside', 'relevance_variance', 'mahalanobis', 'relevance_reduction','relevance_mirror','relevance_prototype','relevance_active','prototype',]
    distanceExpPosition = 'extern'; % 'extern', 'inside'
    if strcmp(Model.database,'wine') 
        normalizeType =  {{'no','no','no','no','no'},{'attributes','attributes','attributes','attributes'}}; 
    else
        %normalizeType = {{'no','no','no','no','no'},{'attributes_selected','attributes_selected','attributes_selected','attributes_selected','attributes_selected'}};
        normalizeType = {{'no','no','no','no','no'},{'attributes','attributes','attributes','attributes'}};
        %{{'no','no','no','no'},{'attributes','attributes','attributes','attributes'}, ...
        %{'attributes_selected','attributes_selected','attributes_selected','attributes_selected'}, ...
        %{'attributes_global','attributes_global','attributes_global','attrattributes_globalibutes'}, ...
        %{'attributes_selected_global','attributes_selected_global','attributes_selected_global','attributes_selected_global'}}; %'attributes_global','attributes_selected_global' %{{'attributes_selected','attributes_selected','attributes_selected','attributes_selected'},{'attributes','attributes','attributes','attributes'}}; % ,{'attributes_selected','attributes_selected','attributes_selected','attributes_selected'}}; %{{'attributes_selected','attributes_selected','attributes_selected','attributes_selected'},...
        %{'attributes_selected_saturation','attributes_selected_saturation','attributes_selected_saturation','attributes_selected_saturation'}, ...
        %{'attributes','attributes','attributes','attributes'}, ... 
        %{'attributes_saturation','attributes_saturation','attributes_saturation','attributes_saturation'}}; %{{'no','no','no'},{'attributes','attributes','attributes'}}; %'global_attributes'
    end;
    
    normalizeRelevance = {{'no','no','no','no','no'}}; %{{'no','no','no'},{'sum_pipeline','sum_pipeline','sum_pipeline'},{'max_attributes','max_attributes','max_attributes'}}; 
                        %{{'no','no','no'},{' max_pipeline','max_pipeline','max_pipeline'},{'sum_pipeline','sum_pipeline','sum_pipeline'}, ...
                         %{'max_attributes','max_attributes','max_attributes'},{'sum_attributes','sum_attributes','sum_attributes'}}; %['no','max_pipeline','sum_pipeline','max_attibutes','sum_attibutes']
    relevanceType = {{'ones','ones','ones','ones','ones'}}; %{{'mult','mult','mult'}}; %{{'ones','ones','ones'},{'mult','mult','mult'}};
    relevanceMatrixType = {{'no','no','no','no','no'}}; %{{'inv','inv','inv'},{'no','no','no'}};
    relevanceFunction = {{'no','no','no','no','no'}}; %{{'no','no','no'},{'quantization','quantization','quantization'},{'sigm','sigm','sigm'}};
    prototype = {'prototype_sample_pipeline_winner','prototype_sample_pipeline_winner','prototype_sample_pipeline_winner','prototype_sample_pipeline_winner','prototype_sample_pipeline_winner'}; %'no','standard','bestSum','bestSum','bestSum','bestSum'},{'n_prototypes','n_prototypes','n_prototypes','n_prototypes'},{'prototype_pipeline_winner','prototype_pipeline_winner','prototype_pipeline_winner','prototype_pipeline_winner'}, {'prototype_sample_pipeline_winner','prototype_sample_pipeline_winner','prototype_sample_pipeline_winner','prototype_sample_pipeline_winner'}, { 'prototype_sample_all'}};
    saturationCodebook = {{'no','no','no','no','no'}}; %{{'yes','yes','yes','yes'},{'no','no','no','no'}};
    functionLearn = {{'standard','standard','standard','standard','standard'}}; %{{'standard','standard','standard','standard'},{'norm','norm','norm','norm'},{'norm_activation','norm_activation','norm_activation','norm_activation'},{'activationInv','activationInv','activationInv','activationInv'}}; 
    functionUnlearn = {{'standard','standard','standard','standard','standard'}}; %{{'standard','standard','standard','standard'},{'norm','norm','norm','norm'},{'norm2','norm2','norm2','norm2'}}; 
    relevanceSelect = {{'train_pipeline','train_pipeline','train_pipeline','train_pipeline','train_pipeline'}}; %'train-traintest','winner_inter','winner_covar_inter','winner_covar_neg_inter' {{'winner','winner','winner','winner'},{'train_pipeline','train_pipeline','train_pipeline','train_pipeline'}}; %{{'yes','yes','yes','yes'},{'no','no','no','no'}};
    relevanceOrder = {{'low','low','low','low','low'}}; %{{'high','high','high','high'},{'low','low','low','low'}};
    inputPrototype = {{'no','no','no','no','no'}}; %{{'no','yes','yes','yes'},{'no','no','no','no'}};
    variancePipeline = {{'lonely','lonely','lonely','lonely','lonely'}}; %{{'lonely','lonely','lonely','lonely'},{'all','all','all','all'},{'all_centers','all_centers','all_centers','all_centers'}};
    relevancePercentFlag = {{'statistic','statistic','statistic','statistic','statistic'}}; %{{'percent','percent','percent','percent'},{'statistic','statistic','statistic','statistic'}};
    relevanceStatistic = {{'band_mean-std_mean+var_fator','band_mean-std_mean+var_fator','band_mean-std_mean+var_fator','band_mean-std_mean+var_fator','band_mean-std_mean+var_fator'}}; %{no,'band_mean-std_mean+var','band_mean-std_mean+var_fator' }{{'mean','mean','mean','mean'},{'mean+std','mean+std','mean+std','mean+std'},{'mean-std','mean-std','mean-std','mean-std'},{'mean_std_fator','mean_std_fator','mean_std_fator','mean_std_fator'}};
    relevanceStatistic2 = {{'no','no','no','no','no'}}; %{{'no','mean','covar','mean_std_fator','product_mean_std_fator','var_mean_std_fator',coef_var_mean
    relevanceNorm = {{'no','no','no','no','no'}}; % 'no', 'max', 'sum', 'max_sum', 'max_attributes', 'max_global'
    relevanceSortType = {{'no','no','no','no','no'}}; % 'no', 'mult'
    relevanceCut = {{'no','no','no','no','no'}}; % 'no', 'inter', 'inter_prototypes','inter_means', 'intra', 'mult', 'inter-intra','inter_pipeline', 'inter_means_pipeline', 'inter_pipeline_binary', 'intra_relevance_1'
    relevanceInicialize = {{'no', 'no', 'no', 'no', 'no'}}; % 'no', 'yes';
    transformFunction = {{'no', 'no' 'no', 'no', 'no'}}; % 'no', 'sigmoid', 'exp', 'sigmoid_adaptative','equal_one', 'linear', 'linear_cut_std_global', 'linear_pipeline' , 'linear_cut_std_pipeline';
    initializePrototype = {'no','no','no','no','no'};  %'no','copyCodebookRelevance', 'copyRelevance'
    
    %if Model.numLayer == 6
    %    flagRelevanceSet = 'yes';
    %else
        flagRelevanceSet = 'no';
    %end;
    
    % run
   
    for i=1:Model.numLayer-1
        if i ~= Model.numLayer-1
            freezeLayer{i} = 'yes';
        else
            freezeLayer{i} = 'no';
        end;
    end;    
    
    
    if strcmp(flagToyProblem,'yes') && strcmp(concatOutput,'concat')
        batch = [1 30 1];
    else
        batch = [1 5 1];
    end;
    relevance = ones(1,numToyProblem);
    
    if strcmp(concatOutput,'concat_subsampling')
        subSampling = [[2 4 8 16]' [1 1 1 1]' [1 1 1 1]']; % [ [16 16 16]' [2 4 8]' [1 1 1]' [1 1 1]'];    
    else
        subSampling =  [[1]' [1]' [1]' [1]'];      
    end;
        
    if strcmp(prototype{1,1},'bestSum') || strcmp(prototype{1,1},'n_prototypes')
        prototypeRange = [[3:1:6]' ones(4,1)  ones(4,1) ones(4,1)];
    else
        prototypeRange = [ones(1,1) ones(1,1) ones(1,1) ones(1,1)];
    end;
    
    
    if strcmp(trainType,'single')
        selectElementMode = 'oneCategoryBalanced';
    elseif strcmp(trainType,'competition')
        selectElementMode = 'balancedSelect';
        if strcmp(Model.database,'ms_coco')
            selectElementMode = 'noBalanced';
        end;
    end;
    normalizePipelineType = 'no'; 
        %['no','samples','attributes','attributes_standard_deviation', 'exp']
    filter = 'yes';
    
    if strcmp(learningMode,'standard')
        inicializeMode = {{'mean_random','mean_random','mean_random','mean_random','mean_random'}}; %{{'random','random','random','random'},{'mean_random','mean_random','mean_random','mean_random'}};
    elseif strcmp(learningMode,'unlearned')
        %inicializeMode = {'samples_unique'};
    end;
    
    normalizeOutUniqueType = 'no';
    compressionType = 'deepsom'; % ['no', 'deepsom']


    if strcmp(trainType,'competition')
         if strcmp(Model.database,'15_Scenes') && strcmp(Model.featuresType,'vgg_19')
            numMaps = [8 8 8 8 8]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [16 16 16 16 16; 9 9 9 9 9; 4 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
            if (Model.numLayer > 2) && ~strcmp(initializePrototype{Model.numLayer-1},'no')
                epochs = [10 10 10 10 10; 3 3 3 3 3; 5 5 5 5 5]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
            end;
        elseif strcmp(Model.database,'15_Scenes') && strcmp(Model.featuresType,'vgg_19')
            numMaps = [8 8 8 8 8; 12 12 12 12 12]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [16 16 16 16 16; 9 9 9 9 9; 4 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 5 5 5 5 5]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'15_Scenes') && strcmp(Model.featuresType,'pyramid')   
            numMaps = [32 8 8 8 8]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [48 16 16 16 16; 36 9 9 9 9; 18 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'8_Sports')   
            numMaps = [8 8 8 8]; % [32 16 16; 32 16 8; 32 16 4];
            window = [48 16 16 9; 36 9 16 9; 18 4 9 6]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'67_Indoors')
            numMaps = [12 12 12 12 12]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [16 16 16 16 16; 9 9 9 9 9; 4 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [5 5 5 5 5; 10 10 10 10 10; 20 20 20 20 20]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'sun_397')
            numMaps = [8 8 8 8 8]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [16 16 16 16 16; 9 9 9 9 9; 4 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [5 5 5 5 5; 10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
		elseif strcmp(Model.database,'sun_rgbd')
            numMaps = [16 16 16 16 16]; % [32 16 16; 32 16 8; 32 16 4]; 
            window = [16 16 16 16 16; 9 9 9 9 9; 4 4 4 4 4]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];               
        elseif strcmp(Model.database,'caltech_101')
            numMaps = [4 4 4 4 4; 8 8 8 8 8];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [5 5 5 5 5; 10 10 10 10 10; 20 20 20 20 20]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'heart')
            numMaps = [4 4 4 4 4;  8 8 8 8 8; 12 12 12 12 12];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database, 'vehicle')
            numMaps = [8 8 8 8 8; 12 12 12 12 12; 16 16 16 16 16];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database, 'coil')
            numMaps = [4 4 4 4 4; 8 8 8 8 8; 12 12 12 12 12];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database, 'yale')
            numMaps = [4 4 4 4 4; 8 8 8 8 8; 12 12 12 12 12; 16 16 16 16 16];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];               
        elseif strcmp(Model.database, 'cifar_10')
            numMaps = [4 4 4 4 4; 8 8 8 8 8; 12 12 12 12 12];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];               
        elseif strcmp(Model.database,'iris')
            numMaps = [2 2 2 2 2; 3 3 3 3 3];%[12 12 12 12 12]; %[4 4 4 4 4;  8 8 8 8 8; 12 12 12 12 12];
            window = [10 10 10 10 10; 7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100; 500 500 500 500 500]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'letter')
            numMaps = [4 4 4 4 4; 8 8 8 8 8]; %[20 20 20 20 20]; %[4 4 4 4 4;  8 8 8 8 8; 12 12 12 12 12];
            window = [10 10 10 10 10; 7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100; 500 500 500 500 500]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
         elseif strcmp(Model.database,'ionosphere')
            numMaps = [3 3 3 3 3; 4 4 4 4 4]; %[8 8 8 8 8];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100; 500 500 500 500 500]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'motion_tracking')
            numMaps = [30 30 30 30 30];
            window = [16 16 16 16 16; 12 12 12 12 12; 7 7 7 7 7]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'segmentation')
            numMaps = [4 4 4 4 4;  8 8 8 8 8; 12 12 12 12 12; 16 16 16 16 16; 24 24 24 24 24];
            window = [12 12 12 12 12; 7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100; 500 500 500 500 500; 1000 1000 1000 1000 1000]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'usps')
            numMaps = [36 36 36 36 36];
            window = [16 16 16 16 16; 10 10 10 10 10; 7 7 7 7 7; 5 5 5 5 5]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'digits')
            numMaps = [24 24 24 24 24]; %[16 16 16 16 16; 20 20 20 20 20; 24 24 24 24 24; 30 30 30 30 30; 36 36 36 36 36];
            window = [16 16 16 16 16; 10 10 10 10 10; 7 7 7 7 7; 5 5 5 5 5]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [16 16 16 16 16; 20 20 20 20 20; 40 40 40 40 40; 100 100 100 100 100; 500 500 500 500 500]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'mnist')
            numMaps = [4 4 4 4 4;  8 8 8 8 8; 12 12 12 12 12; 16 16 16 16 16];
            window = [7 7 7 7 7; 5 5 5 5 5; 3 3 3 3 3]; %[36 16 9; 18 16 6; 9 16 3];  %[36 36 36; 36 18 18; 36 9 9]; %[18 8 2; 18 16 2; 18 32 2];    
            epochs = [10 10 10 10 10; 20 20 20 20 20; 40 40 40 40 40]; %[10 10 10; 10 20 20; 10 40 40]; %[10 40 10; 10 40 20; 10 40 40]; %[10 10 10; 10 20 10; 10 40 10]; %[10 10 10; 10 20 10; 10 40 10; 10 100 10];   
        elseif strcmp(Model.database,'ms_coco')
            numMaps = [64 64 64 64 64];        
            window = [32 16 16 9 9; 16 9 16 9 9; 16 4 9 6 6];    
            epochs = [3 3 3 3 3];
        elseif strcmp(Model.database(1:4),'uofa')
            numMaps = [4 4 4 4 4];        
            window = [4 4 4 4 4; 3 3 3 3 3];    
            epochs = [10 10 10 10 10; 50 50 50 50 50];
        end;
        
        a = repmat(     [0.1    0.1     0.1     0.1     0.1     0.1         0.05    0.05    0.05    0.05    0.01    0.01    0.01    0.01    0.005   0.005   0.001   0.001]', 1, 5);
        aMin = repmat(  [0.01   0.005   0.001   0.0005  0.0001  0.00005     0.005   0.001   0.0005  0.0001  0.0005  0.0001  0.00005 0.00005 0.0001  0.00005 0.0001  0.00005]', 1 ,5);  
        if strcmp(Model.database, 'cifar_10') ||  strcmp(Model.database,'motion_tracking')
            a = 0.1 * a;
            aMin = 0.1 * aMin;
        end;
            
        if strcmp(Model.database,'ms_coco')
            %a = 0.1*a;
            %aMin = 0.1*aMin;
        end;
        if strcmp(trainUnlearnType,'standard')
            unlearnedRate = [0 0 0 0 0];
            unlearnedRateCrossCorrect = [0 0 0 0 0];
            if strcmp(trainUnlearnType2,'convolutional')
                unlearnedRate = [0.01 0.001 0.0001];
            elseif strcmp(trainUnlearnType2,'convolutional_before')
                unlearnedRate = [0.01 0.001 0.0001];
            elseif strcmp(trainUnlearnType2,'cross') || strcmp(trainUnlearnType2,'dual')
               if strcmp(flagToyProblem,'yes')
                    unlearnedRate = [ones(1,1) 0.01*ones(1,1) 0.2*ones(1,1)]; % dual layer 4
                    unlearnedRate = mixFator(unlearnedRate);
                    if strcmp(trainUnlearnType2,'cross') % unlearn_extends_pipeline_correct
                        unlearnedRateCrossCorrect = [0.1 0.05 0.01 0.005]; 
                    else
                        unlearnedRateCrossCorrect = [ones(1,1) ones(1,1) ones(1,1)]; %[ones(5,1) 0.05*ones(5,1) [0.1 0.25 0.5 0.75 0.05]'];
                        unlearnedRateCrossCorrect = mixFator(unlearnedRateCrossCorrect);
                    end
               elseif strcmp(flagToyProblem,'no')
                   unlearnedRate = [ones(4,1) 0.01*ones(4,1) [0.1 0.05 0.01 0.005]']; % dual unlearn layer 3
                   unlearnedRate = mixFator(unlearnedRate);
                   if strcmp(trainUnlearnType2,'cross') % unlearn_extends_pipeline_correct
                        unlearnedRateCrossCorrect = [0.1 0.05 0.01 0.005]; 
                   else
                       unlearnedRateCrossCorrect = [ones(1,1) ones(1,1) ones(1,1)];
                       unlearnedRateCrossCorrect = mixFator(unlearnedRateCrossCorrect);
                   end;
               end;
            end
        elseif strcmp(trainUnlearnType,'allWinnerUnlearnedRate')
            if strcmp(functionUnlearn,'standard')
                unlearnedRate = [0.01:0.04:0.09 0.1:0.4:0.9 1 10 50 100 500]'; 
            elseif strcmp(functionUnlearn,'norm') || strcmp(functionUnlearn,'norm2')
                unlearnedRate = 100*[0.01:0.04:0.09 0.1:0.4:0.9 1 10 50 100 500]'; 
            end;
            unlearnedRate = parserDataLayer('vector', Model, unlearnedRate); %mixFator(unlearnedRate);
            unlearnedRateCrossCorrect = [ones(1,1) ones(1,1) ones(1,1) ones(1,1) ones(1,1)]; %[ones(5,1) 0.05*ones(5,1) [0.1 0.25 0.5 0.75 0.05]'];
            unlearnedRateCrossCorrect = mixFator(unlearnedRateCrossCorrect);
        elseif strcmp(trainUnlearnType,'allWinnerUnlearnedConstant')
            unlearnedRate = [0.0001 0.00001 0.000001];
        elseif strcmp(trainUnlearnType,'bestWinnerAndNeighborhoodUnlearnedRate')
            if strcmp(flagToyProblem ,'yes')
                unlearnedRate = [ [0.01:0.01:0.09 0.1:0.1:0.9 1:1:9]' ones(27,1) ones(27,1) ones(27,1)];
            elseif  strcmp(flagToyProblem ,'no')
                unlearnedRate = [0.1*ones(5,1) [0.1 0.05 0.01 0.005 0.001]' 0.001*ones(5,1) 0.001*ones(5,1)]; %[0.1*ones(5,1) [0.01 0.005 0.001 0.0005 0.0001]' 0.001*ones(5,1)] ;
            end;
            unlearnedRate = mixFator(unlearnedRate);
            unlearnedRateCrossCorrect = [ones(1,1) ones(1,1) ones(1,1) ones(1,1)]; %[ones(5,1) 0.05*ones(5,1) [0.1 0.25 0.5 0.75 0.05]'];
            unlearnedRateCrossCorrect = mixFator(unlearnedRateCrossCorrect);
            if strcmp(trainUnlearnType2,'cross')
                unlearnedRate = [0.0001 0.00001 0.000001 0.0000001];
            end;
        elseif strcmp(trainUnlearnType,'winnerAndNeighborhoodLearned')
            unlearnedRate = [0.01 0.001 0.0001];
        elseif strcmp(trainUnlearnType,'noWinnerAndNoNeighborhood')
            unlearnedRate = [0.001 0.0001 0.00001];
        end;
    end;

    decayFilter = [0.9 0.3 0.5];
    numAtributes = 4;
    layers = 5;
    if strcmp(trainUnlearnType2,'dual')
        if strcmp(flagToyProblem,'yes')
            sigmaAtive = [[5 20 50]' ones(3,1) 0.5*ones(3,1)]; %[0.05*ones(4,1) 0.5*ones(4,1) [0.05 0.1 0.5 1.0]']; %[[0.05 0.1 0.1 0.1]' [0.05 0.1 0.5 1.0]' ones(4,1)];
            sigmaAtive = mixFator(sigmaAtive);
        elseif strcmp(flagToyProblem,'no')
            sigmaAtive = [0.05*ones(5,1) 0.01*ones(5,1) [0.01 0.05 0.1 0.5 1.0]'];
            sigmaAtive = mixFator(sigmaAtive);
        end;
    elseif strcmp(trainUnlearnType2,'standard')
        if  strcmp(prototype{1,1}, 'no')
            sigmaAtive = [ ones(1,1)  ones(1,1) ones(1,1)  ones(1,1) ones(1,1) ];
        else
             sigmaAtive = [ ones(1,1) ones(1,1)  ones(1,1)  ones(1,1) ones(1,1)];
        end;
        sigmaAtive = mixFator(sigmaAtive);
    end;
    
    for i = 1:numToyProblem
        relevancePercent{1,i} = [1];
        relevancePercent2{1,i} = [1];
        relevancePercent3{1,i} = [1];
        relevancePercent4{1,i} = [1];        
    end;
    relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');        
    relevancePercent2 = parserDataLayer('vector_cell', Model, relevancePercent2, numToyProblem,'equal');
    relevancePercent3 = parserDataLayer('vector_cell', Model, relevancePercent3, numToyProblem,'equal');        
    relevancePercent4 = parserDataLayer('vector_cell', Model, relevancePercent4, numToyProblem,'equal');    
    if strcmp(distanceType{1},'relevance_variance') || strcmp(distanceType{1},'relevance_sub_variance') 
        if strcmp(relevancePercentFlag{1,1}(1),'percent')
            for i = 1:numToyProblem
                relevancePercent{1,i} = [0.10:0.10:0.70]; %%{[0.10:0.10:0.50] [0.10:0.10:0.50] [0.10]}; %[ ones(9,1)  [0.10:0.10:0.90]' ones(9,1)  ones(9,1)  ];  %[ ones(32,1) [0.05:0.05:0.9 0.91:0.01:0.99 0.991:0.001:0.995]' ones(32,1)  ones(32,1) ];
                relevancePercent2{1,i} = [1];
            end;
            relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');
            relevancePercent2 = parserDataLayer('vector_cell', Model, relevancePercent2, numToyProblem,'equal');
        elseif strcmp(relevancePercentFlag{1,1}(1),'statistic')
            if strcmp(relevanceStatistic{1,1}(1),'mean')
                for i = 1:numToyProblem
                    relevancePercent{1,i} = 0; 
                end;
                relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');                
            elseif strcmp(relevanceStatistic{1,1}(1),'mean-std')
                relevancePercent = [ -ones(1,1)  -ones(1,1)  -ones(1,1)  -ones(1,1)  ];
            elseif strcmp(relevanceStatistic{1,1}(1),'mean-std') || strcmp(relevanceStatistic{1,1}(1),'band_mean-std_mean+var')
                for i = 1:numToyProblem
                    relevancePercent{1,i} = [1];
                    relevancePercent2{1,i} = [1];
                end;
                relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');
                relevancePercent2 = parserDataLayer('vector_cell', Model, relevancePercent2, numToyProblem,'equal');
            elseif strcmp(relevanceStatistic{1,1}(1),'mean_std_fator')
                for i = 1:numToyProblem
                    relevancePercent{1,i} = [-1.0:0.1:1.0]; 
                end;
                relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');
            elseif strcmp(relevanceStatistic{1,1}(1),'band_mean-std_mean+var_fator')
                for i = 1:numToyProblem
                    if strcmp(Model.database,'wine') 
                        relevancePercent{1,i} = [1]; %[1:1:4]; %[1:100:2000]; 
                        relevancePercent2{1,i} = [13]; %[4:1:9];         %[4:1:6]; %[300:100:1400]; 
                        relevancePercent3{1,i} = [1]; 
                        relevancePercent4{1,i} = [1];
                    else
                        relevancePercent{1,i} = [1]; %[1:200:2001]; %[1:100:2000]; 
                        relevancePercent2{1,i} = [4201];%[600:200:4000]; %[300:100:1400]; 
                        relevancePercent3{1,i} = [1]; 
                        relevancePercent4{1,i} = [1]; 
                    end;
                end;
                relevancePercent = parserDataLayer('vector_cell', Model, relevancePercent, numToyProblem,'equal');  
                relevancePercent2 = parserDataLayer('vector_cell', Model, relevancePercent2, numToyProblem,'equal'); 
                relevancePercent3 = parserDataLayer('vector_cell', Model, relevancePercent3, numToyProblem,'equal');  
                relevancePercent4 = parserDataLayer('vector_cell', Model, relevancePercent4, numToyProblem,'equal');                  
            end;
            if strcmp(relevanceStatistic2{1,1}(1),'mean') || strcmp(relevanceStatistic2{1,1}(1),'product_mean') || ...
                    strcmp(relevanceStatistic2{1,1}(1),'var_mean') || strcmp(relevanceStatistic2{1,1}(1),'product_var_mean') || ...
                    strcmp(relevanceStatistic2{1,1}(1),'coef_var_mean') || strcmp(relevanceStatistic2{1,1}(1),'product_coef_var_mean')

                
            elseif strcmp(relevanceStatistic2{1,1}(1),'mean_std_fator') || strcmp(relevanceStatistic2{1,1}(1),'product_mean_std_fator') || ...
                    strcmp(relevanceStatistic2{1,1}(1),'var_mean_std_fator') || strcmp(relevanceStatistic2{1,1}(1),'product_var_mean_std_fator') || ...
                    strcmp(relevanceStatistic2{1,1}(1),'coef_var_mean_std_fator') || strcmp(relevanceStatistic2{1,1}(1),'product_coef_var_mean_std_fator')

                
            end;
        end;
    else
        relevancePercent = [ ones(1,1)  ones(1,1)  ones(1,1)  ones(1,1)  ];
    end;
    
    if strcmp(transformFunction{1,1}(1), 'linear_cut_std_global') || strcmp(transformFunction{1,1}(1), 'linear_cut_std_pipeline')
        transformFunctionCutStd =[-10:1:0];
    else
        transformFunctionCutStd = [0];
    end;
        
    if Model.numLayer ~= 2
        if strcmp(prototype{1},'prototype_sample_pipeline_winner') || strcmp(prototype{1},'prototype_sample_all') 
            if strcmp(Model.database,'wine')
                updatePrototype =  [0:0.01:0.05]';
            else
                updatePrototype = [0:0.01:0.05 0.075 0.10 0.125 0.15 0.175 0.20]';
            end;
            updatePrototype = parserDataLayer('vector', Model, updatePrototype);
            updateRelevance = [1];
        else
            updatePrototype = [ zeros(1,1)   zeros(1,1)  zeros(1,1)  zeros(1,1) zeros(1,1)  ];
            updateRelevance = [1];
        end;
    else
        updatePrototype = [ zeros(1,1)   zeros(1,1)  zeros(1,1)  zeros(1,1) zeros(1,1)  ];
        updateRelevance = [0.9 0.5 0.1 0.05];        
    end;
    
    if strcmp(Model.database,'wine')
        if strcmp(relevanceCut{1}(1),'no')
            setRelevance = [1:13]; %[1:1:8]; %[1:1:9];
        else
            setRelevance = [1:3];
        end;
    else
        setRelevance = [4200]; %[1 200:200:3000]; 
    end;
    
    if strcmp(relevanceCut{1,1},'no')
        relevanceFatorStd = [0]; 
        relevanceFatorStd2 = [0];         
    else
        if strcmp(relevanceCut{1,1},'inter-intra')
            relevanceFatorStd = [0 0.5 0.75 1]; 
            relevanceFatorStd2 = [0 0.5 0.75 1];             
        else
            if strcmp(Model.database,'wine')
                relevanceFatorStd = [-1 -0.75 -0.5 -0.25 0]; %[0 0.5 0.75 1];
                relevanceFatorStd2 = [0]; 
            elseif strcmp(Model.database,'iris')
                if Model.numLayer == 3
                    relevanceFatorStd = [-0.5 -1];  % layer2
                elseif  Model.numLayer == 4
                    relevanceFatorStd = [0 -1 -1.5 -2]; % layer3
                end;
                relevanceFatorStd2 = [0]; 
            elseif strcmp(Model.database,'letter')
                if Model.numLayer == 3
                    relevanceFatorStd = [0 -0.25 -0.5 -0.75 -1];  % layer2
                elseif  Model.numLayer == 4
                    relevanceFatorStd = [0 -0.5 -1]; % layer3
                end;
                relevanceFatorStd2 = [0];                    
            elseif strcmp(Model.database,'ionosphere')
                if Model.numLayer == 3
                    relevanceFatorStd = [0 -0.25 -0.5 -0.75 -1];  % layer2
                elseif  Model.numLayer == 4
                    relevanceFatorStd = [0 -0.5 -1]; % layer3
                end;
                relevanceFatorStd2 = [0];                 
            elseif strcmp(Model.database,'digits')
                if Model.numLayer == 3
                    relevanceFatorStd = [-1:0.25:0.5]; 
                elseif  Model.numLayer == 4
                     relevanceFatorStd = [-1:0.5:1]; 
                end;
                relevanceFatorStd2 = [0]; 
            elseif strcmp(Model.database,'motion_tracking')
                if Model.numLayer == 3
                    relevanceFatorStd = [-0.8:0.2:0]; 
                elseif  Model.numLayer == 4
                     relevanceFatorStd = [-0.8:0.2:0]; 
                end;
                relevanceFatorStd2 = [0];    
            elseif strcmp(Model.database,'usps')
                if Model.numLayer == 3
                    relevanceFatorStd = [-1.0:0.2:0]; 
                elseif  Model.numLayer == 4
                     relevanceFatorStd = [-0.8:0.2:0]; 
                end;
                relevanceFatorStd2 = [0];   
            elseif strcmp(Model.database,'15_Scenes')
                if Model.numLayer == 3
                    relevanceFatorStd = [-1.0:0.2:0]; 
                elseif  Model.numLayer == 4
                     relevanceFatorStd = [-0.8:0.2:0]; 
                end;
                relevanceFatorStd2 = [0];                   
            end;
        end;
    end;
    
    if strcmp(transformFunction{1}{1},'sigmoid')
        transformFunctionParam = [5 10 20 30 50];
    elseif strcmp(transformFunction{1}{1},'sigmoid_adaptative')
        transformFunctionParam = [10 20 30 50 100];    
    elseif strcmp(transformFunction{1}{1},'exp')
        if strcmp(Model.database,'digits')            
            transformFunctionParam = [0.01 0.05 0.1 0.5 1 2 5 10 50 100 200];
        else
            transformFunctionParam = [0.1 0.5 1 2 5 10 50 100 200];
        end;
    else
        transformFunctionParam = [0];
    end;
    
    if strcmp(trainUnlearnType,'standard') || ...
       strcmp(trainUnlearnType,'bestWinnerAndNeighborhoodUnlearnedRate') || ...
       strcmp(trainUnlearnType,'winnerAndNeighborhoodLearned') || ...
       strcmp(trainUnlearnType,'noWinnerAndNoNeighborhood')    
        limitWinners = 0.5*[ones(1,1) ones(1,1) ones(1,1) ones(1,1) ones(1,1)]; % [ones(4,1) [0.5 0.7 0.9 1.0]' ones(4,1)]; %   
        limitWinners = mixFator(limitWinners);
    elseif strcmp(trainUnlearnType,'allWinnerUnlearnedRate') || ...
           strcmp(trainUnlearnType,'allWinnerUnlearnedConstant') 
        limitWinners = [0.9 0.95 0.99 1]'; %[ ones(3,1) ones(3,1) [0.9 0.95 0.99]' ones(3,1) ones(3,1)];          
        limitWinners = parserDataLayer('vector', Model, limitWinners);  %mixFator(limitWinners);       
    end;
    tau = 1;
    
    if  strcmp(Model.database,'wine')
        centersThreshold = [0.80 0.85 0.90]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1];
    elseif  strcmp(Model.database,'heart')
        centersThreshold = [0.80 0.85 0.90]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; 
    elseif  strcmp(Model.database,'vehicle')
        centersThreshold =  [0.90 0.95 0.98]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; 
    elseif  strcmp(Model.database,'coil')
        centersThreshold =  [0.80:0.02:0.90]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % one
        %unlearnedRate = [ 0.05 0.05 0.05 0.05 0.05; 0.01 0.01 0.01 0.01 0.01; 0.005 0.005 0.005 0.005 0.005]; % ranking
    elseif  strcmp(Model.database,'yale')
        centersThreshold =  [0.80:0.02:0.90]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % one
        %unlearnedRate = [ 0.05 0.05 0.05 0.05 0.05; 0.01 0.01 0.01 0.01 0.01; 0.005 0.005 0.005 0.005 0.005]; % ranking   
    elseif  strcmp(Model.database,'cifar_10')
        centersThreshold =  [0.80:0.02:0.90]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % one
        %unlearnedRate = [ 0.05 0.05 0.05 0.05 0.05; 0.01 0.01 0.01 0.01 0.01; 0.005 0.005 0.005 0.005 0.005]; % ranking   
    elseif  strcmp(Model.database,'iris')
        centersThreshold =  [0]; %[0.5:0.05:0.95]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking
    elseif  strcmp(Model.database,'letter')
        centersThreshold =  [0]; %[0.5:0.05:0.95]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking        
    elseif  strcmp(Model.database,'ionosphere')
        centersThreshold = [0];% [0.94:0.005:0.99]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0]; % [0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking   
    elseif  strcmp(Model.database,'motion_tracking')
        centersThreshold =  [0]; %[0.94:0.005:0.99]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking   
    elseif  strcmp(Model.database,'segmentation')
        centersThreshold = [0.80:0.025:0.975]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0.001 0.001 0.001 0.001 0.001; 0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking           
    elseif  strcmp(Model.database,'usps')
         centersThreshold =  [0]; %[0.94:0.005:0.99]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking  
    elseif  strcmp(Model.database,'digits')
         centersThreshold =  [0]; %[0.7:0.025:0.925]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0]; %[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking          
    elseif  strcmp(Model.database,'mnist')
        centersThreshold =  [0]; %[0.6:0.05:0.95]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking          
    elseif  strcmp(Model.database,'67_Indoors')
        centersThreshold =  [0]; %[0.6:0.05:0.95]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking          
    elseif  strcmp(Model.database,'sun_rgbd')
        centersThreshold =  [0]; %[0.6:0.05:0.95]'; %[0.92:0.01:0.98]';
        unlearnedRate = [0 0 0 0 0];%[0.005 0.005 0.005 0.005 0.005; 0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; % ranking          
    elseif  strcmp(Model.database,'15_Scenes')
        centersThreshold = [0]; %[0.84:0.02:0.92]'; %[0]; %[0 1 0.5 -0.5 -1]'; 
        unlearnedRate = [0 0 0 0 0]; %[0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; %
    elseif  strcmp(Model.database(1:4),'uofa')
        centersThreshold = [0]; %[0.84:0.02:0.92]'; %[0]; %[0 1 0.5 -0.5 -1]'; 
        unlearnedRate = [0 0 0 0 0]; %[0.01 0.01 0.01 0.01 0.01; 0.05 0.05 0.05 0.05 0.05; 0.1 0.1 0.1 0.1 0.1]; %
    end;
    centersThreshold = parserDataLayer('vector', Model, centersThreshold); 
     
    
    if strcmp(learningMode,'unlearned') 
        selectElementMode = 'balancedSelect'; % Constraint
    end;
    
    if strcmp(stage,'refinement')
        normalizeType = {{'no','no','no','no','no'}};
        if strcmp(Model.database,'15_Scenes')
            numMaps = [8 8 8 8 8];
        elseif strcmp(Model.database,'coil') || strcmp(Model.database,'iris')    
            numMaps = [3 3 3 3 3]; %[12 12 12 12 12];
        end;
        window = [16 16 16 16 16];
        epochs = [10 10 10 10 10];
        a = [[0.1 0.1 0.01 0.01 0.001]];
        aMin = [[0.01 0.001 0.001 0.0001 0.0001]];
        updatePrototype = [0]; 
        updateRelevance = [1];
    end;
    

    if strcmp(distanceExpPosition, 'inside')
        distanceExp = [2:2:8]; 
    else
        distanceExp = [0]; 
    end;
    
    [~,lenInicializeMode] = size(inicializeMode);
    [lenNumMap, ~] = size(numMaps); 
    [lenA, ~] = size(a);
    [lenAMin, ~] = size(aMin);
    [lenEpochs, ~] = size(epochs);
    lenTau = length(tau);
    [lenWindow, ~] = size(window);
    [lenSubSampling, ~] = size(subSampling);
    [lenUnlearnedRate, ~] = size(unlearnedRate);
    [lenUnlearnedRateCrossCorrect, ~] = size(unlearnedRateCrossCorrect);
    [lenLimitWinners,~] = size(limitWinners);
    [lenSigmaAtive,~] = size(sigmaAtive);
    [~,lenNormalizeType] = size(normalizeType);    
    [lenBatch,~] = size(batch);
    [~,lenNormalizeRelevance] = size(normalizeRelevance);
    [~,lenRelevanceType] = size(relevanceType);
    [~,lenRelevanceMatrixType] =  size(relevanceMatrixType);
    [~,lenRelevanceFunction] =  size(relevanceFunction);
    [lenPrototypeRange,~] = size(prototypeRange);
    [~,lenSaturationCodebook] = size(saturationCodebook);
    [~,lenFunctionLearn] = size(functionLearn);
    [~,lenFunctionUnlearn] = size(functionUnlearn);
    [~,lenRelevanceSelect] = size(relevanceSelect);
    [lenRelevancePercent, ~] = size(relevancePercent);
    [lenRelevancePercent2, ~] = size(relevancePercent2);
    [lenRelevancePercent3, ~] = size(relevancePercent3);
    [lenRelevancePercent4, ~] = size(relevancePercent4);    
    [lenUpdatePrototype, ~] = size(updatePrototype);
    [~,lenUpdateRelevance] = size(updateRelevance);
    [~,lenRelevanceOrder] = size(relevanceOrder);
    [~,lenInputPrototype] = size(inputPrototype);
    [~,lenVariancePipeline] = size(variancePipeline);
    [~, lenRelevancePercentFlag] = size(relevancePercentFlag);
    [~, lenRelevanceStatistic] = size(relevanceStatistic);
    [~, lenRelevanceStatistic2] = size(relevanceStatistic2);
    [lenRelevanceNorm, ~] = size(relevanceNorm);
    [lenRelevanceSortType, ~] = size(relevanceSortType);
    [~, lenRelevanceFatorStd] = size(relevanceFatorStd);
    [~, lenRelevanceFatorStd2] = size(relevanceFatorStd2);
    [~, lenRelevanceCut] = size(relevanceCut);
    [~,lenSetRelevance] = size(setRelevance);
    [~,lenRelevanceInicialize] = size(relevanceInicialize);
    [~,lenTransformFunction] = size(transformFunction);
    [~,lenTransformFunctionParam] = size(transformFunctionParam);
    [lenCentersThreshold,~] = size(centersThreshold);
    [~,lenTransformFunctionCutStd] = size(transformFunctionCutStd);
    [~,lenDistanceExp] = size(distanceExp);
    
    index = 1;
    indexMultiple = 1;
    ModelCollection = [];
    
    for n = 1:lenInicializeMode
        for m = 1:lenNumMap
            for k = 1:lenA
                for p = 1:lenEpochs
                    for q = 1:lenTau
                        for s = 1:lenWindow
                            for f = 1:lenSigmaAtive
                                for g = 1:lenSubSampling
                                    for v = 1:lenUnlearnedRate
                                        for v2 = 1:lenUnlearnedRateCrossCorrect
                                            for b =1:lenBatch
                                                for n2 = 1:lenNormalizeType
                                                    for c =1:lenNormalizeRelevance
                                                        for d = 1:lenRelevanceType
                                                            for e = 1:lenRelevanceMatrixType
                                                                for v3 = 1:lenRelevanceFunction
                                                                    for h = 1:lenPrototypeRange
                                                                    for h2 = 1:lenSaturationCodebook
                                                                    for h3 = 1:lenFunctionLearn
                                                                    for h4 = 1:lenFunctionUnlearn
                                                                    for h5 = 1:lenRelevanceSelect
                                                                    for h6 = 1:lenRelevancePercent
                                                                    for h15 = 1:lenRelevancePercent2
                                                                    for h16 = 1:lenRelevancePercent3
                                                                    for h17 = 1:lenRelevancePercent4    
                                                                    for h7 = 1:lenRelevanceOrder
                                                                    for h8 = 1:lenInputPrototype
                                                                    for h9 = 1:lenUpdatePrototype
                                                                    for h10 = 1:lenVariancePipeline
                                                                    for h12 = 1:lenRelevancePercentFlag    
                                                                    for h13 = 1:lenRelevanceStatistic
                                                                    for h14 = 1:lenRelevanceStatistic2
                                                                    for h18 = 1:lenUpdateRelevance 
                                                                    for h19 = 1:lenRelevanceNorm
                                                                    for h20 = 1:lenRelevanceSortType
                                                                    for h21 = 1:lenRelevanceFatorStd
                                                                    for h23 = 1:lenRelevanceFatorStd2    
                                                                    for h22 = 1:lenRelevanceCut
                                                                    for h24 = 1:lenRelevanceInicialize
                                                                    for h25 = 1:lenTransformFunction
                                                                    for h26 = 1:lenTransformFunctionParam 
                                                                    for h27 = 1:lenCentersThreshold
                                                                    for h28 = 1:lenTransformFunctionCutStd 
                                                                    for h29 = 1:lenDistanceExp    
                                                                    for z = 1:lenLimitWinners
                                                                        indexFator = 1;
%                                                                        for u = 1:lenFatorM
%                                                                            for x = 1:lenFatorBaseM
                                                                                

                                                                                Model.multiple.index = indexMultiple;
                                                                                Model.multiple.indexFator = indexFator;

                                                                                Model.multiple.trainType = trainType;
                                                                                Model.multiple.trainUnlearnType = trainUnlearnType;
                                                                                Model.multiple.trainUnlearnType2 = trainUnlearnType2;
                                                                                Model.multiple.numTest = numTest;
                                                                                Model.multiple.numMap = numMaps(m,:);
                                                                                Model.multiple.decayFilter = decayFilter;

                                                                                Model.multiple.normalizePipelineType = normalizePipelineType;
                                                                                Model.multiple.filter = filter;
                                                                                Model.multiple.numAtributes = numAtributes;
                                                                                for r = 1:classes
                                                                                    for t = 1:layers
                                                                                        Model.multiple.trainlen(t,r) = epochs(p,t); 
                                                                                    end;
                                                                                end;
                                                                                Model.multiple.a = a(k,:)' * ones(1,classes); 
                                                                                Model.multiple.aMin = aMin(k,:)' *ones(1,classes); 

                                                                                Model.multiple.window = window(s,:);
                                                                                Model.multiple.funcNeigh = 'gaussian';
                                                                                Model.multiple.inicializeMode = inicializeMode{n};
                                                                                Model.multiple.selectElementMode = selectElementMode;
                                                                                Model.multiple.learningMode = learningMode;
                                                                                Model.multiple.unlearnedRate = unlearnedRate(v,:);
                                                                                Model.multiple.unlearnedRateCrossCorrect = unlearnedRateCrossCorrect(v2,:);
                                                                                Model.multiple.relevancePercent = relevancePercent(h6,:);
                                                                                Model.multiple.relevancePercent2 = relevancePercent2(h15,:);
                                                                                Model.multiple.relevancePercent3 = relevancePercent3(h16,:);
                                                                                Model.multiple.relevancePercent4 = relevancePercent4(h17,:);
                                                                                Model.multiple.updatePrototype = updatePrototype(h9,:);
                                                                                Model.multiple.updateRelevance = updateRelevance(1,h18);
                                                                                Model.multiple.datasetType = datasetType;
                                                                                Model.multiple.setRelevance = setRelevance;%setRelevance(1,h24);  
                                                                                Model.multiple.relevanceInicialize = relevanceInicialize{1,h24};  
                                                                                Model.multiple.transformFunction = transformFunction{1,h25};
                                                                                Model.multiple.transformFunctionParam = transformFunctionParam(1,h26);
                                                                                Model.multiple.transformFunctionCutStd = transformFunctionCutStd(1,h28);
                                                                                Model.multiple.centersThreshold = centersThreshold(h27,:);
                                                                                Model.multiple.distanceExp = distanceExp(1,h29);
                                                                                Model.multiple.stage = stage;
                                                                                Model.multiple.meanRelevance = round(Model.multiple.trainlen(1,1)*rand());
                                                                                
                                                                                Model.multiple.limitWinners = limitWinners(z,:); 
                                                                                Model.multiple.decayEpoch = 0;
                                                                                Model.multiple.sigmaAtive = sigmaAtive(f,:);

                                                                                Model.multiple.flagToyProblem = flagToyProblem;
                                                                                Model.multiple.numToyProblem = numToyProblem;
                                                                                Model.multiple.concatOutput = concatOutput;
                                                                                Model.multiple.subSampling = subSampling(g,:); 
                                                                                Model.multiple.distanceType = distanceType;
                                                                                Model.multiple.flagToyProblemDificult = flagToyProblemDificult;
                                                                                Model.multiple.normalizeType = normalizeType{n2};
                                                                                Model.multiple.freezeLayer = freezeLayer; 
                                                                                Model.multiple.distanceExpPosition = distanceExpPosition;
                                                                                Model.multiple.batch = batch(b,:);
                                                                                if strcmp(distanceType(1),'relevance_reduction') || strcmp(distanceType(1),'relevance_mirror') || ...
                                                                                        strcmp(distanceType(1),'relevance_prototype') || strcmp(distanceType(1),'relevance_active') ||...
                                                                                        strcmp(distanceType(1),'relevance_variance')
                                                                                    for h11 = 1:numToyProblem
                                                                                        if strcmp(Model.database,'wine') 
                                                                                            Model.multiple.relevance{1}{h11} = ones(13,1);
                                                                                            Model.multiple.relevanceAttributesActives{1}{h11} = [1:13]';     
                                                                                        elseif strcmp(Model.database,'leukemia') 
                                                                                            Model.multiple.relevance{1}{h11} = ones(7128,1);
                                                                                            Model.multiple.relevanceAttributesActives{1}{h11} = [1:7128]';                                                                                               
                                                                                        elseif  strcmp(Model.database,'15_Scenes') || strcmp(Model.database,'67_Indoors') 
                                                                                            if strcmp(Model.featuresType,'pyramid')
                                                                                                Model.multiple.relevance{1}{h11} = ones(4200,1);
                                                                                                Model.multiple.relevanceAttributesActives{1}{h11} = [1:4200]';
                                                                                            elseif  strcmp(Model.featuresType,'vgg_19')
                                                                                                Model.multiple.relevance{1}{h11} = ones(4096,1);
                                                                                                Model.multiple.relevanceAttributesActives{1}{h11} = [1:4096]';
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                end;
                                                                                Model.multiple.normalizeRelevance = normalizeRelevance{:,c};
                                                                                Model.multiple.relevanceType = relevanceType{:,d};
                                                                                Model.multiple.relevanceMatrixType = relevanceMatrixType{:,e};
                                                                                Model.multiple.relevanceFunction = relevanceFunction{:,v3};
                                                                                Model.multiple.prototype = prototype;
                                                                                Model.multiple.prototypeRange = prototypeRange(h,:);
                                                                                Model.multiple.saturationCodebook = saturationCodebook{:,h2};
                                                                                Model.multiple.functionLearn = functionLearn{:,h3};
                                                                                Model.multiple.functionUnlearn = functionUnlearn{:,h4};
                                                                                Model.multiple.relevanceSelect = relevanceSelect{:,h5};
                                                                                Model.multiple.relevanceOrder = relevanceOrder{:,h7};
                                                                                Model.multiple.inputPrototype = inputPrototype{:,h8};
                                                                                Model.multiple.variancePipeline = variancePipeline{:,h10};
                                                                                Model.multiple.relevancePercentFlag = relevancePercentFlag{:,h12};
                                                                                Model.multiple.relevanceStatistic = relevanceStatistic{:,h13};
                                                                                Model.multiple.relevanceStatistic2 = relevanceStatistic2{:,h14};
                                                                                Model.multiple.relevanceNorm = relevanceNorm{h19,:};
                                                                                Model.multiple.relevanceSortType = relevanceSortType{h20,:};
                                                                                Model.multiple.relevanceFatorStd = relevanceFatorStd(1,h21);
                                                                                Model.multiple.relevanceFatorStd2 = relevanceFatorStd2(1,h23);
                                                                                Model.multiple.relevanceCut = relevanceCut{h22,:};
                                                                                Model.multiple.flagRelevanceSet = flagRelevanceSet;
                                                                                Model.multiple.initializePrototype = initializePrototype;
                                                                                
                                                                                createModelProbabilistic(Model,classes,index);

                                                                                
                                                                                save([Model.dir.models 'model_' num2str(index) '.mat'], 'Model');
                                                                                %savefast [Model.dir.models 'model_' num2str(index) '.mat'] Model;
                                                                                index = index + 1;
                                                                                indexFator = indexFator + 1;
                                                                           %end;
                                                                       %end;
                                                                       indexMultiple = indexMultiple + 1;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;                                                                    
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                    end;
                                                                end;
                                                           end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    
end


