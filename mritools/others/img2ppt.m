

% function img2ppt(indir,imfiles,pptfile,varargin)
%
%  __PARAMETER_
% indir:   this folder contains the images to include in ppt
% files:   filenames (shortlist) of files to include in ppt  {cell}
%          or use filter here such as '*.tif'
% pptfile: name of the PPTfile
%
%  
% ==============================================
%%   __OPTINAL-PARAMETER_
% ===============================================
% 
% __PPT-file/pags____________________________________
% size    PPT-size: [W H] in cm or use the following string ['p' 'l' 'A4' 'A4l']
%             'p' portait
%             'l', landscape
%             'A4' or 'A4p'  A4-format portrait
%             'A4l' A4-format landscape
% scol    slide:background-color  ; default: [1 1 1]
% 
% __IMAGES___________________________________________
% crop              crop images ; default: [1], {0,1}
% cropTol           crop tolerance: pixels to keep on all sides; default: [20]
% keepcropfiles     keep cropped images..otherwise delete temorary created cropped files again..;
%                   default: [0] ; options: {0,1}
%
% wh         [W H] of image in (cm)
%            example: [nan 3];  scaled using via hight parameter
%                     [1 nan]   scaled using via width parameter
%                     [2   2]    no scaling approved
% xy         [X Y] distance (cm) of upper 1st plot to slide-corner (cm); default: [.5 .5]
% gap        [W H] gap between plots (cm); default: [.5 .5]
% columns    number of columns of images to plot
%            if empty..obtain the optimal number of rows-and-columns
%
% __TEXT___________________________________________
% text    text (-box): 'string' or cell of strings such as {'bla ','bob'};
% txy     text:  XY-position of upper-left-Corner of textbox (cm), if empty position to lower-left corner
% tcol    text: fontColor;   default: [0 0 1];
% tbgcol  text: background-fontColor; default:  [1.0000    0.9686    0.9216];
% tfs     text: fontSize; default: 7;
% tfn     text: fontName such as calibri','consolas', if empty use default PPTX-font
% tfw     text: FontWeight: 'normal' or 'bold'
% tfa     text: FontAngle:  'normal' or italic
% tro     text: Rotation    Determines the orientation of the textbox (degrees)
% tha     text: horizontal alignment; default: 'left', {left,center,right}
% tva     text: horizontal alignment; default: 'top', {top,middle,bottom}
% tlw     text: LineWidth if box (default: 1)  
% tecol   text: EdgeColor, color of the box's edge , default: [1 1 1]
% multitext text: struct for multiple texts -->see examples
% 
% __TITLE___________________________________________
% title   title: 'string' or cell of strings such as {'bla ','bob'};
% Txy     title:  XY-position of upper-left-Corner of textbox (cm), if empty position to lower-left corner
% Tcol    title: fontColor;   default: [0 0 1];
% Tbgcol  title: background-fontColor; default:  [1.0000    0.9686    0.9216];
% Tfs     title: fontSize; default: 7;
% Tfn     title: fontName such as calibri','consolas', if empty use default PPTX-font
% Tfw     title: FontWeight: 'normal' or 'bold'
% Tfa     title: FontAngle:  'normal' or italic
% Tro     title: Rotation    Determines the orientation of the textbox (degrees)
% Tha     title: horizontal alignment; default: 'left', {left,center,right}
% Tva     title: horizontal alignment; default: 'top', {top,middle,bottom}
% Tlw     title: LineWidth if box (default: 1)  
% Tecol   title: EdgeColor, color of the box's edge , default: [1 1 1]
% 
% __EXCELFILE___________________________________________
% XLS     excel: PATH of excelfile: 'string' or cell 
% xsheet  excel: sheetNumber: default: 1
% xxy     excel:  XY-position of upper-left-Corner of textbox (cm), if empty position to lower-left corner
% xcol    excel: fontColor;   default: [0 0 1];
% xbgcol  excel: background-fontColor; default:  [1.0000    0.9686    0.9216];
% xfs     excel: fontSize; default: 7;
% xfn     excel: fontName such as calibri','consolas', if empty use default PPTX-font
% xfw     excel: FontWeight: 'normal' or 'bold'
% xfa     excel: FontAngle:  'normal' or italic
% xro     excel: Rotation    Determines the orientation of the textbox (degrees)
% xha     excel: horizontal alignment; default: 'left', {left,center,right}
% xva     excel: horizontal alignment; default: 'top', {top,middle,bottom}
% xlw     excel: LineWidth if box (default: 1)  
% xecol   excel: EdgeColor, color of the box's edge , default: [1 1 1]
% 
% __FILE___________________________________________
% file    file   PATH of asciifile(.txt,.log etc): 'string' or cell 
% fxy     file:  XY-position of upper-left-Corner of textbox (cm), if empty position to lower-left corner
% fcol    file: fontColor;   default: [0 0 1];
% fbgcol  file: background-fontColor; default:  [1.0000    0.9686    0.9216];
% ffs     file: fontSize; default: 7;
% ffn     file: fontName such as calibri','consolas', if empty use default PPTX-font
% ffw     file: FontWeight: 'normal' or 'bold'
% ffa     file: FontAngle:  'normal' or italic
% fro     file: Rotation    Determines the orientation of the textbox (degrees)
% fha     file: horizontal alignment; default: 'left', {left,center,right}
% fva     file: horizontal alignment; default: 'top', {top,middle,bottom}
% flw     file: LineWidth if box (default: 1)  
% fecol   file: EdgeColor, color of the box's edge , default: [1 1 1]
% multifile file: struct for multiple ascifiles -->see examples
% 
%
% ==============================================
%%   EXAMPLES
% ===============================================
% __________________________________________________________________________________________________
%% *** [ADD IMAGES] ***
%  fi=spm_select('List',pwd,'^s.*.tif'); fi=cellstr(fi); fi=fi(1:end); %SELEFT IMAGES FIRST
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx'),'crop',1);
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx'),'crop',1,'gap',[0 0]);
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx'),'crop',1,'gap',[0 0],'columns',10);
% 
%  __WITH FILE-FILTER___  
%  img2ppt(pwd,'^sub.*.tif', fullfile(pwd,'test2.pptx'),'crop',1,'gap',[0 0],'columns',10);
%  img2ppt(pwd,'^sub.*.tif', [],'crop',1,'gap',[0 0],'columns',3);
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx'),'size','p','xy',[2 2],'wh', [nan 5],'columns',5,'gap',[.7 .7]);
% __________________________________________________________________________________________________
%% *** [ADD TITLE] ***
%  img2ppt([],[], fullfile(pwd,'test2.pptx'),'title','Hallo');
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx') ,'text','blawww','title','HALLO','Tha','right','Tcol',[1 1 1],'Tbgcol',[1 0 0]);
%  img2ppt([],[], fullfile(pwd,'test2.pptx'),'title','analysis','Tfa','italic','Txy',[ 5 0]);
%  ___[two tiles on same page]
%  img2ppt([],[], fullfile(pwd,'test2.pptx'),'title','analysis','Tfa','italic','Txy',[ 0 0]);
%  img2ppt([],[], fullfile(pwd,'test2.pptx'),'doc','same','title','analysis2','Tfa','italic','Txy',[ 0 10]);
% __________________________________________________________________________________________________
%% *** [ADD TEXT] **
%  img2ppt(pwd,[], fullfile(pwd,'test2.pptx') ,'text',{'yesterday','today','tomorrow'},'txy',[1 3]);
% __[TEXT and IMAGES]
%  fi=spm_select('List',pwd,'^s.*.tif'); fi=cellstr(fi); fi=fi(1:end); %SELEFT IMAGES FIRST
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx') ,'text',fi,'txy',[15 0]);
%  img2ppt(pwd,fi, fullfile(pwd,'test2.pptx') ,'text',fi,'txy',[15 0],'tbgcol',[1 1 .2],'tcol',[1 0 0],'tfs',15,'tfn','Consolas');
%% *** [ADD TEXT: MULTIPLE-PAGES] ***
%  fi=spm_select('List',pwd,'^s.*.tif'); fi=cellstr(fi); fi1=fi(1:3);fi2=fi(4:end);
%  img2ppt(pwd,fi1, fullfile(pwd,'test2.pptx') ,'text','bla');
%  img2ppt(pwd,fi2, fullfile(pwd,'test2.pptx') ,'doc','add','text','bla2');
%% *** [ADD  MULTIPLE TEXTS] ***
%  v1=struct('text', 'hallo'     ,'txy', [5 0], 'tcol', [0 0 1],'tha', 'center','tfs',40);
%  v2=struct('text',  (ls) ,'txy', [3 8], 'tcol', [1 0 1], 'tbgcol', [1 .97 0.9], 'tfs', 9,'tfn','');
%  vs={v1 v2};
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx') ,'multitext',vs);
% __________________________________________________________________________________________________
%% *** [ADD EXCEL-FILE] ***
%   img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'xls',fullfile(pwd,'lv.xlsx'))
%   img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'xls',fullfile(pwd,'lv.xlsx'),'xfn','consolas');
%   img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'xls',fullfile(pwd,'lv.xlsx'),'xxy',[0 3 10 20]);
% __________________________________________________________________________________________________
%% *** [ADDING TEXTFILE] ***
%% ___adding a single text-file
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'file',fullfile(pwd,'labels.txt'))
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'file',fullfile(pwd,'labels.txt'),'ffn','Arial','ffs',7,'fxy',[1 5])
%% ___adding multiple text-file
%  f1=fullfile(pwd,'labels.txt');
%  f2=fullfile(pwd,'file2.log');
%  vs={  struct('file',f1,'fxy', [2 5],'ffs',9)    struct('file',f2,'fxy', [2 12]) };
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx') ,'multifile',vs);
%% ___adding multiple text-files ...mith more parameters
%  f1=fullfile(pwd,'labels.txt');
%  f2=fullfile(pwd,'file2.log');
%  v1=struct('file', f1,'fxy', [5 3], 'fcol', [0 0 1],'ffs',12);
%  v2=struct('file', f2,'fxy', [1 15], 'fcol', [1 0 1],'fha', 'center', 'fbgcol', [1 .97 0.9], 'ffs', 9,'ffn','');
%  vs={v1 v2};
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx') ,'multifile',vs);
%% ___adding multiple text-files several pages
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'file',fullfile(pwd,'labels.txt'),'ffn','Arial','ffs',7,'fxy',[2 5])
%  vs={  struct('file',f1,'fxy', [1 2])    struct('file',f2,'fxy', [1 10]) };
%  img2ppt(pwd,[], fullfile(pwd,'test3.pptx'),'doc','add' ,'multifile',vs);
% 
% ======================================================
%%   EXAMPLE: multiple images on several ppt-slides
% =======================================================
% paout =pwd;
% paimg =fullfile(pwd,'barplot_img');
% 
% pptfile =fullfile(paout,'barplot.pptx');
% titlem  =['barplots'  ];
% [fis]   = spm_select('FPList',paimg,'^bar.*.png');    fis=cellstr(fis);
% tx      ={['path: '  paimg ]};
% 
% nimg_per_page  =6;           %number of images per plot
% imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
% for i=1:length(imgIDXpage)-1
%     if i==1; doc='new'; else; doc='add'; end
%     img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
%     img2ppt(paout,img_perslice, pptfile,'size','A4','doc',doc,...
%         'crop',0,'gap',[0 0 ],'columns',2,'xy',[0 1.5 ],'wh',[ 10.5 nan],...
%         'title',titlem,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
%         'text',tx,'tfs',6,'txy',[0 28],'tbgcol',[1 1 1]);
% end
% 



