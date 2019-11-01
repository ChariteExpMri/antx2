
%% #b calculate the corrected lesion volume
% this function calculates for ALL SELECTED MOUSEFOLDERS the corrected 
% lesion volume based  on the following nifti-files:
%    - 'masklesion.nii'  (the lesion mask)                 --> MANDATORY, must be provided
%    - 'x_masklesion.nii' (the warped lesion in Allen Space) ..is warped here 
%    - 'AVGTmask.nii'     (mask of the ALLEN BRAIN)
%    - 'ix_AVGTmask.nii' (AVGTmask in mouse space)          ..is warped here 
% the corrected lesion volume for each mouse is saved into a single excelfile
% in the studies-'results'-folder
% 
%#g LESION CORRECTION WORKS ONLY IF A MOUSE IS LINKED WITH A LESION MASK. THIS LESION MASK
%#g HAS TO BE NAMED "masklesion.nii" and must be located in the mouse folder
%
% #r NOTE: The initial warping of "t2.nii" has to be performed in advance because this function uses
% #r the transformation parameters to create 'x_masklesion.nii'  and  'ix_AVGTmask.nii'
% #r Important!!!. If a lesion mask ('masklesion.nii') exists for a mouse it should be copied into
% #r the specific mouse folder BEFORE starting the initial t2.nii-warping process not afterwards !!
% #r if mouse folders with and without lesion masks were selected, the function calculates the 
% #r lesion correction only for those mice with existing 'masklesion.nii' files. Thus, you can select
% #r all mouse-folders and run this function, even if there are only a view folders with a lesion mask.
% 
%    
% function  xgetlesionvolume()  
%% INPUTS: none
   

function  xgetlesionvolume


disp('calculate lesion correction');

global an
mpa    = antcb('getsubjects');
tpa    = fullfile(fileparts(an.datpath),'templates');
amsk   = 'AVGTmask.nii';
av     = fullfile(tpa,amsk);


info1={};
info2={};
for i=1:size(mpa,1)
    
    % fpamsk = fullfile(mpa{i},amsk)
    % exist(fpamsk)~=2
    % % copyfile(av,fpamsk,'f')
    
    [~,id]=fileparts(mpa{i});
    msk=fullfile(mpa{i},'masklesion.nii');
    
    %% CHECK WHETHER MASKLESION EXISTS, otherwise go to next file
    %—————————————————————————————————————————————————————————————————————————
    if exist(msk)~=2
        info2(end+1,:)={id 'masklesion.nii not found'};
        continue
    end
    
    %% warp x_masklesion if its does not exists
    %—————————————————————————————————————————————————————————————————————————
    mskx=fullfile(mpa{i},'x_masklesion.nii');
    if exist(mskx)~=2
        try
            s=xdeformpop(   msk  ,1,  nan, 0);
            doelastix(s.direction    , mpa{i},      s.files   ,s.interpx ,'local' );
        catch
            info2(end+1,:)={id 'ix_AVGTmask.nii not created..run initial wapring before'};
        end
    end
    
    %% warp ix_AVGTmask if its does not exists
    %—————————————————————————————————————————————————————————————————————————
    avix=fullfile(mpa{i},'ix_AVGTmask.nii');
    if exist(avix)~=2
        try
            %% we dont' copy the AVGTmask.nii in each subfolder
            s=xdeformpop(   av  ,-1,  nan, 0);
            %doelastix(s.direction    , [],      s.files      ,s.interpx ,'local' );
            doelastix(s.direction    , mpa{i},      s.files    ,s.interpx ,'local' );
        catch
          info2(end+1,:)={id 'ix_AVGTmask.nii not created..run initial wapring before'};  
        end
    end
    
    
    %% calculate coorected lesion volume
    %—————————————————————————————————————————————————————————————————————————
    [ vm  nm  h2]=getvolume(msk   ,'>0'); % masklesion 
    [ vxm nxm h2]=getvolume(mskx  ,'>0'); % x_masklesion
    [ va  na  h2]=getvolume(av    ,'>0'); % AVGTmask
    [ vxa nxa h2]=getvolume(avix  ,'>0'); % ix_AVGTmask
    
    
    
    
    
    
    
    
    
    r=[ vxa va  vxa/va vm vxm vxm*(vxa/va)];
     info1(end+1,:)=[id num2cell(r)];
    
    
    
end

% return
%———————————————————————————————————————————————
%%   write excelfile
%———————————————————————————————————————————————
paout=fullfile(fileparts(an.datpath),'results');
mkdir(paout);
fileout=fullfile(paout,['lesionvol_' timestr(1) '.xls']);
if isempty(info2);   info2(end+1,:)={'' ' *** no errors ***'}; end
pwrite2excel(fileout,{2 'errors'},{'Animal MRI-ID' 'Error'},[],info2);


if ~isempty(info1)
    lab={...
        'Animal MRI-ID'
        'Vol (mm3) ix_AVGTmask'
        'Vol (mm3) AVGTmask'
        'Sizecorrectionfactor'
        'Lesion Volume manually (mm3)'
        'Lesion Volume uncorr [x_masklesion] (mm3)'
        'Lesion Volume corr (mm3)'	};
    pwrite2excel(fileout ,{1 'lesioncorrection'},lab',[],info1);
end



try
%     explorerpreselect(fileout);
    disp(['LESION CORRECTION: <a href="matlab: explorerpreselect(''' fileout ''')">' 'show excelfile' '</a>'  ]);
catch
    try
    explorer(resultsfolder) ;
    end
end


