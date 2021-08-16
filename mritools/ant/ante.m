%% internal function

function fh=ante
fh.msub=@msub;
fh.madd=@madd;
fh.bbb     =@bbb;
fh.getsubjects     =@getsubjects;
fh.filematrix     =@filematrix;

fh.brukerimport     =@brukerimport;
fh.info='type strucname.function(inf) for help';
% disp('type strucname.function(inf) for help');

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function r=msub(a,b)
r=a-b;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function r=madd(a,b)
r=a+b;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function [e f g]=bbb(a,b)
e=11;
f=12;
g=13;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function [subjects]=brukerimport(in)
try;
    antcb('status',1,'import Bruker data');
    
    
    if exist('in') && isinf(in)
        disp('*** import brukerData ***');
        disp('-->see [xbruker2nifti.m]')
        return
    end
    
    global an;
    % xbruker2nifti( 'O:\harms1\harmsTest_ANT\pvraw', 'Rare' )  %METAFOLDER is explicitly defined, read Rare, trmb is 1Mb
    % xbruker2nifti({'guidir' 'O:\harms1\harmsTest_ANT\'}, 'Rare' ) %startfolder for GUI is defined,  read Rare, trmb is 1Mb
    if isfield(an,'brukerpath') ;
        xbruker2nifti( an.brukerpath, 'Rare' ) ;
        %fun={@xbruker2nifti , an.brukerpath, 'Rare'   };
        %  feval(fun{1},fun{2:end})
    else
        xbruker2nifti({'guidir' [fileparts(an.datpath) filesep]} ,0)
        %xbruker2nifti( {'guidir' fileparts(an.datpath)}  , 'Rare' ) ;
        %   fun={@xbruker2nifti ,{'guidir' fileparts(an.datpath)}, 'Rare'   };
    end
    antcb('update'); %update subjects
catch
    antcb('status',0);
end
antcb('status',0);
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function [subjects]=getsubjects(in)
try;
    if isinf(in)
        disp('get selected subjects');
        return
    end
end
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');
va=get(lb3,'value');
subjects=an.mdirs(va);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function [out]=filematrix(in)
warning off;
try
    if isinf(in)
        disp('plot the cases-file matrix, no inputs');
        disp('example:  r=ante;      r.filematrix();')
        return
    end
end
%% do
global an
out=[];

allsubjects=0;

if allsubjects==1
    pas=an.mdirs;
    files     =spm_select('FPListRec',an.datpath,'.*.nii'); files=cellstr(files);
else
    pas=antcb('getsubjects') ;
    files={};
    for i=1:length(pas)
        fdum     =spm_select('FPListRec',pas{i},'.*.nii'); fdum=cellstr(fdum);
        files=[files;fdum];
    end
end


filesuni=unique(regexprep(files,['.*' '\' filesep],''));
%sort oddEven
nf1=1:ceil(length(filesuni)/2);
nf2=ceil(length(filesuni)/2)+1:length(filesuni);
filedum=repmat({''}, [length(filesuni) 1]);
filedum(1:2:length(nf1)*2)=filesuni(nf1);
filedum(2:2:length(nf2)*2)=filesuni(nf2);
filesuni=filedum;
% tic
%  ma=[];
% for i=1: length(pas)
%       for j=1:length(filesuni)
%           b=regexpi2(files  ,  strrep(fullfile(pas{i},filesuni{j}) ,[filesep],[filesep filesep])  );
%           if ~isempty(b)
%            ma(j,i)=1;
%           end
%       end
% end
% toc
%
% tic
ma=[];
for i=1: length(pas)
    for j=1:length(filesuni)
        if exist(fullfile(pas{i},filesuni{j}))==2
            ma(j,i)=1;
        end
    end
end
% delete files from list
idel=find(sum(ma,2)==0); % not directly in mdir-folder
filesuni(idel)=[];
ma(idel,:)=[];


%plot
col=[    1.0000         0         0
    0         0    1.0000
    0.2314    0.4431    0.3373
    0.6000    0.2000         0
    %          0    1.0000         0
    1.0000         0    1.0000
    1.0000    0.6941    0.3922
    %     0.7020    0.7804    1.0000
    0    0.7490    0.7490
    0.7490         0    0.7490];


%% alphabetsort
[dum iw]=sort(lower(filesuni));
filesuni=filesuni(iw);
ma      =ma(iw,:);


remn=mod(size(ma,1),size(col,1));
colmat=[repmat(col, (size(ma,1)-remn)/size(col,1) ,1);  col(1:remn,:) ];
colmat2=permute(repmat(colmat,[1 1 size(ma,2)]),  [1 3 2]);
ma2=repmat(ma,[1 1 3]).*colmat2;
bg=repmat(ma==0,[1 1 3]);


fg;
set(gcf,'tag','casefilematrix');
image(ma2+bg);
for i=1:size(ma,2)-1;     vline(i+.5,'color','k');      end
for i=1:size(ma,1)-1;    hline(i+.5,'color','k');       end

ht=[];
for i=1:  1: size(ma2,1)
    ht(end+1) =text(0.5,i, [ filesuni{i} '  '] ,'color',  colmat2(i,1,:)  ,  'tag','files');
end
set(ht,'HorizontalAlignment','right');
set(ht,'fontsize',7,'interpreter','none');

% ht2=[];
% for i=2:  2: size(ma2,1)
%     ht2(end+1) =text(size(ma,2)+.5 ,i,['  ' filesuni{i}],'color',  colmat2(i,1,:)  ,  'tag','files');
% end
% set(ht2,'HorizontalAlignment','left');
%
% set([ht  ht2],'interpreter','none');
set(gca,'ytick',[]);
% cases=regexprep(pas,['.*'  '\' filesep ''],'');
[~,cases]=fileparts2(pas);
set(gca,'xtick',[1: size(ma,2)], 'xticklabels',strrep(cases,'_',''),'fontweight','bold');

try;
%     xticklabel_rotate([],55,strrep(cases,'_',''),'HorizontalAlignment','right','fontsize',6);
   hx= xticklabel_rotate([],55,cases,'HorizontalAlignment','right','fontsize',6);
   for i=2:2:length(hx)
      set(hx(i),'color',[0 0 1]) ;
   end
   set(hx(i),'fonweight','bold') ;
 
catch
    try
        set(gca,'xTickLabelRotation',55);
    end
end
set(findobj(gca,'type','text'),'interpreter','none');

% set(gca,'position',[0.15 .19 .845 .77])
set(gca,'position',[0.25 .19 .745 .77]);

drawnow;


% %set sideDOTdirection to read FILE
% hold on;
% for j=1: size(ma2,2)%right
%     for i=1: size(ma2,1)
%         if mod(i,2)==1
%             plot(j-0.5+.03,i,'<g','markerfacecolor','w','markeredgecolor','k','markersize',3);
%         else
%             plot(j+.5-.03,i,'>g','markerfacecolor','w','markeredgecolor','k', 'markersize',3);
%         end
%     end
% end

set(gcf,'units','norm','menubar','none','position',[0.0017    0.0689    0.5424    0.8989]);

set(gca,'units','norm');%,'position',[0.1 .13 .7 .83]);
set(gcf,'WindowButtonMotionFcn',{@matrixmotion, ma, filesuni,cases});
% set(gcf,'position',[0 0 1 1]);
set(gcf,'WindowButtonDownFcn',{@matrixbuttondown, ma, filesuni,cases});
set(gcf,'KeyPressFcn',@keys);

%ELEMENTS
hp=uicontrol('Style', 'pushbutton',     'String', 'resize' , ...
    'units','normalized',   'tag','pbresize');
set(findobj(gcf,'tag','pbresize'),'position',[.0 .98 .05 .02],'fontsize',10,...
    'callback',@resize);

hp=uicontrol('Style', 'radiobutton',     'String', 'BG-flip' ,...
    'units','normalized' ,    'tag','rbflipBG');
set(findobj(gcf,'tag','rbflipBG'),'position',[.05 .98 .05 .02],'fontsize',10,'userdata',0,'value',0);

hp=uicontrol('Style', 'popup',     'String', 't2.nii|AVGT.nii|ANOpcol.nii|w_t2.nii|x_t2.nii|none','units','normalized' ,   'Position', [.1 .9 .1 .05],...
    'tag','popbackground');
set(hp,'position',[.1 .9 .2 .1],'fontsize',12,'tooltipstring','select background image')   ;

%% shwoImageHeader
hp=uicontrol('Style', 'radiobutton',     'String', 'show ImageHeader','units','normalized' ,   'Position', [.3 .98 .15 .02],...
    'tag','showimageheader');
set(hp,'fontsize',6,'tooltipstring','shows the imageheader')   ;

%% HELP
hp=uicontrol('Style', 'pushbutton',     'String', 'help','units','normalized' ,   'Position', [.45 .98 .06 .02],...
    'tag','help_filematrix','callback' , @help_filematrix);
set(hp,'fontsize',12,'tooltipstring','help')   ;

%% replot
hp=uicontrol('Style', 'pushbutton',     'String', 'replot','units','normalized' ,   'Position', [0.9379 0.97958 0.06 0.02],...
    'tag','replot_filematrix','callback' , @replot_filematrix);
set(hp,'fontsize',10,'tooltipstring','replot case-file-matrix')   ;


%% SELECT FOLDERS/FILES
hp=uicontrol('Style', 'radiobutton',     'String', 'select File/Folders','units','normalized' ,   'Position', [.6 .98 .15 .02],...
    'tag','selectobject','callback' , @getfolder);
set(hp,'fontsize',6,'tooltipstring','select files/folders for subsequent jobs')   ;

taskselection={
    'select these folders in ANT-mouse-folder-listbox'
    'copy <unique>          folders to clipboard'
    'copy <unique> fullpath folders to clipboard'
    'copy <unique>          files   to clipboard'
    'copy          fullpath files   to clipboard'
    'copy <unique>          folders to clipboard #MATLAB-CELLSTYLE'
    'copy <unique> fullpath folders to clipboard #MATLAB-CELLSTYLE'
    'copy <unique>          files   to clipboard #MATLAB-CELLSTYLE'
    'copy          fullpath files   to clipboard #MATLAB-CELLSTYLE'
    '------------'
    'tabulate values (Me, SD, Min, Max, counts (n==0; n==1))'
    'header information'
    '------------'
    'make image copy (copy+rename image(s) ..stored in local folder) '
    'export files (export selected files; keep folder structure)'
    '------------'
    'delete image  (this will delete the selected images)'
    } ;
hp=uicontrol('Style', 'popupmenu',    'units','normalized' , 'Position', [.75 .98 .1 .02],...
    'tag','select','callback' , @foldertask,...
    'String', taskselection );
set(hp,'fontsize',7,'tooltipstring','perform this jobs for selected files or folders')   ;


% set(findobj(gcf,'tag','pbresize'),'units','points');
%=============================================================
%% fontsize
if get(0,'ScreenPixelsPerInch')<100
    try
        iniparas=antini;
        fs=iniparas.fontsize;
    catch
        fs=8;
    end
    %     set(findobj(gcf,'type','text'),           'fontsize',fs-2);
    set(findobj(gcf,'style','pushbutton'),    'fontsize',fs-2);
    set(findobj(gcf,'tag','popbackground'),   'fontsize',fs-1);
    set(findobj(gcf,'style','radiobutton'),    'fontsize',fs-2);
end

set(findobj(gcf,'tag','pbresize'),'units','norm');
set(findobj(gcf,'tag','popbackground'),'units','norm','fontunits','norm');
set(findobj(gcf,'style','radiobutton'),'units','norm','fontunits','norm');
% set(gcf,'position',[0.0653    0.1311    0.4576    0.6544]);

% set(gcf,'menubar','none','position',[0.0017    0.0689    0.5424    0.8989]);
% set(gcf,'position',[0.0021    0.0689    0.5365    0.8989]);
% drawnow;
% set(gcf,'position',[0.0017    0.0689    0.5424    0.8989]);

%-------------------------- USERDATA
u.cases    =cases;
u.filesuni =filesuni;
u.pas      =pas;
set(gcf,'userdata',u);
%--------------------------

casefile_exportfiles();
drawnow;
% label=repmat({'ee'},[100 1])
% set(datacursormode(gcf), 'DisplayStyle','datatip', 'SnapToDataVertex','off','Enable','on', 'UpdateFcn',{@showlabel,label});

function replot_filematrix(e,e2)
delete(findobj(0,'tag','casefilematrix'));
r=ante;
r.filematrix();

function keys(he,e)
% e
if isempty(e.Modifier)
    if strcmp(e.Character,'+') || strcmp(e.Character,'-')
        fontstep=1;
        if strcmp(e.Character,'-');
            fontstep=-1;
        end
        ht=findobj(gcf,'type','text');
        nFS=get(ht(1),'fontsize')+fontstep;
        if nFS>0
            set(ht,'fontsize',nFS);
        end
    end
elseif ~isempty(strfind(e.Modifier,'control'))
    if strcmp(e.Key,'rightarrow') || strcmp(e.Character,'leftarrow')
        rotstep=1;
        if strcmp(e.Key,'leftarrow');
            rotstep=-1;
        end
        ht=findobj(gcf,'type','text','-and','UserData','xtick');
        nROT=get(ht(1),'Rotation')+rotstep;
       % if nFS>0
            set(ht,'Rotation',nROT);
        %end
    end
    
end

function casefile_exportfiles

pos=get(gca,'position');
set(gca,'tag','ax1');
ax1=findobj(gcf,'tag','ax1');
%% ====================
% ax2=axes('position',[0 0 .001 .001],'tag','seletfile')
pos2=pos; pos2(1)=0; pos2(3)=.025;
% set(ax2,'position',pos2);
%
%
% yl=get(ax1,'ylim'); yl=[floor(yl(1))  ceil(yl(2))]
% set(ax2,'ylim',yl,'box','on')
% axes(ax2)
% hv=hline([1: round(max(yl))],'color','k','hittest','off')

%% ====================
him=findobj(ax1,'type','Image');
dd=get(him,'cdata');
% axes(ax2)
% him2=image(dd(:,1,:))

tx=findobj(ax1,'type','text','-and','tag','files');
txpos=cell2mat(get(tx,'position'));

%% ====================
% hc=uicontrol('style','radio','units','normalized','tag','rbselect')
%% ==================== set rb.buttons
delete(findobj(gcf,'tag','rbselect'));
% set(ax2,'ydir','reverse')
% ucstep=(pos2(4)-pos2(2))/(size(tx,1))+.0045
ucstep=pos2(4)/size(tx,1); 
rbhigh2=ucstep; %used for files-RB
for i=1:size(tx,1)
    hc=uicontrol('style','radio','units','normalized','tag','rbselect');
    set(hc,'position',[pos2(1)   pos2(2)+i*ucstep-ucstep  pos2(3) ucstep]);
    set(hc,'tooltipstring', get(tx(i),'string') ,'fontsize',2 );
%     col=squeeze(dd(end+1-i,1,:));
    col=get(tx(i),'Color');
    set(hc,'BackgroundColor',col);
%      if sum(col)==3; set(hc,'visible','off'); end
    set(hc,'userdata',get(tx(i),'string'));
end
% ==================== select all files button
i=-1;
delete(findobj(gcf,'tag','rbselectall'));
hc=uicontrol('style','radio','units','normalized','tag','rbselectall');
set(hc,'position',[pos2(1)   pos2(2)+i*ucstep-ucstep  pos2(3)*2 ucstep]);
set(hc,'tooltipstring', 'select all files' ,'fontsize',6,'string','all files' );
col=[1.0000    0.8431         0];
set(hc,'BackgroundColor',col);
set(hc,'userdata','allselect');
set(hc,'callback',@selectallfiles);
set(hc,'userdata',0)
% ==================== export button
i=-3;
delete(findobj(gcf,'tag','pbexport'));
hc=uicontrol('style','pushbutton','units','normalized','tag','pbexport');
set(hc,'position',[pos2(1)   pos2(2)+i*ucstep-ucstep  pos2(3)*3 ucstep*1.5]);
set(hc,'tooltipstring', 'export files' ,'fontsize',7,'string','export');
set(hc,'callback',@exportfiles);
%% ====================  
%% file-selection
%% ====================  
ax1=findobj(gcf,'tag','ax1');
u=get(gcf,'userdata');

%% ==================== set rbselectdirs
delete(findobj(gcf,'tag','rbselectdirs'));
pos3=pos; pos3([2 4])=[0 .02];
ucstep=pos3(3)/length(u.cases);
for i=1:length(u.cases)
    hc=uicontrol('style','radio','units','normalized','tag','rbselectdirs');
    set(hc,'position',[pos3(1)+i*ucstep-ucstep pos3(2)  ucstep.*.99 rbhigh2]);
    set(hc,'tooltipstring', u.cases{i} ,'fontsize',2 );
%     col=[1 1 1];%[ 0.9922    0.9176    0.7961];
   
%      if sum(col)==3; set(hc,'visible','off'); end
    set(hc,'userdata',u.cases{i});
    if mod(i,2)==0
        set(hc,'BackgroundColor',[0 0 1]);
    else
         set(hc,'BackgroundColor',[0.4941    0.4941    0.4941]);
    end
end

%% ==================== select all-dirs button
i=-1;
delete(findobj(gcf,'tag','rbselectalldirs'));
hc=uicontrol('style','radio','units','normalized','tag','rbselectalldirs');
 set(hc,'position',[pos3(1)+i*ucstep-ucstep/2 pos3(2)  ucstep.*.95 rbhigh2]);
set(hc,'tooltipstring', 'select all animal directories' ,'fontsize',6,'string','all dirs' );
col=[1.0000    0.8431         0];
set(hc,'BackgroundColor',col);
set(hc,'callback',@selectalldirs);
set(hc,'userdata',0);

function selectalldirs(e,e2)
disp('select all dirs');
hs=findobj(gcf,'tag','rbselectalldirs');
val=~get(hs,'userdata');
set(hs,'userdata',val);

hf=findobj(gcf,'tag','rbselectdirs','-and','visible','on');
set(hf,'value',val);


function selectallfiles(e,e2)
% disp('select all files');
hs=findobj(gcf,'tag','rbselectall');
val=~get(hs,'userdata');
set(hs,'userdata',val);

hf=findobj(gcf,'tag','rbselect','-and','visible','on');
set(hf,'value',val);
 


function exportfiles(e,e2)
% disp('export files');
[outdir]=uigetdir(pwd,'select export folder');
if isnumeric(outdir);disp('no export-folder selected...cancel'); return; end

%-----dirs-------
% mdir=antcb('getsubjects');
hd   =findobj(gcf,'tag','rbselectdirs','-and','visible','on','-and','value',1);
if isempty(hd); disp('no folders selected...cancel');return; end
names=get(hd,'userdata'); names=cellstr(names);
u=get(gcf,'userdata');
mdir=stradd(names,[ fileparts(u.pas{1}) filesep ] ,1 ); 
 
%-----files-------
hf   =findobj(gcf,'tag','rbselect','-and','visible','on','-and','value',1);
hfall=findobj(gcf,'tag','rbselect','-and','visible','on');
if isempty(hf); disp('no files selected...cancel');return; end


if length(hfall)==length(hf)
   exportmode=1; %COPY ENTIRE FOLDER
else
   exportmode=2;
end


if isempty(hf); return; end
%% ===================================
if exportmode==1
    %% ===================================
   for i=1:length(mdir)
       [~,name]=fileparts(mdir{i});
       cprintf([0 .5 0],...
           ['..exporting [' num2str(i) '/' num2str(length(mdir)) '] ' name '\n'] );
       newdir=fullfile(outdir,name);
       copyfile(mdir{i}, newdir,'f');
   end
    
%% ===================================
elseif exportmode==2
    %% ===================================
    
    files={};
    for i=1:length(hf)
        files(end+1,1)={get(hf(i),'userdata')};
    end
    % regexprep({'     ee rr    '},{'^\s+' '\s+$'},{''})
    files=regexprep(files,{'^\s+' '\s+$'},{''});
    
    tb=allcomb(mdir,files);
    allfiles=cellfun(@(a,b) {[a filesep b]},tb(:,1),tb(:,2));
    
    
    for i=1:length(allfiles)
        
            [px,fname,ext]=fileparts(allfiles{i});
            [ ~,mname    ]=fileparts(px);
            fname2=[fname,ext];
           
            if exist(allfiles{i})==2
                cprintf([0 .5 0],...
                    ['..exporting [' num2str(i) '/' num2str(length(allfiles))...
                    '] ' mname ' : ' fname2 '\n'] );
                newdir=fullfile(outdir,mname);
                if exist(newdir)~=7;
                    mkdir(newdir);
                end
                newfile=fullfile(newdir,fname2);
                copyfile(allfiles{i}, newdir,'f');
            else
                cprintf([1 0 1],...
                    ['..WARNING.. [' num2str(i) '/' num2str(length(allfiles))...
                    '] ' mname ' : ' fname2 '...>file not found\n'] );
            end
    end
end

showinfo2(['export-folder'],outdir) ;



function foldertask(h,e)
hsel=findobj(gcf,'tag','selected');
if isempty(hsel); return; end
us=get(hsel,'userdata');
if isstruct(us); us={us};   end
global an

s.folder   = unique(cellfun(@(a) {[a.folder]},us));
s.fpimages = unique(cellfun(@(a) {[a.fpimage]},us));
s.images   = unique(cellfun(@(a) {[a.image]},us));

%          delete(findobj(gcf,'tag','selected'));

%     'select these folders in ANT-mouse-folder-listbox'
%     'copy <unique>          folders to clipboard'
%     'copy <unique> fullpath folders to clipboard'
%     'copy <unique>          files   to clipboard'
%     'copy          fullpath files   to clipboard'
%     'copy <unique>          folders to clipboard #MATLAB-CELLSTYLE'
%     'copy <unique> fullpath folders to clipboard #MATLAB-CELLSTYLE'
%     'copy <unique>          files   to clipboard #MATLAB-CELLSTYLE'
%     'copy          fullpath files   to clipboard #MATLAB-CELLSTYLE'

if get(h,'value')      ==1                              %select [ANT]-folder
    xselect(0,struct('dirs',{s.folder}));
elseif get(h,'value')  ==2                              %FOLDER
    mat2clip(s.folder);
elseif get(h,'value')  ==3                              %FPfolder
    mat2clip(stradd(s.folder,[an.datpath filesep],1));
elseif get(h,'value')  ==4                              %IMAGES
    mat2clip(s.images);
elseif get(h,'value')  ==5                              %FP-IMAGES
    mat2clip(s.fpimages);
    
elseif get(h,'value')  ==6                              %FOLDER
    mat2clip(s.folder);
    clip2clipcell;
elseif get(h,'value')  ==7                              %FPfolder
    mat2clip(stradd(s.folder,[an.datpath filesep],1));
    clip2clipcell;
elseif get(h,'value')  ==8                              %IMAGES
    mat2clip(s.images);
    clip2clipcell;
elseif get(h,'value')  ==9                              %FP-IMAGES
    mat2clip(s.fpimages);
    clip2clipcell;
end

liststring=h.String{h.Value};
if strfind(liststring, 'make image copy')
    f0= s.fpimages;
    prompt = {'[alternative-1] Enter prefix','[alternative-2] Enter suffix:', '[alternative-3] Enter new name'};
    dlg_title = 'copy file and rename file Input';
    %num_lines = 1;
    defaultans = {'','' ''};
    num_lines = [ones(size(defaultans')) ones(size(defaultans'))*75];
    out = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    if ~isempty(out{1})
        f1= (stradd(f0,out{1},1));
    elseif ~isempty(out{2})
        f1= (stradd(f0,out{2},2));
    elseif ~isempty(out{3})
        opts.Interpreter = 'tex';
        opts.Default = 'cancel';
        quest = ['copy and rename file(s) as "' [strrep(out{3},'.nii','') '.nii' ] '"' char(10) ...
            '\color{magenta} CAUTION: multiple selected files from the same folder can be overwritten, when assigning a new name to the copied files  '];
        ask = questdlg(quest,'copy&rename files',...
            'proceed','cancel',opts);
        f1= (cellfun(@(a){[ a filesep strrep(out{3},'.nii','dd') '.nii' ]},fileparts2(f0)));
        if strcmp(ask,'cancel')
            return
        end
    end
    copyfilem(f0,f1);
    disp('files created...click [replot] to visualize in case-filematrix-window');
elseif strfind(liststring, 'delete image')
    f0= s.fpimages;
    for i=1:length(f0)
        try
            delete(f0{i});
        end
    end
    disp('files deleted...click [replot] to visualize in case-filematrix-window');
    
elseif strfind(liststring,'tabulate values')
    f0= s.fpimages;
    tg={};
    for i=1:length(f0)
        [ha a]=rgetnii(f0{i});
        a=a(:);
        
        td=[...
            min(a) max(a) mean(a) median(a) std(a)  length(unique(a)) ...
            length(find(a<0)) length(find(a>0)) length(find(a==0)) ...
            length(find(a<1)) length(find(a>1)) length(find(a==1)) ...
            ];
        tg=[tg; [f0{i} num2cell(td)]];
     end    
        htd={'Name' 'Min'  'Max' 'ME' 'Med' 'SD' 'Cardinality' ...
            'N<0' 'N>0'  'N==0' ...
            'N<1' 'N>1'  'N==1' };
        footn={'*** ME .. Mean; Med..Median; uniques..; Cardinality...number of different elements in image (uniqueness) '}
        ta= plog([],[ htd;tg],0, 'Image Values/Parameters','al=1;space=0' );
        ta=[ta; footn];
    uhelp( ta,1);
elseif strfind(liststring,'header information')
    % ==============================================
    %%
    % ===============================================
    f0= s.fpimages;
    tg={' #ko IMAGE HEADER '};
    for i=1:length(f0)
        [ha]=spm_vol(f0{i});
        
        
        v.name    =       [' #b NAME: ' f0{i}];
        v.size    =sprintf(' size    : %dx%dx%dx%d',[ha(1).dim length(ha)]);
        ha=ha(1);
        
        v.dt      =sprintf(' dt      : %d %d',[ha.dt]);
        v.pinfo   =sprintf(' pinfo   : %2.10f %2.10f %2.10f',[ha.pinfo]);
        v.mat1    =        ' mat     : ';
        v.mat2    =plog([],ha.mat,0,'','plotlines=0');
        v.n       =sprintf(' n       : %d %d',[ha.n]);
        v.descrip =       [' descrip : ' ha.descrip ];
        
        tg0=[ v.name; v.size;v.dt; v.pinfo; v.mat1; v.mat2; v.n; v.descrip ;'  '];
        tg=[tg; tg0];
        
    end
    uhelp( tg,1);
    % ==============================================
    %%
    % ===============================================
  elseif strfind(liststring,'export files')  
     paout= uigetdir(pwd, 'select target/"export-to" folder');
     if isnumeric(paout); return; end
      % ==============================================
      %%
      % ===============================================
      f0= s.fpimages;
      for i=1:length(f0)
          f1=f0{i};
          [pa1  name ext]=fileparts(f1);
          [pa2 animal]=fileparts(pa1);
          
          f2=fullfile(paout, animal, [name ext ]);
          if exist(f1)==2
              mkdir(fullfile(paout,animal))
              copyfile(f1,f2,'f');
              showinfo2(['EXPORTED: ' f1 ' '],f2)
          end
      end
      
      % ==============================================
      %%
      % ===============================================

end

function txt = showlabel(varargin)
label = varargin{3};
txt   = label{get(varargin{2}, 'DataIndex')};

function help_filematrix(h,e)

h={' ##m CASE-FILEM-MATRIX'};
h{end+1,1}=[ ' shows all nifti-files (y-axes) of all folders (x-axes) '                      ];
h{end+1,1}=[' #by  OVERLAY  '      ];
h{end+1,1}=[' to overlay image onto another image >>select background-IMAGE from [image]-pulldown'      ];
h{end+1,1}=[' to swap foreground and background image usE [BG]-radiobutton'      ];
h{end+1,1}=[' #by  DISPLAY - MOUSE'      ];
h{end+1,1}=[' #g [left  click] #k  on cell to show this volume/overlayed volumes'      ];
h{end+1,1}=[' #g [right click] #k  on cell to show this volume/overlayed volume in MRICRON'      ];
h{end+1,1}=[' #g [left double-click] #k  to open the directory and mark selected file'      ];
h{end+1,1}=[' #by  UICONTROLS  '      ];
h{end+1,1}=[' #b [RESIZE]-BUTTON  #k : toggle window in hakf screen or full screen view'      ];
h{end+1,1}=[' #b [BG]-radiobutton  #k : swap foreground and background images'      ];
h{end+1,1}=[' #b [image]-pulldown  #k : select a background image here'      ];
h{end+1,1}=[' #b [SHOW IMAGEHEADER]-radiobutton  #k : shows the header of the image under the hovered mousePointer'      ];
h{end+1,1}='';
h{end+1,1}=[' #b [selectFiles/Folders]-radiobutton  #k: [x] select multiple images/folder for further jobs '      ];
h{end+1,1}=[' #b                                    #k: [ ] default: select one image and display image/overlay'      ];
h{end+1,1}=[' #b [select jobs]-pulldown  #k : perform one of these jobs on selected files/folders'      ];
h{end+1,1}=[' #k       -to apply a job [selectFiles/Folders] has to be set to [x] and several files/folders has to be picked before'      ];
h{end+1,1}='';
h{end+1,1}=[' #by  SHORTCUTS  '      ];
h{end+1,1}=[' #b [+/-]-key        #k : increase/decrease fontsize'      ];
h{end+1,1}=[' #b [ctr+][+/-]-key  #k : rotate folder labels'      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];

uhelp(h,0,'position',[ 0.6330    0.5178    0.3535    0.40]);


function getfolder(h,e)
%     hfig=get(h,'parent');
%     if isempty(get(hfig,'userdata'))
%         us=[] ;
%         set(hfig,'userdata',us);
%     end
%     us=get(hfig,'userdata');

% 'raw'

if get(h,'value')==1
    delete(findobj(gcf,'tag','selected')); %DELETE PREV. MARKS
    
    %         us.WindowButtonDownFcn=  get(hfig,'WindowButtonDownFcn');
    %         set(hfig,'WindowButtonDownFcn',[]);
    %         set(hfig,'userdata',us);
    
      %      % contextMenu
      cmenu = uicontextmenu;
      hs = uimenu(cmenu,'label','select all files from this folder (colum-wise selection)',         'Callback',{@hcontext, 'selallfilefromdir'});
      hs = uimenu(cmenu,'label','deselect all files from this folder (colum-wise selection)',       'Callback',{@hcontext, 'deselallfilefromdir'});

      hs = uimenu(cmenu,'label','select this files from all folders (row-wise selection)',      'Callback',{@hcontext, 'selfilefromalldir'},'separator','on');
      hs = uimenu(cmenu,'label','delect this files from all folders (row-wise selection)',       'Callback',{@hcontext, 'deselfilefromalldir'});

      hs = uimenu(cmenu,'label','select all',         'Callback',{@hcontext, 'selectall'},'separator','on');
      hs = uimenu(cmenu,'label','deselect all',       'Callback',{@hcontext, 'deselectall'});
      
%       hs = uimenu(cmenu,'label','<html><font color=blue>show background image',  'Callback',{@hcontext, 'showbackground'});
%       hs = uimenu(cmenu,'label','<html><font color=blue>show foreground image',  'Callback',{@hcontext, 'showforeground'});
%       hs = uimenu(cmenu,'label','change paramter (view,slices)',  'Callback',{@hcontext, 'changeParams'});
%       hs = uimenu(cmenu,'label','<html><font color=gray>show help',  'Callback',{@hcontext, 'showhelp'},'separator','on');
      
      him=findall(gcf,'type','image');
      set(him,'UIContextMenu',cmenu);
      %       set(gcf,'WindowButtonMotionFcn',[]);
      
else
    %         DO SOMETHING
    hsel=findobj(gcf,'tag','selected');
    if isempty(hsel); return; end
    %          us=get(hsel,'userdata');
    %          folder = unique(cellfun(@(a) {[a.folder]},us))
    %          '--------'
    %          fpimages = unique(cellfun(@(a) {[a.fpimage]},us))
    %          '--------'
    %          images = unique(cellfun(@(a) {[a.image]},us))
    
    delete(findobj(gcf,'tag','selected'));
    %         set(hfig,'WindowButtonDownFcn',us.WindowButtonDownFcn);
    
    him=findall(gcf,'type','image');
    set(him,'UIContextMenu',[]);
end

function hcontext(e,e2,task)
% 'a'
if strcmp(task,'selallfilefromdir') || strcmp(task,'deselallfilefromdir') || ...
        strcmp(task,'selfilefromalldir') || strcmp(task,'deselfilefromalldir')  || ...
        strcmp(task,'selectall') || strcmp(task,'deselectall')
    
    cp=get(gca,'CurrentPoint');
    cp=round(cp(1,1:2));
    us=get(gcf,'userdata');
    
    hselected=findobj(gcf,'tag','selected');
    try
        cox=cell2mat([get(hselected,'xdata') get(hselected,'ydata')]);
    catch
        cox=([get(hselected,'xdata') get(hselected,'ydata')]);
    end
    %     if isempty(cox)
    %         iexist=[];
    %     else
    %         iexist=find(cox(:,1)==cp(1) & cox(:,2)==cp(2));
    %     end
    %     if ~isempty(iexist)  %delete  SELECTION agaon
    %         delete(hselected(iexist));
    %         return
    %     else  %SELECTION OF FOLDERS
    
    if      strcmp(task,'selallfilefromdir') || strcmp(task,'deselallfilefromdir')
        mod=1;
        ncounts =length(us.filesuni);
        ncounts2=1;
    elseif strcmp(task,'selfilefromalldir') || strcmp(task,'deselfilefromalldir')
        mod=2;
        ncounts=length(us.cases);
        ncounts2=1;
    elseif strcmp(task,'selectall') || strcmp(task,'deselectall')
        mod=3;
        ncounts=length(us.cases);
        ncounts2=length(us.filesuni);
    end
    
    global an
    hold on;
    for j=1:ncounts2
        for i=1:ncounts
            if     mod==1
                cx=[cp(1)  i   ];
            elseif mod==2
                cx=[i     cp(2)];
            elseif mod==3
                cx=[i     j    ];
            end
            
            try
                iexist=find(cox(:,1)==cx(1) & cox(:,2)==cx(2));
            catch
                iexist=[];
            end
            if ~isempty(iexist)
                delete(hselected(iexist));
            end
            if strcmp(task,'selallfilefromdir') || strcmp(task,'selfilefromalldir') || strcmp(task,'selectall')
                sus.image   = us.filesuni{cx(2)};
                sus.folder  = us.cases{cx(1)};
                sus.fpimage =fullfile(an.datpath, us.cases{cx(1)},us.filesuni{cx(2)});
                if exist(sus.fpimage)==2
                    plx= plot(cx(1),cx(2),'k*','markersize',12,'tag','selected');
                    set(plx,'userdata',sus);
                end
            end
        end
    end
end

function resize(he,er)
po=get(gcf,'position');
if po(3)<=.5; po(3)=1;
    set(gcf,'position',po);
elseif po(3)>=.5; po(3)=.5;
    set(gcf,'position',po);
end

function matrixmotion(he,er, ma, filesuni,cases)

hfig=he;
ax=findobj(hfig,'type','axes');
cp=get(ax,'CurrentPoint');

try
    
    cp=round(cp(1,1:2));
    
    % h=title(  ['                 ' filesuni{cp(2)}    '       -   '    cases{cp(1)} ],'interpreter','none',...
    %     'tag','title','HorizontalAlignment','left');%,'verticalalignment','cap');
    set(hfig,'name',['                 ' filesuni{cp(2)}    '       -   '    cases{cp(1)} ]);
    
    %% display header Info
    if get(findobj(gcf,'tag','showimageheader'),'value')==1
        global an
        fi=fullfile(an.datpath,cases{cp(1)},filesuni{cp(2)});
        ha=spm_vol(fi);
        hb=ha(1);
        hdr=[struct2list(hb) ;  ['4th dim= ' num2str(size(ha,1))]   ];
        hdr=cellfun(@(a) {[' ' a]},hdr);
        
        %
        %     ieq=regexpi(hdr,'=')
        %     iempt=cellfun('isempty',ieq)
        %     ieq(iempt)={0}
        %     mxeq=max(cell2mat(ieq));
        %
        
        hf2=findobj(0,'tag','msgx');
        if isempty(hf2)
            %uhelp(hdr,0,'fontsize',8,'position',[ 0.6309    0.7456    0.3590    0.1972]);
            
            hf2=figure('color','w','units','normalized','position',[    0.4875    0.6778    0.2063    0.2078],...
                'tag','msgx','menubar','none','NumberTitle','off');
            
            
            p=uicontrol('style','edit','units','norm','position',[0 0 1 .98],'max',1000,'backgroundcolor','w');
            set(p,'string',hdr,'HorizontalAlignment','left','tag','txtm');
            % set(gcf,'menubar','none')
            set(hf2,'position',[    0.6483    0.7744    0.3073    0.1933]);
            
        else
            hlb=findobj(hf2,'tag','txtm') ;
            set(hlb,'string',hdr);
        end
        
        %[  filesuni{cp(2)}    '   -   '    cases{cp(1)} ]
        set(findobj(0,'tag','msgx'),'name', [  filesuni{cp(2)}    '   -   '    cases{cp(1)} ]  );
        drawnow;
        
        figure(he);
        
        
    end
    
    
end


function matrixbuttondown(he,er, ma, filesuni,cases)


[button sca] = mousebutton;
if button==0; return; end





hgetfolder    = findobj(gcf,'tag','selectobject');
isfoldersel   = get(hgetfolder, 'value');

 if isfoldersel==1
   if strcmp(get(gcf,'SelectionType'),'alt')
       return
   end
 end
%         %      % contextMenu
%         cmenu = uicontextmenu;
%         hs = uimenu(cmenu,'label','<html><font color=blue>show overlay',           'Callback',{@hcontext, 'showoverlay'});
%         hs = uimenu(cmenu,'label','<html><font color=blue>show background image',  'Callback',{@hcontext, 'showbackground'});
%         hs = uimenu(cmenu,'label','<html><font color=blue>show foreground image',  'Callback',{@hcontext, 'showforeground'});
%         hs = uimenu(cmenu,'label','change paramter (view,slices)',  'Callback',{@hcontext, 'changeParams'});
%         hs = uimenu(cmenu,'label','<html><font color=gray>show help',  'Callback',{@hcontext, 'showhelp'},'separator','on');
%         
%         him=findall(gcf,'type','image');
%         set(him,'UIContextMenu',cmenu);
%         
%         return       
%     end
% else
%     him=findall(gcf,'type','image');
%         set(him,'UIContextMenu',[]);
% end



% return

cp=get(gca,'CurrentPoint');
cp=round(cp(1,1:2));
si=size(ma);
if ~(cp(2)>=1 & cp(2)<=si(1) & cp(1)>=1 & cp(1)<=si(2))  ; return ; end  %outsid boundarys (files x cases)



% show selection
if isfoldersel == 0
    delete(findobj(gcf,'tag','selected'));
    hold on;
    plot(cp(1),cp(2),'wx','markersize',12,'tag','selected');
else
    hselected=findobj(gcf,'tag','selected');
    try
        cox=cell2mat([get(hselected,'xdata') get(hselected,'ydata')]);
    catch
        cox=([get(hselected,'xdata') get(hselected,'ydata')]);
    end
    if isempty(cox)
        iexist=[];
    else
        iexist=find(cox(:,1)==cp(1) & cox(:,2)==cp(2));
    end
    if ~isempty(iexist)  %delete  SELECTION agaon
        delete(hselected(iexist));
        return
    else  %SELECTION OF FOLDERS
        hold on;
        plx= plot(cp(1),cp(2),'k*','markersize',12,'tag','selected');
        
        global an
        
        us.image   = filesuni{cp(2)};
        us.folder  = cases{cp(1)};
        us.fpimage =fullfile(an.datpath, cases{cp(1)},filesuni{cp(2)});
        set(plx,'userdata',us);
        
        return
    end
end


if ma(cp(2),cp(1))==0 %NONexist File
    return
end







% ma(cp(2),cp(1))
%  return

global an
hp=findobj(gcf,'tag','popbackground');
list=get(hp,'string'); if  ischar(list); list=cellstr(list); end
bgimg=list{get(hp,'value')};
orient=2; %orientation
if strcmp(bgimg,'t2.nii')
    orient=3;
end


f1=fullfile(an.datpath, cases{cp(1)},bgimg);
f2=fullfile(an.datpath, cases{cp(1)},filesuni{cp(2)});

templatepath=fullfile(fileparts(an.datpath),'templates');

if exist(f1)~=2
    f1=fullfile(   templatepath ,bgimg);
end
if exist(f2)~=2
    f2=fullfile(   templatepath ,filesuni{cp(2)});
end

[pax fix extx]=fileparts(f1);
flipbg=get(findobj(gcf,'tag','rbflipBG'),'value'); %FLIP BG
if flipbg==1
    if strcmp(fix,'none')==0
        f1a=f1;
        f1=f2;
        f2=f1a;
    else
        f1=f2;
    end
    
end




[pa1 fi ext]=fileparts(f2);
if     ~strcmp(ext,'.nii'); return ; end  %no NIFTIfile
fis={f1 f2};
% return
strings=[f1 '  - ' f2];
oneImage=0;
if strcmp(bgimg,'none');
    fis={f2};
    oneImage=1;
    if regexpi(filesuni{cp(2)},'i\w_') ==1  %inverse warped
        orient=3;
    end
end  % no background chosen
% ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [ ] }, strings);
cmap=jet;
if oneImage==1;
    cmap=gray;
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% DEPENDENT MOUSE_CLICK

if button==1
    try
        ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[cmap] .3 [ ] }, strings,...
            struct('position', [0.601    0.1783    0.3889    0.4667] ));
    catch
        lasterrrorx=lasterror ;
        
        cprintf([1 0 1],[ repmat('_',[1 100])  '\n']);
        disp(lasterrrorx.message);
        cprintf([1 0 1],['possible reason: set background image in the upper pulldown menu to "none" '  '\n']);
        cprintf([1 0 1],[ repmat('_',[1 100])  '\n']);
        
    end
    
    %     set(gcf,'position',[0.5701    0.1783    0.3889    0.4667]);
    % elseif strcmp(mouse_seltype,'alt')
    %     if flipbg==1
    %         explorerpreselect(f1);
    %     else
    %         explorerpreselect(f2);
    %     end
    %    disp(['renamed: <a href="matlab: explorerpreselect(''' f2 ''')">' f2 '</a>'  ]);
elseif  button==2
    if ispc
        p=[fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe') ];
        if exist(p)~=2;  disp('mricron-path not found'); return; end
    elseif ismac
        p=[fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','MRIcroGL.app') ];
        if exist(p)~=7;  disp('MRIcroGL.app-path not found'); return; end
    else
        disp(['mricron/MRIcroGL.app not provided for other OS-ante.m' ])
    end
    
    
    %----------------------------------------------
    %% SINGLE IMAGE
    %----------------------------------------------
    if strcmp(bgimg,'none')==1
       if ispc
        m1=[' ' f2 ' -c -0'];
        system(['start ' [p m1 ] ]);
        try
            system(which('rmricronmove.exe'));%rightPositioning
            pause(1);
            system(which('rmricronmove.exe'));%rightPositioning
        end
       elseif ismac
           pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
           vm=[pa_mricrongl ' -S "begin LOADIMAGE(''' f2 ''');ORTHOVIEW(0.5,0.5,0.5);COLORNAME(''Grayscale'');end."'];
           system([vm ' &']);
       end
%----------------------------------------------
    else
        %----------------------------------------------
        %% OVERLAY
        %----------------------------------------------

        %         if flipbg==1
        %             g2=f2;
        %             g1=f1;
        %         else
        g1=f1;
        g2=f2;
        %         end
        if ispc
            % start mricron .\templates\ch2.nii.gz -c -0 -l 20 -h 140 -o .\templates\ch2bet.nii.gz -c -1 10 -h 130
            m1=[' ' g1 ' -c -0'];
            m2=[' -o ' g2 ' -c -13'];
            system(['start ' [p m1 m2] ]);
            try
                system(which('rmricronmove.exe'));%rightPositioning
                pause(1);
                system(which('rmricronmove.exe'));%rightPositioning
            end
        elseif ismac
            pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
            % pa='/Volumes/O/antx/mricron/MRIcroGL.app/Contents/MacOS/MRIcroGL'
            % f1='/Users/skoch/Desktop/test/x_t2.nii'
            % f2='/Users/skoch/Desktop/test/ANOpcol.nii'
            vm=[pa_mricrongl ' -S "begin LOADIMAGE(''' f1 ''');OVERLAYLOAD(''' f2 ''');ORTHOVIEW(0.5,0.5,0.5); OVERLAYCOLORNAME(1,''ACTC'');end."'];
            system([vm ' &']);
        end
    end
elseif  button==3
    if flipbg==1
        explorerpreselect(f1);
    else
        explorerpreselect(f2);
    end
end









