%% #yk image header manipulation: file selector
% THIS GUI IS USED TO SELECT THE IMAGES FOR HEADER-MANIPULATION
% #r SHORTCUTS
% #g [left mouse button single click]: #k select the initial source image
% #g [left mouse button double click]: #k select the initial reference image
% #g [s] #k select other sources  (images whos header should be changes)
% #g [r] #k select other references (images whos header should be used)
% #g [a] #k select 'apply-images', i.e. images whos header should be changed based on 
% #g     #k source image manipulation)
% #g [d] #k deselect an image 
% ————————————————————————————————————————————————————————————————————————————————
% #k *** SELECT ADDITIONAL SOURCES, REFERENCES AND 'APPLY-IMAGES' *** 
% #g [shift]+[s] #k select the same image across all folders as sources   
% #g [shift]+[r] #k select the same image across all folders as references   
% #g [shift]+[a] #k select the same image across all folders as 'apply-images'
% #g [shift]+[d] #k deselect the same image across all folders
% #g [ctrl] +[d] #k deselect all
% #g [e]         #k expand selection across all folders if 1/more source images and/or
%                   reference image(s) and/or 'apply-images' were selected before
%                   i.e. the same image is selected for all folders 
%———————————————————————————————————————————————
% #k *** OTHER SHORTCUTS *** 
% #g [+]/[-] #k in/decrease fontsize of folders and files
% #g [right mouse button]: #k context menu
% #g [i]: #k get header information for current image
% #g [j]: #k get header information for all images with the same name across folders
% #g [left/right/up/down arrow]: #k adjust table in case of long file/folder names
% ————————————————————————————————————————————————————————————————————————————————
% #r TERMINUS USED HERE: SOURCE, REFERENCE and APPLY IMAGE
% #b  sources % #k are those images whose header should be changed
% #b  references #k (optional) are images that provide header information   
% #b  "apply images" #k (optional) are similar to sources except that a specific rule from the 
%     source is used
%   *Example: "S.nii", "t2.nii" and "A.nii" are source, reference and "apply" image, respectively.
%              The aim is to manually translate "S.nii" in x/y/z direction in such a way that it
%              matches "t2.nii", and finally to apply the translation rule to image "A.nii".
%
% #r IMAGE SELECTION EXPLAINED
% #b [SOURCE SELECTION]
%    -SINGLE click left mouse button to select a file as source-IMG: example "S1.nii" from folder "M1"
%     --> a green dot appears, indicating that this file is a source
%     --> click onto the dot to deselect this selection again
% #b [REFERENCE SELECTION] (optional)
%    -double click left mouse button to select a file as reference-IMG: example "t2.nii" from folder "M1"
%     --> a red dot appears, indicating that this file is the reference
%     --> click onto the dot to deselect this selection again
% #b [APPLY IMAGE SELECTION] (optional)
%     -hover mouse over another file and hit key 'a' to select an apply image: example "A1.nii" from 
%     folder "M1"
%     --> the cell of the file appear yellow, indicating that this file is an "apply image"
% #b Extend selection for all mouse folders
%     -if a source image or a reference image or apply images or any combination of them have been 
%      selected for one mouse folder   -->  hit key-'e' to extend the selection for all folders
% #b select other sources
%    hover mouse over another file and hit key 's' --> the cell of the file appears green, indicating that
%     this file is now another source. Example: "S1.nii" from folders "M2" and "M3"
% #b select other references
%    hover mouse over another file and hit key 'r' --> the cell of the file appears red, indicating that
%     this file is now another reference. Example : "t2.nii" from folders "M2" and "M3"
% #b DESELECTION OF IMAGES
%    - use key 'd' to deselect an image or 'shift'+'d' to deselect an images across all folders
%    - use 'ctrl'+'d' to deselect all images
% #r [UPDATE]-BUTTON
%  press [update] to update file and folders in case of file/folder-modifications
% #r [send..]-BUTTON
%  press [send..] to send file selection to the header manipulation gui
% #r [context menu]
%  each cell has a context menu. With the context menu you can open the respective folder,
%  display the image or show the header information in a separate window.

%% GUI initialization
% xheadmanfiles('pamain',fullfile(pwd,'dat')) ; % using main directory ... the sub-directories will be used
% xheadmanfiles('dirs', antcb('getsubjects')) ; % using 1/more dirs 
% xheadmanfiles()  ; % no input will open a gui to select the main path (for other data)
function xheadmanfiles(varargin)

if nargin==0
    p.pamain=uigetdir(pwd,'select main directory');
    fpdirs=antcb('getsubdirs', p.pamain);
else
    p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    if isfield(p,'pamain')==1  && isdir(p.pamain)  %MAIN DIRECTORY
        fpdirs=antcb('getsubdirs', p.pamain);
    elseif isfield(p,'dirs')==1 
        fpdirs=p.dirs;
        
    end
        
    
end


% clc
%  pa='o:\data3\hedermanip\dat';
% % pa='O:\harms1\harms3_lesionfill_20stack\dat'
% %pa='O:\data3\hedermanip\dat4d'
% fpdirs=antcb('getsubdirs', pa);

%===========================
u=findfiles([],fpdirs);





delete(findobj(0,'tag','headmanfiles' ));
f=figure;
set(f,'units','normalized','menubar','none','tag','headmanfiles','color','w');
set(f,'position',[0.0010    0.0467    0.4913    0.9206]);%[  0.0132    0.4100    0.9656    0.4667]);
% 0    0.0333    1.0000    0.9417
set(gcf ,'name',['header manipulation - file selection (' mfilename '.m)' ],'NumberTitle','off');
ha=axes('position',[.1 .4 .4 .4]);
im=imagesc(u.d);%colormap copper
set(im,'tag','him');


cmap=[1 1 1; repmat(0.9,1,3); 0.7412    0.8588    0.5843 ; 0.9294    0.6157    0.6157;  1 1 0 ];
colormap(cmap);
caxis([0 size(cmap,1)-1]);

