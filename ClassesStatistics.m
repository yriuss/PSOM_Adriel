% Marcondes Ricarte

clear;

Classes = 8;

if Classes == 4
    data = 'database\data4Classes.txt';
    label = 'database\labels4.txt';
    load database\labelsNames4.mat

    Dimension  = 20;
    DataCompressionType = 1;

    SamplesTrain = load(data)';
    SamplesTrain = (SamplesTrain >= 1); %Binary
    Labels = load(label)' + 1; %Shift na classes
    SamplesTrain = Compression(SamplesTrain, Labels, Classes, LabelsName, Dimension, DataCompressionType); 
    SplitDataTrain = SplitData(Classes, SamplesTrain, Labels);



    sumGlobal = sum(SamplesTrain');
    meanGlobal = mean(SamplesTrain');

    plot(sumGlobal);
    title('Sum Global');

    plot(meanGlobal);
    title('Mean Global');

    sumKitchen = sum(SplitDataTrain{1}.data');
    sumBathroom = sum(SplitDataTrain{2}.data');
    sumBedroom = sum(SplitDataTrain{3}.data');
    sumOffice = sum(SplitDataTrain{4}.data');

    subplot(5,1,1);
    plot(sumKitchen);
    title('Kitchen');

    subplot(5,1,2);
    plot(sumBathroom);
    title('Bathroom');

    subplot(5,1,3);
    plot(sumBedroom);
    title('Bedroom');

    subplot(5,1,4);
    plot(sumOffice);
    title('Office');

    subplot(5,1,5);
    plot(1:Dimension,sumKitchen', 1:Dimension,sumBathroom', 1:Dimension,sumBedroom', 1:Dimension,sumOffice');
    title('Global');

    meanKitchen = mean(SplitDataTrain{1}.data');
    meanBathroom = mean(SplitDataTrain{2}.data');
    meanBedroom = mean(SplitDataTrain{3}.data');
    meanOffice = mean(SplitDataTrain{4}.data');

    subplot(5,1,1);
    plot(meanKitchen);
    title('Kitchen');

    subplot(5,1,2);
    plot(meanBathroom);
    title('Bathroom');

    subplot(5,1,3);
    plot(meanBedroom);
    title('Bedroom');

    subplot(5,1,4);
    plot(meanOffice);
    title('Office');

    subplot(5,1,5);
    plot(1:Dimension,meanKitchen', 1:Dimension,meanBathroom', 1:Dimension,meanBedroom', 1:Dimension,meanOffice');
    title('Global');
    
elseif Classes == 8
    
    data = 'database\data8Classes.txt';
    label = 'database\labels8.txt';
    load database\labelsNames8.mat

    Dimension  = 20;%1380;
    DataCompressionType = 1;

    SamplesTrain = load(data)';
    SamplesTrain = (SamplesTrain >= 1); %Binary
    Labels = load(label)' + 1; %Shift na classes
    SamplesTrain = Compression(SamplesTrain, Labels, Classes, LabelsName, Dimension, DataCompressionType); 
    SplitDataTrain = SplitData(Classes, SamplesTrain, Labels);


    sumGlobal = sum(SamplesTrain');
    meanGlobal = mean(SamplesTrain');

    plot(sumGlobal);
    title('Sum Global');

    plot(meanGlobal);
    title('Mean Global');

    sumKitchen = sum(SplitDataTrain{1}.data');
    sumBathroom = sum(SplitDataTrain{2}.data');
    sumBedroom = sum(SplitDataTrain{3}.data');
    sumOffice = sum(SplitDataTrain{4}.data');
    sumConferenceRoom = sum(SplitDataTrain{5}.data');
    sumCorridor = sum(SplitDataTrain{6}.data');
    sumLivingRoom = sum(SplitDataTrain{7}.data');
    sumDiningRoom = sum(SplitDataTrain{8}.data');
    
    subplot(5,2,1);
    plot(sumKitchen);
    title('Kitchen');

    subplot(5,2,2);
    plot(sumBathroom);
    title('Bathroom');

    subplot(5,2,3);
    plot(sumBedroom);
    title('Bedroom');

    subplot(5,2,4);
    plot(sumOffice);
    title('Office');

    subplot(5,2,5);
    plot(sumConferenceRoom);
    title('Conference Room');

    subplot(5,2,6);
    plot(sumCorridor);
    title('Corridor');

    subplot(5,2,7);
    plot(sumLivingRoom);
    title('Living Room');

    subplot(5,2,8);
    plot(sumDiningRoom);
    title('Dining Room');
    
    subplot(5,2,9);
    plot(1:Dimension,sumKitchen', 1:Dimension,sumBathroom', 1:Dimension,sumBedroom', 1:Dimension,sumOffice',1:Dimension,sumConferenceRoom', 1:Dimension,sumCorridor', 1:Dimension,sumLivingRoom', 1:Dimension,sumDiningRoom');
    title('Global');

    meanKitchen = mean(SplitDataTrain{1}.data');
    meanBathroom = mean(SplitDataTrain{2}.data');
    meanBedroom = mean(SplitDataTrain{3}.data');
    meanOffice = mean(SplitDataTrain{4}.data');
    meanConferenceRoom = mean(SplitDataTrain{5}.data');
    meanCorridor = mean(SplitDataTrain{6}.data');
    meanLivingRoom = mean(SplitDataTrain{7}.data');
    meanDiningRoom = mean(SplitDataTrain{8}.data');

    subplot(5,2,1);
    plot(meanKitchen);
    title('Kitchen');

    subplot(5,2,2);
    plot(meanBathroom);
    title('Bathroom');

    subplot(5,2,3);
    plot(meanBedroom);
    title('Bedroom');

    subplot(5,2,4);
    plot(meanOffice);
    title('Office');

    subplot(5,2,5);
    plot(meanConferenceRoom);
    title('Conference Room');

    subplot(5,2,6);
    plot(meanCorridor);
    title('Corridor');

    subplot(5,2,7);
    plot(meanLivingRoom);
    title('Living Room');

    subplot(5,2,8);
    plot(meanDiningRoom);
    title('Dining Room');
    
    subplot(5,2,9);
    plot(1:Dimension,meanKitchen', 1:Dimension,meanBathroom', 1:Dimension,meanBedroom', 1:Dimension,meanOffice',1:Dimension,meanConferenceRoom', 1:Dimension,meanCorridor', 1:Dimension,meanLivingRoom', 1:Dimension,meanDiningRoom');
    title('Global');
    
end



