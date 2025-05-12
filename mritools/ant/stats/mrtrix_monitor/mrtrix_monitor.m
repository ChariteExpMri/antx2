% monitor MRtrix-processes
% version: 16.05.2024

function monitor

warning off
%% =====[study-path on 'x' ]==========================================
v=update_monitor;

%% =====[make fig]==========================================
delete(findobj(0,'tag','monitor'));

fg;
hf=gcf;

tabgp = uitabgroup(hf,'units','norm','Position',[0 .0 1 1],'tag','tabgroup');%,...
%     'backgroundcolor','w');
ht1 = uitab(tabgp,'Title','Monitor','backgroundcolor','w','tag','tb_monitor');
ht2 = uitab(tabgp,'Title','Tasks','backgroundcolor','w','tag','tb_tasks');
ht3 = uitab(tabgp,'Title','MRtrix_status','backgroundcolor','w','tag','tb_mrtrixstatus');
ht4 = uitab(tabgp,'Title','slurm_batch','backgroundcolor','w','tag','tb_slurmbatch');


set(gcf,'units','normalized','tag','monitor','menubar','none','numbertitle',...
    'off','name',['monitor [' mfilename '.m]']);
set(hf,'position',[ 0.3049    0.08    0.5337    0.8644]);

xs=0.28;
ys=0.1;
hx=axes(ht1,'position',[xs ys 1-xs-0.001 1-ys-0.001]  ,'tag','ax1');
%% ===============================================

axes(findobj(gcf,'tag','ax1'));
imagesc(v.z);
set(gca,'tag','ax1');
fs=6;
% files_unscore=strrep(v.files,'_','\_');
% set(gca,'ytick',[1:size(v.z,1)],'yticklabels',files_unscore,'fontsize',fs);
%
% set(gca,'xtick',[1:size(v.z,2)],'xticklabels',v.dirnum,'fontsize',fs);
% set(gca,'xTickLabelRotation',45);
%
% hv=vline( [1:size(v.z,2)-1]+.5 ,'color','r','hittest','off');
% hh=hline( [1:size(v.z,1)-1]+.5 ,'color','r','hittest','off');

% ==============================================
%%
% ===============================================
%% ======[version]=========================================
hb=uicontrol(ht1,'style','text','units','normalized');
set(hb,'position',[0.0011138 0.97 0.12 0.026]);
hlp=help([mfilename '.m']);
hlp=strsplit(hlp,char(10))';
vs=hlp{min(regexpi2(hlp,'version:'))};
vs=regexprep(vs,{'version:','\s+'},{'V:' ''});
set(hb,'string',['[' vs ']'],'backgroundcolor','w');

%% =====[update]==========================================
hb=uicontrol(ht1,'style','pushbutton','units','normalized');
set(hb,'string','update');
set(hb,'position',[-0.0011138 0.1 0.078071 0.025708]);
set(hb,'callback',@update_cb);
%% ===============================================
hb=uicontrol(ht1,'style','popupmenu','units','normalized');
set(hb,'string',v.opt2sort(:,1));
set(hb,'tag','pop_displaywhat');
set(hb,'position',[0.0038307 0.052741 0.12 0.026]);
set(hb,'callback',@replot);
%% ===============================================
hb=uicontrol(ht1,'style','radio','units','normalized');
set(hb,'string','sort after');
set(hb,'tag','radio_sort','backgroundcolor','w');
set(hb,'position',[0.1346 0.054669 0.078071 0.026]);
set(hb,'callback',@replot);


set(hf,'userdata',v);
set(hf,'WindowButtonMotionFcn',@mouse_move)

replot();
defineTasks(v);
mrtrixStatus();
slurmbatch(v);

drawnow;
%  tabgp.SelectedTab=ht4; %focus:tab4

function mrtrixStatus()

hf=findobj(0,'tag','monitor');
ht2=findobj(hf,'tag','tb_mrtrixstatus');

u=get(hf,'userdata');
%% ==[server]=============================================
hb=uicontrol(ht2,'style','edit','units','normalized');
set(hb,'position',[0.1 0.97 0.35 0.024]);
set(hb,'tag','hostname','HorizontalAlignment','left');
try; set(hb,'string',u.HPC_hostname); end
set(hb,'tooltipstring',['<html><b>enter HPC-hostname here</b><br>' ...
    'example: "s-sc-frontend2.charite.de"']);
set(hb,'enable','off');
% TXT
hb=uicontrol(ht2,'style','text','units','normalized');
set(hb,'position',[0 0.97 0.1 0.02]);
set(hb,'string','hostname: ','HorizontalAlignment','right','backgroundcolor','w');


