

function cleanmask(file,varargin)

if 0
   cleanmask('F:\data5\nogui\dat\anna_issue\_msk.nii','arg',1) 
end

%% ===============================================

p.dim=3;
p.axpos=[.2 0 .8 .9];

if nargin>1
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2)
    p=catstruct2(p,pin)
end

p.file=file;

%% ===============================================

makegui(p)


return

%% ===============================================
% ==============================================
%%   make gui
% ===============================================

function makegui(p)


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
set(hb,'position',[ 0.001 .6 .5 .05 ]);
set(hb,'string',dimstr,'value',p.dim);
set(hb,'callback',@changeDim);

%% =======[delete slice]========================================
hb=uicontrol(hp,'style','radio','units','norm','tag','deleteslice','value',0);
set(hb,'position',[ 0.001 .5 .75 .05 ]);
set(hb,'string','delete Slice','backgroundcolor','w');
set(hb,'callback',@deleteslice);
%% =======[save]========================================
hb=uicontrol(hp,'style','togglebutton','units','norm','tag','save','value',0);
set(hb,'position',[ 0.001 .0001 .5 .05 ]);
set(hb,'string','save');
set(hb,'callback',@saveimg);


p.ha=ha;
p.a  =a;
p.abk=a;
p.a2 =a2;
p.a2orig =a2;
p.aslide=aslide;
p.aslide2=aslide2;

% set(hp,'units','pixels');
set(hf,'userdata',p);
% addResizebutton(gcf,gca,'mode','L','moo',1);

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
% hf=findobj(0,'tag','cleanmask')
% u=get(hf,'userdata');


function btndown(e,e2)

if get(findobj(gcf,'tag','deleteslice'),'value')==1
    hf=findobj(0,'tag','cleanmask');
    u=get(hf,'userdata');
    
    co=get(gca,'CurrentPoint');
    co=round(co(1,1:2));
    slicenum=u.aslide2(co(2),co(1))
    
    %-----------------------------
    
    dimorder=[setdiff(1:3, u.dim) u.dim]
    
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



