% Marcondes Ricarte

function [SamplesTrain, SamplesTest, train_labels, test_labels] = Compression(Classes, Type, Model)

if strcmp(Model.compressionType,'no')
    [fileNameTrain, fileNameTest] = DataFileNames(Model, numClass);
    SamplesTrain = som_read_data(fileNameTrain);
    SamplesTest = som_read_data(fileNameTest);
    [SamplesTrain.data,SamplesTest.data] = ...
            NormalizeData(SamplesTrain.data, SamplesTest.data, Model.normalizeType); 
    SamplesTrain = SamplesTrain.data';
    SamplesTest = SamplesTest.data';
elseif Type == 0
    SamplesTrain = ExecutePCA(SamplesTrain,Dimension);
elseif Type == 1
    disp('Clustering data hard.');
    [row,col] = size(SamplesTrain);
    SamplesTrainClustering = [];
    BlockSize = floor(row/Dimension); 
    for i=1:Dimension
        IndexBegin  = 1+((i-1)*BlockSize);
        IndexEnd = i*BlockSize;
        SamplesTrainClustering = [SamplesTrainClustering; sum(SamplesTrain(IndexBegin:IndexEnd,:))];
    end
    SamplesTrain = SamplesTrainClustering;
    disp('Normalize data.');
elseif strcmp(Model.compressionType,'deepsom')
    disp('Clustering DeepSOM.');
    [SamplesTrain,SamplesTest, train_labels, test_labels] = DeepSOM(Classes,Model); %DeepSOM(selected,train,numClass,Model);
    disp('Normalize data.');
elseif Type == 3 | Type == 4 | Type == 5
    disp('Clustering data Kmeans.');
    SamplesTrainBinary = (SamplesTrain >= 1);
    if Type == 3
        Indexes = kmeans(SamplesTrainBinary, Dimension);
    elseif Type == 4
        Indexes = kmeans(SamplesTrainBinary, Dimension,'distance','correlation');
    elseif Type == 5
        net = selforgmap([5 5], 50);
        net = configure(net,SamplesTrainBinary');
        net = train(net,SamplesTrainBinary');
        view(net)
        y = net(SamplesTrainBinary');
        Indexes = vec2ind(y);
        Indexes = Indexes';
    end        
    hist(Indexes,Dimension);
    
    [rowIndexes,colIndexes] = size(Indexes);
    for i=1:Dimension
        disp(i);
        for j=1:rowIndexes
            if Indexes(j,1) == i 
                disp(ObjectsName(j,:));
            end 
        end
    end
        
    SamplesTrainClustering = [];
    Singles = [];
    for i=1:Dimension
        Index  = [];
        for j=1:rowIndexes
            if Indexes(j,1) == i
                Index = [Index j];
            end            
        end
        [rowIndex, colIndex] = size(Index);            
        if colIndex == 1
            SamplesTrainClustering = [SamplesTrainClustering; SamplesTrain(Index(1,:),:)];
            %Singles = [Singles Index];
        elseif colIndex ~= 0
            SamplesTrainClustering = [SamplesTrainClustering; sum(SamplesTrain(Index(1,:),:))];
        end
    end
    
    %[rowSingles, colSingles] = size(Singles);
    %if colSingles > 1
        %SamplesTrainClustering = [sum(SamplesTrain(Singles(1,:),:)) ; SamplesTrainClustering];
    %end
    
    DatabaseStatistics(SamplesTrainClustering);
    SamplesTrain = SamplesTrainClustering;
    
    disp('Normalize data.');
    SamplesTrain = normr(SamplesTrain);
elseif Type == 6
    disp('Clustering data Kmeans for categories.');
    SamplesTrainBinary = (SamplesTrain >= 1);
    [rowSamplesTrain,colSamplesTrain] = size(SamplesTrain);

    SamplesTrainClustering = [];
    for i=1:Classes
        SamplesTrainCluster = [];
        for j=1:colSamplesTrain
            if Labels(1,j) == i
                SamplesTrainCluster = [SamplesTrainCluster SamplesTrainBinary(:,j)];
            end
        end
        %Indexes = kmeans(SamplesTrainCluster, Dimension/Classes ); 
        net = selforgmap([3 2], 50, 2);
        net = configure(net,SamplesTrainCluster');
        net = train(net,SamplesTrainCluster');
        view(net)
        y = net(SamplesTrainCluster');
        Indexes = vec2ind(y);
        Indexes = Indexes';
        hist(Indexes,(Dimension/Classes));    

        [F,c]=hist(Indexes,(Dimension/Classes));
        [ValueMax,IndexMax] = max(F);
        [rowIndexes,colIndexes] = size(Indexes);
        for j=1:(Dimension/Classes)
            %if j~= IndexMax
                disp(j);
                for k=1:rowIndexes
                    if Indexes(k,1) == j 
                        disp(ObjectsName(k,:));
                    end 
                end
            %end
        end        
        
        for j=1:(Dimension/Classes)
            %if j~= IndexMax
                Index  = [];
                for k=1:rowIndexes
                    if Indexes(k,1) == j
                        Index = [Index k];
                    end            
                end
                [rowIndex, colIndex] = size(Index);            
                if colIndex == 1
                    SamplesTrainClustering = [SamplesTrainClustering; SamplesTrain(Index(1,:),:)];
                elseif colIndex ~= 0
                    SamplesTrainClustering = [SamplesTrainClustering; mean(SamplesTrain(Index(1,:),:))];
                end
            %end
        end
        
    end
        
    
    DatabaseStatistics(SamplesTrainClustering);
    SamplesTrain = SamplesTrainClustering;
    
    disp('Normalize data.');
    SamplesTrain = normr(SamplesTrain);
end