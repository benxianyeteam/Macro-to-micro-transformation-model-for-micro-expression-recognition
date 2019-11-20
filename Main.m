clc;
clear all;
%load testdata.mat;
%load testdata1.mat;
load 88CKTrain.mat;
load 88CKTest.mat;
load 88CASMETrain.mat;
load 88casmetest.mat;
load CASMElabel.mat;

a=[CKDisgustTrain,CKHappyTrain,CKSurpriseTrain];
b=[CASMEDisgustTrain,CASMEHappinessTrain,CASMESurpriseTrain];
traindata = [a;b];
[k1,k2] = size(a);
%DisgustTrain = [CKDisgustTrain,CASMEDisgustTrain];
%HappinessTrain = [CKHappyTrain,CASMEHappinessTrain];
%SurpriseTrain = [CKSurpriseTrain,CASMESurpriseTrain];
%traindata = [DisgustTrain;HappinessTrain;SurpriseTrain];
M = traindata;
[U,S,V] = svd(M,0);
%  R1 = U(1:59*kk,:);%����
%  X1 = CKtest(1:59*kk,:);%�����������
R1 = U(1:k1,:);%����
X1 = CKtest;%�����������
vG = ((R1'*R1))*R1'*X1;
%aaa = X1*U*inv(S);
%vG = (R1'*R1)\(R1'*X1);
%  R2 = U(59*kk+1:end,:);%΢����
R2 = U(k1+1:end,:);%΢����
XX2 = R2*vG;

X2 = casme88;%΢�����������

labelX2 =cas3label;
labelXX2 = CKtestlabel;

accu1 = 0;
    for m = 1:36%΢����
       for n = 1:300%����
           dist(n) = norm(X2(:,m)-XX2(:,n));
        end
       [MinV,min_index] = sort(dist,'ascend');
        if labelXX2(min_index(1)) == labelX2(m)
     accu1 = accu1 + 1;
        end       
    end
    accu = accu1/36;
    disp(accu);
     


