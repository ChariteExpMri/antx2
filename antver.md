## **ANTx2 Modifications**
 &#x1F34E; last modification:   22 Mar 2024 (09:47:47)  
    
 &#8658; Respository: <a href= "https://github.com/ChariteExpMri/antx2">GitHub:github.com/ChariteExpMri/antx2</a>   
 &#8658; Tutorials: <a href= "https://chariteexpmri.github.io/antxdoc/">https://chariteexpmri.github.io/antxdoc/</a>   
 &#8658; Templates  : <a href= "https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9">googleDrive:animal templates</a>   
    
    
------------------  
  &#x1F535;   <ins>**22 Mar 2024 (09:47:47)**</ins>  
  new atlases/templates implemented  
  __[1]__ DSURQUE-atlas  ("mouse_DSURQUE_vox07mm.zip")  
      -atlas in DSURQUE-space   
      -0.07 mm isovox resolution  
  __[2]__ DSURQUE-atlas in ABA-space ("mouse_DSURQUE_ABAspace.zip")  
      -DSURQUE atlas warped to ABA-space. This allows to interchange 'DSURQE' and 'mouse_Allen2017HikishimaLR'  
       without a new registration  
      -0.07mm isovox resolution  
  &#8658; atlases available via: <a href= "https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9">googleDrive:animal templates</a>   
<!---->
  &#x1F535;   <ins>**06 Mar 2024 (15:48:32)**</ins>  
   __[xflipLR]__ new  
  flip left/right image in native or standard space  
  &#8618; access via ANT-menu: &#8658; TOOLS/flip left/right images  
   __[xop]__ new  
  image operation, identical to xrename.m (wrapper function of xrename)   
  &#8618; access via ANT-menu: &#8658; TOOLS/xop  
   __[xinsertslice_aligned]__ new  
  insert 2d-slices into 3D/4D-volume, preserve alignment with reference file  
  &#8618; access via ANT-menu: &#8658; 2D/insert slices back to 3D/4D volume  
    
<!---->
  &#x1F535;   <ins>**29 Feb 2024 (10:44:56)**</ins>  
   __[xextractslice_aligned]__ new  
  extract 2d-slice from 3D/4D-volume, preserve alignment with original file  
  &#8618; access via ANT-menu: &#8658; 2D/extract slice,preserve alignment  
    
<!---->
  &#x1F535;   <ins>**27 Feb 2024 (13:49:45)**</ins>  
   __[vol3dscript_ballnsticks2PPT]__ new script  
  generate ppt-file containing previously saved ballNstick plots (previously saved as 'v*tif')  
  &#8618; access via xvol3d (GUI): &#8658; scripts/show scripts  
    
<!---->
  &#x1F535;   <ins>**23 Feb 2024 (13:14:33)**</ins>  
   __[xcoreg2D_singleSlice_arbSlice]__ new  
  coregister 3D-images using 2D-registration of a single specified slice-slice assignment pair and  
  apply transformation parameters to all other slices and apply to other 3D-images.  
    
<!---->
  &#x1F535;   <ins>**20 Feb 2024 (11:42:08)**</ins>  
   __[ximportAnalyzemask2D.m]__ new  
  import 2D (single slice) Analyze ('*.obj')-file and convert to NIFTI  
  &#8618; access via ANT-menu: &#8658; Main/import 2D-ANALYZE (obj) files  
    
<!---->
  &#x1F535;   <ins>**13 Feb 2024 (17:56:15)**</ins>  
   __[ximportAnalyzemask]__ modified...better assignment of obj-files to animal-dirs  
    
    
<!---->
  &#x1F535;   <ins>**31 Jan 2024 (16:50:36)**</ins>  
   __[xoperateMaps]__ new  
   arithmetic operations (add,subtract,multiply,divide) two maps (heatmaps/incidenceMaps/etc)  
   example usage: subtract two incidence(lesion)-maps from each other  
  &#8618; access via ANT-menu: &#8658; snips/math operations on maps  
    
<!---->
  &#x1F535;   <ins>**26 Jan 2024 (15:41:27)**</ins>  
   __[xvol3d]__ modified, parameter-settings for displaying atlas-regions can be stored as script  
  and the same plot can be re-created  
  -a sccript "vol3dscript_loadMask_Atlas_Regions_SaveImages.m" can be used from the "scripts"-menu  
   of xvol3d-GUI. To store a parameter-settings after finalizing the plot use "probs"-menu/copy-properties-to clipboard  
    
<!---->
  &#x1F535;   <ins>**12 Jan 2024 (12:55:22)**</ins>  
   __[DTIprep.m]__ modified, check Number of b-values and number of DWI-volumes  
    
    
<!---->
  &#x1F535;   <ins>**20 Dec 2023 (14:00:20)**</ins>  
   __[xgetpreorientationHTML]__ new, obtain pre-orientation (the "pre-alignment task") via HTMLfile  
  -The output ia a HTML-file in the study's 'checks'-folder. The HTML-file contains different orientations of the source-image.  
  To obtain the pre-orientation from native-space to standard-space:  
  &#8618; access via ANTx animal-listbox context menu: &#8658; __[examine orientation via HTMLfile]__  
  For any other images with different orientations:  
  &#8618; access via ANT-menu: &#8658; Tools/"obtain pre-orientation (via HTMLfile)"  
    
<!---->
  &#x1F535;   <ins>**12 Dec 2023 (14:09:47)**</ins>  
   __[xrename.m]__ added option to run operation(mean/median/mode/sum/min/max/std/zscore/var) over 4th dim of NIFTI-file  
    
<!---->
  &#x1F535;   <ins>**11 Dec 2023 (12:26:44)**</ins>  
   __[ximportBrukerNifti.m]__ modified ...noGUI-mode enabled (see last example on HELP of DTIprep.m )  
    
<!---->
  &#x1F535;   <ins>**05 Dec 2023 (23:25:04)**</ins>  
   __[ximportBrukerNifti.m]__ new, import existing NIFTI-files from Brukerdata.  
  -available via ANTx menu Main/Import existing NIFTI-files from Bruker data  
    
<!---->
  &#x1F535;   <ins>**23 Nov 2023 (14:08:03)**</ins>  
   __[xgetpreorientAuto.m]__ new, get studies "t2.nii" pre-orientation automatically   
  -available via ANTx animal-listbox context menu, __[get orientation -automatic mode]__  
    
<!---->
  &#x1F535;   <ins>**13 Nov 2023 (01:09:12)**</ins>  
   __[xcoreg2D_singleSlice.m]__ new function: coregister 3D-images using 2D-registration of a specified slice   
  and apply transformation parameters to all other slices.   
  &#8618; access via ANT-menu: &#8658; 2D/"single slice 2D-registration"   
<!---->
  &#x1F535;   <ins>**09 Nov 2023 (12:42:50)**</ins>  
   __[renameDWIfiles.m]__ new, function to check and rename DWI-files across animals   
   case: different scan-numbers in DWI-filenames across animals  
  -available via DTIprep-GUI, __[check DWI-filename]__-button  
<!---->
  &#x1F535;   <ins>**20 Oct 2023 (10:17:42)**</ins>  
  script __[DTIscript_exportToHPC_makeBatch_07-09-2023.m]__ created  
  reason: conda-path changed on our HPC  
<!---->
  &#x1F535;   <ins>**21 Sep 2023 (22:43:56)**</ins>  
  antconfig/project-file modified,   
  optional mode for initial skull stripping via otsu method (x.wa.usePriorskullstrip =  __[5]__)   
    
   __[xgetlabels4.m]__ modified,   
  different output-formats (.xlsx, .mat, .csv) now available  
    
<!---->
  &#x1F535;   <ins>**15 Sep 2023 (13:10:51)**</ins>  
   __[dtiPREP.m]__ modified, new option: transfer GM,WM,CSF-mask to MRtrix-pipeline   
    
    
<!---->
  &#x1F535;   <ins>**07 Sep 2023 (12:27:25)**</ins>  
  new script "DTIscript_exportToHPC_makeBatch_07-09-2023.m" added. Script exports dti-data to HPC for preprocessing  
  script works with SLURM-JOB-ARRAY (parallelized) due to restricted proc-time (max 48h) on CHARITE-HPC  
    
<!---->
  &#x1F535;   <ins>**30 Aug 2023 (15:37:19)**</ins>  
  script: VWscript_DWIimages__oneWayANOVA.m added to scripts-collection (avaliable from xstat.m)  
