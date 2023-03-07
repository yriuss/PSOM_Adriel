% Marcondes Ricarte

function selected = SelectElement(Model, SamplesTrain, type, classNames, train_labels)

%classNames = unique(SamplesTrain.labels);
classes = length(classNames);

if strcmp(Model.multiple.flagToyProblem,'yes')
    classes = Model.multiple.numToyProblem;
else
    classes = Model.numClasses;
end;

dlen = length(SamplesTrain.labels);

selected = [];
 

if strcmp(type,'balancedSelect')
     %labels = unique(SamplesTrain.labels);
     %labels = unique(SamplesTrain.labels); % order by alphabeth
     labels = uniqueLabels(SamplesTrain, classes); % order by data
     for i = 1:classes
         indexs = find(train_labels == i); %strmatch(labels(i), SamplesTrain.labels,'exact');
         classLen(i) = length(indexs);
     end;
     majorClass = max(classLen);
     classFator = floor(majorClass./classLen);

     for i = 1:Model.multiple.numToyProblem
         i
         indexs = find(train_labels == i); %strmatch(labels(i), SamplesTrain.labels,'exact');
         if ~isempty(indexs)
            for j = 1:classFator(i)             
                selected = [selected indexs];
             end;
         end;
     end;

elseif strcmp(type,'noBalanced')
    selected = [1:dlen];
elseif strcmp(type,'oneCategory')
    labels = uniqueLabels(SamplesTrain, classes);
    selected = strmatch(labels(Model.i), SamplesTrain.labels,'exact'); 
elseif strcmp(type,'oneCategoryBalanced')
    labels = uniqueLabels(SamplesTrain, classes);
    for i = 1:classes
        indexs = strmatch(labels(i), SamplesTrain.labels,'exact');
        classLen(i) = length(indexs);
    end;
    majorClass = max(classLen);
    classFator = floor(majorClass/classLen(Model.i));
    selected = strmatch(labels(Model.i), SamplesTrain.labels,'exact');    
    selected = repmat(selected, classFator, 1);
end;


% Scramble
selectLength = length(selected);
for i=1:10*selectLength
     index1 = randi(selectLength);
     index2 = randi(selectLength);
     temp = selected(index1);
     selected(index1) = selected(index2);
     selected(index2) = temp;
 end

