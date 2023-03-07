function [sMap, sTrain, Model] = som_deeptrain(sMap, sData, D, varargin)

%SOM_SEQTRAIN  Use sequential algorithm to train the Self-Organizing Map.
%
% [sM,sT] = som_seqtrain(sM, D, [[argID,] value, ...])
% 
%  sM     = som_seqtrain(sM,D);
%  sM     = som_seqtrain(sM,sD,'alpha_type','power','tracking',3);
%  [M,sT] = som_seqtrain(M,D,'ep','trainlen',10,'inv','hexa');
%
%  Input and output arguments ([]'s are optional): 
%   sM      (struct) map struct, the trained and updated map is returned
%           (matrix) codebook matrix of a self-organizing map
%                    size munits x dim or  msize(1) x ... x msize(k) x dim
%                    The trained map codebook is returned.
%   D       (struct) training data; data struct
%           (matrix) training data, size dlen x dim
%   [argID, (string) See below. The values which are unambiguous can 
%    value] (varies) be given without the preceeding argID.
%
%   sT      (struct) learning parameters used during the training
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'mask'        (vector) BMU search mask, size dim x 1
%   'msize'       (vector) map size
%   'radius'      (vector) neighborhood radiuses, length 1, 2 or trainlen
%   'radius_ini'  (scalar) initial training radius
%   'radius_fin'  (scalar) final training radius
%   'alpha'       (vector) learning rates, length trainlen
%   'alpha_ini'   (scalar) initial learning rate
%   'tracking'    (scalar) tracking level, 0-3 
%   'trainlen'    (scalar) training length
%   'trainlen_type' *(string) is the given trainlen 'samples' or 'epochs'
%   'train'      *(struct) train struct, parameters for training
%   'sTrain','som_train '  = 'train'
%   'alpha_type' *(string) learning rate function, 'inv', 'linear' or 'power'
%   'sample_order'*(string) order of samples: 'random' or 'ordered'
%   'neigh'      *(string) neighborhood function, 'gaussian', 'cutgauss',
%                          'ep' or 'bubble'
%   'topol'      *(struct) topology struct
%   'som_topol','sTopo l'  = 'topol'
%   'lattice'    *(string) map lattice, 'hexa' or 'rect'
%   'shape'      *(string) map shape, 'sheet', 'cyl' or 'toroid'
%
% For more help, try 'type som_seqtrain' or check out online documentation.
% See also  SOM_MAKE, SOM_BATCHTRAIN, SOM_TRAIN_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_seqtrain
%
% PURPOSE
%
% Trains a Self-Organizing Map using the sequential algorithm. 
%
% SYNTAX
%
%  sM = som_seqtrain(sM,D);
%  sM = som_seqtrain(sM,sD);
%  sM = som_seqtrain(...,'argID',value,...);
%  sM = som_seqtrain(...,value,...);
%  [sM,sT] = som_seqtrain(M,D,...);
%
% DESCRIPTION
%
% Trains the given SOM (sM or M above) with the given training data
% (sD or D) using sequential SOM training algorithm. If no optional
% arguments (argID, value) are given, a default training is done, the
% parameters are obtained from SOM_TRAIN_STRUCT function. Using
% optional arguments the training parameters can be specified. Returns
% the trained and updated SOM and a train struct which contains
% information on the training.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 78-82.
% Kohonen, T., "Clustering, Taxonomy, and Topological Maps of
%    Patterns", International Conference on Pattern Recognition
%    (ICPR), 1982, pp. 114-128.
% Kohonen, T., "Self-Organized formation of topologically correct
%    feature maps", Biological Cybernetics 43, 1982, pp. 59-69.
%
% REQUIRED INPUT ARGUMENTS
%
%  sM          The map to be trained. 
%     (struct) map struct
%     (matrix) codebook matrix (field .data of map struct)
%              Size is either [munits dim], in which case the map grid 
%              dimensions (msize) should be specified with optional arguments,
%              or [msize(1) ... msize(k) dim] in which case the map 
%              grid dimensions are taken from the size of the matrix. 
%              Lattice, by default, is 'rect' and shape 'sheet'.
%  D           Training data.
%     (struct) data struct
%     (matrix) data matrix, size [dlen dim]
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is
%  used. The valid IDs and corresponding values are listed below. The values 
%  which are unambiguous (marked with '*') can be given without the 
%  preceeding argID.
%
%   'mask'       (vector) BMU search mask, size dim x 1. Default is 
%                         the one in sM (field '.mask') or a vector of
%                         ones if only a codebook matrix was given.
%   'msize'      (vector) map grid dimensions. Default is the one
%                         in sM (field sM.topol.msize) or 
%                         'si = size(sM); msize = si(1:end-1);' 
%                         if only a codebook matrix was given. 
%   'radius'     (vector) neighborhood radius 
%                         length = 1: radius_ini = radius
%                         length = 2: [radius_ini radius_fin] = radius
%                         length > 2: the vector given neighborhood
%                                     radius for each step separately
%                                     trainlen = length(radius)
%   'radius_ini' (scalar) initial training radius
%   'radius_fin' (scalar) final training radius
%   'alpha'      (vector) learning rate
%                         length = 1: alpha_ini = alpha
%                         length > 1: the vector gives learning rate
%                                     for each step separately
%                                     trainlen is set to length(alpha)
%                                     alpha_type is set to 'user defined'
%   'alpha_ini'  (scalar) initial learning rate
%   'tracking'   (scalar) tracking level: 0, 1 (default), 2 or 3
%                         0 - estimate time 
%                         1 - track time and quantization error 
%                         2 - plot quantization error
%                         3 - plot quantization error and two first 
%                             components 
%   'trainlen'   (scalar) training length (see also 'tlen_type')
%   'trainlen_type' *(string) is the trainlen argument given in 'epochs'
%                         or in 'samples'. Default is 'epochs'.
%   'sample_order'*(string) is the sample order 'random' (which is the 
%                         the default) or 'ordered' in which case
%                         samples are taken in the order in which they 
%                         appear in the data set
%   'train'     *(struct) train struct, parameters for training. 
%                         Default parameters, unless specified, 
%                         are acquired using SOM_TRAIN_STRUCT (this 
%                         also applies for 'trainlen', 'alpha_type',
%                         'alpha_ini', 'radius_ini' and 'radius_fin').
%   'sTrain', 'som_train' (struct) = 'train'
%   'neigh'     *(string) The used neighborhood function. Default is 
%                         the one in sM (field '.neigh') or 'gaussian'
%                         if only a codebook matrix was given. Other 
%                         possible values is 'cutgauss', 'ep' and 'bubble'.
%   'topol'     *(struct) topology of the map. Default is the one
%                         in sM (field '.topol').
%   'sTopol', 'som_topol' (struct) = 'topol'
%   'alpha_type'*(string) learning rate function, 'inv', 'linear' or 'power'
%   'lattice'   *(string) map lattice. Default is the one in sM
%                         (field sM.topol.lattice) or 'rect' 
%                         if only a codebook matrix was given. 
%   'shape'     *(string) map shape. Default is the one in sM
%                         (field sM.topol.shape) or 'sheet' 
%                         if only a codebook matrix was given. 
%   
% OUTPUT ARGUMENTS
% 
%  sM          the trained map
%     (struct) if a map struct was given as input argument, a 
%              map struct is also returned. The current training 
%              is added to the training history (sM.trainhist).
%              The 'neigh' and 'mask' fields of the map struct
%              are updated to match those of the training.
%     (matrix) if a matrix was given as input argument, a matrix
%              is also returned with the same size as the input 
%              argument.
%  sT (struct) train struct; information of the accomplished training
%  
% EXAMPLES
%
% Simplest case:
%  sM = som_seqtrain(sM,D);  
%  sM = som_seqtrain(sM,sD);  
%
% To change the tracking level, 'tracking' argument is specified:
%  sM = som_seqtrain(sM,D,'tracking',3);
%
% The change training parameters, the optional arguments 'train', 
% 'neigh','mask','trainlen','radius','radius_ini', 'radius_fin', 
% 'alpha', 'alpha_type' and 'alpha_ini' are used. 
%  sM = som_seqtrain(sM,D,'neigh','cutgauss','trainlen',10,'radius_fin',0);
%
% Another way to specify training parameters is to create a train struct:
%  sTrain = som_train_struct(sM,'dlen',size(D,1),'algorithm','seq');
%  sTrain = som_set(sTrain,'neigh','cutgauss');
%  sM = som_seqtrain(sM,D,sTrain);
%
% By default the neighborhood radius goes linearly from radius_ini to
% radius_fin. If you want to change this, you can use the 'radius' argument
% to specify the neighborhood radius for each step separately:
%  sM = som_seqtrain(sM,D,'radius',[5 3 1 1 1 1 0.5 0.5 0.5]);
%
% By default the learning rate (alpha) goes from the alpha_ini to 0
% along the function defined by alpha_type. If you want to change this, 
% you can use the 'alpha' argument to specify the learning rate
% for each step separately: 
%  alpha = 0.2*(1 - log([1:100]));
%  sM = som_seqtrain(sM,D,'alpha',alpha);
%
% You don't necessarily have to use the map struct, but you can operate
% directly with codebook matrices. However, in this case you have to
% specify the topology of the map in the optional arguments. The
% following commads are identical (M is originally a 200 x dim sized matrix):
%  M = som_seqtrain(M,D,'msize',[20 10],'lattice','hexa','shape','cyl');
%
%  M = som_seqtrain(M,D,'msize',[20 10],'hexa','cyl');
%
%  sT= som_set('som_topol','msize',[20 10],'lattice','hexa','shape','cyl');
%  M = som_seqtrain(M,D,sT);
%
%  M = reshape(M,[20 10 dim]);
%  M = som_seqtrain(M,D,'hexa','cyl');
%
% The som_seqtrain also returns a train struct with information on the 
% accomplished training. This is the same one as is added to the end of the 
% trainhist field of map struct, in case a map struct is given.
%  [M,sTrain] = som_seqtrain(M,D,'msize',[20 10]);
%
%  [sM,sTrain] = som_seqtrain(sM,D); % sM.trainhist{end}==sTrain
%
% SEE ALSO
% 
%  som_make         Initialize and train a SOM using default parameters.
%  som_batchtrain   Train SOM with batch algorithm.
%  som_train_struct Determine default training parameters.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 220997
% Version 2.0beta juuso 101199
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check arguments

error(nargchk(2, Inf, nargin));  % check the number of input arguments

% map 
struct_mode = isstruct(sMap);
if struct_mode, 
  sTopol = sMap.topol;
else  
  orig_size = size(sMap);
  if ~ismatrix(sMap), 
    si = size(sMap); dim = si(end); msize = si(1:end-1);
    M = reshape(sMap,[prod(msize) dim]);
  else
    msize = [orig_size(1) 1]; 
    dim = orig_size(2);
  end
  sMap   = som_map_struct(dim,'msize',msize);
  sTopol = sMap.topol;
end
[munits dim] = size(sMap.codebook);

% data
if isstruct(D), 
  data_name = D.name; 
  D = D.data; 
else 
  data_name = inputname(2); 
end
%D = D(find(sum(isnan(D),2) < dim),:); % remove empty vectors from the data
[dlen ddim] = size(D);                % check input dimension
if dim ~= ddim, error('Map and data input space dimensions disagree.'); end

% varargin
sTrain = som_set('som_train','algorithm','seq','neigh', ...
		 sMap.neigh,'mask',sMap.mask,'data_name',data_name);
radius     = [];
alpha      = [];
tracking   = 1;
sample_order_type = 'random';
tlen_type  = 'epochs';

i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     % argument IDs
     case 'msize', i=i+1; sTopol.msize = varargin{i}; 
     case 'lattice', i=i+1; sTopol.lattice = varargin{i};
     case 'shape', i=i+1; sTopol.shape = varargin{i};
     case 'mask', i=i+1; sTrain.mask = varargin{i};
     case 'neigh', i=i+1; sTrain.neigh = varargin{i};
     case 'trainlen', i=i+1; sTrain.trainlen = varargin{i};
     case 'trainlen_type', i=i+1; tlen_type = varargin{i}; 
     case 'tracking', i=i+1; tracking = varargin{i};
     case 'model', i=i+1; Model = varargin{i};
     case 'SamplesTest', i=i+1; sDataTest = varargin{i};
     case 'DeepSOM', i=i+1; DeepSOM = varargin{i};    
     case 'sample_order', i=i+1; sample_order_type = varargin{i};
     case 'radius_ini', i=i+1; sTrain.radius_ini = varargin{i};
     case 'radius_fin', i=i+1; sTrain.radius_fin = varargin{i};
     case 'radius', 
      i=i+1; 
      l = length(varargin{i}); 
      if l==1, 
        sTrain.radius_ini = varargin{i}; 
      else 
        sTrain.radius_ini = varargin{i}(1); 
        sTrain.radius_fin = varargin{i}(end);
        if l>2, radius = varargin{i}; tlen_type = 'samples'; end
      end 
     case 'alpha_type', i=i+1; sTrain.alpha_type = varargin{i};
     case 'alpha_ini', i=i+1; sTrain.alpha_ini = varargin{i};
     case 'alpha',     
      i=i+1; 
      sTrain.alpha_ini = varargin{i}(1);
      if length(varargin{i})>1, 
        alpha = varargin{i}; tlen_type = 'samples'; 
        sTrain.alpha_type = 'user defined'; 
      end
     case {'sTrain','train','som_train'}, i=i+1; sTrain = varargin{i};
     case {'topol','sTopol','som_topol'}, 
      i=i+1; 
      sTopol = varargin{i};
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
      % unambiguous values
     case {'inv','linear','power'}, sTrain.alpha_type = varargin{i}; 
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i}; 
     case {'gaussian','cutgauss','ep','bubble'}, sTrain.neigh = varargin{i};
     case {'epochs','samples'}, tlen_type = varargin{i};
     case {'random', 'ordered'}, sample_order_type = varargin{i}; 
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) & isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
     case 'som_topol', 
      sTopol = varargin{i}; 
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
     case 'som_train', sTrain = varargin{i};
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_seqtrain) Ignoring invalid argument #' num2str(i+2)]); 
  end
  i = i+1; 