function img2ppt(indir,imfiles,pptfile,varargin)
warning off;
if 0
    fi=spm_select('List',pwd,'^s.*.tif'); fi=cellstr(fi); fi1=fi(1:3);fi2=fi(4:end);
    img2ppt(pwd,fi1, fullfile(pwd,'test2.pptx') ,'text','bla');
    img2ppt(pwd,fi2, fullfile(pwd,'test2.pptx') ,'doc','add','text','bla2');
    
    fi=spm_select('List',pwd,'^s.*.tif'); fi=cellstr(fi); fi1=fi(1);fi2=fi(2);
    img2ppt(pwd,fi1, fullfile(pwd,'test3.pptx') ,'text','bla');
    img2ppt(pwd,fi1, fullfile(pwd,'test3.pptx') ,'doc','same','xy', [0 10]);
    
end

%% ===============================================
p.doc='new';    % {'new' 'add' 'same'};% 'new', new document, 'add', add slide; 'same', add something on same slide
p.crop = 1;     %crop images ; default: [1]
p.cropTol=20;   %crop tolerance: pixels to keep; default: [20]
p.keepcropfiles=0;  %keep cropped images..otherwise delete again..;default: [0]

p.wh=[nan 3];    % [W H] of image in (cm)   scaled using via hight parameter
% or  [1 nan]   -->  [W H] of image in (cm)   scaled using via width parameter
% or  [2 2]     -->  [W H] of image in (cm)  no scaling
p.xy      =[.5 .5]       ;% [X Y] distance (cm) of upper 1st plot to slide-corner (cm)
p.gap     =[.5 .5]       ;% [W H]  gap between plots (cm)
p.columns =[]            ;%number of columns if empty..optain optimal number of rows-x-columns
p.size    =[25.4 19.05]  ;%PPT-slide.size: ppw-format: [W H] in cm or use the following string ['p' 'l' 'A4' 'A4l']
p.scol    =[1 1 1]       ;%slide-color    : default: [1 1 1]
% ________________________________________________________________________________________________
%--TEXT
p.text='';  % text (-box) 'string' or cell of strings such as {'bla ','bob'};
p.txy    =[];  % XY-position of upper-left-Corner of textbox (cm), if empty position to
p.tcol   =[0 0 1];                     %text:fontColor
p.tbgcol =[1.0000    0.9686    0.9216];%text:background-fontColor
p.tfs    =7;      %text:fontSize
p.tfn    ='';     %text:fontName such as calibri','consolas', if empty use default PPTX-font
p.tfw    ='normal';
p.tfa    ='normal';
p.tro    =0;
p.tha    ='left'  ;%text: horizontal alignment, %lower left corner of slide, is empty use lower left corner
p.tva    ='top';
p.tlw    =0;
p.tecol  =[1 1 1];
%------
p.multitext=[];
% ________________________________________________________________________________________________
%--TITLE
p.title='';  % text (-box) 'string' or cell of strings such as {'bla ','bob'};
p.Txy    =[];  % XY-position of upper-left-Corner of textbox (cm), if empty position to
p.Tcol   =[0 0 0];                     %text:fontColor
p.Tbgcol =[0.9608    0.9765    0.9922];%text:background-fontColor
p.Tfs    =20;      %text:fontSize
p.Tfn    ='';     %text:fontName such as calibri','consolas', if empty use default PPTX-font
p.Tfw    ='normal';
p.Tfa    ='normal';
p.Tro    =0;
p.Tha    ='center';
p.Tva    ='top';
p.Tlw    =0;
p.Tecol  =[1 1 1];
% ________________________________________________________________________________________________
%-----file
p.file='';
p.fxy    =[0 2];
p.fcol   =[0 0 0];
p.fbgcol =[1 1 1];
p.ffs    =8;
p.ffn    ='Consolas';
p.ffw    ='normal';
p.ffa    ='normal';
p.fro    =0;
p.fha    ='left';
p.fva    ='top';
p.flw    =0;
p.fecol  =[1 1 1];
%------
p.multifile=[];
% ________________________________________________________________________________________________
%----xlsfile
p.xls='';
p.xsheet=1;
p.xxy    =[0 2];
p.xcol   =[0 0 0];
p.xbgcol =[1 1 1];
p.xfs    =8;
p.xfn    ='';
p.xfw    ='normal';
p.xfa    ='normal';
p.xro    =0;
p.xha    ='left';
p.xva    ='top';
p.xlw    =0;
p.xecol  =[.9 .9 .9];