<!---->
  &#x1F535;   <ins>**13 Jul 2023 (08:51:56)**</ins>  
  __[P28 developing mouse template]__ added to gdrive  
  this is a modified version of the Allen developing mouse atlas   
    - Paper : David M Young, Siavash Fazel Darbandi, Grace Schwartz, Zachary Bonzell, Deniz Yuruk, Mai Nojima, Laurent C Gole, John LR Rubenstein, Weimiao Yu, Stephan J Sanders (2021) Constructing and optimizing 3D atlases from 2D data with application to the developing mouse brain eLife 10:e61408  
              https://doi.org/10.7554/eLife.61408  
              https://elifesciences.org/articles/61408  
    - &#8618;  access via link : https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
    
<!---->
  &#x1F535;   <ins>**12 Jul 2023 (08:53:34)**</ins>  
   __[xmakepseudoatlas.m]__ new, create pseudo-color NIFTI-atlas based on existing NIFTI-ATLAS   
  rationale: atlases such as the Allen brain atlas use sparse IDs over a large dynamic range.   
  This is sometimes not optimal for displaying atlas  
  &#8618; access via ANT-menu: &#8658; atlas+masks/"create pseudo-color atlas"  
    
<!---->
  % &#x1F535;   <ins>**16 Jun 2023 (16:11:44)**</ins>  
   __[xdraw.m]__ refurbished  
  contour-line filling: borders can be added to contraint the filling  
  added simple drawing tool  
<!---->
  &#x1F535;   <ins>**13 Jun 2023 (12:04:18)**</ins>  
   __[paramgui.m]__ #n, added 2D-cell pulldown   
<!---->
  &#x1F535;   <ins>**12 Jun 2023 (18:53:05)**</ins>  
   __[xgunzip2nifti.m]__ new, convert gzip-files to NIFTI-files within animal folders  
  &#8618; access via ANT-menu: &#8658; Main/"convert gzip-files to NIFTI"  
   __[xobj2nifti.m]__ new, convert obj-files (Analyze) to NIFTI-files within animal folders  
  &#8618; access via ANT-menu: &#8658; Main/"convert obj-files to NIFTI"  
    reference image can be used to replace header  
   __[xmergemasks.m]__ new, merge multiple masks within animal folders  
  &#8618; access via ANT-menu: &#8658; atlas+masks/"merge masks"  
<!---->
  &#x1F535;   <ins>**01 Jun 2023 (11:38:22)**</ins>  
   __[xbruker2nifti.m]__ modified:   
  -logfile for Bruker converted files is created for each animal  
  -added example for Bruker conversion without GUI  
   __[xdraw.m]__ modified   
  lesions can be delineated: First, preselect the animal folders, than go to &#8618; ANT-menu: &#8658; masks/"draw mask"   
    
<!---->
  &#x1F535;   <ins>**22 May 2023 (09:49:20)**</ins>  
   __[xbruker2nifti.m]__ modified: option to add 'StudId' and 'SubjectName' as suffix to animal-directory name  
<!---->
  &#x1F535;   <ins>**20 Feb 2023 (23:22:40)**</ins>  
   new script: __[DTIscript_DTIstatisticComplete1.m]__   
  -run DTI-statistic,create matrix-plots and ball-n-stick-plots, save plots as PPT, save tables as Excelfiles  
  &#8618; access via MENU: Statistic/DTI-statistic (scripts-button)   or type "dtistat" and hit scripts-button  
<!---->
  &#x1F535;   <ins>**14 Feb 2023 (17:37:59)**</ins>  
   script: __[DTIscript_exportToHPC_makeBatch.m]__ revised again...  
    
<!---->
  % &#x1F535;   <ins>**13 Feb 2023 (12:30:06)** </ins>  
   __[DTIprep.m]__ modified ...scripts added to see status of processing /delete MRtrix-related files   
    
<!---->
  &#x1F535;   <ins>**07 Feb 2023 (22:25:52)**</ins>  
   __[DTIprep.m]__ modified:   
  B-tables are now accompanied by b-tables with fixed b-values ("grad*_fix.txt").   
  The b-tables with fixed b-values will be used for MRtrix preprocessing only (dwifslpreproc/FSL-Eddy).  
  Reason: Sometimes the large variation of b-values within the same shell leads to the FSL-Eddy error   
  "inconsistent b-values detected". To circumvent this issue, the preprocessing uses the b-tables with   
  fixed b-values. For further analysis steps the fixed b-values will be replaced by the original b-values.  
    
<!---->
  &#x1F535;   <ins>**20 Jan 2023 (10:18:21)**</ins>  
   script: __[DTIscript_exportToHPC_makeBatch.m]__ revised:  
    
<!---->
  &#x1F535;   <ins>**19 Jan 2023 (16:38:46)**</ins>  
   __[dti_changeMatrix.m]__ modified:  
  -DTI-weightmatrix can by changed via Excelfile containing the connections to keep   
  -also possible via command-line (see help of __[dti_changeMatrix.m]__)  
  &#8618; access via ANT-menu: &#8658; STATISTIC/"DTI-statistic" --> via __[change matrix]__-button  
    
<!---->
  &#x1F535;   <ins>**16 Jan 2023 (23:56:39)**</ins>  
   __[xrename.m]__ modified:  
  -added: Replace value in 3d/4D image by another value   
  -added: set voxe-size in image-header without changing the image  
  -added: option to add a prefix or suffix to the orignal filename for the output image  
  for examples see context menu/"enter 2nd and 3rd column extended"  
    
<!---->
  &#x1F535;   <ins>**16 Jan 2023 (15:30:39)**</ins>  
   __[paramgui.m]__ modified:  
  -added option to select a colormap from list of colormaps (colormaps appear color-coded in the pulldownmenu)  
  -this option was implemented in xcheckreghtml.m  
    
<!---->
  &#x1F535;   <ins>**10 Jan 2023 (01:48:56)**</ins>  
  minor checks  
    
<!---->
  % &#x1F535;   <ins>**06 Jan 2023 (16:46:35)**</ins>  
    __[xcheckreghtml.m]__ modified:  
   -allows to specify colormaps for foreground and background-image  
   -optional: a fused image of foreground and background-image is embedded in the HTMLfile  
  &#8618; access via ANT-animal-listbox: &#8658; context-menu: "check registration-make HTMLfile"  
  &#8618; access via ANT-menu: &#8658; GRAPHICS/"QA: generate HTML-file with overlays"  
    
<!---->
  &#x1F535;   <ins>**06 Jan 2023 (08:38:39)**</ins>  
   __[xdicom2nifti.m]__ modified: added option to use the DICOM-folderName as NIFTI-fileName  
<!---->
  &#x1F535;   <ins>**05 Jan 2023 (11:22:46)**</ins>  
   __[xstat.m]__ modified: added option to delete existng contrasts  
<!---->
  &#x1F535;   <ins>**03 Jan 2023 (23:21:17)**</ins>  
   __[xgroupassigfactorial.m]__ modified  
  make specific group-comparisons via textfile  
  modifed files:   
   __[paramgui.m]__ --> selection of multiple folders possible (via 'md')  
   __[xstat.m]__    --> append constrasts to multifactorial design via text-file ..see help of xaddContrasts.m  
   __[xaddContrasts.m]__ new file to append new contrasts to SPM-multifactorial design  
<!---->
  &#x1F535;   <ins>**16 Dec 2022 (14:09:43)**</ins>  
   __[VWscript_DWIimages_and_results.m]__ new script  
   script to make summary of voxelwise statistic FOR SEVERAL IMAGES  
  &#8618; access via ANT-menu: &#8658; STATISTIC/SPM-STATISTIC  .. via "scripts"-button  
  &#8618; or type "xstat" --> "scripts"-button  
    
<!---->
  &#x1F535;   <ins>**16 Dec 2022 (13:41:00)**</ins>  
   __[xgroupassigfactorial.m]__ new  
  assign new group-comparisons, create essential group-comparisons or manually via GUI  
  input: excelfile with animal-ids and columns specifying the group-assignment for  
  1/2/3-factorial design. The output are excel-files with new group-comparisons  
  &#8618; access via ANT-menu: &#8658; STATISTIC/NEW GROUP ASSIGNMENT   
    
<!---->
  &#x1F535;   <ins>**16 Dec 2022 (02:33:06)**</ins>  
   __[CTgetbrain_approach2.m]__ modified   
  CT-registration was checked using 6 datasets  
    
<!---->
  &#x1F535;   <ins>**13 Dec 2022 (13:04:03)**</ins>  
  minor bugs removed in  __[xstat.m]__    
    
<!---->
  &#x1F535;   <ins>**09 Dec 2022 (09:21:47)**</ins>  
   __[createGroupassignmentFile.m]__ modified  
  The function create a group-assignment file (usefull for voxelwise statistic).  
  with statistical models: 'unpaired', 'paired', 'regression', '1xANOVA', '1xANOVAwithin''fullfactorialANOVA'    
    
   __[xstat.m]__ modified and all models (with covaraiates) were simulated and checked  
  tutorial needs to be updated and extended for the other statistical models  
    
