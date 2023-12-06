
% Rename dwi-files
% In some cases the dwi-files have different scan-numbers across animals.
% This might might lead to an error because a dwi-file might not be found
% in the animal-folder.
% #b This GUI is used to obtain similar DWI-filenames across animals.
%  #k Before using this GUI:
%   1) DWI-files have to be imported (Bruker-import) for all animals 
%   2) The used DWI-files have to be selected for one animal in the DTIprep-GUI. 
%  #k What this function does:
% -checks the existence of the DTIprep-defined DWI-files for all animals 
% -shows those animals with missing DWI-files. Here 'missing' means that the 
%  exact DWI-filenames are not found in the animal folder.
%  #k The GUI & STEPS:
% -shows the 'problematic animals' with missing DWI-files (left listbox)
% -select a problematic animal from the left listbox 
% -for each animal the expected DWI-filenames are depicted on the right side
% -for each missing DWI-file potential 4D-NIfti-files found in the respective 
%  animal folder are depicted (radio-controls). Additionally, the potential
%  4D-NIfti-files are reduced to those files with a similar numbers of expected 
%  volumes (4th dim).
% -Please check the NIFTI-file that corresponds with the DWI-filename
% -Do this step for all DWI-files for one animal
% -Select the next problematic animal from the left listbox and perform
%  the previous steps
% #r -NOTE: checked/assigned files for a given animal will be internally stored when
% #r      switching to another animal (via left listbox)
% -when done select one of the [SAVING OPTIONS] and hit either 
%  [rename files .. current animal] or [rename files .. all animal] button
% 
% 
% #k [SAVING OPTIONS]
%  'copy & rename file': create a copy of orignal NIFTI-file, than rename 
%                        the copied file. (savest way)
%  'rename file'       : rename the original NIFTI-file (can be done only once!)
%                        
%  'simulate'          : show the source-files and target-files
% 
% [rename files .. current animal]: rename the files of the current animal only 
% [rename files .. all animal]    : rename the files of all animals 
%        #r                   -Please inspect all checked files for all animals
%        #r                    before hitting this button
% 
% 
% 

% ==============================================
%%   
% ===============================================


function renameDWIfiles




ms_error={['ERROR: (' mfilename '.m)']
    'POSSIBLE REASONS:'
    '  -DTIprep-GUI is not open'
    '  -DWI-files not specified in DTIprep-GUI'
    };

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
end

padat=fullfile(u.studypath,'dat');
[mdirs] = spm_select('List',padat,'dir');
mdirs=cellstr(mdirs);
%% ===============================================
fex=zeros(  length(mdirs), length(dwis) );
for i=1:length(mdirs)
    for j=1:length(dwis)
        f1=fullfile(padat,mdirs{i},dwis{j});
        if exist(f1)==2
            fex(i,j)=1;
        end
    end
end
% clc;
% disp(fex);

%% =====format==========================================
ix_mdir_filenameIssue=find(sum(fex,2)~=size(fex,2));
ix_mdir_ok=setdiff([1:length(mdirs)],ix_mdir_filenameIssue);
mdirsTemp=mdirs;
mdirsTemp(ix_mdir_filenameIssue)=cellfun(@(a){[char(9654) a]}, mdirsTemp(ix_mdir_filenameIssue));
mdirsTemp(ix_mdir_ok)=cellfun(@(a){[' ' a]}, mdirsTemp(ix_mdir_ok));

