


function varargout=xhtmlgr(task,varargin)
varargout={};

if 0
    tic
    px=pwd;
    
    ht=xhtmlgr('copyhtml','s' ,which('formgr.html'),'t',fullfile(px,'summary.html'));
    xhtmlgr('study','page',ht,'study',px);
    xhtmlgr('timer','page',ht,'start',datestr(now));
    xhtmlgr('show','page',ht);
    
    xhtmlgr('update','page',ht)
    
    s.pa='O:\data4\Htmltest\dat\test3'
    
    
    
    xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'),'currentTask',1, 'currentsubject',s.pa);
    xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'))
    
    
    
    
    
    
    xhtmlgr('timer','page',ht,'progress',10);
    xhtmlgr('timer','page',ht,'stop',datestr(now));
    xhtmlgr('timer','page',ht,'progress',100);
    

        
        %     web('index.html');
    %     xhtml('timer','page',ht,'stop',datestr(now));
    
    infomsg={'das ist ein TEST','das ist ein anderer      TEST'}
    xhtml('add','page',ht,'section','initialization','info',infomsg);
    xhtml('add','page',ht,'section','coregistration');
    
    
    xhtml('add','page',ht,'section','segmentation');
    xhtml('add','page',ht,'section','warping');
    
    
    toc
    web(ht);
end

if 0
    
    %�����������������������������������������������
    %%   % simulate stuff
    %�����������������������������������������������
    
    td=2;
    showbrowser =1;
    
    px='O:\data4\phagozytose\dat\20190221CH_Exp1_M58';
    ht=fullfile(px,'summary','summary.html');
    htmlblanko=which('form0.html');
    
    xhtml('copyhtml','s' ,htmlblanko,'t',ht);
    xhtml('study',     'page',ht,'study',px);
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
    
    
    
    
    
    
    
    
    if showbrowser; web(ht); end
    
    
    
    
    %�����������������������������������������������
    %%
    %�����������������������������������������������
    
end















if nargin>1
    ps=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
else
    ps.dummy=1;
end

if ~isfield(ps,'page');
    if isfield(ps,'t');
        ps.page=ps.t;
    end
end

if isfield(ps,'page')
    ps.outpath=fileparts(ps.page);
end

% check whether html file exist, otherwise return
if isfield(ps,'page') && ~isfield(ps,'t')  %always check existence but not during initialization of html doc
    if exist(ps.page)~=2
        disp(' html page not found');
        return
    end
end




%�����������������������������������������������
%%
%�����������������������������������������������
if strcmp(task,'copyhtml');  varargout{1}  =copyhtml(ps); end
if strcmp(task,'study');     varargout{1}  =study(ps); end
if strcmp(task,'timer');     varargout{1}  =timer(ps); end
if strcmp(task,'update');     varargout{1} =update(ps); end


if strcmp(task,'add');       varargout{1}  =add(ps); end
if strcmp(task,'progress');  varargout{1}  =progress(ps); end

if strcmp(task,'show');       varargout{1}  =show(ps); end

%�����������������������������������������������
%%   subs
%�����������������������������������������������
%===============================================
function out=update(ps)

% code:
% 1: not existing
% 2: allready exists
% 3: currently running 
% 4: finished

%% current status
if isfield(ps,'currentTask')
    if isfield(ps,'currentsubject')
        currentTask=ps.currentTask;
        save(fullfile(ps.currentsubject,'currentTask.mat'), 'currentTask')
    end
end



out=[];
m=hopen(ps.page);
t1=hget(m,'## start time:','\;'); t1=regexprep(t1,'<.*?>','');


load(fullfile(ps.outpath,'summaryLog.mat'));
passel=log.passel;
pas   =log.pas;

% pas    =antcb('getallsubjects');
% % passel =antcb('getsubjects');
% passel  =pas(get(findobj(findobj(0,'tag','ant'),'tag','lb3'),'value'));
% passel=pas([1 3])
% ###baustelle

chkfi={'_msk.nii', 'coreg2.jpg'  'c1t2.nii' 'x_t2.nii'};
tb=[];
tbmax=[];
procsubject=[];
for i=1:length(pas)
    procsubject(i,1)=any(strcmp(passel,pas{i}));
    for j=1:length(chkfi)
        k=dir(fullfile(pas{i},chkfi{j}));
        if isempty(k)
            %tb{i,j+1}='';
            tb(i,j)=1;
        else
            %tb{i,j+1}=k.date;
            difftime=etime(datevec(k.datenum),datevec(t1));
            if difftime<=0 % 2: allready exists
                tb(i,j)=2;
            else                                     % 4: finished
                tb(i,j)=4;
                
            end 
            tbmax(i,j)=difftime;
        end
    end
    
