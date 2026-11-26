function R = imrotate(I, ang, varargin)
% Version simplifiée (sans Image Processing Toolbox) :
% rotation de ang degrés (sens anti-horaire), plus proche voisin, cadre agrandi ('loose'), fond noir.
if mod(ang, 90) == 0
    R = rot90(I, mod(round(ang/90), 4));   % rotation exacte
    return;
end
[h, w, c] = size(I);
t = ang*pi/180; ct = cos(t); st = sin(t);
H = ceil(abs(h*ct) + abs(w*st));
W = ceil(abs(w*ct) + abs(h*st));
[X, Y] = meshgrid(1:W, 1:H);
xc = (W+1)/2; yc = (H+1)/2; x0 = (w+1)/2; y0 = (h+1)/2;
% transformation inverse : pixel de sortie -> pixel source
xs = round( ct*(X-xc) - st*(Y-yc) + x0);
ys = round( st*(X-xc) + ct*(Y-yc) + y0);
ok = xs >= 1 & xs <= w & ys >= 1 & ys <= h;
R = zeros(H, W, c, 'like', I);
for k = 1:c
    src = I(:,:,k); dst = zeros(H, W, 'like', I);
    dst(ok) = src(sub2ind([h w], ys(ok), xs(ok)));
    R(:,:,k) = dst;
end
end
