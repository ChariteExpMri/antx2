function outw=labs(varargin)
% -labs: instant labeling and more
% examples
% labs([-33 -44 43])
%  labs(XYZmm(:,ix),{'addcolpre',{'R' 'p'} rp(ix,:)})
%  labs(XYZmm(:,ix),{'addcolpost',{'R' 'p'} rp(ix,:)})

if nargin==1 | nargin==2
    cords=varargin{1};
    if size(cords,1)==3
        cords=cords';
    end

    if numel(cords)~=1 
    [labelx header labelcell]=pick_wrapper(cords, 'Noshow');%
    elseif  ishandle(cords)
        delete(timerfindall);
        if findobj(0,'tag','Graphics')& findobj(0,'tag','Menu') & findobj(0,'tag','Interactive') 
        t = timer('TimerFcn','labs;Fgraph = spm_figure(''GetWin'',''Graphics'');', 'executionmode', 'singleShot','StartDelay',.2);
        start(t);            
        end
        return
    end
        

    if nargin==1
        showtable3([0 0 1 1],[header;labelx],'fontsize',8);
    else%ADD COLUMNS addcolpre|addcolpost
        add= varargin{2};
        addheader=add{2};
        addata   =num2cell(add{3});
        
        addata  =cellfun(@(addata) {num2str(addata)},addata);
        
        if strcmp(add{1},'addcolpre')
            labelx=[ addata labelx];
            header=[ addheader header];
        elseif strcmp(add{1},'addcolpost')
            labelx=[ labelx  addata ];
            header=[ header  addheader ];
        end

        showtable3([0 0 1 1],[header;labelx],'fontsize',8);
    end
    
    try
%         ihan=findobj(0,'tag','tabelz2');
        ihan=gcf;
        us=get(ihan,'userdata');
        outw.table =us.table;
        outw.tablec=us.tablec;
        % varargout{1}=out;
    catch
        ihan= findobj(0,'tag','tabelz2');
        ihan=ihan(1);
        
        us=get(ihan,'userdata');
        outw.table =us.table;
        outw.tablec=us.tablec;
        
    end
    
    return
end

fix=sort(findall(0,'tag','menu_brodm'));
% if length(fix)>1
    set(fix,'DeleteFcn','');
    delete(fix);
% end

% fix2=sort(findall(0,'tag','menu_brodm0'));
% set(fix2,'DeleteFcn','');
% delete(fix2);

% --------------------------------------
fig3=findobj(0,'tag','Interactive');
set(0,'currentfigure',fig3);
delete(findobj(0,'tag','menu_brodm0'));%resultspanel
% f2 = uimenu('Label','LABS','tag','menu_brodm0','Callback','labs');
% set(f2,'DeleteFcn',@labs) ;
% --------------------------------------




% fig1=findobj(0,'tag','Graphics');
 fig1=findobj(0,'tag','Interactive');
set(0,'currentfigure',fig1);
delete(findobj(0,'tag','menu_brodm'));
f = uimenu('Label','LABS','tag','menu_brodm');

uimenu(f,'Label','update LABS  [u]','Callback', @labs );
uimenu(f,'Label','TABLE whole brain [t]','Callback',  'batab(1)' ,'Separator','on');
uimenu(f,'Label','TABLE current cluster [z]','Callback',  'batab(2)' ,'Separator','on');

