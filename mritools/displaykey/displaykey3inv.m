
% #wb   MANUAL REGISTRATION (displaykey3inv.m)
% This UI is can be used to manually register two images. The graphics window shows an overlay of 
% two images. If you click into one of the three orthogonal panels the overlayed image disappear 
% for a short moment (This is a way to compare the registration of the two images).
% The mouse click also updates the three overlays w.r.t the clicked position.
% -------------------------------------------------------------------------------------------------
%  #wg |   STEPS OF MANUAL REGISTRATION    |
% 1) select optimal orientationtype from "previous/other Orientations" pulldown-menu    (see below)
% 2) rotate/translate image using icon panels/shortcuts to register images (see below)
% 3) if image is finally #r in register, click #wr [reorient TPMs] #n -from right pull down menu
%   #r Don't forget this step! #n The [reorient TPMs] pulldown will become inactive afterwards 
%  (grayed). 
% 4) hit #r [END] #n -button to close the UI
% 5) #g Please wait a moment #k , sometimes closing the window can take some seconds. 
%
% image rotation/translation via: 
%     (1) edit fields: right, forward, up, pitch roll, yaw
%     (2) icon-panels above each of the 3 orthogonal views
%     (3) shortcuts: rotations:   y/p/r  &  [shift]+y/p/r
%                    translations:  left/right/up/down , [shift+up/down]
% 
%  #wg   Edit fields, panel icons and shortcuts   
% The aim is to register both images manually. For this you may use:
% 1) Edit fields: right, forward, up, pitch, roll and yaw. These edit fields will be also updated
%   when using the respective shortcuts or icons (from icon panels on top of the overlay panels). 
%   Drawback: changing the values via edit controls is really painstaking.
% 2) icon panels: Each image panel is associated with the respective translation (left,right,up/down
%    arrow) and rotation (clock & anticlockwise) icons.
%    The step-size for translation & rotation (edit fields) and a hand-icon to reposition the icon
%    panel. 
% 3) shortcuts:  #b type 'h' in the UI to get list of all keyboard shortcuts
%  ‘up’/’down’ arrow keys          - move foreground(fg)-image (green) up/down (best observed in 1st and 2rd panel)
%  ‘left’/’right’ arrow keys       - move fg-image (green) left/right (best observed in 1st and 3rd panel)
%  shift+‘up’/’down’ arrow keys    - move fg-image (green) inward/outward (best observed in 2nd and 3rd panel)
%  ‘p’ and shift+‘p’               - change pitch-rotation .. clock & anticlockwise
%  ‘r’ and shift+‘r’               - change roll-rotation .. clock & anticlockwise
%  ‘y’ and shift+‘y’               - change yaw-rotation .. clock & anticlockwise
% 
%  The edit fields will be updated each time the translation and rotation icons or shortcuts will be activated
%  Other shortcuts    
%  +/-               - increase/decrease the transparency of the foreground image (green)
%  "#"                 - show/hide red contour plot of the foreground image (green)
% space              - toggle step-size of translation and rotation (two states: large vs. small step-size)
%  F1                - change step-size of translation and rotation via GUI
%  F2, F3, F4        - different toggles to show/hide the foreground/background-image
% 
%  #wg   previous/other Orientations (pulldown-menu)   
% From the pull-down menu (below the overlays) select one of the predefined orientation types and
% check whether at least the orientation of target and source images matches. Inspect all other 
% orientation types from the pull-down menu (once the pull-down has the focus: 
% use up/down arrow keys to change the orientation type). 
% Previous rigid registration attempts also appear in the pull-down menu. Use one of the available
% orientation types or orientation types estimated from previous registrations to constrain the variability 
% in rotation and translation parameters.
% 
% #ol ...  Troubleshooting  ...   
% 1) #b Image is not seen/I see only some pixels: #n Select "Full Volume" from the pulldown menu left to 
% "hide Crosshairs" (if necessary click into one of the image panels afterwards to update the overlay).
% 
% #wb  ...  COMAND LINE   ...
%% 30.05:    displaykey3inv(  refIMG ,t2,1); %
%% [1] manually reorient img1 tp img2 (GUI)
% img1  :sourceIMG (to be transformed)-->BUT ON TOP (overlayed)
% img2  : refIMG-->STATIC IMAGE
% modality: (optional): [0/1] no wait/wait to until button is pressed
%% [2] automatic reorient: <requensted> the paramterfile as addit. input
% example  displaykey3inv(  refIMG ,t2,0,  struct('parafile', which('trafoeuler.txt') ) );
%% EXAMPLES
%          displaykey3inv(  refIMG ,t2,0); %without option to AUTOrotate
%         displaykey3inv(  refIMG ,t2,0,  struct('parafile', which('trafoeuler.txt') ) ); %with option to autorotate

