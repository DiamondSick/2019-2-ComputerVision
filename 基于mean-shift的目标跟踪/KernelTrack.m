clc;clear;close all;
I=imread('Car_Data/car001.bmp');
% imshow(I);
% h=imrect;
% pos=getPosition(h);
% rectangle('Position',[132,35,18,20],'EdgeColor','r','LineWidth',1);
nbin=16; % 将灰度值划分成16个bin
w=21;l=21; % 矩形框的长宽
h=(w/2)^2+(l/2)^2; %带宽
center=[ceil(w/2),ceil(l/2)];
pos=[35,132]; % 第一帧目标矩形框左上角的坐标
threshold=0.2; % 迭代的误差精度
maxiter=10; % 最大迭代次数
npic=100; %视频总帧数
dis_k=zeros(w,l); %距离权重矩阵k(x)
dis_g=zeros(w,l); %g(x)
C=0; %权重归一化系数
pos_seq=zeros(npic,2);%视频序列的矩形框坐标
pos_seq(1,1)=pos(2);pos_seq(1,2)=pos(1);
iter_seq=[];
err_seq=[];
for i=1:w
    for j=1:l
        dis=((i-center(1))^2+(j-center(2))^2)/h;
        dis_k(i,j)=normpdf(dis,0,1); %kernel是高斯函数
        dis_g(i,j)=dis_k(i,j)*dis;
        C=C+dis_k(i,j);
    end
end
error=0;
%目标模型的描述
q_area=I(pos(1):pos(1)+w-1,pos(2):pos(2)+l-1);
q_bin=zeros(w,l);
q_hist=zeros(1,nbin);

for i=1:w
    for j=1:l
        q_bin(i,j)=ceil(double(q_area(i,j)+1)/nbin);%判断该点属于第几个bin
        q_hist(q_bin(i,j))=q_hist(q_bin(i,j))+dis_k(i,j);
    end
end
q_hist=q_hist/C;
tic
% 候选模型的描述
for n=2:npic
    filepath=['Car_Data/car',num2str(n,'%03d'),'.bmp'];
    I=imread(filepath);
    iter=0;
    while(iter<=maxiter)
        iter=iter+1;
        p_area=I(pos(1):pos(1)+w-1,pos(2):pos(2)+l-1);
        p_bin=zeros(w,l);
        p_hist=zeros(1,nbin);
        for i=1:w
            for j=1:l
                p_bin(i,j)=ceil(double(p_area(i,j)+1)/nbin);
                p_hist(p_bin(i,j))=p_hist(p_bin(i,j))+dis_k(i,j);
            end
        end
        p_hist=p_hist/C;
        
        W=zeros(1,16);
        for i=1:16
            if p_hist(i)~=0
                W(i)=sqrt(q_hist(i)/p_hist(i));
            else
                W(i)=0;
            end
        end
        W=W/2;
        coeff=0;
        wx=[0,0];
        for i=1:w
            for j=1:l
                temp=dis_g(i,j)*W(p_bin(i,j));
                coeff=coeff+temp;
                wx=wx+temp*[i-center(1),j-center(2)];
            end
        end
        delta=wx/coeff;
        pos(1)=round(pos(1)+delta(1)); %迭代更新
        pos(2)=round(pos(2)+delta(2));
        t=delta(1)^2+delta(2)^2;
        if t==error
            break;
        else
            error=t;
        end
        
%         error=delta(1)^2+delta(2)^2;
%         if(error<threshold)
%             break;
%         end
    end
    
    pos_seq(n,1)=pos(2);
    pos_seq(n,2)=pos(1);
    
    iter_seq=[iter_seq,iter];
    err_seq=[err_seq,error];
    
end
toc

% 
% figure;
% subplot(121);
% imshow(I);
% subplot(122);
% imshow(I(pos(2):pos(2)+l-1,pos(1):pos(1)+w-1));
% figure;
% imshow(I);
% rectangle('Position',[pos(2),pos(1),l,w],'EdgeColor','r','LineWidth',1);
% 动画播放
for i=1:npic
    filepath=['Car_Data/car',num2str(i,'%03d'),'.bmp'];
    I=imread(filepath);
    imshow(I);
    rectangle('Position',[pos_seq(i,1),pos_seq(i,2),l,w],'EdgeColor','r','LineWidth',1);
    title(num2str(i));
    pause(0.02);
end
% figure;
% plot(iter_seq);
% hold on;
% plot(err_seq);
%
% figure;
% 
% plot((2:100),err_seq);
% title('error of sequence');

%%
A=[1,3i,0,i;-2,-i,1,-i];












