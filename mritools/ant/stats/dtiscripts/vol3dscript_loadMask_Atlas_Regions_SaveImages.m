% <b> script to - load & display a brain-mask,
%  additionally an atlas is loaded and two regions are  rendered,
% if enabled, the figure is saved from different views (several tiff images created) 
% 
% </b>
% atlas-IDs 13 & 7 will be displayed



%% ===============================================
%%   [xvol3]                  
%% ===============================================
close all;  %close all figures
p=[];
% *** GENERAL PARAMETER ***
p.gen.mask='F:\data8\sarah\sarah_plots_26jan24\templates\AVGTmask.nii';
p.gen.view=[-49.9  37.2];
p.gen.brainColor=[0.9333  0.9333  0.9333];
% *** MAIN PARAMETER [xvol3d-window]*** 
p.main.showarrows=[1];
p.main.braindot=[0];
p.main.brainalpha='.05';
p.main.material=[2];
p.main.notused_material='shiny';
p.main.rblight=[1];
 
 % *** ATLAS *** 
p.atlas='F:\data8\sarah\sarah_plots_26jan24\atlas_SA040521_v4\atlas_SA040521_v4.nii';
 
 % COLORIZED REGIONS 
p.atlasregions={  %ATLAS-REGIONS, show these IDs with Facecolor and FaceAlpha
   'ID',[13],'Facecolor',[1,0,0],'FaceAlpha',[0.8]
   'ID',[7],'Facecolor',[0,0,1],'FaceAlpha',[0.2]
    };

% p.atlasregions={   %ATLAS-REGIONS, show these IDs with  FaceAlpha
%    'ID',[13],'FaceAlpha',[0.8]
%    'ID',[7],'FaceAlpha',[0.8]
%     };

%  p.atlasregions=[13 7] ; %ATLAS-REGIONS, show these IDs
%     };
%-----load xvol3-properties-----------------------
xvol3d('loadprop',p); % load properties


%% ===============================================
%% code to save images 
% set 'saveImg' to [1] to enable saving option
%% ===============================================
saveImg=0;
if saveImg==1
    s.saveimg_edPath      =  'F:\data8\sarah\sarah_plots_26jan24\imagesTest';     % outpot path for image(s)
    s.saveimg_rdTimeStamp =  [1];     % add timeStamp to image-filename {0,1}
    s.saveimg_edPrefix    =  'v';     % prefix for image-filename {string}
    s.saveimg_popResol    =  [1];     % image resolution {pulldown-index}
    s.saveimg_popFormat   =  [1];     % image-format {pulldown-index}
    s.saveimg_popViewType =  [2];     % view-type {pulldown-index}; (1)current view; (2) all views
    s.saveimg_edCropTol   =  '20';     % crop-tolerance (in pixel) applies only if [saveimg_rdCrop] is 1
    s.saveimg_rdHideCbar  =  [1];     % hide colorbar {0,1}
    s.saveimg_rdCrop      =  [1];     % crop image {0,1}
    xvol3d('saveimg',s,'closeGUI',0 ); % cmd to save image(s) keep GUI open
end