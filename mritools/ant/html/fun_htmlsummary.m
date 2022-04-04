


function ht=fun_htmlsummary(hstate,px,varargin)

ht=fullfile(px,'summary','summary.html');
htmlblanko=which('form0.html');



if nargin>2
    ps=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
else
    ps.dummy=1;
end

if ischar(hstate)
   ps.px=px; 
end


if isfield(ps,'info')==0;    ps.info=''; end


if hstate==0 %setupHTML
    xhtml('copyhtml','s' ,htmlblanko,'t',ht);
    xhtml('subject',   'page',ht,'subject',px);
    xhtml('timer'  ,   'page',ht,'progress',1);
    xhtml('timer'  ,   'page',ht,'start',datestr(now));
    
%      xhtml('addprocessinglinks','page',ht,'subject',px);
    
elseif hstate==1 %init
%     atic=tic; pause(td); atoc=toc(atic);
%     hinfo=['processing Time: ' secs2hms(atoc)];
%     disp('--proc-1 runns now and is finnished')
    xhtml('add','page',ht,'section','initialization','info',ps.info);
    xhtml('timer'  ,   'page',ht,'progress',25);
    
elseif hstate==2 %coreg
%     atic=tic; pause(td); atoc=toc(atic);
%     hinfo=['processing Time: ' secs2hms(atoc)];
%     disp('--proc-2 runns now and is finnished')
    xhtml('add','page',ht,'section','coregistration','info',ps.info);
    xhtml('timer'  ,   'page',ht,'progress',50);
elseif hstate==3%segmentation
%     atic=tic; pause(td); atoc=toc(atic);
%     hinfo=['processing Time: ' secs2hms(atoc)];
%     disp('--proc-3 runns now and is finnished')
    xhtml('add','page',ht,'section','segmentation','info',ps.info);
    xhtml('timer'  ,   'page',ht,'progress',75);
elseif hstate==4 %warping
%     atic=tic; pause(td); atoc=toc(atic);
%     hinfo=['processing Time: ' secs2hms(atoc)];
%     disp('--proc-4 runns now and is finnished')
    xhtml('add','page',ht,'section','warping','info',ps.info);
    xhtml('timer'  ,   'page',ht,'progress',100);
elseif hstate==-1 %timer reset , proc finnished
    xhtml('timer','page',ht,'stop',datestr(now));
end


if 0 %TESTS
    s.pa='O:\data4\phagozytose\dat\20190221CH_Exp1_M58'
    ht=fun_htmlsummary(0,s.pa); 
     td=2;
   
    timetask=tic;
    pause(td);
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(1,s.pa,'info',hinfo); 
    
    timetask=tic;
    pause(td);
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(2,s.pa,'info',hinfo); 
    
    timetask=tic;
    pause(td);
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(3,s.pa,'info',hinfo); 
    
    timetask=tic;
    pause(td);
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(4,s.pa,'info',hinfo); 
    
    ht=fun_htmlsummary(-1,s.pa);
end






if 0
    
    td=2;
    showbrowser =1;
    
    px='O:\data4\phagozytose\dat\20190221CH_Exp1_M58';
    ht=fullfile(px,'summary','summary.html');
    htmlblanko=which('form0.html');
    
    xhtml('copyhtml','s' ,htmlblanko,'t',ht);
    xhtml('subject',   'page',ht,'subject',px);
    xhtml('timer'  ,   'page',ht,'progress',1);
    xhtml('timer'  ,   'page',ht,'start',datestr(now));
    %if showbrowser==1; web(ht); end
    
    
    atic=tic; pause(td); atoc=toc(atic);
    hinfo=['processing Time: ' secs2hms(atoc)];
    disp('--proc-1 runns now and is finnished')
    xhtml('add','page',ht,'section','initialization','info',hinfo);
    xhtml('timer'  ,   'page',ht,'progress',25);
    
    atic=tic; pause(td); atoc=toc(atic);
    hinfo=['processing Time: ' secs2hms(atoc)];
    disp('--proc-2 runns now and is finnished')
    xhtml('add','page',ht,'section','coregistration','info',hinfo);
    xhtml('timer'  ,   'page',ht,'progress',50);
    
    atic=tic; pause(td); atoc=toc(atic);
    hinfo=['processing Time: ' secs2hms(atoc)];
    disp('--proc-3 runns now and is finnished')
    xhtml('add','page',ht,'section','segmentation','info',hinfo);
    xhtml('timer'  ,   'page',ht,'progress',75);
    
    atic=tic; pause(td); atoc=toc(atic);
    hinfo=['processing Time: ' secs2hms(atoc)];
    disp('--proc-4 runns now and is finnished')
    xhtml('add','page',ht,'section','warping','info',hinfo);
    xhtml('timer'  ,   'page',ht,'progress',100);
    
    xhtml('timer','page',ht,'stop',datestr(now));
    
end