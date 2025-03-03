function [lineobj,xs,ys] = freehanddraw(varargin)
% [LINEOBJ,XS,YS] = FREEHANDDRAW(ax_handle,line_options)
% EXAMPLE: fg,imagesc; [hg,x y] = freehanddraw(gca,'pointer','hand','color',[1 0 1])
% 
% 
% Draw a smooth freehand line object on the current axis (default),
% or on the axis specified by handle in the first input argument.
% Left-click to begin drawing, right-click to terminate, or double-click
% to close contour and terminate.
% 
%
% INPUT ARGUMENTS:  First:      axis handle (optional)
%                  optional: define pointer wvia 'pointer' & pointer to use, default: 'hand'
%                  Additional: valid line property/value pairs
%
% OUTPUT ARGUMENTS: 1) Handle to line object
%                  2) x-data
%                  3) y-data
% (Note that output args 2 and 3 can also be extracted from the first output
% argument.)
%
% Ex: [myobj,xs,ys] = freehanddraw(gca,'color','r','linewidth',3);
%     freehanddraw('linestyle','--');
%
% Written by Brett Shoelson, PhD
% shoelson@helix.nih.gov
% 3/29/05
% Modified:
% 10/05/05: Now allows double-click closing of contour

warning off
axdef = 0;
if nargin ~= 0 & ishandle(varargin{1})
	try
		axes(varargin{1});
		axdef = 1;
	catch
		error('If the initial input argument is a handle, it must be to a valid axis.');
	end
end
	
	
%Get current figure and axis parameters
oldvals = get(gcf);
oldhold = ishold(gca);

hold on;

% set(gcf,'Pointer','crosshair','doublebuffer','on');

%Get the initial point
% [xs,ys,zs] = ginput(1)
 pointer='hand';
if ~isempty(varargin)
    ispointerfield=find(strcmp(varargin,'pointer'));
    if ~isempty(ispointerfield)
        pointer= varargin{ispointerfield+1};
        varargin(ispointerfield:ispointerfield+1)=[];      
    end
end

% t = timer('tag','timerDraw333','ExecutionMode','fixedRate','Period',0.5);
% t.TimerFcn = @(~,~) disp('3 seconds have elapsed');
% t.TimerFcn=@timerfun;
% start(t);

% pointer
[xs,ys,zs] = myginput(1,pointer);
% zs
if zs==27 %ESCAPE
    [lineobj,xs,ys]=deal([]);
%     delete(timerfind('tag','timerDraw333'));
    return
end


%Create and store line object
if axdef
	lineobj = line(xs,ys,'tag','tmpregsel',varargin{2:end});
else
	lineobj = line(xs,ys,'tag','tmpregsel',varargin{:});
end
setappdata(gcf,'lineobj',lineobj);

%Modify wbmf of current figure to update lineobject on mouse motion
set(gcf,'windowbuttonmotionfcn',@wbmfcn);
set(gcf,'windowbuttondownfcn',@wbdfcn);
set(gcf,'windowbuttonupfcn',@winkeyup);
%Wait for right-click or double-click
% while ~strcmp(get(gcf,'SelectionType'),'alt') & ~strcmp(get(gcf,'SelectionType'),'open')
% 	drawnow;
% end
% set(gcf,'Pointer','arrow','doublebuffer','on');

while ~isempty(get(gcf,'windowbuttonupfcn')) && zs~=27
%     char = get(gcf, 'CurrentCharacter')
%             button = abs(get(gcf, 'CurrentCharacter'))
    %get(gcf,'CurrentCharacter');
     drawnow;
end

%Extract xyz data from line object for return in output variables
%(Also retrievable from first output argument)
if nargout > 1
	xs = get(getappdata(gcf,'lineobj'),'xdata')';
end
if nargout > 2
	ys = get(getappdata(gcf,'lineobj'),'ydata')';
end

%Clear temporary variables from base workspace
% evalin('caller','clear tmpx tmpy tmpz done gca lineobj');

%Reset figure parameters
set(gcf,'Pointer',oldvals.Pointer,...
	'windowbuttonmotionfcn',oldvals.WindowButtonMotionFcn,...
    'windowbuttondownfcn',oldvals.WindowButtonDownFcn,...);%,...
'WindowButtonUpFcn',oldvals.WindowButtonUpFcn);%,...
% 	'doublebuffer',oldvals.DoubleBuffer);
%Reset hold value of the axis
if ~oldhold, hold off; end 

if zs==27 %ESCAPE
    [lineobj,xs,ys]=deal([]);
%     delete(timerfind('tag','timerDraw333'));
end

function wbmfcn(varargin)
lineobj = getappdata(gcf,'lineobj');
% rand(1)
if strcmp(get(gcf,'selectiontype'),'normal');
    tmpx = get(lineobj,'xdata');
    tmpy = get(lineobj,'ydata');
    a=get(gca,'currentpoint');
    set(lineobj,'xdata',[tmpx,a(1,1)],'ydata',[tmpy,a(1,2)]);
    drawnow;
else
    setappdata(gcf,'lineobj',lineobj);
end

function wbdfcn(varargin)
lineobj = getappdata(gcf,'lineobj');
if strcmp(get(gcf,'selectiontype'),'open')
    tmpx = get(lineobj,'xdata');
    tmpy = get(lineobj,'ydata');
    a=get(gca,'currentpoint');
    set(lineobj,'xdata',[tmpx,tmpx(1)],'ydata',[tmpy,tmpy(1)]);
    setappdata(gcf,'lineobj',lineobj);
    drawnow;
end
return

function winkeyup(e,e2)
set(gcf,'windowbuttonupfcn',[]);

% 
% function timerfun(e,e2)
% % 'hi'
% 
% 
% % char = get(gcf, 'CurrentCharacter')
% button = abs(get(gcf, 'CurrentCharacter'))
% if button==27
%    try; uiresume(gca); end
%     delete(timerfind('tag','timerDraw333'));
%     
% end



