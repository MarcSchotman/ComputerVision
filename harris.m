function [r,c] = harris(I_grey)
   
    
    

   
    %% % Creation of a centered gaussian kernal
    w = fspecial('gaussian',[10 10],1);
    gauss_image = imfilter(I_grey,w);%,'conv','same'); %maybe 'conv' here? 
    %imshow(gauss_image)

    %[Gx,Gy] = imgradientxy(gauss_image,'IntermediateDifference');
    
    % obtaining image gradients
    kernal = [-2,-1,0,1,2];
    I_conv_x = imfilter(I_grey,kernal,'conv');
    kernal_y = kernal';
    I_conv_y = imfilter(I_grey,kernal_y,'conv');


    wI_x2 = conv2((I_conv_x.^2) , w,'same');
    wI_y2 = conv2((I_conv_y.^2), w,'same');
    wI_xy = conv2((I_conv_y.*I_conv_x),w,'same');

    %% Eigenvalue analysis
    a = wI_x2;
    b = wI_xy;
    c = wI_y2;
    lambda_1 = (a+c)/2 + sqrt(b.^2+((a-c)/2).^2);
    lambda_2 = (a+c)/2 - sqrt(b.^2+((a-c)/2).^2);

    % Harris feature matrix 
    alpha = 0.001;
    harris_im = lambda_1.*lambda_2 - alpha.*((lambda_1 + lambda_2).^2);
    radius = 1;
    thresh = 0.0002;
    cim=harris_im;
    im=I_grey;

    [r, c] = nonmaxsuppts(cim, radius, thresh, im);
