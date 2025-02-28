
% PLOT SLICE OVERLAYS USING MRICRON
% *** WINDOWS ONLY ***
%
%% #wb *** PARAMETERS ***
%     'bg_image'      Background image. If empty, "AVGT.nii" from the template folder is used.
%     'ovl_images'    One or more images to overlay separately onto the background image.
%     'view'          View: {[1],[2],[3]} or {'coronal'/'sagittal'/'axial'}; default: 'coronal'.
%     'slices'        Slices to plot:
%                      [1] As a numeric array using slice indices:
%                         - AVGT-coronal: [60,73,86,99,112,125,138]            -->  [60,73,86,99,112,125,138]
%                         - AVGT-coronal: [80,95,110,125,140,155,170,185,200]  -->  [80,95,110,125,140,155,170,185,200]
%                         - AVGT-coronal: [50,62,74,87,99,111,123,136,148,160] -->  [50,62,74,87,99,111,123,136,148,160]
%                         - AVGT-coronal: [50,83,115,148,180]                  -->  [50,83,115,148,180]
%                         - Slice index: From 50 to 150, step size 6            -->  [50:6:150]
%                      [2] As a string using voxel-millimeters (mm):
%                         - Slices in mm: 0mm,1.1mm,2.135mm,-0.1mm  -->  '0,1.1,2.135,-0.1' (defined as a string).
%                      [3] As a string to define the number of slices:
%                         - 5 equidistant slices         -->   'n5'
%                         - 8 equidistant slices         -->   'n8'
%                         - 10 equidistant slices        -->   'n10'
%                         - Cut 20% left & right (40%) and plot 12 equidistant slices --> 'cut40n12'
%                         - Cut 35% left & right (70%) and plot 6 equidistant slices  --> 'cut70n6'
%                         - Cut 45% left & right (90%) and plot 6 equidistant slices  --> 'cut90n6'
%                         - Cut 50% left and plot 5 equidistant slices                --> 'cutL50n5'
%                         - Cut 50% right and plot 5 equidistant slices               --> 'cutR50n5'
%                     [4] "ovl_n#": Equidistant slices within the region boundaries of 'ovl_images'.
%                         - All 'ovl_images' are loaded, combined, and treated as a mask (values ~= 0).
%                         - Based on the mask boundaries, n equidistant slices are extracted.
%                         - Useful for displaying MCAO lesions or large clusters/masks.
%                         - 5 slices within overlay --> "ovl_n5"
%                         - 7 slices within overlay --> "ovl_n7"
%                     [5] "ovledge_n#": Same as "ovl_n#", but the first and last slices are at the exact mask boundaries.
%                         - The first and last slices may appear empty or contain only a few pixels.
%                         - 5 slices within overlay (edge-based)  --> "ovledge_n5"
%                         - 7 slices within overlay (edge-based)  --> "ovledge_n7"
%
%     'bg_clim'       Background image intensity limits [min, max].
%                     If [NaN NaN], limits are defined automatically.
%                     Example: [0 200] or [NaN NaN].
%     'ovl_cmap'      Overlay image colormap. See the colormap icon for options.
%     'ovl_clim'      Overlay image intensity limits [min, max].
%                     If [NaN NaN], limits are defined automatically.
%                     Example: [0 200] or [NaN NaN].
%     'opacity'       Opacity of the overlay image. Options: -1, 0, 20, 40, 50, 60, 80, 100.
%                     A value of -1 signifies additive color blending.
%
%     'orthoview'     Show an orthogonal plot where the brain is sliced. {0|1}, default: [1].
%     'slicelabel'    Add a slice label (rounded mm coordinate). {0|1}.
%                     NOT RECOMMENDED (rounded by MRIcron).
%     'OverslicePct'  Percentage overlap of slices, range: [-100:10:100], default: [0].
%     'cbar_label'    Colorbar label. If empty, the colorbar has no label.
%                     Examples: 'lesion [%]' or 'intensity [a.u.]'.
%     'cbar_fs'       Colorbar font size. Default: [12].
%     'cbar_fcol'     Colorbar font color. Use the color icon to select a color.
%                     Default: [1 1 1] (white).
%     'outdir'        Output directory. If empty, plots and PPT files are generated in the directory of 'ovl_images'.
%                     Default: ''.
%     'ppt_filename'  PowerPoint filename to be generated.
%                     Example: 'lesion'.
%     'plotdir_suffix' Subfolder containing PNG files (located in 'outdir').
%                     The directory name is defined by "ppt_filename" + "plotdir_suffix".
%
%     'closeMricron'  Set to 1 to close MRIcron after execution.
%
%% #wb *** RUN ***
% xplotslices_mricron(1) or xplotslices_mricron    ... Open PARAMETER GUI
% xplotslices_mricron(0, z)             ... Run without GUI; 'z' is a predefined struct.
% xplotslices_mricron(1, z)             ... Run with GUI; 'z' is a predefined struct.
%
%% #wb *** EXAMPLES ***
%% EXAMPLE: coronal
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
%     z.view           = 'coronal';                                                                      % % view: {coronal/sagittal/axial}
%     z.slices         = [80  95  110  125  140  155  170  185  200];                                    % % slices to plot
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards
%     xplotslices_mricron(0,z);
%
%% ===============================================
%% EXAMPLE: sagittal
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
%     z.view           = 'sagittal';                                                                     % % view: {coronal/sagittal/axial}
%     z.slices         = 'cutR50n6';                                                                     % % slices to plot
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards
%     xplotslices_mricron(0,z);
%
%% ===============================================
%% EXAMPLE: AXIONAL
%     z=[];
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
%     z.view           = 'axial';                                                                     % % view: {coronal/sagittal/axial}
%     z.slices         = 'cut50n5';                                                                     % % slices to plot
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards
%     xplotslices_mricron(0,z);
%
%% ===============================================
%% EXAMPLE: plot 5 equidistant sliced within the MCAO-lesion ('ovl_n5')
% z=[];
% z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
% z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
%                      'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
%                      'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
% z.view           = 'coronal';                                                                      % % view: {coronal/sagittal/axial}
% z.slices         = 'ovl_n5';                                                                       % % slices to plot-->see help/icon
% z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
% z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
% z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
% z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
% z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
% z.slicelabel     = [0];                                                                            % % add slice label  (rounded mm); {0|1}
% z.OverslicePct   = [0];                                                                            % % percent overlapp slices
% z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
% z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
% z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
% z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
% z.ppt_filename   = 'lesion34';                                                                     % % PPT-filename
% z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
% z.closeMricron   = [1];                                                                            % % close mricron afterwards
% xplotslices_mricron(0,z);

