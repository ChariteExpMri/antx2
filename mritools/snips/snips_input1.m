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
% open Antx-history

uhelp(anth) ;
%% #################################################
% cmd
% costumize matlab-session
antcb('cwcol',[1 .94 .87]); 
antcb('cwname','paul works here');

%% #################################################
% cmd
% Convert an IMG/HDR file to NIfTI format, and replace the header of a mask image
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






