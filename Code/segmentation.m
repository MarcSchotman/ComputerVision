function [Outline] = segmentation(I)
%make image to grey image
I_gray = rgb2gray(I);

%apply gaussian filter to filter out most of the noise
w = fspecial('gaussian',[10 10],5);
I_gray = imfilter(I_gray,w);

%find the edges in the image using gradients
%first edge defines the appropiate treshold
[~, threshold] = edge(I_gray, 'canny');
fudgeFactor = 0.1;
BWs = edge(I_gray,'canny', threshold*fudgeFactor);

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
se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);

BWsdil = imdilate(BWs, [se90 se0]);


%fills the holes in the image
BWdfill = imfill(BWsdil, 'holes');

%smoothens borders
BWnobord = imclearborder(BWdfill, 4);

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);


se90 = strel('line', 5, 90);
se0 = strel('line', 5, 0);
%extracts outlines in the picture
Outline = bwperim(BWfinal);
Outline = imdilate(Outline, [se90 se0]);




end