end

% training length
if ~isempty(radius) | ~isempty(alpha), 
  lr = length(radius);
  la = length(alpha);
  if lr>2 | la>1,
    tlen_type = 'samples';
    if     lr> 2 & la<=1, sTrain.trainlen = lr;
    elseif lr<=2 & la> 1, sTrain.trainlen = la;
    elseif lr==la,        sTrain.trainlen = la;
    else
      error('Mismatch between radius and learning rate vector lengths.')
    end
  end
end
if strcmp(tlen_type,'samples'), sTrain.trainlen = sTrain.trainlen/dlen; end 

% check topology
if struct_mode, 
  if ~strcmp(sTopol.lattice,sMap.topol.lattice) | ...
	~strcmp(sTopol.shape,sMap.topol.shape) | ...
	any(sTopol.msize ~= sMap.topol.msize), 
    warning('Changing the original map topology.');
  end
end
sMap.topol = sTopol; 

% complement the training struct
sTrain = som_train_struct(sTrain,sMap,'dlen',dlen);
if isempty(sTrain.mask), sTrain.mask = ones(dim,1); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize

M        = sMap.codebook;
mask     = sTrain.mask;

% % if strcmp(Model.multiple.trainType,'competition')
% %     for k = 1:Model.numClasses 
% %         Ms{k}.M = sMap.codebook;
% %     end;
% % end;




% neighborhood radius
%if length(radius)>2,
  %radius_type = 'user defined';
%else
  %radius = [sTrain.radius_ini sTrain.radius_fin];    
  %rini = radius(1); 
  %rstep = (radius(end)-radius(1))/(trainlen-1);
  %radius_type = 'linear';
  % new definition
  %window = (sMap.topol.msize(1,1)/100);
  %radius = window * (ones(1,trainlen))./(2.^(0:trainlen-1));
  %radius(ceil(window):trainlen) = 0; 
%end
trainlen = 10;
radius_type = 'user defined';
window = (sMap.topol.msize(1,1)/100);
radius = window *(ones(1,trainlen))./(2.^(0:trainlen-1));  
radius(ceil(window):trainlen) = 0;  

% learning rate
if length(alpha)>1, 
  sTrain.alpha_type ='user defined';
  if length(alpha) ~= trainlen, 
    error('Trainlen and length of neighborhood radius vector do not match.')
  end
  if any(isnan(alpha)), 
    error('NaN is an illegal learning rate.')
  end