%% =====[get status]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'position',[0.004 0.93696 0.1 0.024]);
set(hb,'tag','srv_getstatus','HorizontalAlignment','left');
set(hb,'string','get JOB-status','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@mrtrixstatus_tasks,'srv_getstatus'});
set(hb,'tooltipstring','get running/pending JOBs on HPC');


%% =====[list dir sort time]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'position',[0.104 0.93736 0.12 0.024]);
set(hb,'tag','srv_getfiles','HorizontalAlignment','left');
set(hb,'string','list files: sort time','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@mrtrixstatus_tasks,'srv_getfiles'});
set(hb,'tooltipstring','list batch-related output/error-files from HPC, sorted by time');
%% =====[list dir: sort name]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'position',[0.104 0.9136 0.12 0.024]);
set(hb,'tag','srv_getfiles','HorizontalAlignment','left');
set(hb,'string','list files: sort name','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@mrtrixstatus_tasks,'srv_getfiles_by_name'});
set(hb,'tooltipstring','list batch-related output/error-files from HPC, sorted by name');

%% =====[find files]==========================================
hb=uicontrol(ht2,'style','edit','units','normalized');
set(hb,'position',[0.101 0.72088 0.1 0.024]);
set(hb,'tag','srv_findfiles','HorizontalAlignment','left');
set(hb,'string','','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@mrtrixstatus_tasks,'srv_findfiles'});
set(hb,'tooltipstring','find files');
set(hb,'tooltipstring',['<html><b>enter first letters output/error-files here to show their content </b><br>' ...
    'example: "ophel"']);

% TXT
hb=uicontrol(ht2,'style','text','units','normalized');
set(hb,'position',[0 0.72088 0.1 0.024]);
set(hb,'string','file filter: ','HorizontalAlignment','right','backgroundcolor','w');


%% ===============================================
function clicked_listbox(e,e2,task)
%% ===============================================
hf=findobj(0,'tag','monitor');
p.HPC_hostname=get(findobj(hf,'tag','hostname'),'string');
hb=findobj(gcf,'tag','hpc_status');
t=hb.String{hb.Value};
tc=  strsplit(t,' ');
file=tc{end};
[~,name,ext]=fileparts(file);
% if any(strcmp({ '.txt' '.sh' '.py'}, ext ))==0
%     return
% end
sizefile=getHPCstatus(p,'getfilesize',file);
sizefile=char(sizefile.msg);
sizefile=str2num(strtok(sizefile,' '));
if sizefile>50000; disp('file is to large to display'); return; end

hfind=findobj(gcf,'tag','srv_findfiles'); %set into edit
set(hfind,'string',file );

%% ===============================================

mrtrixstatus_tasks([],[],'srv_findfiles');
drawnow
hb1=findobj(hf,'tag','hpc_runningfilesO');
file1(1)=hb1.String(hb1.Value);
hb2=findobj(hf,'tag','hpc_runningfilesE');
file1(2)=hb2.String(hb1.Value);
%% ===============================================
whichbox=find(strcmp(file1,'-')==0);
if isempty(whichbox); return; end

if whichbox(1)==1
    mrtrixstatus_tasks([],[],'getO');
elseif whichbox(1)==2
    mrtrixstatus_tasks([],[],'getE');
end
drawnow;

%% ===============================================

function mrtrixstatus_tasks(e,e2,task,arg)
% tasks
hf=findobj(0,'tag','monitor');
ht2=findobj(hf,'tag','tb_mrtrixstatus');

p.HPC_hostname=get(findobj(hf,'tag','hostname'),'string');

if strcmp(task,'srv_findfiles')
    hb=findobj(hf,'tag','srv_findfiles');
    filename=get(hb,'string');
    if isempty(filename); return; end
    o=getHPCstatus(p,'findfiles', filename);
    mrtrixstatus_tasks([],[],'srv_listfiles',o)
    
elseif strcmp(task,'srv_getfiles')|| strcmp(task,'srv_getfiles_by_name')
    if strcmp(task,'srv_getfiles')
        o=getHPCstatus(p,'listfiles');
    else
        o=getHPCstatus(p,'listfiles_time');
    end
    %o.files='';
    hb=findobj(hf,'tag','hpc_status');
    if isempty(hb)
        hb=uicontrol(ht2,'style','listbox','units','normalized');
        set(hb,'position',[0.22 0.7 0.775 0.27]);
        set(hb,'HorizontalAlignment','left','FontName','consolas');
        set(hb,'tag','hpc_status');
    end
    set(hb,'string',o.status,'value',1);
    set(hb,'callback',{@clicked_listbox,1})
    
elseif strcmp(task,'srv_getstatus') || strcmp(task,'srv_listfiles')
    set(findobj(gcf,'tag','srv_findfiles'),'string','');
    if strcmp(task,'srv_getstatus')
        o=getHPCstatus(p,'squeue --me');
        %o.files='';
        hb=findobj(hf,'tag','hpc_status');
        if isempty(hb)
            hb=uicontrol(ht2,'style','listbox','units','normalized');
            set(hb,'position',[0.22 0.7 0.775 0.27]);
            set(hb,'HorizontalAlignment','left','FontName','consolas');
            set(hb,'tag','hpc_status');
        end
        
        %% ===============================================
        
        ms=o.status;
        if ~isempty(o.isrunning)
            ipending=setdiff(2:length(ms),o.isrunning+1);
            ms(1)=cellfun(@(a){[ '<html><font color=red><b>' a]}, ms(1));
            ms(ipending)=cellfun(@(a){[ '<html><font color=gray>' a]}, ms(ipending));
            ms(o.isrunning+1)=cellfun(@(a){[ '<html><font color=blue>' a]}, ms(o.isrunning+1));
            ms=regexprep(ms, ' ', '&nbsp;');
        else
            set(hb,'value',length(ms));
        end
        set(hb,'string',ms,'value',1);
    elseif strcmp(task,'srv_listfiles')
        %         o.files=
        m=arg.status;
        m1=m(regexpi2(m,'\.o'));
        m2=m(regexpi2(m,'\.e'));
        if isempty(m1) && isempty(m2) && ~isempty(m)
            m1=m;
        end
        m=repmat({'-'},[ max([length(m1) length(m2)])  2 ]);
        m(1:length(m1),1)=m1;
        m(1:length(m2),2)=m2;
        o.files=m;
    end
    %% ===============================================
    % info
    if ~isempty(o.files)
        hb= findobj(hf,'tag','tx_runningFiles');
        if isempty(hb)
            hb=uicontrol(ht2,'style','text','units','normalized');
            
            set(hb,'position',[0.01 0.7 0.2 0.02],'horizontalalignment','left');
            set(hb,'foregroundcolor',...
                'b','backgroundcolor','w');
            set(hb,'tag','tx_runningFiles');
        end
        tit=['running processes-status files (' num2str(size(o.files,1)) ')'];
        if strcmp(task,'srv_listfiles')
            tit=['files (' num2str(size(o.files,1)) ')'];
        end
        set(hb,'string',tit);
        if get(hb,'value')==0; set(hb,'value',1); end
    end
    %% ===============================================
    %% =========[show outputfiles]======================================
    hb=findobj(hf,'tag','hpc_runningfilesO');
    if ~isempty(o.files)
        if isempty(hb)
            hb=uicontrol(ht2,'style','listbox','units','normalized');
            set(hb,'position',[0.01 0.48 0.25 0.218]);
            set(hb,'HorizontalAlignment','left','FontName','consolas');
            set(hb,'tag','hpc_runningfilesO');
            set(hb,'callback',{@mrtrixstatus_tasks,'getO'});
        end
        set(hb,'string',o.files(:,1));
        if get(hb,'value')==0; set(hb,'value',1); end
        if get(hb,'value')>length(get(hb,'string')); set(hb,'value',1); end
    else
        delete(hb);
        delete(findobj(hf,'tag','hpc_fileMSG'));
        delete(findobj(hf,'tag','tx_runningFiles'));
        delete(findobj(hf,'tag','tx_hpc_fileMSG'));
    end
    %% =========[show errorfiles]======================================
    hb=findobj(hf,'tag','hpc_runningfilesE');
    if ~isempty(o.files)
        if isempty(hb)
            hb=uicontrol(ht2,'style','listbox','units','normalized');
            set(hb,'position',[0.26 0.48 0.25 0.218]);
            set(hb,'HorizontalAlignment','left','FontName','consolas');
            set(hb,'tag','hpc_runningfilesE');
            set(hb,'callback',{@mrtrixstatus_tasks,'getE'});
        end
        set(hb,'string',o.files(:,2));
        if get(hb,'value')==0; set(hb,'value',1); end
        if get(hb,'value')>length(get(hb,'string')); set(hb,'value',1); end
    else
        delete(hb);
    end
    %% ===============================================
    
elseif  strcmp(task,'getO')  || strcmp(task,'getE')
    hbo=findobj(hf,'tag','hpc_runningfilesO');
    hbe=findobj(hf,'tag','hpc_runningfilesE');
    if strcmp(task,'getO')
        ix=get(hbo,'value');
        set(hbe,'value',ix);
        file=hbo.String{hbo.Value};
        fileType='outputFile';
    elseif strcmp(task,'getE')
        ix=get(hbe,'value');
        set(hbo,'value',ix);
        file=hbe.String{hbe.Value};
        fileType='errorFile';
    end
    
    o=getHPCstatus(p,['cat ' file]);
    %% =======TXT-content of========================================
    if ~isempty(o.msg)
        hb= findobj(hf,'tag','tx_hpc_fileMSG');
        if isempty(hb)
            hb=uicontrol(ht2,'style','text','units','normalized');
            set(hb,'position',[0.6 0.478 0.3 0.02]);
            set(hb,'horizontalalignment','left');
            set(hb,'foregroundcolor','b','backgroundcolor','w');
            set(hb,'tag','tx_hpc_fileMSG');
        end
        set(hb,'string',[ 'content of  "' file '"']);
    end
    %% ===============================================
    %% =====[display content]==========================================
    
    hb=findobj(hf,'tag','hpc_fileMSG');
    if ~isempty(o.msg)
        if isempty(hb)
            hb=uicontrol(ht2,'style','listbox','units','normalized');
            set(hb,'position',[0 0.001 1 0.475]);
            set(hb,'HorizontalAlignment','left','FontName','consolas');
            set(hb,'tag','hpc_fileMSG');
            %set(hb,'callback',{@mrtrixstatus_tasks,'getE'});
        end
        set(hb,'string',o.msg,'value',size(o.msg,1));
    else
        delete(hb);
        delete(findobj(hf,'tag','tx_hpc_fileMSG'));
    end
    %% ===============================================
    
    
    
end



function defineTasks(v)
%% ===============================================
%% =====[study-path on 'x' ]==========================================

pastudy       = fullfile(fileparts(fileparts(pwd)));
pain          = fullfile(pastudy, 'data');
[~,studyname] = fileparts(pastudy);

if exist('pa_source')==0
    pa_source='';
    sourcefile=fullfile(pastudy,'source.txt');
    if exist(sourcefile)==2
        b=preadfile(sourcefile);
        b=b.all;
        bb=b{min(regexpi2(b,'\[source\]'))};
        pa_source=regexprep(bb,'\[source\]','');
        
        bb=b{min(regexpi2(b,'\[backup\]'))};
        pa_backup=regexprep(bb,'\[backup\]','');
    end
    %     if exist(pa_source)~=7
    %         [t,sts] = spm_select(1,'dir','select orig. ANTx-StudyDIR','',pwd);
    %         if isempty(t); return;        end
    %         pa_source=t;
    %     end
    
    
end
%% ===============================================



hf=findobj(0,'tag','monitor');
ht2=findobj(hf,'tag','tb_tasks');

if  1
    space=repmat(' ',[1 50]);
    m1 = uimenu('Label',space);
    m1 = uimenu('Label',space);
    m1 = uimenu('Label',space);
    m1 = uimenu('Label','misc');
    uimenu(m1,'Label','restart monitor',...
        'Callback',{@cb_uimenu,'restartmonitor'});
    uimenu(m1,'Label','show source-file',...
        'Callback',{@cb_uimenu,'showsourcefile'});
end

%% =====[check_mrtrixProc]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['<html><k>check MRtrix processing ']);
set(hb,'position',[.02 .95 .2 .024 ]);
set(hb,'tag','pb_check_mrtrixProc','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'check_mrtrixProc'});
set(hb,'tooltipstring','check status of MRtrix-processing');
%% =====[open mrtrix-dir]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['open MRtrix-DIR ']);
set(hb,'position',[0.85 0.94904 0.15 0.024],'HorizontalAlignment','left');
set(hb,'tag','pb_openmrtrixdir','foregroundcolor','k','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'pb_openmrtrixdir'});
set(hb,'tooltipstring','open MRtrixstudy-DIR in file explorer');
%% =====[open ANTX-dir]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['open ANTxStudy-DIR ']);
set(hb,'position',[0.85 0.92528 0.15 0.024],'HorizontalAlignment','left');
set(hb,'tag','pb_openantxstudydir','foregroundcolor','k','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'pb_openantxstudydir'});
set(hb,'tooltipstring','open ANTxstudy-DIR in file explorer');
%% =====[open backup-dir]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['open backup-DIR ']);
set(hb,'position',[0.85 0.9014 0.15 0.024],'HorizontalAlignment','left');
set(hb,'tag','pb_backupdir','foregroundcolor','k','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'pb_backupdir'});
set(hb,'tooltipstring','open backup-DIR in file explorer');


%% =====[delete mrtrixfolder]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['restore orig. dataset']);
set(hb,'position',[0.0057825 0.0032521 0.15 0.024],'HorizontalAlignment','left');
set(hb,'tag','pb_restorOrigDataSet','foregroundcolor','k','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'pb_restorOrigDataSet'});
set(hb,'tooltipstring','restore original mrtrix-dataset--> guided, see cmd-win');


%% ===============================================
%% =====[check_mrtrixProc]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string',['<html><k>check volume-btable consistency']);
set(hb,'position',[0.474 0.94784 0.35 0.024]);
set(hb,'tag','pb_check_volBtablecon','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@tasks_specific,'check_volBtablecon'});
%% ===============================================
[~,studyName]=fileparts(v.pastudy);
exportdir=fullfile(v.backupDir,studyName);
sourcedir=v.sourceDir;
[pas sub]=fileparts(sourcedir);
if strcmp(sub,'dat'); sourcedir=pas; end


t={...
    %   'check MRtrix-processing'                 'check_mrtrixProc'   0   ''         ''
    'make screenShots (Linux-machine)'       'makeScreenshots'    2   'force overwrite screenshots'      'optional'  ''
    'make HTML for QA'                       'makeHTML_QA'        0   ''         ''             ''
    'copy data back to ANTx-Study'           'copy2AntXStudyDir'  1  'copy_dir' 'enter ANTx-study-path here'      sourcedir
    'export to BACKUP-drive'                 'export2BackupDIR'   1  'backup_dir' 'enter main path for DTI-backup'  exportdir
    };
    %'ctrl'  'string' 'value' 'tag' 'tooltip'
t2={''  ''   '' '' ''
    ''  ''   '' '' ''
    'radio'  'force to overwrite' '0'  'copy_forceoverwrite'        'copy: force to overwrite file if exist'
    'radio'  'force to overwrite' '0'  'export_forceoverwrite'      'export: force to overwrite file if exist'
    };
t=[t t2];
%  t=t(3,:)

sup=.8;
step=0.05;
pbwid=.25;
hb=uicontrol(ht2,'style','radio','units','normalized');
set(hb,'string','select all');
set(hb,'position',[.01+pbwid sup+step 0.1 0.026]);
set(hb,'tag','select_all','backgroundcolor','w');
set(hb,'callback',{@tasks,'selectall',t});


for i=1:size(t,1)
    hb=uicontrol(ht2,'style','pushbutton','units','normalized');
    set(hb,'string',t{i,1});
    set(hb,'position',[.01 sup-(i*step)+step pbwid 0.026]);
    set(hb,'tag','pb_task');
    set(hb,'userdata',i);
    set(hb,'callback',{@tasks,[i],t});
    set(hb,'tag','pb_run','foregroundcolor','k','backgroundcolor','w');
    
    hb=uicontrol(ht2,'style','radio','units','normalized');
    set(hb,'string','');
    set(hb,'position',[.01+pbwid sup-(i*step)+step 0.02 0.026]);
    set(hb,'tag','rd_task','backgroundcolor','w');
    set(hb,'userdata',i);
    
    if cell2mat(t(i,3))==1
        hb=uicontrol(ht2,'style','edit','units','normalized');
        set(hb,'string',t{i,6});
        set(hb,'position',[.01+pbwid+0.02 sup-(i*step)+step .6 0.026]);
        set(hb,'tag',t{i,4},'backgroundcolor','w');
        set(hb,'tooltipstring',t{i,5});
        set(hb,'userdata',i,'HorizontalAlignment','left');
    elseif cell2mat(t(i,3))==2
        if ~isempty(strfind(t{i,1},'screenShots'))
            hb=uicontrol(ht2,'style','radio','units','normalized');
            set(hb,'string',t{i,4},'value',0);
            set(hb,'position',[.01+pbwid+0.1 sup-(i*step)+step .6 0.026]);
            set(hb,'tag',t{i,4},'backgroundcolor','w');
            set(hb,'tooltipstring',t{i,5})
            set(hb,'tag','radio_screenshots_forceoverwrite');
        end
        
    end
    if ~isempty(t{i,7})
        hb=uicontrol(ht2,'style',t{i,7},'units','normalized');
        set(hb,'string',t{i,8},'value',str2num(t{i,9}));
        set(hb,'position',[.01+pbwid+0.03 sup-(i*step)+step/2 .15 0.024]);
        set(hb,'tag',t{i,10},'backgroundcolor','w');
        set(hb,'tooltipstring',t{i,11})
    end
    
end
%% =====[run]==========================================
hb=uicontrol(ht2,'style','pushbutton','units','normalized');
set(hb,'string','<html><b>RUN');
set(hb,'position',[.15 sup-((i+1)*step)+step/2 0.1 0.026]);
set(hb,'tag','pb_run','foregroundcolor','b','backgroundcolor','w');
set(hb,'callback',{@tasks,'run',t});

% ==============================================
%%   slurm batch
% ===============================================
function slurmbatch(v)
hf=findobj(0,'tag','monitor');
ht4=findobj(hf,'tag','tb_slurmbatch');
%% --list bashfiles
hb=uicontrol(ht4,'style','pushbutton','units','normalized');
set(hb,'position',[.01 0.97748 0.1 0.026]);
set(hb,'string','list bashfiles','tag','pb_listbashfiles',...
    'callback',{@cb_slurmbatch,'listbashfiles'},...
    'foregroundcolor','b','backgroundcolor','w');
set(hb,'tooltip','get list of bashfiles');
q.ini_runtwice=1;
set(hb,'userdata',q);

%% bashfile-list---------
hb=uicontrol(ht4,'style','listbox','units','normalized','string','');
set(hb,'position',[0 .35 .25 .63]);
set(hb,'callback',{@cb_slurmbatch,'show'},'tag','batchfile_list');
set(hb,'tooltip','available bashfiles','visible','off');


cmm=uicontextmenu;
uimenu('Parent',cmm, 'Label','<html><font color=blue>run this bashfile',...            
'callback', {@cb_slurmbatch,'run_bashfile' });
uimenu('Parent',cmm, 'Label','<html><font color=red>delete this bashfile',...            
'callback', {@cb_slurmbatch,'delete_bashfile' });
set(hb,'UIContextMenu',cmm);

%saveas---------
hb=uicontrol(ht4,'style','pushbutton','units','normalized');
set(hb,'position',[.7 0.97748 0.1 0.026]);
set(hb,'string','saveas as..','tag','pb_bfile_saveas',...
    'callback',{@cb_slurmbatch,'bash_saveas'},...
    'foregroundcolor','b','backgroundcolor','w');
set(hb,'visible','off');
set(hb,'tooltip','save bashfile as ...');

%save---------
hb=uicontrol(ht4,'style','pushbutton','units','normalized');
set(hb,'position',[0.802 0.97696 0.1 0.026]);
set(hb,'string','save','tag','pb_bfile_save',...
    'callback',{@cb_slurmbatch,'bash_save'},...
    'foregroundcolor','b','backgroundcolor','w');
set(hb,'visible','off');
set(hb,'tooltip','save bashfile');

% console---------
hb=uicontrol(ht4,'style','edit','units','normalized','string','HPC console output');
set(hb,'position',[0 0 1 .3]);
set(hb,'tag','bfile_console');
set(hb,'Min', 0, 'Max', 1000,'HorizontalAlignment','left',...
        'fontname','consolas','fontsize',8);
set(hb,'backgroundcolor','k','ForegroundColor','w');
jScrollPane = findjobj(hb);
%jScrollPane = findjobj(hb);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);
jEditbox.setWrapping(false);  % do *NOT* use set(...)!!!
% newPolicy = jScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED;
set(jScrollPane,'HorizontalScrollBarPolicy',32);
set(hb,'tooltip','console output');

%enter command ------------------
hb=uicontrol(ht4,'style','edit','units','normalized','string','');
set(hb,'position',[0 .3 1 .68],'tag','ed_bash_submitCMD',...
    'callback',{@cb_slurmbatch,'bash_submitCMD'});    
set(hb,'position',[0 .3 .4 .023],'HorizontalAlignment','left');
set(hb,'tooltip','enter comand here');

    
%enter command-list--------------
cmdlist={'squeue --me' 'ls' 'ls -lts --block-size=1' 'pwd' 'hostname',...
    'echo "$USER"' 'scancel <ID>'                                                   ,...
    'find $(pwd) -maxdepth 1 -name "*.e*" -o -name "*.o*" -atime -5 -ls',...
    'find $(pwd) -maxdepth 1 -name "*batch_*"  -atime -2 -ls',...
    };
hb=uicontrol(ht4,'style','popupmenu','units','normalized','string',cmdlist);
set(hb,'position',[.4 .3 .14 .023],...
    'tag','ed_bash_cmdlist',...
    'callback',{@cb_slurmbatch,'selectfrom_cmdlist'});
set(hb,'tooltip','comand list');
%undo--------------
hb=uicontrol(ht4,'style','pushbutton','units','normalized');
set(hb,'position',[0.63994 0.97956 0.026 0.026]);
set(hb,'string','<','tag','pb_bfile_undo',...
    'callback',{@cb_slurmbatch,'pb_bfile_undo'},...
    'foregroundcolor','b','backgroundcolor','w');
set(hb,'visible','off');
set(hb,'tooltip','undo changes');
%redo --------------
hb=uicontrol(ht4,'style','pushbutton','units','normalized');
set(hb,'position',[0.66568 0.9793 0.026 0.026]);
set(hb,'string','>','tag','pb_bfile_redo',...
    'callback',{@cb_slurmbatch,'pb_bfile_redo'},...
    'foregroundcolor','b','backgroundcolor','w');
set(hb,'visible','off');
set(hb,'tooltip','redo changes');


function cb_slurmbatch(e,e2,task)
hf=findobj(0,'tag','monitor');
v=update_monitor('rootinfo',1);
p.HPC_hostname=get(findobj(gcf,'tag','hostname'),'string');

if  strcmp(task,'listbashfiles')
    %  set_slurmstatus(1,'wait: get bashfiles');
    waitspin(1,'..get bashfiles..','');
    hb=findobj(hf,'tag','batchfile_list');
    o=getHPCstatus(p,'cmd','ls *.sh');
    li=o.msg;
    li=cellstr(li);
    set(hb,'string',li,'visible','on');
    if hb.Value>length(li)
        hb.Value=length(li);
    end
    set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1 1 1]);
    set(findobj(gcf,'tag','tx_batchfileName'),'backgroundcolor',[1 1 1]);
    cb_slurmbatch([],[],'show')
    waitspin(0);
    hc=findobj(gcf,'tag','pb_listbashfiles');
    us=get(hc,'userdata');
    
    if us.ini_runtwice==1  %first time run twice for java-callback issue
       us.ini_runtwice=0;
       set(hc,'userdata',us);
