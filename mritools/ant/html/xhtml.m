


function varargout=xhtml(task,varargin)
varargout={};

if 0
    tic
    px='O:\data4\phagozytose\dat\20190221CH_Exp1_M58';
    
    
    ht=xhtml('copyhtml','s' ,fullfile(pwd,'form0.html'),'t',fullfile(px,'summary','index.html'));
    xhtml('subject','page',ht,'subject',px);
    xhtml('timer','page',ht,'start',datestr(now));
    %     web('index.html');
    %     xhtml('timer','page',ht,'stop',datestr(now));
    
    infomsg={'das ist ein TEST','das ist ein anderer      TEST'}
    xhtml('add','page',ht,'section','initialization','info',infomsg);
    xhtml('add','page',ht,'section','coregistration');
    
    
    xhtml('add','page',ht,'section','segmentation');
    xhtml('add','page',ht,'section','warping');
    
    xhtml('timer','page',ht,'progress',10);
    
    toc
    web(ht);
end

if 0
    
    %———————————————————————————————————————————————
    %%   % simulate stuff
    %———————————————————————————————————————————————
    
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
    
    
    
    
    
    
    
    
    if showbrowser; web(ht); end
    
    
    
    
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    
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




%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————
if strcmp(task,'copyhtml');  varargout{1}  =copyhtml(ps); end
if strcmp(task,'subject');   varargout{1}  =subject(ps); end
if strcmp(task,'timer');     varargout{1}  =timer(ps); end
if strcmp(task,'add');       varargout{1}  =add(ps); end
if strcmp(task,'progress');  varargout{1}  =progress(ps); end

if strcmp(task,'addprocessinglinks'); 
    varargout{1}=addprocessingLinks(ps)
    
end
%———————————————————————————————————————————————
%%   subs
%———————————————————————————————————————————————

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


% function out=addprocessingLinks(ps)
% 
% 'a'
% files=HTMLprocsteps(fileparts(fileparts(ps.subject)),struct('refresh',0,'show',0));
%% ===============================================



%% ===============================================


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



slice='n16';

if strcmp(ps.section,'initialization')
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'_msk.nii');
    [filesOKbool mi]=checkfiles({},{f1 f2});
    if filesOKbool==1
        [d ds] = getslices(f1     ,1,[slice],[],0 );
        [o os] = getslices({f1 f2},1,[slice],[],0 );
        [o d]=adjustContrast(o,d);
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
        [d ds] = getslices(f1     ,1,[slice],[],0 );
        [o os] = getslices({f1 f2},1,[slice],[],0 );
        [o d]=adjustContrast(o,d);
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
        [d ds] = getslices(f1     ,1,[slice],[],0 );
        [o os] = getslices({f1 f2},1,[slice],[],0 );
        [o d]=adjustContrast(o,d);
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
%         try
%         [d ds]=getslices(f1     ,2,['12 20 20'],[],0 );
%         [o os]=getslices({f1 f2},2,['12 20 20'],[],0 );
%         catch
%         [d ds]=getslices(f1     ,2,['3'],[],0 );
%         [o os]=getslices({f1 f2},2,['3'],[],0 );    
%         end
        
        [d ds] = getslices(f1     ,2,[slice],[],0 );
        [o os] = getslices({f1 f2},2,[slice],[],0 );
        [o d]=adjustContrast(o,d);
        gifs   = saveslices_gif({d,ds},{o os}, 1,ps.outpath);
        msg=[' overlay: [' gifs{1} '] and [' gifs{2} '] '] ;
        mi{1,1}=['<b><font size="2"><span style="background-color:rgb(255,215,0);"> ' msg  '</span></font></b><br>'];
        mi  =addimage1(mi,gifs,ps.outpath );
    end
    
    f1 = fullfile(pa,'t2.nii');
    f2 = fullfile(pa,'ix_AVGT.nii');
    [filesOKbool2 mi2]=checkfiles({},{f1 f2});
    if filesOKbool2==1
