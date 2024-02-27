% <b> script to save ballNsticks-plots (v*.tif) to powerpoint </b>
% generate ppt-file containing saved ballNstick plots (previously saved as 'v*tif')



img_path='F:\data8\schoenke_2dregistration\panel3_ballNsticks';
pptfile=fullfile(img_path, 'ballNsticks.pptx');
ballnsticks2ppt(img_path,pptfile);

