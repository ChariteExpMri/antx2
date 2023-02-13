

%% script to DELETE MRTRIX-created files from HPC-dataSets
% can be used to re-evaluate datasets, basically all files/folders
% created by MRtrix will be deleted from the respective dataSets
%% CAUTION...input files will be keept but MRtrix related files are deleted from the dpecified dataSets!

% ===============================================

clear; clc

% _STUDY-DATAPATH_ON_HPC-MACHINE (windows-path-style)
% datpath='X:\Imaging\Paul_DTI\ERANET_REVIS\data'
datpath='X:\Imaging\Paul_DTI\ERANET_REVIS';

% ___dataSets to clear MRtrix-created files/folders
dataSets=[12,13,19,20,21,22,23];
% dataSets=12;


%% ========= do not change ======================================

[~,maindir]=fileparts(datpath); %if "data"-dir does not exist in "datpath"
if strcmp(maindir,'data')==0
   datpath=fullfile(datpath,'data') ;
end

% get ALL EXISTING IDs ____
[dirs] = spm_select('List',datpath,'dir'); idall=cellstr(dirs);
prefix=regexprep(idall{1},'\d','');

delfiles={'fa.nii' 'rd.nii' 'ad.nii' 'adc.nii'};

cprintf('*[1 0 1]',[ '__DELETING MRTRIX-related FILES' '\n']);

for i=1:length(dataSets)
    iddir=[prefix pnum(dataSets(i),3)];
    mdir=fullfile(datpath,iddir);
    isDEL=0;
    
    for j=1:length(delfiles)
        [fi] = spm_select('FPListRec',mdir,delfiles{j});
        if ~isempty(fi); 
            fi=cellstr(fi);
             deletem(fi);
             isDEL=1;
        end
    end
   [mrtrixdir] = spm_select('FPListRec',mdir,'dir','mrtrix');
   if ~isempty(mrtrixdir)
       rmdir(mrtrixdir,'s');
       isDEL=1;
   end
   
   %-----disp output -----
   [fichk] = spm_select('FPListRec',mdir,'ANO_DTI.txt');
   indir=fileparts(fichk);
   if isDEL==1;
       cprintf('[1 0 1]',[ '[' iddir ']' ' MRTRIX-files deleted ...[PATH]: '  strrep(mdir,filesep,[filesep filesep])  '\n']);
       showinfo2([ '    ...' ] ,indir);
   else
       cprintf('[0 .5 0]',[ '[' iddir ']' 'no  MRTRIX-files found ...[PATH]: '  strrep(mdir,filesep,[filesep filesep])  '\n']);
       showinfo2([ '    ...' ] ,indir);
   end
end









