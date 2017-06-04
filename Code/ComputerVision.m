%Computer Vision = epic

I1 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\puzzle1.jpg'));
I2 = im2double(imread('C:\Users\Marc\Documents\GitHub\ComputerVision\Pictures\partially_solved.jpg'));

%% 


[r1,c1] = harris(I1);

%All 'edges' found inside this boundery layer (which follows the edge of the 
%pics) will be deleted
boundery = 10;

%removes points found along the edges
top_side = find(r1 < boundery);
lower_side = find(r1 > length(I1(:,1))- boundery);
left_side = find(c1 < boundery);
right_side = find(c1 > length(I1) - boundery);

%Alle lements that have to be deleted from both the row and corresponding column vector
delete = [top_side; lower_side; left_side; right_side];

%delete the rows and columns
r1(delete) = [];
c1(delete) = [];


%plot image together with found edges
figure, imshow(I1,[]), hold on
plot(c1,r1,'r+'), title('corners detected');

hold off

%% second image (some error with deleteing of points around the edge for this image do not undestand :p

[r2,c2] = harris(I2);

boundery = 20;
%delete points found along the edges

top_side = find(r2 < boundery);
lower_side = find(r2 > length(I2(:,1))- boundery);
left_side = find(c2 < boundery);
right_side = find(c2 > length(I2) - boundery);

%put them in 1 matrix, thus all these elements have to eb deleted in
%both the row and corresponding column vector
delete = [top_side; lower_side; left_side; right_side];

r2(delete) = [];
c2(delete) = [];

figure, imshow(I2,[]), hold on
plot(c2,r2,'r+'), title('corners detected');

hold off