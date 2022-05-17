
% .
% 
% #yk ANTx2
% 
% #b &#8658; Respository: <a href= "https://github.com/ChariteExpMri/antx2">GitHub:github.com/ChariteExpMri/antx2</a> 
% #b &#8658; Tutorials: <a href= "https://chariteexpmri.github.io/antxdoc/">https://chariteexpmri.github.io/antxdoc/</a> 
% #b &#8658; Templates  : <a href= "https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9">googleDrive:animal templates</a> 
% 
% 
%======= CHANGES ================================
% #ra 07 May 2019 (14:16:48)
% #ok new version "ANTx2"
%    - SPM-package: SPM12
%    - templates were outsourced and can be downloaded from:
%      https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
%    - linux/mac/windows
% #ra 08 May 2019 (01:34:19)
%  addedd icon panel [iconpannel4spm.m] for manual preregistration step to facilitate manual
%  registration step
% #ra 22 May 2019 (12:19:03)
%  addded: [xcoregmanu.m] - manually coregister images 
% #ra 07 Aug 2019 (14:23:20)
% initial rigid registration (xwarp3) modified for more robust registration
% [checkRegist.m]:     GUI to check registration of several images
% [getorientation.m]: GUI to examine the apriory orientation (how animal is positioned in scanner)
%  - run it without input arguments or use context menu from ANT animal listbox
%  - the respective ID/number of orientation can be used to define the "orientType" in the projectfile 
% #ra 16 Oct 2019 (03:42:04)
%  1)"create study templates"-step can be performed before running the normalization step
%    ..see Main/Create Study Templates
%  2)two new "get-orientation"-functions implemented. Functions can be used if the orientation of 
%    the native image (t2.nii) is unknown. See animal listbox context menu 
%    (2a) "examineOrientation"       #k [getorientation.m] #n using apriori rotations,.. 
%         best orientation selected via eyeballing
%    (2b) "getOrientationVia3points" #k [manuorient3points.m] #n using 3 manually tagged corresponding points in
%         source and reference image
%     --> 2b approach is easier and faster  for difficult rotations
% function modifications: uhelp, plog
% #ra 17 Oct 2019 (22:04:14)
% [xregisterCT/CTgetbrain_approach2]: added parameter "bonebrainvolume" for more robust cluster-identifaction
% #ra 29 Oct 2019 (23:28:16)
%  modif. files [cfg_getfile2], [uhelp]
% #ra 04 Nov 2019 (11:35:28)
% set up GITHUB repository #bw https://github.com/ChariteExpMri/antx2/
% -primary checks macOS, Linux MINT
% -updated [uhelp]
% #ra 13 Nov 2019 (00:47:38)
% [maskgenerator] added region-lection list and online link to compare selected regions
% #ra 15 Nov 2019 (02:14:16)
% [maskgenerator] added "find" region-panel
% #ra 22 Nov 2019 (11:37:49)
% [maskgenerator] added alpha-transparency slider and display number-of-rows pull down
% checked regions of new Allen2017Hikishima template
% #ra 11 Dec 2019 (14:41:37)
% [xcoreg] fix filename bug; display missing files
% [uhelp]: allows column-wise/selectionwise copying 
% #ra 07 Jan 2020 (15:40:52)
% matlab19b fix: cfg_getfiles2: data from server
% sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)
% #ra 27 Jan 2020 (09:43:48)
% [xexcel2atlas.m]: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx
% [sub_write2excel_nopc]: subfun: write excel file for mac/linux
% #ra 28 Jan 2020 (10:14:11)
% [xexcel2atlas.m]: added information
% #ra 31 Jan 2020 (14:07:48): 
% [xgetlabels4]: allowing readout from "other Space"
% #ra 04 Feb 2020 (18:03:15)
% rat-brain segmentation accelerated
% #ra 17 Feb 2020 (12:32:00)
% set-up pipeline for etruscian shrew
% [xcoreg]: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and
% without spm-registration, (set "task" to [100])
% #ra 19 Feb 2020 (15:15:55)
% [xdraw.m]: manual drawing tool to create masks  ->>Tools/"draw mask"
% #ra 09 Mar 2020 (12:31:52)
% etrucian-shrew modified templates --> not finalized jet
% [approach_60] t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space
% Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration
% #ra 11 Mar 2020 (17:28:49)
% [xsegmenttube]: segment several animals from the same image /tube
% [xsplittubedata]: split data-sets based on tube-segementation
% #ra 20 Mar 2020 (12:30:38)
% [case-filematrix]: export selected files from selected folders
% #ra 14 May 2020 (14:14:07)
% [elastix_checkinstallation] addeed (extras/troubleshoot)  .. fct to check installation of elastix-program
% [uhelp.m] modified: selection color  
% [checkRegist] modified: changed image2clipboard function 
% [summary_export] added (available via context menu of "PR"-radio in ANT-main window) 
% .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder
% #ra 15 May 2020 (17:33:52)
% [setup_elastixlinux.m] modified-->solved problem: stucked installation of MRICRON 
% #ra 29 May 2020 (14:45:41)
% [xstatlabels] bugfixed 
% [uhelp] added finder panel 
% #ra 23 Jun 2020 (17:01:21)
% [doelastix.m] update, backward transformation now possible with userdefined voxel or dim-size
% #ra 23 Jun 2020 (17:13:43)
% 3D-volume visualization added (main menu .. grahics/3D-volume): allows to 3D-visualize atlas regions,
% nodes & links (connections/~strength) and statistical images/intensity images [xvol3d.m]
% -main features can be accessed via command line
% #ra 30 Jun 2020 (23:15:45)
% [xvol3d.m] -updated, tested Linux/MAX/WIN, added more options  and label properties
% #ra 08 Jul 2020 (13:37:00)
% [dtistat]: revised; for DTI-connectivities allows input data from MRtrix; new command line access;
% new COIfile;  
% #ra 03 Aug 2020 (12:50:16)
% debug Matlab19b error [xbruker2nifti].. in preadfile2: error occured due to uncommented code 
% after 'return' command (varargin issue)
% #ra 04 Aug 2020 (16:38:17)
% [installfromgithub] small changes
% #ra 05 Aug 2020 (22:10:09)
% solved issue: unintended interaction between help window (mouse-over main menu) and ant-history window 
% #ra 07 Aug 2020 (14:43:11)
% [xheadman.m] explicit output filename, added tooltips
% [skullstrip_pcnn3d]: added errorMSG  if vox-size is to large
% [displaykey2.m]: bugfix with zooming
% #ra 07 Aug 2020 (17:36:56)
% [doelastix] (deform volumes elastix) now possible, apply registration-trafo to 4D-data (example: BOLD-timeseries) (..not parallelized yet)
% #ra 10 Aug 2020 (11:34:58)
% [doelastix] (deform volumes elastix) parallelized for 4D-data
% #ra 14 Aug 2020 (12:57:03)
% [getReferencePath] modified (layout with listbox, instead of buttons); recursive search for 'AVGT.nii' in (sub)/folder of ant-templates
%  --> to overcome the (sub)/folder nestings in the ant-templates folder
% #ra 17 Aug 2020 (16:49:32)
% [paramgui] new version, (multi-icon style, execution-history)
% ..the old version is still available (via menu/preferences)
% 
% [installfromgithub] BUG-solved:  after 'rebuilding'...gui could not close and workdir did not go prev. study path
% #ra 24 Aug 2020 (09:27:02)
% new tutorial #bw ["tutorial_orientation_and_manucoreg.doc"] 
% This tutorial deals with image orientation for template registration and manual coregistration.
%   #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% #ra 24 Aug 2020 (12:08:22)
% - getanatomicallabels [sub_atlaslabel2xls.m]: fixed bug.. writing excel table (mac) because newer cell2table-version
% variable names must match with Matlab variable style. This happens when animal names (such as "20130422_TF_001_m1_s3_e6_p1")
% start with a numeric value instead of a character). SOLUTION: In such cases animals the animals in the excel table 
% will be renamed (adding a prefix 's' such as "s20130422_TF_001_m1_s3_e6_p1").
% #ra 27 Aug 2020 (15:42:11)
% [xvol3d_convertscores]: new function for xvol3d...allows to 3d colorize user-specific regions by scores/values (percentages/statist scores) 
% #ra 28 Aug 2020 (10:43:27)
% - [uhelp] bug-fix: help-fig failed to update fontsize and fig-position after reopening  
% - updates/changes ([antver.m]) can be inspected from the GITHUB webside.    
% #ra 01 Sep 2020 (12:49:32)
% manual coregistration [displaykey3inv.m]: update help 
% #ra 07 Sep 2020 (03:41:16)
% [xdownloadtemplate] DOWNLOAD TEMPLATES VIA GUI (faster alternative compared to webside).
%    #gw -->  Access via Extras/donwload templates  --> unresolved/untested: proxy settings 
% #ra 14 Sep 2020 (13:14:15)
% [xdownloadtemplate] DOWNLOAD TEMPLATES VIA GUI ..modified using curl (MAC/Linux) and wget.exe (windows)
% - Function was tested with and without proxies using Win, MAC & Linux
% #ra 17 Sep 2020 (13:45:38)
% [xgetlabels4] BUG solved: "zeros" in resulting excelFile
% #ra 21 Sep 2020 (12:46:16)
% [xsegmenttubeManu] added. This function allows to manually segment a Nifti-image containing several
% animals ("multi-tube" image). This function works as manual pendant to [xsegmenttube].
% #ra 22 Sep 2020 (00:14:08)
% [xdicom2nifti]: revised (now allows conversion using MRICRON or SPM)...Mac/Linux/WIN
% #ra 22 Sep 2020 (13:30:09)
% new tutorial #bw ['tutorial_convertDICOMs.doc']  
% This tutorial deals with the conversion of dicom to NIFTI files.
%    #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% #ra 06 Oct 2020 (03:45:46)
% [xdraw] draw a (multi-) mask manually , improved version, allows otsu-segmentation, new image drawing
% tools, calculate volume for each mask-region, save as mask or save masked background image
%    #gw --> access via ANT-menu: Tools/draw mask
% #ra 07 Oct 2020 (12:56:31)
% -[xdraw] : debug, added measuring tool (distance in mm/pixel and angle)
% #ra 13 Oct 2020 (10:46:14)
% - EXVIVO APPROACH: coregistration approach for splitted multi-tube skullstripped (exvivo) animals. 
% The problem is the high intensity of the preserving substance enclosing the animal's brain. 
% This resulted in a defective brain mask with subsequent suboptimal rigid registration. 
% Solution: In the settings menu (gearwheel icon) set [usePriorskullstrip] to [4] and set the parameter
% file for rigid transformation [orientelxParamfile] to "..mypath\..\trafoeuler5_MutualInfo.txt"
% This has two effects: First, background intensity is removed and a peudo-mask of 't2.nii' ("_msk.nii")
% is created. Second, mutual information is used as metric for rigid transformation.
% 
% - PARAMTER SETTING [antconfig] (gear wheel icon) has finally obtained a help window.
%    #gw -->  Access: When creating a new project (Menu: Main/new project) or selecting the [gear wheel icon]  
%    obtain the help window via bulb-icon (lower left corner of the paramter file)
% #ra 14 Oct 2020 (02:03:47)
% - [xdraw] drawing mask tool now includes a 3D-otsu segmentation 
% #ra 14 Oct 2020 (17:53:20)
% - [xdraw] drawing mask tool: added contours and contour-based segmentation, completed help
% #ra 25 Oct 2020 (21:33:14)
%  [xdraw] drawing mask tool: refurbished, containing tools: 
%   - advanced saving options, 
%   - contour line segmentation
%   - ROI manipulation (translate/rotate/flip/copy/replace)
%   - TODO: test MAC & LINUX :  DONE!
% #ra 30 Oct 2020 (14:50:30)
% [SIGMA RAT template] (Barrière et al., 2019) added to gdrive
%   - Paper           : https://rdcu.be/b9tKX  or https://doi.org/10.1038/s41467-019-13575-7
%   - #gw -->  access via link : https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
%     or ANT menu: EXTRAS/download templates
% #ra 16 Nov 2020 (01:37:17) 
% [atlasviewer.m] added. This function allows to display an atlas (NIFTI file) for example the
% 'ANO.nii' -file 
%      #gw -->   access: ANT-MENU: Graphics/Atlas viewer
%   -TODO: test MAC & LINUX   : DONE!
% #ra 18 Nov 2020 (13:30:53)
% - [xdownloadtemplate.m] added: check internet connection status
% - new tutorial #bw ['tutorial_brukerImport.doc']  
%   This tutorial deals with conversion of Bruker data to NIFTI files.
%     #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% #ra 23 Nov 2020 (15:32:33)
% - [xrename]: extended functionality: now allows basic math operations of images such as
%   ROI extraction, image thresholding, combine images (mask an image by another image)
% - other options of [xrename]: scale image, change voxel resolution (see help of xrename)
%       #gw -->  access via ANT-menu: Tools/manipulate files
% #ra 24 Nov 2020 (14:08:48)
% - NEW TUTORIAL  #bw ['tutorial_prepareforFSL.doc']
%   PROBLEM: How to use the backtransformed template brain mask for resting-state
%   data processed via FSL. IMPORTANT..this tutorial is not finished!
%     This tutorial explains the following steps
%               1. Set ANT path, make study folder +start ANT GUI
%               2. Download template
%               3. Define a project
%               4. Import Bruker data
%               5. Import templates for this study
%               6. Create a ‘t2.nii’ image
%               7. Examine Orientation
%               8. Register ‘t2.nii’ to the template
%               9. Back-transform template brain mask to native space
%             10. Extract 1st image of the 4D BOLD series
%             11. Coregister ‘t2.nii’ onto BOLD (RS-) Data
%             12. Mask first EPI-image with brain mask
%             13. Scale up 4D data for FSL
%            #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% -  NEW TUTORIAL  #bw ['tutor_multitube_manualSegment.doc']
%    PROBLEM: Several animals located in one image (I call this "multitube")
%        This tutorial explains the following steps:
%               1. Manual segment images --> draw masks
%               2. Split datasets using the multitube masks
%             #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
%
% #ra 16 Feb 2021 (15:46:57)
%  - DTI-statistic and 2d-matrix/3d-volume visualization was extended 
%    functions: [dtistat.m], [xvol3d.m] and [sub_plotconnections.m]
%  - get anatomical labels [xgetlabels4.m]: The paramter volume percent brain ("volpercbrain") was
%    re-introduced in the resulting Excel-table
% 
% #ra 13 Apr 2021 (21:52:21)
% - CAT-atlas (Stolzberg et al., 2017) added to google-drive
%   #gw -->  access via link : https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
%   paper: https://onlinelibrary.wiley.com/doi/abs/10.1002/cne.24271
% 
% 
% #ra 06 May 2021 (10:29:16)
% fixed BUG in "rsavenii.m" (issue only for writing 4D-data only)
% #ra 07 May 2021 (22:15:55)
% -->started [checkreghtml]: make html-page of overlay of arbitrary pairs of images for selected animals 
% #ra 10 May 2021 (20:39:32)
% #k [xcheckreghtml.m] #n implemented. This function create HTML-files with overlays of arbitrary images. 
%  The HTML-files can be used to check the registration, can be zipped and send to others.
% #gw --> access via ANT-menu: Graphics/generate HTML-file
% 
% #ra 29 May 2021 (01:20:40)
% #k [xrealign.m] #n  --> realign 3D-(time)-series or 4D volume using SPM-realign function
% #gw --> access via ANT-menu: Tools/realign images (SPM, monomodal)
% 
% #ra 25 Jun 2021 (12:05:36)
% #k [xrealign_elastix.m]: #n multimodal realignment of 4D data (timeseries) using ELASTX and mutual information
% #gw --> access via ANT-menu: Tools/realign images (ELASTIX, multimodal)
% 
% #ra 28 Jun 2021 (15:36:53)
% #k [show4d.m]: #n SHOW 4D-VOLUME / check quality of realignment of 4D-volume
% function allows to display a 4D-volume and it's realigned version side-by-side
% For quality assessment, the 1st volume is displayed on top (as contour plot) of the selected (3D)-volume 
% #gw --> access via ANT-menu: Graphics/check 4D-volume (realignment)
% 
% #ra 12 Aug 2021 (18:49:17)
% #k [xcheckreghtml.m] #n ... fixed BUG: "dimension"-parameter error with string/double vartype 
% [checkpath] checks whether paths-names of ANTx-TBX, a study-project/template and data-sets contain special characters 
% Special characters might result in errors & crashes.
% #gw --> access via ANT-menu: Extras/troubleshoot/check path-names
% 
% #ra 16 Aug 2021 (11:18:29)
% #k [case-filematrix] #n add file functionality: copy/delete/export files ; file information  
% #gw -->  access via ANT-menu: Graphics/show case-file-matrix
% #ra 16 Aug 2021 (13:35:35)
% test: gitHub with "personal access token" : upload-seems to work/chk(TunnelBlick)
% 
% #ra 18 Aug 2021 (12:24:04)
% #k [xrename.m]: #n added context menu for easier file manipulation (copying/renaming/expansion/deletion)
% and additional file information (file paths; existence of files; header information)
% 
% #ra 19 Aug 2021 (21:02:37) 
% #k [xstat.m]: #n added pulldown to select the statistical method to treat the multiple comparison problem
% #ba 19 Aug 2021 (23:50:18)
% #k [xrename.m]: #n now allows to threshold an image
% #gw -->  access via ANT-menu: Tools/manipulate files
% #ba 23 Aug 2021 (14:12:17)
% #k [xcalcSNRimage.m] #n convert image to SNR-image 
% according to Gudbjartsson H, Patz S. 1995: The Rician distribution of noisy MRI data. Magn Reson Med.; 34(6): 910–914.)
% -can be used for Fluorine-19 (19F)-contrast images 
% #gw -->  access via ANT-menu: SNIPS/convert image to SNR-image
% #ba 08 Sep 2021 (10:42:24)
% #k [sub_sting.m] #n creates node-related needles with numeric annotations (labels) onto 3D-brain (for DTI-data)
% -annotations are view-dependent and will be adjusted accordingly 
% -labels appear at positions along a circle circumventing the brain
% -labels can be manually repositioned
% -function is part of xvol3d.m/sub_plotconnections to display DTI-connection onto a 3D brain
% 
% #ba 13 Sep 2021 (15:05:32)
% #k [setanimalstatus.m]: #n set a processing status tag for selected animal(s)
% The status tag appears in the left listbox (animals) and tooltip when hovering over the animal.
% #gw --> access via animal-listbox &#8658; context-menu/set status
% 
% #ba 15 Sep 2021 (17:30:22)
% #k [anthistory.m]: #n load a project from history, i.a. from a list of previous ANTx calls/studies
% #gw --> access via ANT main GUI: &#8658; [green book]-button. Hit button to open the history.
% 
% #ba 21 Sep 2021 (01:01:34)
% #k [DTIprep.m]: #n prepare data for DTI-processing via Mrtrix. Ideally DTI-processing could start
% after conventional registration of the "t2.nii" image to the normal space und running 
% this DTIprep-step (a suitable DTI-atlas must be provided).
% shellscripts must be downloaded from https://github.com/ChariteExpMri/rodentDtiConnectomics
% and saved in the "shellscripts" folder (same level as the dat-folder)
%  __current status__
%  #n &#9745; DTIprep for "single-shell" (single b-value diffusion acquisitions) analysis: finished + tested
%  #n &#9832; DTIprep for "multi-shell" analysis: has to be adjusted & tested! 
% #gw --> access via ANT-menu: &#8658; Statistic/DTIprep for mrtrix.
% #ba 21 Sep 2021 (22:50:00)
% #k [DTIprep.m]: updated
% #n &#9745; DTIprep for "multi-shell" (multi b-value diffusion acquisitions) analysis: finished
% -wrote some info/help to work with DTIprep.   
% -added context menu (check b-table/DWI-files; delete files etc.)
% 
% #ba 28 Sep 2021 (13:33:22)
% small changes in 
%  #k [uhelp] #n added: hyperlink selection via context menu 
%  #k [cfg_getfile2] #n added: 4D-Nifti filter
% 
% #ba 29 Sep 2021 (17:11:33)
% Created a web-side with tutorials 
% Depending on the time, further tutorials will be uploaded soon
% #gw -->  access via link : <u>"https://chariteexpmri.github.io/antxdoc"
% 
% 
% #ba 01 Nov 2021 (17:29:22)
%  #k [DTIprep] #n minor changes ..added some solutions to avoid some MRtrix-BUGs:
% --> see help of DTIprep.m
% 
% #ba 27 Nov 2021 (23:15:21)
%  #k [xgetparameter.m ] #n obtain mask-based parameter from images (multimasks & masks can be mulinary)
% mask-based paramters are:  'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'    
% MASK: you can use several masks/images, each with several sub-masks/(IDs), IDS across masks
% can be similar 
% The output is one EXCELFILE containing sheets for each paramter. Each column contains the data of 
% one of the selected animals. The output (excelfile) can be analyzed using MENU/STATISTIC/"label based statistic"
% .. CURRENTLY ONY PROVIDED FOR IMAGES/MASKS IN STANDARD-SPACE
% 
% #ba 28 Nov 2021 (00:33:52)
% #k [xstatlabels.m] #n added tail-option for hypothesis-testing 
% 
% #ba 28 Nov 2021 (23:58:44)
% #k [xcreateMaps.m] #n create MAPS across animals (heatmaps/IncidenceMaps/MeanImage Maps etc)
% xcreateMaps.m: (former version "xincidencemap.m")
% choose a math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*}
% #gw --> access via ANT-menu: &#8658; SNIPS/create Maps (incidenceMaps/MeanImage etc)
% 
% #k [xrealign_elastix.m]  #n --> replace NANs by Zeros in 4D-volume after realignment
% 
% #ba 06 Dec 2021 (17:03:18)
% #k [cfm.m] #n --> case-file-matrix: visualize data (files x dirs), basic file-manipulation
% #gw --> access via ANT-GUI: Two new icons next to study-history-icon: CFM of all animals from 
% the current study or CFM for selected animals (selected via left listbox)
% 
% #ba 08 Dec 2021 (01:22:39)
% #k [xvol3d.m] #n save image as (tif/jpg/png) via context-menu (disable rotation-mode  before access the context menu)
% 
% #ba 20 Dec 2021 (14:42:46)
% #k [xstatlabels.m] #n The group-column in the "group-assignment"-Excel-file can be numeric now
% 
% #ba 03 Jan 2022 (14:08:14)
% #k [xgetlabels4.m] #n A specifc fileName for resulting excel-file can be entered.
% 
% 
% #ba 06 Jan 2022 (13:37:22)
% #k [xcreateMaps.m] #n solved bugs:
% - selection of animals via left ANT-listbox before running this function enabled
% - previous image-operation  "abs" ...sumation over images debugged. Note that this option produces the same
%   result as the "sum"-operation.
% #gw --> access via ANT-menu: &#8658; SNIPS/Create MAPS
% 
% 
% #ba 12 Jan 2022 (17:12:52)
% #k [xstatlabels.m]: #n 'export' as excel-file now also contains the single animal data
% #k [xgetparameter.m]: #n added parameter "integrated density"
% 
% #ba 14 Jan 2022 (12:03:50)
% #k [xdeformpop]: #n GUI was replaced by extended version (part of 'deform Volume Elastix'-operation)
% #k [xstat]: #n function was updated
%   - The Powerpoint-report of the voxelwise statistic was extended
%   - programmatically change viewing parameters / generate Powerpoint-report
% 
% #ba 27 Jan 2022 (11:43:10)
% #k [xstat]: #n  voxelwise analysis was extended.
%   - post-hoc paramter modifications and summary report can executed from comandline
%   - write summary as powerpoint-files, write statistical table as excel-file, 
%   - save statistically thresholded volume  (Nifti)
%   - button [code posthoc] display the code snippet for creating a summary (PPT-,Excel-,NIfti-files) 
% #k [xstatlabels]: #n regionwise statistic was extended
%  - The excelsheet now also contains a sheet "singleData" with the group-specifc single data for each region. 
%   The single data be further used for plots/visualization or other purposes
% 
% #ba 06 Feb 2022 (21:18:33)
% function #k [getNiftiheader]: #n obtain NIFTI-header information of one/several NIFTI-files
% function #k [reslice_nii2]: #n reslice image by applying the header's transformation matrix
% 
% #T 06 Feb 2022 (21:20:48)
% Updated the tutorial webside on Github-Pages. The Webside contains basic tutorials (PDF-files).
% #gw -->  access via link : <u>"https://chariteexpmri.github.io/antxdoc"
% #gw --> access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages)
% 
% #ba 08 Feb 2022 (12:38:25)
% function #k [exportfiles]: #n added as alternative to export/copy files from any data-hierarchie to
% a destination folder (no ANT-project must be loaded for this function)
% -function should also work for files of a studie's "dat"-folder
% #gw --> access via ANT-menu: &#8658; Main/export files (from any folder)
% 
% #ba 11 Feb 2022 (00:31:35)
% small changes in #k [xdraw]: #n 
% -debugged contour-fill and delete object (right-mouse click) functions
% #k [ant]: #n added resize buttons to animal listbox of the ANT gui. Resize the listbox in case of
% large cohorts or long animal names/identifiers
% 
% #ba 23 Feb 2022 (16:40:25)
% function #k [DTIprep]: #n added a script-selection-option
% - scripts can be copied and costumized for own purpose
% - currently, there exist only three scripts:
% 1) "DTIscript_HPC_exportData_makeBatch.m"
%   - script allows to export DTI-data to HPC-cluster storage, write a HPC-slurm batch & make batch executable
%   - using "sbatch myBatchName.sh" the DTI-processing can be performed on the HPC-cluster
% 2) "DTIscript_posthoc_makeHTML_QA.m"
%   - make HTML-file for quality assesment of DTI-processing (using png-images created by MRtrix)
%   - this script ist for posthoc QA
% 3) "DTIscript_posthoc_exportData4Statistic.m"
%  -post hoc file to export necessary files from HPC-cluster to another directory
%  - script can be used for post-hoc statistical analysis
% 
% #ba 02 Mar 2022 (16:17:11)
% function #k [xgetparameter]: #n extended
% - parameter-extraction now possible with animal-specific mask(s) located in the animal-folders
%   potential scenario: parameter-extraction using animal-specific masks from read-out images
%   in native space
% #ba 02 Mar 2022 (17:06:11)
% new tutorial #bw ["tutorial_extractParamter_via_Mask.docx"] 
% This tutorial shows how to extract parameters (mean/volume etc.) from a read-out image 
% using a mask. In this tutorial the mask contains two ROIs.
% #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% #gw --> access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages)
% 
% 
% #ba 07 Mar 2022 (09:52:06)
% new function #k [scripts_gui]: #n This function contains a collection of scripts that can be 
% costumized and applied. Currently the script-collection is available for the following functions:
% DTIprep.m; dtistat.m, xvol3d.m
% 
% #ba 09 Mar 2022 (11:02:40)
% fixed bug in #k [exportfiles]: #n :  subdir was not addressed correctly
% 
% #ba 11 Mar 2022 (08:24:50)
% added a scripts collection to #k [xstat.m]: #n added scripts for voselwise statistic
%  -scripts can be modified and applied
%  -current scripts for voxwelwise statistic:
%     'VWscript_twosampleStat_simple.m'
%     'VWscript_MakeSummary_simple.m'
%     'VWscript_twosampleStat_severalimages.m'
%     'VWscript_MakeSummary_severalimages.m'
%     'VWscript_twosampleStat_severalimages_severalgroups.m'
%     'VWscript_MakeSummary_severalimages_severalgroups.m'
% #gw --> access via ANT-menu: &#8658; Statistic/SPM-statistic (or xstat.m)  &#8658; use the [scripts]-button
% 
% #ba 16 Mar 2022 (11:30:01)
% script "STscript_DTIstatistic_simple2.m" added to #k [dtistat.m]: #n  
% This script performs the t-statistic (two groups) of the fibre-connections (*.csv-file) 
% #gw --> access via ANT-menu: &#8658; Statistic/DTI-statistic (or dtistat.m)  &#8658; use the [scripts]-button
% 
% #ba 18 Mar 2022 (13:06:56)
% added to context menu of ANTx-animal listbox: checkRegistraton via HTML-file
% this option creates an HTML-file with the registration results for selected animals
% you can chose between
%     -check forward registration (standard-space)
%     -check specific forward registration (open GUI) --> you can specify specific paramters
%     -check inverse registration (native-space)
%     -check specific inverse registration (open GUI) --> you can specify specific paramters
% #gw --> ANTx-animal listbox &#8658; context menu
% 
% #ba 23 Mar 2022 (00:37:51) 
% different sorting strategies of the animals in the ANT-main GUI animal-listbox implemented 
%     'default' : default sorting
%     'progress_down' or 'progress_up'    : sort animals after atlas-registration-progress
%     'lengthName_up' or 'lengthName_down': sort animals after animal name length
%     'statusMsg_up'  or 'statusMsg_down' : sort animals after status message (specified via context menu: "set status")
% #gw --> access via ANTx Gui pulldown-menu next to the [update]-button 
% 
% 
% #ba 24 Mar 2022 (11:34:05)
% added "approach_photothrombosis" as option for elxMaskApproach
% This approach can be used for photothrombotic stroke models together with a lesionmask (with name 'lesionmask.nii')
% 
% added #k [cleanmask.m]: #n This function can be used to delete slices from a NIFTI-image
% - currently this function can be used to delete errornuous slices from the "_msk.nii" image,
% generated from the skullstripping step. In some cases the registration (subsequent step) which 
% depends on the "_msk.nii" is suboptimal. Thus use cleanmask.m to delete the affected slices from 
% "_msk.nii"
% this function is still in progress...
% #gw --> ANTx-animal listbox &#8658; context menu /SPECIFIC TOOLS/prune mask ("_msk.nii")
% 
% #ba 24 Mar 2022 (23:16:21)
% #k [cleanmask.m]: #n now also allows to remove tissue parts, help added
% 
% #ba 04 Apr 2022 (13:54:22)
% added #k [HTMLprocsteps.m]: #n This function creates additional HTML-files for the 
% processing report (initialization, coregistration, segementation and warping).
% These HTML-files are available as hyperlinks in the "summary.html"-report and depicts
% the output if each processing step for all animals. Thus you may not need to select the 
% 'inspect'-hyperlink for each animal. Just select respective hyperlink to obtain an 
% overview for all animals.  
% 
% #ba 05 Apr 2022 (12:39:20)
% added #k [scripts_collection.m]: #n This GUI contains scripts which can can be costumized
% The scripts-collection will be extended in the near future  
% #gw --> access via ANT-menu: &#8658; SNIPS/scripts collection
% 
% #ba 06 Apr 2022 (12:21:31)
% bugfix in #k [exportfiles.m]: #n  ...internal file-filter was buggy  
% bugfix in #k [xstat.m]: #n ... multifactorial design was buggy
% 
% #ba 06 Apr 2022 (14:47:57)
% #k [antcb.m]: #n extended.. antcb('studydir') obtain study-folder
% [sdir sinfo]=antcb('studydir','info');  % obtain info for the study (storage-size/number of files/animals)
% see antcb('studydir?') for help
% 
% bugfix in #k [sub_atlaslabel2xls.m]: #n ... removing default-sheets was not working
% 
% #ba 06 Apr 2022 (17:39:47)
% #k [scripts_collection.m]: #n extended.. now contains the following scripts/examples:
% 'sc_xrename.m'                    .. shows how to rename files + basic file manipulation
% 'sc_register_to_standardspace.m'  .. shows how to register 't2.nii' to standard-space
% 'sc_transformimage_exportfile.m'  .. shows how to transform another image to standard-space & export files
% 'sc_checkregistrationHTML.m'      .. shows how to generate HTMLfiles to check the registration
% 'sc_getantomicalLabels.m'         .. shows how to extract anatomical-based parameters from images and save as excel-files
% #gw --> access via ANT-menu: &#8658; SNIPS/scripts collection 
% 
% #ba 11 Apr 2022 (12:23:25)
% #k [xstatlabels.m]: #n GUI was refreshed, added scripts-collection for xstatlabels
% -This function performes regionwise statistics of an image-parameter such as intensity mean or volume
%  between groups 
% #gw --> access via ANT-menu: &#8658; STATISTIC/label-based statistik
% 
% #ba 27 Apr 2022 (17:30:24)
% #k [xbruker2nifti.m]: #n now supports comandline mode (silent/no GUI) with filter option
% -fun "selector2.m" supports preselection of rows
% -fun "lastmodified.m" added; return name and date of the last modified files of a directory and subfolders (sorted)
% 
% #ba 28 Apr 2022 (13:43:07)
% #k [DTIprep.m]: #n prepare data for DTI-processing via Mrtrix. Ideally DTI-processing could start
% - added check and reordering optin for b-table & DWI-files
% #gw --> access via ANT-menu: &#8658; Statistic/DTIprep for mrtrix.
% 
% #ba 29 Apr 2022 (08:23:36)
% #k [xbruker2nifti.m]: #n command line support was exteded (file filter options)
% 
% #ba 04 May 2022 (14:53:04)
% antcb('selectdirs') command extended using filesearch-operation
% example:  antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'or');  %select all dirs containing either 't2.nii' or 'x_t2.nii'      
% 
% #ba 06 May 2022 (14:17:26)
% #k [updateantx.m]: #n noGUI-update/install function for antx-project via GITHUB (no graphical userinterface)
% -type "updateantx(2)" to just update local antx-toolbox
% -see help of updateantx.m for more information
% 
% #ba 09 May 2022 (15:52:33)
% #k [xmaskgenerator.m]: #n implemented reslicing if another atlas is used with a different voxel-size
% 
% #ba 11 May 2022 (00:08:32)
% #k [dispfiles.m]: #n display files folderwise in command-window (no GUI)
% examples with ant: dispfiles('form',2,'flt','.*.nii','counts',0);
% example no graphics support: dispfiles('form',2,'flt','.*.nii','counts',0,'dir',fullfile(pwd,'dat'));
% 
% #ba 13 May 2022 (01:12:05)
% #k [xregister2d.m]: #n modified
%  -runs on machines without graphic support
%  -option to allow parallel processing over animals 
% #k [xcoreg.m]: #n modified
%  -runs on machines without graphic support
%  -option to allow parallel processing over animals 
% 
% #ba 13 May 2022 (16:46:56)
% new tutorial #bw ["tutorial_noGraphic_support.docx"] 
% This tutorial shows how to work on machines without graphic support and without GUIs 
%     1) Optional: how to set the paths of elastix in unix/linux-system:
%     2) Optional: open interactive session on hpc-cluster and start matlab
%     3) Basics
%        -add antx-paths
%        -go to study-folder
%        -update ant-toolbox
%        -create a project-file: 
%        -load a project-file "proj.m" 
%        -check whether the project-file is loaded 
%     4) Import bruker-data
%     5) Visualize files and folders
%     6) Selection of animals
%     7) Rename files
%     8) Register “t2.nii” to template (standard space, ss)
%     9) Extract the first 3d-volume from the 4d-vlume 'dti_b100.nii' 
%     10) Coregister 'dti_b100_1stimg.nii' to ‘t2.nii’
%     11) Transform another image to standard-space
%     12) Transform another image to native-space
%     13) Check registration in standard-space - create html-file
%     14) Check registration in native-space - create html-file
%     15) REGIONWISE PARAMETER-EXTRACTION  
% This tutorial shows how work without GUis or on machines without graphic support
% #gw --> access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs
% #gw --> access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages) https://chariteexpmri.github.io/antxdoc/
% 
% #ba 16 May 2022 (16:13:10)
% [update]-button added next to [ant version]-button in ANTx-main gui
% The update button allows to retrieve the latest updates from GitHub
% (no GUis/no imput requested from user)
% 
% #ba 17 May 2022 (00:20:29) 
% #k [xgetlabels4.m]  #n modified
% - get regionwise parameter now runs on HPC without GUI/graphic support ...
%   see help of xgetlabels4.m ...Example-4
% - "hemisphere": 'separate' added to obtain region-wise parameters for each hemisphere separately
%    in one run --> this results in two Excel-files (..left & ...right)
% - ["tutorial_noGraphic_support.docx"] was extended
% 
% #ba 17 May 2022 (12:29:46)
% [update]-button next to [ant version]-button obtained a context-menu
% - context menu options: update-info, force update, help on update
% 
% 
% 
% 