%        drawnow
       cb_slurmbatch([],[],'show');
%        drawnow
    end
    
elseif strcmp(task,'selectfrom_cmdlist')
    waitspin(1,'..send comand..','');
    hb=findobj(hf,'tag','ed_bash_submitCMD');
    hr=findobj(hf,'tag','ed_bash_cmdlist');
    cmd=hr.String{hr.Value};
    set(hb,'string',cmd);
    cb_slurmbatch([],[],'bash_submitCMD');
    waitspin(0);
elseif  strcmp(task,'pb_bfile_undo') || strcmp(task,'pb_bfile_redo')  
    hb=findobj(gcf,'tag','ed_batchfiles');
    u=get(hb,'userdata');
    if strcmp(task,'pb_bfile_undo')
        num=u.snum-1;
    elseif strcmp(task,'pb_bfile_redo')
        num=u.snum+1;
    end
    
    if num>0 && num<=length(u.s)
        set(hb,'string',u.s{num});
        u.snum=num;
        set(hb,'userdata',u);
        
        hb=findobj(gcf,'tag','ed_batchfiles');
        hj=findjobj(hb);
        w=char(hj.getViewport.getView.getText);
        w=strsplit(w,{'','\n' })';
        v1=strjoin(u.s{1},',');
        v2=strjoin(w,',');
        if (length(v1)==length(v2))
            if strcmp(v1,v2)==1
                % 'identical'
                ht=findobj(gcf,'tag','tx_batchfileName');
                set(ht,'string',[regexprep(get(ht,'string'),'*','') ],...
                    'backgroundcolor',[1 1 1]);
                set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1 1 1]);
            end
        else
            ht=findobj(gcf,'tag','tx_batchfileName');
            set(ht,'string',[regexprep(get(ht,'string'),'*','') '*'],...
                'backgroundcolor',[1 1 0]);
            set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1.0000    0.9490    0.8667]);
        end
    end
    
    
