


%%  #b JUST A PARSER TO DEFINE PARAMETERS FOR IMAGES THAT SHOULD BE WARPED (either BY SPM or Elastix)
%%  #b only for images, for which the warp-transformation should be applied 
% #r  note: this function will be never used in isolation
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
 
 