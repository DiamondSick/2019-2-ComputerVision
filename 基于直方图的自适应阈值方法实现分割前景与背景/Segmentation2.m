clear;clc;
prefix='Test_Img_';
for i=1:3
    filename=[prefix,num2str(i),'.jpg'];
    I=imread(filename);
    [m n]=size(I);
    H=imhist(I);
    fg=H/(m*n);
    index=find(H>0);
    threshold=0;  %最佳划分阈值
    K=1000;
    for i=1:length(index)
        t=index(i);
        X=I(I<=t);
        Y=I(I>t);
        p0=sum(fg(1:t));
        pb=1-p0;
        u0=mean(X);
        ub=mean(Y);
        s0=std(double(X));
        sb=std(double(Y));
        f0=normpdf([1:256],u0,s0);
        fb=normpdf([1:256],ub,sb);
        ptg=p0*f0+pb*fb;
        kt_eq=fg(index).*log10(fg(index)./ptg(index)');
        kt=sum(kt_eq);
        if kt<K
            K=kt;
            threshold=t-1;
        end
    end
    I(I<=threshold)=0;
    I(I>threshold)=255;
    
    figure;
    imshow(I);
end



% plot([1:256],p0.*normpdf([1:256],u0,s0)'+pb.*normpdf([1:256],ub,sb)')
% hold on;
% plot([1:256],fg)