% uimenu(f,'Label','hide   TABLE [h]','Callback', 'batab(0)' ,'Separator','on');
% uimenu(f,'Label','change ATLAS','Callback', @changeAtlas  );
% uimenu(f,'Label','show Brodman','Callback',@showbrodmann,'Separator','on');
% for i=1:4
%  uimenu(f,'Label',['  ' upper(atlasname{i})  ' ...Mwheel'],'Callback',{@changeAtlas ,i}  );   
% end
% uimenu(f,'Label','synchronize slices & sections  [s]','Callback', 'basyncsection' ,'Separator','on');
% uimenu(f,'Label','info        ','Callback', @pinfo ,'Separator','on');
uimenu(f,'Label','show sections  [s]','Callback', 'fun2_sections' ,'Separator','on');
uimenu(f,'Label','show slices    [e]','Callback', 'pslices' ,'Separator','on');
uimenu(f,'Label','render surface [r]','Callback', 'renderer' ,'Separator','on');
uimenu(f,'Label','show 3D brain  [b]','Callback', @fun2_showbrain ,'Separator','on');
uimenu(f,'Label','contrast estimate [c]','Callback', @contrastestimate ,'Separator','on');
% uimenu(f,'Label','contrast estimate II [v]','Callback', @contrastestimate ,'Separator','on');
uimenu(f,'Label','smallVolumeCorrection (using MASK image(s)) [m]','Callback', @svc ,'Separator','on');

% uimenu(f,'Label','previous Contrast [<-]','Callback', 'changeContrast(1)' ,'Separator','on');
% uimenu(f,'Label','next Contrast [->]','Callback', 'changeContrast(2)' ,'Separator','on');

uimenu(f,'Label','..pause..[p]','Callback',@jadiccaller,'Separator','on','tag','jadic');%'Checked','on'
uimenu(f,'Label','..info..','Callback',@info,'Separator','on','tag','pinfo');%'Checked','on'
uimenu(f,'Label','close labs        ','Callback', @pclose ,'Separator','on');

% uimenu(f,'Label','close [q]','Callback', 'batab(''close'')' ,'Separator','on');


 set(f,'DeleteFcn',@labs) ;

%     uimenu(f,'Label','Quit','Callback','exit',...
%            'Separator','on','Accelerator','Q');
txt1 = '<html><b><u><i>Info</i></u>';
txt2 = '<font color="red"><sup>for this toolbox</sup></font></b></html>';
txt3 = '<br />this file as...';
set(findall(fig1,'tag','pinfo'),   'Label',[txt1,txt2]);


  pause(0.1);drawnow

% try
    jFrame = get(handle(fig1),'JavaFrame');
    try % R2008a and later
        jMenuBar = jFrame.fHG1Client.getMenuBar;
    catch     % R2007b and earlier
        jMenuBar = jFrame.fFigureClient.getMenuBar;
    end
%     jFrame = get(handle(gcf),'JavaFrame');
%     jMenuBar = jFrame.fFigureClient.getMenuBar;
    compN =0;
    for i=0:5
        try
            jFileMenu = jMenuBar.getComponent(i);
            if strcmp(jFileMenu.getLabel ,'LABS')
                compN=i;
                break
            end
        end
    end
    jFileMenu = jMenuBar.getComponent(compN);
%     jFileMenu.getMenuComponents,
%     jFileMenu.getMenuComponentCount
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    
    if 0
        % jFileMenu.getLabel
        jFileMenu = jMenuBar.getComponent(compN) ;
        jSave = jFileMenu.getMenuComponent(jFileMenu.getMenuComponentCount-2); %Java indexes start with 0!
        % jSave.getText
        % myIcon = 'C:\Yair\save.gif';
        jSave.setIcon(javax.swing.ImageIcon(icon));
    end

    
     jFileMenu.setIcon(javax.swing.ImageIcon(icon));
   
% end



global Atlas;
keyboardactivate;
try; showbrodmann; end

try
% ihan=findobj(0,'tag','tabelz2');
ihan=gcf;
us=get(ihan,'userdata');
outw.table =us.table;
outw.tablec=us.tablec;
% varargout{1}=out;
end


function info(w,ww)
% disp('***  BAUSTELLE  ***');
% disp('hit [u] to update LABS');
% disp('hit [t] to update table');
% disp('hit [s] to show overlay/SECTIONS [change labs_config.m for another overlay]');
warning off;
labsinfo;
anima; 
warning on;

function jadiccaller(w,ww)
jadic;

