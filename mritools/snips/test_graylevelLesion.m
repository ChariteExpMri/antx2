
clear;clc
warning off

k=dir(fullfile(pwd,['nii' ],'s*'));
k={k(:).name}'
dirs= cellfun(@(k) [fullfile(pwd,'niiSubstack',k)] , k,'UniformOutput',0)

%% run over folders

errorlist={};
z=[]
for j=1    :   length(dirs) %mouse

cd(dirs{j})
% clear
[ha a]=rgetnii(fullfile( pwd,'wT2.nii' ));
[hb b]=rgetnii(fullfile( pwd,'wmask2.nii' ));

a(b~=1)=0;
a2=a(:);
a3=a2(find(a2~=0));

nc=3;
AIC = zeros(1,nc);
clear obj
options = statset('MaxIter',100);
for k = 1:nc
    obj{k} = gmdistribution.fit(a3,k,'Options',options,'Replicates',1);
    AIC(k)= obj{k}.AIC;
end

[minAIC,numComponents] = min(AIC);

 obj{numComponents}.mu;

%  mu=obj{numComponents}.mu';
%  mu=sort(obj{nc}.mu');

  % mu=sort(obj{3}.mu');
mu=sort(obj{3}.mu');
 
 v=[];w=[];
 for i=1:length(mu)
     v(1,i)= (abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>mu(i))));
%       w(1,i)= (abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3<mu(i))));
 end
 disp(v);
 
% rsavenii('mist.nii', ha, a )
% 
% a2=a(:);
% a3=a2(find(a2~=0));
% 
% 
% rsavenii('mist2.nii', ha, a>36.8 )


% (abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3<38.96)))
% 
% (abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3<38.7)))

x=[
(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>33.5)))
(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3<43)))
(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3<37)))
(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>31)))
(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>27)))
]';

per=0.3747;
per=0.3
a4=sort(a3);
tr=a4(round(length(a4)*per));
zz=(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>tr)))  ;


if zz<10
    zz=zz*.5
elseif zz<25
    zz=zz*.75
end
% 
% if    (abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(a3))<20
%     per=0.7
%     a4=sort(a3);
%     tr=a4(round(length(a4)*per));
%     zz=(abs(prod(diag(ha.mat(1:3,1:3))))  ) .*(length(find(a3>tr)))
%     
% end

t2(j,1)=tr; %thresh at xPercent

disp(dirs{j});
disp(v);
disp(w);
disp(x);
z(j,:)=[ (v)  (w) x zz]
dd(j,:)=mu;
ts(j,1)=tr;
end

%====================================
ss=[47.23%uncorrected
61.21
34.10
50.70
11.85
62.17
41.75
78.49
52.75
18.90
33.51
141.72
64.40
47.39
90.07
18.09
33.85
]


aa=[... %corrected
 34.82
51.49
18.58
38.44
3.65
40.38
32.54
52.57
38.65
9.72
27.70
102.52
50.93
40.14
70.92
10.87
26.34
]

%  38.2506
%ist: 34.2790

rr=[z(:,[ end]) aa       z(:,[ end])-aa ]; 
r3=sortrows(rr,2)


%    6.6963    3.6500    3.0463
%    11.1056    9.7200    1.3856
%     9.9553   10.8700   -0.9147
%    23.4883   18.5800    4.9083
%    23.0455   26.3400   -3.2945
%    22.5072   27.7000   -5.1928
%    31.3193   32.5400   -1.2207
%    34.4950   34.8200   -0.3250
%    32.7576   38.4400   -5.6824
%    35.4491   38.6500   -3.2009
%    33.9580   40.1400   -6.1820
%    44.1664   40.3800    3.7864
%    45.7839   50.9300   -5.1461
%    44.8736   51.4900   -6.6164
%    51.3332   52.5700   -1.2368
%    57.3152   70.9200  -13.6048
%   114.6923  102.5200   12.1723

%••••••••••••••••PLOT••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
rr=[ss aa z(:,[ end])       z(:,[ end])-aa ];rr=sortrows(rr,2)
mm=mean(rr)
 ms=std(rr)/sqrt(size(rr,1))
 
 fg,bar(1:3,mm(1:3),'k');hold on; errorbar(1:3,mm(1:3),ms(1:3),'.k'); set(gca,'fontsize',20);ylabel('lesionSize [qmm]')
 fg,plot(rr(:,2),rr(:,3),'or','markerfacecolor','r'); set(gca,'fontsize',20);xlabel('corSusanne');ylabel('corHistogram');
 
 