% cmap=colormap('copper');
if 0
    hold on;
    pl(1)=plot(0,0,'sk','markerfacecolor',cmap(1,:),'linewidth',.5,'hittest','off','visible','on','tag','');
    pl(2)=plot(0,0,'sk','markerfacecolor',cmap(2,:),'linewidth',.5,'hittest','off','visible','on');
    pl(3)=plot(0,0,'ok','markerfacecolor',[0 .5 0],'linewidth',.5,'hittest','off','visible','on');
    pl(4)=plot(0,0,'ok','markerfacecolor',[1 0 0],'linewidth',.5,'hittest','off','visible','on');
    
    pl(5)=plot(0,0,'sk','markerfacecolor',cmap(3,:),'linewidth',.5,'hittest','off','visible','on');
    pl(6)=plot(0,0,'sk','markerfacecolor',cmap(4,:),'linewidth',.5,'hittest','off','visible','on');
    pl(7)=plot(0,0,'sk','markerfacecolor',cmap(5,:),'linewidth',.5,'hittest','off','visible','on');
    axis image;
    
    % TXT file color indicator
    hu=uicontrol('style','text','units','norm','string','## ######');
    set(hu,'position',[ 0.01 0.865    0.14    0.015],'string','File Color Indicator','HorizontalAlignment','left',...
        'fontsize',6,'fontweight','bold','backgroundcolor','w');
    %LEGEND
    le=legend(pl,{'non existing file' 'file exists' 'sourceIMG' 'referenceIMG' 'other sourceIMG(s)'  'other referenceIMG(s)' '"apply IMG(s)"'});
    set(le,'position',[ 0.055 0.8    0.02    0.05],'box','off');
end



%-----matlb2019 issue
if 1
    hold on;
    pl(1)=plot(0,0,'sk','markerfacecolor',cmap(1,:),'linewidth',.5,'hittest','off','visible','on','tag','');
    pl(2)=plot(0,0,'sk','markerfacecolor',cmap(2,:),'linewidth',.5,'hittest','off','visible','on');
    pl(3)=plot(0,0,'ok','markerfacecolor',[0 .5 0],'linewidth',.5,'hittest','off','visible','on');
    pl(4)=plot(0,0,'ok','markerfacecolor',[1 0 0],'linewidth',.5,'hittest','off','visible','on');
    
    pl(5)=plot(0,0,'sk','markerfacecolor',cmap(3,:),'linewidth',.5,'hittest','off','visible','on');
    pl(6)=plot(0,0,'sk','markerfacecolor',cmap(4,:),'linewidth',.5,'hittest','off','visible','on');
    pl(7)=plot(0,0,'sk','markerfacecolor',cmap(5,:),'linewidth',.5,'hittest','off','visible','on');
    axis image
    
    
    LGgstr={'non existing file' 'file exists' 'sourceIMG' 'referenceIMG' 'other sourceIMG(s)'  'other referenceIMG(s)' '"apply IMG(s)"'};
    symbused={'&#9632'  '&#9673'};
    symbind=[1 1 2 2 1 1 1];
    LGsym=symbused(symbind);
    LGcol={cmap(1,:) cmap(2,:)-.2  [0 .5 0]  [1 0 0] cmap(3,:) cmap(4,:) cmap(5,:)};
    hu=uicontrol('style','pushbutton','units','norm','string','## ######');
    set(hu,'position',[ 0.01 0.465    0.14    0.015],'string','File Color Indicator','HorizontalAlignment','left',...
        'fontsize',6,'fontweight','bold','backgroundcolor','w');
    set(hu,'position',[ 0.005 0.865    0.15    0.12],'backgroundcolor',[.5 .5 .5]);
    
    LGms='';
    LGms=[LGms ['<html><tr><td width=9999 align=left>']];
    LGms=[LGms ['<font color="rgb(' sprintf('%d,',int16([0 0 0])) ')"><b>'  '    LEGEND '   '</font><br>']];
    for ii=1:length(LGgstr)
        LGms=[LGms...
            ['<font color="rgb(' sprintf('%d,',int16(LGcol{ii}*255)) ')">' LGsym{ii}  ' ' LGgstr{ii} '</font><br>'] ...
            ];
        %  set(hu,'string',[...
        %['<html><tr><td width=9999 align=left>']...
        %     ['<font color="rgb(' sprintf('%d,',int16([1 1 0]*255)) ')">&#9632 '   legstr{1} '</font><br>']...
        %       ['<font color="rgb(' sprintf('%d,',int16([1 1 0]*255)) ')">&#9673 ' legstr{2} '</font><br>']...
        %    ['<font color="rgb(' sprintf('%d,',int16([1 0 1]*255)) ')">Plot3</font><br>']...
        %    ['.</font></html>']] )
    end
    LGms=[LGms ['.</font></html>']];
    set(hu,'string',LGms);
end
%---------------------


u=setticksNlines(u);
%  de2=strrep(u.fis,'_','\_');
%  dirs=strrep(u.dirs,'_','\_');
% set(gca,'ytick',[1:size(u.d,1)],'yticklabels',de2,'TickLabelInterpreter','none','fontsize',12);
% set(gca,'xtick',[1:size(u.d,2)],'xticklabels',dirs,'fontsize',6,'xaxisLocation','top','XTickLabelRotation',20);
% set(gca,'xaxisLocation','top');
% 
% vl=vline( [1:size(u.d,2)]-.5 ,'color',repmat(.8,1,3),'hittest','off');
% hl=hline( [1:size(u.d,1)]-.5 ,'color',repmat(.8,1,3),'hittest','off');
% 
% xlim([[1-.5 size(u.d,2)+.5]]); ylim([[1-.5 size(u.d,1)+.5]]);



% axis square;
% set(gca,'position',[ .01-.15 .01    0.8000    0.8000],'fontsize',5);
 axis normal;
