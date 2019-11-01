
function  iconpannel4spm()


% icon = fullfile(matlabroot,'/toolbox/matlab/icons/demoicon.gif')
% % addpath('C:\Users\skoch\Desktop\xrot');


p.steptrans=[0.5   0.1];
p.steprot  =[0.1  .05 ];

% ==============================================
%%
% ===============================================

hfig=findobj(0,'tag','Graphics');
figure(hfig);

delete(findobj(gcf,'userdata','ipn1')); delete(findobj(gcf,'userdata','ipn2')); delete(findobj(gcf,'userdata','ipn3'));  delete(findobj(gcf,'tag','mission'))


% fg;
units=get(gcf,'units');
set(gcf,'units','norm');
% clc;

hb=uicontrol('Style','pushbutton','units','norm', 'Position',[0 0 .02 .02], ...
    'tag','mission','BackgroundColor','w','userdata',p);

ax=findobj(gcf,'type','axes');
axpos=cell2mat(get(ax,'position'));
[~, ax3]=min(axpos(:,2)+axpos(:,4))  ; %SORT AXes
[~,ax2]=max(axpos(:,1)+axpos(:,3));
ax1=setdiff(1:3,[ax2 ax3]);
ax=ax([ax1 ax2 ax3]);
axpos=axpos([ax1 ax2 ax3],:);

% ==============================================
%%


makepanel(1,[axpos(1,1) axpos(1,2)+axpos(1,4) ]);
makepanel(2,[axpos(2,1) axpos(2,2)+axpos(2,4) ]);
makepanel(3,[axpos(3,1) axpos(3,2)+axpos(3,4) ]);

% makepanel(2,[axpos(2,1)+axpos(2,3) axpos(2,2) ]);
% makepanel(3,[axpos(3,1)+axpos(3,3) axpos(3,2) ]);

% set(gcf,'units',units);


function makepanel(ipn,tp)
hm=findobj(gcf,'tag','mission');
p=get(hm,'userdata');

id=['ipn'  num2str(ipn)];

%% ===============================================
% n=0;
% e= which('hand.gif');
% v = imread(e);


v=uint8(geticon('hand'));
v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;
%% ________________________________________________________________________________________________
s=v; n=0;        % HAND
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'CData',s,'tag','move',...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2)+pos(4) pos(3:4)];  set(hb,'position',pos2);

% TEXT
hb=uicontrol('Style','text', 'Position',[25 25 16, 16], ...
    'string',[num2str(ipn)],'fontsize',7,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'foregroundcolor',[0.8706    0.4902  0],'fontweight','bold');

%% ===============================================

%% ____________________LEFT_________________________________________________

% e= which('t1.png');
% v = imread(e); if size(v,3)==1; v=repmat(v,[1 1 3]); end

v=uint8(geticon('arrow'));
% v(v==v(1,1,1))=max(v(:));
s=v; n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,1});
% ==============================================
%%   edit
% ===============================================
s=v;
hb=uicontrol('Style','edit', 'Position',[25 25 16, 16], ...
    'fontsize',7,       'tag','ed_transstep',...
    'BackgroundColor','w','userdata',id,'string',p.steptrans(1));
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2)+pos(4) pos(3)*4  pos(4)];  set(hb,'position',pos2);
set(hb,'callback',@ed_transstep);

wid=pos(3);
s=v;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'fontsize',7,...
    'BackgroundColor','w','userdata',id,'string','-');
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+wid*n tp(2)+pos(4) pos(3) pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,101});

hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'fontsize',7,...
    'BackgroundColor','w','userdata',id,'string','+');
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+wid*(n+3) tp(2)+pos(4) pos(3) pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,102});

%% ____________RIGHT____________________________________________________________________________________
s=fliplr(v); n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,2});
%% ____________________DOWN____________________________________________________________________________
s=rot90(v);n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,3});
%% __________________UP______________________________________________________________________________
s=flipud(rot90(v));n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,4});


%% ===============================================

% e= which('rotate.png');
% strcmp(name,'rotate')
% v = imread(e); if size(v,3)==1; v=repmat(v,[1 1 3]); end

v=uint8(geticon('rotate'));
if size(v,3)==1; v=repmat(v,[1 1 3]); end

%% ________________________________________________________________________________________________
s=v;n=n+1.2;

% ==============================================
%%   edit ROTstep
% ===============================================
s=v;
hb=uicontrol('Style','edit', 'Position',[25 25 16, 16], ...
    'fontsize',7,       'tag','ed_rotstep',...
    'BackgroundColor','w','userdata',id,'string',p.steprot(1));
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2)+pos(4) pos(3)*4  pos(4)];  set(hb,'position',pos2);
wid=pos(3);
set(hb,'callback',@ed_rotstep);

s=v;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'fontsize',7,...
    'BackgroundColor','w','userdata',id,'string','-');
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+wid*n tp(2)+pos(4) pos(3) pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,103});

hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'fontsize',7,...
    'BackgroundColor','w','userdata',id,'string','+');
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+wid*(n+3) tp(2)+pos(4) pos(3) pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,104});
%% _________ROTATION ACW_______________________________________________________________________________________
s=v;n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,5});

