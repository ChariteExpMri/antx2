
%% #ok cleanmask: manually remove slices or tissue parts
% cleanmask(file,varargin)
% 
%  #Yk    [1] ___ HOW TO WORK WITH THE GUI ___        
% #k [1] select from [dim]-pulldownMenu the proper view
% #k [2a] to CLEAR a slice: select [delete slice]-radio
%     if set to [x]: 
%     Click onto a slice to remove the slice (replaced by zeros)
%     Click onto same slice agaon to recover the slice
% #k [2b] to REMOVE specific tissue parts or keep specific tissue parts
%    select [remove tissue]-radio
%     if set to [x]:
%   click onto a slice to manipulate the slice. This slice will pop-up in another window
%   #k IN the occuring #yg "removeTissue"-window:  
%    #b -select the specific drawing tool (freehand, polygon, rectangle, ellipse)
%       #o ... shortcut: [1], [2], [3] or [4]
%    #b - hit [new selection]-button to draw a specific ROI
%     -now draw the ROI
%      #o draw ROI:  shortcut: [s]
%      #o to quit/diable selection use shortcut [q]
%    -when ROI is finished  hit either:
%    #b  [remove this]-BTN: to remove tissue inside the ROI...or ..
%           #o ... shortcut: [r]
%    #b  [keep this]-BTN: to keep tissue inside the ROI and remove tissue outside ROI
%           #o ... shortcut: [k]
%        -here the respective pixels will be set to "ZERO"
%   #b use history-buttons [&#60] or [&#62] to undo/redo steps
%         #o ... shortcuts: ctrl+left/rightarrow
%   #b click [submit&close]-BTN  to submit the slice to the cleanmask-window
% 
% #k [3] to SAVE the file: select [SAVE]-BTN
%   -enter filename when asked 
% #k [4] to CLOSE the GUI select [CLOSE]-BTN
% 
% #Yk    [2] ___ COMMANDLINE ___
%  cleanmask(file,varargin)
%  cleanmask()  %  gui opens to ask for image to load
%  cleanmask(file) % NIFTI-file to load (example '_msk.nii')
%  cleanmask(file, varargin) % optional pairwise inputs
% cleanmask([], varargin) % gui ask for file + optional pairwise inputs
% 
%% optional pairwise inputs:
% wait, [0/1]  : let the GUI wait (busy mode); default: 1
% dim, [1/2/3] : dimension to display;  default: 3
% 
% 
% 
% 

function cleanmask(file,varargin)

if 0
    %    cleanmask('F:\data5\nogui\dat\sus_20220215NW_ExpPTMain_009938\_msk.nii','arg',1)
    cleanmask('F:\data5\nogui\dat\sus_20220215NW_ExpPTMain_009938\_msk__orig.nii','arg',1)
end

% ==============================================
%%   
% ===============================================
if exist('file')==1 && exist(file)==2
    % OK...fine... file exist
else
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select NIFTI-file to open ');
    if isnumeric(fi); return; end
    file=fullfile(pa,fi);
    
end


%% ===============================================
p.wait=0;
p.dim =3;
p.axpos=[.2 0 .8 .9];

if nargin>1
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct2(p,pin);
end
[pa fi ext]=fileparts(file);
if isempty(pa); 
    pa=pwd; 
    file=fullfile(pa,[fi ext]);
end

p.file=file;

%% ===============================================
if p.wait==1
    disp(['loading file..busy']);
else
    disp(['loading file..']);
end

hf=makegui(p);
if p.dim~=3
    changeDim([],[])
end
if p.wait==1
    uiwait(gcf);
end

return

%% ===============================================
% ==============================================
%%   make gui
% ===============================================

function hf=makegui(p)


[ha a]=rgetnii(p.file);
% a(181:200,:,:)=0;%test
[a2 si]=montageout(permute(a,[1 2 4 3]));
hl=1:size(a,1):size(a,1)*(si(1)+0);
hv=1:size(a,2):size(a,2)*(si(2)+0);

d(1,1,1:size(a,3))=1:size(a,3);
aslide=repmat(d,[size(a,1) size(a,2) 1]);
[aslide2 ]=montageout(permute(aslide,[1 2 4 3]));

delete(findobj(0,'tag','cleanmask'));
figure
hf=gcf;
set(hf,'menubar','none','tag','cleanmask','color','w');
set(hf,'numbertitle','off','name','cleanmask');
hi=imagesc(imadjust(mat2gray(a2)));
hold on;
vline(hv,'color','w');
hline(hl,'color','w');
[pa fi ext]=fileparts(p.file);
ht=title({
    ['file: ' [fi ext]];
    ['path: ' pa];
    },'fontsize',6);
