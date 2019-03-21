clc
clear all
close all

k = imread('./abhi.jpg');
% yiq_image  = rgb2ntsc(k);
I=k(:,:,:);
faceDetect = vision.CascadeObjectDetector();
bbox=step(faceDetect,I);
face=imcrop(I,bbox);
centerx=size(face,1)/2+bbox(1);
centery=size(face,2)/2+bbox(2);
eyeDetect = vision.CascadeObjectDetector('RightEye');
eyebox=step(eyeDetect,face);
n=size(eyebox,1);
e=[];
d=0;
for it=1:n
    for j=1:n
        if (j > it)
          if ((abs(eyebox(j,2)-eyebox(it,2))<68)&& (abs(eyebox(j,1)-eyebox(it,1))>40))
            e(1,:)=eyebox(it,:);
            e(2,:)=eyebox(j,:);
            d=1;break;
          end
        end
    end
    if(d == 1)
        break;
    end
end
eyebox(1,:)=e(1,:);
eyebox(2,:)=e(2,:);
c=eyebox(1,3)/2;
d=eyebox(1,4)/2;
eyeCenter1x=eyebox(1,1)+c+bbox(1);
eyeCenter1y=eyebox(1,2)+d+bbox(2);
e=eyebox(2,3)/2;
f=eyebox(2,4)/2;
eyeCenter2x=eyebox(2,1)+e+bbox(1);
eyeCenter2y=eyebox(2,2)+f+bbox(2);
ndetect=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
nosebox=step(ndetect,face);
noseCenterx=nosebox(1,1)+(nosebox(1,3)/2)+bbox(1);
noseCentery=nosebox(1,2)+(nosebox(1,4)/2);
m=[1,noseCentery,size(face,1),((size(face,2))-noseCentery)];
mouth=imcrop(face,m);
mdetect=vision.CascadeObjectDetector('Mouth','MergeThreshold' ,20);
mouthbox=step(mdetect,mouth);
for it=1:size(mouthbox,1)
    if(mouthbox(it,2)>20)
        mouthbox(1,:)=mouthbox(it,:);
        break;
    end
end
mouthbox(1,2)=mouthbox(1,2)+noseCentery;
noseCentery=noseCentery+bbox(2);
Mouth = mat2gray(mouth);
imwrite(Mouth,'mouth.jpg');
% imshow(Mouth);