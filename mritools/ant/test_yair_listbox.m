
function bla
% Prepare the Matlab listbox uicontrol
hFig = figure;
listItems = {'apple','orange','banana','lemon','cherry','pear','melon'};
hListbox = uicontrol(hFig, 'style','listbox', 'units','norm', 'pos',[.1 .1 .4 .4], 'string',listItems);
 
% Get the listbox's underlying Java control
jScrollPane = findjobj(hListbox);
 
% We got the scrollpane container - get its actual contained listbox control
jListbox = jScrollPane.getViewport.getComponent(0);
 
% Convert to a callback-able reference handle
jListbox = handle(jListbox, 'CallbackProperties');
 
% Set the mouse-click callback
% Note: MousePressedCallback is better than MouseClickedCallback
%       since it fires immediately when mouse button is pressed,
%       without waiting for its release, as MouseClickedCallback does
set(jListbox, 'MousePressedCallback',{@myCallbackFcn,hListbox});
 set(jListbox, 'MouseMovedCallback', {@mouseMovedCallback,hListbox});
 
% Mouse-movement callback
function mouseMovedCallback(jListbox, jEventData, hListbox)
   % Get the currently-hovered list-item
   mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
   hoverIndex = jListbox.locationToIndex(mousePos) + 1;
   listValues = get(hListbox,'string');
   hoverValue = listValues{hoverIndex};
 
   % Modify the tooltip based on the hovered item
   msgStr = sprintf('<html>item #%d: <b>%s</b></html>', hoverIndex, hoverValue);
   set(hListbox, 'Tooltip',msgStr);


% Define the mouse-click callback function
function myCallbackFcn(jListbox,jEventData,hListbox)
   % Determine the click type
   % (can similarly test for CTRL/ALT/SHIFT-click)
   if jEventData.isMetaDown  % right-click is like a Meta-button
      clickType = 'Right-click';
   else
      clickType = 'Left-click';
   end
 
   % Determine the current listbox index
   % Remember: Java index starts at 0, Matlab at 1
   mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
   clickedIndex = jListbox.locationToIndex(mousePos) + 1;
   listValues = get(hListbox,'string');
   clickedValue = listValues{clickedIndex};
 
   fprintf('%s on item #%d (%s)\n', clickType, clickedIndex, clickedValue);
   
