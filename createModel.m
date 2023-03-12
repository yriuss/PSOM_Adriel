% Marcondes Ricarte

function ModelCollection = createModel(database, SOMType, trainMode, layer)


ModelCollection = [];
pipeline = 'single_multiple'; %['single', 'single_multiple', 'multiple']
numLayer = layer + 1; %total


if strcmp(database,'15_Scenes')
    classes = 15;
elseif strcmp(database,'67_Indoors')
    classes = 67;
elseif strcmp(database,'sun_rgbd')
    classes = 19;    
elseif strcmp(database,'8_Sports')
    classes = 8;   
elseif strcmp(database,'iris')
    classes = 3;
elseif strcmp(database,'letter')
    classes = 26;
elseif strcmp(database,'wine')
    classes = 3;    
elseif strcmp(database,'heart')
     classes = 2;  
elseif strcmp(database,'ms_coco') 
    classes = 80;
elseif strcmp(database,'vehicle') 
    classes = 4;
elseif strcmp(database,'coil')  
    classes = 20;   
elseif strcmp(database,'yale')  
     classes = 38;   
elseif strcmp(database,'caltech_101')   
    classes = 102;  
elseif strcmp(database,'cifar_10')  
    classes = 10;
elseif strcmp(database,'ionosphere')  
    classes = 2;   
elseif strcmp(database,'segmentation')  
    classes = 7;
elseif strcmp(database,'usps')  
    classes = 10;    
elseif strcmp(database,'digits')  
    classes = 10;        
elseif strcmp(database,'mnist')  
    classes = 10;       
elseif strcmp(database,'motion_tracking')  
    classes = 6;
elseif strcmp(database(1:4), 'uofa')
    classes = 15;
elseif strcmp(database, 'kitti')
    classes = 15;
end;


featuresType = 'vgg_19'; % 'vgg_19','pyramid','dsift','sdsift','vectorized','hog' 

% flag plot
flagPlotSamplesForLayer = 'no';
flagPlotCategoryForLayer = 'no';
flagPlotWinners = 'yes';
flagPlotMaps = 'no';
flagPlotDistributions = 'no';
flagPlotConfuseMatrix = 'yes';
flagPlotMapActive = 'no';
flagPlotDebugWinners = 'yes';
flagPlotDebugBMUs = 'no';
flagPlotDebugData = 'no';


dir  = ['logs/figs/' database '/'];
dirResults  = ['logs/results/' database '/'];
dirMaps  = ['logs/maps/' database '/'];
dirOutput  = ['logs/output/' database '/'];
dirDebug  = ['logs/debug/' database '/'];
dirPlotData  = ['logs/plot_data/' database '/'];
if(strcmp(database(1:4), 'uofa'))
    dirModels  = ['logs/models/' database(1:4) '/'];
else
    dirModels  = ['logs/models/' database '/'];
end

resultsSingle = [dirResults 'single/'];
resultsMultiple = [dirResults 'multiple/'];
resultsProbabilistic = [dirResults 'probabilistic/'];
mapsSingle  = [dirMaps 'single/'];
mapsMultiple  = [dirMaps 'multiple/'];

layer1 = [dir 'layer_1_unique/'];
layer2 = [dir 'layer_2_multiple/'];
layer3 = [dir 'layer_3_multiple/'];
layer4 = [dir 'layer_4_multiple/'];
layer5 = [dir 'layer_5_multiple/'];
layerProbability = [dir 'layer_probability/'];
categories = 'categories/';
winners = 'winners/';
histogram = 'histogram/';

test.num = 1;

files = what(dirModels);


len = length(files.mat);
for i = 1:len
    delete([dirModels char(files.mat(i))]);
