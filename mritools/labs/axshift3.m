
function axshift2

% axshift2 interactively SHIFT/RESIZE all or some axes of a figure and parse 
% new positions to workspace or put positions as generated code e.g. via 
% clipboard to your own script
% 
% USAGE
% [1] plot a figure with subplots
% [2] type AXSHIFT2 in commmand window
% [3] activate AXSHIFT2-PUSHBUTTON in the figure's toolbar
% [4] NOW YOUR TURN: SHIFT/RESIZE all or some axes using CONTEXTMENU or
%     KEYBOARD-SHORTKEYS
% [5] parse new positions to workspace or parse short script with positions
%     to workspace/clipboard (you can copy the stuff into your own script..)
% 
% CONTEXTMENU & SHORTCUTS
% =============================================
%  • [S]HIFT axis                       [ S ] 
%  • shift [G]ROUP of axes                 [ G ]
%  • resize [A]LL axes (Mousewheel)        [ A ]
%  • [R]ESIZE axis                         [ R ]
%  • [F]IT axes-layout to figure-size      [ F ]
%  • [C]OPY current axis-size to all axes  [ C ]
%  • background-none (for plots only)    
%  • background-original (for plots only)
%  • positions-original'                 
%  • toggle: current/last positions      [ SPACE ]
%  • positions to workspace (axshiftnew) 
%  • snippet to workspace               
%  • [H]ELP                                [ H ]
%   
%  HELP:  CONTEXTMENU  & SHORTCUTS;
% =============================================
% [1] shift an axis                       [ S ]
%     • shift position of an axis
%     -click on axis,keep button down and drag axis to another position
% 
% [2] shift group of axes                 [ G ]
%     • shift position of one ore more axes
%     -click somewhere on figure, keep button down and drag the diagonal corner
%      of the new created rectangle until the requested axis/axes is/are sourounded
%      by the recangle. then relase the button (the axes caught by the rectangle
%      appear highlighted)
%     -click on/within the rectangle (but NOT on the caught axes), keep button down
%      and drag the rectangle with axes to another position     
%     
% [3] resize all axes (Mousewheel)        [ A ]
%     • use mousewheel to increase/decrease size of all axes
% 
% [4] resize an axis                      [ R ]
%     • increase/decrease size of the selected axes
%      
% [5] [F]IT axes-layout to figure-size [ F ]
%     ..the axes-layout is stretched to fit the figure
%     
% [6] copy current axis-size to all axes  [ C ]
%     • all axes get the size (not position!) of the current axis
%     -might by usefull when a standard widht+hight is essential
%     
% [7] background-none (for plots only)    
%     • set background of axes transparent
%     -works only for plots not image/imagesc/..)
%     
% [8] background-original (for plots only)
%     • set background of axes to default
%     -works only for plots not image/imagesc/..)
%     
% [9] positions-original'
%     • set axes to their original positions
%     
% [10] toggle: current/last positions      [ SPACE ]
%     • switch between current positions and the last modified positions
%     
% [11] positions to workspace (axshiftnew) 
%     • parse positions to workspace
%     -a new variable is crated axshiftnew
%     -axshiftnew contains the positions as Nx4 matrix, where N is the number
%      of axes; and 4 columns (posX,posY, width,hight)
%     -NOTE: the order of the axes in axshiftnew matches the originally
%      plottet order!
%     -matrix is also displayd in the command window
%      
% [12] snippet to workspace
%     • parse positions as snippet to workspace and clipboard
%     -use snippet for new figures within other functions
%     -example snippet:
% 
%         pax=[0.0494941447269404 0.631620782657371 0.271512581246337 0.348379217342629;0.708487418753663 0.631620782657371 0.271512581246337 0.348379217342629;0.377597798241582 0.0772994882085952 0.271512581246337 0.874057865305129;0.0494941447269402 0.0518472177008869 0.271512581246337 0.546559688791636;0.706277858721211 0.0395924207897683 0.271512581246337 0.562821230471731];
%         figure('color','w'); 
%         for i=1:size(pax,1)
%             hax(i)=axes('position',pax(i,:));
%         end
% 
% 
% [13] HELP                                [ H ]
%     • show this help
% 
%  EXAMPLE
%  ========================
%      %plot a sample layout 
%      pax=[0.331309203316243 0.892105804196067 0.0472245203111649 0.0898275786910723;0.652189354737306 0.898097644350808 0.0472245203111649 0.0898275786910723;0.195110277849023 0.894639619305901 0.0472245203111649 0.0898275786910723;0.783469924133279 0.899489191495263 0.0472245203111651 0.0898275786910723;0.263177091132162 0.896773077016503 0.0472245203111646 0.0898275786910723;0.722984927634088 0.899644895511562 0.0472245203111649 0.0898275786910723;0.0357911895498774 0.74498909852264 0.0472245203111649 0.0898275786910723;0.102618789055717 0.769599337130626 0.0472245203111646 0.0898275786910723;0.17198127897439 0.793201821602676 0.0472245203111646 0.0898275786910723;0.242038213337505 0.793201821602676 0.0472245203111646 0.0898275786910723;0.31209514770062 0.793201821602676 0.0472245203111646 0.0898275786910723;0.382152082063737 0.793201821602676 0.0472245203111646 0.0898275786910723;0.452209016426852 0.793201821602676 0.0472245203111649 0.0898275786910723;0.522265950789967 0.793201821602676 0.0472245203111649 0.0898275786910723;0.592322885153084 0.793201821602676 0.0472245203111649 0.0898275786910723;0.6623798195162 0.793201821602676 0.0472245203111649 0.0898275786910723;0.732436753879315 0.793201821602676 0.0472245203111649 0.0898275786910723;0.802493688242432 0.793201821602676 0.0472245203111649 0.0898275786910723;0.871161733716658 0.774568281230005 0.0472245203111649 0.0898275786910723;0.930647352894516 0.755196381900459 0.0472245203111649 0.0898275786910723;0.0357911895498774 0.638125185521942 0.0472245203111649 0.0898275786910723;0.102618789055717 0.662735424129929 0.0472245203111646 0.0898275786910723;0.17198127897439 0.686337908601979 0.0472245203111646 0.0898275786910723;0.242038213337505 0.686337908601979 0.0472245203111646 0.0898275786910723;0.31209514770062 0.686337908601979 0.0472245203111646 0.0898275786910723;0.382152082063737 0.686337908601979 0.0472245203111646 0.0898275786910723;0.452209016426852 0.686337908601979 0.0472245203111649 0.0898275786910723;0.522265950789967 0.686337908601979 0.0472245203111649 0.0898275786910723;0.592322885153084 0.686337908601979 0.0472245203111649 0.0898275786910723;0.6623798195162 0.686337908601979 0.0472245203111649 0.0898275786910723;0.732436753879315 0.686337908601979 0.0472245203111649 0.0898275786910723;0.802493688242432 0.686337908601979 0.0472245203111649 0.0898275786910723;0.871161733716658 0.667704368229308 0.0472245203111649 0.0898275786910723;0.930647352894516 0.648332468899761 0.0472245203111649 0.0898275786910723;0.0357911895498774 0.531261272521244 0.0472245203111649 0.0898275786910723;0.102618789055717 0.555871511129231 0.0472245203111646 0.0898275786910723;0.17198127897439 0.579473995601281 0.0472245203111646 0.0898275786910723;0.242038213337505 0.579473995601281 0.0472245203111646 0.0898275786910723;0.31209514770062 0.579473995601281 0.0472245203111646 0.0898275786910723;0.382152082063737 0.579473995601281 0.0472245203111646 0.0898275786910723;0.592322885153084 0.579473995601281 0.0472245203111649 0.0898275786910723;0.6623798195162 0.579473995601281 0.0472245203111649 0.0898275786910723;0.732436753879315 0.579473995601281 0.0472245203111649 0.0898275786910723;0.802493688242432 0.579473995601281 0.0472245203111649 0.0898275786910723;0.871161733716658 0.56084045522861 0.0472245203111649 0.0898275786910723;0.930647352894516 0.541468555899063 0.0472245203111649 0.0898275786910723;0.0357911895498774 0.424397359520546 0.0472245203111649 0.0898275786910725;0.102618789055717 0.449007598128532 0.0472245203111646 0.0898275786910725;0.17198127897439 0.472610082600582 0.0472245203111646 0.0898275786910725;0.242038213337505 0.472610082600582 0.0472245203111646 0.0898275786910725;0.31209514770062 0.472610082600582 0.0472245203111646 0.0898275786910725;0.6623798195162 0.472610082600582 0.0472245203111649 0.0898275786910725;0.732436753879315 0.472610082600582 0.0472245203111649 0.0898275786910725;0.802493688242432 0.472610082600582 0.0472245203111649 0.0898275786910725;0.871161733716658 0.453976542227911 0.0472245203111649 0.0898275786910725;0.930647352894516 0.434604642898365 0.0472245203111649 0.0898275786910725;0.17198127897439 0.365746169599884 0.0472245203111646 0.0898275786910725;0.242038213337505 0.366987695302875 0.0472245203111646 0.0898275786910725;0.732436753879315 0.365746169599884 0.0472245203111649 0.0898275786910725;0.802493688242432 0.365746169599884 0.0472245203111649 0.0898275786910725;0.192120167863279 0.253913312499808 0.0472245203111646 0.0898275786910725;0.262177102226394 0.253913312499808 0.0472245203111646 0.0898275786910725;0.715075642768204 0.257640020574342 0.0472245203111649 0.0898275786910725;0.785132577131321 0.257640020574342 0.0472245203111649 0.0898275786910725;0.244997151990263 0.139906542356253 0.0472245203111646 0.0898275786910725;0.311681070480362 0.140113581693727 0.0472245203111646 0.0898275786910725;0.669242309434871 0.14704939949911 0.0472245203111649 0.0898275786910725;0.737215910464654 0.145807163474265 0.0472245203111649 0.0898275786910725;0.294501120244231 0.0298335196247061 0.0472245203111646 0.0898275786910725;0.360986626035918 0.0282807245936502 0.0472245203111646 0.0898275786910725;0.622020087212648 0.0389432504735673 0.0472245203111649 0.0898275786910725;0.690587505364241 0.0386738552945063 0.0472245203111649 0.0898275786910725];
%      figure('color','w');
%      for i=1:size(pax,1)
%          hax(i)=axes('position',pax(i,:));
%          imagesc(rand(100));
%          title([num2str(i)],'fontweight','bold','backgroundcolor',[1 1 0],...
%          'fontsize',9,'verticalalignment','top');
%      end
%      set(hax,'fontsize',6)
%      axshift2
% 
% 
% ----------------------------------------------------------------------
%                                                      Paul, BNIC 2010
% ----------------------------------------------------------------------



