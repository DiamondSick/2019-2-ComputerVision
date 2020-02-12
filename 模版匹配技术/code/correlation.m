function [corr] = correlation(M,N)
[m,n]=size(N);
M=double(M);
N=double(N);
ssd=0;
sumM=0;
sumN=0;
for i=1:m
    for j=1:n
        ssd=ssd+M(i,j)*N(i,j);
        sumM=sumM+M(i,j)*M(i,j);
        sumN=sumN+N(i,j)*N(i,j);
    end
end
%sumM
corr=ssd/sqrt(double(sumM*sumN));