% displaykey3inv('O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x\_b1grey.nii',t2,0); %shoenso

%% with screencapture
%% example  displaykey3inv( refIMG ,t2,0,struct('parafile',which('trafoeuler.txt'),'screencapture',   fullfile(fileparts(t2),'coreg.jpg')     ) );
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%———————————————————————————————————————————————
%%   use as default+parse bvec
%———————————————————————————————————————————————
% o.getbvec=1 ;% but parse bvec
% o.addautoregister=0;o.addpreviousorients=0; o.addsetzero=0;o.addreorientTPM=0; %show not these buttons(autoreg,prevorients,setsero,reorientTPM)
% dowait=1
% f1a='O:\data\karina\komish\tpm_2_T2_ax_mousebrain_1.nii'
% f2a'='O:\data\karina\komish\tpm_MSME-T2-map_20slices_1.nii'
% a=displaykey3inv( f2a ,f1a ,dowait,o)

function out=displaykey3inv(img1,img2,modality,  otherparams  )

fprintf(['..loading gui (wait)...']); 
out=[];

dum=img2;
img2=img1;
img1=dum;

try; clear global aux ; end
global aux; aux=[];


try; aux=otherparams;  catch; aux=[];end   %cell of other parameters
aux.img1=img2;
aux.img2=img1;
aux.pwd =pwd;
aux.initialzoomValue=1  ;%set zoomvalue of pulldownMenue to 'Full Volume'


% reorient 1st Image to 2nd image
% img1='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c1s20150908_FK_C1M02_1_3_1.nii,1';
% img2='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c3s20150908_FK_C1M02_1_3_1.nii'
% displaykey2(img1,img2)
% img1='C:\spm8_30apr15\spm8\canonical\single_subj_T1.nii'
% img2='C:\spm8_30apr15\spm8\tpm\grey.nii'
% displaykey2(img1,img2)


if strcmp(spm('Ver'),'SPM12')% use old function
    cd(fullfile(fileparts(which('ant.m')),'spm8functions','private'));
    
 
end


if exist('modality')~=1; modality=0; end   %[0/1] no wait/wait to finish



matlabbatch={};
matlabbatch{1}.spm.util.disp.data = {img1};
% spm_jobman('run',matlabbatch);
  evalc(['spm_jobman(''run'',matlabbatch)']);
  delete(findobj(gcf,'tag','Menu'));delete(findobj(gcf,'tag','Interactive'));
displaykey(2);%without SPMhook

% SET PULLDOWN TO FULL-VOLUME 
hfg=findobj(0,'tag','Graphics');
hzo=findobj(hfg,'tooltipstring','zoom in by different amounts');
ifullvolume=find(strcmp(get(hzo,'string'),'Full Volume'));
set(hzo,'value',ifullvolume);
spm_image('zoom');
spm_orthviews2('Redraw');


%% set graphicsWindow to left
hfig=findobj(0,'tag','Graphics');
unit=get(hfig,'units');
set(hfig,'units','norm');
set(hfig,'position',[  0.090    0.0344    0.3934    0.9078]);
set(hfig,'units',unit);
  
set(hfig, 'CloseRequestFcn', @go2oldpath)



% v='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c3s20150908_FK_C1M02_1_3_1.nii'
%% keyboard
if ~isempty(img2)
    keyb('ovl',img2)
end

%% add reortientIMages-TxtFile

hfigg    =findobj(0,'tag','Graphics');
hbut =findobj(hfigg,'string','Reorient images...');
if isempty(hbut) % SPM12
  hbut =findobj(hfigg,'string','Reorient...');  
end
iptaddcallback(hbut, 'Callback', @writeTXTfile);


