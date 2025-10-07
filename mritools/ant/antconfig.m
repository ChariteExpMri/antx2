
% #ok [ANTCONFIG.m] configure paramters
% 
% #kl  *** SETTINGS-FILE ***
% The paramter are stored in the project-file (matlab m-file): The default name is 'proj.m', but
% you can chose a suitable name. Ideally, store the project-file in a study-folder which can contain
% the raw-data (dicom/Bruker raw data). 
% Later, the study-folder will contain a 'dat'-folder which is the main animal folder. This folder 
% will contain the animals subfolder. Each animal with one subfolder. 
% Please provide enough storage capacity. The study-folder will become large. Also provide the proper 
% access rights (linux!) for writing/deleting files.
% ___________________________________________________________________________________________________
% #b project: #n Project-name. No need to specify. String can be arbibtrarily chosen.
% ___________________________________________________________________________________________________
% #b datpath: #n Path of the 'dat'-folder. The 'dat'-folder contains the animal-data of the study.
%               -ideally the 'dat-folder' is located at the same hierarchical level as the project-file 'proj.m'
%               -Do not store raw-data (dicom/Bruker raw data)  here. 
% ___________________________________________________________________________________________________
% #b voxsize: #n Final voxel-resolution used for the template and images transformed to standard space.
% ___________________________________________________________________________________________________
% #b BiasFieldCor: #n [0,1] use dirty BiasFieldCorrectio of "t2.nii" prior to skull-stripping. 
%               #r Please avoid to use this option. #n In most cases the skullstripping/registration works. 
%               If [1] the biasFieldCorrection will change the input image 't2.nii' permanently.
%               Sometimes, registration will fail because of inhomogenious image intensities. This will,
%              result in skull-stripping (problem with bias-filed/lesion/artecact...). In this case, try
%              another [usePriorskullstrip]-option  & another [orientelxParamfile]-paramterfile ("trafoeuler5_MutualInfo.txt")
%              before using this [BiasFieldCor] finction   
%          #g * default: [0]
% ___________________________________________________________________________________________________
% #b usePriorskullstrip:  #n skull strip "t2.nii". This option is used for rigid registration, only.
%         Here,  the image "_msk.nii" is created based on 't2.nii' 
%         #r '_msk.nii' is not binary!, rather the brain-masked 't2.nii'-image (outer brain values are ideally 0).
% options [0] : 't2.nii' is already skullstripped (exvivo brain) 
%         [1] : create '_msk.nii' based on pcnn3d-tool. #b real skull-stripping 
%              #g default: [1]
%         [2] : '_msk.nii' is a copy of 't2.nii' (no changes)
%                -EXVIVO-data: appriach for already scullstriped data
%         [3] : create '_msk.nii' based on otsu-method (3 clusters). 
%               -This option is prone to errors.
%               -method can be useful for exvivo skullstripped brains preserved in the stuff that produces 
%               high-contrast in the MR-image
%         [5] : same as [3] but using 2-otsu clusters 
%               might work better than [3]
%         [6] : EXVIVO-data in TUBE with high-contrast solution (e.g. PBS) + posthoc skullstripping (pcnn3d)
%         [4] : '_msk.nii' is basically 't2.nii' but background is removed to accellerate segmentation
%               *use this option for exvivo skullstripped brain preserved in the stuff that produces 
%               high-contrast in the MR-image. 
%         [8] : universal approach: use for invivo & exvivo brains, with/without skullstripping, 
%                         works also with brains placed in phosphate-buffered saline (PBS)
%        [-1] : brain masked image '_msk.nii' is assumed to exist in the path
%               use this option if you have created a brain-masked 't2.nii' via other tools
% #g NOTE: The aim of '_msk.nii' file is to obtain a rough but sufficient rigid registration. Accordingly,
% #g don't use this file as 'proper' brain mask for later analysis
% #g for [3]&[4]: For successful registration select the  parameterfile #k "trafoeuler5_MutualInfo.txt" for "orientelxParamfile"-parameter 
% ___________________________________________________________________________________________________
% #b orientType #n : Type of orientation. 
%                This parameter defines the orientation of the animal in the MR bore relative 
%                to the used template. The proper [orientType] is necessary to have a
%                good initial guess for image registration.
%      [orientType] can be specified as #r [1] numeric value #n or as #r [2] as string
%      [1] numeric value: is an index  refering to a table of pre-defined rotation angles (pitch,yaw,roll)
%         *USE #g 'examine orientation' from animals listbox to specify a suitable orientation (index)
%      [2] string: can be used to transmit 3 rotation angles (pitch,yaw,roll). Here we use a string 
%         argument to allow readable PI-fractions  example: 'pi/2 pi 0'
%         *USE #g 'get orientation via 3-point selection' from animals listbox to specify a suitable orientation (string)
%      #g * default: [1]
% ___________________________________________________________________________________________________
% #b orientelxParamfile: #n RIGID PARAMETER FILE #n This file is used to perform rigid-body/Euler transformation.
%           #g * default: #k 'path...\...\trafoeuler5.txt'
%           -try also : #k 'path...\...\trafoeuler5_MutualInfo.txt'
%           * Use "trafoeuler5_MutualInfo.txt" if the rigide registration fails :high contrast; exvivo brains
%             preserved in the stuff that produces high-contrast in the MR-image; artefacts; other modality
% ___________________________________________________________________________________________________
% #b x.wa.elxMaskApproach: #n Approach used for non-linear transformation. The approach is only used to 
%           calculation of a transfomation paramters. Click #g 'ICON' #n for more details.
%           #g * default: [1]
% ___________________________________________________________________________________________________
% #b elxParamfile: #n ELASTIX parameter files (cell-array)  with paths for affine+nonlinear parameter file 
%         -Contains two files: 1st parameter file: affine registration 
%                              2nd parameter file: non-linear warping
%           #g * default: {'f:\antx2\mritools\elastix\paramfiles\Par0025affine.txt' 'f:\antx2\mritools\elastix\paramfiles\Par0033bspline_EM2.txt' }
% ___________________________________________________________________________________________________
% #b cleanup: #n delete temporary files [0,1]
% ___________________________________________________________________________________________________
% #b usePCT: #n use parallel-computation 
%           [0] no ; [1] SPMD; [2] parfor
%           #g * default: [2] 
%           -Parallel Computing toolbox must be provided
%           -currently, support only for the initalization/coregistration/segmentation & warping pipeline     
% ___________________________________________________________________________________________________
% #b refpath: #n Reference Path of the template
%           #r - the reference path has to be specified! Please download the respective animal template
%           #r   from google-drive. See Menu: Extras/get templates from google drive
% ___________________________________________________________________________________________________
% #b species: #n used animal species
%          #r normally, You don't need to change this field. [species] is updated when the template's 
%          #r reference path is selected
% 
% ___________________________________________________________________________________________________
% #b IMAGES : #n images to transform ('tf_t2','tf_avg'..etc). Please do not change these parameters 
% 
% 
% 

