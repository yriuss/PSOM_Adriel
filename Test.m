function [Mean] = Test(database, DataCompressionType, index)

    %database = getDatabaseName(Classes);

    load(['logs/models/' database '/model_' num2str(index) '.mat']);     
    
    disp('Train begin...');

    disp('Compressing data...');
    name = [Model.dir.output 'Output_single_'  num2str(Model.single.index) '_fator_' ...
                num2str(Model.single.indexFator) '_multiple_' num2str(Model.multiple.index) ...
                '_fator_' num2str(Model.multiple.indexFator) '.mat'];
            
    Classes = Model.numClasses;        
    if ~strcmp(Model.trainMode,'onlyCategorization')
        if exist(name) == 0
            [train_data,test_data, train_labels, test_labels] = Compression(Classes, DataCompressionType ,Model);
            save(name,'Model','train_data','test_data', 'train_labels', 'test_labels');  
        else
            load(name,'train_data', 'test_data', 'train_labels', 'test_labels');
        end;

        %%Delete sMaps
        for i= 1:length(Model.multiple.freezeLayer)
            if strcmp(Model.multiple.freezeLayer(i),'no')
                for r = 1:Model.multiple.numTest(i)
                    name = [Model.dir.mapsMultiple, 'sMaps_layer_' num2str(i+1) '_single_' num2str(Model.single.index) '_fator_' ...
                        num2str(Model.single.indexFator) '_multiple_' num2str(Model.multiple.index) ...
                        '_fator_' num2str(Model.multiple.indexFator) '_test_' num2str(r)  '.mat'];
                    if ~exist(name) == 0
                        if Classes ~= 3
                            %delete(name);
                        end;
                    end;
                end;
            end;
        end;
    else
        load(name,'train_data', 'test_data');
    end;

end    