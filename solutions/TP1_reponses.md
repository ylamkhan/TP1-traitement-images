# TP1 – Découverte du traitement d'images : réponses

## 0. Définition d'une image
```matlab
I = repmat(1:256, 256, 1);   % A(i,j) = j, sans boucle for
figure; image(I); colorbar
figure; imagesc(I); colorbar
```
**Conclusion :** une image est une matrice, et chaque valeur sert d'indice dans une palette.
- `image` utilise la valeur brute comme indice. La palette par défaut n'a que 64 couleurs, donc toutes les valeurs > 64 sont saturées à la dernière couleur.
- `imagesc` met les données à l'échelle de [min, max] sur toute la palette, ce qui donne un dégradé complet.

L'affichage dépend donc de la façon dont les valeurs sont associées aux couleurs, et pas seulement des données.

## Palette
```matlab
colormap(gray(256))        % niveaux de gris
colormap(jet), hot, cool, bone, copper, hsv ...
t = linspace(0,1,256)';
maPalette = [min(1,3*t), min(1,max(0,3*t-1)), max(0,3*t-2)];  % noir→rouge→jaune→blanc
colormap(maPalette)        % ou colormapeditor
```
**Conclusion :** la palette est une table N×3 (R, G, B dans [0,1]). La valeur d'un pixel est la ligne de la table utilisée. Changer la palette change l'affichage sans toucher aux données. C'est utile pour les fausses couleurs, pour faire ressortir des détails et pour les images indexées, qui sont plus compactes.

## A. Manipulation d'images
**1) `imfinfo`** (valeurs mesurées sur vos fichiers) :

| Fichier | Format | Taille | Bits/pixel | Type | Taille fichier |
|---|---|---|---|---|---|
| lena.bmp | BMP | 200×200 | 24 | truecolor (RGB) | 120 056 o |
| lena.tif | TIFF | 512×512 | 8 | grayscale | 262 598 o |
| cameraman.bmp | BMP | 512×512 | 8 | indexed (palette 256 gris) | 263 222 o |
| cameraman.tif | TIFF | 512×512 | 8 | grayscale | 262 750 o |

Les fichiers ne sont pas compressés : environ 512×512 = 262 144 octets de données, plus l'en-tête (et la palette de 1 024 octets pour le BMP).

**2) Formats supportés** (`imformats`) : BMP, GIF, HDF4, ICO, CUR, JPEG/JPG, JPEG 2000 (JP2, JPX, J2K, J2C), PBM, PGM, PPM, PNM, PCX, PNG, RAS, TIFF, XWD, FITS.
- Sans perte : BMP, PNG, TIFF, GIF (limité à 256 couleurs).
- Avec perte : JPEG.

**3) Commandes**

| Action | Commande |
|---|---|
| Lire une image entière | `I = imread('cameraman.tif');` |
| Lire une ligne | `L = I(35,:);` (colonne : `I(:,185)`) |
| Écrire une ligne | `I(35,:) = valeurs;` |
| Écrire une image | `imwrite(I,'sortie.tif');` |

**4)** Voir `partieA_manipulation.m`. Le script affiche l'image, puis le profil de la ligne 35 et celui de la colonne 185 avec `plot`, sur un seul `subplot(1,3,…)`.

## B. Transformations géométriques
- `imrotate(I, θ)` pour θ = −45, −90, 45, 90.
  - À ±90°, la rotation est exacte : c'est une simple permutation des pixels.
  - À ±45°, le cadre s'agrandit (environ 725×725) et les coins sont remplis de noir. L'interpolation adoucit un peu l'image.
- `imresize(I, M)` pour M = 0.5, 0.1, 1.5, 2.5. Les tailles obtenues sont 256, 52 (arrondi de 51,2), 768 et 1280 pixels de côté.
  - Avec M = 0.1, l'image est très pixelisée et les détails sont perdus.
  - Avec M > 1, l'image est interpolée et un peu floue : l'agrandissement n'ajoute aucune information.

## C. Séparation des couleurs
`color2rgb` et `color2gray` **n'existent pas** dans MATLAB. Les équivalents sont :
```matlab
R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
imshow(cat(3,R,zeros(size(R),'like',R),zeros(size(R),'like',R)))  % canal rouge en couleur
Gray = rgb2gray(RGB);   % Y = 0.2989R + 0.5870G + 0.1140B
```
Une zone est claire dans un canal quand cette couleur y est forte. Le vert a le plus grand poids dans la conversion en gris, car l'œil y est le plus sensible.

## D. Quantification
```matlab
[X,map] = gray2ind(I, N);  imshow(X, map)   % N = 128, 64, 32, 16, 8, 4, 2
```
| Niveaux | Observation |
|---|---|
| 128, 64 | Pas de différence visible avec l'original |
| 32 | Premiers faux contours dans les dégradés lisses (ciel) |
| 16, 8 | Faux contours nets, effet « posterisation » |
| 4, 2 | Image très dégradée ; 2 niveaux = image binaire |

**Seuil :** les faux contours apparaissent autour de **32 niveaux (5 bits)**. Il faut environ 64 niveaux (6 bits) pour qu'ils ne soient plus visibles.