%% ===============================================
%----- EOF
% make antvermd for GIT: antver('makeantver')


function antver(varargin)
% r=preadfile(which('antver.m')); r=r.all;
r=strsplit(help('antver'),char(10))';
ichanges=regexpi2(r,'#*20\d{2}.*(\d{2}:\d{2}:\d{2})' );
lastchange=r{ichanges(end)};
lastchange=regexprep(lastchange,{'#\w+ ', ').*'},{'',')'});
r=[r(1:3); {[' last modification: ' lastchange ]}  ;  r(4:end)];
if nargin==1
    if strcmp(varargin{1},'makeantver')
        makeantver(r);
        return
    end
end
isDesktop=usejava('desktop');
if isDesktop==1
    uhelp(r,0, 'cursor' ,'end');
    set(gcf,'NumberTitle','off', 'name', 'ANTx2 - VERSION');
else
    help antver
end
    
% uhelp('antver.m');
if 0
    clipboard('copy', [    ['% #ba '   datestr(now,'dd mmm yyyy (HH:MM:SS)') repmat(' ',1,0) ]           ]);
    clipboard('copy', [    ['% #T '   datestr(now,'dd mmm yyyy (HH:MM:SS)') '' ]           ]);
end


return

function makeantver(r);
% this makes a human readable antver.md