%  set(gca,'position',[ .05 0.002    0.3000    0.8000],'fontsize',5);
%  set(gca,'position',[ .15 0.002    0.3000    0.78000],'fontsize',5);
set(gca,'position',[ .15 0.002    0.7000    0.78000],'fontsize',6);
% caxis([0 size(cmap,1)-1]);








hu=uicontrol('style','listbox','tag','ed1','units','norm','tag','msg');

msg={['THIS GUI (' mfilename '.m) IS USED TO SELECT THE FILES' ]};
msg{end+1,1}=[' see [HELP]'];
msg{end+1,1}=['..hover mouse pointer over image cell to obtain the header information'];

% set(hu,'position', [0.01 .9 .75 .1],'string',msg,'fontname','courier');
set(hu,'position', [0.16 .9 .65 .1],'string',msg,'fontname','courier');
set(hu,'max',1000,'HorizontalAlignment','left','fontsize',7,'fontweight','bold');

hu=uicontrol('style','radio','tag','rbapply','units','norm','tag','rbapply');
set(hu,'position', [0.8 .925 .2 .025],'string','select other images','fontname','courier',...
    'fontsize',6,'backgroundcolor','w','foregroundcolor','r','visible','off');

%% show interactive tooltip
hu=uicontrol('style','radio','tag','rbtooltip','units','norm','tag','rbtooltip');
set(hu,'position', [0.9 .95 .2 .025],'string','tooltip','value',0,'tooltipstring','show interactive tooltip',...
    'fontsize',6,'backgroundcolor','w','foregroundcolor','k','visible','off');

% NEXT
hu=uicontrol('style','pushbutton', 'units','norm','tag','parse');
set(hu,'position', [0.875 .5 .1 .025],'string','..send','fontweight','bold','callback',@parse,'tooltipstring','send file/folder selection to header manipulation gui');

% HELP
hu=uicontrol('style','pushbutton', 'units','norm','tag','xhelp');
set(hu,'position', [0.875 .7 .1 .025],'string','Help','fontweight','bold','callback',@xhelp,'tooltipstring','get help for this gui');

% UPDATE
hu=uicontrol('style','pushbutton', 'units','norm','tag','update');
set(hu,'position', [0.875 .676 .1 .025],'string','Update','fontweight','bold','callback',@update,'tooltipstring','update files and folders');

te=      text(1,1,'','tag','msg2','color','k','interpreter','tex',...
    'hittest','off','fontsize',7,'visible','on','fontname','courier');

        
set(gcf, 'WindowKeyPressFcn',@keys);
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn',@xmovepointer);
% set(im,'ButtonDownFcn',@selectimage);
set(im,'ButtonDownFcn',@clickcallback);


% Assign the uicontextmenu to the plot line
cmHandle = uicontextmenu;
uimenu(cmHandle,'Label','show info','callback',{@cmenu,'dispInfo'});
uimenu(cmHandle,'Label','open directory','callback',{@cmenu,'explorer'});
uimenu(cmHandle,'Label','MRICRON-show image','callback',{@cmenu,'mricron'});



% h = imellipse;
% % set all context menus for the underlying line and patch objects
% cmenu_obj = findobj(gcf,'Type','line','-or','Type','patch');
r=findobj(0,'tag','him');
set(r,'uicontextmenu',cmHandle);


% --------------------------------------------------------------------
function u=findfiles(u,fpdirs);
dirs  =strrep(fpdirs,[fileparts(fpdirs{1}) filesep],'');
de={};
fs={};
for i=1:size(dirs,1);
   k= dir(fullfile(fpdirs{i},'*.nii'));
   fs{i}={k(:).name}';
   de=[de;fs{i}];
end
de=unique(de,'rows');
d=zeros( size(de,1) ,size(dirs,1));
for i=1:size(dirs,1)
    for j=1:size(de,1)
        is=find(strcmp(fs{i},de{j}));
        if ~isempty(is)
            d(j,i)=1;
        end
    end
end

u.d=d;
u.fpdirs=fpdirs;
u.dirs  =dirs;
u.fis   =de;
u.tooltipmsg={'empty'};

function u=setticksNlines(u)
 de2=strrep(u.fis,'_','\_');
 dirs=strrep(u.dirs,'_','\_');
set(gca,'ytick',[1:size(u.d,1)],'yticklabels',de2,'TickLabelInterpreter','none','fontsize',12);
set(gca,'xtick',[1:size(u.d,2)],'xticklabels',dirs,'fontsize',6,'xaxisLocation','top','XTickLabelRotation',20);
set(gca,'xaxisLocation','top');

delete(findobj(gcf,'tag','seplines'));
vl=vline( [1:size(u.d,2)]-.5 ,'color',repmat(.8,1,3),'hittest','off','tag','seplines');
hl=hline( [1:size(u.d,1)]-.5 ,'color',repmat(.8,1,3),'hittest','off','tag','seplines');

xlim([[1-.5 size(u.d,2)+.5]]); ylim([[1-.5 size(u.d,1)+.5]]);
set(gca,'TickLabelInterpreter','tex');

 %% UPDATE % --------------------------------------------------------------------
function update(e,e2)

u=get(gcf,'userdata');
s=(findobj(0,'tag','selimg1'));
sfile=get(s,'userdata');
r=(findobj(0,'tag','selimg2'));
rfile=get(r,'userdata'); %otherwise rfile empty






him=findobj(0,'tag','him');
dat=get(him,'cdata');
[sco rco aco]=deal([]);
[sco(:,1) sco(:,2)]=find(dat==2);
[rco(:,1) rco(:,2)]=find(dat==3);
[aco(:,1) aco(:,2)]=find(dat==4);
sel={};
if ~isempty(sfile)
    [px fi ext]=fileparts(sfile);
    sel(end+1,:)=[{22} {px} {[fi ext]} ]  ;
end
if ~isempty(rfile)
    [px fi ext]=fileparts(rfile);
    sel(end+1,:)=[{33} {px} {[fi ext]} ]  ;
