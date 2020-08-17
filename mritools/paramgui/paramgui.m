


%% #b *PARAMGUI* -GUI to show/modify/add and apply parameters
%% #b FAST WAY TO ADD PARAMETERS, WITHOUT SPENDING TO MUCH TIME IN DESIGN
%% #by FEATURES
%   -simple
%   -allows to present more information
%   -parameter sets can be  chunked
%   -additional parameters can be added quickly
%   -output as struct or cell-array
%   -output can be evaluated
%   -listing in the gui can be copyNpasted (to file,e.g to save the paramters with the output)
%   -predefined options (interactive selectors) can be specified, such as:
%     -single or multifile selection
%     -directory selection
%     -color selection
%     -1d or 2d cell arrays
%     -boolean
%   -all paramters can be seen instantly (compare hidden cell-array
%   containing multiple files) -can be used in waitNclose-modus (run a
%   process) or kept open to trigger and modiy another function (change
%   paramert and visualize process) -undo/redo modificatins
%
%% SIMPLEST INPUT:
% [m1 m2]=paramgui(p)
%
%    where p is a nx4 parameterfile with columns:
%               <variableName><variableData><information><optional definition>
%    <variableName>  : name of the variable
%                 -use [inf+number] (inf1,inf2...inf99) for standard line comment
%   <variableData>  : data of the varable
%                   insert text paragraph: for this the <variableName> must
%                   be inf+number and <variableData> starts with a '%'
%                   (without '%' is a standard line comment without text
%                   paragraph )
%   <information>   :<optional> information that appears as comment
%   <type&definition>    :<optional>
%                 'f'   : file  -->icon to open a gui to select a file
%                 'mf'  : multifile-->icon to open a gui and select multiple files
%                 'd'   : directory-->icon to open a gui and select a path
%                 {'mon' 'tue' 'wed'} : icon to open a pulldown to select
%                 from cell {1 2 'tue' 'wed'} :  same
%                  'b'   : icon to
%                 alterate the boolean value 'col' : icon to open
%                 color-picker
%% OUTPUT
%   m1: cellstring with parameters (and comments)
%   m2: struct with parameters (without comments)
%% FURTHER OPTIONAL INPUT
% -pairwise inputs:
% editorpos  : position of editor within window,      e.g. [0.001 0.001 1 1];
% figpos     : position of the window,                e.g [0.3049 0.4189 0.3889 0.4667]
% v.hfig     : handle of another figure (embedding)
% title      : <string> figure
% title info : <cell array> or {@doc, 'filename.m' } or or {@uhelp, 'filename.m' } to show help via help-icon
% pb1string  : name of the RUN-button             ,e.g 'update Figure'
% pb1callback: execute another callback
% uiwait     :{0,1} set modality of the figure, (default: 0 ..block subsequent processes)
% close      :{0,1} close figure afterwards (note: it makes  no sense to have both uiwait and
%             close set to 0)
% data       : just data to be used in the caller functions...stored in the fig''s userdata
%  info      : show help (use bulb-icon to see help)
%             examples:   ..'info',{@doc,'paramgui.m'},.   or  ..'info',{@uhelp,[ mfilename '.m']},..
%
%% KEYBOARD:
% <alt>&<y>    : if some/all parameters are further specified by the 4th column of
% <p>(e.g <type&definition>) one can move the cursor by arrowkeys and press
% <alt>&<y> to -->change the parameter in the current line (toggle boolean if its a boolean,
%         or open gui if parameter is defined as file/directory, or open a pulldown
%         menu if its a cell-array)
% <F1>: simulate RUN-button
% <F3>: simulate click onto cursor-located button 
%
%% EXAMPLE
%    p={...
%     'inf98'      '*** ALLEN LABELING                 '                         '' ''
%     'inf99'      'USE EITHER APPROACH-1 OR APPROACH-2'                         '' ''
%     'inf100'     '==================================='                          '' ''
%     'inf1'      '% APPROACH-1 (fullpathfiles: file/mask)          '                                    ''  ''
%     'files'      ''                             'files used for calculation' ,'mf'
%     'masks'      ''                            '<optional> maskfiles (order is irrelevant)' ,'mf' ...
%
%     'path'      '' 'PATH ANALYSIS'  'd'
%     'inf2'      '% APPROACH-2 (use filetags)' ''  ''
%     'filetag'      ''   'matching stringpattern of filename' ,''
%     'masktag'      ''   '<optional> matching stringpattern of masksname (value=1 is usef for inclusion)' ,''
%     'hemisphere' 'both'     'calculation over [left,right,both] hemisphere' {'left','right','both'}
%
%     'inf3'      '% OTHER PARAMETERS ' ''  ''
%     'threshold'    0     'lower threshold value (when files without masks are used) otherwise leave empty [] ' {'' 0}
%     'space'    'allen'   'calculation in {allen,native} space '      {'allen' 'native'}
%
%     'inf4'      '% PARAMETERS TO EXTRACT' ''  ''
%     'frequency'    1     'frequency [n-voxels] within Allen structure' 'b'
%     'percOverlapp' 1     'percent overlapp between MASK and Allen structure' 'b'
%     'volref'          1  'volume [qmm] of Allen structure (REFERENCE)'       'b'
%     'vol'          1     'volume [qmm] of masked Allen structure'           'b'
%     'mean'         1     'mean over values within structure' 'b'
%     'std'          1     'standard deviation over values within structure' 'b'
%     'median'       1     'median over values within structure' 'b'
%     'min'          1     'min value within structure' 'b'
%     'max'          1     'max value within structure' 'b'
%     'color'          1     'BG-color head' 'col'
%     };
% m=paramgui(p,'uiwait',0,'editorpos',[.03 0 1 1],'figpos',[.5 .3 .3 .5 ],'info',{@doc,'paramgui.m'}); %%START GUI
% m = paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .2 ],'info',{@uhelp,[ mfilename '.m']}); %%START GUI
%%
%
%% secondary-call
% [s ss]=paramgui('getdata') ;% if iswait==0 ...retrieveData
%% REFEREENCE TO LINKED PARAMETERS
% - see 4 column in 'imager' --> the a-priori defined datapath-parameter is passed to the "imager"-function
% p={ 'datapath'     '' 'mainpath (upper directory) of mouse data' 'd'
%     'imager'        '' 'selectImages (x.datapath has to be selected before)'  {@antcb,'selectimageviagui', 'datapath' ,'multi'}
% }
% m=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .2 ],'info',{@doc,'paramgui.m'}); %%START GUI
%
%
%
%
% m=paramgui(dat,struct('uiwait',0,'pb1callback',{{@disp,rand(3,3)}}))
% ,'info','vline.m')
% ,'info',{'Processing Parameters','-->see process1203.m'}
%% DYNAMICALLY SET VARIABLE FIELD
% -during runtime, variablename must exist,
% -variable name must  come with struct-name use 'x.reorienttype' instead of 'reorienttype'
% example
% paramgui('setdata','x.reorienttype','[]')
% paramgui('setdata','x.reorienttype',{'ee' 'eeed' 'fgffd'})
%
%% #by SET PREFERENCES
% Preferences are stored in the global variable:'paramguipref'.
% To set preferences the first input of paramgui must be 'pref' followed by pairwise inputs
% pairwise inputs: 
%  useoldversion : [0,1];  [0] use old version,  [1] use new version
%  mimic_oldstyle: [0,1];  [0] multi-icon stlye  [1] single-icon style 
%                  -value is only important if new version is used (useoldversion is 1)
% show           :  [0,1]; [1] show content of paramguipref 
% 
% #b examples:
% paramgui('pref','useoldversion',0,'mimic_oldstyle',0);  %use NEW VERSION+multi-icon stlye 
% paramgui('pref','useoldversion',0,'mimic_oldstyle',1);  %use new version+single-icon stlye
% paramgui('pref','useoldversion',1);                     %use old version (single-icon stlye)
% paramgui('pref','show',1);  show struct with parmater

function varargout=paramgui( dat,varargin)

% ==============================================
%% set preferences from cmdline 
% ===============================================
if ischar(dat)
    if strcmp(dat,'pref')
        pref=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        global paramguipref
        if isfield(pref,'useoldversion');
            paramguipref.useoldversion=pref.useoldversion;
        end
        if isfield(pref,'mimic_oldstyle');
            paramguipref.mimic_oldstyle=pref.mimic_oldstyle;
        end
        if isfield(pref,'show') && pref.show==1 ;
            disp(' * paramgui-preferences (global variable: "paramguipref"):');
            if isempty(paramguipref)
                disp([ class(paramguipref) ': <empty> ' ]);
            else
            disp(paramguipref);
            end
            if isempty(strfind(which(mfilename),[filesep 'oldfun' filesep]))
               disp([' ...currently running the new version: ' which(mfilename)]);
            else
               disp([' ...currently running the old version: ' which(mfilename)]); 
            end
        end
        return
    end%pref
end

newpath=fullfile(fileparts(antpath),'paramgui');
oldpath=fullfile(fileparts(antpath),'paramgui','oldfun');
addpath(newpath);


global paramguipref
if ~isstruct(paramguipref)
    paramguipref=struct();
end
if isfield(paramguipref,'useoldversion')==0
    paramguipref.useoldversion=0;
end


% ==============================================
%%   use older paramgui-version
% ===============================================

if paramguipref.useoldversion==1 %USE OLD FUNCTION
    addpath(oldpath);
   [v1 v2 v3 v4]= deal([]);
    if nargout==1
        varargout{1}=paramgui( dat,varargin{:});
    elseif nargout==2
        [v1 v2]=paramgui_old( dat,varargin{:});
        varargout{1}=v1;
        varargout{2}=v2;
    elseif nargout==3
        [v1 v2 v3]=paramgui( dat,varargin{:});
        varargout{1}=v1;
        varargout{2}=v2;
        varargout{3}=v3;
    elseif nargout==4
        [v1 v2 v3 v4]=paramgui( dat,varargin{:});
        varargout{1}=v1;
        varargout{2}=v2;
        varargout{3}=v3;
        varargout{4}=v4;
    end
    drawnow;
    addpath(newpath);
    drawnow;
    return
else % use new version
    addpath(newpath);
end

% ==============================================
%%   
% ===============================================



pause(.1)
drawnow;
warning off;
drawnow;

varargout{4}=[];

if ischar(dat)
    varargout={};
    if strcmp(dat,'getdata');
        [aa bb]=getdata;
        varargout{1}=aa;
        varargout{2}=bb;
        return
    elseif strcmp(dat,'setdata');
        
        setdata(varargin);
        return
    end
end


if 0
    
    p={...
        'inf98'      '*** ALLEN LABELING                 '                         '' ''
        'inf99'      'USE EITHER APPROACH-1 OR APPROACH-2'                         '' ''
        'inf100'     '==================================='                          '' ''
        'inf1'      '% APPROACH-1 (fullpathfiles: file/mask)          '                                    ''  ''
        'files'      ''                                                           'files used for calculation' ,'mf'
        'masks'      ''                                                           '<optional>maskfiles (order is irrelevant)' ,'mf' ...
        %
        'inf2'      '% APPROACH-2 (use filetags)' ''  ''
        'filetag'      ''   'matching stringpattern of filename' ,''
        'masktag'      ''   '<optional> matching stringpattern of masksname (value=1 is usef for inclusion)' ,''
        'hemisphere' 'both'     'calculation over [left,right,both]' {'left','right','both'}
        %
        'inf3'      '% PARAMETERS to extract' ''  ''
        'frequency'    1     'frequency [n-voxels] within Allen structure' 'b'
        'percOverlapp' 1     'percent overlapp between MASK and Allen structure' 'b'
        'volref'          1  'volume [qmm] of Allen structure'                   'b'
        'vol'          1     'volume [qmm] of Mask in Allen structure'           'b'
        'mean'         1     'paramter to extract' 'b'
        'std'          1     'paramter to extract' 'b'
        'median'       1     'paramter to extract' 'b'
        'min'          1     'paramter to extract' 'b'
        'max'          1     'paramter to extract' 'b'
        };
    %     dat=preadfile2('cell2line.m');
    m=paramgui(p,'uiwait',0,'editorpos',[.03 0 1 1],'figpos',[.5 .3 .3 .5 ],'title','PARAMETERS: LABELING')
    %     paramgui(dat)
    
end

% varargout{1}=[];
% varargin{1}
% return

warning off;
if nargin>1
    %vnew=varargin{1};
    
    vara=reshape(varargin,[2 length(varargin)/2])';
    vnew=cell2struct(vara(:,2)',vara(:,1)',2);
    
else
    vnew=struct();
end

if size(dat,2)==2; dat=[dat repmat({''},[size(dat,1) 2])] ; end
if size(dat,2)==3; dat=[dat repmat({''},[size(dat,1) 1])] ; end



v.editorpos=[0.001 0.001 1 1];
v.hfig    =[];
v.pb1string ='RUN';
v.uiwait   =1;
v.out      ='pass' ; %pass vs eval;
v.title    ='';
v.figpos   = [0.3049 0.4189 0.3889 0.4667];%[.1 .3 .5 .1];
v.pb1callback=@pb1callback;
v.info  ='';
v.close =0;

v.cb1string ='';
% v.cb1string ='SAVE Settings';
% v.pb2callback=@pb1callback;

v= catstruct(v,vnew);% overwrite defaults with


if iscell(v.pb1callback)
    v.pb1callback={@pb1CB,v.pb1callback};
else
    if strcmp(char(v.pb1callback),'pb1callback')==1 %default
        v.pb1callback={@pb1callback,[]};
    else
        v.pb1callback={@pb1CB,v.pb1callback};
    end
end

% if iscell(v.pb2callback)
%     v.pb1callback={@pb1CB,v.pb1callback};
% else
%     if strcmp(char(v.pb1callback),'pb1callback')==1 %default
%         v.pb1callback={@pb1callback,[]};
%     else
%         v.pb1callback={@pb1CB,v.pb1callback};
%     end
% end


% if isa(v.pb1callback, 'function_handle')==1
%     if strcmp(v.pb1callback,'pb1callback')~=1
%         v.pb1callback={@pb1CB,v.pb1callback};
%     else
%         v.pb1callback={@pb1callback,[]};
%     end
% else
%     if strcmp(char(v.pb1callback{1}),'pb1callback')~=1; %change callback if other callback requested
%         v.pb1callback={@pb1CB,v.pb1callback}
%     else
%         v.pb1callback={@pb1callback,[]};
%     end
% end


% v.pb1callback
% return

% v.hfig=2
% v.position=[0.5 0.5 .2 .1];

% x=get(gcf)

%% test
% b =struct2list(x)
% global an


qw=dat;

% qw={...
%    'hemisphere' 'both'
%    'resolution' [.4 .4 .1]
%    }

% qw=preadfile2('cell2line.m')



if size(qw,2)>1
    %     x=cell2struct(qw(:,2),qw(:,1),1 );
    x=[];
    for i=1:size(qw,1)
        eval(['x.' qw{i,1} '= qw{' num2str(i) ',2};']);
        %         if   isnumeric(getfield(x, qw{i,1} )) & isempty(getfield(x, qw{i,1} ))
        %             x=setfield(x, qw{i,1}, '[]' );
        %
        %         end
    end
    qw2=struct2list(x);
end

%% bring inf-information in correct order
qq=qw2;
ix=regexpi2(qw(:,1), '^inf\d');
ix2=ix+1;
if ~isempty(ix)
    for i=1:length(ix)
        
        i1=regexpi2(qq,['^x.' qw{ix(i),1} '\s*=']);
        i2= regexpi2(qq,['^x.' qw{ix2(i),1} '\s*=']);
        
        infs=qq(i1);
        te=qq;
        te=strrep(te,infs,'<empty>');
        %qq=[te(1:i1-1) ; infs; te(i2:end) ];
        %         pause
        
        qq=[te(1:i2-1) ; infs; te(i2:end) ];
        qq(strcmp(qq,'<empty>'))=[];
        [size(qw2) size(qq)];
    end
    qw2=qq;
end






if size(qw,2)>2
    idinfo=regexpi2(qw2(:,1),'^\w');
    info=repmat({''},size(qw2,1), 1);
    info(idinfo)= cellfun(@(a) {[ '% '  a]},qw(:,3));
    qw3=cellfun(@(a,b) {[a char(9)  b]}, qw2,info);
elseif size(qw,2)==2
    qw3=qw2;
else
    qw3=qw;
end





