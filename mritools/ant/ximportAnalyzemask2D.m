

%% #b import 2D-Analyze ('*.obj')-file , i.e. a single slice
% function to import 2D (single slice) Analyze ('*.obj')-file and convert to NIFTI
% example: ANALYZE software was used tp draw  mask  --> mask should  be converted back to NIFTI
% 
%
% #lk  ___PARAMETER___
% 'objFiles'       select 2D-Analyze(obj)-files to import  (from another folder)
%                  -obj files should only represent a single 2D-slice
%                  -obj files are located in the same external folder, 
%                  -each obj-filename should at least partially contain the name of the respective animal directory
%                     EXAMPLE of external folder with OBJ-files:
%                          'F:\data8\import_2D-OBJfile\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG.obj'
%                          'F:\data8\import_2D-OBJfile\adc_lesion\2023117PM_hypothermia_2DG_PME000652_2DG.obj'
%                          'F:\data8\import_2D-OBJfile\adc_lesion\20231109PM_hypothermia_2DG_PME000647_2DG.obj'
% 
% 'refIMG'          Use header from this NIFTI-file for obj-to-NIFTI-conversion.
%                   The header of this NIFTI-file replaces the header of the imported obj-file
%                   The NIFTI-file used as 'refIMG' must be located in the studiy's animal-folder
% 
% 'sliceNum'        specify sliceNumber to insert the 2d plane 
%                   The 2D-obj-slice will be poitioned at the sliceNum (3rd-DIM) with reference to 'refIMG'
%             option: (a) numeric value: example: 'sliceNum'=[1] ..slice will be inserted as 1st slice in the new 3D-volume
%                                                 'sliceNum'=[2] ..slice will be inserted as 2nd slice in the new 3D-volume
%                     (b) 'sliceNum'='img/hdr': it is assumed that the obj-folder also contain 'img/hdr'-file-Pairs with 
%                     the same or nearly similar names as the obj-files, which where used as input for the ANALYZE-software.
%                     The proper 'sliceNum' is extracted from the 'img/hdr'-file-Pairs-filename, if the 'img/hdr'-file-Pair 
%                     contains the used slice-number as last suffix in the filename
%                      example: The obj-folder additionlly contains img/hdr-files, the suffix of the  'img/hdr'-files indicate 
%                               the slicenumber (22 / 23, respectively) for the two obj-files
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG.obj'
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG_slice22.hdr'
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG_slice22.img'
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\2023117PM_hypothermia_2DG_PME000652_2DG.obj'
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\2023117PM_hypothermia_2DG_PME000652_2DG_slice23.hdr'
%                                  'F:\data8\import_2D-OBJfile\adc_lesion\2023117PM_hypothermia_2DG_PME000652_2DG_slice23.img'
%                   all other slices will contain zeros!
% 
% 'renamestring'    (optional) enter a new filename for the new NIFTI-file 
% 
% #lk  ___EXAMPLES___
%% ==============================================
%%  IMPORT 2D-OBJ-FILES (ADC)
%%  HERE THE img/hdr-file is used to determine the sliceNUmber
%% ===============================================
% z=[];                                                                                                                                                                                                
% z.objFiles     = { 'F:\data8\import_2D-OBJfile\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG.obj'       % % select Analyze(obj)-files to import                                                
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231019PM_hypothermia_2DG_PME000642_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231103PM_hypothermia_2DG_PME000644_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231106PM_hypothermia_2DG_PME000645_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231106PM_hypothermia_2DG_PME000646_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231109PM_hypothermia_2DG_PME000647_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231109PM_hypothermia_2DG_PME000648_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231117PM_hypothermia_2DG_PME000651_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231128PM_hypothermia_2DG_PME000653_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231128PM_hypothermia_2DG_PME000654_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\20231129PM_hypothermia_2DG_PME000655_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\adc_lesion\2023117PM_hypothermia_2DG_PME000652_2DG.obj' };                                                                                            
% z.refIMG       = { 'adc.nii' };                                                                               % % use header from this file. This header replaces the header of the imported obj-file
% z.sliceNum     = 'img/hdr';                                                                                   % % specify sliceNumber to insert the 2d plane                                         
% z.renamestring = 'ADCmask.nii';                                                                               % % (optional) enter a new filename for the new file                                   
% ximportAnalyzemask2D(0,z);  
% 
%% ==============================================
%%  IMPORT 2D-OBJ-FILES (CBF)
%%  sliceNumber is 1
%% ===============================================
% 
% z=[];                                                                                                                                                                                                
% z.objFiles     = { 'F:\data8\import_2D-OBJfile\cbf_lesion\20230925PM_hypothermia_2DG_PME000639_2DG.obj'       % % select Analyze(obj)-files to import                                                
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231019PM_hypothermia_2DG_PME000642_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231103PM_hypothermia_2DG_PME000644_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231106PM_hypothermia_2DG_PME000645_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231106PM_hypothermia_2DG_PME000646_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231109PM_hypothermia_2DG_PME000647_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231109PM_hypothermia_2DG_PME000648_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231117PM_hypothermia_2DG_PME000651_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231128PM_hypothermia_2DG_PME000653_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231128PM_hypothermia_2DG_PME000654_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\20231129PM_hypothermia_2DG_PME000655_2DG.obj'                                                                                              
%                    'F:\data8\import_2D-OBJfile\cbf_lesion\2023117PM_hypothermia_2DG_PME000652_2DG.obj' };                                                                                            
% z.refIMG       = { 'cbf.nii' };                                                                               % % use header from this file. This header replaces the header of the imported obj-file
% z.sliceNum     = [1];                                                                                         % % specify sliceNumber to insert the 2d plane                                         
% z.renamestring = 'CBFmask.nii';                                                                               % % (optional) enter a new filename for the new file                                   
% ximportAnalyzemask2D(0,z);




% ==============================================
%%
% ===============================================

function ximportAnalyzemask2D(showgui,x)





% ==============================================
%%   inputs
% ===============================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
% if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
% if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

global an
padat=an.datpath;
mainDir=fileparts(padat);
mdirs=antcb('getallsubjects');

% ==============================================
%%   get obj-files
% ===============================================
% 
% ==============================================
%%   preps
% ===============================================
[tb tbh v]=antcb('getuniquefiles',mdirs);

% ==============================================
%%     PARAMETER-gui
% ===============================================
sliceNUm_options={...
    'use slicenumber from img/hdr-file (same location as obj-file) "img/hdr"' 'img/hdr';...
    'slice-1 [1]' 1;...
    'slice-2 [2]' 2;...
    'slice-3 [3]' 3};
p={...                        '' ''
    'objFiles'        ''           'select 2D-Analyze(obj)-files to import'                              {@getObjFiles,mainDir}
    'refIMG'          't2.nii'     'use header from this file. This header replaces the header of the imported obj-file'        {@selector2,tb,tbh,'out','col-1','selection','single'}
    'sliceNum'        1            'specify sliceNumber to insert the 2d plane (see help/options via left icon)'   sliceNUm_options
    'renamestring'    'test.nii'   '(optional) enter a new filename for the new NIFTI-file'             {'test.nii' 'ADCmask.nii' 'CBFmask.nii' '_mask.nii'}
    
    %     'reorienttype'   [1]       'select the reorientation type (rec. for mouse space data; click right icon for a preview)'                              {@dumx,tb,ff}
    %     'reorienttype2'  [0]       'or select for more complex reorientation type (rec. for Allen space data;click right icon for a preview)'          {@dumx2,tb,[]}
    };

p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .3 .8 .3 ],'title',[ 'Import Analyze 2D-objfile [' mfilename '.m]'],'info',{@uhelp,[ mfilename '.m']}  );
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