end;


    selectElementMode = 'noBalanced';
    if strcmp(database, 'ms_coco') || strcmp(database, '67_Indoors') || strcmp(database, 'wine') || strcmp(database, 'heart')  || strcmp(database, 'vehicle') || ...
            strcmp(database, 'coil')  || strcmp(database, 'caltech_101') || strcmp(database, 'cifar_10') || strcmp(database, 'iris')  || strcmp(database, 'ionosphere') || ...
            strcmp(database, 'segmentation')  || strcmp(database, 'usps') || strcmp(database, 'digits') || strcmp(database, 'mnist') || strcmp(database, 'motion_tracking')  || ...
            strcmp(database, 'sun_rgbd')
        normalizeType = [{'attributes_selected'}]; %[{'attributes_z_score'}]; %[{'attributes_selected'}]; %[{'attributes_all'}];
    elseif strcmp(database, 'yale')   
        normalizeType = [{'global'}]; %[{'attributes_all'}];
    else
        normalizeType = [{'attributes_selected'}];  %{'attributes_selected_with_test'}; %{'global'},{'attributes_selected_with_test'}; %{'attributes_selected','attributes_selected_with_test'}; %[{'attributes_selected_with_test'},{'no'},{'attributes_all_with_test'}]; %[{'global'},{'samples'},{'attributes_independent'},{'attributes_train'}]; % [{'no'}]; %[{'attributes_all_with_test'}]; %[{'attributes_all_with_test'},{'attributes_selected_with_test'}]; %[{'attributes_selected'},{'attributes_selected_saturation'},{'attributes'},{'attributes_sasturation'}];
    end;
    fatorFilter = 0;