end
others=[
[repmat({2},size(sco,1),1) u.fpdirs(sco(:,2)), u.fis(sco(:,1))]  
[repmat({3},size(rco,1),1) u.fpdirs(rco(:,2)), u.fis(rco(:,1))]  
[repmat({4},size(aco,1),1) u.fpdirs(aco(:,2)), u.fis(aco(:,1))]  ];
sel=[sel;others];

u2=findfiles([],u.fpdirs); 
d=u2.d;
for i=1:size(sel,1)
    idir=find(strcmp(u2.fpdirs, sel{i,2}));
    ifi =find(strcmp(u2.fis   , sel{i,3}));
    val=sel{i,1};
    if val==22
        if isempty(ifi) || isempty(idir)  ;
            delete(s);
        else
            set(s,'xdata',idir);  set(s,'ydata',ifi);
        end
    elseif val==33
        if isempty(ifi)|| isempty(idir);
            delete(s);
        else
            set(r,'xdata',idir);  set(r,'ydata',ifi);
        end
    else
        if isempty(ifi)|| isempty(idir);
        else
        d(ifi,idir) =val;
        end
        
    end
end
set(him,'cdata',d);
u2=setticksNlines(u2);
set(gcf,'userdata',u2);

try
    if get(r,'ydata')>size(d,1)
        delete(r);
    end
end
try
    if get(s,'ydata')>size(d,1)
        delete(s);
    end
end


% --------------------------------------------------------------------


function cmenu(e,e2,task)

u=get(gcf,'userdata');
if strcmp(task,'explorer')
    co=get(gca,'CurrentPoint');
    co=fliplr(round(co(1,[1:2])));
    %     explorer(u.fpdirs{co(2)})
    explorerpreselect( fullfile(u.fpdirs{co(2)}, u.fis{co(1)})   )
    % file::  u.fis{co(1)}
elseif strcmp(task,'mricron')
    co=get(gca,'CurrentPoint');
    co=fliplr(round(co(1,[1:2])));
    %     explorer(u.fpdirs{co(2)})
    f1= fullfile(u.fpdirs{co(2)}, u.fis{co(1)});
    %     rmricron([],f1,[] , [2 3],[0 0])
    
    exefile=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
    if exist(exefile)==2
        mri=['!start '  exefile  ' ' f1];
        eval(mri);
    end
elseif strcmp(task,'dispInfo')
    displayStatic();
    
end






function clickcallback(obj,evt)
persistent chk
if isempty(chk)
      chk = 1;
      pause(0.4); %Add a delay to distinguish single click from a double click
      if chk == 1
%           fprintf(1,'\nI am doing a single-click.\n\n');
          selectimage([],[],'single');
          chk = [];
      end
else
      chk = [];
%       fprintf(1,'\nI am doing a double-click.\n\n');
       selectimage([],[],'double');

end



function seltoggle(e,e2,arg)
if arg==1
    set(findobj(gcf,'tag','rbapply'),'value',0);
elseif arg==2
     set(findobj(gcf,'tag','rbref'),'value',0);
end



function applymat(e,e2)

u=get(gcf,'userdata');

M1=cell2mat(cellfun(@(a){[str2num(a)]},  reshape(get(u.hmat2,'string'),[4 4])))
M2=cell2mat(cellfun(@(a){[str2num(a)]},  reshape(get(u.hmat1,'string'),[4 4])))

M3=M1*M2;
mv=M3(:);
for i=1:length(u.hmat3)
    set(u.hmat3(i),'string', mv(i));
end
matvec=spm_imatrix(M3)
for i=1:length(u.hvec1)
    set(u.hvec3(i),'string', matvec(i));
end


% function cb_rbref(e,e2)
% delete(findobj(0,'tag','selimg2' ));

function clickOntoDot(e,e2)
seltype=get(gcf,'selectiontype');

if strcmp(seltype,'normal')
    delete(e);
    % end
end




function selectimage(e,e2,click)

% seltype=get(gcf,'selectiontype');
% 

u=get(gcf,'userdata');
co=get(gca,'CurrentPoint');
seltype=get(gcf,'selectiontype');
seltype2=click;
co=fliplr(round(co(1,[1:2])));

% tclick =u.tclick;
% tclick2=toc(tclick);
% disp(tclick2);
% u.tclick=tic;
% 
% if tclick2<.3
%    disp('doubleClick');
% else
%     disp('SingleClick');
% end
% 
% 
% 
% set(gcf,'userdata',u);
% return

if strcmp(seltype,'alt'); 
    return; 
end
 

if co(1)>0 && co(2)>0   &&   co(1)<=size(u.d,1)  &&   co(2)<=size(u.d,2)
    
%     img=findobj(gcf,'type','image');
    if u.d(co(1),co(2))==1
%         if strcmp(seltype,'normal')
if strcmp(seltype2,'single')
            if get(findobj(gcf,'tag','rbapply'),'value')==0
                %delete(findobj(0,'tag','selimg1' ));
                h1=findobj(gcf,'tag','selimg1');
                
                if ~isempty(h1)
                    co2=[get(h1,'ydata') get(h1,'xdata')];
                    if co2(1)==co(1) && co2(2)==co(2)
                       % disp('sourceIMAGE selection deleted');
                        delete(h1);
%                        cdat=get(img,'cdata'); cdat(co(1),co(2))  =  u.d(co(1),co(2))*[[0]];      set(img,'cdata',cdat);

                        return
                    else
                        delete(h1);
%                         cdat=get(img,'cdata'); cdat(co(1),co(2))  =  u.d(co(1),co(2))*[[0]];      set(img,'cdata',cdat);

                    end
                end
                
                pl=plot(co(2),co(1),'ok','markerfacecolor',[0.4667    0.6745    0.1882],'tag','selimg1',...
                    'hittest','on', 'ButtonDownFcn',@clickOntoDot);