elseif strcmp(task,'bash_submitCMD')
    %% --
    hc=findobj(hf,'tag','bfile_console');
    hb=findobj(hf,'tag','ed_bash_submitCMD');

    cmd=hb.String;
    hr=findobj(hf,'tag','ed_bash_cmdlist');
    cmdlist=unique([cmd; get(hr,'string'); ],'stable');
    set(hr,'string',cmdlist);
    
    cmdx=[cmd ' &> SomeFile.txt;cat SomeFile.txt'];
    o=getHPCstatus(p,'cmd',[  cmdx ]);
    %% ----
    %s=[[ '<html><font color=b>'  cmd  ]; o.msg];
    s=[[ char(9824) '[COMMAND]: ' cmd  ]; o.msg; {'';}];
    set(hc,'string',s,'value',length(s));
    try
        hj=findjobj(hc);
        hj.getVerticalScrollBar.setValue(hj.getVerticalScrollBar.getMaximum);
    end

    
    %% --
elseif strcmp(task,'run_bashfile')
    %% ===============================================
     waitspin(1,'..run bashfile..','');
   hb=findobj(gcf,'tag','batchfile_list');
   bfile=hb.String{hb.Value} ;
   q=questdlg(['run batchfile "'  bfile '" on HPC now?'],'',...
       'Yes','No','No');
   if strcmp(q,'No'); disp('abort'); return; end
   
   o=getHPCstatus(p,'cmd',[  'sbatch ' bfile ]);
   %disp(char(o.msg));
   waitspin(0);
    %% ===============================================
