
%% #bc [xrename] RENAME/DELETE/EXTRACT/EXPAND/COPY file(s) from selected ant-mousefolders
% #wb THESE TAKSKS CAN BE PERFORMED IN THE MOMENT:
% #b - rename file
% #b - copy+rename file
% #b - delete file
% #b - extract/exand 4d file
% #b - mathematical operation (masking, roi extraction, combining images) ..see below
% #b - set voxel resolution
% #b - scale image by voxel factor
% #b - threshold image
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
% #k 'show image info'    : #n show image information (file paths; existence of files; header information)
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
%% #by voxel resolution (vr:)
% change voxel resolution of an image via  the [TASK]-column
% example: in [TASK]-column type :  "vr: .1 .1 .1" to change the voxel resolution of an image (previous vox resolution was: [.09 .09 .09])
%          "vr: .1 .1 .1"  this is identical to "vr: .1"
% #g change voxel resolution of 'AVGT.nii' to [.1 .1 .1] and save as 'test33.nii'
% z.files={ 'AVGT.nii' 	'test33.nii' 	'vr: .1' };
% xrename(1,z.files(:,1),z.files(:,2),z.files(:,3) );
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
        he{1,2}=finew;
    else
        he(:,1)=fi(:);
        he(:,2)=finew(:);
    end
    he(:,3)=repmat({''},[1 size(he,1)]);
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
            error('extractnum be of same size as fi & finew');
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

v=getuniquefiles(pa);


%———————————————————————————————————————————————
%%  get pairings of old&newfile (optional via gui) and extractionNUmber
%———————————————————————————————————————————————
s.pa=pa; %additional struct
[he tbout]=renamefiles(v,he,s, showgui);
try
    iadd=find(~cellfun(@isempty,  regexpi(tbout(:,3), '^##$|^del$|^delete$')));
    he=[he; tbout(iadd,1:3)];
end
% he
%
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

for i=1:length(pa)      %PATH
    for j=1:length(fi)  %FILE
        s1=fullfile(pa{i},fi{j}); %OLD FILENAME
        if exist(s1)==2  %CHK EXISTENCE
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
                
                [pax fix ex]=fileparts(finew{j});
                s2=fullfile(pa{i},[fix '.nii' ]);
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
                    delete(s1);
                    if exist(s1)==0
                        cprintf([0 .5 0],['file deleted: '  strrep(s1,filesep,[filesep filesep]) '\n']);
                    else
                        cprintf([1 0 1],['could not delete: '  strrep(s1,filesep,[filesep filesep]) '\n']);
                    end
                    
                    
                    
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
                elseif strfind(volnum{j},'vr:'); %vox factor
                    % ==============================================
                    %% voxel resolution
                    % ===============================================
                    try
                        code=volnum{j};
                        vox=str2num(regexprep(code,'vr:' ,''));
                        if length(vox)==1; vox=repmat(vox ,[1 3]); end
                        
                        [ha a ]=rgetnii(s1);
                        if all((mod(a(:),1) == 0))  ;%INTEGER
                            interp=0;
                        else
                            interp=1;
                        end
                        [BB voxold]=world_bb(s1);
                        delete(s2);
                        resize_img5(s1,s2, vox, BB, [], interp);
                        voxsi=sprintf('[%2.3f %2.3f %2.3f]',  voxold(1), voxold(2), voxold(3));
                        voxsi2=sprintf('[%2.3f %2.3f %2.3f]', vox(1)   , vox(2)     ,vox(3));
                        
                        if isDesktop==1
                            disp(['New IMG with altered voxSize: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'...
                                ' new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        else
                            disp(['New IMG with altered voxSize: ' s2 '; new voxSize: ' voxsi2    ' (previous voxSize: ' voxsi ')' ]);
                        end
                        
                        try; delete(regexprep(s2,'.nii$','.mat')); end
                    catch
                        disp('problem with voxel resolution');
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
                    
                    
                    thisvol= lower(volnum{j});
                    save_separately =0;
                    
                    [ha a]   =rgetnii(s1); %MASKexr
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
                        
                        
                        try
                            eval(['hb=ha(' thisvol ');']);
                        catch
                            disp('problem with extraction-index: maybe larger than #volumes stored file');
                            continue
                        end
                        eval(['b=a(:,:,:,' thisvol ');']);
                    end
                    
                    %% delete targetfile if exists
                    if strcmp(thisvol,':')==1
                        if exist(s2)==2
                            delete(s2);
                        end
                    end
                    
                    %% write volume
                    warning off;
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



%________________________________________________
%%  rename files
%________________________________________________
function [he tbout]=renamefiles(v,he,s, showgui)
% keyboard

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

tbeditable=[0 1 1   zeros(1,length(v.tbh(2:end))) ]; %EDITABLE


for i=1:size(tbh,2)
    addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
    tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
end



% make figure
f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.0867    0.6000    0.8428]);
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
    
    %columnsize-auto
    % set(t,'units','pixels');
    % pixpos=get(t,'position')  ;
    % set(t,'ColumnWidth',{pixpos(3)/2});
    % set(t,'units','norm');
    t.ColumnEditable =logical(tbeditable ) ;% [false true  ];
    t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
    
