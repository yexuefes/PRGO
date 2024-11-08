% Binary plant rhizome growth-based optimization
 algorithm:an efficient high-dimensional feature
 selection approach %
%                                                                         %
% Authors:                                                                %
%  Jin Zhang, Fu Yan, Jianqiang Yang                                      %
%                                                                         %
% ** E-mail:                                                              %
%          17678924479@163.com                                            %
%          fyan3@gzu.edu.cn  
%           18380957756@163.com
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all;

addpath("E:\Desktop\PRGO\PRGO\"); 


for kk=1
for id=1
    tic;
   Func_id =id;          % CEC2017 1~30 
   nPop = 50;            % Population Size
   N = 30;               % number of Decision variables 
   MaxFEs = 6000;   % Maximum number of function evaluations
   NumofExper = 51 ;       % Number of test %运行次数
   LB=-100;%lb;          % Lower Bound
   UB=100;%ub;           % Upper Bound
% =====================================================================================

%% 
Function_name=['F' num2str(Func_id)];
%========== CEC2017 ==========

CostFunction=Func_id;
%============================= 
% LB = LB.*ones(1,N);       
% UB = UB.*ones(1,N);       

% Empty Solution Structure
if kk==1
    SumBestCostPRGO_=zeros(MaxFEs,1);
    BestSolCostPRGO_= []; %zeros(MaxFEs,1);
end

%===================================================

for ii=1:NumofExper

% --------  Call PRO algorithm to optimize the selected function --------%%
if kk==1
   [BestCostPRGO_,BestSolCostPRGO(ii)]=PRGO(MaxFEs,LB,UB,N,id);%PRO(N,MaxFEs,LB,UB,Population,nPop,CostFunction,ii); 
   SumBestCostPRGO_=SumBestCostPRGO_+ BestCostPRGO_(1:MaxFEs);
end

end


% AveBestCostPRO_=SumBestCostPRO_ ./ NumofExper;
%% PRO
toc;
r = toc;
if kk==1
    Mean_PRGO = mean(BestSolCostPRGO);
    SD_PRGO  = std(BestSolCostPRGO);
    filename=['AAPRGO Result CEC14 D30_' Function_name '.mat'];% BWO
    save(filename);
end

end
end