% ==============================================
%%   BATCH
% ===============================================
xmakebatch(z,p, mfilename);


% ==============================================
%% PROC
% ===============================================
cprintf('*[0 0 1]', [ ' [Import 2D-Analyze(obj)-file]' '\n']);

z.mdirs=mdirs;
z=objFiles_toDirs(z);    %%  proc-1: assign obj-files to animal-dirs

if ischar(z.sliceNum) && ~isempty(cell2mat(regexpi(z.sliceNum,{'img' ,'hdr'})))
    z=objFiles_to_ImgHdr(z);    %%  proc-2: assign obj-files to IMG/HDR
end

for i=1:size(z.file2dirAssign,1)
    proc_convertObjfile(z,i) 
end
cprintf('*[0 0 1]', ['Done\n']);



    

% ==============================================
%%   subs
% ===============================================
function proc_convertObjfile(z,idx)
%% ===============================================

% f1='H:\Daten-2\Imaging\AG_Mergenthaler\2DG_CEST_Manuskript\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG.obj'
% [ha a]=obj2nifti(f1);
% f2='H:\Daten-2\Imaging\AG_Mergenthaler\2DG_CEST_Manuskript\adc_lesion\20230925PM_hypothermia_2DG_PME000639_2DG_slice22.img'
% f3=fullfile('H:\Daten-2\Imaging\AG_Mergenthaler\2DG_CEST_Manuskript\dat\20230925PM_hypothermia_2DG_PME000639_2DG','adc.nii');
% % [hb b]=rgetnii(f2);

f1        = z.file2dirAssign{idx,1}; %obj-file
animaldir = z.file2dirAssign{idx,2}; %animalDir
if ischar(z.sliceNum) && ~isempty(cell2mat(regexpi(z.sliceNum,{'img' ,'hdr'})))
    if isempty(z.file2Hdr_Assign)
        disp([ 'Img/Hdr-file not assigned']);
        return
    end
    f2=    z.file2Hdr_Assign{find(strcmp(z.file2Hdr_Assign(:,1), f1)),2 };
    [pax namex extx]=fileparts(f2);
    sliceNum=str2num(regexprep(namex(max(strfind(namex,'_')):end),'\D',''));
