
% PLOT ORTHOVIEW OVERLAYS USING MRicroGL
% #r this function is *** OS-INDEPENDENT
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
%
%% #wb *** PARAMETER ***
% ===[IMAGES]================================================================================================
% 'bg_image'     Background image. If empty, "AVGT.nii" from the template folder is used.
% 'ovl_images'   One or more images to overlay onto bg_image separately.
% 'bg_clim'      Background image intensity limits [min, max]. If set to [nan nan], limits are defined automatically.
%                   Examples: [0 200] or [nan nan]
% 'ovl_clim'     Overlay image intensity limits [min, max]. If set to [nan nan], limits are defined automatically.
%                   Examples: [0 200] or [nan nan]
% 'ovl_cmap'     Overlay image colormap .. see icon for colormap.
% 'opacity'      Opacity of the overlayed image: {0, 20, 40, 50, 60, 80, 100}
%                   Example: [50]
% 'linewidth'    Line width of crosshairs (numeric).
%                   Default: 5
% 'linecolor'    Crosshair color (normalized RGB, range 0-1).
%                   Default: [1 1 1] (white).. see icon.
% 
% ===[COORDINATES]================================================================================================
% 'xyzmm'        XYZ coordinates in mm, specified as either a 1x3 vector or an n-by-3 matrix.
%                   Examples:
%                      [-2.15  1.356 0.2]   (single coordinate, in mm)
%                      [-2.15  1.356 0.2; 0 0 0; 1 0 2; 4 5 1]  (multiple coordinates)
% 
% ===[PLOT VIEW ARRANGEMENT] ====================================================================
% 'png_SingleRow' Forces all views – (C)oronal, (A)xial, (S)agittal – into a single row; {0,1}
%                   Default: [1]
%                   - If [0]: The axial view is placed in the second row (default MRIcroGL output).
%                   - If [1]: All views are arranged in a single row (space-saving).
% 'png_views'     Views to keep.
%                   Default: [1 2 3] ? coronal, sagittal, axial (in that order).
%                   Other options:
%                         C-S:  [1 2] 
%                         C-A:  [1 3] 
%                         S-A:  [2 3] 
%                         C:    [1] 
%                         S:    [2] 
%                         A:    [3] 
%                    The order of views can be changed, e.g., [3 2 1] or [3 1].
% 
% ===[COLORBAR] ====================================================================
% 'cbar_label'    Colorbar label. If empty, the colorbar has no label (string).
%                   Examples: 'Lesion [%]' or 'Intensity [a.u.]'
% 'cbar_fs'       Colorbar font size.
%                   Default: [12]
% 'cbar_fontname' Colorbar font name .. see icon for fonts.
%                   Examples: 'Arial', 'Consolas', 'Helvetica'
% 'cbar_fcol'     Colorbar font color (3 values) ? select color from icon.
%                   Example: [1 1 1] (white)
% 
% ===[OUTPUT PARAMETERS] ====================================================================
% 'outdir'         Output directory. If empty, plots/PPT files are stored in the directory of "ovl_images".
% 'ppt_filename'   PowerPoint filename.
%                   Example: 'lesion'
% 'plotdir_suffix' A subdirectory that contains the created PNG files (located in "outdir").
%                   The directory name is defined as "ppt_filename" + "plotdir_suffix".
% 'makePPT'        Create a PowerPoint file with images and information; {0,1}
%                   Default: [1]
% 'sort'           Defines the sorting of PNG images in the PowerPoint file.
%                   Options: {'coordinate' | 'image'}; Default: 'coordinate'
%                    'coordinate': Plots are ordered with respect to coordinates 
%                                   (i.e., the same coordinates appear first).
%                                   Preferred for comparing a coordinate across multiple images, 
%                                   which will appear next to each other on the same PPT slide.
%                    'image'     : Plots are ordered with respect to images (i.e., the overlay images)
%                                   (i.e., the same images appear first).
%                                   Preferred for inspecting multiple coordinates in the same image.
% 
% ===[MISC] ====================================================================
% 'closeMricroGL'  Close MRIcroGL after execution; {0,1}
%                   Default: [1]
% 'mricroGL'       <optional> Specify the full path of the MRIcroGL executable if not found automatically.
%                   - See MRIcroGL installation (above).
%                   Windows example: 'C:\paulprogramme\MRIcroGL3\MRIcroGL.exe'
%                   macOS example: '/Users/klausmaus/MRIcroGL.app'
% 
%
%% #wb *** RUN ***
% xplotslices_mricrogl(1) or  xplotslices_mricrogl    ... open PARAMETER_GUI
% xplotslices_mricrogl(0,z)             ...NO-GUI,  z is the predefined struct
% xplotslices_mricrogl(1,z)             ...WITH-GUI z is the predefined struct
%
%
%% #wb *** EXAMPLES ***
%% EXAMPLE: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
%% make images & powerpoint
% 
% 
%% EXAMPLE-1: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
%% make images & powerpoint, force single-row
% z=[];                                                                                                                                                                                                      
% z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
% z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
%                      'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
% z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
% z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
% z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
% z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
% z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
% z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
% z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
% z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
% z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
% z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
% z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
% z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
% z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
% z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
% z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
% z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
% z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
% z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
% z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
% z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
% xplotortho_mricrogl(0,z);
% 
%% ===============================================
%% EXAMPLE-2: as before but use two rows (z.png_SingleRow=[0])
% z=[];                                                                                                                                                                                                      
% z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
% z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
%                      'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
% z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
% z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
% z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
% z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
% z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
% z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
% z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                                                                                                                                                                                      
% z.png_SingleRow  = [0];                                                                            % % force all views into one row; {0|1}                                                                 
% z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
% z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
% z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
% z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
% z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
% z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
% z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
% z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
% z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
% z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
% z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
% z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
% xplotortho_mricrogl(0,z); 
% 
%% ===============================================
%% EXAMPLE-3: as EXAMPLE-2 but show create only coronar slices (z.png_views= [1];  )
% z=[];                                                                                                                                                                                                      
% z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
% z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
%                      'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
% z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
% z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
% z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
% z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
% z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
% z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
% z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
% z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
% z.png_views      = [1];                                                                            % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
% z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
% z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
% z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
% z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
% z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
% z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
% z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
% z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
% z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
% z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
% z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
% xplotortho_mricrogl(0,z); 
%% EXAMPLE-4: plot ANO-atlas at specifix mm-coordinates
% z=[];                                                                                                                                                                                      
% z.bg_image       = 'F:\data8\mricron_makeSlices_plots\templates\AVGT.nii';        % % background image; if empty, "AVGT.nii" from the template folder is used                              
% z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\templates\ANO.nii' };     % % overlay one or more images onto bg_image                                                             
% z.bg_clim        = [50  200];                                                     % % background image intensity limits [min,max]; [nan nan] = auto                                        
% z.ovl_clim       = [0  1000];                                                     % % overlay image intensity limits [min,max]; [nan nan] = auto                                           
% z.ovl_cmap       = 'actc.clut';                                                   % % overlay colormap                                                                                     
% z.opacity        = [50];                                                          % % overlay opacity (0-100)                                                                              
% z.linewidth      = [5];                                                           % % crosshair line width                                                                                 
% z.linecolor      = [1  1  1];                                                     % % crosshair color (RGB, range 0-1)                                                                     
% z.xyzmm          = [0 -7 -4; 0 -4 -4 ; 0 -1 -2; 0 2 -2 ]                         % % XYZ coordinates in mm (n×3 matrix)                                                                                                                                                                                                          
% z.png_SingleRow  = [1];                                                           % % force all views into one row; {0|1}                                                                  
% z.png_views      = [1  2  3];                                                     % % views to keep; default: [1 2 3] (coronal, sagittal, axial)                                           
% z.cbar_label     = 'atlas IDs';                                                   % % colorbar label; empty = no label                                                                     
% z.cbar_fs        = [12];                                                          % % colorbar font size                                                                                   
% z.cbar_fontname  = 'Helvetica';                                                   % % colorbar font name (e.g., Arial, Consolas, Helvetica)                                                
% z.cbar_fcol      = [1  1  1];                                                     % % colorbar font color                                                                                  
% z.outdir         = 'F:\data8\mricron_makeSlices_plots\results2';                % % output directory; if empty, plots/PPT are stored in "ovl_images" DIR                                 
% z.ppt_filename   = 'ABA_atlas';                                                       % % PowerPoint filename                                                                                  
% z.plotdir_suffix = '_plots';                                                      % % subdirectory for PNG files (in "outdir"), named as "ppt_filename" + "plotdir_suffix"                 
% z.makePPT        = [1];                                                           % % create PowerPoint with images and info                                                               
% z.sort           = 'coordinate';                                                  % % sort PNGs in PowerPoint by {coordinate|image}                                                        
% z.closeMricroGL  = [1];                                                           % % close MRIcroGL after execution                                                                       
% z.mricroGL       = '';                                                            % % <optional> specify full path to MRIcroGL exe/app if not auto-detected (SEE HELP)                     
% xplotortho_mricrogl(0,z);  
% 
% 