end




%% current task
for i=1:length(passel)
    itb=find(strcmp(pas,passel{i}));
    ficurrentTask=fullfile(passel{i},'currentTask.mat');
    if exist(ficurrentTask)==2
       currentTask=load(ficurrentTask);
       if tb(itb,currentTask.currentTask)~=4 % process finished
           tb(itb,currentTask.currentTask)=3;
       end
       
    end
    
end





% procsubject: (0,1)
% tbh={ 'init' 'coreg' 'seg' 'warp' }

%% task to perform
% hlb=findobj(findobj(0,'tag','ant'),'tag','lb1');
% lab=get(hlb,'string');
% val=get(hlb,'value');
% lab=lab(val);
% 
% proctask=[1 1 1 1];  
% proctask(1)=~isempty(regexpi2(lab,'initial'));
% proctask(2)=~isempty(regexpi2(lab,'coregister'));
% proctask(3)=~isempty(regexpi2(lab,'segment'));
% proctask(4)=~isempty(regexpi2(lab,'xwarp-ELASTIX'));

% load(fullfile(ps.outpath,'summaryLog.mat'));
proctask=log.proctask;

%% make html
m1=m(1:regexpi2(m,'<!--SUBJECTS_START-->'));
m2=m(regexpi2(m,'<!--SUBJECTS_STOP-->'):end);


bullit={...
    '<font color="Lavender"  >&#9864' 
    '<font color="orange"    >&#9864'
    '<font color="DodgerBlue">&#9728'
    '<font color="Green"     >&#9864'
    };



%      mx{end+1,1}=[];
mx='';
for s=1:size(tb,1)%subjects
    %---------------------------PROCESSING..
    if procsubject(s)==1 % process this subject
        mx{end+1,1}=['<font color="black" size="3"> processing..'];
    else
        mx{end+1,1}=['<font color="white" size="3"> processing..'];
    end
    %---------------------------BULLITS
    mx{end+1,1}=['<font color="black" size=5px>'];
    for t=1:4
        w=bullit{tb(s,t)}; %get colored bullit
        if  proctask(t).*procsubject(s) ==1  % mark it
            w=[ '<mark>' w  '</mark>'];
        end
        mx{end+1,1}=w;    
    end
    %---------------------------SUBJECT
    [~, name]=fileparts(pas{s});
    mx{end+1,1}=['<font color="black" size="3">'  name];
    
    %---------------------------HTML PAGE
    htmlsubject=fullfile(pas{s},'summary','summary.html');
    if exist(htmlsubject)==2
%         <a href="./">current folder</a>
%         <a href="picture1.jpg">picture1 in current folder</a>
%         <a href="files/">files folder</a>
%         <a href="files/picture2.jpg">picture2 in files folder</a>
%         href="O:\data4\Htmltest\dat\test1\summary\summary.html">inspect</a>
        mx{end+1,1}=['<a target="_new" rel="noopener noreferrer"' ...
            'href="' 'dat/' name '/' 'summary/summary.html' '">inspect</a>'];
    end
    %---------------------------processing done
    if sum(tb(s,:).*proctask) ==sum(proctask)*4  % "4" is the finished taskcode
       mx{end+1,1}=['<b>' 'done ' '</b>' '<font color="gray" size="2">' datestr(now) '</font>']; 
    end
    
    
       mx{end+1,1}=['<br>']; 
    
%     <font color="black" size="3"> processing..
%     <font color="black" size=5px>
%     
%     <font color="Green"     >&#9864</mark>
%     <mark><font color="DodgerBlue">&#9728</mark>
%     <mark><font color="orange"    >&#9864</mark>
%     <mark><font color="Lavender"  >&#9864</mark>
%     
%     
%     <font color="black" size="3">  subject_01
%     <a target="_new" rel="noopener noreferrer"
%     href="O:\data4\Htmltest\dat\test1\summary\summary.html">inspect</a>
%     
%     ..done
%     <br>
%     
    
end

m=[m1; mx ;m2];