<!---->
  &#x1F535;   <ins>**01 Dec 2022 (13:53:56)**</ins>  
   __[CTgetbrain_approach2.m]__ modified  
  CT-segmentaton failed in some cases, ...hopefully solved now  
  function is part of __[xregisterCT.m]__ to rgister a CT-image to t2.nii  
    
<!---->
  &#x1F535;   <ins>**30 Nov 2022 (00:00:04)**</ins>  
   __[xexcel2atlas.m]__ modified  
  - a HTML-file is additionally created to verify the regions of the new atlas  
    
<!---->
  &#x1F535;   <ins>**15 Jun 2022 (00:42:12)** </ins>  
  New tutorial &#x1F4D7;  __["tutorial_voxwiseStatistic_independentTest.docx"]__  
  This tutorial shows how to perform Voxelwise statistic for two independent groups  
  &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages) https://chariteexpmri.github.io/antxdoc/  
    
<!---->
  &#x1F535;   <ins>**11 Nov 2022 (17:10:28)**</ins>  
   __[xstat.m]__ changed  
  added function to posthoc create/repair the MIP-file/change Atlas for reporting table  
  - see xstat-MENU: misc/create MIP,change Atlas  
  - or programmatically, type :  xstat('repairMIP?')  to obtain help  
    
<!---->
  &#x1F535;   <ins>**11 Nov 2022 (08:24:03)**</ins>  
   __[ximportdir2dir.m]__ function revised  
  - revised selection of directory-assignments   
    
<!---->
  &#x1F535;   <ins>**08 Nov 2022 (11:46:42)**</ins>  
   __[antcb.m]__ added option to select/obtain list of animals by status-message  
  example:  
  - select all animals with status-tag "charge2":  
    antcb('selectdirs','status','charge2');  
  - select all animals with status-tag "charge1" or "charge2":  
    antcb('selectdirs','status',{'charge1' 'charge2'});  
  --> for further help type: antcb('selectdirs?')  
    
<!---->
  &#x1F535;   <ins>**07 Nov 2022 (15:07:39)**</ins>  
   __[xstat.m]__ removed bug when writing the NIFTI-file (issue with special characters)  
    
    
<!---->
  &#x1F535;   <ins>**30 Oct 2022 (23:17:02)**</ins>  
   __[xexcel2atlas.m]__ modified  
  removes any other characters in the new-ID column, hemispheric type 4 (both hemisphere, splitted) is used when not specified  
    
<!---->
  &#x1F535;   <ins>**25 Oct 2022 (17:09:33)**</ins>  
   __[xvol3d.m]__ modified   
  If a plot is generated via __[xvol3d.m]__ the corresponding parameter settings can pasted to clipboard   
  &#8618; access via xvol3d-MENU: props/"copy properties to clipboard"  
  The property-list can be pasted into the editor, modified, saved and re-executed via xvol3d('loadprop',p); where p is the parameter-set  
   
    
<!---->
  &#x1F535;   <ins>**21 Oct 2022 (17:24:01)** </ins>  
   __[xwarp3.m]__ modified  
  image "t2.nii" stucked during coregistration to template-space due to potential NAN-values  
  NAN-values are now replaces by "0"-values in the initialization-step  
    
<!---->
  &#x1F535;   <ins>**21 Oct 2022 (17:03:10)**</ins>  
   __[xmakeRGBatlas.m]__ new  
  function to convert an NIFTI-ATLAS to 4D-RGB-NIFTI file. This RGB-Atlas can be displayed for instance   
  via "MRIcroGL" (https://www.nitrc.org/projects/mricrogl). Specifically for the Allen Brain atlas,   
  the RGB-Atlas will depict the brain regions in the orignal Allen Colors similar to http://atlas.brain-map.org/atlas#atlas=1   
<!---->
  &#x1F535;   <ins>**21 Oct 2022 (14:21:05)**</ins>  
  task: generate DTI-atlas. A specific DTI-atlas can be gernated (with fewer regions)  
  for this a modifed ANO-excelfile is saved and can be manually edited to include (include+merge) regions  
  which should occur in the new DTI-atlas. In a second step this modifed ANO-excelfile can be used to generate   
  a new DTI-atlas   
  &#8618; access via ANT-MENU: atlas/masks / generate DTI-atlas / __[1]__ save Atlas-file (excel-file) to manually include regions  
  &#8618; access via ANT-MENU: atlas/masks / generate DTI-atlas / __[2]__ generate DTI-atlas using the modified excel-file  
    
<!---->
  &#x1F535;   <ins>**11 Oct 2022 (14:01:29)**</ins>  
  __[xrename.m]__ modified  
  xrename now allows to modify the header of a NIFTI-file via 'ch:'-tag in the 3rd column  
  header-modifications: use header of another file, change data type, dimensional flips, add header descrition  
  see help of xrename  
    
    
<!---->
  &#x1F535;   <ins>**28 Sep 2022 (13:15:27)**</ins>  
   __[xQAregistration.m]__ new  
   calculate registration-based quality metric (standard-space comparison)  
  -this procedure evaluates the animal registration quality to standard space  
  -the __[gm]__-approach: the gray-matter compartement is warped to standard-space and compared with   
   the gray matter image of the template (metrics: correlation or mutual information)  
  -the resulting report is saved as HTML-file or excel-file  
  &#8618; access via ANT-menu: GRAPHICS/QA:obtain registration metric  
    
<!---->
  &#x1F535;   <ins>**27 Sep 2022 (13:51:29)**</ins>  
   __[anthistory.m]__ modified  
   a project can be found via "find"-button  
<!---->
  &#x1F535;   <ins>**02 Sep 2022 (08:55:09)**</ins>  
   __[xexcel2atlas.m]__ modified    
     -saveMasksSeparately: save output masks as separate NIFTIs  
<!---->
  &#x1F535;   <ins>**26 Jul 2022 (14:01:43)**</ins>  
   __[xrename.m]__ modified  
   -delete multiple files via wildcards via xrename   
   __[explorerpreselect.m]__ modified  
   -explorerpreselect('mean.m') --> open folder in file-explorer containing and highlighting the m-file ('mean.m')   
    
<!---->
  &#x1F535;   <ins>**15 Jun 2022 (00:42:12)**</ins>  
  New tutorial &#x1F4D7;  __["tutorial_prepareDTIpipeline.docx"]__  
  This tutorial shows how to prepare the data for the DTI-MRtrix-pipeline  
  &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages) https://chariteexpmri.github.io/antxdoc/  
    
<!---->
  &#x1F535;   <ins>**14 Jun 2022 (14:20:14)**</ins>  
   __[DTIprep.m]__ modified  
  -'c_t2.nii' is not necessary for DTI-MRtrix-pipeline anymore  
    
<!---->
  &#x1F535;   <ins>**13 Jun 2022 (20:39:32)**</ins>  
  New tutorial &#x1F4D7;  __["getOrientation_via_3pointSelection.pptx"]__  
  This tutorial shows how to determine the orientationType (for instance if method "examine orientation" failes)  
  &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages) https://chariteexpmri.github.io/antxdoc/  
   
<!---->
  &#x1F535;   <ins>**10 Jun 2022 (16:44:06)**</ins>  
   __[scripts_gui.m]__ modified  
  -switch between scripts-collections via context-menu of upper listbox  
    
<!---->
  &#x1F535;   <ins>**09 Jun 2022 (16:36:28)**</ins>  
   __[xnewgroupassignment.m]__ new function  
  -create new group assignments by merging/combining different groups  
  -the resulting excel-files (new group-assignment files) can be used as group-definition for:  
           __[DTIstat.m]__ --> statistic of DTI-connectome/metric  
           __[xstat.m]__   --> voxelwise statistic of images  
           __[xstatlabels.m]__ --> regionwise statistic of images  
    
<!---->
  &#x1F535;   <ins>**04 Jun 2022 (00:38:38)**</ins>  
   __[ant.m]__ was modified  
  - ANT-menu with optional tooltips for menu-items. Enable/disable tooltips via ANT-menu: INFO/"show menu items"  
  -local ant-setttings enabled, this file can be stored in Matlab's userpath and will override default parameter  
    
<!---->
  &#x1F535;   <ins>**02 Jun 2022 (16:51:58)**</ins>  
   __[ant.m]__ was modified  
  The menu of the ant-GUI is now sensitive to the pressed mouse-button:  
   - __[left mouseclick ]__ to execute the function  
   - __[right mouseclick]__ to display the underlying function in the CMD-Window with hyperlink to obtain the function's help  
   - __[cmd]__+__[left mouseclick ]__ to obtain the help of the function  
    
