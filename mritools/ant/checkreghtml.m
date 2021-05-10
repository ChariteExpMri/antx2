
%% write html file with overlay of specific images 
% pa=...
%     {
%     'F:\data3\graham_ana4\dat\20190122GC_MPM_01'
%     'F:\data3\graham_ana4\dat\20190122GC_MPM_02'
%     };
% filepairs={'AVGT.nii','x_T1.nii' }
% outpath='F:\data3\graham_ana4\check'
% checkreghtml(pa,filepairs,outpath)
% checkreghtml(pa,filepairs,outpath,struct('size',300))



function checkreghtml(datapaths, filepairs,outpath,p0)
warning off

p.size      =400; %imageSize 
p.grid      =1; %show grid
p.gridspace =20 ; %grid-space (pixel): 25 is good
p.gridcolor =[1 0 0];
p.dim       =2;  %dimension to plot
p.slices    ='n6';
p.outputstring  =''; %<optional: outputstring

if exist('p0')
    p=catstruct(p,p0);
end

if 0
    pa=...
        {
        'F:\data3\graham_ana4\dat\20190122GC_MPM_01'
        'F:\data3\graham_ana4\dat\20190122GC_MPM_02'
        };
%     filepairs={'x_T1.nii', 'AVGT.nii';}
    filepairs={'AVGT.nii','x_T1.nii' }
    filepairs={'AVGT.nii','blob.nii' }
    outpath='F:\data3\graham_ana4\check'
    
    checkreghtml(pa,filepairs,outpath)
    
    
end
% ==============================================
%%
% ===============================================
pas=cellstr(datapaths);
fname1=filepairs{1};
fname2=filepairs{2};

% name=[fname1 '__' fname2]
[~,tag1]=fileparts(fname1);
[~,tag2]=fileparts(fname2);
name=[tag1 '--' tag2];
if ~isempty(p.outputstring)
    
    if strcmp(p.outputstring(1),'_')==0
        name=[name '_' p.outputstring];
        
    else
        name=[name p.outputstring];
    end
end

% ==============================================
%%
% ===============================================
mkdir(outpath);
% subpath='subs'
subpath=name;
subpathFP=fullfile(outpath,subpath);
mkdir(subpathFP);

p.subpath=subpath;

% ==============================================
%%
% ===============================================
htmlfile=fullfile(outpath,[ 'r_' name '.html']);
cssfile=fullfile(outpath,subpath,'styles.css');
writeCSS(cssfile,p);



header=[ '[' fname1 ''  '-' '' fname2 ']' ];
l=htmlprep(htmlfile,'styles.css',header,p );
% ==============================================
%%
% ===============================================



for i=1:length(pas)
    %fprintf('%s','.');
    pdisp(i,1); 
    
    px=pas{i};
    % fname1='x_T1.nii'
    % fname2='AVGT.nii';
    % % px='V:\Graham\pipeline_test\2019_pilot\analysis4\dat\20190122GC_MPM_01'
    % px='F:\data3\graham_ana4\dat\20190122GC_MPM_01'
    
    [~,aname]=fileparts(px);
    p.title  =aname;
    p.idx    =i;  
    
    vi={};
    f1=fullfile(px,fname1);
    f2=fullfile(px,fname2);
    isOK=0;
    slices=num2str(p.slices);
    if exist(f1) && exist(f2)
        [d ds]=getslices(f1,     p.dim,slices,[],0 );
        [o os]=getslices({f1 f2},p.dim,slices,[],0 );
        gifs   = saveslices_gif({d,ds},{o os}, 1,subpathFP,aname);
        vi(1,:)={fname1  spm_vol(f1)};
        vi(2,:)={fname2  spm_vol(f2)};
        isOK=1;
    else
        if exist(f1)==0
           gifs{1,1}= [ 'ERROR: [' aname ']' ' file:' '"' fname1 '" not found' ];
        else
              gifs{2,1}= [ '[' aname ']' ' file:' '"' fname1 '" exist' ]; 
        end
        if exist(f2)==0
           gifs{2,1}= [ 'ERROR: [' aname ']' ' file:' '"' fname2 '" not found' ];
        else
              gifs{2,1}= [ '[' aname ']' ' file:' '"' fname2 '" exist' ]; 
        end
        gifs{3,1}= [ 'ERROR: MISSING IMAGE' ];
        
     end   
        l=addimages(htmlfile,subpath,gifs,p,l );
    
    %-----add some info
    if isOK==1;
        l=addInfo( l, vi,p);
    end

    if i==length(pas)
        l{end+1}='<br><br>';
    end
    pwrite2file(htmlfile, l);  
