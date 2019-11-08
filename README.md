

<!---
  ANTX2 : tbx, charite,germany



# Construction Site,  started 06-Nov-2019 13:30:16 #
## ...this place is currently under construction, so please do not download in the moment
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

 ===================================================================================================

-->


# ANTx2
ANTx2 stands for **A** tlas **N** ormalization **T** oolbox using elasti **x**. It is a MATLAB toolbox for image registration of mouse magnetic resonance imaging data developed for research laboratories/departments.

## **Requirements**
- Windows (tested: Windows 10)
- Linux (tested: Ubuntu 16.04.6 LTS, MINT17)
- MAC (tested: OS X El Capitan v10.11.6)
- MATLAB, version R2015b/16a were tested, versions above 2018b should work ()

## Installation
### [OPTION-A] Installation via GITHUB using GIT
ADVANTAGE: updates can be made via toolbox         
- download & install GIT client --> https://git-scm.com/downloads
    just follow instructions and keep the default properties
- browse to LINK: https://github.com/ChariteExpMri/antx2
- select "installfromgithub.m" and click [RAW]-button 
  or go to here: https://raw.githubusercontent.com/ChariteExpMri/antx2/master/installfromgithub.m
- select "save as" (cmd+s or ctrl+s) and save file as "installfromgithub.m"
- copy "installfromgithub.m" to the location where antx toolbox should be installed.
  ..please don't create a folder with name "antx2", this folder will be created later on
- set MATLAB's current working dir to the location of "installfromgithub.m" 
- type installfromgithub to open the installer/check updates window
- select [FRESH INSTALL] ...next, select the hyperlink "install" Matlab's in ..wait..and hit [close] to close the window 

### [OPTION-B] just download via clone-button (GITHUB)
ADVANTAGE     : more simple installation
DISADVANTAGE: no update feature (or you have to install the GIT client post hoc) 
- select [Clone & download button]
- select [Download ZIP]
- unzip folder & copy entire "antx2"-folder to desired location

### <ins> Start Ant Gui  </ins> ###
<pre>
- set MATLAB's current working dir to "antx2" directory 
- type antlink to link paths 
  Alternatively, you can create a hyperlink that occurs each time Matlab is started.. (see "__startup.m" file
  in the antx2-directory for more information) 
- type "ant" to open ant-gui 
</pre>
### <ins> Check For Updates </ins> ###
 - To check for updates select EXTRAS/"CHECK FOR UPATES (GITHUB)" from the ant main gui
### <ins> Download Templates </ins> ###
 - download one or more templates (zip-files) from here (googledrive): https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
  
<!---
 or from subfolder "anttemplates" from LINK: https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM 
-->