%% ===============================================

p.info1='__input_constants_';
p.cm2inch =0.393701;

p.imfiles =imfiles;
p.indir   =indir;
p.pptsize=[];
p.info2='____end____';

%% ===============================================

if ~isempty(varargin)
    if length(varargin)==1
        pin=varargin{1}
    else
        pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    end
    p=catstruct(p,pin);
end

%% ===============================================

warning off;
cm2inch=p.cm2inch;


%% =========[size of PPT-slide]======================================
if ischar(p.size)
    if strcmp(lower(p.size),'l') ; p.size=[25.4  19.05]; end %landscape
    if strcmp(lower(p.size),'p') ; p.size=[19.05 25.4 ]; end %portrait
    
    if strcmp(lower(p.size),'a4') || strcmp(lower(p.size),'a4p') ; p.size=[21.0  29.7]; end %A4-portrait
    if strcmp(lower(p.size),'a4l')                               ; p.size=[29.7 21.0];  end %A4-landscape
end
p.pptsize=cm2inch*p.size;

% ==============================================
%%  PPTfile: check, & folder
% ===============================================

pa=indir;
if exist('pptfile')==0 || isempty(pptfile)
    pptfile=fullfile(indir,'test.pptx' );
else
    [pax fix ext]=fileparts(pptfile);
    if isempty(pax); pax=pa; end
    if exist(pax)~=7
        mkdir(pax);
    end