end
disp('Done.');

showinfo2('checkRegHtml',htmlfile);

%———————————————————————————————————————————————
%%   add index
%———————————————————————————————————————————————


[filesfp] = spm_select('FPList',outpath,'.*.html');
filesfp=cellstr(filesfp);
filesfp(regexpi2(filesfp,'index.html'))=[];

s2={'<html><br><br>'};
s2{end+1,1}=[[ '<font color=blue>'  '<h2>' 'OVERLAYS' '</h2>'  '<font color=black>' ];];
s2{end+1,1}=[[ '<font color=green>' '<h4>' ['Path: ' outpath ] '</h4>'  '<font color=black>' ];];

for i=1:length(filesfp)
    [~ ,file,ext]=fileparts(filesfp{i});
    k=dir(filesfp{i});
    s2{end+1,1}=[...
        ' &#9864;  <a href="' [file ext] '"target="_blank">' [file ext]  '</a>' ...
        [    ' <p style="color:blue;display:inline;font-family=''Courier New''; font-size:10px;">' ...
        [ 'Created: '  k(1).date ]   '</p>'] ...
        '<br>'];
    %     <a href="url">link text</a>
end
% <p style="display:inline">...</p>


s2{end+1,1}=['<pre><p style="color:blue;font-family=''Courier New''; font-size:10px;">' [ 'Created: '  datestr(now)]   '</p></pre>'];

indexfile=fullfile(outpath,'index.html');
pwrite2file(indexfile, s2);
showinfo2('INDEXfile',indexfile);

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————


function l1=addInfo(l, vi,p);

% d={};
% d{end+1,1}=['<p style="color:blue;font-size:9px;">This is demo text</p>'];
% l1=[l; d];
% pwrite2file(htmlfile, l1)
% ==============================================
%%   
% ===============================================

d={};
ps={};
for i=1:2
    v=vi{i,2}(1);
    dim=v.dim;
    if length(vi{i,2})>1
        dim=[dim length(vi{i,2})];
    end
    tit=[ ['<b><u>' vi{i,1} '</b></u>']   ';  DIM: [' regexprep(num2str(dim),'\s+','#') ']' ];
    pl=plog([],v.mat(1:3,:),0,tit,'plotlines=0');
    ps=[ps [{tit};pl]];   
    fpname{i,1}=v.fname;
%     dx=strjoin([tit; pl],'<br>');
%     d{end+1,1}=['<pre><p style="color:blue;font-size:9px;">' dx   '</p></pre>'];
end
% col1=repmat({repmat(' ',[1 p.size])},[size(ps,1) 1]);

nlet=size(char(ps),2);
spac=50;
ps2=cellfun(@(a,b){[ a repmat(' ',[1  nlet-length(a)+spac])  ...
    b repmat(' ',[1  nlet-length(b)+spac])  ]},ps(:,1),ps(:,2));

% ps2=plog([],[ ps],0,'tit','plotlines=0,s=20');


col1=[fpname; repmat({' '},[ size(ps2,1)-2 1])];
nlet=size(char(col1),2);
ps2=cellfun(@(a,b){[ a repmat(' ',[1  nlet-length(a)+50])   b   ]},col1,ps2);
% % % ps2=cellfun(@(a){[ repmat(' ',[1 round(p.size/9*2) ]) a  ]},ps2);