end
% waitspin(1,'wait...');
drawnow;

ht=findobj(gcf,'tag','table');
jscrollpane = javaObjectEDT(findjobj(ht));
viewport    = javaObjectEDT(jscrollpane.getViewport);
jtable      = javaObjectEDT( viewport.getView );
% set(jtable,'MouseClickedCallback',@selID)
set(jtable,'MousemovedCallback',@mousemovedTable);

set(jtable,'MouseClickedCallback',@mouseclickedTable);

% MAKE BUTTONS
% h={' #yg  ***RENAME FILES  ***'} ;
% h{end+1,1}=[' - select one/several imageS TO RENAME/EXTRACT/DELETE'];
% h{end+1,1}=['- dirs:  works on preselected dirs (not all dirs), i..e mouse-folders in [ANT] have to be selected before'];
% h{end+1,1}=[' - [newname]-column contains the new filename (file-extension is not needed)'];
% h{end+1,1}=[' - NOTE: "##" (double-hash) in [NEWNAME]-column will delete the file'];
% h{end+1,1}=[' - NOTE: strings such as "1", "2","1:3","end","end-1:end",":"  (without ""!) in [TASK]-COLUMN WILL EXTRACT THE VOLUME(S) '];
% h{end+1,1}=['         and writes a new file with this data...but only if a new filename in the [NEWNAME]-column is given AND!...'];
% h{end+1,1}=['        the new filename is not "##"'];
% h{end+1,1}=[' - NOTE: to simply rename a file (no deletion/no extraction) the new file is not allowed to be named "##" AND ! the '];
% h{end+1,1}=['         [TASK]-column must be empty'];
% h{end+1,1}=[' ------simple example------'];
% h{end+1,1}=[' #g  to rename  a file:  name in [NEWNAME]-column  is "something" but not "##"   &    [TASK]-COLUMN is empty'];
% h{end+1,1}=[' #g  to delete  a file:  name in [NEWNAME]-column  is "##"'];
% h{end+1,1}=[' #g  to extract a file:  name in [NEWNAME]-column  is "something" but not "##"   &    [TASK]-COLUMN is something like "1", "2","1:3","end","end-1:end",":" (without "")'];
% h{end+1,1}=[''];


