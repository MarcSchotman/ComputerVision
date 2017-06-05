close all
% for debugging
I1 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\puzzle1.jpg'));

I1_gray = rgb2gray(I1);
figure, imshow(I1_gray)
w = fspecial('gaussian',[10 10],8);
I1_gray = imfilter(I1_gray,w);

[~, threshold] = edge(I1_gray, 'canny');
fudgeFactor = 0.75;
BWs = edge(I1_gray,'canny', threshold*fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');
%%
%remove border line of white (edges is detected all around the border of
%the image because of bad picture i guess..) Thus this noise has to be
%removed

boundery = 5;
%left and top borders
BWs(:,1:boundery) = 0;
BWs(1:boundery,:) = 0;

%bottom and right border
xmax = length(BWs(1,:));
ymax = length(BWs(:,1));
BWs(:, xmax-boundery : xmax) = 0;
BWs(ymax-boundery : ymax, :) =0;

%stretches all the lines found in the gradient image
se90 = strel('line', 10, 90);
se0 = strel('line', 10, 0);

BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

%fills the holes in the image
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill), title('binary image with filled holes');

%smoothens the filled pieces by eroding twice with a diamond structuring
%element
seD = strel('diamond',1);
BWfinal = imerode(BWdfill,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');
BWfinal = BWdfill;
se90 = strel('line', 5, 90);
se0 = strel('line', 5, 0);
%extracts outlines in the picture
BWoutline = bwperim(BWfinal);
BWoutline = imdilate(BWoutline, [se90 se0]);

Segout = I1; 
Segout(BWoutline) = 0; 
figure, imshow(Segout), title('outlined original image');
