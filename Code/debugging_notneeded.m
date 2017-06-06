close all
clear all
% for debugging
I1 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\puzzle_internet.jpg'));
I1 = imresize(I1, [490 700]);
I1_gray = rgb2gray(I1);
figure, imshow(I1_gray)
w = fspecial('gaussian',[10 10],8);
I1_gray = imfilter(I1_gray,w);

[~, threshold] = edge(I1_gray, 'canny');
fudgeFactor = .75;
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
se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);

BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');
%%
%fills the holes in the image
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill), title('binary image with filled holes');
%%
%smoothens the filled pieces by eroding twice with a diamond structuring
%element
seD = strel('diamond',1);
BWfinal = imerode(BWdfill,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');


%%
se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
%extracts outlines in the picture
BWoutline = bwperim(BWfinal);
BWoutline = imdilate(BWoutline, [se90 se0]);
figure
imshow(BWoutline)
%%
x = 1;
y = 1;
search_image = BWoutline;
first_x = 0;
contour_found = false;
piecefound = true;
piece_count = 1;
while piecefound == true
    %reset
    completed =false;
    contour_found = false;
    puzzle_piece = zeros(size(search_image));
    
    while completed  == false
        %starts by resetting or initilasing variable next_found = false as the
        %next point is not yet found, duh :)
        next_found = false;
       %finds first x-y coordinate of contour stores, to start the search from
       %there
        if contour_found == false    
            for x = 1:length(search_image(1,:))


                if search_image(y,x) == true 

                    puzzle_piece(y,x) =1 ;
                    search_image(y,x) =0;
                    contour_found = true;
                    break

                end

            end
        end
        %if first contour is found find the rest of the contour, otherwise
        %go to next y coordinate
        if contour_found == false    
            
            %if nothing is found in the entire picture
            if y == length(search_image(:,1)) && x == length(search_image)
                piecefound = false;
                break
            end
            
            y = y+1;
            
        else

            %Look for next point of the contour, going clockwise: above, top
            %right, right, bottomr right, bottom, bottom left, left, top left

            %above
            if search_image(y-1, x)== true
                y = y-1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

             %top right
            elseif search_image(y-1, x+1)== true
                y = y - 1;
                x = x + 1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %right
            elseif search_image(y,x+1) == true
                x = x + 1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %bottom right
            elseif search_image(y+1, x+1)== true
                y = y + 1;
                x = x + 1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %bottom
            elseif search_image(y+1, x)== true
                y = y + 1;

                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %bottom left
            elseif search_image(y+1, x-1)== true
                y = y + 1;
                x = x - 1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %left
            elseif search_image(y, x-1)== true
                x = x - 1;

                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;

            %top left
            elseif search_image(y-1, x-1)== true
                y = y - 1;
                x = x - 1;
                puzzle_piece(y,x) = 1;
                search_image(y,x) =0;
                next_found = true;
            end

            %If no next contour line is found, stop, contour extraction completed
            if next_found == false
                disp(['piece ', num2str(piece_count), ' found'])
                
                completed = true;
                break
            end 
        end

    end
    
    piece_number = ['piece', num2str(piece_count)];
    struct.(piece_number)= puzzle_piece;
    piece_count = piece_count +1;
end
for i = 1:24
    piece_number = ['piece', num2str(i)];
    figure
    imshow(struct.(piece_number))
end
%%
puzzle1 = logical(struct.piece1);
Segout = I1; 
Segout(puzzle1) = 0; 
figure, imshow(Segout), title('outlined original image');