function [z]=xplotslices_mricron(showgui,x,pa)


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



% ==============================================
%%   PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end



% clipboard('copy',['[' regexprep(num2str(80:15:200),'\s+',',') ']'])

viewopt={};
viewopt(end+1,:)={'coronal  --> [1] or "coronal"'         'coronal' };
viewopt(end+1,:)={'sagittal --> [2] or "sagittal"'        'sagittal' };
viewopt(end+1,:)={'axial    --> [3] or "axial"'           'axial'  };

sliceopt={};
sliceopt(end+1,:)={'AVGT-coronal:[60,73,86,99,112,125,138]'             [60,73,86,99,112,125,138] };
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
sliceopt(end+1,:)={'cut 50% left and plot 5 equidistant slices'                               'cutL50n5'  };
sliceopt(end+1,:)={'cut 50% right and plot 5 equidistant slices'                              'cutR50n5'  };
sliceopt(end+1,:)={'5 slices within overlay (values~=0), "ovl_n5" (for MCAO)'            'ovl_n5'  };
sliceopt(end+1,:)={'7 slices within overlay (values~=0), "ovl_n7" (for MCAO)'            'ovl_n7'  };
sliceopt(end+1,:)={'5 slices within overlay (values~=0), 1st/last slice at the ovl-edge, "ovledge_n5" (for MCAO)'            'ovledge_n5'  };
sliceopt(end+1,:)={'7 slices within overlay (values~=0), 1st/last slice at the ovl-edge, "ovledge_n7" (for MCAO)'            'ovledge_n7'  };

