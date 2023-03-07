clear all;


experiments = 10;
categories = 3;
colors = ['b', 'r', 'g'];
dimensions = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
targets = {'train', 'test'};



for exp = 1:1%experiments
    load(['C:\Doutorado\PSOM\Viewer\samples\data\dataIris_' num2str(exp) '.mat'])
    
    load(['C:\Doutorado\PSOM\Viewer\samples\data\unitary\sMaps_layer_2_single_1_fator_1_multiple_1_fator_1_test_' num2str(exp) '.mat'])
    Model1 = Model;
    DeepSOM1 = DeepSOM;

    load(['C:\Doutorado\PSOM\Viewer\samples\data\with_relevancies\sMaps_layer_2_single_1_fator_1_multiple_1_fator_1_test_' num2str(exp) '.mat'])
    Model2 = Model;
    DeepSOM2 = DeepSOM;

    load(['C:\Doutorado\PSOM\Viewer\samples\data\without_relevancies\sMaps_layer_2_single_1_fator_1_multiple_1_fator_1_test_' num2str(exp) '.mat'])
    Model3 = Model;
    DeepSOM3 = DeepSOM;    

    [prototypesSize, dim] = size(DeepSOM{1,1}.relevance);

    [~,epochs] = size(Model.test.debug.acurracyTrain);


    [dimensionsLen,~] = size(dimensions);
    for target = 1:2
        for dimension = 1:dimensionsLen
        
            dim1 = dimensions(dimension,1);
            dim2 = dimensions(dimension,2);
    