% ==================
% define icon pushbutton
% ==================%
x.do=1; %toggle between onOffStates of icon
x.icon =icon;%imagefun
x.tagname='axshift';


hToolbar = findall(gcf,'Type','uitoolbar');%create icon in toolbar
try
    bb=findall(gcf,'Type','uipushtool','Tag',x.tagname);
    delete(bb);
end

if ~isempty(hToolbar) && isempty(findall(gcf,'Type','uipushtool',...
        'Tag',x.tagname))
    hPush = uipushtool('parent',hToolbar, ...
        'separator','on', ...
        'HandleVisibility','off', ...
        'TooltipString','shift line', ...
        'tag',x.tagname);
    set(hPush,'userdata',x , 'ClickedCallback',  {@update_pushtool,gcf,hPush},...
        'cdata',x.icon(:,:,:,2)  ); %set userdata, callback, iconimage
end% if
q=findall(gcf,'Type','uitoggletool');
set(q,'oncallback',x.tagname);%if another icon is clicked, renew uilineshift-function (e.g. it's deactivated)

%••••••••••••••••••••••••••••••••••••••••••••••
%  pushbutton IS CLICKED: this can be de-or activated 
%••••••••••••••••••••••••••••••••••••••••••••••
function update_pushtool(cnc1,cnc2,gcf,hPush)
warning off
set(gcf,'WindowButtonupFcn',@figButtonup);
warning on;
%-------------------------------------------------------------------------------
set(findall(gcf,'Type','uitoggletool'),'state','off');%set all other icons 'off'
if ~ishandle(hPush);    return; end% if
x=get(hPush,'userdata');
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
if x.do==0 %•••••••• do off-STATE ••••••••••••••••••••••••••••••pushbutton
    set(findall(gcf,'Type','uitoggletool'),'state','off');
    img=x.icon(:,:,:,2);%replace image
    %clean CONTEXTMENU
    for i=1:length(x.ch); 
        set(x.ch,'UIContextMenu',[]); 
        set(x.ch,'ButtonDownFcn',[]); 
        set(x.ch,'userdata',[]); 
    end
    set(gcf,'UIContextMenu',[]);
    %UP'nDOWN'motion,'wheel'
    set(gcf,'WindowButtonDownFcn',[]);
    set(gcf,'WindowButtonUpFcn',[]);
    set(gcf,'WindowButtonMotionFcn',[]);
    set(gcf,'WindowScrollWheelFcn',[]);
    
    %clean userdata
    y.do=x.do;
    y.icon=x.icon;
    y.tagname=x.tagname;
    x=y;
    set(pushbutt,'userdata',x);
else  %•••••••• do activate ••••••••••••••••••••••••••••••
     set(findobj(gcf,'type','plot'),'ButtonDownFcn',[])
    set(findobj(gcf,'type','image'),'ButtonDownFcn',[]);
    set(findobj(gcf,'type','axes'),'ButtonDownFcn',[]);
%     chx=findobj(gcf,'type','axes');
%     for i=1:length(chx)
%        
%        set(allchild(gca) ,'ButtonDownFcn',[]);
%     end
    
    activateuimode(gcf,'');
    set(findall(gcf,'Type','uitoggletool'),'state','off');
    img=x.icon(:,:,:,1); %replace image
    warning off;
    set(gcf,'WindowButtonupFcn',@figButtonup);
    warning on;
    %     cmenu; %set contextmenu
    set(pushbutt,'userdata',x);
    iconON([]); 
    
end%
x=get(pushbutt,'userdata');
x.do=~x.do;%toggle state
set(hPush,'cdata',img,'userdata',x);%replace image+change userdata

% ==================
% ICONS
% ==================
function img =icon()
c(:,:,1)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.41176           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.41176           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.38824           0     0.38824     0.41176           1         0.4     0.80392           1           1         0.4           1           1           1           1; 0.99608           0           1           1           1     0.41176           1           0           1           0           1         0.4           1           1           1           1; 0.99608           0           1           1           1    0.023529           1           0           1           1           0           0           1           1           1           1; 0.99608           0           0           0           0    0.023529           1           0           0           0           0           0           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.41176     0.41176           1           1           1           1     0.42353     0.42353     0.42353     0.42353     0.42353           1; 0.99608         0.4           1           1           1     0.41176           1           1           1           1     0.42353           1           1           1     0.42353           1; 0.99608         0.4           1           1     0.62353     0.41176           1         0.8           1           1     0.42353           0           1           1     0.42353           1; 0.99608         0.4           1     0.38824           1     0.41176           1         0.8         0.8           1     0.18824           1           0           1     0.42353           1; 0.99608           0     0.38824           1           1     0.60784     0.57647     0.57647     0.57647     0.57647     0.18824           1           1           0     0.42353           1; 0.99608           0           1           1           1    0.078431           1         0.6         0.6           1     0.18824           1           1           1     0.18824           1; 0.99608           0           0           0    0.078431    0.078431           1         0.6           1           1     0.18824     0.18824     0.18824     0.18824     0.18824           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,2)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.39216           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.39216           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.40392   0.0039216     0.40392     0.39216           1         0.4     0.80392           1           1         0.4           1           1           1           1; 0.99608   0.0039216           1           1           1     0.39216           1   0.0039216           1   0.0039216           1         0.4           1           1           1           1; 0.99608   0.0039216           1           1           1           0           1   0.0039216           1           1   0.0039216   0.0039216           1           1           1           1; 0.99608   0.0039216   0.0039216   0.0039216   0.0039216           0           1   0.0039216   0.0039216   0.0039216   0.0039216   0.0039216           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.39216     0.39216           1           1           1           1     0.79216     0.79216     0.79216     0.79216     0.79216           1; 0.99608         0.4           1           1           1     0.39216           1           1           1           1     0.79216           1           1           1     0.79216           1; 0.99608         0.4           1           1     0.58431     0.39216           1         0.4           1           1     0.79216     0.41176           1           1     0.79216           1; 0.99608         0.4           1     0.40392           1     0.39216           1         0.4         0.4           1         0.6           1     0.41176           1     0.79216           1; 0.99608   0.0039216     0.40392           1           1           0   0.0078431   0.0078431   0.0078431   0.0078431         0.6           1           1     0.41176     0.79216           1; 0.99608   0.0039216           1           1           1           0           1   0.0039216   0.0039216           1         0.6           1           1           1         0.6           1; 0.99608   0.0039216   0.0039216   0.0039216           0           0           1   0.0039216           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,3)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.40784           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.40784           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.98824     0.99608     0.98824     0.40784           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608           0           1           1           1     0.40784           1           0           1     0.99608           1         0.4           1           1           1           1; 0.99608           0           1           1           1           0           1           0           1           1     0.99608           0           1           1           1           1; 0.99608           0           0           0           0           0           1           0           0           0           0           0           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.40784     0.40784           1           1           1           1           0           0           0           0           0           1; 0.99608         0.4           1           1           1     0.40784           1           1           1           1           0           1           1           1           0           1; 0.99608         0.4           1           1           1     0.40784           1   0.0078431           1           1           0     0.99608           1           1           0           1; 0.99608         0.4           1     0.98824           1     0.40784           1   0.0078431   0.0078431           1    0.035294           1     0.99608           1           0           1; 0.99608           0     0.98824           1           1           0    0.019608    0.019608    0.019608    0.019608    0.035294           1           1     0.99608           0           1; 0.99608           0           1           1           1           0           1           0           0           1    0.035294           1           1           1    0.035294           1; 0.99608           0           0           0           0           0           1           0           1           1    0.035294    0.035294    0.035294    0.035294    0.035294           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
img(:,:,:,1) =c;
c(:,:,1)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,2)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,3)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
img(:,:,:,2) =  c;

