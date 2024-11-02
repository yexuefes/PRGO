function [Convergence_curve,Bestvalue] = PRGO(MaxIter,lb,ub,dim,fnum)

Seed_Number=50;
fhd = str2func('cec14_func');
rand('state',sum(100*clock));
L=length(lb);

if L==1
    LB = lb *ones(1,dim);% Lower bound of variable;
    UB = ub *ones(1,dim); % Upper bound of variable;
else
    LB = lb .*ones(1,dim);% Lower bound of variable;
    UB = ub .*ones(1,dim); % Upper bound of variable;
end

Convergence_curve = [];
Fun_eval= [];

Bestvalue=inf;
BestPosition=zeros(1,dim);
%% Initialization


for i=1:Seed_Number
      %Initializing the Position of initial eligible points
      Seed(i,:)=unifrnd(LB,UB);
      % Initializing the fitness of initial eligible points     
      Fun(i)=feval(fhd,Seed(i,:)',fnum)  - (fnum*100);%;
      Fun_eval=[Fun_eval; Fun(i)];
      if Bestvalue>Fun(i)
          Bestvalue=Fun(i);
          BestPosition=Seed(i,:);
      end
      Convergence_curve = [Convergence_curve;Bestvalue];
end

Iter=Seed_Number;

while Iter<=MaxIter

    Ir=randi([0,1],1,1);
    RandGroupNumber=randperm(Seed_Number,1);
    RandGroup=randperm(Seed_Number,RandGroupNumber);
    
    MeanGroup=mean(Seed(1:Seed_Number,:)).*(length(RandGroup)~=1)...
        +Seed(RandGroup(1,1),:).*(length(RandGroup)==1);

    % New Seeds
    Alpha(1,:)=2*rand(1,dim)-0.5;
    Alpha(2,:)=2*rand(1,dim)-1;
    Alpha(3,:)=(Ir(1)*rand(1,dim)+(~Ir(1)));
    
    ii=randi([1,2],1,3);
    SelectedAlpha= Alpha(ii,:);
    

    half=ceil(rand*Seed_Number);
    half1=ceil(Seed_Number-rand*half);

if rand>0.5
    %%%%%%%%%%%% 直根系植物
    TT=0;
    NewSeed(1,:)=MeanGroup+SelectedAlpha(1,:).*(MeanGroup-Seed(half,:));%侧根生长
    NewSeed(2,:)=Seed(i,:)+SelectedAlpha(2,:).*(BestPosition-Seed(half1,:));%纤维根生长
    NewSeed(3,:)=NewSeed(1,:)+SelectedAlpha(3,:).*(NewSeed(2,:)-unifrnd(LB,UB));%主根生长
else
    %%%%%%%%%%%% 须根系植物    
    TT=1;
    ii0=randi([0,1],1,1);
    II=ii0.*(Seed(i,:)+Seed(half,:)+Seed(half1,:))/3;
    NewSeed(1,:)=II+(Seed(1,:)-Seed(i,:)+Seed(half,:)-Seed(half1,:));
end

if TT==1
    NewSeed(1,:)=bound(NewSeed(1,:),UB,LB);
    Fun_evalNew(1,:)=feval(fhd,NewSeed(1,:)',fnum)  - (fnum*100);%
    Iter=Iter+1;
if Bestvalue>Fun_evalNew(1,:)
    Bestvalue=Fun_evalNew(1,:);
    BestPosition=NewSeed(1,:);
end
Convergence_curve = [Convergence_curve;Bestvalue];
else
    for j=1:3
        % Checking/Updating the boundary limits for Seeds
         NewSeed(j,:)=bound(NewSeed(j,:),UB,LB);
         Fun_evalNew(j,:)=feval(fhd,NewSeed(j,:)',fnum)  - (fnum*100);%
        % Evaluating New Solutions
%         Fun_evalNew(j,:)=feval(fhd,NewSeed(j,:)',fnum)  - (fnum*100);%fobj(NewSeed(j,:)',fnum)-100*fnum;
        Iter=Iter+1;
        if Bestvalue>Fun_evalNew(j,:)
            Bestvalue=Fun_evalNew(j,:);
            BestPosition=NewSeed(j,:);
        end
        Convergence_curve = [Convergence_curve;Bestvalue];
    end
end
        Seed=[Seed; NewSeed];
        Fun_eval=[Fun_eval; Fun_evalNew];

        % Update the best Seed
        [Fun_eval,SortOrder]=sort(Fun_eval);
        Seed=Seed(SortOrder,:);

        Seed=Seed(1:Seed_Number,:);
        Fun_eval=Fun_eval(1:Seed_Number,:);

    disp([ 'Iteration'  num2str(Iter) ': Best Cost =' num2str(Bestvalue)]);
end

end

function x=bound(x,UB,LB)
x(x>UB)=UB(x>UB); x(x<LB)=LB(x<LB);
end