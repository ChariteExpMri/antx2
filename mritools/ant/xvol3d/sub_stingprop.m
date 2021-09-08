

% property function for [sub_sting.m]
% see [sub_sting.m] for more information

function sub_stingprop(e,e2)

delete(findobj(0,'tag','stingpop'))
h2=findobj(0,'tag','plotconnections'); %gui-2
us2=get(h2,'userdata');

hf=findobj(0,'tag','xvol3d');
hp=findobj(hf,'tag','connectionlabel');
if isempty(hp)
    msgbox('no connect-labels found');
    return
end

%% ===============================================
pos=[[0.263 0.2 0.3 0.6]];
pos=[[0.7 0.4 0.3 0.6]];


% hk=findobj(0,'tag','plotconnections'); %gui-2
hf=findobj(0,'tag','xvol3d');
figure(hf);
huse=hf;

% frame
hh=uipanel(hf,'units','norm','title','sting prop','tag','stingpop');%,'title' ,'sting properties');
set(hh,'position',[[0.263 0.90071 0.11 0.1]],'backgroundcolor','w');
% uistack(hb,'bottom');
set(hh,'position',pos);

delete(findobj(gcf,'tag','btnmove2'))
Bsize=12;
%-----move
% pos2=[pos(1)+pos(3) pos(3)+pos(4)  .01 .01]
hv=uicontrol('parent',gcf,'style','push','units','norm','string','<html>&#9769;');
set(hv,'fontsize',6,'tag','btnmove2',   'TooltipString','drag me');
set(hv,'position',[pos(1)+pos(3)-.02 pos(2)+pos(4)-.03  .02 .03]);
set(hv,'units','pixels','backgroundcolor',[1 1         0]);
% posx=get(hv,'position');
% pos2=[posx(1)+posx(3)/2-Bsize posx(2)+posx(4)/2 Bsize Bsize];
% set(hv,'position',pos2,'backgroundcolor',[1 1         0]);
set(hv,'units','norm');
hdrag = findjobj(hv);
set(hv,'units','norm');
set(hdrag,'MouseDraggedCallback',{@drag_object,'btnmove2',{'stingpop' } }); %'listFontsizeIncrease'

