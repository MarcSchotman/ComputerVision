%read in images

I1 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\puzzle1.jpg'));
I2 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\partially_solved.jpg'));

%% harris corner detection
disp('Detecting edges of the image(s)')

[r1,c1] = harris(I1);
[r2,c2] = harris(I2);


%% Find individual pieces by grouping of found edges





%% figures

%plots images together with the 'edges' detected
figure, imshow(I1,[]), hold on
plot(c1,r1,'r+'), title('edges detected');

hold off

figure, imshow(I2,[]), hold on
plot(c2,r2,'r+'), title('edges detected');

hold off