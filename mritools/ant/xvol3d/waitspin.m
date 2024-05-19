%waitspin: make waitspin in current figure
% status: {1,2,0};
%      1...initialize
%      2...update
%      0...close
% msg:  message such as 'busy'
% msgtt: tooltipstring... (char or cell) tooltipstring is subsequently updated
%% EXAMPLE
% fg
% waitspin(1,'BUSY stuff1','analsysis-1'); pause(1);
% waitspin(2,'BUSY stuff2',{'analsysis-2' '...another messagge!'}); pause(1);
% waitspin(0,'Done');
%
% __ADDITIONAL INPUTS____
% position: <4 values in pixels>!  default: [10,10,80,80]
%
% __EXAMPLE-1__
% fg; waitspin(1,'BUSY stuff1','analsysis-1','position',[100 200 20 20],'color',[1 0 0]);
% 
% __EXAMPLE-2__
% fg; waitspin(1,'BUSY','analsysis-1','position',[4 4  55 55],'color',[1 .5 0]);
% pause(1)
% waitspin(2,' 90%','analsysis-2','color',[1 .5 1]);
% pause(1)
% waitspin(0);
function waitspin(status,msg,msgtt,varargin)
warning off;
p.dummy='dummy';
p.position= [10,10,80,80];     %spinner pos
% p.color   = [1.0, 0.78, 0.0]; %bg-color
if nargin>3
    px= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,px);
end

if 0
    % ==============================================
    %%
    % ===============================================
    tic
    fg
    waitspin(1,'busy1','analsysis-1');
    for i=1:1e9;
        %         disp(i);
        i=i+1;
    end
    waitspin(2,'busy2','analsysis-2');
    for i=1:1e9;
        %         disp(i);
        i=i+1;
    end
    waitspin(0,'Done','--');
    toc
    % ==============================================
    %%
    % ===============================================
    
    
end


if exist('status')==0
    status=1;
end
if exist('msg')==0
    msg='busy';
end
if exist('msgtt')==0
    msgtt='';
    % msgtt={'busy' 'rfd'};
end
if iscell(msgtt)
    msgtt=strjoin(msgtt,'<br>');
end



if status==1
    hv=findobj(gcf,'tag','waitspin');
    try; delete(hv); end
    
    try
        % R2010a and newer
        iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
        iconsSizeEnums = javaMethod('values',iconsClassName);
        SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
        job = com.mathworks.widgets.BusyAffordance(SIZE_32x32, msg);  % icon, label
    catch
        % R2009b and earlier
        redColor   = java.awt.Color(1,0,0);
        blackColor = java.awt.Color(0,0,0);
        job = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
    end
    % job.getComponent.setFont(java.awt.Font('Monospaced',java.awt.Font.PLAIN,1))
    job.setPaintsWhenStopped(true);  % default = false
    job.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    %[hj hv]=javacomponent(job.getComponent, [10,10,80,80], gcf);
    [hj hv]=javacomponent(job.getComponent, [p.position], gcf);
    set(hv,'units','norm');
    
    %     FontName = 'Consolas';
    %     javaLangString = java.lang.String(FontName);
    %     javaAwtFont = java.awt.Font(javaLangString,0,3);
    %
    %     jFont = java.awt.Font('Arial', java.awt.Font.PLAIN, 30);
    %     hj.setFont(jFont);
    %     job.getComponent.setFont(jFont);
    %     set(hv,'position',[.6 .2 .20 .20]);
    % job.getComponent.setFont(job.getComponent.getFont.deriveFont(70))
    
    
    set(hv,'tag','waitspin');
    if isfield(p,'color')==0
       % [1.0, 0.78, 0.0]
        job.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    else
        job.getComponent.setBackground(java.awt.Color(p.color(1), p.color(2),p.color(3)));  % orange
    end
    job.start;
    
    hj.setToolTipText(['<html><font color=green>start:<font color=black> ' datestr(now) ' --> ' msgtt '<br>']);
    
    %job.useWhiteDots(1)
    hv=findobj(gcf,'tag','waitspin');
    
    %     c = uicontextmenu;
    % b = uicontrol('UIContextMenu',c);
    %     set(hv,'UIContextMenu',b)
    %     m1 = uimenu(hv.UIContextMenu,'Label','dashed','Callback',@setlinestyle);
    %
    % hp=findobj(hfig,'tag','move');
    % je = findjobj(job); % hTable is the handle to the uitable object
    set(hj,'MouseDraggedCallback',{@drag_waitspin}  );
    
    % ==============================================
    %%   contextMenu
    % ===============================================
    
    % Prepare the context menu (note the use of HTML labels)
    menuItem1 = javax.swing.JMenuItem('close');
    menuItem2 = javax.swing.JMenuItem('set transparent');
    % menuItem2 = javax.swing.JMenuItem('<html><b>action #2');
    % menuItem3 = javax.swing.JMenuItem('<html><i>action #3');
    % Set the menu items' callbacks
    set(menuItem1,'ActionPerformedCallback',{@contextCB,'close'});
    set(menuItem2,'ActionPerformedCallback',{@contextCB,'transparent'});
    % set(menuItem2,'ActionPerformedCallback',{@myfunc2});
    % set(menuItem3,'ActionPerformedCallback','disp ''action #3...'' ');
    % Add all menu items to the context menu (with internal separator)
    jmenu = javax.swing.JPopupMenu;
    jmenu.add(menuItem1);
    % % jmenu.add(menuItem2);
    jmenu.addSeparator;
    jmenu.add(menuItem2);
    hj.setComponentPopupMenu(jmenu);
    
    
    
    
    %     us=get(gcf,'userdata');
    %     us.hwaitspin =hv;
    %     us.jwaitspin =job;
    %     set(gcf,'userdata',us);
    setappdata(hv,'userdata',job);
    