end



%% ===============================================



[pptpa pptfi pptext]=fileparts(pptfile);
if isempty(pptpa); pptpa=pwd; end
pptfile=fullfile(pptpa ,[pptfi '.pptx']);


try; exportToPPTX('close'); end
try; fclose('all'); end

isOpen  = exportToPPTX();
if ~isempty(isOpen)    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end

% pptsize=[11.69 8.27];

% 8.3 x 11.7
if (strcmp(p.doc,'add') && exist([pptfile])) || (strcmp(p.doc,'same') && exist([pptfile]))
    if (strcmp(p.doc,'add') && exist([pptfile]))
        exportToPPTX('open',[pptfile]);
    else
        [ppt_path ppt_name pp_text]=fileparts(pptfile);
        pptTempfile=fullfile(ppt_path , [ 'temp__' ppt_name pp_text]);
        copyfile(pptfile,pptTempfile,'f')
        exportToPPTX('open',[pptTempfile]);
    end
else
    exportToPPTX('new','Dimensions',p.pptsize, ...
        'Title','Example Presentation', ...
        'Author','MatLab', ...
        'Subject','Automatically generated PPTX file', ...
        'Comments','This file has been automatically generated by exportToPPTX');
end
% ==============================================
%%   add slice
% ===============================================
if strcmp(p.doc,'new')==1 || strcmp(p.doc,'add')==1
    slideNum = exportToPPTX('addslide','BackgroundColor',p.scol);