set(ht,'ButtonDownFcn',@cb_title)
set(gca,'position',p.axpos);
axis off;

set(gca,'ButtonDownFcn',@btndown);
him=findobj(gca,'type','image');
set(him,'ButtonDownFcn',@btndown);
% ==============================================
%%   panel
% ===============================================
hp=uipanel(gcf,'units','norm','tag','pan1');
set(hp,'position',[0 0 .2 1 ],'backgroundcolor','w');

%% =======[dim]========================================
dimstr={'dim1' 'dim2' 'dim3'};
hb=uicontrol(hp,'style','popupmenu','units','norm','tag','changeDim');
set(hb,'position',[0.011 0.9025 0.5 0.05]);
set(hb,'string',dimstr,'value',p.dim);
set(hb,'callback',@changeDim);
set(hb,'tooltipstring',[ 'dimension to display']);


%% =======[RB delete slice]========================================
hb=uicontrol(hp,'style','radio','units','norm','tag','deleteslice','value',0);
set(hb,'position',[ 0.001 .5 .75 .05 ]);
set(hb,'string','delete Slice','backgroundcolor','w');
set(hb,'callback',@deleteslice);
set(hb,'tooltipstring',[ '<html><b>delete slice</b><br> [x] click onto a slice to remove slice, click again to restore slice ']);

%% =======[RB remove tissue]========================================
hb=uicontrol(hp,'style','radio','units','norm','tag','removetissue','value',0);
set(hb,'position',[0.006 0.556 0.8 0.05]);
set(hb,'string','remove tissue','backgroundcolor','w');%[1.0000    0.9490    0.8667]);
set(hb,'callback',@removetissue);
set(hb,'tooltipstring',[ '<html><b>remove tissue</b><br> [x] click onto a slice to remove tissue parts ']);


% set(hb,'value',1);

%% =======[help]========================================
hb=uicontrol(hp,'style','push','units','norm','tag','help1','value',0);
set(hb,'position',[0.694 0.946 0.3 0.05]);
set(hb,'string','help');
set(hb,'callback',@help1);
set(hb,'tooltipstring',[ 'get some help']);


%% =======[save]========================================
hb=uicontrol(hp,'style','togglebutton','units','norm','tag','save','value',0);
set(hb,'position',[ 0.001 .0001 .5 .05 ]);
set(hb,'string','save');
set(hb,'callback',@saveimg);
set(hb,'tooltipstring',[ 'save image (GUI)...you will be ask to specify the filename']);

%% =======[close]========================================
hb=uicontrol(hp,'style','togglebutton','units','norm','tag','closefig','value',0);
set(hb,'position',[0.501 -0.0004 0.5 0.05]);
set(hb,'string','close');
set(hb,'callback',@closefig);
set(hb,'tooltipstring',[ 'close GUI']);

p.ha=ha;
p.a  =a;
p.abk=a;
p.a2 =a2;
p.a2orig =a2;
p.aslide=aslide;
p.aslide2=aslide2;

set(hp,'units','pixels');
set(hf,'userdata',p);
% addResizebutton(gcf,gca,'mode','L','moo',1);
set(gcf,'SizeChangedFcn',@resizefig)

% function removetissue(e,e2)
% hf=findobj(0,'tag','cleanmask');
% u=get(hf,'userdata');
% h2=figure('units','norm','tag','figremovetissue','color','w')

function cb_title(e,e2)
'w'

function help1(e,e2)
uhelp([mfilename '.m']);
function closefig(e,e2)
close(gcf);

function resizefig(e,e2)
%% ===============================================

hf=findobj(0,'tag','cleanmask');
hax=findobj(hf,'type','axes');
hp =findobj(hf,'tag','pan1');

uf=hf.Units;
uax=hax.Units;
up =hp.Units;

hf.Units ='pixels';
hax.Units='pixels';
hp.Units ='pixels';

fpos=hf.Position;
apos=hax.Position;
ppos=hp.Position;

apos2=[  ppos(3)+1  apos(2)   fpos(3)-(ppos(3)+1)  apos(4) ];
hax.Position=apos2;

hf.Units =uf;
hax.Units=uax;
hp.Units =up;



%% ===============================================


function changeDim(e,e2)
hf=findobj(0,'tag','cleanmask');
u=get(hf,'userdata');
hd=findobj(gcf,'tag','changeDim');
dim=hd.Value;
u.dim=dim;

