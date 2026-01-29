function snips_input1

snips
return


%% #################################################
% cmd
% open Antx-GUI and load project
ant;
antcb('load',  fullfile(pwd,'proj.m'  ))  ;

% close Antx-GUI
antcb('close')

% close Antx-GUI & exit from snips-GUI
snips('close');
antcb('close'); exit

% update Antx-GUI from github
updateantx(2);
%% #################################################
% cmd
% set specifc parameters of projectfile
%EXAMPLES: 
%---------------
%   [1]: change name of the ANTx-project
     antcb('set','project','project_123');
     
%   [2]: change preorientiation ('orienttype'-parameter)
     antcb('set','wa.orientType',12);
     
%   [3]: change skullstripping method
     antcb('set','usePriorskullstrip',6);
     
%   [4]: change preorientiation anf skullstripping method
     antcb('set','wa.orientType',1,'wa.usePriorskullstrip',7);


%% #################################################
% cmd
% open Antx-history

uhelp(anth) ;
%% #################################################
% cmd
% costumize matlab-session
antcb('cwcol',[1 .94 .87]); 
antcb('cwname','paul works here');

%% #################################################
% file-conversion
% convert an IMG/HDR file to NIfTI format, and replace the header of a mask image
% with the header from the corresponding structural image

pa=pwd
fi1=fullfile(pa,'20250313MO_SCI_Ko01_sag.img');
fi2=fullfile(pa,'20250313MO_SCI_Ko01_sag_masklesion.img');
[ha a]=rgetnii(fi1);
[hb b]=rgetnii(fi2);

fo1=fullfile(pa,'t2.nii');
fo2=fullfile(pa,'mask.nii');
rsavenii(fo1, ha, a, 64);  %safe 'fi1' as NIFTI
rsavenii(fo2, ha, b, 64);  %safe 'fi2' as NIFTI & replace header, using [ha] from 'fi1'

%% #################################################
% file-conversion
% convert all obj-files file from folder 'path_files' and it's source (img/hdr) to NIFTI
path_files='H:\Daten-2\Imaging\AG_Eickholt_SCI\segmentation'
suffix='_mask';
cd(path_files);
[t,sts] = spm_select(inf,'any','Select analyze-files to convert to NIFTI ',[],path_files,...
    '.*.obj');
t=cellstr(t);
if isempty(t); return; end
for i=1:size(t,1)
    objfile   = t{i};
    [pam name ext]=fileparts(objfile);
    [ho o]    = obj2nifti(objfile);
    imgfile   = fullfile(pam, [name '.img' ]);
    [ha a]    = rgetnii(imgfile);
    a         = flipud(a);
    Fo1       = fullfile(pam, [name '.nii' ]);
    rsavenii(Fo1, ha,a, 16);
    %showinfo2([ 'file' ] ,Fo1);
    Fo2       = fullfile(pam, [name suffix '.nii' ]);
    o2        = flipdim(flipdim(o,1),2);
    rsavenii(Fo2, ha,o2, 16);
    showinfo2([ 'file' ] ,Fo1,Fo2,13);
end
%% #################################################
% pipeline
% from Bruker-import to standardspace

%% ==============================================
%% 1.  make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj2.m" IS CREATED USING A VOXELSIZE
%%     OF [.07 .07 .07] mm, and the ANIMAL-TEMPLATE "mouse_Allen2017HikishimaLR" is used, with species 'mouse'
% ===============================================
makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[.07 .07 .07],...
    'wa_refpath','D:\MATLAB\anttemplates\mouse_Allen2017HikishimaLR',...
    'wa_species','mouse')

antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"

%% ==============================================
%%   2. IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);
 
% FILTER and DISPLAY a list of Bruker files where the protocol name contains 'T2_ax_mousebrain'
protocol='T2_ax_mousebrain'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',protocol});
 
% IMPORT Bruker files where the protocol name contains 'T2_ax_mousebrain'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol',protocol},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);


%% ========================================================================================
%%   3. copy and rename structural image as "t2.nii"
%%      "t2.nii" will be used for transformation to standard space
%% =========================================================================================
antcb('selectdirs','all');   % select all animal-folders
xrename(0,'2_1_T2_ax_mousebrain_3.nii','t2.nii',':');% copy file and name it 't2.nii'

%% ========================================================================================
%%   4. get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal

%% ========================================================================================
%%   5. change 'orientType' variable in project-file
%%      When inspecting the HTML-file best orientation is [1] which is set in 'orientType' variable 
%%      in project-file, projectfile is saved and reloaded
%% ========================================================================================
global an
an.wa.orientType=1   ;% set orientType to [1]
antcb('saveproject') ;% save projfile
antcb('reload')      ;% reload projfile
clear an

%% ========================================================================================================================
%%   6. calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1);

 
%% ================================================================
%%  7. transform images from native to standard-space (SS)
%% =================================================================
 
antcb('selectdirs','all'); %select all animals
% transform bias-corrected t2.nii ('mt2.nii') to SS using B-spline interpolation
doelastix(1, [], 'mt2.nii'  ,3 ,'local' );
 
% transform GrayMatter and WhiteMatter Imaget to SS using linear interpolation
doelastix(1, [], {'c1t2.nii' 'c2t2.nii'}  ,1 ,'local' ); 
 
%% ================================================================
%%  8. transform images from standard-space to native-space  (NS)
%% =================================================================
% transform brain-hemisphere mask from standard-space to native-space using NN-interpolation
doelastix(-1, [], {'AVGThemi.nii'}  ,0 ,'local' );
 
%% ====================================================================================
%%  9. region-based image readout from image in standard-space
%%     get region-based paramers of GrayMatter-image in SS using AllenBrain atlas
%% =====================================================================================
z=[];                                                                                                                                                                              
z.files        = { 'x_c1t2.nii' };            % % files used for calculation                                                                                                                
z.fileNameOut  = 'paras_grayMatter_SS';       % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);  
 
%% ====================================================================================
%%  10. region-based image readout from image in native-space (NS)
%%      get region-based paramers of GrayMatter-image in NS using AllenBrain atlas
%% =====================================================================================
z=[];
z.files        = {'c1t2.nii'};  % files used for calculation     
z.space        =  'native'  ;% use images from "standard","native" or "other" space 
z.hemisphere   =  'both';   % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
z.fileNameOut  = 'paras_grayMatter_NS';            % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);
 
 
 
%% #################################################
% pipeline
% QSM-pipeline
 
cf;clear;
addpath('D:\MATLAB\qsm_tools'); %add path of QSM-wrapper functions
 
%% ===============================================
%% parameter
%% ===============================================
v=struct();
v.pastudy      ='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERC_Syn_2025\GEMI_pilot_2025\qsm_ana'; %path of study
v.paraw        =fullfile(v.pastudy,'raw'); % path: Bruker-rawdata
v.protocol     ='MPM_3D_0p15'    ;         % substring contained in 'protocoll' in Bruker-rawdata to use for QSM
v.qsmfilefilter={'pd'  'mt' 't1'};         % QSM: use these filter to select the input QSM-images
v.qsmnewname   ={'PD'  'MT' 'T1'};         % QSM: new namestring as part of the new files)
%                                          %   note that length and order of "qsmfilefilter" and "qsmnewname" must match
v.useqsmfilefilter=1       ;% if [1]: the string in qsmfilefilter is used for 
%                           % selecting the coorect file
%                           %if [0]: files are selected based on the listorder of 
%                           % the files, accordingly the order of the strings in "qsmfilefilter" 
%                           % must match order of file-listing (REASON: in one study somebody forgot
%                           % to change the protocollnames for 'pd'  'mt' 't1' ...all names were identicall)
v.template_refpath   ='D:\MATLAB\anttemplates\mouse_Allen2017HikishimaLR'; %path of used animal-template
v.template_specis   ='mouse';               % species
v.template_voxsize  =[.07 .07 .07];         % target resolution in standardspace (ideally same as in template)
 
v.SEPIApath    ='D:\MATLAB\sepia-1.2.2.6'; % path of sepia toolbox
v.TE2keep      =[2:8];                     % TE's tto keep (1st one might bee noisy)
% ===============================================
cprintf('*[0 .5 0]',['PARAMETER' '\n']);
disp(v);
 
%% ==============================================
%%  [0] make project  
%% ===============================================
makeproject('projectname',fullfile(v.pastudy,'proj.m'), 'voxsize',v.template_voxsize,...
    'wa_refpath',v.template_refpath,...
    'wa_species',v.template_specis)
antcb('load',fullfile(v.pastudy,'proj.m')); % LOAD A PROJECT-FILE "proj.m"
 
%% ==============================================
%%  [1] IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(v.paraw,0,[],[],'gui',0,'show',1);
 
% FILTER and DISPLAY a list of Bruker files where the protocol name contains 'T2_ax_mousebrain'
% % % protocol='MPM_3D_0p15'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',v.protocol});
 
% IMPORT Bruker files where the protocol name contains 'T2_ax_mousebrain'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol',v.protocol},...
    'paout',fullfile(v.pastudy,'dat'),'ExpNo_File',1,'PrcNo_File',1);
 
%% check if filenumber is consistent
antcb('selectdirs','all');
numfiles=antcb('countfiles', v.protocol);
pat=(numfiles)/(length(v.qsmfilefilter)*2);
numfiles_str=strjoin(cellfun(@(a){[ num2str(a) ]} , num2cell(numfiles)),',');
disp(['number of QSM-files found: ' numfiles_str])
if length(unique(pat))~=1
   error('some animals have different numbers of QSM-files..check') ;
end
if unique(pat)~=round(unique(pat))
   error('some files are missing..presumably the phase-image') ; 
end
 
% ==============================================
%% [2]  work on some of the animals
% ===============================================
animal_dropped=[];  % exclude animal (by number) here
animal_ok     =setdiff([1:length(antcb('getallsubjects'))],  animal_dropped);
% animal_ok   =[4  7 8]
% antcb('selectdirs',[1:3 5 6 9 10 ])
antcb('selectdirs',animal_ok);
mdirs=antcb('getsubjects');

%% ==============================================
%%   [3a] rename files 
%% ===============================================
newnames={...
    'qsm_PD_mag.nii'
    'qsm_PD_pha.nii'
    'qsm_T1_mag.nii'
    'qsm_T1_pha.nii'
    'qsm_MT_mag.nii'
    'qsm_MT_pha.nii'
    };
for i=1:length(mdirs)
    fi=spm_select('List',mdirs{i},[v.protocol]);
    fi=cellstr(fi);
    [~,animal]=fileparts(mdirs{i});
    cprintf('*[0 .5 0]',['renaming files: [' pnum(i,3) '] '  animal '\n']);
    if v.useqsmfilefilter==0
        if length(fi)==6
            F1=stradd(fi       , [mdirs{i} filesep],1);
            F2=stradd(newnames , [mdirs{i} filesep],1);
            copyfilem(F1,F2);
            showinfo2(['copied files'],mdirs{i});
        end
    elseif v.useqsmfilefilter==1
        for j=1:length(v.qsmfilefilter)
            fi2=fi(regexpi2(fi,v.qsmfilefilter{j}));
            imgNum=1;  %magnitude-image
            F1=fullfile(mdirs{i}, fi2{imgNum}                          ); %MAG-image-in
            F2=fullfile(mdirs{i}, [ 'qsm_' v.qsmnewname{j} '_mag.nii'  ]); %MAG-image-out
            imgNum=2;  %phase-image
            F3=fullfile(mdirs{i}, fi2{imgNum}                         ); %MAG-image-in
            F4=fullfile(mdirs{i}, [ 'qsm_' v.qsmnewname{j} '_pha.nii'  ]); %MAG-image-out
            copyfile(F1,F2,'f');
            copyfile(F3,F4,'f'); 
        end
    end
end
%% ==============================================
%%   [3b] replace the header of the 
%%      phasemaps with the magnitude-header
%% ===============================================
  cprintf('*[0 .5 0]',['replace phase-HDR' '\n']);
for i=1:length(v.qsmnewname)
    z=[];
    z.files =  {...
        ['qsm_' v.qsmnewname{i} '_pha.nii']     ['qsm_' v.qsmnewname{i} '_pha.nii']     'rHDR:'
        ['qsm_' v.qsmnewname{i} '_mag.nii']     ''                  'ref'  };
   xrename(0,z.files(:,1),z.files(:,2),z.files(:,3));
    %disp(z.files);
    
end
 
%% ==============================================
%%   [4] extract first magnitude-vol and use as t2.nii for registration
%% ===============================================
% % % % % antcb('selectdirs','all');
xrename(0,'qsm_PD_mag.nii','t2.nii','1');
 
%% ========================================================================================
%%  [5] get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%%      This step has to be done only for one animal per study, assumed that oriention is identical for all animals
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal
 
%% ========================================================================================
%%  [6] change 'orientType' variable in project-file
%%      When inspecting the HTML-file best orientation is [12] which is set in 'orientType' variable 
%%      in project-file, projectfile is saved and reloaded
%% ========================================================================================
global an
an.wa.orientType=11        ;% set preorientation: [12]: florian [11] berlin
an.wa.usePriorskullstrip=7 ;% skullstripping method
antcb('saveproject')       ;% save projfile
antcb('reload')            ;% reload projfile
clear an
 
%% ========================================================================================================================
%%  [7] calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
% antcb('selectdirs','all');   % select all animal-folders
antcb('selectdirs',animal_ok);
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1);
 
%% ================================================================
%%  [8] transform mask-image from standard-space to native-space  (NS)
%% =================================================================
% transform brain mask from standard-space to native-space using NN-interpolation
doelastix(-1, [], {'AVGTmask.nii'}  ,0 ,'local' );
 
%% ==============================================
%%  [9] make QSM header
%% ===============================================
antcb('selectdirs',animal_ok);
mdirs  =antcb('getsubjects');
for j=1:length(mdirs)
    pam   =mdirs{j};
    [~,animal]=fileparts(pam);
    cprintf('*[0 .5 0]',['make header: [' pnum(i,3) '] '  animal '\n']);
    flt='^qsm_.*_mag.nii'; %only magnitudue
    fis= spm_select('FPList',pam,flt); fis=cellstr(fis);
    for i=1:length(fis)
        nifti     =fis{i};
        fo1=qsm_makeheader_v3(nifti,v.paraw,2 );
    end
end
 
%% ==============================================
%% [10]  run QSM
%% ===============================================
antcb('selectdirs',animal_ok);
mdirs=antcb('getsubjects');
 
s.SEPIApath=v.SEPIApath;%'D:\MATLAB\sepia-1.2.2.6';
s.TE2keep  =v.TE2keep;%[2:8];
for j=1:length(mdirs)
    pam   =mdirs{j};
    [~,animal]=fileparts(pam);
    cprintf('*[0 .5 0]',['running QSM: [' pnum(j,3) '] '  animal '\n']);
    flt='^qsm_.*_header.*.mat';
    hdrfiles= spm_select('List',pam,flt); hdrfiles=cellstr(hdrfiles);
    for i=1:length(v.qsmnewname)
        ix=regexpi2(hdrfiles,v.qsmnewname{i});
        hdrfile=fullfile(   pam,  hdrfiles{ix} );
        if exist(hdrfile)==2
            s.HDRfile=hdrfile;
            fo1=qsm_run_approach1(s);
        else
            disp(['..not found: ' hdrfile ])  ;
        end
    end
