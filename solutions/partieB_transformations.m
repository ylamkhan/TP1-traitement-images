%% TP1 - Partie B : Transformations géométriques
% Version sans fonctions locales et sans Image Processing Toolbox
clear; close all; clc;

% Dossier du script
baseDir = fileparts(mfilename('fullpath'));
if isempty(baseDir)
    baseDir = pwd;
end

% Trouver automatiquement cameraman.bmp
candidates = { ...
    fullfile(baseDir, 'cameraman.bmp'), ...
    fullfile(baseDir, '..', 'cameraman.bmp'), ...
    fullfile(baseDir, 'images', 'cameraman.bmp'), ...
    fullfile(pwd, 'cameraman.bmp'), ...
    fullfile(pwd, '..', 'cameraman.bmp')};

imgFile = '';
for i = 1:numel(candidates)
    if exist(candidates{i}, 'file') == 2
        imgFile = candidates{i};
        break;
    end
end
if isempty(imgFile)
    error('Impossible de trouver cameraman.bmp.');
end

I = imread(imgFile);
if size(I, 3) == 3
    I = uint8(0.2989*double(I(:,:,1)) + 0.5870*double(I(:,:,2)) + 0.1140*double(I(:,:,3)));
end
Id = double(I);
[m, n] = size(Id);

%% Rotations (rotation autour du centre, interpolation bilinéaire, fond noir)
angles = [-45 -90 45 90];
figure('Name', 'Rotations');
subplot(2, 3, 1);
imagesc(I, [0 255]); colormap(gray(256)); axis image off;
title(sprintf('Originale (%dx%d)', m, n));

cx = (n + 1) / 2;
cy = (m + 1) / 2;
for k = 1:numel(angles)
    a = angles(k);
    % coins de l'image après rotation -> taille du nouveau cadre
    xC = [1, n, n, 1] - cx;
    yC = [1, 1, m, m] - cy;
    xRot =  xC * cosd(a) + yC * sind(a);
    yRot = -xC * sind(a) + yC * cosd(a);
    [xOut, yOut] = meshgrid(floor(min(xRot)):ceil(max(xRot)), ...
                            floor(min(yRot)):ceil(max(yRot)));
    % transformation inverse : pixel de sortie -> pixel source
    xIn = xOut * cosd(a) - yOut * sind(a) + cx;
    yIn = xOut * sind(a) + yOut * cosd(a) + cy;
    R = uint8(interp2(Id, xIn, yIn, 'linear', 0));   % uint8 arrondit et sature à [0,255]

    subplot(2, 3, k + 1);
    imagesc(R, [0 255]); colormap(gray(256)); axis image off;
    title(sprintf('\\theta = %+d°  (%dx%d)', a, size(R,1), size(R,2)));
end
saveas(gcf, fullfile(baseDir, 'B_rotations.png'));
% Remarque : à ±90° l'image est seulement tournée (pas de perte) ;
% à ±45° le cadre s'agrandit et les coins sont remplis de noir.

%% Redimensionnement (interpolation bilinéaire)
M = [0.5 0.1 1.5 2.5];
figure('Name', 'Redimensionnement');
subplot(2, 3, 1);
imagesc(I, [0 255]); colormap(gray(256)); axis image off;
title(sprintf('Originale (%dx%d)', m, n));

for k = 1:numel(M)
    newM = max(1, round(m * M(k)));
    newN = max(1, round(n * M(k)));
    % centres des pixels de sortie ramenés dans l'image d'origine (bornés pour éviter les bords noirs)
    xIn = min(max(((1:newN) - 0.5) / M(k) + 0.5, 1), n);
    yIn = min(max(((1:newM) - 0.5) / M(k) + 0.5, 1), m);
    [X, Y] = meshgrid(xIn, yIn);
    S = uint8(interp2(Id, X, Y, 'linear'));

    subplot(2, 3, k + 1);
    imagesc(S, [0 255]); colormap(gray(256)); axis image off;
    title(sprintf('M = %.1f  (%dx%d)', M(k), size(S,1), size(S,2)));
end
saveas(gcf, fullfile(baseDir, 'B_redimensionnement.png'));
% Remarque : axis image affiche chaque image à la taille de sa case ; regardez
% les tailles en titre. M = 0.1 -> forte pixelisation ; M > 1 -> image
% interpolée, plus floue, aucune information ajoutée.
