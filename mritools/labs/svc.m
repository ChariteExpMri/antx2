
function svc(ro,ri)
%  ##, =======================================================
%  ##, SMALL VOLUME CORRECTION using one/several mask image(s)
%  ##, =======================================================
% ## how to start SVC  ##
%  • use one of these options:
%    - use [small volume correction] in the pulldonwmenu of LABS
%    - use shortcut [m] in the SPM-graphic figure (if LABS is allready running)
%    -type 'svc' in matlab's command line
%
% #k 1. DEFINE MASKPATH and parameters
% -copy your masks (*nii/*.img/hdr) in one folder
% ##  STEPS
% ### [1]let SVC know where the path for the masks is
% -click ####  [set mask path]  #### to open the "svc_define.m" file in the editor
% -set path for the folder that contains the masks   ####  (maskpath='....')  ####
%   there is only one maskpath allowed thus either comment [crtl+r] other maskpaths
%   or let the actual maskpath be the latest in the "svc_define.m" file
% -click the "save"-button in the editor to actualize the "svc_define.m" file
%  OPTIONAL parameters in the "svc_define.m" file:
%    ####  report_firstclusterOnly:   ####   [0]/[1];
%         [1]: SVC reports only the first (most significant) cluster of each mask
%         [0]: SVC reports all clusters
%    ####  mask_selectall:   ####   [0]/[1];
%           [0] all masks are deselected in the listbox
%           [1] all masks are selected
%    ####  appendResults:   ####   [0]/[1];  preserve previous results in resultstable
%           [0] skip previous results in resultstable (if [run] button is pressed again)
%           [1] preserve results in resultstable (default)
%
% ### [2]actualize the maskpath
% -click #### [apply mask path]
%
% #w NOTE: steps[1]&[2] has to been done only once !!!
%    The maskpath can be applied for other contrasts or
%    the next SPM session without repeating  steps[1]&[2]
%
% #k 2. USING SVC
% -when SVC starts or the [apply mask path] button is pressed
%  the SVC-listbox will show/actualize all masks of the maskpath-folder
% ### [1] select one/several masks
%     -(de)select one/several masks by clicking on the prefered mask in the listbox
%     -use the checkbox ####  []select all #### to select or deselect all all masks
% ### [2] run SVC over mask(s)
%  - click ####  [Run]  #### button to perform svc





figure;
set(gcf,'color',[0.9020    0.8471    0.6824]);
set(gcf,'menubar','none','toolbar','none');
set(gcf,'units','normalized','position',[.6 .4 .23 .5])
set(gcf,'toolbar','none','tag','svc','name','small-vol-correction (SVC-tool)');
% set(gcf,'KeyPressFcn',@keyboardx);
% set(gcf,'WindowScrollWheelFcn',{@mousewheel,1});
% set(gcf,'ButtonDownFcn',@figbuttondown);
try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end


us=[];




lb1 = uicontrol('Style', 'listbox', 'String',  '',...
    'units','normalized',...
    'Position', [0 0.1 1 .9] , 'Callback', @changevalue,...
    'userdata',us,'tag','lb1',...
    'tooltipstring','MASKS for small volume correction (SVC), select 1/more masks for SVC');
set(lb1,'string','');


cb1 = uicontrol('Style', 'checkbox', 'String',  'select all',...
    'units','normalized',...
    'Position', [0  .05 .2 .04 ], 'Callback', @selectall ,...
    'userdata',us,'tag','selectall','visible','on','value',1,...
    'tooltipstring','select/unselect all masks');

ed4 = uicontrol('Style', 'edit', 'String',  'message',...
    'units','normalized','max',5,'fontsize',10,'FontName','courier',...
    'Position', [0 0.1 1 .9],...
    'tag','ed4','visible','off');




% ed1 = uicontrol('Style', 'edit', 'String',  '',...
%     'units','normalized',...
%     'Position', [0.2  .05 .8 .04 ], 'Callback', @editPath ,...
%     'userdata',us,'tag','ed_sel','visible','on','value',1);

ed1 = uicontrol('Style', 'pushbutton', 'String',  'set mask path',...
    'units','normalized',...
    'Position', [0 -.01 .3 .06 ], 'Callback', @setpath ,...
    'userdata',us,'tag','setpath','visible','on',...
    'tooltipstring','select folder with masks (and other setting parameter), the path will be saved for future work in "svc_define.m" ');

ed1 = uicontrol('Style', 'pushbutton', 'String',  'apply mask path',...
    'units','normalized',...
    'Position', [0.3 -.01 .3 .06 ], 'Callback', @applypath ,...
    'userdata',us,'tag','setpath','visible','on',...
    'tooltipstring','apply folder with masks');

ed_hlp = uicontrol('Style', 'pushbutton', 'String',  '?',...
    'units','normalized',...
    'Position', [.9  .05 .06 .05 ], 'Callback', @help ,...
    'userdata',us,'tag','help','visible','on',...
    'tooltipstring','help');

[icon map]=imread(fullfile(matlabroot,'toolbox/matlab/icons/helpicon.gif'));
icon2=ind2rgb(icon ,map);
icon2(icon2==1)=nan;
set(ed_hlp,'cdata',icon2);

ed3 = uicontrol('Style', 'pushbutton', 'String',  'Run',...
    'units','normalized',...
    'Position', [0.6 -.01 .3 .06 ], 'Callback', @runsvc ,...
    'userdata',us,'tag','run','visible','on',...
    'tooltipstring','RUN small volume correction');

set(gcf,'userdata',us);

applypath;

function help(ro,ri)
uhelp('svc',1);

function selectall(ro,ri)
us=get(gcf,'userdata');
if  get(findobj(gcf,'tag','selectall'),'value'   )  ==1;
    set(findobj(gcf,'tag','lb1'),'string',us.tab(:,3));
    us.tab(:,4)=num2cell(ones(size(us.tab,1),1)) ;
else
    set(findobj(gcf,'tag','lb1'),'string',us.tab(:,2));
    us.tab(:,4)=num2cell(zeros(size(us.tab,1),1)) ;
end
set(gcf,'userdata',us);





function setpath(ro,ri)
edit svc_define;

function changevalue(ro,ri)
us=get(gcf,'userdata');
lb=findobj(gcf,'tag','lb1');
va=get(lb,'value');
li=get(lb,'string');
if us.tab{va,4}==1
    li{va}=us.tab{va,2};
    us.tab{va,4}=0;
    %    'unsel'
else
    li{va}=us.tab{va,3};
    us.tab{va,4}=1 ;
    %     'selects'
end
set(gcf,'userdata',us);
us.tab;
set(lb,'string',li);
li{va};

function applypath(ro,ri)

us=get(gcf,'userdata');

run(strrep(which('labs.m'),'labs.m','svc_define') );
if ~exist('maskpath');
    maskpath=pwd;
end
% us.mask_selectall=mask_selectall;

% maskpath='E:\svc_loop\masks'
k=dir(fullfile(maskpath,'*.img'));
k2=dir(fullfile(maskpath,'*.nii'));
k3=[k; k2];
k4={k3(:).name}';



if isempty(k4)
    msg={};
    msg{end+1,1}=[' !!!  OBACHT   !!!'];
    msg{end+1,1}=('• no masks("*.nii" or "*.img") found in mask folder or pwd ') ;
    msg{end+1,1}=('• the mask folder can be defined in svr_define.m-->use [set mask path] button to change the maskpath') ;
    msg{end+1,1}=('•  if no mask folder is specified in svr_define.m, the current path (pwd) is scanned for mask-files') ;

    %       file=fullfile(matlabroot,'toolbox/matlab/icons/warning.gif')
    %           msg{end+1,1}=['<html><body><img src="' file ' width="64" height="64">']
    %     msg{end+1,1}=['<html><body><img src="images/dukeWaveRed.gif" width="64" height="64">
    ed4=findobj(gcf,'tag','ed4');       set(ed4,'visible','on');
    set(ed4,'max',5,'string',msg,'fontsize',10,'FontName','courier');


    lb1=findobj(gcf,'tag','lb1');         set(lb1,'visible','off');


    set(findobj(gcf,'tag','selectall'),'enable','off');

    set(findobj(gcf,'tag','run'),'enable','off');
    return
else
    lb1=findobj(gcf,'tag','lb1');      set(lb1,'visible','on');
    ed4=findobj(gcf,'tag','ed4');       set(ed4,'visible','off');

    set(findobj(gcf,'tag','selectall'),'enable','on');
    set(findobj(gcf,'tag','run'),'enable','on');



end

us.tag_str =[' &nbsp   <FONT SIZE=3 face="Verdana"  font color="black">'];
us.tag_sel =['<HTML><b><FONT SIZE=3><font color="green">' 'X' '</b>'];
us.tag_unsel=['<HTML><b><FONT SIZE=3><font color="green">' '-' '</b>'];

us.report_firstcluster=report_firstclusterOnly;
us.maskpath=maskpath;
us.appendResults=appendResults;

for i=1:size(k4,1)
    tab{i,1}=[ k4{i,1}  ];
    tab{i,2}=[us.tag_unsel   us.tag_str  k4{i,1} '</HTML>' ];
    tab{i,3}=[us.tag_sel     us.tag_str  k4{i,1} '</HTML>' ];
end

us.tab=tab;

if mask_selectall==0 %UNSELECTED ALL
    set(findobj(gcf,'tag','lb1'),'string',tab(:,2));
    tab(:,4)=num2cell(zeros(size(tab,1),1));
    set(findobj(gcf,'tag','selectall'),'value',0);
elseif mask_selectall==1
    set(findobj(gcf,'tag','lb1'),'string',tab(:,3));
    tab(:,4)=num2cell(ones(size(tab,1),1));
    set(findobj(gcf,'tag','selectall'),'value',1);
end

us.tab=tab;
set(gcf,'userdata',us);

function runsvc(ro,ri)

us=get(gcf,'userdata');
% maskpath='E:\svc_loop\masks'
maskpath              =us.maskpath;
report_firstcluster   =us.report_firstcluster;

SPM=evalin('base','SPM');
xSPM=evalin('base','xSPM');
hReg=evalin('base','hReg');

% k=dir(fullfile(maskpath,'*.img'));
% k2=dir(fullfile(maskpath,'*.nii'));
% dat=[k; k2];
% maskfiles={dat(:).name}';

dat=us.tab;
maskfiles=dat([dat{:,4}] ==1,1);

masks=cellfun(@(maskfiles) {[ us.maskpath filesep   maskfiles]},maskfiles);

if isempty(masks)
    disp('...please select mask(s) first...') ;
    return
end

%%APPEND DATA
log=[];
if us.appendResults==1
    try
        oldfig=findobj(0,'tag','uhelp' ,'-and' ,'name','SVC');
        usold=get(oldfig,'userdata');
        log=usold.fun;  %us.e0
    end
end

if isempty(log)
    log{end+1,1}=[' % ##, small volume correction     '];
end
log{end+1,1}=['=============================================================' ];
log{end+1,1}=['SVC-maskPath:                     ' us.maskpath ];
log{end+1,1}=['SVC-report_firstcluster:          ' num2str(report_firstcluster)  '  ...([0]reports all cluster within mask' ];
log{end+1,1}=['SVC-appendResults:                ' num2str(us.appendResults)     '  ...preserve results' ];
log{end+1,1}=['DATApath (SPM.mat)(xSPM.swd):  ###  ' xSPM.swd ];
log{end+1,1}=['contrast TITLE (xSPM.title) :   #### ' xSPM.title ];
log{end+1,1}=['statistic test               :    ' xSPM.STAT ];
log{end+1,1}=['=============================================================' ];

that=[];
for im=1:size(masks,1)
    dat=[];
    tb=svc_spm_VOI_loop(SPM,xSPM,hReg,masks{im});
    hdr =[tb.hdr([1 2],3:end-1)                   ];
    hdr2={'' '' '';   'x' 'y'  'z'  };
    hdr=[hdr hdr2];
    if report_firstcluster==1
        try
            dat=[tb.dat(1,3:end-1) num2cell(tb.dat{1,end}') ];
        catch
            dat=repmat({''},  [1 size(hdr,2)]);
            dat{1,1}='ns';
        end
    else %ALLCLUSTER


        try
           dat=  [ tb.dat(:,3:end-1) num2cell([tb.dat{:,end}]')] ;
        catch
            dat=repmat({' '},  [1 size(hdr,2)]);
            dat{1,1}='ns';
        end
        
        if size(dat,1)==0
            dat=repmat({' '},  [1 size(hdr,2)]);
            dat{1,1}='ns';
        end

    end

    if im==1
        hdrIm1=hdr(1:2,:);
    else
        hdrIm2=[];
        for i=1:size(hdrIm1,2)
            hdrIm2{1,i}=repmat( ' ' ,[1 size(char(hdrIm1(:,i)),2)])  ;
        end
        hdr=hdrIm2;

        %   hdr=  regexprep(hdrIm1,'\S','@');
        %   hdr=hdr(2,:);

    end



    dat2=[hdr;dat];
    %     dat2(1,:)=regexprep(dat2(1,:),{'cluster' },{'clus'});
    %       [this log]= plog(log,{{},{},dat2},1,[ ' #yg ' maskfiles{im} '    ' repmat('  ',1,110)],'s=0' );

    %%add MASK in first colum
    %     datc1=repmat({''},[size(dat2,1)  1]);
    %     dat2=[datc1 dat2 ];
    %     dat2=[ repmat({''},[1 size(dat2,2)  ])  ; dat2 ];
    %     dat2{1,1}=[ ' ## ' maskfiles{im}(1:end-4) ' ## '  ];

    % log(end+1,1)={[ ' ## ' maskfiles{im}(1:end-4) ' ## '  ]};
    %   [this log]= plog(log,{{},{},dat2},1,[],'s=0','lin=0' );
    % uhelp(log(1:end-1));
    % log(find(~cellfun('isempty',regexpi(log,'¯¯¯¯¯'))))=[];

    maskname=maskfiles{im}(1:end-4);
    Nchars=25;
    maskname2=repmat(' ',[1  Nchars]);
    maskname2(1:length(maskname))=maskname;
    this2=repmat({ repmat(' ',[1 Nchars  ]   )  },[size(dat2,1) 1]);
    if im==1
        this2{3,1}=maskname2;
    else
        this2{2,1}=maskname2;
    end
    this3=[ this2 dat2 ];

    % log(end+1,1)={[ ' ## ' maskfiles{im}(1:end-4) ' ## '  ]};
    %   [this log]= plog(log,{{},{},this3},1,[],'s=0','lin=0' );


    %  uhelp(log);


    % set(gcf,'name','SVC')
    %     pause

    that=[that; this3];


end

[this log]= plog(log,{{},{},that},1,[],'s=0','lin=0' );
uhelp(log);


set(gcf,'name','SVC');


















