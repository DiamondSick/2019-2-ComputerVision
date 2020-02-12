function [x,y] = correlationMatching(M,N)
[m,n]=size(M);
[m1,n1]=size(N);
% EM=edge(M,'canny');
% EN=edge(N,'canny');

corrRes=[];
loc=[];
for i=1:m-m1+1
    for j=1:n-n1+1
      corrRes=[corrRes;correlation(M(i:i+m1-1,j:j+n1-1),N)] ;
      loc=[loc;[i,j]];
    end
end
index=find(corrRes==max(corrRes));
x=loc(index,1);y=loc(index,2);
end