elseif strcmp(task,'delete_bashfile')
    waitspin(1,'..delete bashfile..','');
   hb=findobj(gcf,'tag','batchfile_list');
   bfile=hb.String{hb.Value} ;
   q=questdlg(['delete batchfile "'  bfile '" from HPC now?'],'',...
       'Yes','No','No');
   if strcmp(q,'No'); disp('abort');
       waitspin(0);
       return; 
   end
   
   o=getHPCstatus(p,'cmd',[  'rm ' bfile ]);
  % disp(char(o.msg));
    cb_slurmbatch([],[],'listbashfiles');% show in editor
    waitspin(0);
elseif strcmp(task,'bash_saveas') || strcmp(task,'bash_save')
    
    bfile=get(findobj(gcf,'tag','tx_batchfileName'),'string');
    if isempty(bfile); 
        return;
    end
    bfile=regexprep(bfile,'*','');
    bfile=strrep(bfile,'FILE: ','');
    
    
    waitspin(1,'..save bashfile..','');
    if strcmp(task,'bash_saveas')
        %% ========saveas=======================================
        
         prompt = {'Enter new name for bash-file:','open & edit new batchfile: [0|1]'};
         dlg_title = 'copy batchfile';
         num_lines = [1 50];
         [~,bfileNew,ext]=fileparts(bfile);
         defaultans = {[bfileNew '_NEW' ext],'1'};
         answer = inputdlg2(prompt,dlg_title,num_lines,defaultans);
         if isempty(answer);
             waitspin(0);
             return,
         end
         bfileNew =answer{1};
         doshow   =str2num(answer{2});
     else
        %% ========overwrite=======================================
        bfileNew=bfile;
        doshow   =1;
         
        %% ===============================================
        
     end
     
     
     %% ========[write tempfile]=======================================
     ms=get(findobj(gcf,'tag','ed_batchfiles'),'string');
     tmpdir=fullfile(v.pastudy,'tmp');
     if exist(tmpdir)~=7; mkdir(tmpdir); end
     f1=fullfile(tmpdir,bfileNew);
     pwrite2file(f1,ms);
     %showinfo2(['tempfile'],f1);
     %edit(f1)
     %% ========[write bfile to HPC]=======================================
     global mpw
     tmpdir2=strrep(tmpdir,filesep,[filesep filesep]);
        %      msg = scp_simple_put(p.HPC_hostname,mpw.login,mpw.password,...
        %          bfileNew,'',tmpdir);
      msg=sftp_simple_put(p.HPC_hostname,mpw.login,mpw.password,...
         bfileNew,'',tmpdir);

     cmd=['chmod 777 ' bfileNew];
     o=getHPCstatus(p,'cmd',cmd);
     delete(f1);
    %% ===============================================
     cb_slurmbatch([],[],'listbashfiles');% update
    if doshow==1
        hb=findobj(gcf,'tag','batchfile_list');
        idx=find(strcmp(hb.String,bfileNew));
        hb.Value=idx;
        cb_slurmbatch([],[],'show');% show in editor
    end
    waitspin(0);
    %% ===============================================
    
