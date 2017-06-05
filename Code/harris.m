function [r,c] = harris(I)
   

    if(size(I,3) > 1)
        I_grey = rgb2gray(I) ;
    end
    
    %maybe increasing constrast helps, nto sure yet
%     low_in = min(min(I_grey));
%     high_in = max(max(I_grey));
%     
%     low_out = 0.01;
%     high_out = 0.99;
%    
%     I_grey = imadjust(I_grey, [low_in; high_in], [low_out; high_out]);

    %% % Creation of a centered gaussian kernal
    w = fspecial('gaussian',[15 15],2);
    I_grey = imfilter(I_grey,w);%,'conv','same'); %maybe 'conv' here? 


    %[Gx,Gy] = imgradientxy(gauss_image,'IntermediateDifference');
    
    %obtaining image gradients
    kernal = [-2,-1,0,1,2];
    I_conv_x = imfilter(I_grey, kernal, 'conv');
    
    I_conv_y = imfilter(I_grey, kernal', 'conv');


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
    thresh = 0.000002;
  

    [r, c] = nonmaxsuppts(harris_im, radius, thresh, I);
    
    %All 'edges' found inside this boundery layer (which follows the edge of the 
    %pics) will be deleted
    boundery = 15;

    %finds the corners detected within the boundery layer 
    top_side = find(r < boundery);
    lower_side = find(r > length(I(:,1))- boundery);
    left_side = find(c < boundery);
    right_side = find(c > length(I) - boundery);

    %Deletes the found elements from the vector r and c
    delete = [top_side; lower_side; left_side; right_side];
    
    r(delete) = [];
    c(delete) = [];