% % 
% %             diretory = ['unitary_exp_' num2str(exp) '\' targets{target}]; 
% %             if ~exist(diretory, 'dir')
% %                 mkdir(diretory);
% %             end;
% % 
% %             video = VideoWriter([diretory '\attributes_' num2str(dim1) '_' num2str(dim2) '.mp4'],'MPEG-4');
% %             open(video);                
% %         
% %             for epoch = 1:epochs
% %                 epoch
% %                      
% %                 for cat = 1:categories
% %                     if strcmp( targets{target}, 'train')
% %                         correct = Model1.test.debug.matchesTrain(epoch,:);
% %                         incorrect = ~Model1.test.debug.matchesTrain(epoch,:);
% %                         
% %                         pointX = SamplesTrain.data(train_labels(exp,:) == cat & correct, dim1);
% %                         pointY = SamplesTrain.data(train_labels(exp,:) == cat & correct, dim2);
% %                         scatter(pointX,pointY, 10, colors(cat))
% %                         hold on
% %                         pointX = SamplesTrain.data(train_labels(exp,:) == cat & incorrect, dim1);
% %                         pointY = SamplesTrain.data(train_labels(exp,:) == cat & incorrect, dim2);
% %                         scatter(pointX,pointY, 50, colors(cat), 'Marker', '*')
% %                         hold on
% %                     elseif strcmp( targets{target}, 'test')
% %                         correct = Model1.test.debug.matchesTest(epoch,:);
% %                         incorrect = ~Model1.test.debug.matchesTest(epoch,:);
% %                         
% %                         pointX = SamplesTest.data(test_labels == cat & correct, dim1);
% %                         pointY = SamplesTest.data(test_labels == cat & correct, dim2);
% %                         scatter(pointX,pointY, 10, colors(cat))
% %                         hold on
% %                         pointX = SamplesTest.data(test_labels == cat & incorrect, dim1);
% %                         pointY = SamplesTest.data(test_labels == cat & incorrect, dim2);
% %                         scatter(pointX,pointY, 50, colors(cat), 'Marker', '*')
% %                         hold on
% %                     end;
% %                     
% %                 end;
% %                 
% %                 for cat = 1:categories
% %                     for prototypes = 1:prototypesSize
% %                         pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim1);
% %                         pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim2);
% %                         scatter(pointX,pointY, 100, colors(cat), 'LineWidth', 2)
% %                         hold on
% %                     end;            
% %                 end;
% %                 if strcmp( targets{target}, 'train')
% %                     title(['Unitary - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTrain: ' num2str(Model1.test.debug.acurracyTrain(epoch) ) ])
% %                 elseif strcmp( targets{target}, 'test')
% %                     title(['Unitary -  Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTest: ' num2str(Model1.test.debug.acurracyTest(epoch) ) ])                    
% %                 end;                        
% %                 hold off
% %                            
% %                 xlabel(['Attribute ' num2str(dim1)])
% %                 ylabel(['Attribute ' num2str(dim2)])
% %                 set(gcf, 'Position', get(0, 'Screensize'));
% %                 set(gcf, 'innerposition', [0 0 1000 1000]);
% %                 frame = getframe(gcf);
% %                 for freq = 1:30
% %                     writeVideo(video,frame)
% %                 end;
% %             end;
% %         
% %             close(video);


            %%%%%%%%%%%%%%%%%%%%%%%%%%% plot 2 %%%%%%%%%%%%%%%
        
            for type = 1:2
                if type == 1
                    diretory = ['with_relevancies_exp_' num2str(exp) '\' targets{target}]; 
                    Model1 = Model2;
                    DeepSOM1 = DeepSOM2;
               else type == 2 
                    diretory = ['without_relevancies_exp_' num2str(exp) '\' targets{target}];
                    Model1 = Model3;
                    DeepSOM1 = DeepSOM3;
                end;
                if ~exist(diretory, 'dir')
                    mkdir(diretory);
                end;
    
                video = VideoWriter([diretory '\attributes_' num2str(dim1) '_' num2str(dim2) '.mp4'],'MPEG-4');
                open(video);                
    
                
    
                for epoch = 1:epochs
                    epoch
                    
                         
                    for cat = 1:categories
                        for cat2 = 1:categories
                            subplot(1,3,cat)
                            if strcmp( targets{target}, 'train')
                                correct = Model1.test.debug.matchesTrain(epoch,:);
                                incorrect = ~Model1.test.debug.matchesTrain(epoch,:);
                                
                                pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTrain.data(train_labels(exp,:) == cat2 & correct, :);
                                pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTrain.data(train_labels(exp,:) == cat2 & correct, :);
                                scatter(pointX(:,dim1),pointY(:,dim2), 10, colors(cat2))
                                hold on
                                pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTrain.data(train_labels(exp,:) == cat2 & incorrect, :);
                                pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTrain.data(train_labels(exp,:) == cat2 & incorrect, :);
                                scatter(pointX(:,dim1),pointY(:,dim2), 50, colors(cat2), 'Marker', '*')
                                hold on
                            elseif strcmp( targets{target}, 'test')
                                correct = Model1.test.debug.matchesTest(epoch,:);
                                incorrect = ~Model1.test.debug.matchesTest(epoch,:);
                                
                                pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTest.data(test_labels == cat2 & correct, :);
                                pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTest.data(test_labels == cat2 & correct, :);
                                scatter(pointX(:,dim1),pointY(:,dim2), 10, colors(cat2))
                                hold on
                                pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTest.data(test_labels == cat2 & incorrect, :);
                                pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* SamplesTest.data(test_labels == cat2 & incorrect, :);
                                scatter(pointX(:,dim1),pointY(:,dim2), 50, colors(cat2), 'Marker', '*')
                                hold on
                            end;
                        end;
                    end;
                    
                    for cat = 1:categories
                        subplot(1,3,cat)
                        for prototypes = 1:prototypesSize
                            pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,:);
                            pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.relevance(1,:) .* Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,:);
                            scatter(pointX(:,dim1),pointY(:,dim2), 100, colors(cat), 'LineWidth', 2)
                            axis([0 1 0 1])
                            %hold off
                        end;            
                    end;
                    
                    subplot(1,3,2)
                    if type == 1
                        if strcmp( targets{target}, 'train')
                            title(['With relevancies - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTrain: ' num2str(Model1.test.debug.acurracyTrain(epoch) ) ])
                        elseif strcmp( targets{target}, 'test')
                            title(['With relevancies - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTest: ' num2str(Model1.test.debug.acurracyTest(epoch) ) ])                    
                        end;                        
                    elseif type == 2
                        if strcmp( targets{target}, 'train')
                            title(['Without relevancies - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTrain: ' num2str(Model1.test.debug.acurracyTrain(epoch) ) ])
                        elseif strcmp( targets{target}, 'test')
                            title(['Without relevancies - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTest: ' num2str(Model1.test.debug.acurracyTest(epoch) ) ])                    
                        end;                                                
                    end;

                               
    
                    subplot(1,3,1)
                    hold off
                    %set(subplot(1,3,1), 'Position', [0 0 200 200]);
                    xlabel(['Attribute ' num2str(dim1)])
                    ylabel(['Attribute ' num2str(dim2)])                
                    subplot(1,3,2)
                    hold off     
                    %set(gcf, 'innerposition', [0 0 500 500]);
                    xlabel(['Attribute ' num2str(dim1)])
                    ylabel(['Attribute ' num2str(dim2)])                
                    subplot(1,3,3)
                    hold off                
                    %set(gcf, 'innerposition', [0 0 500 500]);
                    xlabel(['Attribute ' num2str(dim1)])
                    ylabel(['Attribute ' num2str(dim2)])                
    
                    %set(gcf, 'Position', get(0, 'Screensize'));
                    set(gcf, 'Position', [0 0 2000 500]);
    
                    frame = getframe(gcf);
                    for freq = 1:30
                        writeVideo(video,frame)
                    end;
                end;
            
                close(video);
    
    
            end;
    
        end;
    end;

