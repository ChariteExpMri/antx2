## **ANTx2 Modifications**
 last modification:   28 Aug 2020 (10:43:27)  
    
 ======= CHANGES ================================  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  28 Aug 2020 (10:43:27)  

  [uhelp] bug-fig: help-fig did not update fontsize and position after closing and reopening     
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  27 Aug 2020 (15:42:11)  
  [xvol3d_convertscores]: new function for xvol3d...allows to 3d colorize user-specific regions by scores/values (percentages/statist scores)   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  24 Aug 2020 (12:08:22)  
  getanatomicallabels [sub_atlaslabel2xls.m]: fixed bug.. writing excel table (mac) because newer cell2table-version  
  variable names must match with Matlab variable style. This happens when animal names (such as "20130422_TF_001_m1_s3_e6_p1")  
  start with a numeric value instead of a character). SOLUTION: In such cases animals the animals in the excel table   
  will be renamed (adding a prefix 's' such as "s20130422_TF_001_m1_s3_e6_p1").  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  24 Aug 2020 (09:27:02)  
  tutorial: "tutorial_orientation_and_manucoreg.doc" added to ..\antx2\mritools\ant\docs  
  This tutorial deals with image orientation for to template registration and manual coregistration.  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  17 Aug 2020 (16:49:32)  
  [paramgui] new version, (multi-icon style, execution-history)  
  ..the old version is still available (via menu/preferences)  
    
  [installfromgithub] BUG-solved:  after 'rebuilding'...gui could not close and workdir did not go prev. study path  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  14 Aug 2020 (12:57:03)  
  [getReferencePath] modified (layout with listbox, instead of buttons); recursive search for 'AVGT.nii' in (sub)/folder of ant-templates  
   --> to overcome the (sub)/folder nestings in the ant-templates folder  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  10 Aug 2020 (11:34:58)  
  [doelastix] (deform volumes elastix) parallelized for 4D-data  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  07 Aug 2020 (17:36:56)  
  [doelastix] (deform volumes elastix) now possible, apply registration-trafo to 4D-data (example: BOLD-timeseries) (..not parallelized yet)  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  07 Aug 2020 (14:43:11)  
  [xheadman.m] explicit output filename, added tooltips  
  [skullstrip_pcnn3d]: added errorMSG  if vox-size is to large  
  [displaykey2.m]: bugfix with zooming  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  05 Aug 2020 (22:10:09)  
  solved issue: unintended interaction between help window (mouse-over main menu) and ant-history window   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  04 Aug 2020 (16:38:17)  
  [installfromgithub] small changes  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  03 Aug 2020 (12:50:16)  
  debug Matlab19b error [xbruker2nifti].. in preadfile2: error occured due to uncommented code   
  after 'return' command (varargin issue)  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  08 Jul 2020 (13:37:00)  
  [dtistat]: revised; for DTI-connectivities allows input data from MRtrix; new command line access;  
  new COIfile;    
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  30 Jun 2020 (23:15:45)  
  [xvol3d.m] -updated, tested Linux/MAX/WIN, added more options  and label properties  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  23 Jun 2020 (17:13:43)  
  3D-volume visualization added (main menu .. grahics/3D-volume): allows to 3D-visualize atlas regions,  
  nodes & links (connections/~strength) and statistical images/intensity images [xvol3d.m]  
  -main features can be accessed via command line  
  % [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  23 Jun 2020 (17:01:21)  
  [doelastix.m] update, backward transformation now possible with userdefined voxel or dim-size  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  29 May 2020 (14:45:41)  
  [xstatlabels] bugfixed   
  [uhelp] added finder panel   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  15 May 2020 (17:33:52)  
  [setup_elastixlinux.m] modified-->solved problem: stucked installation of MRICRON   
  % [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  14 May 2020 (14:14:07)  
  [elastix_checkinstallation] addeed (extras/troubleshoot)  .. fct to check installation of elastix-program  
  [uhelp.m] modified: selection color    
  [checkRegist] modified: changed image2clipboard function   
  [summary_export] added (available via context menu of "PR"-radio in ANT-main window)   
  .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  20 Mar 2020 (12:30:38)  
  [case-filematrix]: export selected files from selected folders  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  11 Mar 2020 (17:28:49)  
  [xsegmenttube]: segment several animals from the same image /tube  
  [xsplittubedata]: split data-sets based on tube-segementation  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  09 Mar 2020 (12:31:52)  
  etrucian-shrew modified templates --> not finalized jet  
  [approach_60] t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space  
  Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  19 Feb 2020 (15:15:55)  
  [xdraw.m]: manual drawing tool to create masks  ->>Tools/"draw mask"  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  17 Feb 2020 (12:32:00)  
  set-up pipeline for etruscian shrew  
  [xcoreg]: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and  
  without spm-registration, (set "task" to [100])  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  04 Feb 2020 (18:03:15)  
  rat-brain segmentation accelerated  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  31 Jan 2020 (14:07:48):   
  [xgetlabels4]: allowing readout from "other Space"  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  28 Jan 2020 (10:14:11)  
  [xexcel2atlas.m]: added information  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  27 Jan 2020 (09:43:48)  
  [xexcel2atlas.m]: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx  
  [sub_write2excel_nopc]: subfun: write excel file for mac/linux  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  07 Jan 2020 (15:40:52)  
  matlab19b fix: cfg_getfiles2: data from server  
  sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  11 Dec 2019 (14:41:37)  
  [xcoreg] fix filename bug; display missing files  
  [uhelp]: allows column-wise/selectionwise copying   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  22 Nov 2019 (11:37:49)  
  [maskgenerator] added alpha-transparency slider and display number-of-rows pull down  
  checked regions of new Allen2017Hikishima template  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  15 Nov 2019 (02:14:16)  
  [maskgenerator] added "find" region-panel  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  13 Nov 2019 (00:47:38)   
  [maskgenerator] added region-lection list and online link to compare selected regions  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  04 Nov 2019 (11:35:28)  
  set up GITHUB repository #bw https://github.com/ChariteExpMri/antx2/  
  -primary checks macOS, Linux MINT  
  - updated [uhelp]  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  29 Oct 2019 (23:28:16)  
    starting GITHUB REPO : https://github.com/pstkoch/antx2  
   modif. files [cfg_getfile2], [uhelp]  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  17 Oct 2019 (22:04:14)  
  [xregisterCT/CTgetbrain_approach2]: added parameter "bonebrainvolume" for more robust cluster-identifaction  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  16 Oct 2019 (03:42:04)  
   1) "create study templates"-step can be performed before running the normalization step  
     ..see Main/Create Study Templates  
   2) two new "get-orientation"-functions implemented. Functions can be used if the orientation of   
     the native image (t2.nii) is unknown. See animal listbox context menu   
     (2a) "examineOrientation"       #k [getorientation.m] #n using apriori rotations,..   
          best orientation selected via eyeballing  
     (2b) "getOrientationVia3points" #k [manuorient3points.m] #n using 3 manually tagged corresponding points in  
          source and reference image  
      --> 2b approach is easier and faster  for difficult rotations  
  function modifications: uhelp, plog  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  07 Aug 2019 (14:23:20)  
  initial rigid registration (xwarp3) modified for more robust registration  
  [checkRegist.m]:     GUI to check registration of several images  
  [getorientation.m]: GUI to examine the apriory orientation (how animal is positioned in scanner)  
   - run it without input arguments or use context menu from ANT animal listbox  
   - the respective ID/number of orientation can be used to define the "orientType" in the projectfile   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  22 May 2019 (12:19:03)  
   addded: [xcoregmanu.m] - manually coregister images   
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  08 May 2019 (01:34:19)  
   addedd icon panel [iconpannel4spm.m] for manual preregistration step to facilitate manual  
   registration step  
  [#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  07 May 2019 (14:16:48)  
  [#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)  new version "ANTx2"  
     - SPM-package: SPM12  
     - templates were outsourced and can be downloaded from:  
       https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM  
     - linux/mac/windows  
