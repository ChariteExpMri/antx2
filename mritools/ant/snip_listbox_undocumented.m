
function snip_listbox_undocumented
fg; 
set(gcf,'units','norm')
hListbox = uicontrol('Style','Listbox','units','norm','position',[.2 .3 .2 .55], 'String',...
    {'item #1','item #2','item #3' '44444' '555' '66666' '77777','888888' '99999' '100000'},'fontsize',10);


jScrollPane = java(findjobj(hListbox))

jListbox = jScrollPane.getViewport.getView



% Set the mouse-movement event callback
set(jListbox, 'MouseMovedCallback', {@mouseMovedCallback,hListbox});
 
% Mouse-movement callback
function mouseMovedCallback(jListbox, jEventData, hListbox)
   % Get the currently-hovered list-item
   mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% hoverIndex = jListbox.locationToIndex(mousePos) + 1;
   hoverIndex=get(mousePos,'Y');
   fs=get(hListbox,'fontsize');
   [hoverIndex   hoverIndex/fs];
   est=fs*2;
   re=rem(hoverIndex,est);
   va=(hoverIndex-re)/est;
%    t=[hoverIndex    va+1   ]
   hoverIndex2=va+1;
    listValues = get(hListbox,'string');
   hoverValue = listValues{hoverIndex2};
   % Modify the tooltip based on the hovered item
   msgStr = sprintf('<html>item #%d: <b>%s</b></html>', hoverIndex2, hoverValue);
   set(hListbox, 'Tooltip',msgStr);
   % mouseMovedCallback