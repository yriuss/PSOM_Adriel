function y = mygaussmf(x, params)

if nargin ~= 2
    error('Two arguments are required by the Gaussian MF.');
elseif length(params) < 2
    error('The Gaussian MF needs at least two parameters.');
elseif params(1) == 0,
    error('The Gaussian MF needs a non-zero sigma.');
end

sigma = params(1); c = params(2);
y = exp(-(x - c).^2/(2*sigma^2));