dimorder=[setdiff([1:3],dim) dim];
ax=permute(u.a,dimorder);
[a2 si]=montageout(permute(ax,[1 2 4 3]));
hl=1:size(ax,1):size(ax,1)*(si(1)+0);
hv=1:size(ax,2):size(ax,2)*(si(2)+1);


d(1,1,1:size(ax,3))=1:size(ax,3);
aslide=repmat(d,[size(ax,1) size(ax,2) 1]);
[aslide2 ]=montageout(permute(aslide,[1 2 4 3]));
u.aslide2=aslide2;

set(hf,'userdata',u);

him=findobj(gca,'type','image');
him.CData=imadjust(mat2gray(a2));
delete(findobj(gca,'type','line'));
hold on;
vline(hv,'color','w');
hline(hl,'color','w');
set(gca,'position',u.axpos);

function saveimg(e,e2)
hf=findobj(0,'tag','cleanmask');
u=get(hf,'userdata');
[fi pa]=uiputfile(u.file, 'save image as');
if isnumeric(fi); return; end
f1=fullfile(pa,fi);

rsavenii(f1,u.ha,u.a);
showinfo2('saved Image',f1);





function deleteslice(e,e2)
hf=findobj(0,'tag','cleanmask');
u=get(hf,'userdata');
set(findobj(hf,'tag','removetissue'),'value',0);

function removetissue(e,e2)
hf=findobj(0,'tag','cleanmask');
u=get(hf,'userdata');
set(findobj(hf,'tag','deleteslice'),'value',0);

% ==============================================
%%   
% ===============================================

function btndown(e,e2)

if get(findobj(gcf,'tag','deleteslice'),'value')==1
    hf=findobj(0,'tag','cleanmask');
    u=get(hf,'userdata');
    
    co=get(gca,'CurrentPoint');
    co=round(co(1,1:2));
    slicenum=u.aslide2(co(2),co(1));
    
    %-----------------------------
    
    dimorder=[setdiff(1:3, u.dim) u.dim];
    
    if u.dim==1
        val=u.a(slicenum,:,:); val=sum(val(:));
        if val==0;             u.a(slicenum,:,:) =u.abk(slicenum,:,:);
        else;                  u.a(slicenum,:,:) =0;
        end
    elseif u.dim==2
        val=u.a(:,slicenum,:); val=sum(val(:));
        if val==0;             u.a(:,slicenum,:) =u.abk(:,slicenum,:);
        else;                  u.a(:,slicenum,:) =0;
        end
    elseif u.dim==3
        val=u.a(:,:,slicenum); val=sum(val(:));
        if val==0;             u.a(:,:,slicenum) =u.abk(:,:,slicenum);
        else;                  u.a(:,:,slicenum) =0;
        end
    end
    
    set(hf,'userdata',u);
    
    dimorder=[setdiff(1:3, u.dim) u.dim];
    ax=permute(u.a,dimorder);
    [a2 si]=montageout(permute(ax,[1 2 4 3]));
    him=findobj(gca,'type','image');
    him.CData=imadjust(mat2gray(a2));
    
end
% ==============================================
%%
% ===============================================

