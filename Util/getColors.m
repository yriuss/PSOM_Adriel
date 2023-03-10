% Marcondes Ricarte

function [cmap] = getColors(classes)

    
    N = classes;
    cmap = zeros(N,3);
    for i=1:N
      id = i-1; r=0;g=0;b=0;
      for j=0:7
        r = bitor(r, bitshift(bitget(id,1),7 - j));
        g = bitor(g, bitshift(bitget(id,2),7 - j));
        b = bitor(b, bitshift(bitget(id,3),7 - j));
        id = bitshift(id,-3);
      end
      cmap(i,1)=r; cmap(i,2)=g; cmap(i,3)=b;
    end
    cmap = cmap / 255;

end