% set(hfigg,'WindowButtonUpFcn','12000')
% iptaddcallback(hfigg, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
% iptaddcallback(hfigg, 'Callback', 'spm_orthviews2(''Redraw'')');

for i=1:9
    hed= findobj(gcf,'callback',['spm_image(''repos'','   num2str(i) ')']);
    set(hed,'keypressfcn', @key4editfield);
    % iptaddcallback(hed, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
    % iptaddcallback(hed, 'Callback', 'spm_orthviews2(''Redraw'')');
end
%spm_orthviews('context_menu','orientation',3);
%  spm_orthviews2('Redraw')

hreorintbutt=findobj(gcf,'string','Reorient images...');
if isempty(hreorintbutt) % SPM12
  hreorintbutt =findobj(hfigg,'string','Reorient...');  
end
iptaddcallback(hreorintbutt, 'Callback', @addinfo);

if exist('otherparams')==0; otherparams=struct(); end

  
    
shows.addhelp            = 1;
shows.addinfo            = 1;
shows.addautoregister    = 0;
shows.addpreviousorients = 1;
shows.addsetzero         = 1;
shows.addreorientTPM     = 1;
shows.addreorientIMG     = 0; %GUI REORIENT IMAGS


if isfield(otherparams,'addinfo');
    shows.addinfo=otherparams.addinfo;
end
if isfield(otherparams,'addautoregister');
    shows.addautoregister=otherparams.addautoregister;
end
if isfield(otherparams,'addpreviousorients');
    shows.addpreviousorients=otherparams.addpreviousorients;
end
if isfield(otherparams,'addsetzero');
    shows.addsetzero=otherparams.addsetzero;
end
if isfield(otherparams,'addreorientTPM');
    shows.addreorientTPM=otherparams.addreorientTPM;
end

if isfield(otherparams,'addreorientIMG');
    shows.addreorientIMG=otherparams.addreorientIMG;
end

if shows.addinfo==1;              addhelp;              end
if shows.addinfo==1;              addinfo;              end
if shows.addautoregister==1;      addautoregister;      end
if shows.addpreviousorients==1;   addpreviousorients;   end
if shows.addsetzero==1;           addsetzero;           end
if shows.addreorientTPM==1;       addreorientTPM;       end
if shows.addreorientIMG==1;       addreorientIMG;       end




% addinfo;
% addautoregister
% addpreviousorients;
% addsetzero;
% addreorientTPM;

% if modality==1
addmodality
iptaddcallback(hreorintbutt, 'Callback', @addmodality);
% end



%% fontsize
fs=8;
set(findobj(gcf,'style','pushbutton'),'fontsize',fs);
set(findobj(gcf,'tag','popup2'),'fontsize',fs);
set(findobj(gcf,'tag','text1'),'fontsize',fs-1);

%% force specific rotation from Table
if isfield(aux,'orientType')
    hrot=findobj(gcf,'tag','popup2');
    if ~isnumeric(aux.orientType);
        rots= get(hrot,'string');
        iuser=regexpi2(rots,'user)'); %find user
        if ~isempty(iuser)
            set(hrot,'value',iuser);
        end
        
%         [arg,rot0]=evalc(['' 'findrotation2' '']);
%         rots2=[rots(1:length(rot0)); ['user) ' aux.orientType ]; rots(length(rot0)+1:end) ];
%         set(hrot,'string',rots2);
%         set(hrot,'value',length(rot0)+1);
        
    else
        if aux.orientType>length(regexpi2(get(hrot,'string'),'^\d+)')); return; end
        if aux.orientType<1; return; end
        disp([' .. setting predefined orientation to orientType=' num2str(aux.orientType)]);
        set(hrot,'value',aux.orientType)
    end
    
    hgfeval({get(hrot,'callback'),hrot});
end



% SET PULLDOWN TO FULL-VOLUME 
hfg=findobj(0,'tag','Graphics');
hzo=findobj(hfg,'tooltipstring','zoom in by different amounts');
ifullvolume=find(strcmp(get(hzo,'string'),'Full Volume'));
set(hzo,'value',ifullvolume);
spm_image('zoom');
spm_orthviews2('Redraw');




iconpannel4spm; %iconbanner
drawnow;
fprintf(['done\n']);


%% modality
if modality==1
%     return
     uiwait(gcf);
     
     global aux
     cd(aux.pwd);
end


global aux
screencapturing();


try
    out=aux.out;
end
% close(findobj(gcf,'tag','Graphics'))
if modality==1
    if isfield(otherparams,'close')==1
        shows.close=otherparams.close;
    else
        shows.close=1;
    end
    
    if shows.close==1;
        try; delete(findobj(gcf,'tag','Graphics')); end
    end
end

%%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function go2oldpath(e,e2)
global aux;
cd(aux.pwd);
 set(gcf,  'CloseRequestFcn', 'closereq');


function screencapturing
global aux
%% screencapure before closing
if isfield(aux,'screencapture')
    if ~isempty(aux.screencapture)
        try
        f=getframe(gcf);
         [X,Map]=frame2im(f);
        imwrite(X,aux.screencapture);
        end
%         try; screencapture(gcf,[],  aux.screencapture );  end  % capture the entire figure into file
    end
end


function closeFigure(ra,ro)
global aux
aux.out=[];
%% screencapure before closing
screencapturing();


% % % if isfield(aux,'screencapture')
% % %     if ~isempty(aux.screencapture)
% % %         try
% % %         f=getframe(gcf);
% % %          [X,Map]=frame2im(f);
% % %         imwrite(X,aux.screencapture);
% % %         end
% % % %         try; screencapture(gcf,[],  aux.screencapture );  end  % capture the entire figure into file
% % %     end
% % % end

if isfield(aux,'getbvec')
    if aux.getbvec==1
      
        for i=1:9
            hd =findobj(gcf,'callback',['spm_image(''repos'','   num2str(i) ')']);
            bv(i,1)=str2num(get(hd,'string'));
        end
        aux.out=bv;
    end
    
end

uiresume(gcf);

function addinfo(ra,ro)
global aux
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');

[pa1 fi1 ext1]=fileparts(aux.img1);
[pa2 fi2 ext2]=fileparts(aux.img2);

[~, pa22]=fileparts(pa2)  ;

infos={};
% infos{end+1,1}=[ 'path:    '      pa22             ];
% infos{end+1,1}=[ 'grey:    ' [fi2 ext2  ] ];
% infos{end+1,1}=[ 'green: '  [fi1 ext1   ]  ];
% infos{end+1,1}=[ '<HTML><FONT color="red" size="+2">Large red font</FONT></HTML>' ];
infos{end+1,1}=['<html>..PATH:   <font style="font-family:verdana;color:blue;size:+2"><i>' [pa22 ]    '   </html>' ];
infos{end+1,1}=['<html>..BACK:      <font style="font-family:verdana;color:gray"><i>' [fi2 ext2   ]    '   </html>' ];
infos{end+1,1}=['<html>FRONT:      <font style="font-family:verdana sans;color:green"><i>' [fi1 ext1   ]    '   </html>' ];


infos{end+1,1}=['*** INFOS ***'];
infos{end+1,1}=['- type [h]: for HOTKEYS help menu'];
infos{end+1,1}=['- use [Reorient Images] Button to apply transformation to images (GUI) '];
infos{end+1,1}=['- click [END] after reorienting TPMs '];

ed=uicontrol('Style', 'list',...
    'String', infos,'units','normalized',...
    'Position',[.60 .45 .4 .15],'max',100  ,'tag','list1');
set(ed,'fontsize',9,'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
% set(ed,'fontname','monospaced','fontweight','bold','fontsize',12);
% set(ed,'tooltip',infos)

set(hfigg,'units',units);

% %%%%%%%%%%%%%%%%
function helpx(ra,ro)

 hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
 a=keylisthelp;
 hlp=[hlp; a];
 uhelp(hlp,1);
 % uhelp(hlp,1,'position',[0.4976    0.3900    0.4951    0.5533]);


function addhelp(ra,ro)

hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
    'String', 'HELP','units','normalized','callback',@helpx,...
    'Position',[.1 0.405 .1 .022],'fontweight','bold','fontsize',9,'tag','helpx',...
    'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','get help');
set(hfigg,'units',units);


%     global aux
% hfigg=gcf;
% units=get(hfigg,'units');
% set(hfigg,'units','normalized');
%
% [pa1 fi1 ext1]=fileparts(aux.img1);
% [pa2 fi2 ext2]=fileparts(aux.img2);
%
% infos={};
% infos{end+1,1}=[ 'path: ' pa2 ];
% infos{end+1,1}=[ 'grey    : ' [fi2 ext2  ] ];
% infos{end+1,1}=[ 'green : '  [fi1 ext1   ]  ];
%
%
% delete(ed)
% ed=uicontrol('Style', 'text',...
%            'String', infos,'units','normalized',...
%            'Position',[.6  .1 .8 .05],'max',100);
% set(ed,'fontsize',14,'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
% set(ed,'fontname','monospaced','fontweight','bold','fontsize',10);
%
%
%
% set(hfigg,'units',units);


function addreorientIMG  %REORIENT BUTTON
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton','tag','pb_reorientIMG',...
    'String', 'reorient images (GUI)',...
    'units','normalized','callback',@reorientIMG,...
    'Position',[.75 0.405 .2 .022],'fontweight','bold','fontsize',7,...
    'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','select images here to reorient');
set(hfigg,'units',units);



function addreorientTPM  %REORIENT BUTTON
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'popup','tag','popup1',...
    'String', 'Reorient TPM | reorient other images (GUI)',...
    'units','normalized','callback',@reorientTPM,...
    'Position',[.8 0.405 .14 .022],'fontweight','bold','fontsize',9,...
    'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','reorient TPMs');
set(hfigg,'units',units);


function addautoregister(ra,ro) %AUTOREG BUTTON
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
    'String', 'AUTOREG','units','normalized','callback',@runautoreg,...
    'Position',[.7 0.405 .1 .022],'fontweight','bold','fontsize',9,'tag','autoregister',...
    'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','get rough orientation');