elseif strcmp(p.doc,'same')==1
%    slideNum=exportToPPTX('switchslide',1)
end
%
% % ==============================================
% %%   adds
% % ===============================================


addTexts(p);

insertTitle(p);
insertmultitext(p);

if strcmp(p.doc,'same')==1 && ~isempty(imfiles)
    exportToPPTX('addtext','','Position',[0 0 1 1]);
end

[p]=insertImages(p);


insertXLSfile(p);

insertTXTfile(p);
insertmultiTXTfiles(p);

% ==============================================
%%   add note
% ===============================================
exportToPPTX('addnote',['source: '  p.indir ]);


% ==============================================
%%   save&close PPT
% ===============================================
try
    
    if (strcmp(p.doc,'same') && exist([pptfile]))
         newFile = exportToPPTX('saveandclose',pptTempfile);
          %newFile = exportToPPTX('saveandclose',pptfile);
          try; delete(pptfile); end
        copyfile(pptTempfile,pptfile,'f');
        newFile=pptfile;
         try; delete(pptTempfile); end
        
    else
       newFile = exportToPPTX('saveandclose',pptfile); 
    end
catch
    error('PPT-file is open...please close it')  ;
end

try; exportToPPTX('close'); end
try; fclose('all'); end

% ==============================================
%% show info
% ===============================================
showinfo2('saved: ',newFile);

% ==============================================
%%   delete cropfiles
% ===============================================

if p.keepcropfiles==0 && isfield(p, 'croppedfilesFP' )==1
    for i=1:length(p.croppedfilesFP)
        try; delete(p.croppedfilesFP{i}); end
    end
end


% ==============================================
%%   subs
% ===============================================