<!---->
  &#x1F535;   <ins>**01 Jun 2022 (14:39:14)**</ins>  
   __[DTIprep.m]__ -scripts prettified  
   
<!---->
  &#x1F535;   <ins>**31 May 2022 (21:32:35)**</ins>  
   __[scripts_gui.m]__ was modified  
  - __[scripts summary]__-button added  
  - scripts currently available for: __[xstat.m]__, __[DTIprep.m]__, __[dtistat.m]__  
  - there is also a general scripts-collection: &#8618; access via ANT-menu: Snips/scripts collection  
<!---->
  &#x1F535;   <ins>**30 May 2022 (14:44:32)**</ins>  
   __[DTIprep.m]__ - bug removed from CMDline-coregistration step  
  The commandline tutorial &#x1F4D7;  __["tutorial_noGraphic_support.docx"]__ was extended:  
  the following steps where included  
      16) DTI-preprocessing: Import DTI/DWI-files from Bruker rawdata  
      17) DTI-preprocessing: rename DWI-files  
      18) DTI-preprocessing: A special DTI-atlas is needed  
      19) DTI-preprocessing: Perform DTI-preprocessing  
<!---->
  &#x1F535;   <ins>**28 May 2022 (18:20:48)**</ins>  
   __[DTIprep.m]__ - preparation for DTI-processing  
   - now works completely via command line (no-GUIs) --> see help DTIprep  
   - sorting+matching of btables and DWIfiles enabled (please confirm visually!)  
   - registration with parallel processing supported ...to enable change flag in the DTIconfig.m file in the DTI-folder  
   - click DTIprep "scripts"-button to obtain an examle of DTIprep via COMMAND LINE ( &#9829; "DTIscript_runDTIprep_COMANDLINE.m")  
    
<!---->
  &#x1F535;   <ins>**25 May 2022 (11:44:39)**</ins>  
   __[sub_atlaslabel2xls.m]__ - bug removed when writing xls-file  
    
<!---->
  &#x1F535;   <ins>**24 May 2022 (13:15:17)**</ins>  
    __[cfg_getfile2.m]__  bug in filter-funtion removed  
    __[cfm.m]__  case-file matrix ...  
    - copy/copy&rename (context menu) of files with different filenames in one step  
    - delete files (context menu) with different filenames in one step  
    
<!---->
  &#x1F535;   <ins>**24 May 2022 (10:17:17)**</ins>  
  -embedded symbols changed in readme.md and antver.md (...seems no further support of placeholder service "via.placeholder.com")  
    
<!---->
  &#x1F535;   <ins>**23 May 2022 (16:16:07)**</ins>  
   __[xrename.m]__  modified  
  - added a file-filter   
  - wildcard-option from command-line ..first tests  
  - bug removed in context menu  
    
<!---->
  &#x1F535;   <ins>**17 May 2022 (12:29:46)**</ins>  
  __[update]__-button:  a context-menu was added  
  - context menu options: update-info, force update, show last local changes, help on update  
    
<!---->
  &#x1F535;   <ins>**17 May 2022 (00:20:29)** </ins>  
   __[xgetlabels4.m]__  modified  
  - get regionwise parameter now runs on HPC without GUI/graphic support ...  
    see help of xgetlabels4.m ...Example-4  
  - "hemisphere": 'separate' added to obtain region-wise parameters for each hemisphere separately  
     in one run --> this results in two Excel-files (..left & ...right)  
  - __["tutorial_noGraphic_support.docx"]__ was extended  
    
<!---->
  &#x1F535;   <ins>**16 May 2022 (16:13:10)**</ins>  
  __[update]__-button added next to __[ant version]__-button in ANTx-main gui  
  The update button allows to retrieve the latest updates from GitHub  
  (no GUis/no imput requested from user)  
    
<!---->
  &#x1F535;   <ins>**13 May 2022 (16:46:56)**</ins>  
  new tutorial &#x1F4D7;  __["tutorial_noGraphic_support.docx"]__   
  This tutorial shows how to work on machines without graphic support and without GUIs   
      1) Optional: how to set the paths of elastix in unix/linux-system:  
      2) Optional: open interactive session on hpc-cluster and start matlab  
      3) Basics  
         -add antx-paths  
         -go to study-folder  
         -update ant-toolbox  
         -create a project-file:   
         -load a project-file "proj.m"   
         -check whether the project-file is loaded   
      4) Import bruker-data  
      5) Visualize files and folders  
      6) Selection of animals  
      7) Rename files  
      8) Register “t2.nii” to template (standard space, ss)  
      9) Extract the first 3d-volume from the 4d-vlume 'dti_b100.nii'   
      10) Coregister 'dti_b100_1stimg.nii' to ‘t2.nii’  
      11) Transform another image to standard-space  
      12) Transform another image to native-space  
      13) Check registration in standard-space - create html-file  
      14) Check registration in native-space - create html-file  
      15) REGIONWISE PARAMETER-EXTRACTION    
  This tutorial shows how work without GUis or on machines without graphic support  
  &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages) https://chariteexpmri.github.io/antxdoc/  
    
<!---->
  &#x1F535;   <ins>**13 May 2022 (01:12:05)**</ins>  
   __[xregister2d.m]__: modified  
   -runs on machines without graphic support  
   -option to allow parallel processing over animals   
   __[xcoreg.m]__: modified  
   -runs on machines without graphic support  
   -option to allow parallel processing over animals   
    
<!---->
  &#x1F535;   <ins>**11 May 2022 (00:08:32)**</ins>  
   __[dispfiles.m]__: display files folderwise in command-window (no GUI)  
  examples with ant: dispfiles('form',2,'flt','.*.nii','counts',0);  
  example no graphics support: dispfiles('form',2,'flt','.*.nii','counts',0,'dir',fullfile(pwd,'dat'));  
    
<!---->
  &#x1F535;   <ins>**09 May 2022 (15:52:33)**</ins>  
   __[xmaskgenerator.m]__: implemented reslicing if another atlas is used with a different voxel-size  
    
<!---->
  &#x1F535;   <ins>**06 May 2022 (14:17:26)**</ins>  
   __[updateantx.m]__: noGUI-update/install function for antx-project via GITHUB (no graphical userinterface)  
  -type "updateantx(2)" to just update local antx-toolbox  
  -see help of updateantx.m for more information  
    
<!---->
  &#x1F535;   <ins>**04 May 2022 (14:53:04)**</ins>  
  antcb('selectdirs') command extended using filesearch-operation  
  example:  antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'or');  %select all dirs containing either 't2.nii' or 'x_t2.nii'        
    
<!---->
  &#x1F535;   <ins>**29 Apr 2022 (08:23:36)**</ins>  
   __[xbruker2nifti.m]__: command line support was exteded (file filter options)  
    
<!---->
  &#x1F535;   <ins>**28 Apr 2022 (13:43:07)**</ins>  
   __[DTIprep.m]__: prepare data for DTI-processing via Mrtrix. Ideally DTI-processing could start  
  - added check and reordering optin for b-table & DWI-files  
  &#8618; access via ANT-menu: &#8658; Statistic/DTIprep for mrtrix.  
    
<!---->
  &#x1F535;   <ins>**27 Apr 2022 (17:30:24)**</ins>  
   __[xbruker2nifti.m]__: now supports comandline mode (silent/no GUI) with filter option  
  -fun "selector2.m" supports preselection of rows  
  -fun "lastmodified.m" added; return name and date of the last modified files of a directory and subfolders (sorted)  
    
<!---->
  &#x1F535;   <ins>**11 Apr 2022 (12:23:25)**</ins>  
   __[xstatlabels.m]__: GUI was refreshed, added scripts-collection for xstatlabels  
  -This function performes regionwise statistics of an image-parameter such as intensity mean or volume  
   between groups   
  &#8618; access via ANT-menu: &#8658; STATISTIC/label-based statistik  
    
<!---->
  &#x1F535;   <ins>**06 Apr 2022 (17:39:47)**</ins>  
   __[scripts_collection.m]__: extended.. now contains the following scripts/examples:  
  'sc_xrename.m'                    .. shows how to rename files + basic file manipulation  
  'sc_register_to_standardspace.m'  .. shows how to register 't2.nii' to standard-space  
  'sc_transformimage_exportfile.m'  .. shows how to transform another image to standard-space & export files  
  'sc_checkregistrationHTML.m'      .. shows how to generate HTMLfiles to check the registration  
  'sc_getantomicalLabels.m'         .. shows how to extract anatomical-based parameters from images and save as excel-files  
  &#8618; access via ANT-menu: &#8658; SNIPS/scripts collection   
    