% ==================
% BUTTON-UP/DOWN
% ==================
function figButtonup(this,varargin);%du UPDATE


% ==================
% UPDATE
% ==================
% 
% function cb1(varargin)
% p=findobj(gca,'type','line');%get all line-handles
% 
% for k = 1:length(p)
%     s=get(p(k),'UserData');
%     set(p(k),'xdata', s.xorig);
%     set(p(k),'ydata', s.yorig);
% end

%%%••••••••••••••••••••••••••••••••••••••••••••••
%   subfuns icon on/off7 ICON IS CLICKES
%%%••••••••••••••••••••••••••••••••••••••••••••••
function iconON(obj, event, pm)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
set(pushbutt,'TooltipString',  get(pushbutt,'tag')   );
x=get(pushbutt,'userdata');
x.tgnow=0;
if x.tgnow==0
    set(pushbutt,'TooltipString','shift axes ON');  %shift axes ON
    set (gcf, 'WindowButtonDownFcn', {@gdown, x});
    set (gcf, 'WindowButtonUpFcn', {@gup, x});
    x.tgnow=1; %make status ON

   %UNITS
    x.units=get(gcf,'units');
    set(gcf,'unit','normalized');
    
    x.ch=findobj(gcf,'type','axes');
    x.bgcol=get(x.ch,'color');
    x.posorig=get(x.ch,'position');
    x.posorig2=x.posorig;
     set(pushbutt,'userdata',x);
   
    cmenu = uicontextmenu;
    set(gcf,'UIContextMenu', cmenu);
    set(x.ch,'UIContextMenu', cmenu);

    % Define the context menu items
    item8 = uimenu(cmenu, 'Label','SHIFT ONE axis • S •',  'Callback', {@gcontext,8});
    item9 = uimenu(cmenu, 'Label','SHIFT GROUP of axes • G •',  'Callback', {@gcontext,9});
    item6 = uimenu(cmenu, 'Label','RESIZE ALL axes (Mouse-scroll) • A •',  'Callback', {@gcontext, 6});
    item7 = uimenu(cmenu, 'Label','RESIZE ONE axis • D •',  'Callback', {@gcontext,7});

   item11 = uimenu(cmenu, 'Label','FIT axes-layout to figure-size • F •',  'Callback', {@gcontext, 11},'separator','on');
   item12 = uimenu(cmenu, 'Label','COPY CURRENT axis-size to all axes • C •',  'Callback', {@gcontext, 12});
    item2 = uimenu(cmenu, 'Label','BACKGROUND-none (for plots only)',  'Callback', {@gcontext, 2},'separator','on');
    item1 = uimenu(cmenu, 'Label','Background-original (for plots only)', 'Callback', {@gcontext, 1});
    item3 = uimenu(cmenu, 'Label','POSITIONS-original',  'Callback', {@gcontext, 3},'separator','on');
   % item4 = uimenu(cmenu, 'Label','POSITIONS-last version',  'Callback', {@gcontext, 4});
   item13 = uimenu(cmenu, 'Label','TOGGLE CURRENT/LAST positions • SPACE •',  'Callback', {@gcontext, 13});         
    item5 = uimenu(cmenu, 'Label','POSITIONS to workspace (axshiftnew)',  'Callback', {@gcontext, 5},'separator','on');
    item10 = uimenu(cmenu, 'Label','snippet to workspace',  'Callback', {@gcontext, 10});
    item14 = uimenu(cmenu, 'Label','HELP • H •',  'Callback', {@gcontext, 14},'separator','on');
     
    set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
    x.wheel=100;
    x.shift=1;
    set(pushbutt,'userdata',x);
    set(gcf,'KeyReleaseFcn',@cb);