end
 
%% ==============================================
%%  [11] make PNG of chi-image
%% ===============================================
mdirs=antcb('getsubjects');
for j=1:length(mdirs)
    pam   =mdirs{j};
    fis= spm_select('FPList',pam,'^chimap_.*.nii'); fis=cellstr(fis);
    for i=1:length(fis)
        fo1=make_chipng(fis{i} );
    end
end
 
%% ==============================================
%% [12] make ppt
%% ===============================================
mdirs=antcb('getsubjects');
paout =v.pastudy;
pptfile =fullfile(paout,'chimaps.pptx');
for j=1:length(mdirs)
    pam   =mdirs{j};
    [~,animal]=fileparts(pam);
    titlem  =['chimaps: ' animal ];
    [pngs]   = spm_select('FPList',pam,'^chimap_.*.png');    pngs=cellstr(pngs);
    tx=[ ['ANIMAL: '  pam ]; pngs];
    if j==1; doc='new'; else; doc='add'; end
    img2ppt(paout,pngs, pptfile,'size','A4l','doc',doc,...
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[0 1 ],'wh',[ 25 5.9],...
        'title',titlem,'Tha','center','Tfs',20,'Tcol',[0 0 0],'Tbgcol',[0.3 0.74 0.93],...
        'text',tx,'tfs',8,'txy',[0 19],'tbgcol',[1 1 1],'disp',0);  
end
showinfo2(['pptfile'],pptfile);
 
 
%% #################################################
% pipeline
% MPM-pipeline
%% turborare is used as 't2.nii' and registered to MD/T1/PD space,
%% --->advantage: better biascorrection compared to scenario where
%% 1st volume of T1(or MT/PD) is used as 't2.nii'
%% ===================================================================
 
%%  ######################################################################
%%  [PART-1] ANTx-setup, BRUKER IMPORT, CONFIGURATIONS
%%  ######################################################################


%% ===============================================
%% [1]  set parameter
%% ===============================================
 
try; antcb('close'); end
clear all
cf;clear, clc, warning off;
 
v.study      ='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERC_Syn_2025\GEMI_pilot_2025\mpm_ana'; %study-folder
v.paraw      ='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERC_Syn_2025\GEMI_pilot_2025\raw' ; %Bruker-rawdata-folder
v.mpm        ='D:\MATLAB\mpm'                       ;%PATH of: wrapper functions
v.MPMtoolbox ='D:\MATLAB\hMRI-toolbox-0.2.4'        ;%%PATH of: MPM-toolbox
 
% ===============================================
cd(v.study);
if exist(fullfile(v.study,'dat'))==7    %remove dat-folder if exist
    rmdir(fullfile(v.study,'dat'),'s');
end
%remove mpm-folder if exist
if exist(fullfile(v.study,'mpm'))==7    %remove mpm-folder if exis
    rmdir(fullfile(v.study,'mpm'),'s');
end
if exist(fullfile(v.study,'templates'))==7  %remove templates-folder if exist
    rmdir(fullfile(v.study,'templates'),'s');
end
 
%% ===============================================
%% [2]  make ANTx-project
%% ===============================================
cprintf('*[0 .5 0]',['MAKE ANTX-PROJECT '  '\n']);
makeproject('projectname',fullfile(v.study,'proj.m'), 'voxsize',[.07 .07 .07],...
    'wa_refpath','D:\MATLAB\anttemplates\mouse_Allen2017HikishimaLR',...
    'wa_species','mouse')
antcb('load',fullfile(v.study,'proj.m')); % LOAD A PROJECT-FILE "proj.m"
 
%% ===============================================
%% [3]  import Bruker data
%% ===============================================
cprintf('*[0 .5 0]',['IMPORT BRUKER DATA '  '\n']);
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(v.paraw,0,[],[],'gui',0,'show',1);
% ===============================================
% FILTER and DISPLAY a list of Bruker files for MPM-files
protocol='MPM_3D';
%THIS MIGHT CONTAIN MAGNITUDE AND PHASE VOLUMES
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',...
    {'protocol',protocol});
%USE ONLY THE MAGNITUDE VOLUME BY USING ONLY THE PrcNo OF [1]
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',...
    {'protocol',protocol,'PrcNo','1'});
% ===============================================
% IMPORT Bruker files where the protocol name contains MPM-data
w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0,'flt',{'protocol',protocol},...
    'paout',fullfile(v.study,'dat'),'ExpNo_File',1);
%IMPORT TURBORARE
w4=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','TurboRARE'},...
    'paout',fullfile(v.study,'dat'),'ExpNo_File',1);
dispfiles;% check files
 
%% ==============================================
%%  [4] rename files
%% ===============================================
cprintf('*[0 .5 0]',['RENAME FILES '  '\n']);
antcb('selectdirs','all');
xrename(0,['.*' protocol '.*pd' '.*'],'in_PD.nii','copy');
xrename(0,['.*' protocol '.*t1' '.*'],'in_T1.nii','copy');
xrename(0,['.*' protocol '.*mt' '.*'],'in_MT.nii','copy');
xrename(0,['.*' 'TurboRARE'  '.*'],'t2.nii','copy');
dispfiles;% check files
 
%% =========================================================================================================================
%%  [5] change ANTx-config: 
%%  Because brains are skullstripped and stored in PBS --> we use another segmentation-type(6)
%% ==========================================================================================================================
cprintf('*[0 .5 0]',['SET  TYPE OF SKULLSTRIPPING'  '\n']);
antcb('set','wa.usePriorskullstrip',6);
drawnow;
 


%%  ######################################################################
%%     [PART-2] MPM-ANALYSIS
%%  ######################################################################

%% =========================================================================================================================
%% [6] set path of MPM-wrapper functions  (or use hyperlink from cmd-window)
%% ==========================================================================================================================
cprintf('*[0 .5 0]',['ADD MPM-PATH'  '\n']);
cd(v.mpm)  ; %go to mpm-wrapper functions
mpmlink    ; %add path path of mpm-wrapper-functions
cd(v.study); %go back to study-path
 
%% ==============================================
%% [7] MPM-setup
%% ==============================================
cprintf('*[0 .5 0]',['MPM-SETUP'  '\n']);
f_setup('ini','mpm.MPM_path',v.MPMtoolbox); % initialize MPM for this study
 
my_MPMpath=fullfile(v.study,'mpm'); %folder with MPM-configuration for this study
config    =fullfile(my_MPMpath, 'mpm_config'); %this file is created and is modifed in below steps
excelfile =fullfile(my_MPMpath,'mpm_NIFTIparameters.xlsx');%this file is created and is modifed in below steps
 
