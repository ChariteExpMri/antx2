


%%  #b JUST A PARSER TO DEFINE PARAMETERS FOR IMAGES THAT SHOULD BE WARPED (either BY SPM or Elastix)
%%  #b only for images, for which the warp-transformation should be applied
% #r  note: this function will be never used in isolation
%
% #ko ___ GENERAL PARAMETERS ___  
% 
% direction      TARGET-SPACE-DIRECTION to warp the selected image; {-1,1}
%           - [-1] inverse to Native-Space(NS), aka animal space (space of t2.nii)
%           - [ 1] forward to Standard-Space(SS), aka template space (space of AVGT.nii/ANO.nii/x_t2.nii)
%           - default: [1]
%            
% resolution   RESOLUTION: target space resolution of the warped image
%              - default input: [NAN NAN NAN], i.e use the resolution of the target-space
%              - a triplet must be entered to represent either voxel-size or image-dimension
%              - voxel-size(triplet)      :  example [.05 .05 .1 ]  or 
%              - image-dimension (triplet):  example [200 200 50 ]  
%              - do not change this parameter if you are not shure!
%                     
% interpolation: IMAGE INTERPOLATION of the resulting image
%            - [0] NN, 
%            - [1] linear, 
%            - [4] cub.bspline  
%            - use [0] for masks/atlases or [1] or [4] for all other images
%            - use [1] for tissue compartements (GM/WM..)  
%            - default: [4]
%                
% imgSource   IMAGE SOURCE: source of the input image
%          - [1]intern/located in dat-folder
%          - [2]extern,image located somewhere else (e.g. in template folder)
%           default: [1]
%           
% imgSize   IMAGE SIZE of the resulting image
%           - default input: [NAN NAN NAN], i.e use image size of the target-space
%           - this option allows to preserve the field of view for images from NS to SS
%           - do not change this parameter if you are not shure!
%           
% imgOrigin  IMAGE ORIGIN of the resulting image
%          - this paramter together with "imgSize"  allows to preserve the field of view for images from NS to SS
%          - do not change this parameter if you are not shure!
%          
% fileNameSuffix  <optional> add additional suffix to the fileName of the resulting image
%             - the suffix is optional!
%             - enter a string here such as '_bla':
%                  .. the outputfile is: "x_myIMAGe_bla.nii" for image transformed to [SS]
%                  .. the outputfile is: "ix_myIMAGe_bla.nii" for image transformed to [NS]
% 
% 
%% #by FUNCTION
% s=xdeformpop(   files  ,direction,  resolution, interpx, filt, aux)
%% #by INPUT
% files       : cellarray with mouse-paths
% direction   : [-1/1] backward/forward transformation direction
% resolution  : final voxelsize [nan/3elementVector] specifying voxelsize,  NAN uses the resolution from transformation parameters
% interpx     : interpolation method, [-1/1/2/3] ;
%                   -1: (FOR ELASTIX ONLY) if data are in 0-1 range, but not binary such as TPMs
%                    0: nearest neighbour for MASKS/labels or if the set of nummber should not chnage (preserve 'uniqueness')
%                    1: linear
%                    2/3 higher order  -->3 is fine for all other data
%  filt: (optional), local file filter -->matching files ill be transformed
%  aux: (optional), struct with current options
%                 'showgui',1  : force to open guis even if all paramters are specified
%% #by EXAMPLES
%% search in two mouse-paths for 't2.nii' , paramters: dir=-1,res=nan,interp=4 ,    force PARAgui to open,
%   s=xdeformpop(   an.mdirs(2:3),[-1],[nan],[4],'^t2.nii' ,struct('showgui',1)),s.files
%
%% same as above, but without gui since paras are all specified
%    s=xdeformpop(   an.mdirs(2:3),[-1],[nan],[4],'^t2.nii' ),s.files
%
%% one Fullpath-file is given, show paragui because vox-resolution is not defined
%   s=xdeformpop(  { 'O:\harms1\koeln\dat\s12345678_s2720er\t2.nii'},[-1],[],[3] ),s.files
%
%% two FPfiles given--> (no guis, since all parars specified)
% s=xdeformpop(  { 'O:\harms1\koeln\dat\s12345678_s2720er\t2.nii', 'O:\harms1\koeln\dat\s10101010_20slices\t2.nii'},[-1],[nan],[4] ),s.files
% 
% 
%% SPECIFIC OPTIONS: EXAMPLE
%% warp to Standard-Space,  preserve large field-of-fiew in superior-inferior-direction
% files={
%     'f:\data5\schoknecht\dat\20210426US_SAB_sab_d7_scan_d7_m02\t2.nii'
%     'f:\data5\schoknecht\dat\20210426US_SAB_sab_d7_scan_d7_m03\t2.nii'}
% pp.source         =  'intern';
% pp.imgSize        =  [NaN  NaN  400];
% pp.imgOrigin      =  [NaN  NaN  -25];
% pp.fileNameSuffix =  '_LARGE';             %add prefix 
% fis=doelastix(1, [],files,1,'local' ,pp);

