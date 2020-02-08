
% #ok [ANTCONFIG.m] configure paramters
% ..has to be written..


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


p={...
    'inf99'      '*** CONFIGURATION PARAMETERS   ***              '                         '' ''
    'inf100'     '==================================='                          '' ''
   % 'inf1'       '% DEFAULTS             '  '' ''
    'project'    'NEW PROJECT'            'PROJECT NAME (arbitrary tag)'    ''
    'datpath'    fullfile(pwd,'dat')      'studie''s datapath, MUST BE be specified, and named "dat", such as "c:\b\study1\dat" '  'd'
    'voxsize'     [.07 .07 .07]           'voxel size (default for Allen Mouse: [.07 .07 .07])'    cellfun(@(a) {repmat(a,1,3)},   {' .01' ' .03' ' .05' ' .07'}')
    
    'inf2'   '_______________________________________________________________________________________________' '' ''
    
    'wa.BiasFieldCor'        [0]         'perform initial bias field correction (only needed if initial skullstripping failes) ' 'b'
    'wa.usePriorskullstrip'  [1]         'use a priori skullstripping (used for automatic registration)'  'b'
    'wa.fastSegment'         [1]         'faster segmentation by cutting boundaries of t2.nii [0,1]' 'b'
    
    
    
    %'wa.orientRefimage'     2                          'RefImage for rough Reorientation: [0]grayMatter and use old functions),[1]grayMatter,[2]"_sample2.nii2 (T2w-image in AllenSpace)'  num2cell(0:2)
    'wa.orientType'          1                          'index from ReorientationTable (see: help findrotation2) to rougly match inputVol and "AllenSpace-template" (example [1]Berlin,[5]Munich/Freiburg)' {@selectorientation }
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

    
    
    'inf34'   '_________VOLUMES TO TRANSFORM________________________________________________________________' '' ''
    'wa.tf_t2'                  1        'create "x_t2.nii" (mouse-t2-image)                         in TEMPLATESPACE (forwardTrafo)'     'b'
    'wa.tf_avg'                 1        'create "ix_AVGT.nii" (template-structural-image)                 in MOUSESPACE (inverseTrafo)'     'b'

    'wa.tf_ano'                 1        'create "ix_ANO.nii" (template-label-image)                       in MOUSESPACE (inverseTrafo)'     'b'
   % 'wa.tf_anopcol'            0        'create "ix_ANOpcol.nii" (template-pseudocolor-label-image label) in MOUSESPACE (inverseTrafo)'     'b'
   % 'wa.tf_refc1'              0        'create "ix_refIMG.nii" (template-grayMatter-image)               in MOUSESPACE (inverseTrafo)'     'b'
    'wa.tf_c1'                  0        'create "x_c1t2.nii" (mouse-grayMatter-image)               in TEMPLATESPACE (forwardTrafo)'     'b'
    'wa.tf_c2'                  0        'create "x_c2t2.nii" (mouse-whiteMatter-image)              in TEMPLATESPACE (forwardTrafo)'     'b'
    'wa.tf_c3'                  0        'create "x_c3t2.nii" (mouse-CSF-image)                      in TEMPLATESPACE (forwardTrafo)'     'b'
    'wa.tf_c1c2mask'            0        'create "x_c1c2mask.nii" (mouse-gray+whiteMatterMask-image) in TEMPLATESPACE (forwardTrafo)'     'b'
    };


p2=paramadd(p,an);%add/replace parameter

if showgui==1
    
    
         hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
        figpos=[0.1688    0.3000    0.8073    0.6111];
        [m z a params]=paramgui(p2,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',figpos,...
            'title','SETTINGS','pb1string','OK','info',hlp);%,'cb1string',cb1string);
        
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




try;
    z.mdirs=an.mdirs ;
end

an=z;
%set Listbox-2
ls=an.ls;
ls(regexpi2(ls,'^\s*z.inf\d'))=[];
ls(regexpi2(ls,'^\s*z.mdirs'))=[];
ls=regexprep(ls,'^\s*z.','');
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
 
 
 
 
 
 
 