function contrastestimate(w,ww)
xSPM=evalin('base','xSPM');
SPM=evalin('base','SPM');
hReg=evalin('base','hReg');

if isempty(xSPM.Z); return; end

fig=findobj(0,'tag','EOIbar');
 
 if isempty(fig)
    [Y,y,beta,Bcov] = pspm_graph(xSPM,SPM,hReg); 
 else
     us=get(fig,'userdata');
     ic=us.definedIC;
    [Y,y,beta,Bcov] = pspm_graph(xSPM,SPM,hReg, [ic]  ); 
 end
 assignin('base','Y',Y);
 assignin('base','y',y);
 assignin('base','beta',beta);
 assignin('base','Bcov',Bcov);
% fig=findobj(0,'tag','EOIbar');
%  labely=get(get(gca,'ylabel'),'string');
%  str2num(char((regexp(labely,'\[.*\]','match'))))
% s1=[regexp(labely,'\[') regexp(labely,'\]') ]
% strct=labs(str2num(labely(s1(1):s1(2))))
% currentLabel=char(strct.tablec(2,3))
% string=labely(1:s1(1)-1)

try
    ax1=findobj(fig,'type','axes');
    labely=get(get(ax1,'ylabel'),'string');
    cordinate=str2num(char((regexp(labely,'\[.*\]','match'))));
    strct=labs(cordinate);
    currentLabel=char(strct.tablec(2,3));
    set(get(ax1,'xlabel'),'string',{'contrast',['\color{blue}'  currentLabel ] });
end

fig=findobj(0,'tag','EOIbar');
figure(fig)
list={SPM.xCon(:).name}';
hpop = uicontrol('Style', 'popup',...
       'String',list,'units','normalized',... 'hsv|hot|cool|gray'
       'Position', [.16 .9 .8 .1],...
       'Callback', @callchangecontrast2plot);
set(hpop,'BackgroundColor','w');
set(hpop,'HorizontalAlignment','right');
set(hpop,'fontsize',10,'fontweight','bold');
set(hpop,'tag','hpopcontrast','tooltip','chose contrast to plot');

 fig=findobj(0,'tag','EOIbar');
us= get(fig,'userdata');
if isfield(us,'definedIC')==0 %never used before
    us.definedIC=xSPM.Ic;
    set(fig,'userdata',us);
end
set(hpop,'value',us.definedIC);
% Fgraph = spm_figure('GetWin','Graphics');
figure(findobj(0,'tag','Graphics'));



function CEstack


fig0=get(0,'currentfigure');

fig=findobj(0,'tag','EOIbar');
% us2=get(fig,'userdata');

fig2=findobj(0,'tag','EOIbarstack');
if isempty(fig2);
    fig2=figure(1123);
    set(fig2,'color','w','units','normalized','tag','EOIbarstack');
    %fig2=findobj(0,'tag','EOIbarstack');
    set(fig2,'KeyPressFcn',@keyboardCEstack,...
        'position',[ 0.7174    0.1422    0.2639    0.3867]);
    uv.figsize=get(fig2,'position');
    set(fig2,'userdata',uv);
    
end
set(0,'currentfigure',fig2);

ax2cop=findobj(fig,'type','axes');
set(ax2cop,'tag','barce');
copyobj(ax2cop, fig2);

ax=findobj(fig2,'type','axes','-and','tag','barce');



% usax.title=us2.title;
% set(max(ax),'userdata',usax);
% pos0=get(min(ax),'position');%firstaxis
% if length(ax)<=1; 
%     return; 
% end

try
pos=cell2mat(get(ax,'position'));
catch
 pos= (get(ax,'position'));
end

% pbas=linspace(0.13,.93,length(ax)+1)
pbas=linspace(0,.9,length(ax)+1);
pbas=pbas+0.07;
phig=abs(diff(pbas(1:2)))*0.9;

pos2=pos;
pos2(:,2)=pbas(1:size(pos,1));
pos2(:,4)=phig;

