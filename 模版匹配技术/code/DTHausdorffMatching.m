function [x,y] = DTHausdorffMatching(M,N)
[m,n]=size(M);
[m1,n1]=size(N);
EM=edge(double(M),'canny');
EN=edge(double(N),'canny');
for j=1:m1
    EN(j,2)=0;
    EN(j,n1-1)=0;
end
for i=1:n1
   EN(2,i)=0; 
   EN(m1-1,i)=0;
end

HausdorffDis=[];
loc=[];
for i=1:m-m1+1
    for j=1:n-n1+1
      HausdorffDis=[HausdorffDis;DTHausdorff(EM(i:i+m1-1,j:j+n1-1),EN,M(i:i+m1-1,j:j+n1-1),N,0.9,0.9)] ;
      loc=[loc;[i,j]];
    end
end
index=find(HausdorffDis==min(HausdorffDis));
x=loc(index,1);y=loc(index,2);
if length(x)>1
    x=x(1);
end
if length(y)>1
    y=y(1);
end
end

