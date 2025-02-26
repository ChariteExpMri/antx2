
% PLOT SLICE OVERLAYS USING MRicroGL
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
% 'bg_image'     background image, if empty, than "AVGT.nii" from template-folder is used
% 'ovl_images'   one/more images to separately overlay onto bg_image
% 'view'         view: [1] sagittal; [2] coronal;[3]axial ;  {1,2,3}
%                   default: [2]
% 'slices'       slices to plot
%                      [1] as numeric array to use slice-indices
%                         -AVGT-coronal:[60,73,86,99,112,125,138]            -->  [60,73,86,99,112,125,138]
%                         -AVGT-coronal:[80,95,110,125,140,155,170,185,200]  -->  [80,95,110,125,140,155,170,185,200]
%                         -AVGT-coronal:[80,95,110,125,140,155,170,185,200]  -->  [80,95,110,125,140,155,170,185,200]
%                         -AVGT-coronal:[50,62,74,87,99,111,123,136,148,160] -->  [50,62,74,87,99,111,123,136,148,160]
%                         -AVGT-coronal:[50,83,115,148,180]                  -->  [50,83,115,148,180]
%                         -slices index: from 50 to 150, 6 slices            -->[50:6:150]
%                      [2] as string to work with voxel-milimeters (mm)
%                         -slices in mm: 0mm,1.1mm,2.135mm,-0.1mm            -->  '0,1.1,2.135,-0.1'   defined as string
%                      [3] as string to obtain a defined number of slices
%                         -5 equidistant slices      -->   'n5'
%                         -8 equidistant slices'     -->   'n8'
%                         -10 equidistant slices'    -->   'n10'
%                         -cut 20% left and right (=40%)  and plot 12 equidistant slices --> 'cut40n12'
%                         -cut 35% left and right (=70%)  and plot 6 equidistant slices  --> 'cut70n6'
%                         -cut 45% left and right (=90%)  and plot 6 equidistant slices  --> 'cut90n6'
%                         -cut 50% left and plot 5 equidistant slices                    --> 'cutL50n5'
%                         -cut 50% right and plot 5 equidistant slices                   --> 'cutR50n5'
%
% 'bg_clim'        background-image: intensity limits [min,max], if [nan nan]..automatically defined
%                      examples: [0 200 ] or [nan nan]
% 'ovl_cmap'       overlay-image: colormap --> see icon for colormap
% 'ovl_clim'       overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%                      examples: [0 200 ] or [nan nan]
% 'opacity'        opacity of the overlayed image : 0,20,40,50,60,80,100
%                     example: [50]
% 'slicelabel'   add slice label , this is the mm-slice cordinate (rounded mm); {0|1}
%                    default: [0]
%                    is not recomended because fontsize is not adjustable
% 'nrows'        number of rows to plot;  a numeric value
%                    default: [1]
% 'sliceOverlapp'  horizontal slice overlapp (left-right); chose one value from range: [-1:0.1:1]
%                    default: [0]
% 'rowOverlapp'   vertical overlapp of rows; chose one value from range: [-1:0.1:1]
%                    default: [0]
%
% 'cbar_label'     colorbar-label, if empty cbar has no label, type string
%                    examples:  'lesion [%]' or 'intensity [a.u.]'
% 'cbar_fs'        colorbar-fonsize
%                     default: [12]
% 'cbar_fontname'  colorbar-fontName  --> see icon for fonts
%                    example: 'arial','consolas' or 'Helvetica'
%
% 'cbar_fcol'      colorbar-fontcolor, (3 values) --> select color from icon
%                    example:  [1 1 1] (white)
%
% 'sliceplot'     show orthogonal plot where brain is sliced; {0|1}
%                    default: [1]
% 'sliceplotDir'  change direction of sliceplot {1,-1},
%                   this changes the view of the sliceplot,i.e  back vs front; left vs right; up vs down
%                   default: [1]
% 'sliceplotDim'  dimension of the orthogonal sliceplot to display  {1,2,3}
%                   if [1] or [2]: the sliceplot is orthogonally to the slices
%                   if [3]: sliceplot is in the same perspective as the slices
%                   default: [1]
% 'linewidth'     linewidht of lines in the sliceplot representing the location of the slices
%                   default: [1]
% 'linecolor'     line color of  of lines in the sliceplot representing the location of the slices
%                    default:  [1 1 1] (white)
% 
% 'outdir'         output-directory, if empty plots/ppt-file is stored in the DIR of the "ovl_images"
% 'ppt_filename'   powerpoint-filename tha tis created
%                   example: 'lesion'
% 'plotdir_suffix' 'a SUBDIR that contains the created png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%
% 'closeMricroGL'  close MricroGl afterwards; {0,1}
%                    default: [1]
% 'makePPT'        make powerpoint-file with image(s) and infos; {0,1}
%                    default: [1]
% 'mricroGL'       '<optional> specify fullpath name of MRicroGL-exe/app if not otherwise found 
%                  -see MRIcro-installation (above)
%                   win-example: 'C:\paulprogramme\MRIcroGL3\MRIcroGL.exe';                                       % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
%                   mac-example: '/Users/klausmaus/MRIcroGL.app
% 
%% #wb *** RUN ***
% xplotslices_mricrogl(1) or  xplotslices_mricrogl    ... open PARAMETER_GUI
% xplotslices_mricrogl(0,z)             ...NO-GUI,  z is the predefined struct
% xplotslices_mricrogl(1,z)             ...WITH-GUI z is the predefined struct
%
%
%% #wb *** EXAMPLES ***
%% EXAMPLE: coronal-1 ===============================================
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
%     z.view           = [1];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
%     z.slices         = [60  73  86  99  112  125  138];                                                 % % slices to plot
%     z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
%     z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
%     z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
%     z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
%     z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
%     z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
%     z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
%     z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
%     z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
%     z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
%     z.sliceplotDir   = [1];                                                                             % % change direction of sliceplot
%     z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
%     z.linewidth      = [1];                                                                             % % linewidht of slices
%     z.linecolor      = [1  1  1];                                                                       % % line color of clices
%     z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion_view1_oth';                                                                        % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
%     z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
%     xplotslices_mricrogl(0,z);
%
%
%% EXAMPLE: coronal-2 ===============================================
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
%     z.view           = [1];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
%     z.slices         = 'cut50n6';                                                 % % slices to plot
%     z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
%     z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
%     z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
%     z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
%     z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
%     z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
%     z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
%     z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
%     z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
%     z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
%     z.sliceplotDir   = [1];                                                                             % % change direction of sliceplot
%     z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
%     z.linewidth      = [1];                                                                             % % linewidht of slices
%     z.linecolor      = [1  1  1];                                                                       % % line color of clices
%     z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion_view1';                                                                        % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
%     z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
%     xplotslices_mricrogl(0,z);
%
%% EXAMPLE: sagittal ===============================================
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
%     z.view           = [2];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
%     z.slices         = 'cutR50n6';                                                 % % slices to plot
%     z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
%     z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
%     z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
%     z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
%     z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
%     z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
%     z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
%     z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
%     z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
%     z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
%     z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
%     z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
%     z.linewidth      = [1];                                                                             % % linewidht of slices
%     z.linecolor      = [1  1  1];                                                                       % % line color of clices
%     z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion_view2';                                                                        % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
%     z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
%     xplotslices_mricrogl(0,z);
%
%% EXAMPLE: axial ===============================================
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
%     z.view           = [3];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
%     z.slices         = 'cut50n8';                                                 % % slices to plot
%     z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
%     z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
%     z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
%     z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
%     z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
%     z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
%     z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
%     z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
%     z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
%     z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
%     z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
%     z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
%     z.linewidth      = [1];                                                                             % % linewidht of slices
%     z.linecolor      = [1  1  1];                                                                       % % line color of clices
%     z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion_view3';                                                                        % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
%     z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
%     xplotslices_mricrogl(0,z);
%



