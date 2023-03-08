% Marcondes Ricarte

clear all 
close(gcf);

addpath(genpath('SOM'));
addpath(genpath('Util'));
addpath(genpath('Viewer'));
addpath(genpath('libs'));
addpath(genpath('EMSOM'));
 
databases = {'uofa_clusters200_seqsize1_surf', 'uofa_clusters200_seqsize3_surf', 'uofa_clusters200_seqsize5_surf', ...
             'uofa_clusters200_seqsize1_sift', 'uofa_clusters200_seqsize3_sift', 'uofa_clusters200_seqsize5_sift', ...
             'uofa_clusters200_seqsize1_orb', 'uofa_clusters200_seqsize3_orb', 'uofa_clusters200_seqsize5_orb'};

%database = 'uofa'; %['wine','15_Scenes', 'LabelMe_8','8_Sports','67_Indoors','heart','vehicle','coil','yale','caltech_101','cifar_10',
                             %'iris','ionosphere','letter','motion_tracking','segmentation','usps','digits','mnist','sun_rgbd']

for database = databases
    database = cell2mat(database);
    SOMType = 'som'; % 'som', 'deepsom'
    trainMode = 'onlyCompression'; % 'onlyCompression', 'all', 'onlyCategorization'
    DataCompressionType = 3; % Nothing = 0, Clustering Static = 1, DeepSOM = 2, Kmeans Euclidian = 3, Kmeans Correlation = 4, SOM = 5, Kmeans Class = 6.
    layer = 1;

    Model = createModel(database, SOMType, trainMode, layer); 

    %database = getDatabaseName(Classes);
    files = what( ['logs/models/' database '/'] );   

    len =  length(files.mat);
    shuffle = 1:len;
    %shuffle = shuffle(randperm(length(shuffle)));

    Test(database, DataCompressionType, 1 );

    gen_D(database)
    %if layer == 1
    %    if strcmp(database,'67_Indoors') || strcmp(database,'sun_rgbd')
    %        for i = 1:len
    %            Test(database, DataCompressionType, shuffle(i) );
    %        end;
    %    else
    %        parfor i = 1:len
    %            Test(database, DataCompressionType, shuffle(i) );
    %        end;
    %    end;
    %else
    %    if strcmp(database,'67_Indoors') || strcmp(database,'15_Scenes') || strcmp(database,'sun_rgbd')
    %        for i = 1:len
    %            Test(database, DataCompressionType, shuffle(i) );
    %        end;    
    %    else
    %        for i = 1:len
    %            Test(database, DataCompressionType, shuffle(i) );
    %        end;         
    %    end;
    %end;
end


% Finished simulation
%%[y,Fs] = audioread('D:/Mestrado/Disserta��o/Projeto/trunk/Matlab/PSOM/Util/music/tema.mp3');
%%sound(y,Fs);