% return
%% ====linestlye===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','line style');
set(hb,'backgroundcolor',[0.8039    0.8784    0.9686],   'tag' ,'');
set(hb,'position',[0.0072    0.9146    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['needle linestyle']);


ls={  '-'    '--'    ':'    '-.'    'none'  };
hb=uicontrol(hh,'style','popupmenu','units','norm',  'string',ls,'value', find(strcmp(ls,us2.sting.linestyle)));
set(hb,'backgroundcolor','w',   'tag' ,'sting_linstyle_pull');
set(hb,'position',[.31    0.9146    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_linstyle_pull'});
set(hb,'tooltipstring',['select needle linestyle']);


%% ====linewidth===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','line width');
set(hb,'backgroundcolor',[0.8039    0.8784    0.9686],   'tag' ,'');
set(hb,'position',[0.0072    0.8427    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['needle linewidth']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_linewid_ed');
set(hb,'position',[.31    0.8427    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_linewid_ed'});
set(hb,'string',num2str(us2.sting.linewidth));
set(hb,'tooltipstring',['enter needle linewidth (1 value)']);


lw=cellfun(@(a) {[num2str(a)]}, num2cell([.1:.1:1 1:.2:3]));
hb=uicontrol(hh,'style','popupmenu','units','norm',  'string',lw);
set(hb,'backgroundcolor','w',   'tag' ,'sting_linewid_pull');
set(hb,'position',[.62    0.8427    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_linewid_pull'});
ix=find(strcmp(lw,num2str(us2.sting.linewidth)));
if isempty(ix)
    set(hb,'value',1);
else
    set(hb,'value',ix);
end
set(hb,'tooltipstring',['select needle linewidth']);


%% ====line-color===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','line color');
set(hb,'backgroundcolor',[0.8039    0.8784    0.9686],   'tag' ,'');
set(hb,'position',[0.0072    0.7708    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['color of needle lines']);

hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_linecol_ed');
set(hb,'position',[.31    0.7708    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_linecol_ed'});
set(hb,'string',sprintf('%2.3f ',us2.sting.linecol),'fontsize',6);
set(hb,'tooltipstring',[' enter color of needle lines [R;G,B]']);


hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','select');
set(hb,'backgroundcolor','w',   'tag' ,'sting_linecol_gui');
set(hb,'position',[.62    0.7708    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_linecol_gui'});
set(hb,'tooltipstring',[' select color of needle lines from palette']);



%% ==== radus factor ===========================================
col=[0.9608    0.9216    0.9216];
hb=uicontrol(hh,'style','text','units','norm',  'string','radus');
set(hb,'backgroundcolor',col,   'tag' ,'');
set(hb,'position',[0.0072    0.65   0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['outer radius for label positioning']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_radus_ed');
set(hb,'position',[.31    0.65    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_radus_ed'});
set(hb,'string',num2str(us2.sting.radiusfac));
set(hb,'tooltipstring',['enter radius for label positioning (1 value)']);


lw=cellfun(@(a) {[num2str(a)]}, num2cell([.8:.1:1.5]));
hb=uicontrol(hh,'style','popupmenu','units','norm',  'string',lw);
set(hb,'backgroundcolor','w',   'tag' ,'sting_radus_pull');
set(hb,'position',[.62    0.65    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_radus_pull'});
ix=find(strcmp(lw,num2str(us2.sting.radiusfac)));
if isempty(ix)
    set(hb,'value',1);
else
    set(hb,'value',ix);
end
set(hb,'tooltipstring',['select radius for label positioning (1 value)']);

%% ====radius points ===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','rad.points');
set(hb,'backgroundcolor',col,   'tag' ,'');
set(hb,'position',[0.0072    0.5780    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['number of points located on the  circle for label positioning']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_radpoint_ed');
set(hb,'position',[.31    0.5780    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_radpoint_ed'});
set(hb,'string',num2str(us2.sting.pointsfac),'fontsize',6);
set(hb,'tooltipstring',['enter number of points located on the  circle for label positioning']);


%% ====radius dist ===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','rad.dist');
set(hb,'backgroundcolor',col,   'tag' ,'');
set(hb,'position',[0.0072    0.5060    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['minimim distance between labels positioned on the circle']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_raddis_ed');
set(hb,'position',[.31    0.5060    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_raddis_ed'});
set(hb,'string',num2str(us2.sting.sepmax),'fontsize',6);
set(hb,'tooltipstring',['enter minimim distance between labels positioned on the circle']);


%% ====label font-bold===========================================
% hb=uicontrol(hh,'style','text','units','norm',  'string','3DvolCenter');
% set(hb,'backgroundcolor',col,   'tag' ,'');
% set(hb,'position',[0.0072   0.4340    0.300    0.07000],'horizontalalignment','right');

hb=uicontrol(hh,'style','checkbox','units','norm',  'string','3DvolCenter');
set(hb,'backgroundcolor',col,   'tag' ,'sting_volcenter');
% set(hb,'position',[0.0072      0.4340    0.5    0.07000],'horizontalalignment','left');
set(hb,'position',[0.61     0.5060    0.5    0.07000],'horizontalalignment','left');

set(hb,'callback',{@sting_property_param,'sting_volcenter'},'fontsize',6);
set(hb,'value',us2.sting.volcenter);
set(hb,'tooltipstring',['circle center is: ' char(10) ' [ ] center of connections  ' char(10) ' [x] center of background volume ']);



col2=[0.8941    0.9412    0.9020];
%% ===============================================
%% ====label fontsize===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','label font');
set(hb,'backgroundcolor',col2,   'tag' ,'');
set(hb,'position',[0.0072    0.324    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',['fontsize of labels']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_labfont_ed');
set(hb,'position',[.31    0.324    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_labfont_ed'});
set(hb,'string',num2str(us2.sting.fs));
set(hb,'tooltipstring',['enter label fontsize (1 value)']);

fs=cellfun(@(a) {[num2str(a)]}, num2cell(2:65));
hb=uicontrol(hh,'style','popupmenu','units','norm',  'string',fs);
set(hb,'backgroundcolor','w',   'tag' ,'sting_labfont_pull');
set(hb,'position',[.62    0.324    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_labfont_pull'});
ix=find(strcmp(fs,num2str(us2.sting.fs)));
if isempty(ix)
    set(hb,'value',1);
else
    set(hb,'value',ix);
end
set(hb,'tooltipstring',['select label fontsize']);


%% ====label font-bold===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','label bold');
set(hb,'backgroundcolor',col2,   'tag' ,'');
set(hb,'position',[0.0072   0.252    0.300    0.07000],'horizontalalignment','right');

hb=uicontrol(hh,'style','checkbox','units','norm',  'string','Bold');
set(hb,'backgroundcolor','w',   'tag' ,'sting_lab_bold');
set(hb,'position',[.31      0.252    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_lab_bold'});
set(hb,'value',us2.sting.fontbold);
%% ====label-color===========================================
hb=uicontrol(hh,'style','text','units','norm',  'string','label color');
set(hb,'backgroundcolor',col2,   'tag' ,'');
set(hb,'position',[0.0072    0.18    0.300    0.07000],'horizontalalignment','right');
set(hb,'tooltipstring',[' label color']);


hb=uicontrol(hh,'style','edit','units','norm',  'string','empty');
set(hb,'backgroundcolor','w',   'tag' ,'sting_labcol_ed');
set(hb,'position',[.31       0.18    0.300    0.07000],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'sting_labcol_ed'});
set(hb,'string',sprintf('%2.3f ',us2.sting.fontcol),'fontsize',6);
set(hb,'tooltipstring',[' edit label color (R,G,B)']);

hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','select');
set(hb,'backgroundcolor','w',   'tag' ,'');
set(hb,'position',[.62       0.18    0.300    0.07000],'horizontalalignment','right');
set(hb,'callback',{@sting_property_param,'sting_labcol_gui'});
set(hb,'tooltipstring',[' select label color from palette']);


%% ====DEBUG mode ===========================================
col3=[.7 .7 .7];
hb=uicontrol(hh,'style','text','units','norm',  'string','debug');
set(hb,'backgroundcolor',col3,   'tag' ,'');
set(hb,'position',[0.0162 0.0929 0.3 0.07],'horizontalalignment','right');
set(hb,'tooltipstring',[' debug mode']);


hb=uicontrol(hh,'style','checkbox','units','norm',  'string','debug');
set(hb,'backgroundcolor','w',   'tag' ,'debug_chk');
set(hb,'position',[[0.325 0.0908 0.3 0.07]],'horizontalalignment','left');
set(hb,'callback',{@sting_property_param,'debug'});
set(hb,'tooltipstring',['debug mode: ' char(10) ' [ ] normal mode  ' char(10) ' [x] debug mode ']);



%% ====help===========================================
col4=[1.0000    0.9490    0.8667];
hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','?');
set(hb,'backgroundcolor',col4,   'tag' ,'');
% set(hb,'position',[.01    0.01    0.300    0.07000]);
set(hb,'position',[.88 .95 .06 .05]);
set(hb,'callback',{@xhelp});
set(hb,'tooltipstring',[' HELP']);
%% ====apply===========================================
col4=[1.0000    0.9490    0.8667];
hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','x');
set(hb,'backgroundcolor',col4,   'tag' ,'');
% set(hb,'position',[.01    0.01    0.300    0.07000]);
set(hb,'position',[.94 .95 .06 .05]);
set(hb,'callback',{@sting_property_endmode,1});
set(hb,'tooltipstring',[' close']);


hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','apply&close');
set(hb,'backgroundcolor',col4,   'tag' ,'');
set(hb,'position',[.02    0.01    0.400    0.07000]);
set(hb,'callback',{@sting_property_endmode,2});
set(hb,'tooltipstring',[' apply changes and close GUI']);


hb=uicontrol(hh,'style','pushbutton','units','norm',  'string','cancel');
set(hb,'backgroundcolor',col4,   'tag' ,'');
set(hb,'position',[.68    0.01    0.300    0.07000]);
set(hb,'callback',{@sting_property_endmode,3});
set(hb,'tooltipstring',['undo last changes and close GUI']);



us2.sting.backup=us2.sting;
set(h2,'userdata',us2);

function xhelp(e,e2)
uhelp('sub_sting.m');

function sting_property_param(e,e2,type)
h2=findobj(0,'tag','plotconnections'); %gui-2
us2=get(h2,'userdata');
hf=findobj(0,'tag','xvol3d');
hp=findobj(0,'tag','stingpop');
if strcmp(type,'debug')
    us2.sting.isdebug=get(findobj(hp,'tag','debug_chk'),'value');
elseif strcmp(type,'sting_labcol_gui')
    col=uisetcolor(us2.sting.fontcol, 'select label color');
    set(findobj(hp,'tag','sting_labcol_ed'),'string', sprintf('%2.3f ',col),'fontsize',6);
    us2.sting.fontcol=col;
    
    %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','nodelabels2'),'color', us2.sting.fontcol );
    return
    %------
elseif strcmp(type,'sting_labcol_ed');
    col=str2num(get(findobj(hp,'tag','sting_labcol_ed'),'string'));
    us2.sting.fontcol=col;
    
    %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','nodelabels2'),'color', us2.sting.fontcol );
    return
    %------
    
elseif strcmp(type,'sting_lab_bold')
    us2.sting.fontbold=get(findobj(hp,'tag','sting_lab_bold'),'value');
     %------
     set(h2,'userdata',us2);
     ch=findobj(hf,'tag','nodelabels2');
     if us2.sting.fontbold==0
         set(ch,'FontWeight', 'normal' );
     else
         set(ch,'FontWeight', 'bold' );
     end
     return
    %------
    
elseif strcmp(type,'sting_labfont_ed')
    he=findobj(hp,'tag','sting_labfont_ed');
    fs=str2num(get(he,'string'));
    set(he,'string',num2str(fs));
    us2.sting.fs=fs;
     %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','nodelabels2'),'fontsize', us2.sting.fs );
    return
    %------
    
    
elseif strcmp(type,'sting_labfont_pull')
    he=findobj(hp,'tag','sting_labfont_ed');
    %val=get(he,'string');
    hs=findobj(hp,'tag','sting_labfont_pull');
    li=cellstr(hs.String);
    fs=str2num(li{hs.Value});
    set(he,'string',num2str(fs));
    us2.sting.fs=fs;
     %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','nodelabels2'),'fontsize', us2.sting.fs );
    return
    %------
    
% ==============================================
%%   radius stuff
% ===============================================

    %   ------radius-----
elseif strcmp(type,'sting_radus_ed')
    he=findobj(hp,'tag','sting_radus_ed');
    lw=str2num(get(he,'string'));
    set(he,'string',num2str(lw));
    us2.sting.radiusfac=lw;
    
elseif strcmp(type,'sting_radpoint_ed')
    he=findobj(hp,'tag','sting_radpoint_ed');
    val=str2num(get(he,'string'));
    us2.sting.pointsfac=val;
elseif strcmp(type,'sting_volcenter')
    he=findobj(hp,'tag','sting_volcenter');
    val=(get(he,'value'));
    us2.sting.volcenter=val; 
elseif strcmp(type,'sting_raddis_ed')
    he=findobj(hp,'tag','sting_raddis_ed');
    val=str2num(get(he,'string'));
    us2.sting.sepmax=val;
    
elseif strcmp(type,'sting_radus_pull')
    he=findobj(hp,'tag','sting_radus_ed');
    hs=findobj(hp,'tag','sting_radus_pull');
    li=cellstr(hs.String);
    lw=str2num(li{hs.Value});
    set(he,'string',num2str(lw));
    us2.sting.radiusfac=lw;
    
    
 % ==============================================
%%   ------line-params-----
% ===============================================

elseif strcmp(type,'sting_linecol_gui')
    col=uisetcolor(us2.sting.fontcol, 'select line color');
    set(findobj(hp,'tag','sting_linecol_ed'),'string', sprintf('%2.3f ',col),'fontsize',6);
    us2.sting.linecol=col;
    
      %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','needle2'),'color', us2.sting.linecol );
    return
    %------
    
    
elseif strcmp(type,'sting_linecol_ed')
    col=str2num(get(findobj(hp,'tag','sting_linecol_ed'),'string'));
    us2.sting.linecol=col;
    %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','needle2'),'color', us2.sting.linecol );
    return
    %------
    
    
    
elseif strcmp(type,'sting_linewid_ed')
    he=findobj(hp,'tag','sting_linewid_ed');
    lw=str2num(get(he,'string'));
    set(he,'string',num2str(lw));
    us2.sting.linewidth=lw;
    
    %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','needle2'),'linewidth', us2.sting.linewidth );
    return
    %------
    
elseif strcmp(type,'sting_linewid_pull')
    he=findobj(hp,'tag','sting_linewid_ed');
    hs=findobj(hp,'tag','sting_linewid_pull');
    li=cellstr(hs.String);
    lw=str2num(li{hs.Value});
    set(he,'string',num2str(lw));
    us2.sting.linewidth=lw;
     %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','needle2'),'linewidth', us2.sting.linewidth );
    return
    %------
    
elseif strcmp(type,'sting_linstyle_pull')
    hs=findobj(hp,'tag','sting_linstyle_pull');
    li=cellstr(hs.String);
    lw= (li{hs.Value});
    us2.sting.linestyle=lw;
     %------
    set(h2,'userdata',us2);
    set(findobj(hf,'tag','needle2'),'linestyle', us2.sting.linestyle );
    return
    %------
    
end

% us2.sting


set(h2,'userdata',us2);
sub_sting();


function rrr(e,e2)





function sting_property_endmode(e,e2,type)
if type==1
    delete(findobj(0,'tag','stingpop'));
    delete(findobj(0,'tag','btnmove2'))
elseif type==2
    sub_sting();
    delete(findobj(0,'tag','stingpop'));
    delete(findobj(0,'tag','btnmove2'))
elseif type==3
    h2=findobj(0,'tag','plotconnections'); %gui-2
    us2=get(h2,'userdata');
    us2.sting=us2.sting.backup;
    set(h2,'userdata',us2);
    sub_sting();
    delete(findobj(0,'tag','stingpop'));
    delete(findobj(0,'tag','btnmove2'))
end



function drag_object(e,e2,tag,othertags)
% tag='cbarmoveBtn'
hv=findobj(gcf,'tag',tag);
hv=hv(1);


units_hv =get(hv ,'units');
units_fig=get(gcf,'units');
units_0  =get(0  ,'units');

set(hv  ,'units','pixels');
set(gcf ,'units','pixels');
set(0   ,'units','pixels');

posF=get(gcf,'position')   ;
posS=get(0  ,'ScreenSize') ;
pos =get(hv,'position');
mp=get(0,'PointerLocation');

xx=mp(1)-posF(1);
if xx<0; xx=0; end
if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
yy=mp(2)-posF(2);
if yy<0; yy=0; end
if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
set(hv,'position',[ xx yy pos(3:4)]);

set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
df=[pos(1)-xx pos(2)-yy];
% -----------------------------
if exist('othertags')==1
    othertags=cellstr(othertags);
    for i=1:length(othertags)
        hv=findobj(gcf,'tag',othertags{i});
        %         try; hv=hv(1); end
        units_hv =get(hv ,'units');
        set(hv  ,'units','pixels');
        
        pos =get(hv,'position');
        pos2=[ pos(1)-df(1) pos(2)-df(2) pos(3:4)];
        set(hv,'position',pos2);
        set(hv ,'units'  ,units_hv);
    end
end