pos2(:,1)=.13;

pos0=pos2(end,:);
if size(pos2,1)==1
  pos2(:,3)=.25;
else
    pos2(:,3)=pos0(3);%.25;
end

tit={};
for i=1:length(ax)
    set(fig2,'currentaxes',ax(i));
            xlim([get(ax(i),'xlim')]);
        ylim([get(ax(i),'ylim')]);
    set(ax(i),'position',pos2(i,:));
    
    %set dot-to invivsible
    l=findobj(gca,'type','line');
    set(l(1),'visible','off');
    
    try
        ih=get(ax(i),'ylabel');
        strCORD=regexprep(get(ih,'string'), 'contrast estimate at ','');
        set(ih,'visible','off');
    end

    %         try
    %          ih=get(ax(i),'xlabel')
    %          str= get(ih,'string');
    %          try
    %          set(ih,'string',str{2});
    %          end
    %          set(ih,'fontsize',8);
    %         end

    try
        ih=get(ax(i),'title');
        set(ih,'visible','off');
        txCE=findobj(ax(i),'tag','txCE');
        if ~isempty(txCE);
            delete(txCE);
        end
        str= get(ih,'string');
        %txpos=[ mean(get(ax(i),'xlim'))   max(get(ax(i),'ylim'))  ];
%         txpos=[ max(get(ax(i),'xlim'))  0  ];
       yl=get(ax(i),'ylim');
        txpos=[ max(get(ax(i),'xlim'))   (mean(yl))  ];

        
        %xlabel
        ih2=get(ax(i),'xlabel');
        str2= get(ih2,'string');
        try ;
            str2=[str2{1}  str2{2}];
        end
        str2=regexprep(str2,'contrast' ,'' );
        set(ih2,'visible','off');

        try
           % str0=regexprep(str{1},'Contrast estimates and ' ,'CE & ' );
            str0='';
            try
               info= getappdata(ax(i),'info');
             tit(end+1,1)= {info.title};
           %['   ' '\color{red}' info.title   '\color[rgb]{.5 .5 .5}' ]
           %             msg={ ['   ' '\fontsize{6}'  str{2} ' ' strCORD   '  ' str0  ' ' ...
           %                    '\fontsize{8}'   str2   ]};
          strCORD=sprintf('[%4.0f %4.0f %4.0f]',round(str2num(strCORD)));  
           
           msg={ ['   ' '\fontsize{6}'    strCORD   '  ' str0  ' ' ...
               '\fontsize{8}'   str2   ]};

            catch
                msg=['   ' str{2} ' ' strCORD   '  ' str0  ' '   str2   ];
            end
            te=text(txpos(1),txpos(2), msg);
        catch
            str0=regexprep(str,'Contrast estimates and ' ,'CE & ' );
            te=text(txpos(1),txpos(2), str0 );
        end
        
        set(te,'verticalalignment','middle','horizontalalignment','left','tag','txCE');
        set(te ,'fontsize',8,'fontweight','bold');
    end
    set(ax(i),'fontsize',6);
    
    if i>1  & length(ax)>1
         set(gca,'xtick',[])
    end
end

fig0=get(0,'currentfigure'); 
set(0,'currentfigure',fig2);
delete(findobj(fig2,'type','axes','-and','tag','contrastname'));
% tituni=unique(tit);


titcmp=tit{1};
tituni{1}=titcmp;
clas=[1];clasno=1;
for i=2:length(tit);
    if strcmp(titcmp,tit{i})==0;
       clasno=clasno+1; 
       titcmp=tit{i} ;
       tituni(end+1,1)={titcmp};
    end
     clas(i,1)=clasno ;
end

for i=1:clasno;%length(tituni)
%    ix= find(strcmp(tit,tituni{i}));
   ix=find(clas==i);
    
    ly= [min(pos2(ix,2)) max(pos2(ix,2)+pos2(ix,4))-min(pos2(ix,2))  ];
 %  ly= [min(pos2(ix,2)) max(pos2(ix,4))  ];
