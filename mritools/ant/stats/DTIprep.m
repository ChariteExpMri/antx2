% #k prepare data for DTI-processing via Mrtrix. #n Ideally DTI-processing could start
% after conventional registration of "t2.nii" to the normal space und running 
% this DTIprep-step (a propriate DTI-atlas must be provided).
% shellscripts must be downloaded from https://github.com/ChariteExpMri/rodentDtiConnectomics
% and saved in the "shellscripts" folder (same level as the dat-folder)
%--> detailed info is provided soon..
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
hb=uicontrol('style','pushbutton','units','norm','string','pb_studypath','tag','studypath');
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
hb=uicontrol('style','pushbutton','units','norm','string','get b-table','tag','getbtable');
set(hb,'position',[0.0053571 0.8516 0.15 0.1]);
set(hb,'backgroundcolor',[ 0.9373    0.8667    0.8667]);
set(hb,'tooltipstring',[...
    '<html><b>get b-table from one of the Bruker raw-data sets</b><br>' ...
    'select one (!) raw data set to obtain the b-table']);


%% getDTIfile
set(hb,'callback',{@process, 'getbtable'} );
hb=uicontrol('style','pushbutton','units','norm','string','get DTIfile','tag','getDTIfile');
set(hb,'position',[0.0053571 0.75571 0.15 0.1]);
set(hb,'callback',{@process, 'getDTIfile'} );
set(hb,'backgroundcolor',[ 0.9373    0.8667    0.8667]);
set(hb,'tooltipstring',[...
    '<html><b>get DTIfile</b><br>' ...
    'select the 4D DTIfile from <b>one</b> of the animals (within the dat-folder) ']);

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
    [pas,sts] = spm_select(1,'dir','select the firectory of the STUDY','',pwd)
    if sts==0; return; end
    u.studypath=pas;
    set(hf,'userdata',u);
    
    set(findobj(hf,'Type','uicontrol'),'enable','on');
    updateLB();
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
    
    if size(d.btable,1)==1
       files(end+1,:)={d.DTIfileName{1}      'dwi.nii'  }; 
    else
        keyboard
    end
    
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
    
    %------files
    d=load(f1); d=d.d;
    [~,dum]=fileparts2(d.btable);
    btablefiles=stradd(dum,[  '.txt' ] ,2);
    files={...
        'rc_ix_AVGTmask.nii'
        'rc_mt2.nii'
        'rc_t2.nii'
        'c_t2.nii'
        'dwi.nii'
        ...
        'atlas_lut.txt'
        'ANO_DTI.txt'  %'atlas_lut.txt'
        'ANO_DTI.nii'
        };
    files=[files; btablefiles];
    %------for each animal
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
                ms2=[' export failed for [' mname ']' ', file: [' files{j} '] ' ms  ]
                cprintf([1 0 1], [strrep(ms2,filesep,[filesep filesep]) '\n']);
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
        'cd ../dat        ; # go to dat-folder'
        './../shellscripts/mouse_dti_complete_7texpmri.sh   #start processing'
        ''
        
        };
   tb=[{' #ko COMANDS FOR MRTRIX ***'} ; ms];
   uhelp(tb,0,'name','mrtrix-processing');
   %% 
    
return
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
    
    for j=size(str0,1)
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
        
        w2=[w2; w];
    end
end

% w2={''; w}
set(hb,'string',w2,'value',1)

























