

% <b> check registration, create HTML-files   </b>          
% <font color=fuchsia><u>select from below examples:</u></font>
% -check inverse registration for files defined in "overlayImg"-variable & create HTML-files  


%% ======================================================================================
%%  check inverse registration for files defined in "overlayImg"-variable
%%  create HTML-files in the checks-folder                                                           
%% ======================================================================================
z=[];                                                                                                                                                                                                                                                                                  
z.backgroundImg = { 't2.nii' };                  % % Background/reference image (a single file)                                                                                                                                 
z.overlayImg    = { 'ix_AVGThemi.nii' 'ix_AVGTmask.nii' 'ix_ANO.nii' 'c1t2.nii' 'fa.nii'};            % % Image to overlay (multiple files possible)                                                                                                                                 
z.outputPath    = fullfile(antcb('studydir'),'checks');     % % Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )                                                         
z.outputstring  = 'chkreg_inv';                  % % optional Output string added (suffix) to the HTML-filename and image-directory                                                                                                      
z.slices        = 'n20';                         % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image                                                                
z.dim           = [1];                           % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                                                                          
z.size          = [400];                         % % Image size in HTML file (in pixels)                                                                                                                                                 
z.grid          = [1];                           % % Show line grid on top of image {0,1}                                                                                                                                                
z.gridspace     = [20];                          % % Space between grid lines (in pixels)                                                                                                                                                
z.gridcolor     = [0.4667    0.6745    0.1882];  % % Grid color                                                                                                                                                                          
xcheckreghtml(1,z); % with open GUI (1st arg is 1)

