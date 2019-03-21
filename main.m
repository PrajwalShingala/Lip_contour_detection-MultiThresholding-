clc
clear all
close all

rgb = imread('./lips.jpg');
% rgb = histeq(rgb);
rgb_img = imgaussfilt(rgb,1);
yiq_image  = rgb2ntsc(rgb_img);
% Retaining Q chromaticity
q_com = yiq_image(:,:,3);
% q_com = histeq(q_com);
% imtool(q_com);
% imwrite(q_com,'Q_img.jpg');
sz = size(q_com);

%% left and right points
level = graythresh(q_com);
BW = imbinarize(q_com,0.045);
% imtool(BW);
num = floor(sz(2)/10);
std = zeros(1,sz(2));
mn = mean(BW);
for y = 1:sz(2)
    for x = 1:sz(1)
        std(y) = sqrt( (BW(x,y) - mn(y))^2 /sz(1));
    end
end

% cp = findchangepts(std,'MaxNumChanges',num);
% Ly = cp(1,1);
% Ry = cp(1,num);
% [max_num_l,Lx] = max(q_com(:,Ly));
% [max_num_r,Rx] = max(q_com(:,Ry));


%% Dividing image into uppper and lower part
% x1 = Ly;
% x2 = Ry;
% y1 = Lx;
% y2 = Rx;
% coefficients = polyfit([x1, x2], [y1, y2], 1);
% a = coefficients (1);
% b = coefficients (2);
% Q_upper = zeros(sz);
% Q_lower = zeros(sz);
% for x = 1:sz(2)
%     for y = 1:sz(1)
%         if (a*x + b - y) > 0
%             Q_upper(y,x) = q_com(y,x);
%         else
%             Q_upper(y,x) = 0;
%         end
%         if (a*x + b -y ) < 0
%             Q_lower(y,x) = q_com(y,x);
%         else
%             Q_lower(y,x) = 0;
%         end
%     end
% end


%% Thresholding
level = graythresh(q_com);
Q_upper = imbinarize(q_com,level);
Otsu_T = level;
t = level-0.01;
D = zeros(1,20);
max1= 0;
for loopvar = 1:20
    t = t + 0.001;
    Q = imbinarize(q_com,t);
%     imtool(Q_upper);
    
    %Morph Op
    SE_closing = strel('disk',10);
    SE_opening = strel('disk',5);
    Q = imclose(Q,SE_closing);
    Q = imopen(Q,SE_opening);
    
    %Connected Comp
    CC = bwconncomp(Q,4);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    k = size(numPixels);
    for i = 1:(k(2))
        if i == idx
            continue;
        else
            Q(CC.PixelIdxList{i}) = 0;
        end
    end
    qup = [];
    qdown = [];
    qx = [];
    figure(1);
    imshow(rgb);
    hold on
    [Q_Cont , h_up] = imcontour(Q);
    [x,y,z] = C2xyz(Q_Cont);
    x=x{1};
    y=y{1};
    qup(1,:) = x(:) + 5;
    qdown(1,:) = x(:) - 5;
    qx = y(:);
    l = size(qup);
    Dvalue = 0; 
    for loopi = 1:l(2)-1
        for loopj = 1:l(2)-1
            Dvalue = Dvalue + abs( q_com( (round(qx(loopi))) , round((qup(loopi))) ) - q_com( (round(qx(loopj))), round((qdown(loopj))) ) );
        end
    end
    Dvalue = Dvalue/(l(2)*l(2))
    
    if(Dvalue>max1)
        max1 = Dvalue;
        thresh_final = t;
        Qcont_final = Q_Cont;
    end   
end


%% Multi Threshold
% CC = bwconncomp(Q_upper,4);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% k = size(numPixels);
% for i = 1:(k(2)-1)
%     Q_upper(CC.PixelIdxList{idx+i}) = 0;
% end
% figure(1);
% imshow(Q_upper);

%% Contour
%Morphological op
% SE_closing = strel('disk',10);
% SE_opening = strel('disk',5);
% Q_upper = imclose(Q_upper,SE_closing);
% Q_upper = imopen(Q_upper,SE_opening);
% % Contouring lip
% figure(2);
% imshow(rgb);
% hold on;
% [Q_up_Cont , h_up] = imcontour(Q_upper); 