set(hfigg,'units',units);


function addmodality(ra,ro) %END BUTTON
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',     'String', 'END','units','normalized','fontsize',9);
set(pb,'position', [.3 0.405 .1 .022],'backgroundcolor',[0 .8 0],'callback',@closeFigure);
set(hfigg,'units',units);

function addsetzero(ra,ro) %setZERO BUTTON
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
    'String', 'set Zeros','units','normalized','callback',@setzero,...
    'Position',[.4 0.405 .1 .022],'fontweight','bold','fontsize',9,...
    'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','set all Transition and Rotation Paras to Zero');
set(hfigg,'units',units);


function addpreviousorients(ra,ro) %previous orientationMATS
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'popup',  'tag','popup2',   'String', 'END_aswderderfgtfredsseers|start','units','normalized');
set(pb,'position', [.5 .395 .2 .03],'backgroundcolor',[1 1 1],'callback',@setotherorientsmat);





% r    =spm_imatrix(inv(M))  ;%[r]==spm-eingabe 
% M2=inv(spm_matrix(r))   % spmMatrix from vector -->this is saved in defs.mat

tb=findrotation2();
% tb={...
%     'pi/2 pi pi'%berlin-->ALLEN
%     '0 0 0'
%     '0 pi 0'
%     '0 0 pi'
%     'pi/2 0 pi'  ;%FB
%     'pi/2 0 0'  ;%berlin
%     'pi pi/2 pi'
%     'pi pi pi/2'
%    };

