
function [bmatrix bval bvec]=getBmatrix(methodfile)

% [bmatrix bval bvec]=getBmatrix(fullfile(pwd,'method'))


% fi=fullfile(pwd,'method')
% methfi='method'
% a=textread('%s',methfi,'delimiter','\n')

a=textread(methodfile,'%s','delimiter','\n');

%% n# B0 images
s1   =find(~cellfun(@isempty,regexpi(a,'^##\$PVM_DwAoImages=')));
nB0  =str2num(a{s1}( cell2mat(regexpi(a(s1),'='))+1 :end));



%% Bvec
s1=find(~cellfun(@isempty,regexpi(a,'^##\$PVM_DwDir=')))+1;
s2=find(~cellfun(@isempty,regexpi(a,'^##')) );
s2=s2(min(find(s2>s1)) )-1;

c= char(a(s1:s2));

c2='';
for i=1:size(c,1);
    c2=[c2 ' ' c(i,:)];
end
c3=str2num(c2);
bvec=reshape(c3', [3 length(c3)/3])' ;  


%% Bval
s1=find(~cellfun(@isempty,regexpi(a,'^##\$PVM_DwEffBval=')))+1;
s2=find(~cellfun(@isempty,regexpi(a,'^##')) );
s2=s2(min(find(s2>s1)) )-1;

c= char(a(s1:s2));

c2='';
for i=1:size(c,1)
    c2=[c2 ' ' c(i,:)];
end
bval=str2num(c2)' 
bval(1:nB0)=0; %set Bvalue for B0 to Zero

%%  out
bmatrix=[ bval [ zeros(nB0,3);bvec ]   ]


    