%         [d ds] = getslices(f1     ,1,['2'],[],0 );
%         [o os] = getslices({f1 f2},1,['2'],[],0 );
        
        [d ds] = getslices(f1     ,1,[slice],[],0 );
        [o os] = getslices({f1 f2},1,[slice],[],0 );
        [o d]=adjustContrast(o,d);
        
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

function [o2 d2]=adjustContrast(o,d)
o2=o;
for i=1:size(o2,3)
    o2(:,:,i)=imadjust(mat2gray(o2(:,:,i)));
end
d2=d;
for i=1:size(d2,3)
    d2(:,:,i)=imadjust(mat2gray(d2(:,:,i)));
end

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

function out=subject(ps)
out=[];
[pa name]=fileparts(ps.subject);

m=hopen(ps.page);
% m=hreplace(m,'# subject:','#',name);
% m=hreplace(m,'# path:'   ,'#',[strrep(pa,[filesep],[filesep filesep])]);
m=regexprep(m,'#subject#',name);
m=regexprep(m,'#path#',[strrep(pa,[filesep],['/'])]);
hsave(ps.page,m)


function out=timer(ps)
out=[];
m=hopen(ps.page);


if isfield(ps,'start')
    m=hreplace(m,'## start time:','\;',['<b>' ps.start '</b>']);
    m=hreplace(m,'50% { opacity:', ';', '0');
    m=regexprep(m,'<blink>done.</blink>','<blink>waiting..</blink>');
    
    m=hreplace(m,'^','% processed <meter','0');
    m=hreplace(m,'value="','"></meter>','0');
    m(regexpi2(m,' <meta http-equiv="refresh" content'))={'        <meta http-equiv="refresh" content="5" >'};
    
elseif isfield(ps,'stop')
    m=hreplace(m,'## end time:','\;',['<b>' ps.stop '</b>']);
    m=hreplace(m,'50% { opacity:', ';', '100');
    m=regexprep(m,'<blink>waiting</blink>','<blink>done.</blink>');
    
    m=hreplace(m,'^','% processed <meter','100');
    m=hreplace(m,'value="','"></meter>','100');
    
    t1=hget(m,'## start time:','\;'); t1=regexprep(t1,'<.*?>','');
    t2=hget(m,'## end time:','\;');    t2=regexprep(t2,'<.*?>','');
    tdif=etime(datevec(t2),datevec(t1));
    tstr=secs2hms(tdif);
    m=hreplace(m,'## diff time:','\;',['<b>' tstr '</b>']);
    
    m(regexpi2(m,' <meta http-equiv="refresh" content'))={'        <meta http-equiv="refresh" content="1000" >'};

elseif isfield(ps,'rerun')
    m(regexpi2(m,' <meta http-equiv="refresh" content'))={'        <meta http-equiv="refresh" content="5" >'};

elseif isfield(ps,'progress')
    if 0
        xhtml('timer','page',ht,'progress',10)
    end
    
    if ps.progress>100; ps.progress=100; end
    if ps.progress<1  ; ps.progress=1    ; end
    
    m=hreplace(m,'^','% processed <meter',num2str(ps.progress));
    m=hreplace(m,'value="','"></meter>'  ,num2str(ps.progress));
    
end

%adding links
% 'a'
% is=regexpi2(m,'</body>');
% m1=m(1:is-1)
% m2=m(is:end)
% 
% w={'<a href="https://www.w3schools.com/">Visit W3Schools.com!</a>'
%    '<a href="https://www.w3schools.com/">Visit W3Schools.com!</a>'
%    '<a href="https://www.w3schools.com/">Visit W3Schools.com!</a>'}
% x=[m1;w;m2]

hsave(ps.page,m);


function m=hopen(page)
m = fileread(page);
m=strsplit(m,char(10))';


function hsave(page,m)
filePh = fopen(page,'w');
fprintf(filePh,'%s\n',m{:});
fclose(filePh);

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










