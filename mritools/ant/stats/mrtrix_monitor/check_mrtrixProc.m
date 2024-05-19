
function check_mrtrixProc(varargin)
%% check MRTRIX-process on HPC for one study
%%  find processed/running/nonprocessed datasets in mrtrix-pipeline

% check_mrtrixProc('rmdirs',[1])

p.dummi=1;

if nargin>0
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);  
end

% ===============================================
v=update_monitor();

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================
% pain:    main path containing the DTI-data (this folder contains the animals)
% outname: output-name string for HTML-file and HTML-image-folder
% paout:   output-folder (fullpath): this resulting folder will contain the HTML-file+images
% ===============================================
pastudy=v.pastudy; %fullfile(fileparts(fileparts(pwd)));
[~,studyname]=fileparts(pastudy);
pain=fullfile(pastudy, 'data');                       % % DTI-data-folder
outname=['DTIcheck_' studyname];                      % % HTML-name-string
paout=fullfile(pastudy,'checks');                   % % HTML-output-folder



% _STUDY-DATAPATH_ON_HPC-MACHINE (windows-path-style)
% datpath='X:\Imaging\Paul_DTI\ERANET_REVIS\data'
datpath=pain;%'X:\Imaging\Paul_DTI\ERANET_REVIS';
% datpath='X:\Imaging\Paul_DTI\AG_Wulczyn_R2'



%% ========= do not change ======================================

[~,maindir]=fileparts(datpath); %if "data"-dir does not exist in "datpath"
if strcmp(maindir,'data')==0
   datpath=fullfile(datpath,'data') ;
end

% get ALL EXISTING IDs ____
[dirs] = spm_select('List',datpath,'dir'); dirs=cellstr(dirs);
idall=str2num(char(regexprep(dirs,'\D',''))); % to numeric

% =======check if above files exist for each dataset ========================================
[dirsFP] = spm_select('FPList',datpath,'dir'); dirsFP=cellstr(dirsFP);

if isfield(p,'rmdirs')
    remove_abnormalSubDirs(p.rmdirs,dirs,dirsFP);
    return
end

%__FILES TO CHECK___: if those files exist processing of this dataSet is most likely performed
file2check={'fa.nii' 'rd.nii' 'ad.nii' 'adc.nii' 'connectome_di_sy.csv' ...
    '100m.tck' '100k.tck' 'smoothed_atlas.obj' };


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
%% ======[check if unexpected SUBDIRS exist in 001/002--dir such as "dwipreproc..."]=========================================
tbSubErr=check_abnormalSubDirs(dirs,dirsFP);

%% ===============================================


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
%%   display other subdirs
% ===============================================

if ~isempty(tbSubErr)
    cprintf('*[1 0 1]',[ 'PLEASE CHECK: these animals contain unexpected subDirs (that shouldn''t be there)'  '\n']);
    for i=1:size(tbSubErr,1)
        disp([tbSubErr{i,4} ' with abnormal dir: ["' tbSubErr{i,2} '"] ' tbSubErr{i,5} ])  
    end

    nums=str2num(char(regexprep(tbSubErr(:,1),'\D*','')));
    nums=unique(nums)';
    numvc=['[' regexprep(num2str(nums),'\s+',' ') ']'];
   disp(['<a href="matlab: check_mrtrixProc(''rmdirs'',''all'')">' ['remove all folders'] '</a>']);
end



function remove_abnormalSubDirs(animalNo,dirs,dirsFP)

%% ===============================================


tbSubErr=check_abnormalSubDirs(dirs,dirsFP);
if isempty(tbSubErr)
   cprintf('*[0 .5 0]',[ 'no unexpected subfolders found!! '  '\n']);
   return
end
nums=str2num(char(regexprep(tbSubErr(:,1),'\D*','')));

if isnumeric(animalNo)
    [idx ]=find(ismember(nums,animalNo));
elseif ischar(animalNo) && strcmp(animalNo,'all');
    idx=1:size(tbSubErr,1);
end

for i=1:length(idx)
    try
        disp( [ '..removing [' tbSubErr{i,2} ']' ' from ' tbSubErr{i,4} ]);
        rmdir(tbSubErr{i,3},'s');
    end
    if exist(tbSubErr{i,3})==7
            disp( [ '..failed removing [' tbSubErr{i,2} ']' ' from ' tbSubErr{i,4} ]);     
    end
        
end
if isempty(idx)
   disp('this animal has no unexpected subfolder') ;
else
    'done!';
end


%% ===============================================


function tbSubErr=check_abnormalSubDirs(dirs,dirsFP)
%% ======[check if unexpected SUBDIRS exist in 001/002--dir such as "dwipreproc..."]=========================================
file2checkBase={'rc_t2.nii' 'ANO_DTI.txt' 'ANO_DTI.nii' 'dwi*.nii' };
tbSubErr={};
for i=1:length(dirsFP)
    [dirsub] = spm_select('FPList',dirsFP{i},'dir');
    dirsub=cellstr(dirsub);
    for j=1:length(dirsub)
        isexistBasefile=cell2mat(cellfun(@(a){[  length(dir(fullfile(dirsub{j},a))) ]},file2checkBase ));
       if any(isexistBasefile)==0
           [~, subErrShort]=fileparts(dirsub{j});
        tbSubErr(end+1,:)=   {dirs{i}  subErrShort dirsub{j} ...
            ['<a href="matlab: explorer(''' dirsFP{i} ''');">' dirs{i} '</a>'] ....
            ['<a href="matlab: try; rmdir(''' dirsub{j} ''',''s'');end">' ['remove this folder'] '</a>']
            };
       end
    end
end