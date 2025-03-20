
% COLORIZE BRAIN REGION FROM ATLAS USING MRicroGL, SAVE AS  PNG, CREATE PPT-FILE
% #r This function supports Windows and macOS. Unix/Linux support is not implemented.
%
%% #wb *** MRICROGL-INSTALLATION ***
% #r IMPORTANT - MRicroGL must be installed before using this function
%
% ---------------------------------------------------------
% [WINDOWS]:  options
% ---------------------------------------------------------
% [A] MRicroGL must be installed using predefined path (must be installed here)
%  'C:\Program Files\MRIcroGL\'
%   or
%  'C:\Users\YourUsername\AppData\Local\MRIcroGL\'
% ..or..
% [B] MRicroGL is installed somewhere else, than...
%  set MRicroGL as permanent environmental variable via:
%  (a) WIN CMD-window as administrator
%    setx PATH "%PATH%;<path_to_MRIcroGL>" /M
%    where '<path_to_MRIcroGL>' is the path to MRIcroGL.exe
%    example:  setx PATH "%PATH%;C:\paulprogramme\MRIcroGL" /M
%  (b) use  PowerShell as administrator
%    execute the following:
%    $oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
%    $newPath = $oldPath + ";<path_to_MRIcroGL>"
%    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
%    where '<path_to_MRIcroGL>' is the path to MRIcroGL.exe
% ..or..
% [c] fullpath MRicroGL.exe must be specified in parameter 'mricroGL' (see below)
%
% ---------------------------------------------------------
% [2] MAC:  options
% ---------------------------------------------------------
% [A] copy MRIcroGL.app in the APP's-folder  (than path is: "/Applications/MRIcroGL.app")
% ..or..
% [B] fullpath MRicroGL.app must be specified in parameter 'mricroGL' (see below)
%
%
%% #wb *** PARAMETER ***
% ===[IMAGES]================================================================================================
% 'bg_image'    - Background image. If this parameter is left empty, the default "AVGT.nii" 
%                 from the template folder will be used.
% 'bg_mask'      - Brain mask. If not specified, the default "AVGTmask.nii" from the template 
%                 folder will be used.
% 'atlas_image'  - Atlas file (NIFTI format). If this parameter is left empty, "ANO.nii" from 
%                 the template folder will be automatically used.
% 
% ===[REGIONS-TO-PLOT]================================================================================================
% 'regions' - Specifies which regions will be color-coded and saved as PNG files.
%             These regions must be present in the 'atlas_image' (NIFTI) and must correspond
%             to entries in a related Excel file (not visible: atlas_image.xlsx).
%             Options:
%             [1] Cell array of region names to plot. 
%                 Example: {'Primary Motor Area', 'Caudoputamen'};
%             [2] Select an Excel file that lists regions in the first column of the first sheet.
%             [3] Choose from the Atlas: This option allows the user to select an atlas file 
%                 (e.g., 'ANO.xlsx') and specify the regions to display from it.
% 
%             IMPORTANT: To specify regions in the left or right hemisphere when the atlas
%             does not explicitly differentiate between hemispheres, add the prefix 'L_' for left
%             or 'R_' for right to the region names.
%             Example: To reference the left hemispheric Primary Motor Area and the right hemispheric
%             Caudoputamen, use: {'L_Primary Motor Area', 'R_Caudoputamen'}.
% 
% ===[PLOT PARAMETER] ====================================================================
% 'bg_clim'     - Background image intensity limits [min, max]. If set to [nan, nan], 
%                 limits are automatically defined.
%                 Examples: [0, 200] or [nan, nan]
%
% 'ovl_clim'    - Overlay image intensity limits [min, max]. If set to [nan, nan], 
%                 limits are automatically defined.
%                 Examples: [0, 200] or [nan, nan]
%
% 'ovl_cmap'    - Overlay image colormap. Refer to the colormap icon for options.
%
% 'opacity'     - Opacity of the overlaid image, specified as one of the following percentages:
%                 {0, 20, 40, 50, 60, 80, 100}
%                 Example: [50]
%
% 'linewidth'   - Line width of the slice cutting line, specified as a numeric value.
%                 Example: 1
%
% 'linecolor'   - Color of the crosshair, specified in normalized RGB values (range 0-1).
%                 Default: [0, 0, 0] (black). Refer to the color icon for options.
% 
% ===[OUTPUT PARAMETERS] ====================================================================
% 'outdir'       - Output directory for saving files.
%                  If this parameter is left empty, PNG and PPT files will be saved in the
%                  following default directory: <current working directory>/results
%
% 'subdir'       - <Optional> Additional subdirectory within 'outdir' for organizing the saved 
%                  PNG files and PowerPoint file. This can be left empty if no subdirectory is needed.
%
% 'ppt_filename' - Name of the PowerPoint file to be saved.
% 
% ===[MISC] ====================================================================
% 'cleanup'      - Specifies whether to remove temporarily created NIFTI files. Options: {0|1}
%                  Default: [1] (1 for true, meaning temporary files will be removed)
%
% 'makePPT'      - Determines whether to create a PowerPoint file with images and information. Options: {0|1}
%                  Default: [1] (1 for true, meaning a PowerPoint file will be created)
%
% 'mricroGL'     - <Optional> Specify the full path of the MRIcroGL executable if it is not found automatically.
%                  Ensure you refer to the MRIcroGL installation instructions (above) for more details.
%                  Windows example: 'C:\\paulprogramme\\MRIcroGL3\\MRIcroGL.exe'
%                  macOS example: '/Users/klausmaus/MRIcroGL.app'
% 
%
%% #wb *** RUN ***
% xcolorregion_mricrogl(1) or  xcolorregion_mricrogl    ... open PARAMETER_GUI
% xcolorregion_mricrogl(0,z)             ...NO-GUI,  z is the predefined struct
% xcolorregion_mricrogl(1,z)             ...WITH-GUI z is the predefined struct
%
%
%% #wb *** EXAMPLES ***
% 
%% EXAMPLE: without loading an ANTx project, paths for bg_image,bg_mask and atlas_image are specified
%% Here, 6 regions are colored and images saved as png-files and a PPTfile is created
%     z=[];                                                                                                                                                                                                                                   
%     z.bg_image     = 'F:\data8\sarah\sarah_plots_26jan24\templates\AVGT.nii';                          % % background image, if empty, "AVGT.nii" from template-folder is used                                                              
%     z.bg_mask      = 'F:\data8\sarah\sarah_plots_26jan24\templates\AVGTmask.nii';                      % % image mask, if empty, "AVGTmask.nii" from template-folder is used                                                                
%     z.atlas_image  = 'F:\data8\sarah\sarah_plots_26jan24\atlas_SA040521_v4\atlas_SA040521_v4.nii';     % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used                                                                  
%     z.regions      = { 'L_Somatosensory_areas_MODIF'                                                   % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
%                        'L_Anterior_cingulate_area_ventral_part_6b_MODIF'                                                                                                                                                                    
%                        'L_Prelimbic_area_layer_6b_MODIF'                                                                                                                                                                                    
%                        'L_Infralimbic_area_layer_6b_MODIF'                                                                                                                                                                                  
%                        'L_Orbital_area_lateral_part_layer_6b_MODIF'                                                                                                                                                                         
%                        'L_Orbital_area_medial_part_layer_6b_MODIF' };                                                                                                                                                                       
%     z.bg_clim      = [NaN  NaN];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                                                
%     z.ovl_cmap     = '1red.clut';                                                                      % % overlay-image: colormap                                                                                                          
%     z.ovl_clim     = [NaN  NaN];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                                                   
%     z.opacity      = [40];                                                                             % % overlay opacity range: 0-100                                                                                                     
%     z.linewidth    = [1];                                                                              % % linewidth of slice cutting line                                                                                                  
%     z.linecolor    = [0  0  0];                                                                        % % line color of slice cutting line                                                                                                 
%     z.outdir       = 'F:\data9\region_redering_mricrogl\out_sarah';                                    % % output-dir, if empty plots/ppt-file in current directory                                                                         
%     z.subdir       = '';                                                                               % % subdir in outdir, contains created png-files, can be <empty>                                                                     
%     z.ppt_filename = 'test2';                                                                          % % PPT-filename                                                                                                                     
%     z.cleanup      = [1];                                                                              % % remove temporarily created NIFTIs,{0|1}                                                                                          
%     z.makePPT      = [1];                                                                              % % make Powerpoint-file with image and infos, {0|1}                                                                                 
%     z.mricroGL     = '';                                                                               % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                           
%     xcolorregion_mricrogl(0,z); 
% 
%% =============================================================================================================================================
%% EXAMPLE: as above but regions to display are extracted from excelfile ('regions.xlsx')
%% Output-folder is current working DIR+"results"+z.subdir  (because 'outdir' is not spcified)
% 
%     pastudy='F:\data8\sarah\sarah_plots_26jan24';
%     z=[];                                                                                                                                                                                                                                   
%     z.bg_image     = fullfile(pastudy,'templates','AVGT.nii');                                         % % background image, if empty, "AVGT.nii" from template-folder is used                                                              
%     z.bg_mask      = fullfile(pastudy,'templates','AVGTmask.nii');                                     % % image mask, if empty, "AVGTmask.nii" from template-folder is used                                                                
%     z.atlas_image  = fullfile(pastudy,'atlas_SA040521_v4' ,'atlas_SA040521_v4.nii');                   % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used                                                                  
%     z.regions      = 'F:\data9\region_redering_mricrogl\regions.xlsx';                                 % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
%     z.bg_clim      = [NaN  NaN];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                                                
%     z.ovl_cmap     = '3blue.clut';                                                                     % % overlay-image: colormap                                                                                                          
%     z.ovl_clim     = [NaN  NaN];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                                                   
%     z.opacity      = [40];                                                                             % % overlay opacity range: 0-100                                                                                                     
%     z.linewidth    = [1];                                                                              % % linewidth of slice cutting line                                                                                                  
%     z.linecolor    = [0  0  0];                                                                        % % line color of slice cutting line                                                                                                 
%     z.outdir       = '';                                                                               % % output-dir, if empty plots/ppt-file in current directory                                                                         
%     z.subdir       = 'regioncolorized2';                                                               % % subdir in outdir, contains created png-files, can be <empty>                                                                     
%     z.ppt_filename = 'test2';                                                                          % % PPT-filename                                                                                                                     
%     z.cleanup      = [1];                                                                              % % remove temporarily created NIFTIs,{0|1}                                                                                          
%     z.makePPT      = [1];                                                                              % % make Powerpoint-file with image and infos, {0|1}                                                                                 
%     z.mricroGL     = '';                                                                               % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                           
%     xcolorregion_mricrogl(0,z); 
% 
%% =============================================================================================================================================
%% EXAMPLE: short version, ANTx-project is loaded
%% ultashort-example: Antx-project must be loaded before, create colored regions using default parameter
%% output (png-images and pptfile) is saved in <study>\results\regioncolorized
%% using default AVGT.nii, AVGTmask and ANO.nii from template folder
%% Although not explicitely occuring in the corresponding region-file 'ANO.xlsx', we can separately display the 
%% left and right hemispheric regions when adding the prefix 'L_' and 'R_' in the region-names (example:
%% 'L_Primary motor area' or 'R_Primary motor area')
%     z=[];
%     z.regions      = { 'L_Primary motor area'        % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")                                                                                 
%                        'R_Primary motor area' 
%                        'Primary motor area' 
%                        'L_Caudoputamen'
%                        'R_Caudoputamen'
%                        'Caudoputamen'  
%                        };                                                                                                                                                                            % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                     
%     xcolorregion_mricrogl(0,z);
% 
%% =============================================================================================================================================
%% EXAMPLE, same as before but specifying more parameters (here green-colored region) 
%     z=[];                                                                                                                                                                               
%     z.bg_image     = '';                           % % background image, if empty, "AVGT.nii" from template-folder is used                                                              
%     z.bg_mask      = '';                           % % image mask, if empty, "AVGTmask.nii" from template-folder is used                                                                
%     z.atlas_image  = '';                           % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used                                                                  
%     z.regions      = { 'L_Primary motor area'      % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
%                        'R_Primary motor area'                                                                                                                                           
%                        'Primary motor area'                                                                                                                                             
%                        'L_Caudoputamen'                                                                                                                                                 
%                        'R_Caudoputamen'                                                                                                                                                 
%                        'Caudoputamen' };                                                                                                                                                
%     z.bg_clim      = [NaN  NaN];                   % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                                                
%     z.ovl_cmap     = '2green.lut';                 % % overlay-image: colormap                                                                                                          
%     z.ovl_clim     = [NaN  NaN];                   % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                                                   
%     z.opacity      = [50];                         % % overlay opacity range: 0-100                                                                                                     
%     z.linewidth    = [1];                          % % linewidth of slice cutting line                                                                                                  
%     z.linecolor    = [0  0  0];                    % % line color of slice cutting line                                                                                                 
%     z.outdir       = '';                           % % output-dir, if empty plots/ppt-file in current directory                                                                         
%     z.subdir       = 'regioncolorized3';           % % subdir in outdir, contains created png-files, can be <empty>                                                                     
%     z.ppt_filename = 'regions';                    % % PPT-filename                                                                                                                     
%     z.cleanup      = [1];                          % % remove temporarily created NIFTIs,{0|1}                                                                                          
%     z.makePPT      = [1];                          % % make Powerpoint-file with image and infos, {0|1}                                                                                 
%     z.mricroGL     = '';                           % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                           
%     xcolorregion_mricrogl(0,z);                                                                                                                                                         
% 
% 
% 