% h{end+1,1}=['renaming:  -files are really renamed (no local copies with new filenamse will be created) '];
% h{end+1,1}=['       -ony those files are treated from those folders that have been selected in the [ANT]-gui mouse-folder listbox'];
% h{end+1,1}=['        thus, check the occurence of the specific file (see [#count]-column)'];
% h{end+1,1}=['       -there is no priority in renaming the file, thus in some cases it might be better to call this'];
% h{end+1,1}=['        function sveral times: for example: if A and B files exist in a folder or in several folders and you want to swap the names such that  '];
% h{end+1,1}=['          file-A becoms file-B and vice versa.'];
% h{end+1,1}=['          in such case: {1} call this function and rename file-A to file-ADUMMY, and  file-B to file-BDUMMY  (ADUMMY/BDUMMY are just non-existing,new names in the folder)'];
% h{end+1,1}=['                        {2} call this function AGAIN (!) and rename file-ADUMMY to file-B, and  file-BDUMMY to file-A'];
%
% h{end+1,1}=[' #r 1st column: the original-filename '];
% h{end+1,1}=[' #r 2nd column: NEW-FILENAME:  type a new filename here, if so, this file will be really(!) renamed '];
% h{end+1,1}=['    - no file-extension needed'];
% h{end+1,1}=['    - you can rename as many files as you like'];
% h{end+1,1}=['    - if column-2 is empty this equals cancelling the process '];
% h{end+1,1}=['    - the filename from column-1 can be copied (ctrl+c) and pasted(ctrl+v) in column-2 (to modify it..)'];
% h{end+1,1}=['    - additional option: [##] will delete the file  (2-hash-signs without brackets)'];
% h{end+1,1}=[' #r 3rd column: EXTRACT-VOLNUM:  FOR VOLUME EXTRACTION OR VOLUME EXPANSION: '];
% h{end+1,1}=['     - strings such as "1" , "2" , "1:3" , "end" ,"2:5" , "end-1:end" , ":"   (without ""!)- TO EXTRACT THIS VOLUMES'];
% h{end+1,1}=['     - strings such as "1s", "2s", "1:3s", "ends","2:5s", "end-1:ends", ":s"  (without ""!)- TO EXPAND THIS VOLUMES'];
%
% h{end+1,1}=[' #r columns 4-7 gives additional information:'];
% h{end+1,1}=['   [#found]: how often is this file found across selected mouse-folders in [ant]-gui'];
% h{end+1,1}=['           -again: appropriate mousefolders in ANT-gui must be selected in advance'];
% h{end+1,1}=['   [Ndims]      : number of dimensions,i.e. 3 or 4 dims' ];
% h{end+1,1}=['   [size]       : number of [x,y,z]-voxels, and in case of a 4d-volume,also the number of volumes (size of 4th.dimension) '];
% h{end+1,1}=['   [resolution] : [x,y,z]-voxel-resolution'];
% h{end+1,1}=['  '];
% h{end+1,1}=['  '];
h={' '};