%                 cdat=get(img,'cdata'); cdat(co(1),co(2))  =  u.d(co(1),co(2))*[[2]];      set(img,'cdata',cdat);
                
                
                %te=findobj(gcf,'tag','msg2');
                 filex=fullfile( u.fpdirs{co(2)}  ,u.fis{co(1)} );
                set(pl,'userdata',filex );
                
                
                %ref and source cannot be the same
                h2=findobj(gcf,'tag','selimg2');
                if ~isempty(h2)
                    co2=[get(h2,'ydata') get(h2,'xdata')];
                    if co2(1)==co(1) && co2(2)==co(2)
                        %disp('refIMAGE selection deleted');
                        delete(h2);
                    end
                end
                
                
            else
                
                him=findobj(gcf,'tag','him');
                d=get(him,'cdata');
                if d(co(1),co(2))==2
                d(co(1),co(2)) =1;
                else
                    d(co(1),co(2)) =2;
                end
                set(him,'cdata',d);
                
            end
                
                
   elseif strcmp(seltype2,'double');%'alt')
%         elseif strcmp(seltype,'alt');%'alt')
            delete(findobj(0,'tag','selimg2' ));
            pl=plot(co(2),co(1),'or','markerfacecolor',[1 0 0],'tag','selimg2',...
                 'hittest','on', 'ButtonDownFcn',@clickOntoDot);
      
             
            
            filex=fullfile( u.fpdirs{co(2)}  ,u.fis{co(1)} );
            set(pl,'userdata',filex );
            
            %ref and source cannot be the same
            h2=findobj(gcf,'tag','selimg1');
            if ~isempty(h2)
                co2=[get(h2,'ydata') get(h2,'xdata')];
                if co2(1)==co(1) && co2(2)==co(2)
                    %disp('sourceImage selection deleted');
                    delete(h2);
                end
            %end
            
            
            
            
            end
        end
        
        
        return
        fis=fullfile(u.fpdirs{co(2)},u.fis{co(1)} );
        hm=findobj(gcf,'tag','msg');
        disp(fis);
        ha=spm_vol(fis)
        
        
        set( findobj(gcf,'tag','file'),'string',['file: ' u.fis{co(1)}]);
        set( findobj(gcf,'tag','path'),'string',['path: ' u.fpdirs{co(2)}]);
        
        mv=ha.mat(:);
        for i=1:length(u.hmat1)
            set(u.hmat1(i),'string', mv(i));
        end
        
        matvec=spm_imatrix(ha.mat)
        for i=1:length(u.hvec1)
            set(u.hvec1(i),'string', matvec(i));
        end
        
    end
        
        
   
end

function keys(e,e2)
% disp('sel');
% % disp(e)
%  disp(e2)


key=e2.Key;
try
    mod=e2.Modifier{1};
catch
    mod='';
end
    
if strcmp(key,'s')  || strcmp(key,'r') || strcmp(key,'a')  || strcmp(key,'d') || strcmp(key,'e') 
    co=get(gca,'CurrentPoint');
    co=fliplr(round(co(1,[1:2])));
    u=get(gcf,'userdata');
    him=findobj(gcf,'tag','him');
    d=get(him,'cdata');
    
 
    if     strcmp(key,'s') && isempty(mod);           d(co(1),co(2)) =u.d(co(1),co(2)).*2;
    elseif strcmp(key,'s') && strcmp(mod,'shift');    d(co(1),:    ) =u.d(co(1),:    ).*2;
        
    elseif strcmp(key,'r') && isempty(mod);           d(co(1),co(2)) =u.d(co(1),co(2)).*3;
    elseif strcmp(key,'r') && strcmp(mod,'shift');    d(co(1),:    ) =u.d(co(1),:    ).*3;
        
    elseif strcmp(key,'a') && isempty(mod);           d(co(1),co(2)) =u.d(co(1),co(2)).*4;
    elseif strcmp(key,'a') && strcmp(mod,'shift');    d(co(1),:    ) =u.d(co(1),:    ).*4;     
        
    elseif strcmp(key,'d') && isempty(mod);           d(co(1),co(2)) =u.d(co(1),co(2)).*1;
    elseif strcmp(key,'d') && strcmp(mod,'shift');    d(co(1),:)     =u.d(co(1),:    ).*1;
    elseif strcmp(key,'d') && strcmp(mod,'control');  d(:,:)         =u.d(:,:        ).*1;
        
    elseif strcmp(key,'e') && isempty(mod);   
        h1=findobj(gcf,'tag','selimg1');
        h2=findobj(gcf,'tag','selimg2');
        if ~isempty(h1) 
            d(d==2)=u.d(d==2);
            x1=[get(h1,'xdata') get(h1,'ydata')];
             d(x1(2),:) =u.d(x1(2),:).*2; 
        end
        if ~isempty(h2) 
            d(d==3)=u.d(d==3);
            x2=[get(h2,'xdata') get(h2,'ydata')];
           d(x2(2),:) =u.d(x2(2),:).*3; 
        end
        
      iother=find(sum(d==4,2));
      if ~isempty(iother)
          d(iother,:)=u.d(iother,:).*4;
      end
        
        
    end
    set(him,'cdata',d);
elseif strcmp(e2.Character,'+')
    hl=findobj(gcf,'tag','legend'); fsl=get(hl, 'fontsize');
    fs=get(gca,'fontsize');    set(gca,'fontsize', fs+1);
    set(hl, 'fontsize',fsl);
elseif strcmp(e2.Character,'-')
    hl=findobj(gcf,'tag','legend'); fsl=get(hl, 'fontsize');
    fs=get(gca,'fontsize');   if fs>2;  set(gca,'fontsize', fs-1);end
    set(hl, 'fontsize',fsl);
    
elseif strcmp(key,'i') && isempty(mod);   displayStatic       ;
elseif strcmp(key,'j') && isempty(mod);   displayStatic(1)     ;
    