%% current subject-task
if sum(tbmax(:)>0)>0
   [i1 i2]=find(tbmax>0);  i1=max(i1); i2=max(i2);
   taskslab={'Initialization', 'Coregistration' 'Segmentation' 'Warping'};
   [~, lastUpdateSubject]=fileparts(pas{i1});  
 m=hreplace(m,  '>last performed case:','</font>' ,[' <b> "' lastUpdateSubject  '" <<>> ' taskslab{i2}  '</b>']);
   
end

%% timer
t1=hget(m,'## start time:','\;'); t1=regexprep(t1,'<.*?>','');
t2=datestr(now);
tdif=etime(datevec(t2),datevec(t1));
tstr=secs2hms(tdif);
m=hreplace(m,'## diff time:','\;',['<b>' ' >' tstr '</b>']);


% statusmatrix-->update progressbar
sm=repmat(procsubject,[1 size(tb,2) ]).*repmat(proctask,[size(tb,1) 1]).*tb;
sm(sm==0)=nan;
Nprocesses=sum(~isnan(sm(:)));
NprocDone =sum(sm(:)==4);
progress=round(NprocDone/Nprocesses*100);


if progress>100; progress=100; end
if progress<1  ; progress=1    ; end

m=hreplace(m,'^','% processed <meter',num2str(progress));
m=hreplace(m,'value="','"></meter>'  ,num2str(progress));

hsave(ps.page,m);


if progress==100
    xhtmlgr('timer','page',ps.page,'stop',datestr(now));
    
end



%repmat(procsubject,[1 size(tb,2) ])
%repmat(proctask,[size(tb,1) 1]).*tb










if 0
    tic
   ht=xhtmlgr('copyhtml','s' ,which('formgr.html'),'t',fullfile(px,'summary.html'));
    xhtmlgr('study','page',ht,'study',px);
    xhtmlgr('timer','page',ht,'start',datestr(now));
    toc
    xhtmlgr('update','page',ht); 
end
%===============================================

function out=show(ps)
out=[];
if ispc
   system(['start ' ps.page]) ;
elseif ismac
   system(['open ' ps.page]) ; 
elseif isunix
    %system(['xdg-open ' ps.page]) ;
    
    [r1 r2]= system(['xdg-open ' ps.page]);
    if  ~isempty(strfind(r2,'no method available'))
        
        [r1 r2]= system(['whoami']);
        ulist=strsplit(r2,char(10))';
        lastuser=strtok(char(ulist(1)),' ');
        [r1 r2]=system(['sudo -u ' lastuser ' xdg-open ' ps.page '&']);
        
    end
end

%===============================================

function [filesOKbool mi]=checkfiles(mi,files);
% check whether NIFIT-files exist
files=cellstr(files);
okvec=zeros(length(files),1);
for i=1:length(files)
    okvec(i,1) =exist(files{i})==2;
    if  okvec(i,1)==0
        [~, name,ext]=fileparts(files{i});
        mi{end+1,1}=['<b><font color="red" size="2">'  [ 'error: "' name,ext '" not found.' ] '</font><b><br>'];
        
    end
end
filesOKbool= all(okvec);



function out=add(ps)
out=[];
[pa name]=fileparts(fileparts(ps.page));
m=hopen(ps.page);

spaceLink=repmat('&nbsp;',[1 4]);

[ms me m1 m2]=newsection(m,ps);
ms{end+1,1}=['<hr>'  ];
ms{end+1,1}=['<b><h2 style="color:green; margin-top:3;margin-bottom:0"> ' upper(ps.section) ' </h2></b>'];


%% ADD JUMSPS/hyperlinks
i1=regexpi2(m,'<!-- ###TOPJUMPS###-->');
i2=regexpi2(m,'<!-- ###TOPJUMPSEND###-->');

jumps=m(i1+1:i2-1);
jumps=regexprep(jumps,{'!--','<-->'},{''}); %activate top-link
jumps(regexpi2(jumps,['codeword_' ps.section]))=[];
ms=[ms; jumps];


% last performed process:
m1=hreplace(m1,'>last performed process','</font>',[' " ' upper(ps.section) '" ']);



