% #k prepare data for DTI-processing via Mrtrix. #n Ideally DTI-processing could start
% after (a) conventional registration of "t2.nii" to normal space, and (b) running
% this DTIprep-step. For this a propriate DTI-atlas must be provided (see below).
% shellscripts must be downloaded from https://github.com/ChariteExpMri/rodentDtiConnectomics
% and saved in the "shellscripts" folder (same level as the dat-folder)
%
% ==============================================
%%  #lk [1] GUI-MODE                          
% ===============================================
% #b DTIprep can be closed and reloaded anytime. The parameter are stored in the
% #b "DTI"-folder (checks.mat)
% __________________________
% #r Atlas-registration has to be made for all animals before running DTIprep (this function)
% #r it is assumed tha that the image "t2.nii" is succesfully registered to the template,i.e.
% #r "x_t2.nii" exists for each animal.
% ____________________________
% #ok OPEN DTIprep GUI
% open ANT gui and load the specific project
% from main ANT gui select MENU: Statistic/"DTI-prep for mrtrix"
% Alternatively you can type "DTIprep" in the comand window and click  [studypath], and
% select the study-path, i.e. the path containing the dat-folder.
%
% ____________________________
% #ok USER-INPUT
% You have to define three inputs:
% - The number of b-tables and DWI-files varies. For single-shell #k [SS] #n you have one b-table and one
%   DWI-file. For multi-shell #k [MS] #n you have several b-tables and accordingly, the same number of
%   DWI-files.
% #ky (a) extract the b-table(s) #k from #r <u>one</u> #k Bruker raw-data set
%    - The b-table(s) will be extracted from one Bruker raw data set and stored in the new
%      folder #r "DTI" #n as grad.txt #k [SS] #n or "grad_b+number.txt" for #k [MS] #n.
%    - You have to do this only once, because the same b-table(s) will be used for all animals
% #ky (b) get the DWI/DTI-file(s) names #k from #r <u>one</u> #k animal (from the 'dat'-folder)
%      - You have to do this only once, because we need only the names of the DWI-files. It is
%        assumed the names of the files are similar across animal folders
%      #m - IMPORTANT:  For [MS]: Select the DWI-files in the same order as the b-tables (see
%      #m   order of the b-table in the right listbox; field: "btable")
% #ky (c) get the DTI-template #k (i.e. a specific DTI-atlas).
%   -The atlas has to be constructed in advance. For atlas-construction you can use
%     [xexcel2atlas.m] available via ANT menu: Tools/"make mask from excelfile".
% #ko (d) check file assignment !!  #k via button [check file assignment]
%    - it is important that the order of the b-tables and DWI-files (DTI-data) corresponds
%    - to theck this : hit button [check file assignment]
%    - to reorder b-tables / DWI-files  --> use menu: tools/reorder b-table/DWI-data
% 
% 
% 
% #r &#9654; Preserve ORDER! First do (a),than (b), than (c)!
% #n &#9654; You can close the DTI-prep gui anytime! The userinput and progress is stored in a
%    mat-file ("check.mat") in the folder #r "DTI".
% ____________________________
% #ok PREPROCESSING STEPS
% #r &#9654; Preserve ORDER! of the processing steps:
%   1. distribute files -> copy DTI-atlas/lutfile & b-tables to animal-dirs
%   2. deform files     -> transform DTIatlas, brainmask etc to native space
%   3. register files   -> register "t2.nii" to DWI-file, than apply trafo to native space files
%                          ("ix_"+DTIatlas, "ix"+brainmask etc)
%   4. rename files      -> rename files (names are fixed and expected from shellscripts)
%   5  export files      -> export files to #r "DTI_export4mrtrix"-folder (OPTIONAL STEP!)
%   6  check registration-> create HTML-files with overlays of images to visualize the coregistration
%                         -this step is done using the data from the 'dat'-folder (not the export-folder!)
%                         -HTML-files are stored in the "checks"-folder within the studie's folder
%                         -OPTIONAL STEP!
%
% #b [all animals] #n : The radio allows to process all animals [x], or a selection of animals via
%  the animal listbox in the ANT gui.
% #b [select all] #n : The radio selects all processing steps. Use #by [run all steps] #n button
%  to execute the selected processing steps. If you select several steps, provide a consecutive
%  succession of steps (The steps [1,2,3,4,5] or [1 2] or [3,4,5] make sense. The steps [1,3,4] or
%  [3,5]) makes no sense).
% #r &#9654; Be aware that all steps (except the "export files"-step) have to be done. I.e. the steps
% #r [3,4,5] can be executed only if the steps [1,2] have been already made!
% #k &#9654; Use the buttons of each processing step or use [run all steps]-button.
%
%
% ____________________________
% #ok CONTEXT MENU
% #b open study directory   : #n open the STUDY-folder  (i.e. the folder containing the "dat"-folder)
% #b open DTI-directory     : #n open DTI-folder  ("DTI" is a folder within the STUDY-folder)
% #b which animal dirs are selected?' : #n shows the selected animal-folders
% #b delete files           : #n delete files which where created using DTIprep (file selection via GUI)
% #b check assignment of b-table & DTI/DWI-file: #n shows the assignment of b-tables and DWI-files
% #b show voxel size of 1st DTI/DWI-file: #n shows the vox-resolution of 1st DWI-file in 1st animal folder
% #b show comands for mrtrix: #n shows the mrtrix-comand to start the DTI-pipeline
%
% ____________________________
% #ok OUPUT-FILES
% The below list shows the files which will be created. The export-step allows to copy these files
% to the folder "DTI_export4mrtrix".
% Note that the name of the resulting files are fixed and expected to be found using mrtrix/shellscripts
% #kc ___SINGLE-SHELL___
%  'ANO_DTI.nii'         % % DTI-atlas, back-transformed to native space and transformed to DWI-space+renamed
%  'ANO_DTI.txt'         % % DTI-labels lookup table,renamed
%  'atlas_lut.txt'       % % DTI-labels lookup table (copy of 'ANO_DTI.txt'),renamed
%  'rc_ix_AVGTmask.nii'  % % brain mask, back-transformed to native space and transformed+resliced to DWI-space
%  'rc_mt2.nii'          % % bias-corected t2.nii,transformed+resliced to DWI-space
%  'rc_t2.nii'           % % t2.nii,transformed+resliced to DWI-space
%  'dwi.nii'             % % original DWI-file, copied & renamed
%  'grad.txt'            % % b-table
%  'grad_fix.txt'        % % b-table for preprocessing only (i.e. for dwifslpreproc/FSL-Eddy)
%  'grad_b1600_fix.txt'  % %  ||
%
%
% #kc ___MULTI-SHELL___
%  'ANO_DTI.nii'         % % DTI-atlas, back-transformed to native space and transformed to DWI-space,renamed
%  'ANO_DTI.txt'         % % DTI-labels lookup table,renamed
%  'atlas_lut.txt'       % % DTI-labels lookup table (copy of 'ANO_DTI.txt'),renamed
%  'rc_ix_AVGTmask.nii'  % % brain mask, back-transformed to native space and transformed+resliced to DWI-space
%  'rc_mt2.nii'          % % bias-corected t2.nii,transformed+resliced to DWI-space
%  'rc_t2.nii'           % % t2.nii,transformed+resliced to DWI-space
%  'dwi_b100.nii'        % % original DWI-file, copied & renamed
%  'dwi_b1600.nii'       % %  ||
%  'dwi_b3400.nii'       % %  ||
%  'dwi_b6000.nii'       % %  ||
%  'grad_b100.txt'       % % b-tables
%  'grad_b1600.txt'      % %  ||
%  'grad_b3400.txt'      % %  ||
%  'grad_b6000.txt'      % %  ||
%  'grad_b100_fix.txt'   % % b-tables for preprocessing only (i.e. for dwifslpreproc/FSL-Eddy) 
%  'grad_b1600_fix.txt'  % %  ||
%  'grad_b3400_fix.txt'  % %  ||
%  'grad_b6000_fix.txt'  % %  ||
%
% ====================================================
%%   #lk [1] COMMANDS: GUI-mode  &  command-line-mode                       
% =====================================================
% DTIprep('scripts','cmd')   ; % show available scripts in CMD-window
%
% ==============================================
%%   #lk [2] COMMANDS: GUI-mode                         
% ===============================================
% DTIprep('scripts')         ; % open the scripts-window only
% 
% ==============================================
%%   #lk [3] COMMANDS: command-line-mode                          
% ===============================================
% - DTIprep can be performed via command line
% - please use either command line mode or GUI-mode !
% - click DTIprep "scripts"-button to obtain an examle of DTIprep via COMMAND LINE ("DTIscript_runDTIprep_COMANDLINE.m")
% 
% - Here a "DTI"-folder is created in the studies folder containing a DTI-struct
%   with necessary inputs
% #yk COMMANDS  
%  DTIprep('delete'); %delete existing "DTI"-folder
% #b __initialize___
%  DTIprep('ini')         : -optional initialize DTIprep-struct and create "DTI-folder"
%                           -the struct is not empty and must be filled!
%  DTIprep('ini',d)       : -initialize DTIprep-struct and fill requested parameters
%     where d is a struct with fields: 
%         d.brukerdata    : -fullpath to a sample Bruker-rawdata set from one animal to obtain the b-table(s)
%                           -char   
%         d.DTItemplate   : -fullpath to DTI-atlas NIFTI-file
%                           -char   
%         d.DTItemplateLUT: -fullpath to DTI-atlas txt-file with labels corresponding to DTI-atlas NIFTI-file
%                           -char         
%         d.DTIfileName   : -short filenames of the DWI/DTI-files located in animal folders
%                           -cell
%                           -examlpe: {'q_b100.nii' 'q_b900.nii' 'q_b1600.nii' 'q_b2500.nii'}; %
% #b  __check struct___
% DTIprep('check');    % check struct (check if everything is initialized/imported/tasks performed)
% #b  __change order___
% DTIprep('reorder','b',[1 4 3 2])  ; %optional: reoder files of 'DTIfileName'
% DTIprep('reorder','b',[1 4 3 2])  ; %optional: reoder files of 'DTIfileName'
%
% #b  __run task(s)___
% DTIprep('run','all',mdirs)  ;%run task:[1]distribute files,[2]deform files[3]register files[4]rename files[5]export files[6]create HTMLfiles for check registration;same as: DTIprep('run',[1:6]);
% DTIprep('run',[1],mdirs)  ; %run task:[1]distribute files
% DTIprep('run',[1:2],mdirs); %run task:[1]distribute files,[2]deform files
% DTIprep('run',[1:6],mdirs); %run task:[1]distribute files,[2]deform files[3]register files[4]rename files[5]export files[6]create HTMLfiles for check registration
% 
% #lk ===============================================
% #lk 2a) EXAMPLE:  DTIprep VIA COMMAND LINE         
% #lk ===============================================
% % % ==== [initialize struct and import data] ====
% DTIprep('delete'); %delete existing "DTI"-folder
% clear d
% d.brukerdata     ='H:\Daten-2\Imaging\Paul\groeschel_test\raw\20200925_132436_20200925MG_LAERMRT_MGR000027_1_1'  ; % % sample Bruker-rawdata set from one animal to obtain the b-table(s)
% d.DTItemplate    ='H:\Daten-2\Imaging\Paul\groeschel_test\atl_auditsys_08dec20_v1\atl_auditsys_08dec20.nii'      ; % % DTI-atlas NIFTI-file
% d.DTItemplateLUT ='H:\Daten-2\Imaging\Paul\groeschel_test\atl_auditsys_08dec20_v1\atl_auditsys_08dec20_INFO.txt' ; % % DTI-atlas txt-file with labels
% d.DTIfileName    ={'q_b100.nii' 'q_b900.nii' 'q_b1600.nii' 'q_b2500.nii'}; % % filenames of the DWI/DTI-files located in animal folders
% DTIprep('ini',d);  % % initialize DTIprep-struct and fill requested parameters
% DTIprep('import'); % % import b-table and DTItemplate/DTItemplateLUT
% 
% % % === [optional: reorder 'DTIfileName' and/or 'btable'] ====
% % aim (1) 'DTIfileName'and 'btable' match in order
% %     (2) appear from lowest to highest number of aqu. angles (b100,b900,b1600, b2500)
% % ---------[btable] -------------
% % 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b100.txt'
% % 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b900.txt'
% % 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b1600.txt'
% % 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b2500.txt'
% % ---------[DTIfileName] --------
% % 'q_b100.nii'
% % 'q_b900.nii'
% % 'q_b1600.nii'
% % 'q_b2500.nii'
% % ===============================================
% if 0
%     DTIprep('reorder','b',[1 4 3 2])  ; %reoder files of 'DTIfileName'
%     DTIprep('reorder','d',[1 2 4 3])  ; %reoder files of 'btable'
% end
% % % ==== [check if struct is filles: __INI____ is "yes"; '__IMPORT_____' is "yes"] ====
% DTIprep('check'); % check struct (check if everything is initialized/imported/tasks performed)
% 
% % % ==== [run all tasks] ====
% mdirsAll=antcb('getallsubjects');% get all animals
% mdirs=mdirsAll(1)               ;% example here; use only the first animal
% DTIprep('run','all',mdirs)      ;% same as: DTIprep('run',[1:6]);
% 
% 
% 
% ==================================================================================
% #lk 2b)  INFO:  empty DTIprep-struct, 
% #lk      no initialization, no import, no tasks performed yet
% ===================================================================================
% ---------[struct info]-------
%                           studypath: 'H:\Daten-2\Imaging\Paul\groeschel_test'
%                             dtipath: 'H:\Daten-2\Imaging\Paul\groeschel_tes…'
%                          brukerdata: []
%                              btable: []
%                         DTIfileName: []
%                         DTItemplate: []
%                      DTItemplateLUT: []
%                            INFO_ini: '__INI____'
%               is_Brukerdata_Defined: 'NO'
%              is_DTItemplate_Defined: 'NO'
%           is_DTItemplateLUT_Defined: 'NO'
%                         INFO_import: '__IMPORT_____'
%                  is_Btable_imported: 'NO'
%             is_DTItemplate_imported: 'NO'
%                           INFO_task: '__TASK_____'
%     is_Atlas_and_Btable_distributed: 'NO'
%                          isdeformed: 'NO'
%                        isregistered: 'NO'
%                           isrenamed: 'NO'
% ---------[btable] -------------
%  ...not imported jet!
% ---------[DTIfileName] --------
%  ...not initialized/defined jet!
% -------------------------------
% ======================================================================
% #lk 2c)    INFO:   filled struct: 
% #lk         initialization, import and tasks performed
% =======================================================================
% ---------[struct info]-------
%                           studypath: 'H:\Daten-2\Imaging\Paul\groeschel_test'
%                             dtipath: 'H:\Daten-2\Imaging\Paul\groeschel_tes…'
%                          brukerdata: 'H:\Daten-2\Imaging\Paul\groeschel_tes…'
%                              btable: {4x1 cell}
%                         DTIfileName: {4x1 cell}
%                         DTItemplate: 'H:\Daten-2\Imaging\Paul\groeschel_tes…'
%                      DTItemplateLUT: 'H:\Daten-2\Imaging\Paul\groeschel_tes…'
%                            INFO_ini: '__INI____'
%               is_Brukerdata_Defined: 'YES'
%              is_DTItemplate_Defined: 'YES'
%           is_DTItemplateLUT_Defined: 'YES'
%                         INFO_import: '__IMPORT_____'
%                  is_Btable_imported: 'YES'
%             is_DTItemplate_imported: 'YES'
%                           INFO_task: '__TASK_____'
%     is_Atlas_and_Btable_distributed: 'YES'
%                          isdeformed: 'YES'
%                        isregistered: 'YES'
%                           isrenamed: 'YES'
% ---------[btable] -------------
%     'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b100.txt'
%     'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b900.txt'
%     'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b1600.txt'
%     'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b2500.txt'
% ---------[DTIfileName] --------
%     'q_b100.nii'
%     'q_b900.nii'
%     'q_b1600.nii'
%     'q_b2500.nii'
% -------------------------------




