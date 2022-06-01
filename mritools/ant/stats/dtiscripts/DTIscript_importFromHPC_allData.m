%% <b> script to copy all necessary data from HPC to target directory </b>
% <font color="red">- use this script when DTI-processing is finished  </font> to copy files to another target-folder
% <font color="blue">- this script copies the following files from HPC:  
%            - connectome-file: 'connectome_di_sy.csv'
%            - lutfile: 'atlas_lut.txt'
%            - QA-screenshots (*.png)
%            - DWI-maps: 'ad.nii','adc.nii','fa.nii','rd.nii'
%            .. to target-directory  </font> 
% - use this script to import the data for statistical analysis
% - the animal-names will be preserved and stored in the "dat"-folder of the target-folder
% - in this way we can import the data to the animals of an existinx ANTx-study
% <font color="fuchsia">
% Note: mandatory data structure of HPC-cluster: the "data"-folder contains
% numeric folders (a001,a002,..,axxx). Each of these folders contain one animal-folder
% with the DTI-processed data </font>
%% ================================================================================================

clear; warning off;

%% =========================================================================================================================
%% variable parameter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
% padatSource : HPC-storage-source, obtain the files from these source  (this is the "..\data\" -folder)
%               -example: 'X:\Daten-2\Imaging\Paul_DTI\2021_Exp7_Exp8_Reinfarkte_jung\data'
% paoutTarget : output path were files will be copied to 
%               -with or without "dat"-dir, if "dat"-dir is missing it will be appended
%               -example: 'H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI\dat'
%               -this is identical to 'H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI' 
% files2export: These files will be copied from "padatSource" and importet to 'paoutTarget'
%% =========================================================================================================================
padatSource='X:\Daten-2\Imaging\Paul_DTI\2021_Exp7_Exp8_Reinfarkte_jung\data'     ;%SOURCE:  HPC-storage
paoutTarget='H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI\dat'  ;%TARGET: output-directory for dataImport

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
    cprintf('*[0 .4 0]',['importing:[' num2str(i) '/' num2str(length(files)) ']' '[ANIMAL]' animal{i} ';[FILE]' [ name ext ] '\n']);

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
    copyfile(f1,f2,'f');
end
showinfo2('output-dir',paoutTarget); %show hyperlink in Matlab-cmd
cprintf('*[1 0 1]',['DONE!(ET=' sprintf('%2.2fmin',toc(atime)/60)  ') \n']);