<!---->
  &#x1F535;   <ins>**06 Apr 2022 (14:47:57)**</ins>  
   __[antcb.m]__: extended.. antcb('studydir') obtain study-folder  
  __[sdir sinfo]__=antcb('studydir','info');  % obtain info for the study (storage-size/number of files/animals)  
  see antcb('studydir?') for help  
    
  bugfix in  __[sub_atlaslabel2xls.m]__: ... removing default-sheets was not working  
    
<!---->
  &#x1F535;   <ins>**06 Apr 2022 (12:21:31)**</ins>  
  bugfix in  __[exportfiles.m]__:  ...internal file-filter was buggy    
  bugfix in  __[xstat.m]__: ... multifactorial design was buggy  
    
<!---->
  &#x1F535;   <ins>**05 Apr 2022 (12:39:20)**</ins>  
  added  __[scripts_collection.m]__: This GUI contains scripts which can can be costumized  
  The scripts-collection will be extended in the near future    
  &#8618; access via ANT-menu: &#8658; SNIPS/scripts collection  
    
<!---->
  &#x1F535;   <ins>**04 Apr 2022 (13:54:22)**</ins>  
  added  __[HTMLprocsteps.m]__: This function creates additional HTML-files for the   
  processing report (initialization, coregistration, segementation and warping).  
  These HTML-files are available as hyperlinks in the "summary.html"-report and depicts  
  the output if each processing step for all animals. Thus you may not need to select the   
  'inspect'-hyperlink for each animal. Just select respective hyperlink to obtain an   
  overview for all animals.    
    
<!---->
  &#x1F535;   <ins>**24 Mar 2022 (23:16:21)**</ins>  
   __[cleanmask.m]__: now also allows to remove tissue parts, help added  
    
<!---->
  &#x1F535;   <ins>**24 Mar 2022 (11:34:05)**</ins>  
  added "approach_photothrombosis" as option for elxMaskApproach  
  This approach can be used for photothrombotic stroke models together with a lesionmask (with name 'lesionmask.nii')  
    
  added  __[cleanmask.m]__: This function can be used to delete slices from a NIFTI-image  
  - currently this function can be used to delete errornuous slices from the "_msk.nii" image,  
  generated from the skullstripping step. In some cases the registration (subsequent step) which   
  depends on the "_msk.nii" is suboptimal. Thus use cleanmask.m to delete the affected slices from   
  "_msk.nii"  
  this function is still in progress...  
  &#8618; ANTx-animal listbox &#8658; context menu /SPECIFIC TOOLS/prune mask ("_msk.nii")  
    
<!---->
  &#x1F535;   <ins>**23 Mar 2022 (00:37:51)** </ins>  
  different sorting strategies of the animals in the ANT-main GUI animal-listbox implemented   
      'default' : default sorting  
      'progress_down' or 'progress_up'    : sort animals after atlas-registration-progress  
      'lengthName_up' or 'lengthName_down': sort animals after animal name length  
      'statusMsg_up'  or 'statusMsg_down' : sort animals after status message (specified via context menu: "set status")  
  &#8618; access via ANTx Gui pulldown-menu next to the __[update]__-button   
    
    
<!---->
  &#x1F535;   <ins>**18 Mar 2022 (13:06:56)**</ins>  
  added to context menu of ANTx-animal listbox: checkRegistraton via HTML-file  
  this option creates an HTML-file with the registration results for selected animals  
  you can chose between  
      -check forward registration (standard-space)  
      -check specific forward registration (open GUI) --> you can specify specific paramters  
      -check inverse registration (native-space)  
      -check specific inverse registration (open GUI) --> you can specify specific paramters  
  &#8618; ANTx-animal listbox &#8658; context menu  
    
<!---->
  &#x1F535;   <ins>**16 Mar 2022 (11:30:01)**</ins>  
  script "STscript_DTIstatistic_simple2.m" added to  __[dtistat.m]__:    
  This script performs the t-statistic (two groups) of the fibre-connections (*.csv-file)   
  &#8618; access via ANT-menu: &#8658; Statistic/DTI-statistic (or dtistat.m)  &#8658; use the __[scripts]__-button  
    
<!---->
  &#x1F535;   <ins>**11 Mar 2022 (08:24:50)**</ins>  
  added a scripts collection to  __[xstat.m]__: added scripts for voselwise statistic  
   -scripts can be modified and applied  
   -current scripts for voxwelwise statistic:  
      'VWscript_twosampleStat_simple.m'  
      'VWscript_MakeSummary_simple.m'  
      'VWscript_twosampleStat_severalimages.m'  
      'VWscript_MakeSummary_severalimages.m'  
      'VWscript_twosampleStat_severalimages_severalgroups.m'  
      'VWscript_MakeSummary_severalimages_severalgroups.m'  
  &#8618; access via ANT-menu: &#8658; Statistic/SPM-statistic (or xstat.m)  &#8658; use the __[scripts]__-button  
    
<!---->
  &#x1F535;   <ins>**09 Mar 2022 (11:02:40)**</ins>  
  fixed bug in  __[exportfiles]__: :  subdir was not addressed correctly  
    
<!---->
  &#x1F535;   <ins>**07 Mar 2022 (09:52:06)**</ins>  
  new function  __[scripts_gui]__: This function contains a collection of scripts that can be   
  costumized and applied. Currently the script-collection is available for the following functions:  
  DTIprep.m; dtistat.m, xvol3d.m  
    
<!---->
  &#x1F535;   <ins>**02 Mar 2022 (17:06:11)**</ins>  
  new tutorial &#x1F4D7;  __["tutorial_extractParamter_via_Mask.docx"]__   
  This tutorial shows how to extract parameters (mean/volume etc.) from a read-out image   
  using a mask. In this tutorial the mask contains two ROIs.  
  &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages)  
    
    
<!---->
  &#x1F535;   <ins>**02 Mar 2022 (16:17:11)**</ins>  
  function  __[xgetparameter]__: extended  
  - parameter-extraction now possible with animal-specific mask(s) located in the animal-folders  
    potential scenario: parameter-extraction using animal-specific masks from read-out images  
    in native space  
<!---->
  &#x1F535;   <ins>**23 Feb 2022 (16:40:25)**</ins>  
  function  __[DTIprep]__: added a script-selection-option  
  - scripts can be copied and costumized for own purpose  
  - currently, there exist only three scripts:  
  1) "DTIscript_HPC_exportData_makeBatch.m"  
    - script allows to export DTI-data to HPC-cluster storage, write a HPC-slurm batch & make batch executable  
    - using "sbatch myBatchName.sh" the DTI-processing can be performed on the HPC-cluster  
  2) "DTIscript_posthoc_makeHTML_QA.m"  
    - make HTML-file for quality assesment of DTI-processing (using png-images created by MRtrix)  
    - this script ist for posthoc QA  
  3) "DTIscript_posthoc_exportData4Statistic.m"  
   -post hoc file to export necessary files from HPC-cluster to another directory  
   - script can be used for post-hoc statistical analysis  
    
<!---->
  &#x1F535;   <ins>**11 Feb 2022 (00:31:35)**</ins>  
  small changes in  __[xdraw]__:   
  -debugged contour-fill and delete object (right-mouse click) functions  
   __[ant]__: added resize buttons to animal listbox of the ANT gui. Resize the listbox in case of  
  large cohorts or long animal names/identifiers  
    
<!---->
  &#x1F535;   <ins>**08 Feb 2022 (12:38:25)**</ins>  
  function  __[exportfiles]__: added as alternative to export/copy files from any data-hierarchie to  
  a destination folder (no ANT-project must be loaded for this function)  
  -function should also work for files of a studie's "dat"-folder  
  &#8618; access via ANT-menu: &#8658; Main/export files (from any folder)  
    
<!---->
  &#x1F4D9;   <ins>**06 Feb 2022 (21:20:48)**</ins>  
  Updated the tutorial webside on Github-Pages. The Webside contains basic tutorials (PDF-files).  
  &#8618;  access via link : <u>"https://chariteexpmri.github.io/antxdoc"  
  &#8618; access via ANT-menu: &#8658; EXTRAS/visit ANTx Tutorials (Github-Pages)  
    
<!---->
  &#x1F535;   <ins>**06 Feb 2022 (21:18:33)**</ins>  
  function  __[getNiftiheader]__: obtain NIFTI-header information of one/several NIFTI-files  
  function  __[reslice_nii2]__: reslice image by applying the header's transformation matrix  
    
