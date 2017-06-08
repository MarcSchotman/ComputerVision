%trying contours of each piece
for i =1:12
number = i;
piece = ['piece' , num2str(number)];
I = puzzle.(piece).Image;
%resize to reduce computational effort and convert to gray image if it's
%not already

if(size(I,3)> I)
    I = rgb2gray(I) ;
end


% wanted_size= [490, 700];
% 
% 
% I = imresize(I_grey, wanted_size);
%applygaussian filter to reduce noise
w = fspecial('gaussian',[10 10],3);
I = imfilter(I,w);

%find the edges of the picture using the 'canny' approximation
[~, threshold] = edge(I, 'canny');
fudgeFactor = 0.1;
I = edge(I,'canny', threshold*fudgeFactor);

%remove border line of white (edges is detected all around the border of
%the image because of bad picture i guess..) Thus this noise has to be
%removed
boundery = 3;
%left and top borders
I(:,1:boundery) = 0;
I(1:boundery,:) = 0;

%bottom and right border
xmax = length(I(1,:));
ymax = length(I(:,1));
I(:, xmax-boundery : xmax) = 0;
I(ymax-boundery : ymax, :) =0;

%stretches all the lines found in the gradient image in order to make sure
%they make a closed perimeter which can be filled with the next function


se90 = strel('line', 6, 90);
se0 = strel('line', 6, 0);
I = imdilate(I, [se90 se0]);

%fills the holes in the image
I = imfill(I, 'holes');

%smoothens the filled pieces by eroding twice with a diamond structuring
%element
seD = strel('diamond',2);
I = imerode(I,seD);
I = imerode(I,seD);

%extracts outlines in the picture
I = bwperim(I);


figure
imshow(I)
end
%%
if piece_count == number_of_pieces
    
    for i = 1:piece_count
        
        piece_number = ['piece', num2str(i)];
        I = struct.(piece_number).Image;

        I = rgb2gray(I);
        %applygaussian filter to reduce noise
        figure 
        hold on
%         w = fspecial('gaussian',[5 5],2);
%         I = imfilter(I,w);

        I = stdfilt(I);
        subplot(1,3,1)
        
        I = imfill(I);
        I = imfill(I);
        imshow(I)
        
        I = imbinarize(I);
%         se90 = strel('line', 3, 90);
%         se0 = strel('line', 3, 0);
%         I = imdilate(I, [se90 se0]);
%        I = imclearborder(I);
        
        contour_piece= contours(I,1);
        struct.(piece_number).contour = contour_piece';
        
        
        subplot(1,3,2)
        imshow(struct.(piece_number).Image);
        subplot(1,3,3)
        plot(struct.(piece_number).contour(:,1), struct.(piece_number).contour(:,2));
        hold off
    end
end


%%
fontSize = 20;
grayImage = rgb2gray(puzzle.piece3.Image);
subplot(3, 1, 1);
imshow(grayImage, []);
title('Original Image', 'FontSize', fontSize);
I_cleared = imclearborder(grayImage);

standardDeviationImage2 = stdfilt(grayImage,ones(5));
subplot(3, 1, 2);
imshow(standardDeviationImage2, [])
title('Built-in stdfilt() filter', 'FontSize', fontSize);

filled = imfill(standardDeviationImage2);
Binary = imbinarize(filled);
%Binary = imclearborder(Binary);
%


% margin = 2; % Whatever
% croppedImage = imcrop(Binary, [margin, margin, length(Binary(1,:)) - 2 * margin, length(Binary(:,1)) - 2 * margin]);
% binaryImage = imclearborder(croppedImage);
% binaryImage = logical(padarray(binaryImage, margin));

subplot(3, 1, 3);
contour_piece= contours(Binary,1)';
hold on
imshow(grayImage)
checking =true;
% while checking ==true
%     
%     for i = 1:2
%         difference= diff(contour_piece);
% 
%         [row, column] = find(abs(difference(:,i)) > 1);
%         if isempty(row)
%             checking = false;
%             break
%         else
%             contour_piece(row,:) = [];
%         end
%         
%     end
% end


plot(contour_piece(2:end, 1),contour_piece(2:end,2),'-r');
hold off
%%

w = fspecial('gaussian',[10 10],5);
blurredImage = imfilter(grayImage,w);
subplot(2, 3, 2);
imshow(blurredImage, []);

% Blur the image with a 5 by 5 averaging (box filter) window.
% blurredImage = conv2(grayImage, ones(4,4)/9);
% subplot(2, 3, 2);
% imshow(blurredImage, []);
% title('Blurred Image', 'FontSize', fontSize);

