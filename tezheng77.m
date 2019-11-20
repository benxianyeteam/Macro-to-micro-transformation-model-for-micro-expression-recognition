clc;
clear all
microCls = {'disgust','happiness','surprise'};
rootPath = 'F:\Casme';

FxRadius = 1; 
FyRadius = 1;
TInterval = 2;

TimeLength = 2;
BorderLength = 1;

bBilinearInterpolation = 1;  % 0: not / 1: bilinear interpolation
%% 59 is only for neighboring points with 8. If won't compute uniform
%% patterns, please set it to 0, then basic LBP will be computed
Bincount = 59; %59 / 0
NeighborPoints = [8 8 8]; % XY, XT, and YT planes, respectively
if Bincount == 0
    Code = 0;
    nDim = 2 ^ (NeighborPoints(1));  %dimensionality of basic LBP
else
    % uniform patterns for neighboring points with 8
    U8File = importdata('UniformLBP8.txt');
    BinNum = U8File(1, 1);
    nDim = U8File(1, 2); %dimensionality of uniform patterns
    Code = U8File(2 : end, :);
    clear U8File;
end

for cls =1:3
    
    microPath = strcat(rootPath,'\',microCls{cls});
    sampleNum = length(dir(microPath))-2;
    Histogram =zeros(59*49,sampleNum);
%     for samp = 134:sampleNum
 for samp = 1:sampleNum
        disp(['正在处理',microCls{cls},'类第',num2str(samp),'个样本']);
        sampRoot = strcat(microPath,'\',num2str(samp));
        frames = dir([sampRoot,'\*.jpg']);
       
        VolData = zeros(33, 33, length(frames));
     for i = 1:7
            for j = 1:7
                for frm = 1:length(frames)
                    imgName = strcat(sampRoot,'\',num2str(frm),'.jpg');
                    imgDat = imread(imgName);
                   grayDat = rgb2gray(imgDat );
                    alignDat = imresize(grayDat,[231,231]);
                    blockDat = alignDat((i-1)*33+1:i*33,(j-1)*33+1:j*33);
%                     if frm ==1
%                         [height,width] = size(alignDat);
%                         VolData = zeros(height, width, length(frames));
%                     end                   
            VolData(:, :, frm) =  blockDat;
                end
                        His  = LBPTOP(VolData, FxRadius, FyRadius, TInterval, NeighborPoints, TimeLength, BorderLength, bBilinearInterpolation, Bincount, Code);
                        row = ((i-1)*7+j-1)*59+1;
                        col=((i-1)*7+j)*59;
                      

             Histogram(row:col,samp) = mean(His)';
%      Histogram(:,samp) = mean(His)';
       %  save([sampRoot,'\BlockHist_LBPTOP1.mat'],'Histogram');
            end
     end
      % eval([microCls{cls},'=',Histogram,';'])
       eval([microCls{cls} ' =Histogram;' ]);
    save(['77CASMEmicro_',microCls{cls},'.mat'],[microCls{cls}])
end
end