<!---->
  &#x1F535;   <ins>**27 Jan 2022 (11:43:10)**</ins>  
   __[xstat]__:  voxelwise analysis was extended.  
    - post-hoc paramter modifications and summary report can executed from comandline  
    - write summary as powerpoint-files, write statistical table as excel-file,   
    - save statistically thresholded volume  (Nifti)  
    - button __[code posthoc]__ display the code snippet for creating a summary (PPT-,Excel-,NIfti-files)   
   __[xstatlabels]__: regionwise statistic was extended  
   - The excelsheet now also contains a sheet "singleData" with the group-specifc single data for each region.   
    The single data be further used for plots/visualization or other purposes  
    
<!---->
  &#x1F535;   <ins>**14 Jan 2022 (12:03:50)**</ins>  
   __[xdeformpop]__: GUI was replaced by extended version (part of 'deform Volume Elastix'-operation)  
   __[xstat]__: function was updated  
    - The Powerpoint-report of the voxelwise statistic was extended  
    - programmatically change viewing parameters / generate Powerpoint-report  
    
<!---->
  &#x1F535;   <ins>**12 Jan 2022 (17:12:52)**</ins>  
   __[xstatlabels.m]__: 'export' as excel-file now also contains the single animal data  
   __[xgetparameter.m]__: added parameter "integrated density"  
    
<!---->
  &#x1F535;   <ins>**06 Jan 2022 (13:37:22)**</ins>  
   __[xcreateMaps.m]__ solved bugs:  
  - selection of animals via left ANT-listbox before running this function enabled  
  - previous image-operation  "abs" ...sumation over images debugged. Note that this option produces the same  
    result as the "sum"-operation.  
  &#8618; access via ANT-menu: &#8658; SNIPS/Create MAPS  
    
    
<!---->
  &#x1F535;   <ins>**03 Jan 2022 (14:08:14)**</ins>  
   __[xgetlabels4.m]__ A specifc fileName for resulting excel-file can be entered.  
    
    
<!---->
  &#x1F535;   <ins>**20 Dec 2021 (14:42:46)**</ins>  
   __[xstatlabels.m]__ The group-column in the "group-assignment"-Excel-file can be numeric now  
    
<!---->
  &#x1F535;   <ins>**08 Dec 2021 (01:22:39)**</ins>  
   __[xvol3d.m]__ save image as (tif/jpg/png) via context-menu (disable rotation-mode  before access the context menu)  
    
<!---->
  &#x1F535;   <ins>**06 Dec 2021 (17:03:18)**</ins>  
   __[cfm.m]__ --> case-file-matrix: visualize data (files x dirs), basic file-manipulation  
  &#8618; access via ANT-GUI: Two new icons next to study-history-icon: CFM of all animals from   
  the current study or CFM for selected animals (selected via left listbox)  
    
<!---->
  &#x1F535;   <ins>**28 Nov 2021 (23:58:44)**</ins>  
   __[xcreateMaps.m]__ create MAPS across animals (heatmaps/IncidenceMaps/MeanImage Maps etc)  
  xcreateMaps.m: (former version "xincidencemap.m")  
  choose a math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*}  
  &#8618; access via ANT-menu: &#8658; SNIPS/create Maps (incidenceMaps/MeanImage etc)  
    
   __[xrealign_elastix.m]__  --> replace NANs by Zeros in 4D-volume after realignment  
    
<!---->
  &#x1F535;   <ins>**28 Nov 2021 (00:33:52)**</ins>  
   __[xstatlabels.m]__ added tail-option for hypothesis-testing   
    
<!---->
  &#x1F535;   <ins>**27 Nov 2021 (23:15:21)**</ins>  
    __[xgetparameter.m ]__ obtain mask-based parameter from images (multimasks & masks can be mulinary)  
  mask-based paramters are:  'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'      
  MASK: you can use several masks/images, each with several sub-masks/(IDs), IDS across masks  
  can be similar   
  The output is one EXCELFILE containing sheets for each paramter. Each column contains the data of   
  one of the selected animals. The output (excelfile) can be analyzed using MENU/STATISTIC/"label based statistic"  
  .. CURRENTLY ONY PROVIDED FOR IMAGES/MASKS IN STANDARD-SPACE  
    
<!---->
  &#x1F535;   <ins>**01 Nov 2021 (17:29:22)**</ins>  
    __[DTIprep]__ minor changes ..added some solutions to avoid some MRtrix-BUGs:  
  --> see help of DTIprep.m  
    
<!---->
  &#x1F535;   <ins>**29 Sep 2021 (17:11:33)**</ins>  
  Created a web-side with tutorials   
  Depending on the time, further tutorials will be uploaded soon  
  &#8618;  access via link : <u>"https://chariteexpmri.github.io/antxdoc"  
    
    
<!---->
  &#x1F535;   <ins>**28 Sep 2021 (13:33:22)**</ins>  
  small changes in   
    __[uhelp]__ added: hyperlink selection via context menu   
    __[cfg_getfile2]__ added: 4D-Nifti filter  
    
<!---->
  &#x1F535;   <ins>**21 Sep 2021 (22:50:00)**</ins>  
   __[DTIprep.m]__: updated  
  &#9745; DTIprep for "multi-shell" (multi b-value diffusion acquisitions) analysis: finished  
  -wrote some info/help to work with DTIprep.     
  -added context menu (check b-table/DWI-files; delete files etc.)  
    
<!---->
  &#x1F535;   <ins>**21 Sep 2021 (01:01:34)**</ins>  
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
  &#x1F535;   <ins>**15 Sep 2021 (17:30:22)**</ins>  
   __[anthistory.m]__: load a project from history, i.a. from a list of previous ANTx calls/studies  
  &#8618; access via ANT main GUI: &#8658; __[green book]__-button. Hit button to open the history.  
    
<!---->
  &#x1F535;   <ins>**13 Sep 2021 (15:05:32)**</ins>  
   __[setanimalstatus.m]__: set a processing status tag for selected animal(s)  
  The status tag appears in the left listbox (animals) and tooltip when hovering over the animal.  
  &#8618; access via animal-listbox &#8658; context-menu/set status  
    
<!---->
  &#x1F535;   <ins>**08 Sep 2021 (10:42:24)**</ins>  
   __[sub_sting.m]__ creates node-related needles with numeric annotations (labels) onto 3D-brain (for DTI-data)  
  -annotations are view-dependent and will be adjusted accordingly   
  -labels appear at positions along a circle circumventing the brain  
  -labels can be manually repositioned  
  -function is part of xvol3d.m/sub_plotconnections to display DTI-connection onto a 3D brain  
    
<!---->
  &#x1F535;   <ins>**23 Aug 2021 (14:12:17)**</ins>  
   __[xcalcSNRimage.m]__ convert image to SNR-image   
  according to Gudbjartsson H, Patz S. 1995: The Rician distribution of noisy MRI data. Magn Reson Med.; 34(6): 910–914.)  
  -can be used for Fluorine-19 (19F)-contrast images   
  &#8618;  access via ANT-menu: SNIPS/convert image to SNR-image  
<!---->
  &#x1F535;   <ins>**19 Aug 2021 (23:50:18)**</ins>  
   __[xrename.m]__: now allows to threshold an image  
  &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  &#x1F535;   <ins>**19 Aug 2021 (21:02:37)** </ins>  
   __[xstat.m]__: added pulldown to select the statistical method to treat the multiple comparison problem  
<!---->
  &#x1F535;   <ins>**18 Aug 2021 (12:24:04)**</ins>  
   __[xrename.m]__: added context menu for easier file manipulation (copying/renaming/expansion/deletion)  
  and additional file information (file paths; existence of files; header information)  
    
<!---->
  &#x1F535;   <ins>**16 Aug 2021 (13:35:35)**</ins>  
  test: gitHub with "personal access token" : upload-seems to work/chk(TunnelBlick)  
    
<!---->
  &#x1F535;   <ins>**16 Aug 2021 (11:18:29)**</ins>  
   __[case-filematrix]__ add file functionality: copy/delete/export files ; file information    
  &#8618;  access via ANT-menu: Graphics/show case-file-matrix  
<!---->
  &#x1F535;   <ins>**12 Aug 2021 (18:49:17)**</ins>  
   __[xcheckreghtml.m]__ ... fixed BUG: "dimension"-parameter error with string/double vartype   
  __[checkpath]__ checks whether paths-names of ANTx-TBX, a study-project/template and data-sets contain special characters   
  Special characters might result in errors & crashes.  
  &#8618; access via ANT-menu: Extras/troubleshoot/check path-names  
    
<!---->
  &#x1F535;   <ins>**28 Jun 2021 (15:36:53)**</ins>  
   __[show4d.m]__: SHOW 4D-VOLUME / check quality of realignment of 4D-volume  
  function allows to display a 4D-volume and it's realigned version side-by-side  
  For quality assessment, the 1st volume is displayed on top (as contour plot) of the selected (3D)-volume   
  &#8618; access via ANT-menu: Graphics/check 4D-volume (realignment)  
    
