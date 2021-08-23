## **ANTx2 Modifications**
 ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) last modification:   23 Aug 2021 (14:12:17)  
    
------------------  
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Aug 2021 (14:12:17)**</ins>  
  **[xcalcSNRimage.m]**:convert image to SNR-image   
  according to Gudbjartsson H, Patz S. 1995: The Rician distribution of noisy MRI data. Magn Reson Med.; 34(6): 910–914.)  
  - can be used for Fluorine-19 (19F)-contrast images   
  &#8618;  access via ANT-menu: SNIPS/convert image to SNR-image  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Aug 2021 (23:50:18)**</ins>  
  **[xrename]** now allows to threshold an image  
  &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Aug 2021 (21:02:37)** </ins>  
  **[xstat]** added pulldown to select the statistical method to treat the multiple comparison problem  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**18 Aug 2021 (12:24:04)**</ins>  
   **[xrename]** : added context menu for easier file manipulation (copying/renaming/expansion/deletion)  
  and additional file information (file paths; existence of files; header information)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Aug 2021 (13:35:35)**</ins>  
  test: gitHub with "personal access token" : upload-seems to work/chk(TunnelBlick)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Aug 2021 (11:18:29)**</ins>  
  **[case-filematrix]** add file functionality: copy/delete/export files ; file information    
   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**12 Aug 2021 (18:49:17)**</ins>  
  **[xcheckreghtml.m]** ... fixed BUG: "dimension"-parameter error with string/double vartype   
  **[checkpath]** checks whether paths-names of ANTx-TBX, a study-project/template and data-sets contain special characters   
  Special characters might result in errors & crashes.  
  &#8618; access via ANT-menu: Extras/troubleshoot/check path-names  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Jun 2021 (15:36:53)**</ins>  
  **[show4d]**: SHOW 4D-VOLUME / check quality of realignment of 4D-volume  
  function allows to display a 4D-volume and it's realigned version side-by-side  
  For quality assessment, the 1st volume is displayed on top (as contour plot) of the selected (3D)-volume   
  &#8618; access via ANT-menu: Graphics/check 4D-volume (realignment)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**25 Jun 2021 (12:05:36)**</ins>  
  **[xrealign_elastix]**: multimodal realignment of 4D data (timeseries) using ELASTX and mutual information  
  &#8618; access via ANT-menu: Tools/realign images (ELASTIX, multimodal)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 May 2021 (01:20:40)**</ins>  
  **[xrealign.m]**  --> realign 3D-(time)-series or 4D volume using SPM-realign function  
  &#8618; access via ANT-menu: Tools/realign images (SPM, monomodal)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**10 May 2021 (20:39:32)**</ins>  
  **[xcheckreghtml]** implemented. This function create HTML-files with overlays of arbitrary images.   
   The HTML-files can be used to check the registration, can be zipped and send to others.  
  &#8618; access via ANT-menu: Graphics/generate HTML-file  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 May 2021 (22:15:55)**</ins>  
  -->started **[checkreghtml]**: make html-page of overlay of arbitrary pairs of images for selected animals   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 May 2021 (10:29:16)**</ins>  
  fixed BUG in "rsavenii.m" (issue only for writing 4D-data only)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Apr 2021 (21:52:21)**</ins>  
  - CAT-atlas (Stolzberg et al., 2017) added to google-drive  
    &#8618;  access via link : https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
    paper: https://onlinelibrary.wiley.com/doi/abs/10.1002/cne.24271  
    
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Feb 2021 (15:46:57)**</ins>  
   - DTI-statistic and 2d-matrix/3d-volume visualization was extended   
     functions: **[dtistat.m]**, **[xvol3d.m]** and **[sub_plotconnections.m]**  
   - get anatomical labels **[xgetlabels4.m]**: The paramter volume percent brain ("volpercbrain") was  
     re-introduced in the resulting Excel-table  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Nov 2020 (14:08:48)**</ins>  
  - NEW TUTORIAL  ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  **['tutorial_prepareforFSL.doc']**  
    PROBLEM: How to use the backtransformed template brain mask for resting-state  
    data processed via FSL. IMPORTANT..this tutorial is not finished!  
      This tutorial explains the following steps  
                1. Set ANT path, make study folder +start ANT GUI  
                2. Download template  
                3. Define a project  
                4. Import Bruker data  
                5. Import templates for this study  
                6. Create a ‘t2.nii’ image  
                7. Examine Orientation  
                8. Register ‘t2.nii’ to the template  
                9. Back-transform template brain mask to native space  
              10. Extract 1st image of the 4D BOLD series  
              11. Coregister ‘t2.nii’ onto BOLD (RS-) Data  
              12. Mask first EPI-image with brain mask  
              13. Scale up 4D data for FSL  
             &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  -  NEW TUTORIAL  ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  **['tutor_multitube_manualSegment.doc']**  
     PROBLEM: Several animals located in one image (I call this "multitube")  
         This tutorial explains the following steps:  
                1. Manual segment images --> draw masks  
                2. Split datasets using the multitube masks  
              &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Nov 2020 (15:32:33)**</ins>  
  - **[xrename]**: extended functionality: now allows basic math operations of images such as  
    ROI extraction, image thresholding, combine images (mask an image by another image)  
  - other options of **[xrename]**: scale image, change voxel resolution (see help of xrename)  
        &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**18 Nov 2020 (13:30:53)**</ins>  
  - **[xdownloadtemplate.m]** added: check internet connection status  
  - new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  **['tutorial_brukerImport.doc']**    
    This tutorial deals with conversion of Bruker data to NIFTI files.  
      &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Nov 2020 (01:37:17)** </ins>  
  **[atlasviewer.m]** added. This function allows to display an atlas (NIFTI file) for example the  
  'ANO.nii' -file   
       &#8618;   access: ANT-MENU: Graphics/Atlas viewer  
    -TODO: test MAC & LINUX   : DONE!  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**30 Oct 2020 (14:50:30)**</ins>  
  **[SIGMA RAT template]** (Barrière et al., 2019) added to gdrive  
    - Paper           : https://rdcu.be/b9tKX  or https://doi.org/10.1038/s41467-019-13575-7  
    - &#8618;  access via link : https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
      or ANT menu: EXTRAS/download templates  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**25 Oct 2020 (21:33:14)**</ins>  
   **[xdraw]** drawing mask tool: refurbished, containing tools:   
    - advanced saving options,   
    - contour line segmentation  
    - ROI manipulation (translate/rotate/flip/copy/replace)  
    - TODO: test MAC & LINUX :  DONE!  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Oct 2020 (17:53:20)**</ins>  
  - **[xdraw]** drawing mask tool: added contours and contour-based segmentation, completed help  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Oct 2020 (02:03:47)**</ins>  
  - **[xdraw]** drawing mask tool now includes a 3D-otsu segmentation   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Oct 2020 (10:46:14)**</ins>  
  - EXVIVO APPROACH: coregistration approach for splitted multi-tube skullstripped (exvivo) animals.   
  The problem is the high intensity of the preserving substance enclosing the animal's brain.   
  This resulted in a defective brain mask with subsequent suboptimal rigid registration.   
  Solution: In the settings menu (gearwheel icon) set **[usePriorskullstrip]** to **[4]** and set the parameter  
  file for rigid transformation **[orientelxParamfile]** to "..mypath\..\trafoeuler5_MutualInfo.txt"  
  This has two effects: First, background intensity is removed and a peudo-mask of 't2.nii' ("_msk.nii")  
  is created. Second, mutual information is used as metric for rigid transformation.  
    
  - PARAMTER SETTING **[antconfig]** (gear wheel icon) has finally obtained a help window.  
     &#8618;  Access: When creating a new project (Menu: Main/new project) or selecting the **[gear wheel icon]**    
     obtain the help window via bulb-icon (lower left corner of the paramter file)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Oct 2020 (12:56:31)**</ins>  
  -**[xdraw]** : debug, added measuring tool (distance in mm/pixel and angle)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 Oct 2020 (03:45:46)**</ins>  
  **[xdraw]** draw a (multi-) mask manually , improved version, allows otsu-segmentation, new image drawing  
  tools, calculate volume for each mask-region, save as mask or save masked background image  
     &#8618; access via ANT-menu: Tools/draw mask  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Sep 2020 (13:30:09)**</ins>  
  new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  **['tutorial_convertDICOMs.doc']**    
  This tutorial deals with the conversion of dicom to NIFTI files.  
     &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Sep 2020 (00:14:08)**</ins>  
  **[xdicom2nifti]**: revised (now allows conversion using MRICRON or SPM)...Mac/Linux/WIN  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**21 Sep 2020 (12:46:16)**</ins>  
  **[xsegmenttubeManu]** added. This function allows to manually segment a Nifti-image containing several  
  animals ("multi-tube" image). This function works as manual pendant to **[xsegmenttube]**.  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Sep 2020 (13:45:38)**</ins>  
  **[xgetlabels4]** BUG solved: "zeros" in resulting excelFile  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Sep 2020 (13:14:15)**</ins>  
  **[xdownloadtemplate]** DOWNLOAD TEMPLATES VIA GUI ..modified using curl (MAC/Linux) and wget.exe (windows)  
  - Function was tested with and without proxies using Win, MAC & Linux  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Sep 2020 (03:41:16)**</ins>  
  **[xdownloadtemplate]** DOWNLOAD TEMPLATES VIA GUI (faster alternative compared to webside).  
     &#8618;  Access via Extras/donwload templates  --> unresolved/untested: proxy settings   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**01 Sep 2020 (12:49:32)**</ins>  
  manual coregistration **[displaykey3inv.m]**: update help   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Aug 2020 (10:43:27)**</ins>  
  - **[uhelp]** bug-fix: help-fig failed to update fontsize and fig-position after reopening    
  - updates/changes (**[antver.m]**) can be inspected from the GITHUB webside.      
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Aug 2020 (15:42:11)**</ins>  
  **[xvol3d_convertscores]**: new function for xvol3d...allows to 3d colorize user-specific regions by scores/values (percentages/statist scores)   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Aug 2020 (12:08:22)**</ins>  
  - getanatomicallabels **[sub_atlaslabel2xls.m]**: fixed bug.. writing excel table (mac) because newer cell2table-version  
  variable names must match with Matlab variable style. This happens when animal names (such as "20130422_TF_001_m1_s3_e6_p1")  
  start with a numeric value instead of a character). SOLUTION: In such cases animals the animals in the excel table   
  will be renamed (adding a prefix 's' such as "s20130422_TF_001_m1_s3_e6_p1").  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Aug 2020 (09:27:02)**</ins>  
  new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  **["tutorial_orientation_and_manucoreg.doc"]**   
  This tutorial deals with image orientation for template registration and manual coregistration.  
    &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Aug 2020 (16:49:32)**</ins>  
  **[paramgui]** new version, (multi-icon style, execution-history)  
  ..the old version is still available (via menu/preferences)  
    
  **[installfromgithub]** BUG-solved:  after 'rebuilding'...gui could not close and workdir did not go prev. study path  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Aug 2020 (12:57:03)**</ins>  
  **[getReferencePath]** modified (layout with listbox, instead of buttons); recursive search for 'AVGT.nii' in (sub)/folder of ant-templates  
   --> to overcome the (sub)/folder nestings in the ant-templates folder  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**10 Aug 2020 (11:34:58)**</ins>  
  **[doelastix]** (deform volumes elastix) parallelized for 4D-data  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2020 (17:36:56)**</ins>  
  **[doelastix]** (deform volumes elastix) now possible, apply registration-trafo to 4D-data (example: BOLD-timeseries) (..not parallelized yet)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2020 (14:43:11)**</ins>  
  **[xheadman.m]** explicit output filename, added tooltips  
  **[skullstrip_pcnn3d]**: added errorMSG  if vox-size is to large  
  **[displaykey2.m]**: bugfix with zooming  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**05 Aug 2020 (22:10:09)**</ins>  
  solved issue: unintended interaction between help window (mouse-over main menu) and ant-history window   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Aug 2020 (16:38:17)**</ins>  
  **[installfromgithub]** small changes  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**03 Aug 2020 (12:50:16)**</ins>  
  debug Matlab19b error **[xbruker2nifti]**.. in preadfile2: error occured due to uncommented code   
  after 'return' command (varargin issue)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 Jul 2020 (13:37:00)**</ins>  
  **[dtistat]**: revised; for DTI-connectivities allows input data from MRtrix; new command line access;  
  new COIfile;    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**30 Jun 2020 (23:15:45)**</ins>  
  **[xvol3d.m]** -updated, tested Linux/MAX/WIN, added more options  and label properties  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Jun 2020 (17:13:43)**</ins>  
  3D-volume visualization added (main menu .. grahics/3D-volume): allows to 3D-visualize atlas regions,  
  nodes & links (connections/~strength) and statistical images/intensity images **[xvol3d.m]**  
  -main features can be accessed via command line  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Jun 2020 (17:01:21)**</ins>  
  **[doelastix.m]** update, backward transformation now possible with userdefined voxel or dim-size  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 May 2020 (14:45:41)**</ins>  
  **[xstatlabels]** bugfixed   
  **[uhelp]** added finder panel   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**15 May 2020 (17:33:52)**</ins>  
  **[setup_elastixlinux.m]** modified-->solved problem: stucked installation of MRICRON   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 May 2020 (14:14:07)**</ins>  
  **[elastix_checkinstallation]** addeed (extras/troubleshoot)  .. fct to check installation of elastix-program  
  **[uhelp.m]** modified: selection color    
  **[checkRegist]** modified: changed image2clipboard function   
  **[summary_export]** added (available via context menu of "PR"-radio in ANT-main window)   
  .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**20 Mar 2020 (12:30:38)**</ins>  
  **[case-filematrix]**: export selected files from selected folders  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**11 Mar 2020 (17:28:49)**</ins>  
  **[xsegmenttube]**: segment several animals from the same image /tube  
  **[xsplittubedata]**: split data-sets based on tube-segementation  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**09 Mar 2020 (12:31:52)**</ins>  
  etrucian-shrew modified templates --> not finalized jet  
  **[approach_60]** t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space  
  Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Feb 2020 (15:15:55)**</ins>  
  **[xdraw.m]**: manual drawing tool to create masks  ->>Tools/"draw mask"  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Feb 2020 (12:32:00)**</ins>  
  set-up pipeline for etruscian shrew  
  **[xcoreg]**: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and  
  without spm-registration, (set "task" to **[100]**)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Feb 2020 (18:03:15)**</ins>  
  rat-brain segmentation accelerated  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**31 Jan 2020 (14:07:48)**: </ins>  
  **[xgetlabels4]**: allowing readout from "other Space"  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Jan 2020 (10:14:11)**</ins>  
  **[xexcel2atlas.m]**: added information  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Jan 2020 (09:43:48)**</ins>  
  **[xexcel2atlas.m]**: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx  
  **[sub_write2excel_nopc]**: subfun: write excel file for mac/linux  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Jan 2020 (15:40:52)**</ins>  
  matlab19b fix: cfg_getfiles2: data from server  
  sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**11 Dec 2019 (14:41:37)**</ins>  
  **[xcoreg]** fix filename bug; display missing files  
  **[uhelp]**: allows column-wise/selectionwise copying   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Nov 2019 (11:37:49)**</ins>  
  **[maskgenerator]** added alpha-transparency slider and display number-of-rows pull down  
  checked regions of new Allen2017Hikishima template  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**15 Nov 2019 (02:14:16)**</ins>  
  **[maskgenerator]** added "find" region-panel  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Nov 2019 (00:47:38)**</ins>  
  **[maskgenerator]** added region-lection list and online link to compare selected regions  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Nov 2019 (11:35:28)**</ins>  
  set up GITHUB repository ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  https://github.com/ChariteExpMri/antx2/  
  -primary checks macOS, Linux MINT  
  -updated **[uhelp]**  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 Oct 2019 (23:28:16)**</ins>  
   modif. files **[cfg_getfile2]**, **[uhelp]**  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Oct 2019 (22:04:14)**</ins>  
  **[xregisterCT/CTgetbrain_approach2]**: added parameter "bonebrainvolume" for more robust cluster-identifaction  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Oct 2019 (03:42:04)**</ins>  
   1)"create study templates"-step can be performed before running the normalization step  
     ..see Main/Create Study Templates  
   2)two new "get-orientation"-functions implemented. Functions can be used if the orientation of   
     the native image (t2.nii) is unknown. See animal listbox context menu   
     (2a) "examineOrientation"       **[getorientation.m]**using apriori rotations,..   
          best orientation selected via eyeballing  
     (2b) "getOrientationVia3points" **[manuorient3points.m]**using 3 manually tagged corresponding points in  
          source and reference image  
      --> 2b approach is easier and faster  for difficult rotations  
  function modifications: uhelp, plog  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2019 (14:23:20)**</ins>  
  initial rigid registration (xwarp3) modified for more robust registration  
  **[checkRegist.m]**:     GUI to check registration of several images  
  **[getorientation.m]**: GUI to examine the apriory orientation (how animal is positioned in scanner)  
   - run it without input arguments or use context menu from ANT animal listbox  
   - the respective ID/number of orientation can be used to define the "orientType" in the projectfile   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 May 2019 (12:19:03)**</ins>  
   addded: **[xcoregmanu.m]** - manually coregister images   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 May 2019 (01:34:19)**</ins>  
   addedd icon panel **[iconpannel4spm.m]** for manual preregistration step to facilitate manual  
   registration step  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 May 2019 (14:16:48)**</ins>  
  ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  new version "ANTx2"  
     - SPM-package: SPM12  
     - templates were outsourced and can be downloaded from:  
       https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
     - linux/mac/windows  
<!---->
