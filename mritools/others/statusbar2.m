

%% statusbar in commandwindow
%% function statusbar2(task,varargin)
%  statusbar2(0)  ;%start statusbar + timer starts
%  statusbar2(0, 'info1', 'info2','info3')  ;%start statusbar + timer starts+ optional up to 3 infos (string) can be displayed
%    statusbar2(1, 'info1UPdate', 'info2UPdate','info3UPdate'); %update statusbar's infos, but timer is not reseted
%    statusbar2(-1) ; %remove timer & delete statusbars infos 

function statusbar2(task,varargin)


if 0
    
    statusbar2(0)  ;%start statusbar + timer starts
    statusbar2(0, 'info1', 'info2','info3')  ;%start statusbar + timer starts+ optional up to 3 infos (string) can be displayed
   statusbar2(1, 'info1UPdate', 'info2UPdate','info3UPdate'); %update statusbar's infos, but timer is not reseted
   statusbar2(-1) ; %remove timer & delete statusbars infos 
    
end



if task==0
    timex(varargin)
elseif task==1
    change(varargin);
    
elseif task==-1
    
    
    
    try;       
        tim=timerfind('tag','timex99');
        us=get(tim,'userdata');
        disp(sprintf([ ' FINNISHED... processing time: '   '%2.2fmin' ],toc(us.t)/60));
        delete(timerfind('tag','timex99'));   
    
    end
    try;           statusbar(0) ; end
end


 

function    change(varargin)

c=timerfind('tag','timex99');
us=get(c,'userdata');
us.tg1='';
us.tg2='';
us.tg3='';
us.tg4='';
try; us.tg1=varargin{1}{1}; end
try; us.tg2=varargin{1}{2}; end
try; us.tg3=varargin{1}{3}; end
set(c,'userdata',us);

function timex(varargin)
  try;              delete(timerfind('tag','timex99'));   ; end

  
% us.tg1='busy..';
% us.tg2='WARPING';
% us.tg3=strrep(pwd,filesep,[filesep filesep]);
% us.tg4='';

us.tg1='';
us.tg2='';
us.tg3='';
us.tg4='';

try; us.tg1=varargin{1}{1}; end
try; us.tg2=varargin{1}{2}; end
try; us.tg3=varargin{1}{3}; end

us.t=tic;
t = timer('period',10,'userdata',us);
set(t,'ExecutionMode','fixedrate','StartDelay',0,'tag','timex99');
set(t,'timerfcn',@update);

% set(t,'timerfcn',['t=timerfind(''tag'',''timex99'')   ; us=get(t,''userdata'');' ...
%     'dt=toc(us.t);'  ,  'statusbar(0, sprintf([ ''  '' us.task   ''%2.2fmin'' ],dt/60));'   ]);
%           'dt=toc(us.t);   statusbar(0,num2str(dt))  '      ]);
%       'dt=toc(us.t);'  ,  'statusbar(0, sprintf([''%2.2f min'' ],dt/60));'   ]);
start(t);
return

function update(ha,ho)


t=ha;
% t=timerfind(''tag'',''timex99'') 
us=get(t,'userdata');
dt=toc(us.t);
tim=sprintf([ ' dt'   '%2.2fmin' ],dt/60);

us.tg4=tim;


% m=['<html>..BACK2:      <font style="font-family:verdana;color:red"><i>' ['BBB'  ]    ' <font style="color:blue">  bla<<font style="color:green">  bla</html>  ' ];

m=['<html>' us.tg1 '      <font style="font-family:verdana;color:red"><i>' us.tg2    ' <font style="color:blue">  ' us.tg3 '<<font style="color:green">  ' us.tg4 ' </html>  ' ];

 statusbar(0,m);
%setDesktopStatus(m);
%  setCWtitle(m);
% changeWintitle


    function  setCWtitle(m);

% http://stackoverflow.com/questions/1924286/is-there-a-way-to-change-the-title-of-the-matlab-command-window        
% For Matlab 7:
% jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% jDesktop.getMainFrame.setTitle('my new title');
% *or specifically for the Command Window:
% cmdWin = jDesktop.getClient('Command Window');
% cmdWin.getTopLevelAncestor.setTitle('my new title');
% 
% For Matlab 6:
% jDesktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;
% jDesktop.getMainFrame.setTitle('my new title');
% *or for the Command Window:
% cmdWin = jDesktop.getClient('Command Window');
% cmdWin.getTopLevelWindow.setTitle('my new title');


try
    jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    jDesktop.getMainFrame.setTitle(m);
catch
    jDesktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;
    jDesktop.getMainFrame.setTitle(m);
end


function changeWintitle(oldName, newName)

wins = java.awt.Window.getOwnerlessWindows();
for i = 1:numel(wins)
    if isequal(char(wins(i).getTitle()), oldName)
        wins(i).setTitle(newName);
    end
end



%% Set the status bar text of the Matlab desktop
function setDesktopStatus(statusText)


    try
        % First, get the desktop reference
        try
            desktop = com.mathworks.mde.desk.MLDesktop.getInstance;      % Matlab 7+
        catch
            desktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;  % Matlab 6
        end

        % Schedule a timer to update the status text
        % Note: can't update immediately, since it will be overridden by Matlab's 'busy' message...
        try
            t = timer('Name','statusbarTimer', 'TimerFcn',{@setText,desktop,statusText}, 'StartDelay',0.05, 'ExecutionMode','singleShot');
            start(t);
        catch
            % Probably an old Matlab version that still doesn't have timer
            desktop.setStatusText(statusText);
        end
    catch
        %if any(ishandle(hFig)),  delete(hFig);  end
        error('YMA:statusbar:desktopError',['error updating desktop status text: ' lasterr]);
    end
%end  %#ok for Matlab 6 compatibility

%% Utility function used as setDesktopStatus's internal timer's callback
function setText(varargin)
    if nargin == 4  % just in case...
        targetObj  = varargin{3};
        statusText = varargin{4};
        targetObj.setStatusText(statusText);
    else
        % should never happen...
    end