elseif strcmp(key,'rightarrow') && isempty(mod);
    pos=get(gca,'position');     
    set(gca,'position',[ pos(1)+.05 pos(2) pos(3)-.05  pos(4)]);
elseif strcmp(key,'leftarrow') && isempty(mod);     
    pos=get(gca,'position');    
    set(gca,'position',[ pos(1)-.05 pos(2) pos(3)+.05  pos(4)]);
    
elseif strcmp(key,'uparrow') && isempty(mod);
    pos=get(gca,'position');     
    set(gca,'position',[ pos(1) pos(2)  pos(3)  pos(4)+.05]);
elseif strcmp(key,'downarrow') && isempty(mod);     
    pos=get(gca,'position');    
     set(gca,'position',[ pos(1) pos(2)  pos(3)  pos(4)-.05]);
        
    
end

function xmovepointer(e,e2)

if strcmp(get(gcf,'tag'),'headmanfiles')~=1; return; end
co=get(gca,'CurrentPoint');
co=fliplr(round(co(1,[1:2])));

% seltype=get(gcf,'selectiontype')
% get(gcf,'CurrentKey')

u=get(gcf,'userdata');

if co(1)>0 && co(2)>0   &&   co(1)<=size(u.d,1)  &&   co(2)<=size(u.d,2)
    % disp(co)
    if u.d(co(1),co(2))==1
%         disp(u.fpdirs{co(2)});
%         disp(u.fis{co(1)});
        fis=fullfile(u.fpdirs{co(2)},u.fis{co(1)} );
        hm=findobj(gcf,'tag','msg');
        
      
        
        %disp(fis);
        try
        ha=spm_vol(fis);
        catch
            return
        end
        size4d=size(ha,1);
        ha=ha(1);
        
        [~, mdir]= fileparts(u.fpdirs{co(2)});
        
        m={['F: ' u.fis{co(1)}      ]};
        m(end+1,1)={['D: ' mdir]};
        m(end+1,1)={[ 'DIM: [' sprintf('%d ',ha.dim) ']          4th Dim: [' sprintf('%d',size4d)    ']           dt: [' sprintf('%d ',ha.dt)  ']']};
        ms=plog([],ha.mat,0,'','plotlines=0;s=0');
        ms{1,1}(1:2)='M:';
        m=[m;ms];
        
        if strcmp(strjoin(u.tooltipmsg,','),strjoin(m,','))==1
           return 
        end
        
        u.tooltipmsg=m;
        set(gcf,'userdata',u);
       
       % m(end+1,1)={['n: ' sprintf('%d ',ha.n)   '  dt: ' sprintf('%d ',ha.dt)]};
      %  m(end+1,1)={['dt: ' sprintf('%d ',ha.dt) ]};
        
      m0=m;
      nspace=50;
      % m0=strrep(m,'_','&#x5f;')
      set(hm,'string',[...
          { [ '<HTML><pre><BODY bgcolor="blue" color="#FFFFFF"   ><font size="4">' [m0{1}(3:end) repmat(' ',[1 size(char(m),2)-length(m0{1})]) ]   '<bgcolor="red" color="#000000">' ':FILE '  '</BODY></HTML>blob']}
          {[ '<HTML><pre><BODY bgcolor="#B23F26" color="#FFFFFF"><font size="4">' [m0{2}(3:end) repmat(' ',[1 size(char(m),2)-length(m0{2})]) ] '</b>:DIR  </BODY></HTML>']}
          m0(3:end)...
          ]);
      set(hm,'fontsize',8);



%         set(hm,'string',m);
        %delete(findobj(gcf,'tag','msg2'));
        %{u.fis{co(1)}; mdir}
        
        
        te=findobj(gcf,'tag','msg2');
        
        if get(findobj(gcf,'tag','rbtooltip'),'value')==0
            set(te,'visible','off');
        else
            set(te,'visible','on');
        end
        
        
        set(te,'string',m,'position',[co(2),co(1)],'hittest','off');
        
        mh=strrep(m,'_','\_') ;
        set(te,'string', [...
            ['\fontsize{10}\bf\color[rgb]{0 0 1}'                      mh{1}                                     ]; ...
            ['\fontsize{10}\bf\color[rgb]{0.8510    0.3255    0.0980}' mh{2} '\fontsize{8}\bf\color[rgb]{0 0 0}' ]; ...
            [mh(2:end) ];...
            ]);
        
       
        set(te,'userdata',fis);
%         te=      text(co(2),co(1),m,'tag','msg2','color','k','interpreter','none',...
%             'hittest','off','fontsize',7,'visible','off');
        xl=xlim;
        yl=ylim;
        set(te,'VerticalAlignment','top');
        
        ext=get(te,'extent');
%                 disp([xl]);
%                 disp([yl]);
%                 disp(ext);
        
        px=get(te,'position');
     
        if (ext(1)+ext(3))>xl(2)
            set(te,'position',[ px(1)-((ext(1)+ext(3))-xl(2)) px(2:3)]);
        end
        
        
        
        if (ext(2)+ext(4))>yl(2)
             %set(te,'position',[ px(1) px(2)-((ext(2)+ext(4))-yl(2)) px(3)]);
            set(te,'VerticalAlignment','bottom');
        end
        
        if strcmp(get(te,'VerticalAlignment'),'bottom')
          px=get(te,'position'); px(2)=px(2)-.5;  set(te,'position',px);
        else
            px=get(te,'position'); px(2)=px(2)+.5;  set(te,'position',px);
        end
        
 
        %%-------- XTICKS-colorize
        xtl=get(gca,'XTickLabel');
        %htmls='\color{red}';
        htmls='\fontsize{10}\bf\color[rgb]{0.8510    0.3255    0.0980}';
        xtl=strrep(xtl,htmls,'');
        xtl{co(2)} = [htmls xtl{co(2)}];
        set(gca,'XTickLabel',xtl);
        
        %%-------- YTICKS-colorize
        ytl=get(gca,'YTickLabel');
        %htmls='\color{red}';
        htmls='\fontsize{10}\bf\color[rgb]{0 0 1}';
        ytl=strrep(ytl,htmls,'');
        ytl{co(1)} = [htmls ytl{co(1)}];
        set(gca,'yTickLabel',ytl);
        
        set(gca,'TickLabelInterpreter','tex');
        
        
        
        drawnow;
    else
        fis=['-'];
        %disp(fis);
        hm=findobj(gcf,'tag','msg');
        set(hm,'string','-');
       %  delete(findobj(gcf,'tag','msg2'));
         te=findobj(gcf,'tag','msg2');;
         set(te,'string','','hittest','off','userdata','');
    end
    
