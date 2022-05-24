

<!---
  ANTX2 : tbx, charite,germany



# Construction Site,  started 06-Nov-2019 13:30:16 #
## ...this place is currently under construction, so please do not download in the moment
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

 ===================================================================================================

-->


# ANTx2
ANTx2 stands for **A** tlas **N** ormalization **T** oolbox using elasti **x**. It is a MATLAB toolbox for image registration of mouse magnetic resonance imaging data developed for research laboratories/departments.

<pre>____________________________________________________________________________________________
&#8658; Respository: <a href= "https://github.com/ChariteExpMri/antx2">GitHub:github.com/ChariteExpMri/antx2</a> 
&#8658; Tutorials: <a href= "https://chariteexpmri.github.io/antxdoc/">https://chariteexpmri.github.io/antxdoc/</a> 
&#8658; Templates  : <a href= "https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9">googleDrive:animal templates</a> 
____________________________________________________________________________________________
</pre>

## **Requirements**
- Windows (tested: Windows 10)
- Linux (tested: Ubuntu 16.04.6 LTS, (MINT17/Linuxfx))
- MAC (tested: OS X El Capitan/Catalina)
- MATLAB, all functions were tested for R2015b/16a. Versions above 2018b should work (otherwise please send a mail)

<!---
![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) Inspect [**last changes/updates**](antver.md).<br>
-->
&#9830; Inspect [**last changes/updates**](antver.md).<br>

## Tutorials ##
Tutorials can be found here: https://chariteexpmri.github.io/antxdoc

## Installation ##
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
ADVANTAGE     : more simple installation <br>
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
 - Or type  updateantx(2) in Matlab's CMD-window

### <ins> Download Templates </ins> ###
  Templates are not included in this repository.
  The templates can be downloaded via the ANT interface (Menu: Extras/get templates from googledrive)  
  or manually from [google-drive](https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9).
   
<!---
 or from subfolder "anttemplates" from LINK: https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM 
-->

---
&#9830;  For C57BL/6 mice we suggest to use the latest Atlas from the Allen Institute (Atlas-2017,CCFv3), in googledrive prepared as "mouse_Allen2017HikishimaLR".
- the Atlas (70µm isotropic resolution) includes gray matter regions, fiber tracts and the ventricular system
###### &nbsp; &nbsp; &nbsp; For more information see http://help.brain-map.org/display/mouseconnectivity/API <br> &nbsp; &nbsp; &nbsp; Please visit also the online interactive atlas: http://atlas.brain-map.org/atlas#atlas=1 ######

---
- unzip the downloaded template(s) file
- create a folder "anttemplates" located at the same hierarchical level as the antx2-folder
  (This is easier to obtain the respective template.)
- copy/move unzipped template folder(s) to the "anttemplates" folder. If unzipping creates a nested folder within the unzipped folder, than copy/move this folder.
- The "anttemplates"-folder should now contain a folder (such as "mouse_Allen2017HikishimaLR") with templates.
       
<pre>
  Examplary tree if "mouse_Allen2017HikishimaLR" template is used:
           mydir (directory of your choice)
             |---antx2
             |---anttemplates
                      |---mouse_Allen2017HikishimaLR  
                                   |---AVGT.nii (file)  
                                   |---ANO.nii (file)  
                                   |      ...
                                   |---readme.txt (file)  
 
</pre>         
                   

____________________________________________________________________________________________

## **Users**
Antx/Antx2 was created and is used in the Department of Experimental Neurology at the Charite© - University Medicine Berlin, Germany since 2015.
If you use it and find it useful please give us a note.

## **Included software**

This toolbox uses and included the following packages [SPM](http://www.fil.ion.ucl.ac.uk/spm/), 
[Elastix](http://elastix.isi.uu.nl/), 
[MRIcron](https://www.nitrc.org/projects/mricron),
[PCNN3D](https://sites.google.com/site/chuanglab/software/3d-pcnn), 
[nii](https://de.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image), 
[findjobj](https://de.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects)
[cbrewer](https://de.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab), 
[screen capture](https://de.mathworks.com/matlabcentral/fileexchange/24323-screencapture-get-a-screen-capture-of-a-figure-frame-or-component), 
[windowapi](https://de.mathworks.com/matlabcentral/fileexchange/31437-windowapi).

Note that the templates are not included in this repository and must be downloaded from [google-drive](https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9).
Please consult the respective 'readme.txt' file in each templated folder regarding data origin and citation policiy. 

Please respect the licenses and copyright of these software packages.

<!---
Scripts in the freiburgLight directory using SPM functions underly the GNU General Public License version 2 or (at your opinion) any later version. All other scripts in the FreiburgLight directory are owned by the Department of Radiology, Medical Physics, University Medical Center Freiburg and are free for academic and non-commercial use. Redistribution without consent of Department of Radiology, Medical Physics, University Medical Center Freiburg (contact persons [Marco Reisert](mailto:marco.reisert@uniklinik-freiburg.de) and [Dominik von Elverfeldt](mailto:dominik.elverfeldt@uniklinik-freiburg.de)) is not permitted.
-->

ANTx2 also includes the pvmatlab package of Bruker BioSpin GmbH, which is intended for Bruker users only. Please respect the legal issues in the manual within the pvtools\_bruker directory and request permission to use the package by Bruker&#39;s preclinical MRI software customer support before using ANTx2. Otherwise please delete the directory pvtools\_bruker.


## **Citation policy**
* When using ANTx2 in publications please use the following citation: <br>
  &nbsp; &nbsp; &nbsp; _Koch et al. &quot;Atlas registration for edema-corrected MRI lesion volume in mouse stroke models &quot;, JCBFM, 2017._
* When using the Allen mouse brain atlas please cite: <br>
  &nbsp; &nbsp; &nbsp; _Hübner et al. &quot;The connectomics of brain demyelination: Functional and structural patterns in the cuprizone mouse model&quot;, NeuroImage, 2017, Volume 146, Pages 1-18. <br>
  &nbsp; &nbsp; &nbsp; _Lein et al. &quot;_ _Genome-wide atlas of gene expression in the adult mouse brain__&quot;, Nature, 2006, Volume 445, pages 168-176.

## **License**
Copyright (C) 2019 Stefan Koch &lt; [stefan.koch@charite.de](mailto:stefan.koch@charite.de)&gt; and Philipp Boehm-Sturm &lt; [philipp.boehm-sturm@charite.de](mailto:philipp.boehm-sturm@charite.de)&gt;
ANTx2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version. 
ANTx2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with ANTx2. For more information see http://www.gnu.org/licenses/old-licenses/gpl-2.0.





<!---
[Changes](antver.md)<br>
![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) end  
end
-->