function [z]=xcolorregion_mricrogl(showgui,x,pa)

%===========================================
%%   PARAMS
%===========================================
isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end

% if ischar(showgui)  % get path of MRICROGL
%     if strcmp(showgui,'path_mricrogl')
%         z=getExecutable();
%         return
%     end
% end

if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end
% ==============================================
%%   PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
palut=(fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents','Resources','lut'));
htmllist=getclut(palut);


regs={};
regs(end+1,:)={'L_Caudoputamen'                                     'L_Caudoputamen'  };
regs(end+1,:)={'L_Nucleus_accumbens'                                'L_Nucleus_accumbens'  };
regs(end+1,:)={'two regions: L_Nucleus_accumbens, L_Caudoputamen'    {'L_Nucleus_accumbens' 'L_Caudoputamen'} };
regs(end+1,:)={'select Excelfile with regions (1st column)'          {@getRegions} };
regs(end+1,:)={'select from atlas (such as "ANO.xlsx")'              {@getRegionsFromAtlas} };


% z.reg={...
%     'L_Caudoputamen'
%     'L_Nucleus_accumbens'};

p={
    'inf0' '__IMAGES__' '' ''
    'bg_image'      ''              'background image, if empty, "AVGT.nii" from template-folder is used' 'f'
    'bg_mask'       ''              'image mask, if empty, "AVGTmask.nii" from template-folder is used' 'f'
    'atlas_image'   ''              'atlas (NIFTI), if empty, "ANO.nii" from template-folder is used' 'f'
    
    'inf11'  '' '' ''
    'inf1' '__REGIONS-TO-PLOT__' '' ''
    'regions'       ''              'enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")'  regs
    
    'inf22'  '' '' ''
    'inf2'  '__IMAGE-PARAMETER__' '' ''
    'bg_clim'          [50 200 ]      'background-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'ovl_cmap'         '1red.clut'    'overlay-image: colormap ' {'cmap',htmllist}
    'ovl_clim'         [0 1 ]         'overlay-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'opacity'          70             'overlay opacity range: 0-100 '  {0,20,40,50,60,80,100}'
    'linewidth'     [1]               'linewidth of slice cutting line'  num2cell(0:4)
    'linecolor'     [0 0 0]           'line color of slice cutting line'  'col'
    
    'inf33'  '' '' ''
    'inf3'  '___OUTPUT-PARAMETER___' '' ''
    'outdir'         ''            'output-dir, if empty plots/ppt-file in "results"-DIR in  current directory'    'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'subdir' 'regioncolorized'     'subdir in outdir, contains created png-files, can be <empty>'         {'_plots' '_figs'}
    'ppt_filename'   'regions'     'PPT-filename, enter PPT-filename here '  {'region'  'rest' 'colorizedRegions'}
    
    'inf55'  '' '' ''
    'inf5'  '___misc___' '' ''
    'cleanup'      1      'remove temporarily created NIFTIs,{0|1}'          'b'
    'makePPT'      1      'make Powerpoint-file with image and infos, {0|1}'  'b'
    'mricroGL'     ''     '<optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)'  {@get_mrigroglPath}
    };
p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .2 .6 .6 ],...
        'title',[ '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m);
        return;
    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end
% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        batch=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        batch=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end




%% ===============================================
%%  proc

% ====get executable, path,batch ================
z.mricroGL=char(z.mricroGL);
if ~isempty(z.mricroGL) && exist(z.mricroGL)==2
    z.exefile=z.mricroGL;
else
    z.exefile=xplotslices_mricrogl('path_mricrogl');
end

global an
if isempty(an)
    studydir=pwd;%fileparts(z.ovl_images{1});
else
    studydir=fileparts(an.datpath);
end
if isfield(z,'outdir')==0 || isempty(z.outdir)
    z.outdir=fullfile(studydir,'results',z.subdir);
end
z.studydir=studydir;
z.batch   =batch;
%% ===============================================
try;
%    'a' %         rmdir(z.outdir,'s');
   delete(fullfile(z.outdir,'*.png'));
end
if exist(z.outdir)==0;
    mkdir(z.outdir);
end

z.outtable={};
z=getAtlas(z);
for i=1:size(z.tb,1)
    [z isfound]=makeNIfti(z,i);
    if isfound==1
        z=saveImageMricronGLM(z);
        z=cutNsplitImages(z);
    end
    
end
z=cratePPT(z);
if z.cleanup==1
    delete(fullfile(z.outdir,'*.nii'));
end

function z=getRegionsFromAtlas(e,e2)
%% ===============================================
z='';
[x1,x2]= paramgui('getdata');
atl=x2.atlas_image;
if isempty(char(atl))  % from ant-template
    global an
    if isempty(an); error('no atlas specified in [atlas_image] '); end
    atl=fullfile(fileparts(an.datpath),'templates','ANO.nii');
    if exist(atl)~=2; error([ 'not found: "'  atl '"']); end 
end
[pa name ext]=fileparts(atl);
atl_xls=fullfile(pa,[name '.xlsx']);
[~,~,a0]=xlsread(atl_xls);
tb=a0(2:end,1);
tb=cellfun(@(a) {[ num2str(a)]},tb);
tb(strcmp(tb,'NaN'))=[];
htb={'region'};
id=selector2(tb,htb,'iswait',1,'finder',1);
try
    z=tb(id);
end
%% ===============================================
function z=getRegions(e,e2)
%% ===============================================
z='';
[fi pa]=uigetfile(fullfile(pwd,'*.xlsx'),'select regionfile (excelfile)');
if isnumeric(fi); return ; end
z=fullfile(pa,fi);
%% ===============================================
function z=cratePPT(z)
%% ===============================================
%%   PPT
%% ===============================================
if z.makePPT==1
    %% ===============================================
    outdir=z.outdir;
    pptfile =fullfile(outdir,[z.ppt_filename '.pptx']);
    titlem  =z.ppt_filename ;%['lesion'  ];
    %     [pnglist] = spm_select('FPList',outdir,'^p_.*.png');
    [pnglist] = spm_select('FPList',outdir,'^pmix_.*.png');
    pnglist=cellstr(pnglist);
    fis     =pnglist;
    
    nimg_per_page  =6;           %number of images per plot
    imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
    for i=1:length(imgIDXpage)-1
        if i==1; doc='new'; else; doc='add'; end
        img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
        [~, namex ext]=fileparts2(img_perslice);
        tx=cellfun(@(a,b) {[ a b ]},namex,ext);
        img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
            'crop',0,'gap',[0 0 ],'columns',2,'xy',[0.02 2 ],'wh',[nan 4 ],...
            'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
            'text',tx,'tfs',12,'txy',[0 15],'tbgcol',[1 1 1],'disp',0 );
    end
    %% ===============================================
    [ ~, studyName]=fileparts(z.studydir);
    info={};
    info(end+1,:)={'study:'                 [studyName]} ;
    info(end+1,:)={'studyPath:'             [z.studydir]} ;
    info(end+1,:)={'date:'                  [datestr(now)]} ;
    info(end+1,:)={' '     '  '} ;
    info= plog([],[info],0,'INFO','plotlines=0;al=1');
   
    v1=struct('txy', [0 1.8 ], 'tcol', [0 0 0],'tfs',11, 'tbgcol',[0.9843    0.9686    0.9686],...
        'tfn','consolas');
    v1.text=info;
    %=============
    if isempty(z.tb);
        tx2=plog([],[{'region' 'id' 'ce_x' 'ce_y' 'ce_z'} ;{'none' '' ''  '' ''}],0,'','al=1;plotlines=0');
    else
        tb2=[z.tb(:,1:2) num2cell(cell2mat(z.tb(:,3)))];
        tx2=plog([],[{'region' 'id' 'ce_x' 'ce_y' 'ce_z'} ;tb2],0,'','al=1;plotlines=0');
    end
    v2=struct('txy', [0 4 ], 'tcol', [0 0 0],'tfs',10, 'tbgcol',[1 1 1],...
        'tfn','consolas');
    v2.text=tx2;
    %=============
    paralist=z.batch(max(regexpi2(z.batch,'^z=\[\];')):end);
    paralist=[{' *** PARAMETER/BATCH ***   '}; paralist ];
    v3=struct('txy', [0 12 ], 'tcol', [0 0 1],'tfs',8, 'tbgcol',[1 1 1],...
        'tfn','consolas');
    v3.text=paralist;
    if ~isempty(z.tb_notfound)
        missregs=plog([],[{'The following Regions were not found: '}; z.tb_notfound(:)],0,'Regions not found','al=1; plotlines=0');
        v2miss=struct('txy', [12 4 ], 'tcol', [0 0 0],'tfs',10, 'tbgcol',[1.0000    0.9490    0.8667],...
            'tfn','consolas');
        v2miss.text=missregs;
        vs={v1 v2 v2miss v3};
    else
        vs={v1 v2 v3};
    end
    img2ppt([],[], pptfile,'doc','add',...
        'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
        'text','','tfs',8,'txy',[0 6],'tcol', [0 0 0],'tbgcol',[0.9451    0.9686    0.9490], 'tfn','consolas',...
        'multitext',vs,'disp',0 );   
    %% ===============================================
    showinfo2([ 'created PPTfile' ] ,pptfile);
    %% ===============================================