end

function clearlbvolinfo(e,e2)
hu=findobj(0,'tag','lb_volinfo');
set(hu,'string',{});

function displayStatic(arg)


u=get(gcf,'userdata');
if strcmp(get(gcf,'tag'),'headmanfiles')~=1; return; end
co=get(gca,'CurrentPoint');
cox=fliplr(round(co(1,[1:2])));
multi=0;
if  exist('arg')==1
    multi=1;
    v=[1:size(u.d,2)]';
    cox=[repmat(cox(1),[length(v) 1]) v];
end

% seltype=get(gcf,'selectiontype')
% get(gcf,'CurrentKey')



for ii=1:size(cox,1)
    co=cox(ii,:);
    if co(1)>0 && co(2)>0   &&   co(1)<=size(u.d,1)  &&   co(2)<=size(u.d,2)
        % disp(co)
        if u.d(co(1),co(2))==1
            %         disp(u.fpdirs{co(2)});
            %         disp(u.fis{co(1)});
            fis=fullfile(u.fpdirs{co(2)},u.fis{co(1)} );
            hm=findobj(gcf,'tag','msg');
            %disp(fis);
            
            ha=spm_vol(fis);
            size4d=size(ha,1);
            ha=ha(1);
            
            [~, mdir]= fileparts(u.fpdirs{co(2)});
            
            m={['F: ' u.fis{co(1)}      ]};
        m(end+1,1)={['D: ' mdir]};
        m(end+1,1)={[ 'DIM: [' sprintf('%d ',ha.dim) ']          4th Dim: [' sprintf('%d',size4d)    ']           dt: [' sprintf('%d ',ha.dt)  ']']};
        ms=plog([],ha.mat,0,'','plotlines=0;s=0');
        ms{1,1}(1:2)='M:';
        m=[m;ms];
        
        hf=findobj(0,'tag','volinfo');
       
        
        if isempty(hf)
            hf=figure;
            set(hf,'units','normalized','menubar','none','name','HDR INFO','NumberTitle','off'  );
            u.n=1;
            u.pos=[  0.6163    0.8250    0.3000    0.1111];
            set(hf,'userdata',u);
            hu=uicontrol('style','listbox','units','norm','tag','lb_volinfo');
            set(hu,'position', [0 0 1 1],'string',{' '},'fontname','courier');
            set(hf,'position',u.pos,'tag','volinfo');
            
            
            hp=uicontrol('style','pushbutton','units','norm','string','c','tag','pb_clear_volinfo');
            set(hp,'position', [0.86 0 .1 .1  ],'string','clear','fontname','courier','callback',@clearlbvolinfo,'units','pixels');
        else
            
            hu=findobj(0,'tag','lb_volinfo');
            u=get(hf,'userdata');
            u.n=u.n+1;;
             set(hf,'userdata',u);
        end
        
        if u.n>=2 && u.n<5
            pos=u.pos;
            posx=get(hf,'position');
            pos([1 3])=posx([1 3]);
            pos2=pos;
            pos2(4)=u.n*pos(4);
            
            pos2(2)=pos(2)-pos2(4);
            set(hf,'position',pos2);
        end
%         if isempty(get(findobj(0,'tag','volinfo'),'position'))
%             set(hf,'position',[ 0.6163    0.8361    0.3160    0.0978],'tag','volinfo');
%             hu=findobj(0,'tag','lb_volinfo');
%         else
%             hfigs=findobj(0,'tag','volinfo');
%             
%             pos=get(findobj(0,'tag','volinfo'),'position');
%             if iscell(pos)
%                 pos=cell2mat(pos);
%                 pos=pos(find(pos(:,2)==min(pos(:,2))),:);
%             end
%             set(hf,'position',[  pos([1]) pos(2)-pos(4)  pos([3:4]) ],'tag','volinfo');
%         end
        
       
                
        m0=m;
        nspace=50;
        % m0=strrep(m,'_','&#x5f;')
        mnew=[...%<font size="6">
            { [ '<HTML><pre><BODY bgcolor="blue" color="#FFFFFF"><font size="4">' [m0{1}(3:end) repmat(' ',[1 size(char(m),2)-length(m0{1})]) ]   '<bgcolor="red" color="#000000">' ':FILE '  '</BODY></HTML>blob']}
            {[ '<HTML><pre><BODY bgcolor="#B23F26" color="#FFFFFF"><font size="4">' [m0{2}(3:end) repmat(' ',[1 size(char(m),2)-length(m0{2})]) ] '</b>:DIR  </BODY></HTML>']}
            m0(3:end)...
            ];
        mold=get(hu,'string');
        mtot=[mold;mnew];
        set(hu,'string',[mtot ]);
        set(hu,'fontsize',8);
        set(hu,'value',size(mtot,1));
        
        
    end
end
end
figure(findobj(0,'tag','headmanfiles'));


function parse(e,e2)

h1=findobj(gcf,'tag','selimg1');
if isempty(h1); 
%     disp('no source image selected')
%     return; 
else
    ims{1,1}=get(h1,'userdata');
end



% disp(char(ims))
% return

h2=findobj(gcf,'tag','selimg2');
if ~isempty(h2)
    ims{2,1}=get(h2,'userdata');
end