%    lys=diff(ly)/50;
%    ly=[ly(1)+lys ly(2)-lys];
%     ly= [min(pos2(ix,2))+.05 max(pos2(ix,2)+pos2(ix,4))-.05];
   ax2=axes( 'position',[0.0  ly(1)     pos2(ix(1),1)*0.4 ly(2) ]);
%     te2=text(.5,0, [' ' tituni{i}]);
%    set(te2,'Rotation',90,'horizontalalignment','left','fontsize',7,'fontweight','bold');

       te2=text(.5,.5, [' ' tituni{i}]);
   set(te2,'Rotation',90,'horizontalalignment','center','fontsize',7,'fontweight','bold');
   
   set(ax2,'xtick',[],'ytick',[],'tag', 'contrastname');
   
   if mod(i,2)==0
      col=[0.9922    0.9176    0.7961];
   else
      col=[0.8039    0.8784    0.9686] ;
   end
      set(ax2,'color',col)
      set(ax2,'ycolor','w','xcolor','w');
end
set(0,'currentfigure',fig0);

%  set(0,'currentfigure',fig2);
% allfigs=findobj(0,'type','figure')
%   set(0,'currentfigure',findobj(0,'tag','EOIbarstack'))


function keyboardCEstack(src,event)
if strcmp(event.Key,'leftarrow')
    ax=findobj(gcf,'type','axes','-and','tag','barce');
    if length(ax)==1; pos= (get(ax,'position'));
    else; pos=cell2mat(get(ax,'position'));
    end
    pos2=pos;
    pos2(:,3)=pos2(:,3)-.05;
    if pos2(1,1)<pos2(1,3)
        for i=1:length(ax)
            set(ax(i),'position',pos2(i,:))
        end
    end

elseif strcmp(event.Key,'rightarrow')
        ax=findobj(gcf,'type','axes','-and','tag','barce');
    if length(ax)==1; pos= (get(ax,'position'));
    else; pos=cell2mat(get(ax,'position'));
    end
    pos2=pos;
    pos2(:,3)=pos2(:,3)+.05;
    if pos2(1,1)<pos2(1,3)
        for i=1:length(ax)
            set(ax(i),'position',pos2(i,:));
        end
    end
elseif strcmp(event.Key,'uparrow') 
%     uv=get(gcf,'userdata');
%     posf=uv.figsize;
    posf=get(gcf,'position'); 
   posf([2 4])=[ 0.0356      0.8878];
  set(gcf,'position',posf); 
elseif strcmp(event.Key,'downarrow')    
   uv=get(gcf,'userdata');
   posf0=uv.figsize;
    posf=get(gcf,'position'); 
   posf([2 4])=[posf0([2 4])];
  set(gcf,'position',posf); 
    
end







function callchangecontrast2plot(ro,ra)
fig=findobj(0,'tag','EOIbar');
us=get(fig,'userdata');
us.definedIC=get(ro,'value');
set(fig,'userdata',us);
contrastestimate([],[]);

 
function pclose(ro,ra)
% 's'
close(findobj(0,'tag','tabelz'));
set(findall(0,'tag','menu_brodm'),'DeleteFcn',[]);
% fig3=findobj(0,'tag','Interactive');
% set(0,'currentfigure',fig3);
% delete(findobj(0,'tag','menu_brodm0'));%r
 fig1=findobj(0,'tag','Interactive');
set(0,'currentfigure',fig1);
delete(findobj(0,'tag','menu_brodm'));
 

fig=findobj(0,	'Tag','Graphics');
% filecallback='fun2_activateResults';
for i=1:3
    c=findobj(fig,	'Tag',['hX' num2str(i) 'r' ]);
    str=get(c,'ButtonDownFcn');
    
    orig='spm_mip_ui(''MoveStart'')';
    set(c,'ButtonDownFcn',[ orig  ]);
