

%% <b> script to extract DTI-processed DTI-matrices (csv) +lut.txt from the HPC-cluster </b>
% <font color="red">- use this script when DTI-processing is finished  </font> to export files to another target-folder
% <font color="blue">- this script exports: the matrix-files (*.csv) and the lut-file (*.txt)  </font> 
% - for instance for statistical analysis
% - the animal-names will be preserved and stored in a "dat"-folder in the target-folder
% 
% Note: mandatory data structure of HPC-cluster: the "data"-folder contains
% numeric folders (a001,a002,..,axxx). Each of these folders contain one animal-folder
% with the DTI-processed data
%% ===============================================

clear; warning off;
%% ===============================================

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
% padatSource : HPC-storage-source, obtain the files from these source  (this is a "..\data\" -folder)
% paoutTarget : output path were files will be written to
% files2export: These files will be obtained from "padatSource"
 
%% ==============================================
% ___conventional-dat-structire ____
% padatSource='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\analysis_27nov20\dat'  ; % HPC-storage-source
% paoutTarget='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\Brains_charge2_July2021\statistic\DTI_round1' %output-directory

% ___HPC-data-structire ____
padatSource='X:\Daten-2\Imaging\Paul_DTI\Eranet\DTI_export4mrtrix\data'  ; % HPC-storage-source
paoutTarget='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\Brains_charge2_July2021\statistic\DTI' %output-directory

files2export={...         %these files will be exported
    'atlas_lut.txt'
    'connectome_di_sy.csv'
    '*.png'           %export also the screenShots
    };
%===================================================================================================

%% ========================================================================
%% #ka  ___ internal stuff ___                  
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
    % length(fdum)
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
mkdir(paoutTarget);
fprintf('..exporting DTI-files ..wait...');
for i=1:length(files)
    f1   =files{i};
    [pa name ext]=fileparts(f1);
    
    pas=fullfile(paoutTarget,'dat',animal{i});
    if exist(pas)~=7; 
        mkdir(pas);
    end
    
    f2=fullfile(pas,[ name ext ]);
    copyfile(f1,f2,'f');
end
fprintf('  Done.\n');
showinfo2('output-dir',paoutTarget); %show hyperlink in Matlab-cmd





