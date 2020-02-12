clear;clc;
I=imread('Scene.jpg');
T1=imread('Template_1.jpg');
T2=imread('Template_2.jpg');
[m n]=size(I);
[m1, n1]=size(T1);
[m2, n2]=size(T2);

figure;
subplot(231);
imshow(I);
[x y]=correlationMatching(I,T1);
rectangle('Position',[y,x,n1,m1],'edgecolor','r');
title(['相关系数 左上角坐标(',num2str(y),',',num2str(m-x),')']);

subplot(232);
imshow(I);
[x,y]=HausdorffMatching(I,T1);
rectangle('Position',[y,x,n1,m1],'edgecolor','r');
title(['Hausdorff距离 左上角坐标(',num2str(y),',',num2str(m-x),')']);

subplot(233);
imshow(I);
[x,y]=DTHausdorffMatching(I,T1);
rectangle('Position',[y,x,n1,m1],'edgecolor','r');
title(['基于DT的Hausdorff距离 左上角坐标(',num2str(y),',',num2str(m-x),')']);
%======================%
subplot(234);
imshow(I);
[x y]=correlationMatching(I,T2);
rectangle('Position',[y,x,n2,m2],'edgecolor','r');
title(['相关系数 左上角坐标(',num2str(y),',',num2str(m-x),')']);

subplot(235);
imshow(I);
[x,y]=HausdorffMatching(I,T2);
rectangle('Position',[y,x,n2,m2],'edgecolor','r');
title(['Hausdorff距离 左上角坐标(',num2str(y),',',num2str(m-x),')']);

subplot(236);
imshow(I);
[x,y]=DTHausdorffMatching(I,T2);
rectangle('Position',[y,x,n2,m2],'edgecolor','r');
title(['基于DT的Hausdorff距离 左上角坐标(',num2str(y),',',num2str(m-x),')']);