else
  if isempty(alpha), alpha = sTrain.alpha_ini; end
  if strcmp(sTrain.alpha_type,'inv'), 
    % alpha(t) = a / (t+b), where a and b are chosen suitably
    % below, they are chosen so that alpha_fin = alpha_ini/100
    b = (trainlen - 1) / (100 - 1);
    a = b * alpha;
  end
end
                                   
% initialize random number generator
rand('state',sum(100*clock));

% distance between map units in the output space
%  Since in the case of gaussian and ep neighborhood functions, the 
%  equations utilize squares of the unit distances and in bubble case
%  it doesn't matter which is used, the unitdistances and neighborhood
%  radiuses are squared.
Ud = som_unit_dists(sTopol).^2; %TODO

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

update_step = ceil(dlen/100); %update_step = 100; TODO 
mu_x_1 = ones(munits,1);
samples = ones(update_step,1);
r = samples; 
alfa = samples;

qe = 0;
start = clock;
if tracking >  0, % initialize tracking
  track_table = zeros(update_step,1);
  qe = zeros(floor(trainlen/update_step),1);  
end




% Load parameters
if strcmp(Model.pipelineExec,'single')
    a = Model.single.a;
    aMin = Model.single.aMin;
    decay = Model.single.decay;
    window = Model.single.window;
    %tau = Model.single.tau;
    funcNeigh = Model.single.funcNeigh;
    trainlen = Model.single.trainlen;
    selectElementMode = Model.single.selectElementMode; 
    decayEpoch = Model.single.decayEpoch;
    learningMode = Model.single.learningMode;
    aMinEpoch = (1-decayEpoch)*a;
else %if strcmp(Model.pipelineExec,'multiple')
    i = Model.i; % class
    j = Model.j; % pipeline
    a = Model.multiple.a(j,i);
    aMin = Model.multiple.aMin(j,i);
    %decay = Model.multiple.decay(j,i);
    windowIni = Model.multiple.window(j);
    window = Model.multiple.window(j);
    %tau = Model.multiple.tau(j);
    funcNeigh = Model.multiple.funcNeigh;
    trainlen = Model.multiple.trainlen(j,i);
    selectElementMode = Model.multiple.selectElementMode; 
    decayEpoch = Model.multiple.decayEpoch;
    learningMode = Model.multiple.learningMode;
    unlearnedRate = Model.multiple.unlearnedRate(1,j);
    unlearnedRateCrossCorrect = Model.multiple.unlearnedRateCrossCorrect(1,j);
%    unlearnedRateEnd = Model.multiple.unlearnedRateEnd;
end;
print = 0;

windowIni = window;
selectedTotal = [];
labels = uniqueLabels(sData, Model.numClasses); % order by data
sMap.victories = zeros(munits, Model.numClasses);
sMap.winnersUnlearned = zeros(munits,1);



if strcmp(Model.multiple.inputPrototype{j},'yes')
    DeepSOMCopy = DeepSOM;
    for t = 1:Model.multiple.numToyProblem
        indexes = find(sData.train_labels == t);
        lenIndexes = length(indexes);
        [lenCodebook,~] = size(DeepSOM{t,j-1}.sMap.codebook());
        indexesOrder = randi([1 lenCodebook], 1, lenIndexes);
        for u = 1:lenIndexes
            DeepSOM{t,j-1}.BMUsValuesTrain(indexes(u), :) = DeepSOM{t,j-1}.sMap.codebook(mod(indexes(u),lenCodebook)+1,:);
        end;
    end;
end;


if strcmp(Model.multiple.trainType,'competition')
    for t = 1:Model.multiple.numToyProblem %Model.numClasses 
        sMaps{t}.sMap = sMap;
        if j == 1
            %if Model.single'samples'
            if strcmp(Model.multiple.inicializeMode(j),'random')
                sMaps{t}.sMap.codebook = (0.002 *rand([munits dim])) - 0.001;
            elseif strcmp(Model.multiple.inicializeMode(j),'mean_random')
                sMaps{t}.sMap.codebook = mean(D(sData.train_labels == t,:)) + (0.00002 *rand([munits dim])) - 0.00001;
            end;
        else
            if ~(~strcmp(Model.multiple.prototype{j},'no') || strcmp(Model.multiple.distanceType{j},'relevance_prototype') || strcmp(Model.multiple.distanceType(i),'relevance_mirror'))
                if strcmp(Model.multiple.concatOutput,'no') %|| strcmp(Model.multiple.distanceType{j},'relevance_active') 
                    if strcmp(Model.multiple.inicializeMode(j),'random')
                        sMaps{t}.sMap.codebook = (0.0000002 *rand([munits Model.multiple.numMap(j-1)])) - 0.0000001;
                    elseif strcmp(Model.multiple.inicializeMode(j),'mean_random')
                        sMaps{t}.sMap.codebook = mean(DeepSOM{t,j-1}.BMUsValuesTrain(sData.train_labels == t,:)) + (0.00002 *rand([munits Model.multiple.numMap(j-1)])) - 0.00001;
                    end;
                elseif strcmp(Model.multiple.concatOutput,'concat') 
                        sMaps{t}.sMap.codebook = (0.00002 *rand([munits (Model.multiple.numToyProblem*Model.multiple.numMap(j-1)) ])) -  0.00001;
                elseif strcmp(Model.multiple.concatOutput,'concat_bmu') 
                    sMaps{t}.sMap.codebook = (0.00002 *rand([munits (Model.multiple.numToyProblem) ])) -  0.00001;
                elseif strcmp(Model.multiple.concatOutput,'concat_subsampling')
                    sMaps{t}.sMap.codebook = (0.00002 *rand([munits ((Model.multiple.numToyProblem*Model.multiple.numMap(j-1))/Model.multiple.subSampling(j-1)) ])) -  0.00001;
                elseif strcmp(Model.multiple.concatOutput,'compress')
                    % TODO
                    sMaps{t}.sMap.codebook = (0.00002 *rand([munits (2*Model.multiple.numMap(j-1)) ])) - 0.00001;
                    %sMaps{t}.sMap.codebook = (0.00002 *rand([munits (Model.multiple.numMap(j-1)+Model.multiple.numToyProblem-1) ])) - 0.00001;
                end;
            else                
                if strcmp(Model.multiple.inicializeMode(j),'random')
                    sMaps{t}.sMap.codebook = (0.0000002 *rand([munits (ddim) ])) -  0.0000001;
                elseif strcmp(Model.multiple.inicializeMode(j),'mean_random')
                    if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes') )
                        [~,dimTrain] = size(DeepSOM{t,j-1}.BMUsValuesTrain);
                        sMaps{t}.sMap.codebook = mean(DeepSOM{t,j-1}.BMUsValuesTrain(sData.train_labels == t,:)) + (0.02 *rand([munits dimTrain ])) -  0.01;                        
                    else
                        sMaps{t}.sMap.codebook = mean(DeepSOM{t,j-1}.BMUsValuesTrain{1}(sData.train_labels == t,:)) + (0.02 *rand([munits (ddim) ])) -  0.01;
                    end;
                end;
            end;
            %sMaps{t}.sMap.codebook = (0.02 *rand([munits 15*Model.multiple.numMap(j-1)])) - 0.01;
            %sMaps{t}.sMap.codebook = (0.02 *rand([munits 15])) - 0.01;
            if ((j > 1)) && strcmp(Model.multiple.trainUnlearnType2,'dual')
                sMaps{t}.sMap.codebookDual = (0.02 *rand([munits Model.multiple.numMap(j-1)])) - 0.01;
            end;
        end;
        Ms{t}.M = sMaps{t}.sMap.codebook;
        if ((j > 1)) && strcmp(Model.multiple.trainUnlearnType2,'dual')
            Ms{t}.MDual = sMaps{t}.sMap.codebookDual;
        end;
        for t2 = 1:trainlen
            sMaps{t}.sMap.histogram{t2}.learnedWin = zeros(munits,1);
            sMaps{t}.sMap.histogram{t2}.unlearnedWin = zeros(munits,1);
        end;
        if strcmp(Model.multiple.initializePrototype{j},'copyCodebookRelevance')
            Ms{t}.M = DeepSOM{t,j-1}.sMap.codebook;
            DeepSOM{t,j}.relevance = DeepSOM{t,j-1}.relevance;
        elseif strcmp(Model.multiple.initializePrototype{j},'copyRelevance')
            DeepSOM{t,j}.relevance = DeepSOM{t,j-1}.relevance;
        end;        
        
    end;
