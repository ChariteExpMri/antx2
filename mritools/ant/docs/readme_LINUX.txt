
LINUX: TESTEST FOR UBUNTU-16.04 
1) install ELASTIX v4.7 manually (see below)
2) if needed MRICRON has to be installed manually (see below) 


***************************************************************


### make matlab desktop icon
1) make a new document on desktop and name it 'matlab.desktop'
2) open this dokument with gedit 
3) copyNpaste this: 
[Desktop Entry]
Name=My script
Comment=Test hello world script
Exec="/media/psf/AllFiles/Volumes/q/progs/progs_linux/matlab14/bin/matlab"
Icon=/media/psf/AllFiles/Volumes/q/progs/progs_linux/matlab14/help/install/ug/matlab_icon.png
Terminal=true
Type=Application
Name[en_US]=runMatLAB

4) modify Exec and Icon to your matlab-path  than close gedit
5) open properties of 'matlab.desktop' (contextmenu) and change in Permissions:
   - Access: to Read and write
   -execute: [x] allow executing this programm 

________________________________________________________________________________
#### xdg-open does not open from matlab-cmdline

-see: https://tex.stackexchange.com/questions/62133/texdoc-cant-find-gnome-open-ubuntu-12-04-texlive-2009
Install gnome-open via sudo apt-get install libgnome2-0

#### install ELASTIX & MRICRON
run file "setup_elastixlinux.m"

___________________________________________________________________________
#### or alternative: install mricron manually

1. download mricron from: https://www.nitrc.org/frs/?group_id=152
2. in terminal type: sudo apt install mricron

________________________________________________________________________________
### or alternative: install elastix manually
-tested for Ubuntu 16.04 LTS
1) go to: http://elastix.isi.uu.nl/download_links.php
2) download v4.7  and unzip file 
3) copy: 
   elastix      to: /usr/bin/elastix 
   transformix  to: /usr/bin/transformix
   libANNlib.so to: /usr/lib

  also made a folder 'elastix' in /usr/local/bin/elastix with folders 'bin' (containing:elastix & transformix file ) and 'lib' (containing:libANNlib.so) 
4) set userright for this files ... sudo chmod 777 ???

------------------------------
excelsheets: must be xlsx-files