if strcmp(ps.section,'initialization')
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'_msk.nii');
    [filesOKbool mi]=checkfiles({},{f1 f2});
    if filesOKbool==1
        [d ds] = getslices(f1     ,1,['2'],[],0 );
        [o os] = getslices({f1 f2},1,['2'],[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi  =addimage1(mi,gifs,ps.outpath );
    end
    
elseif strcmp(ps.section,'coregistration')
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'_b1grey.nii');
    [filesOKbool mi]=checkfiles({},{f1 f2});
    if filesOKbool==1
        [d ds] = getslices(f1     ,1,['2'],[],0 );
        [o os] = getslices({f1 f2},1,['2'],[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi  =addimage1(mi,gifs,ps.outpath );
    end
    
    coregimg=fullfile(pa,'coreg2.jpg');
    if exist(coregimg)==2
        copyfile(coregimg, fullfile(pa,'summary','coreg2.jpg'),'f');
        mi{end+1,1}=   ['<img src="coreg2.jpg" width="300" height="300">'];
    end
    
elseif strcmp(ps.section,'segmentation')
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'c1t2.nii');
    [filesOKbool mi]=checkfiles({},{f1 f2});
    if filesOKbool==1
        [d ds] = getslices(f1     ,1,['2'],[],0 );
        [o os] = getslices({f1 f2},1,['2'],[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi  =addimage1(mi,gifs,ps.outpath );
    end
    
    
    
elseif strcmp(ps.section,'warping')
    
    f1=fullfile(pa,'AVGT.nii');
    f2=fullfile(pa,'x_t2.nii');
    [filesOKbool mi]=checkfiles({},{f1 f2});
    if filesOKbool==1
        [d ds]=getslices(f1     ,2,['12 20 20'],[],0 );
        [o os]=getslices({f1 f2},2,['12 20 20'],[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi  =addimage1(mi,gifs,ps.outpath );
    end
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'ix_AVGT.nii');
    [filesOKbool2 mi2]=checkfiles({},{f1 f2});
    if filesOKbool2==1
        [d ds] = getslices(f1     ,1,['2'],[],0 );
        [o os] = getslices({f1 f2},1,['2'],[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi2{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi2  =addimage1(mi2,gifs,ps.outpath );
    end
    
    if filesOKbool==1 && filesOKbool2==1
        mt(1,1)={[regexprep(mi{1},'<br>',repmat('&nbsp;',[1 174])) mi2{1}]};
        mt=[mt; [mi(2:6) ;repmat('&nbsp;',[1 80]) ; mi2(2:6)]];
        mt=[mt;'<br>'];
        mt=[mt; [mi(8) ; mi2(8)]];
        mi=mt;
    else
        mi=[mi;mi2];
    end
    
    
end

%% info
if isfield(ps,'info')
    info=cellstr(ps.info); info=info(:);
    minfo=cellfun(@(a){[ '' a  ]}, info);
    minfo=['<pre style="color:green; margin-top:0;margin-bottom:0"><font size="2">'  ; minfo;  '</font></pre>'];
else
    minfo='';
end


%% glue

m=[m1; [ms; mi;minfo ;me]; m2 ];




hsave(ps.page,m)

function  mi=addimage1(mi,gifs,outpath )

% 't2.gif'
% '_msk.gif'
% '_msk_animated.gif'




% <input type="button" value="start animation" onclick="document.getElementById('myImage').src='c1t2_animated.gif'">
% <input type="button" value="stop animation"  onclick="document.getElementById('myImage').src='c1t2.gif'">
% <input type="button" onclick="zoomimage(1,600,'myImage')" value="-zoom" />
% <input type="button" onclick="zoomimage(2,600,'myImage')" value="+zoom" />
% <br>
% <img src="t2.gif" id="myImage" width="600" height="600" onclick="changeImage('myImage','t2.gif','c1t2.gif' )" value="Change">
% <br>
[~, idtag]=fileparts(gifs{2});

mi{end+1,1}= ['<input type="button" value="start animation" onclick="document.getElementById(''' idtag ''').src=''' gifs{3} '''"> '] ;
mi{end+1,1}= ['<input type="button" value="stop animation"  onclick="document.getElementById(''' idtag ''').src=''' gifs{2} '''"> '] ;
mi{end+1,1}= ['<input type="button" onclick="zoomimage(1,200,''' idtag ''')" value="-zoom" />'] ;
mi{end+1,1}= ['<input type="button" onclick="zoomimage(2,200,''' idtag ''')" value="+zoom" />'] ;
mi{end+1,1}= ['<font size="2"> click image to toggle images</font>'];
mi{end+1,1}= ['<br>'] ;
mi{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="600" height="600" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
% mi{end+1,1}= ['<br>'] ;



% mi{end+1,1}= ['<font size="1">ckick image to toggle!</font>'] ;
% mi{end+1,1}= ['<a href="#blob" onclick="document.getElementById(''' id ''').src=''' gifs{3} '''"><font size="1"><img src="" alt="start animation" style="border:0;"/></a>'] ;
% mi{end+1,1}= ['<a href="#blob" onclick="document.getElementById(''' id ''').src=''' gifs{2} '''">         <font size="1"><img src="" alt="stop animation" style="border:0;"/></a>'];
% mi{end+1,1}= ['<br>'];
% mi{end+1,1}= ['<br>'];
% mi{end+1,1}= ['<img id ="' id '" src ="' gifs{2} '" width=600 height=600  onclick = "' ['function_' id ] '()"/>'];
% mi{end+1,1}= [' '];
% mi{end+1,1}= ['<script>'];
% mi{end+1,1}= ['var image =  document.getElementById("' id '");'];
% mi{end+1,1}= ['function ' ['function_' id ] '()'];
%
%
%
% mi{end+1,1}= ['{ ' ];
% mi{end+1,1}= ['if (image.getAttribute(''src'') == "' gifs{2} '") ' ];
% mi{end+1,1}= [' {  ' ];
% mi{end+1,1}= ['image.src = "' gifs{1} '"; ' ];
% mi{end+1,1}= ['}  ' ];
% mi{end+1,1}= ['else  ' ];
% mi{end+1,1}= ['{   ' ];
% mi{end+1,1}= ['image.src = "' gifs{2} '";  ' ];
% mi{end+1,1}= ['}  ' ];
% mi{end+1,1}= ['}   ' ];
% mi{end+1,1}= ['</script>  ' ];














function [ms me m1 m2]=newsection(m,ps);
i1=regexpi2(m,['<!-- begin:' upper(ps.section) ' -->' ]);
i2=regexpi2(m,['<!-- end:'   upper(ps.section) ' -->' ]);
m(i1:i2)=[];
% iend=regexpi2(m,'##EOF##');
iend=regexpi2(m,'<A NAME="codewordEND">');

ms={['<!-- begin:' upper(ps.section) ' -->' ]};
me={['<!-- end:'   upper(ps.section) ' -->' ]};

ms{end+1,1}=['<A NAME="codeword_' ps.section  '">'];




m1=m(1:iend-1,:);
m2=m(iend:end,:);

% iEND=regexpi2(m2,'<A NAME="codewordEND">');
% m2{iEND,1}=['<b><font size="2"><A HREF="#codewordTOP">Go to top</A></b></font><br>' '<A NAME="codewordEND">' ];


function out=copyhtml(ps)
[pa]=fileparts(ps.t);
warning off;
mkdir(pa);
copyfile(ps.s,ps.t,'f');
out=ps.t;

function out=study(ps)
out=[];
% [pa name]=fileparts(ps.study);

m=hopen(ps.page);
% m=hreplace(m,'# subject:','#',name);
% m=hreplace(m,'# path:'   ,'#',[strrep(pa,[filesep],[filesep filesep])]);
% m=regexprep(m,'#subject#',name);
m=regexprep(m,'#path#',['Project: &nbsp;&nbsp; '   strrep(ps.study,[filesep],['/'])]);
hsave(ps.page,m)





function out=timer(ps)
out=[];
m=hopen(ps.page);


if isfield(ps,'start')
    
    % remove currentTask
    pam=antcb('getallsubjects');
    for i=1:length(pam)
        if exist(fullfile(pam{i},'currentTask.mat'));
            delete(fullfile(pam{i},'currentTask.mat'));
        end
    end
    
    %% save logfile
    hlb=findobj(findobj(0,'tag','ant'),'tag','lb1');
    lab=get(hlb,'string');
    val=get(hlb,'value');
    lab=lab(val);
    
    proctask=[1 1 1 1];
    proctask(1)=~isempty(regexpi2(lab,'initial'));
    proctask(2)=~isempty(regexpi2(lab,'coregister'));
    proctask(3)=~isempty(regexpi2(lab,'segment'));
    proctask(4)=~isempty(regexpi2(lab,'xwarp-ELASTIX'));
    
    
    log.proctask=proctask;
    
    log.pas    =antcb('getallsubjects');
    log.passel =antcb('getsubjects');
    % passel  =pas(get(findobj(findobj(0,'tag','ant'),'tag','lb3'),'value'));
    % passel=pas([1 3])
    logfile=fullfile(ps.outpath,'summaryLog.mat');
    save(logfile,'log');
    
    %%==========================================
    
    m=hreplace(m,'## start time:','\;',['<b>' ps.start '</b>']);
    m=hreplace(m,'50% { opacity:', ';', '0');
    m=regexprep(m,'<blink><b>done!!!</b>.</blink>','<blink>waiting..</blink>');
    
    m=hreplace(m,'^','% processed <meter','0');
    m=hreplace(m,'value="','"></meter>','0');
    m(regexpi2(m,' <meta http-equiv="refresh" content'))={'        <meta http-equiv="refresh" content="5" >'};
    
    % remove content
 
    
    m(regexpi2(m,'<!--SUBJECTS_START-->')+1:regexpi2(m,'<!--SUBJECTS_STOP-->')-1)=[];
    
    
%     if 0
%         
%         ht=xhtmlgr('copyhtml','s' ,which('formgr.html'),'t',fullfile(px,'summary.html'));
%         xhtmlgr('study','page',ht,'study',px);
%         xhtmlgr('timer','page',ht,'start',datestr(now));
%     
%     end
    
    
    
elseif isfield(ps,'stop')
    
    % remove currentTask
    pam=antcb('getallsubjects');
    for i=1:length(pam)
        if exist(fullfile(pam{i},'currentTask.mat'));
            delete(fullfile(pam{i},'currentTask.mat'));
        end
    end
    
    m=hreplace(m,'## end time:','\;',['<b>' ps.stop '</b>']);
    m=hreplace(m,'50% { opacity:', ';', '100');
    m=regexprep(m,'<blink>waiting</blink>','<blink><b>done!!!</b>.</blink>');
    
    m=hreplace(m,'^','% processed <meter','100');
    m=hreplace(m,'value="','"></meter>','100');
    
    t1=hget(m,'## start time:','\;'); t1=regexprep(t1,'<.*?>','');
    t2=hget(m,'## end time:','\;');    t2=regexprep(t2,'<.*?>','');
    tdif=etime(datevec(t2),datevec(t1));
    tstr=secs2hms(tdif);
    m=hreplace(m,'## diff time:','\;',['<b>' tstr '</b>']);
    
    m(regexpi2(m,' <meta http-equiv="refresh" content'))={'        <meta http-equiv="refresh" content="1000" >'};
elseif isfield(ps,'progress')
    if 0
        xhtml('timer','page',ht,'progress',10)
    end
    
    if ps.progress>100; ps.progress=100; end
    if ps.progress<1  ; ps.progress=1    ; end
    
    m=hreplace(m,'^','% processed <meter',num2str(ps.progress));
    m=hreplace(m,'value="','"></meter>'  ,num2str(ps.progress));
    
end
hsave(ps.page,m)


function m=hopen(page)
m = fileread(page);
m=strsplit(m,char(10))';


function hsave(page,m)
% pause(.1);
% disp('pAGE');
% disp(page);
suc=0;

while suc==0
    try
        filePh = fopen(page,'w');
        fprintf(filePh,'%s\n',m{:});
        fclose(filePh);
        suc=1;
    end
end

function m=hreplace(m,tag1,tag2,input)
% tag1='##subject:';  tag2='##'
m=regexprep(m,['((?<=' tag1 ').*(?=' tag2 '))'],['' input '']);


function sout=hget(m,tag1,tag2)
s=regexp(m,['((?<=' tag1 ').*(?=' tag2 '))'],'tokens');
ix=find(~cellfun('isempty', s));
sout=char(s{ix(1)}{1});






function time_string=secs2hms(time_in_secs)
time_string='';
nhours = 0;
nmins = 0;
if time_in_secs >= 3600
    nhours = floor(time_in_secs/3600);
    if nhours > 1
        hour_string = ' hours, ';
    else
        hour_string = ' hour, ';
    end
    time_string = [num2str(nhours) hour_string];
end
if time_in_secs >= 60
    nmins = floor((time_in_secs - 3600*nhours)/60);
    if nmins > 1
        minute_string = ' mins, ';
    else
        minute_string = ' min, ';
    end
    time_string = [time_string num2str(nmins) minute_string];
end
nsecs = time_in_secs - 3600*nhours - 60*nmins;
time_string = [time_string sprintf('%2.1f', nsecs) ' secs'];










