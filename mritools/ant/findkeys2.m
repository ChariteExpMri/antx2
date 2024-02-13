


%   x=findkeys(keys,list);
%     [x hx]=findkeys(keys,list,'show',0);
%     [x hx]=findkeys(keys,list,'show',1);
    
    
function [x hx]=findkeys2(keys,list,varargin)

x={};
% clear;clc
% ==============================================
%%   prep
% ===============================================
if 0
    %% =========example======================================
    
    keys={
        '20231031_191353_wmstroke_mainstudy_AK7144_TP1_4d_CORRECTED_CC.obj'};
    
    list={'wmstroke_mainstudy_AK7140_TP1_4d_1_9'
        'wmstroke_mainstudy_AK7144_TP1_4d_CORRECTED_1_27'};
    
 
    x=findkeys2(keys,list);
    [x hx]=findkeys2(keys,list,'show',1);
    % [x hx]=findkeys2(keys,list,'show',1);
    %% ===============================================
    
    
end

%% ===============================================
%%   inputs
%% ===============================================

keys=cellstr(keys);
list=cellstr(list);
p.show=0;

if ~isempty(varargin)
   p0=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,p0);
end



%% ===============================================
%%      proc
%% ===============================================

for i=1:length(keys)
    o=calcmetric(keys{i},list,p);
    x(i,:)={o.key o.t  o.ht o.t2 o.info};
end

hx.info='___info___[findkeys.m]___';
hx.info2={...
    '[h]   header of the resulting output' 
    '[ht]  header of the table in column-2 of the  output' 
         };
hx.h={'key' 'table' 'tableheader' 'matlabtable'};
hx.ht=x{i,3};



% ==============================================
%%   metric
% ===============================================
function o=calcmetric(key,list,p)

% 's'

% li     =cellfun(@(a){[ a  repmat( '#',[1 size(char(list),2)-length(a)+5]  )   ]}, list );
li=list;
% [s1 s2 ]=deal(zeros(length(key),1));
[s1 s2 ]=deal(zeros(length(li),1));
[s3 indices]=deal(repmat({''},[length(li),1 ]));

for i=1:length(li)

%     [ d1,d2,d3 idx]=metricLCS( li{i},key);
%     s1(i,1)=d1;
%     s2(i,1)=d2;
%     s3{i,1}=d3;
%     indices{i,1}=idx;
    %% ===============================================
    str1=key;
    str2=li{i};
    P = length(str1);
    Q = length(str2);
    [D, dist, aLongestString idx] = metricLCS(str1, str2);
    nLCS = length(aLongestString);    %do not call the result LCS, that is the function name!
    RatioQ = nLCS/Q;
    RatioP = nLCS/P;
    
    this_EA = (RatioP + RatioQ)/2;  % MSTP-Similarity Equal Average
    this_WA = (P*RatioP+Q*RatioQ)/(P+Q);% MSTP-Similarity Weighted Average
    
%     z={ str1 str2  aLongestString this_EA  this_WA};
%     disp(cell2table(z));
    
    s1(i,1) =this_EA;
    s2(i,1)  =dist;
    s3{i,1}  =aLongestString;
    indices{i,1}=idx;
    
    
    %% ===============================================
    
end

typodiff=length(key)-s2;
isexact=strcmp(list,key);
metric=s1;
code=[isexact+metric];
[~,isort]=sort(code,'descend');
t=[num2cell([ code  typodiff]) s3  list repmat({key},[size(li,1) 1]) indices];
t=t(isort,:);



ht={'metric' 'missLetters' 'LCS' 'list' 'key' 'indices'};

t2=cell2table(t);
t2.Properties.VariableNames=ht;
if p.show==1
    disp(t2);
end
%% ===============================================

o.key=key;
o.t=t;
o.ht=ht;
o.t2=t2;
o.info={...
    '[metric]: '
    '  [2]: exact match :string in list is completly matching with key'
    '  [1]: string found; but there are possinle prefixes/suffix in the string in list'
    '  [>1]: metric similarity...higher is better'
    ''};





function [D, dist, aLongestString, index] = metricLCS(X,Y)

%Calculates the longest common substring between two strings.
% find Y-string in X-string, (X & Y cannot be permuted)!!
%  [D, dist, aLongestString, index] = metricLCS(X,Y)
% 'Y' is the KEY to be looked in 'X'
% 
% D                : distance metric                 
% dist             : distance                   
% aLongestString   : sub-string found in X                            
% index            : index of sub-string in X                    
% 
% 
%%
%%%Code written by David Cumin
%%%email: d.cumin@auckland.ac.nz
%%%INPUT
%%%X, Y - both are strings e.g. 'test' or 'stingtocompare'
%%%OUTPUT
%%%D is the substring over the length of the shortest string
%%%dist is the length of the substring
%%%aLongestString is a sting of length dist (only one of potentially many)
%%%For example
%%% X = 'abcabc';
%%% Y = 'adcbac';
%%% [D dist str] = LCS(X,Y);
%%% results in:
%%% D = 0.6667 
%%% dist = 4
%%% str = acbc
%%% this is seen for X: 'a-c-bc' and Y: 'a-cb-c'
%%%Make matrix
n =length(X);
m =length(Y);
L=zeros(n+1,m+1);
L(1,:)=0;
L(:,1)=0;
b = zeros(n+1,m+1);
b(:,1)=1;%%%Up
b(1,:)=2;%%%Left
for i = 2:n+1
    for j = 2:m+1
        if (X(i-1) == Y(j-1))
            L(i,j) = L(i-1,j-1) + 1;
            b(i,j) = 3;%%%Up and left
        else
            L(i,j) = L(i-1,j-1);
        end
        if(L(i-1,j) >= L(i,j))
            L(i,j) = L(i-1,j);
            b(i,j) = 1;%Up
        end
        if(L(i,j-1) >= L(i,j))
            L(i,j) = L(i,j-1);
            b(i,j) = 2;%Left
        end
    end
end

%===================================================================================================
%% ===============================================

L(:,1) = [];
L(1,:) = [];
b(:,1) = [];
b(1,:) = [];
dist = L(n,m);
D = (dist / min(m,n));
index=[];
if(dist == 0)
    aLongestString = '';
else
    %%%now backtrack to find the longest subsequence
    i = n;
    j = m;
    p = dist;
    aLongestString = {};
    
    while(i>0 && j>0)
        if(b(i,j) == 3)
            aLongestString{p} = X(i);
            index(1,p)=i;
            p = p-1;
            i = i-1;
            j = j-1;
        elseif(b(i,j) == 1)
            i = i-1;
        elseif(b(i,j) == 2)
            j = j-1;
        end
%         aLongestString
    end
    if ischar(aLongestString{1})
        aLongestString = char(aLongestString)';
    else
        aLongestString = cell2mat(aLongestString);
    end
end




%% ===============================================