%% ==============================================
%%  [8] check files (not needed now)
%% ===============================================
% edit(config)
cprintf('*[0 .5 0]',['CHECK FILES..MANUALLY CHANGE SETTINGS IF NEEDED'  '\n']);
disp(['<a href="matlab: edit(''' config ''');">' 'edit mpm_config-file'...
    '</a>' ' * please check the configfile* ']);
showinfo2(['excelfile-riginal'],excelfile);
 
%% ==========================================================
%% [9] write MPM-file names in the excelfile (2nd column)
%% ===========================================================
cprintf('*[0 .5 0]',['WRITE NAMES OF MPM-FILES IN EXCELFILE'  '\n']);
[~,~,a0]=xlsread(excelfile,1);
ha=a0(1,:);
a =a0(2:end,:);
a(:,2)={nan};
a{strcmp(a(:,1),'t2w'),2}='t2.nii';
a{strcmp(a(:,1),'PD' ),2}='in_PD.nii';
a{strcmp(a(:,1),'MT' ),2}='in_MT.nii';
a{strcmp(a(:,1),'T1' ),2}='in_T1.nii';
pwrite2excel(excelfile,{1 'blanko-1'}, ha,[],a);
showinfo2(['excelfile-modified'],excelfile);
 
%% ========================================================================
%% [10] get orientation from 't2.nii'-space to 'T1/MT/PD'-space
%% please check HTML-file for best preorientation ..than go to next step
%% ========================================================================
f_getconfig(config); % load MPM-config of this study
f_estimPreorientHTML()
%PLEASE CHECK THE HTML-FILE before running the next step (f_setup)!
% --> here the best preorientation is: rotTable-Index [14]: which is '1.5708 0 1.5708'
%--> thus, in the next step we'll set 'mpm.t2w_preorient' to [1.5708 0 1.5708]
 
%% ================================================================
%% [11] set preorientation from 't2.nii'-space to 'AVGT.nii'-space
%% via f_setup('update',...
%% ================================================================
f_setup('update','mpm.MPM_path',v.MPMtoolbox, 'mpm.t2w_preorient',[1.5708 0 1.5708]);
 
showinfo2(['excelfile-modified'],excelfile);
disp(['<a href="matlab: edit(''' config ''');">' 'edit mpm_config-file'...
    '</a>' ' * please check the configfile* ']);
 
%% ============================================================================
%% [12] set preorientation from  'T1/MT/PD'-space to  'AVGT.nii'-space
%% please check HTML-file for best preorientation ..than go to next step
%% ============================================================================
antcb('selectdirs','all');
mdirs= antcb('getsubjects');
F1=fullfile(mdirs{1}, 'in_T1.nii');           %use 'T1' from 1st animal
F2=fullfile(v.study,'templates','AVGT.nii');  %use 'AVGT.nii' from template-path
z=[];
z.source       =F1;%source image ('T1/MT/PD'-space)
z.target       =F2;%reference image ('AVGT.nii'-space)
z.outputstring ='sameOrient'; % % prefix of HTML-fileName
xgetpreorientationHTML(0,z);
 
%% ==========================================================================
%% [13] set preorientation from 'T1/MT/PD'-space to 'AVGT.nii'-space
%% best preorientation is rotTable-Index [11]: which is '3.1416 0 1.5708'
%% ==========================================================================
antcb('set','wa.orientType',11);
 
%% ==============================================
%% [14]  RUN MPM-analysis
%%     to see steps, type:  mpm('steps')
%% ===============================================
clear global mpm
cprintf('*[0 .5 0]',['RUN MPM'  '\n']);
loadconfig(fullfile(v.study,'proj.m')); %load ANTX-project of current study
 
w=struct();
w.mpm_configfile   = fullfile(v.study,'mpm','mpm_config.m' );  % mpm-configfile
w.antx_configfile  = fullfile(v.study,'proj.m' );              % antx-projectfile(configfile)
w.pstep            = 'all' ;%preprocessing steps,'all' or use indices([1:5]; see mpm('steps')
w.hstep            = 'all' ;%hmri-processing steps,'all' or use indices([1:5]; see mpm('steps');
w.mdirs=antcb('getallsubjects')  ; % path of animals-DIRs to process
mpm('nogui',w)             ; % run proccessing steps without GUI
 
%% #################################################
% pipeline
% T1_FLASH-pipeline (realign/register series of T1_FLASH volumes)

%% make ANTx-project
%% import Brukerdata
%% flash (optional) : simulate movement/translation over time
%% flash: make 4D 
%% flash: realign vols
%% copy&rename  RARE to 't2.nii'
%% flash: coregister flash to t2.nii
%% (optional):  get HTML-file with pre-orientations
%% (optional): change 'orientType' variable in project-file
%% calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%% transform flash to standard-space (SS)
%% make HTML with overlay

%% ******************************************************************
%%  PART-1  : define project and template
%% ******************************************************************
%% ==============================================
%%     make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj.m" IS CREATED 
%%     USING A VOXELSIZE OF [.09 .09 .09] mm, and the ANIMAL-TEMPLATE "rat_SIGMA_RAT" 
%%     is used, with species 'rat'
% ===============================================
makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[0.09 0.09 0.09],...
    'wa_refpath','F:\anttemplates\rat_SIGMA_RAT',...
    'wa_species','rat')
antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"

%% ==============================================
%%    IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);

% FILTER and DISPLAY a list of Bruker files 
protocol={'2_T1_FLASHax_p2xp2_FA30', '1_T2_tRAREax_Ave3_p1xp1'}
protocol=strjoin(protocol,'|')
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',protocol});
% IMPORT Bruker files
w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0,'ExpNo_File',1,'PrcNo_File' ,1);


antcb('update'); %ipdate GUI
dispfiles; %show files

%% ******************************************************************
%%  PART-2  : flash realign/ registration to t2.nii
%% ******************************************************************
% ==============================================
%%   select animals
% ===============================================
antcb('selectdirs','all'); %all animals
% antcb('selectdirs',[1]); %1st animal
mdirs=antcb('getsubjects');  %get animals


% ==============================================
%%   flash: simulate movement/translation over time
% ===============================================
simulateMovement=0;
if simulateMovement==1
    xop(0,'2_T1_FLASHax_p2xp2_FA30_6_1.nii','2_T1_FLASHax_p2xp2_FA30_6_1.nii','ch:trans:[0.2 0.3 0];');  %translated object by [dx,dy,dz] mm (here: 1,0.2,0.3 mm)
    for i=1:length(mdirs)
        f1=fullfile(mdirs{i},'2_T1_FLASHax_p2xp2_FA30_6_1.nii' );
        fref=fullfile(mdirs{i},'2_T1_FLASHax_p2xp2_FA30_5_1.nii' );
        f3=fullfile(mdirs{i},'2_T1_FLASHax_p2xp2_FA30_6_1.nii' );
        [h,d ]=rreslice2target(f1,fref, f3, 0);
        %now just checks (same hdr.mat and visual inspection)
        hf1= spm_vol(fref);
        hf3= spm_vol(f3);
        deviatmat=sum(abs(hf1.mat(:)-hf1.mat(:)));
        disp(['devation in hdr.mat (ref, aligned): ' num2str(deviatmat)]);
        rmricron([],fref,f3); % show in mricron
    end
end

% ==============================================
%%  flash: make 4D 
% ===============================================
z=[];
z.file      = '.*2_T1_FLASHax_p2xp2_FA30_.*.nii';   % % [SELECT] 3D-NIFTIs to convert to 4D-NIFTI
z.fileout   =  'FLASHax_p2xp2_FA30.nii' ;                      % % output filename of 4D-NIFTI
z.sortfiles = [1];                                  % % sort 3D-NIFTIs/filtered NIFTI-files {0|1}; default:[1]
z.dt        = [0];                                  % % datatype (see spm_type); default:[0], 0 means sane datatype as input
z.writelist = [1];                                  % % write textfile with listed merged NIFTIs;  default:[1]
z.isparallel= [0];                                  % % use parallel processing over animals;  default:[0]
xmergenifti4D(0,z)

% ==============================================
%%  flash: realign vols
% ===============================================
method=1;
if method==1
    tic
    % =====================================================
    % #g FUNCTION:    [xrealign_elastix.m]
    %  #yk  Realign a 3d-(time)series/4Dvolume using ELASTIX and mutual information
    % =====================================================
    z=[];
    z.image3D            = { '' };                                                                       % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)
    z.image4D            = { 'FLASHax_p2xp2_FA30.nii' };                                                 % % SELECT: a 4D-volume to realign
    z.convertDataType    = [0];                                                                         % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision
    z.merge4D            = [1];                                                                          % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume
    z.prefix             = 'r';                                                                          % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image
    z.outputname         = 'FLASHax_p2xp2_FA30_aligned.nii';                                                                           % % optional: rename outputfile; if empty the output-filename is "prefix"+"inputfilename"
    z.cleanup            = [1];                                                                          % % remove temporary files [0]no,[1]yes
    z.keepConvertedInput = [1];                                                                          % % if "convertDataType" is 16,the converted input will be kept(1) or deleted (0) afterwards
    z.isparallel         = [0];                                                                          % % parallel-processing: [0]no,[1]yes
    %z.paramfile          = 'D:\MATLAB\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt';     % % registration parameterfile
    %z.paramfile          =which('trafoeuler5_MutualInfo.txt');
    z.paramfile          = which('trafoeuler5.txt');
    z.numres             = [1];                                                                          % % number of pyramid resolutions. Larger is more precise & more time-consuming.
    z.niter              = [100];                                                                        % % number of iterations in each resolution level.Larger is more precise & more time-consuming.
    z.interp             = [1];                                                                          % % Interpolation: [0]NN, [1]trilinear, [3] bslpine-order 3
    xrealign_elastix(0,z);
    toc
end
if method==2
    tic
    z=[];
    z.image3D          = { '' };                               % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)
    z.image4D          = { 'FLASHax_p2xp2_FA30.nii' };         % % SELECT: a 4D-volume to realign
    z.convertDataType  = [0];                                  % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision
    z.merge4D          = [1];                                  % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume
    z.outputname       = 'FLASHax_p2xp2_FA30_aligned.nii';     % % optional: rename outputfile; if empty the output-filename is "roptions_prefix"+"inputfilename"
    z.isparallel       = [0];                                  % % parallel-processing: [0]no,[1]yes
    z.eoptions_quality = [0.9];                                % % Quality versus speed trade-off {0-1},Highest   quality   (1)   gives   most   precise   results
    z.eoptions_sep     = [1];                                  % % The separation (in mm) between the points sampled in the reference image.
    z.eoptions_fwhm    = [0.5];                                % % SMOOTHING: FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating
    z.eoptions_rtm     = [0];                                  % % [0]Register  to  first:  Images  are registered to the first image in the series. [1]  Register to mean..
    z.eoptions_interp  = [2];                                  % % Interpolation: Method by which the images are sampled when estimating the optimum transformation.
    z.eoptions_wrap    = [0  0  0];                            % % Wrapping: Directions in the volumes the values should wrap around in.
    z.eoptions_weight  = '';                                   % % Weighting: Optional  weighting  image  to  weight  each  voxel  of  the  reference  image
    z.roptions_which   = [2  0];                               % % Specify the images to reslice..see HELP
    z.roptions_interp  = [4];                                  % % Interpolation: The method by which the images are sampled when being written in a different space.
    z.roptions_wrap    = [0  0  0];                            % % Wrapping: This indicates which directions in the volumes the values should wrap around in.
    z.roptions_mask    = [1];                                  % % MASKING: see HELP
    z.roptions_prefix  = 'r';                                  % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image
    xrealign(0,z);
      toc           
end

% ==============================================
%%   copy&rename  RARE to 't2.nii'
% ===============================================
xrename(0,'1_T2_tRAREax_Ave3_p1xp1_7_1.nii', 't2.nii','copy');

% ==============================================
%%   flash: coregister flash to t2.nii
%%  --slow: %43sec
% ===============================================
if 0
    tic
    z=[];
    z.TASK          = '[100] noSPMregistration, only elastix';                                      % % Task to perform (display before/after and or register)
    z.targetImg1    = { 't2.nii' };                                                                 % % target image [t1], (static/reference image)
    z.sourceImg1    = { 'FLASHax_p2xp2_FA30_aligned.nii' };                                         % % source image [t2], (moved image)
    z.sourceImgNum1 = [1];                                                                          % % if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum)
    z.applyImg1     = { '' };                                                                       % % images on which the transformation is applied (do not select the sourceIMG again!)                                                                                                              % % smoothing to apply to 256x256 joint histogram
    z.interpOrder   = 'auto';                                                                       % % interpolation order [0]nearest neighbour, [1] trilinear interpolation, ["auto"] to autodetect interpolation order
    z.warping       = [1];                                                                          % % USE ELASTIX, example..do subsequent nonlinear warping [0|1],
    z.warpParamfile = which('trafoeuler5_MutualInfo.txt');     % % parameterfile used for warping
    z.warpPrefix    = 'c_';                                                                         % % prefix out the output file after warping (if empty, it will overwrite the output of the previously affine registered file)
    z.cleanup       = [1];                                                                          % % remove interim steps
    z.isparallel    = [0];                                                                          % % parallel processing over animals: [0]no,[1]yes
    xcoreg(0,z);
    toc
end

% ==============================================
%%  flash: coregister flash to t2.nii 
%% --faster
%% ok: res/iter: 2/1000->16s, ok
%% ok: res/iter: 2/500->10s, ok
%% ok: res/iter: 1/1000->12s, ok
% ===============================================
parafile=elastixparamfile('copy','pfile','trafoeuler5_MutualInfo.txt','outdir',antcb('getstudypath')   );
paramfile=elastixparamfile('set','pfile',paramfile,'NumberOfResolutions',1, 'MaximumNumberOfIterations',1000); 

tic
z=[];                                                                                                                                                                                                                         
z.TASK          = 100;                                      % % Task to perform (display before/after and or register)                                                                    
z.targetImg1    = { 't2.nii' };                                                                 % % target image [t1], (static/reference image)                                                                               
z.sourceImg1    = { 'FLASHax_p2xp2_FA30_aligned.nii' };                                         % % source image [t2], (moved image)                                                                                          
z.sourceImgNum1 = [1];                                                                          % % if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum)                                           
z.applyImg1     = { '' };                                                                       % % images on which the transformation is applied (do not select the sourceIMG again!)                                                                                                              % % smoothing to apply to 256x256 joint histogram                                                                             
z.interpOrder   = 'auto';                                                                       % % interpolation order [0]nearest neighbour, [1] trilinear interpolation, ["auto"] to autodetect interpolation order         
z.warping       = [1];                                                                          % % USE ELASTIX, example..do subsequent nonlinear warping [0|1],                                                              
z.warpParamfile = parafile;     % % parameterfile used for warping                                                                                            
z.warpPrefix    = 'c_';                                                                         % % prefix out the output file after warping (if empty, it will overwrite the output of the previously affine registered file)
z.cleanup       = [1];                                                                          % % remove interim steps                                                                                                      
z.isparallel    = [0];                                                                          % % parallel processing over animals: [0]no,[1]yes                                                                            
xcoreg(0,z);  
toc

%% ******************************************************************
%%  PART-3  : register to standard space
%% ******************************************************************
% check if change of preorienation is necessary!!!
if 0
    %% ========================================================================================
    %%  [3.1] get HTML-file with pre-orientations
    %%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file
    %%      to update the orientType variable in the project file (proj.m).
    %% ========================================================================================
    antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal
    %% ========================================================================================
    %%  [3.2] change 'orientType' variable in project-file
    %%      When inspecting the HTML-file best orientation is [1] which is set in 'orientType' variable
    %%      in project-file, projectfile is saved and reloaded
    %% ========================================================================================
end
antcb('setpreorientation',1);

%% ========================================================================================================================
%%  [3.3] calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',0);

%% ******************************************************************
%%  PART-4  : transform flash to  standard-space (SS)
%% ******************************************************************
% transform flash3D to SS using linear interp
doelastix(1, [], 'c_FLASHax_p2xp2_FA30_aligned.nii'  ,1 ,'local' );


% ==============================================
%%   make HTML with overlay
% ===============================================
z=[];                                                                                                                                                                                                                         
z.backgroundImg = { 'x_t2.nii' };                                         % % [SELECT] Background/reference image (a single file)                                                                                             
z.overlayImg    = { 'x_c_FLASHax_p2xp2_FA30_aligned.nii' };               % % [SELECT] Image to overlay (multiple files possible)                                                                                             
z.outputPath    = '';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )                     
z.outputstring  = 'flash';                                                % % optional Output string added (suffix) to the HTML-filename and image-directory                                                                  
z.slices        = 'n25';                                                  % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image                            
z.dim           = [2];                                                    % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                                      
z.size          = [400];                                                  % % Image size in HTML file (in pixels)                                                                                                             
z.grid          = [1];                                                    % % Show line grid on top of image {0,1}                                                                                                            
z.gridspace     = [20];                                                   % % Space between grid lines (in pixels)                                                                                                            
z.gridcolor     = [1  0  0];                                              % % Grid color                                                                                                                                      
z.plots         = [1  1  1];                                              % % images to plot [toggleImg BGimg FGimg], example [1 1 1] plot all three                                                                          
z.cmapB         = 'gray';                                                 % % <optional> specify BG-color; otherwise leave empty                                                                                              
z.cmapF         = 'jet';                                                  % % <optional> specify FG-color; otherwise leave empty                                                                                              
z.showFusedIMG  = [1];                                                    % % <optional> show the fused image                                                                                                                 
z.sliceadjust   = [1];                                                    % % intensity adjust slices separately; [0]no; [1]yes                                                                                               
xcheckreghtml(0,z);   







%% #################################################
% pipeline
% PIG-atlas: from Bruker-import to standardspace ( use donwsampled volume)

%% ==============================================
%% 1.  make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj.m" IS CREATED USING A VOXELSIZE
%%     OF [0.5 0.5 0.5] mm, and the ANIMAL-TEMPLATE "piglet_4weeks_PIGMRI_V21" is used, with species 'piglet4w'
% ===============================================
makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[0.5 0.5 0.5],...
    'wa_refpath','F:\anttemplates\piglet_4weeks_PIGMRI_V21',...
    'wa_species','piglet4w')
ant
antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"

%% ==============================================
%%   2. IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);
 
% FILTER and DISPLAY a list of Bruker files where the protocol name contains 'RARE_8_PigBrain5'
% If more than 1 volume should be imported use vertical bar ('|') and strings contained in the protocol-column
% examples; protocol='RARE_8_PigBrain5|Network-DTI';  (will import 'RARE_8_PigBrain5_Cdkl5' and 'Network-DTI_SE_3D_20dir-Piglet4-Cdkl5')
protocol='RARE_8_PigBrain5';
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',protocol});
 
% IMPORT Bruker files with the specific protocol names
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol',protocol},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

dispfiles();% check files and folders

%% ========================================================================================
%%   3. downsample and rename structural image ('RARE_8_PigBrain5_Cdkl5_6.nii') as "t2.nii"
%% REASON: 'RARE_8_PigBrain5_Cdkl5_6.nii' is super large/much larger than the atlas
%%      "t2.nii" will be used for transformation to standard space
%% NOTE: for registration we use a donwsampled version, because image is to large (840MB)!!!!
%% =========================================================================================
antcb('selectdirs','all');   % select all animal-folders
xrename(0,'RARE_8_PigBrain5_Cdkl5_6.nii','t2.nii','vr: 0.5 0.5 0.5');% downsample file and name it 't2.nii' (voxelresoulution: 0.5, 0.5,0.5)

%% ========================================================================================
%%   4. get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%%  !!NOTE THAT THIS STEP DOES NOT WORK HERE BECAUSE BRAINS OF THAT STUDY ARE RANDOMLY DROPPED INTO THE MR-BORE!!
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal
% all brains have a different pre-orientation (don't know why??)--> so we have to obtain the pre-orientation for each animal
% see step-5


%% ========================================================================================
%%   5. because step [4] does not work here...
%%      for each animal use 'examine orientation via HTML-file'  and/or 'get orientation via 3-point selection'  to
%%      obtain a proper preorientation --> make a table (animal x preorientation)
%%     Now; for each animal the  project-file is modified, reloaded, and the first two steps (ini and coreg) are performed
%% ========================================================================================

 % table with animal-names and specific pre-orientations
tb1={    %ANIMAL                            PREORIENTATION
    'YW24_1229_4-weekWTpiglet'              '2.5708 0 0'
    'YW25_0103_4-weekWTpigmale174-7'        '-2.7 4.1 0.15'
    'YW25_0308_4-wk-pig-WT'                 '1.5708 6.1232e-17 -1.570'
};

for i=1:size(tb1,1)
    
    global an
    an.wa.orientType          =tb1{i,2};    % set orientType..this is different for each animal
    an.wa.usePriorskullstrip  =[0];         % brains are already skullstripped
    antcb('saveproject');                   % save projfile
    antcb('reload');                        % reload projfile
    clear an
    drawnow
    
    antcb('selectdirs', tb1{i,1}); drawnow;  %select specific animal
    
    % do only the fisrt 2 steps (ini & coreg)
    xwarp3('batch','task',[1:2],'autoreg',1,'parfor',0);
    
end


%% ========================================================================================================================
%%   6. SEGEMTANTATION (STEP-3) & NONLINEAR REGISTRATION (STEP 4)
%%      calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[3:4],'autoreg',1,'parfor',1);

 
%% ================================================================
%%  7. transform images from native to standard-space (SS)
%% =================================================================
 
antcb('selectdirs','all'); %select all animals
% transform bias-corrected t2.nii ('mt2.nii') to SS using B-spline interpolation
doelastix(1, [], 'mt2.nii'  ,3 ,'local' );
 
% transform GrayMatter and WhiteMatter Imaget to SS using linear interpolation
doelastix(1, [], {'c1t2.nii' 'c2t2.nii'}  ,1 ,'local' ); 
 
%% ================================================================
%%  8. transform images from standard-space to native-space  (NS)
%% =================================================================
% transform brain-hemisphere mask from standard-space to native-space using NN-interpolation
doelastix(-1, [], {'AVGThemi.nii'}  ,0 ,'local' );
 
%% ====================================================================================
%%  9. region-based image readout from image in standard-space
%%     get region-based paramers of GrayMatter-image in SS using AllenBrain atlas
%% =====================================================================================
z=[];                                                                                                                                                                              
z.files        = { 'x_c1t2.nii' };            % % files used for calculation                                                                                                                
z.fileNameOut  = 'paras_grayMatter_SS';       % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);  
 
%% ====================================================================================
%%  10. region-based image readout from image in native-space (NS)
%%      get region-based paramers of GrayMatter-image in NS using AllenBrain atlas
%% =====================================================================================
z=[];
z.files        = {'c1t2.nii'};  % files used for calculation     
z.space        =  'native'  ;% use images from "standard","native" or "other" space 
z.hemisphere   =  'both';   % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
z.fileNameOut  = 'paras_grayMatter_NS';            % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);
 
 
 
 % ============================================================================================
%% [11.1] BIG_VOLUME:  trafo ANO.nii from standardspace to native space ('ix_ANO_big.nii')
%%  with the same size as the orig. big image 'RARE_8_PigBrain5_Cdkl5_6.nii' (super large: 840MB)
% =============================================================================================
tic
mdirs=antcb('getsubjects') ;
fref=fullfile(mdirs{1},'RARE_8_PigBrain5_Cdkl5_6.nii');
h=spm_vol(fref);

%-use explicit files:
% files = {'F:\data9\devin_pigRegistation\dat\YW24_1229_4-weekWTpiglet\ANO.nii'};
%-or use filename and selected animals from GUI-listbox: 
files='ANO.nii';
pp.resolution     = h.dim  ;% [520  850  256];                                          
pp.source         =  'intern';                                                 
pp.fileNameSuffix =  '_big0';     % creates 'ix_ANO_big.nii'                                             
fis=doelastix(-1, [],files,0,'local' ,pp);                                                                                                                      
toc

% ===FIX issue off different spaces of  'RARE_8_PigBrain5_Cdkl5_6.nii' and 'ix_ANO_big0.nii'
mdirs=antcb('getsubjects') ;
for i=1:length(mdirs)
    fref=fullfile(mdirs{i},'RARE_8_PigBrain5_Cdkl5_6.nii');
    f1=fullfile(mdirs{i},'ix_ANO_big0.nii');
    f2=fullfile(mdirs{i},'ix_ANO_big.nii');
    rreslice2target(f1, fref, f2, 0);
    try; delete(f1); end
    
    %PLOT OVERLAY OF WITH 10 SLICES (BIG-IMAGE & AND 'ix_ANO_big2.nii')
    slice='n10'; % 10 slices
    [d ] = getslices( fref    ,2,[slice],[],0 );
    [o ] = getslices({fref f2},2,[slice],[],0 );
    d2=imadjust(mat2gray(montageout(permute(d,[1 2 4 3]))));
    o2=imadjust(mat2gray(montageout(permute(o,[1 2 4 3]))));
    imoverlay2(d2,o2);  hfig=gcf;
    addNote(hfig,'text',['____  mdir: <b>' mdirs{i} '</b><br>'],'pos',[0 0  1 .05],'mode','multi');
    set(hfig,'menubar','none');
end
toc
%% #################################################
% pipeline
% DWI-analysis part-1 (SINGLESHELL): Matlab-preprocessing
% - SINGLESHELL-DWI-pipeline covers the following: 
%     make ANTx-project, Brukerimport, renaming files, transform to standardspace, complete DTIprep-routine


%% ===============================================
%% [0]  set parameter (study and raw-data)
%% ===============================================
 
try; antcb('close'); end
cf;clear all, clc, warning off;
 
v.study      ='H:\Daten-2\Imaging\AG_Harms\2025_PSILO\analysis1'; %study-folder
v.paraw      =fullfile(v.study,'raw') ; %Bruker-rawdata-folder
cd(v.study)

%% ==============================================
%% [1]  make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj.m" IS CREATED USING A VOXELSIZE
%%     OF [.07 .07 .07] mm, and the ANIMAL-TEMPLATE "mouse_Allen2017HikishimaLR" is used, with species 'mouse'
% ===============================================
makeproject('projectname',fullfile(v.study,'proj.m'), 'voxsize',[.07 .07 .07],...
    'wa_refpath','D:\MATLAB\anttemplates\mouse_Allen2017HikishimaLR',...
    'wa_species','mouse')

antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"


%% ===============================================
%% [2]  import Bruker data
%% ===============================================
cprintf('*[0 .5 0]',['IMPORT BRUKER DATA '  '\n']);
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(v.paraw,0,[],[],'gui',0,'show',1);
% ===============================================
%show TURBORARE
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol','TurboRARE'},...
    'paout',fullfile(v.study,'dat'),'ExpNo_File',0);
%import TURBORARE
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','TurboRARE'},...
    'paout',fullfile(v.study,'dat'),'ExpNo_File',0);
dispfiles;% check files

%% ========[import DWI-file]=======================================

% show DWI-files
protocol='DTI_EPI_seg_60dir';
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',...
    {'protocol',protocol});
% import DWI-files
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',...
    {'protocol',protocol},'PrcNo','0');

dispfiles; %checking files

%% ==============================================
%%  [3] rename files (TurboRARE-file to 't2.nii')
%% ===============================================
cprintf('*[0 .5 0]',['RENAME FILES '  '\n']);
antcb('selectdirs','all');
xrename(0,['.*TurboRARE.*.nii'],'t2.nii','copy');
dispfiles; %checking files

%% ========================================================================================
%%  [4] get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal
%% ========================================================================================
%%  [5] change 'orientType' variable in project-file
%%      When inspecting the HTML-file best orientation is [1] which is set in 'orientType' variable 
%%      in project-file, projectfile is saved and reloaded
%% ========================================================================================
antcb('setpreorientation',1);

%% ========================================================================================================================
%%  [6] calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1);

%% ==============================================
%%  [7] check coregistration 
%% visuall check the progressreport (HTML)  and 
%% use this metric (correlation-approach) to find outliers
%% ===============================================
useMetric=0; %optional to use metric across all animals to identy outliers in registration
if useMetric==1
    z=[];
    z.metric             = [1];                   % % used metric [1]Pearson correlation(R); [2] mutual information (MI)
    z.imageType          = 'gm';                  % % imageType to compare "gm": gray matter image is compared
    z.forceReCreateImage = [0];                   % % force to create image even when exists (warp image to standard-space)
    z.report_dosave      = [1];                   % % save report in checks-folder [0]NO, [1]yes
    z.report_type        = 'html';                % % save report as "html" or "xlsx" file
    z.report_filename    = 'QA_registration';     % % filename to save the report in "checks"-folder
    z.report_addDate     = [1];                   % % add time/dateStamp to the saved report
    xQAregistration(0,z);
end

%% ******************************************************************************************
%% ******************************************************************************************
%%  PART-2: DTI-preprocessing
%% ******************************************************************************************
%% ******************************************************************************************

%% ==============================================
%%   [8] copy the here used DWI-atlas to this study
%% ===============================================
atlassource='D:\MATLAB\atlases\DTI_atlas_31mar20';
[~,atlasname]=fileparts(atlassource);
v.DWIatlas=fullfile(v.study,atlasname);
copyfile(atlassource,v.DWIatlas,'f');

%% =========================================================================
%%  [9] DTIprep-setup  : here we use Single-shell-approach!
%% ==========================================================================
DTIprep('delete'); %delete existing "DTI"-folder
clear d;
[rawdirs]  = spm_select('FPList',v.paraw,'dir'); rawdirs=cellstr(rawdirs); % get raw-dirs
[dwifiles] = spm_select('FPListRec',fullfile(v.study,'dat'),'.*DTI_EPI.*.nii');dwifiles=cellstr(dwifiles); %get DWI-epi-files
[~,dwifilesShort]=fileparts2(dwifiles); 
dwifilesShort=unique(dwifilesShort);

if isempty(char(dwifilesShort))
   error('no DWI-files found..please fix!'); 
end
if length(dwifilesShort)>1;
    error('this is a singleShell-approach..but multiple DWI-files found..please fix!');
end
d.brukerdata     =rawdirs{1} ; % % sample Bruker-rawdata set from one animal to obtain the b-table(s)
d.DTItemplate    =spm_select('FPList',v.DWIatlas,'^DTI.*.nii') ; % % DTI-atlas NIFTI-file
d.DTItemplateLUT =spm_select('FPList',v.DWIatlas,'^DTI.*.txt') ; % % DTI-atlas txt-file with labels
d.DTIfileName    ={char(dwifilesShort)}; % % filenames of the DWI/DTI-files located in animal folders
DTIprep('ini',d);  % % initialize DTIprep-struct and fill requested parameters
DTIprep('import'); % % import b-table and DTItemplate/DTItemplateLU

%% ==============================================
%%  [10] run DTIprep-PREPROCESSING
%% ===============================================
DTIprep; % DTI-open GUI
antcb('selectdirs','all');   % select all animal-folders
DTIprep('run','all');

%% ======================================================================
%%   [11] copy the latest script that is used to export the data to HPC
%% note: the local copy of the script has to be modified accordingly 
%% ..or see DTIprep-Gui -->scripts-button
%% =======================================================================
fi1=which('DTIscript_exportToHPC_makeBatch_21-11-2024.m');
fo1=fullfile(v.study,'b2_export2HPC.m');
copyfile(fi1,fo1,'f');
edit(fo1)
% clear

%% #################################################
% pipeline
% DWI-analysis part-2 (SINGLESHELL): Matlab-transfer files and starterscripts to HPC
% this is a modified local copy of 'DTIscript_exportToHPC_makeBatch_21-11-2024.m'
% ..or see DTIprep-Gui -->scripts-button

%% export to HPC
%% -------------[HPC-TARGET-PATH]-------------------------------------------------------------
paHPCstudy_asW     = 'X:\Imaging\Paul_DTI\2025_PSILO'  ;% HPC-TARGET-path as seen from WINDOWS (asW)

%% ------------[DTI_export4mrtrix-path]------------------------------------------------------------
% [painDat]: WINDOWS-folder withINPUT-data for DTI-processing ; form ["studypath"+"DTI_export4mrtrix"+"dat"]
painDat  = fullfile( 'H:\Daten-2\Imaging\AG_Harms\2025_PSILO\analysis1'    ,...
    'DTI_export4mrtrix');

%% ------------[jobname]-------------------------------------
bash.jobName       = 'psilo'          ; % arbitrary name of jobname in bashfile (no space, no sepcial characters,short)
% --------------------------------------------------------------------------

%______ animals to export to HPC-CLUSTER and USE in batch(s) (use "all" or a numeric vector) ____________
p.numBatchfiles    = 2        ; %number of batchfiles, each batchfile process a subset of animals (default: 1 )
p.animals          = 'all'    ;%animals to copy to HPC: 'all': all inimals from "painDat"-dir
% p.animals        = [1:2]    ;%animals to copy  to HPC: 'all': all inimals from "painDat"-dir, or numeric array ; examples: [1 2 4], [4] or [4,7:10] 

% ----------------[other batch-parameter]--------
bash.jobTime       = '48:00:00'   ; % max-limit on total HPC run time: example: "22:00:00" for 22hours; NOTE: max-allowd time is restricted to 48h ("48:00:00")  ...The 7 days ("7-00") option does not work anymore on our HPC  
bash.jobCPUs       = 100          ; % number of CPUs (cores) per task'; number of CPUs (50 seems to be ok, 120 seems to be a bit better but maybe you must wait to obtain the ressources)
p.copydirs         = 1            ; % copy the data to HPC: [1] yes, [0] no
p.overwriteDirs    = 0            ; % force to overwrite data on HPC: [1]yes, [0] no, if folder exist do not copy data

% --------OTHER PARAMS--------------
p.showBatch        = 0                                                                ; % show batch in extra MATALB-window: [1]yes,[0]no

% ----the following applies only if "p.transferBatch" is "1"
p.transferBatch    = 1;                                                               ; % [0,1]transfer batchfile to HPC; [0]no just show batch(copy/nPaste); [1]yes, write batch(sh-file) to HPC-cluster
p.HPC_hostname     = 's-sc-frontend2.charite.de'                                      ; % HPC-hostname:  old HOSTNAME: 's-sc-test4.charite.de
p.makeExecutable   = 1;                                                               ; % make shellscript executable ('chmod' starter shellscript)
p.condaEnvironment = '/sc-projects/sc-proj-agtiermrt/Daten-2/condaEnvs/dtistuff'      ; % name of the conda-environment (containing mrtrix,fsl,ants); otherwise leave empty ('')
p.start_shfile     = 'run_mrtrix.sh'                                                  ; % shellscript linked in the HPC-batchfile: this file is executed from the starting shellscript (previously:  'rat_exvivo_complete_7expmri.sh' or 'mouse_dti_complete_7texpmri.sh')


%% =======[FOR CHARITE: DO NOT MODIFY THE FOLLOWING PARAMTERS!!!, otherwise specify 'p.paHPCstudy_asL' ]========================================
p.paHPC            = '/sc-projects/sc-proj-agtiermrt/Daten-2'  ; % MAIN-DIR on HPC to store the data (as seen from LINUX; "asL")
p.paHPCstudy_asL   = []                                        ;% for CHARITE: keep empty otherwise specify the target-folder on HPC ..(as seen from LINUX; "asL")
p.paBackup         = 'H:\Daten-2\Imaging\BACKUP_DTI'           ; % backupfolder: essential data can be stored there after processing
%% ======================================================================





%% ========================================================================
%% #ka  ___ internal stuff ___
%% ========================================================================
[~,subdir]=fileparts(painDat);
if strcmp(subdir,'dat')==0
    painDat=fullfile(painDat,'dat');
end


if isempty(p.paHPCstudy_asL)
    [isplit1 fileseps1]=strsplit(paHPCstudy_asW,  paHPCstudy_asW(min(regexpi(paHPCstudy_asW,'[\\/]'))) ); %split
    [isplit2 fileseps2]=strsplit(p.paHPC,  p.paHPC(min(regexpi(p.paHPC,'[\\/]')))) ;
    p.paHPCstudy_asL=strjoin([p.paHPC isplit1(2:end)], fileseps2{1});
end

% return
[~,studyname]=fileparts(paHPCstudy_asW);


%% =====================================================================
%%  [PART-2] copy data to HPC-storage
%% =====================================================================
[dirs] = spm_select('FPList',painDat,'dir','.*');
dirs=cellstr(dirs);

if ischar(p.animals) && strcmp(p.animals,'all')%
    animal_ids=1:length(dirs);
else%numeric
    animal_ids=p.animals;
end

if p.copydirs==1
    iscoping=0;
    
    mkdir(paHPCstudy_asW);
    for i=1:length(dirs)
        if  ~isempty(find(animal_ids==i)) ;% if animalID is specified
            Sdir=dirs{i};
            [pa,animal]=fileparts(Sdir);
            Tdir=fullfile(paHPCstudy_asW,'data', [ 'a' pnum(i,3)],animal);
            
            if exist(Tdir)~=7 || p.overwriteDirs==1
                disp([ 'copying data: '  '[a' pnum(i,3) '] - "' animal  '"   ...wait..' ]);
                copyfile(Sdir,Tdir,'f');
                iscoping=1;
            end
        end %animalID-match
    end%animal
    if iscoping==1
        disp('copy dirs...DONE!');
    end
end

%% =====[write source-file to HPC]==========================================
sf.source=fullfile(fileparts(fileparts(painDat)),'dat');
l={};
l{end+1,1}=['[source]'   sf.source  ];
l{end+1,1}=['[backup]'   p.paBackup ];
l{end+1,1}=['[hostname]' p.HPC_hostname ];
l{end+1,1}=['[HPCtargetdirWin]' paHPCstudy_asW ];
l{end+1,1}=['[HPCtargetdirUnix]' p.paHPCstudy_asL ];
sourcefile=fullfile(paHPCstudy_asW,'source.txt' );
pwrite2file(sourcefile,l);
%% =====[write source-file to study's DTI-folder]======================================
dtipath      =fullfile(fileparts(sf.source),'DTI');
sourcefileDTI=fullfile(dtipath,'source.txt' );
pwrite2file(sourcefileDTI,l);
%% =====================================================================
% EXAMPLE BATCH
% #!/bin/bash
% #SBATCH --job-name=newdire     # Specify job name
% #SBATCH --output=newdire.o%A_%a   # File name for standard output       (alternative: .o%j)
% #SBATCH --error=newdire.e%A_%a    # File name for standard error output (alternative: .e%j)
% #SBATCH --partition=compute    # Specify partition name
% #SBATCH --nodes=1              # Specify number of nodes
% 
% # ____SBATCH --ntasks-per-node=100  # Will request 120 logical CPUs
% 
% #SBATCH --cpus-per-task=100     # Specify number of CPUs (cores) per task  (with 24cpus-->14h)
% #SBATCH --time=22:00:00        # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)
% #SBATCH --array=1-4            # Specify array elements
% 
% eval "$(conda shell.bash hook)"               # Connect Conda with the bash shell
% conda activate dtistuff        # Activate conda virtual environment
% 
% animalID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)
% # ___ animal [a001]: "20191029CH_Exp8_M01" ___
% cd /sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/newHPC_directive_AG_Mundlos/data/a$animalID
% ./../../shellscripts/run_mrtrix.sh


% ==============================================
%% [PART-3] make animal-batch
% ===============================================
space=repmat(' ',[1 10]);
bash.partition='compute';
bash.nodes    =1;

% =====get animal folders==========================================
padat=fullfile(paHPCstudy_asW,'data');
[dirs] = spm_select('List',padat,'dir','^a.*');
animals=cellstr(dirs);
if length(animals)<p.numBatchfiles
    error('more batchfiles than animals...reduce "p.numBatchfiles" ');
end

%% =====get number of animals per charge =============================

chargeIndex=[1:length(animals)]';
n = ceil(numel(animals)/p.numBatchfiles);
p.chargeIndex = reshape([chargeIndex;nan(mod(-numel(chargeIndex),n),1)],n,[]);
%% ===============================================

for ss=1:p.numBatchfiles
    if p.numBatchfiles==1
        addnum='';
    else
        addnum=num2str(ss);
    end
    p.batchFilename    = ['batch_' bash.jobName addnum '.sh']       ;%filename of the batch-file (sh-file)

    % create arrayID
    ChargeIDX=unique(p.chargeIndex(:,ss));
    ChargeIDX(isnan(ChargeIDX))=[];
    ChargeIDX=intersect(ChargeIDX,animal_ids);
    if length(ChargeIDX)==1
        bash.array=[num2str(ChargeIDX) ];
    else
        if any(diff(ChargeIDX)~=1) % not-consecutive numbers
            bash.array= regexprep(strjoin(cellstr(num2str(ChargeIDX)),','),'\s+','');
        else %consecutive numbers
            bash.array=[num2str(min(ChargeIDX)) '-' num2str(max(ChargeIDX))];
        end
    end

    
    o={...
        '#!/bin/bash'
        ['#SBATCH --job-name='           [bash.jobName addnum       ]           '        #Specify job name'  ]
        ['#SBATCH --output='             [bash.jobName addnum  '.o%A_%a' ]   '        #FileName of output with %A(jobID) and %a(array-index);(alternative: .o%j)']
        ['#SBATCH --error='              [bash.jobName addnum  '.e%A_%a' ]   '         #FileName of error with %A(jobID) and %a(array-index);alternative: .e%j)']
        ['']
        ['#SBATCH --partition='          bash.partition         '         # Specify partition name']
        ['#SBATCH --nodes='              num2str(bash.nodes)    '                   # Specify number of nodes']
        ['#SBATCH --cpus-per-task='      num2str(bash.jobCPUs)     '         # Specify number of CPUs (cores) per task' ]
        ['#SBATCH --time='               bash.jobTime           '             # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)']
        ['#SBATCH --array='              bash.array             '                 # Specify array elements (indices), i.e. indices of of parallel processed dataSets  ' ]
        ''
        
        };
    
    %% =========[older conda-initialization routines]=====
    % ['eval "$(conda shell.bash hook)"               # Connect Conda with the bash shell']
    % ['eval "$(/opt/conda/bin/conda shell.bash hook)" # Conda initialization in the bash shell']
    %% ===============================================
    oconda={};
    if ~isempty(p.condaEnvironment)
        oconda={
            ['source /etc/profile.d/conda.sh                # Conda initialization in the bash shell']
            ['conda activate ' p.condaEnvironment  '        # Activate conda virtual environment']
            };
    end
    o= [o; oconda; {'';''}];
     %% ===============================================
    
    % pamainlx='sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/Eranet';
    % pastudylx =['/' strrep(fullfile(pamainlx,studyname),filesep ,'/')];
    
    pastudylx=p.paHPCstudy_asL;
    padatlx   =[pastudylx '/data'];
    pascriptslx =[pastudylx '/shellscripts'];
    
    
    %     % =====get animal folders==========================================
    %     padat=fullfile(paHPCstudy_asW,'data');
    %     [dirs] = spm_select('List',padat,'dir','^a.*');
    %     animals=cellstr(dirs);
    
    animalsExplicitName={};
    for i=1:length(animals)
        animalpath=fullfile(padat, animals{i});
        [dirs] = spm_select('List',animalpath,'dir','^20.*');
        animalsExplicitName{i,1}=dirs;
    end
    
    % =====loop==========================================
    % scriptname ='_test_listdir.sh';
    % scriptname = 'rat_exvivo_complete_7expmri.sh';
    scriptname =p.start_shfile;
    
    r={};
    r{end+1,1}=['animalID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)'     '                #obtain SLURM-array-ID ']; % extract
    
    
    ChargeIDX=p.chargeIndex(:,ss);
    ChargeIDX(isnan(ChargeIDX))=[];
    
    r{end+1,1}=['cd ' padatlx '/' 'a$animalID' ];
    r{end+1,1}=['./../../shellscripts/' scriptname]; %eval script

    r{end+1,1}='';
    r{end+1,1}='';
    r{end+1,1}=['# ===================================================='];
    r{end+1,1}=['#   INFOS:    DIRS   &   ANIMAL NAMES   '];
    r{end+1,1}=['# ===================================================='];

    
    for i=1:length(ChargeIDX)
        
        animalIDtrunk=regexprep(animals{ChargeIDX(i)},'^a',''); %truncated animalID
        if ~isempty(find( animal_ids==str2num(animalIDtrunk) )); %use only this animals
            
            r{end+1,1}=['# ___ animal ['  animals{ChargeIDX(i)} ']: "'  animalsExplicitName{ChargeIDX(i)} '" ___'];
            
            %====[go to animal-path ]======
            %g=['cd ' padatlx '/' animals{ChargeIDX(i)} ];
            %r{end+1,1}=g;
            %clipboard('copy',g); %check
            %c=['. ' pascriptslx '/' scriptname ];
            %c=['./../../shellscripts/' scriptname];
            %r{end+1,1}=c;
            % clipboard('copy',c); %check
            
            %r{end+1,1}='';
        end
    end
    s=[o; r];

   
    % display batch
    if p.showBatch==1
        if p.numBatchfiles==1;         uhelp(s);
        else                 ;         uhelp(s,1);
        end
            
        msg={...
            '-you can copy the content of this window to a file on the HPC cluster'
            '- make it executable: cmod +x "mybatch.sh"'
            '- and run it via: sbatch "mybatch.sh"'
            'on the HPC-cluster'
            '<br>'
            };
        addNote(gcf,'text',msg,'pos',[0.1 .05  .85 .2],'head','Note: HPC-batch','mode','single');
    end
 
    
    % ==============================================
    %%  [4] write batch-file local
    % ===============================================
    batchfilename=fullfile(pwd,p.batchFilename);
    disp(['..writing batch-file to local,current working Dir']);
    pwrite2file(batchfilename,s);
    
    if p.transferBatch==0; return; end
    
     %continue
    % ==============================================
    %%  [4] transfer batch-file to HPC
    % via SSH/SFTP/SCP For Matlab (v2)-package
    % ===============================================
    %e=which('scp_simple_put');
    %if isempty(e) % add package to path
    %    addpath(genpath('_paul_temp_doNotDelete'));
    %end
    [batchPath bathNameTmp batchExt]=fileparts(batchfilename);
    batchName=[bathNameTmp batchExt];
    
    % --------------------------------
    % [4.1] get username and password
    if ss==1
        [p.login p.password] = logindlg('Title','HPC-cluster');
        if isempty(p.login) | isempty(p.password)
            cprintf('*[1 0 0]',['transfering batchfile to HPC aborted (no username/password provided)' '\n']);
            return
        end
        global mpw
        mpw.login =p.login;
        mpw.password=p.password;
    end
    
    % --------------------------------
    % [4.2] transfer batchfile
    % delete file
    cmd=['rm ' batchName];
    command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    % transfer file via sftp_simple_put
    msg=sftp_simple_put(p.HPC_hostname,p.login,p.password,batchName,'',batchPath);
    
    % --------------------------------
    % [4.3] verify tranfer
    cmd=['[ -f ' batchName  ' ] && echo "File exist" || echo "File does not exist"'];
    command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    if strfind(strjoin(command_output,char(10)),'File exist')
        cprintf('*[0 .5 0]',['file(' num2str(ss) ') "' batchName '" successfully transfered to HPC-cluster ' '\n']);
    else
        cprintf('*[1 0 0]',['failed to transfer file "' batchName '" to HPC-cluster! ' '\n']);
    end
    % --------------------------------
    % [4.4] make executable
    if p.makeExecutable==1
        % command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,['ls -la ' batchName]);
        cmd=['chmod +x ' batchName ';' ['ls -la ' batchName]  ];
        command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
        if length(strfind(command_output{1}(1:10),'x'))>0
            cprintf('*[0 .5 0]',['file(' num2str(ss) ') "' batchName '" now is executable  ' '\n']);
            disp([' info: ' strjoin(command_output,char(10))]);
        else
            cprintf('*[1 0 0]',['failed to make file "' batchName '" executable!  ' '\n']);
        end
    end
    
    
end %ss several shell-files
disp('Done!');














%% #################################################
% PLOTS
% make plots/save as PNG-file
%% ==========================================================================================
%%  single image
%% ==========================================================================================
%  show AVGT as coronar slices (2nd dim)
f2=fullfile(pwd,'AVGT.nii')
slice2png(f2,'dim',2,'showonly',1);

% sliced along dim-2, 8 eqzidistant slices displayed in 1 row ..saved as 'AVGT.png'
slice2png(f2,'dim',2,'nslices',8,'sb',[1 nan]);

% or use explizit slice-numbers (100,120,150,170) --> only shown, not saved
slice2png(f2,'sb',[1 nan],'dim',2,'slice',[100 120 150 170],'showonly',1)

% or use slices based on mm-unit --> display slices with -5mm,-2.01mm,0mm,0.5mm
slice2png(f2,'sb',[1 nan],'dim',2,'slicemm',[-5 -2.01 0 0.5],'showonly',1)
% more plots in more contrained mm-block (20 slices within -1mm and 0mm)
slice2png(f2,'sb',[nan nan],'dim',2,'slicemm',[linspace(-1,0,20)],'showonly',1)

%% ==========================================================================================
%%  using pseudocolor for large dynamic ranges as in the Allen brain atlas (ABA)
%% ==========================================================================================
%% only pseudocolorized ABA with contour:
f1=fullfile(pwd,'ANO.nii');
slice2png({f1},'alpha',[0.5],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','k','linewidth',.1,'levels',5}},'pcolor',[1]);

%% AVGT with overlay of pseudocolorized ABA:
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 .6 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'brighter',1,'pcolor',[2]);

%% AVGT with overlay of pseudocolorized ABA with contour:
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 0.6],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','k','linewidth',.1,'levels',5}},'brighter',1,'pcolor',[2]);


%% ==========================================================================================
%%  overlay
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2};
slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);

%overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100)

%as above but displayed (not saved)
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'showonly',1)

%automatic layout of 10 slices, with additional title and auto-message
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',1,'show',1)

%as above but with specific message
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',{'kohl','kopf'},'show',1)

%as above but with explitic name for PNG-file
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'savename','dum.png')

% no transparency, black background, white text
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'bgcol','k','fgcol','w','bgtransp',0)

% other colormap
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cbarvisible',[0 1],'showonly',1,'cmap',{'gray','jet'})

%% ==========================================================================================
%%   DISPLAY MASKLESION IN  STANDARD SPACE
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii');

slice2png({f1,f2},'showonly',1); %sagittal, only shown           
slice2png({f1,f2},'dim',2,'showonly',1); %coronar view

% with contout and specific cmpas---see getCMAP('showmaps');
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2}); % other cmaps
% specific cmpas---see getCMAP('showmaps');
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','Greens'});     % other cmaps

% contour only with masklesion
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2,{};1 {}},'alpha',[0 1]);


%% ==============================================
%%   add contour for masklesion
%% ===============================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii');
%add contour for masklesion
slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2}); %coronar view
%add red contour 
slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2,{'color','r','linewidth',1}}); %coronar view


%% ==========================================================================================
%% 3 IMAGES: add mask-lesion contour on top of ANO
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
f3=fullfile(pwd,'x_masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}})

%% ====[same in native space]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'ix_ANO.nii');
f3=fullfile(pwd,'masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'brighter',10)


%% ====[AVGT as contour to check registration ]===========================================
f1=fullfile(pwd,'x_t2.nii');
f2=fullfile(pwd,'AVGT.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);

%% ====[ANO as contour to check registration ]===========================================
f1=fullfile(pwd,'x_t2.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);


%% ====[gray matter  as contour ]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 1 nan],'dim',1,'nslices',5,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','y','linewidth',.1,'levels',3}},'brighter',1);


%% ====[gray matter as contour and masklesion]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'alpha',[1 0 .2],'sb',[ 3 nan], 'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1, 'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}},'brighter',1)


%% ====[gray and white matter as contour ]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'c2t2.nii');
ff={f1;f2; f3};
slice2png(ff,'alpha',[1 0 0],'sb',[ 3 nan], 'dim',1,'nslices',10,'showonly',1,'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}; 3,{'color','r','linewidth',.1,'levels',1}},'brighter',1);

%% ==========================================================================================
%%    NATIVE SPACE
%% ==========================================================================================
 % using NIFTI in native space, assume no mask is available, using implicit mask via Otsu-method
 f1=fullfile(pwd,'t2.nii');
 f2=fullfile(pwd,'ix_ANO.nii');
 
 % less compact view because no implicit mask is used
 slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1,'usemaskotsu',0)
 
 % more compact view because implicit mask is used
 slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1)
 
 
 %% -  --plot tissue compartments
 f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'c2t2.nii');
f4=fullfile(pwd,'c3t2.nii');
ff={f1;f2;f3;f4};
slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0])
%same but with increaded brightness
slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0],'brighter',10)



 %% ==========================================================================================
 %% overlay with Jacobian
 %% ==========================================================================================

f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2};

%overlay, JD is semitransparent, 1-column-layout, dim-2 is sliced,5 slices, only shown (not saved) 
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1)

%as above, but for JD only values above 1.0 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 1 nan])

%as above, but for JD only values below 0.5 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; nan 0.5])

%as above, but for JD only values in the range 0.8 and 1.2 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 0.8 1.2])

%% ==========================================================================================
%% USING 2 IMAGES: THRESHOLD INTENSITY MAPS
%% ==========================================================================================
%  for JD only values above 1.0 are shown (see thresh)
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2};
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot'},'showonly',1,'thresh',[nan nan; 1 nan])

%% ===============================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' twice)
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2; f2};
slice2png(ff,'clims',[0 200; 0.5 1.5; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'cool'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])

%as above but here we use the same 'clims' as for the 'thresh'
slice2png(ff,'clims',[0 200; 1 nan; nan 0.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'winter'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])


%% ==========================================================================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAP 
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii')
f3=fullfile(pwd,'JD.nii');
ff={f1;f2; f3};
slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',1)

% save with black background
slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',0,'bgcol','k','bgtransp',0)



%% ==========================================================================================
%% USING 4 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' 2 times)
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii')
f3=fullfile(pwd,'JD.nii');
ff={f1;f2; f3; f3};
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5])

% show specific colorbars only
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])

% other cmaps
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','isoRed', 'isoBlue'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])


%% ==========================================================================================
%%  overlay atlas  and color specic IDs
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2};
slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);

%overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 672   ]} ,'showonly',1,'cmap',{'gray','isoRed'})

% more ids
slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 201 672 500 733 1047 1070  ]},'showonly',1,'cmap',{'gray','jet'})

%% ==========================================================================================
%%  overlay atlas  and color specic IDs  with specific colors
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2;f2;f2};

keepvalue={2,[672 500 733] ;...
    3 [ 1047 ]; ....
    4,[  1020  ]}
slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'})


%adjustment of colorbar
keepvalue={2,[672] ;...
    3 [ 1047 ]; ....
    4,[  1020  ]}
slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'},'cbarpos',[nan nan 0.02 .02])

%% ==========================================================================================
%%  show left or right hemisphere only
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
f3=fullfile(pwd,'x_masklesion.nii')
mask=fullfile(pwd,'AVGThemi.nii');
ff={f1;f2; f3};

% left hemisphere
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',1);
% right hemisphere
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',2);

% ==============================================
%%   show first 400 regions of the ABA-atlas 
% ===============================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
mask=fullfile(pwd,'ANO.nii');
ff={f1;f2};
slice2png(ff,'clims',[nan nan;nan 1000],'alpha',[1 0],'sb',[ 4 nan],...
    'dim',2,'nslices',20,'cmap',{'gray', 'parula'},'showonly',1,...
    'cbarvisible',[0 0],'mask',mask,'maskvalue',[ 1:1400 ]);








%% #################################################
% powerpoint
% make global PPT with images from animal-folders

%% ==============================================
%%  1) make global PPT with images from animal-folders
%% ===============================================
mdirs=antcb('getsubjects');
paout =pwd;
pptfile =fullfile(paout,'chimaps.pptx');
for j=1:length(mdirs)
    pam   =mdirs{j};
    [~,animal]=fileparts(pam);
    titlem  =['chimaps: ' animal ];
    [pngs]   = spm_select('FPList',pam,'^chimap_.*.png');    pngs=cellstr(pngs);
    tx=[ ['ANIMAL: '  pam ]; pngs];
    if j==1; doc='new'; else; doc='add'; end
    img2ppt(paout,pngs, pptfile,'size','A4l','doc',doc,...
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[0 1 ],'wh',[ 25 5.9],...
        'title',titlem,'Tha','center','Tfs',20,'Tcol',[0 0 0],'Tbgcol',[0.3 0.74 0.93],...
        'text',tx,'tfs',8,'txy',[0 19],'tbgcol',[1 1 1],'disp',0);  
end
showinfo2(['pptfile'],pptfile);
%% #################################################
% powerpoint
% make PPT with multiple images on several ppt-slides
paout   =pwd;
paimg   =fullfile(pwd,'barplot_img');
pptfile =fullfile(paout,'barplot.pptx');
titlem  =['barplots'  ];
[fis]   = spm_select('FPList',paimg,'^bar.*.png');    fis=cellstr(fis);
tx      ={['path: '  paimg ]};

nimg_per_page  =6;           %number of images per plot
imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
for i=1:length(imgIDXpage)-1
    if i==1; doc='new'; else; doc='add'; end
    img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
    img2ppt(paout,img_perslice, pptfile,'size','A4','doc',doc,...
        'crop',0,'gap',[0 0 ],'columns',2,'xy',[0 1.5 ],'wh',[ 10.5 nan],...
        'title',titlem,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
        'text',tx,'tfs',6,'txy',[0 28],'tbgcol',[1 1 1]);
end






%% #################################################
% mricron
% display volumes in mricron

% show single volume in mricron
rmricron([], fullfile('F:\data8\2024_Stefanie_ORC1_24h_postMCAO\templates','AVGT.nii'))


% show overlay (gray-matter onto AVGT) 
pa='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\templates';
f1=fullfile(pa,'AVGT.nii');
f2=fullfile(pa,'_b1grey.nii');
rmricron([], f1,f2,'actc');

%% #################################################
% mricron 
% splot-slices coronal

z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
z.view           = 'coronal';                                                                      % % view: {coronal/sagittal/axial}
z.slices         = [80  95  110  125  140  155  170  185  200];                                    % % slices to plot
z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}
z.OverslicePct   = [0];                                                                            % % percent overlapp slices
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
z.outdir         = fullfile(pwd,'slice1');                                                         % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricron   = [1];                                                                            % % close mricron afterwards
xplotslices_mricron(0,z);
  
%% #################################################
% mricron 
% splot-8 slices ov ANO-atlas, coronal
pa_study='F:\data8\2024_Stefanie_ORC1_24h_postMCAO'
pa_temp =fullfile(pa_study,'templates')
F1=fullfile(pa_temp,'AVGT.nii')
F2=fullfile(pa_temp,'ANO.nii')
z=[];
z.bg_image       = F1;                        % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = F2       % % get one/more images to separately overlay onto bg_image
z.view           = 'coronal';                 % % view: {coronal/sagittal/axial}
z.slices         = ['n8'];                     % % slices to plot
z.bg_clim        = [0  200];                  % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                % % overlay-image: colormap
z.ovl_clim       = [0  1000];                 % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [50];                      % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
z.orthoview      = [1];                       % % show orthogonal plot where brain is sliced; {0|1}
z.slicelabel     = [1];                       % % add slice label  (rounded mm); {0|1}
z.OverslicePct   = [0];                       % % percent overlapp slices
z.cbar_label     = 'ID';                      % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                            % % colorbar: fonsize
z.cbar_fcol      = [1  1  1];                       % % colorbar: fontcolor a color
z.outdir         = fullfile(pa_study,'__test1');    % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'ANO';                           % % PPT-filename
z.plotdir_suffix = '_plots';                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricron   = [1];                             % % close mricron afterwards
xplotslices_mricron(0,z);

%% #################################################
% mricroGL-sliceplots
% using mricroGL to save slices

%% EXAMPLE: coronal ===============================================

z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [2];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cutR50n6';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view2';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);


%% EXAMPLE: sagittal ===============================================
z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [2];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cutR50n6';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view2';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);
%
%% EXAMPLE: axial ===============================================
z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [3];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cut50n8';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view3';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);

%% #################################################
% mricroGL-orthoview/plots
% using mricroGL to save orthoview-plots
% EXAMPLE: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
% make images & powerpoint
%% ====================================================================================
% EXAMPLE-1: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
% make images & powerpoint, force single-row
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z);

%% ====================================================================================
% EXAMPLE-2: as before but use two rows (z.png_SingleRow=[0])
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                                                                                                                                                                                      
z.png_SingleRow  = [0];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z); 

%% ====================================================================================
% EXAMPLE-3: as EXAMPLE-2 but show create only coronar slices (z.png_views= [1];  )
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1];                                                                            % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z); 

%% ============================================================
% EXAMPLE-4: plot ANO-atlas at specifix mm-coordinates
%% ============================================================
z=[];                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\templates\AVGT.nii';        % % background image; if empty, "AVGT.nii" from the template folder is used                              
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\templates\ANO.nii' };     % % overlay one or more images onto bg_image                                                             
z.bg_clim        = [50  200];                                                     % % background image intensity limits [min,max]; [nan nan] = auto                                        
z.ovl_clim       = [0  1000];                                                     % % overlay image intensity limits [min,max]; [nan nan] = auto                                           
z.ovl_cmap       = 'actc.clut';                                                   % % overlay colormap                                                                                     
z.opacity        = [50];                                                          % % overlay opacity (0-100)                                                                              
z.linewidth      = [5];                                                           % % crosshair line width                                                                                 
z.linecolor      = [1  1  1];                                                     % % crosshair color (RGB, range 0-1)                                                                     
z.xyzmm          = [0 -7 -4; 0 -4 -4 ; 0 -1 -2; 0 2 -2 ]                         % % XYZ coordinates in mm (n×3 matrix)                                                                                                                                                                                                          
z.png_SingleRow  = [1];                                                           % % force all views into one row; {0|1}                                                                  
z.png_views      = [1  2  3];                                                     % % views to keep; default: [1 2 3] (coronal, sagittal, axial)                                           
z.cbar_label     = 'atlas IDs';                                                   % % colorbar label; empty = no label                                                                     
z.cbar_fs        = [12];                                                          % % colorbar font size                                                                                   
z.cbar_fontname  = 'Helvetica';                                                   % % colorbar font name (e.g., Arial, Consolas, Helvetica)                                                
z.cbar_fcol      = [1  1  1];                                                     % % colorbar font color                                                                                  
z.outdir         = 'F:\data8\mricron_makeSlices_plots\results2';                % % output directory; if empty, plots/PPT are stored in "ovl_images" DIR                                 
z.ppt_filename   = 'ABA_atlas';                                                       % % PowerPoint filename                                                                                  
z.plotdir_suffix = '_plots';                                                      % % subdirectory for PNG files (in "outdir"), named as "ppt_filename" + "plotdir_suffix"                 
z.makePPT        = [1];                                                           % % create PowerPoint with images and info                                                               
z.sort           = 'coordinate';                                                  % % sort PNGs in PowerPoint by {coordinate|image}                                                        
z.closeMricroGL  = [1];                                                           % % close MRIcroGL after execution                                                                       
z.mricroGL       = '';                                                            % % <optional> specify full path to MRIcroGL exe/app if not auto-detected (SEE HELP)                     
xplotortho_mricrogl(0,z);  


%% #################################################
% orthoslice
% display volumes using orthoslice

  %% =============================================================
  %% display 3 images using orthoslice
  %% =============================================================
 files =  { 'F:\data8\ortoslice_tests\AVGT.nii' 	
      'F:\data8\ortoslice_tests\_b1grey.nii' 
      'F:\data8\ortoslice_tests\_b2white.nii' 	
      'F:\data8\ortoslice_tests\_b3csf.nii' };
  r=[];   
  r.ce=[-1 -1 -1.5]  ;%  center/cursor-location
  r.alpha       =  [0.5  0.5  0.5  0.7];  %transparency                                                                                                                                 
  r.axolperc    =  [7];   %overlapp ov axis in percent                                                                                                                                                  
  r.bgcol       =  '0.93725 0.86667 0.86667'; %background-color                                                                                                                             
  r.cbarvisible =  [0  1  1  1  1]; % colorbar-visibility                                                                                                                                       
  r.clim        =  [0     495.24 ;  0.7 1 ;0.7 1 ; 0.4  1 ];                                                                                                                                     
  r.cmap        =  { 'gray' 	'Oranges' 	'Greens' 	'@yellow' };  %colormaps                                                                                                           
  r.cursorcol   =  [1 1 1 ]; %cursor-color                                                                                                                                                
  r.cursorwidth =  [1];    %cursor-width                                                                                                                                                  
  r.figwidth    =  [780];  %figure width in pixels                                                                                                                                                
  r.mbarlabel   =  { '' 	'GM' 	'WM' 	'csf' };  %cbar-labels 
  r.labelcol    =  [1 0 1]; %cbar-color
  r.mcbarfs     =  [11];      %cbar-fontsize                                                                                                                                             
  r.mcbarpos    =  [-70  20  10  100];   % last c-bar-location relativ to right-fig-size (pixels)                                                                                                                                  
  r.visible     =  [1  1  1  1]; %bg/overlay-images-visible                                                                                                                                          
  orthoslice(files,r);
  
  %% =============================================================
  %% display 3 images using orthoslice  from current study
  %% =============================================================
  global an
  pa_study=fileparts(an.datpath)
  pa_temp=fullfile(pa_study,'templates')
 files =  { fullfile(pa_temp,'AVGT.nii'    )	
            fullfile(pa_temp,'_b1grey.nii' )
            fullfile(pa_temp,'_b2white.nii')	
            fullfile(pa_temp,'_b3csf.nii'  ) };
  r=[];   
  r.ce=[-1 -1 -1.5]  ;%  center/cursor-location
  r.alpha       =  [0.5  0.5  0.5  0.7];  %transparency                                                                                                                                 
  r.axolperc    =  [7];   %overlapp ov axis in percent                                                                                                                                                  
  r.bgcol       =  '0.93725 0.86667 0.86667'; %background-color                                                                                                                             
  r.cbarvisible =  [0  1  1  1  1]; % colorbar-visibility                                                                                                                                       
  r.clim        =  [0     495.24 ;  0.7 1 ;0.7 1 ; 0.4  1 ];                                                                                                                                     
  r.cmap        =  { 'gray' 	'Oranges' 	'Greens' 	'@yellow' };  %colormaps                                                                                                           
  r.cursorcol   =  [1 1 1 ]; %cursor-color                                                                                                                                                
  r.cursorwidth =  [1];    %cursor-width                                                                                                                                                  
  r.figwidth    =  [780];  %figure width in pixels                                                                                                                                                
  r.mbarlabel   =  { '' 	'GM' 	'WM' 	'csf' };  %cbar-labels 
  r.labelcol    =  [1 0 1]; %cbar-color
  r.mcbarfs     =  [11];      %cbar-fontsize                                                                                                                                             
  r.mcbarpos    =  [-70  20  10  100];   % last c-bar-location relativ to right-fig-size (pixels)                                                                                                                                  
  r.visible     =  [1  1  1  1]; %bg/overlay-images-visible                                                                                                                                          
  orthoslice(files,r)
  
%% #################################################
% mricroGL-colorize brain region from atlas
% save as  png, create ppt-file

%% =============================================================
%% EXAMPLE-1: ANTx-projext is already loaded: no need to specify 'bg_image','bg_mask' and 'atlas_image', because
%% the study's template files are used : 'AVGT.nii', 'AVGTmask.nii' and 'ANO.nii'  
%% For regions specified in 'regions' create PNG-files and a PPT-file,region-color is red
%% =============================================================
    z=[];                                                                                                                                                                                                                                   
    z.bg_image     = '';                    % % background image, if empty, "AVGT.nii" from template-folder is used                                                                                
    z.bg_mask      = '';                    % % image mask, if empty, "AVGTmask.nii" from template-folder is used                                                                                  
    z.atlas_image  = '';                    % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used                                                                                    
    z.regions      = { 'L_Prelimbic area'   % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")                  
                       'R_Prelimbic area' 
                       'L_Orbital area' 
                       'Caudoputamen'};                                                                                                                                                                                                  
    z.bg_clim      = [50  200];             % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                                                                  
    z.ovl_cmap     = '1red.clut';           % % overlay-image: colormap                                                                                                                            
    z.ovl_clim     = [0  1];                % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                                                                     
    z.opacity      = [30];                  % % overlay opacity range: 0-100                                                                                                                       
    z.linewidth    = [5];                   % % linewidth of slice cutting line                                                                                                                    
    z.linecolor    = [0  0  0];             % % line color of slice cutting line                                                                                                                   
    z.outdir       = '';                    % % output-dir, if empty plots/ppt-file in current directory                                                                                           
    z.subdir       = 'test5';               % % subdir in outdir, contains created png-files, can be <empty>                                                                                       
    z.ppt_filename = 'regions';             % % PPT-filename                                                                                                                                       
    z.cleanup      = [1];                   % % remove temporarily created NIFTIs,{0|1}                                                                                                            
    z.makePPT      = [1];                   % % make Powerpoint-file with image and infos, {0|1}                                                                                                   
    z.mricroGL     = '';                    % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                                             
    xcolorregion_mricrogl(0,z);
%% =============================================================
%% EXAMPLE-2: ANTx-projext is already loaded, SHORTEST VERSION
% Antx-project must be loaded before, create colored regions using default parameter
% output (png-images and pptfile) is saved in <study>\results\regioncolorized
% using default AVGT.nii, AVGTmask and ANO.nii from template folder
% Although not explicitely occuring in the corresponding region-file 'ANO.xlsx', we can separately display the
% left and right hemispheric regions when adding the prefix 'L_' and 'R_' in the region-names (example:
% 'L_Primary motor area' or 'R_Primary motor area')
%% =============================================================    
    z=[];
    z.regions= {...
        'L_Primary motor area'        % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
        'R_Primary motor area'
        'Primary motor area'
        'L_Caudoputamen'
        'R_Caudoputamen'
        'Caudoputamen'
        };                                                                                                                                                                            % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)
    xcolorregion_mricrogl(0,z);

  
%% =============================================================
%% EXAMPLE-3: independent from loaded ANTx-project 
%% =============================================================
    pastudy='F:\data8\sarah\sarah_plots_26jan24';
    z=[];
    z.bg_image     = fullfile(pastudy,'templates','AVGT.nii');        % % background image, if empty, "AVGT.nii" from template-folder is used
    z.bg_mask      = fullfile(pastudy,'templates','AVGTmask.nii');    % % image mask, if empty, "AVGTmask.nii" from template-folder is used
    z.atlas_image  = fullfile(pastudy,'templates','ANO.nii');         % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used
    z.regions      = {'Caudoputamen' 'L_Primary motor area'}          % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
    z.bg_clim      = [NaN  NaN];                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
    z.ovl_cmap     = '3blue.clut';                                    % % overlay-image: colormap
    z.ovl_clim     = [NaN  NaN];                                      % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
    z.opacity      = [40];                                            % % overlay opacity range: 0-100
    z.linewidth    = [1];                                             % % linewidth of slice cutting line
    z.linecolor    = [0  0  0];                                       % % line color of slice cutting line
    z.outdir       = fullfile(pastudy,'results','___colRegsTest')     % % output-dir, if empty plots/ppt-file in current directory
    z.subdir       = '';                                              % % subdir in outdir, contains created png-files, can be <empty>
    z.ppt_filename = 'test2';                                         % % PPT-filename
    z.cleanup      = [1];                                             % % remove temporarily created NIFTIs,{0|1}
    z.makePPT      = [1];                                             % % make Powerpoint-file with image and infos, {0|1}
    z.mricroGL     = '';                                              % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)
    xcolorregion_mricrogl(0,z);

%% #################################################
% mricroGL-diverse
% run mricrogl-script (explicit mricrogl-path)
system(['"C:\paulprogramme\MRIcroGL\MRIcroGL.exe" "F:\data9\susanne_imghdr\my_xt2_nosaveBPM.py" &'])

% run mricrogl-script (automatically obtain mricrogl-path)
system(['"' xplotslices_mricrogl('path_mricrogl') '" "F:\data9\susanne_imghdr\my_xt2_nosaveBPM.py" &'])


% ==============================================
%%  overlay mask onto BG-image, and rotate 
% ===============================================
F1='F:\data9\susanne_imghdr\20250313MO_SCI_Ko01_sag.nii'  ;%BG-image
F2='F:\data9\susanne_imghdr\mask.nii'                     ;%FG-image
cm={
 'import gl'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 'ktime= 60'
 'ksteps= 72'
 'gl.resetdefaults()'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 'gl.minmax(0, 0.5,2.6)'
 'gl.minmax(1, 0, 2)'
 'gl.opacity(1,90)'
 'gl.colorname(1,''actc'')'
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 '#gl.cameradistance(1)'
 'for x in range(1, ksteps):'
 '  #gl.azimuthelevation(160+(x*5),30)'
 '  gl.azimuthelevation(90,120+(x*5))'
 '  gl.wait(ktime)'
 '#adjust color scheme to show kidneys'
 'gl.colorname(0,''bone'')'
 'gl.shadername(''Tomography'')'
 '#gl.shaderadjust(''brighten'', 1.2)'
 'for x in range(1, ksteps):'
 '  gl.azimuthelevation(160+(x*5),30)'
 '  gl.wait(ktime)'
 'gl.scriptformvisible(1)'
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" &']);
system(cmd );

%% #################################################
% mricroGL-diverse
% make animated GIF using mricroGL
%% ===============================================

F1    ='F:\data9\susanne_imghdr\20250313MO_SCI_Ko01_sag.nii'; %BG-image
F2    ='F:\data9\susanne_imghdr\mask.nii'                   ; %FG-image
rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only 
ktime = 60; %pause between rotations [ms]
ksteps= 10; %rotational steps
outdir='F:\data9\susanne_imghdr\img4';  %PATH WERE IMAGES ARE STORED (used to created animGIF)
dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
outputGIF = fullfile('F:\data9\susanne_imghdr', 'rotation_movie4.gif'); %animGIF: filename
delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
% ===============================================
cm={
 ['ktime=  ' num2str(ktime)]
 ['ksteps= ' num2str(ksteps)]
 ['dosave='  num2str(dosave)]
 ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
 ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
 'import gl'
 'import os'
 'import glob'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 'gl.minmax(0, 0.5,2.6)'
 'gl.minmax(1, 0, 2)'
 'gl.opacity(1,90)'
 'gl.colorname(1,''actc'')'
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 'if not os.path.exists(output_folder):'
 '    os.makedirs(output_folder)'
 'else:'
 '    if dosave==1:'
 '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
 'x=0'
 'if rotations[0] == 1:'
 '   for x in range(1, ksteps):'
 '       gl.azimuthelevation(90,120+(x*5))'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
 ''
 'if rotations[1] == 1:'
 '   for y in range(1, ksteps):'
 '       gl.azimuthelevation(160+(y*5),30)'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
 ''
 'gl.scriptformvisible(1)'
 'gl.wait(2000)'
 'gl.quit()' 
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
system(cmd );
showinfo2(['imagePath:'],outdir);
% ====[SAVE AS NIMATED GIF]===========================================
imgFiles = dir(fullfile(outdir, '*.png'));
if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
for k = 1:length(imgFiles)
    imgPath = fullfile(outdir, imgFiles{k});
    [img, cmap] = imread(imgPath);
    img = imresize(img, 0.5);
    if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
         [imgInd, cmap] = rgb2ind(img, 128);
    else
        imgInd = img; cmap = gray(256); % already grayscale
    end
    if k == 1 % First frame — create the GIF file
        imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else % Append subsequent frames
        imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end
fprintf('Animated GIF saved to:\n%s\n', outputGIF);
showinfo2(['gif:'],outputGIF); 

%% #################################################
% mricroGL-diverse
% make several animated GIFs using mricroGL
% animated gifs created from all '.*Ko.*_mask.nii'-files in folder 'path_files'
path_files='H:\Daten-2\Imaging\AG_Eickholt_SCI\segmentation'
[fi] = spm_select('FPList',path_files,'.*Ko.*_mask.nii')
fi=cellstr(fi);
for i=1:length(fi)
    name0=fi{i};
    [~,namemask]=fileparts(name0);
    name=strrep(namemask,'_mask','');
    
    F1=fullfile(path_files,[name '.nii']);%BG-image
    F2=fi{i};%FG-image
    rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only
    ktime = 30; %pause between rotations [ms]
    ksteps= 100; %rotational steps
    outdir=fullfile(path_files,['imgs_' name])  ;  %PATH WERE IMAGES ARE STORED (used to created animGIF)
    dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
    outputGIF = fullfile(path_files,['movie_' name '.gif' ]); %animGIF: filename
    delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
    % ===============================================
    cm={
        ['ktime=  ' num2str(ktime)]
        ['ksteps= ' num2str(ksteps)]
        ['dosave='  num2str(dosave)]
        ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
        ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
        'import gl'
        'import os'
        'import glob'
        'gl.resetdefaults()'
        'gl.scriptformvisible(0)'
        ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
        ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
        'gl.minmax(0, 0.5,2.6)'
        'gl.minmax(1, 0, 2)'
        'gl.opacity(1,90)'
        'gl.colorname(1,''actc'')'
        'gl.colorbarposition(0)'
        'gl.backcolor(255,255,255)'
        'if not os.path.exists(output_folder):'
        '    os.makedirs(output_folder)'
        'else:'
        '    if dosave==1:'
        '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
        'x=0'
        'if rotations[0] == 1:'
        '   for x in range(1, ksteps):'
        '       gl.azimuthelevation(90,120+(x*5))'
        '       gl.wait(ktime)'
        '       if dosave==1:'
        '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
        ''
        'if rotations[1] == 1:'
        '   for y in range(1, ksteps):'
        '       gl.azimuthelevation(160+(y*5),30)'
        '       gl.wait(ktime)'
        '       if dosave==1:'
        '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
        ''
        'gl.scriptformvisible(1)'
        'gl.wait(2000)'
        'gl.quit()'
        };
    cm2=strjoin(cm,'^');
    exefile=xplotslices_mricrogl('path_mricrogl')
    % exefile='D:\software\MRIcroGL\MRIcroGL\MRIcroGL.exe'
    cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
    system(cmd );
    showinfo2(['imagePath:'],outdir);
    % ====[SAVE AS NIMATED GIF]===========================================
    imgFiles = dir(fullfile(outdir, '*.png'));
    if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
    imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
    for k = 1:length(imgFiles)
        imgPath = fullfile(outdir, imgFiles{k});
        [img, cmap] = imread(imgPath);
        img = imresize(img, 0.5);
        if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
            [imgInd, cmap] = rgb2ind(img, 128);
        else
            imgInd = img; cmap = gray(256); % already grayscale
        end
        if k == 1 % First frame — create the GIF file
            imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
        else % Append subsequent frames
            imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
        end
    end
    fprintf('Animated GIF saved to:\n%s\n', outputGIF);
    showinfo2(['gif:'],outputGIF);
    
end




%% #################################################
% mricroGL-diverse
% make animated GIF (AVGT & ANO) using mricroGL
F1    ='F:\data9\region_redering_mricrogl\templates\x_t2.nii'; %BG-image
F2    ='F:\data9\region_redering_mricrogl\templates\ANO.nii' ; %FG-image
rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only 
ktime = 60; %pause between rotations [ms]
ksteps= 10; %rotational steps
outdir='F:\data9\susanne_imghdr\img5';  %PATH WERE IMAGES ARE STORED (used to created animGIF)
dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
outputGIF = fullfile('F:\data9\susanne_imghdr', 'rotation_movie5.gif'); %animGIF: filename
delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
% ===============================================
cm={
 ['ktime=  ' num2str(ktime)]
 ['ksteps= ' num2str(ksteps)]
 ['dosave='  num2str(dosave)]
 ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
 ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
 'import gl'
 'import os'
 'import glob'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 
 'gl.minmax(0, 10,100)'
 'gl.minmax(1, 1, 1000)'
 'gl.opacity(  0, 100)'
 'gl.opacity(  1 ,90)'
 'gl.colorname(1 ,''actc'')'
 'gl.cameradistance(2)'
 'gl.colorname(0,''bone'')'
 '#gl.shadername(''Tomography'')'
 '#gl.shaderadjust(''brighten'', 3)'
 'gl.cutout(0,0,0,.5,1,1)'
 'gl.colorname(1,''actc'')'
 
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 'if not os.path.exists(output_folder):'
 '    os.makedirs(output_folder)'
 'else:'
 '    if dosave==1:'
 '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
 'x=0'
 'if rotations[0] == 1:'
 '   for x in range(1, ksteps):'
 '       gl.azimuthelevation(90,120+(x*5))'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
 ''
 'if rotations[1] == 1:'
 '   for y in range(1, ksteps):'
 '       gl.azimuthelevation(160+(y*5),30)'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
 ''
 'gl.scriptformvisible(1)'
 'gl.wait(2000)'
 'gl.quit()' 
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
system(cmd );
showinfo2(['imagePath:'],outdir);
% ====[SAVE AS NIMATED GIF]===========================================
imgFiles = dir(fullfile(outdir, '*.png'));
if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
for k = 1:length(imgFiles)
    imgPath = fullfile(outdir, imgFiles{k});
    [img, cmap] = imread(imgPath);
    img = imresize(img, 0.5);
    if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
         [imgInd, cmap] = rgb2ind(img, 128);
    else
        imgInd = img; cmap = gray(256); % already grayscale
    end
    if k == 1 % First frame — create the GIF file
        imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else % Append subsequent frames
        imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end
fprintf('Animated GIF saved to:\n%s\n', outputGIF);
showinfo2(['gif:'],outputGIF); 











   
 
%% #################################################
% chisquaretest
% xstat_chisquarePlot:  example-1
pares='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\results\stat_x_c_angiomask_blk5_p0.05';
z=[];
z.numOverlays   = [2];        % % number of overlays, {1 or 2}
z.dir           = pares;      % % folder with chisquareResults
z.suffix        = '_ovl2';    % % add suffix to powerpoint to not overwrite previous files
z.alpha         = [1  .8  1];  % % transparency [images:1,2,3]
z.cbarvisible   = [0  1  0];  % % colorbar visibility  [images:1,2,3]
z.clim          = [0 200; 1 3; 0 3];      % % color-limits, [images:1,2,3]:[[min max];[min max];[min max]]
% z.cmap          = { 'gray','autumnFLIP','isoLime'  };  % % colormaps, [images:1,2,3] see: dummyColormap
% z.cmap          = { 'gray' 	'autumnFLIP' 	'isoFuchsia' }; 
% z.cmap          = { 'gray' 	'winter' 	'isoFuchsia' };   
z.cmap          = { 'gray' 	'winterFLIP' 	'isoFuchsia' }; 
z.mbarlabel     = { '' 'OR' '' };                % % cbarlabels, [images:1,2,3]
z.mcbarticks    = [2];                           % % number of ticks in barlabel
z.visible       = [1  1  1];                     % % image visibility,[images:1,2,3]
z.usebrainmask  = [0];                           % % use brainMask to get rid off outerbrain activity {0|1}
xstat_chisquarePlot(0,z);


%% #################################################
% chisquaretest
% run chisquaretest

% xstat_chisquare:  example-1
pastudy   ='F:\data8\2024_Stefanie_ORC1_24h_postMCAO';
groupfile =fullfile(pastudy, 'animal_groups_24hMCAO.xlsx');
% pacode    =fullfile(pastudy,'chisquare_test')
% addpath(pacode)

cd(pastudy)
antcb('close')
ant; antcb('load',fullfile(pastudy,'proj.m')); drawnow;
antcb('close')

file='x_c_angiomask.nii'

% blocksize x hthresh
pars=[...
%     5   0.001
%     0   0.001
    5   0.05
%     0   0.05
    ];

for i=1:size(pars,1)
    z=[];
    z.image        = file;                                                                       % % binary image to make statistic on
    z.groupfile    = groupfile;     % % groupfile(excelfile) with animmals and group
    z.atlas        = '';                                                                                           % % nifti-atlas, if empty the default template-atlas is used
    z.outdir       = '';                                                                                           % % output-dir, if empty the default results-folder is used as upper dir
    z.suffix       = '';                                                                                           % % add suffix-string to final output-dir
    z.useUnionMask = [1];                                                                                          % % [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
    z.hthresh      = pars(i,2);%[0.05];                                                                                      % % high-threshold such as 0.05
    z.blocksize    = pars(i,1) ;%blocksize(i);%[5];                                                                                          % % if value above 0 use block-shuffling approach (less conservative), must be integer
    z.nperms       = [100];                                                                                        % % number of permutations
    z.CLpeak_num   = [3];                                                                                          % % number of clusterPeaks to report
    z.CLpeak_dist  = [2];                                                                                          % % minum distance between clusterPeaks
    z.OR_cmap      = 'isoFuchsia'%'YlOrRd_flip';                                                                                % % cmap of signif. OddsRatio-map for plotting
    z.OR_range     = [1  5];                                                                                      % % intensity range of OddsRatio-map for plotting
    z.isparfor     = [1];	% use pararellel processing {0|1} ; default: [1] 
    plot_uncorrected=1;
    xstat_chisquare(0,z);
end



% ==============================================
%%   using angiomask
% ===============================================
cf;clear
pastudy='H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\d7_postMCAO';
groupfile=fullfile(pastudy,'animal_groups_d7.xlsx');
 
cd(pastudy);
antcb('close');
ant; antcb('load',fullfile(pastudy,'proj_d7.m')); drawnow;
antcb('close');
% blocksize x hthresh
pars=[...
    5   0.001
    0   0.001
    5   0.05
    0   0.05
    ];
for i=1:size(pars,1)
    z=[];
    z.image        = { 'x_c_angiomask.nii' };                                                                       % % binary image to make statistic on
    z.groupfile    = groupfile;     % % groupfile(excelfile) with animmals and group
    z.atlas        = '';                                                                                           % % nifti-atlas, if empty the default template-atlas is used
    z.outdir       = '';                                                                                           % % output-dir, if empty the default results-folder is used as upper dir
    z.suffix       = '_v2';                                                                                           % % add suffix-string to final output-dir
    z.useUnionMask = [1];                                                                                          % % [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
    z.hthresh      = pars(i,2);%[0.05];                                                                                      % % high-threshold such as 0.05
    z.blocksize    = pars(i,1) ;%blocksize(i);%[5];                                                                                          % % if value above 0 use block-shuffling approach (less conservative), must be integer
    z.nperms       = [5000];                                                                                        % % number of permutations
    z.isparfor             = [1];             % % use pararellel processing {0|1} ; default: [1]
    % %  ---CLUSTER-PEAKS---
    z.CLpeak_num           = [3];             % % number of peaks per signif. cluster to report
    z.CLpeak_dist          = [2];             % % minimum distance between clusterPeaks
    % ---PLOT OPTIONS---
    z.OR_cmap              = 'isoFuchsia';    % % used colormap of overlay, ie. to plot the OddsRatio-map
    z.OR_range             = [1  5];          % % intensity range of OddsRatio-map for plotting
    z.plot_uncorrected     = [1];             % % additionally create+display the uncorrected image
    z.OR_cmap_uncorrected  = 'winterFLIP';    % % uncorrected image: colormap of overlay for plotting
    z.OR_range_uncorrected = [1  5];          % % uncorrected image: intensity range for plotting
    xstat_chisquare(0,z); 
end


%% #################################################
%  registration to standardspace
% estimation

%   EXAMPLES to batch the warping step
%   [1]: perform all tasks, using the mouse dirs as defined in "dirs"-cell array, automatic preregistration
   xwarp3('batch','mdirs',dirs,'task',[1:4],'autoreg',1)
%   [2] same.., but onle mice previously highlighted in the ANT listbox will be processed
   xwarp3('batch','task',[1:4],'autoreg',1)
%   [3] USING PARALLEL-COMPUTATION
   xwarp3('batch','task',[1:2],'autoreg',1,'parfor',1)
 
%% #################################################
%  registration to standardspace
% apply transformation to other images:

%   doelastix(direction, [], files  ,interpx ,'local' );
%   arg1:  direction .. which direction to warp [1]to allen [-1] to native space
%   arg2:  voxresolution--> leave it empty
%   arg3: files --> cell with nifti files to warp
%   arg4: interpolation order [0,1,2,3] for NN, linear, 2nd order, 3rd order (spline)
%   arg5: apply additional rigid body transformation (calculated beforehand) ..use 'local' to use the local parameters
%   example:
      files={'O:\harms1\harms3_lesionfill\dat\s20150505SM02_1_x_x\lesion_64.nii'
      'O:\harms1\harms3_lesionfill\dat\s20150505SM03_1_x_x\lesion_64.nii'
      'O:\harms1\harms3_lesionfill\dat\s20150505SM09_1_x_x\lesion_64.nii'}
      doelastix(1   , [],      files                      ,3 ,'local' );


  
%% #################################################
% MPM
% Bruker import

% DISPLAY all Bruker-files from 'raw'-folder
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);

% DISPLAY a list of Bruker files where the protocol name contains 'MPM_3D
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol','MPM_3D'},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

% IMPORT Bruker files where the protocol name contains 'MPM_3D
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','MPM_3D'},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

%% #################################################
% Baydiff
% copy files, transform to SS, region-wise parameter readout

 
 
%% ==============================================
%% copy Baydiff-invovo/exvivo images from source folders to target folders
%% than transform those images from targetfolders to standardspace(SS), 
%% than do region-wise parameter readout (via xgetlabels4)
%% ===============================================
 
%% ==============================================
%%  [1] setup
%% ===============================================
cf;clear all
v.updir='H:\Daten-2\Imaging\AG_Paul_Brandt' ;% upper dir with several studies
cd(v.updir);
 
 
t1={...%'subdir-source'   'subdir'-target'                  'proj-file in target'
    'baydiff_exvivo'      '2024_Cuprizone_Exvivo_MPM_DTI'   'proj_2024_exvivo.m'
    'baydiff_invivo'      '2024_Cuprizone_invivo_MPM_DTI'   'proj_invivo.m'
    };
 
%% ==============================================
%%  [2] COPY BAYDIFF-DATA
%% ===============================================
cprintf('*[1 .5 1]',['copying files'  '\n']);
for k=1:size(t1,1)
    paS=fullfile(v.updir, t1{k,1} ,'dat'   );
    paT=fullfile(v.updir, t1{k,2} ,'dat'   );
    
    [dirs] = spm_select('List',paS,'dir'); dS=cellstr(dirs);
    [dirs] = spm_select('List',paT,'dir'); dT=cellstr(dirs);
    
    if sum(ismember(dS,dT))~=length(dS)
        error('some anmimals are missing');
    end
    for j=1:length(dS)
        disp(['...copying:[' num2str(k) '-' num2str(j) '/' num2str(length(dS))  '] ' dS{j}]);
        mdirS=fullfile( paS,  dS{j});
        mdirT=fullfile( paT,  dS{j});
        [fi] = spm_select('List',mdirS,'^r_\d\d\d__.*.nii');
        fi=cellstr(fi);
        fS=stradd(fi, [mdirS filesep],1);
        fT=stradd(fi, [mdirT filesep],1);
        copyfilem(fS,fT);
        showinfo2('check targetDIr: ' ,mdirT);
    end
end
 
%% ==============================================
%%  [3] load project and warp images to SS
%% ===============================================
cprintf('*[1 .5 1]',['trafo files to SS'  '\n']);
fi={
    'r_001__Dax_intra.nii'
    'r_002__Dax_extra.nii'
    'r_003__Drad_extra.nii'
    'r_004__v_intra.nii'
    'r_005__v_csf.nii'
    'r_006__v_extra.nii'
    'r_007__microADC.nii'
    'r_008__microAx.nii'
    'r_009__microRd.nii'
    'r_010__microFA.nii'
    'r_011__p2.nii'
    'r_012__SNR.nii'
    };
for k=1:size(t1,1)
    pastudy= fullfile(v.updir, t1{k,2}) ;
    projfile=fullfile(pastudy, t1{k,3} );
    cd(pastudy);
    antcb('load',projfile);
    antcb('selectdirs','all'); %for all animals
    doelastix(1   , [],      fi   ,1 ,'local' ); % warp to SS (arg1 is [1]) arg-4 is [1]..using linear interpolation
end
%% ==============================================
%%  [4] get anatomical labels
%% ===============================================
cprintf('*[1 .5 1]',['get anatomical labels'  '\n']);
 
z=[];
z.files        ='##';% #FILLED LATER                                                                    % % files used for calculation
z.masks        ='';     % % <optional> corresponding maskfiles (order is irrelevant)or mask from templates folder                                                                                     % % The hemispher mask in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
z.atlas        = 'ANO.nii';                                                                                  % % select atlas here (default: ANO.nii), atlas has to be the standard space atlas
z.space        = 'standard';                                                                                 % % use images from "standard","native" or "other" space
z.hemisphere   = 'both';                                                                                     % % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
z.threshold    = '';                                                                                         % % lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask
z.fileNameOut  = '##'% #FILLED LATER                                                                         % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name
z.format       = '.xlsx';                                                                                    % % select output-format: default: ".xlsx"; other formats: ".mat" ".csv" ".csv|tab" "csv|space"  "csv|bar"  ".txt|tab" ".txt|space",".txt|bar"                                                                                       % % max of values (intensities) within anatomical region
 
fi2=stradd(fi,'x_',1); % using files in SS  
for k=1:size(t1,1)
    pastudy= fullfile(v.updir, t1{k,2}) ;
    projfile=fullfile(pastudy, t1{k,3} );
    cd(pastudy);
    antcb('load',projfile);
    antcb('selectdirs','all'); %for all animals
    %antcb('selectdirs',1); %for first animal only
    for i=1:length(fi2)
        z.files        =fi2{i} ;
        [~, shortname] =fileparts(z.files);
        outfile        =[ 'AL_baydiff_' shortname ];
        z.fileNameOut  =outfile;
        xgetlabels4(0,z);
    end
end
 
 




%% #################################################
% regexp
% Pattern to match required files and exclude '_UNCOR_'
pattern = '^p(?!.*_UNCOR_).*\.png$';

% Get a list of all files in the directory
files = dir(fullfile(folder, '*.png'));

% Filter files based on the regular expression
filtered_files = {files.name};
matches = regexp(filtered_files, pattern, 'match');

%% #################################################
% cellfun
% remove paths from fullpath-filelist
filenameOnlyList = cellfun(@(x) x(max(strfind(x, filesep))+1:end), cellList, 'UniformOutput', false);

%  check which elements of B contain any element of A as a substring (not exact match) 
A = {'cat', 'dog'};
B = {'bigdoghouse', 'wildcat123', 'mouse'};
matches = cellfun(@(b) any(cellfun(@(a) ~isempty(strfind(b,a)), A)), B);
B(matches)   % {'bigdoghouse', 'wildcat123'}



%% #################################################
% forgotten things
% error: create hyperlink to a specific line (use in function/scripts not directly in cmd-window)

%save below lines to function or saved script before running!
st= dbstack('-completenames');  % full stack info
stf=st(find(strcmp({st.name},mfilename)));
disp(['ERROR in file: <a href="matlab:gol(' num2str(stf.line) ')">' [ stf.name '.m  >> line-' num2str(stf.line) '' ] '</a>']);

%% #################################################
% forgotten things
% check space of drive   

% path='x:\'
path='c:\'
 f = java.io.File(path);
    freeBytes = f.getUsableSpace();     % Query usable space (in bytes)
    freeGB=freeBytes / 2^30      % Convert to GB
 
%% #################################################
% forgotten things
% diverse

% remove path of multiple files (incl. subfolders/misc.paths)    
% files_only = cellfun(@(f) [fileparts(f) ''], files, 'uni', 0);    
files_only = cellfun(@(f) f(regexp(f,'[^\\/]+$'):end), files, 'uni', 0);
%% #################################################
% windows-10 server
% logoff session by ID

% 1. List all active sessions
  qwinsta
% 2. Use the session ID (here ID is 2) from the previous output
  logoff 2

% 3. if [2.] is not working, forcefully reset (terminate) a session)
  rwinsta 2
  









