## **ANTx2 Modifications**
 ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) last modification:   08 Feb 2022 (12:38:25)  
    
 &#8658; Respository: <a href= "https://github.com/ChariteExpMri/antx2">GitHub:github.com/ChariteExpMri/antx2</a>   
 &#8658; Templates  : <a href= "https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9">googleDrive:animal templates</a>   
    
    
------------------  
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 Feb 2022 (12:38:25)**</ins>  
  function  __[exportfiles]__: added as alternative to export/copy files from any data-hierarchie to  
  a destination folder (no ANT-project must be loaded for this function)  
  -function should also work for files of a studie's "dat"-folder  
  &#8618; access via ANT-menu: &#8658; Main/export files (from any folder)  
<!---->
  #T  <ins>**06 Feb 2022 (21:20:48)**</ins>  
  Updated the tutorial webside on Github-Pages. The Webside contains basic tutorials (PDF-files).  
  &#8618;  access via link : <u>"https://chariteexpmri.github.io/antxdoc"  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 Feb 2022 (21:18:33)**</ins>  
  function  __[getNiftiheader]__: obtain NIFTI-header information of one/several NIFTI-files  
  function  __[reslice_nii2]__: reslice image by applying the header's transformation matrix  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Jan 2022 (11:43:10)**</ins>  
   __[xstat]__:  voxelwise analysis was extended.  
    - post-hoc paramter modifications and summary report can executed from comandline  
    - write summary as powerpoint-files, write statistical table as excel-file,   
    - save statistically thresholded volume  (Nifti)  
    - button __[code posthoc]__ display the code snippet for creating a summary (PPT-,Excel-,NIfti-files)   
   __[xstatlabels]__: regionwise statistic was extended  
   - The excelsheet now also contains a sheet "singleData" with the group-specifc single data for each region.   
    The single data be further used for plots/visualization or other purposes  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Jan 2022 (12:03:50)**</ins>  
   __[xdeformpop]__: GUI was replaced by extended version (part of 'deform Volume Elastix'-operation)  
   __[xsatat]__: function was updated  
    - The Powerpoint-report of the voxelwise statistic was extended  
    - programmatically change viewing parameters / generate Powerpoint-report  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**12 Jan 2022 (17:12:52)**</ins>  
   __[xstatlabels.m]__: 'export' as excel-file now also contains the single animal data  
   __[xgetparameter.m]__: added parameter "integrated density"  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 Jan 2022 (13:37:22)**</ins>  
   __[xcreateMaps.m]__ solved bugs:  
  - selection of animals via left ANT-listbox before running this function enabled  
  - previous image-operation  "abs" ...sumation over images debugged. Note that this option produces the same  
    result as the "sum"-operation.  
  &#8618; access via ANT-menu: &#8658; SNIPS/Create MAPS  
    
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**03 Jan 2022 (14:08:14)**</ins>  
   __[xgetlabels4.m]__ A specifc fileName for resulting excel-file can be entered.  
    
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**20 Dec 2021 (14:42:46)**</ins>  
   __[xstatlabels.m]__ The group-column in the "group-assignment"-Excel-file can be numeric now  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 Dec 2021 (01:22:39)**</ins>  
   __[xvol3d.m]__ save image as (tif/jpg/png) via context-menu (disable rotation-mode  before access the context menu)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 Dec 2021 (17:03:18)**</ins>  
   __[cfm.m]__ --> case-file-matrix: visualize data (files x dirs), basic file-manipulation  
  &#8618; access via ANT-GUI: Two new icons next to study-history-icon: CFM of all animals from   
  the current study or CFM for selected animals (selected via left listbox)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Nov 2021 (23:58:44)**</ins>  
   __[xcreateMaps.m]__ create MAPS across animals (heatmaps/IncidenceMaps/MeanImage Maps etc)  
  xcreateMaps.m: (former version "xincidencemap.m")  
  choose a math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*}  
  &#8618; access via ANT-menu: &#8658; SNIPS/create Maps (incidenceMaps/MeanImage etc)  
    
   __[xrealign_elastix.m]__  --> replace NANs by Zeros in 4D-volume after realignment  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Nov 2021 (00:33:52)**</ins>  
   __[xstatlabels.m]__ added tail-option for hypothesis-testing   
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Nov 2021 (23:15:21)**</ins>  
    __[xgetparameter.m ]__ obtain mask-based parameter from images (multimasks & masks can be mulinary)  
  mask-based paramters are:  'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'      
  MASK: you can use several masks/images, each with several sub-masks/(IDs), IDS across masks  
  can be similar   
  The output is one EXCELFILE containing sheets for each paramter. Each column contains the data of   
  one of the selected animals. The output (excelfile) can be analyzed using MENU/STATISTIC/"label based statistic"  
  .. CURRENTLY ONY PROVIDED FOR IMAGES/MASKS IN STANDARD-SPACE  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**01 Nov 2021 (17:29:22)**</ins>  
    __[DTIprep]__ minor changes ..added some solutions to avoid some MRtrix-BUGs:  
  --> see help of DTIprep.m  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 Sep 2021 (17:11:33)**</ins>  
  Created a web-side with tutorials   
  Depending on the time, further tutorials will be uploaded soon  
  &#8618;  access via link : <u>"https://chariteexpmri.github.io/antxdoc"  
    
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Sep 2021 (13:33:22)**</ins>  
  small changes in   
    __[uhelp]__ added: hyperlink selection via context menu   
    __[cfg_getfile2]__ added: 4D-Nifti filter  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**21 Sep 2021 (22:50:00)**</ins>  
   __[DTIprep.m]__: updated  
  &#9745; DTIprep for "multi-shell" (multi b-value diffusion acquisitions) analysis: finished  
  -wrote some info/help to work with DTIprep.     
  -added context menu (check b-table/DWI-files; delete files etc.)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**21 Sep 2021 (01:01:34)**</ins>  
   __[DTIprep.m]__: prepare data for DTI-processing via Mrtrix. Ideally DTI-processing could start  
  after conventional registration of the "t2.nii" image to the normal space und running   
  this DTIprep-step (a suitable DTI-atlas must be provided).  
  shellscripts must be downloaded from https://github.com/ChariteExpMri/rodentDtiConnectomics  
  and saved in the "shellscripts" folder (same level as the dat-folder)  
   __current status__  
   &#9745; DTIprep for "single-shell" (single b-value diffusion acquisitions) analysis: finished + tested  
   &#9832; DTIprep for "multi-shell" analysis: has to be adjusted & tested!   
  &#8618; access via ANT-menu: &#8658; Statistic/DTIprep for mrtrix.  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**15 Sep 2021 (17:30:22)**</ins>  
   __[anthistory.m]__: load a project from history, i.a. from a list of previous ANTx calls/studies  
  &#8618; access via ANT main GUI: &#8658; __[green book]__-button. Hit button to open the history.  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Sep 2021 (15:05:32)**</ins>  
   __[setanimalstatus.m]__: set a processing status tag for selected animal(s)  
  The status tag appears in the left listbox (animals) and tooltip when hovering over the animal.  
  &#8618; access via animal-listbox &#8658; context-menu/set status  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 Sep 2021 (10:42:24)**</ins>  
   __[sub_sting.m]__ creates node-related needles with numeric annotations (labels) onto 3D-brain (for DTI-data)  
  -annotations are view-dependent and will be adjusted accordingly   
  -labels appear at positions along a circle circumventing the brain  
  -labels can be manually repositioned  
  -function is part of xvol3d.m/sub_plotconnections to display DTI-connection onto a 3D brain  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Aug 2021 (14:12:17)**</ins>  
   __[xcalcSNRimage.m]__ convert image to SNR-image   
  according to Gudbjartsson H, Patz S. 1995: The Rician distribution of noisy MRI data. Magn Reson Med.; 34(6): 910–914.)  
  -can be used for Fluorine-19 (19F)-contrast images   
  &#8618;  access via ANT-menu: SNIPS/convert image to SNR-image  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Aug 2021 (23:50:18)**</ins>  
   __[xrename.m]__: now allows to threshold an image  
  &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Aug 2021 (21:02:37)** </ins>  
   __[xstat.m]__: added pulldown to select the statistical method to treat the multiple comparison problem  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**18 Aug 2021 (12:24:04)**</ins>  
   __[xrename.m]__: added context menu for easier file manipulation (copying/renaming/expansion/deletion)  
  and additional file information (file paths; existence of files; header information)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Aug 2021 (13:35:35)**</ins>  
  test: gitHub with "personal access token" : upload-seems to work/chk(TunnelBlick)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Aug 2021 (11:18:29)**</ins>  
   __[case-filematrix]__ add file functionality: copy/delete/export files ; file information    
  &#8618;  access via ANT-menu: Graphics/show case-file-matrix  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**12 Aug 2021 (18:49:17)**</ins>  
   __[xcheckreghtml.m]__ ... fixed BUG: "dimension"-parameter error with string/double vartype   
  __[checkpath]__ checks whether paths-names of ANTx-TBX, a study-project/template and data-sets contain special characters   
  Special characters might result in errors & crashes.  
  &#8618; access via ANT-menu: Extras/troubleshoot/check path-names  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Jun 2021 (15:36:53)**</ins>  
   __[show4d.m]__: SHOW 4D-VOLUME / check quality of realignment of 4D-volume  
  function allows to display a 4D-volume and it's realigned version side-by-side  
  For quality assessment, the 1st volume is displayed on top (as contour plot) of the selected (3D)-volume   
  &#8618; access via ANT-menu: Graphics/check 4D-volume (realignment)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**25 Jun 2021 (12:05:36)**</ins>  
   __[xrealign_elastix.m]__: multimodal realignment of 4D data (timeseries) using ELASTX and mutual information  
  &#8618; access via ANT-menu: Tools/realign images (ELASTIX, multimodal)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 May 2021 (01:20:40)**</ins>  
   __[xrealign.m]__  --> realign 3D-(time)-series or 4D volume using SPM-realign function  
  &#8618; access via ANT-menu: Tools/realign images (SPM, monomodal)  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**10 May 2021 (20:39:32)**</ins>  
   __[xcheckreghtml.m]__ implemented. This function create HTML-files with overlays of arbitrary images.   
   The HTML-files can be used to check the registration, can be zipped and send to others.  
  &#8618; access via ANT-menu: Graphics/generate HTML-file  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 May 2021 (22:15:55)**</ins>  
  -->started __[checkreghtml]__: make html-page of overlay of arbitrary pairs of images for selected animals   
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
     functions: __[dtistat.m]__, __[xvol3d.m]__ and __[sub_plotconnections.m]__  
   - get anatomical labels __[xgetlabels4.m]__: The paramter volume percent brain ("volpercbrain") was  
     re-introduced in the resulting Excel-table  
    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Nov 2020 (14:08:48)**</ins>  
  - NEW TUTORIAL  ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  __['tutorial_prepareforFSL.doc']__  
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
  -  NEW TUTORIAL  ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  __['tutor_multitube_manualSegment.doc']__  
     PROBLEM: Several animals located in one image (I call this "multitube")  
         This tutorial explains the following steps:  
                1. Manual segment images --> draw masks  
                2. Split datasets using the multitube masks  
              &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Nov 2020 (15:32:33)**</ins>  
  - __[xrename]__: extended functionality: now allows basic math operations of images such as  
    ROI extraction, image thresholding, combine images (mask an image by another image)  
  - other options of __[xrename]__: scale image, change voxel resolution (see help of xrename)  
        &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**18 Nov 2020 (13:30:53)**</ins>  
  - __[xdownloadtemplate.m]__ added: check internet connection status  
  - new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  __['tutorial_brukerImport.doc']__    
    This tutorial deals with conversion of Bruker data to NIFTI files.  
      &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Nov 2020 (01:37:17)** </ins>  
  __[atlasviewer.m]__ added. This function allows to display an atlas (NIFTI file) for example the  
  'ANO.nii' -file   
       &#8618;   access: ANT-MENU: Graphics/Atlas viewer  
    -TODO: test MAC & LINUX   : DONE!  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**30 Oct 2020 (14:50:30)**</ins>  
  __[SIGMA RAT template]__ (Barrière et al., 2019) added to gdrive  
    - Paper           : https://rdcu.be/b9tKX  or https://doi.org/10.1038/s41467-019-13575-7  
    - &#8618;  access via link : https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
      or ANT menu: EXTRAS/download templates  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**25 Oct 2020 (21:33:14)**</ins>  
   __[xdraw]__ drawing mask tool: refurbished, containing tools:   
    - advanced saving options,   
    - contour line segmentation  
    - ROI manipulation (translate/rotate/flip/copy/replace)  
    - TODO: test MAC & LINUX :  DONE!  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Oct 2020 (17:53:20)**</ins>  
  - __[xdraw]__ drawing mask tool: added contours and contour-based segmentation, completed help  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Oct 2020 (02:03:47)**</ins>  
  - __[xdraw]__ drawing mask tool now includes a 3D-otsu segmentation   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Oct 2020 (10:46:14)**</ins>  
  - EXVIVO APPROACH: coregistration approach for splitted multi-tube skullstripped (exvivo) animals.   
  The problem is the high intensity of the preserving substance enclosing the animal's brain.   
  This resulted in a defective brain mask with subsequent suboptimal rigid registration.   
  Solution: In the settings menu (gearwheel icon) set __[usePriorskullstrip]__ to __[4]__ and set the parameter  
  file for rigid transformation __[orientelxParamfile]__ to "..mypath\..\trafoeuler5_MutualInfo.txt"  
  This has two effects: First, background intensity is removed and a peudo-mask of 't2.nii' ("_msk.nii")  
  is created. Second, mutual information is used as metric for rigid transformation.  
    
  - PARAMTER SETTING __[antconfig]__ (gear wheel icon) has finally obtained a help window.  
     &#8618;  Access: When creating a new project (Menu: Main/new project) or selecting the __[gear wheel icon]__    
     obtain the help window via bulb-icon (lower left corner of the paramter file)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Oct 2020 (12:56:31)**</ins>  
  -__[xdraw]__ : debug, added measuring tool (distance in mm/pixel and angle)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**06 Oct 2020 (03:45:46)**</ins>  
  __[xdraw]__ draw a (multi-) mask manually , improved version, allows otsu-segmentation, new image drawing  
  tools, calculate volume for each mask-region, save as mask or save masked background image  
     &#8618; access via ANT-menu: Tools/draw mask  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Sep 2020 (13:30:09)**</ins>  
  new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  __['tutorial_convertDICOMs.doc']__    
  This tutorial deals with the conversion of dicom to NIFTI files.  
     &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Sep 2020 (00:14:08)**</ins>  
  __[xdicom2nifti]__: revised (now allows conversion using MRICRON or SPM)...Mac/Linux/WIN  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**21 Sep 2020 (12:46:16)**</ins>  
  __[xsegmenttubeManu]__ added. This function allows to manually segment a Nifti-image containing several  
  animals ("multi-tube" image). This function works as manual pendant to __[xsegmenttube]__.  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Sep 2020 (13:45:38)**</ins>  
  __[xgetlabels4]__ BUG solved: "zeros" in resulting excelFile  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Sep 2020 (13:14:15)**</ins>  
  __[xdownloadtemplate]__ DOWNLOAD TEMPLATES VIA GUI ..modified using curl (MAC/Linux) and wget.exe (windows)  
  - Function was tested with and without proxies using Win, MAC & Linux  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Sep 2020 (03:41:16)**</ins>  
  __[xdownloadtemplate]__ DOWNLOAD TEMPLATES VIA GUI (faster alternative compared to webside).  
     &#8618;  Access via Extras/donwload templates  --> unresolved/untested: proxy settings   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**01 Sep 2020 (12:49:32)**</ins>  
  manual coregistration __[displaykey3inv.m]__: update help   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Aug 2020 (10:43:27)**</ins>  
  - __[uhelp]__ bug-fix: help-fig failed to update fontsize and fig-position after reopening    
  - updates/changes (__[antver.m]__) can be inspected from the GITHUB webside.      
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Aug 2020 (15:42:11)**</ins>  
  __[xvol3d_convertscores]__: new function for xvol3d...allows to 3d colorize user-specific regions by scores/values (percentages/statist scores)   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Aug 2020 (12:08:22)**</ins>  
  - getanatomicallabels __[sub_atlaslabel2xls.m]__: fixed bug.. writing excel table (mac) because newer cell2table-version  
  variable names must match with Matlab variable style. This happens when animal names (such as "20130422_TF_001_m1_s3_e6_p1")  
  start with a numeric value instead of a character). SOLUTION: In such cases animals the animals in the excel table   
  will be renamed (adding a prefix 's' such as "s20130422_TF_001_m1_s3_e6_p1").  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**24 Aug 2020 (09:27:02)**</ins>  
  new tutorial ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  __["tutorial_orientation_and_manucoreg.doc"]__   
  This tutorial deals with image orientation for template registration and manual coregistration.  
    &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Aug 2020 (16:49:32)**</ins>  
  __[paramgui]__ new version, (multi-icon style, execution-history)  
  ..the old version is still available (via menu/preferences)  
    
  __[installfromgithub]__ BUG-solved:  after 'rebuilding'...gui could not close and workdir did not go prev. study path  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 Aug 2020 (12:57:03)**</ins>  
  __[getReferencePath]__ modified (layout with listbox, instead of buttons); recursive search for 'AVGT.nii' in (sub)/folder of ant-templates  
   --> to overcome the (sub)/folder nestings in the ant-templates folder  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**10 Aug 2020 (11:34:58)**</ins>  
  __[doelastix]__ (deform volumes elastix) parallelized for 4D-data  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2020 (17:36:56)**</ins>  
  __[doelastix]__ (deform volumes elastix) now possible, apply registration-trafo to 4D-data (example: BOLD-timeseries) (..not parallelized yet)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2020 (14:43:11)**</ins>  
  __[xheadman.m]__ explicit output filename, added tooltips  
  __[skullstrip_pcnn3d]__: added errorMSG  if vox-size is to large  
  __[displaykey2.m]__: bugfix with zooming  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**05 Aug 2020 (22:10:09)**</ins>  
  solved issue: unintended interaction between help window (mouse-over main menu) and ant-history window   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Aug 2020 (16:38:17)**</ins>  
  __[installfromgithub]__ small changes  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**03 Aug 2020 (12:50:16)**</ins>  
  debug Matlab19b error __[xbruker2nifti]__.. in preadfile2: error occured due to uncommented code   
  after 'return' command (varargin issue)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 Jul 2020 (13:37:00)**</ins>  
  __[dtistat]__: revised; for DTI-connectivities allows input data from MRtrix; new command line access;  
  new COIfile;    
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**30 Jun 2020 (23:15:45)**</ins>  
  __[xvol3d.m]__ -updated, tested Linux/MAX/WIN, added more options  and label properties  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Jun 2020 (17:13:43)**</ins>  
  3D-volume visualization added (main menu .. grahics/3D-volume): allows to 3D-visualize atlas regions,  
  nodes & links (connections/~strength) and statistical images/intensity images __[xvol3d.m]__  
  -main features can be accessed via command line  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**23 Jun 2020 (17:01:21)**</ins>  
  __[doelastix.m]__ update, backward transformation now possible with userdefined voxel or dim-size  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 May 2020 (14:45:41)**</ins>  
  __[xstatlabels]__ bugfixed   
  __[uhelp]__ added finder panel   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**15 May 2020 (17:33:52)**</ins>  
  __[setup_elastixlinux.m]__ modified-->solved problem: stucked installation of MRICRON   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**14 May 2020 (14:14:07)**</ins>  
  __[elastix_checkinstallation]__ addeed (extras/troubleshoot)  .. fct to check installation of elastix-program  
  __[uhelp.m]__ modified: selection color    
  __[checkRegist]__ modified: changed image2clipboard function   
  __[summary_export]__ added (available via context menu of "PR"-radio in ANT-main window)   
  .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**20 Mar 2020 (12:30:38)**</ins>  
  __[case-filematrix]__: export selected files from selected folders  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**11 Mar 2020 (17:28:49)**</ins>  
  __[xsegmenttube]__: segment several animals from the same image /tube  
  __[xsplittubedata]__: split data-sets based on tube-segementation  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**09 Mar 2020 (12:31:52)**</ins>  
  etrucian-shrew modified templates --> not finalized jet  
  __[approach_60]__ t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space  
  Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**19 Feb 2020 (15:15:55)**</ins>  
  __[xdraw.m]__: manual drawing tool to create masks  ->>Tools/"draw mask"  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Feb 2020 (12:32:00)**</ins>  
  set-up pipeline for etruscian shrew  
  __[xcoreg]__: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and  
  without spm-registration, (set "task" to __[100]__)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Feb 2020 (18:03:15)**</ins>  
  rat-brain segmentation accelerated  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**31 Jan 2020 (14:07:48)**: </ins>  
  __[xgetlabels4]__: allowing readout from "other Space"  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**28 Jan 2020 (10:14:11)**</ins>  
  __[xexcel2atlas.m]__: added information  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**27 Jan 2020 (09:43:48)**</ins>  
  __[xexcel2atlas.m]__: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx  
  __[sub_write2excel_nopc]__: subfun: write excel file for mac/linux  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Jan 2020 (15:40:52)**</ins>  
  matlab19b fix: cfg_getfiles2: data from server  
  sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**11 Dec 2019 (14:41:37)**</ins>  
  __[xcoreg]__ fix filename bug; display missing files  
  __[uhelp]__: allows column-wise/selectionwise copying   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 Nov 2019 (11:37:49)**</ins>  
  __[maskgenerator]__ added alpha-transparency slider and display number-of-rows pull down  
  checked regions of new Allen2017Hikishima template  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**15 Nov 2019 (02:14:16)**</ins>  
  __[maskgenerator]__ added "find" region-panel  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**13 Nov 2019 (00:47:38)**</ins>  
  __[maskgenerator]__ added region-lection list and online link to compare selected regions  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**04 Nov 2019 (11:35:28)**</ins>  
  set up GITHUB repository ![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+)  https://github.com/ChariteExpMri/antx2/  
  -primary checks macOS, Linux MINT  
  -updated __[uhelp]__  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**29 Oct 2019 (23:28:16)**</ins>  
   modif. files __[cfg_getfile2]__, __[uhelp]__  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**17 Oct 2019 (22:04:14)**</ins>  
  __[xregisterCT/CTgetbrain_approach2]__: added parameter "bonebrainvolume" for more robust cluster-identifaction  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**16 Oct 2019 (03:42:04)**</ins>  
   1)"create study templates"-step can be performed before running the normalization step  
     ..see Main/Create Study Templates  
   2)two new "get-orientation"-functions implemented. Functions can be used if the orientation of   
     the native image (t2.nii) is unknown. See animal listbox context menu   
     (2a) "examineOrientation"        __[getorientation.m]__ using apriori rotations,..   
          best orientation selected via eyeballing  
     (2b) "getOrientationVia3points"  __[manuorient3points.m]__ using 3 manually tagged corresponding points in  
          source and reference image  
      --> 2b approach is easier and faster  for difficult rotations  
  function modifications: uhelp, plog  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 Aug 2019 (14:23:20)**</ins>  
  initial rigid registration (xwarp3) modified for more robust registration  
  __[checkRegist.m]__:     GUI to check registration of several images  
  __[getorientation.m]__: GUI to examine the apriory orientation (how animal is positioned in scanner)  
   - run it without input arguments or use context menu from ANT animal listbox  
   - the respective ID/number of orientation can be used to define the "orientType" in the projectfile   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**22 May 2019 (12:19:03)**</ins>  
   addded: __[xcoregmanu.m]__ - manually coregister images   
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**08 May 2019 (01:34:19)**</ins>  
   addedd icon panel __[iconpannel4spm.m]__ for manual preregistration step to facilitate manual  
   registration step  
<!---->
  ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+)   <ins>**07 May 2019 (14:16:48)**</ins>  
  ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)  new version "ANTx2"  
     - SPM-package: SPM12  
     - templates were outsourced and can be downloaded from:  
       https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
     - linux/mac/windows  
<!---->
