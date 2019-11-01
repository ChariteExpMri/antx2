

%% #b deform other images via spm
% #r NOTE: warping must be done in advance, than other images can be warped with this function
% DEFORM via SPM warp (=APPLY TO IMAGES only)
%% #by FUNCTION
% xdeform2(   files  ,direction,  resolution, interpx, aux)
%% #by INPUT
% files:  FPfiles to deform {char,cell} or a starting_path (char) fot the GUI
% direction: -1/1 ... inverse/forward
% resolution: voxel resolution [1x3 vec]
% interpx    :0/1/4 intrpolation nearsted neighbour/trilinear/spline4th order (one of it)
%% #by EXAMPLES
% xdeform2('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x');  % MOUSE-DIR, than guided by gui
% xdeform2(   fullfile('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x','t2.nii'));    % warp this file+GUI, to allen
% xdeform2(   fullfile('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x','t2.nii')  ,-1) % ..backward ...
% xdeform2(   fullfile('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x','t2.nii')  ,1,[.07 .07 .07]) ; % forward with 0.07 iso-vox resolution
% xdeform2(   fullfile('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x','t2.nii')  ,1,[.07 .07 .07],4) %+..with spline-4th-order
%% #by without opeining a file-gui but using define the path and file-filter
% xdeform2(   an.mdirs(:),[],[],[],struct('flt', '^t2.nii') ); % use paths defined in an.mdirs & warp 't2.nii'

function xdeform2(   files  ,direction,  resolution, interpx, aux)


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% xdeform(   {t2}           ,1,  voxres, [])
if 0
    
    files='O:\harms1\harmsStaircaseTrial\dat'
    voxres=[.07 .07 .07]
    interpx=0
    xdeform2(   files  ,1,  voxres, interpx)
    
    xdeform2(   fullfile(pwd,'t2.nii')  ,1,  [0.07 .07 .07], 1)
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%          [1]       gui FILES
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if exist('aux')~=1
    aux.dummy=1;
end

gui1     =0;
prefdir =pwd;  %preDIR for GUI

try ; %convert files to cell otherwise.:>empty
    if ischar(files); files=cellstr(files) ; end
catch
    files={''};
end

dattype=[];
for i=1:length(files) %check if NIFITs (=2) are deliverd or paths (=7)
    dattype(i)=exist(files{i}  );
end

if any(dattype==0) %no niffti no path given
    prefir=pwd;
    gui1=1;
elseif any(dattype==7) %path(s) given
    if length(files)>1  %more than one path given->go to upper directory
        prefdir=fileparts(files{min(find(dattype==7))});
    else   % one path given
        prefdir=files{1};
    end
    gui1=1;
else   %% FILES WERE GIVEN
    gui1=0;
end


% % gui1
% % files
% % prefdir
% %
% % return
% % if    ~exist('files','var') || isempty(files)   ||           ( ischar(files) && isdir(files)==1    )   %%    ( iscell(pain) && strcmp(pain{1},'guidir')    )
% %     gui1=1;
% %     try
% %         if    isdir(files)   %get start_DIR GUI
% %             prefdir=files;
% %         end
% %     end
% % end