end


function z=cutNsplitImages(z)
%% ===============================================
f1=z.mricroglfile;
[a map]=imread(f1);
% =============[index of cut 2 images: cut in middle with focus on right image ] ==================================
m=mean(double(a),3);
mv=mean(m,1);
ix=find(mv==255);
[idx ce ]= kmeans(ix(:),3);
ces=sort(ce);
iv=find(ce==ces(2));
isep=ix(find(idx==iv));
isplit=isep(end)-10;
% ===========[ idices of up/down CUT]====================================
b=a(:,1:min(find(mv==0))-1);
d=mean(b,2);
iv=find(d==255);
tol=10;
bo=[ min(find(d~=255))   iv(find(diff(iv)>1)+1) ];
ud=[bo(1)-10 bo(2)+tol];
% ===========[split orig file]====================================
a1=a(ud(1):ud(2),  1:isplit,:);
a2=a(ud(1):ud(2),  isplit+1:end,:);
% =========[save images]======================================
[pax name ext]=fileparts(f1);
% IMG-1
% fname=[strrep(name,'Combi_','slice_') ext];
fname=['p_' pnum(z.num,2)  '_1' '__' z.tb{z.num,1} '.png'  ];
f2=fullfile(pax,[fname]);
imwrite(a1,f2,'png','transparency',[1 1 1]);
% showinfo2(['cutImg1'],f2);

