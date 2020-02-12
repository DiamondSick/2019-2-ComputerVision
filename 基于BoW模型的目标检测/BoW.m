clc;clear;close all;
%================用30%训练数据测试分类器性能===============
% setDir  = fullfile('./train');
% imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
%     'foldernames');
% [trainSet,testSet] = splitEachLabel(imds,0.3,'randomize');
% bag = bagOfFeatures(trainSet,'PointSelection','Detector','StrongestFeatures',0.8,'VocabularySize',200);
% classifier = trainImageCategoryClassifier(trainSet,bag);
% confMatrix = evaluate(classifier,testSet);
% PREDICTED
% KNOWN   | neg    pos    
% ------------------------
% neg     | 0.86   0.14   
% pos     | 0.08   0.92  
% 
% negative:label=1 positive:label=2
%================用全部训练集训练===============
% allSet=imageSet('./train','recursive');
% bag=bagOfFeatures(allSet,'PointSelection','Detector','StrongestFeatures',0.8,'VocabularySize',200);
% classifier = trainImageCategoryClassifier(trainSet,bag);
% save classifier.mat classifier
%===============目标识别======================
tic;
load classifier.mat classifier;
width=94;height=34;step=5;threshold=0.5;
testSet=imageSet('./test');
for k=1:testSet.Count
    k
    Img=read(testSet,k);
    [m,n]=size(Img);
    bbox=[];score=[];
    for j=1:step:m-height+1
        for i = 1:step:n-width+1
            tmp=Img(j:j+height-1,i:i+width-1);
            [label,loss]=predict(classifier,tmp);
            diff=abs(loss(2)-loss(1));
            if(label==2&&diff>threshold)
                bbox=[bbox;i,j,width,height];
                score=[score;diff];              
            end
        end
    end
    
    [selectedBbox,selectedScore] = selectStrongestBbox(bbox,score,'RatioType','Min','OverlapThreshold',0.3);
    I = insertObjectAnnotation(Img,'rectangle',selectedBbox,...
        cellstr("loss:"+num2str(selectedScore)),'FontSize',8,'TextColor','r',...
        'Color','r','TextBoxOpacity',0);
    %imwrite(I,['./labeledTest/test-',num2str(k-1),'.bmp']);
end
toc;
%plot(confi);
%%
a=[0,1,0,0;0,0,1,0;1,0,0,0;0,0,0,1];
p=[0;1;1;1];
p'*inv(a)








