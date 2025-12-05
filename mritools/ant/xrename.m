
%% #bc [xrename] RENAME/DELETE/EXTRACT/EXPAND/COPY file(s) from selected ant-mousefolders
% 
% #wb THESE TAKSKS CAN BE PERFORMED:
% #b - rename file                     (EMPTY)
% #b - copy+rename file                ('copy' or ':')
% #b - delete file                     ('##' or 'del' or 'delete')
% #b - extract (keep 4D image)         (IDX)           #g e.g: '1:3'   | ':'  | '[2 3]'  OR  '2:end-3'
% #b - expand (4D-image to 3D images)  (IDXs)          #g e.g: '1:3s'  | ':s' | '[2 3]s' OR  '2:ends-3'
% 
% #b - change voxel & image resolution ('vr:')         #g e.g.: 'vr: .1 .1 .1'  | 'vr: .1' OR 'vr: nan nan 0.1'
%      ..also the image is changed
% #b - change voxel size onle          ('vs:')         #g e.g.: 'vs: .1 .1 .1'  | 'vs: .1' OR 'vs: nan nan 0.1'
%      ..only the header is changed
% #b - scale image by voxel factor     ('vf:')         #g e.g.: 'vf:3'          | 'vf:1 1 0.5'
%      ..also the image is changed
% #b - change header                   ('ch:')         #g e.g.: 'ch:mat:[1 0 0 1;0 1 0 1;0 0 1 1;0 0 0 1];dt:64'  | 'ch:descrip:hallo' | 'ch:dt:64'
%                                                      % translate volume: 'ch:trans:[1 1.2 1.3]; %(xd,dy,dz in mm)
%                                                      % rotate volume   : 'ch:rot:[0.1 0.1 0.1]; %(xd,dy,dz in radians)
% #b - mathematical operation (masking ('mo:')         #g e.g.: see below
% #b - change dataType                 ('dt:')         #g e.g.: 'dt: 64'  | 'dt:16'
% #b - threshold image                 ('tr:')         #g e.g.: 'tr:i>0.5=0'
% #b - Replace value by another value: ('R:' or 'repl:' or 'replace:') #g e.g.: 'R:<=0;1' | 'R:nan;ME'
% #b - flip image along 1st dim.       (flip:)         #g e.g.: 'flip:' 
% #b - remove volume of 4D-image       (rmvol:)        #g e.g.:  'rmvol:6'; remove volume 6; 'rmvol:[1 4:end]' remove volume 1 and 4,5,6,7..
% #b - operations on 4th dimensions of 4D volume  (mean:)(median:)(mode:)(sum:)(max:)(min:)(std:)(zscore:)(var:)
%                                        #g e.g.: xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean', 'mean:') 
% #b - replace Nifti-Header            ('rHDR:')        #g e.g.: header is replaced by a reference file (refference file is tagged as 'ref' in the 3rd column) 
% #b - replace Nifti-mat               ('rmat:')        #g e.g.: NIfti-HDR-mat is replaced by a reference file (refference file is tagged as 'ref' in the 3rd column) 
% #b - gzip Nifti-file                 ('gzip:')        #g e.g.: 'gzip:'
% #b - gunzip Nifti-file               ('gunzip:')      #g e.g.: 'gunzip:'
% #b - apply function to NIFTI         ('niifun:')      #g e.g.: 'niifun:myfunc.m' % to apply function 'myfunc.m' on sleected NIFTIfile
% 
% #r The functions 'XRENAME' and 'XOP' (lowercase) are identical, XOP is a wrapper-function of XRENAME)
% 
% 
% % __________________________________________________________________________________________________________________
% - select one/several images TO RENAME/DELETE/EXTRACT/EXPAND/COPY volumes,aka. files
% - dirs:  works on preselected dirs (not all dirs), i..e mouse-folders in [ANT] have to be selected before
% - 'newname'-column contains the new filename (file-extension is not needed)
% - copy   a file: type 'copy' or ':'in the [TASK]-column
% - delete a file: type '##','del' or 'delete' in the [TASK]-column
%                  or type "##" in the '[NEWNAME]-column
%  - file-deletion: in case of errornous deletion --> deleted files are temporally stored in the recycle-nin
% __________________________________________________________________________________________________________________
% #yg GUI-USAGE________________________________________________
%
%% #lk NEW FILENAME-COLUMN
% -enter a new filename here, for NIFTI-file(s) no file-extension (.nii) needed
% -alternatively you can define a PREFIX or SUFFIX here which will be appended to the input-filename:
% -for #b PREFIX: #n :'p:myprefix', where 'myprefix' is the prefix to add.
%              EXAMPLE: 'p:bla_'  if the input-image is 'v1.nii' the output-file is 'V_bla.nii'
%              commandline example to copy and rename a file:  xrename(1,'v1.nii','p:bla_',':'); 
% -for #b SUFFiX: #n : 's:mysuffix', where 'mysuffix' is the prefix to append.
%              EXAMPLE:  's:_blob'  if the input-image is 'v1.nii' the output-file is 'v1_blob.nii'
%              commandline example to copy and rename a file: xrename(1,'v1.nii','s:_blob',':');   
% #r -IF the FILENAME-COLUMN is EMPTY the original file will be overwritten !!!
% 
%% CONTEXT MENU
% Select a file/several files from first column and use the #b context menu.
% The options from the context menu can be used to fill the 2nd (new name) and 3rd column (task)
% #r WARNING: If you select several files be carefull because renaming/expanding several files from
% #r the same directory with the same output-filename will be subsequently overwritten by the new file.
% -----------------------------------
% #k From the context menu you can chose:
% #k 'enter 2nd & 3rd column extended': #n for selected file(s) allows to fill the 2nd column and 3rd column
%   - allows to select (i.e. use) already filled input from then 2nd or 3rd column
%   - this is the easiest way to fill columns 2 and 3
%   #r - see warning
% #k 'copy & rename file' : #n copy and rename selected file(s) ...the file is copied and then renamed
%   #r - see warning
% #k 'rename file'        : #n rename selected file(s) ...the file is renamed
%   #r - see warning
% #k 'clear all fields'   : #n just clears all fields in 2nd and 3rd column
% #k 'delete file'        : #n delete selected file(s) ...this files will be permanently removed
% #k 'show  info'         : #n show file information (file paths; existence of files; header information)
%
%
%% #by RENAME FILES
%     - type a new name in the [NewName] column (but not "##" this would delete the file)
%     - the [TASK]-column must be empty or type "rename"
%% [RENAME]: rename "T2_TurboRARE.nii" to "t2.nii"
%% -----------------------------------------------------------
%%       [FileName]    [NewName]           [TASK]
%% T2_TurboRARE.nii       t2.nii                               !! the new file name is "t2.nii"
%%  or
%% T2_TurboRARE.nii       t2.nii            rename             !! the new file name is "t2.nii"
%__________________________________________________________________________________________________________________
%% #by COPY FILES
%     - in the [NewName]-COLUMN type a file-name (but not "##" this would delete the file)
%     - the [TASK]-column must contain ":" (the ":" means take all containing volums) or
%       type "copy"
%% [example COPY]: copy T2_TurboRARE.nii and name it "t2.nii"
%%         [FileName]    [NewName]            [TASK]
%% T2_TurboRARE.nii       t2.nii                 :            !! use ":" to copy the file
%%  or
%% T2_TurboRARE.nii       t2.nii               copy           !! use "copy" to copy the file
%__________________________________________________________________________________________________________________
%% #by DELETE FILES
%    - in the [NewName]-COLUMN type "##"  or "delete"  (without "); the [TASK]-column is empty
%    - or: [NewName] is empty and  [TASK]-column contains "##"
%
%% [examples]: delete "T2_TurboRARE.nii"
%%       [FileName]      [NewName]            [TASK]
%% T2_TurboRARE.nii       _##                                      !! use "##", to delete the volume
%% T2_TurboRARE.nii       delete                                   !! type delete, to delete the volume
%% T2_TurboRARE.nii                             ##                 !! type delete, to delete the volume
%% T2_TurboRARE.nii                             del                !! type delete, to delete the volume
%% T2_TurboRARE.nii                             delete             !! type delete, to delete the volume
%__________________________________________________________________________________________________________________
%% #by EXTRACT 3D-volumes
%   extract 1/more volumes from 4D volume and save as 3D or 4D-volume
%   - a new filename in the [NEWNAME]-column must be given (do not use '##'  ..this would delete the orig. file)
%   - in the [Task]-column -type matlabstyle-like index-indications to extract the respective volume(s):
%    EXAMPLES:  single volume   :  "1" or "2" or "5" or "end"   ... to extract the 1st or 2nd or 5th or last single volume
%               multiple volumes: "2:3" or "5:end-1" or ":"     ... extract multiple volumes, here either 2nd & 3rd vol, or 5th to last-1 vol or all vols
%                                  "[2 4 10]" or "[end-3 end]"    ... extract multiple volumes, here either 2nd & 4th & 10th vol, or from the last-3 to the last vol
%    --> for concatenation, don't forget brackets (matlabstyle)
%    OUTPUT: extracted file (either 3d or 4d) with filename from [NEWNAME]-column
%
%% [example EXTRACT]: extract volumes 3 to 6 from "DTI_EPI_seg_30dir_sat_1.nii" and save this as "new.nii" (4d-nifti):
%% ------------------------------------------------------------------------------------------------------------
%%                  [FileName]    [NewName]         [TASK]
%% DTI_EPI_seg_30dir_sat_1.nii      new.nii             3:6          !! note, this creates one (!) 4d volume containing the volumes 3-to-6
%% ----------------------------------------------------------------
%__________________________________________________________________________________________________________________
%% #by EXPAND FILES
% #r EXPAND: expands a 4d-volume into separate 3d-volumes
%    -new filename in the [NEWNAME]-column must be given (but not '##'  ..this would delete the orig. file)
%     in the [TASK]-COLUMN -type the matlabstyle-like index-indications to expand the respective volume(s) and add a "s"
%     EXAMPLES: single volume   : "1s" or "2s" or "5s" or "ends" (or "end s")   ... to expand the 1st or 2nd or 5th or last single volume
%               multiple volumes: "2:3" or "5:end-1" or ":"     ... expand multiple volumes, here either 2nd & 3rd vol, or 5th to last-1 vol or all vols
%                                  "[2 4 10]" or "[end-3 end]"    ... expand multiple volumes, here either 2nd & 4th & 10th vol, or from the last-3 to the last vol
%       --> don't forget brackets (matlabstyle) IF NEEDED
%       --> for concatenation, don't forget brackets (matlabstyle) IF NEEDED
%       --> don't forget to put the "s" tag somewhere (with/without spaces) in the [TASK]-COLUMN
%    OUTPUT: extracted file(s) have always 3dims with the filename from [NEWNAME]-column and a numeric index which volume was expanded
%    EXAMPLES:  "1s"      ... newname_001.nii,                "5s" ... newname_005.nii
%               "2:3"     ... newname_002.nii,newname_003.nii
%               "[2 4 6]" ... newname_002.nii,newname_004.nii,newname_006.nii
%               "[end-3:end]" ... newname with respective numbers of the orig 4dim-volumes of the last three volumes
%
%
%% [example EXPAND]: expand volumes 1:10 from "DTI_EPI_seg_30dir_sat_1.nii" and save volumes as "new_xxx.nii", where xxx is the number of the volume
%% ------------------------------------------------------------------------------------------------------------
%%                  [FileName]    [NewName]         [TASK]
%% DTI_EPI_seg_30dir_sat_1.nii      new.nii            1:10s         !! note the "s", this is mandatory to expand the [s]lices 1-10
%% ---------------------------------------------------------------
%__________________________________________________________________________________________________________________
%__________________________________________________________________________________________________________________
%% #by DELETE FILES
% delete one file, use '##' or 'del' or 'delete' in task-column (or 4th argin via comand)
% xrename(0,'w5_w6.txt','','delete'); %delete ''w5_w6.txt' in all selected animals
% xrename(0,'w5_w6.txt|w6.txt','','##') ;% delete two files ('w5_w6.txt' and 'w6.txt') ...
% 
% delete files starting with 'w5_w6' or 'w6'
% xrename(0,'^w5_w6.*.txt|^w6.*.txt','','##') ;
% 
% delete file ending with '_w6.txt'
% xrename(0,'_w6.txt$','','##') ;
% 
%  delete file ending with '_w6.txt' or 'w5.txt'
% xrename(0,'_w6.txt$|w5.txt$','','##') ;
% 
%% #by REPLACE VALUE BY ANOTHER VALUE
% Replaces in a 3D/4D image a specific values by another value
% - TAG: 'R:' or 'repl:' or 'replace:'
% - ARGs: INPUTVALUE SEMICOLON REPLACING-VALUE
%  ARGs-EXAMPLES: 
% 'R:0;ME'          replace zeros with Normally distributed data with mean and STD of the image                       
% 'R:<0;ME'         replace values below 0 with Normally distributed data with mean and STD of the image                  
% 'R:<=0;MED'       replace values below 0 with Normally distributed data with median and STD of the image                                            
% 'R:<=0;3'         replace values below 0 with value 3                  
% 'R:0;nan'         replace zeros with NaN                  
% 'R:nan;5'         replace NANs with value 5                  
% 'R: inf;7'        replace INFs with value 7                    
% 'R: >0;100'       replace values above 0 with value 100                   
% 'R: >=0;100;'     replace values equal/above 0 with value 100                        
%  EXAMPLES: 
%  xrename(1,'v4D3.nii','v4D3_mod.nii','R:<40;1'); % replace values<40 with 1 in image 'v4D3.nii' and store as 'v4D3_mod.nii'
%  xrename(1,'v1.nii','v1_0.nii','R:0;ME');        % replace zeros with data with mean and STD of the image in 'v1.nii' and store as 'v1_0.nii' 
% 
%% #by Threshold Image (tr:)
% threshold image and save as new file
% filled task code in column-3, EXAMPLES:
%    'tr: i>3=0'        threshold image, values above 3 are set to 0
%    'tr: i<3=0'        threshold image, values below 3 are set to 0
%    'tr: i <=4=0'      threshold image, values <=4 are set to 0
%    'tr: i >=4=0'      threshold image, values >=4 are set to 0
%    'tr: i ~=0=1'      threshold image, nonzero values are set to 1
%    'tr: i<0=3; i>6=6' threshold image, values<0 are set to 3 and values>6 are set to 6
%
% #k Combined thresholds (such as 'tr: i<0=3; i>6=6; ) will be executed from left to right and
% #k must be separated by semicolon
% #m see contextmenu/"enter 2nd & 3rd column extended" for examples (there: column-3 pulldown menu)
% #r Don't forget to specify an output filename in the 2nd-column, otherwise the input file is overwritten!
% #g CMD:  example: threshold image ('INPUT.nii'), values <0.7 set to 0, file stored as 'OUTPUT.nii'
%     xrename(1, 'c2t2.nii' , 'zzz' , 'tr: i<.7=0');  % 1st arg indcates that GUI is poping up when executed
%% #by Change data type (dt:)
% change datytype and save as new file
% example: change 't2_64.nii' to dataType 16 ('float32', see help of spm_type) and save as 't2_16.nii'
% z=[];
% z.files =  { 't2_64.nii' 	't2_16.nii' 	'dt:16' };
% xrename(0,z.files(:,1),z.files(:,2),z.files(:,3));
%__________________________________________________________________________________________________________________
%
%% #by MATHEMATICAL OPERATIONS (ma:)
% SIMPLE MATHEMATICAL OPERATIONS CAN BE Done using the [TASK]-column
% examples: threshold image, extract ROI from atlas image, combine mask(s) with image etc.
% #k used CONVENTIONS:
% #k  'mo: '      .. use 'mo:' to indicate a math operation,
% #k  'i'         .. is the internal input image,
% #k  'i+number'  .. refers to another image  in the [TASK]-column; (the respective images must be indicated with 'i+number' ...see examples)
% #k  'o'         .. is the internal output image
% #k  'dt'        .. <optional>; use 'dt=number' to set the datatype of the stored image ...see spm_type
% #k  structure:   is allways:  'mo: o=...do something with i and or combine with i1/i2...etc '
% #g EXAMPLES:
% #r NOTE the columns in z.files correspond to 'FileName', 'NewName' and 'TASK'-columns in the GUI-TABLE!
% ==============================================
%%  #g get right Striatum-mask of SIGMA-RAT atlas (striatum: id=73) via 'AVGThemi.nii' (internally refered via 'i1')
%%  #g and save file as 'striatum_Right.nii'
% z.files={ 'ANO.nii' 	'striatum_Right.nii' 	'mo: o=(i1==2).*(i==73);'
%          'AVGThemi.nii' 	'' 	  'i1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
% ==============================================
%%   #g recode left/right Striatum of SIGMA-RAT atlas (id=73); store with datatype=2 ('dt=2')
% z.files={ 'ANO.nii' 	'striatum_newID.nii' 	'mo: o=(i1==1).*(i==73)*3; o=o+(i1==2).*(i==73)*4; dt=2;'
%          'AVGThemi.nii' 	'' 	  'i1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
% ==============================================
%%  #g  mask 'x_t2.nii' with 'AVGTmask.nii', here 'AVGTmask.nii' is internally refered as 'i1'
%%  #g i.e. multiply all voxels larger than 0 with 'x_t2.nii'
% z.files={ 'x_t2.nii' 	'x_t2Masked.nii' 	'mo: o=(i1>0).*i;'
%          'AVGTmask.nii' 	'' 	         'i1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
% ==============================================
%% #g threshold 't2.nii' with thresholded GM- and WM-segmentation images'
%% #g i.e.  threshold GM and WM independently at 0.3, add both masks and make all values above 0 1, than
%% #g multiply with 't2.nii' and store as 't2Masked.nii'
%% #g  note that GM and WM are internally referenced via i1 and i2
% z.files={ 't2.nii' 	't2Masked.nii' 	'mo: o=(((i1>0.3)+(i2>0.3))>0).*i;'
%          'c1t2.nii' 	'' 	         'i1'
%          'c2t2.nii' 	'' 	         'i2' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
%
%__________________________________________________________________________________________________________________
%% #by remove volume(s) from 4D volume  (rmvol:)
% example
% remove vol-Nr 6 from 'test_revDtiEpi_5_1.nii', save new file 'test_revDtiEpi_5_1_corrected.nii' (using suffix-tag)
% xrename(1,'test_revDtiEpi_5_1.nii','s:_corrected' ,'rmvol:6')
%
% same as above but remove all volumes >2
% xrename(1,'test_revDtiEpi_5_1.nii','s:_corrected' ,'rmvol:3:end')
% 
%__________________________________________________________________________________________________________________
%% #by operations over 4th dimensions of 4D volume  (mean:)(median:)(mode:)(sum:)(max:)(min:)(std:)(zscore:)(var:)
% the output is a 3D-NIFTI-file
% 
% examples:
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'T2mean.nii', 'mean:')     ;% mean over all volumes of 4th-DIM: save as 'T2mean.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean',    'mean:')     ;% mean over all volumes of 4th-DIM: save file as 'T2map_MSME_CRP_2_1_mean.nii' (add suffix '_mean')
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean', 'mean:1 3')     ;% mean over volumes [1,3] over 4th-DIM: adding suffix '_mean'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean', 'mean:1:4')     ;% mean over volumes [1,2,3,4] over 4th-DIM: adding suffix '_mean'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean', 'mean:1:end')   ;% mean over all volumes over 4th-DIM: adding suffix '_mean'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'s:_mean', 'mean:1:end-1') ;% mean over all volumes except the last one over 4th-DIM: adding suffix '_mean'
% 
%__ the below examples work also with when assigning specific indices/volumes (see above examples)
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'median:');% median over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'mode:')  ;% mode/most frequent value over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'sum:')   ;% sum over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'max:')   ;% maximum over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'min:')   ;% minimum over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'std:')   ;% standard-deviation over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'zscore:');% zscore over all vols of 4th dimension, save as 'dum.nii'
% xrename(0,'T2map_MSME_CRP_2_1.nii' ,'dum', 'var:')   ;% variance over all vols of 4th dimension, save as 'dum.nii'
% 
%__________________________________________________________________________________________________________________
%% #by voxel resolution (vr:)
% change voxel resolution of an image via  the [TASK]-column
% IMPORTANT: HERE THE IMAGE WILL BE CHANGED wrt the new voxelsize!!!
% example: in [TASK]-column type :  "vr: .1 .1 .1" to change the voxel resolution of an image (previous vox resolution was: [.09 .09 .09])
%          "vr: .1 .1 .1"  this is identical to "vr: .1"
% #g change voxel resolution of 'AVGT.nii' to [.1 .1 .1] and save as 'test33.nii'
% z.files={ 'AVGT.nii' 	'test33.nii' 	'vr: .1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
%__________________________________________________________________________________________________________________
%% #by voxel size (vs:)
% set voxel size of an image via  the [TASK]-column
% IMPORTANT: ONLY THE VOXELSIZE IN THE HEADER IS CHANGED (IMAGE IS NOT CHANGED)!!!
% example: in [TASK]-column type :  "vs: .1 .1 .1" to set the voxel size of an image (previous vox resolution was: [.09 .09 .09])
%          "vs: .1 .1 .1"  this is identical to "vs: .1"
% #g set voxel size to [.07 .07 .1] and save as 'v1Z.nii' 
% xrename(1,'v1.nii','v1Z.nii','vs: .07 .07 .1');
% set voxel size of the 2nd dimension to 0.07 preserve vox size of dim1 and dim3 and save as 'v1Z.nii' 
% xrename(1,'v1.nii','v1Z.nii','vs: nan .07 nan');
% 
%__________________________________________________________________________________________________________________
%% #by change header (ch:)
% change header using eather a reference file or a transformation-matrix or header of selected-file
% story as a new file (new name as specified in column-2 /2nd input argument ...or empty to change the original file!!!)
% - if no reference file or transformation-matrix is given, you can change:
%         the dataType, make dimensional flips or add a header-description
% - dimensional flips : flip left/right; up/down and/or anterior/posterior
% - description       : add a header description (string)
% - datatype          : change data type of the NIFTI-image
% #m WORKING WITH THE GUI:
% #b FIRST SELECT THE IMAGE (COLUMN-1), THAN use CONTEXTMENU/CHANGE HEADER
%
% #m COMMAND LINE EXAMPLES:
%% =====[change header example-1]==========================================
%% replace header of "mag.nii" using header of local image ("05_epi_mrexp2.nii"), write description "QR3"
%% and save as "test2.nii".
%% IMPORTANT: "05_epi_mrexp2.nii" must be located in the respective animal folder
%   z=[];
%   z.files =  { 'mag.nii' 	'test2.nii' 	'ch:image:05_epi_mrexp2.nii;descrip:QR3' };
%   xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%% =====[change header example-2]==========================================
%% replace header of "mag.nii" using header of external image ("F:\data5\nogui\misc\_refIMG.nii"),
%% flip dimensions dim-1 and dim-2, write description "flipped", change datatType to 64
%% and save as "test2.nii".
%% IMPORTANT: "_refIMG.nii" is not located in the animal-directory, therefore the replaced header is identical
%% for the 'mag.nii'-images of all selected animals
%   z=[];
%   z.files =  { 'mag.nii' 	'test2.nii' 	'ch:image:F:\data5\nogui\misc\_refIMG.nii;flipdim:[1 2];dt:[64];descrip:flipped' };
%   xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%% =====[change header example-3]==========================================
%% replace header of "mag.nii" using transformation matrix 'mat'; , change datatType to 64
%% and save as "test2.nii"
%   z=[];
%   z.files =  { 'mag.nii' 	'test2.nii' 	'ch:mat:[1 0 0 1;0 1 0 1;0 0 1 1;0 0 0 1];dt:64' };
%   xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%% =====[change header example-4]==========================================
%% flip dimension dim-2 of image 'mag.nii' and save as "test2.nii".
%   z=[];
%   z.files =  { 'mag.nii' 	'test2.nii' 	'ch:flipdim:[2]' };
%   xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%% =====[change header example-5]==========================================
%% flip dimension dim-2 of image 'mag.nii' and save as "test2.nii".
%   z=[];
%   z.files =  { 'mag.nii' 	'test2.nii' 	'ch:flipdim:[2]' };
%   xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%% =====[change header example-6]==========================================
%% replace header of "t2_copy.nii" using transformation matrix 'mat', save changes in original image
%% IMPORTANT: here the header of the original image is changed (2nd arg is empty)
%   z=[];
%   z.files =  { 't2_copy.nii' 	'' 	'ch:mat:[1 0 0 1;0 1 0 1;0 0 1 1;0 0 0 1];' };
%   xrename(0,z.files(:,1),z.files(:,2),z.files(:,3));
% 
%% =====[change header-7:  translate object]==========================================
% xrename(0,'t2.nii','t2_translated.nii','ch:trans:[1 0.2 0.3];');  %translated object by [dx,dy,dz] mm (here: 1,0.2,0.3 mm)
% 
%% =====[change header-8:  rotate object]==========================================
% xrename(0,'t2.nii','t2_rotated.nii'   ,'ch:rot:[0.1 0.1 0.1];');  %rotate object by [dx,dy,dz] radians, (here: 0.1,0.1,0.1 radians)
% 
%
%__________________________________________________________________________________________________________________
%% #by replace Nifti-Header (rHDR:)
% A reference-file is needed, tagged with 'ref' in 3rd-column.  Here, the HDR of 'test3.nii' is
% replaced by HDR of 'test2.nii' (tagged with 'ref') and result is saved as 'bla.nii'
%     z=[];
%     z.files =  { 'test3.nii' 	'bla.nii' 	'rHDR:'
%                  'test2.nii' 	''   	    'ref'  };
%     xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%__________________________________________________________________________________________________________________
%% #by replace Nifti-mat (rmat:)
% A reference-file is needed, tagged with 'ref' in 3rd-column.  Here, the HDR of 'adc.nii' is
% replaced by HDR of 'adc2.nii' (tagged with 'ref') and result is saved as 'bla.nii'
%     z=[];
%     z.files =  { 'adc.nii' 	'bla.nii' 	'rmat:'
%                  'adc2.nii' 	''   	    'ref'  };
%     xrename(1,z.files(:,1),z.files(:,2),z.files(:,3));
%__________________________________________________________________________________________________________________
%% #by zip Nifti-file (gzip:)
%     xrename(1,'test3.nii' ,	'test3.nii' ,	'gzip:')
% same as
%     xrename(1,'test3.nii' ,	'test3' ,     	'gzip:')
%     xrename(1,'test3.nii' ,	'test3.nii.gz',	'gzip:')
%__________________________________________________________________________________________________________________
%% #by unzip Nifti-file (gunzip:)
%     xrename(1, 'test3.nii.gz' ,	'test3.nii' ,	'gunzip:')
%__________________________________________________________________________________________________________________
%% #by apply function to NIFTI (niifun: functionname) 
% a function can be applied to a NIFTI-file (arbitrary function name)
% structure of the function:
% function [ha a]=myfunc(ha,a)    
%    with inputs : ha: header of NIFTI, a =3D/4D-vol array
%    with outputs: ha: header of NIFTI, a =3D/4D-vol array 
% header and array manipulation can be made here
% ---- example of myfunc.m --------
% function [ha a]=myfunc(ha,a)
% a=a*3;
% disp('multiply by 3');      %multiply values by factor 3
% a=imdilate(a,ones(10,10));  %dilate mask
% disp('dilate mask');
% -----------------------------  << save as 'myfunc.m' in the study's main folder
% 
% funcname='F:\data8\schoenke_2dregistration\myfunc.m'
% xrename(1,'ADCmask.nii' ,	'test.nii',	['niifun:' funcname ]);
%   
% or function''s shortname if 'myfunc.m' is located in the study's main dir or in the subfolder 'code' 
% or 'codes' in the study folder:
% xrename(1,'ADCmask.nii' ,	'test.nii',	'niifun:myfunc.m');
%                          

%__________________________________________________________________________________________________________________
%% #by voxel scaling (vf:)
% change voxel scaling of an image via  the [TASK]-column
% this will scal up an image ...PURPOSE: scale up an image ba factor 10 to use software tools for human brain (and it's resolution)
% example: in [TASK]-column type :  "vf: 10 10 10"  or 'vf: 10' to scale up the brain in x,y,z-direction by factor 10
% #g inflate 'AVGT.nii' by voxel fator 1.5,1.5 and 1 in  x,y,z direction and store as 'inflated'
% z.files={ 'AVGT.nii' 	'inflated.nii' 	'vf: 1.5 1.5 1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
%__________________________________________________________________________________________________________________
%
% #r -----simple examples------
% #g  to rename  a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [TASK]-COLUMN is empty
% #g  to copy    a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [TASK]-COLUMN  is ":"  (without "")
% #g  to delete  a file:  name in [NEWNAME]-column  is '##'
% #g  to extract a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [TASK]-COLUMN is something like "1", "2","1:3","end","end-1:end",":" (without "")
% #g  to expand  a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [TASK]-COLUMN is something like "1s", "2s","1:3s","ends","end-1:ends",":s" (without "")
%
%% #r NOTE: DIFFERENCE OF EXTRACTION AND EXPANSION
% INPUT:
%       -expansion differs from extraction only, that for expansion the 's' tag is added in the [TASK]-COLUMN
% OUTPUT:
%  -extraction : extracts one or more volumes from a 3 or 4dim volume (of course one canot extract more than one volume from a 3d-volume-file)
%                and writes this as a 3 or 4dim volume with the filename specified in  [NEWNAME]-column
%  -expansion: same as extraction but (1) writes each volume as 3d-volume separately using the
%               filename as specified in [NEWNAME]-column with suffix, which volumeNumber was taken
%               from the original file
% #bc REMINDER:
%        - RENAMING: files are really renamed (no local copies with new file-names will be created)
%        - ony those files are treated from those folders that have been selected in the [ANT]-gui mouse-folder listbox
%          thus, check the occurence of the specific file (see [#count]-column)
%        - there is no priority in renaming the file, thus in some cases it might be better to call this
%         function sEveral times: for example: if A and B files exist in a folder or in several folders and you want to swap the names such that
%           file-A becoms file-B and vice versa.'];
%           in such case: {1} call this function and rename file-A to file-ADUMMY, and  file-B to file-BDUMMY  (ADUMMY/BDUMMY are just non-existing,new names in the folder)
%                         {2} call this function AGAIN (!) and rename file-ADUMMY to file-B, and  file-BDUMMY to file-A'
% #yb GUI-COLUMNS
%  #r 1st column: the original-filename
%  #r 2nd column: NEW-FILENAME:  type a new filename here, if so, this file will be really(!) renamed
%     - no file-extension needed
%     - you can rename as many files as you like
%     - if column-2 is empty this equals cancelling the process
%     - the filename from column-1 can be copied (ctrl+c) and pasted(ctrl+v) in column-2 (to modify it..)
%     - additional option: [##] will delete the file  (2-hash-signs without brackets)
%  #r 3rd column: EXTRACT-VOLNUM:  FOR VOLUME EXTRACTION OR VOLUME EXPANSION:
%      - strings such as "1" , "2" , "1:3" , "end" ,"2:5" , "end-1:end" , ":"   (without ""!)- TO EXTRACT THIS VOLUMES
%      - strings such as "1s", "2s", "1:3s", "ends","2:5s", "end-1:ends", ":s"  (without ""!)- TO EXPAND THIS VOLUMES
%
%  #r columns 4-7 gives additional information:
%    [#found]: how often is this file found across selected mouse-folders in [ant]-gui
%            -again: appropriate mousefolders in ANT-gui must be selected in advance
%    [Ndims]      : number of dimensions,i.e. 3 or 4 dims
%    [size]       : number of [x,y,z]-voxels, and in case of a 4d-volume,also the number of volumes (size of 4th.dimension)
%    [resolution] : [x,y,z]-voxel-resolution
% __________________________________________________________________________________________________________________
%% #yg NON-GUI-definitions:
%
% function xrename(showgui,fi,finew)
% showgui: (optional)  :  0/1   :no gui/open gui
% fi     : (optional)  :string (single) or cell (multiple) existing filenames to rename
% finew  : (optional)  :string (single) or cell (multiple) new filenames,
%          -'finew' must be specified if 'fi' is specified
%          -same size/declarationtype of 'fi' and 'finew'
%          -'fi' and 'finew' : must correspond ONE TO ONE  !!!
% __________________________________________________________________________________________________________________
%% #yg BATCH EXAMPLES
% #g RENAMING-EXAMPLE
%      xrename                                           %open gui
%      xrename(1);                                       %open gui
%      xrename(1, 'vol5.nii' , 'vol7.nii' )            %open gui, preselect: 'vol5.nii' should be renamed to  'vol7.nii'
%      xrename(1,{'vol5.nii'},{'vol7.nii'})            %same as above
%      xrename(1,{'vol5.nii' 'vol6.nii'},{'vol7.nii' 'vol8.nii'})    %open gui, preselect: 'vol5.nii' should be renamed to  'vol7.nii', and 'vol6.nii' renamed to  'vol8.nii'
%      xrename(1,{'vol5.nii' 'vol6.nii'}',{'vol7.nii' 'vol8.nii'}')  %same..
%      xrename(0,{'vol5.nii' 'vol6.nii'}',{'vol7.nii' 'vol8.nii'}')  %same,but without opening GUI
%      xrename(0, 'blob3.nii'  , 'blob4.nii' ,'rename' ); % 'blob3.nii' it renamed to 'blob4.nii'
% #g COPYING-EXAMPLE
%     % make a copy of c_nan_2.nii , named hausboot.nii
%    xrename(1, 'c_nan_2.nii' ,	'hausboot'   ,	':' )
%    xrename(0, 'bla.nii'     ,  'blob3.nii' ,  'copy' );  % 'bla.nii' is copied as 'blob3.nii'
%
% #g DELETION-EXAMPLE
%     xrename(1, 'vol5.nii' , '##' )
%     xrename(0, 'blob3.nii' ,   'delete'  );
%     xrename(1,'^prc_*|^rc_*|^c_*','','del'); % with GUI-preselection: delete all NIFTs starting with "prc_"/"rc"/"c"
%     xrename(0,'^prc_*|^rc_*|^c_*','','del'); % no GUI: delete all NIFTs starting with "prc_"/"rc"/"c"
%
% #g EXTRACTION-EXAMPLE  "extract one volume"
%    %[example-1]: extract 9th volume from [MSME-T2-map_20slices_1.nii] and save as [M.nii]
%                  xrename(1, 'MSME-T2-map_20slices_1.nii' , 'M' ,9)  ;
%
%    %[example-2]: extract 9th volume from [MSME-T2-map_20slices_1.nii] and save as [x1.nii] and also ...
%                  extract 3rd volume from [msme2neu_1.nii]             and save as [x2.nii]
%                  xrename(1, {'MSME-T2-map_20slices_1.nii' 'msme2neu_1.nii'}, {'x1' 'x2'} ,[9 3]);
%
% #g EXTRACTION-EXAMPLE  "extract several volumes"
%    %[example-1]: extract vols 1-3 from [MSME-T2-map_20slices_1.nii]  and write as [x1.nii] and...
%    %             extract vols 3   from [c_nan2neu_2]                 and write as [x2.nii]
%                  xrename(1, {'MSME-T2-map_20slices_1.nii' 'c_nan2neu_2.nii'}, {'x1' 'x2'} ,{'1:3' '3'})
%
%    %[example-2]: extract last-1 and last vols from [MSME-T2-map_20slices_1.nii]  and write as [x1.nii] and...
%    %             extract all vols            from [c_nan2neu_2]                 and write as [x2.nii]
%                 xrename(1, {'MSME-T2-map_20slices_1.nii' 'c_nan2neu_2.nii'}, {'x1' 'x2'} ,{'end-1:end' ':'})
%
% #g MIXED-RENAMING-EXTRACTION-EXAMPLE
%    %[example-2]: extract 7-9th volumes from [X.nii] and save as [x.nii] and also ...
%    %             extract 3rd volume from [Z.nii] and save as [z.nii] , but
%    %             rename [Y.nii] as [y.nii] (doesn't matter what Y.nii is)
%     xrename(1, {'X.nii' 'Y.nii' 'Z.NII'}, {'x' 'y' 'z'} ,[7-9 0 3]);
%
% #g EPANSION-EXAMPLE  "expand volumes from several files" (dont forget the "s" tag)
% %             expand the 3rd volume from msme2neu_1.nii and                  -->write as x1_003.nii
% %             expand all volumes from c_nan2neu_2.nii starting from 3rd vol  --> x2_003.nii/x2_004.nii...x2_"last volume as number".nii
%    xrename(1, {'msme2neu_1.nii' 'c_nan2neu_2.nii'}, {'x1' 'x2'} ,{'3s' '[3:end s]'})
%
%
% ==============================================
%%    wildcards
% ===============================================
% use ".*" wildcard, optional "^"/"$" for start/ending string
% xrename(1,{'^.*.doc'},{},{'del'});  %delete all doc-files
% xrename(1,{'^.*.doc'},{'newdoc.doc'},{':'}); %make copy of all docfiles...call it 'newdoc.doc'
% xrename(1,'anatomy_axial.*.nii','t2.nii','1s'); %extract 1st volume
% xrename(1,'^B0Map'      ,'NEW.nii',':');   %copyNrename NIFTI(s) starting with "B0Map"
% xrename(1,'sat_4_1.nii$','NEW.nii',':');   %copyNrename NIFTI(s) ending with "sat_4_1.nii"
% 
%% copy and rename all files containg '.*_pd_.*1.nii' to  'PD_mag.nii' and files containing
%% '.*_pd_.*3.nii' to 'PD_phase.nii'
% xrename(0,{'.*_pd_.*1.nii' '.*_pd_.*3.nii'},{'PD_mag.nii' 'PD_phase.nii'},':');
%% delete all files containing '.*_mag.nii' or '.*_phase.nii'
% xrename(0,{'.*_mag.nii' '.*_phase.nii'},{'##','##'});
%% shrter version: delete all files containing '.*_mag.nii' or '.*_phase.nii' 
% xrename(0,'.*_mag.nii|.*_phase.nii','##')
% ==============================================
%%    optional pairwise inputs
% ===============================================
% dir : fullpath dirs (cellarray) to perform the task
% flt : file-filter; default: '.*.nii'  so select only from nifti-files
%     -examples:
%       xrename(1,{},{},{},'flt','.*.txt');
%       xrename(1,{},{},{},'flt','.*.xlsx|.*xls');
%    ! please use no file-filter if you have a preselection of files!
%
%% SHOW ALL FILES IN GUI
% xrename(1,'.*','','')  
% xrename(1,'.*')   ; % same
% __________________________________________________________________________________________________________________
%
%% #yg BATCH EXAMPLE-II   [xrename.m]
%% EXAMPLE 1: delete a file, rename a file and rename another file
% z.files=[];
% z.files={ 'vol.nii' 	     '##'               %% this file is deleted
%           'vol5.nii' 	'vol10.nii'        %% 'vol5.nii'  is renamed to 'vol10.nii'
%           'vol6.nii' 	'vol11' };         %% 'vol6.nii'  is renamed to 'vol11.nii'  (NOTE: 2nd column,i.e. the new name list, does not need file extension)
% xrename(1,z.files(:,1),z.files(:,2));         %% run function with opening gui
%
%% EXAMPLE 2:  rename a file and copy another file
% z=[];
% z.files={ 'XX.nii' 	'XXrenamed.nii'  ''          %  "XX.nii" is renamed to  "XXrenamed.nii"
%           'YY.nii' 	'YYcopied.nni' 	 ':'    };   %  "YY.nii" is copied to  "YYcopied.nii"
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
%
%
%
% #ok NO GUI (silent mode)
% using cell of animal-dirs as extra input ("an.mdirs");
%% [1] copy&rename 'T2_TurboRARE_highres_1.nii' to 't2.nii'
%    xrename(0,'T2_TurboRARE_highres_1.nii','t2.nii',':','dirs',an.mdirs );
%% [2] delete file "nan_2.nii" in animal dirs defined in an.mdirs
%    xrename(0,'t3.nii','','del','dirs',an.mdirs );
%
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace



function xrename(showgui,fi,finew,extractnum,varargin)
warning off;
p0.dummy=1;
if nargin>4
    pin= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p0=catstruct2(p0,pin);
end


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
    
    xrename(1)
    xrename(1, 'vol5.nii' , 'vol7.nii' )
    xrename(1,{'vol5.nii'},{'vol7.nii'})
    xrename(1,{'vol5.nii' 'vol6.nii'},{'vol7.nii' 'vol8.nii'})
    xrename(1,{'vol5.nii' 'vol6.nii'}',{'vol7.nii' 'vol8.nii'}')
    xrename(0,{'vol5.nii' 'vol6.nii'}',{'vol7.nii' 'vol8.nii'}')
end

%———————————————————————————————————————————————
%%   PARAMS input check
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
% if exist('x')==0                           ;    x=[]                     ;end
% if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if isfield(p0,'mdirs') && ~isempty(char(p0.mdirs))
    pa=p0.mdirs;
else
    pa=antcb('getsubjects')  ;
end


if exist('fi')~=1;
    he{1,1}=[]  ;
    he{1,2}=[]  ;
    he{1,3}=[]  ;
else
    if ischar(fi)
        he{1,1}=fi;
        if exist('finew')~=1; finew=''; end
        he{1,2}=finew;
    else
        he(:,1)=fi(:);
        if exist('finew')~=1; finew=repmat({''},[length(fi)  1]); end
        if isempty(finew(:)) %empty
            he(:,2)={''};
        else
            he(:,2)=finew(:);
        end
    end
    if ~iscell(he)
        he=repmat({''},[1 3]);
    else
        he(:,3)=repmat({''},[1 size(he,1)]);
    end
end

if exist('extractnum')
    if isnumeric(extractnum)
        extractnum=extractnum(:);
        extractnum(extractnum==0)=nan;
        extractnum=cellstr(num2str(extractnum));
        extractnum=regexprep(regexprep(extractnum,'NaN',''),'\s+','');
        
        if size(he,1) == size(extractnum,1)
            he(:,3)=extractnum;
        else
            error('extractnum be of same size as fi & finew');
        end
    elseif ischar(extractnum) | iscell(extractnum)
        if ischar(extractnum); extractnum=cellstr(extractnum); end
        extractnum=extractnum(:);
        ix = cellfun('isclass', extractnum, 'double');
        extractnum(ix) =cellfun(@num2str,extractnum(ix),'UniformOutput',0);
        extractnum=regexprep(regexprep(extractnum,'^0',''),'\s+',' ');
        extractnum=regexprep(regexprep(extractnum,'NaN',''),'\s+',' ');
        if size(he,1) == size(extractnum,1)
            he(:,3)=extractnum;
        else
            he(:,3)=extractnum;
            %         else
            %             error('extractnum be of same size as fi & finew');
        end
        
        
    end
    %
    %     elseif ischar(extractnum)
    %
    %     elseif iscell(extractnum)
    %
    %     end
    
end



%———————————————————————————————————————————————
%%   get unique-files from all data
%———————————————————————————————————————————————
if isfield(p0,'dirs')==1 %obtain from argin-paths
    pa=p0.dirs;
end
if ischar(pa); pa=cellstr(pa); end

% ==============================================
%%   filter data
% ===============================================
s.flt='.*.nii';
if isfield(p0,'flt')==1
    s.flt=p0.flt;
end


if ~isempty(he)
    he=cellfun(@(a){[num2str(a)]} ,he);
    [~,~, ext]=fileparts2(he(:,1));
    uniext=unique(ext);
    if length(uniext)==1 && isempty(uniext{1})
        
    else
        s.flt=strjoin(uniext,'|');
    end
end
v=getuniquefiles(pa,'flt',s.flt);

%% =============add to do column ==================================
if 0
    he2=he;
    col3=he(:,1)
    unicol3=unique(col3);
    if ~isempty(char(unicol3))
        for i=1:length(unicol3)
            ix=regexpi2(he(:,1),unicol3{i});
            incol3=he(strcmp(col3,unicol3{i} ),3)
            try;incol3=incol3{1}; end
            he2(ix,3)={incol3};
        end
    end
    
    he=he2;
end



%———————————————————————————————————————————————
%%  get pairings of old&newfile (optional via gui) and extractionNUmber
%———————————————————————————————————————————————
% ==============================================
%%   SHOW GUI
% ===============================================
delete(findobj(0,'tag','xrename'));
s.pa=pa; %additional struct

[ v2,he2 ]=parse4gui(v,he); %parses commands to cell 




if usejava('desktop')==0;
    showgui=0;
end
if showgui==0
    he=he2; tbout=v2.tb ;
else
    if size(v2.tb,1)<10
        [he, tbout isOKpressed]=renameGUI(v2,he2,s, showgui, struct('pos', [.2 .4 .6 .3]));
        
    else
        [he, tbout isOKpressed]=renameGUI(v2,he2,s, showgui);
    end
    
    
    %     isOKpressed
    %     return
    if isOKpressed==0;% if cancel pressed...abort
        return
    end
end

% return
% keyboard
%% add special files due to special inserts in col-3
try
    if showgui==1
        iadd=find(~cellfun(@isempty,  regexpi(tbout(:,3), '^##$|^del$|^delete$')));
        he=[he; tbout(iadd,1:3)];
    else
        
        
    end
%    
end
try
  if isempty(find(strcmp(he(:,end),'ref')))
    iadd=find(~cellfun(@isempty,  regexpi(tbout(:,3), '^ref$')));
    he=[he; tbout(iadd,1:3)];
  end
end
% he
% return

%———————————————————————————————————————————————
%%  process
%———————————————————————————————————————————————
isDesktop=usejava('desktop');% is DEKSTOP enabled

if isempty(he); return; end

fi   =he(:,1);
finew=he(:,2);
volnum=he(:,3);
he_aux={};
recycle('on'); %set recycle-bin to on



%% ===============================================
% change prefix abbreviation
ix=regexpi2(finew,'\$p|p:');
if ~isempty(ix)
    for i=1:length(ix)
        prefix=regexprep(finew{ix(i)},'\$p|p:','');
        if ~isempty(prefix)
            finew{ix(i)}= [regexprep([prefix fi{i}] ,'\s+','') ];
        end
    end
end
% ===============================================
% change prefix abbreviation
ix=regexpi2(finew,'\$s|s:');
if ~isempty(ix)
    for i=1:length(ix)
        suffix=regexprep(finew{ix(i)},'\$s|s:','');
        if ~isempty(suffix)
            [~, namexx,extxx ]=fileparts(fi{i});
            finew{ix(i)}= [regexprep([  namexx  suffix extxx ] ,'\s+','') ];
        end
    end
end
% ===============================================


%% ===============================================

% using wildcards without GUI
% example: xrename(0,{'.*_pd_.*1.nii' '.*_pd_.*3.nii'},{'PD_mag.nii' 'PD_phase.nii'},':');
% xrename(0,{'.*_mag.nii' '.*_phase.nii'},{'##','##'});
% xrename(0,'.*_mag.nii|.*_phase.nii','##')
is_wildcard=1;
if showgui==0
    if ~isempty(regexpi2(fi,strjoin({ '*','\^','\$','?' },'|')))
      % create new list (he, v)
      tn={};
      for i=1:size(he,1)
        is=regexpi2(v.tb(:,1),he{i,1});
         tn=[tn;       [v.tb(is,1) repmat(he(i,2:3),[length(is) 1])]    ];
      end
      fi    =tn(:,1);
      finew =tn(:,2);
      volnum=tn(:,3);      
    end
end




%% ===============================================



for i=1:length(pa)      %PATH
    [~,Z.animalDir]=fileparts(pa{i});
    Z.animalDirFP  =pa{i};
    
    
    
    
    for j=1:length(fi)  %FILE
        s1=fullfile(pa{i},fi{j}); %OLD FILENAME
        if exist(s1)==2  %CHK EXISTENCE
            Z.file=fi{j};
            
            if strcmp(finew{j},'##')==1 || strcmp(finew{j},'delete')==1  % DELETE FILE
                %                 if 1
                %                     disp('---delete-test--');
                %                     disp(['del: ' s1]);
                %                 end
                %% DO IT
                if 1
                    try;
                        delete(s1);
                        disp(['deleted:' s1]);
                    end
                end
            else % RENAME FILE  /extract volume
                [pax0 fix0 ex0]=fileparts(s1);
                [pax fix ex]=fileparts(finew{j});
                if isempty(ex);  s2=fullfile(pa{i},[fix ex0 ]);
                else             s2=fullfile(pa{i},[fix ex ]);
                end
                %                 if 1
                %                     disp('---rename-test--');
                %                     disp(['old: ' s1]);
                %                     disp(['new: ' s2]);
                %                 end
                
                if isempty(volnum{j})
                    %% rename
                    try
                        movefile(s1,s2,'f');
                        if isDesktop==1
                            disp(['renamed: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
                        else
                            disp(['renamed file: ' s2]);
                        end
                    end
                elseif ~isempty(regexpi(volnum{j},'^##$|^del$|^delete$')); %delete
                    % 'delete me'
                   delete(s1);  %delete files here
                    if exist(s1)==0
                        cprintf([0 .5 0],['file deleted: '  strrep(s1,filesep,[filesep filesep]) '\n']);
                    else
                        cprintf([1 0 1],['could not delete: '  strrep(s1,filesep,[filesep filesep]) '\n']);
                    end
                    
                    
                   % cprintf([0 .5 0],['file deleted: '  strrep(s1,filesep,[filesep filesep]) '\n']);
                    
                    
                    
                elseif strfind(volnum{j},'vf:'); %vox factor
                    % ==============================================
                    %% VOXELFACTOR : scaling up down by voxfactor multiplication
                    % ===============================================
                    try
                        code=volnum{j};
                        copyfile(s1,s2,'f');
                        vox=str2num(regexprep(code,'vf:' ,''));
                        if length(vox)==1
                            hm=diag([vox vox vox 1]);
                        else
                            hm= diag([vox(:)' 1]);
                        end
                        hx=spm_get_space(s2);
                        spm_get_space(s2, hm*hx);
                        
                        hxnew=spm_get_space(s2);
                        vec =spm_imatrix(hx);
                        vec2 =spm_imatrix(hxnew);
                        voxsi=sprintf('[%2.3f %2.3f %2.3f]',  vec(7), vec(8), vec(9));
                        voxsi2=sprintf('[%2.3f %2.3f %2.3f]', vec2(7),vec2(8),vec2(9));
                        
                        
                        if isDesktop==1
                            disp(['New IMG with altered voxSize: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
                                ' new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        else
                            disp(['New IMG with altered voxSize: ' s2 '; new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        end
                        
                        % regexprep()
                    catch
                        disp('problem with voxelfactor');
                        continue
                    end
                    % ==============================================
                    %%
                    % ===============================================
                elseif strfind(volnum{j},'dt:')==1; %vox factor
                    % ==============================================
                    %% change dataType
                    % 
                    % ===============================================
                    try
                        code=volnum{j};
                        datType=str2num(regexprep(code,'dt:' ,''));
                        
                        
                        [ha a ]=rgetnii(s1);
                        delete(s2);
                        rsavenii(s2,ha,a,datType)
                        
                        if isDesktop==1
                            disp(['New IMG with altered dataType: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
                                ]);
                        else
                            disp(['New IMG with altered dataType: ' s2  ]);
                        end
                        
                    catch
                        disp('problem to change dataType');
                        continue
                    end
                elseif strfind(volnum{j},'flip:')==1; %flip image in standardspace
                    % ==============================================
                    %% flip image
                    % xrename(0,'x_t1_mask.nii','s:_inv','flip:');
                    % xrename(0,'x_t1_mask.nii','s:_inv3','flip:m=1');
                    % xrename(0,'x_t1_mask.nii','s:_inv3','flip:m=1;in=1;');
                    % ===============================================
                    try
                        code=volnum{j};
                        c=regexprep(code,'flip:' ,'');
                        c=regexprep(c,'\s+','');
                        if ~isempty(c); 
                        c=[c ';'];
                        end
                        
                        g=struct();
                        g.mode=2;
                        g.dim=1;
                        g.doreslice=1;
                        g.dt=64;
                        g.interp=0;
                            
                        if ~isempty(c)
                            c2=tostruct(c);
                            if isfield(c2,'m');  g.mode     =c2.m; end
                            if isfield(c2,'d');  g.dim      =c2.d; end
                            if isfield(c2,'r');  g.doreslice=c2.r; end
                            if isfield(c2,'dt'); g.dt       =c2.dt; end
                            if isfield(c2,'in'); g.interp   =c2.in; end
                        end
                        
                        
                        
                        flipIMG(s1,s2,g.mode,g.dim,g.doreslice,g.dt,g.interp);
                        
                        if isDesktop==1
                            if exist(s1)==2
                                showinfo2('New flipped IMG ',s2,s1);
                            else
                            disp(['New flipped IMG: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
                                ]);
                            end
                        else
                            disp(['New flipped IMG: ' s2  ]);
                        end
                        
                    catch
                        disp('problem to flip image');
                        continue
                    end    
                    
                elseif strfind(volnum{j},'ch:')==1; %vox factor
                    % ==============================================
                    %% change header (ch)
                    %% xop(0,'t2.nii','t2_translated','ch:trans:[1 0.2 0.3];');  %translated object by [dx,dy,dz] mm
                    %% xop(0,'t2.nii','t2_rotated'   ,'ch:rot:[0.1 0.1 0.1];');  %rotate object by [dx,dy,dz] radians
                    % ===============================================
                    try
                        %% ===============================================
                        code=volnum{j};
                        code=regexprep(code,'ch:' ,'');
                        if isempty(regexpi(code,'mat:\s*['))
                            t1=strsplit(code,';')';
                            if ~isempty(regexpi(code,'trans:\s*[')) || ~isempty(regexpi(code,'rot:\s*[')) %translate or rotate
                               if ~isempty(regexpi(code,'trans:\s*['))
                                   i1=regexpi(code,'trans:\s*[');
                               elseif ~isempty(regexpi(code,'rot:\s*['))
                                   i1=regexpi(code,'rot:\s*[');
                               end
                                i2s=regexpi(code,']');
                                i2=i2s(min(i2s>i1));
                                code2=code(i1:i2);
                                code=strrep(code,code2,'');
                                t1=strsplit(code,';')';
                            end
                            
                            
                        else
                            i1=regexpi(code,'mat:\s*[');
                            i2s=regexpi(code,']');
                            i2=i2s(min(i2s>i1));
                            code2=code(i1:i2);
                            code=strrep(code,code2,'');
                            t1=strsplit(code,';')';
                        end
                        
                        [k1 k2]=strtok(t1,':');
                        k1=regexprep(k1,'\s+' ,'');
                        k2=regexprep(k2,{'^\s+' '^:' '\s+$'}, {''});
                        idel=find(cellfun(@isempty,k1));
                        k1(idel)=[];
                        k2(idel)=[];
                        
                        if ~isempty(k1)
                            x=cell2struct(k2,k1);
                        else
                            x=struct();
                        end
                        if exist('code2')==1
                            if  ~isempty(strfind(code2,'mat'))
                                x.mat= str2num(regexprep(code2,'mat:',''));
                            elseif   ~isempty(strfind(code2,'trans'))  % translate images
                                i1=strfind(code2,'trans');
                                i2=strfind(code2,']');  i2=i2(min(find(i2>i1)));
                                eval([strrep(code2(i1:i2),':','=') ';'])
                                h=spm_vol(s1); h=h(1);
                                imatrix=spm_imatrix(h.mat);
                                if exist('trans')==1 && length(trans)==3
                                    imatrix(1:3)=imatrix(1:3)+trans(:)';
                                else
                                    disp('adding translation: "trans" must be a vector of 3 values');
                                end
                                x.mat=spm_matrix(imatrix);
                            elseif   ~isempty(strfind(code2,'rot'))  % translate images
                                i1=strfind(code2,'rot');
                                i2=strfind(code2,']');  i2=i2(min(find(i2>i1)));
                                eval([strrep(code2(i1:i2),':','=') ';'])
                                h=spm_vol(s1); h=h(1);
                                imatrix=spm_imatrix(h.mat);
                                if exist('rot')==1 && length(rot)==3
                                    imatrix(4:6)=imatrix(4:6)+rot(:)';
                                else
                                    disp('adding rotation: "rot" must be a vector of 3 values');
                                end
                                x.mat=spm_matrix(imatrix);
                                
                                
                            end
                            
                        end
                        
                        
                        %x.image='';
                        % x.mat='304 04';
                        if isfield(x,'mat');
                            if ischar(x.mat);   x.mat=str2num(x.mat); end
                            if isempty(x.mat)
                                x=rmfield(x,'mat');
                            end
                        end
                        if isfield(x,'image');
                            [IMGpa IMGname IMGext]=fileparts(x.image);
                            if isempty(IMGpa) %local animal path
                                x.image=fullfile(fileparts(s1), [IMGname IMGext]);
                            end
                            
                            
                            if exist(x.image)~=2
                                x=rmfield(x,'image');
                            end
                        end
                        x.usedMethod=0;
                        if isfield(x,'image')==1
                            x.usedMethod=1;
                        elseif isfield(x,'mat')==1
                            x.usedMethod=2;
                        else
                            x.usedMethod=0;
                        end
                        %% ===============================================
                        if x.usedMethod==1
                            href=spm_vol(x.image);
                            href=href(1);
                            matN=href.mat;
                        elseif x.usedMethod==2
                            matN=x.mat;
                        else
                            hv=spm_vol(s1);
                            matN=hv.mat;
                        end
                        
                        if isfield(x,'flipdim')
                            try; x.flipdim=str2num(x.flipdim); end
                            if isempty(x.flipdim);
                                x=rmfield(x,'flipdim');
                            end
                        end
                        
                        [hb b]=rgetnii(s1);                 %get file
                        
                        [pas2 names2 exts2]=fileparts(s2);  % specal case:overwrite file
                        if isempty(names2)
                            s2=s1;
                            msgImg='same IMG';
                        else
                            msgImg='new IMG';
                        end
                        
                        if strcmp(s1,s2)==0
                            try; delete(s2);end
                            %copyfile(s1,s2,'f');
                        end
                        
                        
                        %hb.mat=M2;
                        for jj=1:length(hb)
                            hb(jj).mat=matN;                    % CHANGE MAT
                        end
                        dt=hb(1).dt(1);
                        if isfield(x,'dt')                      % CHANGE DATAtYPE
                            dt=str2num(x.dt);
                        end
                        if isfield(x,'descrip')                 % CHANGE DESCRIPTION
                            for jj=1:length(hb)
                                hb(jj).descrip=char(x.descrip);
                            end
                        end
                        
                        
                        
                        rsavenii( s2 , hb, b,dt);
                        
                        
                        if isfield(x,'flipdim')           %FLIP-DIMENSION
                            try; x.flipdim=str2num(x.flipdim); end
                            if length(x.flipdim)<=3
                                flipvec=ones(1,3);
                                flipvec(x.flipdim)=-1;
                                zv=zeros(1,12);
                                zv(7:9)=flipvec;
                                flipmat=spm_matrix(zv);
                                hs2=spm_vol(s2);
                                if length(hs2)==1
                                    rsavenii( s2 , hb, b,dt);
                                    M2=hs2(1).mat*flipmat;
                                    spm_get_space(s2,M2);
                                else
                                    hb2=hb;
                                    for jj=1:length(hb)
                                        hb2(jj).mat=hs2(1).mat*flipmat;
                                    end
                                    rsavenii( s2 , hb2, b,dt);
                                end
                            end
                        end
                        
                        %% =========check/debug======================================
                        
                        if 0
                            %                             rclosemricron
                            %                             rmricron([],s1);
                            rmricron([],s2);
                        end
                        
                        if x.usedMethod==0 && length(fieldnames(x))==1
                            msgHDR='(file copied only)';
                        else
                            msgHDR='(changed header)';
                        end
                        
                        
                        %% ===============================================
                        
                        if isDesktop==1
                            disp([msgImg ' ' msgHDR ': <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
                                ]);
                        else
                            disp([msgImg ' ' msgHDR ': ' s2  ]);
                        end
                        showinfo2('show file' ,s2);
                        
                        try; delete(regexprep(s2,'.nii$','.mat')); end
                    catch
                        disp('problem to change header');
                        continue
                    end
                
                %% ===============================================    
                %%   REPLACE VALUES    ('R:' or 'replace:' or 'repl:')
                %% ===============================================
                elseif  ~isempty(regexpi2(volnum(j),'^R:|^replace:|^repl:'))...%replace
                        
                %% ===============================================
                
                code=volnum{j};
                
%                 code='R:0;ME'
%                 code='R:<0;ME'
%                 code='R:<=0;MED'
%                 code='R:<=0;3'
%                 code='R: 0;nan'
%                 code='R: nan;5'
%                 code='R: inf;7'
%                 code='R: >0;100'
%                 code='R: >=0;100;'
                
                m=regexprep(code,'^R:|^replace:|^repl:','');
                
                %in=strsplit(m,';');
                in=strsplit(m,{';',','});
                
                %% ===============================================
                
                [ha a ]=rgetnii(s1);
                ao=zeros(size(a));
                for jj=1:size(a,4) %over-4D
                    
                    a1=a(:,:,:,jj);
                    a2=a1(:);
     
                    if isempty(regexpi2(in{1},{'<|>|='}))
                        if ~isempty(regexpi2(in{1},{'nan|NaN|NAN'}))
                            w=  ['iv=find(isnan(a2));'];
                        elseif ~isempty(regexpi2(in{1},{'inf|INF'}))
                            w=  ['iv=find(isinf(a2));'];
                        else
                            w=['iv=find(a2==' in{1} ');'];
                        end
                    else
                        w=['iv=find(a2' in{1} ');'];
                    end
                    eval(w);
                    
                    av=a2;
                    av(iv)=[];
                    if strcmp(in{2},'ME') || strcmp(in{2},'MED')
                        if     strcmp(in{2},'ME' ) ;   me=mean(av);
                        elseif strcmp(in{2},'MED') ;   me=median(av);
                        end
                        sd=std(av);
                        r=randn(length(a2),1);
                        r=r./std(r);
                        r=r-mean(r);
                        r=r*sd;
                        r=r+me;
                        a2(iv)=r(1:length(iv));
                    elseif isnumeric(str2num(in{2}))
                        a2(iv)=str2num(in{2});
                    end
                    
                    
                    a2=reshape(a2,size(a1));
                    ao(:,:,:,jj)=a2;
                end %over-4D
                %% ===============================================
                
                
                rsavenii(s2 ,ha,ao,64);
               % montage2(a2)

               if isDesktop==1
                   showinfo2('',s2,[],'',sprintf('  VALUES:[in]:%s;[out]:%s',in{1},in{2}) );
               else
                   disp(['New IMG with replaced Values: ' s2 ';' ...
                       sprintf('  [in]:%s;[out]: %s',in{1},in{2}) ]);
               end
                
                %% ===============================================
                
                elseif ~isempty(strfind(volnum{j},'vr:')) || ~isempty(strfind(volnum{j},'vs:'))
                    % ==============================================
                    %% voxel resolution (change image also) or
                    %% voxel size (change header only)
                    % ===============================================
                    try
                        code=volnum{j};
                        vox=str2num(regexprep(code,{'vr:' 'vs:'} ,''));
                        if length(vox)==1; vox=repmat(vox ,[1 3]); end
                        
                        [ha a ]=rgetnii(s1);
                        if all((mod(a(:),1) == 0))  ;%INTEGER
                            interp=0;
                        else
                            interp=1;
                        end
                        [BB voxold]=world_bb(s1);
                        
                        if any(isnan(vox))
                           inan=isnan(vox);
                           vox(inan)=voxold(inan);
                        end
                        delete(s2);
                        if ~isempty(strfind(volnum{j},'vr:'))
                            resize_img5(s1,s2, vox, BB, [], interp);
                            msg='New IMG (altered voxsize and altered image):';
                            err='problem to change voxel resolution (''vr:'')';
                        elseif ~isempty(strfind(volnum{j},'vs:'))
                           msg='New IMG (altered voxsize):';
                           err='problem to change voxel size (''vs:'')';
                           
                           hb=ha(1);
                           vec=spm_imatrix(hb.mat);
                           vec(7:9)=vox;
                           hb.mat=spm_matrix(vec);
                           rsavenii(s2 , hb, a);
                           
                        end 
                        voxsi=sprintf('[%2.3f %2.3f %2.3f]',  voxold(1), voxold(2), voxold(3));
                        voxsi2=sprintf('[%2.3f %2.3f %2.3f]', vox(1)   , vox(2)     ,vox(3));
                        
                        if isDesktop==1
%                             disp([msg '<a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
%                                 ' new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                            showinfo2(msg, s2,'','',[' new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        else
                            disp([msg  s2 '; new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        end
                        
                        try; delete(regexprep(s2,'.nii$','.mat')); end
                    catch
                        disp(err);
                        continue
                    end
                elseif ~isempty( regexpi(volnum{j} ,'^i\d+')  )
                    % just a catcher...do nothing
                elseif strfind(volnum{j},'tr:'); %vox factor
                    try
                        [pax fix ex]=fileparts(finew{j});
                        s2=fullfile(pa{i},[fix '.nii' ]);
                        if isempty(fix)
                            s2=s1; % work on imputFile
                        end
                        if isempty(volnum{j})
                            disp('..could not threshold image: --> no threshold defined...example: "tr:i<3=0" to set all values in image<3 to zero')
                        end
                        
                        [ha a ]=rgetnii(s1);
                        dims=[ha(1).dim max(size(ha))];
                        a2=reshape(a,[prod(dims) 1]);
                        
                        %% --- threshold image
                        code=volnum{j};
                        %code='tr:    i==3=0';
                        %code='tr:    i>3=0';
                        %code='tr:    i<3=0';
                        % code='tr:    i <=3=0;';
                        %code='tr:    i >=3=0;';
                        %code='tr:    i ~=3=0;';
                        %code='tr:    i<0=3; i>6=6;';
                        %a2=1:10
                        %code=regexprep(code,'==','#');
                        %                     code=regexprep(code,'==','EQ');
                        %                     code=regexprep(code,'<=','LE');
                        %                     code=regexprep(code,'>=','GTE');
                        %                     code=regexprep(code,'<','LL');
                        %                     code=regexprep(code,'>','GG');
                        %                     code=regexprep(code,'~=','NE');
                        
                        rep1= {'==' '<=' '>='   '<'   '>'    '~='}  ;
                        rep2= {'EQ' 'LE' 'GTE'  'LL'  'GG'   'NE'} ;
                        code=regexprep(code,rep1,rep2);
                        
                        code=regexprep(code,{ ['tr:' '\s+']  'i' '=' },{'' 'a2(a2' ')='});
                        code=regexprep(code,{'tr:'},{''});
                        code=[code ';'];
                        code=regexprep(code,rep2,rep1);
                        
                        eval(code);
                        
                        a2=reshape(a2, dims);
                        %                     if ha.dt(1)==2
                        rsavenii(s2 ,ha,a2,[64 0]);
                        %                     else
                        %                         rsavenii(s2 ,ha,a2);
                        %                     end
                        showinfo2(['threshold image: ' s2 ' '],s2);
                    catch
                        disp([' ..threshold image...something went wrong  (internal code: "' code '")']);
                    end
                    
                    %% test
                    
                    
                elseif ~isempty(strfind(volnum{j},'descrip:')) || ~isempty(strfind(volnum{j},'desc:'))
                    code=volnum{j};
                    code=regexprep(code,{'desc:' 'descrip:'},{''});
                    
                    if strcmp(s1,s2)==1
                        sx=s1;
                    else
                        copyfile(s1,s2,'f');
                        sx=s2;
                    end
                    
                    hm=spm_vol(sx);
                    for i=1:length(hm)
                        hm(i).descrip=code;
                    end
                    spm_create_vol(hm);
                    
                   disp(['..description changed in "' Z.file '" of [' Z.animalDir ']' ' --> current description: "'  hm(1).descrip '"' ]);
             
             elseif ~isempty(strfind(volnum{j},'mean:')) || ~isempty(strfind(volnum{j},'median:')) ||...
                    ~isempty(strfind(volnum{j},'sum:'))  || ~isempty(strfind(volnum{j},'max:'))    || ...
                    ~isempty(strfind(volnum{j},'min:'))  || ~isempty(strfind(volnum{j},'mode:'))   || ...
                    ~isempty(strfind(volnum{j},'std:'))  || ~isempty(strfind(volnum{j},'zscore:')) || ...
                    ~isempty(strfind(volnum{j},'var:'))
                 %% ==========[mean volume over 4th dim]=====================================
                 code=volnum{j} ;
                 %code='mean: 3:4';
                 %code='mean: end';
                 %code='mean: 4:end';
                 %code='median: 3:4';
                 %code='sum: 3:4';
                % code='sum: ';
                %code='max: 3:4';
                %code='min: 1:2';
                %code='mode: 1:2';
                %code='mode: 1:2';
                %code='std: 1:2';
                %code='zscore: ';
                %code='var: ';
                 
                 [spl]=regexp(code, ':','split','once');
                 cmd=spl{1};
                 res=spl{2};
                 if isempty(regexprep(res,'\s+',''))
                     res='';
                 end
                 
                 err='';
                 [ha]=spm_vol(s1);
                 if length(ha)>1
                      [ha a]=rgetnii(s1);
                     if isempty(res); idx=[1:length(ha)];
                     else
                         idxstr=['idx=[' res '];'];
                         idxstr=regexprep(idxstr,'end',num2str(length(ha)) );
                         eval(idxstr);
                     end
                     idx=intersect([1:length(ha)],idx); % check that no lower/hight indices are given
                     
                     if length(idx)>1
                         b=a(:,:,:,idx);
                         if     strcmp(cmd,'mean');    b2 =mean(b,4);       lastcmd='mean';
                         elseif strcmp(cmd,'median')   b2 =median(b,4);     lastcmd='median';
                         elseif strcmp(cmd,'mode')     b2 =mode(b,4);       lastcmd='mode';
                         elseif strcmp(cmd,'sum')      b2 =sum(b,4);        lastcmd='sum';
                         elseif strcmp(cmd,'max')      b2 =max(b,[],4);     lastcmd='max';
                         elseif strcmp(cmd,'min')      b2 =min(b,[],4);     lastcmd='min';
                         elseif strcmp(cmd,'std')      b2 =std(b,[],4);     lastcmd='std';
                         elseif strcmp(cmd,'zscore')   b2 =zscore(b,[],4);  lastcmd='zscore';
                         elseif strcmp(cmd,'var')      b2 =var(b,[],4);     lastcmd='var';
                         end
                         %disp(['indices: [' num2str((idx))  ']']);
                         %disp(['size   : [' num2str(size(b2))  ']']);
                         %disp(['lastcmd: ' lastcmd]);
                         
                         %write file
                         if exist('b2')==1
                             try; delete(s2); end
                             hb2=ha(1);
                             rsavenii(s2,hb2,b2,64);
                             
                             showinfo2(['[' Z.animalDir ']' 'new volume(' cmd '):'],s2,[],[],...
                                 ['INFO: function over 4th.DIM: "' lastcmd '";' ...
                                 ['indices:' regexprep(num2str(idx),'\s+',',')]]);
                             
                         end
                     else
                         err=['error in [' Z.animalDir ']: NIFTI [' Z.file '] length of 4th-dim indices must larger 1'];
                         
                     end
                 else
                     err=['error in [' Z.animalDir ']: NIFTI [' Z.file '] is 3-dimensional, but 4-dim NIFTI is needed.']; 
                 end
                 if ~isempty(err)
                     disp(err);
                 end
                 
                 
                 %% ===============================================                
             elseif ~isempty(strfind(volnum{j},'rmvol:')) || ~isempty(strfind(volnum{j},'removevol:'))      
                %% ==========[remove volume]=====================================
                
                 code=volnum{j} ;
                 code=regexprep(code,{'rmvol:' 'removevol:'},{''});
                 
%                  code='4'
%                  code='1 4 6'
%                  code='[1 4:end]'
%                   code='1 2 4:end'
%                  code='77'
                 
                 code=['[' code  ']'];
                 [ha a]=rgetnii(s1);
                 if ~isempty(strfind(code,'end'));
                     vol_ixstr=strrep(code,'end',num2str(size(a,4)) );
                     eval(['volix=' vol_ixstr ';']);
                 else
                     eval(['volix=[' code '];']);
                     
                 end
                 volix=unique(volix);
                 ivol2del=find(ismember(1:size(a,4), volix)) ;
                 
                 if isempty(ivol2del)
                     disp(['failed: 4Dvol has ' num2str(length(ha))  ' 3D-vols, can''t remove the following volumes :[' num2str(volix) ']' ]  );
                 else
                     a(:,:,:,ivol2del)=[];
                     ha(ivol2del)=[];
                     for jj=1:length(ha)
                         ha(jj).n(1)=jj;
                     end
                     try; delete(s2); end
                     rsavenii(s2,ha,a,64);
                      
                     showinfo2(['[' Z.animalDir '] reduced volume:'],s2);
                     
                     %---check if DWI-file with same name exist
                     [pay namey exty]=fileparts(s1);
                     [paN nameN extN]=fileparts(s2);
                     s1Txt=fullfile(pay,[namey '.txt']);
                     if exist(s1Txt)==2
                         dwifile=preadfile(s1Txt); dwifile=dwifile.all;
                         dwifile(ivol2del,:)=[];
                         F2new=fullfile(paN,[nameN '.txt']);
                         pwrite2file(F2new,dwifile);
                         showinfo2(['[' Z.animalDir '] reduced Btable:'],F2new); 
                     end
                     
                     
                    
                     
                 end
                 
                 %% ===============================================
                 
                   
              elseif ~isempty(strfind(volnum{j},'pd:')) || ~isempty(strfind(volnum{j},'permdim:')); %permute dimensions
                    % ==============================================
                    %% permute dimension: 'permdim:' or 'pd:'; example 'pd: 1 3 2'
                    % ===============================================

                    code=volnum{j};
                    code=regexprep(code,{'pd:' 'permdim:'},'');
                    dim=str2num(code); %new permorder
                    
                    [ha a]=rgetnii(s1); 
                    if length(ha)>1  % 4DIM
                       dim= [dim setdiff([1:4],dim)]; 
                    else
                       dim= [dim setdiff([1:3],dim)];
                    end
                    dimMat=dim(1:3);
                    
                    a2=permute(a, dim);
                    
                    vc=spm_imatrix(ha(1).mat);
                    vc_ord=[dimMat dimMat+3 dimMat+6 dimMat+9];
                    vc2=vc(vc_ord);
                    mat=spm_matrix(vc2);
                    
                    hx =ha;
                    siz=size(a2);
                    for i=1:length(hx)
                        hx(i).mat=mat;
                        hx(i).dim=siz(1:3);
                    end
                    rsavenii(s2, hx, a2,64);
                    
                    showinfo2(['orig dimension: ' s1 ' '],s1);
                    showinfo2(['permute dimension: ' s2 ' '],s2);
                    %% ________________________________________________________________________________________________
                elseif strfind(volnum{j},'rmat:'); 
                    %% ===[replace meat by ref-file-mat]===========
                    % z=[];
                    % z.files =  { 'adc.nii' 	'bla' 	'rmat:'
                    %              'adc2.nii' 	''   	'ref' };
                    % xop(1,z.files(:,1),z.files(:,2),z.files(:,3));
                    %% ===============================================
                    %---reffile
                    ixref=find(strcmp(he(:,end),'ref'));
                    if isempty(ixref); 
                        error('no reference-file found ... no file tagged with ''ref''');
                    end
                    refName=he{ ixref };
                    fref=fullfile(Z.animalDirFP, refName);
                    hr=spm_vol(fref); %[hr r]=rgetnii(fref);
                    
                    [ha a]=rgetnii(s1);
                    delete(s2);
                    hb=ha;
                    for jj=1:length(ha)
                        hb(jj).mat= hr(jj).mat;
                        %hb(jj).descrip='replaced-HDRmat';
                    end
                    
                    rsavenii(s2, hb, a, 64);
                    showinfo2(['replace HDRmat:[' Z.animalDir ']'],s2);
                    %% ===============================================
                elseif strfind(volnum{j},'rHDR:');
                    %% ===[replace header by ref-file]===========
                    % z=[];
                    % z.files =  { 'test3.nii' 	'bla' 	'rHDR:'
                    %              'test2.nii' 	''   	'ref' };
                    % xop(1,z.files(:,1),z.files(:,2),z.files(:,3));
                    %% ===============================================
                    %---reffile
                    ixref=find(strcmp(he(:,end),'ref'));
                    if isempty(ixref); 
                        error('no reference-file found ... no file tagged with ''ref''');
                    end
                    refName=he{ ixref };
                    fref=fullfile(Z.animalDirFP, refName);
                    hr=spm_vol(fref); %[hr r]=rgetnii(fref);
                    
                    [ha a]=rgetnii(s1);
                    delete(s2);
                    %hr.descrip='replaced-HDR';
                    rsavenii(s2, hr, a, 64);
                    showinfo2(['replace HDR:[' Z.animalDir ']'],s2);
                    %% ===============================================
               elseif strfind(volnum{j},'gzip:');
                    %% ===[gzip file]===========
                    % z=[];
                    % z.files =  { 'test3.nii' 	'bla' 	'gzip:'};
                    % xop(1,z.files(:,1),z.files(:,2),z.files(:,3));
                    %% ===============================================
                    s3=gzip(s1,Z.animalDirFP);
                    s3=char(s3);
                    [paw namew extw]=fileparts(s2);
                    s4=fullfile(paw,[namew '.nii.gz']);
                    try; 
                        movefile(s3,s4,'f')
                    showinfo2(['gzip:[' Z.animalDir ']'],s4);
                    end
                    %% ===============================================
                elseif strfind(volnum{j},'gunzip:');
                    %% ===[gunzip file]===========
                    % z=[];
                    % z.files =  { 'test3.nii.gz' 	'test3.nii' 	'gunzip:'};
                    % xop(1,z.files(:,1),z.files(:,2),z.files(:,3));
                    %% ===============================================
                    [pax namex extx]=fileparts(s2);
                    s2=fullfile(pax,[ namex '.nii.gz']);
                    if strcmp(s1,s2)==0
                        copyfile(s1,s2,'f');
                    end
                    s3=gunzip(s2,Z.animalDirFP);
                    showinfo2(['gunzip:[' Z.animalDir ']'],s3{1});
                    if strcmp(s1,s2)==0
                        delete(s2);
                    end
                    %% ===============================================
                 elseif ~isempty(regexpi(volnum{j},'^niifun:'))==1
                     
                     if 0
                         funcname='F:\data8\schoenke_2dregistration\myfunc.m'
                         funcname='myfunc.m'
                         xrename(1,'ADCmask.nii' ,	'test.nii',	['niifun:' funcname ]);
                     end
                     code=volnum{j};
                     fun=regexprep(code,'^niifun:\s*','');
                     err=1;
                     if exist(fun)~=2
                         [funcpa funcname funcext]=fileparts(fun);
                         
                         subdirs={'' 'code' 'codes'};
                         pathBase=fileparts(fileparts(Z.animalDirFP));
                         for jj=1:length(subdirs)
                             potdir=fullfile(pathBase,subdirs{jj});
                             potfile=fullfile( potdir, [ funcname funcext]);
                             if exist(potfile)==2
                                 fun=potfile;
                             end
                         end
                     end
                     if exist(fun)==2; err=0; end
                     
                     if err==1
                        error(['function not found: "' [funcname funcext] '...add full path or save function' ...
                            ' in study-dir or in "code"-dir or "codes"-dir within study-dir' ]) ;
                     end
                     [funcpa funcname funcext]=fileparts(fun);
                     if isempty(funcpa);
                         funcpa=pwd;
                     end
                     %% ===============================================
                     try
                         paThis=pwd;
                         cd(funcpa)
                         
                         [ha a]=rgetnii(s1);
                         disp(['...applied function: ' fun]);
                         [hb,b] = feval(funcname,ha,a);
                         
                         cd(paThis)
                         
                         rsavenii(s2, hb, b, 64);
                         showinfo2(['apply function "' funcname '.m" :[' Z.animalDir ']'],s2);
                     catch ME
                        rethrow(ME); 
                     end
                     %% ===============================================

                     
                         
                    
                         
                         
                     
                     
                     
                     %% ===============================================
                     
                     
                     
                    
                elseif strfind(volnum{j},'mo:'); %vox factor
                    % ==============================================
                    %% mathematical operation
                    % ===============================================
                    try
                        code=volnum{j};
                        
                        %code='ma: (i<.5)=0; (i>=.5)=1;'
                        %code='ma: (i<.5)=.5'
                        %code='ma: i+4'
                        %code='ma: i=(i1==1).*(i==73);'
                        
                        code=regexprep(code,{'mo:' ''},'');
                        img =regexpi(code,'i\d+','match');
                        
                        %if ~isempty(img)                % USE ANOTHER IMAGE-OPERATION
                        dt=[];
                        img2=strrep(img,'i','u');
                        for im=1:length(img)
                            r1= regexpi(tbout(:,3),['^\s{0,10}' img{im} '\s{0,10}$']);
                            fileaux   =tbout{find(~cellfun('isempty',r1)),1};
                            tblin=tbout(find(~cellfun('isempty',r1)),1:3);
                            he_aux=[he_aux; tblin];
                            fpfileaux =fullfile(fileparts(s1),fileaux);
                            [hdum dum]=rgetnii(fpfileaux);
                            eval([  img2{im} '=dum;' ]);
                        end
                        [hu u]=rgetnii(s1);
                        %code2=regexprep(code,'i','u');
                        code2=regexprep(code,'(?<![a-zA-Z])i(?![a-zA-Z])','u');
                        %evalstr=['mo=' code2 ';' ];
                        evalstr=[  code2 ';' ];
                        eval(evalstr);
                        
                        
                        if hu.dt(1)==2
                            hu.dt(1) =4;
                        end
                        if ~isempty(dt)
                            hu.dt(1)=dt(1);
                        end
                        
                        %disp(hu.dt);
                        
                        delete(s2);
                        rsavenii(s2,hu,o);
                        %[hb b]=rgetnii(s2);unique(b)
                        
                        
                        if isDesktop==1
                            disp(['New IMG ..math operation: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>' ]);
                        else
                            disp(['New IMG ..math operation: ' s2  ]);
                        end
                    catch
                        disp('problem with math operation');
                        continue
                    end
                    
                    
                    
                    
                else
                    % ==============================================
                    %%   %% extractvolume
                    % ===============================================
                    if ischar(volnum{j}) && strcmp(volnum{j},'ref')
                        continue
                    end
                    
                    
                    thisvol= lower(volnum{j});
                    save_separately =0;
                    if strcmp(ex0,'.nii') %nifti-file
                        [ha a]   =rgetnii(s1); %MASKexr
                    end
                    if isnumeric(thisvol)
                        try
                            hb = ha(thisvol);
                        catch
                            disp('problem with extraction-index: maybe larger than #volumes stored file');
                            continue
                        end
                        b  = a(:,:,:,thisvol);
                    else %used if thisvol is 'end' or 'end-1' or '3:7' or '3:end-1' ...
                        if strcmp(thisvol,'copy');
                            thisvol=':';
                        end
                        if strcmp(thisvol,'rename');
                            try
                                movefile(s1,s2,'f');
                                if isDesktop==1
                                    disp(['renamed: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
                                else
                                    disp(['renamed: ' s2  ]);
                                end
                                
                                continue
                            end
                        end
                        
                        %check whether to separately save volumes ,using [s] tag
                        save_separately=strfind(thisvol,'s');
                        if ~isempty(save_separately)
                            save_separately=1;
                            thisvol=strrep(thisvol,'s','');
                        else
                            save_separately=0;
                        end
                        
                        if strcmp(ex0,'.nii') %nifti-file
                            try
                                eval(['hb=ha(' thisvol ');']);
                            catch
                                disp('problem with extraction-index: maybe larger than #volumes stored file');
                                continue
                            end
                            eval(['b=a(:,:,:,' thisvol ');']);
                        end
                    end
                    
                    %% delete targetfile if exists
                    %if strcmp(thisvol,':')==1
                    if exist(s2)==2 && save_separately==0
                        delete(s2);
                    end
                    %end
                    
                    %% write volume
                    warning off;
                    if strcmp(ex0,'.nii') %nifti-file
                        if save_separately==0
                            for k = 1 : size(hb,1)
                                hb(k).fname = s2;
                                hb(k).n     = [k 1];
                                spm_create_vol(hb(k));
                                spm_write_vol(hb(k),b(:,:,:,k));
                            end
                            try;
                                delete( strrep(s2,'.nii','.mat')  ) ;
                            end
                            
                            if isDesktop==1
                                disp(['created: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
                            else
                                disp(['created: ' s2  ]);
                            end
                            
                        else  %write separate volumes
                            vec_allvols=1:size(ha,1);
                            eval(['vol_id =vec_allvols(' thisvol ');']);
                            
                            for k = 1 : size(b,4)
                                s3=fullfile(pa{i},[fix '_' pnum(vol_id(k) ,3) '.nii' ]);
                                hc       =hb(k);
                                hc.fname = s3;
                                hc.n     = [1 1] ;
                                spm_create_vol(hc);
                                spm_write_vol(hc,b(:,:,:,k));
                                try; delete( strrep(s3,'.nii','.mat')  ) ;     end
                                
                                if k==1
                                    if size(hb,1)==1
                                        if isDesktop==1
                                            disp(['created: one separate vol: <a href="matlab: explorerpreselect(''' s3 ''')">' s3 '</a>'  ]);
                                        else
                                            disp(['created: one separate vol: : ' s3  ]);
                                        end
                                    else
                                        if isDesktop==1
                                            disp(['created: several separate vol, starting with: <a href="matlab: explorerpreselect(''' s3 ''')">' s3 '</a>'  ]);
                                        else
                                            disp(['created: several separate vol, starting with: ' s3  ]);
                                        end
                                    end
                                end
                            end
                        end %write vol
                    else
                        % NOT A NIFTI_____
                        copyfile( s1,s2, 'f');
                        if isDesktop==1
                            disp(['created: file: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
                        else
                            disp(['created: file: ' s2  ]);
                        end
                    end
                    
                    
                    
                end
                
                
            end  %delete or rename
        end%exist
    end%file
end%path


%———————————————————————————————————————————————
%%   batch
%———————————————————————————————————————————————
if ~isempty(he_aux)
    [~,idx]=unique(  strcat(he_aux(:,1),he_aux(:,2),he_aux(:,3)) , 'rows'); %REMOVE IDENTICAL
    he_aux=he_aux(idx,:);
    z.files=[he;he_aux];
else
    z.files=he;
end
makebatch(z,p0);

drawnow;
try
    antcb('update');
end



% ==============================================
%%   subs
% ===============================================

function  [ v2,he2 ]=parse4gui(v,he);
%% ===============================================

if isempty(he)
    he=repmat({''},[ 1 3]) ;
end

%% predefined file-rename
newname       =repmat({''}, [size(v.tb,1) 1]);
extractvolnum =repmat({''}, [size(v.tb,1) 1]);
if ~isempty(he{1})
    for i=1:size(he,1)
        % wildcard
        if ~isempty(regexpi( he{i,1},'*|\^|\$|\|')) %~isempty(strfind( he{i,1},'*'))
            %id=regexpi2(v.tb(:,1), ['^' he{i,1}] );
            id=regexpi2(v.tb(:,1), [ he{i,1}] );
        else
            id=find(strcmp(v.tb(:,1), [ he{i,1}]));
        end
        if ~isempty(id)
            newname(id,1)       = he(i,2);
            extractvolnum(id,1) = he(i,3);
        end
    end
end

%% ===============================================


% %% NO_GUI
% if showgui == 0
%     tb       = [v.tb(:,1)  newname extractvolnum ] ;
%     ishange=find(~cellfun('isempty' ,tb(:,2))) ;
%     if isempty(ishange)
%         he=[];
%         tbout=tb;
%     else
%         he= tb(ishange,1:3);
%         tbout=tb;
%     end
%     v2.tbh=v.tbh;
%     v2.tb =tbout;
%     he2=he;
%
%     return
% end

%% GUI
tb       = [v.tb(:,1)  newname  extractvolnum  v.tb(:,2:end) ] ;
%  tbh      = [ v.tbh(1)  'NEW FILENAME (no extension)' 'TASK (extract volnum)' v.tbh(2:end)];
%  tbh      = [ v.tbh(1)  'NEW FILENAME               ' 'TASK                 ' v.tbh(2:end)];
tbh      = [ v.tbh(1)  'NEW FILENAME_______________' 'TASK_________________' v.tbh(2:end)];



% tb    =tb(: ,[1 end 2:end-1 ]); % 2nd element is new name
% tbh   =tbh(:,[1 end 2:end-1 ]);
% tbh{1}='Filename';  %give better name
tbh{1}='Filename_______________';  %give better name
tbh   =upper(tbh);


if size(tb,2)<length(tbh)
    tb=[tb repmat({''},[1 length(tbh)-size(tb,2)])];
end
for i=1:size(tbh,2)
    addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
    tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
end

v2.tbh=tbh;
v2.tb =tb;
he2=he;

%________________________________________________
%%  rename files
%________________________________________________
function [he tbout isOKpressed]=renameGUI(v,he,s, showgui,varargin)
% keyboard
if ~isempty(varargin);%nargin>4
    pin=varargin{1};
    
end


tb= v.tb;
tbh=v.tbh;
isOKpressed=0;
if 0
    if isempty(he)
        he=repmat({''},[ 1 3]) ;
    end
    
    %% predefined file-rename
    newname       =repmat({''}, [size(v.tb,1) 1]);
    extractvolnum =repmat({''}, [size(v.tb,1) 1]);
    if ~isempty(he{1})
        for i=1:size(he,1)
            id=regexpi2(v.tb(:,1), ['^' he{i,1}] );
            if ~isempty(id)
                newname(id,1)       = he(i,2);
                extractvolnum(id,1) = he(i,3);
            end
        end
    end
    
    
    %% NO_GUI
    if showgui == 0
        tb       = [v.tb(:,1)  newname extractvolnum ] ;
        ishange=find(~cellfun('isempty' ,tb(:,2))) ;
        if isempty(ishange)
            he=[];
            tbout=tb;
        else
            he= tb(ishange,1:3);
            tbout=tb;
        end
        return
    end
    
    %% GUI
    tb       = [v.tb(:,1)  newname  extractvolnum  v.tb(:,2:end) ] ;
    %  tbh      = [ v.tbh(1)  'NEW FILENAME (no extension)' 'TASK (extract volnum)' v.tbh(2:end)];
    %  tbh      = [ v.tbh(1)  'NEW FILENAME               ' 'TASK                 ' v.tbh(2:end)];
    tbh      = [ v.tbh(1)  'NEW FILENAME_______________' 'TASK_________________' v.tbh(2:end)];
    
    
    
    % tb    =tb(: ,[1 end 2:end-1 ]); % 2nd element is new name
    % tbh   =tbh(:,[1 end 2:end-1 ]);
    tbh{1}='Filename';  %give better name
    tbh   =upper(tbh);
    
end
%% ===============================================


tbeditable=[0 1 1   zeros(1,length(v.tbh(2:end))) ]; %EDITABLE

if 0
    if size(tb,2)<length(tbh)
        tb=[tb repmat({''},[1 length(tbh)-size(tb,2)])];
    end
    for i=1:size(tbh,2)
        addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
        tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
    end
end

isFig=0;
if ~isempty(findobj(0,'tag','xrename'))
    isFig=1;
end

if isFig==0
    % make figure
    f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.0867    0.6000    0.8428]);
    set(f,'visible','off');
    set(f,'tag','xrename');
    tx=uicontrol('style','text','units','norm','position',[0 .95 1 .05 ],...
        'string',      '..rename/copy/delete/extract/expand NIFTIs, see [help]...',... % UPPER-TITLE
        'fontweight','bold','backgroundcolor','w','tag','msg');
    
    
    [~,MLvers] = version;
    MatlabVersdate=str2num(char(regexpi(MLvers,'\d\d\d\d','match')));
    if MatlabVersdate<=2014
        
        t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table',...
            'ColumnName',tbh, 'ColumnEditable',logical(tbeditable));
    else
        
        t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table',...
            'ColumnWidth','auto');
        t.ColumnName =tbh;
    end
    
    %columnsize-auto
    % set(t,'units','pixels');
    % pixpos=get(t,'position')  ;
    % set(t,'ColumnWidth',{pixpos(3)/2});
    % set(t,'units','norm');
    t.ColumnEditable =logical(tbeditable ) ;% [false true  ];
    t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
    

    % waitspin(1,'wait...');
    drawnow;
    
    ht=findobj(gcf,'tag','table');
    jscrollpane = javaObjectEDT(findjobj(ht));
    viewport    = javaObjectEDT(jscrollpane.getViewport);
    jtable      = javaObjectEDT( viewport.getView );
    % set(jtable,'MouseClickedCallback',@selID)
    set(jtable,'MousemovedCallback',@mousemovedTable);
    
    set(jtable,'MouseClickedCallback',@mouseclickedTable);
    
    
    h={' '};
    h0={};
    h0{end+1,1}=[' '];
    h0{end+1,1}=[' ##m   *** [ ' upper(mfilename)  '] ***'   ];
    h0{end+1,1}=[' _______________________________________________'];
    hlp=help(mfilename);
    h=[h0; strsplit2(hlp,char(10))' ; h ];
    
    setappdata(gcf,'phelp',h);
    
    stack = dbstack('-completenames');
    funcname=mfilename;
     if ~isempty(find(strcmp({stack.name},'xop')))
        funcname=[mfilename '.m' ' or ' 'xop.m' ];
    end
    set(gcf,'name',[' manipulate file [' funcname ']'],'NumberTitle','off');
    set(gcf,'SizeChangedFcn', @resizefig);
    % ==============================================
    %%   controls
    % ===============================================
    
    %% HELP
    pb=uicontrol('style','pushbutton','units','norm','position',[.45 0 .15 .03 ],'string','Help','fontweight','bold','backgroundcolor','w',...
        'callback' ,@getHELP);
%         'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
    set(pb,'tooltipstring','get some help');
    set(pb,'units','pixels');
    
    %% OK
    pb=uicontrol('style','pushbutton','units','norm','position',[.05 0 .15 .03 ],'string','OK','fontweight','bold','backgroundcolor','w' );%@renameFile
    set(pb,'tooltipstring','OK..proceed','tag','ok');
    %set(pb, 'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));' );
    set(pb, 'callback',{@isOK,1});
    set(pb,'units','pixels');
    
    %% CANCEL
    pb=uicontrol('style','pushbutton','units','norm','position',[.8 0 .15 .03 ],'string','CANCEL','fontweight','bold','backgroundcolor','w');
    %set(pb, 'callback',   'set(gcf,''userdata'',0);'       )   ;%@renameFile
    set(pb, 'callback',{@isOK,0});
    set(pb,'tooltipstring','cancel');
    set(pb,'units','pixels');
    
    %% ===============================================
    %% filefilter
    options = {'.*.nii','.*.txt','.*','.*.xls|.*.xlsx' };
    if isfield(s,'flt')
        is=find(strcmp(options,s.flt));
        if ~isempty(is)
            options=  options([is setdiff(1:length(options),is)]);
        else
            options=[s.flt options];
        end
        
    end
    if exist('pin') ==1
        if isfield(pin,'pos')
            set(f,'position',pin.pos);
        end
    end
    set(f,'visible','on');
    
    position = [10,100,90,20];  % pixels
    hContainer = gcf;  % can be any uipanel or figure handle
    
    model = javax.swing.DefaultComboBoxModel(options);
    [jCombo hb] = javacomponent('javax.swing.JComboBox', position, hContainer);
    jCombo.setModel(model);
    jCombo.setEditable(true);
    set(hb,'position',[250 2 70 18]); %set final position
    set(hb,'tag', 'filterfile');
    set(jCombo,'ActionPerformedCallback',@filterfilelist);
    jCombo.setToolTipText('file filter');
    %% ===============================================
    %% filefilter-txt
%     hv=uicontrol('style','text','units','pixels','position',[0 0 10 10 ],...
%         'string','file-filter','backgroundcolor','w');
%     set(hv,'position',[250 20 130 18],'horizontalalignment','left');
    
    
    %% ===============================================
%   if exist('pin') ==1
%       if isfield(pin,'pos')
%          set(f,'position',pin.pos); 
%       end
%   end
    
    
    us.tb  =tb;
    us.tbh =tbh;
    us.hj =jtable;
    us.s  =s;
    us.he =he;
    us.hj_flt=jCombo;
    us.isOK=0;
    
    set(gcf,'userdata',us);
    % ==============================================
    %%
    % ===============================================
    
    % waitspin(0,'Done!');
    drawnow;
    
    % ==============================================
    %%   context menu
    % ===============================================
    contextmenu_make();
else %fig exists
    %keyboard
    f=gcf;
    us=get(f,'userdata');
    ht=findobj(0,'tag','table');
    ht.Data=tb;
    us.tb   =tb;
    us.tbh  =tbh;
    set(f,'userdata',us);
end


% ==============================================
%%   wait
% ===============================================
uiwait(gcf)

% waitfor(f, 'userdata');
% disp('geht weiter');


try
    
    u=get(gcf,'userdata');
    tb=u.tb;
    
    %tb=get(f,'userdata');
    %% cancel
    if u.isOK==0;%isnumeric(tb)
        he=[];
        tbout=tb;
        close(f);
        return;
    end
    
    %%
    ht=findobj(gcf,'tag','table');
    tb   =ht.Data;
    tbout=tb;
    ishange=find(~cellfun('isempty' ,ht.Data(:,2)));
    % ikeep=find(cellfun('isempty' ,tb(:,2))) ;
    %ishange=find(~cellfun('isempty' ,tb(:,2))) ;
    if isempty(ishange)
        he=[];
        tbout=tb;
    else
        he= tb(ishange,1:3);
        tbout=tb;
    end
    close(f);
catch
    [he tbout]=deal({});
end

if u.isOK==1
    isOKpressed=1;
    
end


function isOK(e,e2,task)
u=get(gcf,'userdata');
if task==1
    u.isOK=1;
    set(gcf,'userdata',u);
end
uiresume(gcf);


function getHELP(e,e2)

stack = dbstack('-completenames');
funcname=mfilename;
if ~isempty(find(strcmp({stack.name},'xop')))
   funcname='xop'; 
end
h=help(mfilename);
if strcmp(funcname,'xop')
   h= strrep(h,'xrename','xop');
end
uhelp([h]);

function filterfilelist(e,e2)

% disp('iii')
us=get(gcf,'userdata');
flt=char(us.hj_flt.getSelectedItem);
v=getuniquefiles( us.s.pa,'flt',flt);
ht=findobj(gcf,'tag','table');
[ v2,he2 ]=parse4gui(v,[]);
ht.Data=v2.tb;  % set table

us.tb  =v2.tb;
us.htb =v2.tbh;
us.he  =he2;
set(gcf,'userdata',us);

% he      =us.he;
% showgui =1;
% s       =us.s;
% [he tbout]=renamefiles(v,he,s, showgui);
% 's'



function contextmenu_make()
us=get(gcf,'userdata');
ht=findobj(gcf,'tag','table');
cmenu = uicontextmenu;
% hs = uimenu(cmenu,'label','enter 2nd & 3rd column',             'Callback',{@hcontext, 'enter2and3'},'separator','on');
hs = uimenu(cmenu,'label','enter 2nd & 3rd column extended',     'Callback',{@hcontext, 'enter2and3_extended'},'separator','on');


hs = uimenu(cmenu,'label','copy & rename file'    ,         'Callback',{@hcontext, 'copyNrename'},'separator','off');
hs = uimenu(cmenu,'label','rename file'           ,         'Callback',{@hcontext, 'rename'},'separator','off');

hs = uimenu(cmenu,'label','<html><font color=orange>clear SELECTION: all fields'      ,  'Callback',{@hcontext, 'clearfields_sel'}      ,'separator','on');
hs = uimenu(cmenu,'label','<html><font color=orange>clear SELECTION: "NEW FILENAME"'  ,  'Callback',{@hcontext, 'clearfields_sel_file'} ,'separator','off');
hs = uimenu(cmenu,'label','<html><font color=orange>clear SELECTION: "TASK"'          ,  'Callback',{@hcontext, 'clearfields_sel_task'} ,'separator','off');

hs = uimenu(cmenu,'label','<html><font color=red   >clear ALL: all fields'            ,  'Callback',{@hcontext, 'clearfields'}          ,'separator','on');
hs = uimenu(cmenu,'label','<html><font color=red   >clear ALL: "NEW FILENAME"'        ,  'Callback',{@hcontext, 'clearfields_file'}     ,'separator','off');
hs = uimenu(cmenu,'label','<html><font color=red   >clear ALL: "TASK"'                ,  'Callback',{@hcontext, 'clearfields_task'}     ,'separator','off');

hs = uimenu(cmenu,'label','delete file'           ,         'Callback',{@hcontext, 'deleteFile'},'separator','on');


hs = uimenu(cmenu,'label','<html><font color=blue>replace header'           ,      'Callback',{@hcontext, 'replaceHeader'},'separator','on');


hs = uimenu(cmenu,'label','<html><font color=green>  show file info'        ,         'Callback',{@hcontext, 'showimageinfo'},'separator','on');
hs = uimenu(cmenu,'label','<html><font color=green>  open file'             ,         'Callback',{@hcontext, 'openfile'},'separator','on');


% hs = uimenu(cmenu,'label','show current image using MRICRON',         'Callback',{@hcontext, 'showMRICRON'},'separator','off');
% hs = uimenu(cmenu,'label','open folder of current image',                     'Callback',{@hcontext, 'openPath'},'separator','off');
%
%
% hs = uimenu(cmenu,'label','select all files from this folder (colum-wise selection)',         'Callback',{@hcontext, 'selallfilefromdir'},'separator','on');
% hs = uimenu(cmenu,'label','deselect all files from this folder (colum-wise selection)',       'Callback',{@hcontext, 'deselallfilefromdir'});
%
% hs = uimenu(cmenu,'label','select this files from all folders (row-wise selection)',      'Callback',{@hcontext, 'selfilefromalldir'},'separator','on');
% hs = uimenu(cmenu,'label','delect this files from all folders (row-wise selection)',       'Callback',{@hcontext, 'deselfilefromalldir'});
%
% hs = uimenu(cmenu,'label','select all',         'Callback',{@hcontext, 'selectall'},'separator','on');
% hs = uimenu(cmenu,'label','deselect all',       'Callback',{@hcontext, 'deselectall'});

set(ht,'UIContextMenu',cmenu);


function pan_callback(e,e2,task)
if strcmp(task,'pop1')
    he=findobj(gcf,'tag','pan_ed_col2');
    hb=findobj(gcf,'tag','pan_pop_col2');
    insert=regexprep(hb.String{hb.Value},{'(.*\)','\s+'},'');
    set(he,'string',insert);
elseif strcmp(task,'pop2')
    he=findobj(gcf,'tag','pan_ed_col3');
    hb=findobj(gcf,'tag','pan_pop_col3');
    
    list=get(hb,'userdata');
    set(he,'string',list{hb.Value,1});
    %     set(he,'string',hb.String{hb.Value});
elseif strcmp(task,'cancel')
    set(findobj(gcf,'tag','pan1'),'userdata','cancel');
    %     delete(findobj(gcf,'tag','pan1'));
    delete(findobj(gcf,'tag','pan_ed_cancel'));
    delete(findobj(gcf,'tag','hsim_pbmovepan'));
    %uiresume(gcf);
elseif strcmp(task,'ok')
    set(findobj(gcf,'tag','pan1'),'userdata','ok');
    delete(findobj(gcf,'tag','pan_ed_cancel'));
    delete(findobj(gcf,'tag','hsim_pbmovepan'));
end

function hcontext(e,e2,task)
us=get(gcf,'userdata');



if ~strcmp(task,'showimageinfo') && ~strcmp(task,'openfile')
    % if strcmp(task,'enter2and3') || strcmp(task,'copyNrename') || strcmp(task,'rename') ||...
    %         strcmp(task,'deleteFile') ||  strcmp(task,'enter2and3_extended') ||  strcmp(task,'clearfields')
    e=us.hj;
    selrows=get(e,'SelectedRows');
    if isempty(selrows)
        disp(' first select one/several rows before using the context menu');
    end
    
    
    if strcmp(task,'enter2and3')
        
        
        prompt = {[' [column-2] ' us.tbh{2} ' ..Enter here'] [' [column-3] ' us.tbh{3} ' ..Enter here']};
        dlg_title = 'same operation on different files --> see help for more information';
        num_lines = [ones(size(prompt')) ones(size(prompt'))*75];
        defaultans = {'' ''};
        out = inputdlg(prompt,dlg_title,num_lines,defaultans);
        
    elseif strcmp(task,'enter2and3_extended')
        % ==============================================
        %%
        % ===============================================
        ht= findobj(gcf,'tag','table');
        
        delete(findobj(0,'tag','pan1'));
        hf=findobj(gcf,'tag','xrename');
        fig_unit=get(hf,'units');
        set(hf,'units','pixels');
        figposPix=get(hf,'position');
        set(hf,'units',fig_unit);
        
        panpos=[[230 300   270 120]];
        panpos=[200 figposPix(4)-120-100  270 120];
        hp = uipanel('Title','enter 2nd/3rd column','FontSize',8,...
            'BackgroundColor','white','units','pixels','tag','pan1');
        set(hp,'position',panpos);
        
        
        %% ==============pan-tool=================================

        img=[129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
            129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
            129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
            129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
            129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
            129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
            129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
            0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
            0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
            129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
            129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
            129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
            129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
            129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
            129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
            129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];
        img=uint8(img);
        img(img==img(1,1))=255;
        if size(img,3)==1; img=repmat(img,[1 1 3]); end
        img=double(img)/255;
        %% ______________
        
        hv=uicontrol('style','pushbutton','units','pixels','tag', 'hsim_pbmovepan');
        set(hv,'position',[panpos(1) panpos(2)+panpos(4) .015 .015],'string','',...
            'CData',img,'tooltipstr',['shift panel position' char(10) 'left mouseclick+move mouse/trackpad pointer position' ]);%, 'callback', {@changecolumn,-1} );
        set(hv,'position',[panpos(1)+panpos(3)-17 panpos(2)+panpos(4)-17 15 15 ]);
        je = findjobj(hv); % hTable is the handle to the uitable object
        set(je,'MouseDraggedCallback',{@hsim_motio,hp}  );
        % set(hp,'units','pixels');
        % pos=get(hp,'position');
        % set(hp,'position',[pos(1:2) 16 16]);
        % set(hp,'units','norm');
        set(hv,'tooltipstring',[...
            '<html><b>drag icon to move panel</b>']);
        
        %% ===============================================
        %% ================[column2]===============================
        %TXT-col2
        hb=uicontrol(hp,'style','text','units','norm','tag','pan_tx_col2','string','column-2: NEW FILENAME');
        set(hb,'position',[0    .75   .8 .2],'backgroundcolor','w','horizontalalignment','left');
        set(hb,'foregroundcolor','b');
        
        hb=uicontrol(hp,'style','edit','units','norm','tag','pan_ed_col2');
        set(hb,'position',[0    .6  .5 .2]);
        set(hb,'tooltipstring','enter new filename (column-2) here or choose from right popup-menu');
        
        list1=unique(ht.Data(:,2));
        list1(strcmp(list1, ''))=[];
        list1=[list1 ; {''} ;'t2.nii';'_test1.nii'  ;'_test2.nii' ;'p:V_ (ADD FILENAME-PREFIX: here "V_")'; 's:_s (ADD FILENAME-SUFFIX: here "_s")' ];
        
        %TXT-selectable options
        hb=uicontrol(hp,'style','text','units','norm','string','selectable options');
        set(hb,'position',[.55   .75   .8 .2],'backgroundcolor','w','horizontalalignment','left');
        set(hb,'foregroundcolor','k');
        
        hb=uicontrol(hp,'style','popupmenu','units','norm','tag','pan_pop_col2');
        set(hb,'position',[.55  .6 .45 .2],'string',list1);
        set(hb,'tooltipstring','selected item from popup-menu is used to fill the left edit box');
        set(hb,'callback',{@pan_callback,'pop1'});
        
        
        
        %% ================[column3]===============================
        %TXT-col3
        hb=uicontrol(hp,'style','text','units','norm','tag','pan_tx_col2','string','column-3: TASK');
        set(hb,'position',[0     .4 .8 .2],'backgroundcolor','w','horizontalalignment','left');
        set(hb,'foregroundcolor','b');
        
        
        hb=uicontrol(hp,'style','edit','units','norm','tag','pan_ed_col3');
        set(hb,'position',[0     .25 .5 .2]);
        set(hb,'tooltipstring','enter code here for column-3 or choose from right popup-menu');
        
        list2=unique(ht.Data(:,3));
        list2(strcmp(list2, ''))=[];
        %list2=[list2 ; {''} ;':';'copy';'del'; '1:ends' ];
        lis={...
            ':'       'copy this file ("copy", same as ":")'
            'del'     'delete this file ("del", same as "##")'
            '1'       'extract 1st 3D volume ("1")'
            '1:ends'  'expand entire 4D-file to separate 3D-files ("1:ends")'
            '1:3s'    'expand the first 3D-volumes of 4D-file to separate 3D-files ("1:3s")'
            ''        'empty this field'
            'tr: i<=3=0'               'THRESHOLD image: set all values <=3 to ZERO  '
            'tr: i<=3=1;i>20=20;'      'THRESHOLD image: set all values <=3 to ONE; and values >20 t0 20  '
            'tr: i~=0=1;'              'THRESHOLD image: set all non-zero values to ONE'
            'R:0;ME'                   'REPLACE values: zeros replaced by data defined by MEAN&STD of IMAGE)'
            'R:<2;2'                   'REPLACE values: value of two replace by two'
            'dt:64'                    'DATA-TYPE: set data-type to 64'
            'vr: 0.1 0.1 0.1'          'VOXEL-RESOLUTION: change voxelresolution to [0.1 0.1 0.1]'
            'vr: nan 0.1 nan'          'VOXEL-RESOLUTION: change 2nd dim of voxelresolution to [0.1] keep orig. value for other dims'
            'vs: 0.1 0.1 0.1'          'set VOXEL-SIZE: set voxel-size to [0.1 0.1 0.1] (change header only)'
            'vs: 0.05'                 'set VOXEL-SIZE: set voxel-size to [0.05 0.05 0.05] (change header only)'
            'rmvol:6'                  'remove 6th volume of 4D-NIFTI-file'
            'mean:'                    '[mean:]   mean over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'median:'                  '[median:] median over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'sum:'                     '[sum:]    sum over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'max:'                     '[max:]    max over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'min:'                     '[min:]    min over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'zscore:'                  '[zscore:] zsore over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'std:'                     '[std:]    std over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'var:'                     '[var:]    variance over 4th dimension of 4D-NIFTI-file (4D NIFTI only) '
            'rHDR:'                    '[rHDR:]   replace NIFTI-header by reference file which is tagged with ''ref'''
            'rmat:'                    '[rmat:]   replace NIFTI-mat by  mat of reference file which is tagged with ''ref'''
            'gzip:'                    '[gzip:]   gzip NIFTI-file (saved as *.nii.gz)'
            'gunzip:'                  '[gunzip:] gunzip (*.nii.gz) file (saved as *.nii) '
            'niifun:myfun.m'           '[niifun: myfun.m] apply function "myfun" to NIFTIfile (see help)' 
            };
        

        listbk=[[list2 ; {''} ;lis(:,1) ] [list2 ; {''} ;lis(:,2) ]];
        
        
         %TXT-selectable options
        hb=uicontrol(hp,'style','text','units','norm','string','selectable options');
        set(hb,'position',[.55   .4   .8 .2],'backgroundcolor','w','horizontalalignment','left');
        set(hb,'foregroundcolor','k');
        
        hb=uicontrol(hp,'style','popupmenu','units','norm','tag','pan_pop_col3');
        set(hb,'position',[.55   .25 .45 .2],'string',listbk(:,2));
        set(hb,'tooltipstring','selected item from popup-menu is used to fill the left edit box');
        set(hb,'callback',{@pan_callback,'pop2'});
        set(hb,'userdata',listbk)
        
        %----------ok/cancel-------
        hb=uicontrol(hp,'style','pushbutton','units','norm','tag','pan_ed_ok');
        set(hb,'position',[0.1    0  .3 .2],'string','OK');
        set(hb,'tooltipstring','ok..insert fields now');
        set(hb,'callback',{@pan_callback,'ok'});
        
        hb=uicontrol(hp,'style','pushbutton','units','norm','tag','pan_ed_cancel');
        set(hb,'position',[.6    0  .3 .2],'string','Cancel');
        set(hb,'tooltipstring','cancel operation');
        set(hb,'callback',{@pan_callback,'cancel'});
        
        
        %hb=findobj(gcf,'tag','pan1');
        hdel=findobj(gcf,'tag','pan_ed_cancel');
        waitfor(hdel);
        
        
        hb=findobj(gcf,'tag','pan1');
        col2=get(findobj(gcf,'tag','pan_ed_col2'),'string');
        col3=get(findobj(gcf,'tag','pan_ed_col3'),'string');
        out={col2 col3};
        isOK=strcmp(get(hb,'userdata'),'ok');
        delete(hb);
        if isOK==0
            return
        end
        
        % ==============================================
        %%
        % ===============================================
        
        
    elseif strcmp(task,'copyNrename')
        prompt = {[' enter new filename ']};
        dlg_title = 'copy and  rename file';
        num_lines = [ones(size(prompt')) ones(size(prompt'))*75];
        defaultans = {''};
        out = inputdlg(prompt,dlg_title,num_lines,defaultans);
    elseif strcmp(task,'rename')
        prompt = {[' enter new filename ']};
        dlg_title = 'rename file';
        num_lines = [ones(size(prompt')) ones(size(prompt'))*75];
        defaultans = {''};
        out = inputdlg(prompt,dlg_title,num_lines,defaultans);
    elseif strcmp(task,'deleteFile')
        out={'','del'};
    elseif strcmp(task,'clearfields') || strcmp(task,'clearfields_task') || strcmp(task,'clearfields_file') ||...
           strcmp(task,'clearfields_sel') || strcmp(task,'clearfields_sel_task') || strcmp(task,'clearfields_sel_file') 
        out={'',''};
        if strcmp(task,'clearfields') || strcmp(task,'clearfields_task') || strcmp(task,'clearfields_file')
            selrows=[1:size(us.tb,1)]-1;
        end
        
        modx=[0 0];
        if     strcmp(task,'clearfields'     ) || strcmp(task,'clearfields_sel')       ; modx=[1 1];
        elseif strcmp(task,'clearfields_file') || strcmp(task,'clearfields_sel_file')  ; modx=[1 0];    
        elseif strcmp(task,'clearfields_task') || strcmp(task,'clearfields_sel_task')  ; modx=[0 1]; 
        end
        
        jtable=e;
        if length(out)==2
            for i=1:length(selrows)
                if modx(1)==1;
                jtable.setValueAt(java.lang.String(''), selrows(i), 1); % to insert this value in cell (1,1)
                end
                if modx(2)==1;
                jtable.setValueAt(java.lang.String(''), selrows(i), 2); % to insert this value in cell (1,1)
                end
            end
        end
        
        return
    elseif strcmp(task,'replaceHeader')
        %% ===============================================
        
        q={...
            'inf1'   'click [BULB]-icon for help' '' ''
            'image'    '' 'use header of this image: either as fullpath name or the patheless name of a file located in the animal directory' 'f'
            'mat'      [] 'INSTEAD OFF "imageSource": use this transformation-matrix ' {'[1 0 0 1;0 1 0 1;0 0 1 1;0 0 0 1]'}
            'trans'    [] 'INSTEAD OFF "imageSource": translate image by [dx,dy,dz] mm  ' {'[0 0 0]'; '[1 1 1]'; '[1 0 0]' ; '[0 0 1]'}
            'rot'      [] 'INSTEAD OFF "imageSource": rotate image by [dx,dy,dz] radians ' {'[0 0 0]'; '[0.1 0.1 0.1]'; '[0.1 0 0]' ; '[0 0 0.1]'}
            'flipdim'  [] 'flip dimensions by index {1,2,3}: {1} Left/Right, {2} up/down and/or {3} anterior/posterior ... for the respective dimension: example [1 2]: flips L/R and up/down  dimension  ' {'' '1 2' '2' '1' '1 2 3'  }'
            'dt'       [] 'change dataType of the stored image; (empty: preserve orig. dataType)'  { [] 2      4      8   16   64}
            'descrip'  '' 'add arbitrary description {string} in the description-field of the header'  {'' '..test any text can be provided here' 't2w-image'}
            };
        
        hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
        
        [m z z2]=paramgui(q,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.3 .34 .5 .16 ],...
            'title','***CHANGE NIFTI-HEADER***','info',{@uhelp,[ mfilename '.m'],1,'goto','change header (ch:)'});
        if isempty(m); return; end
        fn=fieldnames(z);
        z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
        %% ===============================================
        z.image=char(z.image);
        fn=fieldnames(z);
        t1={};
        for j=1:length(fn)
            dx=(getfield(z,fn{j}));
            
            if ~isempty(dx)
                if isnumeric(dx)
                    if size(dx,1)==1
                        dx=['[' num2str(dx)  ']'];
                    else
                        dx=strjoin(cellstr(num2str(dx)),';');
                        dx=['[' (dx)  ']'];
                    end
                    dx=regexprep(dx,'\s+' ,' ');
                end
                
                
                t1(end+1,1)={ [fn{j} ':'  dx ]};
            end
        end
        if isempty(t1)
            return
        end
        t2=[ 'ch:' strjoin(t1,';')];
        out{2}=t2;
        
        
        %% ===============================================
        
        
        
        %% ===============================================
        
        
    end
    
    
    
    if length(out)==0;         return ;    end
    
    if strcmp(task,'copyNrename'); out{2}=':'; end
    if strcmp(task,'rename');      out{2}=''; end
    
    jtable=e;
    
    for i=1:length(selrows)
        if ~isempty(out{1})
            jtable.setValueAt(java.lang.String(out{1}), selrows(i), 1); % to insert this value in cell (1,1)
        end
    end
    if length(out)==2
        for i=1:length(selrows)
            jtable.setValueAt(java.lang.String(out{2}), selrows(i), 2); % to insert this value in cell (1,1)
        end
    end
    
else
    if strcmp(task,'openfile')
        %% ===============================================
        e=us.hj;
        iselrows=get(e,'SelectedRows')+1;
        files=us.tb(iselrows,1);
        show_file(files);
        out=[];
        %% ===============================================
        
        
    else
    % elseif strcmp(task,'showimageinfo')
    e=us.hj;
    iselrows=get(e,'SelectedRows')+1;
    files=us.tb(iselrows,1);
    show_imageinfo(files);
    end
end

%% ===============================================
function hsim_motio(e,e2,hpa)
if 1%try
    units=get(0,'units');
    set(0,'units','norm');
    mp=get(0,'PointerLocation');
    set(0,'units',units);
    
    fp  =get(gcf,'position');
    hp  =findobj(gcf,'tag','hsim_pbmovepan');
    set(hp,'units','norm');
    pos =get(hp,'position');
    set(hp,'units','pixels');
    mid=pos(3:4)/2;
    newpos=[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4))];
    if newpos(1)-mid(1)<0; newpos(1)=mid(1); end
    if newpos(2)-mid(2)<0; newpos(2)=mid(2); end
    if newpos(1)-mid(1)+pos(3)>1; newpos(1)=1-pos(3)+mid(1); end
    if newpos(2)-mid(2)+pos(4)>1; newpos(2)=1-pos(4)+mid(2); end
    df=pos(1:2)-newpos+mid;
    hx=[hp hpa];
    for i=1:length(hx)
        set(hx(i),'units','norm');
        pos2=get(hx(i),'position');
        pos3=[ pos2(1:2)-df   pos2([3 4])];
        if length(hx)==1
            set(hx,'position', pos3);
        else
            set(hx(i),'position', pos3);
        end
        set(hx(i),'units','pixels');
    end
end
%% ===============================================
function show_file(files);

%% ===============================================
us=get(gcf,'userdata');
pa=us.s.pa;
t2={};
for j=1:length(files)
    for i=1:size(pa,1)
        fn=fullfile(pa{i},files{j});
        [~,animal]=fileparts(pa{i});
       t2(end+1,:)= { animal files{j} double(exist(fn)==2)  fn}; 
    end
end
htb={'animal' 'image'  'exist'}
t2=cellfun(@(a) {[  num2str(a) ]},t2);
id=selector2(t2(:,1:3),htb,'iswait',1,'position',[0.0903    0.1561    0.3767    0.6211],...
    'title','select files to open');
if isempty(id) || id(1)==-1
   return
end
t2=t2(id,:);
for i=1:size(t2,1)
    fis=t2{i,4};
    if exist(fis)==2
        [~,~, ext]=fileparts(fis)
        if ~isempty(regexpi2({ext},'.nii|.gz|.hdr|.img'))
        rmricron([], fis,[],1);
        else
            if ispc
                winopen(fis);  % Windows: uses the default program
            elseif ismac
                system(['open "', fis, '" &']);  % macOS: open with default
            elseif isunix
                system(['xdg-open "', fis, '" &']);  % Linux: open with default
%             else
%                 error('Unsupported OS');
            end
            
        end
    end
    drawnow
end





%% ===============================================



function show_imageinfo(files);
us=get(gcf,'userdata');
pa=us.s.pa;
%———————————————————————————————————————————————
%%  image information
%———————————————————————————————————————————————
filelist={};
for j=1:length(files)
    filelist=[filelist; {' #ky num' [' #ko FILE #b "' files{j} '"' ] ''}];
    for i=1:size(pa,1)
        fn=fullfile(pa{i},files{j});
        fn2={i fn ' #g file exist'};
        if exist(fn)~=2
            fn2={i fn ' #r file not found'};
        end
        filelist=[filelist; fn2];
    end
    filelist=[filelist; repmat({''},1,size(filelist,2))];
end
% uhelp( plog([],[ filelist],0, '','al=1;space=0' ),1);
% oo=plog([],[ filelist],0, ' #wk *** [1] FILE INFORMATION ***','al=1;space=0' );
oo=plog([],[ filelist],0, '','al=1;space=0;plotlines=0' );

% uhelp(oo);
% % ==============================================
%%   more specific info
% ===============================================
o={};
for i=1:size(filelist,1)
    if ~isempty(strfind(filelist{i,1},'num'))
        o(end+1,1)={[ '  #ko ' repmat(' ',[1 70]) ]};
        o(end+1,1)={[ ' ' filelist{i,2}] };
        o(end+1,1)={[ '  #ko ' repmat(' ',[1 70]) ]};
    elseif isnumeric(filelist{i,1})
        
        
        o=[o; [' #k ' cell2line(filelist(i,:),1,' ')]];
        
        if isempty(strfind(filelist{i,3},'not'))
            file=filelist{i,2};
            [~,~,fmt]=fileparts(file);
            if strcmp(fmt,'.nii')
                h1=spm_vol(file);
                dim4=length(h1);
                h1=h1(1);
                h1.dim=[h1.dim dim4]; %add 4th dim
                %
                
                t={};
                t=[t; '   dim:     ' sprintf('[%d %d %d %d]',[h1.dim ]) ];
                t=[t; '   dt:      ' sprintf('[%d %d]',[h1.dt ]) ];
                if sum(h1.pinfo==round(h1.pinfo))
                    t=[t; '   pinfo:   ' sprintf('[%d %d %d]',[h1.pinfo ]) ];
                else
                    t=[t; '   pinfo:   ' sprintf('[%2.5f %2.5f %2.5f]',[h1.pinfo ]) ];
                end
                t=[t; '   mat:     '];
                mat=plog([],num2cell(h1.mat),[0],'s','plotlines=0;d=4');
                t=[t; cellfun(@(a) {[ repmat(' ',[1 10]) a]},  mat)];
                %t=[t; plog([],num2cell(h1.mat),[0],'s','plotlines=0')];
                t=[t; '   n:       ' sprintf('[%d %d]',[h1.n ]) ];
                t=[t; '   descrip: ' h1.descrip ];
                t=[t; repmat('-',[1 70])];
                o=[o; t];
            else
                %% ===============================================
                
                k=dir(file);
                t={};
                t=[t; '      date:     ' k.date ];
                t=[t; '  size(KB):     ' num2str(k.bytes/1000) ];
                
                o=[o; t];
                
                %% ===============================================
                
            end
        else
            o=[o; repmat('-',[1 70])];
        end
        %         o=[o; {'';'';''}];
    end
end
o=[o; {'';'';''}];
uhelp([' #wk *** [1] FILE INFORMATION ***'; oo; ' '; ' #wk *** [2] HEADER INFORMATION ***';' '; o]);
set(gcf,'name','file information','numbertitle','off');




% ==============================================
%%
% ===============================================
function mouseclickedTable(e,e2)


if get(e2,'Button')==3 %context menu
    
    
    return
    us=get(gcf,'userdata');
    ht=findobj(gcf,'tag','table');
    
    
    cmenu = uicontextmenu;
    
    hs = uimenu(cmenu,'label','show current image in Matlab',         'Callback',{@hcontext, 'showImageIntern'},'separator','on');
    hs = uimenu(cmenu,'label','show current image using MRICRON',         'Callback',{@hcontext, 'showMRICRON'},'separator','off');
    hs = uimenu(cmenu,'label','open folder of current image',                     'Callback',{@hcontext, 'openPath'},'separator','off');
    
    
    hs = uimenu(cmenu,'label','select all files from this folder (colum-wise selection)',         'Callback',{@hcontext, 'selallfilefromdir'},'separator','on');
    hs = uimenu(cmenu,'label','deselect all files from this folder (colum-wise selection)',       'Callback',{@hcontext, 'deselallfilefromdir'});
    
    hs = uimenu(cmenu,'label','select this files from all folders (row-wise selection)',      'Callback',{@hcontext, 'selfilefromalldir'},'separator','on');
    hs = uimenu(cmenu,'label','delect this files from all folders (row-wise selection)',       'Callback',{@hcontext, 'deselfilefromalldir'});
    
    hs = uimenu(cmenu,'label','select all',         'Callback',{@hcontext, 'selectall'},'separator','on');
    hs = uimenu(cmenu,'label','deselect all',       'Callback',{@hcontext, 'deselectall'});
    
    
    set(ht,'UIContextMenu',cmenu);
    
    return
    
    
    
    
    
    % ==============================================
    %% mass rename
    % ===============================================
    selrows=get(e,'SelectedRows');
    prompt = {[' [column-2] ' us.tbh{2} ' ..Enter here'] [' [column-3] ' us.tbh{3} ' ..Enter here']};
    dlg_title = 'same operation on different files --> see help for more information';
    %num_lines = 1;
    defaultans = {'' ''};
    num_lines = [ones(size(defaultans')) ones(size(defaultans'))*75];
    out = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    if length(out)==0
        return
    end
    
    jtable=e;
    
    for i=1:length(selrows)
        jtable.setValueAt(java.lang.String(out{1}), selrows(i), 1); % to insert this value in cell (1,1)
    end
    for i=1:length(selrows)
        jtable.setValueAt(java.lang.String(out{2}), selrows(i), 2); % to insert this value in cell (1,1)
    end
    
    
    % ==============================================
    %%
    % ===============================================
    
end

function resizefig(e,e2)
ht=findobj(gcf,'tag','table'); %table
hb=findobj(gcf,'tag','ok');   %OK-btn

hm=findobj(gcf,'tag','msg'); %message

ht_pos=get(ht,'position');
hm_pos=get(hm,'position');

hbunit=get(hb,'units');
set(hb,'units','norm');
hb_pos=get(hb,'position');
set(hb,'units','pixels');


ht_pos2=[ht_pos(1)  hb_pos(2)+hb_pos(4)  ht_pos(3)   1-(hb_pos(2)+hb_pos(4)+hb_pos(4)/2  )  ];

if ht_pos2(4)<.2
    %     ht_pos2=[ht_pos(1)  hb_pos(2)+hb_pos(4)  ht_pos(3)   1-(hb_pos(2)+hb_pos(4)+hb_pos(4)/2  )  ];
    
    return
end


set(ht,'position',ht_pos2)


% hb_pospix=get(hb,'position');
% set(ht,'units','pixels');
% ht_pos2=get(ht,'position');
% ht_pos3=[ht_pos2(1:3) ht_pos2(4)-hb_pospix(4)/2];
% set(ht,'position',ht_pos3);







%________________________________________________
%%  batch
%________________________________________________
function makebatch(z,p0)
%% ===============================================

stack = dbstack('-completenames');
funcname=mfilename;
% if strcmp({stack(end).name},'xop')
if    ~isempty(find(strcmp({stack.name},'xop')))
   funcname='xop'; 
end

try
    hlp=help(funcname);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ======================================================');
hh{end+1,1}=[ '% BATCH:        [' [funcname '.m' ] ']' ];
% hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ======================================================');

if ~isstruct(p0)
    
    if isempty(z.files{1})
        hh(end+1,1)={[funcname '(' '1'  ');' ]};
    elseif size(z.files,2)==2
        hh=[hh; 'z=[];' ];
        z.files=z.files(:,1:2);
        hh=[hh; struct2list(z)];
        hh(end+1,1)={[funcname '(' '1',  ',z.files(:,1),z.files(:,2)' ');' ]};
    elseif size(z.files,2)==3
        hh=[hh; 'z=[];' ];
        hh=[hh; struct2list(z)];
        hh(end+1,1)={[funcname '(' '1',  ',z.files(:,1),z.files(:,2),z.files(:,3) ' ');' ]};
    end
    
    %===================================================================================================
    %% ===============================================
    
elseif isstruct(p0)
    %% ===============================================
    p0=rmfield(p0,'dummy');
    z2=catstruct(z,p0);
    fn=fieldnames(p0);
    ap={};%additonal parameter
    for i=1:length(fn)
        %         va=getfield(p0,fn{i})
        %         if isnumeric(va);
        %             va=num2str(va);
        %         elseif ischar(va)
        %             va=[ '''' va '''']
        %         end
        %addstr= [addstr '''' fn{i} '''' ',' va ];
        ap{end+1,1}=[ '''' fn{i} ''''];
        ap{end+1,1}=[ 'z.' fn{i}  ];
    end
    if isempty(char(ap))
        aplist='';
    else
        aplist=[ ','  strjoin(ap,',')  ];
    end
    
    % ===============================================
    isDesktop=usejava('desktop');
    if size(z.files,1)>1
        
        hh=[hh; 'z=[];' ];
        hh=[hh; struct2list2(z2,'z')];
        
        reginput={'z.files(:,1)' 'z.files(:,2)' 'z.files(:,3)'};
        
        ac=[reginput(1:size(z.files,2)) ...
            repmat( {'[]'},[1 3-length(reginput(1:size(z.files,2)))])];
        a1=strjoin(ac,',');
        
       
    else
        a1=[  ...
            '''' z.files{1} ''',' ...
            '''' z.files{2} ''',' ...
            '''' z.files{3} '''' ...
          ];
    end
    a2=[ funcname '(' num2str(isDesktop)  ',' a1 ');' ];
    hh(end+1,1)={a2};
    
    
    %disp(char(hh));
    
    %hh(end+1,1)={[mfilename '(''0',',z.files(:,1),z.files(:,2),z.files(:,3) ' ');' ]};
    
    %% ===============================================
    
end


% disp(char(hh));
% uhelp(hh,1);
%% ===============================================

try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa,varargin)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

if nargin==1
    flt='.*.nii*$';
    %flt='.*.txt*$';
else
    p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    flt=p.flt;
end

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},flt);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
% li=unique(fi2);
fi2(cellfun(@isempty, fi2))=[];
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    try
        %         ha=spm_vol(fifull2{i});
        [msg,ha]=evalc('spm_vol(fifull2{i});');
        
        ha0=ha;
        ha=ha(1);
        if length(ha0)==1
            tb{i,1}='3';
            tag='';
        else
            tb{i,1}='4' ;
            tag= length(ha0);
        end
        tb{i,2}=sprintf('%i '   ,[ha.dim tag]);
        tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
        tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
    catch
        tb(i,2:4)={''};
    end
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];


% ==============================================
%%
% ===============================================
function ccc2=tostruct(ccc)

eval(ccc);
varw=who;
varw(strcmp(varw,'ccc'))=[];
ccc2=struct();
for i=1:length(varw)
    eval(['ccc2.' varw{i} '=' varw{i} ';']); 
end


function waitspin(status,msg)
if status==1
    hv=findobj(gcf,'tag','waitspin');
    try; delete(hv); end
    
    try
        % R2010a and newer
        iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
        iconsSizeEnums = javaMethod('values',iconsClassName);
        SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
        jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, msg);  % icon, label
    catch
        % R2009b and earlier
        redColor   = java.awt.Color(1,0,0);
        blackColor = java.awt.Color(0,0,0);
        jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
    end
    % jObj.getComponent.setFont(java.awt.Font('Monospaced',java.awt.Font.PLAIN,1))
    jObj.setPaintsWhenStopped(true);  % default = false
    jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    [hj hv]=javacomponent(jObj.getComponent, [10,10,80,80], gcf);
    set(hv,'units','norm');
    set(hv,'position',[.6 .2 .20 .20]);
    set(hv,'tag','waitspin')
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    jObj.start;
    
    
    hv=findobj(gcf,'tag','waitspin');
    %     us=get(gcf,'userdata');
    %     us.hwaitspin =hv;
    %     us.jwaitspin =jObj;
    %     set(gcf,'userdata',us);
    setappdata(hv,'userdata',jObj);
    
elseif status==2
    hv=findobj(gcf,'tag','waitspin');
    hv=hv(1);
    jObj=getappdata(hv,'userdata');
    %     us=get(gcf,'userdata');
    %     jObj=us.jwaitspin;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    set(hv,'visible','on');
    drawnow;
elseif status==0
    hv=findobj(gcf,'tag','waitspin');
    hv=hv(1);
    jObj=getappdata(hv,'userdata');
    %us=get(gcf,'userdata');
    %jObj=us.jwaitspin;
    jObj.stop;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(.4667,    0.6745,    0.1882));  % green
    %     pause(.2);
    %jObj.getComponent.setVisible(false);
    %set(us.hwaitspin,'visible','off');
    set(hv,'visible','off');
end
% ===============================================
function mousemovedTable(e,e2)
e2.getPoint;
jtable=e;
% index = jtable.convertColumnIndexToModel(e2.columnAtPoint(e2.getPoint())) + 1
idx=e.rowAtPoint(e2.getPoint())+1;
col=e.columnAtPoint(e2.getPoint())+1;
% disp(col);
% return


% us=get(gcf,'userdata');
% idc=idx+1;
try
    if col==1
        ms=['<html><font color="blue"><b>' 'EXISTING FILES' '</font></b><br>' ...
            '<font color="black">'  ...
            '  you can also select 1/several images and use the context menu' ...
            ''];
    elseif col==2
        ms=['<html><font color="blue"><b>' 'NEW FILENAME' '</font></b><br>'  ...
            '<font color="black">'  ...
            'enter (copy+modify) a new file name here<br>' ...
            '<font color="red">"nii."-extension is not necessary'];
    elseif col==3
        ms=['<html><font color="blue"><b>' 'TASK' '</b></font><br>'  ...
            '<font color="black">'  ...
            '<b>copy file    :</b>  type ":" or "copy" <br>'...
            '<b>rename file  :</b>  type "rename" <br>'...
            '<b>delete file:</b>  type "##" or "del" or "delete"        <br>'...
            '<b>extract 4D-volume:</b>  type index such as "[2 4 10]"   <br>' ...
            '<b>voxel factor     ("vf: .."):</b>  type "vf: 1.5" to scale up image by factor 1.5  <br>' ...
            '<b>voxel resolution ("vr: .."):</b>  type "vr: [0.1 0.1 0.1]" to define a new voxel resolution  <br>' ...
            '<b>math operation   ("mo: .."):</b>  "mo: o=i>.5"  <font color="green"> --> see HELP <font color="black"> <br>' ...
            '<b>threshold image  ("tr: .."):</b>  "tr: i<3=0" to set all values below 3 to zero   <br>' ...
            '<font color="red"> ..Don''t forget to type a new filename in column-2!'
            ];
    else
        us=get(gcf,'userdata');
        colname=us.tbh{col};
        drawnow;
        if col==4
            ms=['<html><font color="blue"><b>' colname '</font></b><br>' ...
                '<font color="black"> number of files found'  ...
                ''];
        else
            ms=['<html><font color="blue"><b>' colname '</font></b><br>' ...
                '<font color="black">'  ...
                ''];
        end
        
        
        
    end
    
    % ms=[us.c{idc,1} char(10) 'ID: '  num2str(us.c{idc,4}) char(10) ...
    %     'children: '  num2str(length(us.c{idc,5}))];
    
    %     ms=['<html><font color="black"><b>' us.c{idc,1} '</font><br>'...
    %         '<font color="red">'       ' ID: ' num2str(us.c{idc,4})       '</font>' ...
    %         '</b><font color="blue">'     ' ; #children: ' num2str(length(us.c{idc,5})) '</font></b><br>' ...
    %         '</b><font color="grey">'     ' VOL (ID) : ' num2str(us.volume(idc)) ' qmm ' '</font></b><br>' ...
    %         '</b><font color="grey">'     ' VOL (tot): ' num2str(us.volumetot(idc)) ' qmm ' '</font></b><br>' ...
    %         ...
    %         '</html>'];
    
    jtable.setToolTipText(ms);
end