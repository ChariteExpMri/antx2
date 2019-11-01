%#gk    ======================================__
%#gk    LABS   .. instant LABEL toolbox  v1.3 __
%#gk    ======================================__
%##                                  *  07-Apr-2014 13:40:37
%## NOTE
% ••• use contextMENU to change fontType/Size
% to change the fontsize you can also use [ctrl]+mousewheel
% the mousewheel can be used for text scrolling
%___________________________________________________________________________________________________
%### [PURPOSE]  
% • labs can be useful to get the instantious labels for a given MNI-coordinate from several atlases
% • create label table from whole brain/current cluster table 
% • slicing view with instant lables (relodable as matlab-fig file) & linked to SPM's MIP-cursor
% • shortcuts
%### [RISK]   
% • I do not guarantee for the correctness of the output
%___________________________________________________________________________________________________
%#yg NEW
% - small volume correction iteration over with multiple masks
% - statistic value added to current label table 
% -use #### left/right arrow keys #### to change to previous/next contrast
% -separate keyboard shortcuts for ## whole brain / current cluster 
%         #### shortcut [t] #### for ## whole brain table  
%         #### shortcut [z] #### for ## current cluster 
%  CURRENT-Label-WINDOW with 'Allways-ON-TOP'-Checkbox
%  TABLE-WINDOW with  excel/txt-export (statistics & labels) >> ### see contextMenu  
% do you know what JADIC is? See [pause] in the labs-menu of the SPM-RESULTS-Window
% 
%___________________________________________________________________________________________________
%##, SHORTCUTS ####  
%#### [u] ####  ## update LABS ##  
%#### [t] #### create ## whole brain table ## (see context menu for data export)
%#### [z] #### create ## current cluster table ## (see context menu for data export)
%#### [s] ####  ## show section ## (same as .overlays/sections)
%#### [e] ####  ## show slices ##  sag/ax/cor slices with labelInspector,reloadable, locations linked to SPM-MIPS
%#### [b] ####  ## show 3D brain ## (brain in explosive view , ... experimental state)
%#### [c] ####  ## contrast estimate ## (same as: plot/contrast estimate/'myContrast' -->only useful for Anova/EOI 
%#### [m] ####  ## small volume correction ## SVC over multiple masks,--> outputs table for the first cluster of selected mask(s) 
%___________________________________________________________________________________________________
%##, STARTER ####  
% [0] to start labs with SPM: use the 'toolbox'-pulldownMenu from the SPM-MAIN-Window (see installation)
% or type 'labs' in the command window
% [1] #yg the menubar of the SPM-RESULTS window should now contain the new item 'LABS' with pulldown-options
% [2] a small window is opened and indicates the labels of the MNI coordinate of the current MIP position
% [3] you can move the MIP cursor or use the MIP-contextMenu (goto global/local maxima) to another
% position and the small window contains the updated labels of the new MIP coordinate
% [4] the inspection is much faster when using the 'SPM-sections view': if the SPM-graphic-window is active,
%  simply use the shortcut [s] to get the 'sections-view'. Now you can click on your blobs in the coronal/
% saggital and axial images and the small window will show the updated labels
% [5] to get the labels fot the whole brain cluster table use the shortcut [t]: 
%   This opens a new figure with the labels of the peakMaxima of the survived clusters 
% ### [note] ###  you can click on a row in this new figure and the SPM-MIP cursor in the 
%   SPM-graphic-window will jump to this location
% [6] use the shortcut [z]: (sorry 'german tastatur..') to get the labels for the current cluster table 
% [7] inspect LABS-Menubar in the SPM-RESULTS-Window
% 
%##, MICH. #### 
%### [commandwindow]  
% ## labs ## can be re/started also from commandwindow (>> #### labs #### )
% labs([nx3]) ## gives labels of one/severeal MNI coordinates  
%   example: #### labs([0 0 0; 12 -1 22]) #### shows labels for coordinates [0 0 0] and [12 -1 22]
% ## pslices ## (wrapper function for the slice plotter) can be used from commandline see: help pslices
% % 
%##, INSTALLATION #### 
% ### [AUTOMATIC INSTALLATION]  
% [1]unzip folder
% [2]douple-click on #### "labsinstall.m" #### in the labs-folder 
%  ## or
%   draw "labsinstall.m" from the unzipped labs-folder into the matlab workspace
%  ## or
%    navigate matlab to the unzipped folder and type "labsinstall" in the workspace 
% [3]restart SPM
% ### [MANUAL INSTALLATION] 
% [1] copy labs-folder (unzippped) into the SPM/toolbox-folder
%  -check the path of your SPM  [in command window type:   "  which spm.m  "  to obtain the SPM-path]
% [2] add path in matlab: use File\Set Path ...than add folder...select the new path of the labs toolbox  ...spm8\toolbox\labs\
% [3]restart SPM
%___________________________________________________________________________________________________
%## questions/suggestions
%to paul (stefan.koch@charite.de)
%___________________________________________________________________________________________________

 
% 
% >> uhelp(textread('labsinfo.txt','%s','delimiter','\n'))
% 
% e2={'ee3e' ;'blll #gy HASH ### ddede' 
%  #cm LABS
warning off

 uhelp('labsinfo.m')
 fig=findobj(0,'tag','uhelp');
    try
        warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
        jframe=get(fig,'javaframe');
        icon=strrep(which('labs.m'),'labs.m','monkey.png');
        jIcon=javax.swing.ImageIcon(icon);
        jframe.setFigureIcon(jIcon);
    end
 
 
 