function varargout=antconfig(showgui,varargin)
varargout{1}=[];
varargout{2}=[];
% varargin : with parameter-pairs
% currently:
%    'parameter'  'default'  ...load default parameter (i.e. overrides global "an" struct )
%        otherwise use an struct
%      'savecb' 'yes'/'no'   ...show save checkbox, default is 'yes'
% antconfig(1,'parameter','default','savecb','no')
% antconfig(1,'parameter','default')
% antconfig(1)





if  exist('showgui')~=1 ; showgui=1; end

%% additional parameters
para=struct();
if ~isempty(varargin)
    para=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
end

if isfield(para,'parameter') && strcmp(getfield(para,'parameter'),'default') ==1
    an=struct();
else
    global an
end




[pant r]=   antpath;
%% __datapath__
datapath=fullfile(pwd,'dat');
spaceInPath=strfind(datapath,' ');
if ~isempty(spaceInPath)
    %clc;
    cprintf('*[1 0 1]','___ ERROR ___\n');
    msg=[ 'Space-characters in study-path not allowd: '  ];
    cprintf('*[1 0 1]',msg); fprintf([ strrep(datapath,[filesep],[filesep filesep]) '\n' ]);
    msg2=[' space(s) found (n=' num2str(length(spaceInPath)) '): ' ];
    msg2=[repmat(' ',[1 length(msg)-length(msg2)])  msg2];
    msgspacepos=repmat(' ',[1 length(datapath)]);
    msgspacepos(spaceInPath)='^';
    
   cprintf(' [0 0 0]',[msg2 ]);  cprintf('*[1 0 0]',[ msgspacepos '\n' ]);
   cprintf('*[.75 .75 0]',['Please remove spaces from studypath and try again! [process aborted]' '\n'   ]);
   return