end

fig3=findobj(0,'Tag','Graphics'); %SECTIONS
ch=findobj(fig3,'type','image','tag','Transverse');
for i=1:length(ch)
    ax =get(ch(i),'parent');
    r=get(ax,'ButtonDownFcn');
%     if size(r,1)<2
        set(ax,'ButtonDownFcn',r(2));
%     end
end
fig=findobj(0,'Tag','Graphics');
set(fig,'KeyPressFcn',[]);

function keyboardactivate

fig=findobj(0,'Tag','Graphics');
if ~isempty(fig)
    set(fig,'KeyPressFcn',@keyboardx);
    % set(fig,'WindowButtonUpFcn',@showbrodmann);
    % dum=['delete(timerfindall);t = timer(''TimerFcn'',@showbrodmann,''startdelay'',.3);start(t)' ]
    %     set(fig,'WindowButtonUpFcn',dum);

    try
        im=findobj(fig,'type','image');
        im= (im(end));
        ch=sort(get(get(im,'UIContextMenu'),'children'));
        idx=find(~cellfun('isempty',regexpi(get(ch,'label'),'goto ')));
        for i=1:length(idx)
            id=ch(idx(i));
            co=getappdata(id,'funs');
            if isempty(co)
                code= get(id ,'callback') ;
                setappdata(id,'funs',code) ;
            end
            co=getappdata(id,'funs');
            co=[co ';showbrodmann'];
            set(id ,'callback',co);
        end
    end
%    set(fig, 'WindowScrollWheelFcn',@figScroll);
end


% function figScroll(src,event)
% dire=event.VerticalScrollCount ;
% fig=findobj(0,'Tag','Menu');
% us=getappdata(fig,'atlas');
% us.atlas=us.atlas+dire;
% if us.atlas>4; us.atlas=1;end
% if us.atlas<1; us.atlas=4;end
% setappdata(fig,'atlas','us');
% fig2=findobj(0,'Tag','Graphics');
% loadatlas(0,0,us.atlas);
% if ~isempty(findobj(fig2,'tag','brodtab'))
%     batab;
% end
% showbrodmann;


function keyboardx(src,event)
if strcmp(event.Key,'u')
    labs;
%     fig=findobj(0,'Tag','Graphics')
elseif strcmp(event.Key,'t')
    
  batab(1);% showtable;
elseif strcmp(event.Key,'z')
  batab(2);% showtable;  
% elseif strcmp(event.Key,'h')
%   batab(0);% showtable;
elseif strcmp(event.Key,'s')   
   fun2_sections;
elseif strcmp(event.Key,'e')
    pslices;
elseif strcmp(event.Key,'b')
    fun2_showbrain;
 elseif strcmp(event.Key,'c')   
     
     if strcmp(event.Modifier, 'control')
       contrastestimate([],[]) ;
       CEstack;
       figure(findobj(0,'tag','EOIbarstack'));
     elseif strcmp(event.Modifier, 'alt')
%          vv=batab(1);
         
         
         fig=findobj(0,'Tag','Graphics');
         axtab=get(findobj(fig,'string','mm mm mm'),'parent');%table
         hl=sort(findobj(axtab,'Tag','ListXYZ')) ;%mmText mm mm mm
         % return
         if isempty(axtab)
             disp('there is no table');
             return
         end
         cords=str2num(char([get(hl,'string')]));
         
         
         for ii=1:size(cords,1)
             %set MIPpointer
             spm_mip_ui('SetCoords',cords(ii,:),findobj(findobj(0,'tag','Graphics'),...
                 'tag','hMIPax'));
             drawnow
             contrastestimate([],[]) ;
             CEstack;
         end
        figure(findobj(0,'tag','EOIbarstack')); 
     else
     contrastestimate([],[]) ;
     end
   
  elseif strcmp(event.Key,'r')   
   renderer ;
   renderer('finflate',1);
 elseif strcmp(event.Key,'m') 
   svc;
