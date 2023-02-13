

%% check MRTRIX-process on HPC for one study
%%  find processed/running/nonprocessed datasets in mrtrix-pipeline

% ===============================================
clear; clc

% _STUDY-DATAPATH_ON_HPC-MACHINE (windows-path-style)
% datpath='X:\Imaging\Paul_DTI\ERANET_REVIS\data'
datpath='X:\Imaging\Paul_DTI\ERANET_REVIS';
% datpath='X:\Imaging\Paul_DTI\AG_Wulczyn_R2'



%% ========= do not change ======================================
%__FILES TO CHECK___: if those files exist processing of this dataSet is most likely performed
file2check={'fa.nii' 'rd.nii' 'ad.nii' 'adc.nii' 'connectome_di_sy.csv' ...
    '100m.tck' '100k.tck' 'smoothed_atlas.obj' };



[~,maindir]=fileparts(datpath); %if "data"-dir does not exist in "datpath"
if strcmp(maindir,'data')==0
   datpath=fullfile(datpath,'data') ;
end

% get ALL EXISTING IDs ____
[dirs] = spm_select('List',datpath,'dir'); 
dirs=cellstr(dirs);
idall=str2num(char(regexprep(dirs,'\D',''))); % to numeric

% =======check if above files exist for each dataset ========================================
[dirsFP] = spm_select('FPList',datpath,'dir'); dirsFP=cellstr(dirsFP);

t=zeros(length(dirsFP), length(file2check)+1);
for i=1:length(dirsFP)
    for j=1:length(file2check)
        [fi] = spm_select('FPListRec',dirsFP{i},file2check{j});
        if ~isempty(fi)
            t(i,j)=1;
        end
    end
    [mrtrixdir] = spm_select('FPListRec',dirsFP{i},'dir','mrtrix');
    if ~isempty(mrtrixdir)
         t(i,j+1)=1;
    end
end

ids=idall(find(sum(t,2)==size(t,2)));

% ===============================================
idprocessed   =intersect(ids,idall);
idNotprocessed=setdiff(idall,ids);
idINprocess   =idall(find(sum(t,2)~=size(t,2) & t(:,end)==1));


str_processed   =regexprep(num2str((idprocessed(:)')),'\s+',',');
str_NOTprocessed=regexprep(num2str((idNotprocessed(:)')),'\s+',',');
str_InProcess   =regexprep(num2str((idINprocess(:)')),'\s+',',');

if isempty(str_processed)   ; str_processed   ='-';end
if isempty(str_NOTprocessed); str_NOTprocessed='-';end
if isempty(str_InProcess)   ; str_InProcess   ='-';end
% ===============================================
cprintf('*[1 0 1]',[ 'DIR: ' strrep(datpath,filesep,[filesep filesep])  '\n']);
disp(['#dataSets     : '  num2str(length(idall)) ]);
disp(['#finished     : '  num2str(length(idprocessed)) ]);
disp(['#in process   : '  num2str(length(idINprocess)) ]);
disp(['#NOT processed: '  num2str(length(idNotprocessed)) ]);
disp(['_____IDs_______________________________']);
disp([' #finished IDs    : ' str_processed ]);
disp([' #in-process IDs  : ' str_InProcess ]);
disp([' #not finished IDs: ' str_NOTprocessed ]);

if isempty(idNotprocessed)
    cprintf('*[0 0.5 0]',[ 'All dataSets processed!! '  '\n']);
else
    cprintf('*[1 0 0]',[ 'some dataSets not processed yet!! '  '\n']);
end

%% ====check ... hyperlink===========================================
prefix=regexprep(dirs{1},'\d','');
idc={idprocessed idINprocess idNotprocessed};
labs={...
    'processed    : '
    'in-Process   : ' 
    'not Processed: '};
for k=1:length(idc)
    idx=idc{k};
    ms={};
    for i=1:length(idx)
        tdir=fullfile(datpath, [prefix pnum(idx(i),3)]);
        [fichk] = spm_select('FPListRec',tdir,'ANO_DTI.txt');
        if ~isempty(fichk)
            fichk=fileparts(fichk);
            ms{end+1,1}=['<a href="matlab: explorer(''' fichk ''');">' num2str(idx(i)) '</a>'];
        end
    end
    if ~isempty(ms)
        disp([labs{k} strjoin(ms,',')]);
    end
    %disp(['<a href="matlab: explorer(''' fichk ''');">' num2str(idx(i)) '</a>'])
end

% disp([ ' or <a href="matlab: system(''TASKKILL /F /IM explorer.exe'');">' 'CLOSE open folders ' '</a>' ' '  ]);
% 
% disp([ ' or <a href="matlab: !TASKKILL /F /IM explorer.exe;start explorer '  ''');">' 'CLOSE open folders ' '</a>' ' '  ]);
% 
% 
% %  try; evalc('!TASKKILL /F /IM explorer.exe'); end
% %     try; evalc('!start explorer '); end
% ==============================================
%%   
% ===============================================






