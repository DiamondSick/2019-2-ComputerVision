clear all;clc;
prefix='Texture_mosaic_';
titles=["(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)"];
w = 17;
for k=1:4
    filename=[prefix,num2str(k),'.jpg'];
    I=imread(filename);
    [m,n] = size(I);
    I1=padarray(I,[(w-1)/2,(w-1)/2],'replicate');
    I1=histeq(I1);
    GLCM_con = zeros(m,n);
    GLCM_hom = zeros(m,n);
    GLCM_cor = zeros(m,n);
    GLCM_ene = zeros(m,n);
    for i = 1:m
        for j = 1:n
            W = I1(i:i+w-1,j:j+w-1);
            [glcms,SI] = graycomatrix(W,'NumLevels',16,'G',[],'offset',[0,1;-1,1;-1,0;-1,-1]);
            stats = graycoprops(glcms,'all');
            GLCM_con(i,j) = mean(stats.Contrast);
            GLCM_hom(i,j) = mean(stats.Homogeneity);
            GLCM_cor(i,j) = mean(stats.Correlation);
            GLCM_ene(i,j) = mean(stats.Energy);
        end
    end
    
    features(:,1) = reshape(GLCM_con,m*n,1);
    features(:,2) = reshape(GLCM_hom,m*n,1);
    features(:,3) = reshape(GLCM_cor,m*n,1);
    features(:,4) = reshape(GLCM_ene,m*n,1);
    
    [Idx,Ctrs] = kmeans(features,k+1);
    Idx=reshape(Idx,m,n);
    I_show = zeros(m,n);
    d=255/k;
    for i=1:k+1
        I_show(Idx==i)=(i-1)*d;
    end
    I_show = uint8(I_show); 
    figure;
    subplot(121);imshow(I);title(titles(2*k-1))
    subplot(122);imshow(I_show);title(titles(2*k))
end






