function sMap = som_randinit(D, varargin)

%SOM_RANDINIT Initialize a Self-Organizing Map with random values.
%
% sMap = som_randinit(D, [[argID,] value, ...])
%
%  sMap = som_randinit(D);
%  sMap = som_randinit(D,sMap);
%  sMap = som_randinit(D,'munits',100,'hexa');
% 
%  Input and output arguments ([]'s are optional): 
%    D                 The training data.
%             (struct) data struct
%             (matrix) data matrix, size dlen x dim
%   [argID,   (string) Parameters affecting the map topology are given 
%    value]   (varies) as argument ID - argument value pairs, listed below.
%
%   sMap      (struct) map struct
%
% Here are the valid argument IDs and corresponding values. The values 
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) topology struct
%  'som_topol','sTopol'    = 'topol'
%  'map'         *(struct) map struct
%  'som_map','sMap'        = 'map'
%
% For more help, try 'type som_randinit' or check out online documentation.
% See also SOM_MAP_STRUCT, SOM_LININIT, SOM_MAKE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_randinit
%
% PURPOSE
%
% Initializes a SOM with random values.
%
% SYNTAX
%
%  sMap = som_randinit(D)
%  sMap = som_randinit(D,sMap);
%  sMap = som_randinit(D,'munits',100,'hexa');
%
% DESCRIPTION
%
% Initializes a SOM with random values. If necessary, a map struct
% is created first. For each component (xi), the values are uniformly
% distributed in the range of [min(xi) max(xi)]. 
%
% REQUIRED INPUT ARGUMENTS
%
%  D                 The training data.
%           (struct) Data struct. If this is given, its '.comp_names' and 
%                    '.comp_norm' fields are copied to the map struct.
%           (matrix) data matrix, size dlen x dim
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is used. 
%
%  Here are the valid argument IDs and corresponding values. The values 
%  which are unambiguous (marked with '*') can be given without the 
%  preceeding argID.
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix) the training data
%                *(struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) topology struct
%  'som_topol','sTopol'    = 'topol'
%  'map'         *(struct) map struct
%  'som_map','sMap'        = 'map'
%
% OUTPUT ARGUMENTS
% 
%  sMap     (struct) The initialized map struct.
%
% EXAMPLES
%
%  sMap = som_randinit(D);
%  sMap = som_randinit(D,sMap);
%  sMap = som_randinit(D,sTopol);
%  sMap = som_randinit(D,'msize',[10 10]);
%  sMap = som_randinit(D,'munits',100,'hexa');
%
% SEE ALSO
% 
%  som_map_struct   Create a map struct.
%  som_lininit      Initialize a map using linear initialization algorithm.
%  som_make         Initialize and train self-organizing map.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 100997
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% data
if isstruct(D), 
  data_name = D.name; 
  comp_names = D.comp_names; 
  comp_norm = D.comp_norm; 
  D = D.data;
  struct_mode = 1; 
else 
  data_name = inputname(1); 
  struct_mode = 0; 
end
[dlen dim] = size(D);

% varargin
sMap = [];
sTopol = som_topol_struct; 
sTopol.msize = 0; 
munits = NaN;
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'munits',     i=i+1; munits = varargin{i}; sTopol.msize = 0;
     case 'msize',      i=i+1; sTopol.msize = varargin{i};
                               munits = prod(sTopol.msize); 
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i}; 
     case 'shape',      i=i+1; sTopol.shape = varargin{i}; 
     case {'som_topol','sTopol','topol'}, i=i+1; sTopol = varargin{i}; 
     case {'som_map','sMap','map'}, i=i+1; sMap = varargin{i}; sTopol = sMap.topol;
     case {'hexa','rect'},          sTopol.lattice = varargin{i}; 
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i};
     case 'model',     i=i+1; model = varargin{i};
     case 'sData',     i=i+1; sData = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) & isfield(varargin{i},'type'), 
    switch varargin{i}.type, 
     case 'som_topol',
      sTopol = varargin{i}; 
     case 'som_map', 
      sMap = varargin{i};
      sTopol = sMap.topol;
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_topol_struct) Ignoring invalid argument #' num2str(i)]); 
  end
  i = i+1; 
end

if ~isempty(sMap), 
  [munits dim2] = size(sMap.codebook);
  if dim2 ~= dim, error('Map and data must have the same dimension.'); end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create map

% map struct
if ~isempty(sMap), 
  sMap = som_set(sMap,'topol',sTopol);
else  
  if ~prod(sTopol.msize), 
    if isnan(munits), 
      sTopol = som_topol_struct('data',D,sTopol);
    else
      sTopol = som_topol_struct('data',D,'munits',munits,sTopol);
    end
  end  
  sMap = som_map_struct(dim, sTopol); 
end

if struct_mode, 
  sMap = som_set(sMap,'comp_names',comp_names,'comp_norm',comp_norm);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialization

% train struct
sTrain = som_train_struct('algorithm','randinit');
sTrain = som_set(sTrain,'data_name',data_name);

munits = prod(sMap.topol.msize);


% set interval of each component to correct value
for i = 1:dim,
  inds = find(~isnan(D(:,i)) & ~isinf(D(:,i))); 
  if isempty(inds), mi = 0; ma = 1; 
  else ma = max(D(inds,i)); mi = min(D(inds,i));  
  end
  sMap.codebook(:,i) = (ma - mi) * sMap.codebook(:,i) + mi; 
end

if strcmp(model.inicializeMode,'random')
    sMap.codebook = (0.02 *rand([munits dim])) - 0.01; 
elseif strcmp(model.inicializeMode,'samples')
    sMap.codebook = D(randint(munits,1,[1 dlen]),:);
elseif strcmp(model.inicializeMode,'samples_mean')
    sMap.codebook = (0.02 *rand([munits dim])) - 0.01;
    labels = unique(sData.labels);
    len = length(labels);
    means = [];
    for i=1:len
        means = [means; mean(D(strcmp(sData.labels,labels(i)),:))];
    end;    
    check = zeros(len,1);
    step = floor(munits/len);
    sMap.codebook(step,:) = means(1,:);
    last = 1;
    check(1) = 1;
    %order = last;
    for i=2:len
        distances = pdist2(means(last,:),means);
        [distances, distancesIndex] = sort(distances);
        for j=2:len 
            if check(distancesIndex(j)) == 0
                sMap.codebook(i*step,:) = means(distancesIndex(j),:);
                check(distancesIndex(j)) = 1;
                last = distancesIndex(j);
                %order = [Model.order last];
                break;
            end;
        end;
    end;
end;
%save('neuron' order);
sMap.winners = zeros(1,munits);

% training struct
sTrain = som_set(sTrain,'time',datestr(now,0));
sMap.trainhist = sTrain;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%