% updates
% 01-Nov-2021 15:56:06
% -"descrip" & "private" fields are removed from NIFTI-files during the "renaming" proc step.
%  REASON: non-UTF8 characters (umlauts) produce crash during MRTRIX (DWIFSLPREPROC) analysis
%  errorMSG was --> UnicodeDecodeError: 'utf8' codec can't decode byte 0xfc in position 4: invalid start byte
% -the datatype of the ATLAS ("ANO_DTI.nii") is changed to dt=[8 0] (32bit integer) during the "renaming" proc step.
%  REASON: crash during MRTRIX (in *_connectome_7texpmri.sh) analysis
%  errorMSG was -->labelconvert: [ERROR] Floating-point number detected in image "d6/mrtrix/ANO_DTI_up.mif"; label images should contain integers only
% -check and if missing adds a newline character at the end of (each) btable-txt files (grad.txt/grad*.txt)
%  REASON: potential concatenation of grad-files in the multishell approach failed

function DTIprep(varargin)

% ==============================================
%%
% ===============================================
%v=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
                %makestruct(v);
                
p.gui=1 ;% show gui

%% ===========[inputs: only for noGUI-mode]====================================
if nargin>0
    close(findobj(0,'tag','DTIprep')); % no gui
    
    if strcmp(varargin{1},'ini')
        close(findobj(0,'tag','DTIprep')); % no gui
        p.gui=0;
        if nargin>1 && isstruct(varargin{2})
            makestruct(varargin{2});
        else
            makestruct();
        end
        
        return
    elseif strcmp(varargin{1},'scripts')
        scripts(varargin);
    elseif strcmp(varargin{1},'check')
        nogui_check();
        return
        
    elseif strcmp(varargin{1},'reorder')  
        if nargin~=3
           disp('2nd arg must be "DTIfileName"/("d") or "btable"/"b"');
           disp('3rd arg must be an array to resort such as [1 3 2 4]');
            return
        end
        nogui_change_order(varargin{2},varargin{3});
        
    elseif strcmp(varargin{1},'delete')
        global an
        dtidir=fullfile(fileparts(an.datpath),'DTI');
        try
            rmdir(dtidir,'s');
        catch
            if exist(dtidir)~=0
                disp('could not remove "DTI"-folder ..check if something is open');
            end
        end
        if exist(dtidir)==0
             disp(['.."DTI"-folder deleted']);
        end
        
      elseif strcmp(varargin{1},'import')  
            nogui_importdata();
      elseif strcmp(varargin{1},'run') 
          if nargin==2
             nogui_run(varargin{2});
          else
             nogui_run(varargin{2},varargin{3});
          end
    end
    return
end

% ==============================================
%%   GUI-mode ...starts here
% ===============================================
if p.gui==1
    makefig();
end




function makefig()
delete(findobj(0,'tag','DTIprep'));
fg;
set(gcf,'units','norm','menubar','none','tag','DTIprep','name','DTIprep','numbertitle','off');
set(gcf,'position',[0.3146    0.3922    0.3889    0.2433]);

%% studyPath
hb=uicontrol('style','pushbutton','units','norm','string','study path','tag','studypath');
set(hb,'callback',{@process, 'pb_studypath'} );
set(hb,'position',[0.34816 0.90204 0.15 0.1]);

set(hb,'tooltipstring',[...
    '<html><b>select study path</b><br>' ...
    'use this if you don''t have the ANTx-gui open and the desired project loaded' '<br>'...
    ['- if ANTx-gui is open and the desired project loaded there is no need to press this button' '<br>']...   
    ]);

%% Listbox
hl=uicontrol('style','listbox','units','norm','tag','lb_check');
set(hl,'position',[0.5 0 .5 1]);
set(hl,'string','<>');

%% frame-1
hb = uipanel('Title','USER INPUT','FontSize',8,'tag','uip1',...
    'BackgroundColor','white');
set(hb,'position',[[0.001 .635 .16 .365]]);

%% getbtable
hb=uicontrol('style','pushbutton','units','norm','string','get b-table(s)','tag','getbtable');
set(hb,'position',[0.0053571 0.8381 0.15 0.1]);
set(hb,'backgroundcolor',[ 0.9373    0.8667    0.8667]);
set(hb,'tooltipstring',[...
    '<html><b>get b-table from one of the Bruker raw-data sets</b><br>' ...
    'select one (!) raw data set to obtain the b-table(s) <br>'...
    ' - if a <B> single b-table </B> is found --> this is a <B>single-shell </B>approach <br>'...
    ' - if <B> several b-tables </B> are found --> this is a <B>multi-shell </B>approach <br>'...
    ]);

%% getDTIfile
set(hb,'callback',{@process, 'getbtable'} );
hb=uicontrol('style','pushbutton','units','norm','string','get DTIfile(s)','tag','getDTIfile');
set(hb,'position',[0.0053571 0.7422 0.15 0.1]);
set(hb,'callback',{@process, 'getDTIfile'} );
set(hb,'backgroundcolor',[ 0.9373    0.8667    0.8667]);
set(hb,'tooltipstring',[...
    '<html><b>get DWI/DTIfile(s)</b><br>'...
    'select the 4D DTIfile(s) from <b>one</b> of the animals (within the dat-folder) <br>'...
    '<B>single-shell</B>: select <B>one</B> DWI file <br>'...
    '<B>multi-shell </B>: select <B>several</B> DWI files (as many as b-tables) <br>'...
    ]);

%% getDTItemplate
hb=uicontrol('style','pushbutton','units','norm','string','getDTItemplate','tag','getDTItemplate');
set(hb,'position',[0.0053571 0.6463 0.15 0.1]);
set(hb,'callback',{@process, 'getDTItemplate'} );
set(hb,'backgroundcolor',[ 0.9373    0.8667    0.8667]);

set(hb,'tooltipstring',[...
    '<html><b>select DTI-template</b><br>' ...
    ' - select two files here:  <br>' ...
    [ '  (1) DTI-template (NIFTI-file) ..example:'  '<font color=green>' '"DTI_harms31mar20.nii"  <font color=black><br>' ]...
    [ '  (2) LUT-ile(txt-file) ..example:'  '<font color=green>' '"DTI_harms31mar20_info.txt" <font color=black><br>' ]...
    '   - selection order is arbitrary' ...
    ]);

%% ----------update-checklist-------------------
hb=uicontrol('style','pushbutton','units','norm','string','update listbox','tag','getchecklist');
set(hb,'position',[0.34816 0.66457 0.15 0.1]);
set(hb,'callback',{@process, 'getchecklist'},'backgroundcolor',[0.8392    0.9098    0.8510]);

set(hb,'tooltipstring',[...
    '<html><b>manually update checklist/listbox</b><br>' ]);
% ==============================================
%%   procs
% ===============================================
%% frame-2
hframe2 = uipanel('Title','PROCESSING STEPS','FontSize',8,'tag','uip2',...
    'BackgroundColor','white');
set(hframe2,'position',[[0.001 0 .34 .64]]);


