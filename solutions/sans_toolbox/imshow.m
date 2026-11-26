function hOut = imshow(I, varargin)
% Version simplifiée (sans Image Processing Toolbox).
% imshow(I) : gris ou RGB ; imshow(X, map) : image indexée.
if nargin >= 2 && isnumeric(varargin{1}) && ~isempty(varargin{1}) && size(varargin{1}, 2) == 3
    h = image(I); colormap(gca, varargin{1});          % image indexée
elseif size(I, 3) == 3
    h = image(I);                                      % couleur
else
    if isa(I, 'uint8'),      lim = [0 255];
    elseif isa(I, 'uint16'), lim = [0 65535];
    else,                    lim = [0 1];
    end
    h = imagesc(double(I), lim); colormap(gca, gray(256));
end
axis image off;
if nargout, hOut = h; end
end