% elseif strcmp(event.Key,'q');%quit
%     batab('close');
 elseif strcmp(event.Key,'rightarrow') 
changeContrast(1);
 elseif strcmp(event.Key,'leftarrow') 
changeContrast(2);
% elseif strcmp(event.Key,'p')
% jadiccaller
end


function changeContrast(direction)
state=0;
if ~isempty(findobj(findobj(0,'tag','Graphics'),'tag','Transverse')) ;
   state=1; %show slices
end

if state~=1
    fig=findobj(0,'tag','Graphics');
    ch=findobj(fig,'type','text');
    for i=1:length(ch)
        try
            tx=get(ch(i),'string');
            if ischar(tx)
                if ~isempty(regexpi(tx,'Statistics:'));
                    state=2;%%show wholebrainTable
                end
            end
        end
    end
end



fig=findobj(0,'tag','Interactive');
c=findobj(fig,'label','Contrasts');
c2=get(c,'children');
names=get(c2,'Label');
if direction==1
    id=find(cellfun('isempty',strfind(names,'Next'))==0);
elseif direction==2
    id=find(cellfun('isempty',strfind(names,'Previous'))==0);
end

if strcmp(get(c2(id),'Enable'),'on')
    busy;
    callbackCell =get(c2(id),'callback');
    callbackCell{1}(c2(id),[],callbackCell{2:end});
    
    fig=findobj(0,'tag','Graphics');
   figure(fig);
   busy(1);
end

%%update table/image
if state==1 %show slices
    fun2_sections;
%     return
elseif state==2 %show wholebrainTable
    cb=get(findobj(findobj(0,'tag','Interactive'),'string','whole brain'),'callback');
    hgfeval(cb);
%     eval(cb);
end




% function batab %showtable

% function showbrodmann(src,evt)
% 
% %
% fig1=findobj(0,'tag','Menu');
% atlas=getappdata(fig1,'atlas');
% tc=atlas.tc;
% area=atlas.area;
% 
% %%
% fig2=findobj(0,'Tag','Interactive');
% axpar= get(findobj(0,'tag','hX2r'),'parent');
% xyz=spm_mip_ui('GetCoords',axpar);
% disp(xyz);
% cox=xyz(:)';
% tc2=tc(:,2:end);
% siz=size(tc);
% 
% 
% tab=single(zeros(size(cox,1) ,4 ));
% for i=1:size(cox,1)
%     ci=cox(i,:);
%     ci2=repmat(ci,[siz(1) 1]);
%     ssq=sum((tc2-ci2).^2,2);
%     imin=find(ssq==min(ssq));
%     imin=imin(1);%check this: arbitrary take first idx
%     tab(i,:)=tc(imin,:);
% end
% 
% 
% idlabel=tab(:,1);
% %     area(idlabel)';
% 
% ax=findobj(0,'tag','hX2r');
% ax= (get(ax,'parent'));
% set(gcf,'currentaxes',ax);
% yl=get(ax,'ylim');
% delete(findobj(0,'tag','brot'));
% tx=[area{idlabel}  ' [' num2str(cox)  ']'];
% te=text(0,yl(1),tx,'fontsize',14,'color','b','tag','brot','fontweight','bold');
% % te=text(0,yl(1),'wurst','fontsize',14,'color','b','tag','brot','fontweight','bold');
% 
% 
% %     ######################################
% fig=findobj(0,	'Tag','Graphics');
% 
% for i=1:3
%     % c=findobj(fig,	'Tag','hX3r')
%     c=findobj(fig,	'Tag',['hX' num2str(i) 'r' ]);
%     
%     str=get(c,'ButtonDownFcn');
%     orig='spm_mip_ui(''MoveStart'')';
%     set(c,'ButtonDownFcn',[ orig ';' 'fun2_activateResults']);
%     
% end
% 
% set(fig,'WindowButtonUpFcn',@showbrodmann);



