
% #yk ___Usage___
% The panel depict: 
%     left: the input image
%   middle: the contour lines on top of the input image
%    right: output image, i.e. the mask that can be forwarded to the slice of xdraw.m
% step-1) move the the green vertical bar to left/right to change the contourlines
%  For example if the slice contain a lesion: adjust the contourlines that they match the boundary 
%  of the lesion.
% step-2) click into the area of an enclosed contour. This area will appear in the right image.
% Steps (1) and (2) can be done multiple times, for example in case of ROIs (multiple lesions).
% 
% [median filter]  - when radio is checked, the order of the median filter can be changed to change 
%                    the behaviour of the contourlines
% [ID]             - numeric value of the mask of the right image
%                  - change ID before doing step-2
%                  - for multiple ROIs multiple IDs can be used
% [clear] -clear mask
% [inv]   -invert mask
% [rem]   -remove ROI from mask (see toolip fo usage)
% [rMan]  -manually remove region/ROI by drawing tool (see toolip fo usage)
% [cID]   -change ID/value of region/ROI (see toolip fo usage)
% [cbar]  -show/hide toolbar
% 
% 
% #yk ___CMDLINE___
% [msk]=threshtool(sa,struct('medfilt',1,'tr',.6));
% INPUT:
% img: 2d-slice


function [msk]=threshtool(img,param)
% clc
warning off;
if 0
    sa=evalin('base','sa');
end
if exist('param')==0; param=[];end
if isempty(param)
   param=struct(); 
end

% ----external----
u.sa=img;
u.cmap=parula;
u.tr=0.5;
u.medfilt=0;
u.id=1;
u.medfiltlength=3;
u.linwid=.02;
u.showcontour =1;
u.wait =      1;
u.msk = [];

u=paramadd(u,param);

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————
 f = fieldnames(param);
 for i = 1:length(f)
    u.(f{i}) = param.(f{i});
 end


% ----internal----
u.butstate=0  ; % buttonDownState
u.isOK = 0;
if isempty(u.msk)
    u.maskout=zeros(size(u.sa));
else
    u.maskout=u.msk;
end

u.maskin=u.maskout;

% -----
makeFig(u);
makeAxes();
defineSlider();
updateMaskPan2();
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————
if u.wait==1
    uiwait(gcf)
end
% ----------------------------------
msk=[];
u=get(gcf,'userdata');
if isempty(u); msk=[]; return; end

if u.isOK==1
    hf =findobj(gcf,'tag','ax4');
   him=findobj(hf,'type','image');
  msk=  get(him,'cdata');
end

if u.wait==1
close(gcf);
end



%———————————————————————————————————————————————
%%   
function makeFig(u)

% ==============================================
%%   
% ===============================================

delete(findobj(0,'tag','threshtool'));
fg;
set(gcf,'visible','off');
set(gcf,'menubar','none','tag','threshtool','name','threshTool','NumberTitle','off');
% h1=axes('position',[0 .4 .4 .4]);
% set(h1,'position',[0 .45 .5 .5],'tag','ax1');; axis off;
% h2=axes('position',[0 .4 .4 .4]);
% set(h2,'position',[.5 .45 .5 .5],'tag','ax2'); axis off;
% h3=axes('position',[0 .2 1 .2]);
% set(h3,'position',[0.05 .24 .9 .2],'tag','ax3'); axis off; 
% set(h3,'fontsize',8,'fontweight','bold');

h1=subplot(2,2,1);
h2=subplot(2,2,2);
h4=subplot(2,2,3); 
h3=subplot(2,2,4);

% h1=axes(); h2=axes(); h4=axes();
% h3=axes();

set(h1,'position',[ 0   .45 .333 .5],'tag','ax1');; axis off;
set(h1,'xTickLabel',[],'yTickLabel',[]);
set(h2,'position',[.333 .45 .333 .5],'tag','ax2'); axis off;
set(h2,'xTickLabel',[],'yTickLabel',[]);
set(h4,'position',[.666 .45 .333 .5],'tag','ax4'); axis off;
set(h4,'xTickLabel',[],'yTickLabel',[]);
set(h3,'position',[0.05 .24 .9 .17],'tag','ax3'); axis on;


set(h3,'fontsize',8,'fontweight','bold');