end

%% =====[skullStrippingMethos]==========================================
meth_skullstrip=...
    {...
    '[1]: create "_msk.nii" using pcnn3d-tool (default)'                                   [1]
    '[3]: create "_msk.nii" unsing otsu-method (3 clusters)'                               [3]
    '[5]: create "_msk.nii" unsing otsu-method (2 clusters)'                               [5]
    '[6]: EXVIVO & high-contrast tube (PBS): approach1: "deTube"+pcnn3d)'                  [6]
    '[7]: EXVIVO & high-contrast tube (PBS): approach2: "deTube"+pcnn3d)'                  [7]
    '[8]: UNIVERSAL: – in/ex vivo, ±skullstrip, ±PBS'                                      [8]
    '                                                               '  [1]
    '[0]: "t2.nii" is already skullstripped (exvivo brain) '                               [0]
    '[2]: create "_msk.nii" as copy of "t2.nii"  (for allready skullstripped brains)'      [2]
    '[4]: "_msk.nii" is "t2.nii" but background is removed to accellerate segmentation'    [4]
    '[-1]: brain masked "_msk.nii" is assumed to exist in path'                            [-1]
    };
%              #g default: [1]
%         [2] : '_msk.nii' is a copy of 't2.nii' (no changes)
%                -EXVIVO-data: appriach for already scullstriped data
%         [3] : create '_msk.nii' based on otsu-method (3 clusters). 
%               -This option is prone to errors.
%               -method can be useful for exvivo skullstripped brains preserved in the stuff that produces 
%               high-contrast in the MR-image
%         [5] : same as [3] but using 2-otsu clusters 
%               might work better than [3]
%         [6] : EXVIVO-data in TUBE with high-contrast solution (e.g. PBS) + posthoc skullstripping (pcnn3d)
%         [4] : '_msk.nii' is basically 't2.nii' but background is removed to accellerate segmentation
%               *use this option for exvivo skullstripped brain preserved in the stuff that produces 
%               high-contrast in the MR-image. 
%        [-1] : brain masked image '_msk.nii' is assumed to exist in the path

% options [0] : 't2.nii' is already skullstripped (exvivo brain) 
%         [1] : create '_msk.nii' based on pcnn3d-tool. #b real skull-stripping 
%              #g default: [1]
%         [2] : '_msk.nii' is a copy of 't2.nii' (no changes)
%                -EXVIVO-data: appriach for already scullstriped data
%         [3] : create '_msk.nii' based on otsu-method (3 clusters). 
%               -This option is prone to errors.
%               -method can be useful for exvivo skullstripped brains preserved in the stuff that produces 
%               high-contrast in the MR-image
%         [5] : same as [3] but using 2-otsu clusters 
%               might work better than [3]
%         [6] : EXVIVO-data in TUBE with high-contrast solution (e.g. PBS) + posthoc skullstripping (pcnn3d)
%         [4] : '_msk.nii' is basically 't2.nii' but background is removed to accellerate segmentation
%               *use this option for exvivo skullstripped brain preserved in the stuff that produces 
%               high-contrast in the MR-image. 
%        [-1] : brain masked image '_msk.nii' is assumed to exist in the path