% OPT-1) ORIENTATION FROM TABLE ---------------------------------------------
mats={};
for i=1:size(tb,1)
    bvec=[   [0 0 0    str2num(tb{i})   ]  1 1 1 0 0 0];  %wenig slices
   % M2=inv(spm_matrix(bvec))  
   mats(end+1,:)={bvec tb{i}};
end
matsinfo=mats;
matsinfo(:,2)=cellfun(@(a,b){[ num2str(b) ') ' a]},mats(:,2),num2cell([1:size(mats,1)]'));


% OPT-2) %USERDEFINDE VIA STRING ---------------------------------------------
global aux
if isfield(aux,'orientType')
    if ~isnumeric(aux.orientType);
        bvec    =[   [0 0 0    str2num(aux.orientType)   ]  1 1 1 0 0 0];
        bvecinfo1= [ char(aux.orientType)];
        bvecinfo2= [ 'user) '  char(aux.orientType)];
        mats(end+1,:)     =     {bvec bvecinfo1};
        matsinfo(end+1,:) =     {bvec bvecinfo2};
    end
end
% OPT-3) %HISTORY ---------------------------------------------
try
    global st;
    t2=st.vols{1}.fname;
    gm=st.overlay.fname;
    [pa fi ext]=fileparts(t2);
    load(fullfile(pa,'defs'));
    mats0={};
    for i=1:size(defs.reorientmats,1)
        M2=defs.reorientmats{i,1};
        mats0(end+1,:)={spm_imatrix(inv(M2))      defs.reorientmats{i,2}  };
    end
    mats=[ mats;mats0];
    matsinfo=[matsinfo; mats0];
end

% OPT-4) interactive user input---------------------------------------------

mats(end+1,:)={[] ,' *** user input (6 values: x,y,z,pitch,roll,yaw as vecor)'};
matsinfo(end+1,:)=mats(end,:);
global aux
aux.mats=mats;
set(pb,'string',matsinfo(:,2),'fontsize',12);