elseif strcmp(task,'show')
    
%     hg=findobj(hf,'tag','batchfile_list');
%      if isempty(hg.String); return; end
    
    hf=findobj(0,'tag','monitor');
    ht4=findobj(hf,'tag','tb_slurmbatch');
    hb=findobj(ht4,'tag','ed_batchfiles');
    waitspin(1,'..show file..','');
    set(findobj(gcf,'tag','pb_bfile_save'),'visible','on');
    set(findobj(gcf,'tag','pb_bfile_saveas'),'visible','on');
    set(findobj(gcf,'tag','pb_bfile_undo'),'visible','off');
    set(findobj(gcf,'tag','pb_bfile_redo'),'visible','off');
    
    if isempty(hb)
        %% edit bashfile
        hb=uicontrol(ht4,'style','edit','units','normalized','string',{'empyt';'--'});
        set(hb,'position',[.25 .323 .75 .656],'tag','ed_batchfiles');
        set(hb,'Min', 0, 'Max', 1000,'HorizontalAlignment','left',...
        'fontname','consolas','fontsize',8);
        drawnow
        
        %u.jScrollPane = findjobj(hb);
        %set(hb,'userdata',u)
        
%         if 1
%             jScrollPane = findjobj(hb);
%             jViewPort = jScrollPane.getViewport;
%             jEditbox = jViewPort.getComponent(0);
%             jEditbox.setWrapping(false);  % do *NOT* use set(...)!!!
%             % newPolicy = jScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED;
%             set(jScrollPane,'HorizontalScrollBarPolicy',32);
%             set(jEditbox, 'KeyPressedCallback',@cb_bfile_statechanges);
%         end
    end
    
    hg=findobj(hf,'tag','batchfile_list');
   
    thisbashfile=hg.String{hg.Value};
    
    p.HPC_hostname=get(findobj(gcf,'tag','hostname'),'string');
    cmd=['cat ' thisbashfile ];
    o=getHPCstatus(p,'cmd',cmd);
    %% ===============================================
    
    %lis=strjoin(o.msg, char(13))
    lis=o.msg;
    set(hb,'string',lis,'value',1);
    if 1
        u=get(hb,'userdata');
        jScrollPane = findjobj(hb);
        %jScrollPane=u.jScrollPane;
        
        
        jScrollPane = findjobj(hb);
        %jScrollPane = findjobj(hb);
        jViewPort = jScrollPane.getViewport;
        jEditbox = jViewPort.getComponent(0);
        jEditbox.setWrapping(false);  % do *NOT* use set(...)!!!
        % newPolicy = jScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED;
        set(jScrollPane,'HorizontalScrollBarPolicy',32);
        set(jEditbox, 'KeyPressedCallback',@cb_bfile_statechanges);
        u.s={};
        u.s{1}=lis;
        u.snum=1;
        set(hb,'userdata',u);
    end
    drawnow;
    set(jEditbox, 'KeyPressedCallback',@cb_bfile_statechanges)
    
    ht=findobj(ht4,'tag','tx_batchfileName');
    if isempty(ht)
        %%  bashfile-name
        ht=uicontrol(ht4,'style','text','units','normalized','string','bla');
        set(ht,'position',[0.295 0.97298 0.3 0.026],'tag','tx_batchfileName',...
             'foregroundcolor','k','backgroundcolor','w','HorizontalAlignment','left');
         uistack(ht,'bottom');
    end
    set(ht,'string', ['FILE: '  thisbashfile ],'backgroundcolor',[1 1 1]);
    set(hb,'backgroundcolor',[1 1 1]);
    waitspin(0);
    %% ===============================================
