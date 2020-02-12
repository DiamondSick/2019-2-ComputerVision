clear;clc;
I=imread('Scene.jpg');
T1=imread('Template_1.jpg');
T2=imread('Template_2.jpg');
[m, n]=size(I);
[m1, n1]=size(T1);
[m2,n2]=size(T2);
corrRes=[];
loc=[];
for i=1:m-m2+1
    for j=1:n-n2+1
      corrRes=[corrRes;correlation(I(i:i+m2-1,j:j+n2-1),T2)] ;
      loc=[loc;[i,j]];
    end
end
index=find(corrRes==max(corrRes));
x=loc(index,1);y=loc(index,2);
figure;
imshow(I);
rectangle('Position',[y,x,n2,m2],'edgecolor','r');
fprintf('T1定位的位置坐标为：(%d,%d),(%d,%d),(%d,%d),(%d,%d)',x,y,x+m1,y)