% IMG-2
% fname=[strrep(name,'Combi_','cutpos_') ext];
fname=['p_' pnum(z.num,2)  '_2' '__' z.tb{z.num,1} '.png'  ];
f2=fullfile(pax,[fname]);
imwrite(a2,f2,'png','transparency',[1 1 1]);
% showinfo2(['cutImg1'],f2);

%% ===============================================
function z=saveImageMricronGLM(z)
%% ===============================================
exefile=z.exefile;%z.mricrogl_path;
slice=z.regcenterXYZ(2);
if round(slice)==0;
    slice= round(slice);
end
f1=fullfile(fileparts(z.NIIout),'AVGT.nii');
f2=z.NIIout;
f3=fullfile(z.outdir, ['pmix_' pnum(z.num,2)  '__' z.tb{z.num,1} '.png'  ]);
% lutdir=(fullfile(fileparts(exefile),'Resources','lut'));
% [luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);
% cmapname=luts{3};
% [~,lutname]=fileparts(cmapname);

if any(isnan(z.bg_clim))
    bglims='';
else
    bglims =['gl.minmax(0,'  num2str(z.bg_clim(1)) ',' num2str(z.bg_clim(2)) ')' ];
end
if any(isnan(z.ovl_clim))
    ovlims='';
else
    ovlims =['gl.minmax(1,'  num2str(z.ovl_clim(1)) ',' num2str(z.ovl_clim(2)) ')' ];
