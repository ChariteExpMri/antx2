% #k prepare data for DTI-processing via Mrtrix. #n Ideally DTI-processing could start
% after (a) conventional registration of "t2.nii" to normal space, and (b) running 
% this DTIprep-step. For this a propriate DTI-atlas must be provided (see below).
% shellscripts must be downloaded from https://github.com/ChariteExpMri/rodentDtiConnectomics
% and saved in the "shellscripts" folder (same level as the dat-folder)
% 
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
%   4. rename files     -> rename files (names are fixed and expected from shellscripts)
%   5  export files     -> export files to #r DTI_export4mrtrix (OPTIONAL STEP!)
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
%  'c_t2.nii'            % % t2.nii registered to DWI-file space
%  'rc_ix_AVGTmask.nii'  % % brain mask, back-transformed to native space and transformed+resliced to DWI-space
%  'rc_mt2.nii'          % % bias-corected t2.nii,transformed+resliced to DWI-space
%  'rc_t2.nii'           % % t2.nii,transformed+resliced to DWI-space
%  'dwi.nii'             % % original DWI-file, copied & renamed
%  'grad.txt'            % % b-table
% 
% 
% #kc ___MULTI-SHELL___
%  'ANO_DTI.nii'         % % DTI-atlas, back-transformed to native space and transformed to DWI-space,renamed
%  'ANO_DTI.txt'         % % DTI-labels lookup table,renamed
%  'atlas_lut.txt'       % % DTI-labels lookup table (copy of 'ANO_DTI.txt'),renamed
%  'c_t2.nii'            % % t2.nii registered to DWI-file space
%  'rc_ix_AVGTmask.nii'  % % brain mask, back-transformed to native space and transformed+resliced to DWI-space
%  'rc_mt2.nii'          % % bias-corected t2.nii,transformed+resliced to DWI-space
%  'rc_t2.nii'           % % t2.nii,transformed+resliced to DWI-space
%  'dwi_b100.nii'        % % original DWI-file, copied & renamed
%  'dwi_b1600.nii'       % %  ||
%  'dwi_b3400.nii'       % %  ||
%  'dwi_b6000.nii'       % %  ||
%  'grad_b100.txt'       % % b-table
%  'grad_b1600.txt'      % %  ||
%  'grad_b3400.txt'      % %  ||
%  'grad_b6000.txt'      % %  ||
% 
% 

function DTIprep();

% ==============================================
%%
% ===============================================
delete(findobj(0,'tag','DTIprep'));
fg;
set(gcf,'units','norm','menubar','none','tag','DTIprep','name','DTIprep','numbertitle','off');
set(gcf,'position',[0.3146    0.3922    0.3889    0.2433]);

% ==============================================
%
% ===============================================
% check
% hb=uicontrol('style','pushbutton','units','norm','string','check','tag','check');
% set(hb,'position',[0.43923 0.90204 0.06 0.1]);
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
hb = uipanel('Title','user input','FontSize',8,'tag','uip1',...
             'BackgroundColor','white');
set(hb,'position',[[0.001 .64 .16 .38]]);

%% getbtable
hb=uicontrol('style','pushbutton','units','norm','string','get b-table(s)','tag','getbtable');
set(hb,'position',[0.0053571 0.8516 0.15 0.1]);
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
set(hb,'position',[0.0053571 0.75571 0.15 0.1]);
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
set(hb,'position',[0.0053571 0.65982 0.15 0.1]);
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
hb=uicontrol('style','pushbutton','units','norm','string','check status','tag','getchecklist');
set(hb,'position',[0.34816 0.66457 0.15 0.1]);
set(hb,'callback',{@process, 'getchecklist'},'backgroundcolor',[0.8392    0.9098    0.8510]);

set(hb,'tooltipstring',[...
    '<html><b>manually update checklist/listbox</b><br>' ]);