---
  ![#1589F0](https://placehold.it/15/1589F0/000000?text=+) For C57BL/6 mice we suggest to use the latest Atlas from the Allen Institute (Atlas-2017,CCFv3), in googledrive prepared as "mouse_Allen2017HikishimaLR".
- the Atlas (70µm isotropic resolution) includes gray matter regions, fiber tracts and the ventricular system
######...  for more information see http://help.brain-map.org/display/mouseconnectivity/API ######
######  ... Please visit also the online interactive atlas: http://atlas.brain-map.org/atlas#atlas=1 ######

---
- unzip downloaded template file: 
 - create folder "anttemplates" located at the same hierarchical level as antx2-folder is located
   ..this is easier to obtain the respective template 
 - copy unzipped template folder to "anttemplates" dir
    -the "anttemplates"-folder should now contain a folder (such as "mouse_Allen2017HikishimaLR") with templates
         Examplary tree if "mouse_Allen2017HikishimaLR" template is used:
<pre>
           mydir
             |---antx2
             |---anttemplates
                   |---mouse_Allen2017HikishimaLR   
</pre>         
                   

____________________________________________________________________________________________


### <ins> Start Ant Gui  </ins> ###
 see [OPTION-A] --> Start Ant Gui 
### <ins> Download Templates  </ins> ###
 see [OPTION-A] --> Download Templates
_________________________________________________________________________________________________________________________
## [OPTION-C] Installation via googledrive
DISADVANTAGE: older versions & no update feature
LINK: https://drive.google.com/drive/u/1/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM
-	download and unzip the ANTX2-toolbox
-	save the toolbox to your preferred drive/path
-	open Matlab, in Matlab set current path to the location of ANTX-Toolbox
-	 type and evaluate Ñantlink.mì  in the command window to temporally add all necessary paths to the matlabpath (these paths are temporally added and will lost after restarting Matlab). 
-	Alternatively, you can create a hyperlink that occurs each time Matlab is started (select this hyperlink to temporally add all necessary paths of the toolbox). 
To do this, you can copy the __startup.mí file (located in the ANTX-directory) to the matlab-root-path (in Matlab type: ëmatlabrootí to obtain your matlab-root-path, see also: https://de.mathworks.com/help/matlab/ref/startup.html?requestedDomain=de.mathworks.com). 
Rename this file to 'startup.m'
Finally, in the ëstartup.mí-file you have to set the path of ANTX-TBX. 

STUDY PATH:
set matlabís current path to your mouse data ñuse Ñcd studypathî, where studypath is the current study-folder  or navigate to this path via Matlabís current path (edit field in Matlabís main window).
-example:  suppose data are in the study-folder ÑO:\TOMsampleData\harms\_retest_stack32ì. This folder contains the folder ëdatí with subfolders (each subfolder of the ëdatí-folder represents the data of one mouse) ? thus set path to: O:\TOMsampleData\harms\_retest_stack32


Start ANT:
  -type ant in Matlab editor to start ANT-GUI
The right figure shows the main panel, containing:
-	an upper listbox to display information & parameters 
-	a left listbox to display all mouse-folders, i.e. subfolders in the ëdatí-directory, data of each mouse is stored in its own folder
-	 a right listbox main warping functions)
-	 some buttons (with tooltips) 
-	a menu-bar with functions and instant help if mouse pointer is hovered over a menu-bar-item (functionís help is displayed in the lower help figure)



##########

## **Installation**

- download the ANTX-toolbox
- save the toolbox to your preferred drive/path
**- !! unzip the three files &quot;ANO.nii.zip&quot; &quot;AVGT.nii.zip&quot; and &quot;FIBT.nii.zip&quot; in the subfolder mritools/ant/templateBerlin\_hres !!**
- open Matlab, in Matlab set current path to the location of ANTX-Toolbox
- type and evaluate antlink.m  in command window to temporally add all necessary paths to the matlabpath (these paths are temporally added and will lost after restarting Matlab).

- alternatively you can create a hyperlink that occurs each time Matlab is started (select this hyperlink to temporally add all necessary paths of the toolbox). To do this, you can copy the startup.m file (located in the ANTX-directory) to the matlab-root-path (in Matlab type: matlabroot to obtain your matlab-root-path, see also: https://de.mathworks.com/help/matlab/ref/startup.html?requestedDomain=de.mathworks.com). Finally, in this startup.m-file you have to set your ANTX-path.

**Study path**

set matlabs current path to your mouse data use cd studypath, where studypath is the current study-folder or navigate to this path via MATLABS current path (edit field in MATLABS main window).

**Start ANTX**

- type ant in Matlab editor to start ANT-GUI

The right figure shows the main panel, containing:
- an upper listbox to display information &amp; parameters
- a left listbox to display all mouse-folders, i.e. subfolders in the √´dat√≠-directory, data of each mouse is stored in its own folder
- a right listbox main warping functions)
- some buttons (with tooltips)
- a menu-bar with functions and instant help if mouse pointer is hovered over a menu-bar-item (function√≠s help is displayed in the lower help figure)

## **Users**

ANTX was created and is used in the Department of Experimental Neurology at the Charit√© - University Medicine Berlin, Germany since 2015.

If you use it and find it useful please give us a note.

## **Included software**

ANTX uses the packages [SPM](http://www.fil.ion.ucl.ac.uk/spm/), [elastix](http://elastix.isi.uu.nl/), [mricron](https://www.nitrc.org/projects/mricron), [PCNN3D](https://sites.google.com/site/chuanglab/software/3d-pcnn), [nii](https://de.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image), [cbrewer](https://de.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab), [screen capture](https://de.mathworks.com/matlabcentral/fileexchange/24323-screencapture-get-a-screen-capture-of-a-figure-frame-or-component), [windowapi](https://de.mathworks.com/matlabcentral/fileexchange/31437-windowapi) and the [Allen mouse brain atlas](http://mouse.brain-map.org/), which are included in this repository. Please respect the licenses and copyright of these software packages.

Scripts in the freiburgLight directory using SPM functions underly the GNU General Public License version 2 or (at your opinion) any later version. All other scripts in the FreiburgLight directory are owned by the Department of Radiology, Medical Physics, University Medical Center Freiburg and are free for academic and non-commercial use. Redistribution without consent of Department of Radiology, Medical Physics, University Medical Center Freiburg (contact persons [Marco Reisert](mailto:marco.reisert@uniklinik-freiburg.de) and [Dominik von Elverfeldt](mailto:dominik.elverfeldt@uniklinik-freiburg.de)) is not permitted.

ANTX also includes the pvmatlab package of Bruker BioSpin GmbH, which is intended for Bruker users only. Please respect the legal issues in the manual within the pvtools\_bruker directory and request permission to use the package by Bruker&#39;s preclinical MRI software customer support before using ANTX. Otherwise please delete the directory pvtools\_bruker.

## **Citation policy**

When using ANTX in publications you are obliged to cite the following primary publications:

_Koch et al. &quot;Atlas registration for edema-corrected MRI lesion volume in mouse stroke models &quot;, JCBFM, 2017_

_H√ºbner et al. &quot;The connectomics of brain demyelination: Functional and structural patterns in the cuprizone mouse model&quot;, NeuroImage, 2017, Volume 146, Pages 1-18_

_Lein et al. &quot;_ _Genome-wide atlas of gene expression in the adult mouse brain__&quot;, Nature, 2006, Volume 445, pages 168-176_

## **License**

Copyright (C) 2017 Stefan Koch &lt; [stefan.koch@charite.de](mailto:stefan.koch@charite.de)&gt; and Philipp Boehm-Sturm &lt; [philipp.boehm-sturm@charite.de](mailto:philipp.boehm-sturm@charite.de)&gt;

ANTX is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

ANTX is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with ANTX. If not, see &lt; [http://www.gnu.org/licenses/old-licenses/gpl-2.0](http://www.gnu.org/licenses/old-licenses/gpl-2.0)&gt;.





