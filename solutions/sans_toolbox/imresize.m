function S = imresize(I, M, varargin)
% Version simplifiée (sans Image Processing Toolbox) : interpolation bilinéaire.
[h, w, c] = size(I);
H = ceil(h*M); W = ceil(w*M);
xs = min(max(((1:W) - 0.5)/M + 0.5, 1), w);
ys = min(max(((1:H) - 0.5)/M + 0.5, 1), h);
[X, Y] = meshgrid(xs, ys);
S = zeros(H, W, c, 'like', I);
for k = 1:c
    S(:,:,k) = cast(interp2(double(I(:,:,k)), X, Y, 'linear'), class(I));
end
end
