clear; clc;
prefix='Test_Img_';
% for i=1:3
%     filename=[prefix,num2str(i),'.jpg'];
%     I=imread(filename);
%     figure;
%     imhist(I);
% end

threshold=[120,115,65];

for i=1:3
    filename=[prefix,num2str(i),'.jpg'];
    I=imread(filename);
    I(I<=threshold(i))=0;
    I(I>threshold(i))=255;
    figure;
    imshow(I);
end