i1=min(regexpi2(r,'CHANGES'));
head=r(1:i1);

s1=r(i1+1:end); % changes
lastline=max(regexpi2(s1,'\w'));
s1=[s1(1:lastline); {' '}];

%resort time: new-->old
it=find(~cellfun(@isempty,regexpi(s1,['#\w+.*(\d\d:\d\d:\d\d)'])));
it(end+1)=size(s1,1);

% https://stackoverflow.com/questions/11509830/how-to-add-color-to-githubs-readme-md-file
tb(1,:)={ '#yk'    '![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) '  'red' } ;
tb(2,:)={ '#ok'    '![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) '  'green' } ;
tb(3,:)={ '#ra'    '![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) '  'blue' } ;
tb(4,:)={ '#bw'    '![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+) '  'margenta' } ;
tb(5,:)={ '#gw -->' '&#8618;'  'green arrow' } ;
tb(6,:)={ '#ba'    '![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) '  'blue' } ;
tb(7,:)={ '#k '     ' '  'remove tag' } ;
tb(8,:)={ ' #n '    ' '  'remove tag' } ;
tb(9,:)={ ' #b '    ' '  'remove tag' } ;


s2=[];
for i=length(it)-1:-1:1
    dv2=s1(it(i):it(i+1)-1);
    
    dv2=regexprep(dv2, {'\[','\]'},{'__[',']__' }); %bold inside brackets
    
    l1=dv2{1};
    idat=regexpi(l1,'\d\d \w\w\w');
    dat=l1(idat:end);
    col=l1(1:idat-1);
    
    dat2=[col ' <ins>**' dat '</ins>' ]; %underlined+bold
    dat2=regexprep(dat2,')',')**');
    
    
    dv2=[ dat2;  dv2(2:end) ];
    %    dv2=[{ro};{ro2}; dv2];
    
    
    for j=1:size(tb,1)
        dv2=cellfun(@(a) {[regexprep(a,tb{j,1},tb{j,2})]} ,dv2 ) ; %green icon for #ok
    end
    
    
    dv2=cellfun(@(a) {[a '  ']} ,dv2 ); % add two spaces for break <br>