% return
r1=cellfun(@(a,b){[ '   DWI' num2str(a) ': "' b '"' ]}, num2cell(1:length(dwis))', dwis);
r=[ [ {'' } cellfun(@(a){[ 'DWI' num2str(a) ]}, num2cell(1:length(dwis)))   ]   ;mdirsTemp num2cell(fex)];
ms={};
ms(end+1,1)={' [1]: file exists'};
ms(end+1,1)={' [0]: file not found'};
ms=[ms ; r1];
r2=plog([],[r],0,ms);


% cl
cprintf('*[0 .5 1]', [ repmat('=', 1,80)  '\n']);
cprintf('*[0 .5 1]', [  ' Check existence of DWI-files across animal folders'   '\n']);
disp(char(r2));
if isempty(ix_mdir_filenameIssue)
  cprintf('*[0 .5 0]', [  ' ..all DWI-files found in all animals!!!'   '\n']);
else
    cprintf('*[1 .0 1]', [  ' animals with missing DWI-files'   '\n']);
    r3=plog([],[r([1; ix_mdir_filenameIssue+1],:)],0,'','plotlines=0;');
    disp(char(r3));
    cprintf('*[0 .5 1]', [ repmat('=', 1,80)  '\n']);
end
% if ~isempty(ix_mdir_filenameIssue)
%     disp('HOW TO PROCEED?');
%     disp(['1] rename dwi-files (files exist but have a different filename)']);
%     disp(['0] quit']);
% end

% ==============================================
%%   if no problmeatic animals found--> return
% ===============================================
if isempty(ix_mdir_filenameIssue)
    return
end

disp(' .. loading GUI..please wait...');

% ==============================================
%%  make struct
% ===============================================
v.mdirs     =mdirs;
v.mdirsIssue=mdirs(ix_mdir_filenameIssue);
v.dwis      =dwis;
v.fex       =fex;
v.ix_mdir_filenameIssue =ix_mdir_filenameIssue;
v.padat     =padat;


% ==============================================
%%   make GUI
% ===============================================

delete(findobj(0,'tag','renameDWIfiles'));
fg;
set(gcf,'units','norm','menubar','none','tag','renameDWIfiles',...
    'NumberTitle','off','name','renameDWIfiles' );
hf=gcf;
set(hf,'userdata',v);
%% ======[animal listbox]=========================================
hb=uicontrol('style','listbox','units','norm','tag','lb1');
set(hb,'position',[0.0071429 0.55238 0.4 0.4]);
set(hb,'string',v.mdirsIssue);
set(hb,'callback',@selectMdir_cb);
set(hb,'fontsize',8);
set(hb,'tooltipstring',['<html>animals with missing DWI-files' ...
    '<br> select animals here' ...
    ]);

%% ======[save option]=========================================
saveopt=...
    {'copy & rename file'
    'rename file'
    'simulate'};
saveopt_sel=1;
%--------------
hr=uicontrol('style','popupmenu','units','norm','tag','copyoption');
set(hr,'value',1,'backgroundcolor',[1.0000    0.9490    0.8667],...
    'string',saveopt);
set(hr,'position',[0.01 .4 .3 .035]);
set(hr,'value',saveopt_sel);
set(hr,'tooltipstring',['<html>saving option' ...
    '<br><b>NOTE: </b>'...
    '<br> -use "simulate" to check source and target-filenames!' ...
    '<br> -rather use "copy & rename file" ("rename file" can be critical)'...
    '<br> -"rename file" can be critical!'...
    ]);

%% ======[rename current animal]=========================================
hr=uicontrol('style','pushbutton','units','norm','tag','renamefiles');
set(hr,'value',1,'backgroundcolor',[0.9451    0.9686    0.9490]);
set(hr,'string',['<html><b>rename files' '</b><br>' 'current animal']);
set(hr,'position',[0.01 .1 .18 .08]);
set(hr,'callback',{@renamefiles});
set(hr,'tooltipstring',['<html>rename/copy&rename all files for the current animal']);
%% =========[rename all animals]======================================
hr=uicontrol('style','pushbutton','units','norm','tag','renamefiles');
set(hr,'value',1,'backgroundcolor',[1.0000    0.9686    0.9216]);
set(hr,'string',['<html><b>rename files' '</b><br>' 'all animals']);
set(hr,'position',[0.19 .1 .18 .08]);
set(hr,'callback',{@renamefiles,'all'});
set(hr,'tooltipstring',['<html>rename/copy&rename all files for all animals' ...
    '<br><b>PLEASE check file-assignment before!!!']);

%% =========[close]======================================
hr=uicontrol('style','pushbutton','units','norm','tag','close');
set(hr,'backgroundcolor',[1 1 1]);
set(hr,'string',['close']);
set(hr,'position',[0.24821 0.0047619 0.12 0.05]);
set(hr,'callback',{@cb_misc,'close'});
set(hr,'tooltipstring',['close GUI']);
%% =========[help]======================================
hr=uicontrol('style','pushbutton','units','norm','tag','help');
set(hr,'backgroundcolor',[1 1 1]);
set(hr,'string',['help']);
set(hr,'position',[0.12679 0.0047619 0.12 0.05]);
set(hr,'callback',{@cb_misc,'help'});
set(hr,'tooltipstring',['get some help']);
%% =========[open animaldir]======================================
hr=uicontrol('style','pushbutton','units','norm','tag','openAnimalDir');
set(hr,'backgroundcolor',[1 1 1]);
set(hr,'string',['openAnimalDir'],'fontsize',7);
set(hr,'position',[0.28839 0.5 0.12 0.05]);
set(hr,'callback',{@cb_misc,'openAnimalDir'});
set(hr,'tooltipstring',['open current animal-folder (for inspections)']);
%% ===============================================
hb=findobj(hf,'tag','lb1');
for i=1:length(v.mdirsIssue)
   hb.Value=i;
   selectMdir_cb([],[],i); 
%    drawnow;
end
hb.Value=1; 
selectMdir_cb([],[],1);



function selectMdir_cb(e,e2,idx)
hf=findobj(0,'tag','renameDWIfiles');
hb=findobj(hf,'tag','lb1');
if exist('idx')~=1
    idx=get(hb,'value')  ;
end
if mod(idx,2)==1
    col1=[0.3020    0.7451    0.9333];
else
    col1=[0.8549    0.7020    1.0000];
end
%% ===============================================

v=get(gcf,'userdata');
ix_missfiles=find(v.fex(v.ix_mdir_filenameIssue(idx),:)==0);
%% ===========[get number of 4d-volums from reference-animal ]====================================
mdirref_ix=min(find(sum(v.fex,2)==size(v.fex,2)));
mdirref   =v.mdirs{mdirref_ix};
numvolsref=zeros(size(1, length(v.dwis) ));
if ~isempty(mdirref)
    for i=1:length(v.dwis)
        f1=fullfile(  v.padat ,mdirref, v.dwis{i});
        if exist(f1)==2
            h=spm_vol(f1);
            numvolsref(1,i)=length(h);
        end
    end
end
%% =======[problemANimal: get 4D-NIFTIS and number of volums]========================================
animal=v.mdirs{v.ix_mdir_filenameIssue(idx)};
mdir=fullfile(v.padat,animal);
[files] = spm_select('List',mdir,'.*.nii');
files=cellstr(files);
potlist=zeros(length(files),2);
for i=1:length(files)
    h=spm_vol(fullfile(mdir,files{i}));
    %length(h)
    if size(h,1)>1
        potlist(i,:)=[1 length(h)];
    end
end
ix_pot=find(potlist(:,1)==1);
files=files(ix_pot);
potlist=potlist(ix_pot,:);
%% ===============================================
ht=uicontrol('style','text','units','norm','tag','tx_animal');
set(ht,'backgroundcolor',col1);
set(ht,'string',['MDIR: ' animal],'fontweight','bold');
set(ht,'position',[0.45 .95 .5 .035]);


delete(findobj(hf,'tag','tx_dwiname'));
delete(findobj(hf,'tag','rb_dwinamePot'));
stp=0.9;
tb={};
for i=1:length(ix_missfiles)
    hb=uicontrol('style','text','units','norm','tag','tx_dwiname');
    set(hb,'backgroundcolor',col1);
    set(hb, 'string',v.dwis{ix_missfiles(i)});
    set(hb,'position',[0.45 stp .5 .035]);
    
    files2=files;
    
    ix_matchvol=find(potlist(:,2)==numvolsref(ix_missfiles(i)));
    files2=files(ix_matchvol);
    isExist4D=1;
    if isempty(files2)
        files2={'no 4D-NIFTI found !!!-->please import DWI-file!!!'};
        isExist4D=0;
    end
    
    for j=1:length(files2)
        hr=uicontrol('style','radio','units','norm','tag','rb_dwinamePot');
        set(hr,'string',files2{j},'backgroundcolor','w');
        set(hr,'position',[0.45 stp-.032*j .5 .035]);
        set(hr,'userdata',i);
        
        if isExist4D==0
           set(hr,'enable','off','BackgroundColor',[1 0.84 0]) 
        end
        
        w.idx=idx;
        w.animal=animal;
        w.dwifile=v.dwis{ix_missfiles(i)};
        setappdata(hr,'data',w);
        
        set(hr,'callback',@singleselect);
        if isfield(v,'tb')==0 || size(v.tb,2)<idx || isempty(v.tb{idx})
            if j==1
                set(hr,'value',1);
                tb(end+1,:)={ v.dwis{ix_missfiles(i)} files2{j}};
            end
        end
    end
    posc=get(hr,'position');
    stp=posc(2)-.05;
end
if isfield(v,'tb')==1 && size(v.tb,2)>=idx
    tk=v.tb{idx};
    for i=1:size(tk,1)
        ha=findobj(hf,'tag','rb_dwinamePot' ,'-and' ,'userdata', i);
        str=get(ha,'string');
        set(ha(strcmp(str,tk{i,2})),'value',1);
    end
end

if isfield(v,'tb')==0 || size(v.tb,2)<idx || isempty(v.tb{idx})
    v.tb{idx}=tb;
    set(hf,'userdata',v);
    %disp('logged')
    %v
end


%% ===============================================
function singleselect(e,e2)
hf=findobj(0,'tag','renameDWIfiles');
usgrp=get(e,'userdata');
ixrb=findobj(hf,'tag','rb_dwinamePot' ,'-and' ,'userdata', usgrp);
set(ixrb,'value',0);
set(e,'value',1);

w=getappdata(e,'data');

v=get(hf,'userdata');
tb=v.tb{w.idx};

ix_file=find(strcmp(tb(:,1),w.dwifile));
tb(ix_file,2)={e.String};
v.tb{w.idx}=tb;
set(hf,'userdata',v);


function renamefiles(e,e2,arg)
hf=findobj(0,'tag','renameDWIfiles');
v=get(hf,'userdata');
hc=findobj(hf,'tag','copyoption');
p.copyoption=hc.String{hc.Value};

if exist('arg')==1 && strcmp(arg,'all')
    %% ===============================================
    ix=1:size(v.tb,2);
    p.animals=v.mdirsIssue(ix);
    if isempty(strfind(p.copyoption, 'simulate'))
        ask = questdlg({['Sure to copy/copy&rename all files in all animals (n='  num2str(length(ix)) ')?']...
            'Please check the files before doing this step!'}, ...
            '', ...
            'yes','no','yes');
        
        if strcmp(ask,'no'); return; end
    end
    %% ===============================================
    
    
    
else
    hr=findobj(hf,'tag','rb_dwinamePot' ,'-and' ,'userdata', 1);
    w=getappdata(hr(1),'data');
    ix=w.idx;
    p.animals=v.mdirsIssue(ix);
end


% p.animal    =w.animal;

%% ===============================================
for j=1:length(ix)
    tb=v.tb{ix(j)};
    animal=p.animals{j};
    if strfind(p.copyoption, 'simulate')
        cprintf('*[0.9 .7 .13]', [  ' Simulate (_COPY & RENAME FILES_)  '   '\n']);
    else
        cprintf('*[0 .5 1]', [  ' _COPY & RENAME FILES_'   '\n']);
    end
    cprintf('*[0 0 1]', [  ' ANIMAL:  ' animal  '\n']);
    
    for i=1:size(tb,1)
        fsource=tb{i,2};
        ftarget=tb{i,1};
        f1=fullfile(v.padat,animal,fsource );
        f2=fullfile(v.padat,animal,ftarget );
        
        if exist(f1)==0
            %disp(['no 4D-NIFTI found in [' animal '] --> can''t assign/rename DWI-file']);
            cprintf('*[1 0 0]', ['FAILED: no 4D-NIFTI found in [' animal '] --> can''t assign/rename DWI-file' '\n']);
            continue
        end
        
        cprintf('*[0 .7 1]', [  ' DWIfile:  ' ftarget  '\n']);
        
        if strfind(p.copyoption,'copy')
            copyfile(f1,f2,'f');
            showinfo2('copy&rename',f2);
        elseif strfind(p.copyoption, 'rename file')
            movefile(f1,f2,'f');
            showinfo2('renamed',f2);
        elseif strfind(p.copyoption, 'simulate')
            disp(['source:' f1]);
            disp(['target:' f2]);
        end
    end
end
disp('DONE!');

function cb_misc(e,e2,task)
hf=findobj(0,'tag','renameDWIfiles');
if strcmp(task,'close')
    close(hf);
elseif strcmp(task,'help')
    uhelp([mfilename '.m']);
elseif strcmp(task,'openAnimalDir')
    v=get(gcf,'userdata');
    hb=findobj(gcf,'tag','lb1');
    explorer(fullfile(v.padat,hb.String{hb.Value}));
end