end;

compare = [];
unlearnedTotalArray = [];



 for cat = 1:Model.numClasses
    DeepSOM{cat,j}.indexAlpha = ones(1,munits);
    DeepSOM{cat,j}.winner = zeros(1,munits);
 end;


for t = 1:trainlen
    if strcmp(Model.multiple.trainType,'single')
        sMap.winnersUnlearned = zeros(munits,1);
        sMap.winners = zeros(munits,1); % Inicialize for Epochs
        sMap.victoriesEpochs = zeros(munits,classes); % Inicialize for Epochs
    end;
% %     if strcmp(Model.pipelineExec,'single')
% %         waitbar(t/trainlen);
% %     elseif strcmp(Model.pipelineExec,'multiple')
% %         waitbar(t/trainlen, bar, ['SOM Training Pipeline ' int2str(i) ' Layer ' int2str(j+1) ' ...'])
% %     end;
    selected = SelectElement(Model, sData, selectElementMode, labels, sData.train_labels);
    selectedTotal = [selectedTotal selected'];
    %window = ceil(windowIni*((trainlen-3*t+1)/trainlen)); % TODO
    window = ceil(windowIni*((2*trainlen-3*t+3)/(2*trainlen)));
    dlen = length(selected);
    
    if strcmp(learningMode,'decayEpoch')
        aStep = (a-aMinEpoch)/dlen; 
    end;    
          % Every update_step, new values for sample indeces, neighborhood
      % radius and learning rate are calculated. This could be done
      % every step, but this way it is more efficient. Or this could 
      % be done all at once outside the loop, but it would require much
      % more memory.
      ind = rem(t,update_step); if ind==0, ind = update_step; end
      if ind==1, 

        steps = [1:trainlen];

         
         coef = (aMin/a)^(trainlen/(steps(trainlen)-1));   
         alfa = a * coef.^((steps-1)/trainlen);  % ((aMin-a)/trainlen)*[0:trainlen-1]+a;

         unAlfa = unlearnedRate*ones(1,trainlen);
         unAlfaCrossCorrect = unlearnedRateCrossCorrect*ones(1,trainlen);
      end
    
    if strcmp(Model.multiple.trainType,'single')
        % vazio
    elseif strcmp(Model.multiple.trainType,'competition')

        if t == 1 & strcmp(Model.flag.plotDebugData,'yes')
            [Model.test.debug.acurracyTrain(1),Model.test.debug.histogramTrain{1},Model.test.debug.ratioBMUsTrain(1,:), matchesTrainBase, Model.test.debug.errorNoSupervisedCorrectTrain(1,:), Model.test.debug.errorNoSupervisedAllTrain{1}] = ...
                debugWinners(Model, sData, Ms, munits, labels, DeepSOM);
            [Model.test.debug.acurracyTest(1),Model.test.debug.histogramTest{1},Model.test.debug.ratioBMUsTest(1,:), matchesTestBase, Model.test.debug.errorNoSupervisedCorrectTest(1,:), Model.test.debug.errorNoSupervisedAllTest{1}] = ...
                debugWinners(Model, sDataTest, Ms, munits, labels, DeepSOM);
            Model.test.debug.matchesTrain(t,:) = matchesTrainBase;
            Model.test.debug.matchesTest(t,:) = matchesTestBase;            
            Model.test.debug.dataTrain{t} = [];
            Model.test.debug.dataTest{t} = [];
            for k = 1:Model.numClasses 
                sMap.codebook = Ms{k}.M;
                DeepSOM{k,j}.sMap.codebook = Ms{k}.M;  
                Model.test.debug.dataTrain{t} = [Model.test.debug.dataTrain{t} som_bmusdeep(sMaps{k}.sMap, sData, 'ALL',k,Model.multiple.sigmaAtive(j), Model, [],Model.multiple.distanceType(j),j,DeepSOM{k,j}.relevance ) ]; %som_bmusdeep(sMap, sData, 'ALL',0,Model.multiple.sigmaAtive(j))];
                Model.test.debug.dataTest{t} = [Model.test.debug.dataTest{t} som_bmusdeep(sMaps{k}.sMap, sDataTest, 'ALL',k,Model.multiple.sigmaAtive(j), Model, [],Model.multiple.distanceType(j),j,DeepSOM{k,j}.relevance ) ]; %som_bmusdeep(sMap, sData, 'ALL',0,Model.multiple.sigmaAtive(j))];
            end;
            [Model.test.debug.acurracyDensityTrain(t),Model.test.debug.dataDensityTrain{t}, ...
                Model.test.debug.ratioBMUsDensityTrain(t,:),matchesDensityTrainBase] = ...
                debugMeanWinners(Model, Model.test.debug.dataTrain{t}, j, munits, sData.train_labels, 'descend');
            [Model.test.debug.acurracyDensityTest(t),Model.test.debug.dataDensityTest{t}, ...
                Model.test.debug.ratioBMUsDensityTest(t,:),matchesDensityTestBase] = ...
                debugMeanWinners(Model,Model.test.debug.dataTest{t}, j, munits, sDataTest.test_labels, 'descend');
            Model.test.debug.som{t}.DeepSOM = DeepSOM;
        end;
        
                
        category = [];
        unlearnedTotalArray = [];
        unlearnedDebug = zeros(15,16);
        learnedDebug = zeros(15,16);
        categories = zeros(1,102);
        for cat = 1:Model.numClasses
            DeepSOM{cat,j}.indexAlpha = DeepSOM{cat,j}.indexAlpha + (DeepSOM{cat,j}.winner > 0); % winner
            %DeepSOM{cat,j}.indexAlpha = DeepSOM{cat,j}.indexAlpha + (DeepSOM{cat,j}.winner > mean(DeepSOM{cat,j}.winner) ); % upper mean
            DeepSOM{cat,j}.winner = zeros(1,munits);            
        end;
        
        count = 0;
        for m = 1:dlen,
          
          category = sData.train_labels(1, selected(m) );
          categories(category) = categories(category) + 1;
          if j == 1
            x = D(selected(m),:);                 % pick one sample vector
            known = ~isnan(x);                     % its known components
          else
            if ( j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes') )  
                x = DeepSOM{category,j-1}.BMUsValuesTrain(selected(m),:);                 % pick one sample vector
                known = ~isnan(x);                     % its known components
            else
                for range = 1:Model.multiple.prototypeRange(j-1)
                    x{range} = DeepSOM{category,j-1}.BMUsValuesTrain{range}(selected(m),:);                 % pick one sample vector
                    known{range} = ~isnan(x{range});                     % its known components
                end;                
            end;
          end;
          
          % pipeline myself
          if strcmp(Model.multiple.distanceType{j},'euclidian') || strcmp(Model.multiple.distanceType{j},'prototype') %|| ...
              if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes') )  
                  Dx = (Ms{category}.M(:,:) - x(mu_x_1,:)); 
                  dist = sum(Dx'.^2);
                  [qerr bmu] = min(dist);
                  Ms{category}.Dx = Dx; 
              else
                  for range = 1:Model.multiple.prototypeRange(j-1)
                      Dx{range} = (Ms{category}.M(:,known{range}) - x{range}(mu_x_1,known{range})); 
                      [qerr bmu] = min(sum(Dx{range}'.^2));
                      Ms{category}.Dx{range} = Dx{range}; 
                      dist{range} = sum(Dx{range}'.^2);                  
                  end;
              end;
          elseif strcmp(Model.multiple.distanceType{j},'mahalanobis')  
              Dx = (Ms{category}.M(:,known) - x(mu_x_1,known)); 
              [~,dim] = size(x);
              if mod(m-1,Model.multiple.batch(j)) == 0
                for itInv =1:Model.multiple.numToyProblem   
                    matrixCov = nancov(Ms{itInv}.M);
                    matrixInv{itInv} = pinv(matrixCov);
                end;
              end;
              for itMatrix=1:munits
                dist(itMatrix) = sqrt(Dx(itMatrix,:)*matrixInv{category}*Dx(itMatrix,:)');
              end;
                  
              [qerr bmu] = min(dist);
              Dx = (Ms{category}.M(:,:) - x(mu_x_1,:));
              Ms{category}.Dx = Dx;
              
              %%
              qerrs(category,m+((t-1)*300)) = qerr;
              bmus(category,m+((t-1)*300)) = bmu;
              %% 
          elseif strcmp(Model.multiple.distanceType{j},'relevance_prototype') || strcmp(Model.multiple.distanceType{j},'relevance_active') ...
                  || strcmp(Model.multiple.distanceType(i),'relevance_mirror') || strcmp(Model.multiple.distanceType(i),'relevance_variance') 
              Dx = (Ms{category}.M(:,:) - x(mu_x_1,:));               
              Ms{category}.Dx = Dx; 
              dist = sum( (repmat(Model.multiple.relevance{j}{category}',muni0ts,1)') .* (Dx'.^2));  
              [qerr bmu] =  min(dist);  
          elseif strcmp(Model.multiple.distanceType(i),'relevance_sub_variance') 
              Dx = (Ms{category}.M(:,:) - x(mu_x_1,:));                
              Ms{category}.Dx = Dx; 
              if strcmp(Model.multiple.distanceExpPosition,'extern')
                dist = sum( (DeepSOM{category,j}.relevance') .* (Dx'.^2), 'omitnan' );   
              elseif strcmp(Model.multiple.distanceExpPosition,'inside')
                dist = sum(  (DeepSOM{category,j}.relevance' .* Dx') .^ Model.multiple.distanceExp, 'omitnan' );
              end;

              [qerr bmu] =  min(dist); 
          end;
          
          

          if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  )  
              Ms{category}.BMUsValues = exp(-sqrt(dist/Model.multiple.sigmaAtive(j))');
              [BMUWinner bmuHit] = max(Ms{category}.BMUsValues); 
              BMUWinnerMean = mean(Ms{category}.BMUsValues);
          else
              for range = 1:Model.multiple.prototypeRange(j-1)
                  Ms{category}.BMUsValues{range} = exp(-sqrt(dist{range}/Model.multiple.sigmaAtive(j))');
                  [BMUWinner{range} bmuHit{range}] = max(Ms{category}.BMUsValues{range}); 
                  BMUWinnerMean{range} = mean(Ms{category}.BMUsValues{range});     
              end;
          end;


          
          if (j>1) && strcmp(Model.multiple.trainUnlearnType2,'cross')
              % cross
              for k = 1:Model.multiple.numToyProblem %train 
                  if k ~= category
                    x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                    Dx = (Ms{k}.M(:,known) - x(mu_x_1,known));
                    [qerr bmu] = min(sum(Dx'.^2));
                    Ms{category}.unlearned{k,k} = zeros(munits, 1);

                    % Unlearn
                    Ms{category}.crossDx{k,k} = Dx; 
                    Ms{category}.unlearned{k,k}(bmu) = 1;                   

                  end;                 
              end;
              
              
              % Cross-extends-pipeline-correct
              for k = 1:Model.multiple.numToyProblem %train 
                  if k ~= category
                    x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                    Dx = (Ms{category}.M(:,known) - x(mu_x_1,known));
                    [qerr bmu] = min(sum(Dx'.^2));
                    Ms{category}.unlearned{category,k} = zeros(munits, 1);                    

                    % Unlearn
                    Ms{category}.crossDx{category,k} = Dx; 
                    Ms{category}.unlearned{category,k}(bmu) = 1;                   
                  end;
              end;
              
% %               for k = 1:Model.numClasses
% %                   for k2 = 1:Model.numClasses
% %                       if k ~= k2 & k == category 
% %                         x = DeepSOM{k2,j-1}.BMUsValuesTrain(selected(m),:);
% %                         Dx = (Ms{k}.M(:,known) - x(mu_x_1,known));
% %                         [qerr bmu] = min(sum(Dx'.^2));
% %                         Ms{category}.crossDx{k,k2} = Dx; 
% %                         dist = sum(Dx'.^2);  
% %                         [~, bmusError] = min(dist);
% %                         Ms{category}.BMUsValues = exp(-sqrt(dist/Model.multiple.sigmaAtive)');
% %                         [BMUWinner bmuHit] = max(Ms{category}.BMUsValues); 
% %                         Ms{category}.unlearned{k,k2} = zeros(munits, 1);
% %                         Ms{category}.unlearned{k,k2}(bmusError) = 1; 
% %                         if k == 1 && (j == 2)  %%debug
% %                             unlearnedDebug = unlearnedDebug + Ms{category}.unlearned{k,k2};
% %                         end;
% %                       end;
% %                   end;
% %               end;
          elseif  (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'dual')
             % dual without unlearn
             for k = 1:Model.multiple.numToyProblem  %train 
                  if k ~= category
                    x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                    Dx = (Ms{k}.MDual(:,known) - x(mu_x_1,known));
                    [qerr bmu] = min(sum(Dx'.^2));
                    Ms{category}.unlearned{k,k} = zeros(munits, 1);
                    
                    % Unlearn
                    Ms{category}.crossDx{k,k} = Dx; 
                    Ms{category}.unlearned{k,k}(bmu) = 1; 
                  end;
             end;

             % dual with unlearn
% %              for k = 1:Model.multiple.numToyProblem   
% %                   if k ~= category
% %                     x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
% %                     Dx = (Ms{k}.M(:,known) - x(mu_x_1,known));
% %                     [qerr bmu] = min(sum(Dx'.^2));
% %                     Ms{category}.unlearned{k,k} = zeros(munits, 1);
% %                     
% %                     % Unlearn
% %                     Ms{category}.crossDx{k,k} = Dx; 
% %                     Ms{category}.unlearned{k,k}(bmu) = 1; 
% %                   end;
% %              end;
% %              for k = 1:Model.multiple.numToyProblem   
% %                 x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
% %                 Dx = (Ms{k}.MDual(:,known) - x(mu_x_1,known));
% %                 [qerr bmu] = min(sum(Dx'.^2));
% %                 Ms{category}.unlearnedDual{k,k} = zeros(munits, 1);
% % 
% %                 % Unlearn
% %                 Ms{category}.crossDxDual{k,k} = Dx; 
% %                 Ms{category}.unlearnedDual{k,k}(bmu) = 1; 
% %              end;
          else    
              % pipeline others
              unlearnedTotal = 0;
              for k = 1:Model.multiple.numToyProblem 
                  if k ~= category
                      if (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'convolutional')
                          x = DeepSOM{category,j-1}.BMUsValuesTrain(selected(m),:).* ...
                            DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                      elseif (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'convolutional_before')
                          x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                      elseif (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'cross')
                          x = DeepSOM{category,j-1}.BMUsValuesTrain(selected(m),:);
                      elseif (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'standard')
                          x = DeepSOM{k,j-1}.BMUsValuesTrain(selected(m),:);
                      end;

                      if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  )
                          known = ~isnan(x); 
                          Dx = (Ms{k}.M(:,:) - x(mu_x_1,:));
                          Ms{k}.Dx = Dx;
                          if strcmp(Model.multiple.distanceType{j},'prototype') || strcmp(Model.multiple.distanceType{j},'euclidian') || strcmp(Model.multiple.distanceType{j},'relevance_prototype') || strcmp(Model.multiple.distanceType{j},'relevance_active')  || strcmp(Model.multiple.distanceType(i),'relevance_mirror')
                              dist = sum(Dx'.^2);                          
                          elseif strcmp(Model.multiple.distanceType{j},'mahalanobis')
                              for itMatrix=1:munits
                                dist(itMatrix) = sqrt(Dx(itMatrix,:)*matrixInv{k}*Dx(itMatrix,:)');
                              end;
                          elseif strcmp(Model.multiple.distanceType{j},'relevance_variance') 
                              dist = sum( (repmat(Model.multiple.relevance{j}{k}',munits,1)') .* (Dx'.^2)); 
                          elseif strcmp(Model.multiple.distanceType{j},'relevance_sub_variance') 
                              if strcmp(Model.multiple.distanceExpPosition,'extern')
                                dist = sum( (DeepSOM{k,j}.relevance') .* (Dx'.^2), 'omitnan' );   
                              elseif strcmp(Model.multiple.distanceExpPosition,'inside')
                                dist = sum(  (DeepSOM{k,j}.relevance' .* Dx') .^ Model.multiple.distanceExp, 'omitnan' );
                              end;                               
                          end;
                          [~, bmusError(k)] = min(dist);      
                          Ms{k}.BMUsValues = exp(-sqrt(dist/Model.multiple.sigmaAtive(j))');

                          if strcmp(Model.multiple.trainUnlearnType,'allWinnerUnlearnedRate') || ...
                              strcmp(Model.multiple.trainUnlearnType,'allWinnerUnlearnedConstant')
                            Ms{k}.unlearned = (Ms{k}.BMUsValues > (Model.multiple.limitWinners(j)*BMUWinner));
                          elseif strcmp(Model.multiple.trainUnlearnType,'standard') || ...
                              strcmp(Model.multiple.trainUnlearnType,'bestWinnerAndNeighborhoodUnlearnedRate') || ...
                              strcmp(Model.multiple.trainUnlearnType,'noWinnerAndNoNeighborhood') ||...
                              strcmp(Model.multiple.trainUnlearnType,'winnerAndNeighborhoodLearned')
                            Ms{k}.unlearned = zeros(munits, 1);
                            Ms{k}.unlearned(bmusError(k)) = 1;
                          end;                     
                      
                      else
                          for range = 1:Model.multiple.prototypeRange(j-1)
                              Dx{range} = (Ms{k}.M(:,known{range}) - x{range}(mu_x_1,known{range}));
                              Ms{k}.Dx{range} = Dx{range};
                              if strcmp(Model.multiple.distanceType{j},'prototype') || strcmp(Model.multiple.distanceType{j},'euclidian') || strcmp(Model.multiple.distanceType{j},'relevance_prototype') || strcmp(Model.multiple.distanceType{j},'relevance_active')  || strcmp(Model.multiple.distanceType(i),'relevance_mirror')
                                  dist{range} = sum(Dx{range}'.^2);                          
                              elseif strcmp(Model.multiple.distanceType{j},'mahalanobis')
                                  for itMatrix=1:munits
                                    dist{range}(itMatrix) = sqrt(Dx{range}(itMatrix,:)*matrixInv{k}*Dx{range}(itMatrix,:)');
                                  end;
                              end;
                              [~, bmusError{range}(k)] = min(dist{range});      
                              Ms{k}.BMUsValues{range} = exp(-sqrt(dist{range}/Model.multiple.sigmaAtive(j))');
                               
                          end;
                      end;                  

                      if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  )
                        unlearnedTotal = unlearnedTotal + sum(Ms{k}.unlearned);
                      end;
                  end;
              end;  
              if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  )
                unlearnedTotalArray = [unlearnedTotalArray unlearnedTotal/((Model.numClasses-1)*munits)];       
              end;
          end;
          
          
          
          % update M          
          % same class
          h = zeros(munits, 1); 
          if window > 0 %t/trainlen < limitOrder
              h = mygaussmf(1:munits,[window/3 bmu])';
          else
              h(bmu) = 1;
          end;
          
           h = h*alfa(t); % seleção de taxa de aprendizado
% %           h = h*alfa(DeepSOM{category,j}.indexAlpha(bmu));
% %           DeepSOM{category,j}.winner(bmu) = DeepSOM{category,j}.winner(bmu) + 1;
% %           if category == 1
% %             count = count + 1;
% %           end;
          
          if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  )
              [~,colDx] = size(Dx);
              [~,knowLen] = size(Ms{category}.M);
              known = ones(1,knowLen);


                               
              if strcmp(Model.multiple.functionLearn{1,j},'standard')
                  if  strcmp(Model.multiple.distanceType{1,j},'relevance_sub_variance')
                    %Ms{category}.M(:,:) = Ms{category}.M(:,:) - h(:,ones(sum(known),1)) .* DeepSOM{category,j}.relevance  .* Ms{category}.Dx; %Learn 
                    Ms{category}.M(:,:) = Ms{category}.M(:,:) - h(:,ones(sum(known),1)).*Ms{category}.Dx; %Learn
                  else
                    Ms{category}.M(:,:) = Ms{category}.M(:,:) - h(:,ones(sum(known),1)).*Ms{category}.Dx; %Learn      
                  end;
              elseif strcmp(Model.multiple.functionLearn{1,j},'norm')
                  Ms{category}.M(:,known) = Ms{category}.M(:,known) - (1 - Ms{category}.BMUsValues) .* h(:,ones(sum(known),1)) .* ( Ms{category}.Dx ./ repmat(sqrt(sum(Ms{category}.Dx.^2'))',1, colDx)) ; %Learn
              elseif strcmp(Model.multiple.functionLearn{1,j},'norm_activation')
                  Ms{category}.M(:,known) = Ms{category}.M(:,known) - Ms{category}.BMUsValues .* h(:,ones(sum(known),1)) .* ( Ms{category}.Dx ./ repmat(sqrt(sum(Ms{category}.Dx.^2'))',1, colDx)) ; %Learn
              elseif strcmp(Model.multiple.functionLearn{1,j},'activationInv')
                  Ms{category}.M(:,known) = Ms{category}.M(:,known) - (1./sqrt(Ms{category}.BMUsValues)) .* h(:,ones(sum(known),1)) .* ( Ms{category}.Dx ./ repmat(sqrt(sum(Ms{category}.Dx.^2'))',1, colDx));
              end;
              sMaps{category}.sMap.histogram{t}.learnedWin(bmu) = sMaps{category}.sMap.histogram{t}.learnedWin(bmu) + 1;
          else
              for range = wrev(1:Model.multiple.prototypeRange(j-1))
                  Ms{category}.M(:,known{range}) = Ms{category}.M(:,known{range}) - Model.multiple.weights{category,j}(selected(m),range) * h(:,ones(sum(known{range}),1)).*Ms{category}.Dx{range}; %Learn                                   
              end;
              sMaps{category}.sMap.histogram{t}.learnedWin(bmu) = sMaps{category}.sMap.histogram{t}.learnedWin(bmu) + 1; 
          end;
          
          
          %others classes
          if (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'cross')
              for k = 1:Model.multiple.numToyProblem
                if k ~= category
                  h = Ms{category}.unlearned{k,k};
                  [~,knowLen] = size(Ms{k}.M);
                  known = ones(1,knowLen);
                  % learn, cross
% %                   if window > 0 
% %                     indexUnlearned = find(h == 1);
% %                     lenIndexUnlearned = length(indexUnlearned);
% %                     hTotal = [];
% %                     if lenIndexUnlearned > 1
% %                         for k2 = 1:lenIndexUnlearned
% %                             hTotal = [hTotal; mygaussmf(1:munits,[window/3 indexUnlearned(k)])];
% %                         end;
% %                         h = max(hTotal)'*alfa(t)*unAlfa(t);   
% %                     elseif lenIndexUnlearned == 1
% %                         %hTotal = mygaussmf(1:munits,[window/3 indexUnlearned(1)]);
% %                         hTotal = zeros(1,munits);
% %                         hTotal(indexUnlearned(1)) = 1;
% %                         h = hTotal'*alfa(t)*unAlfa(t);   
% %                     else
% %                         h = zeros(munits, 1);
% %                     end;
% %                   else
% %                     h = h*alfa(t)*unAlfa(t);
% %                   end;


                  % Unlearn, cross thershold  
                  h = h*alfa(t)*unAlfa(t);                    
                  Ms{k}.M(:,known) = Ms{k}.M(:,known) + h(:,ones(sum(known),1)).*Ms{category}.crossDx{k,k}; %Unlearn 


                  % Cross positive 
% %                   h = h*alfa(t)*unAlfa(t);                    
% %                   Ms{k}.M(:,known) = Ms{k}.M(:,known) -
% h(:,ones(sum(known),1)).*Ms{category}.crossDx{k,k}; %Learn
                end;                 
              end; 
              
              
              % Cross-extends-pipeline-correct
              for k = 1:Model.multiple.numToyProblem
                if k ~= category
                  h = Ms{category}.unlearned{category,k};
                  h = h*alfa(t)*unAlfaCrossCorrect(t);                    
                  Ms{category}.M(:,known) = Ms{category}.M(:,known) + h(:,ones(sum(known),1)).*Ms{category}.crossDx{category,k}; %Unlearn 
                end;
              end;

              
% %               for k = 1:Model.numClasses
% %                 for k2 = 1:Model.numClasses
% %                     if k ~= k2 & k == category
% %                       h = Ms{category}.unlearned{k,k2};
% %                       if window > 0 
% %                         indexUnlearned = find(h == 1);
% %                         lenIndexUnlearned = length(indexUnlearned);
% %                         hTotal = [];
% %                         if lenIndexUnlearned > 1
% %                             for k2 = 1:lenIndexUnlearned
% %                                 hTotal = [hTotal; mygaussmf(1:munits,[window/3 indexUnlearned(k2)])];
% %                             end;
% %                             h = max(hTotal)'*alfa(t)*unAlfa(t);   
% %                         elseif lenIndexUnlearned == 1
% %                             %hTotal = mygaussmf(1:munits,[window/3 indexUnlearned(1)]);
% %                             hTotal = zeros(1,munits);
% %                             hTotal(indexUnlearned(1)) = 1;
% %                             h = hTotal'*alfa(t)*unAlfa(t);   
% %                         else
% %                             h = zeros(munits, 1);
% %                         end;
% %                       else
% %                         h = h*alfa(t)*unAlfa(t);
% %                       end;
% %                       Ms{k}.M(:,known) = Ms{k}.M(:,known) + h(:,ones(sum(known),1)).*Ms{category}.crossDx{k,k2}; 
% %                     end;
% %                 end;                   
% %               end;
          elseif (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'dual')
              % Dual without   
              for k = 1:Model.multiple.numToyProblem 
                if k ~= category              
                  h = Ms{category}.unlearned{k,k};

                  if window > 0 
                    indexUnlearned = find(h == 1);
                    lenIndexUnlearned = length(indexUnlearned);
                    hTotal = [];
                    if lenIndexUnlearned > 1
                        for k2 = 1:lenIndexUnlearned
                            hTotal = [hTotal; mygaussmf(1:munits,[window/3 indexUnlearned(k)])];
                        end;
                        h = max(hTotal)'*alfa(t)*unAlfa(t);   
                    elseif lenIndexUnlearned == 1
                        hTotal = mygaussmf(1:munits,[window/3 indexUnlearned(1)]);
                        h = hTotal'*alfa(t)*unAlfa(t);   
                    else
                        h = zeros(munits, 1);
                    end;
                  else
                    h = h*alfa(t)*unAlfa(t);
                  end;
                
                  Ms{k}.MDual(:,known) = Ms{k}.MDual(:,known) - h(:,ones(sum(known),1)).*Ms{category}.crossDx{k,k}; %Learn               
                end;
              end;
              

              
          else
              if ~strcmp(Model.multiple.trainUnlearnType,'standard') || ...
                  (((j > 1)) && (strcmp(Model.multiple.trainUnlearnType2,'convolutional') || ...
                  strcmp(Model.multiple.trainUnlearnType2,'convolutional_before')))
                  for k = 1:Model.multiple.numToyProblem 
                      if k ~= category 
                          if (j == 1 || ~strcmp(cellstr(Model.multiple.prototype(j-1)), 'n_prototypes')  ) 
                              h = Ms{k}.unlearned;
                              if strcmp(Model.multiple.trainUnlearnType,'allWinnerUnlearnedRate')
                                  h = h*alfa(t)*unAlfa(t);
                              elseif strcmp(Model.multiple.trainUnlearnType,'allWinnerUnlearnedConstant')
                                  h = h*unAlfa(t);
                              elseif  strcmp(Model.multiple.trainUnlearnType,'noWinnerAndNoNeighborhood')
                                  h = ones(munits, 1);
                                  for k2 = bmu-window:bmu+window
                                    if k2 >= 1 & k2 <= munits  
                                       h(k2) = 0;
                                    end;                               
                                  end;
                                  h = h*alfa(t)*unAlfa(t);
                              elseif strcmp(Model.multiple.trainUnlearnType,'bestWinnerAndNeighborhoodUnlearnedRate') || ...
                                      strcmp(Model.multiple.trainUnlearnType,'noWinnerAndNoNeighborhood') || ...
                                      ( ((j > 1)) && (strcmp(Model.multiple.trainUnlearnType2,'convolutional') || ...
                                      strcmp(Model.multiple.trainUnlearnType2,'convolutional_before')))
                                  if window > 0 
                                    indexUnlearned = find(h == 1);
                                    lenIndexUnlearned = length(indexUnlearned);
                                    hTotal = [];
                                    if lenIndexUnlearned > 1
                                        for k2 = 1:lenIndexUnlearned
                                            hTotal = [hTotal; mygaussmf(1:munits,[window/3 indexUnlearned(k2)])];
                                        end;
                                        h = max(hTotal)'*alfa(t)*unAlfa(t);   
                                    elseif lenIndexUnlearned == 1
                                        hTotal = mygaussmf(1:munits,[window/3 indexUnlearned(1)]);
                                        h = hTotal'*alfa(t)*unAlfa(t);   
                                    else
                                        h = zeros(munits, 1);
                                    end;
                                  else
                                    h = h*alfa(t)*unAlfa(t);
                                  end;
                              elseif strcmp(Model.multiple.trainUnlearnType,'winnerAndNeighborhoodLearned')
                                  windowOthers = ceil(window/2);
                                  if windowOthers > 0 
                                    indexUnlearned = find(h == 1);
                                    lenIndexUnlearned = length(indexUnlearned);
                                    hTotal = [];
                                    if lenIndexUnlearned > 1
                                        for k2 = 1:lenIndexUnlearned
                                            hTotal = [hTotal; mygaussmf(1:munits,[windowOthers/3 indexUnlearned(k2)])];
                                        end;
                                        h = max(hTotal)'*alfa(t)*unAlfa(t);   
                                    elseif lenIndexUnlearned == 1
                                        hTotal = mygaussmf(1:munits,[windowOthers/3 indexUnlearned(1)]);
                                        h = hTotal'*alfa(t)*unAlfa(t);   
                                    else
                                        h = zeros(munits, 1);
                                    end;
                                  else
                                    h = h*alfa(t)*unAlfa(t);
                                  end;
                              end;
                              
                              % debug
                              if selected(m) < 101 %(selected(m) == 4 || selected(m) == 5 || selected(m) == 21 || selected(m) == 31 || selected(m) == 35 || selected(m) == 37 ...
                                  %    || selected(m) == 43 || selected(m) == 61 || selected(m) == 82)...
                                      
                                for cat2 = 1:Model.multiple.numToyProblem
                                    distDebug(cat2,:) = sum(  ( DeepSOM{cat2,2}.relevance .* ( ( DeepSOM{cat2,1}.BMUsValuesTrain(selected(m),:) - Ms{cat2}.M ) .^2))' ) ;
                                end;
                                distDebugSum = min(distDebug');                                  
                                debugCatTrain{selected(m)}(t,:) = distDebugSum;
                                
                                indexesTest = [1 2 8 13 20 23 29 34];
                                for indexTest = indexesTest
                                    for cat2 = 1:15
                                        distDebugTest(cat2,:) = sum(  ( DeepSOM{cat2,2}.relevance .* ( ( DeepSOM{cat2,1}.BMUsValuesTest(indexTest,:) - Ms{cat2}.M ) .^2))' ) ;
                                    end;
                                    distDebugSum = min(distDebugTest');                                  
                                    debugCatTest{indexTest}(t,:) = distDebugSum;                                    
                                end;
                              end;
                              %

                              if ~strcmp(Model.multiple.trainUnlearnType,'winnerAndNeighborhoodLearned')
                                if strcmp(Model.multiple.functionUnlearn(1,j),'standard')  
                                    Ms{k}.M(:,known) = Ms{k}.M(:,known) + h(:,ones(sum(known),1)) .* DeepSOM{k,j}.relevance .* Ms{k}.Dx;
                                elseif strcmp(Model.multiple.functionUnlearn(1,j),'norm')  
                                    Ms{k}.M(:,known) = Ms{k}.M(:,known) + Ms{k}.BMUsValues .* h(:,ones(sum(known),1)) .* DeepSOM{k,j}.relevance .* ( Ms{k}.Dx ./ repmat(sqrt(sum(Ms{k}.Dx.^2'))',1, colDx)) ; %Unlearn
                                elseif strcmp(Model.multiple.functionUnlearn(1,j),'norm2')  
                                    Ms{k}.M(:,known) = Ms{k}.M(:,known) + (Ms{k}.BMUsValues.^(1/2)) .* h(:,ones(sum(known),1)) .* DeepSOM{k,j}.relevance .* ( Ms{k}.Dx ./ repmat(sqrt(sum(Ms{k}.Dx.^2'))',1, colDx)) ; %Unlearn                                    
                                end;
                              else
                                Ms{k}.M(:,known) = Ms{k}.M(:,known) - h(:,ones(sum(known),1)).*Ms{k}.Dx;     
                              end;
                              sMaps{k}.sMap.histogram{t}.unlearnedWin(bmusError(k)) = sMaps{k}.sMap.histogram{t}.unlearnedWin(bmusError(k)) + 1;
                          end;
                      end;
                  end;
              end;
          end;
          
          
        if strcmp(Model.multiple.saturationCodebook{1,j},'yes')
            [rowM, colM] = size(Ms{1}.M);
            for k = 1:Model.multiple.numToyProblem
                 for k2 = 1:rowM
% %                      Ms{k}.M(k2, find(Ms{k}.M(k2,:)) < 0) = 0;
% %                      Ms{k}.M(k2, find(Ms{k}.M(k2,:)) > 1) = 1;
                    for k3 = 1:colM
                        if Ms{k}.M(k2,k3) < 0 
                            Ms{k}.M(k2,k3) = 0;
                        end;
                        if Ms{k}.M(k2,k3) > 1 
                            Ms{k}.M(k2,k3) = 1;
                        end;                        
                    end;
                end;
            end;
        end;          
          
          

        end;
        
        %Epochs
        for k = 1:Model.multiple.numToyProblem 
            DeepSOM{k,j}.sMap.codebook = Ms{k}.M;  
        end;
        if t ~= trainlen % não é necessário recalcular as relevâncias após o último treinamento
            [Model, DeepSOM] = computeRelevanceEpochs(Model, DeepSOM, j, sData, sDataTest, sData.train_labels, sDataTest.test_labels, t, trainlen, alfa(t));
            
            if strcmp(Model.multiple.distanceType{j},'relevance_sub_variance') 
                for k = 1:Model.multiple.numToyProblem 
                    relevanceLog{k,t}.relevance = DeepSOM{k,j}.relevance;
                end
            end;
        end;
        
    end;
   
    
    if strcmp(Model.flag.plotDebugData,'yes')
        [Model.test.debug.acurracyTrain(t+1),Model.test.debug.histogramTrain{t+1},Model.test.debug.ratioBMUsTrain(t+1,:), matchesTrain, Model.test.debug.errorNoSupervisedCorrectTrain(t+1,:), Model.test.debug.errorNoSupervisedAllTrain{t+1}] = ...
            debugWinners(Model, sData, Ms, munits, labels, DeepSOM);
        [Model.test.debug.acurracyTest(t+1),Model.test.debug.histogramTest{t+1},Model.test.debug.ratioBMUsTest(t+1,:), matchesTest, Model.test.debug.errorNoSupervisedCorrectTest(t+1,:), Model.test.debug.errorNoSupervisedAllTest{t+1}] = ...
            debugWinners(Model, sDataTest, Ms, munits, labels, DeepSOM);        
        Model.test.debug.meanFrequencyUnlearned(t+1) = mean(unlearnedTotalArray);
        Model.test.debug.maxFrequencyUnlearned(t+1) = max(unlearnedTotalArray);
        Model.test.debug.stdFrequencyUnlearned(t+1) = std(unlearnedTotalArray);        
        Model.test.debug.matchesTrain(t+1,:) = matchesTrain;
        Model.test.debug.matchesTest(t+1,:) = matchesTest;


        Model.test.debug.dataTrain{t+1} = [];
        Model.test.debug.dataTest{t+1} = [];
        for k = 1:Model.numClasses 
            sMap.codebook = Ms{k}.M;
            Model.test.debug.dataTrain{t+1} = [Model.test.debug.dataTrain{t+1} som_bmusdeep(sMaps{k}.sMap, sData, 'ALL',k,Model.multiple.sigmaAtive(j), Model, [],Model.multiple.distanceType(j),j,DeepSOM{k,j}.relevance ) ]; %som_bmusdeep(sMap, sData, 'ALL',0,Model.multiple.sigmaAtive(j))];
            Model.test.debug.dataTest{t+1} = [Model.test.debug.dataTest{t+1} som_bmusdeep(sMaps{k}.sMap, sDataTest, 'ALL',k,Model.multiple.sigmaAtive(j), Model, [],Model.multiple.distanceType(j),j,DeepSOM{k,j}.relevance ) ]; %som_bmusdeep(sMap, sData, 'ALL',0,Model.multiple.sigmaAtive(j))];
        end;
        [Model.test.debug.acurracyDensityTrain(t+1),Model.test.debug.dataDensityTrain{t+1}, ...
            Model.test.debug.ratioBMUsDensityTrain(t+1,:),matchesDensityTrain] = ...
            debugMeanWinners(Model, Model.test.debug.dataTrain{t+1}, j, munits, sData.train_labels, 'descend');
        [Model.test.debug.acurracyDensityTest(t+1),Model.test.debug.dataDensityTest{t+1}, ...
            Model.test.debug.ratioBMUsDensityTest(t+1,:),matchesDensityTest] = ...
            debugMeanWinners(Model,Model.test.debug.dataTest{t+1}, j, munits, sDataTest.test_labels, 'descend');        


        Model.test.debug.matchesDensityTrain(t+1,:) = mean(matchesDensityTrainBase ~= matchesDensityTrain);
        Model.test.debug.matchesDensityTest(t+1,:) = mean(matchesDensityTestBase ~= matchesDensityTest);
        matchesTrainBase = matchesTrain;
        matchesTestBase = matchesTest;
        matchesDensityTrainBase = matchesDensityTrain;
        matchesDensityTestBase = matchesDensityTest;

        Model.test.debug.som{t+1}.DeepSOM = DeepSOM;
    end;
        
end; % for t = 1:trainlen
%close(bar); % stem(sMap.winners,'MarkerSize',1),xlabel('nodos'), ylabel('vitórias') ;


%[Model, DeepSOM] = computeSetRelevance(Model, DeepSOM, j, sData.train_labels, sDataTest.test_labels);

if strcmp(Model.multiple.inputPrototype{j},'yes')
    DeepSOMCopy = DeepSOM;
    for t = 1:Model.multiple.numToyProblem
        DeepSOM{t,j-1}.BMUsValuesTrain = DeepSOMCopy{t,j-1}.BMUsValuesTrain;
    end;
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build / clean up the return arguments

if tracking, fprintf(1,'\n'); end

% update structures
sTrain = som_set(sTrain,'time',datestr(now,0));
if struct_mode,
  if strcmp(Model.multiple.trainType,'single')  
      sMap = som_set(sMap,'codebook',M,'mask',sTrain.mask,'neigh',sTrain.neigh);
      tl = length(sMap.trainhist);
      sMap.trainhist(tl+1) = sTrain;
  elseif strcmp(Model.multiple.trainType,'competition')
      for k = 1:Model.multiple.numToyProblem %Model.numClasses
          sMaps{k}.sMap = som_set(sMaps{k}.sMap,'codebook',Ms{k}.M,'mask',sTrain.mask,'neigh',sTrain.neigh);
          if strcmp(Model.multiple.distanceType{j},'relevance_sub_variance')  
            sMaps{k}.relevance = DeepSOM{k,j}.relevance;
            sMaps{k}.relevanceAtive = DeepSOM{k,j}.relevanceAtive;
          elseif  strcmp(Model.multiple.distanceType{j},'relevance_variance')  
            [nodes, dim] = size(DeepSOM{k,j}.sMap.codebook);  
            sMaps{k}.relevance = ones(nodes,dim);
          end;
          if (j > 1) && strcmp(Model.multiple.trainUnlearnType2,'dual')
            sMaps{k}.sMap.codebookDual = Ms{k}.MDual;
          end;
          tl = length(sMaps{k}.sMap.trainhist);
          sMaps{k}.sMap.trainhist(tl+1) = sTrain;          
      end;
      sMap = sMaps; %fusão da saída
  end;
else
  sMap = reshape(M,orig_size);
end

return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

%%%%%%%%
function [] = trackplot(M,D,tracking,start,n,qe)

  l = length(qe);
  elap_t = etime(clock,start); 
  tot_t = elap_t*l/n;
  fprintf(1,'\rTraining: %3.0f/ %3.0f s',elap_t,tot_t)  
  switch tracking
   case 1, 
   case 2,       
    plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
    title('Quantization errors for latest samples')    
    drawnow
   otherwise,
    subplot(2,1,1), plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
    title('Quantization error for latest samples');
    subplot(2,1,2), plot(M(:,1),M(:,2),'ro',D(:,1),D(:,2),'b.'); 
    title('First two components of map units (o) and data vectors (+)');
    drawnow
  end  
  % end of trackplot