%% ===============================================
%% distributefiles
hb=uicontrol('style','pushbutton','units','norm','string','distribute files','tag','distributefiles');
set(hb,'position',[[0.0035714 0.4726 0.15 0.1]]);
set(hb,'callback',{@process, 'distributefiles'} );
set(hb,'tooltipstring',['copies the b-table/DTI-atlas (Nii+txt) to the animal folders in dat-folder']);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',               'ch_distributefiles');
set(hb,'position',[[0.155 0.4726 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "distribute files"  via [run all steps]-button']);
set(hb,'value',1);
%% ===============================================
%% deformfiles
hb=uicontrol('style','pushbutton','units','norm','string','deform files','tag','deformfiles');
set(hb,'position',[0.0035714 0.37671 0.15 0.1]);
set(hb,'callback',{@process, 'deformfiles'} );
set(hb,'tooltipstring',[ '<html><b>deform images</b><br>' ...
    'deform images to native space (space of t2.nii): <br>' ...
    ' -AVGTmask.nii<br> -AVGThemi.nii<br> -DTI_ATLAS ']);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',          'ch_deformfiles');
set(hb,'position',[[0.155 0.37671 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "deform files"  via [run all steps]-button']);
set(hb,'value',1);
%% ===============================================
%% registerimages
hb=uicontrol('style','pushbutton','units','norm','string','register images','tag','registerimages');
set(hb,'position',[0.0035714 0.28082 0.15 0.1]);
set(hb,'callback',{@process, 'registerimages'} );
set(hb,'tooltipstring',[ '<html><b>register these images to the 4D DTI image: </b><br>' ...
    ' -ix_ANO.nii<br> -ix_AVGTmask.nii<br> -ix_AVGT.nii<br> -ix of DTI-ATLAS<br> -mt2.nii<br>']);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',             'ch_registerimages');
set(hb,'position',[[0.155 0.28082 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "register images"  via [run all steps]-button']);
set(hb,'value',1);
%===================================================================================================
%% renamefiles
hb=uicontrol('style','pushbutton','units','norm','string','rename files','tag','renamefiles');
set(hb,'position',[0.0035714 0.18493 0.15 0.1]);
set(hb,'callback',{@process, 'renamefiles'} );
set(hb,'tooltipstring',[ '<html><b>make copy and rename files of following images</b><br>' ...
    [ 'rc_ix of "DTI-ATLAS ---> ANO_DTI.nii'  '<br>'] ...
    [ 'DTI-Atlas LUT (txt-file) ---> atlas_lut.txt'  '<br>'] ...
    [ 'DTI-Atlas LUT (txt-file) ---> ANO_DTI.txt  (again ...is a copy of atlas_lut.txt)'  '<br>'] ...
    ]);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',           'ch_renamefiles');
set(hb,'position',[[0.155 0.18493 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "rename files"  via [run all steps]-button']);
set(hb,'value',1);

%% ===============================================
%% export files
hb=uicontrol('style','pushbutton','units','norm','string','export files','tag','exportfiles');
set(hb,'position',[[0.0035714 0.089145 0.15 0.1]]);
set(hb,'callback',{@process, 'exportfiles'} );

set(hb,'tooltipstring',[ '<html><b>OPTIONAL STEP: export files for mrtrix-processing </b><br>' ...
    [ ' -this step is optional '  '<br>'] ...
    [ '- use this step if mrtrix processing is done one another computer'  '<br>'] ...
    [ ' -the exported files will be stored in ..mySTUDY/DTI_export4mrtrix'  '<br>'] ...
    [ '<b> The export-folder is <font color=red>"DTI_export4mrtrix" <font color=black> within '...
    'the study-folder'  '<br>'] ...
    ]);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',          'ch_exportfiles');
set(hb,'position',[[0.155 0.089145 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "export files"  via [run all steps]-button']);
set(hb,'value',1);

%% ===============================================
%% check registration overlay
hb=uicontrol('style','pushbutton','units','norm','string','check registration','tag','checkreg');
set(hb,'position',[[0.0035714 -0.0109 0.15 0.1]]);
set(hb,'callback',{@process, 'checkreg'} ,'fontsize',7);

set(hb,'tooltipstring',[ '<html><b>OPTIONAL STEP: check registration of images to DWI/DTI-images </b><br>' ...
    [ ' -this step is optional '  '<br>'] ...
    [ ' -HTML-files with overlays are created in the "checks"-folder within the study-folder'  '<br>'] ...
    [ ' -this step is performed using the data in the "dat"-folder not the export-folder'  '<br>'] ...
    ...
    ]);
% ----chk
hb=uicontrol('style','checkbox','units','norm','string','','tag',          'ch_checkreg');
set(hb,'position',[[0.155 -0.0109 0.025 0.1]],'backgroundcolor','w');
set(hb,'tooltipstring',['-select this to execute "check registration"  via [run all steps]-button']);
set(hb,'value',1);

%% ===============================================
%% select all
hb=uicontrol('style','radio','units','norm','string','select all','tag',   'selectallsteps');
set(hb,'position',[0.22317 0.13481 0.1 0.1],'fontsize',7,'backgroundcolor','w');
set(hb,'callback',@selectallsteps );
set(hb,'tooltipstring',['-select all processing steps']);
set(hb,'value',1);
%% ===============================================
%% mdir_type: all animals
hb=uicontrol('style','radio','units','norm','string','all animals','tag',   'allmdirs');
set(hb,'position',[[0.22495 0.52299 0.11 0.085]],'fontsize',7,'backgroundcolor','w','foregroundcolor','m');
set(hb,'callback',@mdir_type );
set(hb,'tooltipstring',['<html><b>animal selection </b><br>' ...
    ['[x] DTIprep is done for all animals in dat-folder ' '<br>']...
    ['[ ] DTIprep is done for selected animals via ANT-gui animal-listbox()' ]...
    ]);
set(hb,'value',0);

%% ===============================================
%% run all steps
hb=uicontrol('style','pushbutton','units','norm','string','run all steps','tag','runallpreprocsteps');
set(hb,'position',[0.21959 0.025209 0.11 0.1],'fontsize',8);
set(hb,'callback',{@process, 'runallpreprocsteps'} );
set(hb,'backgroundcolor',[   0.8039    0.8784    0.9686]);
set(hb,'tooltipstring',[ '<html><b>run all selected processing steps (gray buttons) </b><br>']);
%% ===============================================
%% help
hb=uicontrol('style','pushbutton','units','norm','string','help','tag','xhelp');
set(hb,'position',[0.22317 0.91118 0.05 0.08],'fontsize',8);
set(hb,'callback',{@xhelp} );
set(hb,'backgroundcolor',[   1 1 1]);
set(hb,'tooltipstring',[ 'get some help']);
%% file assignmnet
hb=uicontrol('style','pushbutton','units','norm','string','check file assignment');
set(hb,'position',[[0.16781 0.80157 0.15 0.08]],'fontsize',7,'foregroundcolor','m','fontweight','bold');
set(hb,'callback',{@context,'checkassignment'},'tag','checkassignment' );
set(hb,'backgroundcolor',[   1 1 1]);
set(hb,'tooltipstring',[ 'check b-table & DTI-data file assignment (order)']);
%% rename b-tables
hb=uicontrol('style','pushbutton','units','norm','string','rename b-table(s)');
set(hb,'position',[[0.16782 0.69439 0.15 0.08]],'fontsize',7,'foregroundcolor','k');
set(hb,'callback',{@context,'rename_btables'},'tag','rename_btables' );
set(hb,'backgroundcolor',[   1 1 1]);
set(hb,'tooltipstring',[ '<html><b>rename b-tables (for MULTIshell-only) </b><br>' ...
    '..REASON: <br>' ...
    'filenames of corresponding DWI-files are hard-coded in the current MRTRIX-shellscripts <br>'...
    'if you have 4 btables, the names of the b-tables must be: <br>'...
    ' "grad_b100.tx" , "grad_b900.tx" , "grad_b1600.tx" and "grad_b2500.tx" <br>'...
    'the renameing is done here on the b-tables (txt.files) in the study''s "DTI"-folder'
    ]);

% ==============================================
%%   contextmenu.
% ===============================================
hf=findobj(0,'tag','DTIprep');
% u=get(hf,'userdata');
c = uicontextmenu;
% m= uimenu(c,'Label','delete current selection from history','Callback',@removefromhistory);
% m= uimenu(c,'Label','delete history of THIS STUDY (all entries of this study is deleted)','Callback',{@context,'deleteStudy'});
% m= uimenu(c,'Label','keep newest 3 entries  of THIS STUDY in history (remove the older entries)','Callback',{@context,'keepNewest3'});

m= uimenu(c,'Label','open study directory','Callback',{@context,'openStudyDir'},'separator','on');
m= uimenu(c,'Label','open DTI-directory',  'Callback',{@context,'openDTIDir'},'separator','off');
m= uimenu(c,'Label','<html><font color =fuchsia>which animal are currently selected?','Callback',{@context,'checkSelectedDirs'},'separator','on');
% m= uimenu(c,'Label',' show configfile','Callback',{@context,'showConfigfile'});
m= uimenu(c,'Label','<html><font color =red> delete files','Callback',{@context,'deletefiles'},'separator','on');
m= uimenu(c,'Label','<html><font color =blue><b>check assignment of b-tables & (DWI-files)',  'Callback',{@context,'checkassignment'},'separator','on');
m= uimenu(c,'Label','<html><font color =blue>reorder b-table/DWI-data',   'Callback',{@context,'reorder_data'},'separator','off');
m= uimenu(c,'Label','<html><font color =green>sow voxel size of 1st DTI/DWI-file ',  'Callback',{@context,'getvoxSize'},'separator','on');
m= uimenu(c,'Label','<html><font color =green>show comands for mrtrix',  'Callback',{@context,'comands_for_mrtrix'},'separator','on');

% ==============================================
%%   UIMENU/TOOLS
% ===============================================

f = uimenu('Label','                             ');
f = uimenu('Label','<html><b>Tools');

m= uimenu(f,'Label','open study directory','Callback',{@context,'openStudyDir'},'separator','on');
m= uimenu(f,'Label','open DTI-directory',  'Callback',{@context,'openDTIDir'},'separator','off');
m= uimenu(f,'Label','<html><font color =fuchsia>which animal are currently selected?','Callback',{@context,'checkSelectedDirs'},'separator','on');
% m= uimenu(c,'Label',' show configfile','Callback',{@context,'showConfigfile'});
m= uimenu(f,'Label','<html><font color =red> delete files','Callback',{@context,'deletefiles'},'separator','on');
m= uimenu(f,'Label','<html><font color =blue><b>check assignment of b-tables & (DWI-files)',  'Callback',{@context,'checkassignment'},'separator','on');
m= uimenu(f,'Label','<html><font color =blue>reorder b-table/DWI-data',   'Callback',{@context,'reorder_data'},'separator','off');
m= uimenu(f,'Label','<html><font color =green>sow voxel size of 1st DTI/DWI-file ',  'Callback',{@context,'getvoxSize'},'separator','on');
m= uimenu(f,'Label','<html><font color =green>show comands for mrtrix',  'Callback',{@context,'comands_for_mrtrix'},'separator','on');

%% ===============================================
f = uimenu('Label','<html><b>MIsc');
m= uimenu(f,'Label','show/edit DTIconfig-file','Callback',{@context,'DTIconfig_edit'},'separator','on');
%% ===============================================
f = uimenu('Label','MRTRIX-ISSUES/BUGs');
uimenu(f,'Label','Solution: ERROR ""inconsistent b-values detected" ','Callback',{@MRTRIXissue, 'inconsistent-b-values'});
%% ===============================================

set(hf     ,'UIContextMenu',c);
set(hframe2,'UIContextMenu',c);

% ==============================================
%%   disable controls
% ===============================================
global an
q=an;
% q=[]
if isempty(q)
    set(findobj(gcf,'Type','uicontrol'),'enable','off');
    set(findobj(gcf,'tag','studypath'),'enable','on');
    u.studypath=[];
else
    u.studypath=fileparts(q.datpath);
end

% ==============================================
%%   scripts-button
% ===============================================
hb=uicontrol('style','pushbutton','units','norm','string','scripts','tag','scripts_pb');
set(hb,'position',[0.3678 0.025209 0.07 0.08],'fontsize',8);
set(hb,'callback',{@scripts_pb} );
set(hb,'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 1]);
set(hb,'tooltipstring',[ '<html><b>collection of scripts</b><br>'...
    'some scripts that might be usefull']);

% ==============================================
%% userdata +update
% ===============================================
u.dummi=1;
set(gcf,'userdata',u);
if ~isempty(u.studypath)
    updateLB();
end


% ==============================================
%%  MRTRIXissue
% ===============================================
function MRTRIXissue(e,e2,task)
hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
dtipath=fullfile(u.studypath,'DTI');
f1=fullfile(dtipath,'check.mat');

if strcmp( task,  'inconsistent-b-values')
    load(f1);
    
    %% ---
    cprintf('*[0  0 1]', [ '___ MRTRIX-BUG: "inconsistent-b-values" ___ \n' ]);
    cprintf([0  0 1], [ 'Which of the following B-tables produces the error "inconsistent b-values detected" error" : \n' ]);
    cprintf([0  0 1], [ '...type enter without input to cancel : \n' ]);
    
    [~, gradnames ext]=fileparts2(d.btable);
    
    disp(char(cellfun(@(a,b,c){[ num2str(a) ') ' b c ]}, num2cell([1:size(d.btable,1)]'), gradnames,ext )));
    cprintf([0  0 1], [ 'enter a number":' ]);
    q1=input('','s');
    
    if isnumeric(str2num(q1)) && ~isempty(str2num(q1))
        f1=d.btable{str2num(q1)};
        if exist(f1)~=2;
            msgbox([  'file not found: "' f1 '"']);
        end
        q2=input('enter noise reducing factor (default: 1.5): ','s');
        fac=str2num(q2);
        if isempty(fac);
            fac=1.5;
        end
        %%   ==============================================
        a=textread(f1);
        ix=find(a(:,4)~=0);
        c=a(ix,4);
        cm=mean(c);sd=std(c);
        d=c-cm;
        d=(d/fac)+cm; %d=(d/1.5)+cm;
        e=[a(:,1:3) zeros(size(a,1),1)];
        e(ix,4)=d;
        disp(['..reducing variation in B-table..'])
        disp(sprintf('ORIGINAL TABLE: ME=%2.2f (SD=%2.2f)', mean(c),std(c) ));
        disp(sprintf('MODIFIED TABLE: ME=%2.2f (SD=%2.2f)', mean(d),std(d) ));
        
        [pas name ext]=fileparts(f1);
        nameoriginal=[name '_original'      ext ];
        nameadjusted=[name '_adjusted'      ext ];
        f2=fullfile(pas,nameoriginal);
        f3=fullfile(pas,nameadjusted);
        disp(['saved original Btable: "' nameoriginal '"' '   (FULLNAME: ' f2 ' )' ]);
        disp(['saved adjusted Btable: "' nameadjusted '"' '   (FULLNAME: ' f3 ' )' ]);
        
        pwrite2file(f2,a);
        pwrite2file(f3,e);
        %% ----------
        cprintf('*[1  0   1]', [ '..what next..\n' ]);
        disp(['1) DIRTY SOLUTION: ']);
        disp(['copy "' nameadjusted '" from "DTI"-DIR into  the respective animal folder  ']);
        disp(['..and rename the file to "'  [ name ext] '"']);
        disp(['2) BETTER SOLUTION: ']);
        disp(['..available soon...sorry... "']);
        
        
        %disp('in case this error occurs for an animal do the following:')
        
        
        %%
        %%   ==============================================
    end
    %% ----
end

% ==============================================
%%  PROC STEPS
% ===============================================

function process(e,e2,task,pp)
isGUI=1;
if exist('pp')==1
    isGUI=0;
    d=getdata();
    dtipath=d.dtipath;
    u.studypath=d.studypath;
end

% disp(['TASK: ' task]);
cprintf([0 .5 1], ['TASK: ' task '... \n']);
if isGUI==1;
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    dtipath=fullfile(u.studypath,'DTI');
end
f1=fullfile(dtipath,'check.mat');

% ==============================================
%%   load configfile -parameter
% ===============================================

fconfig=fullfile(dtipath,'DTIconfig.m');
if exist(fconfig)==2
    thispa=pwd;
    try
        cd(dtipath);
        cc=DTIconfig();
    end
    cd(thispa);
    
end

% ==============================================
%%   STUDY-PATH
% ===============================================
if strcmp(task,'pb_studypath')
    [pas,sts] = spm_select(1,'dir','select the STUDY-folder (this folder contains the dat-folder)','',pwd);
    if sts==0; return; end
    u.studypath=pas;
    set(hf,'userdata',u);
    
    set(findobj(hf,'Type','uicontrol'),'enable','on');
    updateLB();
    %disp([' "DTI"-folder created'  ]);
    paDTI=fullfile(u.studypath,'DTI');
    showinfo2('..The "DTI"-dir contains the Info. ' ,paDTI,[],[], [ '>> '  paDTI  ]);
    cprintf([0 0 1], ['   DONE!\n']);
    return
end
% ==============================================
%%   checklist
% ===============================================
if strcmp(task,'getchecklist')
    updateLB();
    return
end
% ==============================================
%%   BTABLE
% ===============================================
if strcmp(task,'getbtable')
    o=getBtable;
    if isempty(o)
        disp('..user abort');
        return
    end
    
    % sort b-table accord size of entries in txt-files
    %     [~,isort]=sort(cell2mat(cellfun(@(a){[ size(a,1) ]} ,o(:,2))));
    %     o=o(isort,:);
    
    
    load(f1);
    bfi={};
    ck=zeros(size(o,1), 1);
    try
        for i=1:size(o,1)
            bfi=[bfi; o{i,3}.fileout];
            if exist(o{i,3}.fileout)==2
                ck(i,1)=1;
            end
        end
        if all([1 1])==1
            d.btable=bfi;
            save(f1,'d');
            
        else
            err=lasterr;
            msgbox({'b-table files not found' ['error: ' err]}) ;
        end
    catch
        msgbox({'could not update b-tables...something went wrong!' ...
            ['error: ' err]})
    end
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
end
% ==============================================
%%   getDTItemplate
% ===============================================
if strcmp(task,'getDTItemplate')
    load(f1);
    pax=d.studypath;
    mesg='select DTI-template (NIFTI-file) and LUT-ile(txt-file)  (arbitrary order)';
    %    [t,sts] = spm_select(n,typ,mesg,sel,wd,filt,frames)
    [t,sts] = spm_select(2,'any',mesg,[],pax,'.*.nii|.*.txt');
    if sts==0; return; end
    
    if size(t,1)~=2;
        msgbox({'ERROR' ...
            'DTI-template (NIFTI-file) and LUT-ile(txt-file)  (arbitrary order) has to be selected'...
            '-two files expected! '
            });
    end
    fis=cellstr(t);
    [~,~,ext]=fileparts2(fis);
    %__________________
    d.DTItemplate    = fis{find(strcmp(ext,'.nii'))};
    d.DTItemplateLUT = fis{find(strcmp(ext,'.txt'))};
    save(f1,'d');
    
    
    copyfile( d.DTItemplate    ,replacefilepath(d.DTItemplate, dtipath ), 'f');
    copyfile( d.DTItemplateLUT ,replacefilepath(d.DTItemplateLUT, dtipath ), 'f');
    %____________________
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
end
% ==============================================
%%    getDTIfile
% ===============================================
if strcmp(task,'getDTIfile')
    
    
    load(f1);
    pax=fullfile(d.studypath,'dat');
    if size(d.btable,1)==1
        mesg='SINGLE-SHELL: select one DTI-file (NIFTI-file) from one of the animals';
        cprintf('*[1 0 1]', [ 'SINGLE-SHELL: select one DTI-file (NIFTI-file) from one of the animals' '\n' ]);
        [t, sts]=  cfg_getfile2(1,'image',mesg,[],pax,'.*.nii');
    else
        % ==============================================
        %%
        % ===============================================
        
        mesg={'MULTI-SHELL: select multishell DTI-files from one (!) of the animals'
            '(1)NUMBER OF FILES: the number of the files must correpond to the number of b-tables'
            '(2)FILE ORDER:  ASCENDING ..from lowest to largest   (b100, b1600,b3400, b6000)'
            ' '};
        cprintf('*[1 0 1]', [ 'MULTI-SHELL: select multishell DTI-files from one (!) of the animals' '\n' ]);
        
        [t, sts]=  cfg_getfile2(inf,'image',mesg,[],pax,'.*.nii');
        % ==============================================
        %%
        % ===============================================
        
    end
    
    %    [t,sts] = spm_select(n,typ,mesg,sel,wd,filt,frames)
    %[t,sts]    = spm_select(1,'image',mesg,[],pax,'.*.nii');
    %[t, sts]=  cfg_getfile2(inf,'image',mesg,[],pax,'.*.nii');
    if sts==0;
        disp('..user abort');
        return;
    end
    %[~, name, ext]=fileparts(t);
    [~, name, ~ ]=fileparts2(t);
    
    % __try sorting files via numeric values
    try
        [sortnames isort ]=sort(str2num(char(regexprep(name,'\D',''))));
        if ~isempty(isort)
        name=name(isort);
        end
    end
    
    d.DTIfileName=cellfun(@(a){[ a '.nii' ]},  name);
    save(f1,'d');
    
    %____________________
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
    
end

% ==============================================
%%   DISTRIBUTE-FILES
% ===============================================


if strcmp(task,'distributefiles')
    cprintf('*[1 0 1]', ['START..  distributing files.. \n']);
    padat=fullfile(u.studypath,'dat');

    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    %disp(mdirs);
    
    
    if isempty(mdirs); return; end
    mdirs=cellstr(mdirs);
    load(f1);
    for i=1:length(mdirs)
        thispa=mdirs{i};
        
        for j=1:length(d.btable)
            %% ================copy btable===============================
            try
                fi1=d.btable{j};
                fi2=replacefilepath(fi1,thispa);
                copyfile(fi1,fi2,'f');
            catch
                disp(['..could not copy btable:  ' fi1 ' to' thispa]) ;
                err=lasterr;
                disp(err);
            end
        end
        %% ================copy DTItemplate===============================
        try
            fi1=d.DTItemplate;
            fi2=replacefilepath(fi1,thispa);
            copyfile(fi1,fi2,'f');
        catch
            disp(['..could not copy DTIatlas-NIFTI:  ' fi1 ' to' thispa]) ;
            err=lasterr;
            disp(err);
        end
        %% ================copy DTItemplateLUT===============================
        try
            fi1=d.DTItemplateLUT;
            fi2=replacefilepath(fi1,thispa);
            copyfile(fi1,fi2,'f');
        catch
            disp(['..could not copy DTIatlas-LUT:  ' fi1 ' to' thispa]) ;
            err=lasterr;
            disp(err);
        end
        
        
        
        
    end %dirs
    
    if isGUI==1
        updateLB();
    else
        d.is_Atlas_and_Btable_distributed='YES';
        setdata(d);
    end
    cprintf('*[0 0 1]', ['DONE!  (distribute files) \n']);
end




% ==============================================
%%   deformfiles
% ===============================================
if strcmp(task,'deformfiles')
    cprintf('*[1 0 1]', ['START..  deforming files.. \n']);
    padat=fullfile(u.studypath,'dat');
  
    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    %disp(mdirs);
    
    
    d=load(f1); d=d.d;
    
    
    %-------DTI-ATLAS---------
    [~, finame, ext]=fileparts(d.DTItemplate);
    files=stradd(mdirs,[ finame ext ] ,2);
    filename=[finame ext];
    pp.source =  'intern';
    fis=doelastix(-1, mdirs,filename,0,'local' ,pp);
    
    %------- AVGTmask.nii & AVGThemi.nii ---------
    pp.source =  'intern';
    fis=doelastix(-1, mdirs,{'AVGTmask.nii' 'AVGThemi.nii'},0,'local' ,pp);
    
    %     if 0
    %         %% DEFORM VIA ELASTIX
    %         files = {'F:\data4\ernst_DTImrtrix\dat\Tom_NH\DTI_harms31mar20.nii'};
    %         pp.source =  'intern';
    %         fis=doelastix(-1, [],files,0,'local' ,pp);
    %     end
    %____________________
    
    %______________________________________________________
    if isGUI==1
        updateLB();
    else
        d.isdeformed='YES';
        setdata(d);
    end
    cprintf('*[0 0 1]', ['DONE! (deforming files)\n']);
end

% ==============================================
%%   register images
% ===============================================
if strcmp(task,'registerimages')
    cprintf('*[1 0 1]', ['START..  registering images.. \n']);
    padat=fullfile(u.studypath,'dat');
    
    
    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    %disp(mdirs);
    
    
    d=load(f1); d=d.d;
    
    % ==============================================
    %%
    % ===============================================
    if isGUI==1
        hf=findobj(0,'tag','DTIprep');
        u=get(hf,'userdata');
        padat=fullfile(u.studypath,'dat');
    end
    
    %% ======================================================
    %% new
    %% ======================================================
    if 1
        [~, DTItemplate0]=fileparts(d.DTItemplate);
        DTItemplate=['ix_' DTItemplate0 '.nii'];
        
        approach=cc.coreg_approach  ;  % formerly : 1;
        if approach==1 %SPM
            v.xcoregtask='[2]';
            v.warping=0;
        elseif approach==2 %ELASTIX
            v.xcoregtask='[100]';
            v.warping=1;
        end
        z=[];
        z.TASK         =v.xcoregtask ;% ########### FILLED ABOVE        %{'[100]'}%{ '[2]' };
        z.targetImg1   =d.DTIfileName{1}  ;%{ 'DTI_EPI_3D_40dir_sat_1.nii' };
        z.sourceImg1   ={ 't2.nii' };
        z.sourceImgNum1=[1];
        z.applyImg1={ ...
            'ix_ANO.nii'
            'ix_AVGTmask.nii'
            DTItemplate              %'ix_DTI_harms31mar20.nii'
            ...
            'mt2.nii'
            'ix_AVGT.nii'};
        
        
        z.cost_fun      =cc.cost_fun     ;% FORMERLY: 'nmi';
        z.sep           =cc.sep          ;% FORMERLY: [4  2  1  0.5  0.1  0.05];
        z.tol           =cc.tol          ;% FORMERLY: [0.01  0.01  0.01  0.001  0.001  0.001];
        z.fwhm          =cc.fwhm         ;% FORMERLY: [7  7];
        z.interpOrder   =cc.interpOrder  ;% FORMERLY: 0;'auto';%[0];
        z.warpParamfile =cc.warpParamfile;% FORMERLY: {fullfile(fileparts(antpath),'elastix','paramfiles','Par0025affine.txt')};
        z.cleanup       =cc.cleanup      ;% FORMERLY: [1];
        z.isparallel    =cc.isparallel   ;% FORMERLY: [0]; i.e. not specified
        
        z.centerering=[0];
        z.reslicing=[1];
        
        z.prefix      ='r';
        z.warping     =v.warping ;  % ########### FILLED ABOVE
        z.warpPrefix  ='c_';
        
        
        
        xcoreg(0,z,mdirs);
        %% ===============================================
    end %new
    
    
    
    %% ======================================================
    %% BACKUP: old
    %% ======================================================
    if 0
        [~, DTItemplate0]=fileparts(d.DTItemplate);
        DTItemplate=['ix_' DTItemplate0 '.nii'];
        
        approach=1;
        if approach==1 %SPM
            v.xcoregtask='[2]';
            v.warping=0;
        elseif approach==2 %ELASTIX
            v.xcoregtask='[100]';
            v.warping=1;
        end
        z=[];
        z.TASK         =v.xcoregtask ;% ########### FILLED ABOVE        %{'[100]'}%{ '[2]' };
        z.targetImg1   =d.DTIfileName{1}  ;%{ 'DTI_EPI_3D_40dir_sat_1.nii' };
        z.sourceImg1   ={ 't2.nii' };
        z.sourceImgNum1=[1];
        z.applyImg1={ ...
            'ix_ANO.nii'
            'ix_AVGTmask.nii'
            DTItemplate              %'ix_DTI_harms31mar20.nii'
            ...
            'mt2.nii'
            'ix_AVGT.nii'};
        z.cost_fun='nmi';
        z.sep=[4  2  1  0.5  0.1  0.05];
        z.tol=[0.01  0.01  0.01  0.001  0.001  0.001];
        z.fwhm=[7  7];
        z.centerering=[0];
        z.reslicing=[1];
        z.interpOrder=0;'auto';%[0];
        z.prefix='r';
        z.warping=v.warping ;  % ########### FILLED ABOVE
        z.warpParamfile={fullfile(fileparts(antpath),'elastix','paramfiles','Par0025affine.txt')};
        %                  fullfile(fileparts(antpath),'elastix','paramfiles','p33_bspline.txt')
        z.warpPrefix='c_';
        z.cleanup=[1];
        xcoreg(0,z,mdirs);
        %% ===============================================
    end %bk-old
    
    
    
    
    %______________________________________________________
    if isGUI==1
        updateLB();
    else
        d.isregistered='YES';
        setdata(d);
    end
    cprintf('*[0 0 1]', ['DONE! (registering images)\n']);
    
end

% ==============================================
%%   renamefiles
% ===============================================
if strcmp(task,'renamefiles')
    cprintf('*[1 0 1]', ['START..  renaming files.. \n']);
    padat=fullfile(u.studypath,'dat');

    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    
    d=load(f1); d=d.d;
    % ==============================================
    %%
    % ===============================================
    
    [~,DTIatlas0]      =fileparts(d.DTItemplate);
    [~,DTItemplateLUT0]=fileparts(d.DTItemplateLUT);
    
    files={...
        'rc_ix_AVGTmask.nii'                 ''
        'rc_ix_ANO.nii'                      ''
        ['rc_ix_' DTIatlas0 '.nii'     ]     'ANO_DTI.nii'          %'rc_ix_DTI_harms31mar20.nii'
        'rc_mt2.nii'                         ''
        'rc_t2.nii'                          ''
        [DTItemplateLUT0 '.txt'             ]    'atlas_lut.txt'
        [DTItemplateLUT0 '.txt'             ]    'ANO_DTI.txt'  %'atlas_lut.txt'
        };
    
    if size(d.btable,1)==1%singleshell
        files(end+1,:)={d.DTIfileName{1}      'dwi.nii'  };
    else %multishell
        [~,btable_name0,ext ]=fileparts2(d.btable);
        btable_name_ext=cellfun(@(a,b){[ a b ]},  btable_name0, ext);
        btable_name  =strrep(btable_name0,'grad_','');
        
        %check
%         n_btables=size(btable_name,1);
%         n_dwis  =size(d.DTIfileName,1);

        n_btables=length(btable_name);
         n_dwis  =length(d.DTIfileName);

%% =========check same-size of b-table and DWI-files ======================================

if n_btables~=n_dwis
    %%
    chktab=repmat({' '}, [  max([n_btables n_dwis]) 2]);
    chktab(1:n_btables,1) =btable_name_ext;
    chktab(1:n_dwis,2)    =d.DTIfileName;
    chktab=[{['\bf' '___b-table___'] ['       ___DWI-file___' '\rm']} ;chktab];
            
            chklist=cellfun(@(a,b){[ a repmat(' ',[1 size(char(chktab(:,1)),2)+10-length(a)]) b ]},  chktab(:,1),chktab(:,2));
            ms={
                '\bf\color{magenta}conflict "renaming files"! ... Process aborted!\rm\color{black}'
                ['number of b-tables does not match the number of DTI/DWI-files!'  ]
                [' No of b-tables :' num2str(n_btables)]
                [' No of DWI-files:' num2str(n_dwis)]
                '\bf #PLEASE CHECK ASSIGNMENT:\rm'
                };
            ms=[ms;chklist];
            ms=strrep(ms,'_','\_');
            errordlg(ms,'',struct('Interpreter','tex','WindowStyle','modal'));
            %%
            return
        end
        
        % keyboard
        for i=1:size(d.DTIfileName,1)
            files(end+1,:)=  {d.DTIfileName{i}     [ 'dwi_' btable_name{i} '.nii' ] };
        end
    end
    %% ===================================================================================================
    
    for k=1:length(mdirs)
        thisdir=mdirs{k};
        nf=1;
        for j=1:size(files,1)
            if ~isempty(files{j,2})
                fx1=fullfile(thisdir, files{j,1});
                fx2=fullfile(thisdir, files{j,2});
                %disp(char([fx1  '#' fx2]));
                
                %% MRTRIX potential error DATAYPE: float-DT instead of Integer
                if strcmp(files{j,2},'ANO_DTI.nii')
                    %keyboard
                    [ha a]=rgetnii(fx1);
                    hb=ha;
                    %hb.dt=[8 0];
                    rsavenii(fx2,  hb,a,64);
                    
                    %[hc c]=rgetnii(fx2);
                    %find(abs(unique(c(:))==unique(a(:))==0))
                elseif strcmp(files{j,2}, 'atlas_lut.txt') || strcmp(files{j,2}, 'ANO_DTI.txt')
                    lut=preadfile(fx1); lut=lut.all;
                    lut=regexprep(lut,'['''']',''); %remove apostrophe as in Ammon's_horn (produces an error in DTI-pipeline)
                    pwrite2file(fx2,lut)
                else
                    if strcmp(fx1,fx2)==0
                        copyfile(fx1,fx2,'f');
                    end
                end
                %%  ----remove 'descrip' & private  frpm HDR----------
                [paw namew extw]= fileparts(fx2);
                if strcmp(extw,'.nii')==1
                    hb=spm_vol(fx2);
                    hb=rmfield(hb,'private');
                    hb=rmfield(hb,'descrip');
                    spm_create_vol(hb);
                    %hv=spm_vol(fx2);
                    %disp(hv(1));
                end
                
                %---------
                showinfo2([ num2str(k) '-' num2str(nf) ' RENAMED' ] ,fx2,[],[], [ '>> ' fx2 ]);
                nf=nf+1;
            end
        end %files
        %---check GRADFILES: add newline ad the end of file if not exists-----------
        if 1
            for j=1:size(d.btable,1)
                [paw namew ext]=fileparts(d.btable{j});
                grfile=fullfile(thisdir, [namew ext]);
                a=fileread(grfile);
                
                if double(a(end))~=10
                    a2=str2num(a);
                    %a= preadfile(grfile)
                    pwrite2file(grfile,a2);
                end
            end
        end
        
        % ==============================================
        %%      create the btables with fixed Bvalues
        % ===============================================
        for j=1:size(d.btable,1)
            [paw namew ext]=fileparts(d.btable{j});
            grfix_file =fullfile(thisdir, [namew ext]);
            grfix_file2=stradd(grfix_file,'_fix',2);
            
            t=preadfile(grfix_file);
            t=t.all;
            t=str2num(char(t));
            
            me=median(t(2:end,4));
            t(2:end,4)=me;
            
            pwrite2file(grfix_file2,t); 
            showinfo2([ ' ... crating btable-for-preprocessing: ' ] ,grfix_file2,[],[], [ '>> ' grfix_file2 ]);
        end
        
        
        
        
        
        
        %% ===============================================
        
    end%Mdirs
    
    
    
    
    % ==============================================
    %%
    % ===============================================
    
    
    % These scans should be finally in the?dat location:
    % - dwi_b100.nii ,dwi_b1600, dwi_b3400, dwi_b6000
    % - rc_ix_AVGTmask.nii
    % - rc_ix_ANO.nii
    % - rc_ix_example_atlas.nii
    % - rc_ mt2.nii
    % - rc_t2.nii
    % - atlas_lut.txt
    
    
    %____________________
    if isGUI==1
        updateLB();
    else
        d.isrenamed='YES';
        setdata(d);
    end
    cprintf('*[0 0 1]', ['DONE! (renaming files) \n']);
    
end

% ==============================================
%%
% ===============================================
if strcmp(task,'exportfiles')
    cprintf('*[1 0 1]', ['START ... exporting files) \n']);
    paexp=fullfile(fileparts(dtipath), 'DTI_export4mrtrix');
    mkdir(paexp);
    paexpdat=fullfile(paexp, 'dat');
    mkdir(paexpdat);
    
    
    padat=fullfile(u.studypath,'dat');

    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    
    %% ------files
    d=load(f1); d=d.d;
    [~,dum]=fileparts2(d.btable);
    btablefiles=stradd(dum,[  '.txt' ] ,2);
    
    
    if size(btablefiles,1)==1 %single shell
        DWIfiles={'dwi.nii'};
    else%multishell
        DWIfiles=cellfun(@(a){[ a '.nii' ]},  strrep(dum,'grad','dwi'));
    end
    
    files={...
        'rc_ix_AVGTmask.nii'
        'rc_mt2.nii'
        'rc_t2.nii'
        ...
        'atlas_lut.txt'
        'ANO_DTI.txt'  %'atlas_lut.txt'
        'ANO_DTI.nii'
        };
    files=[files; btablefiles; DWIfiles];
    files=[files; stradd(btablefiles,'_fix',2)];% add grad with fixed b-values
    
    %% ------for each animal
    for i=1:length(mdirs)
        thispa=mdirs{i};
        [~,mname]=fileparts(thispa);
        thispa_export=fullfile(paexpdat,mname);
        mkdir(thispa_export);
        ms1=['[target]: ' thispa_export ' ' ';[source]: ' thispa ''   ];
        showinfo2('exporting files for' ,thispa_export,[],[], [ '>> ' ms1 ]);
        
        for j=1:length(files)
            fi1=fullfile(thispa        ,files{j}  );
            fi2=fullfile(thispa_export ,files{j}  );
            try
                copyfile(fi1,fi2,'f');
            catch
                if exist(fi1)==2
                    ms=[ ' ..there is another reason why export failed, the exporting file exist: '  fi1  ];
                else
                    ms=[ ' ..exporting file does not exist: '  fi1  ];
                end
                ms2=[' export failed for [' mname ']' ', file: [' files{j} '] ' ms  ];
                [msgstr, msgid]=lasterr;
                cprintf([1 0 1], [strrep(ms2,filesep,[filesep filesep]) msgid  ]);
                cprintf([0.9294    0.6941    0.1255], ['  ' msgid  '\n' ]);
            end
        end
    end
    
    %---------
    showinfo2('EXPORT-MAIN-FOLDER' ,paexp,[],[], [ '>> '  paexp  ]);
    cprintf('*[0 0 1]', ['DONE! (exporting files) \n']);
    %%
    
end
%% ===============================================

if strcmp(task,'checkreg')
    
    %% ===============================================
    cprintf('*[1 0 1]', ['START ... make HTMLfiles (check registration)) \n']);
    d=load(f1); d=d.d;
    
    imno=cc.cr.bgImageIndex;
    
    bgimg    ={d.DTIfileName{imno}}; % formerly: 1
    ovimg    =cc.cr.ovImg; % formerly: {'rc_t2.nii' 'rc_ix_AVGTmask.nii' 'ANO_DTI.nii' };
    pa_check =fullfile(d.studypath,cc.cr.outputdir); % formerly: fullfile(d.studypath,'checks')
    
    padat    =fullfile(u.studypath,'dat');
   
    
    if exist('pp') && isfield(pp,'mdirs')
        mdirs=pp.mdirs;
    else
        mdirs=get_mdir(padat);
    end
    
    
    z=[];
    z.backgroundImg = bgimg;%{ 't2.nii' };                     % % background/reference image (a single file)
    z.overlayImg    = ovimg;%{ 'c1t2.nii'   }                   % % overlay image [t2], (may be multiple files)
    z.outputPath    = pa_check           ;%formerly:'F:\data3\graham_ana4\check';     % % select outputpath (path to write HTMLfiles and images)
    z.outputstring  = cc.cr.outputstring ;%formerly: 'DTIreg';                    % % optional output string added to html  and image-directory
    z.slices        = cc.cr.slices       ;%formerly:'n20';                             % % " (1) n"+number: number of slices to plot or (2) a single number, which plots every nth. image
    z.dim           = cc.cr.dim          ;%formerly:[1];                              % % dimension to plot {1,2,3}: in standardspace: {1}transversal,{2}coronal,{3}sagital
    z.size          = cc.cr.size         ;%formerly:[400];                            % % image size width&high in HTML file
    z.grid          = cc.cr.grid         ;%formerly:[1];                              % % show line grid on top ov image {0,1}
    z.gridspace     = cc.cr.gridspace    ;%formerly:[10];                             % % space between grid lines (pixels)
    z.gridcolor     = cc.cr.gridcolor    ;%formerly:[0  .5  0];                        % % grid color
    xcheckreghtml(0,z,mdirs);
    cprintf('*[0 0 1]', ['DONE!  (creating HTML files..registration-checks) \n']);
    %% ===============================================
    
end
% ==============================================
%%
% ===============================================

if strcmp(task,'runallpreprocsteps')
    run_all_steps()
end


function run_all_steps()
hf=findobj(0,'tag','DTIprep');



if get(findobj(hf,'Tag','ch_distributefiles'),'value')==1
    process([],[],'distributefiles');
end
if get(findobj(hf,'Tag','ch_deformfiles'),'value')==1
    process([],[],'deformfiles');
end
if get(findobj(hf,'Tag','ch_registerimages'),'value')==1
    process([],[],'registerimages');
end
if get(findobj(hf,'Tag','ch_renamefiles'),'value')==1
    process([],[],'renamefiles');
end
if get(findobj(hf,'Tag','ch_exportfiles'),'value')==1
    process([],[],'exportfiles');
end

if get(findobj(hf,'Tag','ch_checkreg'),'value')==1
    process([],[],'checkreg');
end



function selectallsteps(e,e2)
hf=findobj(0,'tag','DTIprep');
val=get(findobj(hf,'Tag','selectallsteps'),'value');
tags={'ch_distributefiles' 'ch_deformfiles' 'ch_registerimages' ...
    'ch_renamefiles' 'ch_exportfiles' 'ch_checkreg' };
for i=1:length(tags)
    set(findobj(hf,'Tag',tags{i}),'value',val);
end

function mdir_type(e,e2)
val=get(e,'value'); %[1]all dirs; [0]from ANTgui
if val==0
    err=0;
    global an
    if isempty(an); err=1; end
    try;
        antcb('getsubjects');
    catch
        err=1;
    end
    if err==1
        msgbox({'Selection of specifc animals not working!'
            'STEPS TO DO THIS: '
            ' 1.) Open ANT-gui and load a project.';
            ' 2.) Select animals from ANT-gui left listbox. '});
        set(e,'value',1); %force [x]...all animals
    else
        
    end
end

% ==============================================
%%   clean up
% ===============================================
function deleteFiles()
%% ===================================================================================================

hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
f1=fullfile(u.studypath,'DTI','check.mat');
d=load(f1); d=d.d;
% --------------------
[~, dum ]=fileparts2(d.btable);
btable=stradd(dum,[  '.txt' ] ,2);

[~, dum, ext ]=fileparts(d.DTItemplateLUT);
lutfile=[dum ext ];

[~, dum, ext ]=fileparts(d.DTItemplate);
atlasfile=[dum ext ];

[~, dum ]=fileparts2(d.DTIfileName);
dtifile=stradd(dum,[  '.nii' ] ,2);


% ==============================================
%%   erasable files-1 (aux-files)
% ===============================================
% clc;
ms1='<html><font color=green>  auxilary files  (deleting file is OK)';
ls1={
    ['rc_ix_' atlasfile]        ms1
    'rc_ix_ANO.nii'             ms1
    'rc_ix_AVGT.nii'            ms1
    };
ls1=[ls1; [  stradd(dtifile,[ 'rc_ix_' ] ,1) repmat({ms1}, [size(dtifile,1) 1])    ]];


ms2='<html><font color=blue>  auxilary files  (deleting file is OK)';
ls2={...
    ['c_ix_' atlasfile]        ms2
    'c_ix_ANO.nii'             ms2
    'c_ix_AVGT.nii'            ms2
    'c_ix_AVGTmask.nii'        ms2
    'c_mt2.nii'                ms2
    };
ls2=[ls2; [  stradd(dtifile,[ 'c_ix_' ] ,1) repmat({ms2}, [size(dtifile,1) 1])    ]];


% id=selector2([ls1a;ls1b],{'file' 'info'},'title','delete files (selected files will be deleted)');


% ==============================================
%   erasable files-2 (input-files for mrtrix)
% ===============================================
ms3='<html><font color=red>  inputfile for mrtrix  (deleting file not suggested)';
ls3={
    'ANO_DTI.nii'         ms3
    'ANO_DTI.txt'         ms3
    'atlas_lut.txt'       ms3
    'dwi.nii'             ms3
    'rc_ix_AVGTmask.nii'  ms3
    'rc_t2.nii'           ms3
    'rc_mt2.nii'          ms3
    };
ls3=[ls3; [btable repmat({ms3}, [size(btable,1) 1])]];

tb=[ls1;ls2;ls3 ];
id=selector2(tb,{'file (to delete)' 'info'},'title','delete files (selected files will be deleted)');

%%   prerequisites


%% questdlg
if 1
    button = questdlg('do you really want to delete the selected files?','', 'Yes','No', 'No');
    if strcmp(button ,'No'); return; end
end
%% ------DELETE FILES
file2del=tb(id,1);
padat=fullfile(u.studypath,'dat');
mdirs=get_mdir(padat);

for i=1:length(mdirs)
    for j=1:length(file2del)
        fx=fullfile( mdirs{i}, file2del{j});
        if exist(fx)==2
            try
                disp([' ...deleting: ' fx ]) ;
                delete(fx)
            end
        end
    end
end




% ==============================================
%%   context
% ===============================================
function context(e,e2,task)
hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
padat=fullfile(u.studypath,'dat');

if strcmp(task,'DTIconfig_edit')
    fconfig=fullfile(u.studypath,'DTI','DTIconfig.m');
    if exist(fconfig)==2
        disp('modify "DTIconfig.m" on your own risk...if broken...please delete "DTIconfig.m" in "DTI"-dir');
        edit(fconfig);
    else
        disp(' .."DTIconfig.m" not found in "DTI"-dir ...');
    end
    return
end

if strcmp(task,'openStudyDir')
    explorer(u.studypath);
    return
end
if strcmp(task,'openDTIDir')
    explorer(fullfile(u.studypath,'DTI'));
    return
end
if strcmp(task,'checkSelectedDirs')
    % ==============================================
    %%
    % ===============================================
    
    mdirs=get_mdir(padat);
    [dirsx] = spm_select('List',padat,'dir','.*');
    ms={...
        [repmat('_',[1 80 ] )]
        [  ' #g <font size="5">  N: ' num2str(size(mdirs,1))  '/' num2str(size(dirsx,1)) ' animal dirs selected' ]
        };
    tb=[{' #ko ANIMALS ***'; repmat('_',[1 80 ]) } ;mdirs; ms];
    uhelp(tb,0,'name','animals');
    % ==============================================
    %%
    % ===============================================
    
    return
end
if strcmp(task,'deletefiles')
    deleteFiles();
    return
end

if strcmp(task,'getvoxSize')
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    f1=fullfile(u.studypath,'DTI','check.mat');
    d=load(f1); d=d.d;
    
    
    mdirs=get_mdir(padat);
    thispa=mdirs{1}
    fx=fullfile(thispa,d.DTIfileName{1});
    if exist(fx)==2
        ha=spm_vol(fx);
        ha=ha(1);
        %%---
        vec=spm_imatrix(ha.mat);
        vox=vec(7:9);
        cprintf(-[0    0.4980         0], ['____VOXELSIZE______'  '\n' ]);
        cprintf([0    0.4980         0], [strrep(['..using ' fx],filesep,[filesep filesep])  '\n' ]);
        disp(sprintf('[voxSize]:\t\t\t\t %2.10f,%2.10f,%2.10f',vox));
        disp(sprintf('[voxSize x factor 10]:\t %2.10f,%2.10f,%2.10f  --> for mrtrix option',vox*10));
        %%---
    else
        disp('..file not found..');
    end
    
    
    return
end


if strcmp(task,'comands_for_mrtrix')
    %%
    ms={
        ''
        ' #b 1) go to shellscripts-folder & make files executable'
        ' #b --------------------------------------------------------'
        'cd Your_DTIdataPath/shellscripts;     # your shellscripts-path'
        'sudo find . -iname "*.sh" -exec bash -c ''chmod +x "$0"'' {} \;  #make files executable'
        ''
        ' #b 2) run mrtrix-processing (pwd must be the dat-folder!)'
        ' #b --------------------------------------------------------'
        'cd ../dat        ; # go to the "dat"-folder'
        ''
        ' #r for MOUSE use this cmd to start processing'
        './../shellscripts/mouse_dti_complete_7texpmri.sh'
        ''
        ' #r for RAT use this cmd to start processing'
        './../shellscripts/rat_exvivo_complete_7expmri.sh'
        
        
        ''
        
        };
    tb=[{' #ko COMANDS FOR MRTRIX ***'} ; ms];
    uhelp(tb,0,'name','mrtrix-processing');
    %%
    
    return
end
% ==============================================
%%   rename b-tables
% ===============================================
if strcmp(task,'rename_btables')
    %% ===============================================
    
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    f1=fullfile(u.studypath,'DTI','check.mat');
    d=load(f1); d=d.d;
    
    tb=d.btable;
    
    if ~all(existn(tb)==2)
        msgbox('PLEASE define b-tabels first! ... via [get b-table(s)]-button');
        return
    end
    if length(tb)==1
       msgbox('renamimg option for MULTISHELL-data only! ... cancelled');
        return 
    end
    
    [ xpa xfi xext ]=fileparts2(tb);
    xfi=cellfun(@(a,b){[ a b]}, xfi, xext );
    %xfi=xfi([2 4 3 1])
    try
        bnumber=str2num(char(regexprep(xfi,'[a-zA-Z\s_.]','')));
    catch
        bnumber=[1:length(xfi)]';
    end
    xfi=sortrows([xfi  num2cell(bnumber)],2);
    xfi=xfi(:,1);
    
    
    choices=  {'grad_b100.txt' , 'grad_b900.txt' , 'grad_b1600.txt' 'grad_b2500.txt' }';
    p={};
    p(end+1,:)={'inf1' '' 'MUTLISHELL-DATA: for b-tables the following filenames are needed:' '' };
    p(end+1,:)={'inf2' '' ['"' strjoin(choices,'","') '"'] '' };
    p(end+1,:)={'inf3' '' ['For your b-tables the following new filenames are suggested: '] '' };
    for i=1:length(xfi)
        opt=[choices];
        sel=choices{i};
        p(end+1,:) = {  ['btable_' num2str(i)]    sel    [ 'RENAME your orig. file "' xfi{i} '" (b-table) to...' ] ...
            opt };
    end
    [m z]=paramgui(p,'close',1,'figpos',[ 0.2000    0.5322    0.5299    0.2189],...
        'title','Rename b-tables'); %%START GUI
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
    
   %% ========[ rename files (make temp-files first)]=======================================
    fn=fieldnames(z);
    fnb=fn(regexpi2(fn,'^btable_'));
    TA=xfi;
    for i=1:length(fnb)
       cur=getfield(z,fnb{i});
       if isempty(cur)
          cur= xfi{i};
       end
        TA{i,2}=['temp_' cur];
        TA{i,3}=cur;
    end
    % ERROR IF SAME NAME IS GIVEN
    if length(unique(TA(:,3)))~=length(fnb)
        msgbox(strjoin({'ERROR: NAME OF NEW b-table-NAME given more than once',...
            'Each b-table needs a different name!'},char(10)));
        return
    end
    
        % FIRST: copy to temporary files
        fis1= stradd(TA(:,1), [xpa{1} filesep],1);
        fis2= stradd(TA(:,2), [xpa{1} filesep],1);
        copyfilem(fis1,fis2),
        % SECOND: remove orig. b-tables
        deletem(fis1);
        %third: rename to final name
        fis3= stradd(TA(:,3), [xpa{1} filesep],1);
        movefilem(fis2,fis3);
    
    %% =========== [update struct] and update GUI =========
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    f1=fullfile(u.studypath,'DTI','check.mat');
    d=load(f1); d=d.d;
    d.btable=fis3;
    
    
    setdata(d);
    delete(hf);
    DTIprep;
    
    %% ===============================================
    
    return
end
% ==============================================
%%  reorder bb-table & DWI-data
% ===============================================
if strcmp(task,'reorder_data')
    ms_error={'reorder of b-tables NOT POSSIBLE'
        'FIRST, define USER INPUT (b-tables)'
        };
    %%
    err=0;
    try
        hf=findobj(0,'tag','DTIprep');
        u=get(hf,'userdata');
        f1=fullfile(u.studypath,'DTI','check.mat');
        d=load(f1); d=d.d;
    catch
        err=1 ;
    end
    if err==1;
        msgbox(ms_error,'warning');
        return
    end
    
    if isfield(d,'btable') && ~isempty(d.btable) && ...
            isfield(d,'DTIfileName') && ~isempty(d.DTIfileName)
        % dummy
    else
        msgbox('both b-tables and DWI-data must be loaded before reordering.. ','reodering');
        return
    end
    
    
    %% ===============================================
    % btable
    [~, btableNames, ext]= fileparts2(d.btable);
    cellfun(@(a,b){[ a b ]} ,btableNames, ext);
    btableNames0=cellfun(@(a,b){[ a b ]} ,btableNames, ext);
    btableNames=regexprep(btableNames0,'_','\\_');
    % DWI-files
    DTIfileName0=d.DTIfileName;
    DTIfileName=regexprep(DTIfileName0,'_','\\_');
    
    
    prompt={...
        ['\color{magenta} Reorder such that b-table and DWI-data match! '...
        'Changing one of the two items might be sufficient. ' '\color{black}' char(10) ...
        '\bf b-table \rm (current order): ' char(10)...
        strjoin(btableNames,char(10)) char(10)...
        '\bf ENTER NEW ORDER \rm (EXAMPLE: [2 1 3 4]): ' ] ...
        ...
        ['\bf DWI-data \rm (current order): ' char(10)...
        strjoin(DTIfileName,char(10)) char(10)...
        '\bf ENTER NEW ORDER \rm (current order):' ] ...
        };
    name='Reorder b-table & DWI-data';
    numlines=[1, 70];
    defa1=1: length(btableNames);
    defa2=1: length(DTIfileName);
    defaultanswer={regexprep(num2str(defa1),'\s+',' ')  regexprep(num2str(defa2),'\s+',' ')};
    opt=struct('Resize','on','WindowStyle','normal','Interpreter','tex');
    
    answer  =inputdlg(prompt,name,numlines,defaultanswer,opt);
    if isempty(char(answer)) % cancel
        return
    end
    % ===============================================
    
    neworder1=str2num(num2str(answer{1}));
    if length(neworder1)~=length(btableNames) || length(intersect( defa1 ,neworder1))~=length(defa1)
        msgbox('b-table: number of indices for ordering does not match..aborted.','reodering');
        return
    end
    neworder2=str2num(num2str(answer{2}));
    if length(neworder2)~=length(DTIfileName) || length(intersect( defa2 ,neworder2))~=length(defa2)
        msgbox('DWI-data: number of indices for ordering does not match..aborted.','reodering');
        return
    end
    
    % reorder data
    d.btable      =d.btable(neworder1);
    d.DTIfileName =d.DTIfileName(neworder2);
    
    if 1 %save data
        save(f1,'d');
    end
    
    %% ===============================================
    updateLB();
    
    %% ===============================================
    cprintf('*[0 .5 .8]',['_____REORDINGING B-TABLES & DWI-FILES___ \n']);
    cprintf('*[0 .5 .8]',['[1] b-table: new order  \n']);
    disp(btableNames0(neworder1));
    cprintf('*[0 .5 .8]',['[2] DWI-data: new order  \n']);
    disp(DTIfileName0(neworder2));
    
    %% ===============================================
    
    
end

% ==============================================
%%
% ===============================================


if strcmp(task,'checkassignment')
    
    
    ms_error={'check assignment of b-table & DTI/DWI-file NOT POSSIBLE'
        'FIRST, define USER INPUT (b-table, DTI-files)'
        };
    %%
    err=0;
    try
        hf=findobj(0,'tag','DTIprep');
        u=get(hf,'userdata');
        f1=fullfile(u.studypath,'DTI','check.mat');
        d=load(f1); d=d.d;
    catch
        err=1 ;
    end
    if err==1;
        msgbox(ms_error,'warning');
        return
    end
    % --
    try
        [~,btable_name0,ext ]=fileparts2(d.btable);
        btables=cellfun(@(a,b){[ a b ]},  btable_name0, ext);
        dwis   =d.DTIfileName;
        
        n_btables=size(btables,1);
        n_dwis  =size(dwis,1);
        
        chktab=repmat({' '}, [  max([n_btables n_dwis]) 3]);
        chktab(1:n_btables,1) =btables;
        chktab(1:n_dwis,2)    =dwis;
        if n_btables==1
            chktab{1,3}='dwi.nii';
        else
            finaldwiname=regexprep(chktab(1:n_btables,1),{'grad_b' '.txt'},{'dwi_b' '.nii'});
            if length(finaldwiname)==4
                bnumber=str2num(char(regexprep(finaldwiname,'[a-zA-Z\s_.]','')));
                if length(bnumber)==4
                    outrequested={'dwi_b100.nii' 'dwi_b900.nii' 'dwi_b1600.nii' 'dwi_b2500.nii'}';
                    outrequested=sortrows([outrequested num2cell(bnumber)],2);
                    finaldwiname=outrequested(:,1);
                else
                    
                    
                end
            end
            
            chktab(1:size(finaldwiname,1),3) =finaldwiname;
        end
        %% ===============================================
        
        hd={' #ra ___b-table___' '#ka ___INPUT-DWI___'  '#ba ___OUTPUT-DWI___'};
        [~, ms]=plog([],[hd ;chktab ],0,'','s=10;plotlines=0;al=1');
        
        ms{end+1,1}=['  '];
        ms{end+1,1}=[' #dw ' repmat('_',[1 80])];
        ms{end+1,1}=[' #dw -Please check correspondence of b-tables and input-DWI-files!  '];
        ms{end+1,1}=[' #dw  to reorder files use contextmenu: reorder..  '];
        ms{end+1,1}=[' #dw -The table does not state that these files exist for each animal!  '];
        if n_btables==4
             ms{end+1,1}=['  '];
             ms{end+1,1}=[' #, IMPORTANT! '];
             ms{end+1,1}=[' #r MULTISHELL-approach is used! The names of the DWI-files in the current '];
             ms{end+1,1}=[' #r shellscripts are hard-coded. The names of the DWI-files'];
             ms{end+1,1}=[' #r has to be:  '];
             ms=[ms; finaldwiname];
             ms{end+1,1}=[' #, PLEASE CHECK THAT THIS IS TRUE FOR THE "___OUTPUT-DWI___" -files!  '];
        end
        drawnow;
        uhelp(ms,1,'name','assignment');
        %% ===============================================
        
        
        %         chktab=[{['\bf' '___b-table___'] ['       ___DWI-file___' '\rm']} ;chktab];
        %         chklist=cellfun(@(a,b){[ a repmat(' ',[1 size(char(chktab(:,1)),2)+2-length(a)]) b ]},  chktab(:,1),chktab(:,2));
        %         ms={
        %             '\bf\color{magenta}conflict "renaming files"! ... Process aborted!\rm\color{black}'
        %             ['number of b-tables does not match the number of DTI/DWI-files!'  ]
        %             [' No of b-tables :' num2str(n_btables)]
        %             [' No of DWI-files:' num2str(n_dwis)]
        %             '\bf #PLEASE CHECK ASSIGNMENT:\rm'
        %             };
        %         ms=[ms;chklist];
        %         ms=strrep(ms,'_','\_');
        %         errordlg(ms,'',struct('Interpreter','tex','WindowStyle','modal'))
    catch
        msgbox(ms_error,'warning');
    end
    
    % ==============================================
    %%
    % ===============================================
    
end


%%

% ==============================================
%%   select animal m-dirs
% ===============================================
function seldirs=get_mdir(padat)
hf=findobj(0,'tag','DTIprep');
if isempty(hf)
    seldirs=antcb('getallsubjects');
else
    mdirType=get(findobj(hf,'Tag','allmdirs'),'value');
    % u=get(hf,'userdata');
    if mdirType==1%all mdirs
        %padat=fullfile(u.studypath,'dat');
        [seldirs] = spm_select('FPList',padat,'dir','.*');
        if isempty(seldirs);
            seldirs=[];
        else
            seldirs=cellstr(seldirs);
        end
    else
        seldirs= antcb('getsubjects');
    end
end

%% ===============================================
function nogui_check(u)

global an
if isempty(an);
    disp('DTI struct not initialiized struct ');
end
f1=fullfile(fileparts(an.datpath),'DTI','check.mat');
if exist(f1)==2
   load(f1);
   
   disp( [' *** [DTIprep-info saved]: ' f1  ]);
   disp('---------[struct info]-------');
   disp(d);
   disp('---------[btable] -------------');
   if isempty(d.btable)
       disp(' ...not imported jet!');
   else
       disp(d.btable);
   end
   disp('---------[DTIfileName] --------');
   if isempty(d.DTIfileName)
       disp(' ...not initialized/defined jet!');
   else
       disp(d.DTIfileName);
   end
   disp('-------------------------------');
else
    disp(['file not found: ' f1]);
    disp('initialize the project first, use:  DTIprep(''ini''); ');
end
    

function nogui_change_order(fieldname,order)
if strcmp(fieldname,'d')
    fieldname='DTIfileName';
elseif strcmp(fieldname,'b')
    fieldname='btable';
end
global an;
d=getdata;

if strcmp(fieldname,'DTIfileName') || strcmp(fieldname,'btable')
   val= getfield(d,fieldname);
   if length(val)==length(order)
      d=setfield(d,fieldname,val(order) );
      setdata(d);
      disp(['***  "' fieldname '" was reordered: ']);
      %d=getdata;
      %disp(getfield(d,fieldname));
      DTIprep('check');
   else
      disp(['cannot resort: mismatch number of entries in  "' fieldname '"  and order-vector' ]) ;
   end
   
end

    

%% ===============================================
function makestruct(u)


%% =============[make check mat]==================================
global an
if isempty(an)
    error('load study first!');
end
studypath=fileparts(an.datpath);
dtipath  =fullfile(studypath,'DTI');
% dtipath=fullfile(u.studypath,'DTI');
warning off;
mkdir(dtipath);
f1=fullfile(dtipath,'check.mat');
if exist(f1)==0
    d.studypath   =studypath;
    d.dtipath     =dtipath;
    d.brukerdata  =[];
    d.btable   =[];
    
    d.DTIfileName =[];
    
    d.DTItemplate    =[];
    d.DTItemplateLUT =[];
    
    d.INFO_ini= '__INI____';
    d.is_Brukerdata_Defined      ='NO';
    d.is_DTItemplate_Defined     ='NO';
    d.is_DTItemplateLUT_Defined  ='NO';
    
    d.INFO_import= '__IMPORT_____';
    d.is_Btable_imported          ='NO';
    d.is_DTItemplate_imported     ='NO';
    
    d.INFO_task= '__TASK_____';
    d.is_Atlas_and_Btable_distributed   ='NO';
    d.isdeformed             ='NO';
    d.isregistered           ='NO';
    d.isrenamed              ='NO';
    
    save(f1,'d');
end
% =============[config file]==================================
fconfig=fullfile(dtipath,'DTIconfig.m');
if exist(fconfig)==0
    makeconfig(dtipath);
end
%% ======updata struct===========================
d=load(f1); d=d.d;

if exist('u')==1;
    if isfield(u,'brukerdata')==1 && exist(u.brukerdata)==7
        disp([' ..BrukerRawdata included to struct : ' u.brukerdata]);
        %d.INFO_misc '__MISC_____';
        d.brukerdata= u.brukerdata;
        d.is_Brukerdata_Defined='YES';
    end
    if isfield(u,'DTItemplate')==1 && exist(u.DTItemplate)==2
        disp([' ..DTItemplate included to struct   : ' u.DTItemplate]);
        d.DTItemplate= u.DTItemplate;
        d.is_DTItemplate_Defined='YES';
    end
    if isfield(u,'DTItemplateLUT')==1 && exist(u.DTItemplateLUT)==2
        disp([' ..DTItemplateLUT included to struct: ' u.DTItemplateLUT]);
        d.DTItemplateLUT= u.DTItemplateLUT;
        d.is_DTItemplateLUT_Defined='YES';
    end
    if isfield(u,'DTIfileName')==1
        disp([' ..DTIfileName included to struct   : ' strjoin(u.DTIfileName,'|') ]);
        d.DTIfileName= u.DTIfileName(:);
    end
    
    
    
    
    disp( [' *** [DTIprep-info saved]: ' f1  ]);
    disp('---------[struct info]-------');
    disp(d);
    disp('-----------------------------');
    save(f1,'d');
end
DTIprep('check');


function d=getdata()
global an
f1=fullfile(fileparts(an.datpath),'DTI','check.mat');
if exist(f1)==2
    d=load(f1);
    d=d.d;
else
    error('ant-project not loaded or "DTIprep not initialized"');
end
function setdata(d)
global an
f1=fullfile(fileparts(an.datpath),'DTI','check.mat');
if exist(f1)==2
    save(f1,'d');
else
    error('ant-project not loaded or "DTIprep not initialized"');
end

function nogui_run(task, mdirs)

atime=tic;

pp.isGUI=0;
if exist('mdirs')~=0
    pp.mdirs=mdirs;
end

if ischar(task)
    if strcmp(task,'all')
       task=1:6; 
    end
else
   task=sort(task);  
end

if isfield(pp,'mdirs')==1
    mdirs=(pp.mdirs);
else
    mdirs=antcb('getallsubjects');
end
disp(['.. processing task(s) across [' num2str(length(mdirs)) '] animals.' ]);

msg='';
if ~isempty(find(task==1))
    process([],[],'distributefiles',pp);
    msg=[msg '(1)distribute; '];
end
if ~isempty(find(task==2))
    process([],[],'deformfiles',pp);
     msg=[msg '(2)deform; '];
end
if ~isempty(find(task==3))
    process([],[],'registerimages',pp);
    msg=[msg '(3)register; '];
end
if ~isempty(find(task==4))
    process([],[],'renamefiles',pp);
    msg=[msg '(4)rename; '];
end
if ~isempty(find(task==5))
    process([],[],'exportfiles',pp);
    msg=[msg '(5)export; '];
end
if ~isempty(find(task==6))
    process([],[],'checkreg',pp);
    msg=[msg '(6)checkregistration; '];
end


disp(['ET: ' sprintf('%2.2fmin',toc(atime)/60) ...
    '; Ndirs=' num2str(length(mdirs)) ,'; TASK: ' msg ]);



% if get(findobj(hf,'Tag','ch_renamefiles'),'value')==1
%     process([],[],'renamefiles');
% end
% if get(findobj(hf,'Tag','ch_exportfiles'),'value')==1
%     process([],[],'exportfiles');
% end
% 
% if get(findobj(hf,'Tag','ch_checkreg'),'value')==1
%     process([],[],'checkreg');
% end


function nogui_importdata()
%% ============ import btables =================
d=getdata();
out=getBtable(d.brukerdata);

bfiles={};
for i=1:size(out,1)
  bfiles(i,1)=  {out{i,3}.fileout};
end
d.btable=bfiles;
d.is_Btable_imported='YES';
setdata(d);
%% ============ import dtitemplate =================
f2=d.DTItemplate;
[ ~,name ext ]=fileparts(f2);
f2c=fullfile(d.dtipath, [name ext]);
isok=0;
try
   copyfile(f2,f2c,'f') ;
    disp('...DTItemplate imported');
    isok=isok+1;
end

f2=d.DTItemplateLUT;
[ ~,name ext ]=fileparts(f2);
f2c=fullfile(d.dtipath, [name ext]);
try;
   copyfile(f2,f2c,'f') ;
    disp('...DTItemplateLUT imported');
    isok=isok+1;
end
if isok==2
    d.is_DTItemplate_imported='YES';
    setdata(d);
end
DTIprep('check');


%% ===============================================

function updateLB(varargin)

    
hf=findobj(0,'tag','DTIprep');
if isempty(hf)
   return 
end
u=get(hf,'userdata');
hb=findobj(hf,'Tag','lb_check');



%% =============[make check mat]==================================
dtipath=fullfile(u.studypath,'DTI');
warning off;
mkdir(dtipath);
f1=fullfile(dtipath,'check.mat');
if exist(f1)==0
    d.studypath=u.studypath;
    d.dtipath  =dtipath;
    d.DTIfileName =[];
    d.btable   =[];
    d.DTItemplate    =[];
    d.DTItemplateLUT =[];
    d.is_Atlas_distributed   ='NO';
    d.is_Btable_distributed  ='NO';
    d.isdeformed             ='NO';
    d.isregistered           ='NO';
    d.isrenamed              ='NO';
    
    save(f1,'d');
end
%% =============[config file]==================================
fconfig=fullfile(dtipath,'DTIconfig.m');
if exist(fconfig)==0
    makeconfig(dtipath);
end
%% ===============================================

% ==============================================
%%    update-post correction
% ===============================================
if 0
    
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    hb=findobj(hf,'Tag','lb_check');
    dtipath=fullfile(u.studypath,'DTI');
    warning off;
    mkdir(dtipath);
    f1=fullfile(dtipath,'check.mat');
    load(f1);
    
    
    
    save(f1,'d');
end
% ==============================================
%%
% ===============================================

dtipath=fullfile(u.studypath,'DTI');

f1=fullfile(dtipath,'check.mat');
load(f1);

padat=fullfile(u.studypath,'dat');
% [dirs] = spm_select('FPList',padat,'dir','.*');
% mdirs=cellstr(dirs);
mdirs=get_mdir(padat);
% ==============================================
%%
% ===============================================

% s={'DTI-check-LIST'}
% s(end+1,1)={['<html>studypath <font color=green>' d.studypath] }
% set(hb,'string',s)
set(hb,'fontname','courier new');
% ==============================================
%%
% ===============================================
fn=fieldnames(d);
col1 =sprintf('%02X',round([0.9922    0.9176    0.7961].*255));   %MISSING
col2 =sprintf('%02X',round([  0.7569    0.8667    0.7765].*255)); %OK

w2={'*** DTI prep***'};
for i=1:length(fn)
    field=fn{i};
    str0=getfield(d,fn{i});
    
    field2=[ repmat('&nbsp;' ,[ 1   size(char(fn),2)-length(field)    ] )   field];
    
    %% ==========BTABLE-DISTRIB====================================
    if strcmp(field,'is_Btable_distributed')
        chk=zeros(length(mdirs), size(d.btable,1));
        if 1% ~isempty(d.btable);
            for k=1:length(mdirs)
                thisdir=mdirs{k};
                for j=1:size(d.btable,1)
                    [~,btablename, ext]=fileparts(d.btable{j});
                    if exist(fullfile(thisdir,[ btablename ext] ))==2
                        chk(k,j)=1 ;
                    end
                end
            end
            if isempty(chk);
                chk=0;
            end
            if all(chk(:))==1
                col=col2; msg='YES';
                d.is_Btable_distributed ='YES'; save(f1,'d'); load(f1);
            else
                col=col1;  msg='NO';
                d.is_Btable_distributed ='NO'; save(f1,'d'); load(f1);
            end
            w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
                ['<b>[' field2 ']:</b>'   msg ] ...
                '</TD></TR> </table>'...
                ] ;
            w2=[w2; w];
            continue
        end
    end
    if strcmp(field,'btable')
        if isempty(char(d.btable))
            set(findobj(hf,'tag','getbtable'),'backgroundcolor',[ 0.9373    0.8667    0.8667]);
        else
            set(findobj(hf,'tag','getbtable'),'backgroundcolor',[ 0.7490    0.7490         0]);
        end
    end
    if strcmp(field,'DTIfileName')
        if isempty(char(d.DTIfileName))
            set(findobj(hf,'tag','getDTIfile'),'backgroundcolor',[ 0.9373    0.8667    0.8667]);
        else
            set(findobj(hf,'tag','getDTIfile'),'backgroundcolor',[ 0.7490    0.7490         0]);
        end
    end
    if strcmp(field,'DTItemplate')
        if isempty(char(d.DTItemplate)) || isempty(char(d.DTItemplateLUT))
            set(findobj(hf,'tag','getDTItemplate'),'backgroundcolor',[ 0.9373    0.8667    0.8667]);
        else
            set(findobj(hf,'tag','getDTItemplate'),'backgroundcolor',[ 0.7490    0.7490         0]);
        end
    end
    
    %% ==========is_Atlas_distributed====================================
    if strcmp(field,'is_Atlas_distributed')
        chk=zeros(length(mdirs), 2); % chk two files
        if ~isempty(d.DTItemplate);
            for k=1:length(mdirs)
                thisdir=mdirs{k};
                
                [~,dumname, ext]=fileparts(d.DTItemplate); %ATLAS
                if exist(fullfile(thisdir,[ dumname ext] ))==2
                    chk(k,1)=1 ;
                end
                [~,dumname, ext]=fileparts(d.DTItemplateLUT);%LUT
                if exist(fullfile(thisdir,[ dumname ext] ))==2
                    chk(k,2)=1 ;
                end
                
            end
            if all(chk(:))==1
                col=col2; msg='YES';
                d.is_Atlas_distributed ='YES'; save(f1,'d'); load(f1);
            else
                col=col1;  msg='NO';
                d.is_Atlas_distributed ='NO'; save(f1,'d'); load(f1);
            end
            w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
                ['<b>[' field2 ']:</b>'   msg ] ...
                '</TD></TR> </table>'...
                ] ;
            w2=[w2; w];
            continue
        end
    end
    %% ==========isdeformed====================================
    if strcmp(field,'isdeformed')
        chk=zeros(length(mdirs), 3); % chk two files
        if ~isempty(d.DTItemplate);
            for k=1:length(mdirs)
                thisdir=mdirs{k};
                
                [~,dumname, ext]=fileparts(d.DTItemplate); %ATLAS
                finame=['ix_' dumname ext];
                if exist(  fullfile(thisdir,finame )  )==2
                    chk(k,1)=1 ;
                end
                
                finame=['ix_AVGTmask.nii' ];
                if exist(  fullfile(thisdir,finame )  )==2
                    chk(k,2)=1 ;
                end
                
                finame=['ix_AVGThemi.nii' ];
                if exist(  fullfile(thisdir,finame )  )==2
                    chk(k,3)=1 ;
                end
                
            end
            if all(chk(:))==1
                col=col2; msg='YES';
                d.isdeformed ='YES'; save(f1,'d'); load(f1);
            else
                col=col1;  msg='NO';
                d.isdeformed ='NO'; save(f1,'d'); load(f1);
            end
            w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
                ['<b>[' field2 ']:</b>'   msg ] ...
                '</TD></TR> </table>'...
                ] ;
            w2=[w2; w];
            continue
        end
    end
    
    %% ==========isregistered====================================
    if  strcmp(field,'isregistered')
        if ~isempty(d.DTItemplate);
            [~,DTIatlas0]=fileparts(d.DTItemplate);
            
            files={...
                'rc_ix_ANO.nii'
                'rc_ix_AVGTmask.nii'
                ['rc_ix_' DTIatlas0 '.nii'];%'rc_ix_DTI_harms31mar20.nii'
                'rc_mt2.nii'
                'rc_t2.nii'};
            chk=zeros(length(mdirs), length(files)); % chk two files
            for k=1:length(mdirs)
                thisdir=mdirs{k};
                for jj=1:length(files)
                    finame=[files{jj} ];
                    if exist(  fullfile(thisdir,finame )  )==2
                        chk(k,jj)=1 ;
                    end
                end
            end
            if all(chk(:))==1
                col=col2; msg='YES';
                d.isregistered ='YES'; save(f1,'d'); load(f1);
            else
                col=col1;  msg='NO';
                d.isregistered ='NO'; save(f1,'d'); load(f1);
            end
            w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
                ['<b>[' field2 ']:</b>'   msg ] ...
                '</TD></TR> </table>'...
                ] ;
            w2=[w2; w];
            continue
        end
    end
    
    %% ==========isrenamed====================================
    if  strcmp(field,'isrenamed')
        files={'atlas_lut.txt'  };
        chk=zeros(length(mdirs), length(files)); % chk two files
        for k=1:length(mdirs)
            thisdir=mdirs{k};
            for jj=1:length(files)
                finame=[files{jj} ];
                if exist(  fullfile(thisdir,finame )  )==2
                    chk(k,jj)=1 ;
                end
            end
        end
        if all(chk(:))==1
            col=col2; msg='YES';
            d.isregistered ='YES'; save(f1,'d'); load(f1);
        else
            col=col1;  msg='NO';
            d.isregistered ='NO'; save(f1,'d'); load(f1);
        end
        w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
            ['<b>[' field2 ']:</b>'   msg ] ...
            '</TD></TR> </table>'...
            ] ;
        w2=[w2; w];
        continue
    end
    
    %% ===================================================================================================
    
    for j=1:size(str0,1)
        if iscell(str0)
            str=str0{j};
        else
            str=str0;
        end
        if isempty(str) || strcmp(str,'NO')
            col=col1;
            if strcmp(str,'NO')
                msg='';
            else
                msg=['--undefined--'];
            end
        else
            col=col2;
            msg='';
        end
        
        w=['<html><table border=0 width=1400 bgcolor=' col '><TR><TD>'   ...
            ['<b>[' field2 ']:</b>'  str msg ] ...
            '</TD></TR> </table>'...
            ];
        %  w=['<html><p style bgcolor= ' col   ...
        %         ['<b>[' field ']:</b>'  str msg ] ...
        %         ...
        %         ]
        %disp(['w---']);
        %disp(w);
        w2=[w2; w];
    end
end

% w2={''; w}
set(hb,'string',w2,'value',1)



function xhelp(e,e2)

uhelp([mfilename '.m']);

function scripts_pb(e,e2)
scripts();
function scripts(argin)

isGUI=1; %GUI mode
if exist('argin') && length(argin)>1
    if iscell(argin) && strcmp(argin{2},'cmd')
        isGUI=0;
    end
end

scripts={
 'DTIscript_exportToHPC_makeBatch.m'
 'DTIscript_exportToHPC_makeBatch_old'
 'DTIscript_makeQA_HTML_from_screenshots.m'
 'DTIscript_importFromHPC_allData.m'
 'DTIscript_importFromHPC_connectome.m'
 'DTIscript_importFromHPC_DWImaps.m'
 'DTIscript_runDTIprep_COMANDLINE.m'
};

if isGUI==0
    cprintf('*[1 0 1]','*** AVAILABLE SCRIPTS for [DTIprep] ***\n');
    disp(char(scripts));
    disp('____________________________________________________________');
    disp('...please make a copy of the script and modify accordingly ')
    disp('____________________________________________________________');
    return
    
end

% xpos=.15;
% scripts_gui(gcf, 'pos',[xpos 0 1-xpos 1],'closefig',0,'scripts',scripts);


scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name','scripts: DTIprep','closefig',1,'scripts',scripts);
% scripts_gui(gcf, 'pos',[0 0 1 1],'name','scripts: voxelwise statistic','closefig',1,'scripts',scripts)


% ==============================================
%%   older
% ===============================================
return
% 
% scripts_process([],[],'close');
% 
% h=uipanel('units','norm');
% set(h,'position',[0.5 0  .5 1 ],'title','scripts','tag','scripts_panel');
% set(h,'ForegroundColor','b','fontweight','bold');
% 
% 
% % %% ====[lb script-name]===========================================
% % scripts={
% %   
% %     'DTIscript_HPC_exportData_makeBatch.m'
% %     'DTIscript_posthoc_makeHTML_QA.m'
% %     % 'DTIscript_posthoc_exportData4Statistic.m'
% %     'DTIscript_posthoc_exportDTImatrices_fromHPC_4Statistic.m.m'
% %     'DTIscript_posthoc_exportDTImaps_fromHPC_4Statistic.m'
% %     };






hb=uicontrol(h,'style','listbox','units','norm','tag','scripts_lbscriptName');
set(hb,'string',scripts);
set(hb,'position',[[0 0.7 0.9 0.3]]);
set(hb,'callback',{@scripts_process, 'scriptname'} );
set(hb,'tooltipstring',['script/function name']);


c = uicontextmenu;
hb.UIContextMenu = c;
m1 = uimenu(c,'Label','show script','Callback',{@scripts_process, 'open'});
m1 = uimenu(c,'Label','<html><font style="color: rgb(255,0,0)">edit file (not prefered)','Callback',{@scripts_process, 'editOrigFile'});

%% ====[help via addNote]===========================================
% hb=uicontrol(h,'style','text','units','norm','tag','scripts_TXTscriptHelp');
% set(hb,'string',{'eeee'},'backgroundcolor','w');
% set(hb,'position',[[0 0.1 1.01 0.45]]);
% % set(hb,'callback',{@scripts_process, 'close'} );
% set(hb,'tooltipstring',['script/function help']);
NotePos=[0.5 .085  .5 .58];
msg='select <b>script/function</b> from <u>above</u> to obtain <font color="blue">help.<br>';
addNote(gcf,'text',msg,'pos',NotePos,'head','scripts/functions','mode','single','fs',30);
%% =======[open script]========================================
hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_open');
set(hb,'string','show script');
set(hb,'position',[-1.21e-16 0.0056 0.25 0.08]);
set(hb,'callback',{@scripts_process, 'open'} );
set(hb,'tooltipstring',['<html><b>open scripts/function in HELP window</b><br> '...
    'the script can be copied and modified']);
%% =======[edit script]========================================
hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_edit');
set(hb,'string','edit script');
set(hb,'position',[[0.3 0.0 0.25 0.08]]);
set(hb,'callback',{@scripts_process, 'edit'} );
set(hb,'tooltipstring',['<html><b>open scripts/function in EDITOR</b><br> '...
    'the script can be copied and modified']);

%% =========[close script panel]======================================
%%
hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_close');
set(hb,'string','close panel');
set(hb,'position',[[0.73 0.0 0.25 0.08]]);
% set(hb,'position',[[0.94 0.93 0.06 0.07]]);
set(hb,'callback',{@scripts_process, 'close'} );
set(hb,'tooltipstring',['close']);
%% ===============================================



function scripts_process(e,e2,task)
hn=findobj(gcf,'tag','scripts_lbscriptName');

if strcmp(task,'close')
    delete(findobj(gcf,'tag','scripts_panel'));
    addNote(gcf,'note','close') ;
elseif strcmp(task,'scriptname')
    
    file=hn.String{hn.Value};
    hlp=help(file);
    hlp=strsplit(hlp,char(10));
    hlp=[hlp repmat('<br>',[1 2])];
    NotePos=[0.5 .085  .5 .58];
    addNote(gcf,'text',hlp,'pos',NotePos,'mode','single','fs',20);
elseif strcmp(task,'open')
    file=hn.String{hn.Value};
    
    cont=preadfile(file);
    cont=cont.all;
    uhelp(cont,1,'name',['script: "' file '"']);
    
    msg={'-copy script to Matlab editor'
        '-change parameter accordingly'
        '-save script somewhere on your path'
        '-run script'};
    addNote(gcf,'text',msg,'pos',[0.5 .1  .44 .3],'head','Note','mode','single');
elseif strcmp(task,'editOrigFile')
    pw=logindlg('Password','only');
    pw=num2str(pw);
    if strcmp(pw,'1')
        file=hn.String{hn.Value};
        edit(file);
    end
elseif strcmp(task,'edit')
    file=hn.String{hn.Value};
    
    %% ===============================================
    cont=preadfile(file);
    cont=cont.all;
    
    str = strjoin(cont,char(10));
    editorService = com.mathworks.mlservices.MLEditorServices;
    editorApplication = editorService.getEditorApplication();
    editorApplication.newEditor(str);
    %% ===============================================
    
end



function makeconfig(dtipath)

% --anker_config_start
%% ===============================================
% ==============================================
%%   DTI-preprocessing config (DTIconfig.m)
% ##path##
% ##date##
% ===============================================
% ==============================================
%%  task: coregistration
% ===============================================

s=struct();
s.info_COREG     = '--------COREGISTRATION-----';
s.coreg_approach = 1                          ;%coregistration approach either [1]SPM [2]ELASTIX (afine both)

% ___ parameter for approach-1 ___
s.cost_fun       = 'nmi'                      ;% SPM-costfunction,objective function: ['nmi'] norm. mutual Info, ['mi'] mutual Info,
%['ecc'] entropy corrcoef,['ncc'] norm. crosscorr; Default:  'nmi'
s.sep           = [4  2  1  0.5  0.1  0.05]   ;%SPM-optimisation sampling steps (mm), default:  [4  2  1  0.5  0.1  0.05];
s.tol           = [0.01  0.01  0.01  0.001  0.001  0.001];% SPM-tolerences for accuracy of each param: default [0.01  0.01  0.01  0.001  0.001  0.001];
s.fwhm          = [7  7]                      ;% SPM-smoothing to apply to 256x256 joint histogram:  default: [7  7];
s.interpOrder   = 0                           ;% interpolation of data ('auto';[0];); default: 0

%___ parameter for approach-2 ___
s.warpParamfile={fullfile(fileparts(antpath),'elastix','paramfiles','Par0025affine.txt')};
%fullfile(fileparts(antpath),'elastix','paramfiles','p33_bspline.txt')

% ___ parameter for approach-1 & approach-2 ___
s.cleanup       = [1];                   % clean up (remove interim data)
s.isparallel    = [0];                   % run coregistration in parallel

% ==============================================
%%  task: check registration (HTMLfiles)
% ===============================================
s.cr.info_checkreg = '--------HTML-files/CHECK-REGISTRATION-----';
s.cr.bgImageIndex  = 1;                                 %index of the image in "DTIfilename"-list to use as backgroundimage
s.cr.ovImg         = {'rc_t2.nii' 'rc_ix_AVGTmask.nii' 'ANO_DTI.nii' }; % images to use as overlay-images
s.cr.outputdir     = 'checks'          ;% output-dir (shortname, i.e. not fullpath!) to store the HTML-files
s.cr.outputstring  = 'DTIreg'          ;% optional output string added to html  and image-directory
s.cr.slices        = 'n20'             ;% " (1) n"+number: number of slices to plot or (2) a single number, which plots every nth. image
s.cr.dim           = [1]               ;% dimension to plot {1,2,3}: in standardspace: {1}transversal,{2}coronal,{3}sagital
s.cr.size          = [400]             ;% image size width&high in HTML file
s.cr.grid          = [1]               ;% show line grid on top ov image {0,1}
s.cr.gridspace     = [10]              ;% space between grid lines (pixels)
s.cr.gridcolor     = [0  .5  0]        ;% gridcolor (RGB)


%% ===============================================
% --anker_config_end

% ==============================================
%%   read file
% ===============================================

a=preadfile([mfilename,'.m']);
a=a.all;
ianker=[min(regexpi2(a,'% --anker_config_start')) ;min(regexpi2(a,'% --anker_config_end'))];

b=a(ianker(1)+2:ianker(2)-1);
b=strrep(b,'##path##',['path: ' dtipath]);
b=strrep(b,'##date##',['date: ' datestr(now)]);

c=[{'function s=DTIconfig()' }; b];

fconfig=fullfile(dtipath,'DTIconfig.m');
pwrite2file(fconfig,c);