%% ======[orientType]=========================================

 [arg,rot]=evalc(['' 'findrotation2' '']);
 orientype=[cellfun(@(a,b){['[' num2str(a) '] which is [' b  ']']}, num2cell([1:size(rot,1)]') ,rot)];
 orientype(:,2)=num2cell([1:size(orientype,1)])';
%% ============[]===================================


%% ===============================================


p={...
    'inf99'      '*** CONFIGURATION PARAMETERS   ***              '                         '' ''
    'inf100'     '==================================='                          '' ''
   % 'inf1'       '% DEFAULTS             '  '' ''
    'project'    'NEW PROJECT'            'PROJECT NAME (arbitrary tag)'    ''
    'datpath'    fullfile(pwd,'dat')      'studie''s datapath, MUST BE be specified, and named "dat", such as "c:\b\study1\dat" '  'd'
    'voxsize'     [.07 .07 .07]           'voxel size (default for Allen Mouse: [.07 .07 .07])'    cellfun(@(a) {repmat(a,1,3)},   {' .01' ' .03' ' .05' ' .07'}')
    
    'inf2'   '_______________________________________________________________________________________________' '' ''
    
    'wa.BiasFieldCor'        [0]         'perform initial bias field correction (only needed if initial skullstripping failes) ' 'b'
    'wa.usePriorskullstrip'  [1]         'priori skullstripping method (used for automatic registration)' meth_skullstrip ;% {1 0 2 3 4 -1}
    'wa.fastSegment'         [1]         'faster segmentation by cutting boundaries of t2.nii [0,1]' 'b'
    
    
    
    %'wa.orientRefimage'     2                          'RefImage for rough Reorientation: [0]grayMatter and use old functions),[1]grayMatter,[2]"_sample2.nii2 (T2w-image in AllenSpace)'  num2cell(0:2)
    'wa.orientType'          1     'reorientation index (see "examine orientation" from animal listbox context menu; see: help findrotation2,  ) to rougly match inputVol and "AllenSpace-template" (example [1]Berlin,[5]Munich/Freiburg)' orientype %{@selectorientation }
    'wa.orientelxParamfile'  which('trafoeuler5.txt')   'single Parameter file for rough Rigid-body registration; default: "trafoeuler2.txt"; use trafoeuler3.txt for large dislocations ' {@paramfilesRigid }
    
    
    %%'is used use compartments,(3)use t2w/AVGT as moving/fixed image,(4)heavy lesions(5)used use BFC-t2w/AVGT'
    'wa.elxMaskApproach'       1         'used registration approach..click icon for further information  '   {@setapproach} 
    %'wa.autoreg'             1         'automatic registration (0:manual, 1:automatic)' 'b'
    'wa.elxParamfile'     { which('Par0025affine.txt');  which('Par0033bspline_EM2.txt')}' ...
                                        'ELASTIX Parameterfiles, fullpath of either Par0025affine.txt+Par0033bspline_EM2.txt  or par_affine038CD1.txt+par_bspline033CD1.txt'  {@paramfiles} % 'mf'
    
 
    
     %'wa.create_gwc'       1         'create overlay gray-white-csf-image (recommended for visualization) ' 'b'
     %'wa.create_anopcol'   1         'create pseudocolor anotation file (recommended for visualization) ' 'b'
    'wa.cleanup'            1         'delete unused files in folder' 'b'
    'wa.usePCT'             2         'use Parallel Computing toolbox (0:no/1:SPMD/2:parfor) ' {1,2,3}
   
    'inf31'   '_________TEMPLATE_________________________________________________________________________' '' ''

    'wa.refpath'     r.refpa         'PATH of the used reference system (such as "O:\anttemplates\mouse_spmmouse" for "mouse_spmmouse" )'  { @referencefolder }
    'wa.species'     'mouse'         'animal species to investigate {mouse or rat}'  {'mouse' 'rat' 'etruscianshrew'}
    
%     'wa.refTPM'      r.refTPM    'c1/c2/c3-compartiments (reference)' ,'mf'
%     'wa.ano'         r.ano       'reference anotation-image' 'f'
%     'wa.avg'         r.avg       'reference structural image' 'f'
%     'wa.fib'         r.fib       'reference fiber image' 'f'
    %'wa.refsample'  r.refsample       'a sample image in reference space' 'f'

    'inf34'   '_________OTHERS________________________________________________________________' '' ''
    'wa.resizeFactor'   1      'use a smaller value such as 0.9 if animal brain is much smaller than the template; default: 1.0 '   {1 .9 .85 1.1}
    
%     
%     'inf34'   '_________VOLUMES TO TRANSFORM________________________________________________________________' '' ''
%     'wa.tf_t2'                  1        'create "x_t2.nii" (mouse-t2-image)                         in TEMPLATESPACE (forwardTrafo)'     'b'
%     'wa.tf_avg'                 1        'create "ix_AVGT.nii" (template-structural-image)                 in MOUSESPACE (inverseTrafo)'     'b'
% 
%     'wa.tf_ano'                 1        'create "ix_ANO.nii" (template-label-image)                       in MOUSESPACE (inverseTrafo)'     'b'
%    % 'wa.tf_anopcol'            0        'create "ix_ANOpcol.nii" (template-pseudocolor-label-image label) in MOUSESPACE (inverseTrafo)'     'b'
%    % 'wa.tf_refc1'              0        'create "ix_refIMG.nii" (template-grayMatter-image)               in MOUSESPACE (inverseTrafo)'     'b'
%     'wa.tf_c1'                  0        'create "x_c1t2.nii" (mouse-grayMatter-image)               in TEMPLATESPACE (forwardTrafo)'     'b'
%     'wa.tf_c2'                  0        'create "x_c2t2.nii" (mouse-whiteMatter-image)              in TEMPLATESPACE (forwardTrafo)'     'b'
%     'wa.tf_c3'                  0        'create "x_c3t2.nii" (mouse-CSF-image)                      in TEMPLATESPACE (forwardTrafo)'     'b'
%     'wa.tf_c1c2mask'            0        'create "x_c1c2mask.nii" (mouse-gray+whiteMatterMask-image) in TEMPLATESPACE (forwardTrafo)'     'b'
   };


p2=paramadd(p,an);%add/replace parameter

if showgui==1
    
    
         hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
        %figpos=[0.1688    0.3000    0.8073    0.6111];
        figpos=[0.1688    0.3611    0.8073    0.5511];
        [m z a params]=paramgui(p2,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',figpos,...
            'title',['SETTINGS [' mfilename '.m]'],'pb1string','OK','info',hlp);%,'cb1string',cb1string);
        
%          hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
%     [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .5 ],...
%         'title','LABELING','info',hlp);
        
   if isempty(m)
        
%            [m z a params]=paramgui(p2,'uiwait',0,'close',1,'editorpos',[.03 0 1 1],'figpos',[0 0 .1 .1],...
%             'title','SETTINGS','pb1string','OK','info',hlp);%,'cb1string',cb1string);
        return
    end
    

else
    z=[];
    for i=1:size(p2,1)
        eval(['z.' p2{i,1} '=' 'p2{' num2str(i) ',2};']);
    end
    
end

%% aditional variables

try
    z.templatepath=fullfile(fileparts(z.datpath),'templates');
    z.ls=struct2list(z);
end

    % ==============================================
    %% sanity check: remove ending fileseps
    % =============================================== 
    % 
   
   
    try; z.datpath         =regexprep(z.datpath     ,['\' filesep '$'],''); end
    try; z.templatepath    =regexprep(z.templatepath,['\' filesep '$'],''); end
    try; z.wa.refpath      =regexprep(z.wa.refpath  ,['\' filesep '$'],''); end
    
    try
        mb=strsplit(m,char(10))';
        il=regexpi2(mb,'^x.datpath');
        mb(il)=strrep(mb(il)    ,[z.datpath filesep], z.datpath );
        
        
        il=regexpi2(mb,'^x.wa.refpath');
        mb(il)=strrep(mb(il)    ,[z.wa.refpath filesep], z.wa.refpath );
        m=strjoin(mb,char(10));
    end

try;
    z.mdirs=an.mdirs ;
end
%---get configfile
try
    ix=regexpi2(an.ls,'an.configfile');
    configfile_str=an.ls(ix);
end

%...........
%% ==== create an-struct and ls ========================



an=z;
%set Listbox-2
ls=an.ls;
ls(regexpi2(ls,'^\s*z.inf\d'))=[];
ls(regexpi2(ls,'^\s*z.mdirs'))=[];
ls=regexprep(ls,'^\s*z.','');
try
ls=[ls; configfile_str];    
end
try
 eval(configfile_str{1});   
end

%% ===============================================

set(findobj(findobj('tag','ant'),'tag','lb2'),'string',ls);


try
    varargout{1}=m;
end

try
    varargout{2}=z;
end
try
    varargout{3}=a;
end
try
    varargout{4}=params;
end

if showgui==0
   varargout{length(varargout)+1}=p; % third arg-out
end

function paramfiles(li,lih)
% function paramfiles(e,e2)
% paramgui('setdata','x.wa.elxParamfile',{'ee' 'eeed' 'fgffd'})
he=[];
pap=fileparts(which('Par0025affine.txt'));
msg='select 1x affine and 1x bspline parameterFile (in that order!)';
[t,sts] = spm_select(inf,'any',msg,'',pap,'.*.txt','');
if isempty(t); return; end
t=cellstr(t);
paramgui('setdata','x.wa.elxParamfile',t)
return

function he=paramfilesRigid(li,lih)
% function paramfiles(e,e2)
% paramgui('setdata','x.wa.elxParamfile',{'ee' 'eeed' 'fgffd'})
he=[];
pap=fileparts(which('trafoeuler2.txt'));
msg='select one Parameter file for rough Rigid-body registration; default: "trafoeuler2.txt"';
[t,sts] = spm_select(inf,'any',msg,'',pap,'.*.txt','');
if isempty(t); return; end
% t=cellstr(t);
% [s ss]=paramgui('getdata')
% paramgui('setdata','x.wa.orientelxParamfile',[t ' % rem'])
he=t;
return


function selectorientation(e,e2)
he=[];
if 0
    [arg,rot]=evalc(['' 'findrotation2' '']);
    tb=[ rot];
    id=selector2(tb,{ 'rotation'},'selection','single','title','orientation');
    
    
    if isempty(id);
        id=-1;
    end
    if id==-1;
        [e x2]=paramgui('getdata','x.wa.orientType');
        paramgui('setdata','x.wa.orientType',x2.wa.orientType);
    else
        paramgui('setdata','x.wa.orientType',id);
    end
end


px=antcb('getsubjects');
px=px(1);
refimg=fullfile(fileparts(fileparts(px{1})),'templates','AVGT.nii');
if exist(refimg)~=2
    warning('refImage in templates-folder not found..please select an appropriate "AVGT.nii" as reference image');
    [t,sts] = spm_select(1,'image','select reference image (example: "AVGT.nii")',[],pwd,'.*.nii',1);
    refimg=strtok(t,',');
end

img=fullfile(px{1},'t2.nii');
if exist(img)~=2
    warning('"t2.nii" image not found not found..please select another image');
    [t,sts] = spm_select(1,'image','select image (example "t2.nii") ',[],px{i},'.*.nii',1);
    img=strtok(t,',');
end

[~,name   ]=fileparts(px{1});
[~,nameref]=fileparts(refimg);
infox=['select orientation with best match between [' name '] and [' nameref ']'];
% [id rotstring]=getorientation('ref',refimg,'img',img,'info', name);
[id rotstring]=getorientation('ref',refimg,'img',img,'info', infox,'mode',1,'wait',1,'disp',1);

% disp([ name ' rotTable-ID is [' num2str(id)  '] ..which is  "' rotstring  '"']);
[arg,rot]=evalc(['' 'findrotation2' '']);
if (id)  > size(rot,1)
    outval=rotstring;
else
    outval=id;
end

 paramgui('setdata','x.wa.orientType',outval);       
        
        



function referencefolder(li,lih)
he=[];


[ref ]=getReferencePath;

if isempty(ref); return; end


paramgui('setdata','x.wa.refpath',ref.path);
paramgui('setdata','x.wa.species',ref.species);


% removed fields: [tpm,fib,avg,ano ]
%  tpm={fullfile(ref.path,'_b1grey.nii' )
%      fullfile(ref.path,'_b2white.nii' )
%      fullfile(ref.path,'_b3csf.nii' ) };
%  paramgui('setdata','x.wa.refTPM',tpm);
%  
%  
%  paramgui('setdata','x.wa.ano', fullfile(ref.path,'ANO.nii'));
%  paramgui('setdata','x.wa.avg', fullfile(ref.path,'AVGT.nii'));
%  if exist(fullfile(ref.path,'FIBT.nii'))==2
%      paramgui('setdata','x.wa.fib', fullfile(ref.path,'FIBT.nii'));
%  else
%      paramgui('setdata','x.wa.fib', '');
%  end
 
 
 if isfield(ref,'voxsize')
     paramgui('setdata','x.voxsize',ref.voxsize);
 end
 
 
 
 
 
 
 





