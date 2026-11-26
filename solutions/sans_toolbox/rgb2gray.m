function G = rgb2gray(RGB)
% Version simplifiée : luminance Y = 0.2989 R + 0.5870 G + 0.1140 B
if size(RGB, 3) ~= 3, G = RGB; return; end
d = double(RGB);
G = cast(0.2989*d(:,:,1) + 0.5870*d(:,:,2) + 0.1140*d(:,:,3), class(RGB));
end