end


function cb_bfile_statechanges(e,e2)

ht=findobj(gcf,'tag','tx_batchfileName');
set(ht,'string',[regexprep(get(ht,'string'),'*','') '*'],...
    'backgroundcolor',[1 1 0]);
set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1.0000    0.9490    0.8667]);
hb=findobj(gcf,'tag','ed_batchfiles');
drawnow


u=get(hb,'userdata');

try
    w=char(e.getText);
catch
    hb=findobj(gcf,'tag','ed_batchfiles');
    hj=findjobj(hb);
    w=char(hj.getViewport.getView.getText);
    'works'
end
w=strsplit(w,{'','\n' })';
u.s{end+1}=w;
u.snum=length(u.s);
set(hb,'userdata',u);
set(findobj(gcf,'tag','pb_bfile_redo'),'visible','on');
set(findobj(gcf,'tag','pb_bfile_undo'),'visible','on');


v1=strjoin(u.s{1},',');
v2=strjoin(u.s{end},',');
% [length(v1) length(v2)]
if (length(v1)==length(v2))
    if strcmp(v1,v2)==1
      % 'identical' 
      ht=findobj(gcf,'tag','tx_batchfileName');
      set(ht,'string',[regexprep(get(ht,'string'),'*','') ],...
    'backgroundcolor',[1 1 1]);
      set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1 1 1]);
    end
% else
%     ht=findobj(gcf,'tag','tx_batchfileName');
%     set(ht,'string',[regexprep(get(ht,'string'),'*','') '*'],...
%         'backgroundcolor',[1 1 0]);
%     set(findobj(gcf,'tag','ed_batchfiles'),'backgroundcolor',[1.0000    0.9490    0.8667]);
end
% hb.String

%% ===============================================
function cb_uimenu(e,e2,task)
%% ===============================================
v=update_monitor('rootinfo',1);
if strcmp(task,'restartmonitor')
    eval(mfilename);
elseif strcmp(task,'showsourcefile')
    disp(['==== source-file ========= ']);
    a=preadfile(v.sourcefile);a=a.all;
    disp(char(a));
    disp(['==========================']);
    showinfo2(['location'],v.sourcefile);
end







%% ===============================================
function tasks_specific(e,e2,task)
if strcmp(task,'check_mrtrixProc')
    check_mrtrixProc();
elseif strcmp(task,'check_volBtablecon')
    check_vol_btable_consistency();
elseif strcmp(task,'pb_openmrtrixdir')
    v=update_monitor();
    sdir=v.pastudy;
    explorer(sdir);
elseif strcmp(task,'pb_openantxstudydir')
    sdir=get(findobj(gcf,'tag','copy_dir'),'string');
    explorer(sdir);
elseif strcmp(task,'pb_backupdir')
    sdir=get(findobj(gcf,'tag','backup_dir'),'string');
    explorer(sdir);
elseif strcmp(task,'pb_restorOrigDataSet')
     mrtrix_delete('del',{'origin'});  
end





function tasks(e,e2,task,t)
hf=findobj(0,'tag','monitor');
%% ===============================================
if ischar(task) && strcmp(task,'selectall')
    hr=findobj(hf,'tag','rd_task');
    %    val=abs(round(mean([hr.Value]))-1)
    val=get(findobj(hf,'tag','select_all'),'value');
    set(hr,'value',val);
end

if (ischar(task) && strcmp(task,'run')) || isnumeric(task)
    if isnumeric(task)
        irun=task;
    else
        hr=findobj(hf,'tag','rd_task');
        [~,iwsort]=sort(cell2mat(get(hr,'userdata')));
        hr=hr(iwsort);
        irun=find(cell2mat(get(hr,'value'))==1);
    end
    funstab=t(irun,:);
    for i=1:size(funstab,1)
        cprintf('*[0 0 1]',[ '..busy..' funstab{i,1}  '\n']);
        if funstab{i,3}==0
            feval(funstab{i,2});
        else
            hed=findobj(hf,'tag',funstab{i,4});
            paout=get(hed,'string');
            %             if exist(paout)~=7
            %                return
            %             end
            if strcmp(funstab{i,2},'makeScreenshots')
                hx=findobj(hf,'tag','radio_screenshots_forceoverwrite');
                forceoverwrite=hx.Value;
                makeScreenshots('overwrite',forceoverwrite);
            elseif strcmp(funstab{i,2},'copy2AntXStudyDir') 
                paout          =get(findobj(gcf,'tag','copy_dir'),'string');
                force2overwrite=get(findobj(gcf,'tag','copy_forceoverwrite'),'value');
                copy2AntXStudyDir('force2overwrite',force2overwrite,'paout',paout);
            elseif strcmp(funstab{i,2},'export2BackupDIR') 
                paout          =get(findobj(gcf,'tag','backup_dir'),'string');
                force2overwrite=get(findobj(gcf,'tag','export_forceoverwrite'),'value');
                export2BackupDIR('force2overwrite',force2overwrite,'paout',paout);
            else
                feval(funstab{i,2},paout);
            end
        end
    end
    