% Perform a variance filter.
% Output image is the variance of the input image in a 3 by 3 sliding

VarianceFilterFunction = @(x) var(x(:));
varianceImage = nlfilter(grayImage, [3 3], VarianceFilterFunction);
% An alternate way of doing the variance filter is on the next line:
% varianceImage = reshape(std(im2col(originalImage,[3 3],'sliding')),
%size(originalImage)-2);
subplot(2, 3, 3);
imshow(varianceImage, [])
title('Variance Image', 'FontSize', fontSize);

% Compute the square root of the variance image to get the standard
%deviation.
standardDeviationImage = sqrt(varianceImage);
subplot(2, 3, 4);
imshow(standardDeviationImage, [])
title('Standard Deviation Image', 'FontSize', fontSize);

% Compute the standard deviation filter with MATLAB's built-in
%stdfilt() filter.



% hold off
% Perform Sobel filter
% h = fspecial('sobel') returns a 3-by-3 filter h (shown below) that
%emphasizes horizontal edges
% using the smoothing effect by approximating a vertical gradient.
% If you need to emphasize vertical edges, transpose the filter h'.
% [ 1 2 1
% 0 0 0
% % -1 -2 -1 ]
% verticalSobelKernel = fspecial('prewitt');
% sobelImage = imfilter(grayImage, verticalSobelKernel);
% subplot(2, 3, 6);
% imshow(sobelImage, [])
% title('Sobel edge filter', 'FontSize', fontSize);

%%
% for i = 1:number_of_pieces
%     
%     piece_number = ['piece', num2str(i)];
%     I = puzzle.(piece_number).Image;
%     I = rgb2gray(I);
%     
%     w = fspecial('gaussian',[10 10],5);
%     I = imfilter(I,w);
%     I = contour(I,1);
%     
%     se90 = strel('line', 2, 90);
%     se0 = strel('line', 2, 0);
%     I = imdilate(I, [se90 se0]);
%     figure; imshow(I)
% end
% %%
% for i = 1:number_of_pieces
%     
%     piece_number = ['piece', num2str(i)];
%     I = puzzle.(piece_number).Image;
%     
%     I = rgb2gray(I);
%     figure 
%     I_logic = imbinarize(I);
%     imshow(bwboundaries(I_logic))
%     %applygaussian filter to reduce noise
%     w = fspecial('gaussian',[10 10],2);
%     I = imfilter(I,w);
%     
%     %find the edges of the picture using the 'canny' approximation
%     [~, threshold] = edge(I, 'canny');
%     fudgeFactor = 2;
%     I = edge(I,'canny', threshold*fudgeFactor);
%   
%     
%     %stretches all the lines found in the gradient image in order to make sure
%     %they make a closed perimeter which can be filled with the next function
%     
%     
%     se90 = strel('line', 2, 90);
%     se0 = strel('line', 2, 0);
%     I = imdilate(I, [se90 se0]);
%     
%     %fills the holes in the image
%     I = imfill(I, 'holes');
%     
%     I = imclearborder(I);
%     %smoothens the filled pieces by eroding twice with a diamond structuring
%     %element
%     seD = strel('diamond',1);
%     I = imerode(I,seD);
%     I = imerode(I,seD);
%     
%     se90 = strel('line', 1, 90);
%     se0 = strel('line', 1, 0);
%     %extracts outlines in the picture
%     I = bwperim(I);
%     I = imdilate(I, [se90 se0]);
%     struct.(piece_number).contour = I;
%     figure
%     imshow(I)
% end

%% Stuff that works but is not needed now


% %% harris corner detection
% disp('Detecting edges of the image(s)')
% 
% [r1,c1] = harris(I1);
% [r2,c2] = harris(I2);


% %% figures
% 
% %plots images together with the 'edges' detected
% figure, imshow(I1,[]), hold on
% plot(c1,r1,'r+'), title('edges detected');
% 
% hold off
% 
% figure, imshow(I2,[]), hold on
% plot(c2,r2,'r+'), title('edges detected');
% 
% hold off


%This normalizes the image w.r.t. color. MI thought it could help but it
%didnt for now....

% red = I1(:,:,1);
% green = I1(:,:,2);
% blue = I1(:,:,3);
% 
% S = red+ green+blue;
% Nred = red ./S;
% Ngreen = green ./S;
% Nblue = blue ./S;
% 
% I1_norm = cat(3,Nred,Ngreen,Nblue);
% imshow(I1_norm)