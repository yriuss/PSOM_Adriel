len = 256;
vec1 = zeros(1,len);
vec2 = zeros(1,len);

dist = [];
for i = 1:len
    distD(1,i) = nansum(sum((vec1 - vec2).^2));
    sigma = std(vec1 - vec2);
    dist(1,i) = nansum(sum(((vec1 - vec2).^2)/1));
    vec2(1,i) = 1; 
end;

distExp = exp(-sqrt(dist)');