% ----
% delete(htx)
htx=uicontrol('Style', 'text',     'String', 'prev./other REORIENT','units','normalized','tag','text1');
set(htx,'position', [.5 .42 .21 .018],'backgroundcolor',[1 1 1],'fontsize',9,'fontweight','bold',...
    'tooltip','set previously applied REORIENTATIONS on this mouse or use other reorientMATS');
% -------

set(hfigg,'units',units);
%•••••••••••••••••••••••••••• functions •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


function setotherorientsmat (h,e) %from TABLE (pi-table and previously saved reorientMAT)
global aux;
id=get(h,'value');

%userINPUT
if ~isempty(strfind(aux.mats{id,2},'input'))
    q = inputdlg(' Translation+Rotationparameters: 6 values: x,y,z,pitch,roll,yaw as vecor)________________________________________ ','REORIENTATION',1,{''});
    
    try
        if length(str2num(char(q)))==6
            mat=str2num(char(q));
        else
            return
        end
    catch
        return
    end
else
    mat=aux.mats{id,1}(1:6);
    
    if isempty(regexpi(aux.mats{id,2},'-')) % original. Possible rots
        trafo2   =[mat 1 1 1 0 0 0];
        trafoinv=spm_imatrix(inv(spm_matrix(trafo2)))    ;
        mat=trafoinv(1:6);
    end
    
    
end




hfig=findobj(0,'tag','Graphics');
set(0,'currentfigure',hfig);
for i=1:6
    ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
    set(hfig,'CurrentObject',ex  );
    set(ex,'string',num2str(mat(i)) );
    hgfeval(get(ex,'callback'));
end
spm_orthviews('context_menu','orientation',3);
spm_orthviews2('Redraw');




function reorientIMG(h,e)
global st;
t2=st.vols{1}.fname;
gm=st.overlay.fname;
[pa fi ext]=fileparts(t2);
    prefdir=pa;
    [files,sts] = cfg_getfile2(inf,'any',{'TASK:  select images to reorient' ...
        'NOTE:- the reorientation matrix is applied to these images ',...
        '    -the correct path is determined automatically'},[],prefdir,'img|nii');
    files=cellstr(files);
if isempty(files{1})     return          ;end

