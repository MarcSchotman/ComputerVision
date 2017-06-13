close all
for i =1
piece = ['piece' , num2str(i)];
I = puzzle.(piece).Image;
w = fspecial('gaussian',[10 10],1);
I = imfilter(I,w);

[height, width, planes] = size(I);
rgb = reshape(I, height, width * planes);


r = imadjust(I(:, :, 1));             % red channel
g = imadjust(I(:, :, 2));             % green channel
b = imadjust(I(:, :, 3));             % blue channel
figure
threshold = 0.90;                % threshold value
subplot(2,1,1)
imagesc(rgb);                   % visualize RGB planes
Ir = r > threshold;
Ig = g > threshold;
Ib = b > threshold;

Icheck = zeros(size(Ir));

[r_r, c_r] = find(Ir == true);
[r_g, c_g] = find(Ig == true);
[r_b, c_b] = find(Ib == true);
r = [r_r; r_g; r_b];
c = [c_r; c_g; c_b];

Icheck(r,c) =1;


subplot(2,1,2)
imshow(Icheck);

end
