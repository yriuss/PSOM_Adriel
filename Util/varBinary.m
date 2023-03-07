% Marcondes Ricarte

function variance = varBinary(data, center)

    [samples,~] = size(data);
    variance = sum((data - center).^2)/(samples-1);

end