function [croppedfiles, croppedfilesFP ]= croppImages(fis,indir,p)
croppedfiles={};
croppedfilesFP={};
for i=1:length(fis)
    %% ===============================================
    if exist(fis{i})==2
         F1=fis{i};
    else
        F1=fullfile(indir,fis{i});
    end
    [a map]=imread(F1);
    si=size(a);
    a2=reshape(a,[prod(si(1:2)) si(3)  ]);
    ar=repmat(squeeze(a(1,1,:))',[size(a2,1) 1 ]);
    d2=(sum(a2==ar,2)==3);
    d=reshape(d2,[si(1:2) ]);
    %         bo=p.cropTol;
    %         d(:,[1:bo end-bo:end])=1;
    %         d([1:bo end-bo:end],:)=1;
    
    xx=mean(d,1)==1;
    xl=[min(find(xx~=1))-p.cropTol  length(xx)-min(find(fliplr(xx)~=1))+p.cropTol  ];
    yy=mean(d',1)==1;
    yl=[min(find(yy~=1))-p.cropTol  length(yy)-min(find(fliplr(yy)~=1))+p.cropTol  ];
    
    
    ac=a;
    try
        ac=a(yl(1):yl(2),xl(1):xl(2) ,:);
    catch
        try
            ac=a(:,xl(1):xl(2) , :            );
        catch
            try
                ac=a(:   ,xl(1):xl(2) ,:);
            end
        end
    end
    %size(ac),size(a)
    
    %% ===============================================
    
    %         ho=any(d==0,1);
    %         xl=[min(find(ho==1)) max(find(ho==1))];
    %         ve=any(d==0,2);
    %         yl=[min(find(ve==1)) max(find(ve==1))];
    
    f=imfinfo(F1);
    [pam name ext]=fileparts(F1);
    croppedName=['cropped_' name ext ];
    F2=fullfile(pam,croppedName);
    if strcmp(f.Format,'tif')
        imwrite(ac, F2, 'Resolution', [f.XResolution f.YResolution]);
    elseif strcmp(f.Format,'jpg')
        imwrite(ac, F2,'Quality',100,'Mode','lossy');
    else
        imwrite(ac, F2);
    end
    
    croppedfiles{end+1,1}    =croppedName;
    croppedfilesFP{end+1,1}  =F2;
end


function [p]=insertImages(p)

%% =========[file-filter/files]======================================
p.isfig=1;
if isempty(p.imfiles)
    p.isfig=0;
    return
else
    if ischar(p.imfiles) && exist(fullfile(p.indir,p.imfiles))==0
        [fis] = spm_select('List',p.indir,p.imfiles);
    else
        fis=p.imfiles;
    end
    fis=cellstr(fis);
    if isempty(char(fis)); disp('no images found'); return; end
end
% ==============================================
%%   crop images
% ===============================================
if p.isfig==1
    if p.crop==1
        [p.croppedfiles, p.croppedfilesFP ]=croppImages(fis,p.indir, p);
        fis=p.croppedfilesFP;
    end
end

% ==============================================
%%   plots
% ===============================================
%% ==[columns: empty optimal number of columns]=====
if isempty(p.columns)
    p.columns=ceil(sqrt(length(fis)));
end
%% ===============================================
% cm2inch= p.cm2inch;
xygap  = p.gap.*p.cm2inch;
ncol   = p.columns;%4;
nimg   = length(fis);
re     = mod(nimg,ncol);
nrow   = ((nimg-re)/ncol)+sum(re>0);
irow   = 1;
cn     = 1;

xy0   = p.xy.*p.cm2inch;
x     = xy0(1); y=xy0(2);

if isempty(p.wh) || length(find(isnan(p.wh)))==2
    p.wh=[nan 7];
end
p.wh=p.wh*p.cm2inch;
for j=1:(nrow)
    for i=1:(ncol)
        if cn<=length(fis)
            a=imread(fis{cn});
            si=[size(a,1) size(a,2)];
            %[H W]
            inan=find(isnan(p.wh));
            if isempty(inan)
                WH=p.wh;%.*cm2inch;
                % px(3:4)=WH;
            elseif length(inan)==2
                p.wh=[nan 2];
                WH=[  si(2)*p.wh(2)/si(1)  p.wh(2)   ];
                % px(3:4)=WH;
            elseif inan==1
                WH=[  si(2)*p.wh(2)/si(1)  p.wh(2)   ];
                %px(3:4)=WH;
                
            elseif inan==2
                WH=[  p.wh(1)  si(1)*p.wh(1)/si(2) ];
                %px(3:4)=WH;
            end
            
            if i==1 && j==1
                px=[ x y   WH];
            end
            if i>1
                px=[ px(1)+(WH(1))+(xygap(1)) px(2)  WH];
                % disp(px);
            end
            if j>1 && i==1
                px(1)=x;
                %px(2)=px(2)+WH(2)-px(4)+xygap(2);
                px(2)=px(2)+WH(2)+xygap(2);
            end
            drawnow;
            %exportToPPTX('addpicture',a,'Position',px);
            exportToPPTX('addpicture',fis{cn},'Position',px);
            
            px2=px;
        end
        cn=cn+1;
    end
    irow=irow+1;
end

% ==============================================
%%   add title
% ===============================================
function [o]=insertTitle(p);
o=addTexts(p,'title');


% ==============================================
%%   add multitext
% ===============================================
function [o]=insertmultitext(p);

for i=1:length(p.multitext)
    p.imulti=i;
    o=addTexts(p,'multitext');
end


% ==============================================
%%   add text
% ===============================================
function [o]=addTexts(p,task);
o=[];
istext=1;
if exist('task')==0
    istext=1;
    v=p;
elseif strcmp(task,'title')
    istext=0;
    v=p;
    v.text  =v.title;
    v.txy   =p.Txy    ;
    v.tcol  =p.Tcol   ;
    v.tbgcol=p.Tbgcol ;
    v.tfs   =p.Tfs    ;
    v.tfn   =p.Tfn    ;
    v.tfw   =p.Tfw    ;
    v.tfa   =p.Tfa    ;
    v.tro   =p.Tro    ;
    v.tha   =p.Tha    ;
    v.tva   =p.Tva    ;
    v.tlw   =p.Tlw    ;
    v.tecol =p.Tecol  ;  
elseif strcmp(task,'multitext')
    v  = p;
    vm = p.multitext{p.imulti};
    v=catstruct(v,vm);   
end

v.text=cellstr(v.text);
msg=strjoin(v.text,char(10));
if isempty(char(msg)); return; end
wh=[max(cell2mat(cellfun(@(a){[ length(a)]}, v.text)))  size(v.text,1) ];
% ===============================================
% text-box obtain-size
% ===============================================
warning off
figure('Visible','off');
hf=gcf;
ht=text(0,0, msg);
% if p.t_fs<10
%     fsadj=3
% else
%     fsadj=p.t_fs*.2
% end
set(ht,'fontsize',v.tfs);
try;set(ht,'fontname',v.tfn); end
set(ht,'units','inches');
tbox=get(ht,'extent');
texWH=tbox(3:4);
texWH(1)=texWH(1)+1;
texWH(2)=texWH(2)+0.2;
delete(hf);
% ===============================================
% add textbox
% ===============================================
pos=v.txy;
if isempty(pos)
    %p.t_pos   =[pptsize(1)-3 pptsize(2)-1 3 0.4  ];
    %p.t_pos   =[pptsize(1)-texWH(1) pptsize(2)-texWH(2) texWH(1)  texWH(2) ]; right-lower side
    if istext==1;
        pos   =[0 v.pptsize(2)-texWH(2) texWH(1)  texWH(2) ];%left lower side
    else
       pos   = [0 0 v.pptsize(1)  texWH(2)  ];
    end
    
else
    tposInch=v.cm2inch*pos;
    if istext==1
        pos   =[tposInch(1) tposInch(2) texWH(1)  texWH(2) ];
    else
        pos   =[tposInch(1) tposInch(2) v.pptsize(1)  texWH(2) ]; %title
    end
    
end




args={...
    'Position'   ,          pos     ,     ...
    'color'      ,          v.tcol  ,     'BackgroundColor'    ,  v.tbgcol, ...
    'FontSize'   ,          v.tfs   ,     ...
    'FontWeight' ,          v.tfw   ,     'FontAngle'          ,  v.tfa,...
    'Rotation'   ,          v.tro   ,     ...
    'HorizontalAlignment',  v.tha   ,     'VerticalAlignment'  ,  v.tva,...
    'LineWidth',            v.tlw   ,     'EdgeColor'          ,  v.tecol...
    };
if ~isempty(v.tfn )
    args=[args, 'FontName', v.tfn ];
end
pargs=args(:);
exportToPPTX('addtext',msg,pargs{:});




% if isempty(v.tfn)
%     exportToPPTX('addtext',msg,'Position',txy ,'Color',v.tcol,'FontWeight','bold',...
%         'BackgroundColor',v.tbgcol,'FontSize',v.tfs,...
%         'HorizontalAlignment',v.tha...
%         );
% else
%     exportToPPTX('addtext',msg,'Position',txy ,'Color',v.tcol,'FontWeight','bold',...
%         'BackgroundColor',v.tbgcol,'FontSize',v.tfs,...
%          'HorizontalAlignment',v.tha,...
%         'FontName',v.tfn);
% end

% ==============================================
%%   xls
% ===============================================
function insertXLSfile(p)
if isempty(p.xls); return; end
%% ===============================================

p.xls=cellstr(p.xls);

[~,~,a]=xlsread(p.xls{1} ,p.xsheet);
%% ===============================================
% exportToPPTX('addtable',a);

% p.xxy    =[0 2];
% p.xcol   =[0 0 0];
% p.xbgcol =[1 1 1];
% p.xfs    =8;
% p.xfn    ='Consolas';
% p.xfw    ='normal';
% p.xfa    ='normal';
% p.xro    =0;
% p.xha    ='left';
% p.xva    ='top';
% p.xlw    =0;
% p.xecol  =[.9 .9 .9];
w=cell2mat(cellfun(@(a){[ length(num2str(a))]}, a));
nchar=max(sum(w,2));

xy=p.xxy*p.cm2inch;
if length(p.xxy)==2
   pos= [xy p.pptsize];
else
    pos=xy;
end


% ===============================================
% wid=round(p.xfs*nchar./[get(0,'ScreenPixelsPerInch')])
% warning off
% figure('Visible','off');
% hf=gcf;
% msg=repmat('.',[length(w), nchar]);
% ht=text(0,0, msg);
% % if p.t_fs<10
% %     fsadj=3
% % else
% %     fsadj=p.t_fs*.2
% % end
% set(ht,'fontsize',p.xfs);
% try;set(ht,'fontname',v.xfn); end
% set(ht,'units','inches');
% tbox=get(ht,'extent');
% texWH=tbox(3:4);
% texWH(1)=texWH(1)+1;
% texWH(2)=texWH(2)+0.2;
% delete(hf);
% ===============================================


% pos=[ xy   wid texWH(1) texWH(2) ]
    
args={'Position',pos,...
    'color'    , p.xcol,     'BackgroundColor'    , p.xbgcol, ...
    'FontSize' , p.xfs,     ...
    'FontWeight' , p.xfw,    'FontAngle',p.xfa,...
    'Rotation' , p.xro,   ...
    'HorizontalAlignment',p.xha, 'VerticalAlignment',p.xva,...
    'LineWidth',p.xlw,           'EdgeColor',p.xecol...
    };
if ~isempty(p.xfn )
    args=[args, 'FontName',p.xfn ];
end
pargs=args(:);
exportToPPTX('addtable',a,pargs{:});
    
%  'Position', p.xy, 'Color', p.xcol,...
     %     'BackgroundColor', p.xbgcol,...

%     
%                Position    Four element vector: x, y, width, height (in
%                             inches) or template placeholder ID or name.
%                             Coordinates x=0, y=0 are in the upper left corner 
%                             of the slide.
%                 Color       Three element vector specifying RGB value in the
%                             range from 0 to 1. Default text color is black.
%                 BackgroundColor         Three element vector specifying RGB
%                             value in the range from 0 to 1. By default 
%                             background is transparent.
%                 FontSize    Specifies the font size to use for text.
%                             Default font size is 12.
%                 FontName    Specifies font name to be used. Default is
%                             whatever is template defined font is.
%                             Specifying FixedWidth for font name will use
%                             monospaced font defined on the system.
%                 FontWeight  Weight of text characters:
%                             normal - use regular font (default)
%                             bold - use bold font
%                 FontAngle   Character slant:
%                             normal - no character slant (default)
%                             italic - use slanted font
%                 Rotation    Determines the orientation of the textbox. 
%                             Specify values of rotation in degrees (positive 
%                             angles cause counterclockwise rotation).
%                 HorizontalAlignment     Horizontal alignment of text:
%                             left - left-aligned text (default)
%                             center - centered text
%                             right - right-aligned text
%                 VerticalAlignment       Vertical alignment of text:
%                             top - top-aligned text (default)
%                             middle - align to the middle of the textbox
%                             bottom - bottom-aligned text
%                 LineWidth   Width of the textbox's edge line, a single
%                             value (in points). Edge is not drawn by 
%                             default. Unless either LineWidth or EdgeColor 
%                             are specified. 
%                 EdgeColor   Color of the textbox's edge, a three element
%                             vector specifying RGB value. Edge is not drawn
%                             by default. Unless either LineWidth or
%                             EdgeColor are specified. 
%     
%     


% ==============================================
%%   xls
% ===============================================
function insertTXTfile(p)
if isempty(char(p.file)); return; end
%% ===============================================
p.file=cellstr(p.file);

if exist(p.file{1})==2
    addText_fromFiles(p);   
end




% ==============================================
%%   add text from files
% %-----file
% p.file='';
% p.fxy    =[0 2];
% p.fcol   =[0 0 0];
% p.fbgcol =[1 1 1];
% p.ffs    =8;
% p.ffn    ='Consolas';
% p.ffw    ='normal';
% p.ffa    ='normal';
% p.fro    =0;
% p.fha    ='left';
% p.fva    ='top';
% p.flw    =0;
% p.fecol  =[.9 .9 .9];
% p.multifile=[];

% ==============================================
%%   add multitext
% ===============================================
function [o]=insertmultiTXTfiles(p);

for i=1:length(p.multifile)
    p.imultifile=i;
    o=addText_fromFiles(p,'multifile');
end



% ===============================================
function [o]=addText_fromFiles(p,task);
o=[];
istext=1;
if exist('task')==0
    istext=1;
    v=p;
    F1=fullfile(p.file{1});
    a=preadfile(F1); 
    filecontent=a.all;
    
elseif strcmp(task,'multifile')
    v  = p;
    vm = p.multifile{p.imultifile};
    v=catstruct(v,vm);
    
    F1=v.file;
    a=preadfile(F1);
    filecontent=a.all;
    
end


filecontent=cellstr(filecontent);
msg=strjoin(filecontent,char(10));
wh=[max(cell2mat(cellfun(@(a){[ length(a)]}, filecontent)))  size(filecontent,1) ];



% ===============================================
% text-box obtain-size
% ===============================================
warning off
figure('Visible','off');
hf=gcf;
ht=text(0,0, msg);
set(ht,'fontsize',v.ffs);
try;set(ht,'fontname',v.ffn); end
set(ht,'units','inches');
tbox=get(ht,'extent');
texWH=tbox(3:4);
texWH(1)=texWH(1)+1;
texWH(2)=texWH(2)+0.3;
delete(hf);
% ===============================================
% add textbox
% ===============================================
pos=v.fxy;
if isempty(pos)
    if istext==1;
        pos   =[0 v.pptsize(2)-texWH(2) texWH(1)  texWH(2) ];%left lower side
    else
       pos   = [0 0 v.pptsize(1)  texWH(2)  ];
    end
else
    tposInch=v.cm2inch*pos;
    pos   =[tposInch(1) tposInch(2) texWH(1)  texWH(2) ];
end


args={...
    'Position'   ,          pos     ,     ...
    'color'      ,          v.fcol  ,     'BackgroundColor'    ,  v.fbgcol, ...
    'FontSize'   ,          v.ffs   ,     ...
    'FontWeight' ,          v.ffw   ,     'FontAngle'          ,  v.ffa,...
    'Rotation'   ,          v.fro   ,     ...
    'HorizontalAlignment',  v.fha   ,     'VerticalAlignment'  ,  v.fva,...
    'LineWidth',            v.flw   ,     'EdgeColor'          ,  v.fecol...
    };
if ~isempty(v.ffn )
    args=[args, 'FontName', v.ffn ];
end
pargs=args(:);
exportToPPTX('addtext',msg,pargs{:});