function s=xdeformpop(   files  ,direction,  resolution, interpx, filt, aux)


s=struct();
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0
    %% examples
    %% search in two paths for 't2.nii' , paramters: dir=-1,res=nan,interp=4 ,    force PARAgui to open,
    s=xdeformpop(   an.mdirs(2:3),[-1],[nan],[4],'^t2.nii' ,struct('showgui',1)),s.files
    %% same as above, but no Paragui since paras are all specified
    s=xdeformpop(   an.mdirs(2:3),[-1],[nan],[4],'^t2.nii' ),s.files
    %% 1 FPfile given, show paragui since Res. not defined
    s=xdeformpop(  { 'O:\harms1\koeln\dat\s12345678_s2720er\t2.nii'},[-1],[],[3] ),s.files
    %% 2FPfiles given--> (no guis, since all parars specified)
    s=xdeformpop(  { 'O:\harms1\koeln\dat\s12345678_s2720er\t2.nii', 'O:\harms1\koeln\dat\s10101010_20slices\t2.nii'},[-1],[nan],[4] ),s.files
    
    
    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%          [1]       gui FILES
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if exist('filt')~=1   ;   filt='';                   end
if exist('')~=1       ; aux.dummy='<>'; end

gui1     =0;
prefdir =pwd;  %preDIR for GUI

try ; %convert files to cell otherwise.:>empty
    if ischar(files); files=cellstr(files) ; end
catch
    files={''};
end

dattype=[];
for i=1:length(files) %check if NIFITs (=2) are deliverd or paths (=7)
    dattype(i)=exist(files{i}  );
end

if any(dattype==0) %no niffti no path given
    prefir=pwd;
    gui1=1;
elseif any(dattype==7) %path(s) given
    if length(files)>1  %more than one path given->go to upper directory
        prefdir=fileparts(files{min(find(dattype==7))});
    else   % one path given
        prefdir=files{1};
    end
    gui1=1;
else   %% FILES WERE GIVEN
    gui1=0;
    maskfi=files;
end