if  gui1==1
    maskfi={''};
    %     msg={'select all files that should be warped:'
    %         '1)choose rootpath'
    %         '2) type a matching token (e.g. "mask" "total_mask") in the filterbox, use also regular expressions (^/$ etc)'
    %         '3) press [rec] to recursivly search for the token in the roothpath''s subfolders'
    %         '4) add/remove images from button listbox'
    %         };
    msg={' DEFORM FILES'
        'HOW TO SELECT MULTIPLE FILES FROM MULTIPLE MOUSE FOLDERS?'
        ' 1) choose data rootpath: the data rootpath is the folder that contains all mouse folders'
        '        -copyNpaste folder-name in the [Dir] editbox  or navigitate to this folder within the left listbox (at the end, the left listbox contains all mice folders)  '
        '       -at the end the data rootpath has to be visible in [Dir] editbox'
        '2) in the [Filt] editbox (right to the [Filt] button) type search patterns that are parts of the filenames that should be warped : '
        '  examples: '
        '       ^mask                search for files starting with "mask"  '
        '       .*mask.*.nii         search for NIFTIfiles containing "mask"  '
        '       ^x.*.nii|^ix.*.nii  search for NIFTIfiles starting with "x" or "ix" '
        '3) press [rec] button to recursivly search for files within the roothpath''s subfolders that contain the "filter pattern" '
        '4) add/remove files from the selection listbox (=lower listbox, this box contains the selected files)'
        '      -in the selection listbox use the context menu''s  "unselect all" to clear all files from the selection listbox'
        '  '
        'HOW TO SELECT  MULTIPLE FILES FROM SINGLE MOUSE FOLDER?'
        '1) navigate to the mouse folder of interest ( [Dir] editbox should contain the mouse path )'
        '2) select files from the right listbox (this files appear in the selection listbox(=lower listbox))'
        };
    
    if any(dattype==7) %% recursivley search only in those paths
        if isfield(aux,'flt') %filter was given-->NO GUI
            maskfi={}
            for i=1:length(files)
                filesdum= spm_select('FPListRec',files{i},aux.flt)  ;
                maskfi=[maskfi;   filesdum]
            end
        else %OPEN GUI
            w.recpaths=files;
            [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii' ,[],w);
        end
    else
        [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii');
    end
    
    if isempty(maskfi)   ; return;
    else;                          files=maskfi;
    end
end







%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%          [2]       gui params
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
gui=[0 0 0];
if exist('direction')~=1   || isempty(direction)  ;                                       gui(1)=1;     direction =1;                              end
if exist('resolution')~=1 || isempty(resolution)     ;                                  gui(2)=1;      resolution =[.07 .07 .07];                             end
if exist('interpx')~=1      || isempty(interpx)     ;                                       gui(3)=1;        interpx =4         ;                                        end

if any(gui)==1
    prompt = {'Direction [-1]inverse [1] forward:',        'Resolution (voxsize)'     ...
        'Interpolation [0] NN   [1] linear [4] cub.Spline  (use [0] for mask/atlases or [4] for all other)'};
    dlg_title = 'Inputs for DEFORM';
    num_lines = 1;
    def = {'1',  '.07 .07 .07'  , '4' };
    def={num2str(direction)  num2str(resolution) num2str(interpx)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer);    return             ; end
    
    direction   =    str2num(answer{1}) ;
    resolution=  str2num(answer{2}) ;
    interpx      = str2num(answer{3}) ;
    
end





%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% BBOX
% bbox =  [-6 -9.5 -7
%     6 5.5 1];
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% cellInput
if ischar(files);               files=cellstr(files);  end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% %% voxsize set to nan ...use default
% if any(isnan(resolution))
%     if direction==   -1
%         %hh=spm_vol(fullfile(fileparts(files{1}),'t2.nii'))
%         [bb resolution] = world_bb(fullfile(fileparts(files{1}),'t2.nii'));
%     elseif direction==1
%         [bb resolution] = world_bb(fullfile(fileparts(files{1}),'_refIMG.nii'))  ;
%     end
% end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% RESOLUTION
if any(isnan(resolution))
    getResolution=1;
else
    getResolution=0;
end

for i=1:length(files)
    matlabbatch=[];
    [pathx fi ext ]=fileparts(files{i});
    
    %% avoid that a warped image is warped again
    if direction==1
        if ~isempty(regexpi(fi,'^w_'))   ;        continue  ;     end
    end
    if direction==-1
        if ~isempty(regexpi(fi,'^iw_'))   ;        continue  ;     end
    end
    
    %% voxsize set to nan ...use default
    if getResolution==1
        if direction==   -1
            %hh=spm_vol(fullfile(fileparts(files{1}),'t2.nii'))
            [bb resolution] = world_bb(fullfile(fileparts(files{i}),'t2.nii'));
        elseif direction==1
            [bb resolution] = world_bb(fullfile(fileparts(files{i}),'_refIMG.nii'))  ;
        end
    end
    
    resolution=abs(resolution);
    
    try;
        cprintf([0 .5 0],(['warp: ' '['    num2str(i) '/'  num2str(length(files)) ']: '    strrep(files{i},filesep,[filesep filesep])  '\n']  ));
    catch
        disp(['warp: ' '['    num2str(i) '/'  num2str(length(files)) ']: '    files{i}    ]  );
    end
    %% —————————————————————————————————————————————————————————————————————————————————————————————————
    spmversion=spm('ver');
    if strcmp(spmversion,'SPM8')
        cnt = 1;
        if direction==1
            matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(pathx,'y_forward.nii')};
            %bbox = world_bb(fullfile(pathx,'y_forward.nii'));
            
            %bbox=world_bb(fullfile('V:\mritools\ant\templateBerlin_hres','AVGT.nii'))
            bbox=   [-5.67500019073486 -8.79445947147906 -8.45034562284127;
                5.69999997876585 5.94400887237862 2.53627848625183];%AVGT
            %         cbox=[-.07 -.07 -.07 ; .07 .07 .07 ]
            cbox=[-[resolution];resolution];
            bbox=bbox+cbox;
        elseif direction==-1
            matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(pathx,'y_inverse.nii')};
            %bbox = world_bb(fullfile(pathx,'y_inverse.nii'));
            [bb resolution]  = world_bb(fullfile(pathx,'t2.nii'));
            resolution=abs(resolution);
            
            bbox=[bb(1,1)-resolution(1)  bb(1,2)-resolution(2)   bb(1,3)-resolution(3)  ;bb(2,:) ];%FREIBURG-BUG?
            %         bbox=bb;
        end
        %matlabbatch{cnt}.spm.util.defs.comp{2}.id.space = '<UNDEFINED>'; % For fMRI Files use fMRI-Scan resolution.
        matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.vox = resolution;
        matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.bb = bbox;
        matlabbatch{cnt}.spm.util.defs.ofname = '';
        matlabbatch{cnt}.spm.util.defs.fnames = files(i);
        matlabbatch{cnt}.spm.util.defs.savedir.savesrc = 1;
        matlabbatch{cnt}.spm.util.defs.interp =interpx;% 4;  default is 4 (spline4)
        spm_jobman('serial',  matlabbatch);
        
        
        %% rename
        if direction==1
            movefile(  fullfile(pathx,['w' fi ext])  ,fullfile(pathx,['w_' fi ext]),  'f');
            outfile=fullfile(pathx,['w_' fi ext]);
            reffile=fullfile(fileparts(fileparts(fileparts(fullfile(pathx,['w_' fi ext])))),'templates','AVGT.nii');
            rreslice2target(outfile,reffile, outfile  , 0);
        elseif direction==-1
            movefile(  fullfile(pathx,['w' fi ext])  ,fullfile(pathx,['iw_' fi ext]),  'f');
        end
        %% —————————————————————————————————————————————————————————————————————————————————————————————————
        
    elseif strcmp(spmversion,'SPM12')
        
        
        if direction==1
            
            matlabbatch={}; cnt=1;
            matlabbatch{1}.spm.util.defs.comp{1}.comp{1}.def         = {fullfile(pathx,'y_forward.nii')}; %{'O:\data4\ant_upd2_win\dat\m09\y_forward.nii'};
            matlabbatch{1}.spm.util.defs.out{1}.pull.fnames          = files(i);%{'O:\data4\ant_upd2_win\dat\m09\t2.nii'};
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp          = interpx ;%4;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask            = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm            = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix          = 'w';
            spm_jobman('serial',  matlabbatch);
            
            movefile(  fullfile(pathx,['w' fi ext])  ,fullfile(pathx,['w_' fi ext]),  'f');
            outfile=fullfile(pathx,['w_' fi ext]);
            reffile=fullfile(fileparts(fileparts(fileparts(fullfile(pathx,['w_' fi ext])))),'templates','AVGT.nii');
            rreslice2target(outfile,reffile, outfile  , 0);
            
        elseif direction==-1
            
            matlabbatch={}; cnt=1;
            matlabbatch{1}.spm.util.defs.comp{1}.comp{1}.def         = {fullfile(pathx,'y_inverse.nii')};;%{'O:\data4\ant_upd2_win\dat\m09\y_inverse.nii'};
            matlabbatch{1}.spm.util.defs.out{1}.pull.fnames          = files(i); ;%{'O:\data4\ant_upd2_win\dat\m09\AVGT.nii'};
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp          = interpx ;%4;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask            = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm            = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix          = 'iw';
            spm_jobman('serial',  matlabbatch);
            
            movefile(  fullfile(pathx,['iw' fi ext])  ,fullfile(pathx,['iw_' fi ext]),  'f');
            
        end
        
        
        
        
        
        
        
        
        
    end
    
end %i



% [ht t]=rgetnii('wt2.nii');size(t)
% [ha a]=rgetnii('sAVGT.nii');size(a)

% size(t)
% ans =
%    163   211   157
% size(a)
% ans =
%    164   212   158

% resolution =[.025 .025 .025]
% bbox =  [-6 -9.5 -7
%     6 5.5 1];
% cnt = 1;
% nr = 1;
% AMAfiles =..
% %    'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c1t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c2t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c1c2mask.nii,1'
% %
% matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(t2destpath,'y_forward.nii')};
% %matlabbatch{cnt}.spm.util.defs.comp{2}.id.space = '<UNDEFINED>'; % For fMRI Files use fMRI-Scan resolution.
% matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.vox = resolution;
% matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.bb = bbox;
% matlabbatch{cnt}.spm.util.defs.ofname = '';
% matlabbatch{cnt}.spm.util.defs.fnames = AMAfiles(1:end);
% matlabbatch{cnt}.spm.util.defs.savedir.savesrc = 1;
% matlabbatch{cnt}.spm.util.defs.interp = 4;
% spm_jobman('serial',  matlabbatch);
