function smart_scrollbars(hContainer, varargin)  % varargin is used so that you can set @smart_scrollbar 
%smart_scrollbars fixes Matlab's listbox/editbox scrollbars, which are shown even when not needed
%
% Syntax:
%    smart_scrollbars(hContainer)
%
% Input parameters:
%    hContainer - optional handle to container (e.g., panel, tab or figure). Default = current figure (gcf)
%
%    Note: additional inputs may be specified and are ignored - this is useful for specifying smart_scrollbars
%          as the target callback function (e.g., of the container's SizeChangedFcn). See example below.
%
% Output parameters:
%    (none)
%
% Examples:
%    smart_scrollbars;           % fixes the scrollbars in all listboxes/editboxes in currrent figure
%    smart_scrollbars(hPanel);   % fixes the scrollbars in all listboxes/editboxes in hPanel container
%    smart_scrollbars(hListbox); % fixes the scrollbars of the specified listbox
%    set(gcf,'SizeChangedFcn',@smart_scrollbars)  % fix scrolling whenever the figure resizes
%
% Technical explanation & details:
%    http://undocumentedmatlab.com/blog/smart-listbox-editbox-scrollbars
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab functionality.
%    It works on Matlab 7+, but use at your own risk!
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2016-04-20: First version posted on the MathWorks file exchange: <a href="http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A27420">http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A27420</a>
%
% See also:
%    java, handle, findobj, findjobj, uiinspect (on the File Exchange)
% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
    if nargin<1,  hContainer = gcf;  end
    % The new scrollbar policies are changed to *_AS_NEEDED
    % See: https://docs.oracle.com/javase/7/docs/api/javax/swing/ScrollPaneConstants.html
    % ^^^  https://docs.oracle.com/javase/tutorial/uiswing/components/scrollpane.html#scrollbars
    try
        vpolicy = javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED;
        hpolicy = javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED;
    catch
        vpolicy = 20;  % possible for old Matlab releases, but should not really happen
        hpolicy = 30;  % possible for old Matlab releases, but should not really happen
    end
    % Loop over all listboxes and editboxes in the specified container
    hControls = findall(hContainer, 'style','listbox','-or','style','edit');
    for idx = 1 : numel(hControls)
        try
            % Try to find a direct reference to the Java scrollpane in the control's appdata
            hControl = hControls(idx);
            jScrollPane = getappdata(hControl,'jScrollPane');
            if isempty(jScrollPane)
                % Not found - find the Java scrollpane reference using the findjobj utility
                jContainer = getappdata(hControl,'jContainer');
                jScrollPane = findjobj_fast(hControl, jContainer);
                if isempty(jContainer)
                    setappdata(hControl,'jContainer',jScrollPane.getParent);
                end
                setappdata(hControl,'jScrollPane',jScrollPane);
            end
            % Modify the scrollbar policies to *_AS_NEEDED
            jScrollPane.setVerticalScrollBarPolicy(vpolicy);
            jScrollPane.setHorizontalScrollBarPolicy(hpolicy);
            jScrollPane.repaint;
            % Instrument the scrollbars to automatically fix when the component is resized
            hjScrollPane = handle(jScrollPane,'CallbackProperties');
            set(hjScrollPane,'ComponentResizedCallback',@reapplySmartScrollbars);
        catch
            % never mind, ignore...
        end
    end
end  % smart_scrollbars
% Utility functions (taken from the findjobj utility) to find the Java reference of a Matlab uicontrol
function jControl = findjobj_fast(hControl, jContainer)
    try jControl = hControl.getTable; return, catch, end  % fast bail-out for old uitables
    try jControl = hControl.JavaFrame.getGUIDEView; return, catch, end  % bail-out for HG2 matlab.ui.container.Panel
    oldWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    if nargin < 2 || isempty(jContainer)
        % Use a HG2 matlab.ui.container.Panel jContainer if the control's parent is a uipanel
        hParent = get(hControl,'Parent');
        try jContainer = hParent.JavaFrame.getGUIDEView; catch, jContainer = []; end
    end
    if isempty(jContainer)
        hFig = ancestor(hControl,'figure');
        jf = get(hFig, 'JavaFrame');
        jContainer = jf.getFigurePanelContainer.getComponent(0);
        try
            dummy = hControl.Style; %#ok<NASGU>
            warning('YMA:smart_scrollbars:uipanel','smart_scrollbars can be much faster if the list/edit control is wrapped in a tightly-fitting uipanel (<a href="matlab:web(''http://undocumentedmatlab.com/blog/smart-listbox-editbox-scrollbars#performance'',''-browser'');">details</a>)');
        catch
            % Probably HG1 - R2014a or earlier
        end
    end
    warning(oldWarn);
    jControl = [];
    counter = 100;
    oldTooltip = get(hControl,'Tooltip');
    set(hControl,'Tooltip','!@#$%^&*');
    while isempty(jControl) && counter>0
        counter = counter - 1;
        pause(0.001);
        jControl = findTooltipIn(jContainer);
    end
    %try jControl.setToolTipText(oldTooltip); catch, end  % this causes an empty tooltip which is undesirable
    set(hControl,'Tooltip',oldTooltip);
    try jControl = jControl.getParent.getView.getParent.getParent; catch, end  % return JScrollPane if exists
end
function jControl = findTooltipIn(jContainer)
    try
        tooltipStr = jContainer.getToolTipText;
        %if strcmp(char(tooltipStr),'!@#$%^&*')
        if ~isempty(tooltipStr) && tooltipStr.startsWith('!@#$%^&*')  % a bit faster
            jControl = jContainer;
        else
            for idx = 1 : jContainer.getComponentCount
                jControl = findTooltipIn(jContainer.getComponent(idx-1));
                if ~isempty(jControl), return; end
            end
        end
    catch
        % ignore
        jControl = [];
    end
end
% Reapply smart scrollbars in case of component resize
function reapplySmartScrollbars(jScrollPane, varargin)
    %set(jScrollPane,'VerticalScrollBarPolicy',20, 'HorizontalScrollBarPolicy',30);
    jScrollPane.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
    jScrollPane.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
end
