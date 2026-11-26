%% TP1 - Partie D : Quantification d'une image
clear; close all; clc;
% --- Recherche automatique des dossiers (marche depuis TP1/ ou TP1/solutions/) ---
baseDir = fileparts(mfilename('fullpath'));
if isempty(baseDir), baseDir = pwd; end        % exécution section par section / code collé
cand = {baseDir, fullfile(baseDir,'..'), pwd, fullfile(pwd,'..')};
imgDir = '';
for i = 1:numel(cand)
    if exist(fullfile(cand{i}, 'cameraman.tif'), 'file') == 2, imgDir = cand{i}; break; end
end
if isempty(imgDir), error('Images introuvables : faites cd vers le dossier TP1 ou TP1/solutions.'); end
outDir = fullfile(imgDir, 'solutions');        % les résultats sont enregistrés ici
if exist(outDir, 'dir') ~= 7, outDir = imgDir; end
% Si Image Processing Toolbox absente : utiliser les versions simplifiées
tbDir = fullfile(outDir, 'sans_toolbox');
if exist('imrotate','file') ~= 2 && exist(tbDir, 'dir') == 7, addpath(tbDir); end
I = imread(fullfile(imgDir,'cameraman.tif'));
if size(I,3) > 1, I = rgb2gray(I); end

niveaux = [256 128 64 32 16 8 4 2];
figure('Name','Quantification (gray2ind)');
for k = 1:numel(niveaux)
    N = niveaux(k);
    [X, map] = gray2ind(I, N);          % image indexée à N niveaux + palette gray(N)
    subplot(2,4,k); imshow(X, map);
    title(sprintf('%d niveaux', N));
end
saveas(gcf, fullfile(outDir, 'D_quantification.png'));

% Méthode équivalente "à la main" : pas de quantification q = 256/N
figure('Name','Quantification manuelle');
for k = 1:numel(niveaux)
    N = niveaux(k); q = 256 / N;
    Iq = uint8(floor(double(I) / q) * q + q/2);   % reconstruction au milieu de l'intervalle
    subplot(2,4,k); imshow(Iq); title(sprintf('N=%d, pas=%g', N, q));
end
saveas(gcf, fullfile(outDir, 'D_quantification_manuelle.png'));

% Conclusion : jusqu'à 32 niveaux, l'image est visuellement identique.
% Les faux contours apparaissent à 16 niveaux dans les zones de dégradé
% lisse (ciel) et deviennent très nets à 8 niveaux et moins.
% Seuil minimal : environ 32 niveaux (5 bits) ; en dessous l'image se
% dégrade nettement (2 niveaux = image binaire).