elseif status==2
    hv=findobj(gcf,'tag','waitspin');
    hv=hv(1);
    job=getappdata(hv,'userdata');
    %     us=get(gcf,'userdata');
    %     job=us.jwaitspin;
    job.setBusyText(msg); %'All done!');
    if isfield(p,'color')==0;%isempty(regexpi2(varargin,'position'))
        job.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    else
        job.getComponent.setBackground(java.awt.Color(p.color(1), p.color(2),p.color(3)));  % userDefined
    end
    hj=(job.getComponent);
    msgtt2=[...
        char(hj.getToolTipText) ...
        ['<html><font color=green>start:<font color=black> ' datestr(now) ' --> ' msgtt '<br>']...
        ];
    hj.setToolTipText(msgtt2);
    
    set(hv,'visible','on');
    drawnow;
elseif status==0
    hv=findobj(gcf,'tag','waitspin');
    if isempty(hv)
        hv=findobj(0,'tag','waitspin');
    end
    hv=hv(1);
    job=getappdata(hv,'userdata');
    %us=get(gcf,'userdata');
    %job=us.jwaitspin;
    job.stop;
    job.setBusyText(msg); %'All done!');
    job.getComponent.setBackground(java.awt.Color(.4667,    0.6745,    0.1882));  % green
    drawnow
    pause(.2);
    %job.getComponent.setVisible(false);
    %set(us.hwaitspin,'visible','off');
   try; set(hv,'visible','off');end
end

drawnow;


function contextCB(e,e2,task)
% task
if strcmp(task,'close')
    waitspin(0);
elseif strcmp(task,'transparent')
    hv=findobj(gcf,'tag','waitspin');
    job=getappdata(hv,'userdata');
    if job.getComponent.isOpaque==0
        job.getComponent.setOpaque(1);
        job.getComponent.setBackground(java.awt.Color(0,0,0,0));  % green
    else
        job.getComponent.setOpaque(0);
        job.getComponent.setBackground(java.awt.Color(0,0,0,0));  % green
    end
end


function drag_waitspin(e,e2)
hv=findobj(gcf,'tag','waitspin');
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
%disp(xx)
%disp(posS)
%disp(posF)
%disp(mp)
%disp(yy);
%disp([xx yy]);
set(hv,'position',[ xx yy pos(3:4)]);

set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);