% other IMG
u=get(gcf,'userdata');
him=findobj(gcf,'tag','him');
d=get(him,'cdata');




[x y]=find(d==2); % source

if isempty(x) && isempty(h1)            % ## CHECK WHETHER SOURCE EXISTS
    disp('no sources selected');
    return
end


% [get(h1,'ydata') get(h1,'xdata')];
%% ADD SOURCE
if ~isempty(h1)
    if isempty(find(x==get(h1,'ydata') & y==get(h1,'xdata')))
        x=[ get(h1,'ydata') ;x];
        y=[ get(h1,'xdata') ;y];
    end
end

if ~isempty(h2)
    d(get(h2,'ydata') , get(h2,'xdata') ) = 3;
end

ls={};
appimg='';
for i=1:length(x)
    si= x(i);
    ri=find(d(:,y(i))==3);
    ai=find(d(:,y(i))==4);
    px=u.fpdirs{y(i)};
    
    [s0 r0 a0] =deal('');
    if ~isempty(si);    s0=fullfile(px,u.fis{si}); end
    if ~isempty(ri);    r0=fullfile(px,u.fis{ri}); end
    if ~isempty(ai);
        a0=stradd(u.fis(ai),[px filesep],1);
    end
   ls(end+1,:) ={s0 r0 a0};
end

 
p.list=ls;
xheadman('setimage',p);


return


hu=uicontrol('style','listbox','tag','lb1','units','norm')
set(hu,'position', [0 0 .3 .9 ],'string',dirs,'fontsize',7,'callback',@getfiles);

hu=uicontrol('style','listbox','tag','lb2','units','norm')
set(hu,'position', [.3 0 .3 .9 ],'string','','fontsize',7,'callback',@getinfo);

u.fpdirs=fpdirs;
u.dirs=dirs;
set(f,'userdata',u);
hgfeval(get(findobj(gcf,'tag','lb1'),'callback'));
hgfeval(get(findobj(gcf,'tag','lb2'),'callback'));
function getfiles(e,e2)
u=get(gcf,'userdata');
lb1=findobj(gcf,'tag','lb1');

dirx=u.fpdirs(get(lb1,'value'));
[tb tbh v]=antcb('getuniquefiles',dirx);

lb2=findobj(gcf,'tag','lb2');
set(lb2,'string',tb(:,1));
hgfeval(get(findobj(gcf,'tag','lb2'),'callback'));


function getinfo(e,e2)

u=get(gcf,'userdata');
lb1=findobj(gcf,'tag','lb1');
va=get(lb1,'value');
dirx=u.fpdirs{va};

lb2=findobj(gcf,'tag','lb2');
fi=get(lb2,'string');
va=get(lb2,'value');
if va>size(fi,1)
    va=size(fi,1);
    set(lb2,'value',va)
end
fi=fi{get(lb2,'value')};
fi=fullfile(dirx,fi);

h=spm_vol(fi);
disp(h);
disp(h.mat);


function xhelp(e,e2)
uhelp(mfilename);
figure(findobj(0,'tag','uhelp'));

function prepimg2


f=figure;
set(f,'units','normalized','menubar','none','tag',mfilename,'color','w');
set(f,'position',[ 0.5066    0.0433    0.4913    0.9206]);%[  0.0132    0.4100    0.9656    0.4667]);
% 0    0.0333    1.0000    0.9417



 

hu=uicontrol('style','text','tag','msg_ref','units','norm');
set(hu,'position', [.01 0.98 .5 .02 ],'string','SOURCE: -','HorizontalAlignment','left','backgroundcolor','w');

hu=uicontrol('style','text','tag','msg_ref','units','norm');
set(hu,'position', [.501 0.98 .5 .02 ],'string','REF: -','HorizontalAlignment','left','backgroundcolor','w');



%••••••••••••••••••• A 1••••••••••••••••••••••••••••••••
u.hm1=[];
pos=[ .01 .85 .05 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
       u.hm1(end+1)=hu;
       %pause(.1)
    end
end

u.hm2=[];
pos=[ .5 .85 .05 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
       u.hm2(end+1)=hu;
       pause(.1)
    end
end



delete(u.hm1)



u.hvec1=[];
pos=[ .8 .85 .035 .035];
parm={'Transl' 'Rotat.' 'VoxSiz.' 'Scaling'};
 for i=1:4
     for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
       % set(hu,'string',[num2str(i) '-' num2str(j)]);
       u.hvec1(end+1)=hu;
       
       if j==1
           hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold');
           set(hl,'position',[pos(1)+pos(3)*j-pos(3)-0.04  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
           set(hl,'HorizontalAlignment','right');
       end
   
    end
 end
%•••••••••••••••••••••A2••••••••••••••••••••••••••••••
 
 mat2=eye(4); mat2=mat2(:)
 
 u.hmat2=[];
 pos=[ .6 .65 .035 .035];
 n=1;
 for j=1:4
     for i=1:4
         hu=uicontrol('style','edit','tag','w','units','norm','string','','foregroundcolor','b');
         set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
         set(hu,'callback',@applymat);
         set(hu,'string',[num2str(mat2(n))  ]);
         n=n+1;
         u.hmat2(end+1)=hu;
        
     end
 end

 %••••••••••••••••••• A 3••••••••••••••••••••••••••••••••
u.hmat3=[];
pos=[ .6 .45 .035 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
       u.hmat3(end+1)=hu;
       pause(.1)
    end
end


u.hvec3=[];
pos=[ .8 .45 .035 .035];
parm={'Transl' 'Rotat.' 'VoxSiz.' 'Scaling'};
 for i=1:4
     for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
       % set(hu,'string',[num2str(i) '-' num2str(j)]);
       u.hvec3(end+1)=hu;
       
       if j==1
           hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold');
           set(hl,'position',[pos(1)+pos(3)*j-pos(3)-0.04  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
           set(hl,'HorizontalAlignment','right');
            pause(.1)
       end
   
    end
 end
 
 