end
%%%••••••••••••••••••••••••••••••••••••••••••••••
%  keyboard-KEYS    
%%%••••••••••••••••••••••••••••••••••••••••••••••
function cb(obj,event)
% event.Character
switch event.Character
    case 's' ;gcontext(obj, event, 8)
    case 'r' ;gcontext(obj, event, 7)
    case 'a' ;gcontext(obj, event, 6)
    case 'g' ;gcontext(obj, event, 9)
    case 'f' ;gcontext(obj, event, 11)  
    case 'c' ;gcontext(obj, event, 12)   
    case 'h' ;gcontext(obj, event, 14)       
end
switch event.Key
 case 'space' ;gcontext(obj, event, 13) ;%toggle undoLASTSTEP
end
%••••••••••••••••••••••••••••••••••••••••••••••
%  rescale subplots  
%••••••••••••••••••••••••••••••••••••••••••••••
 
function gresize(obj, event, mode)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
co=  get(gcf,'CurrentPoint');
x= get(pushbutt,'userdata');
sel=gca;
set(gcf,'currentaxes',sel);
uistack(sel,'top');
% try
if ~isempty(sel)
     delete(findobj(gcf,'tag','resi'));
    delete(findobj(gcf,'tag','cords'));
    xl=get( (sel),'xlim');
    yl=get( (sel),'ylim');
    prx= [diff(xl)/20];
    pry= [diff(yl)/20];

    set(gcf,'currentaxes', (sel) );
    hold on;
    ms=7;
    x.v(1)=plot(xl(1)+prx,         yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',           'ButtonDownFcn',{@gresize2, 1});
    x.v(2)=plot(diff(xl)/2+xl(1),  yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 2});
    x.v(3)=plot(xl(2)-prx,             yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',           'ButtonDownFcn',{@gresize2, 3});

    x.v(4)=plot(xl(2)-prx,  diff(yl)/2+yl(1),'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi', 'ButtonDownFcn',{@gresize2, 4});
    x.v(5)=plot(xl(2)-prx,   yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',            'ButtonDownFcn',{@gresize2, 5});


    x.v(6)=plot(diff(xl)/2+xl(1), yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 6});

    x.v(7)=plot(xl(1)+prx,         yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',             'ButtonDownFcn',{@gresize2, 7});
    x.v(8)=plot(xl(1)+prx,         diff(yl)/2+yl(1)  ,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 8});
else
    delete(findobj(gcf,'tag','resi'));
    try;     delete(x.ve); end
    try; x.ve=[];end

end
set(pushbutt,'userdata',x);
% end

function gresize2(obj, event, mode)
set (gcf, 'WindowButtonMotionFcn',[]);
set (gcf, 'WindowButtonMotionFcn',{@gresize3, mode});
set (gcf, 'WindowButtonUpFcn',{@gcontext, 7});

function gresize3(obj, event, mode)
po= get(gca,'position');  cp=get(gcf,'CurrentPoint');

if mode==2
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==6
    df=cp(2)- po(2);    po(4)= df;
elseif mode==8
    df=po(1)-cp(1);    po(1)=cp(1); po(3)=po(3)+df;
elseif mode==4
    df=cp(1)- po(1);
    po(3)= df;
elseif mode==3
    df=cp(1)- po(1); po(3)= df;
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==1
    df=po(1)-cp(1);
    po(1)=cp(1); po(3)=po(3)+df;
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==5
    df=cp(1)- po(1);     po(3)= df;
    df=cp(2)- po(2);    po(4)= df;
elseif mode==7
    df=po(1)-cp(1);    po(1)=cp(1); po(3)=po(3)+df;
    df=cp(2)- po(2);    po(4)= df;
end
if po(3)>0 & po(4)>0
    set(gca,'position',po);
end
pos=[get(gca,'xlim') get(gca,'ylim')];
delete(findobj(gcf,'tag','cords'));
text(pos(1),pos(3)- (diff(pos(3:4))/5), num2str([(round(po*1000))./1000 ]) ,'tag','cords','VerticalAlignment','top',...
    'backgroundcolor',[0 0 0],'color',[1 1 1] ,'fontweight','bold','fontsize',8);

%••••••••••••••••••••••••••••••••••••••••••••••
%  resize all : MOUSEWHEEL 
%••••••••••••••••••••••••••••••••••••••••••••••
function gwheel(obj, event, mode)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x= get(pushbutt,'userdata');
x.wheel=x.wheel+       event.VerticalScrollCount;
set(pushbutt,'userdata',x);
for i=1:size(x.posorig,1)
    dx=x.posorig2{i};
    dx(:,3:4)=dx(:,3:4)*x.wheel/100;
    dz=get(x.ch(i),'position');
    %      dz(:,3:4)=dz(:,3:4)*x.wheel/100;
    % set(x.ch(i),'position',[dz ] );
    set(x.ch(i),'position',[dz(1:2) dx(3:4)] );
end



 
%••••••••••••••••••••••••••••••••••••••••••••••
%   indiv. axshift     
%••••••••••••••••••••••••••••••••••••••••••••••
%----------------------------------
%          1 : button down                    
%---------------------------------
function gdown(obj, event, x)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x= get(pushbutt,'userdata');

x=backup(x);
set(pushbutt,'userdata',x);

x.ax=gca;
uistack(x.ax,'top');
x.posax=get(gca,'position');
x.pospoint=get(gcf,'CurrentPoint');
x.axhelp= axes('position',[x.posax(1:2)  1  1],'color','none','xtick',[],...
    'ytick',[],'ycolor',[.7 .7 .7],'xcolor',[.7 .7 .7]);
x.axhelp2=axes('position',[x.posax(1:2)  1  1],'color','none','xtick',[],...
    'ytick',[],'ycolor',[.7 .7 .7],'xcolor',[.7 .7 .7]);
x.ax_xcolor=get(x.ax,'xcolor');
x.ax_ycolor=get(x.ax,'ycolor');
x.ax_box=get(x.ax,'box');
set(x.ax,'xcolor',[1 0 0],'ycolor',[1 0 0],'box','on');
set(pushbutt,'userdata',x);
set (gcf, 'WindowButtonMotionFcn', {@gmot, x});
set (gcf, 'WindowButtonUpFcn', {@gup, x});
%----------------------------------
%          2 : button up                    
%---------------------------------
function gup(obj, event, x)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x=get(pushbutt,'userdata');
set (gcf, 'WindowButtonMotionFcn', []);
set(x.ax,'xcolor',x.ax_xcolor);
set(x.ax,'ycolor',x.ax_ycolor);
set(x.ax,'box',x.ax_box);


delete(x.axhelp);
delete(x.axhelp2);
%----------------------------------
%          3 : motion                    
%---------------------------------
function gmot(obj, event, x)
po=x.posax; %position axis xy
poi=x.pospoint;%first buttondown position in axes
poinow=get(gcf,'CurrentPoint');%curretn position in axis
dx=po(1:2)-poi(1:2);
po(1:2)=[poinow+dx];

poh=get(x.axhelp,'position');poh(1:2)=[po(1) 0];
set(x.axhelp,'position',poh,'xtick',[],'ytick',[]);
poh=get(x.axhelp2,'position');poh(1:2)=[0 po(2)];
set(x.axhelp2,'position',poh,'xtick',[],'ytick',[]);
set(x.ax,'position',po);
set(x.ax,'xcolor',[1 0 0],'ycolor',[1 0 0],'box','on');

%••••••••••••••••••••••••••••••••••••••••••••••
%  contextmenu 
%••••••••••••••••••••••••••••••••••••••••••••••

function gcontext(obj, event, mode)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x= get(pushbutt,'userdata');
if mode==1
    for i=1:size(x.bgcol)
        set(x.ch(i),'color',x.bgcol{i}) ;
    end
elseif mode==2
    set(x.ch,'color','none') ;
elseif mode==3
    x.posnow=get(x.ch,'position');
    for i=1:size(x.bgcol)
        set(x.ch(i),'position',x.posorig{i}) ;
    end
elseif mode==4
    try
        for i=1:size(x.bgcol)
            set(x.ch(i),'position',x.posnow{i}) ;
        end
    end
elseif mode==5
    
    axshiftnew=cell2mat(get( sort(  x.ch ) ,'position'));    
    assignin('base','axshiftnew',axshiftnew);
    disp('••• parse positions as variable ''axshiftnew'' to workspace •••');
    disp(axshiftnew);
elseif mode==6 %RESIZE ALL axes (scroll)
    x=backup(x);
    delete(findobj(gcf,'tag','resi'));
    set (gcf, 'WindowButtonDownFcn', []);
    set (gcf, 'WindowButtonUpFcn', []);
    set (gcf, 'WindowButtonMotionFcn', []);
    x.posorig2=get(x.ch,'position') ;
    set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
elseif mode==7 %RESIZE ONE axis
    x=backup(x); 
    set(gcf,'WindowScrollWheelFcn',[]);
    % set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
    set (gcf, 'WindowButtonDownFcn', []);
    set (gcf, 'WindowButtonUpFcn', []);

    set (gcf, 'WindowButtonMotionFcn', {@gresize, x});
elseif mode==8%SHIFT ONE axis
    x=backup(x); 
    delete(findobj(gcf,'tag','resi'));
    delete(findobj(gcf,'tag','resi'));
    set (gcf, 'WindowButtonMotionFcn', []);
    set (gcf, 'WindowButtonDownFcn', {@gdown, x});
    set (gcf, 'WindowButtonUpFcn', {@gup, x});
elseif mode==9%SHIFT GROUP of axes
    x=backup(x); 
    delete(findobj(gcf,'tag','resi'));
    delete(findobj(gcf,'tag','resi'));
    set (gcf, 'WindowButtonMotionFcn', []);
    set (gcf, 'WindowButtonDownFcn', {@gdown, x});
    set (gcf, 'WindowButtonUpFcn', {@gup, x});
    down
    pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
    x= get(pushbutt,'userdata');
elseif mode==10 %snippet
    pax=cell2mat(get( sort(  x.ch ) ,'position'));
    pax=['pax=' mat2str(pax) ';'];
    

    tg={};
    tg{end+1,1}=pax;
    tg{end+1,1}='figure(''color'',''w''); ';
    tg{end+1,1}='for i=1:size(pax,1)';
    tg{end+1,1}='    hax(i)=axes(''position'',pax(i,:));';
    tg{end+1,1}='end';
 
    disp('%••• copy stuff below /the code is also send to clipboard');
    disp(' ');
    disp(char(tg));
    disp(' ');
    tg2='';
    for i=1:size(tg,1)
        if i==size(tg,1)
            bl=[tg{i}];
        else
            bl=[tg{i} char(10) ];
        end
        tg2(end+1:end+length(bl))=bl ;
    end
    %clipboard
    try;
        warning off;
        clipboard('copy', tg2) ;
        warning on;
    end
elseif mode==11 %stretch to fit figuresize
    x=backup(x); 
    stretch2figsize;
elseif mode==12 %set one axisTo all Axis
    x=backup(x); 
    sizeAxis2allAxes;
elseif mode==13 %last step
    try;
        cha= x.bk.posis;
        for i=1:size(cha,1)
            x.bk.posis(i,:)=[cha(i,1) get(cha(i,1),'position')];
            set(cha(i,1),'position',cha(i,2:end));
        end
    end
elseif mode==14 %help    
   uhelp('axshift2.m') ;    
    
end    
set(pushbutt,'userdata',x);

%••••••••••••••••••••••••••••••••••••••••••••••
% backup file to toggle last /current position
%••••••••••••••••••••••••••••••••••••••••••••••

function x=backup(x); 
x.bk.posis=[x.ch cell2mat(get(x.ch,'position'))];
 

%••••••••••••••••••••••••••••••••••••••••••••••
% shift group of axes
%••••••••••••••••••••••••••••••••••••••••••••••
%----------------------------------
%           1: button down                      
%---------------------------------
function down(obj, event, x) ;
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
set(gcf,'WindowButtondownFcn',[]); set(gcf,'WindowButtonupFcn',[]);

x=get(pushbutt,'userdata');
x=backup(x);
x.ro_group=[];
x.ch_group=[];
x.api_group=[];
x.h_group=[];
try; delete(findobj('tag','hlp_group'));end
g=axes('position',[0 0 1 1],'tag','hlp_group');
xlim([0 1]);ylim([0 1]);
uistack([g],'bottom'); %  delete(g)

h_group = imrect(gca, []);
api_group = iptgetapi(h_group);
ro_group=[];
ro_group= api_group.getPosition();
% disp(['ro_group: ' num2str(ro_group)]);

x.h_group=h_group;
x.ro_group=ro_group;
set(pushbutt,'userdata',x);

api_group.addNewPositionCallback(@(p) funo(p));
fcn = makeConstrainToRectFcn('imrect',...
                 get(gca,'XLim'),get(gca,'YLim'));
api_group.setPositionConstraintFcn(fcn);

if ~isempty(ro_group)
    define(h_group,api_group)
end



%----------------------------------
%           2: define axes enclosed by the rectangular                      
%---------------------------------
function define(h_group,api_group)% 'define'
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x=get(pushbutt,'userdata');
ro_group= api_group.getPosition();

chh=findobj(gcf,'type','axes','-and','tag','hlp_group'); %helpAXES
po=cell2mat(get(x.ch,'position'));
axm=[po(:,1) po(:,2) po(:,1)+po(:,3)  po(:,2)+po(:,4)];
ref=[ro_group(:,1) ro_group(:,2) ro_group(:,1)+ro_group(:,3)  ro_group(:,2)+ro_group(:,4)];
gu= find(axm(:,2)>ref(2) & axm(:,4)<ref(4) & ...
     axm(:,1)>ref(1) & axm(:,3)<ref(3) );
 if ~isempty(gu)
     set(x.ch(gu),'color',[1 0 0]);
     x.ch_group=x.ch(gu);
     x.ro_group=ro_group;
     x.api_group=api_group;
     set(pushbutt,'userdata',x);
 else %EMPTY: nothing is chosen
   bupp([], [],[]) 
 end
 set(pushbutt,'userdata',x);

 %----------------------------------
 %           3: move selected axes
 %---------------------------------
function funo(p)
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x=get(pushbutt,'userdata');
r0=x.ro_group;
df=p-r0;
chh=x.ch_group;
if ~isempty(chh)
    % chh=findobj(gcf,'type','axes','-and','userdata','sh');
    if length(chh)==1
        po= (get(chh,'position'));
    else
        po=cell2mat(get(chh,'position'));
    end
    po(:,[1:2])=[po(:,1)+df(:,1) po(:,2)+df(:,2)]  ;
    for i=1:length(chh)
        set(chh(i),'position',po(i,:));
    end
    x.ro_group= x.api_group.getPosition();
    % set(gcf,'userdata',x);
end
set(pushbutt,'userdata',x);
set(gcf,'WindowButtonUpFcn',{@bupp,[]})
 
%----------------------------------
%           1: button up                      
%---------------------------------
function bupp(obj, event, x) 

set(gcf,'WindowButtondownFcn',[]);
set(gcf,'WindowButtonMotionFcn',[]);
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x=get(pushbutt,'userdata');
% x=get(gcf,'userdata');

try; x.api_group.delete();end

set(x.ch_group,'color',[1 1 1]);
x.ro_group=[];
x.ch_group=[];
x.api_group=[];
x.h_group=[];

% set(gcf,'userdata',x);
set(pushbutt,'userdata',x);
% set(gcf,'WindowButtondownFcn',{@down,[]});
% down([],[],[]); 

chh=findobj(gcf,'type','axes','-and','tag','hlp_group'); %helpAXES
delete(chh)

delete(findobj(gcf,'tag','resi'));
delete(findobj(gcf,'tag','resi'));
set (gcf, 'WindowButtonMotionFcn', []);
set (gcf, 'WindowButtonDownFcn', {@gdown, x});
set (gcf, 'WindowButtonUpFcn', {@gup, x});

%••••••••••••••••••••••••••••••••••••••••••••••
% stretch axes-layout to figure
%••••••••••••••••••••••••••••••••••••••••••••••
function stretch2figsize
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
X=get(pushbutt,'userdata');
hax=X.ch;
set(gcf,'units','normalized');

%rest to x/y~0/0
po=cell2mat(get(hax,'position'));
gs1=[0.04 0.04 1 1];
mi=min(po);
ma=max(po);

%'x' right
gs0=[mi(1:2) max(po(:,1)+mi(:,3)) max(po(:,2)+mi(:,4)) ];
for i=1:length(hax)
    z=get(hax(i),'position');
    z(1)=z(1)-gs0(1)+gs1(1);
    set(hax(i),'position',[z]);
end
% 'y' down
for i=1:length(hax)
    z=get(hax(i),'position');
    z(2)=z(2)-gs0(2)+gs1(2);
    set(hax(i),'position',[z]);
end

%zoom
po=cell2mat(get(hax,'position'));
mi=min(po);
ma=max(po);
gs0=[mi(1:2) max(po(:,1)+mi(:,3)) max(po(:,2)+mi(:,4)) ]  ;
fc=1./gs0(3:4)    ;%factorZoom

for i=1:length(hax)
    z=get(hax(i),'position');
    z(3:4)=z(3:4).*fc;
    set(hax(i),'position',[z]);
end
%relocate: x
po=cell2mat(get(hax,'position'));
x=po(:,1)+po(:,3);
ix=max(find(x==max(x)));
plu=0.98  -(po(ix,1)+po(ix,3));
xl=((po(ix,1)+plu).*po(:,1))  ./po(ix,1);
for i=1:length(hax)
    z=get(hax(i),'position');
    z(1)=xl(i);
    set(hax(i),'position',[z]);
end
%relocate: y
po=cell2mat(get(hax,'position'));
x=po(:,2)+po(:,4);
ix=max(find(x==max(x)));
plu=0.98  -(po(ix,2)+po(ix,4));
xl=((po(ix,2)+plu).*po(:,2))  ./po(ix,2);
for i=1:length(hax)
    z=get(hax(i),'position');
    z(2)=xl(i);
    set(hax(i),'position',[z]);
end

%••••••••••••••••••••••••••••••••••••••••••••••
% copy axes-size to all axes
%••••••••••••••••••••••••••••••••••••••••••••••
function sizeAxis2allAxes
pushbutt=findall(gcf,'Type','uipushtool','-and','tag','axshift');
x=get(pushbutt,'userdata');
ch=x.ch;

po1=get(gca,'position');
for i=1:length(ch)
    po=get(ch(i),'position');
    po(3:4)=po1(3:4);
    set(ch(i),'position',po);
end












