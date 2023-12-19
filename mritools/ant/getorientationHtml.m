
% get orientation using asciiArt (no-display-mode/no graphic card)
% getorientationAscii(f1,f2,varargin)
%% --INPUT--
% f1=fullpath-NIFTI  (e.g. 't2.nii') ;
% f2=fullpath-REFERENCE-NIFTI ('AVGT.NII')
% f1=fullfile('F:\data7\automaticCoreg\dat\issue1','t2.nii')
% f2=fullfile('F:\data7\automaticCoreg\templates','AVGT.nii')
% getorientationAscii(f1,f2) ;% display ; % display in cmd-window
% getorientationAscii(f1,f2,'write',0) ;% display in cmd-window
% getorientationAscii(f1,f2,'write',1,'disp',0) ;% just write to txt-file

function htmlfile=getorientationHtml(f1,f2,varargin)

p.size       =400; %imageSize
p.grid      =1; %show grid
p.gridspace  =20 ; %grid-space (pixel): 25 is good
p.gridcolor  =[1 0 0];
p.dim        =2;  %dimension to plot
% p.slices    ='n6';
p.outputstring='Reorient';



if nargin>2
    s = {varargin{:}};
    p = cell2struct(s(2:2:end),s(1:2:end),2);
end


if isfield(p,'disp')  ==0;        p.disp     =1; end
if isfield(p,'slices')==0;        p.slices   =1; end     %No of slices for MIP
% if isfield(p,'write') ==0;        p.write    =0; end
% if isfield(p,'edge')  ==0;        p.edge     =0; end

if isfield(p,'fc')    ==0;        p.fc       =.4; end




if 0
    %% ===============================================
    
    f1=fullfile('F:\data7\automaticCoreg\dat\issue1','t2.nii')
    f2=fullfile('F:\data7\automaticCoreg\templates','AVGT.nii')
    getorientationAscii(f1,f2) ;% display ; % display in cmd-window
    getorientationAscii(f1,f2,'write',0) ;% display in cmd-window
    getorientationAscii(f1,f2,'write',1,'disp',0) ;% just write to txt-file
    %% ===============================================
    f1='F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_18-9_DTI_T2_MPM\t2.nii'
    f2='F:\data8_MPM\MPM_agBrandt3\templates\AVGT.nii'
    getorientationAscii(f1,f2,'slices',1) ;%
    %% ===============================================
    
    
end

%% ===============================================

if exist('f1')==0 || isempty(f1)
    global an
    mdir=antcb('getsubjects');
    f1=fullfile(mdir{1},'t2.nii');
end
if exist('f2')==0 || isempty(f2)
    global an
    f2=fullfile(fileparts(an.datpath),'templates','AVGT.nii');
end

p.img=f1;
p.ref=f2;



% p.slices=5;

[arg,rot]=evalc(['' 'findrotation2' '']);
p.rot=rot;
p.rotlist=arg;

%de-pack
rot=p.rot;
% hs =p.hs;
% rb =p.rb;
% ipl=length(p.hs)./p.np; %IMAGE PER LINE

m={};
padloc='post'; %pre
r={};%reference
for i=1:size(p.rot,1)
    
    rotm   = str2num(char(rot{i}));
    vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotm 1 1 1 0 0 0])));
    rotinv = vecinv(4:6);
    
    o = get_orthoview(     p.img,[0 0 0 rotinv],0,'max',p.slices);
    o.imgc=imadjust(mat2gray(o.imgc));
    o.imgs=imadjust(mat2gray(o.imgs));
    o.imgt=imadjust(mat2gray(o.imgt));
    % ===============================================
    
    si=[size(o.imgc) size(o.imgs) size(o.imgt)];
    mxh=max(si(1:2:end));
    v1=padarray(o.imgc,mxh-size(o.imgc,1),0,    padloc);
    v2=padarray(o.imgs,mxh-size(o.imgs,1),0,    padloc);
    v3=padarray(o.imgt,mxh-size(o.imgt,1),0,    padloc);
    v=[v1 v2 v3];
    v=flipud(v);
    
    %equal size
    %v=imresize(v,[size(v,2) size(v,2)],'nearest' );
    %size(v,2)-size(v,1)
    %v=padarray(v, size(v,2)-size(v,1)  ,0,'pre');
    
    q.idx    =i;
    q.rot    =rot{i};
    q.rotstr =rotm;
    
    [~,name,ext] =fileparts(p.img);
    q.name   =[name ext];
    m(i,:)={q v};
    
    if i==1
        u = get_orthoview( p.ref,[0 0 0 ],0,'max',p.slices);
        u.imgc=imadjust(mat2gray(u.imgc));
        u.imgs=imadjust(mat2gray(u.imgs));
        u.imgt=imadjust(mat2gray(u.imgt));
                      
        si=[size(u.imgc) size(u.imgs) size(u.imgt)];
        mxh=max(si(1:2:end));
        v1=padarray(u.imgc,mxh-size(u.imgc,1),0,    padloc);
        v2=padarray(u.imgs,mxh-size(u.imgs,1),0,    padloc);
        v3=padarray(u.imgt,mxh-size(u.imgt,1),0,    padloc);
        v=[v1 v2 v3];
        v=flipud(v);
        q.idx    =1;
        q.rot    =[0 0 0];
        q.rotstr ='0 0 0';
        [~,name,ext] =fileparts(p.ref);
        q.name   =[name ext];
        r(i,:)={q v};
        
        
    end
    
    %cut borders (U/D)
    % b=double(v)==double('@')
