
%% #bc [xrename] RENAME/DELETE/EXTRACT/EXPAND/COPY file(s) from selected ant-mousefolders
% - select one/several images TO RENAME/DELETE/EXTRACT/EXPAND/COPY volumes,aka. files
% - dirs:  works on preselected dirs (not all dirs), i..e mouse-folders in [ANT] have to be selected before
% - 'newname'-column contains the new filename (file-extension is not needed)
% - to copy a file , the [EXTRACT VOLNUM]-column must contain the ":" tag (":" tag without "")
%  - "##" (double-hash) in '[NEWNAME]-column will delete the file
%  - examples made here are either with "" or ''  -->indon't use "" or ''  (example use 1:5 but not "1:5" , same for the (double-hash) )
%  - file-deletion: in case of errornous deletion --> deleted files are temporally stored in the recycle-nin
% __________________________________________________________________________________________________________________
% #yg GUI-USAGE________________________________________________
%
%% #by RENAME FILES
%     - in the [NEWNAME]-column type a new name (but not "##" this would delete the file)
%     - the [EXTRACT VOLNUM]-column must be empty or type "rename"
%
%% [RENAME]: rename "T2_TurboRARE.nii" to "t2.nii"
%% -----------------------------------------------------------
%% [current filename]    [new file name]  [extract volume]
%% T2_TurboRARE.nii       t2.nii                               !! the new file name is "t2.nii"
%%  or
%% T2_TurboRARE.nii       t2.nii            rename             !! the new file name is "t2.nii"   
%__________________________________________________________________________________________________________________
%% #by COPY FILES
%     - in the [NEWNAME]-COLUMN type a file-name (but not "##" this would delete the file)
%     - the [EXTRACT VOLNUM]-column must contain ":"  (the ":" means take all containing volums) or
%       type "copy"
%
%% [example COPY]: copy T2_TurboRARE.nii and name it "t2.nii"
%% ---------------------------------------------------------------------------
%% [current filename]    [new file name]  [extract volume]
%% T2_TurboRARE.nii       t2.nii                 :            !! use ":" to copy the file
%%  or
%% T2_TurboRARE.nii       t2.nii               copy           !! use "copy" to copy the file
%__________________________________________________________________________________________________________________
%% #by DELETE FILES
%    - in the [NEWNAME]-COLUMN type "##"  or "delete"  (without ")  
%    - the [EXTRACT COLNUM]-column must be empty
%
%% [example DELETE]: delete "T2_TurboRARE.nii"   (use ##)
%% --------------------------------------------------------------
%% [current filename]    [new file name]  [extract volume]
%% T2_TurboRARE.nii       _##                                      !! use "##", to delete the volume
%% or
%% T2_TurboRARE.nii       delete                                   !! type delete, to delete the volume
%__________________________________________________________________________________________________________________
%% #by EXTRACT FILES
%   extract 1/more volumes from 4d volume and save this in a single file
%   - a new filename in the [NEWNAME]-column must be given (do not use '##'  ..this would delete the orig. file)
%   - in the [EXTRACT VOLNUM]-COLUMN -type the matlabstyle-like index-indications to extract the respective volume(s):
%    EXAMPLES:  single volume   :  "1" or "2" or "5" or "end"   ... to extract the 1st or 2nd or 5th or last single volume
%               multiple volumes: "2:3" or "5:end-1" or ":"     ... extract multiple volumes, here either 2nd & 3rd vol, or 5th to last-1 vol or all vols
%                                  "[2 4 10]" or "[end-3 end]"    ... extract multiple volumes, here either 2nd & 4th & 10th vol, or from the last-3 to the last vol
%    --> for concatenation, don't forget brackets (matlabstyle)
%    OUTPUT: extracted file (either 3d or 4d) with filename from [NEWNAME]-column
%
%% [example EXTRACT]: extract volumes 3 to 6 from "DTI_EPI_seg_30dir_sat_1.nii" and save this as "new.nii" (4d-nifti):
%% ------------------------------------------------------------------------------------------------------------
%% [current filename]            [new file name]  [extract volume]
%% DTI_EPI_seg_30dir_sat_1.nii      new.nii             3:6          !! note, this creates one (!) 4d volume containing the volumes 3-to-6
%% ----------------------------------------------------------------
%__________________________________________________________________________________________________________________
%% #by EXPAND FILES
% #r EXPAND: expands a 4d-volume into separate 3d-volumes
%    -new filename in the [NEWNAME]-column must be given (but not '##'  ..this would delete the orig. file)
%     in the [EXTRACT VOLNUM]-COLUMN -type the matlabstyle-like index-indications to expand the respective volume(s) and add a "s"
%     EXAMPLES: single volume   : "1s" or "2s" or "5s" or "ends" (or "end s")   ... to expand the 1st or 2nd or 5th or last single volume
%               multiple volumes: "2:3" or "5:end-1" or ":"     ... expand multiple volumes, here either 2nd & 3rd vol, or 5th to last-1 vol or all vols
%                                  "[2 4 10]" or "[end-3 end]"    ... expand multiple volumes, here either 2nd & 4th & 10th vol, or from the last-3 to the last vol
%       --> don't forget brackets (matlabstyle) IF NEEDED
%       --> for concatenation, don't forget brackets (matlabstyle) IF NEEDED
%       --> don't forget to put the "s" tag somewhere (with/without spaces) in the  [EXTRACT VOLNUM]-COLUMN
%    OUTPUT: extracted file(s) have always 3dims with the filename from [NEWNAME]-column and a numeric index which volume was expanded
%    EXAMPLES:  "1s"      ... newname_001.nii,                "5s" ... newname_005.nii
%               "2:3"     ... newname_002.nii,newname_003.nii
%               "[2 4 6]" ... newname_002.nii,newname_004.nii,newname_006.nii
%               "[end-3:end]" ... newname with respective numbers of the orig 4dim-volumes of the last three volumes
%
%
%% [example EXPAND]: expand volumes 1:10 from "DTI_EPI_seg_30dir_sat_1.nii" and save volumes as "new_xxx.nii", where xxx is the number of the volume
%% ------------------------------------------------------------------------------------------------------------
%% [current filename]            [new file name]  [extract volume]
%% DTI_EPI_seg_30dir_sat_1.nii      new.nii            1:10s         !! note the "s", this is mandatory to expand the [s]lices 1-10
%% ---------------------------------------------------------------
%__________________________________________________________________________________________________________________
%
%
% #r -----simple example------
% #g  to rename  a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [EXTRACT VOLNUM]-COLUMN is empty
% #g  to copy    a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [EXTRACT VOLNUM]-COLUMN  is ":"  (without "")
% #g  to delete  a file:  name in [NEWNAME]-column  is '##'
% #g  to extract a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [EXTRACT VOLNUM]-COLUMN is something like "1", "2","1:3","end","end-1:end",":" (without "")
% #g  to expand  a file:  name in [NEWNAME]-column  is 'something' but not '##'   &    [EXTRACT VOLNUM]-COLUMN is something like "1s", "2s","1:3s","ends","end-1:ends",":s" (without "")
%
%% #r NOTE: DIFFERENCE OF EXTRACTION AND EXPANSION
% INPUT:
%       -expansion differs from extraction only, that for expansion the 's' tag is added in the [EXTRACT VOLNUM]-COLUMN
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



%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace



function xrename(showgui,fi,finew,extractnum)




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
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
% if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
%     showgui  =1   ;
%     x=[]          ;
% end


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
        extractnum=regexprep(regexprep(extractnum,'^0',''),'\s+','');
        extractnum=regexprep(regexprep(extractnum,'NaN',''),'\s+','');
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

v=getuniquefiles(pa);

%———————————————————————————————————————————————
%%  get pairings of old&newfile (optional via gui) and extractionNUmber
%———————————————————————————————————————————————

he=renamefiles(v,he, showgui);

% he
%
% return

%———————————————————————————————————————————————
%%  process
%———————————————————————————————————————————————
if isempty(he); return; end

fi   =he(:,1);
finew=he(:,2);
volnum=he(:,3);

recycle('on'); %set recycle-bin to on

for i=1:size(pa,1)      %PATH
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
                        disp(['renamed: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
                    end
                else
                    %% extractvolume
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
                                disp(['renamed: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
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
                    
                    %% write volume
                    if save_separately==0
                        for k = 1 : size(hb,1)
                            hb(k).fname = s2;
                            hb(k).n     = [k 1];
                            spm_create_vol(hb(k));
                            spm_write_vol(hb(k),b(:,:,:,k));
                        end
                        try; delete( strrep(s2,'.nii','.mat')  ) ;     end
                        disp(['created: <a href="matlab: explorerpreselect(''' s2 ''')">' s2 '</a>'  ]);
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
                                    disp(['created: one separate vol: <a href="matlab: explorerpreselect(''' s3 ''')">' s3 '</a>'  ]);
                                else
                                    disp(['created: several separate vol, starting with: <a href="matlab: explorerpreselect(''' s3 ''')">' s3 '</a>'  ]);
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
z.files=he;
makebatch(z);

drawnow;
antcb('update');


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••




%________________________________________________
%%  rename files
%________________________________________________
function he=renamefiles(v,he, showgui)
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
    else
        he= tb(ishange,1:3);
    end
    return
end

%% GUI
tb       = [v.tb(:,1)  newname  extractvolnum  v.tb(:,2:end) ] ;
tbh      = [ v.tbh(1)  'NEW NAME (no extension)' 'extract volnum' v.tbh(2:end)];

% tb    =tb(: ,[1 end 2:end-1 ]); % 2nd element is new name
% tbh   =tbh(:,[1 end 2:end-1 ]);
tbh{1}='current filename';  %give better name
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
    'fontweight','bold','backgroundcolor','w');


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


% MAKE BUTTONS
% h={' #yg  ***RENAME FILES  ***'} ;
% h{end+1,1}=[' - select one/several imageS TO RENAME/EXTRACT/DELETE'];
% h{end+1,1}=['- dirs:  works on preselected dirs (not all dirs), i..e mouse-folders in [ANT] have to be selected before'];
% h{end+1,1}=[' - [newname]-column contains the new filename (file-extension is not needed)'];
% h{end+1,1}=[' - NOTE: "##" (double-hash) in [NEWNAME]-column will delete the file'];
% h{end+1,1}=[' - NOTE: strings such as "1", "2","1:3","end","end-1:end",":"  (without ""!) in [EXTRACT VOLNUM]-COLUMN WILL EXTRACT THE VOLUME(S) '];
% h{end+1,1}=['         and writes a new file with this data...but only if a new filename in the [NEWNAME]-column is given AND!...'];
% h{end+1,1}=['        the new filename is not "##"'];
% h{end+1,1}=[' - NOTE: to simply rename a file (no deletion/no extraction) the new file is not allowed to be named "##" AND ! the '];
% h{end+1,1}=['         [EXTRACT VOLNUM]-column must be empty'];
% h{end+1,1}=[' ------simple example------'];
% h{end+1,1}=[' #g  to rename  a file:  name in [NEWNAME]-column  is "something" but not "##"   &    [EXTRACT VOLNUM]-COLUMN is empty'];
% h{end+1,1}=[' #g  to delete  a file:  name in [NEWNAME]-column  is "##"'];
% h{end+1,1}=[' #g  to extract a file:  name in [NEWNAME]-column  is "something" but not "##"   &    [EXTRACT VOLNUM]-COLUMN is something like "1", "2","1:3","end","end-1:end",":" (without "")'];
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
pb=uicontrol('style','pushbutton','units','norm','position',[.45 0.02 .15 .03 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);


pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .03 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile
pb=uicontrol('style','pushbutton','units','norm','position',[.8 0.02 .15 .03 ],'string','CANCEL','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',0);'          );%@renameFile


drawnow;



waitfor(f, 'userdata');
% disp('geht weiter');
tb=get(f,'userdata');
%% cancel
if isnumeric(tb)
    if tb==0
        he=[];
        close(f);
        return;
    end
end

%%

% ikeep=find(cellfun('isempty' ,tb(:,2))) ;
ishange=find(~cellfun('isempty' ,tb(:,2))) ;
if isempty(ishange)
    he=[];
else
    he= tb(ishange,1:3);
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


%________________________________________________
%%  batch
%________________________________________________
function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
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
% disp(char(hh));
% uhelp(hh,1);

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


