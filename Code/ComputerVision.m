%read in images
clear all
close all

number_of_pieces = 12;
I1 = imresize(im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\IM1.jpg')), [864 1296]);
% I2 = imresize(im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\IM2.jpg')), [490 700]);
% I3 = imresize(im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\IM3.jpg')), [490 700]);
% I4 = imresize(im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\IM4.jpg')), [490 700]);
% I5 = imresize(im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\IM5.jpg')), [490 700]);

%% Find contours
[puzzle, piece_count1] = find_pieces(I1,number_of_pieces);
% [puzzle_pieces2, piece_count2] = find_pieces(I2,number_of_pieces);
% [puzzle_pieces3, piece_count3] = find_pieces(I3,number_of_pieces);
% [puzzle_pieces4, piece_count4] = find_pieces(I4,number_of_pieces);
% [puzzle_pieces5, piece_count5] = find_pieces(I5,number_of_pieces);

%% figures 
figure
hold on
for i =1:number_of_pieces
    piece = ['piece' , num2str(i)];
    I = puzzle.(piece).Image;
    
    tresh = 0.002;
    [r,c] = corners_of_pieces(I,tresh);
    
    subplot(3,4,i)
    
    hold on
    imshow(I)
    plot(c,r,'r+')
    hold off
end
    