% 'ovl_n5';                                    % % slices to plot
% %     z.slices         = 'ovledge_n5';


exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
lutdir=(fullfile(fileparts(exefile),'lut'));
[luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);


p={
    'inf0'  '*** WINDOWS ONLY ***' '' ''
    'bg_image'      ''              'background image, if empty, than "AVGT.nii" from template-folder is used' 'f'
    'ovl_images'    ''              'get one/more images to separately overlay onto bg_image' 'mf'
    'view'         'coronal'        'view: {coronal/sagittal/axial} '   viewopt
    'slices'       '-2.5,-2,1,2.3'  'slices to plot-->see help/icon'   sliceopt  %[60,73,86,99,112,125,138]
    
    'inf1'  '' '' ''
    'inf11'  '' '' ''
    'bg_clim'         [0 200 ]           'background-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'ovl_cmap'        'actc.lut'     'overlay-image: colormap ' {'cmap',luts'}
    'ovl_clim'        [0 100 ]           'overlay-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    
    
    'inf2' '' '' ''
    'opacity'        50   'opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending'  {-1,0,20,40,50,60,80,100}'
    'orthoview'     [1]   'show orthogonal plot where brain is sliced; {0|1}' 'b'
    'slicelabel'    [1]   'add slice label  (rounded mm); {0|1}'    'b'
    'OverslicePct'  [0]   'percent overlapp slices'  num2cell([-100:10:100]')
    
    
    'cbar_label'      'lesion [%]'  'colorbar: label, if empty cbar has no label' {'lesion [%]'; 'intensity [a.u.]'}
    'cbar_fs'         12            'colorbar: fonsize'     [num2cell(7:30)']
    'cbar_fcol'       [1 1 1]       'colorbar: fontcolor a color'                         'col'
    
    
    'inf33'  '___OUTPUT-PARAMETER___' '' ''
    'outdir'         ''           'output-dir, if empty plots/ppt-file in the DIR of the ovl_images'   'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'ppt_filename'   'lesion'     'PPT-filename'  {'incidencemaps' '_test2'}
    'plotdir_suffix' '_plots'      'DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" '         {'_plots' '_figs'}
    
    'inf4'  '___misc___' '' ''
    'closeMricron'  1  'close mricron afterwards'  'b'
    
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
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .6 .46 ],...
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
viewtb={...    asUDEDinthisGUI    mricron
    'coronal'   1   3 
    'sagittal'  2   2
    'axial'     3   1 };
if ischar(z.view)
    z.view=viewtb{strcmp(viewtb(:,1),z.view),2};
end
%  view: [1] sagittal; [2] coronal;[3]axial ;  {1,2,3}
% mricroorientation=...
%     {'axial'    1
%     'sagittal'  2
%     'coronal'   3}

mricroorient=viewtb{find(cell2mat(viewtb(:,2))==z.view),3};

% ==============================================
%%   slice
% ===============================================
hb       =spm_vol(z.bg_image);
[bb vox] =world_bb(z.bg_image);
orderdim=[2 1 3];  % because 1st and 2nd dim are flipped!
dim= hb.dim(orderdim);
bb  =bb(:,orderdim);;
vox =vox(orderdim);
% disp(bb);
clear hb 
% disp(bb)
if ischar(z.slices)
    if ~isempty(strfind(z.slices,':'))  %from-to
        eval(['slices=' z.slices ';']);
    elseif ~isempty(strfind(z.slices,'n'))  %n-slices
        if ~isempty(strfind(z.slices,'cut'))
            %% ===============================================
            numslices=str2num(regexprep(z.slices,'^.*n',''))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''))
            if  ~isempty(strfind(z.slices,'cutL'))
                cutidx=round((cut*dim/100)); %onesided
                slices=round(linspace(2,dim([z.view])-cutidx(z.view),numslices));
            elseif ~isempty(strfind(z.slices,'cutR'))
                cutidx=round((cut*dim/100)); %onesided
                slices=round(linspace(2,dim([z.view])-cutidx(z.view),numslices));
            else
                cutidx=round((cut*dim/100/2)); %twosided
                slices=round(linspace(cutidx(z.view),dim([z.view])-cutidx(z.view),numslices)); 
            end
        elseif ~isempty(strfind(z.slices,'ovl'))
            %% ===============================================
            for i=1:length(z.ovl_images)
                [ha a]=rgetnii(z.ovl_images{i});
                if i==1
                    d=zeros(size(a));
                end
                d=d+a;
            end
            [rows, cols, sl] = ind2sub(size(d), find(d));% Find indices where the mask is nonzero
            start_idx = [min(rows), min(cols), min(sl)];% Determine the start and end indices in each dimension
            end_idx   = [max(rows), max(cols), max(sl)];
            ss=[start_idx; end_idx]'; % indices when mask start/stops in each dim
            ss=ss(orderdim,:);
            numslices=str2double(regexp(z.slices, '_n(\d+)', 'tokens', 'once'));
            if ~isempty(strfind(z.slices,'ovl_'))
                numslices=numslices+2; % take two more
            end
            slices=round(linspace( ss(z.view,1)+1,ss(z.view,2)-1,numslices));
            if ~isempty(strfind(z.slices,'ovl_'))
                slices([1 end])=[]; % remove the two which was added
            end
            %% ===============================================
        else
            numslices=str2num(strrep(z.slices,'n',''));
            slices=round(linspace(2,dim([z.view])-1,numslices));
        end
    else  % mm-approach
        slicemm =str2num(z.slices);
        mm      =linspace(bb(1,[z.view]),bb(2,[z.view]),dim([z.view]));
        slices  =vecnearest2(mm, slicemm);
    end