u.h1=h1;
u.h2=h2;
u.h3=h3;
u.h4=h4;
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn',@thresh_moving);
set(gcf,'WindowButtonDownFcn'  ,{@thresh_figbut,1});
set(gcf,'WindowButtonUpFcn'    ,{@thresh_figbut,0});
% drawnow;
set(u.h1,'tag','ax1');
set(u.h2,'tag','ax2');
set(u.h3,'tag','ax3');

%contour
hp=uicontrol('style','radio','units','norm','string','contour');
set(hp,'position' ,[0.5    0.1    0.1071    0.0476],'backgroundcolor','w');
set(hp,'tooltipstring',['show [0] mask or [1] contour']);
set(hp,'tag','showContour','callback',@showContour, 'value',u.showcontour);
% FILTER
hp=uicontrol('style','radio','units','norm','string','median filter');
set(hp,'position' ,[0.0339    0.1    0.15    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['median-filter [0] no [1] yes']);
set(hp,'tag','do_medfilt','callback',@do_medfilt,'value',u.medfilt);

hp=uicontrol('style','edit','units','norm','string','3');
set(hp,'position' ,[0.18    0.1    0.05    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['median-filter length']);
set(hp,'tag','thresh_filtlen','callback',@do_medfilt,'value',u.medfiltlength);

% ID
hp=uicontrol('style','text','units','norm','string','ID');
set(hp,'position' ,[0    0    0.05    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['ID, value to assign for mask']);
set(hp,'tag','ID_txt');

hp=uicontrol('style','edit','units','norm','string','3');
set(hp,'position' ,[0.05    0    0.05    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['ID, numeric value to assign for mask']);
 set(hp,'tag','id_ed','string',num2str(u.id));
% set(hp,'tag','id_ed','callback',@id_cb,'string',num2str(u.id));


% %% CLEAR
% hp=uicontrol('style','pushbutton','units','norm','string','clear');
% set(hp,'position' ,[0.9    0.15    0.08    0.05],'backgroundcolor','w');
% set(hp,'tooltipstring',['clear output']);
% set(hp,'tag','clearMask','callback',@clearMask);
%% SUBMIT
hp=uicontrol('style','pushbutton','units','norm','string','Done');
set(hp,'position' ,[0.9    0.05    0.08    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['done...submit mask']);
set(hp,'tag','thresh_done','callback',{@thresh_done,'ok'} );
%% CANCEL
hp=uicontrol('style','pushbutton','units','norm','string','Cancel');
set(hp,'position' ,[0.82    0.05    0.08    0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['cancel']);
set(hp,'tag','thresh_cancel','callback',{@thresh_done,'cancel'});

%% Help
hp=uicontrol('style','pushbutton','units','norm','string','Help');
set(hp,'position' ,[0.46607 0.0035714 0.08 0.05],'backgroundcolor','w');
set(hp,'tooltipstring',['get some help']);
set(hp,'tag','thresh_cancel','callback',{@xhelp});

set(findobj(gcf,'type','axes'),'fontsize',7,'fontweight','bold');

%% ===============================================
%% CLEAR
hp=uicontrol('style','pushbutton','units','norm','string','clear');
set(hp,'position' ,[0.675 0.40833 0.05 0.04],'backgroundcolor','w');
set(hp,'tooltipstring',['clear mask']);
set(hp,'callback',{@cmenuCB_output,'clear'},'fontsize',7);
% 
hp=uicontrol('style','pushbutton','units','norm','string','inv');
set(hp,'position' ,[ 0.7250 0.40833 0.05 0.04],'backgroundcolor','w');
set(hp,'tooltipstring',['invert mask']);
set(hp,'callback',{@cmenuCB_output,'invert'},'fontsize',7);
% 
hp=uicontrol('style','pushbutton','units','norm','string','rem');
set(hp,'position' ,[0.7750 0.40833 0.05 0.04],'backgroundcolor','w');
set(hp,'tooltipstring',['remove ROI:' char(10) ...
    'click onto ROI to remove this ROI']);
set(hp,'callback',{@cmenuCB_output,'removeThis'},'fontsize',7);
% 
hp=uicontrol('style','pushbutton','units','norm','string','rMan');
set(hp,'position' ,[0.8250 0.40833 0.05 0.04],'backgroundcolor','w');
set(hp,'tooltipstring',['remove manually:' char(10) ...
     'draw region to remove ...than double-click into region']);
set(hp,'callback',{@cmenuCB_output,'manuallyRemove'},'fontsize',7);


hp=uicontrol('style','pushbutton','units','norm','string','cID');
set(hp,'position' ,[0.8750 0.40833 0.05 0.04],'backgroundcolor','w');
set(hp,'tooltipstring',['change ID/Value:' char(10) ...
     'click onto region/ROI to change the ID/value']);
set(hp,'callback',{@cmenuCB_output,'changeValue'},'fontsize',7);

% m1 = uimenu(c,'Label','clear image/Mask','Callback',{@cmenuCB_output,'clear'});
% m1 = uimenu(c,'Label','invert Mask','Callback',{@cmenuCB_output,'invert'});
% m1 = uimenu(c,'Label','remove a local region (via ginput)','Callback',{@cmenuCB_output,'removeThis'});
% m1 = uimenu(c,'Label','manually remove part','Callback',{@cmenuCB_output,'manuallyRemove'});


hp=uicontrol('style','pushbutton','units','norm','string','cbar');
set(hp,'position' ,[0.95536 0.40833 0.05 0.04],'backgroundcolor',[0.8941    0.9412    0.9020]);
set(hp,'tooltipstring',['show/hide colorbar:' char(10) ...
     ' ...usefull to check Ids/values']);
set(hp,'callback',{@cmenuCB_output,'showColorbar'},'fontsize',7);

%% ===============================================


% drawnow;


% function id_cb(e,e2)
% u=get(gcf,'userdata');
% hb=findobj(gcf,'tag','id_ed');
% u.id=str2num(get(hb,'string'));
% set(gcf,'userdata',u);
function xhelp(e,e2)
uhelp([mfilename '.m']);


function thresh_done(e,e2, status)
u=get(gcf,'userdata');
u.isOK=0;
if strcmp(status,'ok')
    u.isOK=1;
end
set(gcf,'userdata',u);
uiresume(gcf);


function do_medfilt(e,e2)
u=get(gcf,'userdata');
hmed=findobj(gcf,'tag','do_medfilt');
hlen=findobj(gcf,'tag','thresh_filtlen');

u.medfilt       =get(hmed,'value') ; 
u.medfiltlength =str2num(get(hlen,'string')) ; 
set(gcf,'userdata',u);

 makeAxes();
% defineSlider();
updateMaskPan2();
% updateSlider


function cmenuCB_create()
u=get(gcf,'userdata');
ax=findobj(gcf,'tag','ax4');
him=findobj(ax,'type','image');
c = uicontextmenu;
him.UIContextMenu = c;
% Create menu items for the uicontextmenu
m1 = uimenu(c,'Label','clear image/Mask','Callback',{@cmenuCB_output,'clear'});
m1 = uimenu(c,'Label','invert Mask','Callback',{@cmenuCB_output,'invert'});
m1 = uimenu(c,'Label','remove a local region (via ginput)','Callback',{@cmenuCB_output,'removeThis'});
m1 = uimenu(c,'Label','manually remove part','Callback',{@cmenuCB_output,'manuallyRemove'});
m1 = uimenu(c,'Label','change value (ID)','Callback',{@cmenuCB_output,'changeValue'});

m1 = uimenu(c,'Label','show Colorbar','Callback',{@cmenuCB_output,'showColorbar'});
% m2 = uimenu(c,'Label','dotted','Callback',@context,'invert');
% m3 = uimenu(c,'Label','solid','Callback',@context,'invert');

function cmenuCB_output(e,e2,par)
hf=findobj(0,'tag','threshtool');
u=get(gcf,'userdata');

ax4=findobj(gcf,'tag','ax4');
im4=findobj(ax4,'type','image');
d=get(im4,'cdata');
if strcmp(par,'clear')
    d3=zeros(size(d));
    set(im4,'cdata', d3);          u.maskout=d3;
elseif strcmp(par,'invert')
    if length(unique(d))<3
    d3=~d;
    else
       d3=d-1;
       d3(d3==-1)=max(unique(d3))+1;
    end
    set(im4,'cdata', d3);          u.maskout=d3;
elseif strcmp(par,'removeThis') || strcmp(par,'changeValue')
    
    axes(ax4)
    co=ginput(1); co=round(co);
   
    if strcmp(par,'removeThis')
        d2=bwlabeln(d);
        d2=d2.*(d==d(co(2),co(1)));
        d3=d;
        val=0;
        d3(d2~=0)=val;
    
    
    elseif strcmp(par,'changeValue')
        set(hf,'WindowButtonUpFcn'    ,[]);
        %% ===============================================
        drawnow;
        prompt = {['Enter new ID/Value (previous value: '  num2str(d(co(2),co(1))) '):' ]};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {num2str(d(co(2),co(1)))};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        if isempty(answer); 
            set(hf,'WindowButtonUpFcn'    ,{@thresh_figbut,0});
            return, end
         A1=(str2num(answer{1}));
         val=d(co(2),co(1));
         if isnumeric(A1);
             val=A1;
         end
         set(hf,'WindowButtonUpFcn'    ,{@thresh_figbut,0});
         %% ===============================================
          d2=bwlabeln(d);
          d2==d2(co(2),co(1));
          v1=d2==d2(co(2),co(1));
          v2=d2~=d2(co(2),co(1));
          d3=v2.*d+(v1*val);
        
        %% ===============================================
    end
   
    
%     invm=~(d2==d2(co(2),co(1)));
%     d3=d.*invm;
    set(im4,'cdata', d3);          u.maskout=d3;
 elseif strcmp(par,'manuallyRemove')
     %% ===============================================
%      set(gcf,'WindowButtonUpFcn'     ,[]);
%      set(gcf,'WindowButtonUpFcn'     ,@freehandstop);
    ax4= findobj(gcf,'tag','ax4');
     axes(ax4);
     h = imfreehand(ax4);
     wait(h);
     try
         bw=createMask(h);
         d3=d;
         d3(bw==1)=0;
         set(im4,'cdata', d3);          u.maskout=d3;
         delete(h);
     end
elseif strcmp(par,'showColorbar')
     ax4= findobj(gcf,'tag','ax4');
     axes(ax4);
     hcbar=findobj(gcf,'tag','colorbar1');
     if isempty(hcbar)
     t = colorbar('peer',gca,'Tag','colorbar1');
     else
         delete(hcbar);
         %colorbar off
     end
end
set(gcf,'userdata',u);





% function freehandstop(e,e2)
% 
% 'sss'
%  delete(findobj(gcf,'userdata','imtool'));


function showContour(e,e2)
u=get(gcf,'userdata');
hb=findobj(gcf,'tag','showContour');
u.showcontour=get(hb,'value')  ;%set(hb,'value', ~get(hb,'value'));
set(gcf,'userdata',u);
updateMaskPan2();

function makeAxes()
u=get(gcf,'userdata');
if u.medfilt==1
    bg=medfilt2(u.sa,[repmat(u.medfiltlength,[1 2]) ],'symmetric');
else
    bg=u.sa;
end
% ----ax1
% s=ind2rgb(round(bg*size(u.cmap,1)),u.cmap);
s=ind2rgb(round(u.sa*size(u.cmap,1)),u.cmap);
axes(u.h1); %axis off;

him1=findobj(u.h1,'type','image');
if isempty(him1);
    image(u.h1,s);
    title('input');
    set(gca,'tag','ax1');
      axis off;
    % ----ax3
    axes(u.h3);
    imhist(bg);
    xlim([0 1]);
    set(gca,'tag','ax3');
%     axis off;
% else
%    set(him1,'cdata',s);   
end


%---ax4
axes(u.h4); 
him4=findobj(u.h4,'type','image');
if isempty(him4);      
    imagesc(u.h4,u.maskin);  
    title('output'); colormap gray;
set(gca,'tag','ax4'); 
 axis off;
cmenuCB_create();
else   ;    
%     set(him4,'cdata',u.maskin); 
end


% set(findobj(gcf,'type','axes'),'fontsize',.1,'fontweight','bold');
% set(u.h3,'fontsize',7,'fontweight','bold');
set(findobj(gcf,'type','axes'),'fontsize',7,'fontweight','bold');


u.bg=bg;
set(gcf,'userdata',u);
%———————————————————————————————————————————————
function defineSlider();
u=get(gcf,'userdata');
wid=u.linwid;%.03
tr=u.tr;
axes(u.h3);
yl=ylim;
hp=patch([tr-wid/2 tr+wid/2 tr+wid/2 tr-wid/2  ],[yl(1) yl(1) yl(2) yl(2)],'r');
set(hp,'facealpha',.5,'edgecolor','none','facecolor',[0 .45 0]);
set(hp,'tag','line');
% set(u.h3,'ButtonDownFcn',@clickThresh);
% set(hp,'ButtonDownFcn',@clickThresh);
 
%———————————————————————————————————————————————
%%   update
%———————————————————————————————————————————————
function updateMaskPan2()
u=get(gcf,'userdata');
u.maskthresh=u.bg>u.tr;
set(gcf,'userdata',u);

axes(u.h2);
him=findobj(u.h2,'type','image');
if isempty(him)
    him=imagesc(u.maskout); colormap(gray); title('segmented');
end
delete(findobj(gca,'type','contour'));
if u.showcontour==0
    set(him,'cdata', u.maskthresh);
else
    set(him,'cdata',u.bg); hold on;
    try
        contour(u.maskthresh,1,'r');
    end
end
set(gca,'xticklabel',[],'yticklabel',[]);
set(gca,'tag','ax2');%,'fontsize',.1);
set(him,'ButtonDownFcn',@submit2outputpanel,'userdata',u.maskout);

function updateSlider()
u=get(gcf,'userdata');
hp=findobj(gcf,'tag','line');
xdat=get(hp,'xdata');
try
shift=u.tr-mean(xdat(1:2));
catch
    shift=0;
end
set(hp,'xdata',[ xdat+shift ]);

function clearMask(e,e2)
u=get(gcf,'userdata');
% ---------------------------
h4=findobj(gcf,'tag','ax4');
him4=findobj(h4,'type','image');
u.maskout=u.maskin ;%u.maskout.*0;

id=unique(u.maskin);

axes(h4);
% him=findobj(u.h2,'type','image');
set(him4,'cdata', u.maskin );
% imagesc(h4,u.maskout);
title('output');
set(h4,'tag','ax4');
set(gcf,'userdata',u);
axis off;
% if length(id)~=1
%     caxis([0 max(id)]);
% else
% %     caxis([0 1]);
% end

function id=getID()
id=str2num(get(findobj(gcf,'tag','id_ed'),'string'));

function submit2outputpanel(e,e2)
u=get(gcf,'userdata');
co=get(gca,'CurrentPoint');
co=round(co(1,1:2));

% return
% ---------------------------
h4=findobj(gcf,'tag','ax4');
him4=findobj(h4,'type','image');
% m=get(him4,'cdata');
m=u.maskthresh;
bn=bwlabeln(m);
m2=bn==bn(co(2),co(1));

% bw2=bwlabeln(m2); %inversion
% m2=bw2==bw2(co(2),co(1));
m2=imclose(m2,strel('disk',1));
m3=m2;
% ---------------------------
maskout=u.maskout;
maskout(m3==1)             =getID() ;  %set ID
u.maskout=maskout;
set(gcf,'userdata',u);

axes(h4);
% imagesc(h4,maskout);
set(him4,'cdata',maskout);
set(h4,'tag','ax4');
axis off;
title('output'); drawnow;


function thresh_moving(e,e2)
if strcmp(get(gcf,'tag'),'threshtool')
    changethreshold('moving');
end

%———————————————————————————————————————————————
%%    moving
%———————————————————————————————————————————————
function changethreshold(par1)

if strcmp(get(gcf,'tag'),'threshtool')==0
   return 
end
try
o=overobj('axes');
ch=get(o,'children');
%  disp(['move: ' num2str(strcmp(get(o,'tag'),'ax3')) ]);
% get(o,'tag')

movelineNow=0;
if strcmp(get(o,'tag'),'ax3')
    movelineNow=1;
% elseif strcmp(get(o,'tag'),'ax3')==1 %isempty(findobj(ch,'tag','line'))==0 || 
%    movelineNow=1 ;
%     disp(['move: ' num2str(strcmp(get(o,'tag'),'ax3')) ]);
% elseif strcmp(get(o,'tag'),'ax2')
%    thresh_submit();
     
end

if movelineNow==0; return; end
u=get(gcf,'userdata');
axes(u.h3);
co=get(gca,'CurrentPoint');
co= (co(1,1:2));
if strcmp(par1,'moving')
    if u.butstate==1
        u.tr=co(1);
        set(gcf,'userdata',u);
        updateMaskPan2();
    end
elseif strcmp(par1,'click')
    u.tr=co(1);
    set(gcf,'userdata',u);
    updateMaskPan2();
end
updateSlider();
% disp(u.tr);
end

function thresh_figbut(e,e2,butstate)
u=get(gcf,'userdata');
% o=overobj('axes');
% if strcmp(get(o,'tag'),'ax2')
%    %thresh_submit();
%    'ys'
%    return 
% end


u.butstate=butstate;
set(gcf,'userdata',u);
if butstate==0
    changethreshold('click');
end

%  butstate
 

 
 
 
 
 
 
 
 
 
 
 
 