if get(findobj(gcf,'tag','removetissue'),'value')==1
    hf=findobj(0,'tag','cleanmask');
    u=get(hf,'userdata');
    hf=findobj(0,'tag','cleanmask');
    u=get(hf,'userdata');
    
    co=get(gca,'CurrentPoint');
    co=round(co(1,1:2));
    slicenum=u.aslide2(co(2),co(1));
    
    if u.dim==1
        b= squeeze(u.a(slicenum,:,:));
    elseif u.dim==2
        b= squeeze(u.a(:,slicenum,:));
    elseif u.dim==3
        b= squeeze(u.a(:,:,slicenum));
    end
    
    %% ====controls===========================================
    delete(findobj(0,'tag','fig_removetissue'));
    h2=figure('units','norm','tag','fig_removetissue','color','w','name','removeTissue');
    imagesc(b);
    axis off;
    title(['slice: ' num2str(slicenum)],'fontsize',8);
    u2.b  =b;
    u2.bbk=b;
    u2.hist=b;
    u2.histstep=1;
    u2.slicenum=slicenum;
    set(h2,'userdata',u2);
    set(h2,'WindowKeyPressFcn', @keys_deletetissue);
    % ====controls===========================================
    
    
    % ===============[selection]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','new selection','tag','newselection','callback',{@cb_removetissue,'newselection'})
    set(hb,'position',[0 0.60357 0.13 0.08],'backgroundcolor',[ 0.8706    0.4902         0]);
    set(hb,'tooltipstring',['<html><b>select a region by drawing a ROI</b>'...
        '<br>[s]-shortcut to draw a region'...
        '<br>[q]-shortcut to quit/cancel selection']);
    % ===============[selection-type]================================
    seltype={'imfreehand' 'impoly' 'imrect' 'imellipse'};
    hb=uicontrol('style','pop','units','norm','value',1);
    set(hb,'units','norm','string',seltype,'tag','seltype');
    set(hb,'position',[0 0.64643 0.13 0.08]);
    set(hb,'tooltipstring',['<html><b>select drawing tool</b><br>shortcuts: [1],[2],[3],[4]']);

    % ===============[hisstmsg]================================
    hb=uicontrol('style','text','units','norm');
    set(hb,'string','step-1','tag','histmsg')
    set(hb,'position',[[0.032143 0.053571 0.1 0.05]],'backgroundcolor','w');
   set(hb,'tooltipstring',['<html><b>history step']);

    % ===============[histback]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','<','tag','histback','callback',{@cb_removetissue,'histback'})
    set(hb,'position',[[0.032143 0.017857 0.05 0.05]]);
    set(hb,'tooltipstring',['<html><b>go backward in history</b><br>ctrl+[leftarrow]-shortcut']);

    % ===============[hisstforw]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','>','tag','histforw','callback',{@cb_removetissue,'histforw'})
    set(hb,'position',[[0.080357 0.017857 0.05 0.05]]);
    set(hb,'tooltipstring',['<html><b>go forward in history</b><br>ctrl+[rightarrow]-shortcut']);
    
    
    % ===============[removethis]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','remove this','tag','removethis','callback',{@cb_removetissue,'removethis'})
    set(hb,'position',[[0.016071 0.43452 0.10714 0.047619]]);
    set(hb,'tooltipstring',['<html><b>remove tissue within selected region</b><br>[r]-shortcut']);
    set(hb,'backgroundcolor',[ 1 1 0]);
    
    % ===============[keepthis]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','keep this','tag','keepthis','callback',{@cb_removetissue,'keepthis'})
    set(hb,'position',[0.016071 0.38214 0.10714 0.047619]);
    set(hb,'tooltipstring',['<html><b>keep only tissue within selected region, remove rest</b><br>[k]-shortcut']);
    set(hb,'backgroundcolor',[ 1 1 0]);
    
    
    % ===============[submit]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','submit & close','tag','submitNclose','callback',{@cb_removetissue,'submitNclose'})
    set(hb,'position',[0.5 0 0.15 0.055],'backgroundcolor',[ 0.7569    0.8667    0.7765]);
    set(hb,'tooltipstring',['<html><b>submit slice and close figure</b>']);
    % ===============[close]================================
    hb=uicontrol('style','push','units','norm');
    set(hb,'string','close','tag','close','callback',{@cb_removetissue,'close'})
    set(hb,'position',[0.35 0 0.15 0.055],'backgroundcolor',[ 0.8627    0.8627    0.8627]);
    set(hb,'tooltipstring',['<html><b>close figure</b><br>submit nothing!']);
    
    

    removetissue_enabelcontrols(0)
    %% ===============================================
end

%% ===============================================

function removetissue_enabelcontrols(arg)
h2=findobj(0,'tag','fig_removetissue');
if arg==1
    set(findobj(h2,'tag','removethis'),'enable','on','backgroundcolor',[ 1 1 0]);
    set(findobj(h2,'tag','keepthis'),'enable','on'  ,'backgroundcolor',[ 1 1 0]);
else
    set(findobj(h2,'tag','removethis'),'enable','off','backgroundcolor',[ 0.8627    0.8627    0.8627]);
    set(findobj(h2,'tag','keepthis'),'enable','off'  ,'backgroundcolor',[ 0.8627    0.8627    0.8627]);
end

function keys_deletetissue(e,e2)
% e
% e2
h2=findobj(0,'tag','fig_removetissue');

if strcmp(e2.Modifier,'control')
    if strcmp(e2.Key,'leftarrow')
        cb_removetissue([],[],'histback');
    elseif strcmp(e2.Key,'rightarrow')
        cb_removetissue([],[],'histforw');
    end
else
    
    if strcmp(e2.Key,'s')
        cb_removetissue([],[],'newselection');
    elseif strcmp(e2.Key,'r')
        cb_removetissue([],[],'removethis');
    elseif strcmp(e2.Key,'k')
        cb_removetissue([],[],'keepthis');
    elseif strcmp(e2.Key,'1') || strcmp(e2.Key,'2') || strcmp(e2.Key,'3') || strcmp(e2.Key,'4')
        hb=findobj(h2,'tag','seltype');
        hb.Value=str2num(e2.Key);
    elseif strcmp(e2.Key,'q')
       cb_removetissue([],[],'removeROI'); 
    end
