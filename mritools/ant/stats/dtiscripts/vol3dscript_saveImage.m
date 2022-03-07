

% <b> script to save xvol3d-image to drive </b> 
% this example stores the current view of the xvol3d-plot as tif-images with 300dpi-res, 
% adding the time-stamp and the prefix 'v' to resulting filename. 
% The image is cropped, the colorbar is hidden.
% <pre>
% <u><font color="blue"> PARAMETER  <font></u>
% s.saveimg_edPath      =  'F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome_6vsAll\images';     % outpot path for image(s)
% s.saveimg_rdTimeStamp =  [1];     % add timeStamp to image-filename {0,1}
% s.saveimg_edPrefix    =  'v';     % prefix for image-filename {string} 
% s.saveimg_popResol    =  [1];     % image resolution {pulldown-index}
% s.saveimg_popFormat   =  [1];     % image-format {pulldown-index}
% s.saveimg_popViewType =  [1];     % view-type {pulldown-index}; (1)current view; (2) all views
% s.saveimg_edCropTol   =  '20';     % crop-tolerance (in pixel) applies only if [saveimg_rdCrop] is 1 
% s.saveimg_rdHideCbar  =  [1];     % hide colorbar {0,1}
% s.saveimg_rdCrop      =  [1];     % crop image {0,1}
% xvol3d('saveimg',s,'closeGUI',0 ); % cmd to save image(s) keep GUI open
% </pre>
%% =============================================================================


s=[];
s.saveimg_edPath      =  'F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome_6vsAll\images';     % outpot path for image(s)
s.saveimg_rdTimeStamp =  [1];     % add timeStamp to image-filename {0,1}
s.saveimg_edPrefix    =  'v';     % prefix for image-filename {string} 
s.saveimg_popResol    =  [1];     % image resolution {pulldown-index}
s.saveimg_popFormat   =  [1];     % image-format {pulldown-index}
s.saveimg_popViewType =  [1];     % view-type {pulldown-index}; (1)current view; (2) all views
s.saveimg_edCropTol   =  '20';     % crop-tolerance (in pixel) applies only if [saveimg_rdCrop] is 1 
s.saveimg_rdHideCbar  =  [1];     % hide colorbar {0,1}
s.saveimg_rdCrop      =  [1];     % crop image {0,1}
xvol3d('saveimg',s,'closeGUI',0 ); % cmd to save image(s) keep GUI open