ps2=regexprep(ps2,'#',' ');
ps3=strjoin(ps2,'<br>');
 d{end+1,1}=['<pre><p style="color:blue;font-family=''Courier New''; font-size:9px;">' ps3   '</p></pre>'];

%  d=strrep(d,' ' ,'&nbsp')
% for i=1:size(ps2,1)
%     d{end+1,1}=['<pre><p style="color:blue;font-family=''Courier New''; font-size:9px;">' ps2{i}   '</p></pre>'];
% end


l1=[l; d];
% -------------


% ==============================================
%%   
% ===============================================







function l1=addimages(htmlfile,subpath,gifs,p,l0 )
sp='&nbsp';
aname =p.title;
siz   =p.size;
idx   =p.idx;
% % gifs=stradd(gifs,[subpath '/'],1);
gifs=cellfun(@(a){[subpath '/' a ]},gifs);

l={[ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname   '</h5>'  '<font color=black>' ]    ;
    };

%idtag=gifs{2};
 [~, idtag]=fileparts(gifs{2});
 
 
%  bol=[...
%      exist(gifs{1})==2  isempty(strfind(gifs{1},'ERROR:')) ;
%      exist(gifs{2})==2  isempty(strfind(gifs{2},'ERROR:')) ;
%      ]
 

gifsFP=cellfun(@(a){[  fileparts(htmlfile)   filesep a   ]},gifs);

 
 %% ___animated gif_____________________________________________________________________________________________
 
 if exist(gifsFP{1})==2 && isempty(strfind(gifsFP{1},'ERROR:')) && ...
         exist(gifsFP{2})==2 && isempty(strfind(gifsFP{2},'ERROR:'))
     l{end+1,1}= ['<input type="button" value="start animation" onclick="document.getElementById(''' idtag ''').src=''' gifs{3} '''"> '] ;
     l{end+1,1}= ['<input type="button" value="stop animation"  onclick="document.getElementById(''' idtag ''').src=''' gifs{2} '''"> '] ;
     l{end+1,1}= ['<input type="button" onclick="zoomimage(1,200,''' idtag ''')" value="-zoom" />'] ;
     l{end+1,1}= ['<input type="button" onclick="zoomimage(2,200,''' idtag ''')" value="+zoom" />'] ;
     l{end+1,1}= ['<font size="2"> click image to toggle images</font>'];
     l{end+1,1}= ['<br>'] ;
     
     l{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) ...
         '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
 else
     %l{end+1,1}= ['<pre><font color=red> ' gifs{3} '<font color=black>  </pre>   '] ;
 end
  %% ___statig IMAG1_____________________________________________________________________________________________

 if exist(gifsFP{1})==2 && isempty(strfind(gifsFP{1},'ERROR:'))
     l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{1} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
 else
      if isempty(strfind(gifsFP{1},'ERROR:'))==1
         col='gray';
     else
         col='red';
     end
     l{end+1,1}= ['<pre><font color=red> ' gifs{1} '<font color=black>  </pre>   '] ;
 end
   %% ___statig IMAG2_____________________________________________________________________________________________

 if exist(gifsFP{2})==2 && isempty(strfind(gifsFP{2},'ERROR:'))
     l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{2} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
 else
     if isempty(strfind(gifsFP{2},'ERROR:'))==1
         col='gray';
     else
         col='red';
     end
     l{end+1,1}= ['<pre><font color=' col '> ' gifs{2} '<font color=black>  </pre>   '] ;
 end


% l{end+1,1}= ['<img src="' gifs{1} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
% l{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;


%   l{end+1,1}= ['<div class="grid fixed">' ...
%       '<img src="' gifs{1} '" width="' num2str(siz) '" height="' num2str(siz) '" />' ...
%       '<img src="' gifs{2} '" width="' num2str(siz) '" height="' num2str(siz) '" />' ...
%       '</div>'] ;
% l{end+1,1}= ['<div class="grid fixed"><img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{2} ''',''' gifs{1} ''' )" value="Change"></div>'] ;
% l{end+1,1}='<div id="drawTable" style="background:url(''https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQiX43nTAcsgpYUlK0MarurfXV_Hx2w53BonmYbKJUNyO4GJ35Q'');width:275px; height:183px"></div>'