end

% ==============================================
%%  PART-2:  make HTML
% ===============================================
%% ===============================================
%  change struct
%% ===============================================
g={};
for i=1:size(m,1)
    w=m{i,1};
    
    w1=struct();
    w1.hdr1=[ 'LEFT: ["' w.name  '"]          RIGHT: ["' r{1}.name '"]' ];
    w1.hdr2=[ 'rotTable-Index [' num2str(w.idx) ']:'   '  which is ''' regexprep(num2str(w.rotstr),'\s+',' ') ''''  ];
    
%     if size(m{i,2},1)<size(r{1,2},1)
        %q=padarray(m{i,2},size(r{1,2},1)-size(m{i,2},1),0.5,'pre');
        q=imresize(m{i,2},size(r{1,2}), 'nearest');
        img= [{q}  r(1,2)];
%     else
%         img=[m(i,2)  r(1,2)];
%     end
    g(i,:)= {w1 img};
end
%% ===============================================

% p.size       =400; %imageSize
% p.grid      =1; %show grid
% p.gridspace  =20 ; %grid-space (pixel): 25 is good
% p.gridcolor  =[1 0 0];
% p.dim        =2;  %dimension to plot
% % p.slices    ='n6';
% p.outputstring='Reorient';
%% =======[HTML-filename]========================================


% name=[fname1 '__' fname2]
[~,tag1]=fileparts(w.name);
[~,tag2]=fileparts(r{1}.name);
name=[tag1 '--' tag2];
if ~isempty(p.outputstring) % add outputstring
    if strcmp(p.outputstring(1),'_')==0
        name=[p.outputstring  '_' name ];
    else
        name=[ p.outputstring name];
    end
else
    name=['r_' name ];
end
%===========================================
%%   OUTPUTpath
%===========================================
if ~isempty(strfind(f1,[filesep 'dat' filesep]))
    outpath=fullfile(fileparts(fileparts(fileparts(f1))),'checks');
elseif ~isempty(strfind(f2,[filesep 'dat' filesep]))
    outpath=fullfile(fileparts(fileparts(fileparts(f1))),'checks')
end
if isempty(char(outpath))
    try
        global an
        outpath= fullfile( fileparts(an.datpath),'checks');
    end
    if isempty(char(outpath))
        [od]=uigetdir(pwd,'select/create+select output directory');
        if isnumeric(od);
            disp('canceled'); return;
        else
            outpath=od ;
        end
    end
end

warning off
if exist(outpath)~=7; mkdir(outpath); end
subpath=name;
subpathFP=fullfile(outpath,subpath);
mkdir(subpathFP);
p.subpath   =subpath;
p.subpathFP =subpathFP;
p.outpath   =outpath;

%% ===============================================
htmlfile=fullfile(outpath,[  name '.html']);
cssfile=fullfile(outpath,subpath,'styles.css');
writeCSS(cssfile,p);

header=name;
l=htmlprep(htmlfile,'styles.css',header,p );
%% ===============================================
sp='&nbsp';
l{end+1,1}=[ '<font color=green>' '<h4> '  ']'  sp  w1.hdr1  '</h5>'  '<font color=black>' ] ;

for i=1:size(g,1)
    d=g{i,1};
    im=g{i,2} ;
    
    p.title  =d.hdr1;
    p.idx    =i;
%     vi(1,:)={'Tx'   img{1}};
%     vi(2,:)={'AVG'  img{2}};
     
    %% ===============================================
    l{end+1,1}= [ '<font color=blue>' '<h5> ' d.hdr2   '</h5>'  '<font color=black>' ] ;
    
    for j=1:length(im)
        name=['img_'  num2str(p.idx)  '_' num2str(j)  '.jpg' ];
        imgFP=fullfile(p.subpathFP,name);
        imwrite(im{j},imgFP);
        src=[p.subpath '/' name];
        %         la{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' src '" width="' num2str(p.size) '" height="' num2str(p.size) '" /></div>'] ;
        %         la{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' src '" width="' num2str(p.size) '" /></div>'] ;
        l{end+1,1}= ['<style="border:none;><img src="' src '" width="' num2str(p.size) '" /></div>'] ;
        
        
    end
    %% ===============================================

    

    
%    l{end+1,1}='<br><br><br>';% ['<hr>'] ;
    
    
end
%% ===============================================
v={ ['<br><br><br>']
    ['sourceImg: ' p.img ]
    ['targetImg: ' p.ref ]
    [' ']
    ' rotation-table'
    };
v=[v; p.rotlist];
v{end+1,1}=['<br><br><br>'];


    if 1
        ps2=regexprep(v,'#',' ');
        ps3=strjoin(ps2,'<br>');
        l{end+1,1}=['<pre><p style="color:blue;font-family=''Courier New''; font-size:11px;">' ps3   '</p></pre>'];
    end
%% ===============================================


pwrite2file(htmlfile, l);
disp('Done.');

showinfo2('checkRegHtml',htmlfile);

%———————————————————————————————————————————————
%%   add index-file
%———————————————————————————————————————————————

index_title='orientation (pre-alignment)';
index_name ='index_orientation.html';

[filesfp] = spm_select('FPList',outpath,'.*.html');
filesfp=cellstr(filesfp);
filesfp(regexpi2(filesfp,index_name))=[];

s2={'<html><br><br>'};
s2{end+1,1}=[[ '<font color=blue>'  '<h2>' index_title '</h2>'  '<font color=black>' ];];
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

indexfile=fullfile(outpath,index_name);
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





%          l=addimages(htmlfile,subpath,vi,p,l );

function l1=addimages(htmlfile,subpath,im,p,l0 )
sp='&nbsp';
aname =p.title;
siz   =p.size;
idx   =p.idx;
% % gifs=stradd(gifs,[subpath '/'],1);
% gifs=cellfun(@(a){[subpath '/' a ]},gifs);

l={[ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname   '</h5>'  '<font color=black>' ]    ;
    };

%idtag=gifs{2};
%  [~, idtag]=fileparts(gifs{2});


%  bol=[...
%      exist(gifs{1})==2  isempty(strfind(gifs{1},'ERROR:')) ;
%      exist(gifs{2})==2  isempty(strfind(gifs{2},'ERROR:')) ;
%      ]


% gifsFP=cellfun(@(a){[  fileparts(htmlfile)   filesep a   ]},gifs);


%% ___animated gif_____________________________________________________________________________________________

%  if exist(gifsFP{1})==2 && isempty(strfind(gifsFP{1},'ERROR:')) && ...
%          exist(gifsFP{2})==2 && isempty(strfind(gifsFP{2},'ERROR:'))
%      l{end+1,1}= ['<input type="button" value="start animation" onclick="document.getElementById(''' idtag ''').src=''' gifs{3} '''"> '] ;
%      l{end+1,1}= ['<input type="button" value="stop animation"  onclick="document.getElementById(''' idtag ''').src=''' gifs{2} '''"> '] ;
%      l{end+1,1}= ['<input type="button" onclick="zoomimage(1,200,''' idtag ''')" value="-zoom" />'] ;
%      l{end+1,1}= ['<input type="button" onclick="zoomimage(2,200,''' idtag ''')" value="+zoom" />'] ;
%      l{end+1,1}= ['<font size="2"> click image to toggle images</font>'];
%      l{end+1,1}= ['<br>'] ;
%
%      l{end+1,1}= ['<img src="' gifs{2} '" id="' idtag '" width="' num2str(siz) ...
%          '" height="' num2str(siz) '" onclick="changeImage(''' idtag ''',''' gifs{1} ''',''' gifs{2} ''' )" value="Change">'] ;
%  else
%      %l{end+1,1}= ['<pre><font color=red> ' gifs{3} '<font color=black>  </pre>   '] ;
%  end

% ==============================================
%%
% ===============================================

for j=1:size(im,1)
    name=['img_'  num2str(p.idx)  '_' num2str(j)  '.jpg' ];
    imgFP=fullfile(p.subpathFP,name);
    imwrite(im{j,2},imgFP);
    src=[p.subpath '/' name];
    l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' src '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
end


% %% ___statig IMAG1_____________________________________________________________________________________________
%
%  if exist(gifsFP{1})==2 && isempty(strfind(gifsFP{1},'ERROR:'))
%      l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{1} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
%  else
%       if isempty(strfind(gifsFP{1},'ERROR:'))==1
%          col='gray';
%      else
%          col='red';
%      end
%      l{end+1,1}= ['<pre><font color=red> ' gifs{1} '<font color=black>  </pre>   '] ;
%  end
%    %% ___statig IMAG2_____________________________________________________________________________________________
%
%  if exist(gifsFP{2})==2 && isempty(strfind(gifsFP{2},'ERROR:'))
%      l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{2} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
%  else
%      if isempty(strfind(gifsFP{2},'ERROR:'))==1
%          col='gray';
%      else
%          col='red';
%      end
%      l{end+1,1}= ['<pre><font color=' col '> ' gifs{2} '<font color=black>  </pre>   '] ;
%  end
%
% %% ___fused image_____________________________________________________________________________________________
% if length(gifsFP)>3
%     if exist(gifsFP{4})==2 && isempty(strfind(gifsFP{4},'ERROR:'))
%         l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' gifs{4} '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
%     else
%         if isempty(strfind(gifsFP{4},'ERROR:'))==1
%             col='gray';
%         else
%             col='red';
%         end
%         l{end+1,1}= ['<pre><font color=' col '> ' gifs{4} '<font color=black>  </pre>   '] ;
%     end
% end

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
