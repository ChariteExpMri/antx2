function starttimer
try; delete(timerfind('tag','xboxtimer')); end
t = timer('TimerFcn',@timercallback, 'Period', 1,'tag','xboxtimer','ExecutionMode', 'FixedRate');
start(t);

function timercallback(u1,u2)
try 
    txt=evalin('base','msgtxt');
    hfig=findobj(0,'tag','xbox');
%     set(findobj(hfig,'tag','status'),'string',[txt ' ' datestr(now,'HH:MM:SS (dd-mmm)')]);
      set(findobj(hfig,'tag','status'),'string',[txt.tag ' ' sprintf('dt %2.2fs', etime(clock, txt.time))  ]);
%     assignin('base','msgtxt',msgtxt)
disp('#####################################')
end