%% replace inf-information
id=regexpi2(qw3,'^x.inf\d');
for i=1:length(id)
    dum=qw3{id(i)};
    dum(1:regexpi(dum,'='))=[];
    dum=regexprep(dum,{'''', ';' },{'' ' '});
    
    if strcmp(dum(1),'%')
        dum=[ char(10)  '% ' strrep(dum,'%' ,'')];
    else
        if isempty(regexprep(dum,{'%' '\s*'},''))
            dum='       ';
        else
            dum=[  '% ' strrep(dum,'%' ,'')];
        end
    end
    qw3{id(i)}=dum;
end

qw3=makennicer(qw3);
%qw3=makenicer2(qw3);

b=qw3;
b=[b;{'';''} ];
b2=cell2line(b,1,'@999@');
b3=regexprep(b2,'@999@',char(10));
b3=[b3 ' ' char(9) ];

b3=makenicer2(b3);

% b2=char(b)
%
% b3='';
% for i=1:size(b2,1)
%     dum=b2(i,:);
%     dum=regexprep(dum,char(13),'');
%     b3=[b3 dum ];
% %     b2(i,:)
% end
% b3
%
us.v=v;
us.dat=dat;
if isfield(v,'data')
    us.data=v.data;
end

% %% test
pos=v.editorpos;%[0.001 0.001 1 1];
delete(findobj(0,'tag','paramgui'));
% figure
if isempty(v.hfig)
    figure('visible','off','color','w','menubar','none','toolbar','none','tag','paramgui', 'name',(v.title),...
        'NumberTitle','off');
else
    figure(v.hfig)
    set(v.hfig,'tag','paramgui');
end


ax=axes('position',v.editorpos,'visible','off','tag','axe1');
uistack(ax,'bottom');

set(gcf,'units','pixels')
figposp=get(gcf,'position');
sizepixel=figposp(3:4);

set(gcf,'units','norm')
pos0=get(gcf,'position');
set(gcf,'position',[0.01 pos0(2) 1  pos0(4)   ])
set(gcf,'units','pixels');


% posfig   =get(gcf,'position');
pos2=[ pos(1:2).*sizepixel  pos(3:4).*sizepixel];

if ~isempty(v.figpos)
    set(gcf,'units','norm');
    set(gcf,'position',v.figpos);
    set(gcf,'units','pixels');
end


jCodePane = com.mathworks.widgets.SyntaxTextPane;
codeType = com.mathworks.widgets.text.mcode.MLanguage.M_MIME_TYPE;
jCodePane.setContentType(codeType)
% jCodePane.setContentType('text/html');
% str = ['% create a file for output\n' ...
%        '!touch testFile.txt\n' ...
%        'fid = fopen(''testFile.txt'', ''w'');\n' ...
%        'for i=1:10\n' ...
%        '    % Unterminated string:\n' ...
%        '    fprintf(fid,''%6.2f \\n, i);\n' ...
%        'end'];
% str = sprintf(strrep(str,'%','%%'));

jCodePane.setText(b3);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCodePane);
[jhPanel,hContainer] = javacomponent(jScrollPane,round(pos2),gcf); %[10,10,500,200]
% jhPanel.setFont(java.awt.Font('Comic Sans MS',java.awt.Font.PLAIN,28))
set(gcf,'position',figposp)



set(gcf,'visible','off');  % #rp1
set(hContainer,'units','norm');


us.jCodePane=jCodePane;
us.jhPanel=jhPanel;
us.hContainer=hContainer;
us.ispulldownON=0;


us.mimic_oldstyle=0 ;% OLD single-icon STYLE
us.lastYscroll=inf;

drawnow
us.history{1}=b3;
us.historyValue=1;
set(gcf,'userdata',us);
set(gcf,'units','normalized','KeyPressFcn',@figkey);











%% PANEL
p5=uicontrol('style','text',       'tag','pb5',    'string','','units','normalized',...
    'backgroundcolor','w','position',[0 -.005 .5 .045],'units','pixels');%[.01 .93 .1 .04]
% set(p4,'cdata',flipdim(e,2))
uistack(p5,'top');




p=uicontrol('style','pushbutton',       'tag','pb1',    'string',v.pb1string,'units','normalized',...
    'position',[.02 -.005 .1 .045],'units','pixels','callback',{v.pb1callback{1}, v.pb1callback{2:end}},...);%[.01 .93 .1 .04]
    'backgroundcolor','w');
% set(p,'string',b3)




p=uicontrol('style','checkbox',       'tag','cb1',    'string',v.cb1string,'units','normalized',...
    'position',[.252 -.005 .15 .045],'units','pixels','callback','',...);%[.01 .93 .1 .04]
    'backgroundcolor','w','tooltipstring',v.cb1string);
if isempty(v.cb1string); set(p,'visible','off');end



if ~isempty(v.info )
    
    p2=uicontrol('style','pushbutton',       'tag','pb2',    'string','','units','normalized',...
        'position',[0 -.005 .02 .045],'units','pixels','callback',{@showhelp, v.info},...
        'TooltipString','help');%[.01 .93 .1 .04]
    icon = fullfile(matlabroot,'/toolbox/matlab/icons/demoicon.gif');
    if ~isempty(regexpi(icon,'.gif$'))
        [e map]=imread(icon)  ;
        e=ind2rgb(e,map);
        e(e<=0.01)=nan;
    else
        e=double(imread(icon));
        e=e/max(e(:));
        e(e<=0.01)=nan;
    end
    set(p2,'cdata',e);
end


%% DO/UNDO

p3=uicontrol('style','pushbutton',       'tag','pb3',    'string','','units','normalized',...
    'position',[.12 -.005 .05 .045],'units','pixels','callback',{@pbhist, [-1]},...
    'TooltipString','UNDO','backgroundcolor','w');%[.01 .93 .1 .04]

e = which('undo.gif');
%    if ~isempty(regexpi(e,'.gif$'))
[e map]=imread(e)  ;% e=double(e);
e=ind2rgb(e,map);
% e(e<=0.01)=1;
set(p3,'cdata', e); uistack(p3,'top');

p4=uicontrol('style','pushbutton',       'tag','pb4',    'string','','units','normalized',...
    'position',[.17 -.005 .05 .045],'units','pixels','callback',{@pbhist, [1]},...
    'TooltipString','REDU','backgroundcolor','w');%[.01 .93 .1 .04]
set(p4,'cdata',flipdim(e,2));




% cancel
p6=uicontrol('style','pushbutton',       'tag','pb6',    'string','cancel','units','normalized',...
    'position',[0.22 -.005 .1 .045],'units','pixels','callback',{@cancelate},...
    'TooltipString','Cancel','backgroundcolor','w');%[.01 .93 .1 .04]

% {v.pb1callback{1}, v.pb1callback{2:end}}



% set(p,'string',b3)
% pl=findjobj(p)
% % pl.setContentType(codeType)
% us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition())
% [us.jCodePane.getX() us.jCodePane.getY()]

% us.jCodePane.getVisibleRect()
% us.jCodePane.getHeight()
% us.jCodePane.getNumLines()
% us.jCodePane.getLineStart(0)

drawnow;
if ~isempty(v.figpos)
    figpos0=get(gcf,'position');
    if isnan(v.figpos(1))
        figpos0(3:4)=v.figpos(3:4);
        set(gcf,'position',figpos0);
    else
        set(gcf,'position',v.figpos);
    end
    
    
end

try
    set(us.jCodePane,'CaretUpdateCallback',@showIcon);
catch
    jTextAreaWA = handle(us.jCodePane,'CallbackProperties');
    set(jTextAreaWA,'CaretUpdateCallback',@showIcon);
end
set(findobj(gcf,'tag','pb4'),'enable','off');
set(findobj(gcf,'tag','pb3'),'enable','off');


us.jhPanel.setHorizontalScrollBarPolicy(32);
delete(findobj(gcf,'tag','pb5'));
set(gcf,'Resizefcn',@resizefun);%32-always,31-needed,30-depends
% set(us.hContainer,'units','pixels')



try
    set(us.jCodePane, 'KeyPressedCallback',@keypress);
end

drawnow;
set(gcf,'visible','on');  % #rp1

% reformat; %reformat


% us.jCodePane.setCaretPosition(1); %pos-1
us.jCodePane.requestFocus(); %set focus

% ==============================================
%%    show all icons
% ===============================================
%
% drawnow;
% prepicon();drawnow
% updateIconposition();drawnow
% 
% us.jCodePane.setCaretPosition(1);
if 0
    [icon tooltip varnamefull]=getIcon2(7)
    txt=us.jCodePane.getText;
    lin_icons=find(~cellfun('isempty',qw(:,4)));
    
    CR=strfind(txt,char(10));
    CR=[-1 CR];
    for i=1:length(lin_icons)
        us.jCodePane.setCaretPosition(CR(lin_icons(i))+1);
        %     drawnow;
        drawnow;
    end
    us.jCodePane.setCaretPosition(1);
end

% ==============================================
%%   callback vertic.-scroll
% ===============================================

% *** get PORPERTIES ***
% get(handle(us.jhPanel.VerticalScrollBar, 'CallbackProperties'))

set(us.jhPanel,'MousePressedCallback','1');
set(us.jhPanel,'MouseDraggedCallback','2');
set(us.jhPanel,'MouseWheelMovedCallback',@mousescroll);
set(us.jhPanel,'MouseReleasedCallback','5');
set(us.jhPanel.VerticalScrollBar,'MouseReleasedCallback',@resizefun);
% set(us.hContainer,'MouseReleasedCallback','66');
%set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',@updateIconposition_cb);

%
% jo = get(gcf,'JavaFrame')
% jf = get(handle(gcf),'JavaFrame')
% jClient = jf.fHG2Client
% jframe = jClient.getWindow
% cbo=handle(jframe,'callbackproperties')
% set(jframe,'MouseReleasedCallback','777');
% set(jframe,'ComponentResizedCallback','1888');
% set(jframe,'PropertyChangeCallback','999');

% ==============================================
%%   preferences
% ===============================================
% global paramguipref
% if ~isstruct(paramguipref)
% paramguipref.mimic_oldstyle=us.mimic_oldstyle;
if isfield(paramguipref,'hist')==0
    paramguipref.hist.time={};
    paramguipref.hist.list={};
end
% else
if isfield(paramguipref,'mimic_oldstyle')
    us.mimic_oldstyle =paramguipref.mimic_oldstyle;  %from global to current
else
    paramguipref.mimic_oldstyle=us.mimic_oldstyle;
end


  


posfig=get(gcf,'position');
set(gcf,'position',[posfig(1:3) posfig(4)+0.02]); drawnow;
set(gcf,'position',[posfig]); drawnow;


us.origfigposition=get(gcf,'position');
set(gcf,'userdata',us);  
% drawnow;
prepicon();
drawnow;


% if 1 %%TEST-number-of-ICONS
%      r=findobj(gcf,'style','pushbutton');
%     iicons=[];
%     for i=1:length(r)
%         try
%             if strcmp(func2str(r(i).Callback),'pbcb')
%                 iicons=[iicons i];
%             end
%         end
%     end
%     r=r(iicons);
%     disp(['nIcos:' num2str(length(r))]);
% end



if us.mimic_oldstyle==1 ;% OLD single-icon STYLE
    r=findobj(gcf,'style','pushbutton');
    iicons=[];
    for i=1:length(r)
        try
            if strcmp(func2str(r(i).Callback),'pbcb')
                iicons=[iicons i];
            end
        end
    end
    r=r(iicons);
    % left distance of text-pane
    if ~isempty(r)
        iconpos= get(r(1),'position');
        posini=get(r(1),'position');
        posini(3)=15;
        set(r(1),'position',posini);
    end
end
resizefun();
updateIconposition();drawnow;
us.jCodePane.setCaretPosition(1); %pos-1
us.jCodePane.requestFocus();

% 
% us.jCodePane.setCaretPosition(1);


%% MORE-BUTTON
pm=uicontrol('style','togglebutton',  'value',0,     'tag','pbmore',    'string',':','units','normalized',...
    'position',[.12 -.005 .05 .045]);
set(pm,'position',[.95 -.005 .025 .04]);
set(pm,'units','pixels','callback',@morepanel,...
    'TooltipString',['..show menu'],'backgroundcolor','w');%[.01 .93 .1 .04]

hrun=findobj(gcf,'style','pushbutton','tag','pb1');
posr=get(hrun,'position');

set(gcf,'units','pixels');
fpix=get(gcf,'position');
set(gcf,'units','norm');
% set(pm,'string','hallo')
set(pm,'position',[fpix(3)-posr(3)/2 0 posr(3)/5.5 posr(4) ]);

drawnow;
us.jCodePane.setCaretPosition(1); %pos-1
us.jCodePane.requestFocus();



% ==============================================
%%   uiwait
% ===============================================
if v.uiwait==1
    uiwait(gcf);
    
    
end
us=  get(findobj(0,'tag','paramgui'),'userdata');
drawnow;
varargout{1}=[];      varargout{2}=[];  varargout{3}=[];




try
    txt=us.jCodePane.getText;
catch
    disp('..process cancelled (GUI-based)');
    return
end
if strcmp(v.out,'pass')
    varargout{1}=char(txt);
else
    eval(txt);
    varargout{1}=x;
end

eval(txt);
varargout{2}=x;

try
    c=list2cell(char(txt), us.dat );
    varargout{3}=c;
catch
    varargout{3}=[];
end

%'PARAMETERS'
params.cb1=get(findobj(gcf,'tag','cb1'),'value');
varargout{4}=params;
% cel=[]
% fn=fieldnames(x)
% for i=1:length(fn)
%  cel{i,1}=fn{i}
%  cel{i,1}=fn{i}
% end
%


% 'showiconsall'
%  return
% cartpos=r.getCaretPosition;
% ichar=regexpi(tx,char(10));
% charbef=find(ichar>cartpos);
% cartline=min(charbef);



if us.v.close==1
    drawnow;
    close(findobj(0,'tag','paramgui'));
    drawnow;
end


function morepanel(e,e2)

hb=findobj(gcf,'tag','pbmore');
if get(hb,'value')==1 
    m = uimenu(gcf,'label','more','tag','moremenu');
    
    hm = uimenu(m,'label','Help Paramgui');
    set(hm,'callback',@paramguihelp);
    
    
    hm = uimenu(m,'label','shortcuts Paramgui');
    set(hm,'callback',@paramguishortcuts);
    
    
     hm = uimenu(m,'label','History (get list of previous Paramgui-calls)');
    set(hm,'callback',@paramguihistory);
    
    hm = uimenu(m,'label','Preferences');
    set(hm,'foregroundcolor',[0.4706    0.6706    0.1882],'callback',@preferences_win);
    
    
    
else
    delete(findobj(gcf,'tag','moremenu'));
end


function paramguishortcuts(e,e2)

%% start
% anker_shortcuts_on
%  #Wo PARAMGUI SHORTCUTS
%  #g [ctrl+p] or [cmd+p]  #n open preferences 
%  #b WINDOW-SIZE
%  #g [ctrl+upp]     #n original windows position/size 
%  #g [ctrl+right]   #n window width fits content (width adapted to line with max characters)
%  #g [ctrl+down]    #n window height fits content (height adapted to number of lines)
%  #g [ctrl+left]    #n previous window position & size
%  #r EXECUTION
%  #g [F1]   #n  simulates "Run"/"START" button 
%  #g [F3]   #n  simulates click onto cursor-located button 

%  #b FOR PULLDOWN(PD) ONLY (cellmode)
%  #g [left/right arrow]   #n  navigate through PD, for PD with n>2 items (sorry)
%                              -PD remains open (use mouse or enter-key to lock item and close PD)
%  #g [up/down arrow]      #n  toggle between first two items (PD will be closed after item-switch)
%  #g [return]             #n  lock selected item and close PD
%  #g [esc]                #n  close PD (no item is locked)
% 
% anker_shortcuts_off

ms=preadfile('paramgui.m');
ms=ms.all;

idx=[min(regexpi2(ms,'% anker_shortcuts_on')) min(regexpi2(ms,'% anker_shortcuts_off'))];
ms2=ms(idx(1)+1:idx(2)-1);
ms3=regexprep(ms2,'^%','','once');

uhelp(ms3,1);
%uhelp(ms3);

%% end


function paramguihistory(e,e2)

%% this
us=get(gcf,'userdata');
delete(findobj(gcf,'userdata','ipn1'));
% delete(findobj(gcf,'tag','pgprev') );
% delete(findobj(gcf,'tag','pgnext') );
% delete(findobj(gcf,'tag','pgclose') );
% delete(findobj(gcf,'tag','pgtime') );
% delete(findobj(gcf,'tag','pglist') );
% delete(findobj(gcf,'tag','pgdrag') );

global paramguipref
checkok=0;
try
    if size(paramguipref.hist.time,1)>0
        checkok=1;
    end
catch
    disp('no previous list-history found');
    checkok=0;
    return
end

if checkok==0; return; end 

set(gcf,'units','pixel');
pf=get(gcf,'position');
set(gcf,'units','norm');

%prev
hr=findobj(gcf,'tag','pb3');%refernce pushbutton
pr=get(hr,'position');


p=[pf(3)/2 pf(4)*.9  pr(3:4)];

%% close
h3=uicontrol('style','pushbutton','units','pixel');
p3=[p];
set(h3,'position',p3, 'string','x','tooltipstring','close paramgui-history',...
    'callback',{@paramguihistorychange,0},'tag','pgclose');
set(h3,'userdata','ipn1');

%% dragg
v=[129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];

v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;

h33=uicontrol('style','pushbutton','units','pixel','cdata',v);
% p33=[p1(1)-p1(3)  p1(2)    p1(3:4)];
p33=[p(1)+p(3) p(2:end)];
set(h33,'position',p33, 'string','<>','tooltipstring','drag panel to another position ',...
    'tag','pgdrag');
je = findjobj(h33); % hTable is the handle to the uitable object
    set(je,'MouseDraggedCallback',@paramguihistoryDarag  )
    set(h33,'userdata','ipn1');

%% prev
h1=uicontrol('style','pushbutton','units','pixel');
p1=[p(1)+3*p(3) p(2:end)];
set(h1,'position',p1, 'cdata',get(hr,'cdata'),'tooltipstring','previous paramgui-call',...
    'callback',{@paramguihistorychange,1},'tag','pgprev');
set(h1,'userdata','ipn1');

%% next
hr=findobj(gcf,'tag','pb4');%refernce pushbutton
pr=get(hr,'position');

h2=uicontrol('style','pushbutton','units','pixel');
p2=[p(1)+4*p(3) p(2:end)];
set(h2,'position',p2, 'cdata',get(hr,'cdata'),'tooltipstring','next paramgui-call',...
    'callback',{@paramguihistorychange,2},'tag','pgnext');
set(h2,'userdata','ipn1');




% timestamp
h4=uicontrol('style','listbox','units','pixel','HorizontalAlignment','left');
p4=[p(1)  p(2)-2*p(4)    p(3)*8 p(4)*2];
set(h4,'position',p4, 'string','timestamp','tooltipstring','selected time stamp',...
    'tag','pgtime');
set(h4,'userdata','ipn1');

%listbox
h5=uicontrol('style','listbox','units','pixel');
% p5=[p(1)  p(2)-10*p(4)    p(3)*8 p(4)*2];
p5=[p4(1) 0+p(4)   p(3)*8 p(2)-p(4)*2];
set(h5,'position',p5, 'cdata',get(hr,'cdata'),'tooltipstring','list of paramgui calls',...
    'callback',{@paramguihistorychange,3},'tag','pglist');
set(h5,'userdata','ipn1');

% set(h4,'string','actuall list');

lbtime=[...
    paramguipref.hist.time 
    'CURRENT CALL'];
% set(h5,'string',lbtime);
lblist=[...
    paramguipref.hist.list;
     (us.jCodePane.getText );
    ];
set(h5,'value',size(lbtime,1));
set(findobj(gcf,'tag','pgnext'),'enable','off');


li=lblist;
line1={};
for i=1:size(li,1)
   cel=strsplit(char(li(i)),char(10))';
   line1{i,1}= cel{1};
   if isempty(line1{i,1})
        line1{i,1}='empty';
   end
end
[a1 same]=ismember(line1,unique(line1));

ncolors=length(unique(same));
colall= cbrewer('qual', 'Pastel1', ncolors+4);
usecol=colall(same,:);
isamenow=find(same==same(end));
usecol(isamenow,:)=repmat([0.4706    0.6706    0.1882],[ length(isamenow) 1] );

lbtime2={};
for i=1:size(lbtime,1)
   rgb=usecol(i,:);
    hxcol=['#' reshape(sprintf('%02X',(round(255*rgb)).'),6,[]).'  ];
    ms=['<html><p style="background-color:'  hxcol '">' lbtime{i}  '  #1)' line1{i}  repmat('&nbsp;',[1 50])];
    lbtime2{i,1}=ms;
end
set(h5,'string',lbtime2);
% set(gco,'value',1','string',{'<html><p style="background-color:red;">Hello World</h1>'})

% currcal=lbtime2{end}
% sep=strfind(currcal,'#1)');
% currcal2=currcal(1:sep+30)
set(h4,'string',lbtime2{end},'style','listbox');
uicontrol(h5);


% % paramguipref.hist.time
us.paramhist.lbtime= (lbtime2);
us.paramhist.lblist= (lblist);
set(gcf,'userdata',us);


function paramguihistoryDarag(e,e2)

us=get(gcf,'userdata');
set(gcf,'units','norm');
% try
units=get(0,'units');
set(0,'units','norm');
mp=get(0,'PointerLocation');
set(0,'units',units);

id='ipn1';
hf=gcf;
fp  =get(hf,'position');
hp  =findobj(hf,'tag','pgdrag');
set(findobj(hf,'userdata',id),'units','normalized');

pos =get(hp,'position');
mid=pos(3:4)/2;
newpos=[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4))];
if newpos(1)-mid(1)<0; newpos(1)=mid(1); end
if newpos(2)-mid(2)<0; newpos(2)=mid(2); end
if newpos(1)-mid(1)+pos(3)>1; newpos(1)=1-pos(3)+mid(1); end
if newpos(2)-mid(2)+pos(4)>1; newpos(2)=1-pos(4)+mid(2); end
df=pos(1:2)-newpos+mid;
hx=findobj(hf,'userdata',id);%'ipn1');

pos2=cell2mat(get(hx,'position'));
for i=1:length(hx)
    pos3=[ pos2(i,1:2)-df   pos2(i,[3 4])];
    set(hx(i),'position', pos3);
end
set(findobj(hf,'userdata',id),'units','pixels');
drawnow,
return




% ---------old
us=get(gcf,'userdata');
xy=us.jCodePane.getMousePosition;

hp=findobj(gcf,'tag','pgdrag');
pos=get(hp,'position'); 
taglist={'pgclose' 'pgprev' 'pgnext' 'pglist' 'pgtime'};
% for i=1:length(taglist)
%     hs=findobj(gcf,'tag',taglist{i});
%     set(hs,'visible','off');
% end

viewport=us.jhPanel.getViewport();
startPoint = viewport.getViewPosition();
size = viewport.getExtentSize();

%--------
set(gcf,'units','pixel');
posf=get(gcf,'position');
set(gcf,'units','norm');

%--------


try
    df=pos(1:2)-[get(xy,'x') get(xy,'y')] ;%[xy.x xy.y];
    df
    pos2=get(hp,'position');
    pos2(1)=pos2(1)-df(1);
    df(2)=get(size ,'Height')+df(2);
    pos2(2)=df(2)-pos2(2);
    set(hp,'position',pos2);
   
    
    for i=1:length(taglist)
       
        hs=findobj(gcf,'tag',taglist{i});
%          get(hs,'units')
        pos2=get(hs,'position');
        pos2(1)=pos2(1)-df(1);
        pos2(2)=df(2)-pos2(2);
        set(hs,'position',pos2); 
        set(hs,'position',pos2);
        
    end

end
  drawnow;
  
% for i=1:length(taglist)
%     hs=findobj(gcf,'tag',taglist{i});
%     set(hs,'visible','on');
% end


function paramguihistorychange(e,e2,arg)
 us=get(gcf,'userdata');

 
 
if arg==3 || arg==1 || arg==2 %change
    hl=findobj(gcf,'tag','pglist');
    li=get(hl,'string');
    va=get(hl,'value');
    if arg==1;             va=va-1;
    elseif arg==2;         va=va+1;
    end
    if va==0;         va=1;          end
    if va>length(li); va=length(li); end
        
    ht=findobj(gcf,'tag','pgtime');
    %disp(['value: ' num2str(va)]);
    set(ht,'string',li{va});
    set(hl,'value',va);
    
    if va==1 
        set(findobj(gcf,'tag','pgprev'),'enable','off');
    else
        set(findobj(gcf,'tag','pgprev'),'enable','on');
    end
    if va==length(li)
        set(findobj(gcf,'tag','pgnext'),'enable','off');
    else
        set(findobj(gcf,'tag','pgnext'),'enable','on');
    end
    
    list=us.paramhist.lblist(va);
    us.jCodePane.setText(list);
    drawnow;
    updateIconposition();
    drawnow;
     updateIconposition();
    uicontrol(findobj(gcf,'tag','pglist'));
end
if arg==0 %delete
  
delete(findobj(gcf,'tag','pgprev') );
delete(findobj(gcf,'tag','pgnext') );
delete(findobj(gcf,'tag','pgclose') );
delete(findobj(gcf,'tag','pgtime') );
delete(findobj(gcf,'tag','pglist') ); 
delete(findobj(gcf,'tag','pgdrag') );

end




%% that

function paramguihelp(e,e2)
uhelp('paramgui.m');

function cancelate(e,e2)
drawnow
uiresume(gcf);
varargout{1}=[];
drawnow
close(findobj(0,'tag','paramgui'));
drawnow
%   return
% evalin('caller','return');
% error('');
% 'a'

% clc;

% try
%   % Some code that throws an exception....
%    u=a;
% catch ME
% 	errorMessage = sprintf('Error in function BlahSnafuFubar().\n\nError Message:\n%s', ME.message);
% 	fprintf(1,'%s\n', errorMessage);
% 	uiwait(warndlg(errorMessage));
% end




function [varargout]=getdata
drawnow
hf=findobj(gcf,'tag','paramgui');
us=  get(findobj(0,'tag','paramgui'),'userdata');
v=us.v;

try
    txt=us.jCodePane.getText;
catch
    error('..process cancelled (GUI-based)');
    return
end
if strcmp(v.out,'pass')
    varargout{1}=char(txt);
else
    eval(txt);
    varargout{1}=x;
end

eval(txt);
varargout{2}=x;

try
    c=list2cell(char(txt), us.dat );
    varargout{3}=c;
catch
    varargout{3}=[];
end

%'PARAMETERS'
params.cb1=get(findobj(gcf,'tag','cb1'),'value');
varargout{4}=params;



function figkey(h,e)

% if strcmp(e.Key,'f3')
%     hbut=findobj(gcf,'tag','pb1');
%     hgfeval(get(hbut,'Callback'));
% end





function showhelp(h,e,info)

if strfind(char(info{1}),'doc');
    hgfeval(info);
elseif strfind(char(info{1}),'uhelp');
    %     hgfeval(info);
    uhelp(info{2});
else
    uhelp(info(:),1,'position',[.75 .5 .25 .4]);
end

function keypress(jEditbox, eventData)
% The following comments refer to the case of Alt-Shift-b
keyChar = get(eventData,'KeyChar');  % or: eventData.getKeyChar  ==> 'B'
isAltDown = get(eventData,'AltDown');  % ==> 'on'
isAltDown = eventData.isAltDown;  % ==> true
modifiers = get(eventData,'Modifiers');  % or: eventData.getModifiers ==> 9 = 1 (Shift) + 8 (Alt)
modifiersDescription = char(eventData.getKeyModifiersText(modifiers));  % ==> 'Alt+Shift'
% (now decide what to do with this key-press...)

% get(eventData)

% jPopup = findjobj(findobj(gcbf,'Tag','popupmenu1'));
% jPopup.hidePopup();
% jPopup.showPopup();

e=eventData;


% arror-scroll
if get(e,'KeyCode') ==40 || get(e,'KeyCode') ==38 % [40]down-arrow,[38]up-arrow
    % 'down'
    us=get(gcf,'userdata');
    scroll=us.jCodePane.getY;
    %disp(scroll);
    if scroll~=us.lastYscroll
        pos=us.jCodePane.getCaretPosition;
        %       linum=us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition);
        updateIconposition();
        us.jCodePane.setCaretPosition(pos);
        us.lastYscroll=scroll;
        set(gcf,'userdata',us);
    end
    
%     
% elseif get(e,'KeyCode') ==38 % up-arrow
%     %'up'
%     us=get(gcf,'userdata');
%     pos=us.jCodePane.getCaretPosition;
%     %       linum=us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition);
%     updateIconposition();
%     us.jCodePane.setCaretPosition(pos);
    
end

% if strcmp(get(e,'KeyChar'),'p')  %preferences
if get(e,'ControlDown')==1 && get(e,'KeyCode') ==80 % 'p' 
    preferences_win();
    return
end
if get(e,'MetaDown')==1 && get(e,'KeyCode') ==80 % 'p' 
    preferences_win();
    return
end
if (get(e,'MetaDown')==1 && get(e,'KeyCode') ==39)  ||...  % 'right-arrow' --> autowidth
   ( get(e,'ControlDown')==1 && get(e,'KeyCode') ==39)
    autowidth();
    return
     %get(e,'KeyCode')
end
% get(e,'KeyCode')

if (get(e,'MetaDown')==1     && get(e,'KeyCode') ==40)  ||...  % 'down-arrow' --> autoHeight
   ( get(e,'ControlDown')==1 && get(e,'KeyCode') ==40)
    autoheight()
    return
     %get(e,'KeyCode')
end

if (get(e,'MetaDown')==1 && get(e,'KeyCode') ==38)  ||...  % 'up-arrow' --> last/orig size
        ( get(e,'ControlDown')==1 && get(e,'KeyCode') ==38)
    us=get(gcf,'userdata');
    set(gcf,'position',us.origfigposition);
    return
    %get(e,'KeyCode')
end
if (get(e,'MetaDown')==1 && get(e,'KeyCode') ==37)  ||...  % 'left-arrow' --> autowidth
        ( get(e,'ControlDown')==1 && get(e,'KeyCode') ==37)
    us=get(gcf,'userdata');
    set(gcf,'position',us.lastfigposition);
    return
    %get(e,'KeyCode')
end
% us=get(gcf,'userdata');
% us.lastfigposition=get(gcf,'position');





hp=findobj(gcf,'tag','pulldown');
if ~isempty(hp)
    n=length(get(hp,'string'));
    val=get(hp,'value');
    if get(e,'KeyCode') ==40;%  strcmp(e.Key,'downarrow');
        if val<n
            set(hp,'value',val+1);
        end
    elseif get(e,'KeyCode') ==38 % strcmp(e.Key,'uparrow')
        if val>1
            set(hp,'value',val-1);
        end
    elseif get(e,'KeyCode') ==10 % return
        ps=get(findobj(gcf,'tag','pulldown'),'callback');
        ps2=[ps(1);{[]};{[]};ps(2:end)];
        hgfeval(ps2);
    end
end

%     clc
%     keyChar
%     isAltDown
%     modifiers
%     modifiersDescription

%% F3 run-button
if get(eventData,'KeyCode')==114;
    %     hbut=findobj(gcf,'tag','pb1');
    %     hgfeval(get(hbut,'Callback'));
    %
    
    us=get(gcf,'userdata');
    %    get line
    lastcurpos=us.jCodePane.getCaretPosition;
    linenum=us.jCodePane.getLineFromPos(lastcurpos);
    txcurrline=char(us.jCodePane.getLineText(linenum));
    
    r=findobj(gcf,'style','pushbutton');
    iicons=[];
    for i=1:length(r)
        try
            if strcmp(func2str(r(i).Callback),'pbcb')
                iicons=[iicons i];
            end
        end
    end
    r=r(iicons);
    
    userdat=get(r,'userdata');
    currvarname=regexprep(txcurrline,'\s*=.*','');
    ibut=find(strcmp(userdat,currvarname)); %this button
    hbut=r(ibut);
    hgfeval(get(hbut,'Callback'),hbut);
    try
        us.jCodePane.setCaretPosition(lastcurpos);
    end
    
end

if  get(eventData,'KeyCode')==112
    us=get(gcf,'userdata');
    hp=findobj(gcf,'tag','pb1');
    if ~isempty(hp)
        hgfeval(get(hp,'callback'));
    end
end


function pbhist(he,e,task)
us=get(gcf,'userdata');
r=us.jCodePane;

set(r,'CaretUpdateCallback','');
% carpos=us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition());
if task==-1
    if us.historyValue>1
        r.setText(  char(us.history{us.historyValue-1}));
        us.historyValue=us.historyValue-1;
    end
end
if task==1
    if us.historyValue<length(us.history)
        r.setText(  char(us.history{us.historyValue+1}));
        us.historyValue=us.historyValue+1;
    end
end
if us.historyValue==length(us.history)
    set(findobj(gcf,'tag','pb4'),'enable','off');
else
    set(findobj(gcf,'tag','pb4'),'enable','on');
end
if us.historyValue==1
    set(findobj(gcf,'tag','pb3'),'enable','off');
else
    set(findobj(gcf,'tag','pb3'),'enable','on');
end
set(gcf,'userdata',us);

% r.setCaretPosition(carpos);
set(r,'CaretUpdateCallback',@showIcon);

function pbhelp(he,e,infox)
if isstr(infox)
    if exist(infox)==2
        eval(['doc ' infox;]);
    else
        uhelp(cellstr(infox));
    end
else
    uhelp( (infox));
end




% ==============================================
%%   updateIconposition_cb
% ===============================================

function updateIconposition_cb(e,e2)

% us=get(gcf,'userdata');
% drawnow
% tx1=get_visibletext();
% pos=us.jCodePane.getCaretPosition;
%
%
% scroll=us.jCodePane.getY

updateIconposition();

% tx2=get_visibletext();

% if strcmp(tx1,tx2)==1 %match
% disp('match');
% else
%    disp('no-match');
%    us.jCodePane.setCaretPosition(pos);
% end
%

return

persistent atime
if isempty(atime)
    atime=tic;
end
persistent check % Shared with all calls of pushbutton1_Callback.
delay = .1; % Delay in seconds.
% Count number of clicks. If there are no recent clicks, execute the single
% click action. If there is a recent click, ignore new clicks.
if isempty(check)
    check = 1;
    disp('Single click action');
    %     set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',[]);
    %     updateIconposition();
else
    check = [];
    drawnow;
    %     pause(delay)
    disp( ['moved ' num2str(toc(atime))      ]);
    atime=tic;
    %    set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',@updateIconposition_cb);
    updateIconposition();
end
return








updateIconposition();



function textselextion=get_visibletext()

us=get(gcf,'userdata');


viewport=us.jhPanel.getViewport();
startPoint = viewport.getViewPosition();
size = viewport.getExtentSize();

startPoint=java.awt.Point(startPoint.x + 0, startPoint.y  );
endPoint = java.awt.Point(startPoint.x + size.width, startPoint.y + size.height );

%     endPoint = java.awt.Point(startPoint.x + size.width, startPoint.y + size.height);

start=us.jCodePane.viewToModel( startPoint );
ende =us.jCodePane.viewToModel( endPoint );
tx=char(us.jCodePane.getText(start, ende - start));

textselextion=tx;


function flag=isMultipleCall()
flag = false;
% Get the stack
s = dbstack();
disp(numel(s));



return
if numel(s)<=2
    % Stack too short for a multiple call
    disp(numel(s));
    return
end
% How many calls to the calling function are in the stack?
names = {s(:).name};
TF = strcmp(s(2).name,names);
count = sum(TF);
if count>1
    % More than 1
    flag = true;
end
disp(numel(s));

function mousescroll(e,e2)

us=get(gcf,'userdata');

% if isempty(get(us.jhPanel,'MouseWheelMovedCallback'))
%     sisp('....leer');
% else
%    disp( '...foll');
% end

scroll=us.jCodePane.getY;
if scroll==0; return; end


% disp(scroll);
if ~isfield(us ,'scroll');
    us.scroll=-1e6;
    set(gcf,'userdata',us);
end

set(us.jhPanel,'MouseWheelMovedCallback',[]);
drawnow;drawnow;drawnow;drawnow;drawnow;
pause(.5);
drawnow();

% if isempty(get(us.jhPanel,'MouseWheelMovedCallback'))
%     disp(['FF: empty' ]);
% else
%     disp(['EE:' func2str(get(us.jhPanel,'MouseWheelMovedCallback'))]);
% end

% updateIconposition();
% drawnow;

% if us.scroll~=scroll
updateIconposition(); drawnow
%      disp('update');
% end

cbfun=get(us.jhPanel,'MouseWheelMovedCallback');
% disp(cbfun);
% 'whel'
set(us.jhPanel,'MouseWheelMovedCallback',@mousescroll);
% us.wheel=us.wheel+1;
% set(gcf,'userdata',us);

us.scroll=scroll;
set(gcf,'userdata',us);

return


disp(scroll);
if ~isfield(us ,'scroll');
    us.scroll=-1e6;
    set(gcf,'userdata',us);
end

if us.scroll~=scroll
    updateIconposition();
    disp('update');
end


us.scroll=scroll;
set(gcf,'userdata',us);





return
persistent returnFlag
if ~isempty(returnFlag)
    return
end
returnFlag=1;
disp('do something');
returnFlag=[];

return

persistent UHELP_RunOnce_Flag0001
if isempty(UHELP_RunOnce_Flag0001)
    UHELP_RunOnce_Flag0001 = 1;
    disp('empty');
end

if UHELP_RunOnce_Flag0001==0
    disp('0');
    return
end

if UHELP_RunOnce_Flag0001==1
    disp('1');
    UHELP_RunOnce_Flag0001 = 0;
end

if UHELP_RunOnce_Flag0001==1
    disp('do no');
    UHELP_RunOnce_Flag0001=[];
end




return
us=get(gcf,'userdata');
if ~isfield(us ,'wheel');
    us.wheel=1;
    set(gcf,'userdata',us);
end
set(us.jhPanel,'MouseWheelMovedCallback',[]);


if us.wheel==1
    pause(.5);
    drawnow();
    
    updateIconposition();
    drawnow;
    
    cbfun=get(us.jhPanel,'MouseWheelMovedCallback');
    disp(cbfun);
    'whel'
    set(us.jhPanel,'MouseWheelMovedCallback',@mousescroll);
    us.wheel=us.wheel+1;
    set(gcf,'userdata',us);
else
    
end
us.wheel

% % 'wheel'
%
%
%  flag=isMultipleCall() ;
%
% %  disp(flag)


return


% persistent atimer
persistent atime
if isempty(atime)
    atimer=tic+1000;
end

thistime=toc(atimer);

if thistime<atime+.2
    disp([ '------'  ]);
    pause(.2);
else
    disp(['++++++'   ]);
end

disp(rand(1));


function preferences_win(e,e2)


%% PREFS

global paramguipref

hf=findobj(0,'tag','paramgui');
us=get(gcf,'userdata');
% prompt = {'use old style (0); new style(1):'};
% prompt = {
%     [...
%     ' VERSION & ICON STYLE (0|1|2) ' char(10) ...
%     '   [0] use new version + multi-icon style' char(10) ...
%     '   [1] use new version + single-icon style' char(10) ...
%     '   [2] use old version  ..use only if [0]or[1] does not run smooth' char(10) ...
%     ]};

prompt = {
    [...
    ' VERSION & ICON STYLE (0|1|2) ' char(10) ...
    '   [0] use old version  ..use only if [1]or[2] does not run smooth' char(10) ...
    '   [1] use new version + single-icon style' char(10) ...
    '   [2] use new version + multi-icon style' char(10) ...
 
    ]};

% prompt='<html><font color="green"><b> Species'
title = 'paramgui preferences';
dims = [1 80];

if isfield(paramguipref,'useoldversion')
  if paramguipref.useoldversion==1
      versicon=0;
  else
      versicon=~paramguipref.mimic_oldstyle+1; 
  end 
end

definput = {num2str(versicon)};
answer = inputdlg(prompt,title,dims,definput);

%% gui-off
if isempty(answer); return; end


carpos=us.jCodePane.getCaretPosition;
if strcmp(answer{1},'0')  
   paramguipref.useoldversion =1; %use OLD bersion
   us.mimic_oldstyle=0;
   paramguipref.mimic_oldstyle=us.mimic_oldstyle;
   msgbox('The old version of paramgui is used when paramgui is executed the next time.','modal');
elseif strcmp(answer{1},'1') 
    paramguipref.useoldversion =0; %use NEW bersion
    us.mimic_oldstyle=1; 
    paramguipref.mimic_oldstyle=us.mimic_oldstyle;
elseif strcmp(answer{1},'2') 
    paramguipref.useoldversion =0; %use NEW bersion
    us.mimic_oldstyle=0; 
    paramguipref.mimic_oldstyle=us.mimic_oldstyle;  
    
end
set(gcf,'userdata',us);
updateIconposition();
us.jCodePane.setCaretPosition(carpos);


function updateIconposition
% us=get(gcf,'userdata');
% txt=us.jCodePane.getText
% CR=strfind(txt,char(10));
% CR=[-1 CR];
% curpos=us.jCodePane.getCaretPosition;
% for i=1:length(CR)-1
%     us.jCodePane.setCaretPosition(CR(i)+1);
%     drawnow;
% end
% us.jCodePane.setCaretPosition(curpos);
% 'updateIconposition'

us=get(gcf,'userdata');
% drawnow;
tx=char(us.jCodePane.getText);

%% visible text only
if 1
    % ==============================================
    %%
    % ===============================================
    % us.jhPanel.setHorizontalScrollBarPolicy(32);
    %   clc
    viewport=us.jhPanel.getViewport();
    startPoint = viewport.getViewPosition();
    size = viewport.getExtentSize();
    
%   startPoint=java.awt.Point(startPoint.x + 0, startPoint.y + 34/2);
%      endPoint = java.awt.Point(startPoint.x + size.width, startPoint.y + size.height-34);
% %     

yd=us.jCodePane.getLineHeight();
startPoint=java.awt.Point(startPoint.x + 0, startPoint.y + yd/2);
endPoint = java.awt.Point(startPoint.x + size.width, startPoint.y + size.height-yd);

%     startPoint=java.awt.Point(startPoint.x + 0, startPoint.y +0);
%     endPoint = java.awt.Point(startPoint.x + size.width, startPoint.y + size.height-0);
%     

    start=us.jCodePane.viewToModel( startPoint );
    ende =us.jCodePane.viewToModel( endPoint );
    try
        tx=char(us.jCodePane.getText(start, ende - start)) ;
    catch
        tx=char(us.jCodePane.getText);
    end;
    
    % ==============================================
    %%
    % ===============================================
    
end





txall=char(us.jCodePane.getText);

r=findobj(gcf,'style','pushbutton');
iicons=[];
for i=1:length(r)
    try
        if strcmp(func2str(r(i).Callback),'pbcb')
            iicons=[iicons i];
        end
    end
end
r=r(iicons);
% set(r,'visible','off');

%sort iconandles
lastcurpos=us.jCodePane.getCaretPosition;
linenum=us.jCodePane.getLineFromPos(lastcurpos);

   

if us.mimic_oldstyle==1
    txcurrline=char(us.jCodePane.getLineText(linenum));
    currvarname=regexprep(txcurrline,'\s*=.*','');
    ifind=find(strcmp(get(r,'userdata'),currvarname));
    if ~isempty(ifind)
        r=r([ setdiff(1:length(r),ifind)  ifind]);
    end
    if ~isempty(r)
        r=r(end);
    end
end




iuse   =[];
inotuse=[];
for j=1:length(r)
    p=r(j);
    % get(r(i),'position')
    varname=get(p,'userdata');
    carposIDX=regexpi(tx,[ varname '\s*=' ]);
    
    carposIDX2=regexpi(txall,[ varname '\s*=' ]);
    
    if ~isempty(carposIDX)
        %         continue
        %     end
        %         set(p,'visible','on');
        try
            
            us.jCodePane.setCaretPosition(carposIDX2);
        end
        drawnow
        %         get(p,'userdata')
        %                 pause(.5); drawnow
        %         %        showIcon();
        %              set(p,'visible','on');
        iuse(end+1)=j;
        %         CR=[-1 strfind(tx,char(10))];
        %         carpos=max(find(CR<carposIDX))-1;
    else
        inotuse(end+1)=j;
    end
end


set(r(iuse),'visible','on');
set(r(inotuse),'visible','off');

% us.jCodePane.setCaretPosition(lastcurpos);

% us.jCodePane.setCaretPosition(lastcurpos);

return

height=us.jCodePane.getHeight();
yd=us.jCodePane.getLineHeight();
numli=us.jCodePane.getNumLines();


screen=get(0,'MonitorPositions');
if screen(3)>1600;
    yd=yd*2;
end
% if ismac==1
if ~ispc
    if screen(3)>1300;
        yd=yd*2;
    end
end


% height

for j=1:length(r)
    p=r(j);
    % get(r(i),'position')
    varname=get(p,'userdata');
    carposIDX=regexpi(tx,[ varname '\s*=' ]);
    if ~isempty(carposIDX)
        %         continue
        %     end
        set(p,'visible','on');
        CR=[-1 strfind(tx,char(10))];
        carpos=max(find(CR<carposIDX))-1;
        %     carpos
        
        if carpos+1>numli; return; end
        %     % return
        %     tb=[];
        %     n=0;
        %     for i=1:(numli)
        %         drawnow;
        %         %pos=us.jCodePane.getLineFromPos(n)
        %         nsign=us.jCodePane.getLineStart(n);
        %         pnt= us.jCodePane.getPointFromPos(nsign);
        %         xy=[pnt.x pnt.y];
        %         tb(i,:)=[i nsign xy];
        %         n=n+1;
        %     end
        %
        %     idx=find(tb(:,1)==carpos)+1
        %
        %
        %         scroll=us.jCodePane.getY;
        %            scroll
        %     scroll=-(scroll/2);
        %     y0=height/2;
        %
        %
        %     screen=get(0,'MonitorPositions');
        %     if screen(3)>1600;
        %         yd=yd*2;
        %     end
        %     if ~ispc
        %         if screen(3)>1300;
        %             yd=yd*2;
        %         end
        %     end
        
        % delete(findobj(gcf,'userdata',varnamefull));
        %     i=carpos;
        %     iconpos=[0 y0+(29/4)-(i*29/2)-(yd/2)/3+scroll yd/2 yd/2 ];
        %     set(p,'position',[[0 tb(end,4)-tb(idx,4) yd/2 yd/2 ]]);
        
        %         [length(txall) length(tx)]
        if length(txall)==length(tx)
            set(p,'position',[[0 height/2-((yd/2)*(carpos+0))+yd/10 yd/2 yd/2 ]]);
            
            
        else
            set(us.hContainer,'units','pixel');
            poscon=get(us.hContainer,'position');
            
            %         set(p,'position',[[0 height/2-((yd/2)*(carpos+0))+yd/4 yd/2 yd/2 ]]);
            %posy=(1-(carpos+1)./length(CR))*poscon(4)+poscon(2)
            posy=(1-(carpos+1)./length(CR))*(poscon(4)-poscon(2)-poscon(1))+poscon(1);
            set(p,'position',[0 posy yd/2 yd/2]);
            %             set(p,'position',[[0  ((1-(carpos+1)./length(CR))*poscon(4))+yd/8  yd/2 yd/2 ]]);
            set(us.hContainer,'units','normalized');
        end
        
    end
end %j


function autowidth(e,e2)
us=get(gcf,'userdata');
carposOrig=us.jCodePane.getCaretPosition;
tx=char(us.jCodePane.getText);

% if isfield(us,'lastfigposition')==0
us.lastfigposition=get(gcf,'position');  %REMEMBER ############
set(gcf,'userdata',us);
% end

% yd=us.jCodePane.getLineHeight()

tc=strsplit(tx,char(10))';
len=cell2mat(cellfun(@(a){length(a)},tc));
cr=regexpi(tx,char(10));
crdiff=diff(cr);
imax=min(find(crdiff==max(crdiff))+1);

caret=cr(imax)-1;
us.jCodePane.setCaretPosition(caret);
us.jCodePane.requestFocus();

po=us.jCodePane.getPointFromPos(caret);
if ispc; 
    po.x=po.x/2;
end

% us.jCodePane.getBounds
set(gcf,'units','pixels'); 
pos=get(gcf,'position'); 
pos2=pos;
pos2(3)=po.x+40;
screen=get(0,'ScreenSize');
if pos2(1)+pos2(3)>screen(3)
    pos2(1)=pos2(1)-((pos2(1)+pos2(3))-screen(3)+20);
end
if abs(pos2(1))+pos(3)>screen(3)
    pos2(1)=0;
    pos2(3)=screen(3);
end
set(gcf,'position',pos2);
set(gcf,'units','norm');
us.jCodePane.setCaretPosition(carposOrig);


function autoheight(e,e2)

%% autoheight
us=get(gcf,'userdata');
carposOrig=us.jCodePane.getCaretPosition;
tx=char(us.jCodePane.getText);

% if isfield(us,'lastfigposition')==0
us.lastfigposition=get(gcf,'position');  %REMEMBER ############
set(gcf,'userdata',us);
% end
%

tc=strsplit(tx,char(10))';
len=length(tc);

yd=us.jCodePane.getLineHeight();
if ispc; yd=yd/2; end


% us.jCodePane.getBounds
screenunits=get(0,'units');
set(0,'units','pixels'); 

set(gcf,'units','pixels'); 
pos=get(gcf,'position'); 
pos2=pos;
pos2(4)=yd*len+3*yd;
screen=get(0,'ScreenSize');
% pos2(2)=pos2(2)+(pos2(4))/2;
pos2(2)=screen(4)-(pos2(4)+screen(4)/10);
% if pos2(2)+pos2(4)>screen(4)
%     pos2(1)=pos2(1)-((pos2(1)+pos2(3))-screen(3)+20);
% end
set(gcf,'position',pos2);
set(gcf,'units','norm');
us.jCodePane.setCaretPosition(carposOrig);
set(0,'units',screenunits);

%%
% ==============================================
%%   prepicon
% ===============================================
function prepicon()
drawnow
us=get(gcf,'userdata');

us.lastfigposition=get(gcf,'position');
set(gcf,'userdata',us);


txt=char(us.jCodePane.getText);
tb=strsplit((txt),char(10))';
for i=1:length(tb)
    [icon tooltip varnamefull]=getIcon2(i);
    if ~isempty(icon)
        p=uicontrol('style','pushbutton','units','pixels' ,'position',[0 0 30 30 ],...
            'tag','open','userdata',varnamefull,'visible','off');
        set(p,'callback',@pbcb) ;%'delete(findobj(gcf,''tag'',''open''))'
        %         drawnow;
        %tooltip
        try
            itab=find(strcmp(us.dat(:,1),regexprep(varnamefull,'.*\.','')));
            lg=[['<html>   <b><font color="green">'  varnamefull '</font></b>' '<br>'] ...]
                [  char(us.dat(itab,3)) '<br>'] ...
                [  '<u><font color="blue">'  'input type:'  '</font></u>' ' ' tooltip '<br>'] ...
                [  '</html>'] ...
                ];
            tooltip2=lg;
        catch
            tooltip2=tooltip;
        end
        set(p,'TooltipString',tooltip2)% ps(i+1)=p;
        
        if ~isempty(regexpi(icon,'.gif$'))
            [e map]=imread(icon)  ;
            e=ind2rgb(e,map);
            e(e<=0.01)=nan;
        else
            e=double(imread(icon));
            e=e/max(e(:));
            e(e<=0.01)=nan;
            if ndims(e)==2
                e=repmat(e,[1 1 3]);
            end
        end
        
        set(p,'cdata',e);
        
    end
end

%     us.jCodePane.setCaretPosition(1);

% ==============================================
%%   show icon
% ===============================================

function showIcon(he,e)
% updateIconposition();
drawnow;
us=get(gcf,'userdata');
if ~isempty(findobj(gcf,'tag','pulldown')) ; return; end


carpos=us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition());
% pnt= us.jCodePane.getPointFromPos(carpos)
%    xy=[pnt.x pnt.y]

height=us.jCodePane.getHeight();
yd=us.jCodePane.getLineHeight();
numli=us.jCodePane.getNumLines();

% carpos


if carpos+1>numli; return; end
% return
% tb=[];
% n=0;
% for i=1:(numli)
%     drawnow;
%     %pos=us.jCodePane.getLineFromPos(n)
%     nsign=us.jCodePane.getLineStart(n);
%     pnt= us.jCodePane.getPointFromPos(nsign);
%     xy=[pnt.x pnt.y];
%     tb(i,:)=[i nsign xy];
%     n=n+1;
% end

scroll=us.jCodePane.getY;
scroll=-(scroll/2);
y0=height/2;


try
    [icon tooltip varnamefull]=getIcon;
catch
    return
end
if isempty(icon); return; end
screen=get(0,'MonitorPositions');
if screen(3)>1600;
    yd=yd*2;
end
% if ismac==1
if ~ispc
    if screen(3)>1300;
        yd=yd*2;
    end
end

% delete(findobj(gcf,'userdata',varnamefull));
i=carpos+1;
p=findobj(gcf,'userdata',varnamefull);
if isempty(p)
    p=uicontrol('style','pushbutton','units','pixels' ,'position',[0 y0+(29/4)-(i*29/2)-(yd/2)/3+scroll yd/2 yd/2 ],...
        'tag','open','userdata',varnamefull);
    % else
    %     set(p,'position',[0 y0+(29/4)-(i*29/2)-(yd/2)/3+scroll yd/2 yd/2 ]);
    % end
    set(p,'callback',@pbcb) ;%'delete(findobj(gcf,''tag'',''open''))'
    
    %tooltip
    try
        itab=find(strcmp(us.dat(:,1),regexprep(varnamefull,'.*\.','')));
        lg=[['<html>   <b><font color="green">'  varnamefull '</font></b>' '<br>'] ...]
            [  char(us.dat(itab,3)) '<br>'] ...
            [  '<u><font color="blue">'  'input type:'  '</font></u>' ' ' tooltip '<br>'] ...
            [  '</html>'] ...
            ];
        tooltip2=lg;
    catch
        tooltip2=tooltip;
    end
    set(p,'TooltipString',tooltip2)% ps(i+1)=p;
    
    if ~isempty(regexpi(icon,'.gif$'))
        [e map]=imread(icon)  ;
        e=ind2rgb(e,map);
        e(e<=0.01)=nan;
    else
        e=double(imread(icon));
        e=e/max(e(:));
        e(e<=0.01)=nan;
    end
    set(p,'cdata',e);
    
else
    set(p,'position',[0 y0+(29/4)-(i*29/2)-(yd/2)/3+scroll yd/2 yd/2 ]);
    
    try % if figure-Y-position is to small--> error
    %% ALTERNATIVE-CURSOR
    pos3=us.jCodePane.getCursorPercentFromTop();
    
    
    ax1=findobj(gcf,'tag','axe1');
    axpix=uni2uni(ax1,'position','pixels');
    %  axpix=uni2uni(gcf,'position','pixels')
    apix2=axpix(4);%yd*.75;
    % ypos2=axpix(4)-axpix(4)*(pos3/100)
    
    nn=(pos3/100)*yd/2;
    ypos2=(apix2-apix2*((pos3)/(100)))+nn;
    set(p,'position',[0  ypos2-yd.*.6    yd/2 yd/2 ]);  %145
    end
    
end



% %% ALTERNATIVE-CURSOR
% pos3=us.jCodePane.getCursorPercentFromTop();
% ax1=findobj(gcf,'tag','axe1');
% axpix=uni2uni(ax1,'position','pixels');
% %  axpix=uni2uni(gcf,'position','pixels')
% apix2=axpix(4);%yd*.75;
% % ypos2=axpix(4)-axpix(4)*(pos3/100)
%
% nn=(pos3/100)*yd/2;
% ypos2=(apix2-apix2*((pos3)/(100)))+nn;
% set(p,'position',[0  ypos2-yd/2    yd/2 yd/2 ]);  %145


if 0
    'a'
    r=us.jCodePane
    [r.modelToView( r.getCaretPosition() ).x r.modelToView( r.getCaretPosition() ).y]
    r.getY
    height=us.jCodePane.getHeight()
    yd=us.jCodePane.getLineHeight()
    numli=us.jCodePane.getNumLines()
    
    yw=r.modelToView( r.getCaretPosition() ).y
    yscroll=r.getY
    carpos=us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition())
    
    height=us.jCodePane.getHeight()
    
    yw+yscroll
    set(p,'position',[0  145   yd/2 yd/2 ])  %145
end



%   c=uni2uni(us.hContainer,'position','pixels');
% f=uni2uni(gcf,'position','pixels');


delete(findobj(gcf,'tag','pulldown'));

if us.mimic_oldstyle==1
    set(p,'visible','on')
    
    r=findobj(gcf,'style','pushbutton');
    iicons=[];
    for i=1:length(r)
        try
            if strcmp(func2str(r(i).Callback),'pbcb')
                iicons=[iicons i];
            end
        end
    end
    r=r(iicons);
    set(setdiff(r,p),'visible','off');

end



% updateIconposition();

%MOUSECLICK
% import java.awt.Robot;
% import java.awt.event.*;
% mouse = Robot;
% mouse.mouseMove(100, 100);
% mouse.mousePress(InputEvent.BUTTON2_MASK);    //left click press
% mouse.mouseRelease(InputEvent.BUTTON2_MASK);

%  updateIconposition();


function [icon tooltip varnamefull]=getIcon
us=get(gcf,'userdata');
varname=[];

r=us.jCodePane;
tx=char(r.getText);
val=r.getLineFromPos(r.getCaretPosition())+1;




% carpos=r.getLineFromPos(r.getCaretPosition())
% carpos=r.getCaretPosition();

%tx modiic
ict=[0 strfind(tx,char(10)) length(tx) ];
tx2={};
for i=1:length(ict)-1
    tx2{end+1,1}=tx(ict(i)+1: ict(i+1)-1 );
end

lin=tx2(val);
if isempty(lin{1}); return; end
si1=min(cell2mat(strfind(lin,'=')));
si2=min([min(cell2mat(strfind(lin,'%')))  length(lin{1})+1 ]);
tb{1,1}=[lin{1}(1:si1) ];
tb{2,1}=[lin{1}(si1+1:si2-1) ];
tb{3,1}=[lin{1}(si2:end) ];
varname=char(  regexprep(tb(1),{'x\.' '='},'') );
varname=deblank(varname);

varnamefull=char(deblank(regexprep(tb(1),{'' '='},'')));

%find index in OrigTable
idx=find(strcmp(us.dat(:,1),varname));

% tx3=tx2;
try
    if strcmp(us.dat{idx,4},'col')
        icon =which('color.gif'); %file_open.png');
        tooltip='GET COLOR';
    elseif strcmp(us.dat{idx,4},'f')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png'); %file_open.png');
        icon =which('file.gif');
        tooltip='GET FILE';
    elseif strcmp(us.dat{idx,4},'mf')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png'); %file_open.png');
        icon =which('file.gif');
        tooltip='GET MULTIPLE FILES';
    elseif strcmp(us.dat{idx,4},'d')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/dir.gif');%foldericon.gif');
        icon=which('dir.gif');
        tooltip='GET DIRECTORY';
    elseif strcmp(us.dat{idx,4},'b')
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/tool_font_bold.png');
        tooltip='BOOLEAN {0;1}';
    elseif ~isempty(strfind(us.dat{idx,4},'{'))
        icon=which('pulldown3.gif');
        %icon = fullfile(matlabroot,'/toolbox/matlab/icons/pageicon.gif');%tool_text_align_justify.png');
        tooltip='pulldown';
    else
        icon=[];
        tooltip='';
    end
end
%    help_ex.png

try
    if iscell(us.dat{idx,4})
        %         icon = fullfile(matlabroot,'/toolbox/matlab/icons/pageicon.png');
        icon=which('pulldown3.gif');
        tooltip='pulldown';
    end
end
%% CELL_FUNCTION HANDLE
try
    if  iscell(us.dat{idx,4})
        w=us.dat{idx,4};
        if strcmp(class(w{1}),'function_handle')
            %      icon=which('pulldown3.gif');
            icon = fullfile(matlabroot,'/toolbox/matlab/icons/help_gs.png');%tool_text_align_justify.png');
            tooltip='myfun';
        end
    end
    
end



function [icon tooltip varnamefull]=getIcon2(line)
icon=[];tooltip=[];varnamefull=[];
us=get(gcf,'userdata');
varname=[];

r=us.jCodePane;
tx=char(r.getText);
% val=r.getLineFromPos(r.getCaretPosition())+1;

val=line;


% carpos=r.getLineFromPos(r.getCaretPosition())
% carpos=r.getCaretPosition();

%tx modiic
ict=[0 strfind(tx,char(10)) length(tx) ];
tx2={};
for i=1:length(ict)-1
    tx2{end+1,1}=tx(ict(i)+1: ict(i+1)-1 );
end

lin=tx2(val);
if isempty(lin{1}); return; end
si1=min(cell2mat(strfind(lin,'=')));
si2=min([min(cell2mat(strfind(lin,'%')))  length(lin{1})+1 ]);
tb{1,1}=[lin{1}(1:si1) ];
tb{2,1}=[lin{1}(si1+1:si2-1) ];
tb{3,1}=[lin{1}(si2:end) ];
varname=char(  regexprep(tb(1),{'x\.' '='},'') );
varname=deblank(varname);

varnamefull=char(deblank(regexprep(tb(1),{'' '='},'')));

%find index in OrigTable
idx=find(strcmp(us.dat(:,1),varname));

% tx3=tx2;
try
    if strcmp(us.dat{idx,4},'col')
        icon =which('color.gif'); %file_open.png');
        tooltip='GET COLOR';
    elseif strcmp(us.dat{idx,4},'f')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png'); %file_open.png');
        %icon =which('file.gif');
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/book_link.gif');
        tooltip='GET FILE';
    elseif strcmp(us.dat{idx,4},'mf')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png'); %file_open.png');
        %icon =which('file.gif');
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/book_mat.gif');
        tooltip='GET MULTIPLE FILES';
    elseif strcmp(us.dat{idx,4},'d')
        %     icon = fullfile(matlabroot,'/toolbox/matlab/icons/dir.gif');%foldericon.gif');
        %icon=which('dir.gif');
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png');
        tooltip='GET DIRECTORY';
    elseif strcmp(us.dat{idx,4},'b')
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/tool_font_bold.png');
        tooltip='BOOLEAN {0;1}';
    elseif ~isempty(strfind(us.dat{idx,4},'{'))
        icon=which('pulldown3.gif');
        icon=which('curly-brackets.png');
        %icon = fullfile(matlabroot,'/toolbox/matlab/icons/pageicon.gif');%tool_text_align_justify.png');
        tooltip='pulldown';
    else
        icon=[];
        tooltip='';
    end
end
%    help_ex.png

try
    if iscell(us.dat{idx,4})
        %         icon = fullfile(matlabroot,'/toolbox/matlab/icons/pageicon.png');
        %icon=which('pulldown3.gif');
        %icon=which('curly-brackets.png');
        icon = fullfile(matlabroot,'/toolbox/matlab/icons/tool_legend.png');
        tooltip='pulldown';
        
    end
end
%% CELL_FUNCTION HANDLE
try
    if  iscell(us.dat{idx,4})
        w=us.dat{idx,4};
        if strcmp(class(w{1}),'function_handle')
            %      icon=which('pulldown3.gif');
            icon = fullfile(matlabroot,'/toolbox/matlab/icons/help_gs.png');%tool_text_align_justify.png');
            tooltip='external function';
        end
    end
    
end








function pb1callback(h,e,v)

us=get(gcf,'userdata');

try % history saved
    global paramguipref
%     paramguipref.hist.time(end+1,1)={datestr(now)};
%     paramguipref.hist.list(end+1,1)=us.jCodePane.getText;
    try
    paramguipref.hist.time=[paramguipref.hist.time; {datestr(now)} ];
    paramguipref.hist.list=[paramguipref.hist.list; us.jCodePane.getText]; 
    catch
    paramguipref.hist.time=[  {datestr(now)} ];
    paramguipref.hist.list=[  us.jCodePane.getText];     
    end
catch
    disp('no history saved (paramguipref)');
 end
uiresume(gcf);

function pb1CB(h,e,arg)
r=get(h,'callback');
r2=r{2};
uiresume(gcf)

hgfeval(r2)
%paul

function pbcb(h,e)% ICON CLICKED
drawnow;
us=get(gcf,'userdata');
r=us.jCodePane;
tx=char(r.getText);

% posvar=strfind(tx,get(h,'userdata'));
posvar=regexpi(tx,[ get(h,'userdata') '\s*=' ]);
r.setCaretPosition(posvar);
showIcon();

val=r.getLineFromPos(r.getCaretPosition())+1;


% carpos=r.getLineFromPos(r.getCaretPosition())
carpos=r.getCaretPosition();

%tx modiic
ict=[0 strfind(tx,char(10)) length(tx) ];
tx2={};
for i=1:length(ict)-1
    tx2{end+1,1}=tx(ict(i)+1: ict(i+1)-1 );
end

lin=tx2(val);
si1=min(cell2mat(strfind(lin,'=')));
si2=min([min(cell2mat(strfind(lin,'%')))  length(lin{1})+1 ]);
tb{1,1}=[lin{1}(1:si1) ];
tb{2,1}=[lin{1}(si1+1:si2-1) ];
tb{3,1}=[lin{1}(si2:end) ];
varname=char(  regexprep(tb(1),{'x\.' '='},'') );
varname=deblank(varname);
%find index in OrigTable
idx=find(strcmp(us.dat(:,1),varname));
tx3=tx2;

iscellmode=0;
try;
    if  ~isempty(strfind(us.dat{idx,4},'{'))
        iscellmode=1;
    end
end
try;
    if  iscell(us.dat{idx,4})
        iscellmode=2;
    end
end

try
    isfunmode=0;
    w=us.dat{idx,4};
    if strcmp(class(w{1}),'function_handle')
        iscellmode=0;
        isfunmode=1;
    end
    
end



if strcmp(us.dat{idx,4},'col')
    set(r,'CaretUpdateCallback','');
    drawnow;
    pointer=get(0,'PointerLocation');
    newtag=uisetcolor;
    if newtag==0; return; end
    n=[tb{1} [ '[  '  sprintf('%2.2f  ',newtag) ']'   ] ';'  char(9) tb{3} ];
    pause(.1);
    drawnow;
    %       set(r,'CaretUpdateCallback',{@disp,'1'});
    drawnow;
    set(0,'PointerLocation',pointer);
    
    
    
    set(r,'CaretUpdateCallback',@showIcon);
elseif strcmp(us.dat{idx,4},'f')
    dum=us.dat{idx,2};
    if exist(dum)==7
        prepwd=(dum) ;
    elseif exist(dum)==2
        prepwd=fileparts(dum) ;
    else
        prepwd=pwd;
    end
    try
        [fi]=  cfg_getfile2(1,'any',{'ee';'rrr'},{},prepwd,'.*' ,[]);
        fi=char(fi);
    catch
        % [fi pa]=uigetfile([prepwd ],'D',[],'multiselect','off');
        [fi pa]=uigetfile([fullfile(prepwd,'*.*') ],['select file'],'multiselect','off');
        
        fi=fullfile(pa,fi);
    end
    
    newtag=fi;
    n=[tb{1} [ '''' newtag '''' ';' char(9) ] tb{3}];
    
elseif strcmp(us.dat{idx,4},'mf')
    dum=us.dat{idx,2};
    if ischar(dum); dum=cellstr(dum); end
    dum=char(dum);
    
    if exist(dum)==7
        prepwd=(dum) ;
    elseif exist(dum)==2
        prepwd=(dum) ;
    else
        prepwd=pwd;
    end
    
    try
        %[maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii');
        [fi2]=  cfg_getfile2(inf,'any',{'ee';'rrr'},[],prepwd,'.*');
        if isempty(char(fi2)); return; end
    catch
        %[fi pa]=uigetfile([prepwd ],'select multiple files',[],'multiselect','on');
        [fi pa]=uigetfile([fullfile(prepwd,'*.*') ],['select file(s)'],'multiselect','on');
        if isnumeric(fi); return; end
        if ischar(fi); fi=cellstr(fi);; end
        if max(strfind(pa,filesep))==length(pa);
            pa(end)=[];
        end
        fi2=cellfun(@(fi) {[pa filesep fi]}, fi(:));
    end
    %    [fi pa]=uigetfile('*.*','select multiple files','*.*','multiselect','on');
    
    
    eval([tb{1}  'fi2;' ]);
    ls =struct2list(x);
    ls(1)=   { [ ls{1}  char(9)  tb{3} ]};
    n=ls;
    
elseif strcmp(us.dat{idx,4},'d')
    dum=us.dat{idx,2};
    if exist(dum)==7
        prepwd=fileparts(dum) ;
    elseif exist(dum)==2
        prepwd=fileparts(fileparts(dum)) ;
    else
        prepwd=pwd;
    end
    
    
    
    [pa]=uigetdir('*.*');
    newtag=pa;
    n=[tb{1} [ '''' newtag '''' ';' char(9) ] tb{3}];
    
elseif strcmp(us.dat{idx,4},'b')
    %     chk=0;
    if isempty(regexpi(tb{2,1},'0'))
        newtag= strrep(tb{2,1},'1','0');
    elseif isempty(regexpi(tb{2,1},'1'))
        newtag= strrep(tb{2,1},'0','1');
    else
        newtag=[   num2str( us.dat{idx,2})     ];%no semicolon!!
    end
    n=[tb{1} [   newtag    ]   tb{3} ];
    
elseif   iscellmode>=1
    delete(findobj(gcf,'tag','pulldown'));
    us=get(gcf,'userdata');
    us.ispulldownON=1;
    set(gcf,'userdata',us);
    
    if iscellmode==1
        pulldown=regexprep(us.dat{idx,4},'{|}','');
    else
        pulldown=  us.dat{idx,4};
    end
    
    %% PULLDOWN
    pd=uicontrol('style','popupmenu','units','normalized','position',[0 0 .3 .1],'tag','pulldown',...
        'string',pulldown,'backgroundcolor',[1 .8 .43 ]);
    set(pd,'units','pixels');
    %     hbut= findobj(gcf,'tag','open');
    try
    hbut=e.Source;
    catch
     hbut=h;   
    end
    pos=get(hbut,'position');
    pos2=[pos(1)+pos(3)  pos(2)-pos(4)    pos(4)*10 pos(4)  ];
    set(pd,'position',pos2,...
        'callback'    ,{@cbpulldown,tx3,tb,val,carpos,iscellmode  },...
        'KeyPressFcn' ,{@pulldownkeypress,tx3,tb,val,carpos,iscellmode  });
    uicontrol(pd);
    set(gcf,'currentobject',findobj(gcf,'tag','pulldown'));
    try
        drawnow;%pause(.2)
        jPopup = findjobj(findobj(gcf,'Tag','pulldown'));
        %jPopup.setEditable(true)
        %drawnow
        % jPopup.hidePopup();
        jPopup.showPopup();
    end
    
    
    set(gcf,'currentobject',findobj(gcf,'tag','pulldown'));
    set(findobj(gcf,'tag','pulldown'),'value',1);
    
    set(findobj(gcf,'tag','open'),'KeyPressFcn',@pulldownBUTTONkeypress);
    
   
    return
    
elseif   isfunmode==1
    
    eval(  char(us.jCodePane.getText       ));
    xtemp=x;
    clear x
    
    func2eval=us.dat{idx,4};
    
    %replace fields for INparameter-linkage
    %       islink=0
    %% check this.../check reason for this
    try
        for j=1:length(func2eval)
            if isfield(xtemp,func2eval{3})
                func2eval(3)={getfield(xtemp,func2eval{3})};
                %                   islink=1;
            end
        end
    end
    
    
    
    
    try
        list=hgfeval(func2eval);
    catch
        hgfeval(func2eval);
        updateIconposition();
        
        us.jCodePane.setCaretPosition(carpos);
        us.jCodePane.requestFocus();
        
        
        return
    end
    if isempty(list); list={''};end
    
    eval([tb{1}  'list;' ]);
    ls =struct2list(x);
    ls(1)=   { [ ls{1}  char(9)  tb{3} ]};
    n=ls;
    %     if islink==1
    %         isfunmode=0;
    %     end
end


if strcmp(class(us.dat{idx,4}),'function_handle')
    
    
    
    
    
    
    return
end

if strcmp(us.dat{idx,4},'mf')  | isfunmode==1  %% ICON-SELECTED DATA
    
    
    %%###
    tx=char(r.getText);
    val=r.getLineFromPos(r.getCaretPosition())+1;
    % carpos=r.getLineFromPos(r.getCaretPosition())
    %carpos=r.getCaretPosition();
    
    %tx modiic
    ict=[0 strfind(tx,char(10)) length(tx) ];
    tx2={};
    for i=1:length(ict)-1
        tx2{end+1,1}=tx(ict(i)+1: ict(i+1)-1 );
    end
    
    lin=tx2(val);
    si1=min(cell2mat(strfind(lin,'=')));
    si2=min([min(cell2mat(strfind(lin,'%')))  length(lin{1})+1 ]);
    tb{1,1}=[lin{1}(1:si1) ];
    tb{2,1}=[lin{1}(si1+1:si2-1) ];
    tb{3,1}=[lin{1}(si2:end) ];
    varname=char(  regexprep(tb(1),{'x\.' '='},'') );
    varname=deblank(varname);
    %find index in OrigTable
    idx=find(strcmp(us.dat(:,1),varname));
    tx3=tx2;
    
    %%###
    
    
    
    
    
    dum=tx3{val};
    i1=strfind(dum,'{');
    i2=strfind(dum,'}');
    if min(i1)>min(strfind(dum,'%'))  ;  i1=[]; end
    if min(i2)>min(strfind(dum,'%'))  ;  i2=[]; end
    
    if ~isempty(i1) && isempty(i2)
        for j=val+1:size(tx3,1)
            dum=tx3{j};
            %i1=strfind(dum,'{')
            i2=strfind(dum,'}');
            i3=strfind(dum,'%');
            
            if ~isempty(i2)
                if ~isempty(i3)
                    if min(i3)>min(i2) %comment after '}'
                        break;
                    end
                    
                else %no comment
                    break;
                end
            end
        end
        try; s1=tx3(1:val-1); catch; s1=[];end
        s2=n;
        try; s3=tx3(j+1:end); catch; s3=[];end
        
        try
            s2b=reformatline(s2, s1 ,s3);
            %            s2= [s2(1);cellfun(@(s2) {[ '    ' s2]},s2(2:end))]; %bug
        end
        
        tx3=[s1;s2b;s3];
    else
        %single LINE befor
        try; s1=tx3(1:val-1); catch; s1=[];end
        s2=n;
        if size(s2,1)>1
            try
                s2= [s2(1);cellfun(@(s2) {[ '    ' s2]},s2(2:end))]; %bug
            end
        end
        
        try; s3=tx3(val+1:end); catch; s3=[];end
        
        s2b=reformatline(s2,   s1,s3);
        tx3=[s1;s2b;s3];
    end
else
    try; s1=tx3(1:val-1); catch; s1=[];end
    try; s3=tx3(val+1:end); catch; s3=[];end
    s2=n;
    s2b=reformatline(s2,   s1,s3);
    tx3(val)=s2b;
    
    %     [tx3{1:val-1}]
    
end
b=tx3;
b2=cell2line(b,1,'@999@');
b3=regexprep(b2,'@999@',char(10));
b3=[b3 ' ' char(09) ];
b3=makenicer2(b3);
r.setText(b3);
try; r.setCaretPosition(carpos);end

updatehistory();
updateIconposition();

us.jCodePane.setCaretPosition(carpos);
us.jCodePane.requestFocus();


function s2b=reformatline(s2, s1 ,s3)

icom=cell2mat(regexpi(regexprep(s2(1),'\s',''),'%'));
if icom==1
    s2b=s2;
    return
end

tx3=[s1;s3];


isx =regexpi(tx3,'x.','once');
iseq=regexpi(tx3,'=','once');
isc =regexpi(tx3,'%','once');

ls=[isx iseq isc];
empt=cellfun('isempty' ,ls);
ls(empt(:,3),3)={1000};
ls(empt(:,1),1)={0};
ls(empt(:,2),2)={0};
ls=cell2mat(ls);
isval=find(ls(:,1)<ls(:,2) & ls(:,1)<ls(:,3) & ls(:,1)<ls(:,3));
mxeq=max( (ls(isval,2)));

% ls=[isx iseq ];
% iseq=regexpi(tx3,'=','once');
% isx =regexpi(tx3,'x.','once');
% isc =regexpi(tx3,'%','once');
% ls=[isx iseq ];
% isval=find(~cellfun('isempty',ls(:,1)));
% mxeq=max(cell2mat(ls(isval,2)));



dum=s2;
if ischar(dum); dum={dum};   end
ithis=cell2mat(regexpi(dum,'=','once'));

icell=cell2mat(regexpi(dum(1),'=\s*{'));
if ~isempty(icell)
    %     dum{1}(icell+1:icell+2)=[];
end

dum=regexprep(dum,['=\s*'],['=' repmat(' ',[1  (mxeq-ithis)+1 ])]);
if size(dum,1)>1
    c=regexpi(dum,'''');%commata
    ref=min(c{1});
    for i=2 :size(c,1);
        add=ref-min(c{i});
        if add<0;%del space
            dum{i}=  dum{i}(abs(add)+1:end);
        else %add space
            dum{i}=[ repmat(' ',[1 add]) dum{i}];
        end
    end
    %     dum=[dum(1,1); cellfun(@(s2) {[ repmat(' ', [1 mxeq-ithis]) s2]},dum(2:end))]
end

s2b=dum;
% disp([char([s1;s2b;s3])]);
% disp('lin-1141   reformatline');


function reformat
us=get(findobj(gcf,'tag','paramgui'),'userdata');
txt=us.jCodePane.getText;
txt=char(txt);
b=regexp(txt, '\n', 'split')';

% if 1
try
    
    bx=b;
    s1=1;
    s2=1;
    isrun1=1;
    isrun2=1;
    n=1;
    
    while  isrun1==1
        
        while  isrun2==1
            try
                evalc(regexprep(cell2line(bx(s1:s2),1,'@999@'),'@999@',char(10)));
                %disp([s1 s2]);
                isrun2=0;
                
                s2b=reformatline(bx(s1:s2), bx(1:s1-1) ,bx(s2+1:end));
                bx(s1:s2)=s2b;
            catch
                s2=s2+1;
            end
        end
        
        %      disp([s1 s2])
        if s2>=size(b,1)
            isrun1=0;
        end
        
        isrun2=1;
        s1=s2+1;
        s2=s1;
    end
    b3=bx;
    
catch
    eb=regexpi2(b,'=');
    eb2=[];
    for i=1:length(eb)
        ic=min(cell2mat(strfind(b(eb(i)),'%')));
        ie=min(cell2mat(strfind(b(eb(i)),'=')));
        if isempty(ic); ic=1000; end
        if ic>ie
            eb2(end+1,:)=[ eb(i) ic ie ] ;
        end
    end
    eb2(find(eb2(:,2)==1000),2)=max(eb2(find(eb2(:,2)~=1000),2));
    
    mx=max(eb2(:,2));
    b2=b;
    for i=1:size(eb2,1)
        d=char(b2(eb2(i,1)));
        %     regexprep(d, '=[\s]*','=')
        %        regexprep('s =45 % ', '=[\s]*','=')
        %     regexprep('well =   [23]', '=[\s]+','=')
        %  d2=regexprep(d, '[\s]*=[\s]*',[ '=' repmat(' ',1,mx-eb2(i,2))])
        d2=regexprep(d, '[\s]*=[\s]*',[ '=' ]);
        %   d2=regexprep(d, '=[\s]*',[ '=' repmat(' ',1,mx-eb2(i,2))])
        b2{eb2(i,1)}=d2;
    end
    
    eb=regexpi2(b2,'=');
    eb2=[];
    for i=1:length(eb)
        ic=min(cell2mat(strfind(b2(eb(i)),'%')));
        ie=min(cell2mat(strfind(b2(eb(i)),'=')));
        if isempty(ic); ic=1000; end
        if ic>ie
            eb2(end+1,:)=[ eb(i) ie ic ] ;
        end
    end
    
    eb2(find(eb2(:,2)==1000),2)=max(eb2(find(eb2(:,2)~=1000),2));
    eb2(find(eb2(:,3)==1000),3)=max(eb2(find(eb2(:,3)~=1000),3));
    
    mx=max(eb2(:,2));
    b3=b2;
    for i=1:size(eb2,1)
        d=char(b3(eb2(i,1)));
        d2=regexprep(d, '[\s]*=[\s]*',[ '= ' repmat(' ',1,mx-eb2(i,2))]);
        b3{eb2(i,1)}=d2;
    end
end


b4=cell2line(b3,1,'@999@');
b4=regexprep(b4,'@999@',char(10));
% b4=[b4 ' ' char(09) ];
us.jCodePane.setText(b4);






%history
function updatehistory
hf=findobj(0,'tag','paramgui');
us=get(hf,'userdata');
r=us.jCodePane;
us.historyValue=us.historyValue+1;
us.history(us.historyValue,1)={(char(r.getText))};
us.history=us.history(1:us.historyValue);
set(hf,'userdata',us);

if us.historyValue==length(us.history)
    set(findobj(hf,'tag','pb4'),'enable','off');
else
    set(findobj(hf,'tag','pb4'),'enable','on');
end
if us.historyValue==1
    set(findobj(hf,'tag','pb3'),'enable','off');
else
    set(findobj(hf,'tag','pb3'),'enable','on');
end




function pulldownBUTTONkeypress(h,e)
'b'
% '1318-pulldownBUTTONkeypress'
hp=findobj(gcf,'tag','pulldown');
n=length(get(hp,'string'));
val=get(hp,'value');
if strcmp(e.Key,'downarrow')
    if val<n
        set(hp,'value',val+1);
    end
elseif  strcmp(e.Key,'uparrow')
    if val>1
        set(hp,'value',val-1);
    end
elseif  strcmp(e.Key,'return')
    %     hgfeval(get(findobj(gcf,'tag','pulldown'),'callback'))
    
    ps=get(findobj(gcf,'tag','pulldown'),'callback');
    ps2=[ps(1);{[]};{[]};ps(2:end)];
    hgfeval(ps2);
end




function pulldownkeypress(h,e,tx3,tb,val,carpos,iscellmode)
% h

% if strcmp(e.Key,'return') %close and lock answer
%     'space'
% end
if strcmp(e.Key,'leftarrow') 
   % 'le'
    hpull=findobj(gcf,'tag','pulldown');
    li=get(hpull,'string');
    va=get(hpull,'value');
    va=va-1;
    if va<1; return; end
    set(hpull,'value',va);
    
elseif strcmp(e.Key,'rightarrow')
   % 'ri'
     hpull=findobj(gcf,'tag','pulldown');
    li=get(hpull,'string');
    va=get(hpull,'value');
    va=va+1;
    if va>length(li); return; end
    set(hpull,'value',va);
end

function cbpulldown(h,e,tx3,tb,val,carpos,iscellmode)



% set(gcf,'currentobject',findobj(gcf,'tag','pulldown'))
% return

pb=findobj(gcf,'tag','pulldown');
li=cellstr(get(pb,'string'));
va=get(pb,'value');
us=get(gcf,'userdata');
curpos=us.jCodePane.getCaretPosition;
r=us.jCodePane;
try
    set(r,'CaretUpdateCallback','');
catch
    jTextAreaWA = handle(r,'CallbackProperties');
    set(jTextAreaWA,'CaretUpdateCallback','');
end

% return

% carpos=r.getCaretPosition();

newtag=[ char(li(va)) ];
if iscellmode==1
    n=[tb{1} [ '''' newtag '''' char(9) ';' ] tb{3}];
elseif iscellmode==2
    n=[tb{1} [ ['[' newtag ']'] char(9) ';' ] tb{3}];
end

chk=str2num(newtag);
if isempty(chk)%must be a string
    n=[tb{1} [ '''' newtag '''' char(9) ';' ] tb{3}];
else
    n=[tb{1} [ ['[' newtag ']'] char(9) ';' ] tb{3}];
end


tx3{val}=n;
try; s1=tx3(1:val-1); catch; s1=[];end
s2=n;
try; s3=tx3(val+1:end); catch; s3=[];end
s2b=reformatline(s2,   s1,s3);
tx3=[s1;s2b;s3];


% %     try
% %________________________________________________
% %% fun reformat_line
%
% iseq=regexpi(tx3,'=','once');
% isx =regexpi(tx3,'x.','once');
% ls=[isx iseq ];
%
% isval=find(~cellfun('isempty',ls(:,1)));
% mxeq=max(cell2mat(ls(isval,2)));
%
% dum=tx3{val};
% ithis=cell2mat(regexpi({dum},'=','once'));
% dum=regexprep(dum,['=\s*'],['=' repmat(' ',[1  mxeq-ithis ])]);
% tx3{val}=dum;
% %% fun distance
%________________________________________________

%    tx3{val} =regexprep(tx3{val},'=',[ '= ' repmat(char(9),[1 1]) ],'once');
%     end
% catch
% tx3{val}=n;
% end
b=tx3;
b2=cell2line(b,1,'@999@');
b3=regexprep(b2,'@999@',char(10));
b3=[b3 ' ' char(09) ];
b3=makenicer2(b3);
r.setText(b3);
try
    r.setCaretPosition(carpos);
catch
    r.setCaretPosition(carpos-20);
end

delete(findobj(gcf,'tag','pulldown'));
% us.ispulldownON=0;
set(gcf,'userdata',us);
drawnow;
pause(1)
drawnow
set(r,'CaretUpdateCallback',@showIcon);
updatehistory();
% icon=findobj(gcf,'tag','open');
% set(icon,'userdata',char(li(va)));
 us.jCodePane.setCaretPosition(curpos);
us.jCodePane.requestFocus();

function resizefun(he,e)
% clc

set(gcf,'Resizefcn',[]);%32-always,31-needed,30-depends


r=findobj(gcf,'style','pushbutton');
iicons=[];
for i=1:length(r)
    try
        if strcmp(func2str(r(i).Callback),'pbcb')
            iicons=[iicons i];
        end
    end
end
r=r(iicons);
set(r,'visible','off');
updateIconposition();


set(gcf,'Resizefcn',@resizefun);%32-always,31-needed,30-depends


% us=get(gcf,'userdata');
% persistent atime
% if isempty(atime)
%     atime=tic;
% end
% persistent check % Shared with all calls of pushbutton1_Callback.
% delay = .01; % Delay in seconds.
% % Count number of clicks. If there are no recent clicks, execute the single
% % click action. If there is a recent click, ignore new clicks.
% if isempty(check)
%     check = 1;
%     disp('Single click action');
%     set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',[]);
%     drawnow
% else
%     check = [];
%     drawnow;
% %     pause(delay)
%    disp( ['moved ' num2str(toc(atime))      ]);
%    atime=tic;
%    set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',@updateIconposition_cb);
%    drawnow;
% end
% return
%  set(us.jhPanel.VerticalScrollBar,'AdjustmentValueChangedCallback',@updateIconposition_cb);





% return
% persistent returnFlag
% if ~isempty(returnFlag)
%     disp('...do nothing');
%     return
% end
% returnFlag=1;
% disp('...do something');
% % returnFlag=[];
%
% return


% flag = false;
% % Get the stack
% s = dbstack();
% %   disp(['rin' num2str(numel(s))]);
% if numel(s)<=2
%     % Stack too short for a multiple call
%     %    drawnow;
%     return
% end
% % How many calls to the calling function are in the stack?
% names = {s(:).name};
% TF = strcmp(s(2).name,names);
% count = sum(TF);
% if count>1
%     % More than 1
%     flag = true;
% end
% % disp(count);
%
% return












us=get(gcf,'userdata');
curpos=us.jCodePane.getCaretPosition;

% % highlim=0.15;
% % fpos=get(gcf,'position');
% % if fpos(4)<highlim;
% %     fpos2=[fpos(1)  fpos(1)+fpos(3)-highlim   fpos(3)  highlim ];
% %     set(gcf,'position',fpos2);
% % end
%
% us=get(gcf,'userdata');
% p=findobj(gcf,'tag','open');
% if isempty(p); return; end
%
% yd=us.jCodePane.getLineHeight();
% screen=get(0,'MonitorPositions');
% if screen(3)>1600;
%     yd=yd*2;
% end
%
% %% ALTERNATIVE-CURSOR
% pos3=us.jCodePane.getCursorPercentFromTop();
% ax1=findobj(gcf,'tag','axe1');
% axpix=uni2uni(ax1,'position','pixels');
% %  axpix=uni2uni(gcf,'position','pixels')
% apix2=axpix(4);%yd*.75;
% %  ypos2=axpix(4)-axpix(4)*(pos3/100)
% ypos2=apix2-apix2*(pos3/100);
% set(p,'position',[0  ypos2-yd/2    yd/2 yd/2 ]);  %145
% %% set ICON on left border
% % ax1=findobj(gcf,'tag','axe1');
% % axpix=uni2uni(ax1,'position','pixels')
% % xpos=axpix(1)-yd/2;
% %  set(p,'position',[xpos  ypos2-yd/2    yd/2 yd/2 ]);  %145
%
% us.jCodePane.setCaretPosition(curpos);


% %


r=findobj(gcf,'style','pushbutton');
iicons=[];
for i=1:length(r)
    try
        if strcmp(func2str(r(i).Callback),'pbcb')
            iicons=[iicons i];
        end
    end
end
r=r(iicons);
% left distance of text-pane
if ~isempty(r)
    iconpos= get(r(1),'position');
    units=get(us.hContainer,'units');
    set(us.hContainer,'units','pixels');
    posList=get(us.hContainer,'position');
    set(us.hContainer,'position',[iconpos(3) posList(2:end) ]);
    set(us.hContainer,'units',units);
else
    hh=findobj(gcf,'tag','pb2');
    if isempty(hh)
        iconpos(3)=1;
    else
        if strcmp(get(hh,'units'),'pixels')
            iconpos=get(hh,'position');
        else
            unitsT=get(hh,'units');
            set(hh,'units','pixels')
            iconpos=get(hh,'position');
            set(hh,'units',unitsT);
        end
    end
    units=get(us.hContainer,'units');
    set(us.hContainer,'units','pixels');
    posList=get(us.hContainer,'position');
    set(us.hContainer,'position',[iconpos(3) posList(2:end) ]);
    set(us.hContainer,'units',units);
    
end


try
    updateIconposition(); %drawnow;
end


%
%
%
%
% carpos=us.jCodePane.getCaretPosition();
% if carpos<1
%     us.jCodePane.setCaretPosition(carpos+1);
% else
%     us.jCodePane.setCaretPosition(carpos-1);
% end
%  us.jCodePane.setCaretPosition(carpos);


function value = uni2uni(hObject,propName,unitType)

oldUnits = get(hObject,'Units');  %  Get the current units for hObject
set(hObject,'Units',unitType);    % Set the units to unitType
value = get(hObject,propName);    % Get the propName property of hObject
set(hObject,'Units',oldUnits);    % Restore the previous units


function [s]=cell2line(c,mode,varargin)
%=======================================================================
% function [s]=cell2line(c,varargin)
%=======================================================================
% parse a singleline from a cell [works LINEWISE,]
% optional: varargin 1 can be a stoperSIGN (string) default is: ' | '
%
%% exp.
%     lab={'Mrk', '12','45';'mkf','red' ,'blue' }
%     o=cell2line(lab,1);disp(o);
%     o=cell2line(lab,2);disp(o);
%     o=cell2line(lab,2,' ;Handle: ');disp(o);
%
%=======================================================================
%                                                      Paul, BNIC 2007
%=======================================================================
stp=' | ';

if nargin>2
    stp= varargin{1};
end



y='';

if mode==1
    %COLUMNWISE
    for i=1:size(c,2)
        for j=1:size(c,1);
            try
                x=[char(c(j,i)) stp] ;
            catch
                x=[num2str(cell2mat(c(j,i))) stp] ;
            end
            
            y(end+1: [end+length(x) ]) = [x ];
        end
    end
elseif mode==2
    %ROWISE
    for j=1:size(c,1);
        for i=1:size(c,2);
            try
                x=[char(c(j,i)) stp] ;
            catch
                x=[num2str(cell2mat(c(j,i))) stp] ;
            end
            y(end+1: [end+length(x) ]) = [x ];
        end
    end
end



%clear stp at end
y(end-length(stp)+1:end)=[];

s=y;







function id=regexpi2(cells, str,varargin)
%same as regexpi but jelds indizes of mathing cells , instead of empty cells ('I'm tired to code this again and again)
id=regexpi(cells,str,varargin{:});
id=find(cellfun('isempty',id)==0);

function A = catstruct(varargin)
% CATSTRUCT   Concatenate or merge structures with different fieldnames
%   X = CATSTRUCT(S1,S2,S3,...) merges the structures S1, S2, S3 ...
%   into one new structure X. X contains all fields present in the various
%   structures. An example:
%
%     A.name = 'Me' ;
%     B.income = 99999 ;
%     X = catstruct(A,B)
%     % -> X.name = 'Me' ;
%     %    X.income = 99999 ;
%
%   If a fieldname is not unique among structures (i.e., a fieldname is
%   present in more than one structure), only the value from the last
%   structure with this field is used. In this case, the fields are
%   alphabetically sorted. A warning is issued as well. An axample:
%
%     S1.name = 'Me' ;
%     S2.age  = 20 ; S3.age  = 30 ; S4.age  = 40 ;
%     S5.honest = false ;
%     Y = catstruct(S1,S2,S3,S4,S5) % use value from S4
%
%   The inputs can be array of structures. All structures should have the
%   same size. An example:
%
%     C(1).bb = 1 ; C(2).bb = 2 ;
%     D(1).aa = 3 ; D(2).aa = 4 ;
%     CD = catstruct(C,D) % CD is a 1x2 structure array with fields bb and aa
%
%   The last input can be the string 'sorted'. In this case,
%   CATSTRUCT(S1,S2, ..., 'sorted') will sort the fieldnames alphabetically.
%   To sort the fieldnames of a structure A, you could use
%   CATSTRUCT(A,'sorted') but I recommend ORDERFIELDS for doing that.
%
%   When there is nothing to concatenate, the result will be an empty
%   struct (0x0 struct array with no fields).
%
%   NOTE: To concatenate similar arrays of structs, you can use simple
%   concatenation:
%     A = dir('*.mat') ; B = dir('*.m') ; C = [A ; B] ;

%   NOTE: This function relies on unique. Matlab changed the behavior of
%   its set functions since 2013a, so this might cause some backward
%   compatibility issues when dulpicated fieldnames are found.
%
%   See also CAT, STRUCT, FIELDNAMES, STRUCT2CELL, ORDERFIELDS

% version 4.1 (feb 2015), tested in R2014a
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% Created in 2005
% Revisions
%   2.0 (sep 2007) removed bug when dealing with fields containing cell
%                  arrays (Thanks to Rene Willemink)
%   2.1 (sep 2008) added warning and error identifiers
%   2.2 (oct 2008) fixed error when dealing with empty structs (thanks to
%                  Lars Barring)
%   3.0 (mar 2013) fixed problem when the inputs were array of structures
%                  (thanks to Tor Inge Birkenes).
%                  Rephrased the help section as well.
%   4.0 (dec 2013) fixed problem with unique due to version differences in
%                  ML. Unique(...,'last') is no longer the deafult.
%                  (thanks to Isabel P)
%   4.1 (feb 2015) fixed warning with narginchk

% narginchk(1,Inf) ;
N = nargin ;

if ~isstruct(varargin{end}),
    if isequal(varargin{end},'sorted'),
        %         narginchk(2,Inf) ;
        sorted = 1 ;
        N = N-1 ;
    else
        error('catstruct:InvalidArgument','Last argument should be a structure, or the string "sorted".') ;
    end
else
    sorted = 0 ;
end

sz0 = [] ; % used to check that all inputs have the same size

% used to check for a few trivial cases
NonEmptyInputs = false(N,1) ;
NonEmptyInputsN = 0 ;

% used to collect the fieldnames and the inputs
FN = cell(N,1) ;
VAL = cell(N,1) ;

% parse the inputs
for ii=1:N,
    X = varargin{ii} ;
    if ~isstruct(X),
        error('catstruct:InvalidArgument',['Argument #' num2str(ii) ' is not a structure.']) ;
    end
    
    if ~isempty(X),
        % empty structs are ignored
        if ii > 1 && ~isempty(sz0)
            if ~isequal(size(X), sz0)
                error('catstruct:UnequalSizes','All structures should have the same size.') ;
            end
        else
            sz0 = size(X) ;
        end
        NonEmptyInputsN = NonEmptyInputsN + 1 ;
        NonEmptyInputs(ii) = true ;
        FN{ii} = fieldnames(X) ;
        VAL{ii} = struct2cell(X) ;
    end
end

if NonEmptyInputsN == 0
    % all structures were empty
    A = struct([]) ;
elseif NonEmptyInputsN == 1,
    % there was only one non-empty structure
    A = varargin{NonEmptyInputs} ;
    if sorted,
        A = orderfields(A) ;
    end
else
    % there is actually something to concatenate
    FN = cat(1,FN{:}) ;
    VAL = cat(1,VAL{:}) ;
    FN = squeeze(FN) ;
    VAL = squeeze(VAL) ;
    
    
    [UFN,ind] = unique(FN, 'last') ;
    % If this line errors, due to your matlab version not having UNIQUE
    % accept the 'last' input, use the following line instead
    % [UFN,ind] = unique(FN) ; % earlier ML versions, like 6.5
    
    if numel(UFN) ~= numel(FN),
        warning('catstruct:DuplicatesFound','Fieldnames are not unique between structures.') ;
        sorted = 1 ;
    end
    
    if sorted,
        VAL = VAL(ind,:) ;
        FN = FN(ind,:) ;
    end
    
    A = cell2struct(VAL, FN);
    A = reshape(A, sz0) ; % reshape into original format
end




%% convert struct to (executable) cell list (inDepth)
%% function ls=struct2list(x)
% -works with char, 1-2-3D numeric array, mixed cells
%% example
% w.project=	  'TEST'	  ;
% w.voxsize=	  [0.07  0.07  0.07]  ;
% w.datpath=	  'O:\harms1\harmsTest_ANT\dat'	  ;
% w.brukerpath=	  'O:\harms1\harmsTest_ANT\pvraw'	  ;
% w.refpa=	  'V:\mritools\ant\templateBerlin_hres'	  ;
% w.refTPM =  { 'V:\mritools\ant\templateBerlin_hres\_b1grey.nii'
%               'V:\mritools\ant\templateBerlin_hres\_b2white.nii'
%               'V:\mritools\ant\templateBerlin_hres\_b3csf.nii' };
% w.refsample=	  'V:\mritools\ant\templateBerlin_hres\_sample.nii'	  ;
% w.a.b=	  'hallo'	  ;
% w.x.e=	  [1  2  3]  ;
% w.haus.auto =  { 'YPL-320' 	'Male' 	38.00000	1.00000	176.00000
%                  'GLI-532' 	'Male' 	43.00000	0.00000	163.00000
%                  'PNI-258' 	'Female' 	38.00000	1.00000	131.00000
%                  'MIJ-579' 	'Female' 	40.00000	0.00000	133.00000};
% w.O =  { 'hello' 	123.00000
%          3.14159	'bye' };
% w.O2 =  { 'hello' 	3.14159
%           123.00000	'bye' };
% w.d1=	  [1  2  3  4  5]  ;
% w.d1v =  [          1
%                     2
%                     3
%                     4
%                     5  ];
% w.d2 =  [          1          0          1          1
%                    0          1          1          1
%                    1          1          1          1  ];
% w.d3(:,:,1) = [ 0.5800903658 0.1208595711
%                 0.01698293834 0.8627107187 ];
% w.d3(:,:,2) = [ 0.4842965112 0.209405084
%                 0.8448556746 0.5522913415 ];
% w.d3(:,:,3) = [ 0.6298833851 0.6147134191
%                 0.03199101576 0.3624114623 ];
% w.r=	  [0.045673  1  1000  1.5678e+022  4.5678e-008]  ;
% w.r2 =  [   0.045673          1       1000 1.5678e+022 4.5678e-008
%                   -1         -1      -1000 -1.5678e+022        -10  ];
% ls=struct2list(w)

function [ls varargout]=struct2list(x,varargin)

op=struct();
if nargin>1
    c=varargin(1:2:end);
    f=varargin(2:2:end);
    op = cell2struct(f,c,2); %optional Parameters
    %optional parameter: 'ntabs'  number of tabs after ''
    
end


if 0
    run('proj_harms_TESTSORDNER');
    [pathx s]=antpath;
    x= catstruct(x,s);
    clear s
    x.a.b='hallo'; x.x.e=[1 2 3];
    x.haus.auto = {
        'YPL-320', 'Male',   38, true,  uint8(176);
        'GLI-532', 'Male',   43, false, uint8(163);
        'PNI-258', 'Female', 38, true,  uint8(131);
        'MIJ-579', 'Female', 40, false, uint8(133) };
    x.O= {'hello', 123;pi, 'bye'};
    x.O2= {'hello', 123;pi, 'bye'}';
    
    % x=[]
    x.d1=1:5;
    x.d1v=[1:5]';
    x.d2= logical(round(rand(3,4)*2-.5));
    x.d3=rand(2,2,3);
    x.r=([0.045673 1 1000   1.56780e22 .000000045678]);
    x.r2=[[0.045673 1 1000   1.56780e22 .000000045678] ; -[[1 1 1000   1.56780e22 10.000000045678]]];
    
    % t='x';
end

name=inputname(1);
eval([name '=x;'  ]);
% fn= fieldnamesr(dum,'prefix');
eval(['fn= fieldnamesr(' name ',''prefix'');'  ]);
s1={};
s2=s1;

if isfield(op,'ntabs')
    ntabs=repmat('\t',1,op.ntabs);
else
    ntabs='';
end



for i=1:size(fn,1)
    eval(['d=' fn{i} ';']);
    
    
    if isnumeric(d) | islogical(d)
        
        if size(d,1)==0
            s2{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , '');
        elseif size(d,1)==1
            %             d2=sprintf('% 10.10g ' ,d);
            d2=regexprep(num2str(d),'\s+','  ');
            s2{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , d2);
        elseif size(d,1)>1 && ndims(d)==2
            g={};
            for j=1:size(d,1)
                d2=sprintf('%10.5g ' ,d(j,:));
                g{end+1,1}= sprintf('%s%s ','' , d2)       ;
            end
            p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '[');
            p0=repmat(' ',[1 length(p1)]);
            
            g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
            g{1,1}(1:length(p1))=p1       ;%start
            g{end}=[g{end} '];']       ;      ;%end
            %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
            s2=[s2;g];
        elseif size(d,1)>1 && ndims(d)==3
            g2={};
            for k=1:size(d,3)
                g={};
                for j=1:size(d,1)
                    d2=sprintf('%10.10g ' ,squeeze(d(j,:,k)));
                    g{end+1,1}= sprintf('%s %s','' , d2)       ;
                end
                p1=sprintf([ '%s(:,:,%d)=' ntabs '[' ],fn{i} ,  k);
                p0=repmat(' ',[1 length(p1)]);
                
                g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
                g{1,1}(1:length(p1))=p1       ;%start
                g{end}=[g{end} '];']       ;      ;%end
                %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
                g2=[g2;g];
            end
            s2=[s2;g2];
        end
    elseif ischar(d)
        g=[ '''d'''];
        s2{end+1,1}=sprintf(['%s=' ntabs '''%s'';'],fn{i} , d);
    elseif iscell(d)
        if  ~isempty(d)
            d2=  (mat2clip(d));
        else
            d2='';
        end
        
        s=sort([strfind(d2,char(10)) 0  length(d2)+1]);
        g={};
        for j=1: length(s)-1
            g{end+1,1}=d2(s(j)+1:s(j+1)-1);
        end
        p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '{');
        p0=repmat(' ',[1 length(p1)]);
        
        g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
        g{1,1}(1:length(p1))=p1       ;%start
        g{end}=[g{end} '};']       ;      ;%end
        %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
        s2=[s2;g];
    end
end

% uhelp(s2,1);set(findobj(gcf,'tag','txt'),'fontname','courier')

ls=s2;

function out = mat2clip(a, delim)



% each element is separated by tabs and each row is separated by a NEWLINE
% character.
sep = {'\t', '\n', ''};

if nargin == 2
    if ischar(delim)
        sep{1} = delim;
    else
        error('mat2clip:CharacterDelimiter', ...
            'Only character array for delimiters');
    end
end

% try to determine the format of the numeric elements.
switch get(0, 'Format')
    case 'short'
        fmt = {'%s', '%0.5f' , '%d'};
    case 'shortE'
        fmt = {'%s', '%0.5e' , '%d'};
    case 'shortG'
        fmt = {'%s', '%0.5g' , '%d'};
    case 'long'
        fmt = {'%s', '%0.15f', '%d'};
    case 'longE'
        fmt = {'%s', '%0.15e', '%d'};
    case 'longG'
        fmt = {'%s', '%0.15g', '%d'};
    otherwise
        fmt = {'%s', '%0.5f' , '%d'};
end
fmt{1}='''%s'' ';

if iscell(a)  % cell array
    a = a';
    
    floattypes = cellfun(@isfloat, a);
    inttypes = cellfun(@isinteger, a);
    logicaltypes = cellfun(@islogical, a);
    strtypes = cellfun(@ischar, a);
    
    classType = zeros(size(a));
    classType(strtypes) = 1;
    classType(floattypes) = 2;
    classType(inttypes) = 3;
    classType(logicaltypes) = 3;
    if any(~classType(:))
        error('mat2clip:InvalidDataTypeInCell', ...
            ['Invalid data type in the cell array. ', ...
            'Only strings and numeric data types are allowed.']);
    end
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a{:});
    
elseif isfloat(a)  % floating point number
    a = a';
    
    classType = repmat(2, size(a));
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a(:));
    
elseif isinteger(a) || islogical(a)  % integer types and logical
    a = a';
    
    classType = repmat(3, size(a));
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a(:));
    
elseif ischar(a)  % character array
    % if multiple rows, convert to a single line with line breaks
    if size(a, 1) > 1
        b = cellstr(a);
        b = [sprintf('%s\n', b{1:end-1}), b{end}];
    else
        b = a;
    end
    
else
    error('mat2clip:InvalidDataType', ...
        ['Invalid data type. ', ...
        'Only cells, strings, and numeric data types are allowed.']);
    
end

% clipboard('copy', b);

out = b;




function NAMES = fieldnamesr(S,varargin)
%FIELDNAMESR Get structure field names in recursive manner.
%
%   NAMES = FIELDNAMESR(S) returns a cell array of strings containing the
%   structure field names associated with s, the structure field names
%   of any structures which are fields of s, any structures which are
%   fields of fields of s, and so on.
%
%   NAMES = FIELDNAMESR(S,DEPTH) is an optional field which allows the depth
%   of the search to be defined. Default is -1, which does not limit the
%   search by depth. A depth of 1 will return only the field names of s
%   (behaving like FIELDNAMES). A depth of 2 will return those field
%   names, as well as the field names of any structure which is a field of
%   s.
%
%   NAMES = FIELDNAMESR(...,'full') returns the names of fields which are
%   structures, as well as the contents of those structures, as separate
%   cells. This is unlike the default where a structure-tree is returned.
%
%   NAMES = FIELDNAMESR(...,'prefix') returns the names of the fields
%   prefixed by the name of the input structure.
%
%   NAMES = FIELDNAMESR(...,'struct') returns only the names of fields
%   which are structures.
%
%   See also FIELDNAMES, ISFIELD, GETFIELD, SETFIELD, ORDERFIELDS, RMFIELD.

%   Developed in MATLAB 7.13.0.594 (2011b).
%   By AATJ (adam.tudorjones@pharm.ox.ac.uk). 2011-10-11. Released under
%   the BSD license.

%Set optional arguments to default settings, if they are not set by the
%caller.
if size(varargin,1) == 0
    optargs = {-1} ;
    optargs(1:length(varargin)) = varargin ;
    depth = optargs{:} ;
    
    full = [0] ; [prefix] = [0] ; [struct] = [0] ;
else
    if any(strcmp(varargin,'full') == 1)
        full = 1 ;
    else
        full = 0 ;
    end
    
    if any(strcmp(varargin,'prefix') == 1)
        prefix = 1 ;
    else
        prefix = 0 ;
    end
    
    if any(strcmp(varargin,'struct') == 1)
        struct = 1 ;
    else
        struct = 0 ;
    end
    
    if any(cellfun(@isnumeric,varargin) == 1)
        depth = varargin{find(cellfun(@isnumeric,varargin))} ;
    else
        depth = -1 ;
    end
end


%Return fieldnames of input structure, prefix these with "S.".
NAMES = cellfun(@(x) strcat('S.',x),fieldnames(S),'UniformOutput',false) ;

%Set state counters to initial values (k terminates recursive loop, g makes
%recursive loop behave in a different way.
k = 1 ; g = 0 ;

fndstruct = {} ;

%k is ~0 while all fields have not been searched to exhaustion or to
%specified depth.
while k ~= 0
    fndtemp = {} ;
    
    k = length(NAMES) ;
    
    %g set to 1 prevents fieldnames from being added to output NAMES.
    %Useful when determining whether fields at the lowest specified depth
    %are structures, without adding their child fieldnames (i.e. at
    %specified depth + 1) to NAMES output.
    if depth == 1
        g = 1 ;
    end
    
    for i = 1:length(NAMES)
        %If the current fieldname is a structure, find its child
        %fieldnames, add to NAMES if not at specified depth (g = 0). Add to
        %fndstruct (list of structures).
        if isstruct(eval(NAMES{i})) == 1
            if g ~= 1
                fndtemp2 = fieldnames(eval(NAMES{i})) ;
                fndtemp2 = cellfun(@(x) strcat(sprintf('%s.'            ...
                    ,NAMES{i}),x),fndtemp2,'UniformOutput',false) ;
                fndtemp = cat(1,fndtemp,fndtemp2) ;
            elseif g == 1
                fndtemp = cat(1,fndtemp,NAMES{i}) ;
                k = k - 1 ;
            end
            fndstruct = cat(1,fndstruct,NAMES{i}) ;
        else
            fndtemp = cat(1,fndtemp,NAMES{i}) ;
            k = k - 1 ;
        end
    end
    
    NAMES = fndtemp ;
    
    %If we have reached depth, stop recording children fieldnames to NAMES
    %output, but determine whether fields at final depth are structures or
    %not (g). After this, terminate loop by setting k to 0.
    if depth ~= -1                                                      ...
            && any(cellfun(@(x) size(find(x == '.'),2),NAMES) == depth)
        g = 1 ;
    elseif depth ~= -1                                                  ...
            && any(cellfun(@(x) size(find(x == '.'),2),NAMES) > depth)
        k = 0 ;
    end
end

%Return names of fields which are structures, as well as fields which are
%not structures, if 'full' optional argument is set.
if full == 1
    for i = 1:length(fndstruct)
        
        %If depth is specified, add structure names to appropriate depth to
        %output NAMES.
        if depth == -1 || size(find(fndstruct{i} == '.'),2) <= depth-1
            structi = find(cellfun(@(x) isempty(x) == 0                 ...
                ,strfind(NAMES,fndstruct{i})),1) ;
            
            %If the current structure name is related to the first field of
            %NAMES, add structure name to NAMES in a particular way, else
            %add it in another way.
            if structi > 1
                NAMES = cat(1,NAMES(1:(structi-1)),fndstruct{i}         ...
                    ,NAMES(structi:end)) ;
            elseif isempty(structi)
                error ('AATJ:fieldnamesr,NotFindStructure'              ...
                    ,'Could not find structure name in NAMES') ;
            else
                NAMES = cat(1,fndstruct{i},NAMES) ;
            end
        end
    end
end

%Return only fields which are structures, if optional argument is defined.
%If 'full' is not set, do not include both parent and child structures.
if struct == 1
    if full == 0
        fndstruct2 = {} ;
        for i = 1:length(fndstruct)
            if isempty(cell2mat(strfind(fndstruct,strcat(fndstruct{i},'.')))) == 1
                fndstruct2(end+1,1) = fndstruct(i) ;
            end
        end
        fndstruct = fndstruct2 ;
    end
    NAMES = fndstruct ;
end

%Prefix input structure name on all fields of output cell array NAME if
%user set this option.
if prefix == 1
    structname = inputname(1) ;
    NAMES = cellfun(@(x) strcat(sprintf('%s.',structname),x(3:end))     ...
        ,NAMES,'UniformOutput',false) ;
else
    NAMES = cellfun(@(x) sprintf('%s',x(3:end)),NAMES,'UniformOutput'   ...
        ,false) ;
end


function qw3=makennicer(qw3)




v2=cellstr(qw3);

iq=regexpi(v2,'=');
inot=~cellfun('isempty',regexpi(v2,'=='));
iq(inot==1)={[]};
iq(cellfun('isempty',iq))={nan};


ip=cell2mat(cellfun(@(a){min(a)},iq));
imax=nanmax(ip);


v3=v2;
for i=1:size(v2,1)
    if ~isnan(iq{i})
        ipo=regexpi(v2{i},'=','once');
        v3{i}= regexprep(v2{i},'=',[ '=' repmat(' ',1,(imax+1)-ip(i))],'once' );
    end
end
qw3=v3;

qw3=makenicer2(qw3);
%test t
return





%% improves readability of paramgui
% input can be char or cell -->output is of input classtype
% function out=makenicer2(in)
% out=makenicer2(strsplit(tx4,char(10))');
% out=makenicer2(tx4);

function out=makenicer2(in)

%% ________________________________________________________________________________________________
% make nicer
%% ________________________________________________________________________________________________

if ischar(in)
    tx5=strsplit(in,char(10))';
else
    tx5=in;
end
% lincod=regexpi2(tx5, ['x.' '\w+=|\w+\s+=']);
lincod=regexpi2(tx5,'^x\.'); % #NEU
lin=tx5(lincod);

% set '='
w1=regexpi(lin,'=','once')          ; %equal sign
w2=regexpi(lin,'\S=|\S\s+=','once') ;% %last char of fieldname %regexpi({'w.e=3';'wer   =  33'},'\S=|\S\s+=','once')
try; w1=cell2mat(w1); end
try; w2=cell2mat(w2); end
lin2=lin;
for i=1:size(lin2)
    is1=regexpi(lin2{i},'\S=|\S\s+=','once');
    is2=regexpi(lin2{i},'=','once');
    
    lin2{i} = ...
        [lin2{i}(1:is1) repmat(' ',[1 max(w2)-w2(i)]) ' ='  lin2{i}(is2+1:end) ];
end
% char(lin2)
lin=lin2;

%set field
w1=regexpi(lin,'(?<==\s*)(\S+)','once'); %  look back for "= & space"
try; w1=cell2mat(w1); end
lin2=lin;
spac=repmat(' ',[1 2]);
for i=1:size(lin2)
    is=regexpi(lin2{i},'=','once');
    if i==1
        extens=length([lin2{i}(1:is) spac]  );%used later for multiline
    end
    lin2{i} = [lin2{i}(1:is) spac   lin{i}(w1(i):end) ];
end



lin=lin2;
%place back
% set line with cell-one sign before
for i=1:length(lin)
    lino=lin{i};
    curlon=min(regexpi(lino ,'{'));
    if~isempty(curlon)
        coment=min(regexpi(lino ,'%'));
        if isempty(coment); coment=inf; end
        if curlon<coment
            if strcmp(lino(curlon-1),' ')
                lino=regexprep(lino,'\s{','{','once');
                lino=regexprep(lino,'{\s*','{','once');
            end
        end
        
    end
    lin{i}=lino;
end

tx6=tx5;
tx6(lincod)=lin;

% COMMENT IN 1st line in MULTILINE
for i=lincod(1):size(tx6,1)
    if isempty(find(lincod==i))  % no first-line linecode or other stuff
        dx=tx6{i};
        if strcmp(regexpi(dx,'\S','match','once'),'%') ==0 ;% FIRST SIGN ASIDE SPACE is not COMMENTSIGN  regexpi(' ;%','\S','match','once')
            dx=[repmat(' ',[1 extens+1]) regexprep(dx,'^\s+','','once')];
            tx6{i}=dx;
        end
    end
end

%% cell-stuff again
tx7=tx6;
for i=1:length(lincod)
    cmdnum=lincod(i);
    lino=tx7{cmdnum};
    curlon =min(regexpi(lino ,'{'));
    curloff =min(regexpi(lino ,'}'));
    if~isempty(curlon)
        coment=min(regexpi(lino ,'%'));
        if isempty(coment); coment=inf; end
        if curloff>coment; curloff=[];end %  curl-off is in comment
        
        if curlon<coment && isempty(curloff)
            try
                %mors=tx7(cmdnum+1:lincod(i+1)-1);
                idxout=cmdnum+1:lincod(i+1)-1;
                mors=tx7(idxout);
            catch
                idxout=cmdnum+1:size(tx7,1);
                mors=tx7(idxout);
            end
            
            for j=1:size(mors,1)
                thismor=mors{j};
                try
                    charsp=thismor(curlon+1);
                catch
                    charsp='Q' ; % short line/ info
                end
                coment2=min(regexpi(thismor ,'%'));
                if isempty(coment2); coment2=inf; end
                if strcmp(charsp,' ') && curlon+1<coment2
                    
                    thismor(curlon+1)=[]; % one space back
                end
                mors{j}=thismor;
            end
            tx7(idxout)=mors;
        end
    end
end


fin=tx7;
if ischar(in)
    out=strjoin(fin,char(10));
else
    out=fin;
end

function out=makenicer2_old(in)
%% ________________________________________________________________________________________________
% make nicer
%% ________________________________________________________________________________________________

if ischar(in)
    tx5=strsplit(in,char(10))';
else
    tx5=in;
end
% lincod=regexpi2(tx5, ['x.' '\w+=|\w+\s+=']);
lincod=regexpi2(tx5,'^x\.'); % #NEU
lin=tx5(lincod);

% set '='
w1=regexpi(lin,'=','once')          ; %equal sign
w2=regexpi(lin,'\S=|\S\s+=','once') ;% %last char of fieldname %regexpi({'w.e=3';'wer   =  33'},'\S=|\S\s+=','once')
try; w1=cell2mat(w1); end
try; w2=cell2mat(w2); end
lin2=lin;
for i=1:size(lin2)
    is1=regexpi(lin2{i},'\S=|\S\s+=','once');
    is2=regexpi(lin2{i},'=','once');
    
    lin2{i} = ...
        [lin2{i}(1:is1) repmat(' ',[1 max(w2)-w2(i)]) ' ='  lin2{i}(is2+1:end) ];
end
% char(lin2)
lin=lin2;

%set field
w1=regexpi(lin,'(?<==\s*)(\S+)','once'); %  look back for "= & space"
try; w1=cell2mat(w1); end
lin2=lin;
spac=repmat(' ',[1 2]);
for i=1:size(lin2)
    is=regexpi(lin2{i},'=','once');
    if i==1
        extens=length([lin2{i}(1:is) spac]  );%used later for multiline
    end
    lin2{i} = [lin2{i}(1:is) spac   lin{i}(w1(i):end) ];
end
lin=lin2;

%place back
tx6=tx5;
tx6(lincod)=lin;

% multi-line array
for i=lincod(1):size(tx6,1)
    if isempty(find(lincod==i))% no first-line linecode or other stuff
        dx=tx6{i};
        if strcmp(regexpi(dx,'\S','match','once'),'%') ==0 ;% FIRST SIGN ASIDE SPACE is not COMMENTSIGN  regexpi(' ;%','\S','match','once')
            
            dx=[repmat(' ',[1 extens+1]) regexprep(dx,'^\s+','','once')];
            tx6{i}=dx;
        end
    end
    
end

if ischar(in)
    out=strjoin(tx6,char(10));
else
    out=tx6;
end






%%   setdata
function setdata(varargin);
inp=varargin{1};

hp=findobj(gcf,'tag','paramgui');
us=get(hp,'userdata');
r=us.jCodePane;
tx=char(r.getText);

%--------------------------------------------------
%% get line of caret [cartposnew]
cartpos=r.getCaretPosition;
ichar=regexpi(tx,char(10));
charbef=find(ichar>cartpos);
cartline=min(charbef);
try
    cartposnew=ichar(cartline-1)+3;
catch
    cartposnew= 2; %set at the beginning
end
% r.setCaretPosition(cartposnew)
%%

%--------------------------------------------------
%% get field and new data

field    =inp{1};
replaceby=inp{2};


%--------------------------------------------------
% special characters -cases
if     ischar(replaceby)
    if isempty(replaceby);
        replaceby='''''';
    else
        replaceby=['''' replaceby ''''];
    end
elseif isnumeric(replaceby)
    if ndims(replaceby)<3
        w=struct();
        w.r=replaceby;
        w2=struct2list(w);
        w2=strrep(strrep(w2,'w.r=',''),';','');
        w2=regexprep(w2,'\s+',' ');
        w3=strjoin(w2,char(10));
        replaceby=w3;
        
    else % 3d
        
        wp={};
        for i=1:size(replaceby,3)
            w=struct();
            w.r=replaceby(:,:,i);
            w2=struct2list(w);
            w2=strrep(strrep(w2,'w.r=',''),';','');
            if i<size(replaceby,3)
                w2{end}=[w2{end} ',...'];
            end
            wp=[wp;w2];
        end
        wp{1}=[ 'cat(3,' wp{1}];
        wp{end}=[ wp{end} ')'];
        w3=strjoin(wp,char(10));
        replaceby=w3;
    end
    
    
    %     ndims(size(w.r))
    %      if isempty(replaceby); replaceby='[]';
    %         if numel(replaceby)==1
    %         [regexprep(num2str(replaceby),'\s+','') ]
    %         elseif size(replaceby,1)==1 & size(replaceby,1)==1
    %            ['[' regexprep(num2str(replaceby),'\s+',' ') ']' ]
    %     end
elseif iscell(replaceby)
    try;
        replaceby{1};
        si=size(replaceby);
        if find(si>=1)
            dx=replaceby;
            for i=1:length(dx)
                if ischar(dx{i})
                    dx{i}=['''' dx{i} ''''] ;
                end
            end
            replaceby=dx;
            
            
            dx=['{' strjoin(replaceby,char(10)) '}'];
            dx=strrep(dx,[char(10)] ,[ char(10) ' ']);
            replaceby=dx;
        end
    catch
        replaceby='{}';
    end
end

%--------------------------------------------------
% REPLACE TEXT
iv   =regexpi(tx,[ char(10) field '[=|\s*]'])  ;% find onset of  variable
ichar=regexpi(tx,[ char(10) 'x.' '[\S+ \S+=]']);   %find chars

if isempty(iv)
    error('### could not found variable "field --> TYPO ???? ###"');
    
    
end

try
    range=  [iv ichar(find(ichar==iv)+1)-1];  % get line of code of this variable
    tx2=[tx(range(1):range(2))];
catch
    range=  [iv length(tx)];                  % .. in case it is the last entry in txt
    tx2=[tx(range(1):range(2))];
end

d1=min(regexpi(tx2,'='));  %find equal sign
d2=min(regexpi(tx2,'%'));  %find comment
if ~isempty(d2)
    le=length(tx2(d1:d2));
    insert=['= ' replaceby '; %']; %this should be inserted
    ende=tx2(d2+1:end);
    
    cr=strfind(ende,char(10));
    if ~isempty(cr)
        ende=ende(1:cr(1));
        
        %ende=ende(1:strfind(ende,char(10)));
    end
    
    crt=strfind(insert,char(10));
    if ~isempty(crt)
        insert2=[insert(1:crt(1)-1) ['% ' ende(1:end-1)] insert(crt(1):end)  ];
        tx3=[tx2(1:d1-1) insert2];
    else
        tx3=[tx2(1:d1-1) insert ende];
    end
    
    
    
else                                        % no commented code
    insert=['= ' replaceby ';' ];
    tx3=[tx2(1:d1-1) insert];
end
try
    tx4=[tx(1:range(1)-1)  tx3  tx(range(2)+1:end)];
catch
    tx4=[tx(1:range(1)-1)  tx3  tx(range(2):end)];
end

%--------------------------------------------------
% make nicer
tx5=makenicer2(tx4);

%--------------------------------------------------
% insert back
r.setText(tx5);
%--------------------------------------------------
% set caretposition
try
    r.setCaretPosition(cartposnew);
end











