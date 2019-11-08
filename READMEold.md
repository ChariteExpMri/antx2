# Important note: read only repository for documentation purposes. This version is no longer maintained, a newer version is available at https://github.com/ChariteExpMri/antx2

# ANTX

ANTX stands for **A** tlas **N** ormalization **T** oolbox using elasti **X**. It is a MATLAB toolbox for image registration of mouse magnetic resonance imaging data developed for research laboratories/departments.

## **Requirements**

- Windows (successfully tested with Windows 7)
- MATLAB (successfully tested with R2015b)

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
- a left listbox to display all mouse-folders, i.e. subfolders in the ëdatí-directory, data of each mouse is stored in its own folder
- a right listbox main warping functions)
- some buttons (with tooltips)
- a menu-bar with functions and instant help if mouse pointer is hovered over a menu-bar-item (functionís help is displayed in the lower help figure)

## **Users**

ANTX was created and is used in the Department of Experimental Neurology at the Charité - University Medicine Berlin, Germany since 2015.

If you use it and find it useful please give us a note.

## **Included software**

ANTX uses the packages [SPM](http://www.fil.ion.ucl.ac.uk/spm/), [elastix](http://elastix.isi.uu.nl/), [mricron](https://www.nitrc.org/projects/mricron), [PCNN3D](https://sites.google.com/site/chuanglab/software/3d-pcnn), [nii](https://de.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image), [cbrewer](https://de.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab), [screen capture](https://de.mathworks.com/matlabcentral/fileexchange/24323-screencapture-get-a-screen-capture-of-a-figure-frame-or-component), [windowapi](https://de.mathworks.com/matlabcentral/fileexchange/31437-windowapi) and the [Allen mouse brain atlas](http://mouse.brain-map.org/), which are included in this repository. Please respect the licenses and copyright of these software packages.

Scripts in the freiburgLight directory using SPM functions underly the GNU General Public License version 2 or (at your opinion) any later version. All other scripts in the FreiburgLight directory are owned by the Department of Radiology, Medical Physics, University Medical Center Freiburg and are free for academic and non-commercial use. Redistribution without consent of Department of Radiology, Medical Physics, University Medical Center Freiburg (contact persons [Marco Reisert](mailto:marco.reisert@uniklinik-freiburg.de) and [Dominik von Elverfeldt](mailto:dominik.elverfeldt@uniklinik-freiburg.de)) is not permitted.

ANTX also includes the pvmatlab package of Bruker BioSpin GmbH, which is intended for Bruker users only. Please respect the legal issues in the manual within the pvtools\_bruker directory and request permission to use the package by Bruker&#39;s preclinical MRI software customer support before using ANTX. Otherwise please delete the directory pvtools\_bruker.

## **Citation policy**

When using ANTX in publications you are obliged to cite the following primary publications:

_Koch et al. &quot;Atlas registration for edema-corrected MRI lesion volume in mouse stroke models &quot;, JCBFM, 2017_

_Hübner et al. &quot;The connectomics of brain demyelination: Functional and structural patterns in the cuprizone mouse model&quot;, NeuroImage, 2017, Volume 146, Pages 1-18_

_Lein et al. &quot;_ _Genome-wide atlas of gene expression in the adult mouse brain__&quot;, Nature, 2006, Volume 445, pages 168-176_

## **License**

Copyright (C) 2017 Stefan Koch &lt; [stefan.koch@charite.de](mailto:stefan.koch@charite.de)&gt; and Philipp Boehm-Sturm &lt; [philipp.boehm-sturm@charite.de](mailto:philipp.boehm-sturm@charite.de)&gt;

ANTX is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

ANTX is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with ANTX. If not, see &lt; [http://www.gnu.org/licenses/old-licenses/gpl-2.0](http://www.gnu.org/licenses/old-licenses/gpl-2.0)&gt;.
