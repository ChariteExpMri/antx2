

% #b [checkRegist] - check image registration of preselected folders
%  (mouse) folders must be preselected in advance from ANT gui
% #r GUI
% [mouse panel]     - grey vertical box. You can select a specific mouse from here. The current animal
%                     is indicated by a blue rectangle.
% [pulldown menu]: select a single image or two images from pulldown menu to display
% [edit field]   : type a specific image name to display specific images not found in the [pulldown menu] 
%                  example:  't20.nii'            .. to show 't20.nii'
%                            't20.nii - mask.nii' .. to show 'mask.nii' onto 't20.nii'
% [intern/MRIcon]   - Radio to change the display mode: display the images either internal of via MRICRON.
% [single Instance] - Radio to allow multiple instances of MRIcron ([intern/MRIcon] radio must be set accordingly).
% [tag mouse]       - Button to tag a specific mouse. Tagged mice ar indicated by yellow boxes in the
%                     above mouse panel.
% [explorer]        - Button to open the mouse-specific folder using Explorer (Win)/Nautilus(Ubuntu)/Finder(Mac) 
% [select tagged mouse in ANT gui]: This button allows to preselect the tagged mice in the ANT gui and
%                      canbe used for further processing.
% [previous/next]  - Show image of the next/previous mouse folder. You can also type a number in the
%                    [edit] field to go to this mouse (The number can be found in the in the [mouse panel])
% #g INTERNAL DISPLAY MODE - shortcuts
% - If two images are displayed you can click on the image to toggle between BG- and FG-image
% [#] change number of displayed slices
% [-] change orientation {sagital, coronal, axial}
% [.] fuse images (toggle betwee two different fusion modes)
% [f] flip up/down image
% [n] change color of BG image
% [m] change color of FG image
% [left arrow/right arrow] - go to next/previous mouse

%% other input uses;
%  checkRegist({image})  ; % open specific images
% examples
%     checkRegist
%     checkRegist({'c1t2.nii'})
%     checkRegist(3)
%     checkRegist({'t2.nii' 'c2t2.nii'})    ; % overlay default color
%     checkRegist({'t2.nii' 'c2t2.nii' 3})  ; % overlay using MRICRON-color 3
%----
% subfun: slicesPanel_subf.m 

function checkRegist(arg1)

if 0
    checkRegist
    checkRegist({'c1t2.nii'})
    checkRegist('help') ;% display table of images to display
    checkRegist(3)      ;% display third row in table
    
    checkRegist({'t2.nii' 'c2t2.nii'})
    checkRegist({'t2.nii' 'c2t2.nii' 3})
    
end

%———————————————————————————————————————————————
%%   TABLE
%———————————————————————————————————————————————
tb={...
    't2.nii'     ''            nan
    't2.nii'     '_msk.nii'     1
    'coreg.jpg'  ''             nan
    'coreg2.jpg'  ''            nan
    't2.nii'     [filesep 'rigid' filesep '_bestROT.nii'] 2
    't2.nii'     'c1t2.nii'     2
    't2.nii'     'c2t2.nii'     3
    't2.nii'     'c3t2.nii'     4
    't2.nii'     '_mask.nii'    3
    'x_t2.nii'    'AVGT.nii'    0
    'x_t2.nii'    ''            nan
    'x_t2.nii'     'x_c1t2.nii'     2
    'x_t2.nii'     'x_c2t2.nii'     3
    'x_t2.nii'     'x_c3t2.nii'     4
    'x_t2.nii'     'ANO.nii'       13
    't2.nii'       'ix_ANO.nii'    13
    't2.nii'       'ix_AVGT.nii'    0
    ...
    };


if nargin==0
    mode=1;
else
    if ischar(arg1)
        if strcmp(arg1,'help')
            disp(tb);
            return
        end
        return
    elseif iscell(arg1)
        tb2=arg1;
        if size(tb2,2)==2
            tb2=[tb2  repmat({0}, [size(tb2,1) 1]) ];
        elseif size(tb2,2)==1
            tb2=[tb2  repmat({''}, [size(tb2,1) 1])   repmat({nan}, [size(tb2,1) 1])   ];
            
        end
        tb=[tb2; tb];
        mode=1;
    elseif isnumeric(arg1)
        mode=arg1;
    else
        
        mode=1;
    end
    
    
end


us.tb=tb;



global an;
pax=antcb('getsubjects');

us.mode=mode;
us.pax=pax;
us.num  =1;
us.mricronSingleInstance=1;
us.marked=zeros(length(us.pax),1 );
us.markedCol0 = [0.9400    0.9400    0.9400];
us.markedCol1 = [ 1.0000    0.8431        0];

us.ids={};
for i=1:length(us.pax)
    [~,name]= fileparts(us.pax{i});
    us.ids(i,1)={name};
end

us.displaymode=0;
try
    global checkrr
    us.displaymode=checkrr.displaymode;
end

prepgui(us);
update;

function prepgui(us)


%%
delete(findobj(0,'tag','checkRegist'));
fg;
set(gcf,'menubar','none','units','norm','tag','checkRegist','name','checkRegist','NumberTitle','off');
% set(gcf,'position',[0.1464    0.1444    0.3849    0.7954]);
% set(gcf,'KeyPressFcn',@keys);
set(gcf,'windowKeyPressFcn',@keys);

set(gcf,'WindowKeyReleaseFcn',@fokus)
set(gcf,'position',[ 0.0024    0.1383    0.3344    0.7956]);
ha=axes('position',[[0.001 .278 .995 .7]],'tag','ax_checkRegist');
axis off;
plot(1:10)
% axes(ha);
us.ax1=ha;

ha2=axes('position',[0 0 .5 .5 ],'tag','ax_subjects');
set(ha2,'position',[0.1 .25 .8 .025],'color','k');
set(ha2,'ButtonDownFcn',@ax2click);
us.ax2=ha2;

fs=7;
hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','prev','string','previous','position',[.05 .05 .15 .025],'callback', {@mouse,-1},'fontsize',fs);
set(hb,'tooltipstring','check previous mouse' );

hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','next','string','next','position',[.2 .05 .15 .025],'callback', {@mouse,1},'fontsize',fs);
set(hb,'tooltipstring','check next mouse' );

hb=uicontrol('style','edit','units','normalized');  %EDIT MOUSE NUMBER
set(hb,'tag','ednumcase','string','','position',[.005 .05 .045 .025],'callback', {@mouse,0},'fontsize',fs);
set(hb,'tooltipstring','enter case number here' );


% hb=uicontrol('style','pushbutton','units','normalized');  %pb-selectFiles
% set(hb,'tag','ednumcase','string','','position',[.05 .05 .045 .025],'callback', {@selectfiles,0},'fontsize',fs);
% set(hb,'tooltipstring','enter case number here' );



hb=uicontrol('style','edit','units','normalized');  %EDIT image/pair to show
set(hb,'tag','edimage','string','','position',[.05 .1 .275 .02],'callback', {@edimage},'fontsize',fs);
set(hb,'tooltipstring',...
    ['enter an image name or two images to overlay (two images must be separated by " - ")' char(10) ...
    'example: "t2.nii - c2t2.nii" '] );

hb=uicontrol('style','pushbutton','units','normalized');  %select files gui
set(hb,'tag','pbselectimage','string','f>','position',[0 .1 .05 .02],'callback', {@selectfiles},'fontsize',fs);
set(hb,'tooltipstring',...
    ['select one image or two images to overlay' char(10)  ' '] );




hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','mark','string','tag this mouse','position',[.4 .05 .15 .025],'callback', {@mark,1},'fontsize',fs);
set(hb,'tooltipstring','tag this illposed mouse, to untag hit button again' );


hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','img2clipboard','string','img2clip','position',[.4 .1 .12 .025],'callback',@img2clipboard ,'fontsize',fs);
set(hb,'tooltipstring','copy image to clipboard' );

hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','select','string','select tagged mice in GUI','position',[.6 .05 .2 .025],'callback', {@select},'fontsize',fs);
set(hb,'tooltipstring','select taged mice in ANT GUI' );


hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','openexplorer','string','explorer','position',[.4 .025 .1 .025],'callback', {@openexplorer},'fontsize',fs);
set(hb,'tooltipstring','open explorer window for this mouse' );

hb=uicontrol('style','pushbutton','units','normalized');
set(hb,'tag','helpgui','string','help','position',[.5 .025 .1 .025],'callback', {@helpgui},'fontsize',fs);
set(hb,'tooltipstring','help for this gui' );


imag=cellfun(@(a,b){[a ' - ' b ]},  us.tb(:,1),us.tb(:,2));

hb=uicontrol('style','popupmenu','units','normalized');
set(hb,'tag','selectImage','string',imag,'position',[.6 .05 .2 .025],'callback', {@selectImage},'fontsize',6);
set(hb,'tooltipstring','select image' );
set(hb,'position',[0.05 .05 .3 .05]);
set(hb,'value',us.mode);

hb=uicontrol('style','radio','units','normalized');
set(hb,'tag','displaymode','string','Intern/MRIcon','position',[.001 .001 .18 .025],'callback', {@displaymode},'fontsize',fs);
set(hb,'value',us.displaymode,'backgroundcolor','w','tooltipstring','select displaymode: intern or mricron');



hb=uicontrol('style','radio','units','normalized');
set(hb,'tag','MRICRONsingle','string','singleInstance','position',[.2 .001 .2 .025],'callback', {@MRICRONsingle},'fontsize',fs);
set(hb,'value',us.mricronSingleInstance,'backgroundcolor','w','tooltipstring','single Instance of MRICRON');


hb=uicontrol('style','radio','units','normalized','backgroundcolor','w','value',0);  %reverse ORDER
set(hb,'tag','reverseimageorder','string','swapImageOrder','position',[.4 .001 .2 .025],'fontsize',fs-1);
set(hb,'tooltipstring', ['reverse background and foreground image' char(10) ' '],...
    'callback',@callupdate);

hb=uicontrol('style','popupmenu','units','normalized','backgroundcolor','w','string','rr');  %reverse ORDER
set(hb,'tag','orientationDim','position',[.6 .001 .1 .025],'fontsize',fs-1);
set(hb,'tooltipstring', ['display orientation ' char(10) '"options: "auto",1,2 or 3 '],...
    'callback',@callupdate,'string',{'auto','1','2','3'});



% hb=uicontrol('style','pushbutton','units','normalized');
% set(hb,'tag','select','string','tag marked mice in GUI','position',[.6 .05 .15 .025],'callback', {@select},'fontsize',fs);
% set(hb,'tooltipstring','close this figure' );


set(gcf,'userdata',us);


function helpgui(e,e2)
uhelp([mfilename '.m']);
set(gcf,'name','checkregist-help','numbertitle','off');



function displaymode(e,e2)
val=get(e,'value');

global checkrr
checkrr.displaymode=val;
us=get(gcf,'userdata');
us.displaymode=val;
set(gcf,'userdata',us);
update;

function fokus(e,e2)
figure(findobj(0,'tag','checkRegist'))

function MRICRONsingle(e,e2)
hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist')
us=get(hf,'userdata');
if us.mricronSingleInstance==1;      us.mricronSingleInstance=0;
elseif us.mricronSingleInstance==0;  us.mricronSingleInstance=1;
end
set(gcf,'userdata',us);


function selectImage(e,e2)
va=get(e,'value');
hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist')
us=get(hf,'userdata');

us.mode=va;
set(hf,'userdata',us);
update;


function callupdate(e,e2)

hf=findobj(0, 'tag','checkRegist');
f=findobj(hf,'tag','selectImage');
va=get(f,'value');
% ha=findobj(hf, 'tag','ax_checkRegist')
us=get(hf,'userdata');

us.mode=va;
set(hf,'userdata',us);
update



function update

hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist')
us=get(hf,'userdata');
ax1=us.ax1;
ax2=us.ax2;

num=us.num;
set(findobj(gcf,'tag','ednumcase'),'string',num2str(num));
pas=us.pax{num};
[~,name ]=fileparts(pas);

updateAx2; drawnow;
axes(ax1);


%% 'orientationDim'
horient=findobj(hf,'tag','orientationDim');
va=get(horient,'value');
li=get(horient,'string');
orientstr=li{va};

if ~isempty(regexpi2(cellstr(orientstr),'1|2|3'))
    %     us.dim = str2num(regexprep(orientstr,'\D',''));
    %     disp(['us.dim: ' num2str(us.dim)]);
    %     set(hf,'userdata',us);
    global checkrr
    checkrr.dim = str2num(regexprep(orientstr,'\D',''));
%     disp(['us.dim: ' num2str(us.dim)]);
%     set(hf,'userdata',us);
    
else
     global checkrr
%     us.dim=checkrr.dim;
     filestr={us.tb{us.mode,1} us.tb{us.mode,2}} ;
     if ~isempty(regexpi2(filestr,['^x_t2.nii$|^AVGT.nii$|^ANO.nii$|^x_.*.nii$' ]));
         checkrr.dim=2; %NORMSPACE
     else
        checkrr.dim=1; 
        us.dim=1;
     end
     
     
    
end




if us.mode==0   % mask and T2
    
else
    mode=us.mode;
    if us.mricronSingleInstance==1;
        rclosemricron;
    end
    
    % wait
    hs=imagesc(permute([0 0 0], [3 1 2 ]),'tag','wait') ;
    axis off
    if us.displaymode==0
        msg=[''];
    else
        msg=[' for MRIcron... '];
    end
     delete(findobj(gcf,'tag','waittxt'));
    te=text(1,1,['..wait' msg],'tag','waittxt','color','w');
    set(te,'horizontalAlignment','center','fontweight','bold');
    drawnow;
    
    
    [~,~,ext]=fileparts(us.tb{mode,1});
    delete(findobj(gcf,'tag','notfound'));
    if strcmp(ext,'.jpg')
         set(gcf,'windowKeyPressFcn',@keys);
        try
            fis=fullfile(pas,us.tb{mode,1});            % 'coreg.jpg'
            [a map]=imread(fis);
            si= (size(a));
            hs=imagesc(a);
            %     hs=imagesc(a(1:round(si.*.6),:  ,:));
        catch
            hs=imagesc(permute([0.9294    0.6941    0.1255], [3 1 2 ])) ;
            set(hs,'tag','notfound');
            [~,mdir]=fileparts(pas)
            te=text(1,1,{'file not found:'; ['# ' fullfile(mdir,us.tb{mode,1} ) ]},'tag','notfound');
            set(te,'horizontalAlignment','center','fontweight','bold');
        end
    else
        
        f1=fullfile(pas, us.tb{mode,1});
        f2=fullfile(pas, us.tb{mode,2});
        col=us.tb{mode,3};
        
        if exist(f1)==2 && exist(f2)==2  %OVERLAY
            
            %check reverse order
            himageorder=findobj(hf,'tag','reverseimageorder');
            if get(himageorder,'value')==1
                f1tmp=f1;
                f1   =f2;
                f2   =f1tmp;
            end
            
            %           set(findobj(0,'tag','checkRegist'),'KeyPressFcn',[]);
            % tic
            %              fi= { ...
            %                  fullfile('O:\data4\recode2Rat_WHS2\dat\t_fastsegm','x_t2.nii');
            %                  fullfile('O:\data4\recode2Rat_WHS2\dat\t_fastsegm','AVGT.nii')};
            %              test11(fi,2,'n20', 1);
            if  us.displaymode ==0
                slicesPanel_subf({f1 f2},2,'n6', 1);
                %slicesPanel_subf({f1 f2},us.dim,'n6', 1);
            else
                set(gcf,'windowKeyPressFcn',@keys);
                rmricron([],f1,f2,col);
                
                delete(findobj(gcf,'tag','waittxt'));
                te=text(1,1,[''],'tag','waittxt','color','w');
                set(te,'horizontalAlignment','center','fontweight','bold');
                drawnow;
            end
            % toc
            %           drawnow
            %           set(findobj(0,'tag','checkRegist'),'KeyPressFcn',@keys);
        elseif exist(f1)==2 && isempty(us.tb{mode,2})  %SINGLE
            %           set(findobj(0,'tag','checkRegist'),'KeyPressFcn',[]);
            %           drawnow;
            if  us.displaymode ==0
                slicesPanel_subf({f1 f2},2,'n6', 1);
                %slicesPanel_subf({f1 f2},us.dim,'n6', 1);
            else
                set(gcf,'windowKeyPressFcn',@keys);
                rmricron([],f1);
                
                delete(findobj(gcf,'tag','waittxt'));
                te=text(1,1,[''],'tag','waittxt','color','w');
                set(te,'horizontalAlignment','center','fontweight','bold','interpreter','none');
                drawnow;
            end
            
            %
            
            %           set(findobj(0,'tag','checkRegist'),'KeyPressFcn',@keys);
            
            
        else
            hs=imagesc(permute([0.9294    0.6941    0.1255], [3 1 2 ])) ;
            set(hs,'tag','notfound');
            %te=text(1,1,'file not found','tag','notfound');
               [px1 mfi1 ext1 ]=fileparts(f1);[ ~, mdir1]=fileparts(px1);
               [px2 mfi2 ext2 ]=fileparts(f2);[ ~, mdir2]=fileparts(px2); 
               
               if    exist(f1)==2; msg_f1=''; 
               else;               msg_f1=['# '  fullfile(mdir1,[mfi1 ext1])   '   (missing)' ];
               end
                   
               
               if    isempty(us.tb{mode,2}); msg_f2='';
               else;                         msg_f2=['# '  fullfile(mdir2,[mfi2 ext2])   '   (missing)' ]; 
               end
               
            te=text(1,1,{'file(s) not found:' 
                msg_f1
                msg_f2
                },'tag','notfound','interpreter','none');
            set(te,'horizontalAlignment','center','fontweight','bold');
        end
        
        
        
    end
    
    
    
    
end








% set(ax1,'position',[.2 .3 .6 .6]);
% axis off;
set(gca,'xticklabels','','yticklabels','');
title([ '[' num2str(num) '/' num2str(length(us.pax))  '] ' name  ],'interpreter','none');

% updateAx2;
drawnow;
figure(findobj(0,'tag','checkRegist'))

function updateAx2
hf=findobj(0, 'tag','checkRegist');

us=get(hf,'userdata');
ax1=us.ax1;
ax2=us.ax2;
% ax 2
col=repmat(us.markedCol0,[length(us.marked) 1 ]);
imarked=find(us.marked==1);
col(imarked,:)=repmat(us.markedCol1,[length(imarked) 1]);
col2=permute(col,[ 3 1 2]);

ha2=findobj(hf, 'tag','ax_subjects');
axes(ax2);
hs=imagesc(col2);
set(hs,'ButtonDownFcn',@ax2click);

e=findobj(hf,'tag','mark');
if us.marked(us.num) == 1  %MARK THIS
    set(e,'backgroundcolor' ,us.markedCol1 );
else % UNMARK
    set(e,'backgroundcolor',us.markedCol0 );
end


ids=strrep(us.ids,'_','\_');
ids=cellfun(@(a,b){[ a '] ' b ]}, cellstr(num2str([1:length(ids)]')) , ids );
set(gca,'xtick',[1:length(us.ids)],'xticklabel',ids);
try
    set(gca,'XTickLabelRotation',45,'fontsize',7,'xlim',[.5 length(ids)+.5]);
catch
    myXTickLabelRotation([1:length(us.ids)],ids,45); %MISSING FUN before 2014b
end



vl=vline([.5:1:length(ids)+.5],'color','k','linewidth',2);
set(gca,'ytick',[]);

try; delete(findobj(ha2,'tag','currentset') ); end
num=us.num;
vx=rectangle('Position',[num-.5 .5 1 1],'Curvature',0.2);
set(vx,'linewidth',3,'EdgeColor','b','tag','currentset');

function myXTickLabelRotation(xx,lab,angle)
% xx: x-pos
% lab: label
% angle ..

% Set the tick locations and remove the labels
set(gca,'XTick',xx,'XTickLabel','')
% Define the labels
hx = get(gca,'XLabel');  % Handle to xlabel
set(hx,'Units','data');
pos = get(hx,'Position');
y = pos(2);
% Place the new labels
for i = 1:length(lab)
    t(i) = text(xx(i),y  ,lab(i));
end
set(t,'Rotation',angle,'HorizontalAlignment','right');


% % ###
% % figure
% % X = 1:12;
% % Y = rand(1,12);
% % % Generate a plot
% % bar(X,Y);
% % % Set the tick locations and remove the labels
% % set(gca,'XTick',1:12,'XTickLabel','')
% % % Define the labels
% % lab = [{'January'};{'February'};{'March'};{'April'};{'May'};{'June'};...
% %          {'July'};{'August'};{'September'};{'October'};...
% %          {'November'};{'December'}];
% % % Estimate the location of the labels based on the position
% % % of the xlabel
% % hx = get(gca,'XLabel');  % Handle to xlabel
% % set(hx,'Units','data');
% % pos = get(hx,'Position');
% % y = pos(2);
% % % Place the new labels
% % for i = 1:size(lab,1)
% %   t(i) = text(X(i),y,lab(i,:));
% % end
% % set(t,'Rotation',45,'HorizontalAlignment','right')
% % ##





function mouse(e,e2, par)
hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist');
us=get(hf,'userdata');

if par==-1 || par==1
    num=us.num+par;
else
    num=str2num(get(findobj(gcf,'tag','ednumcase'),'string')); %via editor
end
if num<=length(us.pax) & num>0
    us.num=num;
    set(hf,'userdata',us);
    update;
end






function mark(e,e2, par)
hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist');
us=get(hf,'userdata');

if us.marked(us.num) == 0  %MARK THIS
    us.marked(us.num)=1;
    set(e,'backgroundcolor' ,us.markedCol1 );
    set(hf,'userdata',us);
else % UNMARK
    us.marked(us.num)=0;
    set(e,'backgroundcolor',us.markedCol0 );
    set(hf,'userdata',us);
end
updateAx2



function select(e,e2)
hf=findobj(0, 'tag','checkRegist');
us=get(hf,'userdata');
ids=us.ids(find(us.marked));
if ~isempty(ids)
    antcb('selectdirs',ids );
    disp('marked mice were selected in ANT GUI');
else
    disp('no mice were tagged');
end


function keys(e,e2)
% e2.Key
if strcmp(e2.Key,'leftarrow')
    mouse([],[],-1);
elseif strcmp(e2.Key,'rightarrow')
    mouse([],[],1);
end

function ax2click(e,e2)
currpoi=get(get(e,'parent'),'CurrentPoint');
num=round(currpoi(1,1));
set(findobj(gcf,'tag','ednumcase'),'string',num2str(num));
mouse([],[],0);

function openexplorer(e,e2)
us=get(gcf,'userdata');
explorer(us.pax{us.num});

function selectfiles(e,e2)
hf=findobj(0, 'tag','checkRegist');
% ha=findobj(hf, 'tag','ax_checkRegist');
us=get(hf,'userdata');
currdir=us.pax{us.num};

% [t,sts] = spm_select(n,typ,mesg,sel,wd,filt,frames)
% [t,sts] = spm_select([1 2],'image','??','',currdir,'.*',1)

 [files,~] = spm_select('List',currdir,['.*.nii$']); 
 files=cellstr(files);
 title='select one ore two image(s) to overlay';
 ro=selector2(files,{'TargetImage'},'out','list','selection','multi','title',title);
 if isnumeric(ro);return; end
 
 e=findobj(hf,'tag','edimage');
 if length(ro)==1; 
     set(e,'string',ro{1}); 
 else
     set(e,'string',[ro{1} ' - '  ro{2}]); 
 end
 

function edimage(e,e2)

us=get(gcf,'userdata');
str=get(e,'string');
sep=findstr(str,' - ');
if ~isempty(sep)
    im1=str(1:sep-1);  im1=strrep(im1,' ','');
    im2=str(sep+2:end);im2=strrep(im2,' ','');
    col=4;
else
    im1=str;  im1=strrep(im1,' ','');
    im2='';
    col=nan;
end

us.tb=[us.tb; {im1 im2 col}];
us.mode=size(us.tb,1);

imag=cellfun(@(a,b){[a ' - ' b ]},  us.tb(:,1),us.tb(:,2));
hpop=findobj(gcf,'tag','selectImage');
set(hpop,'string',imag); set(hpop,'value',us.mode);

set(e,'string','');
set(gcf,'userdata',us);
update;

function img2clipboard(e,e2)
hf=findobj(0,'tag','checkRegist');
set(hf,'color',[0.9294    0.6941    0.1255]);
currAxes = get(findobj(hf,'tag','imo'),'parent');


newFig =fg('visible','off');
newax = copyobj(currAxes,newFig);
set(gcf,'menubar','none');
set(newax,'position',[0 0 1 .95]);

if isunix
    fmt='-dbitmap';
else
    fmt='-dmeta';
end

try
    print(newFig,'-clipboard',fmt);
catch
    try
        hgexport(newFig,'-clipboard');
        
    catch
        try
            print(newFig,'-clipboard',fmt);
        catch
            
        end
    end
end

close(newFig);
set(hf,'color',[1 1 1]);




