%% ________ROTATION CW________________________________________________________________________________________
s=fliplr(v);n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@cb_ilist,6});
%% ________________________________________________________________________________________________

hp=findobj(gcf,'tag','move');
je = findjobj(hp); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',{@motio,id}  );



function motio(e,e2,id)
try
    units=get(0,'units');
    set(0,'units','norm');
    mp=get(0,'PointerLocation');
    set(0,'units',units);
    
    fp  =get(gcf,'position');
    %hp  =findobj(gcf,'tag','move');
    hp  =findobj(gcf,'tag','move', '-and' ,'userdata',id);
    pos =get(hp,'position');
    % set(hp,'position',[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4)) pos(3:4)])
    % get(gcf,'currentpoint')
    %  0.5571    0.5000
    mid=pos(3:4)/2;
    newpos=[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4))];
    if newpos(1)-mid(1)<0; newpos(1)=mid(1); end
    if newpos(2)-mid(2)<0; newpos(2)=mid(2); end
    if newpos(1)-mid(1)+pos(3)>1; newpos(1)=1-pos(3)+mid(1); end
    if newpos(2)-mid(2)+pos(4)>1; newpos(2)=1-pos(4)+mid(2); end
    
    %     if newpos(2)+pos(4)>1; newpos(2)=1-pos(4); end
    
    
    df=pos(1:2)-newpos+mid;
    hx=findobj(gcf,'userdata',id);%'ipn1');
    pos2=cell2mat(get(hx,'position'));
    for i=1:length(hx)
        pos3=[ pos2(i,1:2)-df   pos2(i,[3 4])];
        set(hx(i),'position', pos3);
    end
end


function cb_ilist(e,e2, do)
% do
id= get(e,'userdata');
hfig=findobj(0,'tag','Graphics');


hm = findobj(gcf,'tag','mission');
p=get(hm,'userdata');


if do==101 %% EDIT TRANSLATIONSTEP
    hr=findobj(gcf,'tag','ed_transstep');
    val=str2num(get(hr(1),'string'));
    val=val-p.steptrans(2);
    if val>0;     set(hr,'string',val); end
elseif do==102
    hr=findobj(gcf,'tag','ed_transstep');
    val=str2num(get(hr(1),'string'));
    val=val+p.steptrans(2);
    if val>0;     set(hr,'string',val); end
    
    
elseif do==103 %% EDIT ROTATION
    hr=findobj(gcf,'tag','ed_rotstep');
    val=str2num(get(hr(1),'string'));
    val=val-p.steprot(2);
    if val>0;     set(hr,'string',val); end
elseif do==104
    hr=findobj(gcf,'tag','ed_rotstep');
    val=str2num(get(hr(1),'string'));
    val=val+p.steprot(2);
    if val>0;     set(hr,'string',val); end
end

%% ______PANEL1__________________________________________________________________________________________
if strcmp(id,'ipn1')
    if do==1
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(1) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==2
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(1) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==3
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(3) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==4
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(3) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==5
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(5) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==6
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(5) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex,  stp );
    end
end

%% ______PANEL2__________________________________________________________________________________________
if strcmp(id,'ipn2')
    if do==1
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(2) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==2
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(2) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==3
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(3) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==4
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(3) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==5
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(4) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==6
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(4) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    end
end

%% ______PANEL3__________________________________________________________________________________________
if strcmp(id,'ipn3')
    if do==1
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(1) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==2
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(1) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==3
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(2) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, stp );
    elseif do==4
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(2) ')' ]);
        hr=findobj(gcf,'tag','ed_transstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==5
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(6) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex, -stp );
    elseif do==6
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(6) ')' ]);
        hr=findobj(gcf,'tag','ed_rotstep');
        stp=str2num(get(hr(1),'string'));
        do2(ex,  stp );
    end
end


return
for i=1:6
    ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
    set(hfig,'CurrentObject',ex  );
    set(ex,'string',num2str(mat(i)) );
    hgfeval(get(ex,'callback'));
end
spm_orthviews('context_menu','orientation',3);
spm_orthviews2('Redraw');


function do2(ex, stp )

hfig=findobj(0,'tag','Graphics');
% e=sort(findobj(gcf,'style','edit'));
% ex=findobj(gcf,'callback' ,callback);

val0=str2num(get(ex,'string'));
val=val0+stp  ;
set(hfig,'CurrentObject',ex)
set(ex,'string',num2str(val) );
hgfeval(get(ex,'callback'));
spm_orthviews2('Redraw');


function ed_transstep(e,e2)
% set(hb,'callback',@ed_transstep);
set(findobj(gcf,'tag','ed_transstep'),'string', get(e,'string'));
function ed_rotstep(e,e2)
set(findobj(gcf,'tag','ed_rotstep'),'string', get(e,'string'));



function v=geticon(name)

