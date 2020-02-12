function [Hdis] = Hausdorff(EM,EN,M,N)
% M=double(M);
% N=double(N);
% 
% EM=edge(M,'canny');
% EN=edge(N,'canny');

[Xm Ym]=find(EM);%³¡¾°±ßÔµ×ø±ê
[Xn Yn]=find(EN);%Ä£°å±ßÔµ×ø±ê
lenM=size(Xm,1);
lenN=size(Xn,1);
H1=[];
for i=1:lenM
   minD=inf;
   for j=1:lenN
       tmp=sqrt((Xm(i)-Xn(j))^2+(Ym(i)-Yn(j))^2);
       if tmp<minD
          minD=tmp;
          minIndex=j;
       end
   end
   H1=[H1,abs(M(Xm(i),Ym(i))-N(Xn(minIndex),Yn(minIndex)))];
end

H2=[];
for i=1:lenN
    minD=inf;
    for j=1:lenM
        tmp=sqrt((Xn(i)-Xm(j))^2+(Yn(i)-Ym(j))^2);
        if tmp<minD
            minD=tmp;
            minIndex=j;
        end
    end
    H2=[H2,abs(N(Xn(i),Yn(i))-M(Xm(minIndex),Ym(minIndex)))];
end
Hdis=max(max(H1),max(H2));