% ==============================================
%%   procs
% ===============================================
%% frame-2
hframe2 = uipanel('Title','preproc steps','FontSize',8,'tag','uip2',...
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
%% select all
hb=uicontrol('style','radio','units','norm','string','select all','tag',   'selectallsteps');
set(hb,'position',[0.22317 0.13481 0.1 0.1],'fontsize',7,'backgroundcolor','w');
set(hb,'callback',@selectallsteps );
set(hb,'tooltipstring',['-select all processing steps']);
set(hb,'value',1);
%% ===============================================
%% mdir_type
hb=uicontrol('style','radio','units','norm','string','all animals','tag',   'allmdirs');
set(hb,'position',[[0.22495 0.52299 0.11 0.085]],'fontsize',7,'backgroundcolor','w');
set(hb,'callback',@mdir_type );
set(hb,'tooltipstring',['<html><b>animal selection </b><br>' ...
    ['[x] DTIprep is done for all animals ' '<br>']...
    ['[ ] DTIprep is done for selected animals via ANT-gui animal-listbox()' ]...
    ]);
set(hb,'value',1);
%% ===============================================
%% ===============================================


%% run all steps
hb=uicontrol('style','pushbutton','units','norm','string','run all steps','tag','runallpreprocsteps');
set(hb,'position',[0.21959 0.025209 0.11 0.1],'fontsize',8);
set(hb,'callback',{@process, 'runallpreprocsteps'} );
set(hb,'backgroundcolor',[   0.8039    0.8784    0.9686]);
set(hb,'tooltipstring',[ '<html><b>run all steps gray processing steps from above</b><br>']);


% ==============================================
%%   
% ===============================================
%% help
hb=uicontrol('style','pushbutton','units','norm','string','help','tag','xhelp');
set(hb,'position',[0.22317 0.91118 0.05 0.08],'fontsize',8);
set(hb,'callback',{@xhelp} );
set(hb,'backgroundcolor',[   1 1 1]);
set(hb,'tooltipstring',[ 'get some help']);

% ==============================================
%%   contextmenu.
% ===============================================

% lis={'delete files (posthoc/clean up)'}

hf=findobj(0,'tag','DTIprep');
% u=get(hf,'userdata');
c = uicontextmenu;
% m= uimenu(c,'Label','delete current selection from history','Callback',@removefromhistory);
% m= uimenu(c,'Label','delete history of THIS STUDY (all entries of this study is deleted)','Callback',{@context,'deleteStudy'});
% m= uimenu(c,'Label','keep newest 3 entries  of THIS STUDY in history (remove the older entries)','Callback',{@context,'keepNewest3'});

m= uimenu(c,'Label','open study directory','Callback',{@context,'openStudyDir'},'separator','on');
m= uimenu(c,'Label','open DTI-directory',  'Callback',{@context,'openDTIDir'},'separator','off');
m= uimenu(c,'Label','which animal dirs are selected?','Callback',{@context,'checkSelectedDirs'},'separator','on');
% m= uimenu(c,'Label',' show configfile','Callback',{@context,'showConfigfile'});
m= uimenu(c,'Label','<html><font color =red> delete files','Callback',{@context,'deletefiles'},'separator','on');


m= uimenu(c,'Label','<html><font color =green>check assignment of b-table & DTI/DWI-file',  'Callback',{@context,'checkassignment'},'separator','on');
m= uimenu(c,'Label','<html><font color =green>sow voxel size of 1st DTI/DWI-file ',  'Callback',{@context,'getvoxSize'},'separator','on');


m= uimenu(c,'Label','<html><font color =green>show comands for mrtrix',  'Callback',{@context,'comands_for_mrtrix'},'separator','on');

 

set(hf     ,'UIContextMenu',c);
set(hframe2,'UIContextMenu',c);

% ==============================================
%%   
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
%%
% ===============================================

u.dummi=1;


% ==============================================
%%
% ===============================================

set(gcf,'userdata',u);

if ~isempty(u.studypath)
    updateLB();
end



% ==============================================
%%
% ===============================================

function process(e,e2,task)
% disp(['TASK: ' task]);
cprintf([0 .5 1], ['TASK: ' task '... \n']);

hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
dtipath=fullfile(u.studypath,'DTI');
f1=fullfile(dtipath,'check.mat');

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
    
    load(f1)
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
    if sts==0; return, end
    
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
        [t, sts]=  cfg_getfile2(1,'image',mesg,[],pax,'.*.nii');
    else
        % ==============================================
        %%
        % ===============================================
        
        mesg={'MULTI-SHELL: select multishell DTI-files from one (!) of the animals'
            '(1)NUMBER OF FILES: the number of the files must correpond to the number of b-tables'
            '(2)FILE ORDER:  ASCENDING ..from lowest to largest   (b100, b1600,b3400, b6000)'
            ' '};
        [t, sts]=  cfg_getfile2(inf,'image',mesg,[],pax,'.*.nii');
        % ==============================================
        %%
        % ===============================================
        
    end
    
    %    [t,sts] = spm_select(n,typ,mesg,sel,wd,filt,frames)
    %[t,sts]    = spm_select(1,'image',mesg,[],pax,'.*.nii');
    %[t, sts]=  cfg_getfile2(inf,'image',mesg,[],pax,'.*.nii');
    if sts==0; return, end
    %[~, name, ext]=fileparts(t);
    [~, name, ~ ]=fileparts2(t);
    
    
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
    padat=fullfile(u.studypath,'dat');
    %[dirs] = spm_select('FPList',padat,'dir','.*');
    %mdirs=cellstr(dirs);
    mdirs=get_mdir(padat);
    %mdirs
    %return
    
    if isempty(mdirs); return; end
    mdirs=cellstr(mdirs);
    load(f1);
    for i=1:length(mdirs)
        thispa=mdirs{i};
        
        for j=1:size(d.btable,1)
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
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
end
% ==============================================
%%   deformfiles
% ===============================================
if strcmp(task,'deformfiles')
    padat=fullfile(u.studypath,'dat');  
    %[dirs] = spm_select('FPList',padat,'dir','.*');
    %mdirs=cellstr(dirs);
    mdirs=get_mdir(padat);
    %mdirs
    %return
    
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
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
end

% ==============================================
%%   register images
% ===============================================
if strcmp(task,'registerimages')
    padat=fullfile(u.studypath,'dat');
    %[dirs] = spm_select('FPList',padat,'dir','.*');
    %mdirs=cellstr(dirs);
    mdirs=get_mdir(padat);
    %mdirs
    %return
    
    d=load(f1); d=d.d;
    
    
    % ==============================================
    %%
    % ===============================================
    
    
    % ==============================================
    %%
    % ===============================================
    hf=findobj(0,'tag','DTIprep');
    u=get(hf,'userdata');
    padat=fullfile(u.studypath,'dat');
    
 
    
    
    % ======================================================
    % BATCH:        [xcoreg.m]
    % #b descr:  #b coregister images using affine transformation,
    % ======================================================
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
    
    % ==============================================
    %%
    % ===============================================
    
    
    %____________________
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
    
    
end    
    
% ==============================================
%%   renamefiles
% ===============================================
if strcmp(task,'renamefiles')
    padat=fullfile(u.studypath,'dat');
    %[dirs] = spm_select('FPList',padat,'dir','.*');
    %     mdirs=cellstr(dirs);
     mdirs=get_mdir(padat);
    %mdirs
    %return
    
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
        'c_t2.nii'                           ''
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
        n_btables=size(btable_name,1);
        n_dwis  =size(d.DTIfileName,1);
        
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
               copyfile(fx1,fx2,'f');
               showinfo2([ num2str(k) '-' num2str(nf) ' RENAMED' ] ,fx2,[],[], [ '>> ' fx2 ]);
               nf=nf+1;
            end
        end
        
    end
    
    
        
        
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
    % - c_t2.nii 
    % - atlas_lut.txt  
    
    
    %____________________
    updateLB();
    cprintf([0 0 1], ['   DONE!\n']);
    
    
    
end

% ==============================================
%%   
% ===============================================
if strcmp(task,'exportfiles')
    paexp=fullfile(fileparts(dtipath), 'DTI_export4mrtrix');
    mkdir(paexp);
    paexpdat=fullfile(paexp, 'dat');
    mkdir(paexpdat);
    
    
    padat=fullfile(u.studypath,'dat');
%     [dirs] = spm_select('FPList',padat,'dir','.*');
%     mdirs=cellstr(dirs);
     mdirs=get_mdir(padat);
    %mdirs
    %return
    
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
        'c_t2.nii'
        ...
        'atlas_lut.txt'
        'ANO_DTI.txt'  %'atlas_lut.txt'
        'ANO_DTI.nii'
        };
    files=[files; btablefiles; DWIfiles];
    
    
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
 cprintf([0 0 1], ['   DONE!\n']);   
 %%
   
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




