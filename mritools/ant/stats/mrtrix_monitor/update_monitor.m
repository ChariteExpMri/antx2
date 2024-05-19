%get info
% v=update_monitor();  %get full info
% v=update_monitor('rootinfo',0)  ;%get rootinfo only
function v=update_monitor(varargin)
% v=[];
p.rootinfo=0;
if ~isempty(varargin)
   pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end


%% ===============================================

global an
sourcefile='';
try
    sourcefile=fullfile(fileparts(an.datpath),'DTI','source.txt');
end
if exist(sourcefile)~=2
  
    
    
    %% ===============================================
    cprintf('*[1 0 1]',[ 'ERROR: mrtrix-monitor and related functions not working' '\n'] );
    ms={['file "source.txt" notfound in [DTI]-folder of the current ANTx-project']
        ['potential reasons: ']
        ['  -ANTx-project not loaded']
        ['  -not all steps in DTIprep performed  ']
        ['  -script to export data to HPC not executed (see "scripts"-button)  ']
        };
    msg=strjoin(ms, char(10));
    cprintf('[0 0 1]',[ msg '\n'] );
    ME = MException( [mfilename ':sourcefile'],' ');
    throwAsCaller(ME)
   
   %% ===============================================
   
    return
end
t=preadfile(sourcefile); t=t.all;
for i=1:size(t,1)
    l=t{i};
    l=regexprep(l,'^\s*[','pp.');
    l=[regexprep(l,']','=''','once') ''';'];
    t{i}=l;
end
% get pp-struct
eval(strjoin(t,';'));

%% ===============================================

pastudy       =pp.HPCtargetdirWin ;% fullfile(fileparts(fileparts(pwd)));
datpath       = fullfile(pastudy, 'data');
[~,studyname] = fileparts(pastudy);
%% ===============================================
v.HPC_hostname=pp.hostname;%'s-sc-frontend2.charite.de';
v.pastudy     =pastudy;
v.HPCtargetdirUnix=pp.HPCtargetdirUnix;
v.backupDir   =pp.backup;
v.sourceDir   =pp.source;
v.sourcefile  =sourcefile;
if p.rootinfo==1
    return
end
%% ===============================================

[dirs] = spm_select('List',datpath,'dir'); dirs=cellstr(dirs);
idall=str2num(char(regexprep(dirs,'\D',''))); % to numeric
[dirsFP] = spm_select('FPList',datpath,'dir'); dirsFP=cellstr(dirsFP);

v.dirnum      =dirs;
v.dirsFP      =dirsFP;
v             =check_abnormalSubDirs(v);

%% ===============================================
pasub={'','mrtrix'};
patag={'main' 'mrtrix'};
t={};
for i=1:length(v.fpdir)
    
    for j=1:length(pasub)
        pax=fullfile(v.fpdir{i},pasub{j});
        k=dir(pax);
        k(find([k(:).isdir]==1))=[];
        
        fi ={k(:).name}';
        tim =[k(:).datenum]';
        mb  =[[k(:).bytes]./(1024^2)]';
        dt_min=zeros(length(fi),1);
        tnow=datevec(now);
        for ii=1:length(fi)
            dt_min(ii,1)=etime(tnow,datevec(k(ii).datenum))/60;
        end
        dt_h=dt_min./60;
        dt_d=dt_h/24;
        
        td=[  repmat(v.dirnum(i),[ length(fi) 1])...
            fi num2cell([mb dt_min dt_h dt_d ]) ...
            repmat(patag(j),[ length(fi) 1])];
        t=[t; td];
    end
    
end
t(regexpi2(t(:,2),'.*.gz'),:)=[]; %remove guzip-file
ht={'dirNo' 'nifti' 'mb' 'min' 'hour' 'day', 'sub'};
%% =======[check if exist for each animal]========================================
unif1=unique(   t(find(strcmp(t(:,7),patag{1})),2)    );
unif2=unique(   t(find(strcmp(t(:,7),patag{2})),2)    );
unif   =[unif1;unif2];
unifsub=[...
    repmat(patag(1),[length(unif1) 1]);
    repmat(patag(2),[length(unif2) 1])];
z=zeros(length(unif), length(v.dirnum) );
[mb tm td th  ]=deal(zeros(size(z)));

for i=1:length(unif)
    %iv=find(strcmp(t(:,2),unif{i}));
    iv=find(strcmp(t(:,2),unif{i}) & strcmp(t(:,7),unifsub{i}) );
    animalno=t(iv,1);
    ix=find(ismember(v.dirnum,animalno));
    z(i,ix)=1;
    mb(i,ix)=cell2mat(t(iv,3));
    tm(i,ix)=cell2mat(t(iv,4));
    th(i,ix)=cell2mat(t(iv,5));
    td(i,ix)=cell2mat(t(iv,6));
end

ix_dwi=find(strcmp(unif,'dwi.mif'));
if ~isempty(ix_dwi)
    ts=repmat(th(ix_dwi,:),[size(th,1)  1])-th;
else
   ts= zeros([size(th,1)  1]);
end
ts(ts<0)=0;
%% ======[to struct]=========================================
% clear u

v.i1='___filesInfo__';
v.z=z;
v.mb=mb;
v.tm=tm;
v.td=td;
v.th=th;
v.ts=ts;
v.files=unif;
v.unifsub=unifsub;

%% ===============================================
v.opt2sort={...
    'exist file'    'v.z'
    'size (log10 of MB)'      'v.mb'
    'dT (min)'  'v.tm'
    'dT (hours)'   'v.td'
    'dT (days)'    'v.th'
    'dT since start (log10 of h)'    'v.ts'
    };


%% ===============================================

function v=check_abnormalSubDirs(v)
%% ======[check if unexpected SUBDIRS exist in 001/002--dir such as "dwipreproc..."]=========================================
file2checkBase={'rc_t2.nii' 'ANO_DTI.txt' 'ANO_DTI.nii' 'dwi*.nii' };
dirs   =v.dirnum;
dirsFP =v.dirsFP;

tbSubErr={};
v.fpdir={};
v.dirname  ={};
for i=1:length(dirsFP)
    [dirsub] = spm_select('FPList',dirsFP{i},'dir');
    dirsub=cellstr(dirsub);
    for j=1:length(dirsub)
        isexistBasefile=cell2mat(cellfun(@(a){[  length(dir(fullfile(dirsub{j},a))) ]},file2checkBase ));
        if any(isexistBasefile)==1
            v.fpdir(end+1,:)=dirsub(j);
            [~,animalName]= fileparts(dirsub{j});
            v.dirname(end+1,:)={animalName};
        end
    end
end