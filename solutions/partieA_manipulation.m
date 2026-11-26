%% TP1 - Partie A : Manipulation d'images avec MATLAB
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

%% A.1) Informations sur les 4 images
fichiers = {'lena.bmp','lena.tif','cameraman.bmp','cameraman.tif'};
for k = 1:numel(fichiers)
    info = imfinfo(fullfile(imgDir, fichiers{k}));
    fprintf('\n===== %s =====\n', fichiers{k});
    fprintf('Format      : %s\n', info.Format);
    fprintf('Taille      : %d x %d\n', info.Width, info.Height);
    fprintf('Bits/pixel  : %d\n', info.BitDepth);
    fprintf('Type couleur: %s\n', info.ColorType);
    fprintf('Taille fich.: %d octets\n', info.FileSize);
    disp(info);   % affichage complet
end

%% A.2) Formats supportés par MATLAB
imformats     % affiche la liste : BMP, CUR, FITS, GIF, HDF4, ICO, JP2, JPF,
              % JPX, J2C, J2K, JPEG/JPG, PBM, PCX, PGM, PNG, PNM, PPM, RAS,
              % TIFF/TIF, XWD

%% A.3) Commandes : lire / écrire une ligne ou une image
I = imread(fullfile(imgDir,'cameraman.tif')); % lire une image entière
ligne = I(35, :);                             % lire une ligne (ligne 35)
colonne = I(:, 185);                          % lire une colonne
J = I; J(35, :) = 255;                        % écrire une ligne (la mettre en blanc)
imwrite(J, fullfile(outDir,'cameraman_modifiee.tif'));  % écrire (stocker) une image entière

%% A.4) Afficher l'image, la ligne 35 et la colonne 185 avec subplot
figure('Name','Partie A.4');
subplot(1,3,1); imshow(I); title('cameraman.tif');
hold on; plot([1 size(I,2)], [35 35], 'r');      % repère ligne 35
plot([185 185], [1 size(I,1)], 'g'); hold off;   % repère colonne 185
subplot(1,3,2); plot(ligne, 'r');   title('Ligne 35');    xlabel('colonne j'); ylabel('niveau de gris'); xlim([1 numel(ligne)]);
subplot(1,3,3); plot(colonne, 'g'); title('Colonne 185'); xlabel('ligne i');   ylabel('niveau de gris'); xlim([1 numel(colonne)]);
saveas(gcf, fullfile(outDir, 'A4_cameraman_ligne_colonne.png'));