hfig=findobj(0,'tag','Graphics');
Bvec=[];
for i=1:9
    hed= findobj(hfig,'callback',['spm_image(''repos'','   num2str(i) ')']);
    Bvec(1,i)=str2num(get(hed,'string'));
    % iptaddcallback(hed, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
    % iptaddcallback(hed, 'Callback', 'spm_orthviews2(''Redraw'')');
end
predef=[Bvec [0 0 0]];
% fsetorigin(files, predef);  %ANA
fsetorigin(files,   spm_imatrix(inv(spm_matrix(predef)))    );
%  displaykey2(gm,t2)
disp('...images reoriented [done]');




function reorientTPM(h,e)
global st;
t2=st.vols{1}.fname;
gm=st.overlay.fname;
[pa fi ext]=fileparts(t2);

if get(h,'value')==1
    files={fullfile(pa, '_b1grey.nii') ; fullfile(pa, '_b2white.nii') ; fullfile(pa, '_b3csf.nii')};
    set(h,'enable','off','tooltip','already reoriented');
elseif get(h,'value')==2;
    prefdir=pa;
    [files,sts] = cfg_getfile2(inf,'any',{'TASK:  select all images to reorient' ...
        'NOTE:- ALL 3 TPMS (gray/white/CSF) MUST BE SELECTED !!!!! ',...
        '    -the correct path is determined automatically'},[],prefdir,'img|nii');
end

if isempty(files)     return          ;end

hfig=findobj(0,'tag','Graphics');
Bvec=[];
for i=1:9
    hed= findobj(hfig,'callback',['spm_image(''repos'','   num2str(i) ')']);
    Bvec(1,i)=str2num(get(hed,'string'));
    % iptaddcallback(hed, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
    % iptaddcallback(hed, 'Callback', 'spm_orthviews2(''Redraw'')');
end
predef=[Bvec [0 0 0]];
% fsetorigin(files, predef);  %ANA
fsetorigin(files,   spm_imatrix(inv(spm_matrix(predef)))    );
%  displaykey2(gm,t2)
disp('...images reoriented [done]');

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function addotherorients
hfig=findobj(0,'tag','Graphics');

hauto=findobj(hfig,'tag','autoregister');
us=get(hauto,'userdata');


units=get(hfig,'units'); set(hfig,'units','norm');
pos=get(hfig,'position'); set(hfig,'units',units);

try; delete(findobj(0,'tag','otherrots')); end
%       fg; set(gcf,'units','norm','position',[pos(1)+pos(3)+.005  .5   [.2 .25] ],'tag','otherrots','menubar','none');
fg; set(gcf,'units','norm','position',[pos(1)+pos(3)+.005  .2  [.25 .5] ],'tag','otherrots','menubar','none');

%% FIRST CHART
ax1=axes('position',[.09 .5 .6  .45],'fontsize',7);
%

val=us.stat ;        vec=1:length(val);
% bar(vec,val,'r');
plot(vec,val,'ob-','linewidth',1,'markerfacecolor','b');     hold on;
mx=find(val==max(val));
plot(mx,val(mx),'om','markersize',5,'markerfacecolor','m');

set(gca,'fontweight','bold')
ti=title('MATCH[T2,Allen]..bestTRAFO[FORWARD-DIR]');
set(ti,'fontweight','bold','fontsize',8); box off;%'verticalalignment','top'
if length(vec)>1
    xlim([vec(1) vec(end)]);
end
set(gca,'fontsize',9);
pl=[];
tx={'***TRAFOS {FORWARD}***'};
tx{end+1,1}=['   * from ALLEN to T2'];
for i=1:size(us.tbur,1);
    %          pl(i)=plot(i,g(i),'ob','markerfacecolor','b');
    tx{end+1,1}=sprintf('%2.2d] %5.2f %5.2f %5.2f',[i us.tbur(i,:)]);
end
box off; grid on

%     h=legend(pl,tx)
ax2=axes('position',[.73 .5 .25 .45]);
te=text(0,.5,tx,'fontsize',7);
uistack(ax2,'bottom'); axis off;


%% TABLE
pb=uicontrol('Style', 'listbox',...
    'String', 'rr' ,'units','normalized','callback',@otherorients,...
    'Position',[0 0 1 .45 ],'fontweight','normal','fontsize',7,...
    'foregroundcolor',[0 0 1],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','other Trafos,..select one to see as overlay');
tb=us.tb;
fmt='% 7.3f';
fmtr='% 8.4f';
sp='';
tb2=[];
for i=1:size(tb,1)
    if i==us.id; chk='[x] '; else; chk='[  ] ';end
    chk=   sprintf('%s ( %2i) ',chk,i);
    tb2{end+1, 1} =  [ chk sprintf( [fmt sp  fmt sp fmt sp '  '  fmtr sp  fmtr sp fmtr ],         tb{i,3})   ];
end
%    tb2{us.id}=[ ' <html><b><font  color="green"> '      tb2{us.id} ' </b></font> '   ]
%     colortag='<html><div style="color:blue;"<pre>> '
%  tb2{us.id}=[ colortag tb2{us.id} ]
%   colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD><pre>',text,'</pre></TD></TR> </table></html>'];
%   tb2{us.id}=colergen('#ffcccc',[  tb2{us.id} 'x]' ] );
tb2{end+1, 1}=   repmat('–',[1 length(tb2{1,1})]);
tb2{end+1, 1}=     '***TESTED TRAFOS {BACKWARD}***';
tb2{end+1, 1}='    ... [x] denotes the  best trafo from autoreg tool';
tb2{end+1, 1}='    ... select a TRAFO from table to see the match in the SPM-graphics Window';
set(pb,'string',tb2);
set(pb,'value', us.id);

function otherorients(h,e)
id=get(h,'value');

hfig=findobj(0,'tag','Graphics');
set(0,'currentfigure',hfig);
hauto=findobj(hfig,'tag','autoregister');
us=get(hauto,'userdata');

try
    trafo= us.tb{id,3};
catch
    return
end
%       trafo2   =[trafo 1 1 1 0 0 0];
%       trafoinv=spm_imatrix(inv(spm_matrix(trafo2)))    ;
trafoinv=us.tb{id,3};

for i=1:6
    ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
    set(hfig,'CurrentObject',ex  );
    set(ex,'string',num2str(trafoinv(i)) );
    hgfeval(get(ex,'callback'));
end
spm_orthviews('context_menu','orientation',3);
spm_orthviews2('Redraw');
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function runautoreg(h,b)
lab=get(h,'string'); col=get(h,'backgroundcolor');
set(h,'string','..wait..'); set(h,'backgroundcolor',[1 1 0]);
drawnow;

% V:\mritools\ant\paraaffine4rots.txt
% parafile=which('paraaffine4rots.txt');
global aux
try;
    parafile=aux.parafile;  %%  parafile: 'V:\mritools\elastix\paramfiles\trafoeuler.txt'
    % parafile=which('trafoeuler.txt');
catch
    error('no elastix parameterfile given as input');
    %keyboard
end



% parafile=which('paraaffine4rots_testnew.txt'); %paraaffine4rots_testnew.txt
%parafile='V:\mritools\elastix\paramfiles\Par0025affine.txt';
% parafile=fullfile(pwd,'mist.txt')
global st
% f1=st.vols{1}.fname;  displaykey2 anordnung
% f2=st.overlay.fname;

f2=st.vols{1}.fname;
f1=st.overlay.fname;

% % % % if 0 %changed
% % % %     %f1='O:\data2\muenchen_importbug\dat\hab2\_sample.nii'
% % % %     %f1='O:\data2\muenchen_importbug\dat\hab2\AVGT.nii'
% % % %     f1='O:\data2\muenchen_importbug\dat\hab2\sample2.nii';
% % % %     disp(['LINE-607 using "karina-s2014109_10sr_1_x_x" as reference: '  mfilename ]);
% % % % end

if isfield(aux,'version2')==0 %OLD  VERSION
    aux.version2=0;
end


if aux.version2==0;            %OLD VERSION
     disp('..running OLD-version of manual coreg');
     disp(['refIMG    : ' f1]);
     disp(['sourcefIMG: ' f2]);
        disp('...wait');
    [rot id trafo tb tbur stat]=findrotation(f1,f2,parafile, 1,0);
else                             %NEWVERSION
    iref   =aux.orientRefimage;
    isource=f2;
    params.orientType=aux.orientType;
    
%     disp('..running NEW-version of manual coreg');
%     disp(['refIMG    : ' iref]);
%     disp(['sourcefIMG: ' isource]);
     disp('...wait');
     
     iref              = aux.auto_iref;
     isource           = aux.auto_isource;
     params.orientType = aux.orientType;
     params.outdir     = aux.outdir;
     aux.orientType
     
%      return
     [rot id trafo tb tbur stat]=findrotation2(iref ,isource,params ,parafile, 1,0);
      
end
  disp('...[DONE]');

%OLD
%  trafo2   =[trafo 1 1 1 0 0 0];
%  trafoinv=spm_imatrix(inv(spm_matrix(trafo2)))    ;
%NEW
trafoinv=trafo;


us.id   =id;
us.tb   =tb;
us.tbur=tbur;
us.stat=stat;
set(h,'userdata',us);

hfig=findobj(0,'tag','Graphics');
for i=1:6
    ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
    set(hfig,'CurrentObject',ex  );
    set(ex,'string',num2str(trafoinv(i)) );
    hgfeval(get(ex,'callback'));
end
spm_orthviews('context_menu','orientation',3);
spm_orthviews2('Redraw');
set(h,'string',lab); set(h,'backgroundcolor',col);

addotherorients



function setzero(h,b)
global st
f1=st.vols{1}.fname;    f2=st.overlay.fname;
trafo=zeros(1,6);
for i=1:6
    hfig=findobj(0,'tag','Graphics');
    ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
    set(hfig,'CurrentObject',ex  );
    set(ex,'string',num2str(trafo(i)) );
    hgfeval(get(ex,'callback'));
end
spm_orthviews2('Redraw');






% spm_orthviews('context_menu','orientation',3);
% spm_orthviews2('Redraw');





%% chnage EDITFIELDS: x,y,z,y,p,r
function key4editfield(src,evnt)
% 'qq'
tdel=0;%.01;
if strcmp(evnt.Key,'return')
    pause(tdel);
    %spm_orthviews('context_menu','orientation',3);
    %      pause(tdel);
    spm_orthviews2('Redraw');
    %      pause(tdel);
    %disp('return');
elseif strcmp(evnt.Key,'tab')  %% UPDATE
    pause(tdel);
    %spm_orthviews('context_menu','orientation',3);
    spm_orthviews2('Redraw');
    %disp('tab');
end



function writeTXTfile(h1,h2)
global st;

vector= (st.B);
fileout=regexprep(st.vols{1}.fname, '.nii|.hdr|.img', '_REORIENT.txt');
dlmwrite(fileout,  vector,'delimiter','\t','delimiter','\t');