% mi{end+1,1}= ['<br>'] ;
% l=[l ; add2; adds];
l1=[l0;l];

% pwrite2file(htmlfile, l1)



% ==============================================
%%   htmlprep(outpath)
% ===============================================
function lf=htmlprep(htmlfile,cssfile,header,p)


sp='&nbsp';
siz=[400];


add2={
%     '<style>'
%     'h5 { '
%     '    display: block;'
%     '    font-size: 0.9em;'
%     '    margin-top: 0em;'
%     '    margin-bottom: 0em;'
%     '    margin-left: 10;'
%     '    margin-right: 10;'
%     '    font-weight: bold;'
%     '}'
%     '</style>'
    };

l={
    '<html>'
    '<head>'
    [ '<link rel="stylesheet" href="' fullfile(p.subpath,cssfile) '">']
    };

JS=getJS;

l=[l;  add2; '</head>'];

l2={['<body>']
  [ '<font color=blue>' '<h3><u>' header '</u>' '</h3>'  '<font color=black>' ];
   ['</body>' ]
   };

lf=[l;l2; JS];

pwrite2file(htmlfile, lf);









function rest

% ==============================================
%%
% ===============================================
htmlfile=fullfile(outpath,'index.html')
sp='&nbsp';
siz=[400]




cssfile=fullfile('styles.css');

l={
    '<html>'
    '<head>'
    [ '<link rel="stylesheet" href="' cssfile '">']
    %[<script type="text/javascript" src="path-to-javascript-file.js"></script>]
    '</head>'
    '<body>'
    [ '<font color=blue>' '<h3><u> [' fname1 ']'  '-' '[' fname2 ']'  '</u>' '</h3>'  '<font color=black>' ]
    [ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname   '</h5>'  '<font color=black>' ]
    %    [  'lala'   '<br>' ]
    
    }


[~, idtag]=fileparts(gifs{2});
l{end+1,1}= ['<input type="button" value="start animation" onclick="document.getElementById(''' idtag ''').src=''' gifs{3} '''"> '] ;
l{end+1,1}= ['<input type="button" value="stop animation"  onclick="document.getElementById(''' idtag ''').src=''' gifs{2} '''"> '] ;
l{end+1,1}= ['<input type="button" onclick="zoomimage(1,200,''' idtag ''')" value="-zoom" />'] ;
l{end+1,1}= ['<input type="button" onclick="zoomimage(2,200,''' idtag ''')" value="+zoom" />'] ;
l{end+1,1}= ['<font size="2"> click image to toggle images</font>'];
l{end+1,1}= ['<br>'] ;
l{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
% l{end+1,1}= ['<img src="' gifs{1} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
% l{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;


l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{1} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{2} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;


%   l{end+1,1}= ['<div class="grid fixed">' ...
%       '<img src="' gifs{1} '" width="' num2str(siz) '" height="' num2str(siz) '" />' ...
%       '<img src="' gifs{2} '" width="' num2str(siz) '" height="' num2str(siz) '" />' ...
%       '</div>'] ;



% l{end+1,1}= ['<div class="grid fixed"><img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{2} ''',''' gifs{1} ''' )" value="Change"></div>'] ;


% l{end+1,1}='<div id="drawTable" style="background:url(''https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQiX43nTAcsgpYUlK0MarurfXV_Hx2w53BonmYbKJUNyO4GJ35Q'');width:275px; height:183px"></div>'


