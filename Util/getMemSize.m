function [ bytes ] = getMemSize( variable, sizelimit, name, indent )
    if nargin < 2
        sizelimit = -1;
    end
    if nargin < 3
        name = 'variable';       
    end
    if nargin < 4
        indent = '';
    end
    
    strsize = 30;
    
    props = properties(variable); 
    if size(props, 1) < 1
        
        bytes = whos(varname(variable)); 
        bytes = bytes.bytes;
        
        if bytes > sizelimit
            if bytes < 1024
                fprintf('%s%s: %i\n', indent, pad(name, strsize - length(indent)), bytes);
            elseif bytes < 2^20
                fprintf('%s%s: %i Kb\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^10));
            elseif bytes < 2^30
                fprintf('%s%s: %i Mb\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^20));
            else
                fprintf('%s%s: %i Gb [!]\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^30));
            end
        end
    else
        
        fprintf('\n%s[%s] \n\n', indent, name);
        bytes = 0;
        for ii=1:length(props)
            currentProperty = getfield(variable, char(props(ii)));
            pp = props(ii);
            bytes = bytes + getMemSize(currentProperty, sizelimit, pp{1}, [indent, '  ']);
        end                
                
        if length(indent) == 0
            fprintf('\n');
            name = 'TOTAL';
            if bytes < 1024
                fprintf('%s%s: %i\n', indent, pad(name, strsize - length(indent)), bytes);
            elseif bytes < 2^20
                fprintf('%s%s: %i Kb\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^10));
            elseif bytes < 2^30
                fprintf('%s%s: %i Mb\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^20));
            else
                fprintf('%s%s: %i Gb [!]\n', indent, pad(name, strsize - length(indent)), round(bytes / 2^30));
            end
        end
    
    end   
        
end