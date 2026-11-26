%% TP1 - Partie 0 : Définition d'une image et palette
clear; close all; clc;

%% 1) Matrice I de largeur 256 telle que A(i,j) = j  (sans boucle for)
I = repmat(1:256, 256, 1);      % 256 lignes, chaque ligne = 1..256

figure('Name','image vs imagesc');
subplot(1,2,1); image(I);   axis image; title('image(I)');   colorbar;
subplot(1,2,2); imagesc(I); axis image; title('imagesc(I)'); colorbar;
saveas(gcf, '0_image_vs_imagesc.png');
% Conclusion : une image n'est qu'une matrice ; chaque valeur est un indice
% dans la palette. image() utilise directement la valeur comme indice
% (palette par défaut de 64 couleurs -> tout ce qui dépasse 64 est saturé),
% alors que imagesc() met à l'échelle [min,max] sur toute la palette.

%% 2) Palette en niveaux de gris
figure('Name','Palette gris');
imagesc(I); axis image; colormap(gray(256)); colorbar; title('colormap gray(256)');
saveas(gcf, '0_palette_gris.png');

%% 3) Différentes palettes
palettes = {'gray','jet','hot','cool','bone','copper','hsv','parula'};
figure('Name','Différentes palettes');
for k = 1:numel(palettes)
    ax = subplot(2,4,k);
    imagesc(I); axis image off;
    colormap(ax, feval(palettes{k}, 256));
    title(palettes{k});
end
saveas(gcf, '0_differentes_palettes.png');

%% 4) Palette personnelle : noir -> rouge -> jaune -> blanc (256 x 3, valeurs dans [0,1])
n = 256; t = linspace(0,1,n)';
maPalette = [min(1,3*t), min(1,max(0,3*t-1)), max(0,3*t-2)];
figure('Name','Palette personnelle');
imagesc(I); axis image; colormap(maPalette); colorbar; title('Palette personnelle');
saveas(gcf, '0_palette_personnelle.png');
% (on peut aussi l'éditer graphiquement : colormapeditor)

% Conclusion : la palette (colormap) est une table de correspondance
% N x 3 (R,G,B) : la valeur du pixel est un indice dans cette table.
% Changer la palette change l'affichage sans modifier les données ;
% utile pour la visualisation (fausses couleurs, mise en évidence de
% détails, images indexées moins volumineuses).
