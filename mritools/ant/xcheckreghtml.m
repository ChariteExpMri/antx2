
% #yk create HTML-files with overlay of images. 
% The single HTML-file can be used to check the registration.
% Each html-file can contain the overlays of two images for several animals (study animals)
% The folder with the HTML-file and the corresponding subfolder with the images. 
% can be zipped and emailed (in case somebody else want to check the registration).
% You can select several different images and the same reference image when calling this GUI. 
% In this case N-different HTML-files will be generated, each containing the overlays of the
% background image and ONE (!) of the selected images. With this an "index.html"-file is
% generated that lists and links to all generate HTML-files
% #g ______________________________________________________________________________
% #g EACH HTML-file contains the same image-pairs (example: 'AVGT.nii' & 'x_t2.nii' ) 
% #g but can contain the results from several animals.
% #g ______________________________________________________________________________
% #r NOTE: SELECT the animals from ANT-listbox before calling this function! 
% 
% 
% #ka PARAMETER
% 
% 'backgroundImg'    -[SELECT] Background/reference image (a single file).        
% 'overlayImg'       -[SELECT] Image to overlay (multiple files possible).         
% 'outputPath'       -[SELECT] Outputpath: path to write HTMLfiles and image-folder. 
%                     Best way: create a new folder "checks" in the study-folder.
% 'outputstring'     - <optional> Output string added (suffix) to the HTML-filename and image-directory 
% 'slices'          SLICE-SELECTION TYPE
%                    +option-1) "n"+NUMBER: number of slices to plot  
%                     example:     'n6': plots 6 equidistant slices
%                    +option-2)  a single number, which plots every nth. image
%                     example:     4 or '4': plots every 4th slice
% 'dim'            Dimension to plot {1,2,3}: 
%                    -In standard-space this is: {1}transversal,{2}coronal,{3}sagital
% 'size'           Image size in HTML file (in pixels); default: 400  
% 'grid'           Show line grid on top of image {0,1}; default:1   
% 'gridspace'      Space between grid lines (in pixels).; default: 20
% 'gridcolor'      'Grid color (use icon); default: [1 0 0] 
% 'cmapB'           <optional> specify background-color; otherwise leave empty,  default: ''                                                                       
% 'cmapF'           <optional> specify foreground-color; otherwise leave empty,  default: ''                                                                         
% 'showFusedIMG'    <optional> show the fused image [0]no,[1]yes                                                                                           
% 
% 
% #ka BATCH
% Code is generated during execution and is listed in the 'anth'-variable 
% Code available via [anth]-Button (main GUI).
% xcheckreghtml(1,z);     %  RUN WITH OPEN GUI
% xcheckreghtml(0,z);     %  RUN WITHOUT GUI 
% 
% ==============================================
%%   #ko __EXAMPLE-1__
% ===============================================
% z=[];                                                                                                                                                 
% z.backgroundImg = { 't2.nii' };                     % % background/reference image (a single file)                                                    
% z.overlayImg    = { 'c1t2.nii'                      % % overlay image [t2], (may be multiple files)                                                   
%                     'c2t2.nii'                                                                                                                        
%                     'c3t2.nii' };                                                                                                                     
% z.outputPath    = 'F:\data3\graham_ana4\check';     % % select outputpath (path to write HTMLfiles and images)                                        
% z.outputstring  = 'nativeSpace';                    % % optional output string added to html  and image-directory                                     
% z.slices        = 'n20';                             % % " (1) n"+number: number of slices to plot or (2) a single number, which plots every nth. image
% z.dim           = [1];                              % % dimension to plot {1,2,3}: in standardspace: {1}transversal,{2}coronal,{3}sagital             
% z.size          = [400];                            % % image size width&high in HTML file                                                            
% z.grid          = [1];                              % % show line grid on top ov image {0,1}                                                          
% z.gridspace     = [10];                             % % space between grid lines (pixels)                                                             
% z.gridcolor     = [0  0  1];                        % % grid color
% xcheckreghtml(1,z);     % % RUN WITH OPEN GUI 
% ==============================================
%%  #ko __EXAMPLE-2__
% show 'ANO.nii' onto 'AVGT.nii'
% -colormpaps (z.cmapB/z.cmapF) are used
% -a fused image is shown (z.showFusedIMG=1)
% ===============================================
% z=[];                                                                                                                                                                                 
% z.backgroundImg = {'AVGT.nii' };                      % % [SELECT] Background/reference image (a single file)                                                                        
% z.overlayImg    = {'ANO.nii' };                        % % [SELECT] Image to overlay (multiple files possible)                                                                        
% z.outputPath    = 'f:\data6\juergen_angio\checks';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
% z.outputstring  = 'testColor';                         % % optional Output string added (suffix) to the HTML-filename and image-directory                                             
% z.slices        = 'n20';                                % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
% z.dim           = [2];                                 % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                 
% z.size          = [300];                               % % Image size in HTML file (in pixels)                                                                                        
% z.grid          = [1];                                 % % Show line grid on top of image {0,1}                                                                                       
% z.gridspace     = [20];                                % % Space between grid lines (in pixels)                                                                                       
% z.gridcolor     = [1  0  0];                           % % Grid color                                                                                                                 
% z.cmapB         = 'bone';                              % % <optional> specify BG-color; otherwise leave empty                                                                         
% z.cmapF         = 'parula';                            % % <optional> specify FG-color; otherwise leave empty                                                                         
% z.showFusedIMG  = [1];                                 % % <optional> show the fused image                                                                                            
% xcheckreghtml(0,z);        % % RUN WITHOUT GUI                                                                                                                                                                            
% ______________________
%   
% ______________________
% 
% #k Animals are pre-selected via listbox from ANT-gui. However, you can override this selection 
% #k when using an animal path-list as 3rd input argument.
% EXAMPLE:
% px={'F:\data3\graham_ana4\dat\20190122GC_MPM_02'}; % % only this animal is evaluated
% xcheckreghtml(1,z,px);                             % % RUN WITH OPEN GUI
% 
 




