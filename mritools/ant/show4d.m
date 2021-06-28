%% #wg  SHOW 4D VOLUME / check quality of 4D-realignemnt
% FUNCTION DISPLAYS ONE OR TWO 4d-VOLUMES
% #r If two volumes are selected it is assumed that the number of slices/dimensions and volumes are identical
% #r This function allows to visualize the realignment of 4D-data. You can select the un-realigned (input)
% #r and realigned (after realignment) 4D-files, which will be displayed side-by-side.
% Additionally the 1st volume is overlayed as contour plot on the selective volume to obtain the quality
% of realignment/registration within the 4D-volume
% 
% ==============================================
% #wg   GUI     + Order of Processing                
% ==============================================
%  #b Blue color instructions denote the short form instruction
% 
% #b [animal listbox]:displayes the animals (i.e. subdirs of a directoy)
%      you can add other directorys (main of specif directories) via [dir>>]-button
% #b [file listbox]  :displayes the files of a currnetly selected animal
%      -select  a 4D file here...
% #b [-->]: select 1st-file-Buttonn: if the 4D file is selected in the file-listbox, hit this button.
%       The filename appears in the right edit box
% [-->]: select 2nd-file-Buttonn: Optional. Select a 2nd 4D file from the file-listbox. It is assumed that
%       this file is the realigned version of the first selected 4D volume 
%       The filename appears in the right edit box
% [x]   clear 1st-file/2nd-file  edit field  
% 
% [dim]: choose dimension here (1,2,3)...coronar view is prefered
% [slice]: choose slice to display
%          -'mid': referes to the middle slice of the respective dimension
% [show contour]  radio: shows the contour plot of the 1st volume overlayed over the respective volume
%              This allows to check the data quality of the realignment/coregistration of the 4D-volume
%              
% #b [update]  : Hit update to visualize the data.
% 
% [volume-slider]: -(located below images) allows to select the specific volume 
%                  -use left/right arrow keyboard keys (if slider is focused) to move through the volumes
%               
% [volume-edit]: -(located below images) shows the current volume number
%                -edit a number here to visualize this volume
% 
% ==============================================
% #wg   COMMANDLINE                      
% ==============================================
%% #g animal-folder is current PWD
% show4d;                               
% #b PRESELECT folder
%% #g use MAIN-folder, 4D-files of subfolders can be accessed
% show4d('F:\data4\realign_4Ddata\dat');
%% #g USE SPEICIFC-folder containing 4D-data
% show4d('F:\data4\realign_4Ddata\dat\20200716SA_G1_D7'
% #b PRESELECT FILES
% show4d('F:\data4\realign_4Ddata\dat',{'short.nii'})
%% #g open with main folder, preselect 2 4D-files (short.nii and the realigned version 'rshort.nii') 
% show4d('F:\data4\realign_4Ddata\dat',{'short.nii' ,'rshort.nii'}); 
%% #g open specific folder, preselect 2 4D-files (short.nii and the realigned version 'rshort.nii') 
% show4d('F:\data4\realign_4Ddata\dat\20200716SA_G1_D7',{'short.nii' ,'rshort.nii'})
% 
% 
% 

function show4d(pam,file)

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————
% pam='F:\data4\realign_4Ddata\dat';
% pam='';

if exist('pam')~=1 || isempty(pam)
    pam=pwd;
end



[dirs] = spm_select('fpList',pam,'dir','.*');
if isempty(dirs)
    dirs=cellstr(pam);
else
    dirs=cellstr(dirs);
end

u.filepreselection0={'imageFile1,undefined' 'imageFile2 (optional),undefined'};

if exist('file')~=1 || isempty(file)
    % u.filepreselection={'imageFile1,undefined' 'imageFile2 (optional),undefined'};
    u.filepreselection={'dwi_unregistered16.nii' 'rdwi_unregistered.nii'};
    % u.filepreselection={'short.nii' 'rshort.nii'};
    u.filepreselection={'short.nii' ''};
    % u.filepreselection={'AVGT.nii' ''};
    u.filepreselection={'' ''};
    u.filepreselection={'imageFile1,undefined' 'imageFile2 (optional),undefined'};
else
    if ischar(file)==1
        file=cellstr(file);
    end
    if length(file)==1
        file{2}='';
    end
    
    u.filepreselection=file;
end

% u.filepreselection
% return
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————

u.dirs=dirs;



u.dim            =1; %starting dim
u.showcontour    =1; %show countiour of 1st volume
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————
makefig(u);


hf=findobj('tag','show4d');
set(hf,'userdata',u);
defpath();
% getdimsize();
%  update([],[],1);
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————

function selectDir(e,e2)
hf=findobj('tag','show4d');
u=get(hf,'userdata');
pam=uigetdir(pwd,'select main directory here');
if isnumeric(pam);return; end

[dirs] = spm_select('fpList',pam,'dir','.*');
if isempty(dirs)
    dirs=cellstr(pam);
else
    dirs=cellstr(dirs);
end


if isempty(char(u.dirs))
    u.dirs=dirs;
else
   u.dirs= unique([ u.dirs ;dirs],'stable');
end
set(hf,'userdata',u);

% hb=findobj(gcf, 'tag','lbanimal');
% if isempty(char(hb.String))
%     hb.String=dirs;
% else
%    hb.String= unique([ hb.String ;dirs],'stable')
% end



defpath();




function updatefull()
hf=findobj('tag','show4d');
hb=findobj(hf, 'tag','dim');
dim=hb.Value;

hb=findobj(hf, 'tag','lbanimal');

he1=findobj(hf, 'tag','edimg1');
he2=findobj(hf, 'tag','edimg2');

pa=hb.String{hb.Value};
name1=he1.String;
name2=he2.String;

f1=fullfile(pa,name1);
f2=fullfile(pa,name2);

if exist(f1)==2 && exist(f2)==2   %two PLOTS
    n=2;
    h1=spm_vol(f1);
else
    n=1;
    if exist(f1)~=2 && exist(f2)~=2 %both missing
        n=0;
%         msgbox('no file found');
        return
    elseif exist(f2)==2
        h1=spm_vol(f2);
    elseif exist(f1)==2
        h1=spm_vol(f1);
    end   
end

vo=h1(1);
sl=1:min(vo.dim);


hs=findobj(hf, 'tag','slice');
slic=cellfun(@(a){[  num2str(a)  ]}, num2cell(sl));
slic=[ 'mid' slic];
set(hs,'string',slic);

u=get(hf,'userdata');
u.nvol=length(h1);
set(hf,'userdata',u);


hv=findobj(hf, 'tag','volnr');
hsl=findobj(hf, 'tag','slider');


currvol=str2num(get(hv,'string'));

set(hsl,'min',1);
set(hsl,'max',u.nvol);
if currvol<=u.nvol && currvol>=1  %keep volume
    set(hsl,'value',currvol);
else % set to 1st volume
    set(hsl,'value',1);
    set(hv,'string','1');
end


if u.nvol==1
   set(hsl,'visible','off'); 
else
    set(hsl,'visible','on'); 
   try; set(hsl, 'SliderStep', [1/(u.nvol-1) , 1/(u.nvol-1) ]);end
end





function getdimsize(e,e2)

% hf=findobj('tag','show4d');
% hb=findobj(hf, 'tag','dim');
% dim=hb.Value;
% 
% hb=findobj(hf, 'tag','lbanimal');
% 
% he1=findobj(hf, 'tag','edimg1');
% he2=findobj(hf, 'tag','edimg2');
% 
% pa=hb.String{hb.Value};
% name1=he1.String;
% name2=he2.String;
% 
% f1=fullfile(pa,name1);
% f2=fullfile(pa,name2);
% 
% if exist(f1)==2 && exist(f2)==2   %two PLOTS
%     n=2;
%     h1=spm_vol(f1);
% else
%     n=1;
%     if exist(f1)~=2 && exist(f2)~=2 %both missing
%         n=0;
%         msgbox('no file found');
%         return
%     elseif exist(f2)==2
%         h1=spm_vol(f2);
%     elseif exist(f1)==2
%         h1=spm_vol(f1);
%     end   
% end
% 
% vo=h1(1);
% sl=1:min(vo.dim);
% 
% 
% hs=findobj(hf, 'tag','slice');
% slic=cellfun(@(a){[  num2str(a)  ]}, num2cell(sl));
% slic=[ 'mid' slic];
% set(hs,'string',slic);
% 
% u=get(hf,'userdata');
% u.nvol=length(h1);
% set(hf,'userdata',u);
% 
% 
% 
% hsl=findobj(hf, 'tag','slider');
% set(hsl,'value',1);
% set(hsl,'min',1);
% set(hsl,'max',u.nvol);
% if u.nvol==1
%    set(hsl,'visible','off'); 
% else
%     set(hsl,'visible','on'); 
%    try; set(hsl, 'SliderStep', [1/(u.nvol-1) , 1/(u.nvol-1) ]);end
% end
% hv=findobj(hf, 'tag','volnr');
% set(hv,'string','1');
updatefull();
update();

% ==============================================
%%   
% ===============================================

function update(e,e2,vol)
updatefull();
hf=findobj('tag','show4d');
if exist('vol')==1 && vol==0
   clear vol; 
end
if exist('vol')~=1
    vol=str2num(get(findobj(hf, 'tag','volnr'),'string'));
end

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————

hb=findobj(hf, 'tag','lbanimal');

he1=findobj(hf, 'tag','edimg1');
he2=findobj(hf, 'tag','edimg2');

pa=hb.String{hb.Value};
name1=he1.String;
name2=he2.String;

f1=fullfile(pa,name1);
f2=fullfile(pa,name2);
if exist(f1)==2 && exist(f2)==2   %two PLOTS
    n=2;
else
    n=1;
    if exist(f1)~=2 && exist(f2)~=2 %both missing
        n=0;
        msgbox('no file found');
        return
    elseif exist(f2)==2
        f1=f2;
%         disp(['file not found: '  (f1)]);
    elseif exist(f1)==2
%         disp(['file not found: '  (f2)]);
    end   
end





%———————————————————————————————————————————————
%%   axis
%———————————————————————————————————————————————
u=get(hf,'userdata');

H1=spm_vol(f1);
[~,Name1,ext]=fileparts(f1);
if n==2
    H2=spm_vol(f2);
    [~,Name2,ext]=fileparts(f2);
end

if n==2
    if isempty(findobj(hf, 'tag','ax1'))
        ha1=axes('Position',[0 .03 .5 .64]);
        set(ha1,'tag','ax1');
    end
    if isempty(findobj(hf, 'tag','ax2'))
        ha2=axes('Position',[.5 .03 .5 .64]);
        set(ha2,'tag','ax2');
    end
end

if n==1
    resize=0;
    if ~isempty(findobj(hf, 'tag','ax2'))
        delete(findobj(hf, 'tag','ax2'));
        resize=1;
    end
    if isempty(findobj(hf, 'tag','ax1'))
        ha1=axes('Position',[0 .03 .5 .64]);
        set(ha1,'tag','ax1');
    else
        if resize==1
            %            set(findobj(hf, 'tag','ax1'),'position', [.3 0 .5 .65]) ;
        end
        
    end
    
%     title([Name1 '.nii'],'interpreter','none','fontsize',7);
end
    

%———————————————————————————————————————————————
%%   get data
%———————————————————————————————————————————————

hr=findobj(hf, 'tag','showcontour');   showcontour  = get(hr,'value');
hd=findobj(hf, 'tag','dim');           dim          = hd.Value;
hs=findobj(hf, 'tag','slice');         slice        = hs.String{hs.Value};
if strcmp(slice,'mid')
  slice=round(str2num(hs.String{end})/2);
else
   slice=str2num(slice); 
end


% [~,Name1,ext]=fileparts(f1);
if showcontour==1
    [o1 ]=getslices({f1},dim,[slice],[],0, 1 );
end

if n==2
%     [~,Name2,ext]=fileparts(f2);
    if showcontour==1
        [o1 ]=getslices({f1},dim,[slice],[],0, 1 );
        [r1 ]=getslices({f2},dim,[slice],[],0, 1 );
    end
end

%% ________________________________________________________________________________________________

% ==============================================
%%   to struct
% ===============================================


u.inf1='---update---';
u.n=n;
if showcontour==1
    u.o1=single(o1);
end
u.Name1=Name1;
u.f1   =f1;
u.H1   =H1;

if n==2
    if showcontour==1
        u.r1=single(r1);
    end
    u.Name2=Name2;
    u.f2=f2;
    u.H2= H2; %spm_vol(u.f2);
end
u.showcontour=showcontour;
u.pa   =pa;
u.slice=slice;
u.dim  =dim;

set(hf,'userdata',u);
% 'a'
showvol(vol);



function slidchangeVol(e,e2)
vol=round(get(e,'value'));

hf=findobj('tag','show4d');
he=findobj(hf, 'tag','volnr');
set(he,'string',num2str(vol));

% update([],[],vol);
showvol(vol);

function editchangevol(e,e2)
vol=str2num(get(e,'string'));
hs=findobj(gcf, 'tag','slider');
set(hs,'value',vol);

% update([],[],vol);
showvol(vol);


function showvol(vol)
hf=findobj('tag','show4d');
u=get(hf,'userdata');

%———————————————————————————————————————————————
%%   get data
%———————————————————————————————————————————————
if vol>u.nvol
   vol=u.nvol;      set(findobj(hf, 'tag','volnr'),'string',u.nvol);
   set(findobj(hf, 'tag','slider'),'value',u.nvol);
elseif vol<1
    vol=1;      set(findobj(hf, 'tag','volnr'),'string','1');
    set(findobj(hf, 'tag','slider'),'value',1);
end
if u.n==2
    try
    [o ]=getslices({u.f1},u.dim,[u.slice],[],0, vol );
    catch
     [o ]=getslices({u.f1},u.dim,[u.slice],[],0, 1 );
    end
     
    try
    [r ]=getslices({u.f2},u.dim,[u.slice],[],0, vol );
    catch
      [r ]=getslices({u.f2},u.dim,[u.slice],[],0, 1 );   
    end
else
    [o  os1]=getslices({u.f1},u.dim,[u.slice],[],0, vol );
end


ax1=findobj(hf, 'tag','ax1');
axes(ax1);
imagesc(o);
axis off;
set(gca,'tag','ax1');
if u.showcontour==1
    hold on;
    contour(u.o1,3,'r');
end
hold off;
dimstr1=sprintf('[%dx%dx%dx%d]',[u.H1(1).dim  length(u.H1)]);
 title([u.Name1 '.nii' dimstr1],'interpreter','none','fontsize',7);

if u.n==2
    ax2=findobj(hf, 'tag','ax2');
    axes(ax2);
    imagesc(r);
    axis off;
    set(gca,'tag','ax2');
    if u.showcontour==1
        hold on;
        contour(u.r1,3,'r');
    end
    hold off;
    dimstr2=sprintf('[%dx%dx%dx%d]',[u.H1(1).dim  length(u.H1)]);
    title([u.Name2 '.nii' dimstr2],'interpreter','none','fontsize',7);  
end
% toc
drawnow;

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————


function defpath(e,e2)
hf=findobj('tag','show4d');
u=get(hf,'userdata');
hb=findobj(hf, 'tag','lbanimal');
set(hb,'string',u.dirs);

casenum=get(hb,'value');
thisdir=u.dirs{casenum,1};

[files] = spm_select('List',thisdir,'.*.nii');
files=cellstr(files);

hb2=findobj(hf, 'tag','lbfile');

fis=get(hb2,'string');
va=get(hb2,'value');
if isempty(fis)
    idx=1;
else
   oldfile=fis{va};  
   idx=min(find(strcmp(files,oldfile)));
end


if isempty(idx)
    set(hb2,'value',1);
else
    set(hb2,'value',idx); 
end

set(hb2,'string',files);


function setimg(e,e2, imgtype)
% imgtype
hf=findobj('tag','show4d');
hb2=findobj(hf, 'tag','lbfile');
li=get(hb2,'string');
va=get(hb2,'value');

name=li{va};
if imgtype==1
    he=findobj(hf, 'tag','edimg1');
    set(he,'foregroundcolor','k');
else
    he=findobj(hf, 'tag','edimg2');
    set(he,'foregroundcolor','k');
end
set(he,'string',name);


function delimg(e,e2, imgtype)
% imgtype
hf=findobj('tag','show4d');
u=get(hf,'userdata');

if imgtype==1
    he=findobj(hf, 'tag','edimg1');
    set(he,'foregroundcolor','r');

    set(he,'string',u.filepreselection{1});
    ax1=findobj(hf, 'tag','ax1');
    axes(ax1); cla; title('');
else
    he=findobj(hf, 'tag','edimg2');
    set(he,'foregroundcolor','r');
    set(he,'string',u.filepreselection{2});
    ax2=findobj(hf, 'tag','ax2');
    axes(ax2); cla; title('');
end






function xhelp(e,e2)
uhelp([mfilename '.m']);


function makefig(u)
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————

delete(findobj('tag','show4d'));
figure;
set(gcf,'color','w','units','norm', 'tag', 'show4d','NumberTitle','off','name', [ '4d-Viewer [' mfilename ']' ]);
set(gcf,'menubar','none');
hf=findobj('tag','show4d');

% animals
hb=uicontrol('style','listbox','units','norm','tag','lbanimal');
set(hb,'position',[0 .7 .3 .3]);
set(hb,'callback',@defpath);
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> ANIMAL <br></b> select animal here<br>then select a file from the FILES-Listbox </html>');


% files
hb=uicontrol('style','listbox','units','norm','tag','lbfile');
set(hb,'position',[0.3 .7 .3 .3]);
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> ANIMAL-FILES <br></b> select files<br>use arrow-button to visualize the selected file </html>');


%% first image -------------
hb=uicontrol('style','pushbutton','units','norm','tag','pbimg1','string','<html>&#8594;' );
set(hb,'position',[0.6 .9 .05 .04]);
set(hb,'callback',{@setimg,1});
set(hb,'tooltipstring',...
   [ '<html><b><FONT color="red"> SELECT-1st-FILE <br></b> First select a file from ANIMAL-FILES listbox.<br>' ...
   ' Hit this button to visualize this 4D-file--> The File appears in the right edit-box. </html>']);

%edit file name
hb=uicontrol('style','edit','units','norm','tag','edimg1','string',u.filepreselection{1} );
set(hb,'position',[0.65 .9 .34 .04],'HorizontalAlignment','left');
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> 1st File to display <br></b> This file will be visualized. </html>');

if strcmp(u.filepreselection0{1},u.filepreselection{1})==0
    set(hb,'foregroundcolor','b');
else
   set(hb,'foregroundcolor','r');
end
    


% delete
hb=uicontrol('style','pushbutton','units','norm','tag','pbimg1del','string','<html>&#x2715;' );
set(hb,'position',[0.975 .9 .02 .04]);
set(hb,'callback',{@delimg,1});
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> clear 1st-File edit-box <br></b> This file will be removed from visualization </html>');



%% 2nd image --------------
hb=uicontrol('style','pushbutton','units','norm','tag','pbimg2','string','<html>&#8594;' );
set(hb,'position',[0.6 .85 .05 .04]);
set(hb,'callback',{@setimg,2});
set(hb,'tooltipstring',...
   [ '<html><b><FONT color="red"> SELECT-2nd-FILE <br></b> First select a file from ANIMAL-FILES listbox.<br>' ...
   ' Hit this button to visualize this 4D-file--> The File appears in the right edit-box.<br>'...
   '<FONT color="red">A 2nd file can be chosen to visualize pre-post realignment, i.e. two 4D files<br>'...
   'can be displayd next to each other</html>']);


%edit file name
hb=uicontrol('style','edit','units','norm','tag','edimg2','string',u.filepreselection{2} );
set(hb,'position',[0.65 .85 .34 .04],'HorizontalAlignment','left');
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> 2nd File to display <br></b> This file will be visualized next to the 1st file. </html>');
if strcmp(u.filepreselection0{2},u.filepreselection{2})==0
    set(hb,'foregroundcolor','b');
else
   set(hb,'foregroundcolor','r');
end
    
% delete
hb=uicontrol('style','pushbutton','units','norm','tag','pbimg2del','string','<html>&#x2715;' );
set(hb,'position',[0.975 .85 .02 .04]);
set(hb,'callback',{@delimg,2});
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> clear 2nd-File edit-box <br></b> This file will be removed from visualization </html>');


%% update -------------
hb=uicontrol('style','pushbutton','units','norm','tag','update','string','update' );
set(hb,'position',[0.75 .7 .1 .04],'backgroundcolor',[ 1.0000    0.8431         0]);
set(hb,'callback',{@update,0});
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> UPDATE/REFRESH VISUALIZATION <br></b> Use this button if path/filename(s) and parameter have been changed </html>');

%% HELP -------------
hb=uicontrol('style','pushbutton','units','norm','tag','help','string','help' );
set(hb,'position',[0.92143 0.95833 0.075 0.04]);
set(hb,'callback',@xhelp);
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> SOME HELP <br></b> ...</html>');



%% dim
hb=uicontrol('style','popupmenu','units','norm','tag','dim','string',{'dim1' 'dim2' 'dim3'} );
set(hb,'position',[0.61 .75 .1 .04],'backgroundcolor','w');
set(hb,'value',u.dim);
set(hb,'callback',@getdimsize);
set(hb,'tooltipstring',...
    '<html><b><FONT color="red"> IMAGE-DIMENSION<br></b> changed IMAGE dimension </html>');


%% slice
hb=uicontrol('style','popupmenu','units','norm','tag','slice','string',{'mid'} );
set(hb,'position',[0.71 .75 .1 .04],'backgroundcolor','w');
set(hb,'value',1);
set(hb,'callback',@getdimsize);
set(hb,'tooltipstring',...
   [ '<html><b><FONT color="red"> SELECT SLICE TO DISPLAY  <br></b>'...
   ' First select the prefered dimension (such as coronal view...dimension: 1,2 or 3).<br>' ...
   ' Than select the slice.<br>'...
    '"mid": refers to the middle slice of the selected dimension <br>'...
   '']);

%%showcontour
hb=uicontrol('style','radio','units','norm','tag','showcontour','string','show contour' );
set(hb,'position',[0.61 .70 .13 .04],'backgroundcolor','w','fontsize',7);
set(hb,'value',u.showcontour);
set(hb,'callback',@getdimsize);
set(hb,'tooltipstring',...
  [  '<html><b><FONT color="red"> SHOW CONTOUR<br></b>'...
    'IF [X] the contour of the 1st volume is overlayed on top of the respective IMAGE-volume<br>'...
    '<FONT color="red">The contour might help to visualize the realignment/coregistration quality of volumes<br>'...
    'in a 4D-volume</html>']);


%% ________________________________________________________________________________________________


%% slider
hb=uicontrol('style','slider','units','norm','tag','slider','string','volume' );
set(hb,'position',[0.1 .0 .5 .03]);
set(hb,'value',1,'SliderStep',[.1 .1]);
 set(hb,'callback',@slidchangeVol);
 set(hb,'tooltipstring',[...
    '<html><b><FONT color="red"> 4D-VOLUME-SLIDER<br></b> changed volume in a 4D-volume here<br>'...
    'If the slider is active (in focus) use left/right arrow-Keys to change the volume. </html>']);

 %% volnum
hb=uicontrol('style','edit','units','norm','tag','volnr','string','1' );
set(hb,'position',[0.6 .0 .05 .03]);
set(hb,'callback',@editchangevol);
 set(hb,'tooltipstring',[...
    '<html><b><FONT color="red"> CURRENT VOLUME displayed<br></b> The edit field shows the currently displayed volume number.<br>'...
    'You can change the volume using the slider or edit a number in this field. </html>']);

%% ________________________________________________________________________________________________
%specific folder
hb=uicontrol('style','pushbutton','units','norm','tag','dir','string','dir>>' );
set(hb,'position',[0.61 0.95833 0.07 0.04]);
set(hb,'callback',@selectDir);
set(hb,'tooltipstring',...
    ['<html><b><FONT color="red"> SELECT MAIN OR SPECIFIC DIRECTORY <br></b> ...'...
     'OPTIONS: <br>'...
    '1) select a MAIN-directory here: The animal-listbox will display the subdirs of the selected directory<br>'...
    '2) alternatively, select a SPECIFIC directory here: The animal-listbox will display this directory<br>'...
    ' ..the selected dir/or subdirs will be appended in the animal-listbox<br>'...
    ' ..directory selection can be done several times <br>'...
    '</html>']);












