function [struct, piece_count] = find_pieces(I, number_of_pieces)
%If there are more pieces found then number_of_pieces it will riterate and
%increase certain parameters with the iteration factor. The iteration
%factor is increased by 0.25 for every iteration needed. (this did not gave
%proper results yet though)



I_origin = I;
%resize to reduce computational effort and convert to gray image if it's
%not already

if(size(I,3)> I)
    I_grey = rgb2gray(I) ;
end


wanted_size= [490, 700];


I = imresize(I_grey, wanted_size);
%applygaussian filter to reduce noise
w = fspecial('gaussian',[10 10],2);
I = imfilter(I,w);

%find the edges of the picture using the 'canny' approximation
[~, threshold] = edge(I, 'canny');
fudgeFactor = 5;
I = edge(I,'canny', threshold*fudgeFactor);
%%
%remove border line of white (edges is detected all around the border of
%the image because of bad picture i guess..) Thus this noise has to be
%removed

boundery = 5;
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


se90 = strel('line', 5, 90);
se0 = strel('line', 5, 0);
I = imdilate(I, [se90 se0]);

%fills the holes in the image
I = imfill(I, 'holes');

%smoothens the filled pieces by eroding twice with a diamond structuring
%element
seD = strel('diamond',1);
I = imerode(I,seD);
I = imerode(I,seD);

se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
%extracts outlines in the picture
I = bwperim(I);
I = imdilate(I, [se90 se0]);
%% Contour determination

%This algorithm searches the image wich now contains the contours. The
%contourrs aer made up of a single line of one's.
%It scans the image until it hits a one, THen it stops scanning and looks
%for the next one attachted to this one. Afterwards it makes the found one
%zero so that it can not be 'found' again.
minimum_ones = 30; %if a contour consists out of less then 20 ones it is concidered noise
x = 1;
y = 1;
loopkill = false;
piece_count = 0;
while loopkill == false
    %reset
    completed =false;
    contour_found = false;
    puzzle_piece = zeros(size(I));
    
    while completed  == false
        %starts by resetting or initilasing variable next_found = false as the
        %next point is not yet found, duh :)
        next_found = false;
        %finds first x-y coordinate of contour stores, to start the search from
        %there
        if contour_found == false
            for x = 1:length(I(1,:))
                
                
                if I(y,x) == true
                    
                    puzzle_piece(y,x) =1 ;
                    I(y,x) =0;
                    contour_found = true;
                    break
                    
                end
                
            end
        end
        %if first contour is found find the rest of the contour, otherwise
        %go to next y coordinate
        if contour_found == false
            
            %if nothing is found in the entire picture so when it is at its
            %last pixel = [max_row max_coloumn]
            if y == length(I(:,1)) && x == length(I)
                loopkill = true;
                break
            end
            y = y+1;
            
        else
            
            %Look for next point of the contour, going clockwise: above, top
            %right, right, bottomr right, bottom, bottom left, left, top left
            
            %above
            if I(y-1, x)== true
                y = y-1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %top right
            elseif I(y-1, x+1)== true
                y = y - 1;
                x = x + 1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %right
            elseif I(y,x+1) == true
                x = x + 1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %bottom right
            elseif I(y+1, x+1)== true
                y = y + 1;
                x = x + 1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %bottom
            elseif I(y+1, x)== true
                y = y + 1;
                
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %bottom left
            elseif I(y+1, x-1)== true
                y = y + 1;
                x = x - 1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %left
            elseif I(y, x-1)== true
                x = x - 1;
                
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
                
                %top left
            elseif I(y-1, x-1)== true
                y = y - 1;
                x = x - 1;
                puzzle_piece(y,x) = 1;
                I(y,x) =0;
                next_found = true;
            end
            
            %If no next contour line is found, stop, contour extraction completed
            if next_found == false
                completed = true;
                break
            end
        end
        
    end
    % sometimes noise still gets through and is picked up as contour. A
    % check is done to delete contours that contain very little ones
    amount_ones = length(find(puzzle_piece == 1));
    if amount_ones < minimum_ones
        %nothing
    else
        %if it meets treshold and loopkill = false it will be recorded as piece
        if loopkill == false
            piece_count = piece_count +1;
            piece_number = ['piece', num2str(piece_count)];
            struct.(piece_number).Image= puzzle_piece;
        end
    end
end



% extracts the pieces from the original picture I_origin using the found
% contours.
for k = 1:piece_count
    
    
    piece_number = ['piece', num2str(k)];
    struct.(piece_number).Image = imresize(struct.(piece_number).Image, size(I_grey));
    
    [row1,col1] = find(struct.(piece_number).Image);
       
    filled = imfill(struct.(piece_number).Image, 'holes');
    extracted_piece =[];
    
    boundery = 15; 
    first_row = min(row1) - boundery;
    first_column = min(col1) - boundery;
    
    for i  = first_row:length(filled(:,1))
        for j  = first_column:length(filled(1,:))
            if filled(i,j)~=0 
                extracted_piece(i + 1 - first_row, j + 1 - first_column,:) = I_origin(i,j,:);
            end
        end
    end
    % Before this loop the background is black, this loop replaces the
    % background with its original pixels
    for i = 1:length(extracted_piece(:,1,1) + boundery)
        for j = 1:length(extracted_piece(1,:,1) + boundery )
            if extracted_piece(i,j,1)==0 
                extracted_piece(i,j,:) = I_origin(i + first_row, j + first_column,:);
            end
        end
    end
    struct.(piece_number).Image = extracted_piece;

end


end