function [z]=xplotortho_mricrogl(showgui,x,pa)

clc
%===========================================
%%   PARAMS
%===========================================
isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end

if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end


% exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
% if ispc==1
%     exefile='C:\paulprogramme\MRIcroGL\MRIcroGL.exe';
% else % mac
%     exefile='/Applications/MRIcroGL.app/Contents/MacOS/MRIcroGL';
% end

% exefile=getExecutable();

% ==============================================
%%   PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
palut=(fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents','Resources','lut'));
htmllist=getclut(palut);


% clipboard('copy',['[' regexprep(num2str(80:15:200),'\s+',',') ']'])
% viewopt={};
% viewopt(end+1,:)={'coronal'             2 };
% viewopt(end+1,:)={'sagittal'            1 };
% viewopt(end+1,:)={'axial'               3  };

xyzmmopt={};
xyzmmopt(end+1,:)={'xyz(mm):[0 0 0]'                                     [0 0 0] };
xyzmmopt(end+1,:)={'xyz(mm):[0 0 0; -1 -1 -1]'                           [0 0 0; -1 -1 -1] };
xyzmmopt(end+1,:)={'xyz(mm):[-.1 -.1 -.1; 0 0 0 ; -1 -1 -1]'             [-.1 -.1 -.1; 0 0 0 ; -1 -1 -1] };
xyzmmopt(end+1,:)={'xyz(mm):[-.1 -.1 -.1; 0 0 0 ; -1 -1 -1;0 -1 3; -2.5 -2 -3]'   [-.1 -.1 -.1; 0 0 0 ; -1 -1 -1;0 -1 3; -2.5 -2 -3] };

png_views={};
png_views(end+1,:)={'(c)oronal-(s)agittal-(a)xial;  [1 2 3]' [1 2 3] };
png_views(end+1,:)={'c-s;  [1 2 ]' [1 2] };
png_views(end+1,:)={'c-a;  [1 3 ]' [1 3] };
png_views(end+1,:)={'s-a;  [2 3 ]' [2 3] };
png_views(end+1,:)={'c;       [1]' [1] };
png_views(end+1,:)={'s;       [2]' [2] };
png_views(end+1,:)={'a;       [3]' [3] };

p={
    % IMAGES ====================================================================
    'inf11' ['__[IMAGES]__' repmat('_',[1 70])  ] '' ''
    'bg_image'     ''                'background image; if empty, "AVGT.nii" from the template folder is used'     'f'
    'ovl_images'   {''}              'overlay one or more images onto bg_image'                      'mf'
    'bg_clim'      [50 200 ]         'background image intensity limits [min,max]; [nan nan] = auto'    {[0 200 ]; [nan nan]}
    'ovl_clim'     [0 100 ]          'overlay image intensity limits [min,max]; [nan nan] = auto'       {[0 200 ]; [nan nan]}
    'ovl_cmap'     'NIH_fire.lut'    'overlay colormap'          {'cmap',htmllist}
    'opacity'      70                'overlay opacity (0-100)'     {0,20,40,50,60,80,100}
    'linewidth'    [5]               'crosshair line width'        num2cell(0:10)
    'linecolor'    [1 1 1]           'crosshair color (RGB, range 0-1)'  'col'
    
    % COORDINATE ====================================================================
    'inf21' '' '' ''
    'inf22' ['__[COORDINATE]__' repmat('_',[1 70])  ] '' ''
    'xyzmm'      [-1.27 0.03 -3.48]  'XYZ coordinates in mm (n×3 matrix)'   xyzmmopt  
    
    % PLOT VIEW ARRANGEMENT ====================================================================
    'inf31' '' '' ''
    'inf32' ['__[PLOT VIEW ARRANGEMENT]__' repmat('_',[1 70])  ] '' ''
    'png_SingleRow'   [1]      'force all views into one row; {0|1}'    'b'
    'png_views'       [1 2 3]  'views to keep; default: [1 2 3] (coronal, sagittal, axial)'   png_views
    
    % COLORBAR ====================================================================
    'inf41' '' '' ''
    'inf42' ['__[COLORBAR]__' repmat('_',[1 70])  ] '' ''
    'cbar_label'      'lesion [%]'  'colorbar label; empty = no label' {'lesion [%]'; 'intensity [a.u.]'}
    'cbar_fs'         12            'colorbar font size'     [num2cell(7:30)']
    'cbar_fontname'   'Helvetica'   'colorbar font name (e.g., Arial, Consolas, Helvetica)' listfonts
    'cbar_fcol'       [1 1 1]       'colorbar font color'   'col'
    
    % OUTPUT ====================================================================
    'inf70' '' '' ''
    'inf71' ['__[OUTPUT PARAMETERS]__' repmat('_',[1 70])  ] '' ''
    'outdir'         ''           'output directory; if empty, plots/PPT are stored in "ovl_images" DIR'   'd'
    'ppt_filename'   'lesion'     'PowerPoint filename'  {'incidencemaps' '_test2'}
    'plotdir_suffix' '_plots'     'subdirectory for PNG files (in "outdir"), named as "ppt_filename" + "plotdir_suffix"'  {'_plots' '_figs'}
    'makePPT'        1            'create PowerPoint with images and info'  'b'
    'sort'                        'coordinate'  'sort PNGs in PowerPoint by {coordinate|image}'  {'coordinate','image'}
    
    % MISC ====================================================================
    'inf80' '' '' ''
    'inf81' ['__[MISC]__' repmat('_',[1 70])  ] '' ''
    'closeMricroGL'  1  'close MRIcroGL after execution'  'b'
    'mricroGL'   '' '<optional> specify full path to MRIcroGL exe/app if not auto-detected (SEE HELP)'  {@get_mrigroglPath}
};



% p={
%     % IMAGES ====================================================================
%     'inf11' ['__[IMAGES]__' repmat('_',[1 70])  ] '' ''
%     'bg_image'     ''                'background image, if empty, than "AVGT.nii" from template-folder is used'     'f'
%     'ovl_images'   {''}              'get one/more images to separately overlay onto bg_image'                      'mf'
%     'bg_clim'      [50 200 ]         'background-image: intensity limits [min,max], if [nan nan]..automatically defined'    {[0 200 ]; [nan nan]}
%     'ovl_clim'     [0 100 ]          'overlay-image: intensity limits [min,max], if [nan nan]..automatically defined'       {[0 200 ]; [nan nan]}
%     'ovl_cmap'     'NIH_fire.lut'    'overlay-image: colormap '          {'cmap',htmllist}
%     'opacity'      70                'overlay opacity range: 0-100 '     {0,20,40,50,60,80,100}'
%     'linewidth'    [5]               'crosshairs-linewidht'              num2cell(0:10)
%     'linecolor'    [1 1 1]           'crosshairs-color'                  'col'
%     % coordinate ====================================================================
%     'inf21' '' '' ''
%     'inf22' ['__[coordinate]__' repmat('_',[1 70])  ] '' ''
%     'xyzmm'      [-1.27 0.03 -3.48]  'xyz-coordinates in mm (nx3-matrix)'   xyzmmopt  %[60,73,86,99,112,125,138]
%     % coordinate ====================================================================
%     'inf31' '' '' ''
%     'inf32' ['__[PLOTVIEW ARANGEMENT]__' repmat('_',[1 70])  ] '' ''
%     'png_SingleRow'   [1]      'force all views into one row; {0|1}'    'b'
%     'png_views'       [1 2 3]  'views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}'   png_views
%     %    {[1 2 3];[1 2];[1 3];[2 3]}
%     % COLORBAR ====================================================================
%     'inf41' '' '' ''
%     'inf42' ['__[COLORBAR]__' repmat('_',[1 70])  ] '' ''
%     'cbar_label'      'lesion [%]'  'colorbar: label, if empty cbar has no label' {'lesion [%]'; 'intensity [a.u.]'}
%     'cbar_fs'         12            'colorbar: fonsize'     [num2cell(7:30)']
%     'cbar_fontname'   'Helvetica'   'fontName example: arial/consolas/Helvetica' listfonts
%     'cbar_fcol'       [1 1 1]       'colorbar: fontcolor a color'                         'col'
%     % OUTPUT ====================================================================
%     'inf70' '' '' ''
%     'inf71' ['__[OUTPUT-PARAMETER]__' repmat('_',[1 70])  ] '' ''
%     'outdir'         ''           'output-dir, if empty plots/ppt-file in the DIR of the ovl_images'   'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
%     'ppt_filename'   'lesion'     'PPT-filename'  {'incidencemaps' '_test2'}
%     'plotdir_suffix' '_plots'     'DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" '         {'_plots' '_figs'}
%     'makePPT'        1            'make powerpoint with image and infos'  'b'
%     'sort'                        'coordinate'  'png-images in powerpoint is sorted after  {coordinate|image}'  {'coordinate','image'}
%     %MISC====================================================================
%     'inf80' '' '' ''
%     'inf81' ['__[MISC]__' repmat('_',[1 70])  ] '' ''
%     'closeMricroGL'  1  'close MricroGl afterwards'  'b'
%     'mricroGL'   '' '<optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)'  {@get_mrigroglPath}
%     };
% [m z]=paramgui(p,'close',1,'figpos',[0.2 0.4 0.5 0.35],'info',{@uhelp, 'paramgui.m' },'title','GUI-123'); %%START GUI
%% ====[test]===========================================
% if 1
%     cprintf('*[1 0 1]',[ '   TESTDATA'  '\n'] );
%     pa='F:\data8\mricron_makeSlices_plots';
%     f1=fullfile(pa,'AVGT.nii');
%     % f2=fullfile(pa,'MAPpercent_x_masklesion_24h_KO.nii')
%     [ovl] = spm_select('FPList',pa,'^MAP.*.nii');
%     ovl=cellstr(ovl);
%     ovl=ovl(1);
%     p(find(strcmp(p(:,1),'bg_image')),2)={f1};
%     p(find(strcmp(p(:,1),'ovl_images')),2)={ovl};
% end
%% ===============================================

% NIH_ice.lut'

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
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

z_bk=z;

% ==============================================
%%  proc
% https://people.cas.sc.edu/rorden/mricron/bat.html
% ===============================================
%% ====get executable ===========================================
z.mricroGL=char(z.mricroGL);
if ~isempty(z.mricroGL) && exist(z.mricroGL)==2
    exefile=z.mricroGL;
else
    exefile=getExecutable();
end


%% ====define parameter===========================================
z.bg_image   =char(   z.bg_image);
z.ovl_images =cellstr(z.ovl_images);
z.outdir     =char(   z.outdir);
[~, z.ppt_filename] =fileparts(z.ppt_filename);
if isempty(z.ppt_filename); z.ppt_filename='test123'; end



global an
if isempty(an)
    studydir=fileparts(z.ovl_images{1});
else
    studydir=fileparts(an.datpath);
end
if isempty(z.outdir)
    z.outdir=fullfile(studydir,'results');
end
if exist(z.outdir)~=7; mkdir(z.outdir); end
if isempty(z.bg_image)
    z.bg_image=fullfile(studydir, 'templates','AVGT.nii');
end
outdir=z.outdir;
outdirplot=fullfile(outdir, [ [z.ppt_filename z.plotdir_suffix]]);
if exist(outdirplot)~=7; mkdir(outdirplot); end
delete(fullfile(outdirplot ,'*.png'));




% ==============================================
%%   get lut and trans
% ===============================================


% lutdir=(fullfile(fileparts(exefile),'lut'));
lutdir=(fullfile(fileparts(exefile),'Resources','lut'));
[luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);
% luttb=[num2cell([1:length(luts)]'-1)  luts];
cmapname=z.ovl_cmap;
% cmapnum =find(strcmp(luttb(:,2), cmapname));
[o o2]=getCMAP(cmapname);
call='';
endtag=' &';
if exist(exefile)==2
    call=[call  exefile  ' '];
end
[~,lutname]=fileparts(cmapname);

trans=z.opacity;
if ~isempty(trans)
    if trans<=1
        trans=trans*100;
    end
else
    trans=50;
end
% ==============================================
%%   loop over images
% ===============================================
ovl=z.ovl_images;
f1 =z.bg_image;
% sp='';
% if z.sliceplot==1
%     spdir='';
%     if z.sliceplotDir<0; spdir='-'; end
%     sp=[viewssliceblock ' X R ' spdir '0.5' ];
% end
linecolStr=strjoin(cellstr(num2str(round(z.linecolor(:)*255))),',');%'255,0,0'
gl_quit    ='';    if z.closeMricroGL==1;  gl_quit    ='gl.quit()'     ;      end
% slicelabel ='';    if z.slicelabel  ==1;  slicelabel ='L'             ;      end
% olapp      =num2str(z.sliceOverlapp);
% rowlapp    =num2str(z.rowOverlapp);
% %% =====[rows]==========================================
% rows=z.nrows;
% if rows==1
%     slices_gl_str=sprintf('%2.2f ',slices_gl);
% else
%     sl=cellfun(@(a) {[ num2str(a)  ]},num2cell(slices_gl));
%     ncol=ceil((length(sl)+z.sliceplot  )/rows);
%     w='';
%     for j=1:length(sl)
%         w=[w ' ' sl{j}];
%         if mod(j,ncol)==0; w(1,end+1)=';'; end
%     end
%     slices_gl_str=w;
% end
%% ===============================================




pnglist={};
for i=1:length(ovl)
    f2=ovl{i};
    [~, name,ext]=fileparts(f2);
    if any(isnan(z.bg_clim));  bglims='';
    else                       bglims =['gl.minmax(0,'  num2str(z.bg_clim(1)) ',' num2str(z.bg_clim(2)) ')' ];
    end
    if any(isnan(z.ovl_clim)); ovlims='';
    else                       ovlims =['gl.minmax(1,'  num2str(z.ovl_clim(1)) ',' num2str(z.ovl_clim(2)) ')' ];
    end
    
    
    
    %% ===============================================
    if iscell(z.xyzmm)
        xyzmm=cell2mat(z.xyzmm(:));
    else
        xyzmm=z.xyzmm;
    end
    
    f4={};
    for j=1:size(xyzmm,1)
        f4{end+1,1}=[fullfile(outdirplot,[ 'p_' pnum(i,2) '_' name  '_xyz' pnum(j,2) '.png'])];
    end
    
    
    c1={'"import gl'
        
    'gl.resetdefaults()'
    ['gl.overlayloadsmooth(1)']
    ['gl.loadimage('''   strrep(f1,filesep,[filesep filesep]) ''')']
    'gl.orthoviewmm(-2,0,-3)'
    %     ['gl.overlayloadsmooth(1)']
    ['gl.overlayload('''   strrep(f2,filesep,[filesep filesep]) ''')']
    [bglims]
    [ovlims]
    ['gl.colorname (1,''' lutname ''')']
%     ['gl.invertcolor(0,1)']
    %
    %         ['gl.backcolor(0, 255, 0)']
    %     ['gl.SHADERNAME(''overlay'')']
    ['gl.opacity(1,' num2str(trans) ')']
    ['gl.linewidth (' num2str(z.linewidth) ')']
    ['gl.linecolor(' linecolStr ')']
    ['gl.colorbarposition(0)']  % 0,1,2
    };
% ===============================================
c2={};
for j=1:size(xyzmm,1)
    c2{end+1,1}=['gl.wait(100)' ];
    c2{end+1,1}=['gl.orthoviewmm(' regexprep(num2str(xyzmm(j,:)),'\s+',',') ')'];
    c2{end+1,1}=['gl.wait(100)' ];
    c2{end+1,1}=['gl.savebmp(''' strrep(f4{j},filesep,[filesep filesep]) ''')'];
end
% ===============================================
c3={[gl_quit]};
cm=[c1;c2;c3];
% =====[save PNG as tempfile]===========================
cm2=strjoin(cm,'^');
cmd=(['"' exefile '"' ' -s ' cm2 '" &']);
system(cmd );
%     showinfo2(['png:'],f4);
% ===============================================
check_filepermission(f4);
png_makeSingleRow(z, f2,f4 );
pnglist=[pnglist;f4];
end


% ==============================================
%%   colorbar
% ===============================================
% cf;
delete(findobj(0,'tag','colorbarTemp'));
% fg; hf=gcf;
hf=figure('visible','off');
set(hf,'tag','colorbarTemp');
set(gcf,'position',[ 585   421   100   189] );


ax = axes;
c = colorbar(ax);
colormap(o)
ax.Visible = 'off';
caxis(z.ovl_clim);
set(c,'fontsize',z.cbar_fs,'fontweight','bold');
set(hf,'menubar','none');
set(hf,'color','none');
set(gca,'color','none');
c.Color=z.cbar_fcol;
c.Label.String  = z.cbar_label;
c.FontName      = z.cbar_fontname;
c.FontSize      =z.cbar_fs;
c.Label.FontSize=z.cbar_fs;

pos=get(c,'position');
set(c,'position',[pos(1)-.5 pos(2) pos(3)+0.05 pos(4) ]);
set(c, 'YAxisLocation','right');
set(gca,'units','pixels');
set(hf,'units','pixels');
clear p
p.bgtransp =0;
p.saveres  =200;
p.crop     =0;
file_legend=fullfile(outdirplot,'legend.png');

if p.bgtransp==1; set(hf,'InvertHardcopy','on' );
else ;            set(hf,'InvertHardcopy','off');
end
% set(gcf,'color',[1 0 1]);
% set(findobj(gcf,'type','axes'),'color','none');
% set(hf,'InvertHardcopy','off');
% print(hf,file_legend,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
print(hf,file_legend,'-dpng',['-r'  num2str(p.saveres) ]);
% showinfo2(['legend:'],file_legend);
if p.bgtransp==1 || p.crop==1;
    [im hv]=imread(file_legend);
    if p.crop==1;
        v=mean(double(im),3);
        v=v==v(1,1);
        v1=mean(v,1);  mima1=find(v1~=1);
        v2=mean(v,2);  mima2=find(v2~=1);
        do=[mima2(1)-1 mima2(end)+1];
        ri=[mima1(1)-1 mima1(end)+1];
        if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
        if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
        im=im(do(1):do(2),ri(1):ri(2),:);
    end
    if p.bgtransp==1
        imwrite(im,file_legend,'png','transparency',[1 1  1],'xresolution',p.saveres,'yresolution',p.saveres);
        if 0
            imd=double(im);
            pix=squeeze(imd(1,1,:));
            m(:,:,1)=imd(:,:,1)==pix(1);
            m(:,:,2)=imd(:,:,2)==pix(2);
            m(:,:,3)=imd(:,:,3)==pix(3);
            m2=sum(m,3)~=3;
            imwrite(im,file_legend,'png','alpha',double(m2));
        end
        %         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],file_legend);
    else
        imwrite(im,file_legend,'png');
    end
end
close(hf);
delete(findobj(0,'tag','colorbarTemp'));
% showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],file_legend);

%% ===============================================
%%   PPT
%% ===============================================
if z.makePPT==1
    %% ====[sort after:  (1) as is; (2): same cord]===========================================
    fis=pnglist;
    [~, pngname_nofmt ext]=fileparts2(fis);
    pngname=cellfun(@(a,b) {[a b ]},pngname_nofmt ,ext);
    numbers = regexp(pngname, '_xyz(\d+)\.png', 'tokens');
    ix_cord = cellfun(@(x) str2double(x{1}), numbers);
    
    
    numbers = regexp(fis, 'p_(\d\d)_', 'tokens');
    niftiNum = cellfun(@(x) str2double(x{1}), numbers);
    
    %     da=regexprep(niftiName,unique(niftiName), cellfun(@(a) {[ num2str(a) ]},num2cell(1:length(unique(niftiName)))') )
    %     niftiNum=cellfun(@(a) {[str2num(a)  ]},da);
    
    numbers = regexp(fis, '_xyz(\d+)\.png', 'tokens');
    niftiName = regexprep(pngname_nofmt,{'^p_\d\d_', '_xyz\d\d$'},{''});
    tb=[ num2cell(niftiNum)  num2cell(ix_cord)  niftiName pngname  pnglist ] ;
    htb={'niftinum' 'cordnum' 'niftiName' 'pngname' 'pngnameFP'};
    %      uhelp(plog([],[htb;tb],0,'ee','al=2'),1)
    %% ===============================================
    if strcmp(z.sort,'coordinate')
        tb=sortrows(tb,find(strcmp(htb,'cordnum')));
        
    end
    %% ===============================================
    txy=[0 16];
    if z.png_SingleRow==1
        ncols=1;
        nimg_per_page  =4;           %number of images per plot
        wh=[ nan 3.5]; %width/Hight
        if length(z.png_views)==1
            ncols=5;
            nimg_per_page  =10;           %number of images per plot
            wh=[ 25.4/ncols nan];
            txy=[0 14];
        elseif length(z.png_views)==2
            ncols=2;
            nimg_per_page  =4;           %number of images per plot
            wh=[ 25.4/ncols nan];
            txy=[0 14];
        end
    else
        ncols=2;
        nimg_per_page  =2;           %number of images per plot
        wh=[ nan 12.25]; %width/Hight
    end
    
    pptfile =fullfile(outdirplot,[z.ppt_filename '.pptx']);
    titlem  =z.ppt_filename ;%['lesion'  ];
    fis=tb(:,find(strcmp(htb,'pngnameFP')));
    
    imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
    for i=1:length(imgIDXpage)-1
        if i==1; doc='new'; else; doc='add'; end
        idx=[imgIDXpage(i):imgIDXpage(i+1)-1];
        img_perslice=fis(idx);
        [~, namex ext]=fileparts2(img_perslice);
        tx=cellfun(@(a,b) {[ a b ]},namex,ext);
        %get cords
        numbers = regexp(img_perslice, '_xyz(\d+)\.png', 'tokens');
        co_idx = cellfun(@(x) str2double(x{1}), numbers);
        cord=xyzmm(co_idx,:);
        cord=plog([],[num2cell(cord)],0,'ee','al=2;plotlines=0;s=0');
        ino=min(find(sum(double(char(cord))==double(' '),1)~=size(cord,1)));
        cord=cellfun(@(a) {[ '[' a(ino:end) ']' ]},cord);
        tx=(cellfun(@(a,b) {[a char(9)  b ]},tx, cord));
        % ==legend=============================================
        [~,namelegend, ext]=fileparts(file_legend);
        tx(end+1,1)={[ namelegend ext ]};
        
        img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
            'crop',0,'gap',[0 0 ],'columns',ncols,'xy',[0.0 1.7 ],'wh',wh,...
            'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
            'text',tx,'tfs',9,'txy',txy,'tbgcol',[1 1 1],'tcol',[0 0 0], 'disp',0 );
        
        legendfile={file_legend};
        img2ppt([],legendfile, pptfile,'doc','same',...%,'size','A4'
            'crop',0,'gap',[0 0 ],'columns',1,'xy',[21.5 15 ],'wh',[ 2 nan],'disp',0 );
    end
    
    
    
    
    
    
    
    
    
    
    
    %% =====[old]==========================================
    %
    %
    %         pptfile =fullfile(outdirplot,[z.ppt_filename '.pptx']);
    %         titlem  =z.ppt_filename ;%['lesion'  ];
    %         fis=pnglist;
    %
    %         nimg_per_page  =4;           %number of images per plot
    %         imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
    %         for i=1:length(imgIDXpage)-1
    %             if i==1; doc='new'; else; doc='add'; end
    %             img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
    %             [~, namex ext]=fileparts2(img_perslice);
    %             tx=cellfun(@(a,b) {[ a b ]},namex,ext);
    %             %get cords
    %             numbers = regexp(img_perslice, '_xyz(\d+)\.png', 'tokens');
    %             co_idx = cellfun(@(x) str2double(x{1}), numbers);
    %             cord=xyzmm(co_idx,:);
    %              cord=plog([],[num2cell(cord)],0,'ee','al=2;plotlines=0;s=0');
    %              ino=min(find(sum(double(char(cord))==double(' '),1)~=size(cord,1)));
    %              cord=cellfun(@(a) {[ '[' a(ino:end) ']' ]},cord);
    %              tx=(cellfun(@(a,b) {[a char(9)  b ]},tx, cord));
    %             % ==legend=============================================
    %             [~,namelegend, ext]=fileparts(file_legend);
    %             tx(end+1,1)={[ namelegend ext ]};
    %
    %             img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
    %                 'crop',0,'gap',[0 0 ],'columns',1,'xy',[0.02 1.5 ],'wh',[ nan 3.5],...
    %                 'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
    %                 'text',tx,'tfs',10,'txy',[0 16],'tbgcol',[1 1 1],'tcol',[0 0 0], 'disp',0 );
    %
    %             legendfile={file_legend};
    %             img2ppt([],legendfile, pptfile,'doc','same',...%,'size','A4'
    %                 'crop',0,'gap',[0 0 ],'columns',1,'xy',[21.5 15 ],'wh',[ 2 nan],'disp',0 );
    %         end
    
    
    
    %% ===============================================
    cord=xyzmm;
    cord=plog([],[num2cell(cord)],0,'ee','al=2;plotlines=0;s=0');
    ino=min(find(sum(double(char(cord))==double(' '),1)~=size(cord,1)));
    cord=cellfun(@(a) {[ '[' a(ino:end) ']' ]},cord);
    
    
    [ ~, studyName]=fileparts(studydir);
    info={};
    info(end+1,:)={'study:'                 [studyName]} ;
    info(end+1,:)={'studyPath:'             [studydir]} ;
    %     info(end+1,:)={'slices [mm]   :'        slicemm_str} ;
    info(end+1,:)={'date:'                  [datestr(now)]} ;
    info(end+1,:)={' '     '  '} ;
    info= plog([],[info],0,'INFO','plotlines=0;al=1');
    %===============================================
    v1=struct('txy', [0 1.7 ], 'tcol', [0 0 0],'tfs',11, 'tbgcol',[0.9843    0.9686    0.9686],...
        'tfn','consolas');
    v1.text=info;
    v2=struct('txy', [17 1.7 ], 'tcol', [0 0 0],'tfs',9, 'tbgcol',[1 1 1],...
        'tfn','consolas','tfw','bold');
    v2.text=[{'xyz-coordinates (mm)'};cord];
    
    vs={v1 v2};
    % paralist= struct2list2(z_bk,'z');
    % paralist=[{' PARAMETER'}; {'z={};'}; paralist; {[mfilename '(1,z) ;% RUN FUNCTION ']}];
    
    paralist=batch(max(regexpi2(batch,'^z=\[\];')):end);
    %     paralist=regexprep(paralist,'^\s+',repmat(char(9),[1 2]));
    paralist=[{' *** PARAMETER/BATCH ***   '}; paralist ];
    
    img2ppt([],[], pptfile,'doc','add',...
        'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
        'text',paralist,'tfs',8,'txy',[0 6],'tcol', [0 0 0],'tbgcol',[0.9451    0.9686    0.9490], 'tfn','consolas',...
        'multitext',vs,'disp',1 );
    %% ===============================================
    
    
end



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
%     if success
%         %     disp(['File is ready for reading after ', num2str(attempt), ' attempts!']);
%     else
%         %     disp('File was not accessible after maximum attempts.');
%     end
end





function png_makeSingleRow(z, f2,f4 )
%% ===============================================
if z.png_SingleRow==0; return; end
if ischar(f4); f4=cellstr(f4); end
for j=1:length(f4)
    file=f4{j};
    x1=imread(file);
    h=spm_vol(f2);
    dims=h.dim;
    vi=round(dims(1)/(dims(1)+dims(2))*size(x1,2)); %vertical split index
    hi=round(dims(3)/(dims(3)+dims(2))*size(x1,1)); %horizontal split index
    
    %     if 0
    %         % Display the split
    %         figure;imshow(x1);hold on;
    %         plot([vi vi], [1 size(x1,1)], 'r', 'LineWidth', 2); % Draw  line
    %         plot([1 size(x1,2)], [hi hi] , 'm', 'LineWidth', 2); % Draw  line
    %     end
    s1=x1(1:hi,1:vi,:);
    s2=x1(1:hi,vi:end,:);
    s3=x1(hi+1:end,1:vi,:);  s3=rot90(s3,3);
    %==[same size] ==================================
    maxi=max([size(s1,1) size(s2,1) size(s3,1)]);
    w={s1 s2 s3};
    w2={};
    for i=1:length(w)
        v1= cast(zeros(maxi,  size(w{i},2),3),'like',x1);
        if (size(v1,1)-size(w{i},1))==0
            v1=w{i};
            w2{i}=v1;
        else
            do=ceil((size(v1,1)-size(w{i},1))/2);
            v1(do:do+size(w{i},1)-1,:,:)=w{i};
            w2{i}=v1;
        end
    end
    % ==[extract used views and attach] ==========================
    % z.png_views=[1 2 3];
    w3=w2(z.png_views);
    w4 = cat(2, w3{:});
    % fg,imagesc(w4)
    % ==[save]===============================
    fout=file;%fullfile(pwd,'map1row.png')
    imwrite(w4, fout);
    %     showinfo2(['png:'],fout);
    
end





%% ===============================================

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


function colorbar_rgb=clutmap(filename)
% Function to read a CLUT file, interpolate RGB values, and plot a smooth colorbar.
% Compatible with MATLAB 2016 (no startsWith).
%
% INPUT:
%   filename - Path to the CLUT file (.clut format)
%
% OUTPUT:
%   Displays an interpolated colorbar.

% Open the file
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

% Close file
fclose(fid);

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

% Step 4: Plot the interpolated colorbar
%     figure;
%     colormap(colorbar_rgb);
%     caxis([1, num_colors]);
%     colorbar;
%     title('Interpolated Colorbar from CLUT');

function executable=getExecutable()

%% ===============================================
if ismac
    pagl='/Applications/MRIcroGL.app/Contents/MacOS';
    if exist(pagl)~=7
        q=path;
        q=strsplit(path,':')';
        ix=regexpi2(q,'MRIcroGL')
        if isempty(ix);
            error('MRIcroGL not found in path');
        end
        pagl=q{ix};
        [p1,p2,ext]=fileparts(pagl);
        if strcmp([p2,ext],'MRIcroGL.app')
            pagl=fullfile(pagl,'Contents','MacOS');
        end
    end
    executable=fullfile(pagl,'MRIcroGL');
elseif ispc
    pagl=[];
    potpaths={
        fullfile(getenv('USERPROFILE'),'AppData','Local','MRIcroGL') %'C:\Users\YourUsername\AppData\Local\MRIcroGL\'
        'C:\Program Files\MRIcroGL\'
        %     'C:\paulprogramme\MRIcroGL\'
        };
    ix=min(find(existn(potpaths)~=0));
    if ~isempty(ix);   pagl=potpaths{ix}; end
    if isempty(pagl)
        q=path;
        q=strsplit(path,';')';
        ix=regexpi2(q,'MRIcroGL');
        if ~isempty(ix);
            pagl=q{ix};
            %%error('MRIcroGL not found in path');
        end
    end
    % check if in in enviroment vars
    if isempty(pagl)
        [q1 q2]=system('where MRIcroGL.exe');
        q2=cellstr(q2);
        if exist(q2{1})==2
            pagl=fileparts(q2{1});
        end
    end
    
    % search C-drive
    if isempty(pagl)
        disp('..searching drive for "MRIcroGL.exe" ');
        tic1=tic;
        exec = findMRIcroGL();
        if exist(exec)==2
            pagl=fileparts(exec);
            % This adds the new path temporarily to the current MATLAB session.
            setenv('PATH', [getenv('PATH') [';' pagl]]);
            disp(['MRIcroGL.exe found: "'  pagl  '" (searchtime:' sprintf('%2.1fs',toc(tic1)) ') ']);
            disp('temporally added to matlab''s env-paths');
        else
            error(['MRIcroGL.exe not found--> see help of '  mfilename '.m']);
        end
        
        
    end
    executable=fullfile(pagl,'MRIcroGL.exe');
    
end
% system(executable)



function filepath = findMRIcroGL()
searchFile = 'MRIcroGL.exe';   % Set the file to search for
startDir = 'c:\';              % Set the starting directory (modify as needed)
% Convert to Java File object
startFolder = java.io.File(startDir);

% Perform recursive search
filepath = searchInDirectory(startFolder, searchFile);

% Display results
if isempty(filepath)
    disp('File not found.');
else
    disp(['Found: ', filepath]);
end

function filepath = searchInDirectory(directory, targetFile)
% List all files and directories
files = directory.listFiles();

% If directory is empty, return empty
if isempty(files)
    filepath = '';
    return;
end

% Iterate over each file/folder
for i = 1:length(files)
    fileObj = files(i);
    
    if fileObj.isDirectory()
        % Recursive search in subdirectories
        filepath = searchInDirectory(fileObj, targetFile);
        if ~isempty(filepath)
            return; % Stop searching once we find the first occurrence
        end
    elseif strcmpi(char(fileObj.getName()), targetFile)
        % File found, return its absolute path
        filepath = char(fileObj.getAbsolutePath());
        return;
    end
end

% If no match found
filepath = '';


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
%% ===============================================