<!---->
  &#x1F535;   <ins>**25 Jun 2021 (12:05:36)**</ins>  
   __[xrealign_elastix.m]__: multimodal realignment of 4D data (timeseries) using ELASTX and mutual information  
  &#8618; access via ANT-menu: Tools/realign images (ELASTIX, multimodal)  
    
<!---->
  &#x1F535;   <ins>**29 May 2021 (01:20:40)**</ins>  
   __[xrealign.m]__  --> realign 3D-(time)-series or 4D volume using SPM-realign function  
  &#8618; access via ANT-menu: Tools/realign images (SPM, monomodal)  
    
<!---->
  &#x1F535;   <ins>**10 May 2021 (20:39:32)**</ins>  
   __[xcheckreghtml.m]__ implemented. This function create HTML-files with overlays of arbitrary images.   
   The HTML-files can be used to check the registration, can be zipped and send to others.  
  &#8618; access via ANT-menu: Graphics/generate HTML-file  
    
<!---->
  &#x1F535;   <ins>**07 May 2021 (22:15:55)**</ins>  
  -->started __[checkreghtml]__: make html-page of overlay of arbitrary pairs of images for selected animals   
<!---->
  &#x1F535;   <ins>**06 May 2021 (10:29:16)**</ins>  
  fixed BUG in "rsavenii.m" (issue only for writing 4D-data only)  
<!---->
  &#x1F535;   <ins>**13 Apr 2021 (21:52:21)**</ins>  
  - CAT-atlas (Stolzberg et al., 2017) added to google-drive  
    &#8618;  access via link : https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
    paper: https://onlinelibrary.wiley.com/doi/abs/10.1002/cne.24271  
    
    
<!---->
  &#x1F535;   <ins>**16 Feb 2021 (15:46:57)**</ins>  
   - DTI-statistic and 2d-matrix/3d-volume visualization was extended   
     functions: __[dtistat.m]__, __[xvol3d.m]__ and __[sub_plotconnections.m]__  
   - get anatomical labels __[xgetlabels4.m]__: The paramter volume percent brain ("volpercbrain") was  
     re-introduced in the resulting Excel-table  
    
<!---->
  &#x1F535;   <ins>**24 Nov 2020 (14:08:48)**</ins>  
  - NEW TUTORIAL  &#x1F4D7;  __['tutorial_prepareforFSL.doc']__  
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
  -  NEW TUTORIAL  &#x1F4D7;  __['tutor_multitube_manualSegment.doc']__  
     PROBLEM: Several animals located in one image (I call this "multitube")  
         This tutorial explains the following steps:  
                1. Manual segment images --> draw masks  
                2. Split datasets using the multitube masks  
              &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
   
<!---->
  &#x1F535;   <ins>**23 Nov 2020 (15:32:33)**</ins>  
  - __[xrename]__: extended functionality: now allows basic math operations of images such as  
    ROI extraction, image thresholding, combine images (mask an image by another image)  
  - other options of __[xrename]__: scale image, change voxel resolution (see help of xrename)  
        &#8618;  access via ANT-menu: Tools/manipulate files  
<!---->
  &#x1F535;   <ins>**18 Nov 2020 (13:30:53)**</ins>  
  - __[xdownloadtemplate.m]__ added: check internet connection status  
  - new tutorial &#x1F4D7;  __['tutorial_brukerImport.doc']__    
    This tutorial deals with conversion of Bruker data to NIFTI files.  
      &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  &#x1F535;   <ins>**16 Nov 2020 (01:37:17)** </ins>  
  __[atlasviewer.m]__ added. This function allows to display an atlas (NIFTI file) for example the  
  'ANO.nii' -file   
       &#8618;   access: ANT-MENU: Graphics/Atlas viewer  
    -TODO: test MAC & LINUX   : DONE!  
<!---->
  &#x1F535;   <ins>**30 Oct 2020 (14:50:30)**</ins>  
  __[SIGMA RAT template]__ (Barrière et al., 2019) added to gdrive  
    - Paper           : https://rdcu.be/b9tKX  or https://doi.org/10.1038/s41467-019-13575-7  
    - &#8618;  access via link : https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
      or ANT menu: EXTRAS/download templates  
<!---->
  &#x1F535;   <ins>**25 Oct 2020 (21:33:14)**</ins>  
   __[xdraw]__ drawing mask tool: refurbished, containing tools:   
    - advanced saving options,   
    - contour line segmentation  
    - ROI manipulation (translate/rotate/flip/copy/replace)  
    - TODO: test MAC & LINUX :  DONE!  
<!---->
  &#x1F535;   <ins>**14 Oct 2020 (17:53:20)**</ins>  
  - __[xdraw]__ drawing mask tool: added contours and contour-based segmentation, completed help  
<!---->
  &#x1F535;   <ins>**14 Oct 2020 (02:03:47)**</ins>  
  - __[xdraw]__ drawing mask tool now includes a 3D-otsu segmentation   
<!---->
  &#x1F535;   <ins>**13 Oct 2020 (10:46:14)**</ins>  
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
  &#x1F535;   <ins>**07 Oct 2020 (12:56:31)**</ins>  
  -__[xdraw]__ : debug, added measuring tool (distance in mm/pixel and angle)  
<!---->
  &#x1F535;   <ins>**06 Oct 2020 (03:45:46)**</ins>  
  __[xdraw]__ draw a (multi-) mask manually , improved version, allows otsu-segmentation, new image drawing  
  tools, calculate volume for each mask-region, save as mask or save masked background image  
     &#8618; access via ANT-menu: Tools/draw mask  
<!---->
  &#x1F535;   <ins>**22 Sep 2020 (13:30:09)**</ins>  
  new tutorial &#x1F4D7;  __['tutorial_convertDICOMs.doc']__    
  This tutorial deals with the conversion of dicom to NIFTI files.  
     &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  &#x1F535;   <ins>**22 Sep 2020 (00:14:08)**</ins>  
  __[xdicom2nifti]__: revised (now allows conversion using MRICRON or SPM)...Mac/Linux/WIN  
<!---->
  &#x1F535;   <ins>**21 Sep 2020 (12:46:16)**</ins>  
  __[xsegmenttubeManu]__ added. This function allows to manually segment a Nifti-image containing several  
  animals ("multi-tube" image). This function works as manual pendant to __[xsegmenttube]__.  
<!---->
  &#x1F535;   <ins>**17 Sep 2020 (13:45:38)**</ins>  
  __[xgetlabels4]__ BUG solved: "zeros" in resulting excelFile  
<!---->
  &#x1F535;   <ins>**14 Sep 2020 (13:14:15)**</ins>  
  __[xdownloadtemplate]__ DOWNLOAD TEMPLATES VIA GUI ..modified using curl (MAC/Linux) and wget.exe (windows)  
  - Function was tested with and without proxies using Win, MAC & Linux  
<!---->
  &#x1F535;   <ins>**07 Sep 2020 (03:41:16)**</ins>  
  __[xdownloadtemplate]__ DOWNLOAD TEMPLATES VIA GUI (faster alternative compared to webside).  
     &#8618;  Access via Extras/donwload templates  --> unresolved/untested: proxy settings   
<!---->
  &#x1F535;   <ins>**01 Sep 2020 (12:49:32)**</ins>  
  manual coregistration __[displaykey3inv.m]__: update help   
<!---->
  &#x1F535;   <ins>**28 Aug 2020 (10:43:27)**</ins>  
  - __[uhelp]__ bug-fix: help-fig failed to update fontsize and fig-position after reopening    
  - updates/changes (__[antver.m]__) can be inspected from the GITHUB webside.      
<!---->
  &#x1F535;   <ins>**27 Aug 2020 (15:42:11)**</ins>  
  __[xvol3d_convertscores]__: new function for xvol3d...allows to 3d colorize user-specific regions by scores/values (percentages/statist scores)   
<!---->
  &#x1F535;   <ins>**24 Aug 2020 (12:08:22)**</ins>  
  - getanatomicallabels __[sub_atlaslabel2xls.m]__: fixed bug.. writing excel table (mac) because newer cell2table-version  
  variable names must match with Matlab variable style. This happens when animal names (such as "20130422_TF_001_m1_s3_e6_p1")  
  start with a numeric value instead of a character). SOLUTION: In such cases animals the animals in the excel table   
  will be renamed (adding a prefix 's' such as "s20130422_TF_001_m1_s3_e6_p1").  