end
linecolStr=strjoin(cellstr(num2str(round(z.linecolor(:)*255))),',');%'255,0,0'
[~,lutname]=fileparts(z.ovl_cmap);
c1={
    ['import gl']
    ['gl.backcolor(255,255,255)']
    ['gl.loadimage('''   strrep(f1,filesep,[filesep filesep]) ''')']
    %     ['#gl.minmax(0, 50,300)']
    bglims
    ['gl.colorfromzero(0,1)']
    ['gl.overlayload('''   strrep(f2,filesep,[filesep filesep]) ''')']
    % ['gl.colorname(1,''2green.lut'')']
    ['gl.colorname (1,''' lutname ''')']
    %     ['gl.minmax(1, 0, 1)']
    ovlims
    ['gl.opacity(1,' num2str(z.opacity) ')']
    ['gl.mosaic(''C H 0 V 0 ' num2str(num2str(slice)) ' S X R 0'')']
    % ['gl.mosaic(''C L+ H 0 V 0 ' num2str(num2str(slice)) ' S X R 0'')']
    ['gl.colorbarposition(0)']
    ['gl.linewidth (' num2str(z.linewidth) ')']
    ['gl.linecolor(' linecolStr ')']
    % ['#gl.wait(1000)']
%     ['gl.fullscreen(1)']
%     ['gl.scriptformvisible(0)']
%     ['gl.toolformvisible(0)']
    % ['#gl.bmpzoom(1) ']   %#will save bitmaps at twice screen resolution
    % % ['gl.savebmp('F:/data9/region_redering_mricrogl/out/Combi_imgno_01.png')']
    ['gl.savebmp(''' strrep(f3,filesep,[filesep filesep]) ''')']
    ['quit()']
    };
cm=[c1];
% =====[save PNG as tempfile]===========================
cm2=strjoin(cm,'^');
cmd=(['"' exefile '"' ' -s "' cm2 '" &']);
system(cmd);
check_filepermission(f3);
% showinfo2([ 'file' ] ,f3);
%% ===============================================
z.mricroglfile=f3;


function htmllist=getclut(palut);
%% ===============================================
% pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
%
% exefile='C:\paulprogramme\MRIcroGL\MRIcroGL.exe';
% palut=fullfile(fileparts(exefile),'Resources','lut');
% ls(fullfile(fileparts(exefile),'Resources','lut'))
% ls(palut)
%% ===============================================
% a=preadfile(fullfile(palut,'HOTIRON.clut')); a=a.all
% palut=(fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents','Resources','lut'))
[fis] = spm_select('List',palut,'.*.clut');fis=cellstr(fis);
fis(regexpi2(fis,'^\.'))=[];
fisFP=stradd(fis,[palut filesep],1);
htmllist={};
for i=1:length(fisFP)
    filename=fisFP{i};
    [cm]=clutmap(filename);
    html=getCMAP('html',{filename});
    htmllist(i,1)=html;
end
htmllist=strrep(htmllist,[palut filesep],'');
htmllist=strrep(htmllist,['[1]'],'');
% ##### INFO #####
% https://www.nitrc.org/plugins/mwiki/index.php/mricrogl:MainPage#Command_Line_Arguments
% https://kathleenhupfeld.com/scripting-figures-in-mricrogl/
% https://github.com/rordenlab/MRIcroGL/blob/master/PYTHON.md
% https://github.com/neurolabusc/MRIcroGL10_OLD/blob/master/COMMANDS.md
% https://www.nitrc.org/plugins/mwiki/index.php/mricrogl:MainPage#Scripting

function check_filepermission(f4)
max_attempts = 100; % Maximum number of retries
if ~iscell(f4);     f4=cellstr(f4);end
for i=1:length(f4)
    filename     = f4{i};
    attempt = 0;
    success = false;
    while ~success && attempt < max_attempts
        attempt = attempt + 1;
        fid = fopen(filename, 'r'); % Try opening the file for reading
        if fid ~= -1  % If opening succeeds
            fclose(fid); % Close the file
            success = true;
        else
            pause(0.2); % Wait 200 ms before retrying
        end
    end
end

function [z isfound]=makeNIfti(z, num);
% ==============================================
%%   get NIFTI
% ===============================================
isfound=1;
tb=z.tb;
[hb b mm]=rgetnii(z.atlas_image);
b2=b(:);
if tb{num,5}  >0  %define hemisphere
    potpathhemi={...
        fullfile(fileparts(z.atlas_image),'AVGThemi.nii');
        fullfile(fileparts(z.bg_image),'AVGThemi.nii');
        fullfile(fileparts(z.bg_mask),'AVGThemi.nii');
        };
    potpathhemi_exist=existn(potpathhemi);
    iuse=max(find(potpathhemi_exist==2));
    F1=potpathhemi{iuse};
    [hhemi hemi ]=rgetnii(F1);
    hemi=round(hemi);
    hv=hemi(:)==tb{num,5};
    b2=b2.*hv;
end
c=zeros(size(b2));
ix=find(b2==tb{num,2});
if ~isempty(tb{num,4})
    try
        child=tb{num,4};
        ids=sort([tb{num,2};  child(:) ]);
        [s1 s2]=ismember(b2,ids) ;%histc(b2,ids);
        %     uni=unique(s2); uni(uni==0)=[];
        %     for i=1:length(uni)
        %         v1=length(find(s2==uni(i)) );
        %         v2=length(find(b2==ids(i)) ) ;
        %
        %        disp( [   num2str(v1)  '--vs--' num2str(v2) ]  );
        %     end
        ix=find(s1==1);
        disp('..involving children of IDs');
    end
end

if isempty(ix)
   isfound=0; 
   disp(['not found: [' tb{num,1} ']']);
else
    c(ix,1)   =[1];
    regcenter=mean(mm(:,ix),2);
    z.regcenterXYZ=(regcenter');
    c2=reshape(c,size(b));
    z.num=num;
    %% ===============================================
    %% save images
    %% ===============================================
    % if z.saveImg==1
    %copy AVGT
    f1=z.bg_image;
    f2=fullfile(z.outdir,'AVGT.nii' );
    if exist(f2)~=2
        [hb b]=rgetnii(z.bg_image);
        [hm m]=rgetnii(z.bg_mask);
        b2=m.*b;
        rsavenii(f2, hb, b2, 64);
        %copyfile(f1,f2,'f');
    end
    
    %write NIFTI
    outname=['colorRegion_' num2str(num)];
    f3=fullfile(z.outdir, [outname '.nii']);
    rsavenii(f3, hb, c2, 64);
    % showinfo2(['targetFile:'],f2,f3,13); % actc
    z.NIIout=f3;
    co=sprintf('CenterXYZ(mm)[%2.2f %2.2f %2.2f]', z.regcenterXYZ );
    line=[ num2str(num) '] ' tb{num,1}  '  ' co  ];
    z.outtable=[z.outtable; line];
    
    %     %write excel
    %     f4=fullfile(savePath, [outname '.xlsx']);
    %     tb2=tb(:,[1 2  [4]   [5 6 7]]);
    %     htb2={'region' 'ID' 'tvalue' 'center_x' 'center_y' 'center_z'};
    %     sheetname=[ tag  isinverted ];
    %     pwrite2excel(f4,{1 sheetname},htb2,[],tb2);
    %     showinfo2(['lutfile:'],f4);
    % end
end


function z=getAtlas(z);
% ==============================================
%%  atlas get IDs/table
% ===============================================
z.regions=cellstr(z.regions);
if exist(z.regions{1})==2 %file
    z.regionsfile=z.regions{1};
    [pareg namereg extreg]=fileparts(z.regionsfile);
    if ~isempty(strfind(extreg,'.xls'))
        [~,~,a0]=xlsread(z.regionsfile);
        a0=xlsprunesheet(a0);
        z.regions=a0(2:end,1);        
    end
end
reg      =z.regions(:);
if isempty(char(z.atlas_image))  % from ant-template
    global an
    if isempty(an); error('no atlas specified in [atlas_image] '); end
    atl=fullfile(fileparts(an.datpath),'templates','ANO.nii');
    if exist(atl)~=2; error([ 'not found: "'  atl '"']); 
    else
        z.atlas_image=atl;
    end 
end
if isempty(char(z.bg_image))  % from ant-template
    global an
    if isempty(an); error('no image specified in [bg_image] '); end
    d=fullfile(fileparts(an.datpath),'templates','AVGT.nii');
    if exist(d)~=2; error([ 'not found: "'  d '"']); 
    else
        z.bg_image=d;
    end 
end
if isempty(char(z.bg_mask))  % from ant-template
    global an
    if isempty(an); error('no image specified in [bg_mask] '); end
    d=fullfile(fileparts(an.datpath),'templates','AVGTmask.nii');
    if exist(d)~=2; error([ 'not found: "'  d '"']); 
    else
        z.bg_mask=d;
    end 
end
[pa name ext]=fileparts(z.atlas_image);
z.atlas_xls=fullfile(pa,[name '.xlsx']);
%% ===============================================
[~,~,at0]=xlsread(z.atlas_xls);
hat=at0(1,:);
at=at0(2:end,:);
at(:,1)=cellfun(@(a) {[ num2str(a)]},at(:,1));
ID=[];
CH=[];
tb={};
tb_notfound={};
% hemitb={'L_'   1;
%     'R_'    2}
     
for i=1:length(reg)
    searchregion=reg{i} ;
     hemi=0 ;
    if isempty(regexpi2(at(:,1),'^L_|^R_'))
        if ~isempty(regexpi2({searchregion},'^L_'))
           searchregion= regexprep(searchregion,'^L_','');
           hemi=1;
        elseif ~isempty(regexpi2({searchregion},'^R_'))
            searchregion= regexprep(searchregion,'^R_','');
            hemi=2;
        end
    end    
    is=find(strcmp(at(:,1),searchregion  )   );
    if ~isempty(is)
        ID=at{is,4};
        if isnumeric((at{is,5}))
            at{is,5}=num2str(at{is,5});
        end
        CH=str2num(at{is,5});
        if any(isnan(CH)); CH=[]; end
        
        col= str2num(at{is,3})/255;
        tb(end+1,:)=  { reg{i} , ID , col CH  hemi};
    else
        tb_notfound(end+1,1)={reg{i}};
    end
end
z.infoOut='----out----';
z.tb=tb;
z.tb_notfound=tb_notfound;
return

% ==============================================
%%   get NIFTI
% ===============================================
[hb b mm]=rgetnii(z.atlas);
b2=b(:);
c=zeros(size(b2));
% c=nan(size(b2));
for i=1:size(tb,1)
    ix=find(b2==tb{i,2});
    %c(ix,1)   =tb{i,4};
    c(ix,1)   =[1];
    regcenter=mean(mm(:,ix),2);
    tb(i,5:7)=num2cell(regcenter');
end
c2=reshape(c,size(b));

%% ===============================================
%% code to save images
% set 'saveImg' to [1] to enable saving option
%% ===============================================
if saveImg==1
    try; rmdir(savePath,'s'); end
    if exist(savePath)==0; mkdir(savePath); end
    f1=avgt;
    f2=fullfile(savePath,'AVGT.nii' );
    copyfile(f1,f2,'f');
    
    %write NIFTI
    outname=['colorRegTvalue_' isinverted];
    f3=fullfile(savePath, [outname '.nii']);
    rsavenii(f3, hb, c2, 64);
    showinfo2(['targetFile:'],f2,f3,13); % actc
    
    %write excel
    f4=fullfile(savePath, [outname '.xlsx']);
    tb2=tb(:,[1 2  [4]   [5 6 7]]);
    htb2={'region' 'ID' 'tvalue' 'center_x' 'center_y' 'center_z'};
    sheetname=[ tag  isinverted ];
    pwrite2excel(f4,{1 sheetname},htb2,[],tb2);
    showinfo2(['lutfile:'],f4);
end

function colorbar_rgb=clutmap(filename)
fid = fopen(filename, 'r');
if fid == -1
    error('Could not open the CLUT file.');
end

% Initialize variables
node_intensities = [];
rgb_nodes = [];
num_colors = 256;  % Default number of colors in final colormap

% Read file line by line
while ~feof(fid)
    line = strtrim(fgetl(fid));
    % Read the number of nodes (numnodes)
    if strncmp(line, 'numnodes', 8)
        num_nodes = sscanf(line, 'numnodes=%d');
    end
    % Read node intensity indices
    if strncmp(line, 'nodeintensity', 13)
        values = sscanf(line, 'nodeintensity%d=%d');
        if numel(values) == 2
            node_idx = values(1) + 1;  % MATLAB 1-based index
            node_intensities(node_idx) = values(2) + 1;  % Store intensity index
        end
    end
    % Read RGBA values
    if strncmp(line, 'nodergba', 8)
        values = sscanf(line, 'nodergba%d=%d|%d|%d|%d');
        if numel(values) == 5
            node_idx = values(1) + 1;  % MATLAB 1-based index
            rgb_nodes(node_idx, :) = values(2:4);  % Extract R, G, B (ignore Alpha)
        end
    end
end
fclose(fid);% Close file
% Ensure node intensity and RGB values match
if length(node_intensities) ~= size(rgb_nodes, 1)
    error('Mismatch between node intensities and RGB nodes.');
end
% Step 1: Create an empty (n,3) colormap
colorbar_rgb = zeros(num_colors, 3);
% Step 2: Place RGB values at the specified node intensities
for i = 1:length(node_intensities)
    idx = node_intensities(i); % Get the color index
    if idx > 0 && idx <= num_colors
        colorbar_rgb(idx, :) = rgb_nodes(i, :);
    end
end
% Step 3: Interpolate missing colors
x_original = node_intensities; % Known intensity positions
x_interp = 1:num_colors; % Full range

% Interpolating R, G, B separately
colorbar_rgb(:,1) = interp1(x_original, rgb_nodes(:,1), x_interp, 'linear', 'extrap');
colorbar_rgb(:,2) = interp1(x_original, rgb_nodes(:,2), x_interp, 'linear', 'extrap');
colorbar_rgb(:,3) = interp1(x_original, rgb_nodes(:,3), x_interp, 'linear', 'extrap');
% colorbar_rgb(:,1) = interp1(x_original, rgb_nodes(:,1), x_interp, 'linear');
% colorbar_rgb(:,2) = interp1(x_original, rgb_nodes(:,2), x_interp, 'linear');
% colorbar_rgb(:,3) = interp1(x_original, rgb_nodes(:,3), x_interp, 'linear');

% Normalize RGB values to [0, 1] for MATLAB colormap
colorbar_rgb = colorbar_rgb / 255;
colorbar_rgb(colorbar_rgb>1)=1;
colorbar_rgb(colorbar_rgb<0)=0;


function o=get_mrigroglPath()
%% ===============================================
o='';
if     ispc  ;    fmt='*.exe';
elseif ismac ;    fmt='*.app';  disp([['....select MRicroGL-executable (' fmt ') ']]);
else   isunix;   fmt='*.*';
end

[fi, pa] = uigetfile(fmt, ['select MRicroGL-executable (' fmt ') ']);
if isnumeric(fi); return ;end
exec=fullfile(pa,fi);
if ismac;     exec=fullfile(exec, 'Contents','MacOS','MRIcroGL');  end
if exist(exec)==2
    o=exec;
end
return

