
%% xoverlay/display 3d/4D VOLUMES
% 
% #yg GUI-NOTE
% some parameters have an #r "interactive selector" #w (the selector appears as icon on the very left side of a parameter)
% to use the "interactive selector": move the coursor to the line of the parameter, an interactive selector icon appears it
% it appears. Click the icon or press [f1]-key and follow the instructions
% 
% #yg HOWTO
% this function opens two windows: % [1] a file window  and [2] a parameter window
% -the file window shows all NIFTI-files from the selected mousefolders of the [ANT]-gui
%  #r thus, only those files will be seen and can be displayed from the preelected mouse-folders
% -additionally the NIFTI-files from the "templates"-folders are shown and can be used
%  #k first select one or two (for overlays) files from the a file window 
%  #k than go to the parameter-window, select #r [x.images] #k , and click on the left interactive icon to import the filenames
%  #r [img1_no] & [img2_no]  #k for 4dim data of background-file (and foreground-file in case of ocerlays) select the respective volume (refers to the 4th. dimension) 
%  #r [x.imswap]  #k swap foreground and background image
% ____optional_________
%  #r [x.slice]  #k define slice or slices to display, (example: 'center' or [5:10] or [5] ...) --> see pulldown 
%  #r [x.cmap]   #k define colormap, see help colormap
%  #r [x.alpha]  #k define transparancy of overlays, rang 0-1, default: 0.5
%  #r [x.nsb]    #k define number of subplots, (''  : best match, 'r' or ('row') to let mice appear rowwise  (for multi-slice display)
%  #r [x.cut]    #k define image cropping (left,r,u,d) --> 4 values in percent [down up left right ], e.g. to view only the upper-right quadrant [.5 0 .5 0] -->this cuts 50% down and 50% left, default [0 0 0 0]
%  #r [x.clim1]  #k define colorlimits of image-1 ,2 values within [0-1],  brighterIMG [0 .5], darkerIMG [0.5 1]
%  #r [x.clim2]  #k define colorlimits of image-2 ,2 values within [0-1]
%  #r [x.fontsize]  #k define fontsize for labels (slice-mm from bregma, file&path-names)

% 
%% BATCH: no batch-mode available

function xoverlay(showgui,x)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end