<!---->
  &#x1F535;   <ins>**24 Aug 2020 (09:27:02)**</ins>  
  new tutorial &#x1F4D7;  __["tutorial_orientation_and_manucoreg.doc"]__   
  This tutorial deals with image orientation for template registration and manual coregistration.  
    &#8618; access via ANT-menu: Extras/documentations  or ..\antx2\mritools\ant\docs  
<!---->
  &#x1F535;   <ins>**17 Aug 2020 (16:49:32)**</ins>  
  __[paramgui]__ new version, (multi-icon style, execution-history)  
  ..the old version is still available (via menu/preferences)  
    
  __[installfromgithub]__ BUG-solved:  after 'rebuilding'...gui could not close and workdir did not go prev. study path  
<!---->
  &#x1F535;   <ins>**14 Aug 2020 (12:57:03)**</ins>  
  __[getReferencePath]__ modified (layout with listbox, instead of buttons); recursive search for 'AVGT.nii' in (sub)/folder of ant-templates  
   --> to overcome the (sub)/folder nestings in the ant-templates folder  
<!---->
  &#x1F535;   <ins>**10 Aug 2020 (11:34:58)**</ins>  
  __[doelastix]__ (deform volumes elastix) parallelized for 4D-data  
<!---->
  &#x1F535;   <ins>**07 Aug 2020 (17:36:56)**</ins>  
  __[doelastix]__ (deform volumes elastix) now possible, apply registration-trafo to 4D-data (example: BOLD-timeseries) (..not parallelized yet)  
<!---->
  &#x1F535;   <ins>**07 Aug 2020 (14:43:11)**</ins>  
  __[xheadman.m]__ explicit output filename, added tooltips  
  __[skullstrip_pcnn3d]__: added errorMSG  if vox-size is to large  
  __[displaykey2.m]__: bugfix with zooming  
<!---->
  &#x1F535;   <ins>**05 Aug 2020 (22:10:09)**</ins>  
  solved issue: unintended interaction between help window (mouse-over main menu) and ant-history window   
<!---->
  &#x1F535;   <ins>**04 Aug 2020 (16:38:17)**</ins>  
  __[installfromgithub]__ small changes  
<!---->
  &#x1F535;   <ins>**03 Aug 2020 (12:50:16)**</ins>  
  debug Matlab19b error __[xbruker2nifti]__.. in preadfile2: error occured due to uncommented code   
  after 'return' command (varargin issue)  
<!---->
  &#x1F535;   <ins>**08 Jul 2020 (13:37:00)**</ins>  
  __[dtistat]__: revised; for DTI-connectivities allows input data from MRtrix; new command line access;  
  new COIfile;    
<!---->
  &#x1F535;   <ins>**30 Jun 2020 (23:15:45)**</ins>  
  __[xvol3d.m]__ -updated, tested Linux/MAX/WIN, added more options  and label properties  
<!---->
  &#x1F535;   <ins>**23 Jun 2020 (17:13:43)**</ins>  
  3D-volume visualization added (main menu .. grahics/3D-volume): allows to 3D-visualize atlas regions,  
  nodes & links (connections/~strength) and statistical images/intensity images __[xvol3d.m]__  
  -main features can be accessed via command line  
<!---->
  &#x1F535;   <ins>**23 Jun 2020 (17:01:21)**</ins>  
  __[doelastix.m]__ update, backward transformation now possible with userdefined voxel or dim-size  
<!---->
  &#x1F535;   <ins>**29 May 2020 (14:45:41)**</ins>  
  __[xstatlabels]__ bugfixed   
  __[uhelp]__ added finder panel   
<!---->
  &#x1F535;   <ins>**15 May 2020 (17:33:52)**</ins>  
  __[setup_elastixlinux.m]__ modified-->solved problem: stucked installation of MRICRON   
<!---->
  &#x1F535;   <ins>**14 May 2020 (14:14:07)**</ins>  
  __[elastix_checkinstallation]__ addeed (extras/troubleshoot)  .. fct to check installation of elastix-program  
  __[uhelp.m]__ modified: selection color    
  __[checkRegist]__ modified: changed image2clipboard function   
  __[summary_export]__ added (available via context menu of "PR"-radio in ANT-main window)   
  .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder  
<!---->
  &#x1F535;   <ins>**20 Mar 2020 (12:30:38)**</ins>  
  __[case-filematrix]__: export selected files from selected folders  
<!---->
  &#x1F535;   <ins>**11 Mar 2020 (17:28:49)**</ins>  
  __[xsegmenttube]__: segment several animals from the same image /tube  
  __[xsplittubedata]__: split data-sets based on tube-segementation  
<!---->
  &#x1F535;   <ins>**09 Mar 2020 (12:31:52)**</ins>  
  etrucian-shrew modified templates --> not finalized jet  
  __[approach_60]__ t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space  
  Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration  
<!---->
  &#x1F535;   <ins>**19 Feb 2020 (15:15:55)**</ins>  
  __[xdraw.m]__: manual drawing tool to create masks  ->>Tools/"draw mask"  
<!---->
  &#x1F535;   <ins>**17 Feb 2020 (12:32:00)**</ins>  
  set-up pipeline for etruscian shrew  
  __[xcoreg]__: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and  
  without spm-registration, (set "task" to __[100]__)  
<!---->
  &#x1F535;   <ins>**04 Feb 2020 (18:03:15)**</ins>  
  rat-brain segmentation accelerated  
<!---->
  &#x1F535;   <ins>**31 Jan 2020 (14:07:48)**: </ins>  
  __[xgetlabels4]__: allowing readout from "other Space"  
<!---->
  &#x1F535;   <ins>**28 Jan 2020 (10:14:11)**</ins>  
  __[xexcel2atlas.m]__: added information  
<!---->
  &#x1F535;   <ins>**27 Jan 2020 (09:43:48)**</ins>  
  __[xexcel2atlas.m]__: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx  
  __[sub_write2excel_nopc]__: subfun: write excel file for mac/linux  
<!---->
  &#x1F535;   <ins>**07 Jan 2020 (15:40:52)**</ins>  
  matlab19b fix: cfg_getfiles2: data from server  
  sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)  
<!---->
  &#x1F535;   <ins>**11 Dec 2019 (14:41:37)**</ins>  
  __[xcoreg]__ fix filename bug; display missing files  
  __[uhelp]__: allows column-wise/selectionwise copying   
<!---->
  &#x1F535;   <ins>**22 Nov 2019 (11:37:49)**</ins>  
  __[maskgenerator]__ added alpha-transparency slider and display number-of-rows pull down  
  checked regions of new Allen2017Hikishima template  
<!---->
  &#x1F535;   <ins>**15 Nov 2019 (02:14:16)**</ins>  
  __[maskgenerator]__ added "find" region-panel  
<!---->
  &#x1F535;   <ins>**13 Nov 2019 (00:47:38)**</ins>  
  __[maskgenerator]__ added region-lection list and online link to compare selected regions  
<!---->
  &#x1F535;   <ins>**04 Nov 2019 (11:35:28)**</ins>  
  set up GITHUB repository &#x1F4D7;  https://github.com/ChariteExpMri/antx2/  
  -primary checks macOS, Linux MINT  
  -updated __[uhelp]__  
<!---->
  &#x1F535;   <ins>**29 Oct 2019 (23:28:16)**</ins>  
   modif. files __[cfg_getfile2]__, __[uhelp]__  
<!---->
  &#x1F535;   <ins>**17 Oct 2019 (22:04:14)**</ins>  
  __[xregisterCT/CTgetbrain_approach2]__: added parameter "bonebrainvolume" for more robust cluster-identifaction  
<!---->
  &#x1F535;   <ins>**16 Oct 2019 (03:42:04)**</ins>  
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
  &#x1F535;   <ins>**07 Aug 2019 (14:23:20)**</ins>  
  initial rigid registration (xwarp3) modified for more robust registration  
  __[checkRegist.m]__:     GUI to check registration of several images  
  __[getorientation.m]__: GUI to examine the apriory orientation (how animal is positioned in scanner)  
   - run it without input arguments or use context menu from ANT animal listbox  
   - the respective ID/number of orientation can be used to define the "orientType" in the projectfile   
<!---->
  &#x1F535;   <ins>**22 May 2019 (12:19:03)**</ins>  
   addded: __[xcoregmanu.m]__ - manually coregister images   
<!---->
  &#x1F535;   <ins>**08 May 2019 (01:34:19)**</ins>  
   addedd icon panel __[iconpannel4spm.m]__ for manual preregistration step to facilitate manual  
   registration step  
<!---->
  &#x1F535;   <ins>**07 May 2019 (14:16:48)**</ins>  
  &#x1F34E;  new version "ANTx2"  
     - SPM-package: SPM12  
     - templates were outsourced and can be downloaded from:  
       https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9  
     - linux/mac/windows  
<!---->
