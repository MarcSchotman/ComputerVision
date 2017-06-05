%read in images
clear all
close all

I1 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\puzzle_internet.jpg'));
I2 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\partially_solved.jpg'));

%% harris corner detection
disp('Detecting edges of the image(s)')

[r1,c1] = harris(I1);
[r2,c2] = harris(I2);


%% Find individual pieces by grouping of found edges
% pieces = 12;
% disp('Finding piece centers')
% y_im  = length(I1(:,10));
% x_im  = length(I1);
% 
% [x_pieces1, y_pieces1] = clustering(pieces, c1, r1, x_im, y_im);
% [x_pieces2, y_pieces2] = clustering(pieces, c2, r2, x_im, y_im);
% %function [x_pieces,y_pieces] = Clustering(pieces,, x_points,  y_points., x_im, y_im)

%% segmentiation.m 
disp('Detecting outline')
Outline = segmentation(I1);
Segout = I1; 
Segout(Outline) = 0; 
figure, imshow(Segout), title('outlined original image');

%% figures

%plots images together with the 'edges' detected
figure, imshow(I1,[]), hold on
plot(c1,r1,'r+'), title('edges detected');

hold off

figure, imshow(I2,[]), hold on
plot(c2,r2,'r+'), title('edges detected');

hold off


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