function selectallsteps(e,e2)
hf=findobj(0,'tag','DTIprep');
val=get(findobj(hf,'Tag','selectallsteps'),'value');
tags={'ch_distributefiles' 'ch_deformfiles' 'ch_registerimages' ...
    'ch_renamefiles' 'ch_exportfiles' };
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
'c_t2.nii'            ms3                                              
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


%%


% ==============================================
%%   context
% ===============================================
function context(e,e2,task)
hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
padat=fullfile(u.studypath,'dat');

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
             chktab(1:size(finaldwiname,1),3) =finaldwiname;
        end
        
        hd={' #ra ___b-table___' '#ka ___INPUT-DWI___'  '#ba ___OUTPUT-DWI___'};
        [~, ms]=plog([],[hd ;chktab ],0,'','s=10;plotlines=0;al=1');
        
        ms{end+1,1}=['  '];
        ms{end+1,1}=[' #dw ' repmat('_',[1 80])];
        ms{end+1,1}=[' #dw -The table does not state that these files exist!  '];
        uhelp(ms,0,'name','assignment');
        
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
% ==============================================
%%
% ===============================================

function updateLB()
hf=findobj(0,'tag','DTIprep');
u=get(hf,'userdata');
hb=findobj(hf,'Tag','lb_check');


%% ===============================================
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





















