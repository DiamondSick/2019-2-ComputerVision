clc;clear;close all;
C=3;%高斯混合模型的单模型个数
D=2.5;%方差的阈值系数
sd_init=6;%初始化模型的标准差
npic=200;%共有多少帧图片
alpha=0.01;%学习率
thresh=0.8;

fr=imread('Scene_Data/0000.jpg');
fr=double(rgb2gray(fr));
width=size(fr,2);
height=size(fr,1);
w=zeros(height,width,C);%单模型的权重,初始化第一个模型的权重为1
w(:,:,1)=1;
w(:,:,2:C)=0;
mean=zeros(height,width,C);%单模型的均值，初始化为第一帧像素
mean(:,:,1)=fr(:,:);
sd=ones(height,width,C)*sd_init;%单模型的标准差，初始化为sd_init
mask=zeros(npic,height,width);%分割后的图片

tic;
for n=1:npic
    filepath=['Scene_Data/',num2str(n,'%04d'),'.jpg'];
    br=imread(filepath);
    br=double(rgb2gray(br));
    for i=1:height
        for j=1:width
            ismatch=0;
            %更新参数
            for k=1:C
                u_diff=abs(br(i,j)-mean(i,j,k));
                if u_diff<=D*sd(i,j,k)
                    ismatch=1;
                    w(i,j,k)=(1-alpha)*w(i,j,k)+alpha;
                    p=alpha/w(i,j,k);
                    mean(i,j,k)=(1-p)*mean(i,j,k)+p*br(i,j);
                    sd(i,j,k)=sqrt((1-p)*(sd(i,j,k)^2)+p*(u_diff^2));
                else
                    w(i,j,k)=(1-alpha)*w(i,j,k);
                end
            end
            
            % 如果没有匹配的模型，用新模型取代权值最小的模型
            if ismatch==0
                [minv,minindex]=min(w(i,j,:));
                mean(i,j,minindex)=br(i,j);
                sd(i,j,minindex)=sd_init;
            end
            
            %对各个高斯按weight/std从大到小排序，找出权值之和大于阈值的前k个，作为背景模型，其余为前景
            w_sum=sum(w(i,j,:));
            w(i,j,:)=w(i,j,:)/w_sum;
            rank = w(i,j,:)./sd(i,j,:);
            [sorted_rank, rank_ind] = sort(rank, 'descend');
            
            for p=1:C
                if(sum(w(i,j,1:p))>=thresh)
                    if abs(br(i,j)-mean(i,j,p))<=D*sd(i,j,p)
                        mask(n,i,j)=255;
                    end
                    break;
                end
            end            
        end
    end
end
toc;
%%
% for n=1:npic
%     imshow(uint8(reshape(mask(n,:,:),height,width)));
%     pause(0.02);
% end
%%
videoObj = VideoWriter('result');
% videoObj.FrameRate = 24;
open(videoObj);
for n=1:npic
    t=uint8(reshape(mask(n,:,:),height,width)); 
    frames=im2frame(t,gray(256));
    writeVideo(videoObj,frames);
end
close(videoObj);