end;




% % for exp = 1:experiments
% %     load(['C:\Doutorado\PSOM\Viewer\samples\data\dataIris_' num2str(exp) '.mat'])
% %     
% %     load(['C:\Doutorado\PSOM\Viewer\samples\data\sMaps_layer_2_single_1_fator_1_multiple_1_fator_1_test_' num2str(exp) '.mat'])
% %     Model1 = Model;
% %     DeepSOM1 = DeepSOM;
% % 
% %     load(['C:\Doutorado\PSOM\Viewer\samples\data\sMaps_layer_2_single_1_fator_1_multiple_1_fator_1_test_' num2str(exp) '_r.mat'])
% %     Model2 = Model;
% %     DeepSOM2 = DeepSOM;
% % 
% %     [prototypesSize, dim] = size(DeepSOM{1,1}.relevance);
% % 
% %     [~,epochs] = size(Model.test.debug.acurracyTrain);
% % 
% % 
% %     [dimensionsLen,~] = size(dimensions);
% %     for target = 1:2
% %         for dimension = 1:dimensionsLen
% %         
% %             dim1 = dimensions(dimension,1);
% %             dim2 = dimensions(dimension,2);
% %     
% %             diretory = ['exp_' num2str(exp) '\' targets{target}]; 
% %             if ~exist(diretory, 'dir')
% %                 mkdir(diretory);
% %             end;
% % 
% %             video = VideoWriter([diretory '\attributes_' num2str(dim1) '_' num2str(dim2) '.mp4'],'MPEG-4');
% %             open(video);
% %                 
% %         
% %             for epoch = 1:epochs -1 %retirar
% %                 epoch
% %                      
% %                 for cat = 1:categories
% %                     for sub = 1:2
% %                         if sub == 1
% %                             subplot(1,2,1)
% %                         elseif sub == 2
% %                             subplot(1,2,2)
% %                         end;
% %                         if strcmp( targets{target}, 'train')
% %                             if sub == 1
% %                                 correct = Model1.test.debug.matchesTrain(epoch,:);
% %                                 incorrect = ~Model1.test.debug.matchesTrain(epoch,:);
% %                             elseif sub == 2                                
% %                                 correct = Model2.test.debug.matchesTrain(epoch,:);
% %                                 incorrect = ~Model2.test.debug.matchesTrain(epoch,:);
% %                             end;
% % 
% %                             pointX = SamplesTrain.data(train_labels == cat & correct, dim1);
% %                             pointY = SamplesTrain.data(train_labels == cat & correct, dim2);
% %                             scatter(pointX,pointY, 10, colors(cat))
% %                             hold on
% %                             pointX = SamplesTrain.data(train_labels == cat & incorrect, dim1);
% %                             pointY = SamplesTrain.data(train_labels == cat & incorrect, dim2);
% %                             scatter(pointX,pointY, 50, colors(cat), 'Marker', '*')
% %                             hold on
% %                         elseif strcmp( targets{target}, 'test')
% %                             if sub == 1
% %                                 correct = Model1.test.debug.matchesTest(epoch,:);
% %                                 incorrect = ~Model1.test.debug.matchesTest(epoch,:);
% %                             elseif sub == 2                                
% %                                 correct = Model2.test.debug.matchesTest(epoch,:);
% %                                 incorrect = ~Model2.test.debug.matchesTest(epoch,:);
% %                             end;
% %                             pointX = SamplesTest.data(test_labels == cat & correct, dim1);
% %                             pointY = SamplesTest.data(test_labels == cat & correct, dim2);
% %                             scatter(pointX,pointY, 10, colors(cat))
% %                             hold on
% %                             pointX = SamplesTest.data(test_labels == cat & incorrect, dim1);
% %                             pointY = SamplesTest.data(test_labels == cat & incorrect, dim2);
% %                             scatter(pointX,pointY, 50, colors(cat), 'Marker', '*')
% %                             hold on
% %                         end;
% %                     end;
% % 
% %                 end;
% %                 for sub = 1:2
% %                     if sub == 1
% %                         subplot(1,2,1)                
% %                         for cat = 1:categories
% %                             for prototypes = 1:prototypesSize
% %                                 if epoch > 1
% %                                 pointX = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim1);
% %                                 pointY = Model1.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim2);
% %                                 scatter(pointX,pointY, 100, colors(cat), 'LineWidth', 2)
% %                                 hold on
% %                                 end;
% %                             end;            
% %                         end;
% %                         if strcmp( targets{target}, 'train')
% %                             title(['Update without relevances - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTrain: ' num2str(Model1.test.debug.acurracyTrain(epoch) ) ])
% %                         elseif strcmp( targets{target}, 'test')
% %                             title(['Update without relevances -  Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTest: ' num2str(Model1.test.debug.acurracyTest(epoch) ) ])                    
% %                         end;                        
% %                         hold off
% %                     elseif sub == 2
% %                         subplot(1,2,2)                
% %                         for cat = 1:categories
% %                             for prototypes = 1:prototypesSize
% %                                 if epoch > 1
% %                                 pointX = Model2.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim1);
% %                                 pointY = Model2.test.debug.som{epoch}.DeepSOM{cat,1}.sMap.codebook(prototypes,dim2);
% %                                 scatter(pointX,pointY, 100, colors(cat), 'LineWidth', 2)
% %                                 hold on
% %                                 end;
% %                             end;            
% %                         end;
% %                         if strcmp( targets{target}, 'train')
% %                             title(['Update with relevances - Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTrain: ' num2str(Model2.test.debug.acurracyTrain(epoch) ) ])
% %                         elseif strcmp( targets{target}, 'test')
% %                             title(['Update with relevances -  Experiment: ' num2str(exp) ' - Dimensions ' num2str(dim1) ' and ' num2str(dim2)  ' - Epoch ' (num2str(epoch) - 1) '. AccuracyTest: ' num2str(Model2.test.debug.acurracyTest(epoch) ) ])                    
% %                         end;                        
% %                         hold off
% %                     end;
% %                 end;
% % 
% %                 set(gcf, 'Position', get(0, 'Screensize'));
% %                 frame = getframe(gcf);
% %                 for freq = 1:30
% %                     writeVideo(video,frame)
% %                 end;
% %             end;
% %         
% %             close(video);
% %     
% %         end;
% %     end;
% % 
% % end;