else
    if ischar(z.sliceNum);  
        sliceNum=str2num(z.sliceNum);
    else
        sliceNum=       (z.sliceNum);
    end  
end

f3=fullfile(animaldir,char(z.refIMG) );
% ===========[check errors]======================
isErr=0;
if exist(f3)~=2; 
    disp([ 'refIMG ["' z.refIMG  '"] not found for: ' animaldir]);
    isErr=1;
end
if exist(f1)~=2; 
    disp([ 'Obj-file ["' f1  '"] not found ']);
    isErr=1;
end
if isErr==1;
   return 
end

% ==============================================
%   proc
% ===============================================
% [ha a]=rgetnii(f3);
% a=a(:,:,:,volNum);
ha=spm_vol(f3);
hb=ha(1);
[hm m]=obj2nifti(f1);

b=zeros((hb.dim));
b(:,:,sliceNum)=m;
% ====write file===========================================

[~,nameout,~]=fileparts(f1);
if ~isempty(z.renamestring)
   [~,nameout,~]=fileparts(z.renamestring); 
end
f4=fullfile(animaldir,[  nameout  '.nii' ]);
rsavenii(f4,hb,b);


showinfo2(['new NIFTI [' nameout '.nii] '],f3,f4,1);

%% ===============================================







%% ===============================================




function z=objFiles_to_ImgHdr(z)
%% ==========[ obj-to-dir-assignment]=====================================
z.file2Hdr_Assign=[];

if isempty(z.file2dirAssign)
   disp('...no object files assigned to animal-dirs...proc cancelled');
   return
end

% ===============================================
objFiles=z.file2dirAssign(:,1)
[pamainObj,nameObj, extObj] =fileparts2(objFiles);
objfiles=cellfun(@(a,b){[ a b]}, nameObj, extObj);
% ===============================================

[files] = spm_select('FPList',pamainObj{1},'.*.hdr');
files=cellstr(files);
[pamain_hdr,files_hdr, ext_hdr ]    =fileparts2(files);
files_hdr=cellfun(@(a,b){[ a b]}, files_hdr, ext_hdr);

o=gui_assign(objfiles ,files_hdr,'ndirs',1,'matchtype',3,'wait',1,...
    'hdr_in','obj-files','hdr_out','IMG/HDR-files',...
    ...
    'figtitle','[step-2] Assign oBJfiles to IMG/HDR-files');

if isempty(o); disp('..proc cancelled...'); return; end
t1=stradd(o(:,1),[pamainObj{1}  filesep],[1]);
t2=stradd(o(:,2),[pamain_hdr{1} filesep],[1]);
z.file2Hdr_Assign=[t1 t2];
%% ===============================================


function z=objFiles_toDirs(z)
%% ==========[ obj-to-dir-assignment]=====================================
z.file2dirAssign=[];

[pamainObj,nameObj, extObj] =fileparts2(z.objFiles);
objfiles=cellfun(@(a,b){[ a b]}, nameObj, extObj);
[pamainDat,animalDir, ]    =fileparts2(z.mdirs);

o=gui_assign(objfiles ,animalDir,'ndirs',1,'matchtype',3,'wait',1,...
    'hdr_in','obj-files','hdr_out','animalDirs',...
    ...
    'figtitle','[step-1] Assign oBJfiles to animalDirs');

if isempty(o); disp('..proc cancelled...'); return; end
t1=stradd(o(:,1),[pamainObj{1} filesep],[1]);
t2=stradd(o(:,2),[pamainDat{1} filesep],[1]);
z.file2dirAssign=[t1 t2];

function o=getObjFiles(mainDir)
%% ==========[ gui:obj-file selection]=====================================

o='';
msg={'IMPORT ANALYZE (*.obj) FILES (lesionmasks)'
    'select *.obj-files (MASK files from ANALZYESOFTWARE) to import'
    '..these files will be converted to NIFTIs and assignd to the best-matching mouse-folders'
    '____HOWTO'
    '1) if obj-files are located in one folder --> navigate to the folder and select the files or...'
    '2) <optional> select [fileSTR] to select the filter for the obj-files'
    '.. the filter-field must contain ".obj$" to find the *.obj-files  '
    '3) select [Rec] to recursively select all obj-files'
    '4) <optional> deselect unwanted files from lower panel'
    };
try
    if isfield(x,'obj_files')
        fi2imp= x.obj_files;
        if ischar(fi2imp); fi2imp=cellstr(fi2imp); end
    end
end

if exist('fi2imp')==0
    %     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
    [fi2imp,sts] = cfg_getfile2(inf,'any',msg,[],mainDir,'.obj$');
end
if isempty(char(fi2imp)); return ; end
o=fi2imp ;





















