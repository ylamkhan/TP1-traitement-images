%% TP1 - Partie C : Séparation des couleurs
% NB : "color2rgb" et "color2gray" ne sont pas des fonctions MATLAB.
% On sépare les canaux par indexation et on utilise rgb2gray.
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
fichiers = {'image1.jpg','image2.jpg'};

for k = 1:numel(fichiers)
    RGB = imread(fullfile(imgDir, fichiers{k}));
    R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
    Z = zeros(size(R), 'like', R);

    figure('Name', ['Séparation RGB - ' fichiers{k}]);
    subplot(2,4,1); imshow(RGB); title('Originale');
    % Composantes en niveaux de gris (intensité de chaque canal)
    subplot(2,4,2); imshow(R); title('R (gris)');
    subplot(2,4,3); imshow(G); title('G (gris)');
    subplot(2,4,4); imshow(B); title('B (gris)');
    % Composantes en couleur
    subplot(2,4,6); imshow(cat(3,R,Z,Z)); title('Rouge');
    subplot(2,4,7); imshow(cat(3,Z,G,Z)); title('Vert');
    subplot(2,4,8); imshow(cat(3,Z,Z,B)); title('Bleu');
    saveas(gcf, fullfile(outDir, sprintf('C_rgb_%d.png', k)));

    % Conversion en niveaux de gris : Y = 0.2989 R + 0.5870 G + 0.1140 B
    Gray = rgb2gray(RGB);
    figure('Name', ['Niveaux de gris - ' fichiers{k}]);
    subplot(1,2,1); imshow(RGB);  title('Couleur');
    subplot(1,2,2); imshow(Gray); title('rgb2gray');
    saveas(gcf, fullfile(outDir, sprintf('C_gray_%d.png', k)));
end
% Remarque : une zone apparaît claire dans un canal si cette couleur y est
% fortement présente (ex. le ciel est clair dans B). Le vert a le poids le
% plus fort dans rgb2gray car l'œil y est le plus sensible.
