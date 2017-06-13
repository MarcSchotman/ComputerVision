%function I = find_contours_individual_piece(I)
close all
for i =1:12
piece = ['piece' , num2str(i)];
I = puzzle.(piece).Image;

%resize to reduce computational effort and convert to gray image if it's
%not already

if(size(I,3)> I)
    I = rgb2gray(I) ;
end

Iadjust = imadjust(I);

% wanted_size= [490, 700];
% 
% 
% I = imresize(I_grey, wanted_size);
%applygaussian filter to reduce noise
w = fspecial('gaussian',[10 10],2);
I = imfilter(I,w);
% figure
% imshow(I)
%find the edges of the picture using the 'canny' approximation
[~, threshold] = edge(Iadjust, 'canny');
fudgeFactor = 0.75;
Icanny = edge(I,'canny', threshold*fudgeFactor);

%remove border line of white (edges is detected all around the border of
%the image because of bad picture i guess..) Thus this noise has to be
%removed
% boundery = 3;
% %left and top borders
% I(:,1:boundery) = 0;
% I(1:boundery,:) = 0;
% 
% %bottom and right border
% xmax = length(I(1,:));
% ymax = length(I(:,1));
% I(:, xmax-boundery : xmax) = 0;
% I(ymax-boundery : ymax, :) =0;

%stretches all the lines found in the gradient image in order to make sure
%they make a closed perimeter which can be filled with the next function

I_filtered1 = bwareaopen(Icanny,10);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
I_dilated = imdilate(I_filtered1, [se90 se0]);

I_cleared = imclearborder(I_dilated);


%fills the holes in the image
I_filled = imfill(I_cleared, 'holes');


%smoothens the filled pieces by eroding twice with a diamond structuring
%element
seD = strel('diamond',2);
I_eroded = imerode(I_filled,seD);
I_eroded = imerode(I_eroded,seD);

I_filtered2 = bwareaopen(I_eroded,100);
%extracts outlines in the picture
I_final = bwperim(I_filtered2);


figure
subplot(3,3,1); imshow(Iadjust)
subplot(3,3,2); imshow(Icanny)
subplot(3,3,3); imshow(I_filtered1)
subplot(3,3,4); imshow(I_dilated)
subplot(3,3,5); imshow(I_cleared)
subplot(3,3,6); imshow(I_filled)
subplot(3,3,7); imshow(I_eroded)
subplot(3,3,8); imshow(I_filtered2)
subplot(3,3,9); imshow(I_final)
end
