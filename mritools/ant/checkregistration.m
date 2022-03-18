
%simple function to check the registration (HTML-file)
% for this a HTML-file is created in the "checks"-folder within the study-folder
%% CMD
% checkregistration        % checks forward registration 'x_t2.nii' onto template ('AVGT.nii'), silent mode
% checkregistration(gui)   % gui [0/1]: open gui NO/YES to change parameter,  default: 0
% checkregistration(gui,direction) % direction [1/-1]: forward/invers registration, default: 1
% checkregistration(gui,direction,varargin); /optional)varargin: addit. pairwaise paramter inputs
% 
%% additional pairwise paramter
% backgroundImg: Background/reference image (a single file); default:  'AVGT.nii'                                                                      
% overlayImg   : Image to overlay (multiple files possible); default:  'x_t2.nii'                                                                       
% outputPath   : Outputpath: path to write HTMLfiles and image-folder. 
%                default: "checks" in the study-folder , if empty
% outputstring : optional Output string added (suffix) to the HTML-filename and image-directory 
%                default: 'checkRegistration_fdw' for standard-space                                            
% slices       : SLICE-SELECTION:  "n"+NUMBER: number of slices to plot
%                default: 'n20';                          
% dim          : imension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital   
%                default for standard-space: 'n20'                             
% size         : Image size in HTML file (in pixels);  default: [400];                                                                                                        
% grid         : Show line grid on top of image {0,1}; default: [1];                                                                                                             
% gridspace    : Space between grid lines (in pixels); default: [20];                                                                                                               
% gridcolor    : RGB-Grid color; default: [1  0  0];                                                                                                                                
% 
%% examples;
% checkregistration    % checks forward registration (STANDARD_SPACE): 'x_t2.nii' onto template ('AVGT.nii'), silent mode
% checkregistration(1) % same with open GUI
% checkregistration([],-1);% checks inverse registration (NATIVE SPACE) 't2.nii' onto inverse template ('ix_AVGT.nii'), silent mode
% checkregistration(0,-1) ;% same as above
% checkregistration(1,-1) ;% same as above  with open GUI
% checkregistration(1)
%% example: no gui, check standardspace, overlay with 'x_t2.nii' with hemisphereMak 'AVGThemi.nii', outputstring(folder) is 'chk_fwd_hemisphereMask'
% checkregistration(0,1,'backgroundImg','AVGThemi.nii','outputstring','chk_fwd_hemisphereMask')
%% example: no gui, check standardspace, use several images to check--> click hyperlink "index-file" [open] to inspect the results
% checkregistration(0,0,'overlayImg',{'x_t2.nii' 'AVGThemi.nii'},'outputstring','chk_fwd_multiimages')
% example: no gui, check standardspace, transversal view, 10 slices, green gridcolor
%  checkregistration(0,1,'dim',1,'slices','n10','gridcolor',[0 0.5 0 ])

function checkregistration(gui,direction,varargin)

%% ======[inputs]=========================================

d.gui       =0;
d.direction =1;

if exist('gui')==1        && ~isempty(gui);           d.gui      =gui       ;end
if exist('direction')==1  && ~isempty(direction);     d.direction=direction ;end


if nargin>2
    p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
else
    p=struct();
end

%% =========[predefinitions]======================================
p0=struct();

if d.direction==1
    p0.backgroundImg = { 'AVGT.nii' };                   % % [SELECT] Background/reference image (a single file)
    p0.overlayImg    = { 'x_t2.nii' };                   % % [SELECT] Image to overlay (multiple files possible)
    p0.outputstring  = 'checkRegistration_fdw';              % % optional Output string added (suffix) to the HTML-filename and image-directory
    p0.dim           = [2];                              % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital
elseif d.direction==-1
    p0.backgroundImg = { 'ix_AVGT.nii' };                   % % [SELECT] Background/reference image (a single file)
    p0.overlayImg    = { 't2.nii' };                   % % [SELECT] Image to overlay (multiple files possible)
    p0.outputstring  = 'checkRegistration_inv';              % % optional Output string added (suffix) to the HTML-filename and image-directory
    p0.dim           = [1];                              % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital
end

% ==============================================
%%      variable up parameter
% ===============================================
p0.outputPath    = '';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
p0.slices        = 'n20';                            % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
p0.size          = [400];                            % % Image size in HTML file (in pixels)                                                                                        
p0.grid          = [1];                              % % Show line grid on top of image {0,1}                                                                                       
p0.gridspace     = [20];                             % % Space between grid lines (in pixels)                                                                                       
p0.gridcolor     = [1  0  0];                        % % Grid color   

% ==============================================
%%   run it
% ===============================================

p=catstruct(p0,p);
% p
% d.gui
% return
xcheckreghtml(d.gui,p);

%hyperlink for more help
disp(['<a href="matlab:uhelp(''' mfilename ''')"> ... obtain  help for ['  mfilename '.m]</a>']);


return

    
% % % =====================================================                                                                                                                          
% % % #g FUNCTION:        [xcheckreghtml.m]                                                                                                                                          
% % % #b info :              #yk create HTML-files with overlay of images.                                                                                                           
% % % =====================================================                                                                                                                          
% z=[];                                                                                                                                                                              
% z.backgroundImg = { 'AVGT.nii' };                   % % [SELECT] Background/reference image (a single file)                                                                        
% z.overlayImg    = { 'x_t2.nii' };                   % % [SELECT] Image to overlay (multiple files possible)                                                                        
% z.outputPath    = '';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
% z.outputstring  = 'checkRegistration_fdw';              % % optional Output string added (suffix) to the HTML-filename and image-directory                                             
% z.slices        = 'n20';                            % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
% z.dim           = [2];                              % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                 
% z.size          = [400];                            % % Image size in HTML file (in pixels)                                                                                        
% z.grid          = [1];                              % % Show line grid on top of image {0,1}                                                                                       
% z.gridspace     = [20];                             % % Space between grid lines (in pixels)                                                                                       
% z.gridcolor     = [1  0  0];                        % % Grid color                                                                                                                 
% xcheckreghtml(p.gui,z);
% 
% % ==============================================
% %%   
% % ===============================================
% 
% z=[];                                                                                                                                                                              
% z.backgroundImg = { 'ix_AVGT.nii' };                   % % [SELECT] Background/reference image (a single file)                                                                        
% z.overlayImg    = { 't2.nii' };                   % % [SELECT] Image to overlay (multiple files possible)                                                                        
% z.outputPath    = '';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
% z.outputstring  = 'checkRegistration_inv';              % % optional Output string added (suffix) to the HTML-filename and image-directory                                             
% z.slices        = 'n20';                            % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
% z.dim           = [1];                              % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                 
% z.size          = [400];                            % % Image size in HTML file (in pixels)                                                                                        
% z.grid          = [1];                              % % Show line grid on top of image {0,1}                                                                                       
% z.gridspace     = [20];                             % % Space between grid lines (in pixels)                                                                                       
% z.gridcolor     = [1  0  0];                        % % Grid color                                                                                                                 
% xcheckreghtml(p.gui,z);


