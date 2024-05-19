

function export2BackupDIR(varargin) 


p.paout='';
p.dummi=0;
if ~isempty(varargin)
   pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end

%% ===============================================
v=update_monitor();
pastudy       = v.pastudy ;%fullfile(fileparts(fileparts(pwd)));
pain          = fullfile(pastudy, 'data');                       
[~,studyname] = fileparts(pastudy);
paout    =p.paout;
%% ===============================================

if exist('paout')==0
    [~,studyName]=fileparts(v.pastudy)
    paout=fullfile(v.backupDir,studyName);
    
    if exist(paout)~=7
        [t,sts] = spm_select(1,'dir','select orig. ANTx-StudyDIR','',pwd);
        if isempty(t); return;        end
        paout=t;
    end
end
%% =================[ change this ]==============================
% p.force2overwrite=0;


pain=pastudy; %'X:\Imaging\Paul_DTI\AG_aswendt_koeln'             %main path STUDY from HPC without "data"-subdir
%% ===============================================


%% ===============================================
% [~,study]=fileparts(pain);
paoutstudy=paout;



%% get aditional files and dirs to copy
[fisin] = spm_select('List',pain); fisin=cellstr(fisin);
[dirsin] = spm_select('List',pain,'dir'); dirsin=cellstr(dirsin);
dirsin(strcmp(dirsin,'data'))=[];

% obtain animal-paths
padat=fullfile(pain,'data');
[pamatrix] = spm_select('List',padat,'dir'); pamatrix=cellstr(pamatrix);

animalfp={};
for i=1:length(pamatrix)
    pamatrixfp=fullfile(padat, pamatrix{i});
    [sub] = spm_select('FPList',pamatrixfp,'dir'); sub=cellstr(sub);
    animalfp=[animalfp; sub];
end

% ==============================================
%%   check if screenshots where created ..otherwise abort copying data
% ===============================================
% fis={ 'capture_fod0000.png'  'capture_tck0000.png' 'capture_voxels0000.png'     };
% isscreenshot=[];
% for i=1:length(animalfp)
%     fifp=stradd(fis,[ fullfile(animalfp{i},'mrtrix') filesep   ],1);
%     isscreenshot(i,:)=existn(fifp);
% end
% 
% pashort=strrep(animalfp,pain,'');
% t=cell2table([pashort num2cell(isscreenshot)],'VariableNames',['charge1' regexprep(fis(:)',{'\.' ''},'') ]);
% % screenshotstatus=unique(isscreenshot(:)==2);
% screenshotstatus=unique(sum(isscreenshot,2)>4);
% if length(screenshotstatus)>1 | ~isempty(find(any([screenshotstatus],1)==0))
%     disp('screenshots were not made...abort copying data!') ;
%     disp('type 2t", to see table');
%     return
% end


% ==============================================
%%   copy other files and folders
% ===============================================


mkdir(paoutstudy);

% [1] copy files
if ~isempty(char(fisin))
    for i=1:length(fisin)
        fin  =fullfile(pain,        fisin{i});
        fout =fullfile(paoutstudy,  fisin{i});
        copyfile(fin,fout,'f');
    end
end

% [1] copy other dirs
if ~isempty(char(dirsin))
    for i=1:length(dirsin)
        din  =fullfile(pain,        dirsin{i});
        dout =fullfile(paoutstudy,  dirsin{i});
        copyfile(din,dout,'f');
    end
end



% ==============================================
%%   copy animal-files
% ===============================================
files2copy={ 'capture_fod0000.png'
    'capture_tck0000.png'
    'capture_voxels0000.png'
    'connectome_di_sy.csv'
    'atlas_lut.txt'
    };
files2copyMrtrixdir=...
    {'densMap_10k_SS.nii'
    '.*.png'
    '10k_SS.tck'
    '.*.txt'
    '100k.tck'
    'rc_t2.mif'};

mrtrix_copyall=[1]; %[1]copy all, exceppt of 'excludeFiles'
excludeFiles={'100m.tck'
               'noise.mif'};

for i=1:length(animalfp)
    
    [~,animal]=fileparts(animalfp{i});
    cprintf('*[1 0 1]',[ 'copying to BACKUP-drive [' num2str(i) '/' num2str(length(animalfp))  '] ' animal  '\n']);
    
    outdir=fullfile(  paoutstudy   ,'dat', animal);
    mkdir(outdir);
    [filesIn] = spm_select('List',animalfp{i}); filesIn=cellstr(filesIn);
    
    for j=1:length(filesIn)
        fi_in=fullfile(animalfp{i},filesIn{j}  );
        fi_out=fullfile(outdir,filesIn{j}  );
        if p.force2overwrite==1 || exist(fi_out)==0
            copyfile(fi_in,fi_out,'f');
        end
    end
    %---copy mrtrix files
    for j=1:length(files2copy)
        fi_in=fullfile(animalfp{i},'mrtrix', files2copy{j});
        fi_out=fullfile(outdir             , files2copy{j});
        if p.force2overwrite==1 || exist(fi_out)==0
            copyfile(fi_in,fi_out,'f');
        end
    end
    %  --------------copy TVB-"gz"-file
    pamatrix=fullfile(animalfp{i},'mrtrix');
    [files] = spm_select('List',pamatrix,'.*.gz$');
    if ~isempty(files)
        files=cellstr(files);
        for j=1:length(files)
            f1=fullfile(pamatrix ,files{j});
            f2=fullfile(outdir   ,files{j});
            if p.force2overwrite==1 || exist(f2)==0
                copyfile(f1,f2,'f');
            end
        end
    end
    
    %%  --------------copy some mrtrix-files in backup-mrtrix-folder
    pamatrix=fullfile(animalfp{i},'mrtrix');
    pamatrixout=fullfile(outdir,'mrtrix');
    if exist(pamatrixout)~=7; mkdir(pamatrixout); end
    
    if mrtrix_copyall==1
        files2copyMrtrixdir= spm_select('List',pamatrix);
        files2copyMrtrixdir=cellstr(files2copyMrtrixdir);
        inotcopy=regexp(files2copyMrtrixdir,['^' strjoin(excludeFiles,'$|^') '$']);
        files2copyMrtrixdir(find(cellfun(@isempty,inotcopy)==0))=[];
    end
    
    for j=1:length(files2copyMrtrixdir)
        fis=files2copyMrtrixdir{j};
        if strfind(fis,'*')
            file=spm_select('List',pamatrix,fis);
            file=cellstr(file);
        else
           file=cellstr(fis) ;
        end
        
        f1=stradd(file       ,[pamatrix    filesep],1);
        f2=stradd(file       ,[pamatrixout filesep],1);
        for ii=1:length(f1)
           try
               if p.force2overwrite==1 || exist(f2{ii})==0
                   copyfile(f1{ii},f2{ii},'f') ;
               end
           end
        end
    end
    
    %% ===============================================
    
end

showinfo2(['BACKUP-DIR'],paoutstudy);
disp('DONE!');









