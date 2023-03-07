
function size_var = getVarSize(var)
    name = getVarName(var);
    size = whos(name);
    size_var = size.bytes/(1024);
end
function out = getVarName(var)
    out = inputname(1);
end