% mi{end+1,1}= ['<br>'] ;
l=[l ; add2; adds];

pwrite2file(htmlfile, l)


% pwrite2file(cssfile, css)

% ==============================================
%%   css
% ===============================================
function writeCSS(cssfile,p)

col=round(p.gridcolor.*255);
col=cellfun(@(a){[  num2str(a)  ]},num2cell(col)); %to strCell
% ---
gridtransp=0;
if p.grid==1
    gridtransp=1;
end

    

css={
    %'div { border-style: none!important;  padding-bottom: 0px;    padding-top: -0px;}'
    '*,'
    '*::before,'
    '::after {'
    '  margin: 1;'
    '  padding: 0;'
    '  box-sizing: border-box;'
    '}'
    '.grid img {'
    '  display: block;'
    '}'
    '.grid {'
    '  display: inline-block;'
    '  position: relative;'
    '  margin: -1px;'
    '  vertical-align: top;'
    '}'
    '.grid::before,'
    '.grid::after {'
    '  content: '''';'
    '  position: absolute;'
    '  top: 0;'
    '  left: 0;'
    '  width: 100%;'
    '  height: 100%;'
    ['  background: linear-gradient(to right, rgba(' col{1} ', '  col{2} ','  col{3} ',' num2str(gridtransp) ') 0px, transparent 1px);']
    %'  background: linear-gradient(to right, rgba(255, 0, 0, 0.7) 0px, transparent 1px);'
    '  background-size: 10%;'
    '}'
    '.grid::before {'
    ' background-color: transparent;'
    %  '  background-color: rgba(0, 0, 0, 0.0);'
    %  '  box-shadow: inset 0px 0px 0 2px #000;'
    '}'
    '.grid::after {'
    '  transform: rotate(90deg);'
    '}'
    '.fixed::before,'
    '.fixed::after {'
    ['  background-size: ' num2str(p.gridspace) 'px;']
    '}'
    };
pwrite2file(cssfile, css)


% ==============================================
%%   javascript
% ===============================================

function js=getJS
js={
    '    <script type="text/javascript">'
    '        function zoomimage()'
    '        {'
    '        var task = parseInt(arguments[0]);   // 0,1 ..smaller larger'
    '        var SIZE = parseInt(arguments[1]);  //var SIZE = 200;'
    '        var ID   = arguments[2];            //var ID   = "myImage";'
    '        '
    '        '
    '        '
    '        '
    '        '
    '        if (task == 2){            '
    '        var myImg = document.getElementById(ID);'
    '        var currWidth = myImg.clientWidth;'
    '        if(currWidth == 2000){'
    '        alert("Maximum zoom-in level reached.");'
    '        } else{'
    '        myImg.style.width = (currWidth + SIZE) + "px";'
    '        myImg.style.height= (currWidth + SIZE) + "px";'
    '        } '
    '        } '
    '        '
    '        else {'
    '        var myImg = document.getElementById(ID);'
    '        var currWidth = myImg.clientWidth;'
    '        if(currWidth-SIZE <= 150){'
    '        myImg.style.width = 100 + "px";'
    '        myImg.style.height= 100 + "px";'
    '        } else{'
    '        myImg.style.width = (currWidth - SIZE) + "px";'
    '        myImg.style.height = (currWidth -SIZE) + "px";'
    '        }'
    '        }'
    '        }'
    '    </script>'
    '    <script>'
    '        function changeImage() {'
    '        '
    '        var ID      = arguments[0];'
    '        var BGimage = arguments[1]; //t2'
    '        var FGimage = arguments[2]; //c1t2'
    '        '
    '        var image = document.getElementById(ID);'
    '        if (image.src.match(FGimage)) {'
    '        image.src = BGimage;'
    '        }'
    '        else {'
    '        image.src = FGimage;'
    '        }'
    '        }'
    '    </script>'
    };