if  gui1==1
    maskfi={''};
    %     msg={'select all files that should be warped:'
    %         '1)choose rootpath'
    %         '2) type a matching token (e.g. "mask" "total_mask") in the filterbox, use also regular expressions (^/$ etc)'
    %         '3) press [rec] to recursivly search for the token in the roothpath''s subfolders'
    %         '4) add/remove images from button listbox'
    %         };
    msg={' DEFORM FILES'
        'HOW TO SELECT MULTIPLE FILES FROM MULTIPLE MOUSE FOLDERS?'
        ' 1) choose data path (mypath/../dat): Note: the data path contains the mouse folders'
        '        -copyNpaste data path in the [Dir] editbox (..at the top)  or navigitate to this folder in the [LEFT LISTBOX]'
        '       -at the end the data rootpath has to be visible in [Dir] editbox AND the [LEFT LISTBOX] should list all mouse folders '
        '2) in the [Filt] editbox (right to the [Filt] button) type search patterns that are parts of the filenames that should be transformed: '
        '  examples: '
        '       ^mask                search for files starting with "mask"  '
        '       .*mask.*.nii         search for NIFTIfiles containing "mask"  '
        '       ^x.*.nii|^ix.*.nii  search for NIFTIfiles starting with "x" or "ix" '
        '       NOTE: ^mask means the filesnames should start with means  (mask_bla.nii but not  bla_mask_bla.nii will be found) '
        '             for ''*'' wildcard use ''.*'' (specific in regexp) '
        '3a) press [rec] button to recursivly search for files within the roothpath''s subfolders that contain the "filter pattern" '
        '3b) additionally or alternative to (3a): '
        '       press [fileSTR] to get a global list of all files'
        '      select the files which should be transformed '
        '      press [rec] again to find these files in folders'
        '     if needed, deselect files from lower panel '
        '4) add/remove files from the selection listbox (=lower listbox, this box contains the selected files)'
        '      -in the selection listbox use the context menu''s  "unselect all" to clear all files from the selection listbox'
        '  '
        'HOW TO SELECT  MULTIPLE FILES FROM SINGLE MOUSE FOLDER?'
        '1) navigate to the mouse folder of interest ( [Dir] editbox should contain the mouse path )'
        '2) select files from the right listbox (this files appear in the selection listbox(=lower listbox))'
        };
    
    if any(dattype==7) %% recursivley search only in those paths
        if ~isempty(filt) %filter was given-->NO GUI
            maskfi={};
            for i=1:length(files)
                filesdum= spm_select('FPListRec',files{i},filt)  ;
                maskfi=[maskfi;   filesdum]
            end
        else %OPEN GUI
            w.recpaths=files;
            [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii' ,[],w);
            if isempty(char(maskfi)); return; end
        end
    else
        [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii');
    end
    
    if isempty(maskfi)   ; files=[];
    else;                          files=maskfi;
    end
end

% maskfi

% ==============================================
%%
% ===============================================
p0.direction  =  1;
p0.resolution = [nan nan nan];
p0.interp     = 4;
p0.source     = 1;

p0.imgSize   = [nan nan nan];
p0.imgOrigin = [nan nan nan];
p0.suffix     = [''];

gui=[zeros(1,10)];
if exist('direction')==1  && ~isempty(direction)   ;  p0.direction  =direction;   else gui(1)=1;    end
if exist('resolution')==1 && ~isempty(resolution)  ;  p0.resolution =resolution;  else gui(2)=1;    end
if exist('interpx')==1    && ~isempty(interpx)     ;  p0.interp     =interpx;     else gui(3)=1;    end
if exist('source')==1     && ~isempty(source)      ;  p0.source     =source;      else gui(4)=1;    end
% if exist('isparallel')==1 && ~isempty(isparallel)  ;  p0.isparallel =0     ;      else gui(4)=1;    end



if isfield(aux,'showgui')%force gui to open
    if aux.showgui==1;       gui=1  ; end
end
%% ===============================================


% ==============================================
%%   GUI
% ===============================================
x=struct();


sel.dir        =cellfun(@(a){[   (a)]} ,num2cell([p0.direction   setdiff([-1 1],  p0.direction)]'));
sel.interp     =cellfun(@(a){[   (a)]} ,num2cell([p0.interp      setdiff([0:4],   p0.interp)]'));
sel.source     =cellfun(@(a){[   (a)]} ,num2cell([p0.source      setdiff([1 2],   p0.source)]'));


p={...
    'inf1'      '___ GENERAL PARAMETERS ___             '                         '' ''
    'direction'      sel.dir{1}                'DIRECTION: [-1] inverse to Native-Space, [1] forward to Standard-Space' ,sel.dir
    'resolution'     p0.resolution             'RESOLUTION: target space resolution: default input: [NAN]; see help for further information' ,''
    'interpolation'  sel.interp{1}             'INTERPOLATION: [0] NN, [1] linear, [4] cub.bspline  (use [0] for mask/atlases and [1 or 4] for all other images)' sel.interp
    'imgSource'      sel.source{1}             'IMAGE SOURCE:[1]intern/located in dat-folder,[2] extern,image located somewhere else (e.g. in template folder)'  sel.source
    
    'inf2'      ''  '' ''
    'inf3'      '___ SPECIFIC OPTIONS ___'  '' ''
    
    'imgSize'         p0.imgSize           'IMAGE SIZE: target image size: default input: [NAN]; see help for further information' ,''
    'imgOrigin'       p0.imgOrigin         'IMAGE ORIGIN: target image ORIGIN: default input: [NAN]; see help for further information' ,''
    'fileNameSuffix'  p0.suffix             '<optional> add additional suffix to the fileName of the resulting image' ''
    'isparallel'      0                     'parallel processing for lot of files; {0|1};  '  'b'
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if any(gui)==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.2493    0.5544    0.6542    0.2178],...
        'title','DEFORM OTHER IMAGES [xdeformpop]','info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

%% ===============================================

s=z;
s=rmfield(s,{'interpolation','imgSource'});
s.interpx =z.interpolation;
s.source  =z.imgSource;
s.files   =maskfi;
% s.bla     ='123'   
% s
















return

% ==============================================
%%   older version
% ===============================================
if 0
    
    return
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%          [2]       gui params
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    gui=[0 0 0 0];
    if exist('direction')~=1   || isempty(direction)  ;               gui(1)=1;     direction =1;                              end
    if exist('resolution')~=1  || isempty(resolution)     ;            gui(2)=1;     resolution =[nan nan nan];                             end
    if exist('interpx')   ~=1  || isempty(interpx)     ;             gui(3)=1;     interpx =4         ;                                        end
    if exist('source')   ~=1   || isempty(source)     ;             gui(4)=1;     source =1         ;end
    if isfield(aux,'showgui')%force gui to open
        if aux.showgui==1;       gui=1  ; end
    end
    
    if any(gui)==1
        % ==============================================
        %%   GUI
        % ===============================================
        
        prompt = {...
            'DIRECTION: [-1] inverse, [1] forward',
            ['RESOLUTION: target space resolution: default input: [NAN] ' char(10)...
            ' ..alternatives:' char(10) ...
            '              voxel-size(triplet):       example [.05 .05 .1 ]  or ..' char(10) ...
            '              image-dimension (triplet):  example [200 200 50 ]  '   ]
            [         'INTERPOLATION:     [0] NN,   [1] linear, [4] cub.bspline  (use [0] for mask/atlases or [4] for all other)' ]
            [char(10) ....
            'IMAGE SOURCE: [1] intern, [2] extern' char(10) ...
            '       [1] intern: images located in dat-folder ' char(10)...
            '       [2] extern  images located somewhere else (e.g. in template folder)' ]
            };
        dlg_title = 'Deform Images   [xdeformpop]';
        num_lines = 1;
        def = {'1',  '.07 .07 .07'  , '4' '1'};
        def={num2str(direction)  num2str(resolution) num2str(interpx)   num2str(source)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        
        % ==============================================
        %%
        % ===============================================
        if isempty(answer);    return             ; end
        
        direction   =    str2num(answer{1}) ;
        resolution=  str2num(answer{2}) ;  if length(resolution)==1; resolution=repmat(resolution,[1 3]); end
        interpx      = str2num(answer{3}) ;
        source      = str2num(answer{4}) ;
        
    end
    
    s.files=maskfi(:);
    s.direction=direction;
    s.resolution=resolution;
    s.interpx     =interpx;
    s.source      =source;
    
end