pa=antcb('getsubjects');
pa2=[ {fullfile(fileparts(fileparts(pa{1})),'templates')}];
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
fi2={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
end
li1=unique(fi2);
 
fi2={};
for i=1:length(pa2)
    [files,~] = spm_select('FPList',pa2{i},['.*.nii$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa2{i} filesep],'');
    fi2=[fi2; fis];
end
li2=unique(fi2);
li2=stradd(li2,[pa2{i} filesep],1);

li=[li2;li1];

selector2(li,{'nifti-images'},'iswait',0,'out','col-1','position',[    0.0149    0.1000    0.2500    0.8600]);





%———————————————————————————————————————————————
%%   help for parametergui
%———————————————————————————————————————————————

      hh={};
       hh{end+1,1}=( ' #yk ***  SHOW IMAGE/IMAGEOVERLAY  ***' );
       hh{end+1,1}=(' §b [images] §k select ONE or TWO images (the 2nd image will be overlayed onto 1st image)');
       hh{end+1,1}=('             use left icon to import selected image(s) from §r "Selector"  §k (left window) ');
       hh{end+1,1}=('            -->for this: first, select one or two images in the §r "Selector"  §k window   ');
       hh{end+1,1}=('              than, move coursor to  the lineNumber of §r "x.images" §k in the §r "Parameters" §k window   ');
       hh{end+1,1}=('              if so, an import-icon appears on the left side of  §r "x.images" §k in the §r "Parameters" §k window   ');
       hh{end+1,1}=('            click §r icon §k to import selected image(s)  from §r "Selector"  §k');

       hh{end+1,1}=('      ');
       hh{end+1,1}=(' §b [img1_no/img2_no] §k this refers to the image number, if nifti has 4-Dims , default: 1');
       hh{end+1,1}=(' §b [imswap]  §k    flips foreground/background image' );
       hh{end+1,1}=(' §b [slice]  §k  slice(s) to plot ' );
       hh{end+1,1}=('   §g examples:    [100] §k  display 100th. slice ' );
       hh{end+1,1}=('   §g        [100:5:120] §k  display every 5th. slice between 100 and 120 ' );
       hh{end+1,1}=('   §g        ''center'' §k     display center slice ' );
       hh{end+1,1}=('   §g        inf §k          display all slices ' );
       hh{end+1,1}=('   §g        ''each2'' §k      display each 2nd slice ' );
       hh{end+1,1}=('   §g        ''eachX'' §k      display each Xth slice, Xmust be a number' );
       hh{end+1,1}=('   §g        ''each3 10 20''  §k  display each 3rd slice, start with 10th slice to the end-20th. slice' );
       hh{end+1,1}=('                           these 3 values can be changed     ');

       hh{end+1,1}=('   §b cmap  §k colormap -->see colormap; §g example:   ''jet'' ,''hsv'' ' );
       hh{end+1,1}=('   §b alpha §k alpha , image-fusion alphaBlending factor, range [0 1] ' );
       hh{end+1,1}=('   §b nsb §k number of subplots [Nrows Ncolumns]' );
       hh{end+1,1}=('   §g examples:  [2 3] §k    !! if exact number of pannels is known !! , here: 2rows & 3columns ' );
       hh{end+1,1}=('   §g            [4 nan] §k  4 rows and N-necessary columns (which is calculated)   ' );
       hh{end+1,1}=('   §g           [nan 5] §k   N-necessary rows (calculated on the fly) and 5 columns ' );
       hh{end+1,1}=('   §g           []  §k       optimal number of rows and columns (calculated on the fly)' );
       hh{end+1,1}=('   §g           ''row'' or ''r''  §k   number of rows matches numbr of mice, ..each case is a row ' );
       hh{end+1,1}=('   §b cut §k cut image borders - 4 values, percent of the image size [bootom top left right ] to cut/crop');
       hh{end+1,1}=('   §g examples:  [.5 0 .5 0] §k   to view only the upper-right quadrant ');
       hh{end+1,1}=('                 -->this cuts/removes  50% of the image from bottom  and from left (cut)' );
       hh{end+1,1}=('   §b clim1/clim2 §k colorlimis of img1/img2, 2values within [0-1]range');
       hh{end+1,1}=('                 default is [] each' );
       hh{end+1,1}=('   §b fontsize §k  fontsize for label/coordinates');




       
%        uhelp(hh,1,'position',[ 0.7378    0.7633    0.2601    0.130])  ; 
%        drawnow;


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
showgui=1;


if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• SHOW IMAGE/IMAGEOVERLAY   •••             '                         '' ''
    'inf100'      [repmat('—',[1,100])]                            '' ''
    %
    'images'       {''}          'select ONE or TWO images (the 2nd image will be overlayed onto 1st image)'  {@selector2,'getid'}
    'img1_no'      1             'volumeNr img1 (if vol has 4dims) '    ''
    'img2_no'      1             'volumeNr img2 (if vol has 4dims) '    ''

    'imswap'       0             'flip BG/FG'                                   'b'
    'slice'        'center'           'slice(s) to display, .i.e [5:10] or [5] or see pulldown '    {inf 'center'  'each2' 'each3' 'each4' 'each2 5 5'  'each3 10 10' }

    'cmap'         'jet'         'colormap'     {'jet' 'parula' 'vga'  'hsv' 'hot' 'gray' 'bone' 'copper' 'pink' 'white' 'flag' 'lines' 'colorcube' 'cool' 'prism' 'autumn' 'spring' 'winter'   'summer'   }'
    'alpha'        0.5           ''       num2cell([0:.1:1])
    'nsb'        ''           'number of subplots, ([]) best match, (''r'') or (''row'') subjects appear rowwise  '      {'','r' '[2 nan]'} 
    'cut'          [0 0 0 0]     'cut image borders - 4 values in percent [down up left right ], e.g. to view only the upper-right quadrant [.5 0 .5 0] -->this cuts 50% down and 50% left'      {'0 0 0 0';'.1 .1 .1 .1'; '.2 .2 .2 .2';'.2 .2 0 0' ;'0 0 2 2'}
    'clim1'       ''            'colorlimits img-1 ,2 values within [0-1],  brighterIMG [0 .5], darkerIMG [0.5 1]' ''
    'clim2'       ''            'colorlimits img-2' ''
    'fontsize'     7             'fontsize for label/coordinates'                 num2cell([2:14])
    };


% s.fontsize  =z.fontsize;
% s.imgno     =z.imgno;
% s.rimgno    =z.rimgno;

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[ 0.2674    0.6578    0.3524    0.3017],...
        'title','OVERLAY','info',hh);
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

%% change button and callback
pb1=findobj(gcf,'tag','pb1');
set(pb1,'string','PLOT','callback',{@plotcb,z});


%% make SELECTOR-buttons+uis invisible
hsel=findobj(0,'tag','selector');

try;set(findobj(hsel,'tag','pb1'),'visible','off');end
try;set(findobj(hsel,'tag','pb2'),'visible','off');end
try;set(findobj(hsel,'tag','pb3'),'visible','off');end
try;set(findobj(hsel,'tag','pop'),'visible','off');end
try;set(findobj(hsel,'tag','cbox1'),'visible','off');end


%———————————————————————————————————————————————
%%   callback
%———————————————————————————————————————————————
function plotcb(h,e,z)

[sa z]=paramgui('getdata');

s.file      =  z.images{1};
s.rfile     = [];
if length(z.images)>1
  s.rfile     =    z.images{2};
end
 
s.imswap    =z.imswap;
% s.doresize  =z.doresize;  
s.slice     =z.slice;  
s.cmap      =z.cmap;  
s.alpha     =z.alpha;  
s.nsb       =z.nsb;  
s.cut       =z.cut; 

s.fontsize  =z.fontsize;
s.imgno     =z.img1_no;
s.rimgno    =z.img2_no;

s.clim1    =z.clim1;
s.clim2    =z.clim2;


fun1(s);

% assignin('base','s',s)
% warp_summary2(s);
% 
%         file: 'x_t2.nii'
%        rfile: 'O:\data\karina\templates\ANOpcol.nii'
%       imswap: 1
%     doresize: '1'
%        slice: 100
%         cmap: ''
%        alpha: 0.5000
%          nsb: []
%          cut: [0 0 0 0]




function fun1(s)
if 0
    
    s.rimgno=3;
    s.imgno=1;
       s.rfile= 'MSME-T2-map_20slices_1.nii'
      s.file='2_T2_ax_mousebrain_1.nii'
      s.imswap= 0
    s.doresize= 1
       s.slice= 10:12
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= 'r'
         s.cut= [0 0 0 0] 
     fun1(s);

     
       s.rimgno=1;
       s.imgno=1;
       s.file={'O:\data\karina\templates\AVGT.nii'}
       s.rfile= 'x_t2.nii'
      s.imswap= 0
    s.doresize= 1
       s.slice= 100
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= ''
         s.cut= [0 0 0 0] 
     fun1(s);

     
      s.rimgno=1;
       s.imgno=1;
       s.file= 'x_t2.nii'
      s.rfile={'O:\data\karina\templates\AVGT.nii'}
      s.imswap= 0
    s.doresize= 1
       s.slice= 100:102
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= ''
         s.cut= [0 0 0 0] 
     fun1(s);

     
      s.rimgno=1;
       s.imgno=1;
       s.file= 'x_t2.nii'
       s.rfile= ''
      s.imswap= 1
    s.doresize= 1
       s.slice= [100:105 120 150]
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= 'row'
         s.cut= [0 0 0 0] 
     fun1(s);

      s.rimgno=1;
       s.imgno=1;
       s.file= 'O:\data\karina\templates\AVGT.nii'
       s.rfile= 'O:\data\karina\templates\ANOpcol.nii'
      s.imswap= 0
    s.doresize= 1
       s.slice= 30:40
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= ''
         s.cut= [0 0 0 0] 
     fun1(s);

      s.rimgno=1;
       s.imgno=1;
        s.file= ''
       s.rfile= 'O:\data\karina\templates\ANOpcol.nii'
      s.imswap= 0
    s.doresize= 1
       s.slice= 100
        s.cmap= 'jet'
       s.alpha= 0.5000
         s.nsb= ''
         s.cut= [0 0 0 0] 
     fun1(s); 
end

% input
%        file: 'O:\data\karina\templates\AVGT.nii'
%        rfile: 'x_t2.nii'
%       imswap: 0
%     doresize: 1
%        slice: 100
%         cmap: 'jet'
%        alpha: 0.5000
%          nsb: ''
%          cut: [0 0 0 0]

if s.imswap==1
    dum  =s.file;
    s.file =s.rfile;
    s.rfile=dum;
end


s=getpath(s);
 [x s]=f_reslice(s);
 [x s]=make3d(s,x);
 [x s]=cut(s,x);
 

 
 
%  assignin('base','x',x);
%  assignin('base','s',s);
% add.nsb=[];
add.title=x.af;
add.cord=x.mm2;
add.nsb=s.nsb;
add.fontsize=s.fontsize;
 

 if isempty(x.b)
     imoverlay2(x.a,[],s.clim1,[],s.cmap,s.alpha,'',add);;
 else
     add.title2=x.bf;
     imoverlay2(x.a,x.b,  s.clim2 , s.clim1  ,s.cmap,s.alpha,'',add);;
 end



 if 0
    x.images=   { 'O:\data\karina\templates\ANOpcol.nii' 	% select ONE or TWO images (the 2nd image will be overlayed onto 1st image)
              'O:\data\karina\templates\AVGT.nii' }; 
 end


%  imoverlay2(ri,rf,[],[],s.cmap,s.alpha,'',add);; 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function [x s]=cut(s,x)
%cut percent
if ~isempty(s.cut)
    if length(s.cut)==4
        ri=x.a;
        si=size(ri);
        cut=[round(si(1)*s.cut(2))  round(si(1)*s.cut(1))       round(si(2)*s.cut(3))  round(si(2)*s.cut(4)) ];
        ri=ri(1+cut(1):end-cut(2),1+cut(3):end-cut(4),:);
        x.a=ri;
        if isempty(x.b)==0
            ri=x.b;
            ri=ri(1+cut(1):end-cut(2),1+cut(3):end-cut(4),:);
            x.b=ri;
        end
        
        
    else
        
    end
end


function [x s]=make3d(s,x)

nsubj=size(x.a,4);
%names
% dum=repmat(x.af, [1 size(x.a,3)] )';
dum={};
for i=1:size(x.af,1)
    [pa fi   ext]=fileparts(x.af{i});
    [pa2 fi2 ext2]=fileparts(pa);
    dum{i,1}=fullfile(fi2,[fi ext]);
end
dum=[dum repmat({''}, [size(x.a,4) size(x.a,3)-1 ] ) ]';
dum=dum(:) ;
x.af=dum;
if isempty(x.b)==0
    dum={};
    for i=1:size(x.bf,1)
        [pa fi   ext]=fileparts(x.bf{i});
        [pa2 fi2 ext2]=fileparts(pa);
        dum{i,1}=fullfile(fi2,[fi ext]);
    end
    dum=[dum repmat({''}, [size(x.a,4) size(x.a,3)-1 ] ) ]';
    dum=dum(:) ;
    x.bf=dum;
end

%% data
si=size(x.a);
if length(si)==2; si(3:4)=1; end
if length(si)==3; si(4)=1; end
% x.a=reshape(permute(x.a,[1 2 4 3]),[si(1:2) prod(si(3:4))]);
x.a=reshape((x.a),[si(1:2) prod(si(3:4))]);

if isempty(x.b)==0
%     x.b=reshape(permute(x.b,[1 2 4 3]),[si(1:2) prod(si(3:4))]);
    x.b=reshape((x.b),[si(1:2) prod(si(3:4))]);

end

%% mm
mm2=[];
for i=1:size(x.mm2,2);
  mm2=[mm2; x.mm2{i}];
end
% x.mm2=mm2;
x.mm2=cellfun(@(a) { sprintf('%02.3f',a)  }, num2cell(mm2) );

%% nsb
if ischar(s.nsb)
    if strcmp(s.nsb,'row')  || strcmp(s.nsb,'r')
        s.nsb=[nsubj nan ];
    end
end

 %% cmap
 if ischar(s.cmap)
     eval(['s.cmap=' s.cmap ';' ]);
 end


function [x s]=f_reslice(s)

% p1='O:\data\karina\dat\s20160613_RosaHDNestin_eml_08_1_x_x\2_T2_ax_mousebrain_1.nii'
% p2='O:\data\karina\dat\s20160613_RosaHDNestin_eml_08_1_x_x\MSME-T2-map_20slices_1.nii,1'
% if isempty(s.file); s.file=s.rfile;s.rfile=[] ;end



% clc
% disp(char(s.file));
% disp('-')
% disp(char(s.rfile));
% return



for i=1:size(s.file,1)
    
    p1name=s.file{i};
    p1 =[s.file{i} ,    [',' num2str(s.imgno)]];
    if isempty(s.rfile)==0
        p2name=s.rfile{i};
        p2=[s.rfile{i} ,[',' num2str(s.rimgno)]];
    end
    
    % p1='O:\data\karina\dat\s20160613_RosaHDNestin_eml_08_1_x_x\AVGT.nii'
    % p2='O:\data\karina\dat\s20160613_RosaHDNestin_eml_08_1_x_x\x_t2.nii,1'
    if isempty(s.rfile)==0
        [hb,b ]=rreslice2target(p2, p1, [], 1);
    end
    
    [ha a]=rgetnii(p1);
    [bb vx] = world_bb(p1);
    %% allen space
    if    ha.dim(3)>100
        a=rot90(permute(a,[1 3 2]));
        if isempty(s.rfile)==0
            b=rot90(permute(b,[1 3 2]));
        end
        mm=single(linspace(bb(1,2),bb(2,2),size(a,3)))';%2nd dim in bbwolrd
    else %% native space
        a=rot90(a);
        if isempty(s.rfile)==0
            b=rot90(b);
        end
        mm=single(linspace(bb(1,3),bb(2,3),size(a,3)))';
    end
    
    a=single(a);
    if isempty(s.rfile)==0
        b=single(b);
    else
        b=[];
    end
    
    %% extract slice
    if ischar(s.slice)
        if strcmp(s.slice,'center')
           s.slice=round(size(a,3)/2);
        elseif strfind(s.slice,'each')
            sep=str2num(strrep(s.slice,'each',''));
            if length(sep)==1
                s.slice=1:sep:size(a,3);
            else
                if length(sep)==2; sep(3)=0; end
                s.slice=sep(2):sep(1):size(a,3)-sep(3);
            end
        end
    else
        if isinf(s.slice);
            s.slice=[1:size(a,3)];
        end
    end
    
    
    a2=a(:,:,s.slice);
    if isempty(s.rfile)==0
        b2=b(:,:,s.slice);
    end
    mm2=mm(s.slice);
    
    %% put2struct
%     clear z
    x.a(:,:,:,i)=a2;
    x.mm2{i}=mm2;
    x.af{i,1}    =p1name;
    if isempty(s.rfile)==0
        x.b(:,:,:,i)=b2;
        x.bf{i,1}    =p2name;
    else
        x.b=[];
        x.bf    =[];
    end
    
end




function s=getpath(s)
pa=antcb('getsubjects');
%% file
if ~isempty(s.file)
    
    if ischar(s.file);
        s.file=cellstr(s.file);
    end
    [pax fix ex]=fileparts(s.file{1});
    if isempty(pax)
        s.file= stradd(pa,[filesep [fix ex]],2) ;
    end
end
%% rfile
if ~isempty(s.rfile)
    if ischar(s.rfile);
        s.rfile=cellstr(s.rfile);
    end
    [pax fix ex]=fileparts(s.rfile{1});
    if isempty(pax)
        s.rfile= stradd(pa,[filesep [fix ex]],2) ;
    end
end

%fill up file & rfile
if isempty(s.file)==0  && isempty(s.rfile)==0
    if size(s.file,1)<size(s.rfile,1)
        s.file=repmat(s.file,[size(s.rfile,1) 1]);
    end
     if size(s.file,1)>size(s.rfile,1)
        s.rfile=repmat(s.rfile,[size(s.file,1) 1]);
    end
end


%%check
exi1=ones(size(s.file,1),1);
for i=1:size(s.file,1)
    if exist(s.file{i})~=2;
        exi1(i)=0;
    end
end
%     s.file=s.file(exi==1);


%%check
exi2=ones(size(s.rfile,1),1);
for i=1:size(s.rfile,1)
    if exist(s.rfile{i})~=2;
        exi2(i)=0;
    end
end
%     s.rfile=s.rfile(exi==1);

if isempty(s.file)==0  && isempty(s.rfile)==0
   ival=find(exi1+exi2==2);
    s.file =s.file(ival);
    s.rfile=s.rfile(ival);
    
elseif isempty(s.file)==0  && isempty(s.rfile)==1
     s.file=s.file(exi1==1);
elseif isempty(s.file)==1  && isempty(s.rfile)==0
     s.rfile=s.rfile(exi2==1);
    
end



if isempty(s.file); 

    dum =s.file;
    dum2=s.imgno;
    
    s.file=s.rfile;
    s.imgno=s.rimgno; 
    
    s.rfile  =dum;
    s.rimgno =dum2;
%     s.file=s.rfile;s.rfile=[] 
end

