function xtest(showgui,x,pa)


if 0
    % ==============================================
    %%
    % ===============================================
    
    pa={'F:\data3\graham_ana4\dat\20190122GC_MPM_01'
        'F:\data3\graham_ana4\dat\20190122GC_MPM_02'}
    xtest(1,[],pa)
    
    %   % ==============================================
    %%
    % ===============================================
end

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;   try pa=antcb('getsubjects') ;catch; pa=[];end ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%===========================================
%%   %% test SOME INPUT
%===========================================


%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
if isempty(pa)
    msg='select one/multiple animal folders';
    [t,sts] = spm_select(inf,'dir',msg,'',pwd,'[^\.]'); % do not include 'upper' dir
    if isempty(t); return; end
    pa=cellstr(t);
end

% ==============================================
%%   
% ===============================================

%% fileList
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end

cmapList=[ {''} getcmapList];
try; 
    cmapList=[cmapList lutmap('show')'];
end

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf0' ''  '____SELECT_IMAGES HERE____'  ''
    'backgroundImg'   {''}                '[SELECT] Background/reference image (a single file)'          {@selector2,li,{'ReferenceImage'},'out','list','selection','single'}
    'overlayImg'      {''}                '[SELECT] Image to overlay (multiple files possible)'         {@selector2,li,{'OverlayImage(s)'},'out','list','selection','multi'}
    'outputPath'      ''                  '[SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )'  'd'
    'outputstring'    ''                  'optional Output string added (suffix) to the HTML-filename and image-directory '  ''
    'inf1' ''  '____PARAMETER____'  ''
    'slices'  'n6'   'SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image'  {'n2' 'n3' 'n4' 'n5' 'n6'  '2' '3' '4' '5' '6'}
    'dim'     2      'Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital'  {1,2,3}
    'size'    400    'Image size in HTML file (in pixels)' {100 200 300 400 500}
    'grid'    1      'Show line grid on top of image {0,1}'  'b'
    'gridspace'  20  'Space between grid lines (in pixels)'  { 5 10 20 30}
    'gridcolor'   [1 0 0] 'Grid color'  'col'
    'inf2'   '__optional___' '' ''
    'cmapB'           ''      '<optional> specify BG-color; otherwise leave empty'  cmapList
    'cmapF'           ''      '<optional> specify FG-color; otherwise leave empty'  cmapList
    'showFusedIMG'   0  '<optional> show the fused image'   'b'
    'sliceadjust'    0  'intensity adjust slices separately; [0]no; [1]yes' 'b'  
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.0840    0.2711    0.8000    0.3056 ],...
        'title',['***check overlay HTML*** ('  mfilename ')' ],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%===========================================
%%   checks
%===========================================
if isempty(char(z.outputPath))
    try
        global an
        z.outputPath= fullfile( fileparts(an.datpath),'checks');
    end
    if isempty(char(z.outputPath))
        [od]=uigetdir(pwd,'select/create+select output directory');
        if isnumeric(od); 
            disp('canceled'); return; 
        else
           z.outputPath=od ;
        end
    end
end

%===========================================
%%   history
%===========================================
 xmakebatch(z,p, mfilename);


 
 % ==============================================
%%   process
% ===============================================

datapaths=pa;
outpath  =z.outputPath;

%% ---make filepairs
z.backgroundImg  =cellstr(z.backgroundImg);
z.overlayImg     =cellstr(z.overlayImg);
z.overlayImg     =z.overlayImg(:);

filepairs=[  repmat(z.backgroundImg,[size(z.overlayImg,1) 1]) z.overlayImg];

%% ----

for i=1:size(filepairs,1)
    checkreghtml(datapaths, filepairs(i,:),outpath,z)
end

 
 



%% ===== colormaps ==========================================
function cmaplist=getcmapList();
colormapeditorString = fileread(strcat(matlabroot,'\toolbox\matlab\graph3d\colormapeditor.m'));
posStart = strfind(colormapeditorString,'stdcmap(maptype');
posEnd = strfind(colormapeditorString(posStart:end),'end') + posStart;
stdcmapString = colormapeditorString(posStart:posEnd);
split = strsplit(stdcmapString, '(mapsize)');
list = cellfun(@(x)x(find(x==' ', 1,'last'):end), split,'uni',0);
list(end) = [];
list=regexprep((list),'\s+','');
li2={'gray' 'parula' 'jet' 'hot'};
cmaplist=[li2 setdiff(list,li2)];

%% ===============================================


