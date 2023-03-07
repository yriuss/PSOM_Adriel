
% Marcondes Ricarte

function [fileNameTrain, fileNameTest] = DataFileNames(Model, k)


    %os = computer;
    %if strcmp(os,'GLNXA64')
    %    diretory = 'database/';
    %else
        diretory = 'database/';
    %end;
    

    if strcmp(Model.database, '8_Sports')
        if strcmp(Model.featuresType,'pyramid')
            fileNameTrain = [diretory '8_Sports/8_Sports_4200_train_' int2str(k) '.csv'];  %['labelMe8Train_0_5.data','labelMe8Train_0_9.data']
            fileNameTest = [diretory '8_Sports/8_Sports_4200_test_' int2str(k) '.csv'];   %['labelMe8Test_0_5.data','labelMe8Test_0_1.data']
        end;
    elseif strcmp(Model.database, '15_Scenes')
        if strcmp(Model.featuresType,'pyramid')
            if strcmp(Model.featuresType,'simple')
                fileNameTrain = [diretory '15_Scenes_200_train.data'];
                fileNameTest = [diretory '15_Scenes_200_test.data'];
            elseif strcmp(Model.featuresType,'pyramid')
                if Model.multiple.numToyProblem == 3
                    fileNameTrain = [diretory '15_Scenes_4200_train.data'];
                    fileNameTest = [diretory '15_Scenes_4200_test.data'];                 
                elseif Model.multiple.numToyProblem == 15
                    fileNameTrain = [diretory '15_Scenes_4200_train_new.data']; %[diretory '15_Scenes_4200_train.data'];
                    fileNameTest = [diretory '15_Scenes_4200_test_new.data']; %[diretory '15_Scenes_4200_test.data'];

                end;

            end;
        elseif  strcmp(Model.featuresType,'vgg_19')
            fileNameTrain = [diretory '15_Scenes_vgg/scenes_15_vgg19_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory '15_Scenes_vgg/scenes_15_vgg19_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];
        end;
    elseif strcmp(Model.database,'wine')
            fileNameTrain = [diretory 'wine/wine_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'wine/wine_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];  
    elseif strcmp(Model.database,'ms_coco')
            fileNameTrain = [diretory 'ms_coco/ms_coco_trainning_' int2str(1) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'ms_coco/ms_coco_testing_' int2str(1) '.csv']; %[diretory '15_Scenes_4200_test.data'];              
    elseif strcmp(Model.database,'heart')
            fileNameTrain = [diretory 'heart/heart_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'heart/heart_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];
    elseif strcmp(Model.database,'vehicle')
            fileNameTrain = [diretory 'vehicle/vehicle_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'vehicle/vehicle_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'coil')
        if strcmp(Model.featuresType,'vectorized')
            fileNameTrain = [diretory 'coil_vectorized/coil_vectorized_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'coil_vectorized/coil_vectorized_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];         
        elseif strcmp(Model.featuresType,'dsift')
            fileNameTrain = [diretory 'coil_dsift/coil_dsift_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'coil_dsift/coil_dsift_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
        elseif strcmp(Model.featuresType,'sdsift')
            fileNameTrain = [diretory 'coil_sdsift/coil_sdsift_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'coil_sdsift/coil_sdsift_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];     
        elseif strcmp(Model.featuresType,'hog')
            fileNameTrain = [diretory 'coil_hog/coil_hog_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'coil_hog/coil_hog_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];                 
        end;
    elseif strcmp(Model.database,'yale')
        if strcmp(Model.featuresType,'vectorized')
            fileNameTrain = [diretory 'yale_vectorized/yale_vectorized_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'yale_vectorized/yale_vectorized_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
        elseif strcmp(Model.featuresType,'sdsift')
            fileNameTrain = [diretory 'yale_sdsift/yale_sdsift_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'yale_sdsift/yale_sdsift_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];             
        end; 
    elseif strcmp(Model.database,'cifar_10')
        if strcmp(Model.featuresType,'vectorized')
            fileNameTrain = [diretory 'cifar_10_vectorized/cifar_10_vectorized_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'cifar_10_vectorized/cifar_10_vectorized_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
        end;  
    elseif strcmp(Model.database,'iris')
        fileNameTrain = [diretory 'iris/iris_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'iris/iris_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
    elseif strcmp(Model.database,'ionosphere')
        fileNameTrain = [diretory 'ionosphere/ionosphere_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'ionosphere/ionosphere_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
    elseif strcmp(Model.database,'motion_tracking')
        fileNameTrain = [diretory 'motion_tracking/motion_tracking_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'motion_tracking/motion_tracking_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
    elseif strcmp(Model.database,'segmentation')
        fileNameTrain = [diretory 'segmentation/segmentation_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'segmentation/segmentation_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data']; 
    elseif strcmp(Model.database,'usps')
        fileNameTrain = [diretory 'usps/usps_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'usps/usps_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];         
    elseif strcmp(Model.database,'digits')
        fileNameTrain = [diretory 'digits/digits_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'digits/digits_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];    
    elseif strcmp(Model.database,'letter')
        fileNameTrain = [diretory 'letter/letter_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'letter/letter_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];     
    elseif strcmp(Model.database,'isolet')
        fileNameTrain = [diretory 'isolet/isolet_training.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'isolet/isolet_testing.csv']; %[diretory '15_Scenes_4200_test.data'];         
    elseif strcmp(Model.database,'mnist')
        fileNameTrain = [diretory 'mnist/mnist_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'mnist/mnist_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];    
    elseif strcmp(Model.database,'67_Indoors')
            fileNameTrain = [diretory '67_Indoors/indoor_vgg19_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory '67_Indoors/indoor_vgg19_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];      
    elseif strcmp(Model.database,'caltech_101')
            fileNameTrain = [diretory 'caltech_101/caltech_vgg19_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'caltech_101/caltech_vgg19_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];                
    elseif strcmp(Model.database,'sun_397_vgg') || strcmp(Model.database,'sun_397')
            fileNameTrain = [diretory 'sun_397_vgg/sun_397_vgg_training_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'sun_397_vgg/sun_397_vgg_testing_' int2str(k) '.csv']; %[diretory '15_Scenes_4200_test.data'];  
    elseif strcmp(Model.database,'sun_rgbd_vgg') || strcmp(Model.database,'sun_rgbd')
            fileNameTrain = [diretory 'sun_rgbd_vgg/sun_rgbd_vgg_training.csv']; %[diretory '15_Scenes_4200_train.data'];
            fileNameTest = [diretory 'sun_rgbd_vgg/sun_rgbd_vgg_testing.csv']; %[diretory '15_Scenes_4200_test.data'];              
    elseif strcmp(Model.database,'uofa_clusters200_seqsize1_surf')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize1/SURF_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize1/SURF_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize3_surf')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize3/SURF_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize3/SURF_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize5_surf')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize5/SURF_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize5/SURF_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif strcmp(Model.database,'uofa_clusters200_seqsize1_sift')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize1/SIFT_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize1/SIFT_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize3_sift')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize3/SIFT_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize3/SIFT_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize5_sift')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize5/SIFT_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize5/SIFT_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif strcmp(Model.database,'uofa_clusters200_seqsize1_orb')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize1/ORB_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize1/ORB_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize3_orb')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize3/ORB_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize3/ORB_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
    elseif strcmp(Model.database,'uofa_clusters200_seqsize5_orb')
        fileNameTrain = [diretory 'uofa_clusters200_seqsize5/ORB_sequence1.csv']; %[diretory '15_Scenes_4200_train.data'];
        fileNameTest = [diretory 'uofa_clusters200_seqsize5/ORB_sequence2.csv']; %[diretory '15_Scenes_4200_test.data'];   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    end;

end