% %         normalizeType = [{'attributes_pos_filter'},{'attributes_norm_percentual_samples_filter'},...
% %             {'attributes_norm_percentual_samples_filter'}, {'attributes_norm_percentual_samples_filter'},...
% %             {'attributes_norm_percentual_attributes_filter'}, 'attributes_norm_percentual_attributes_filter',...
% %             'attributes_norm_percentual_attributes_filter','attributes_selected'];
% %         fatorFilter = [0.05 0.05 0.10 0.30 0.05 0.10 0.30];
        %'attributes_norm_percentual_attributes_filter'; 
        %['no','samples','attributes','attributes_max','attributes_standard_deviation', 'attributes_filter'
        % 'attributes_pos_filter', 'attributes_samples_filter', 'attributes_norm_percentual_samples_filter'
        % 'attributes_norm_percentual_attributes_filter']         
    normalizePipelineType = 'no'; 
        %['no','samples','attributes','attributes_standard_deviation', 'exp']
    if strcmp(SOMType,'deepsom') % TODO
        filter = 'yes';
        inicializeMode = 'random'; %['random', 'samples', 'samples_mean']
        normalizeOutUniqueType = 'no';
    elseif strcmp(SOMType,'som')
        filter = 'yes';
        inicializeMode = 'samples'; %['random', 'samples', 'samples_mean', 'samples_region', 'order']
        normalizeOutUniqueType = 'no'; %['no','attributes']
    end;
    compressionType = 'deepsom'; % ['no', 'deepsom']
    sigmaAtive = [10];

    
    numMaps = [256]; % [64, 256]
    aLabel = {'neuron','neuron','dimension'};
    aMinLabel = {'dimension','samples','samples'};
    a =     [0.1]; % [0.1 0.1]  %[1/numMaps(1)   1/numMaps(1)    1/200];
    aMin =  [0.01]; % [0.01 0.001]   %[1/4200          1/1500         1/1500];
    fator = [-10.0]; %[1.2]; %[1.2 1.3 1.4]; %[1.0 1.1 1.2 1.3 1.4]; %[0.6:0.2:1.4]; 
    epochs = [10]; %[10 20]
    tau = [3];
    window = [40]; %[10 20 40]
         


    lenNumMap = length(numMaps); 
    lenA = length(a);
    lenEpochs = length(epochs);
    lenTau = length(tau);
    lenFator = length(fator);
    lenWindow = length(window);
    lenFatorFilter = length(fatorFilter);
    lenNormalizeType = length(normalizeType);
    lenSigmaAtive = length(sigmaAtive);
    
    index = 1;
    indexSingle = 1; 
    for n = 1:lenNumMap
        for m = 1:lenEpochs
            for i = 1:lenA
                for j = 1:lenTau
                    for q = 1:lenWindow
                        for p = 1:lenSigmaAtive
                            for s = 1:lenNormalizeType
                                for r = 1:lenFatorFilter
                                    indexFator = 1;
                                    for k = 1:lenFator
                                        Model{index}.index = index
                                        Model{index}.single.index = indexSingle;


                                        Model{index}.dir.layer1 = layer1;
                                        Model{index}.dir.layer2 = layer2;
                                        Model{index}.dir.layer3 = layer3;
                                        Model{index}.dir.layer4 = layer4;
                                        Model{index}.dir.layer5 = layer5;
                                        Model{index}.dir.layerProbability = layerProbability;
                                        Model{index}.dir.winners = winners;
                                        Model{index}.dir.histogram = histogram;
                                        Model{index}.dir.categories = categories;
                                        Model{index}.dir.resultsSingle = resultsSingle;
                                        Model{index}.dir.resultsMultiple = resultsMultiple;
                                        Model{index}.dir.resultsProbabilistic = resultsProbabilistic;
                                        Model{index}.dir.mapsSingle = mapsSingle;
                                        Model{index}.dir.mapsMultiple = mapsMultiple;
                                        Model{index}.dir.output = dirOutput;
                                        Model{index}.dir.debug = dirDebug;
                                        Model{index}.dir.plotData = dirPlotData;
                                        Model{index}.dir.models = dirModels;

                                        Model{index}.flag.plotSamplesForLayer = flagPlotSamplesForLayer;
                                        Model{index}.flag.plotCategoryForLayer = flagPlotCategoryForLayer;
                                        Model{index}.flagPlotWinners = flagPlotWinners;
                                        Model{index}.flagPlotMaps = flagPlotMaps;
                                        Model{index}.flagPlotDistributions = flagPlotDistributions;
                                        Model{index}.flagPlotConfuseMatrix = flagPlotConfuseMatrix;
                                        Model{index}.flagPlotMapActive = flagPlotMapActive;
                                        Model{index}.flag.plotDebugWinners = flagPlotDebugWinners;
                                        Model{index}.flag.plotDebugBMUs = flagPlotDebugBMUs;
                                        Model{index}.flag.plotDebugData = flagPlotDebugData;

                                        Model{index}.test.num = test.num;
                                        Model{index}.test.scoreTrain = zeros(test.num,1);
                                        Model{index}.test.scoreTest = zeros(test.num,1);
                                        Model{index}.test.confuseMatrix = cell(test.num,1);

                                        Model{index}.numClasses = classes;
                                        Model{index}.numLayer = numLayer;
                                        Model{index}.single.numMap = numMaps(n);
                                        Model{index}.database = database;
                                        Model{index}.featuresType = featuresType;
                                        Model{index}.single.inicializeMode = inicializeMode;
                                        Model{index}.compressionType = compressionType;
                                        Model{index}.single.fatorFilter = fatorFilter(r); 
                                        Model{index}.pipeline = pipeline;
                                        Model{index}.single.normalizeType = normalizeType{s};
                                        Model{index}.single.normalizeOutUniqueType = normalizeOutUniqueType;
                                        Model{index}.normalizePipelineType = normalizePipelineType;
                                        Model{index}.single.filter = filter;
                                        Model{index}.single.trainlen = epochs(m);
                                        Model{index}.single.aLabel = aLabel(i);
                                        Model{index}.single.a = a(i);
                                        Model{index}.single.aMinLabel = aMinLabel(i);
                                        Model{index}.single.aMin = aMin(i);
                                        Model{index}.single.decay = (aMin(i)/a(i))^(1/Model{index}.single.trainlen);
                                        Model{index}.single.window = window(q);
                                        Model{index}.single.tau = tau(j);
                                        Model{index}.single.funcNeigh = 'gaussian';            
                                        Model{index}.single.selectElementMode = selectElementMode;
                                        Model{index}.single.learningMode = 'standard';
                                        Model{index}.single.decayEpoch = 0.1; 
                                        Model{index}.single.sigmaAtive = sigmaAtive(p);

                                        Model{index}.single.indexFator = indexFator;
                                        Model{index}.single.fator = fator(k);

                                        Model{index}.trainMode = trainMode;
                                        Model{index}.featuresType = featuresType;;

                                        Models = createModelMultiple(Model{index},classes,index);
                                        ModelCollection = [ModelCollection Models];

                                        index = index + 1; %length(Models);
                                        indexFator = indexFator + 1; 
                                    end;
                                    indexSingle = indexSingle + 1; 
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

end