if strcmp(name,'arrow')
    v(:,:,1) =[
        0    0    0    0    1    6   56   97   97   57    8    1    0    0    0    0
        0    0    0   10  127  207  177  149  145  156  176  117   12    0    0    0
        0    0   18  189  138   90   94   90  125  162   92  103  145   22    0    0
        0    9   81   85   79  117  255  254   78   81   81   78   81  117   11    0
        1   99   72   66  106  255  255  254   64   72   72   65   72   71   69    1
        4  141   53   82  255  255  255  254   50   58   58   50   58   58   72    6
        33   96   72  255  255  255  255  255  254  254  254  254  253   45   46   25
        50   61  255  255  255  255  255  255  255  255  255  255  254   32   33   20
        43   44  209  255  255  255  255  255  255  255  255  255  254   19   20   12
        22   37    1  209  255  255  255  255  208  208  208  208  207    5    6    5
        1   44    0    2  209  255  255  254    0    1    1    1    1    0    0    3
        0   29    0    0    2  209  255  254    0    0    0    0    0    0    1    0
        0    0    0    0    0    2  238  207    0    0    0    0    0    0    0    0
        0    0    0   10    0    0    1    1    1   69    0    0    0    0    0    0
        0    0    0    0    4    1    0    0    0    0    0    0    0    0    0    0
        0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0];
    v(:,:,2) =[
        0    0    0    0    8   44  113  147  147  113   44    8    0    0    0    0
        0    0    0   61  173  241  241  233  232  236  233  169   60    0    0    0
        0    0   76  226  227  210  210  209  219  229  211  218  212   75    0    0
        0   56  202  204  202  213  255  255  202  205  205  202  205  201   56    0
        7  162  196  194  207  255  255  255  193  196  196  193  196  199  147    7
        36  225  186  195  255  255  255  255  184  188  188  185  188  188  191   37
        93  211  188  255  255  255  255  255  255  255  255  255  254  178  183   89
        123  192  255  255  255  255  255  255  255  255  255  255  255  171  174  104
        117  183  242  255  255  255  255  255  255  255  255  255  255  163  166   98
        84  179  114  242  255  255  255  255  241  242  242  242  241  154  159   76
        28  176  148  114  242  255  255  254  113  113  113  113  113  151  152   29
        5  122  151  149  114  242  255  255  146  151  151  147  151  154  116    5
        0   35  152  151  149  114  248  241  147  152  152  147  152  147   38    0
        0    0   46  145  154  151  151  149  150  179  147  154  147   50    0    0
        0    0    0   35  103  149  156  154  154  154  153  113   36    0    0    0
        0    0    0    0    5   24   64   82   83   66   24    4    0    0    0    0];
    v(:,:,3) =[
        0    0    0    0    0    0   32   77   77   33    0    0    0    0    0    0
        0    0    0    0  110  203  174  144  140  152  171  100    0    0    0    0
        0    0    1  183  133   84   88   84  119  159   87   99  138    2    0    0
        0    0   76   80   73  112  255  254   73   76   76   73   76  109    0    0
        0   85   68   62  103  255  255  254   60   68   68   61   68   68   56    0
        1  136   49   79  255  255  255  254   45   53   53   46   53   54   66    0
        19   92   68  255  255  255  255  255  254  254  254  254  253   42   44   13
        39   57  255  255  255  255  255  255  255  255  255  255  254   30   32    9
        34   43  205  255  255  255  255  255  255  255  255  255  254   18   19    4
        14   36    1  205  255  255  255  255  204  204  204  204  203    4    5    0
        0   41    0    2  205  255  255  254    0    1    1    1    1    0    0    0
        0   26    0    0    2  205  255  254    0    0    0    0    0    0    0    0
        0    0    0    0    0    2  238  203    0    0    0    0    0    0    0    0
        0    0    0    9    0    0    1    1    1   69    0    0    0    0    0    0
        0    0    0    0    3    1    0    0    0    0    0    0    0    0    0    0
        0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0];

elseif strcmp(name,'hand')
    v=[129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];
elseif strcmp(name,'rotate')
v=[  252  255  252  252  254  255  254  252  255  254  252  254  255  252  252  255
  255  255  252  255  252  255  252  255  255  252  255  252  255  252  255  255
  252  255  252  255  252  248  155   79   41   41   79  155  248  252  255  255
  252  255  252  255  227   74   37   37   37   37   37   37   74  227  255  255
  255  255  255  248   74   37   71  188  245  245  188   71   37   74  248  255
  255  255  255  157   37   71  242  255  255  255  255  242   71   37  157  255
  252  160  255   79   37  188  160  252  254  255  254  252  188   37   78  254
  252   37  146   41   37  136   37  255  252  255  252  255  245   37   41  252
  255   44   37   37   37   37   44  255  252  255  252  255  245   37   41  252
  252  178   39   37   37   39  178  255  252  255  254  252  188   37   78  254
  255  255  180   39   39  180  255  255  255  255  255  242   71   37  157  255
  255  255  255  185  185  255  255  201  245  245  188   71   37   74  248  255
  252  252  255  252  252  255  200   37   37   37   37   37   74  229  252  255
  252  255  255  252  255  255  184   79   41   41   79  155  248  252  255  255
  252  255  255  255  252  255  255  252  255  252  255  252  255  252  255  255
  252  255  255  252  252  255  255  252  255  252  255  252  255  254  252  255];
end

