end


function cb_removetissue(e,e2,task)
h2=findobj(0,'tag','fig_removetissue');
hax=findobj(h2,'type','axes');
u2=get(h2,'userdata');
figure(h2);
if strcmp(task,'close')
    close(h2);
elseif strcmp(task,'submitNclose')
    him=findobj(hax,'type','image');
    x=him.CData;
    
    slicenum=u2.slicenum;
    
    hf=findobj(0,'tag','cleanmask');
    u=get(hf,'userdata');
    if u.dim==1
        u.a(slicenum,:,:)=x;
    elseif u.dim==2
        u.a(:,slicenum,:)=x;
    elseif u.dim==3
        u.a(:,:,slicenum)=x;
    end
    set(hf,'userdata',u);
    
    close(h2);
    
    dimorder=[setdiff(1:3, u.dim) u.dim];
    ax=permute(u.a,dimorder);
    [a2 si]=montageout(permute(ax,[1 2 4 3]));
    hax2=findobj(hf,'type','axes');
    him2=findobj(hax2,'type','image');
    him2.CData=imadjust(mat2gray(a2));
    
    
    
elseif strcmp(task,'newselection')
    hs=findobj(h2,'tag','seltype');
    delete(findobj(h2,'type','hggroup'));
    drawstr=hs.String{hs.Value};
    eval(['h=' drawstr '(hax);']);
    u2.h=h;
    set(h2,'userdata',u2);
 
    removetissue_enabelcontrols(1);
    
elseif strcmp(task,'removethis') || strcmp(task,'keepthis')
    %% ===============================================
    if isfield(u2,'h')==0; return; end
    co=round(u2.h.getPosition());
    %ms = roipoly(size(u2.b,1),size(u2.b,2),co(:,1),co(:,2));
    ms=createMask(u2.h);
   
%     
%     api=iptgetapi(u2.h);
%     vert=api.getVertices();
%     m=poly2mask(co(:,1),co(:,2), size(u2.b,1),size(u2.b,2));
%     
    
    him=findobj(hax,'type','image');
    b=him.CData;
    if strcmp(task,'removethis');
        b(ms)=0;
    else
        b(~ms)=0;
    end
    him.CData=b;
    
    try; delete(u2.h);       end
    try; u2=rmfield(u2,'h'); end
    
    if isfield(u2,'hist')==0
        u2.hist=u2.bbk;
    end
    u2.histstep=u2.histstep+1;
    u2.hist(:,:,u2.histstep)=b;
    u2.hist(:,:,u2.histstep+1:end)=[];
    
    set(h2,'userdata',u2);
    set(findobj(h2,'tag','histmsg'),'string',['step-' num2str(u2.histstep)]);
    
    removetissue_enabelcontrols(0);
    
elseif strcmp(task,'removeROI')
    
     try; delete(u2.h);       end
    try; u2=rmfield(u2,'h'); end
    removetissue_enabelcontrols(0);
    %% ===============================================
elseif strcmp(task,'histback') || strcmp(task,'histforw')
    if u2.histstep==1 && strcmp(task,'histback')
        hb=findobj(h2,'tag','histback');
        col=get(hb,'backgroundcolor');
        set(hb,'backgroundcolor',[0.9294    0.6941    0.1255]); drawnow;
        set(hb,'backgroundcolor',col);
        for i=1:2
            set(hb,'backgroundcolor',[0.9294    0.6941    0.1255]); pause(.1);drawnow;
            set(hb,'backgroundcolor',col);drawnow;
        end
        return
    end
    if u2.histstep>=size(u2.hist,3) && strcmp(task,'histforw')
        hb=findobj(h2,'tag','histforw');
        col=get(hb,'backgroundcolor');
        for i=1:2
            set(hb,'backgroundcolor',[0.9294    0.6941    0.1255]); pause(.1);drawnow;
            set(hb,'backgroundcolor',col);drawnow;
        end
        return
    end
    if strcmp(task,'histback')
        u2.histstep=u2.histstep-1;
    else
        u2.histstep=u2.histstep+1;
    end
    him=findobj(hax,'type','image');
    him.CData=u2.hist(:,:,u2.histstep);
    set(h2,'userdata',u2);
    set(findobj(h2,'tag','histmsg'),'string',['step-' num2str(u2.histstep)]);
    
end





