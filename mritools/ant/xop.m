
% xop: operation on NIFIs
% xop.m is identical (wrapper function of) to xrename.m
% see help of xrename


function xop(showgui,fi,finew,extractnum,varargin)


% if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
% if exist('x')==0                           ;    x=[]                     ;end
% if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

%% ===============================================

inp={ 'showgui' 'fi' 'finew' 'extractnum' 'varargin'};
inpv=zeros(1,length(inp));
for i=1:length(inp)
    if exist(inp{i})==1;      inpv(i)=1; end
end
if isempty(varargin); inpv(end)=0; end
%% ===============================================


% inp=zeros(1,5)
% if exist('showgui')==1; showgui(1)=1; end
% if exist('fi')==1;      inp(2)=1; end


inp2=inp;
% inp2(find(inpv==0))={'[]'};
inp2=inp2(1:max(find(inpv~=0)));


% xrename(showgui,fi,finew,extractnum,varargin);
if isempty(inp2);
    xrename
else
    task=['xrename(' strjoin(inp2,',') ');'];
    eval(task);
end