%     dv2{end}(end-1:end)=[]; %remove last two of list to avoid break ..would hapen anyway
%   dv2(end+1,1)={'<!---->'}; %force end of list
%     el=dv2{end};
    if ~isempty(regexpi(dv2 ,'^\s*-\s|^\s*\(\d+)\s|^\s*\d+)\s'))
        dv2(end+1,1)={'<!---->'}; %force end of list
    end
    s2=[s2; dv2];
end


head0={'## **ANTx2 Modifications**'};
head1=head(regexpi2(head,'Antx2')+1:end);
head1(regexpi2(head1,' CHANGES'))=[];%remove  '=== CHANGES ==' line
head1=[head1; '------------------' ];%'**CHANGES**'
head1=cellfun(@(a) {[regexprep(a,'last modification:',[tb{1,2} 'last modification:']) ]} ,head1 ) ; %red icon for last modific
head1=cellfun(@(a) {[a '  ']} ,head1 ); % add two spaces for break <br>

w=[head0; head1; s2];

% tes1='```js ...
%   import { Component } from '@angular/core';
%   import { MovieService } from './services/movie.service';
% 
%   @Component({
%     selector: 'app-root',
%     templateUrl: './app.component.html',
%     styleUrls: ['./app.component.css'],
%     providers: [ MovieService ]
%   })
%   export class AppComponent {
%     title = 'app works!';
%   }
% ```'

% w=[ '<font size="+5">' ;w; '</font>'];
w=regexprep(w,' #b ','');

fileout=fullfile(fileparts(which('antver.m')),'antver.md');
pwrite2file(fileout,w);