else
    slices=z.slices ;
end
slices=slices(:)';

%get mm-cords
mm              =linspace(bb(1,[z.view]),bb(2,[z.view]),dim([z.view]));
slicemm_str     =['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
slices_gl       =slices./dim([z.view]);
slice_index_str =['[' regexprep(num2str(slices),'\s+',',') ']'];
slices_insert   =regexprep(num2str(slices),'\s+',',');
% debug=1;
% if debug==1
%     disp(['fov[mm] :[' regexprep(num2str([mm([1 end])]),'\s+',',')  ']'   ]);
%     disp(bb);
% end





% ==============================================
%%  slices- old
% ===============================================
if 0
    hb=spm_vol(z.bg_image);
    [bb vox]= world_bb(z.bg_image);
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
            elseif ~isempty(strfind(z.slices,'ovl'))
                %% ===============================================
                for i=1:length(z.ovl_images)
                    [ha a]=rgetnii(z.ovl_images{i});
                    if i==1
                        d=zeros(size(a));
                    end
                    d=d+a;
                end
                [rows, cols, sl] = ind2sub(size(d), find(d));% Find indices where the mask is nonzero
                start_idx = [min(rows), min(cols), min(sl)];% Determine the start and end indices in each dimension
                end_idx   = [max(rows), max(cols), max(sl)];
                ss=[start_idx; end_idx]'; % indices when mask start/stops in each dim
                numslices=str2double(regexp(z.slices, '_n(\d+)', 'tokens', 'once'));
                if ~isempty(strfind(z.slices,'ovl_'))
                    numslices=numslices+2; % take two more
                end
                if z.view==3
                    slices=round(linspace(ss(2,1),ss(2,2),numslices));
                elseif z.view==2
                    slices=round(linspace(ss(1,1),ss(1,2),numslices));
                elseif z.view==1
                    slices=round(linspace(ss(3,1),ss(3,2),numslices));
                end
                if ~isempty(strfind(z.slices,'ovl_'))
                    slices([1 end])=[]; % remove the two which was added
                end
                %% ===============================================
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
    if z.view==3 %get mm-cords
        mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
        slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    elseif z.view==2
        mm=linspace(bb(1,[1]),bb(2,[1]),hb.dim([1]));
        slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    elseif z.view==1
        mm=linspace(bb(1,[3]),bb(2,[3]),hb.dim([3]));
        slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
    end
    slice_index_str =['[' regexprep(num2str(slices(:)'),'\s+',',') ']'];
end
%% ===============================================
%
% cf;clear;
% clc
% pa='F:\data8\mricron_makeSlices_plots';
% f1=fullfile(pa,'AVGT.nii');
% % f2=fullfile(pa,'MAPpercent_x_masklesion_24h_KO.nii')
%
% [ovl] = spm_select('FPList',pa,'^MAP.*.nii');
% ovl=cellstr(ovl);
%
% p.slices=[60,73,86,99,112,125,138];
% % p.slices=[60:10:100];
% p.orient =3 ;
% p.lim    =[ 10 80 ];
% % p.cmapname='actc.lut'
% p.cmapname='NIH_fire.lut';
% p.orthoview=1;
% p.slicelabel=1;
% p.sliceoverlap=0;
%
% p.cmap_label= 'Power (db)'
% p.cmap_fs   = 12;
%
% p.ppt_filename='test';
% p.ppt_title='Lesion Incidencemaps';

%% ===============================================
% temp to be shure
clear p
clear pa

%% ===============================================


outdir=z.outdir;
outdirplot=fullfile(outdir, [ [z.ppt_filename z.plotdir_suffix]]);
if exist(outdirplot)~=7; mkdir(outdirplot); end
delete(fullfile(outdirplot ,'*.png'));

exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
inifilebase =fullfile(fileparts(exefile),'mricron.ini');
inifile     =fullfile(outdirplot,'mricron.ini');
copyfile(inifilebase,inifile,'f');

slices_insert=regexprep(num2str(slices(:)'),'\s+',',');
msfile=fullfile(outdirplot,'multislice.ini');
ms=...
    {
    '[STR]'
    ['Slices=' slices_insert]  %60,73,86,99,112,125,138'
    '[BOOL]'
    ['OrthoView='  num2str(z.orthoview)]
    ['SliceLabel=' num2str(z.slicelabel)]
    '[INT]'
    ['Orient='  num2str(mricroorient) ]%'Orient=3'
    ['OverslicePct=' num2str(z.OverslicePct)]
    };
pwrite2file(msfile,ms);
% showinfo2(['msfile:'],msfile);


lutdir=(fullfile(fileparts(exefile),'lut'));
[luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);
cmapname=z.ovl_cmap;
[o o2]=getCMAP(cmapname);
call='';
endtag=' &';
if exist(exefile)==2
    call=[call  exefile  ' '];
end

% ==============================================
%%   loop over images
% ===============================================
ovl=z.ovl_images;
f1 =z.bg_image;
opacity=z.opacity;
if z.opacity>0
    opacity=100-z.opacity;
end

pnglist={};
for i=1:length(ovl)
    f2=ovl{i};
    [~, name,ext]=fileparts(f2);
    
    if any(isnan(z.bg_clim))
        bglims='';
    else
        bglims =[ ' -l ' num2str(z.bg_clim(1)) ' -h ' num2str(z.bg_clim(2))];
    end
    p1=[' -m ' msfile ' -c -0 ' bglims ' -b ' num2str(opacity) ];
    
    if any(isnan(z.ovl_clim))
        ovlims='';
    else
        ovlims =[ ' -l ' num2str(z.ovl_clim(1)) ' -h ' num2str(z.ovl_clim(2))];
    end
    
    %     img2para=[' -c -' num2str(cmapnum) ' -l ' num2str(p.lim(1)) ' -h ' num2str(p.lim(2)) ' ']
    p2=[' -c ' cmapname ' ' ovlims ' '];
    [status]= system([call   f1 p1   ' -o '  f2  p2 endtag]);
    
    
    % ==============================================
    %%   automate
    % ===============================================
    
    n_attempts  =2;
    issuccess   =0;
    
    for j=1:length(n_attempts)
        if issuccess==0;
            [fistemp] = spm_select('FPList',outdirplot,'_temp123*.png');
            while ~isempty(fistemp)
                delete(fullfile(outdirplot ,'_temp123*.png'));
                [fistemp] = spm_select('FPList',outdirplot,'_temp123*.png');
            end
            pause(.5);
            f3=fullfile(outdirplot,[repmat('_temp123' ,[1 2])]);
            h = actxserver('WScript.Shell');
            h.AppActivate('MultiSlice'); h.SendKeys('%{F}a');pause(.5); h.SendKeys([f3 '{ENTER}']);
            fis='';
            n=0;
            dorun=1;
            tic_max=tic;
            while  dorun==1 % exist(fis)~=2
                [fis] = spm_select('FPList',outdirplot,'_temp123.png');
                % fis=fullfile(outdirplot, '_temp123.png')
                drawnow;
                if isnumeric(fis); fis=''; end
                n=n+1;
                if exist(fis)==2 ;            dorun=0;        end
                if toc(tic_max)>2;            dorun=0;        end
            end
            
            
            
            [fis] = spm_select('FPList',outdirplot,'_temp123.png');
            f4=fullfile(outdirplot,[ 'p_' pnum(i,2) '_' name  '.png']);
            pause(.5);
            [status,message,messageid]=movefile(fis,f4,'f');
        end
        if status==1
            issuccess=1;
        end
        
    end
    %showinfo2(['png:'],f4);
    
    %% ===============================================
    
    
    if z.closeMricron==1
        rclosemricron
    end
    pnglist(end+1,1)={f4};
end



% ==============================================
%%   colorbar
% ===============================================
% cf;
delete(findobj(0,'tag','colorbarTemp'));
% fg; hf=gcf;
hf=figure('visible','off');
set(hf,'tag','colorbarTemp')

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
c.FontSize      =z.cbar_fs;
c.Label.FontSize=z.cbar_fs;

pos=get(c,'position');
set(c,'position',[pos(1)-.5 pos(2) pos(3)+0.05 pos(4) ]);
set(c, 'YAxisLocation','right');

%% ===============================================

set(gca,'units','pixels')
set(hf,'units','pixels')
%% ===============================================
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

% paout =pa;
% paimg =fullfile(pa);
% [~, pptname]=fileparts(p.ppt_filename);
% if isempty(pptname); pptname='test1'; end
% [fis]   = spm_select('FPList',paimg,'p_.*.png');    fis=cellstr(fis);
% tx      ={['path: '  paimg ]};


pptfile =fullfile(outdirplot,[z.ppt_filename '.pptx']);
titlem  =z.ppt_filename ;%['lesion'  ];
fis=pnglist;

nimg_per_page  =4;           %number of images per plot
imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
for i=1:length(imgIDXpage)-1
    if i==1; doc='new'; else; doc='add'; end
    img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
    [~, namex ext]=fileparts2(img_perslice);
    tx=cellfun(@(a,b) {[ a b ]},namex,ext);
    [~,namelegend, ext]=fileparts(file_legend);
    tx(end+1,1)={[ namelegend ext ]};
    
    
    img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[0.02 1.5 ],'wh',[ nan 3.5],...[25.4   nan],...%[ nan 3.5],...
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
    'text',paralist,'tfs',10,'txy',[0 8],'tcol', [0 0 0],'tbgcol',[0.9451    0.9686    0.9490], 'tfn','consolas',...
    'multitext',vs,'disp',1 );