function [z]=xplotslices_mricrogl(showgui,x,pa)

% clc
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

viewopt={};
viewopt(end+1,:)={'coronal'             2 };
viewopt(end+1,:)={'sagittal'            1 };
viewopt(end+1,:)={'axial'               3  };

sliceopt={};
sliceopt(end+1,:)={'AVGT-coronal:[60,73,86,99,112,125,138]'             [60,73,86,99,112,125,138] };
sliceopt(end+1,:)={'AVGT-coronal:[80,95,110,125,140,155,170,185,200]'   [80,95,110,125,140,155,170,185,200]   };
sliceopt(end+1,:)={'AVGT-coronal:[80,95,110,125,140,155,170,185,200]'   [80,95,110,125,140,155,170,185,200]   };
sliceopt(end+1,:)={'AVGT-coronal:[50,62,74,87,99,111,123,136,148,160]'  [50,62,74,87,99,111,123,136,148,160]   };
sliceopt(end+1,:)={'AVGT-coronal:[50,83,115,148,180]]'                  [50,83,115,148,180]   };
sliceopt(end+1,:)={'slices index: from 50 to 150, 6 slices [50:6:150]'        '50:6:150'   };
sliceopt(end+1,:)={'slices index: from 80 to 200, 10 slices[80:10:200]'       '80:10:200'  };
sliceopt(end+1,:)={'slices in mm: 0mm,1.1mm,2.135mm,-0.1mm'              '0,1.1,2.135,-0.1'  };
sliceopt(end+1,:)={'5 equidistant slices'              'n5'   };
sliceopt(end+1,:)={'8 equidistant slices'              'n8'   };
sliceopt(end+1,:)={'10 equidistant slices'             'n10'  };
sliceopt(end+1,:)={'cut 20% left and right (=40%)  and plot 12 equidistant slices'            'cut40n12'  };
sliceopt(end+1,:)={'cut 35% left and right (=70%)  and plot 6 equidistant slices'             'cut70n6'  };
sliceopt(end+1,:)={'cut 45% left and right (=90%)  and plot 6 equidistant slices'             'cut90n6'  };

% exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
% lutdir=(fullfile(fileparts(exefile),'lut'));
% [luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);


p={
    'inf0' '__IMAGES__' '' ''
    'bg_image'      ''              'background image, if empty, than "AVGT.nii" from template-folder is used' 'f'
    'ovl_images'   {''}             'get one/more images to separately overlay onto bg_image' 'mf'
    'view'         2                'view: [1]sagittal; [2]coronal;[3]axial '   viewopt
    'slices'       '-2.5,-2,1,2.3'  'slices to plot'   sliceopt  %[60,73,86,99,112,125,138]
    'inf1'  '' '' ''
    'bg_clim'           [50 200 ]        'background-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'ovl_cmap'         'NIH_fire.lut'   'overlay-image: colormap ' {'cmap',htmllist}
    'ovl_clim'          [0 100 ]        'overlay-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'opacity'              70          'overlay opacity range: 0-100 '  {0,20,40,50,60,80,100}'
    'slicelabel'   [0]  'add slice label  (rounded mm); {0|1}'    'b'
    
    'inf2' '__ROWS & COLUMNS__ ' '' ''
    'nrows'          1    'number of rows to plot; default: 1'         num2cell(1:4)
    'sliceOverlapp' [0]   'slice overlapp horizontally (left-right)'   num2cell([-1:0.1:1]')
    'rowOverlapp'   [0]   'rows overlapp (vertical overlap of rows)'   num2cell([-1:0.1:1]')
    
    
    'inf3' '__COLORBAR__' '' ''
    'cbar_label'      'lesion [%]'  'colorbar: label, if empty cbar has no label' {'lesion [%]'; 'intensity [a.u.]'}
    'cbar_fs'         12            'colorbar: fonsize'     [num2cell(7:30)']
    'cbar_fontname'   'Helvetica'   'fontName example: arial/consolas/Helvetica' listfonts
    'cbar_fcol'       [1 1 1]       'colorbar: fontcolor a color'                         'col'
    
    'inf4' '__SHOW SLICEPLOT__' '' ''
    'sliceplot'     [1]   'show orthogonal plot where brain is sliced; {0|1}' 'b'
    'sliceplotDir'  [1]   'change direction of sliceplot'  {1 ,-1}
    'sliceplotDim'  [1]   'dimension of the orthogonal sliceplot'  {1 ,2}
    'linewidth'     [1]   'linewidht of slices'  num2cell(0:4)
    'linecolor'     [1,1,1] 'line color of clices'  'col'
    
    
    
    'inf33'  '___OUTPUT-PARAMETER___' '' ''
    'outdir'         ''           'output-dir, if empty plots/ppt-file in the DIR of the ovl_images'   'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'ppt_filename'   'lesion'     'PPT-filename'  {'incidencemaps' '_test2'}
    'plotdir_suffix' '_plots'      'DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" '         {'_plots' '_figs'}
    
    'inf5'  '___misc___' '' ''
    'closeMricroGL'  1  'close MricroGl afterwards'  'b'
    'makePPT'        1  'make powerpoint with image and infos'  'b'
    'mricroGL'   '' '<optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)'  {@get_mrigroglPath}
    
    };
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
viewtb={...
    'coronal'   3    's'   'c'   'a'
    'sagittal'  2    'c'   'a'   's'
    'axial'     1    's'   'a'   'c'};
% if isnumeric(z.view)
%     if z.view==1;     z.view=2;
%     elseif z.view==2; z.view=1;
%     end
% end

if ischar(z.view)
    if ~isempty(find(strcmp(viewtb(:,1),z.view)))
        z.view=viewtb{strcmp(viewtb(:,1),z.view),2};
    else
        z.view= viewtb{strcmp({'s','a','c'},lower(z.view)),2};
    end
    
end
viewgl=viewtb{z.view,1}(1);
% disp(['dim: ' num2str(find(cell2mat(viewtb(:,2))== z.view) )]);
viewssliceblock=viewtb{  find(cell2mat(viewtb(:,2))== z.view)  ,2+z.sliceplotDim};

hb       =spm_vol(z.bg_image);
[bb vox] =world_bb(z.bg_image);
if ischar(z.slices)
    if ~isempty(strfind(z.slices,':'))  %from-to
        eval(['slices=' z.slices ';']);
    elseif ~isempty(strfind(z.slices,'n'))  %n-slices
        if ~isempty(strfind(z.slices,'cutR'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cutR\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100)); %onesided
            if z.view==3
                slices=round(linspace(2,hb.dim([2])-cutidx(2),numslices));
            elseif z.view==2
                slices=round(linspace(2,hb.dim([1])-cutidx(1),numslices));
            elseif z.view==1
                slices=round(linspace(2,hb.dim([3])-cutidx(3),numslices));
            end
        elseif ~isempty(strfind(z.slices,'cutL'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cutL\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100)); %onesided
            if z.view==3
                slices=round(linspace(cutidx(2),hb.dim([2]),numslices));
            elseif z.view==2
                slices=round(linspace(cutidx(1),hb.dim([1]),numslices));
            elseif z.view==1
                slices=round(linspace(cutidx(3),hb.dim([3]),numslices));
            end
        elseif ~isempty(strfind(z.slices,'cut'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cut\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100/2)); %twosided
            if z.view==3
                slices=round(linspace(cutidx(2),hb.dim([2])-cutidx(2),numslices));
            elseif z.view==2
                slices=round(linspace(cutidx(1),hb.dim([1])-cutidx(1),numslices));
            elseif z.view==1
                slices=round(linspace(cutidx(3),hb.dim([3])-cutidx(3),numslices));
            end
            
        else
            numslices=str2num(strrep(z.slices,'n',''));
            if z.view==3
                slices=round(linspace(2,hb.dim([2])-1,numslices));
            elseif z.view==2
                slices=round(linspace(2,hb.dim([1])-1,numslices));
            elseif z.view==1
                slices=round(linspace(2,hb.dim([3])-1,numslices));
            end
        end
    else  % mm-approach
        
        slicemm=str2num(z.slices);
        if z.view==3
            mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
            slices=vecnearest2(mm, slicemm);
        elseif z.view==2
            mm=linspace(bb(1,[1]),bb(2,[1]),hb.dim([1]));
            slices=vecnearest2(mm, slicemm);
        elseif z.view==1
            mm=linspace(bb(1,[3]),bb(2,[3]),hb.dim([3]));
            slices=vecnearest2(mm, slicemm);
        end
    end
else
    slices=z.slices ;
end
slices=slices(:)';

%get mm-cords
if z.view==3
    mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    slices_gl=slices./hb.dim([2]);
elseif z.view==2
    mm=linspace(bb(1,[1]),bb(2,[1]),hb.dim([1]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    slices_gl=slices./hb.dim([1]);
elseif z.view==1
    mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    slices_gl=slices./hb.dim([2]);
end


% slices    =regexprep(num2str(z.slices(:)'),'\s+',',');
slice_index_str =['[' regexprep(num2str(slices),'\s+',',') ']'];





outdir=z.outdir;
outdirplot=fullfile(outdir, [ [z.ppt_filename z.plotdir_suffix]]);
if exist(outdirplot)~=7; mkdir(outdirplot); end
delete(fullfile(outdirplot ,'*.png'));


%
% inifilebase =fullfile(fileparts(exefile),'mricron.ini');
% inifile     =fullfile(outdirplot,'mricron.ini');
% copyfile(inifilebase,inifile,'f');


slices_insert=regexprep(num2str(slices),'\s+',',');



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
sp='';
if z.sliceplot==1
    spdir='';
    if z.sliceplotDir<0; spdir='-'; end
    sp=[viewssliceblock ' X R ' spdir '0.5' ];
end
linecolStr=strjoin(cellstr(num2str(round(z.linecolor(:)*255))),',');%'255,0,0'

gl_quit    ='';    if z.closeMricroGL==1;  gl_quit    ='gl.quit()'     ;      end
slicelabel ='';    if z.slicelabel  ==1;  slicelabel ='L'             ;      end
olapp      =num2str(z.sliceOverlapp);
rowlapp    =num2str(z.rowOverlapp);
%% =====[rows]==========================================
rows=z.nrows;
if rows==1
    slices_gl_str=sprintf('%2.2f ',slices_gl);
else
    sl=cellfun(@(a) {[ num2str(a)  ]},num2cell(slices_gl));
    ncol=ceil((length(sl)+z.sliceplot  )/rows);
    w='';
    for j=1:length(sl)
        w=[w ' ' sl{j}];
        if mod(j,ncol)==0; w(1,end+1)=';'; end
    end
    slices_gl_str=w;
end
%% ===============================================




pnglist={};
for i=1:length(ovl)
    f2=ovl{i};
    [~, name,ext]=fileparts(f2);
    
    if any(isnan(z.bg_clim))
        bglims='';
    else
        bglims =['gl.minmax(0,'  num2str(z.bg_clim(1)) ',' num2str(z.bg_clim(2)) ')' ];
    end
    if any(isnan(z.ovl_clim))
        ovlims='';
    else
        %         ovlims =[ num2str(z.ovl_clim(1)) ',' num2str(z.ovl_clim(2))];
        ovlims =['gl.minmax(1,'  num2str(z.ovl_clim(1)) ',' num2str(z.ovl_clim(2)) ')' ];
    end
    
    
    
    
    f4   =fullfile(outdirplot,[ 'p_' pnum(i,2) '_' name  '.png']);
    ftemp=fullfile(pwd,[ '_temp123'   '.png']);
    
    cm={['"import gl']
        %['gl.resetdefaults()']
        ['gl.loadimage('''   f1 ''')']
        %     ['gl.overlayloadsmooth(1)']
        ['gl.overlayload('''   f2 ''')']
        %['gl.colorname(2, "actc")' ];
        %     ['gl.colorname (0,"grayscale")']
        [bglims]
        [ovlims]
        
        %         ['gl.minmax(0, 50, 200)']
        %         ['gl.minmax(1, 2, 70)']
        ['gl.colorname (1,''' lutname ''')']
        
        %     ['gl.backcolor(0, 0, 0)']
        %['gl.SHADERNAME(''overlay'')']
        ['gl.opacity(1,' num2str(trans) ')']
        %   ['gl.mosaic(''C 20 -50 S 0 20 S X R 0'')']
        % %   ['gl.mosaic(''C L- H 0.1 V -0.9 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 S X R 0.5'')']
        %   ['gl.mosaic(''C L- 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 S X R 0.5'')']
        ['gl.mosaic(''' viewgl ' ' slicelabel ' H ' olapp ' V ' rowlapp ' '  slices_gl_str ' '  sp ''')']
        ['gl.linewidth (' num2str(z.linewidth) ')']
        ['gl.linecolor(' linecolStr ')']
        
        ['gl.colorbarposition(0)']  % 0,1,2
        
        %  ['gl.colorbarsize(1)']    % single value
        ['gl.savebmp(''' ftemp ''')']
        [gl_quit]
        };
    
    
    
    % "savebmp('test.png')"
    %   ['gl.mosaic(''C L+ H 0.1 V -0.9 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 S X R 0.5'')']
    % 1st arg, C,S,A vor view
    % $ label on/of: L+1/L-1
    % H/V scalar of panels
    %slices: have to find out what it means: scaling 0:1 ???
    % than: slice-img: in C,S,A
    %  X ( or not X) show slice-lines
    % R  -1, or R 1 change from L/R ot S/A -view, back/top
    
    cm2=strjoin(cm,'^');
    %  cmd=([pa_mricrongl ' -s ''' cm2 ''' &']);
    %cmd=([exefile ' -s ' cm2 '" &']);
    cmd=(['"' exefile '"' ' -s ' cm2 '" &']);
    
    %     disp(char(cmd))
    system(cmd );
    % gl.mosaic("C 20 -50 S 0 20 S X R 0");
    
    % "MRIcroGL -s "import gl|
    % gl.backcolor(255, 255,255)^gl.loadimage('CT_Abdo')"".
    % WOrks::
    % worked=[['C:\paulprogramme\MRIcroGL\MRIcroGL.exe -s "import gl^gl.loadimage(''F:\data8\mricron_makeSlices_plots\AVGT.nii'')"']];
    % system(['C:\paulprogramme\MRIcroGL\MRIcroGL.exe -s "import gl^gl.loadimage(''F:\data8\mricron_makeSlices_plots\AVGT.nii'')"'])
    %     % ===============================================
    fis='';
    n=0;
    while exist(fis)~=2
        [fis] = spm_select('FPList',pwd,'_temp123.png');
        if isnumeric(fis); fis=''; end
        n=n+1;
    end
    pause(.5);
    
    movefile(ftemp, f4,'f');
    showinfo2(['png:'],f4);
    pnglist(end+1,1)={f4};
    %% ===============================================
    %     if z.closeMricroGL==1
    %         rcloseMricroGL
    %     end
    %% ===============================================
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

%% ===============================================

set(gca,'units','pixels')
set(hf,'units','pixels')
%% ===============================================
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
% ===============================================

%% ===============================================
%%   PPT
%% ===============================================
if z.makePPT==1
    % paout =pa;
    % paimg =fullfile(pa);
    % [~, pptname]=fileparts(p.ppt_filename);
    % if isempty(pptname); pptname='test1'; end
    % [fis]   = spm_select('FPList',paimg,'p_.*.png');    fis=cellstr(fis);
    % tx      ={['path: '  paimg ]};
    
    
    pptfile =fullfile(outdirplot,[z.ppt_filename '.pptx']);
    titlem  =z.ppt_filename ;%['lesion'  ];
    fis=pnglist;
    
    nimg_per_page  =6;           %number of images per plot
    imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
    for i=1:length(imgIDXpage)-1
        if i==1; doc='new'; else; doc='add'; end
        img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
        [~, namex ext]=fileparts2(img_perslice);
        tx=cellfun(@(a,b) {[ a b ]},namex,ext);
        [~,namelegend, ext]=fileparts(file_legend);
        tx(end+1,1)={[ namelegend ext ]};
        
        
        img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
            'crop',0,'gap',[0 0 ],'columns',1,'xy',[0.02 1.5 ],'wh',[ nan 3.5],...
            'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
            'text',tx,'tfs',12,'txy',[0 16],'tbgcol',[1 1 1],'disp',0 );
        
        legendfile={file_legend};
        img2ppt([],legendfile, pptfile,'doc','same',...%,'size','A4'
            'crop',0,'gap',[0 0 ],'columns',1,'xy',[21.5 15 ],'wh',[ 2 nan],'disp',0 );
        
        
    end
    %% ===============================================
    [ ~, studyName]=fileparts(studydir);
    info={};
    info(end+1,:)={'study:'                 [studyName]} ;
    info(end+1,:)={'studyPath:'             [studydir]} ;
    info(end+1,:)={'slices [mm]   :'        slicemm_str} ;
    info(end+1,:)={'slices [index]:'        slice_index_str} ;
    info(end+1,:)={'date:'                  [datestr(now)]} ;
    info(end+1,:)={' '     '  '} ;
    info= plog([],[info],0,'INFO','plotlines=0;al=1');
    %===============================================
    
    v1=struct('txy', [0 1.5 ], 'tcol', [0 0 0],'tfs',11, 'tbgcol',[0.9843    0.9686    0.9686],...
        'tfn','consolas');
    v1.text=info;
    vs={v1};
    % paralist= struct2list2(z_bk,'z');
    % paralist=[{' PARAMETER'}; {'z={};'}; paralist; {[mfilename '(1,z) ;% RUN FUNCTION ']}];
    
    paralist=batch(max(regexpi2(batch,'^z=\[\];')):end);
    paralist=[{' *** PARAMETER/BATCH ***   '}; paralist ];
    
    img2ppt([],[], pptfile,'doc','add',...
        'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
        'text',paralist,'tfs',8,'txy',[0 6],'tcol', [0 0 0],'tbgcol',[0.9451    0.9686    0.9490], 'tfn','consolas',...
        'multitext',vs,'disp',1 );
    
end



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