h0={};
h0{end+1,1}=[' '];
h0{end+1,1}=[' ##m   *** [ ' upper(mfilename)  '] ***'   ];
h0{end+1,1}=[' _______________________________________________'];
hlp=help(mfilename);
h=[h0; strsplit2(hlp,char(10))' ; h ];

setappdata(gcf,'phelp',h);

set(gcf,'name',[' manipulate file [' mfilename '.m]'],'NumberTitle','off');
set(gcf,'SizeChangedFcn', @resizefig);
% ==============================================
%%   controls
% ===============================================

%% HELP
pb=uicontrol('style','pushbutton','units','norm','position',[.45 0 .15 .03 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
set(pb,'tooltipstring','get some help');
set(pb,'units','pixels');

%% OK
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0 .15 .03 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile
set(pb,'tooltipstring','OK..proceed','tag','ok');
set(pb,'units','pixels');

%% CANCEL
pb=uicontrol('style','pushbutton','units','norm','position',[.8 0 .15 .03 ],'string','CANCEL','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',0);'          );%@renameFile
set(pb,'tooltipstring','cancel');
set(pb,'units','pixels');


us.tb  =tb;
us.tbh =tbh;
us.hj =jtable;
us.s  =s;
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




% ==============================================
%%   wait
% ===============================================

waitfor(f, 'userdata');
% disp('geht weiter');
try
    tb=get(f,'userdata');
    %% cancel
    if isnumeric(tb)
        if tb==0
            he=[];
            tbout=tb;
            close(f);
            return;
        end
    end
    
    %%
    
    % ikeep=find(cellfun('isempty' ,tb(:,2))) ;
    ishange=find(~cellfun('isempty' ,tb(:,2))) ;
    if isempty(ishange)
        he=[];
        tbout=tb;
    else
        he= tb(ishange,1:3);
        tbout=tb;
    end
    % oldnames={};
    % for i=1:length(ikeep)
    %     [pas fis ext]=fileparts(tb{ikeep(i),1});
    %     tb(ikeep(i),2)={[fis ext]};
    % end
    % oldnames={};
    % for i=1:length(ishange)
    %     [pas  fis  ext]=fileparts(tb{ishange(i),1});
    %     [pas2 fis2 ext2]=fileparts(tb{ishange(i),2});
    %     tb(ishange(i),2)={[fis2 ext]};
    % end
    % he=tb;
    %     disp(tb);
    close(f);
catch
    [he tbout]=deal({});
end

function contextmenu_make()
us=get(gcf,'userdata');
ht=findobj(gcf,'tag','table');
cmenu = uicontextmenu;
% hs = uimenu(cmenu,'label','enter 2nd & 3rd column',             'Callback',{@hcontext, 'enter2and3'},'separator','on');
hs = uimenu(cmenu,'label','enter 2nd & 3rd column extended',     'Callback',{@hcontext, 'enter2and3_extended'},'separator','on');


hs = uimenu(cmenu,'label','copy & rename file'    ,         'Callback',{@hcontext, 'copyNrename'},'separator','off');
hs = uimenu(cmenu,'label','rename file'           ,         'Callback',{@hcontext, 'rename'},'separator','off');

hs = uimenu(cmenu,'label','clear all fields'      ,         'Callback',{@hcontext, 'clearfields'},'separator','on');

hs = uimenu(cmenu,'label','delete file'           ,         'Callback',{@hcontext, 'deleteFile'},'separator','on');

hs = uimenu(cmenu,'label','<html><font color=green>  show image info'           ,         'Callback',{@hcontext, 'showimageinfo'},'separator','on');



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
    set(he,'string',hb.String{hb.Value});
elseif strcmp(task,'pop2')
    he=findobj(gcf,'tag','pan_ed_col3');
    hb=findobj(gcf,'tag','pan_pop_col3');
    
    list=get(hb,'userdata');
    set(he,'string',list{hb.Value,1});
    %     set(he,'string',hb.String{hb.Value});
elseif strcmp(task,'cancel')
    set(findobj(gcf,'tag','pan1'),'userdata','cancel');
    %     delete(findobj(gcf,'tag','pan1'));
    uiresume(gcf);
elseif strcmp(task,'ok')
    set(findobj(gcf,'tag','pan1'),'userdata','ok');
    uiresume(gcf);
end

function hcontext(e,e2,task)
us=get(gcf,'userdata');
if strcmp(task,'enter2and3') || strcmp(task,'copyNrename') || strcmp(task,'rename') ||...
        strcmp(task,'deleteFile') ||  strcmp(task,'enter2and3_extended') ||  strcmp(task,'clearfields')
    e=us.hj;
    selrows=get(e,'SelectedRows');
    
    
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
        hp = uipanel('Title','enter 2nd/3rd column','FontSize',8,...
            'BackgroundColor','white','units','norm','tag','pan1');
        set(hp,'position',[0.25 .5   .3 .15]);
        %---------------------
        %TXT
        hb=uicontrol(hp,'style','text','units','norm','tag','pan_tx_col2','string','column-2: NEW FILENAME');
        set(hb,'position',[0    .75   .8 .2],'backgroundcolor','w','horizontalalignment','left');
        
        hb=uicontrol(hp,'style','edit','units','norm','tag','pan_ed_col2');
        set(hb,'position',[0    .6  .5 .2]);
        set(hb,'tooltipstring','enter new filename (column-2) here or choose from right popup-menu');
        
        list1=unique(ht.Data(:,2));
        list1(strcmp(list1, ''))=[];
        list1=[list1 ; {''} ;'_test1.nii' ; '_test2.nii' ];
        
        hb=uicontrol(hp,'style','popupmenu','units','norm','tag','pan_pop_col2');
        set(hb,'position',[.55  .6 .45 .2],'string',list1);
        set(hb,'tooltipstring','selected item from popup-menu is used to fill the left edit box');
        set(hb,'callback',{@pan_callback,'pop1'});
        %----------------
        %TXT
        hb=uicontrol(hp,'style','text','units','norm','tag','pan_tx_col2','string','column-3: TASK');
        set(hb,'position',[0     .4 .8 .2],'backgroundcolor','w','horizontalalignment','left');
        
        hb=uicontrol(hp,'style','edit','units','norm','tag','pan_ed_col3');
        set(hb,'position',[0     .25 .5 .2]);
        set(hb,'tooltipstring','enter code here for column-3 or choose from right popup-menu');
        
        list2=unique(ht.Data(:,3));
        list2(strcmp(list2, ''))=[];
        %list2=[list2 ; {''} ;':';'copy';'del'; '1:ends' ];
        lis={...
            ':'       'copy this file ("copy", same as ":")'
            'del'     'delete this file ("del", same as "##")'
            '1:ends'  'expand entire 4D-file to separate 3D-files ("1:ends")'
            '1:3s'    'expand the first 3D-volumes of 4D-file to separate 3D-files ("1:3s")'
            ''        'empty this field'
            'tr: i<=3=0'               'threshold image: set all values <=3 to ZERO  '
            'tr: i<=3=1;i>20=20;'  'threshold image: set all values <=3 to ONE; and values >20 t0 20  '
            'tr: i~=0=1;'          'threshold image: set all non-zero values to ONE'
            };
        listbk=[[list2 ; {''} ;lis(:,1) ] [list2 ; {''} ;lis(:,2) ]];
        
        
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
        
        
        uiwait(gcf);
        
        
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
    elseif strcmp(task,'clearfields')
        out={'',''};
        selrows=[1:size(us.tb,1)]-1;
    end
    
    
    
    if length(out)==0;         return ;    end
    
    if strcmp(task,'copyNrename'); out{2}=':'; end
    if strcmp(task,'rename');      out{2}=''; end
    
    jtable=e;
    
    for i=1:length(selrows)
        jtable.setValueAt(java.lang.String(out{1}), selrows(i), 1); % to insert this value in cell (1,1)
    end
    if length(out)==2
        for i=1:length(selrows)
            jtable.setValueAt(java.lang.String(out{2}), selrows(i), 2); % to insert this value in cell (1,1)
        end
    end
    
elseif strcmp(task,'showimageinfo')
    e=us.hj;
    iselrows=get(e,'SelectedRows')+1;
    files=us.tb(iselrows,1);
    show_imageinfo(files);
end


function show_imageinfo(files);
% ==============================================
%%
% ===============================================
us=get(gcf,'userdata');
pa=us.s.pa;
%———————————————————————————————————————————————
%%  image information
%———————————————————————————————————————————————
filelist={};
for j=1:length(files)
    filelist=[filelist; {' #ky num' [' #ko image #b "' files{j} '"' ] ''}];
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
            o=[o; repmat('-',[1 70])];
        end
        %         o=[o; {'';'';''}];
    end
end
o=[o; {'';'';''}];
uhelp([' #wk *** [1] FILE INFORMATION ***'; oo; ' '; ' #wk *** [2] HEADER INFORMATION ***';' '; o]);
set(gcf,'name','image information','numbertitle','off');




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

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ======================================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ======================================================');

if ~isstruct(p0)
    
    if isempty(z.files{1})
        hh(end+1,1)={[mfilename '(' '1'  ');' ]};
    elseif size(z.files,2)==2
        hh=[hh; 'z=[];' ];
        z.files=z.files(:,1:2);
        hh=[hh; struct2list(z)];
        hh(end+1,1)={[mfilename '(' '1',  ',z.files(:,1),z.files(:,2)' ');' ]};
    elseif size(z.files,2)==3
        hh=[hh; 'z=[];' ];
        hh=[hh; struct2list(z)];
        hh(end+1,1)={[mfilename '(' '1',  ',z.files(:,1),z.files(:,2),z.files(:,3) ' ');' ]};
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
    
   
    hh=[hh; 'z=[];' ];
    hh=[hh; struct2list2(z2,'z')];
    
    reginput={'z.files(:,1)' 'z.files(:,2)' 'z.files(:,3)'};
    
    ac=[reginput(1:size(z.files,2)) ...
        repmat( {'[]'},[1 3-length(reginput(1:size(z.files,2)))])];
    a1=strjoin(ac,',');
    
    isDesktop=usejava('desktop');
    a2=[ mfilename '(' num2str(isDesktop)  ',' a1 ');' ];
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
function v=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
li=unique(fi2);
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
    ha=spm_vol(fifull2{i});
    ha0=ha;
    ha=ha(1);
    if length(ha0)==1
        tb{i,1}='3';
        tag='';
    else
        tb{i,1}='4' ;
        tag= length(ha0);
    end
    tb{i,2}=sprintf('%i ',[ha.dim tag]);
    tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
    tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];


% ==============================================
%%
% ===============================================

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