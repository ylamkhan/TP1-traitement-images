function [X, map] = gray2ind(I, N)
% Version simplifiée (sans Image Processing Toolbox) : quantification sur N niveaux.
if nargin < 2, N = 64; end
d = double(I);
if isa(I, 'uint8'), d = d/255; elseif isa(I, 'uint16'), d = d/65535; end
X = round(d*(N-1));                 % indices 0..N-1
if N <= 256, X = uint8(X); else, X = uint16(X); end
map = gray(N);
end