end


%% ===============================================
function replot(e,e2)
%% ===============================================

hf=findobj(0,'tag','monitor');
hr=findobj(hf,'tag','pop_displaywhat');
hs=findobj(hf,'tag','radio_sort');

v=get(hf,'userdata');
iparam=hr.Value;
eval(['z=' v.opt2sort{iparam,2} ';']);
files=strrep(v.files,'_','\_');
if iparam==2 || iparam==6
    z=log10(z+1);
end
issort=hs.Value;
%% ===============================================



%% ===============================================
if issort==1
    [~,ixsort]=sort(mean(z,2),'descend');
    files=files(ixsort);
    z=z(ixsort,:);
else
    ixsort=1:size(z,1);
end
%% =====current values back to struct==========================================
for i=1:size(v.opt2sort,1)
    eval(['dx=' v.opt2sort{i,2} ';']);
    dx=dx(ixsort,:);
    eval([v.opt2sort{i,2} '_cur=dx;' ]);
end
v.files_cur=v.files(ixsort);
set(hf,'userdata',v);
%% ===============================================

% him=findobj(hf,'type','image');
% him.CData
axes(findobj(gcf,'tag','ax1'));
him=imagesc(z);
set(gca,'tag','ax1');
fs=6;


set(gca,'ytick',[1:size(v.z,1)],'yticklabels',files,'fontsize',fs);
set(gca,'xtick',[1:size(v.z,2)],'xticklabels',v.dirnum,'fontsize',fs);
set(gca,'xTickLabelRotation',45);

hv=vline( [1:size(v.z,2)-1]+.5 ,'color','r','hittest','off');
hh=hline( [1:size(v.z,1)-1]+.5 ,'color','r','hittest','off');
%% ======CONTEXTMENU=========================================

c = uicontextmenu;
him.UIContextMenu = c;
set(hv,'uicontextmenu',c);
set(hh,'uicontextmenu',c);
set(gca,'uicontextmenu',c);
m1 = uimenu(c,'Label','<html><font color=red>show file in explorer'       ,'Callback',{@context,'showFileExplorer'});
m1 = uimenu(c,'Label','open animal Dir in explorer'       ,'Callback',{@context,'explorer'});
m1 = uimenu(c,'Label','open animal MRtrix-Dir in explorer','Callback',{@context,'explorer_mrtrix'});


%% ===============================================


% col=flipud(cbrewer('seq','Greens',20));
col=flipud(cbrewer('seq','YlOrRd',50));
if iparam==6
    col=flipud(cbrewer('seq','YlGnBu',50));
end
col(end+1,:)=[1 1 1];
col(1:8,:)=[];
if iparam==1
    col=[.5 .5 .5
        1 1 1];
elseif iparam==2 | iparam==6
    col=flipud(col);
end
colormap(col);

cb=colorbar('location','south');
% pos=get(cb,'position')
set(cb,'position',[0.3 .02 .3 .01]);
cbtit=get(cb,'Title');
param_title=[hr.String{iparam} ];
set(cbtit,'string',param_title,'fontsize',8);
%% ===============================================

function context(e,e2,task)
hf=findobj(0,'tag','monitor');
ax=findobj(hf,'tag','ax1');
co=get(ax,'CurrentPoint');
co=fliplr(round(co(1,1:2)));
v=get(gcf,'userdata');

% v.dirnum(co(2));
if strcmp(task ,'showFileExplorer');
    f1={fullfile(v.fpdir{co(2)}         ,v.files_cur{co(1)})
        fullfile(v.fpdir{co(2)} ,'mrtrix',v.files_cur{co(1)})}
    ix= find( existn(f1)==2)
    if ~isempty(ix)
        f2=f1{min(ix) };
        explorerpreselect(f2);
    end
elseif strcmp(task ,'explorer');
    explorer(v.fpdir(co(2)));
elseif strcmp(task ,'explorer_mrtrix');
    explorer(fullfile(v.fpdir(co(2)),'mrtrix'));
end

function mouse_move(e,e2)

try
htabgrp=findobj(gcf,'tag','tabgroup');
currentTab=get(htabgrp.SelectedTab,'title');
if strcmp(currentTab,'Monitor')==0; 
    return
end
% disp('inMonitorTab')
catch
    return
end

hf=findobj(0,'tag','monitor');
ax=findobj(hf,'tag','ax1');
co=get(ax,'CurrentPoint');
co=fliplr(round(co(1,1:2)));

% msg={['hallo' num2str(rand(1))  ]};
msg={' '};
try
    v=get(gcf,'userdata');
    %% ===============================================
    
    msg=({
        ['\color{blue}file      : ' strrep(v.files_cur{co(1)},'_','\_')]
        ['\color{magenta}animal    : ' v.dirnum{co(2)}]
        ['\color{black}size(MB)  : ' sprintf('%2.2f',v.mb_cur(co(1),co(2))) ]
        ['time(min) : ' sprintf('%2.2f',v.tm_cur(co(1),co(2))) ]
        ['time(h)   : ' sprintf('%2.2f',v.th_cur(co(1),co(2))) ]
        ['time(days): ' sprintf('%2.2f',v.td_cur(co(1),co(2))) ]
        ['dt start (h): ' sprintf('%2.5f',v.ts_cur(co(1),co(2))) ]
        });
    %% ===============================================
    
    %% ===============================================
    %     msg
    %     co
end
ht=findobj(hf,'tag','tooltip');
if isempty(ht)
    ht=text(1,1,'empty','tag','tooltip','fontsize',8,...
        'interpreter','tex','fontname','consolas',...
        'hittest','off');
end
msg=strjoin(msg,char(10));
set(ht,'string',msg,'position',[co(2) co(1) 0 ]);
set(ht,'backgroundcolor','w');
%
try
    if co(1)<size(v.z,1)/2
        set(ht,'VerticalAlignment','top');
    else
        set(ht,'VerticalAlignment','bottom');
    end
end
try
    if co(2)<size(v.z,2)/2
        set(ht,'HorizontalAlignment','left');
    else
        set(ht,'HorizontalAlignment','right');
    end
end
%% ===============================================

function update_cb(e,e2)
% v=update();
v=update_monitor();
hf=findobj(0,'tag','monitor');
set(hf,'userdata',v);
replot();



% function v=update()



