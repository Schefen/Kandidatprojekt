function [ fargbild ] = WatershedJ( bild, pixlar, nfile, slice_resolution )

I = im2double(bild);


hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

se = strel('disk', pixlar(1,1));         %4

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

fgm = imregionalmax(Iobrcbr);

I2 = I;
I2(fgm) = 255;

se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, pixlar(2,1)); %10 
I3 = I;
I3(fgm4) = 255;

for i=1:nfile
    bw(:,:,i) = im2bw(Iobrcbr(:,:,i), graythresh(Iobrcbr(:,:,i)));
end

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

gradmag2 = imimposemin(gradmag, bgm | fgm4);
L = watershed(gradmag2);
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;

Lrgb = zeros(slice_resolution(1), slice_resolution(2),3, nfile);
%size(Lrgb)
%size(L)
%size(label2rgb(L(:,:,i), 'jet', 'w', 'shuffle'))
for i=1:nfile
    Lrgb(:,:,:,i) = label2rgb(L(:,:,i), 'jet', 'w', 'shuffle');
end

fargbild = Lrgb;
%size(fargbild)
%figure(1), imshow(fargbild, [])


end

