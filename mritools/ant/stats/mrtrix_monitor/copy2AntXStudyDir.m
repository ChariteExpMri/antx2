function copy2AntXStudyDir(varargin)

p.paout='';
p.dummi=0;
if ~isempty(varargin)
   pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end
%% ===============================================
v=update_monitor();
paout=p.paout;

%% =========================================================================================================================


pastudy       = v.pastudy;%fullfile(fileparts(fileparts(pwd)));
pain          = fullfile(pastudy, 'data');                       
[~,studyname] = fileparts(pastudy);
%% ===============================================

if isempty(paout)
    paout=v.sourceDir;
    [pas,sub]=fileparts(paout);
    if strcmp(sub,'dat'); paout=pas; end
    
    if exist(paout)~=7
        [t,sts] = spm_select(1,'dir','select orig. ANTx-StudyDIR','',pwd);
        if isempty(t); return;        end
        paout=t;
    end
end
%% =====[check paout]==========================================
[pax fix]=fileparts(paout);
if strcmp(fix,'dat')==0
    paout=fullfile(pax,fix,'dat');
end

%% ===============================================

padatSource=pain;%'X:\Daten-2\Imaging\Paul_DTI\2021_Exp7_Exp8_Reinfarkte_jung\data'     ;%SOURCE:  HPC-storage
paoutTarget=paout;%'H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI\dat'  ;%TARGET: output-directory for dataImport

files2export={...    %these files will be imported
    'atlas_lut.txt'
    'connectome_di_sy.csv'
    '*.png'           %import also the screenShots
    'ad.nii'         % import DWI-maps
    'adc.nii'
    'fa.nii'
    'rd.nii'
    };
%===================================================================================================

%% ========================================================================
%% #ka  ___internal stuff___                  
%% ========================================================================

% ==============================================
%%   copy content of checksfolder
% ===============================================

checks_dir=fullfile(pastudy,'checks');
if exist(checks_dir)==7
    checksTarget_dir = fullfile( fileparts(paoutTarget),'checks');
    if exist(checksTarget_dir)~=7;
        mkdir(checksTarget_dir);
    end
    [fis_ck,dir_ck] = spm_select('FPList',checks_dir);
    fis_ck=cellstr(fis_ck);
    copy_ck=[fis_ck; cellstr(dir_ck)  ] ;
    copy_ck(cellfun(@isempty,copy_ck))=[];
    if ~isempty(char(copy_ck))
        for i=1:length(copy_ck)
            f1=copy_ck{i};
            [~, name2,ext2]=fileparts(f1);
            f2=fullfile(checksTarget_dir,[name2 ext2 ]);
            copyfile(f1,f2,'f');
        end
    end
    html_makeindexfile(checksTarget_dir,'index.html','checks','verbose',0); 
end



% ==============================================
%%   
% ===============================================



% ==============================================
%%   obtain files
% ===============================================
files={};
for i=1:length(files2export)
    filt=['^'  files2export{i} '$'];
    [fdum] = spm_select('FPListRec',padatSource,filt);
    fdum=cellstr(fdum);
    files=[files; fdum];
end

% ==============================================
%%  obtain animal-name
% ===============================================
if ~isempty(strfind(files{1},[filesep 'dat' filesep]))  %conventional dat-structure
    v=regexprep(files,['.*dat' [filesep filesep] ],'');
    animal=regexprep(v,[filesep filesep '.*'],'');
else    
    v=regexprep(files,['.*data' [filesep filesep] ],'');  %HPC-data-structure
    isep=cellfun(@(a){[min(strfind(a,filesep)) ]},v);
    v=cellfun(@(a,b){[a(b+1:end) ]},v,isep);
    animal=regexprep(v,[filesep filesep '.*'],'');
end
% ==============================================
%%   copy files
% ===============================================
if exist(paoutTarget)~=7;  % make main-target-dir
    mkdir(paoutTarget);
end
cprintf('*[1 0 1]','..importing DTI-files ..wait...\n');   %message
atime=tic;   %obtain time
for i=1:length(files)
    f1   =files{i};
    [pa name ext]=fileparts(f1);
    %cprintf('*[0 .4 0]',['importing to ANTxStudy:[' num2str(i) '/' num2str(length(files)) ']' '[ANIMAL]' animal{i} ';[FILE]' [ name ext ] '\n']);

    [~,datfolder ]=fileparts(paoutTarget);           %check if target-folder is dat-folder
    if strcmp(datfolder,'dat')==1
        pas=fullfile(paoutTarget,animal{i});
    else
        pas=fullfile(paoutTarget,'dat',animal{i});   %add 'dat'-dir if not specified in "paoutTarget" 
    end
    if exist(pas)~=7;    % make animal-dir
        mkdir(pas);
    end
    f2=fullfile(pas,[ name ext ]);
    %disp(f1);
    %disp(f2);
    if p.force2overwrite==1 || exist(f2)==0
        % cprintf('*[0 .4 0]',['importing to ANTxStudy:[' num2str(i) '/' num2str(length(files)) ']' '[ANIMAL]' animal{i} ';[FILE]' [ name ext ] '\n']);
        copyfile(f1,f2,'f');
    else
        % cprintf(repmat(0.4,[1 3]),['importing to ANTxStudy, file already exist:[' num2str(i) '/' num2str(length(files)) ']' '[ANIMAL]' animal{i} ';[FILE]' [ name ext ] '\n']);
    end
end
showinfo2(['STUDY-DIR'],paoutTarget);
cprintf('*[1 0 1]',['DONE!(ET=' sprintf('%2.2fmin',toc(atime)/60)  ') \n']);








