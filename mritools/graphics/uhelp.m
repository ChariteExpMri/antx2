
% #ko [uhelp] isplay a function's HELP or a CELL array in text window.
% 
% #wo _SHORTCUTS_   #k    available in READMODE (RM) AND EDITMODE (EM)
% #g [ctrl+"+"]/[ctrl+"-"]     #n increase/decrease fontsize
% #g [ctrl+c]       #n copy selection 
% #g [ctrl+f]       #n finder panel (use [ESC] or [x]-button to close finder panel)
% #g [ctrl+"up"]    #n scroll to begin
% #g [ctrl+"down"]  #n scroll to end
% #g [ctrl+1]       #n position help window to left side with 50% screensize
% #g [ctrl+2]       #n position help window to left side with 75% screensize
% #g [ctrl+3]       #n position help window to right side with 50% screensize
% #g [ctrl+4]       #n position help window to right side with 75% screensize
% #g [ctrl+5]       #n home position of help window (below ant-window)
% #g [ctrl+0]       #n position help window to left side with 50% screensize
% #g [ctrl+m]       #n toggle READMODE (RM) / EDITMODE (EM)
% #g [ctrl+t]       #n adjust window to  text width
% 
% ##  see also contextmenu
%
% #k =====================================================================================
% #wo _INPUT PARAMETER_  
% uhelp additional infos
% 2nd arg : 0/1 to make a new window(1) or overwrite the old one
% additional pairwise infows
% 'cursor' :   'start' or 'end'  -position the cursor in listbox
% 'lbpos'  :  [x y w h]          -position if the listbox default: [0 0 1 1] 
% 'fontsize': value              -set listbox fontsize 
% EXAMPLES
% uhelp(his, 1, 'cursor' ,'end','lbpos',[0 .025 1 .95] );           
% uhelp(cell, 0/1, 'cursor' ,'end' )   ;%places cursor to the end

%
%% COLORCODE
% e2={'ee3e' ; 'blll ## HASH ' ;'blll ### HASH ### ddede' ;'blll #### HASH ddede';' ## ------------------------------' };
% uhelp(e2)
% e2={'ee3e' ; ' § [h] § [heute]  ; § [m] § morgen '};uhelp(e2)
% % uhelp({' #cm rote KORRELATION #k ccrrc #ky blob';' #c deddeede'});
% uhelp(e2)
%
%% ##wg _______EXAMPLES_______________________________________________
%% #bl              MOUSE-LISTBOX
%% #bx           MOUSE-LISTBOX
%% #ok        _MOUSE-LISTBOX_
%% #ko     _MOUSE-LISTBOX_
%% #wg  _MOUSE-LISTBOX_
%% #ka _MOUSE-LISTBOX_
%% #kd _MOUSE-LISTBOX_
%% #ra _MOUSE-LISTBOX_
%% #rd _MOUSE-LISTBOX_
%
% HREF-matlab-workspace
% disp(['BATCH: <a href="matlab: uhelp({'' #r RED'' ;'' #g green''},1,''cursor'',''end'')">' 'show history' '</a>'  ]);
%
% FEATURES:
% •HTML-style to display text (words in uppercase and the name of the
%    function within the text appear highlighted
% •use mouse wheel to scroll up/down the text
% •use mouse wheel + control button to change the fontsize
% •change fontstyle and backgroundcolor
% •set window to 'always on top' mode ([aot.m] required from matlab file exchange)
% •multiple window mode possible
% •save fontstyle/color/windowsize parameter within this function for the
%  next call
%
%SYNTAX:   uhelp(function) ;%one window mode
%          uhelp(cell)
%          uhelp(function,1) ;%multiple windows mode
%          uhelp(cell,1)
%
% DESCRIPTION:
% uhelp('regexprep');   %replace window mode (default)
% uhelp('regexprep',1) ;%multiple windows mode
% [mousewheel up/down]:             scroll text
% [control]+ [mousewheel up/down]:  decrease/increase fontsize
% [arrow left]/[arrow right]:       decrease/increase fontsize
%
% checkbox    :  to set window as 'always on top'
% contextmenu : [font]      -> choose font-size/weight/style from menu
%               [backgroundcolor]
%               [saveconfig]-> save following parameter in THIS matlab-function:
%                    - font-size/weight/style
%                    - used  'always on top' mode
%                    - figure position
%               [copy selection]-> copy selection to clipboard
%               [evaluate selection]-> ..
% help         : opens another textwindow (replace window mode) to depict help
%              [Help browser]: see documentation in the Help browser
%EXAMPLES:
% uhelp uhelp
% uhelp('fft')
%
%NOTE: the following file is required
%  FINDOBJ by Yair Altman -->
%  http://www.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects
%
% optional: to set window to 'allways on top' download AOT -->
% http://www.mathworks.com/matlabcentral/fileexchange/20694-aot
% --------------------------------------------------
% paul koch,BNIC Berlin 2010
%____________________________ADDIT PARAS____________________
% pairwise add. PARAS
% currently: 'position'  [4 elements]
% uhelp({'ded';'fff'},1,'position',[0 0 .5 .3])
%
%___________________________new COLOR marks_____________________
% ' §b [left]    §k,    :  §  combined with matlab colorletter (y,m,k,b,g,r)
%
%% EXAMPLE
%    %% bka
%        hh={};
%        hh{end+1,1}=( ' #yk ***  IMAGE-SHORTCUTS  ***' );
%        hh{end+1,1}=(' §b [left]    §k    toggle imageFusion/image1');
%        hh{end+1,1}=(' §b [right]   §k    toggle image1/image2');
%        hh{end+1,1}=(' §b [up/down] §k    increase/decrease alpha-blending');
%        hh{end+1,1}=(' §b [c/v]     §k    change colormap (forward/backward)' );
%
%        hh{end+1,1}=(' §b [z]       §k    show/hide coordinates  ');
%        hh{end+1,1}=(' §b [t]       §k    show/hide labels  ');
%
%        uhelp(hh,1,'position',[ 0.7378    0.7633    0.2601    0.130])  ;
%        drawnow;
%% CONVERT TO HTML ONLY
% rr=uhelp(' #rb haalo',[],'export',1)

%---------------------------------------------
% For more information, see <a href="matlab: 
% web('http://www.mathworks.com')">the MathWorks Web site</a>.
% rev: datestr(now) - copy selection bug


function varargout=uhelp(fun,varargin)


warning off;





if nargin>2
    %vnew=varargin{1};
    varag=varargin(2:end);
    
    vara=reshape(varag,[2 length(varag)/2])';
    paras=cell2struct(vara(:,2)',vara(:,1)',2);
    
else
    paras=struct();
end


%% EXPORT HTML ONLY________________________________________________________
if isfield(paras,'export')
    if ~iscell(fun) %call help of a function
        
%         if 0 %%% M-files ..not implmented
%             e=help(fun);
%             e2=strsplit2(e,char(10))';
%         end
        e2=cellstr(fun);
    else %CELL as input
        e2=fun;
    end
    e3=htmlcolorize(e2)  ;
    varargout{1}=e3;
    return
    
end
%%________________________________________________________



posfig=[];
if nargin==0
    uhelp({'..use contextmenu to open Figuretable existing '},1)  ;
    return;
end

% if length(varargin)==0 %dirty: 2 inputs means 'multiple windows mode'
%     try; posfig=get(335,'position'); end
%     try; close(335);end %otherwise replace an existing window
% end
if nargin>0 %dirty: 2 inputs means 'multiple windows mode'
    %     try
    if isempty(varargin) || varargin{1}==0
        try; posfig=get(335,'position'); end
        %         try; close(335);end %otherwise replace an existing window
    end
    %     end
end

if ~iscell(fun) %call help of a function
    e=help(fun);
    %     ix=strfind(e,char(10));%replace Carriage return
    %     ix=[1 ix length(e)];
    %     for i=1:length(ix)-1 %make a cell
    %         e2(i,1)={e(ix(i):ix(i+1)-1)};
    %     end
    e2=strsplit2(e,char(10))';
else %CELL as input
    e2=fun;
end

%%%••••••••••••••••••••••••••••••••••••••••••••••
x.aot=0;
x.evntModifier=0;
%%%••••••••••••••••••••••••••••••••••••••••••••••


e0=e2;%backup


% #############################################################
% vorl={};
% vorl(end+1,:)={'^^'    ' <html><b><font  color="red"> '     ' </b></font> '  }
% vorl(end+1,:)={'^^^'   ' <html><b><font  color="green"> '   ' </b></font> '  };

% vorl={};
% vorl(end+1,:)={'^^'    ' <b><font  color="red"> '     ' </b></font> '  }
% vorl(end+1,:)={'^^^'   ' <b><font  color="green"> '   ' </b></font> '  };


%   drawnow;


x.fun=fun;
x.e0=e0;

e2=htmlcolorize(e2)  ;

% htmlline=regexpi2(e2,'<html>');
% if ~isempty(htmlline); %underscore
%    % e2=regexprep( e2  ,'_','<u>_</u>');
%    e2(htmlline)=regexprep( e2(htmlline)  ,'_','<u>_</u>');
% end




% if length(varargin)==0
if isfield(paras,'position')
    posfig=[paras.position];
else
    posfig= [ 0.3049    0.4189    0.3889    0.4667];
end

figexist=0;
if isempty(varargin) ||  varargin{1}==0
    
    hfig=findobj(0,'tag','uhelp');
    %hfig=hfig(find(cell2mat(get(hfig,'Number'))==335));
    hfig=hfig(find(hfig==335));
    
    if ~isempty(hfig)   %~isempty(findobj(0,'Number', 335))
        figexist=1;
        %hfig=helpfig       ;%findobj(0,'Number', 335);
    else
        % disp('####  new fig');
        % hfig=figure('visible','off');
        hfig=figure(335);
%         set(hfig,  'visible','off','units','normalized','position',posfig);%[0.5757    0.0822    0.3889    0.4667]);
        set(hfig,  'visible','off','units','normalized','position',[0.5757    0.0822    0.3889    0.4667]);

       set(hfig,'CloseRequestFcn',@closeFig);
        %     hfig=findobj(0,'Number', 335);
        %         set(hfig,'visible','off','units','normalized','position',posfig);
    end
else
    %hfig=figure;
    hfig=figure('visible','off','units','normalized','position',posfig);
    set(hfig,'CloseRequestFcn',@closeFig);
end

if ischar(fun)
   if exist(fun) ==2 % file
       set(hfig,'name', ['[HELP] ' fun], 'NumberTitle', 'off');
   end
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if figexist==0
    pause(.001)
end

x=setup(x);

if figexist==0
    pause(.001)
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if ~isfield(paras,'lbpos')
    paras.lbpos=[0 0 1 1];  %LISTBOXposition
end

if figexist==0
%     figure(hfig);
    %mlock();
    set(hfig,'tag','uhelp','color',[1 1 1]);
    set(hfig,'units','normalized','menubar','none',...
        'WindowScrollWheelFcn',{@gwheel,1});
    ui=uicontrol('Style','listbox','units','normalized', 'Position',paras.lbpos,...%[0 0,1 1],...
        'String', ...
        e2, 'tag','txt','max',2,...
        'backgroundcolor',[x.colbg],'fontsize',8);%,'fontname','Courier New');
    if ~isempty(posfig)
        %set(hfig,'position',posfig);
    end
    set(hfig,'WindowKeyPressFcn',@keyx)
else
    hlb=findobj(hfig,'tag','txt');
    set(hlb,'value',1)
    set(hlb,'string',e2);
end

% PUT AT THE END-orig
% if figexist==0
%     try
%         set(ui,'FontName',  x.FontName,'FontAngle',x.FontAngle,...
%             'FontWeight',x.FontWeight,'fontsize',x.fontsize);
%         set(ui,'backgroundcolor','w');
%         
%     end
%     if isfield(paras,'position');
%         set(hfig,'position',paras.position);
%     else
%         try
%             if isempty(varargin) || varargin{1}==0
%                 set(hfig,'position',posfig); % previous pos
%             end
%         catch
%             set(hfig,'position',x.fgpos);
%         end
%     end
%     drawnow;
%     try;     aot(x.aot);aot(x.aot);  end %AOT
%     set(hfig,'toolbar','none');
% end




if figexist==0
    
    %----------------------------------
    %           AOT-button
    %----------------------------------
    b1 = uicontrol('Style', 'checkbox', 'String', '','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','toggle: alway on top',...
        'Position', [0 0 .03 .032], 'Callback', @ontop,'backgroundcolor',[1 1 1]);
    if x.aot==1; set(b1,'value',1); else; set(b1,'value',0);end
    set(b1,'units','pixels');
    %----------------------------------
    %         window-resize button
    %----------------------------------
    b1 = uicontrol('Style', 'togglebutton', 'String', '<>','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','adjust window to text',...
        'Position', [0.055 0 .04 .035], 'Callback', @adjustwindow,'tag','adjustwindow','backgroundcolor',[1 1 1]);
   % if x.aot==1; set(b1,'value',1); else; set(b1,'value',0);end
   set(b1,'value',0);
   set(b1,'units','pixels');
   
    %----------------------------------
    %         editor-mode button
    %----------------------------------
    b1 = uicontrol('Style', 'togglebutton', 'String', 'EM','tag', 'EM','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','toogle READMODE/EDITORMODE[EM]',...
        'Position', [0.095 0 .04 .035], 'Callback', @editormode,'backgroundcolor',[1 1 1]);
   % if x.aot==1; set(b1,'value',1); else; set(b1,'value',0);end
   set(b1,'value',0);
   set(b1,'units','pixels');
   
    %----------------------------------
    %      text lineNumber
    %----------------------------------
    b1 = uicontrol('Style', 'text', 'String', '1','fontsize',7,...%'pushbutton'
        'units','normalized','TooltipString',[...
        'selected line numbers(s)/N of total lines' char(10) ...
        '#N number of selected lines' ...
        ],'tag','txtline',...
        'Position', [0.135 0 .13 .035], 'Callback', @txtline,'backgroundcolor',[     0.8627    0.8627    0.86277]);
   % if x.aot==1; set(b1,'value',1); else; set(b1,'value',0);end
%    set(b1,'value',0);
   set(b1,'units','pixels');
    
     %----------------------------------
    %     main functions
    %----------------------------------
    if exist('showfun.m')==2
        if isempty(findobj(hfig,'tag','helpMainfunctions')) 
            p=showfun;
            p=cellfun(@(a) {[a '.m']},p);
            b1 = uicontrol('Style', 'popupmenu', 'string',p,'fontsize',7,...%'pushbutton'
                'units','normalized','TooltipString','help for other functions ','tag','helpMainfunctions',...
                'Position', [0.265 -.001 .14 .039], 'Callback', @helpMainfunctions,...
                'backgroundcolor',[     0.8627    0.8627    0.86277],'ForegroundColor',[0 .5 0]);
            set(b1,'units','pixels');
        end
    end
   
    finder_ini();
end

if figexist==0
    
    %----------------------------------
    %           HELP
    %----------------------------------
    b2 = uicontrol('Style', 'pushbutton', 'String', '','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','help; see also CONTEXTMENU',...
        'Position', [0.025 0 .03 .035], 'Callback', {@gcontext, 6},'backgroundcolor',[1 1 1]);
    a2=[0 1 0.0313725490196078 0.32156862745098 1 1 1 1 1 1 1 1 1 1 0.83921568627451 0.741176470588235 0.968627450980392 0.905882352941176 0.741176470588235 0.968627450980392 0.776470588235294 0.258823529411765 0.776470588235294 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0470588235294118 0.333333333333333 1 1 1 1 1 1 1 1 1 1 0.811764705882353 0.729411764705882 0.952941176470588 0.890196078431373 0.713725490196078 0.937254901960784 0.745098039215686 0.235294117647059 0.764705882352941 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0627450980392157 0.290196078431373 0 0.290196078431373 0.32156862745098 0.352941176470588 0.517647058823529 0.611764705882353 0.67843137254902 0.83921568627451 0.870588235294118 0.968627450980392 0 0.0941176470588235 0.223529411764706 0.258823529411765 0.0941176470588235 0.290196078431373 0.290196078431373 0.0627450980392157 0.741176470588235 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0]';
    aa2=[25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 21 20 16 19 17 21 21 25 25 25 25 25;25 25 25 21 15 11 13 8 5 14 14 21 21 24 24 25;25 25 25 21 18 12 1 10 5 5 4 4 21 1 1 2;21 21 25 21 18 12 1 4 7 21 21 4 21 22 22 2;25 25 25 21 18 9 7 5 5 5 4 4 21 3 3 2;25 25 25 21 18 6 4 4 4 18 18 21 21 2 23 25;25 25 25 25 21 18 18 18 18 21 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25]';
    set(b2,'cdata',   ind2rgb(uint8(aa2),a2),'visible','on');
    set(b2,'units','pixels');
    %----------------------------------
    %%         context
    %----------------------------------
   
    cmenu = uicontextmenu;
    
    item4 = uimenu(cmenu, 'Label','copy  selection', 'Callback', {@gcontext, 4});%copy
    item41 = uimenu(cmenu, 'Label','copy  vertical selection', 'Callback', {@gcontext, 41},'tag' ,'copyverticalselection','enable','off');%copyverticalSelection
    item42 = uimenu(cmenu, 'Label','copy  column'            , 'Callback', {@gcontext, 42},'tag' ,'copycolumn','enable','off');%copy columnwise
    
    item8 = uimenu(cmenu, 'Label','save table as Figure (reloadable)', 'Callback', {@gcontext, 8},'separator','on');%save
    
    item9 = uimenu(cmenu, 'Label','load table (Figure)', 'Callback', {@gcontext, 9});%open
    
    
    item10 = uimenu(cmenu, 'Label','save as textfile', 'Callback', {@gcontext, 10});%save
    set(item10,'Separator','on');
    item11 = uimenu(cmenu, 'Label','load textfile', 'Callback', {@gcontext, 11});%save
    
    
    item1 = uimenu(cmenu, 'Label','font',     'Callback', {@gcontext, 1});
    set(item1,'Separator','on');
    item2 = uimenu(cmenu, 'Label','backgroundcolor', 'Callback', {@gcontext, 2},'Separator','off');
  
    
   %====================================
    
    item5 = uimenu(cmenu, 'Label','<html><font color=red>evaluate selection', 'Callback', {@gcontext, 5},'Separator','on');% evaluate
    item6 = uimenu(cmenu, 'Label','help',   'Callback', {@gcontext, 6});%help
    item7 = uimenu(cmenu, 'Label','see in Matlabs Help browser',   'Callback', {@gcontext,7});%help
    
    item20 = uimenu(cmenu, 'Label','toggle: [RM] Read Mode [EM] Editor Mode ',   'Callback', {@gcontext,20});%switch mode
    %====================================
    item3 = uimenu(cmenu, 'Label','save Config as global variable "uhelp_properties" (session-preserved)',...
        'Callback', @saveconfig_global,'Separator','on');
    item3 = uimenu(cmenu, 'Label','reset Config to default properties (clear global variable "uhelp_properties"',...
        'Callback', @clearconfig_global,'Separator','off');
    
    item3 = uimenu(cmenu, 'Label','save Config,<not recommended>, props will be saved in this file  (until next upgrade-preserved)', 'Callback', {@gcontext, 3});
    set(item3,'Separator','on');
    
    drawnow;
    
   
    set(ui,'UIContextMenu', cmenu);

    %----------------------------------
    %           keys
    %----------------------------------
    set(hfig,'KeyPressFcn',@fontsize); %figure and..
    set(ui,'KeyPressFcn',@fontsize); %listbox is keysensitive
    %----------------------------------
    %           scroll:
    %here use findjobj
    %----------------------------------
end


set(hfig,'userdata',x);


%% from mfile-saved config
if figexist==0
    set(findobj(hfig,'style','listbox'),'FontName',x.FontName, 'fontsize',single(x.fontsize),'FontWeight','normal');%x.FontWeight
    
end

lb1=findobj(hfig,'style','listbox');
if isfield(paras,'fontsize');
    set(lb1, 'fontsize',paras.fontsize) ;
end

if isfield(paras,'cursor');
    if strcmp(paras.cursor,'end')
        set(lb1, 'value',size(get(lb1,'string'),1)  );
    end
    %   else
end

if figexist==0 %selection color listbox
    highlightedcolorLB();
end
% ==============================================
%%   
% ===============================================


% ==============================================
%%   loAD global defaults
% ===============================================

if figexist==0
    global uhelp_properties
    if ~isempty(uhelp_properties)
        s=uhelp_properties;
        tx= findobj(hfig,'tag','txt');
        try; set(tx,'backgroundcolor', s.colbg); end
        try; set(tx,'fontsize'       , s.fontsize); end
        try; set(tx,'FontName'       , s.FontName); end
        try; set(tx,'FontAngle'      , s.FontAngle); end
        try; set(tx,'FontWeight'     , s.FontWeight); end
        try; set(hfig,'position'     , s.fgpos);   end
    end
    
end


% ==============================================
%%   % PUT AT THE END-orig-shifted
% ===============================================


if figexist==0
    try
        set(ui,'FontName',  x.FontName,'FontAngle',x.FontAngle,...
            'FontWeight',x.FontWeight,'fontsize',x.fontsize);
        %set(ui,'backgroundcolor','w');
        
    end
    if isfield(paras,'position');
        set(hfig,'position',paras.position);
    else
        try
            if isempty(varargin) || varargin{1}==0
                set(hfig,'position',posfig); % previous pos
            end
        catch
            set(hfig,'position',x.fgpos);
        end
    end
   drawnow;
    try;     aot(x.aot);aot(x.aot);  end %AOT
    set(hfig,'toolbar','none');
else
    if isfield(paras,'position')
        set(hfig,'position',paras.position);
    end
end


set(hfig,'visible','on');

tx= findobj(hfig,'tag','txt');
set(tx,'callback', @txtline);

txtline([],[]);

varargout{1}=hfig;

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% •••••••••••••••••••••••••••••  SUBFUNS      •••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%%••••••••••••••••••••••••••••••••••••••••••••••
% embedded functions
%%%••••••••••••••••••••••••••••••••••••••••••••••

function closeFig(e,e2)

saveconfig_global();
try
    closereq();
catch
    set(gcf,'CloseRequestFcn','closereq');
    close(gcf);
end



function clearconfig_global(e,e2)
evalin('base','clear global uhelp_properties;');
x=setup({});
tx = findobj(Huhelp,'tag','txt');
try; set(tx,'backgroundcolor', x.colbg); end
try; set(tx,'fontsize'       , x.fontsize); end
try; set(tx,'FontName'       , x.FontName); end
try; set(tx,'FontAngle'      , x.FontAngle); end
try; set(tx,'FontWeight'     , x.FontWeight); end
try; set(Huhelp,'position'    , x.fgpos);   end

function saveconfig_global(e,e2)

% disp('..uhelp props stored in peristent variable (uhelp_properties)');
tx = findobj(Huhelp,'tag','txt');
s.colbg     =get(tx,'backgroundcolor');
s.fontsize  =get(tx,'fontsize');
s.FontName  =get(tx,'FontName');
s.FontAngle =get(tx,'FontAngle');
s.FontWeight=get(tx,'FontWeight');
s.fgpos     =get(Huhelp,'position');
% x=get(Huhelp,'userdata') ;
% s.aot=x.aot;
global uhelp_properties
uhelp_properties=s;
% disp(uhelp_properties);

% evalin('base','uhelp_properties');
% assignin('base','uhelp_properties',uhelp_properties);

function  hf=Huhelp % get handle of uhelp-figure
ch=findobj(0,'tag','uhelp');
hf=ch(1);

function helpMainfunctions(e,e2)

tx= findobj(Huhelp,'tag','txt');
if strcmp(get(tx,'style'),'listbox')==0;
    errordlg('select READ MODE first ','HELP FCTn');
   return 
end

hc=findobj(Huhelp,'tag','helpMainfunctions');
va=get(hc,'value');
li=get(hc,'string');
hlpfun=li{va};

a=help([hlpfun ]);
a=strsplit2(a,char(10))';
mT=[{[' #yk [' upper(hlpfun) '.m] ']}];%        __________________________________________________________________']}];
msg2=[{}; mT; a] ;


msg3=uhelp(msg2,[],'export',1); %to HTML
set(tx,'value',1,'string',msg3,'ListboxTop',1);

us=get(Huhelp,'userdata');
us.e0=msg2;
us.e2=msg3;
set(Huhelp,'userdata',us);
drawnow;



function highlightedcolorLB
tx=findobj(Huhelp,'tag', 'txt');

if strcmp(get(tx,'style'),'listbox')
    try
        % jListbox = findjobj(tx);
        % jListbox=jListbox.getViewport.getComponent(0);
        % jListbox.setSelectionAppearanceReflectsFocus(0);
        
        % drawnow;
        jScrollPane = findjobj(tx); % get the scroll-pane object
        jListbox = jScrollPane.getViewport.getComponent(0);
        jListbox.setSelectionAppearanceReflectsFocus(0);
        %
        v2=[ 0 0 0];%color
%         v=[ 0.98    0.98    0.98];
%         v=[0.9451    0.9686    0.9490];
        v=[0.8941    0.9412    0.9020];
        % v=uisetcolor
        set(jListbox, 'SelectionForeground',java.awt.Color(v2(1),v2(2),v2(3))); % java.awt.Color.brown)
        % set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
        set(jListbox, 'SelectionBackground',java.awt.Color(v(1),v(2),v(3))); % option #2
    end
end

% function f_find()
% 'sss'
% hs=findobj(Huhelp,'tag','txt')
% type=get(hs,'style');
% if strcmp(type,'listbox')
%     'lb'
%     tx=get(hs,'string')
%     iv=regexpi2(tx,'mean');
%     set(hs,'value',iv)
%     
% elseif strcmp(type,'edit')
%     'ed'
% end


function keyx(h,e)
try
    tx=findobj(Huhelp,'tag', 'txt');
    % if strcmp(get(tx,'style'),'edit'); return; end
catch
    return
end
    
 


if strcmp(e.Key,'escape')
   finder_cb_removefinder([],[],'ipn1');
end

if strcmp(e.Modifier,'alt') %copy selection
    % positioning
   if strcmp(e.Key      ,'uparrow')
       fontlist = listfonts;
       tx = findobj(Huhelp,'tag','txt');
       inum=find(   strcmp(fontlist, get(tx,'FontName')   ) );
       if inum>=2
           disp(['FONT(' num2str(inum-1) '/' num2str(length(fontlist))  '): ' fontlist{inum-1}]);
           set(tx,'FontName',fontlist{inum-1}); 
       end
   elseif strcmp(e.Key      ,'downarrow')
       fontlist = listfonts;
       tx = findobj(Huhelp,'tag','txt');
       inum=find(   strcmp(fontlist, get(tx,'FontName')   ) );
       if inum<=length(fontlist)-1
           disp(['FONT(' num2str(inum+1) '/' num2str(length(fontlist))  '): ' fontlist{inum+1}]);
           set(tx,'FontName',fontlist{inum+1}); 
       end
   end
end


if strcmp(e.Modifier,'control') %copy selection
    % positioning
   if strcmp(e.Character      ,'1')  || strcmp(e.Character      ,'0')  || strcmp(e.Key      ,'f1')
        set(Huhelp,'position',[0    0.0706         0.5    0.8983]);
    elseif strcmp(e.Character  ,'2') || strcmp(e.Character      ,'9')  || strcmp(e.Key      ,'f2')
        set(Huhelp,'position',[0    0.0706    0.75    0.8983]);
    elseif strcmp(e.Character  ,'3')                                   || strcmp(e.Key      ,'f3')
        set(Huhelp,'position',[0.4743    0.0728    0.5    0.8961]) ;
    elseif strcmp(e.Character,  '4')                                   || strcmp(e.Key      ,'f4')
        set(Huhelp,'position',[ 0.2486    0.0717    0.75    0.8961]);
    elseif strcmp(e.Character,  '5')
        posant=get(findobj(0,'tag','ant'),'position');
        if ~isempty(posant)
            height=0.35;
            set(Huhelp,'position',[posant(1) posant(2)-height   posant(3)  height-.03]);
        else
            set(Huhelp,'position',[ 0.3049    0.4189    0.3889    0.4667]);
        end
    elseif strcmp(e.Character,   '6')
        set(Huhelp,'position',[ 0.0028    0.0817    0.7500    0.4128]);
    elseif strcmp(e.Character,'j')
        try
            %         us=get(get(h,'parent'),'userdata');
            us=get(h,'userdata');
            sc=get(0,'ScreenSize');
            sc=sc(3:4);
            p=round (get(0,'PointerLocation'));
            p(2)=sc(2)-p(2);
            %     p
            us.jFrame.setLocation(p(1)*2,p(2)*2);
        end
    elseif strcmp(e.Character,'s')
        try
            %         us=get(get(h,'parent'),'userdata');
            us=get(h,'userdata');
            sc=get(0,'ScreenSize');
            sc=sc(3:4);
            p=round (get(0,'PointerLocation'));
            p(2)=sc(2)-p(2);
            c=[us.jFrame.getX us.jFrame.getY];
            d(1)= 2*p(1)-c(1);
            d(2)= 2*p(2)-c(2);
            us.jFrame.setSize(d(1),   d(2));
            
            %         us.jFrame.getSize
            %         us.jFrame.getWidth
            %         us.jFrame.getWidth
            %         jFrame.setSize=( )
        end
        
        
    elseif strcmp(e.Character,'+')
        tx= findobj(Huhelp,'tag','txt');
        set(tx,'fontsize', get(tx,'fontsize')+1)  ;
    elseif strcmp(e.Character,'-')
        tx= findobj(Huhelp,'tag','txt');
        if get(tx,'fontsize')-1 >1
            set(tx,'fontsize', get(tx,'fontsize')-1)  ;
        end
        % ----------------------------------------------------------------
    elseif strcmp(e.Key,'downarrow')  % go to END
        try
            lb1=findobj(h,'tag','txt');
            if strcmp(get(lb1,'style'),'edit')
                jhEdit = findjobj(tx);
                r = jhEdit.getComponent(0).getComponent(0);
                txt=char(r.getText);
                set(r,'CaretPosition',length(txt));
            else
                set(lb1, 'value',size(get(lb1,'string'),1)  );
            end
            uicontrol(lb1);
        end
    elseif strcmp(e.Key,'uparrow')  %go to begin
        try
            lb1=findobj(h,'tag','txt');
            if strcmp(get(lb1,'style'),'edit')
                jhEdit = findjobj(tx);
                r = jhEdit.getComponent(0).getComponent(0);
                txt=char(r.getText);
                set(r,'CaretPosition',1);
            else
                set(lb1, 'value',1 );
            end
            uicontrol(lb1);
        end
        % ----------------------------------------------------------------'
   elseif strcmp(e.Key          ,'m'); %EDITOR.MODE TOGGLE    
       hc=findobj(Huhelp,'tag','EM');
       set(hc,'value',~(get(hc,'value')));
       gcontext([],[], 20);
       return
           % ----------------------------------------------------------------'
   elseif strcmp(e.Key          ,'t'); %ADJUST TEXT TOGGLE  
       hc=findobj(Huhelp,'tag','adjustwindow');
       set(hc,'value',~(get(hc,'value')));
       adjustwindow();
       return    
    end
    
    
    if strcmp(e.Key,'leftarrow')
        gcontext([], [], 4);
    elseif strcmp(e.Key,'f')
        finder_MAIN_OpenPanel([],[]);
    end
end




%----------------------------------
%         AOT/ontop
% here use aot
%----------------------------------
function ontop(src,evnt)
warning off;

try
    
    jframe=get(Huhelp,'javaframe');
    try
        warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    catch
        warning off;
    end
    
    try
        jClient = jframe.fFigureClient;  % This works up to R2011a
    catch
        try
            jClient = jframe.fHG1Client;  % This works from R2008b-R2014a
        catch
            jClient = jframe.fHG2Client;  % This works from R2014b and up
        end
    end
    jWindow = jClient.getWindow;
    
    if jWindow.isAlwaysOnTop==1
        jWindow.setAlwaysOnTop(0);
    else
        jWindow.setAlwaysOnTop(1);
    end
    
catch
    
    if exist('aot.m')==0;%if aot.m is not in the matlabpath
        disp('[figure on top] is enabled, download and add [aot.m] to the matlabpath');
        disp('http://www.mathworks.com/matlabcentral/fileexchange/20694-aot');
    else
        x=get(Huhelp,'userdata');
        if x.aot==0
            try; x.aot=1; aot(1);end;  set(Huhelp,'menubar','none','toolbar','none');
        else
            try; x.aot=0; aot(0);end;  set(Huhelp,'menubar','none','toolbar','none');
            
        end
        set(Huhelp,'userdata',x);
    end
    
end


function txtline(e,e2)
% % 's'
try
    tx= findobj(Huhelp,'tag','txt');
    if strcmp(get(tx,'style'),'listbox')
        val=(get(tx,'value'));
        Nsel=length(val);
        minval=min(val);
        maxval=max(val);
        %tag='RM';
        tag='';
    else
        
        jhEdit = findjobj(tx);
        r = jhEdit.getComponent(0).getComponent(0);
        
        if r.hasFocus==0; return; end
        
        drawnow;
        txt=char(r.getText);
        cartpos=r.getCaretPosition;
        
        selstart=r.getSelectionStart;
        selend=r.getSelectionEnd    ;
        
        
         jVScroll = jhEdit.getVerticalScrollBar;
         g.scrollDown=jVScroll.getValue;
         g.height   =r.getHeight;
         g.perc     =g.scrollDown/g.height;
         g.sel=sort([cartpos selstart selend]);
        
        %disp(['caret-selection: ' num2str(g.sel) ]);
        setappdata(tx,'selectionindex',g);
        
        
        
        ichar=regexpi(txt,char(10)); %ichar(end+1)=ichar(end)+1;
        ichar=[-1 ichar]; %workaround for 1st line ...pretend there is a CR in neg.space
        sel=sort([cartpos selstart selend]);
        minval=max(find(ichar<=sel(1) ));
        maxval=max(find(ichar<=sel(end)  ));
       Nsel=maxval-minval+1 ;
       val=unique([minval maxval]);
       
%        clc;
%        disp(minval);
%        disp(maxval);
%         ichar=regexpi(txt,char(10));
%         charbef=find(ichar>sel(1));
%         minval=min(charbef);
%         if isempty(minval)
%             minval=max(minval)+1;
%         end
%         val=unique([minval  min(find(ichar>=sel(end)))]);
%         %tag='EM';
%         tag='';
%         
%         charbefEnd=find(ichar>=sel(3));
%         maxval=min(charbefEnd);
%         if isempty(maxval)
%             maxval=length(ichar)+1;
%         end
%          Nsel=maxval-minval+1 ;
% %         maxval=2;
%         
    end
    
    tg='';
    %if length(val)>1; tg='+'; end;
    %msg=[ tag ' ' num2str(minval) tg  '/' num2str(size(get(tx, 'string'),1)) ' #' num2str(Nsel)  ];
%     clc;
%     disp(maxval-minval+1);
%     disp(Nsel);
   

    if length(val)>1; 
        if maxval-minval+1==Nsel
        tg=['-' num2str(maxval)]; 
        else
         tg=['..' num2str(maxval)];    
        end
    end;
%     msg=[ num2str(minval)  tg  '/' num2str(size(get(tx, 'string'),1)) ' #' num2str(Nsel)  ];

  msg=[ '<HTML><b>' num2str(minval)  tg  '/' num2str(size(get(tx, 'string'),1))  ...
      '<FONT color="blue"><b> #' num2str(Nsel)  ];
  msg_NoHTML = regexprep( msg, '<.*?>', '' );
  
    if length(msg_NoHTML)<=12
        fs=7;
    else
        fs=6;
    end    
    set(findobj(Huhelp,'tag','txtline'),'string',msg,'fontsize',fs);
    hc=findobj(Huhelp,'tag','txtline');
    set(hc,'style','pushbutton')
end
%----------------------------------
%           adjust window
%----------------------------------
function adjustwindow(v,v2)

v=findobj(Huhelp,'tag','adjustwindow');
val=get(v,'value');
if val==1 && isempty(get(v,'userdata'))
   us2.figposition= get(Huhelp,'position');
   set(v,'userdata',us2);
end

if val==1
    lb=findobj(Huhelp,'tag', 'txt');
    fs=get(lb,'fontsize');
    
    us=get(Huhelp,'userdata');
    rw=char(us.e0);
    rc=sum(double(rw)==double(' '),1);
    lensp=length(find(rc==size(rw,1)));
    sil=size(rw,2);%size(char(get(lb,'string')),2)
    sil=sil-lensp;
    % sil=100
    if sil<10; sil=10; end
    
    % set(Huhelp,'units','inches'); pos=get(Huhelp,'position'); disp(pos(3));
    % set(Huhelp,'units','centimeters'); pos=get(Huhelp,'position'); disp(pos(3));
    % set(Huhelp,'units','characters'); pos=get(Huhelp,'position'); disp(pos(3));
    % set(Huhelp,'units','points'); pos=get(Huhelp,'position'); disp(pos(3));
    set(Huhelp,'units','pixels'); pos=get(Huhelp,'position'); %disp(pos(3));
    
    % sp=get(0,'ScreenPixelsPerInch')
    px=(sil*fs)*0.9;
    set(Huhelp,'position',[pos(1:2) px pos(4)]);
    set(Huhelp,'units','normalized');
else
    if ~isempty(get(v,'userdata'))
        us2=get(v,'userdata');
       pos=get(Huhelp,'position');
       set(Huhelp,'position',[pos(1:2) us2.figposition(3)  pos(4)]);
    end
    
end

%----------------------------------
%           adjust window
%----------------------------------
function editormode(v,v2)

gcontext([],[], 20);
% val=get(v,'value');
% if val==1
%     
% else
%     
%     
% end





%----------------------------------
%           arrow keys
%----------------------------------
function fontsize(src,evnt)

%———————————————————————————————————————————————
%%   listing to run callback only once
%———————————————————————————————————————————————
persistent UHELP_RunOnce_Flag0001
if isempty(UHELP_RunOnce_Flag0001)
    UHELP_RunOnce_Flag0001 = 1;
end

if UHELP_RunOnce_Flag0001==0
    return
end

if UHELP_RunOnce_Flag0001==1
    UHELP_RunOnce_Flag0001 = 0;
end
%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————


if strcmp(get(gco,'style'),'listbox')==0
    keyx([],evnt);
end
x=get(Huhelp,'userdata');



tx=findobj(Huhelp,'tag', 'txt');
% if strcmp(get(tx,'style'),'edit'); return; end

if strcmp(evnt.Modifier,'control'); %[control]+mousewheel
    x.evntModifier=1; %if [control]-key is pressed..
    %code this for mousewheel-specifications
else
    %     x.evntModifier=0;
    %     tx= findobj(Huhelp,'tag','txt');
    %     if size(tx,1)>1
    %         tx=tx(1);
    %     end
    %     if strcmp(evnt.Key,'leftarrow')
    %         if get(tx,'fontsize')-1>1
    %             set(tx,'fontsize', get(tx,'fontsize')-1)  ;
    %         end
    %     elseif strcmp(evnt.Key, 'rightarrow')
    %         set(tx,'fontsize', get(tx,'fontsize')+1)  ;
    %     end
    
    tx=findobj(Huhelp,'tag', 'txt');
    si=size(get(tx,'string'),1);
    nlinstp=20;
    vec=1:nlinstp:si;
    curlinTop=get(tx,'ListboxTop');
    if strcmp(evnt.Key,'leftarrow');
       % ixnewtop=vecnearest2(vec,curlinTop)-1;
        ixnewtop=max(find(vec<curlinTop-1));
        if ixnewtop>0
            set(tx,'ListboxTop', vec(ixnewtop)  )  ;
        end
    elseif strcmp(evnt.Key, 'rightarrow')
        ixnewtop=vecnearest2(vec,curlinTop)+1;
        if ixnewtop<=length(vec);
            set(tx,'ListboxTop', vec(ixnewtop) )  ;
        end 
%       elseif strcmp(evnt.Key, 'w')   
         % 'adjustWindow'
%       adjustwindow([],[]);
        
    end
    
    
end
% if strcmp(evnt.Modifier,'control')  && strcmp(evnt.Key,'c')
%     'copy'
%     us=get(Huhelp,'userdata');
% end

set(Huhelp,'userdata',x);

%----------------------------------
%           mousewheel
%----------------------------------
function gwheel(obj, event, mode)

try
    x=get(Huhelp,'userdata');
    if  x.evntModifier==0 %[scroll text]
        x=get(Huhelp,'userdata'); scroll=x.scroll;
        try
            set(scroll,'value',   get(scroll,'value')  +event.VerticalScrollCount*25);
        catch %after savibng Image
            x.scroll=findjobj(Huhelp,'Class', 'UIScrollPane$1');%scroll
            set(Huhelp,'userdata',x);
        end
        
    else %define fontsize with mouse wheel
        tx= findobj(Huhelp,'tag','txt');
        
        fs= get(tx,'fontsize');
        fs2=fs+event.VerticalScrollCount;
        if fs2>1
            set(tx,'fontsize', fs2)  ;
        end
        x.evntModifier=0;
        set(Huhelp,'userdata',x);
    end
end



%----------------------------------
%           contextmenu
%----------------------------------
function gcontext(obj, event, mode)
x= get(Huhelp,'userdata');
if mode==1
    tx= findobj(Huhelp,'tag','txt');
    r.FontName=get(tx,'FontName');
    r.FontWeight=get(tx,'FontWeight');
    r.FontAngle=get(tx,'FontAngle');
    r.FontSize=get(tx,'fontsize');
    r.FontUnits= 'points' ;
    
    try;aot(0);end
    set(Huhelp,'menubar','none','toolbar','none');
    ix= uisetfont(r );
    try
    set(tx,'fontsize',ix.FontSize);
    catch
        return
    end
    
    
    try
        str=get(tx,'string');
        fstag=find(cellfun('isempty',regexpi(str,'<font size='))==0);
        fstag=fstag(1);
        fstag=str{fstag};
        fstag=fstag(min(findstr(fstag,'font size')):min(findstr(fstag,'font size'))+14);
        
        oldFS=str2num(char(regexprep({fstag},'[A-z\W]','')));
        newFS=ix.FontSize;
        str=regexprep(str,['<font size="'  num2str(oldFS) '">'],['<font size="'  num2str(newFS) '">']);%char(dd(1:6));
        set(tx,'string',str);
    end
    
    try;    set(tx,ix);drawnow; end
elseif mode==2
    try
        p=colorui;
    catch
        p=uisetcolor;
    end
    try
        tx= findobj(Huhelp,'tag','txt');
    end
    try;     set(tx,'backgroundcolor',p); end
elseif mode==3
    tx= findobj(Huhelp,'tag','txt');
    s.colbg=get(tx,'backgroundcolor');
    s.fontsize=get(tx,'fontsize');
    s.FontName=get(tx,'FontName');
    s.FontAngle=get(tx,'FontAngle');
    s.FontWeight=get(tx,'FontWeight');
    s.fgpos=get(Huhelp,'position');
    x=get(Huhelp,'userdata') ;
    s.aot=x.aot;
    
    fi=which('uhelp.m');
    fil={};
    fid=fopen(fi);    j=1;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        fil{j,1}=tline;     j=j+1;
    end
    fclose(fid);
    
    for i=1:length(fil)
        if ~isempty( findstr(fil{i},'%***setup-start'))
            w1=i;
        end
        if ~isempty( findstr(fil{i},'%***setup-end'))
            w2=i;
        end
    end
    
    fil1=fil(1:w1);
    fil2=fil(w2:end);
    v=fieldnames(s);
    filset={};
    for i=1:length(v)
        dum0=['dum1=s.' v{i} ';']; eval(dum0);
        if ischar( dum1)
            filset{i,1}=['x.' v{i} '='''   num2str(dum1)  ''';' ];
        else
            filset{i,1}=['x.' v{i} '=['   num2str(dum1)  '];' ];
        end
    end
    %      char(filset)
    filnew=[fil1; filset; fil2];
    
    fid = fopen([   fi ],'w','n');%SAVE
    for i=1:size(filnew,1)
        dumh=char(  (filnew(i,:)) );
        fprintf(fid,'%s\n',dumh);
    end
elseif mode==4 || mode==5%[4] copy selection or [5]evaluate selection
    
    tx= findobj(Huhelp,'tag','txt');
    if strcmp(get(tx,'style'),'edit') 
      
            jhEdit = findjobj(tx);
            r = jhEdit.getComponent(0).getComponent(0);
            txt=char(r.getText);
            %txt2copy=txt(r.getSelectionStart+1:r.getSelectionEnd);
            txt2copy=get(r,'SelectedText');
        if mode==4
            clipboard('copy',txt2copy);
            return
        else  
            try
                try
                    cprintf([0 .5 0],[ 'RUN:\n' ]);
                catch
                    fprintf(1,'RUN:\n');
                end
                disp(txt2copy);
                
                evalin('base',txt2copy);
            catch e %e is an MException struct
                try
                    cprintf([0 .5 0],[ sprintf('ERROR  : %s',e.identifier) '\n' ]);
                    cprintf([0 .5 0],[ sprintf('MESSAGE: %s',e.message   ) '\n' ]);
                catch
                    fprintf(1,'The identifier was:\n%s',e.identifier);
                    fprintf(1,'There was an error! The message was:\n%s',e.message);
                end
            end
            
            return
        end
    end
    
    
    x=get(Huhelp,'userdata');%get(tx,'string');
    li=x.e0;
    va=get(tx,'value');
    
    e0='';
    for i=1:length(va)
        %e0=[e0 li{va(i)}];
        e0=[e0 sprintf('%s\n' ,li{va(i)})];
    end
    
    if mode==4
        warning off;
        clipboard('copy',e0)
        warning on;
    elseif mode==5
        try;
            %             eval(e0);
            evalin('base',e0);
        end
    end
    
elseif mode==6
    %% HELP OF HELP
    po=get(Huhelp,'position');
    %     uhelp('uhelp',1); drawnow;
    
    hlp=help(mfilename);
    hlp=strsplit2(hlp,char(10))';
    uhelp(hlp,1);
    hf2=Huhelp;
%     set(hf2,'tag','uhelphelp')
    
    
    %
    %     ch=findobj(0,'tag','uhelp');
    %     x=get(Huhelp,'userdata');
    %     if x.aot==1
    %         for i=length(ch):-1:1
    %             figure(ch(i)); aot(0) ;
    %             if x.aot==1
    %                 try; aot(1); end
    %                 set(ch(i),'menubar','none','toolbar','none');
    %             end
    %         end
    %     end
    po([1 2])=po([1 2])-.1;
    set(hf2,'position',po,'name','HELP of HELP');
    setappdata(hf2,'helphelp',1)
elseif mode==7  %BROWSER
    
    us=get(Huhelp,'userdata');
    %xx=x.fun;
    xx=us.e0;
    
    if iscell(xx);     tx=strjoin(xx,char(10));
    else;                 tx=xx;
    end
    
    
    ta= regexprep(tx,{' #\w ' ,' #\w{1,2} ',' ## ' '&lt;'  '&gt;'},'');
    
    try;
        doc(ta);
    end
elseif mode==8 %save as figure
    %     item8 = uimenu(cmenu, 'Label','save Figure', 'Callback', {@gcontext, 8});%save
    
    [fi pa]=uiputfile('*.fig', 'save as Figure');
    try;
        saveas(Huhelp,fullfile(pa,fi),'fig') ;
        disp([ 'table saved as: ' fi ] );
    end
elseif mode==9 %Load Figure
    %     item9 = uimenu(cmenu, 'Label','load table (Figure)', 'Callback', {@gcontext, 9});%open
    [fi pa]=uigetfile('*.fig', 'load figuretable');
    open(fullfile(pa,fi));
    
elseif mode==10
    %     item10 = uimenu(cmenu, 'Label','save as textfile', 'Callback', {@gcontext, 10});%save
    try
        [fi pa]= uiputfile('*.txt', 'save as textfile');
        pathname=[pa fi];
        dataX=(x.e0);
        clas=class(dataX);
        fid = fopen(fullfile(pa,fi),'w','n');
        if  ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
            for i=1:size(dataX,1)
                dumh=char(  (dataX(i,:)) );
                fprintf(fid,'%s\n',dumh);
            end
        end
        fclose(fid);
    catch
        try;  fclose(fid);end
    end
    
elseif mode==11
    %     item11 = uimenu(cmenu, 'Label','load textfile', 'Callback', {@gcontext, 11});%save
    
    [fi pa]= uigetfile('*.txt', 'load textfile');
    
    
    try
        fid = fopen(fullfile(pa,fi));
        d=[];
        j=1;
        while 1
            tline=fgetl(fid);
            if ~ischar(tline);break;end
            d{j,1}=tline;
            j=j+1;
        end
        fclose(fid);
        
        uhelp(d,1);
        return
    catch
        try;    fclose(fid);;end
    end
    
    
    
    
elseif mode==20 %SWITCH DO EDIT MODE
    tx= findobj(Huhelp,'tag','txt');
    HF=Huhelp;
    
    %% change to EDITMODE
    if strcmp(get(tx,'style'),'listbox') 
        
        % change COLORBUTTON + label
        hc=findobj(HF,'tag','EM');
        set(hc,'backgroundcolor',[1 1 0],'string','EM');
        tt= strsplit(get(hc,'tooltipstring'),char(10));
        tt{2}=['current mode: EDIT-MODE '];
        tt=strjoin(tt,char(10));
        set(hc,'tooltipstring',tt);
        
        
         %----LISTBOX_TOP-PART1
         hEdit=findobj(HF,'tag','txt');
         jhEdit = findjobj(hEdit);
         jVScroll = jhEdit.getVerticalScrollBar;
         tx= findobj(HF,'tag','txt');
         scrollDown=jVScroll.getValue;
         r = jhEdit.getComponent(0).getComponent(0);
         height=r.getHeight;
         perc=scrollDown/height;
         %disp([scrollDown height perc ]);
        %----------------------------
        
        s1=get(tx,'string');
        val=get(tx,'value');
%         lbtop=get(tx,'ListboxTop');
        
        us=get(HF,'userdata');
        set(tx,'string',us.e0);
        set(tx,'style','edit','HorizontalAlignment','left');
        set(tx,'value',val);
%         set(tx,'ListboxTop',lbtop);
        us.e2=s1;
        set(HF,'userdata',us)
        set(tx,'ButtonDownFcn',@txtline);
        
        cartline=val;
        hEdit=findobj(HF,'tag','txt');
        uicontrol(hEdit);
        jhEdit = findjobj(hEdit);
        set(jhEdit, 'HorizontalScrollBarPolicy', 32);
          
        r = jhEdit.getComponent(0).getComponent(0);
        r.setWrapping(0);
        set(r,'Editable',1) ;
        set(r,'MouseMovedCallback',@caretmoved);
%         set(r,'ActionPerformedCallback','123');
      % set(jhEdit, 'CaretPositionChangedCallback', 'disp(''rrrr'')');%https://de.mathworks.com/matlabcentral/answers/143259-caretpositionchanged-callback-for-editbox-not-working
      %set(jhEdit.getComponent(0).getComponent(0), 'CaretUpdateCallback', 'disp(''rrrr'')')
       set(jhEdit.getComponent(0).getComponent(0), 'CaretUpdateCallback', @txtline);

       
        txt=char(r.getText);
        
        try
            % ----- MIMIC SELECTED TEXT
            ichar=[regexpi(txt,char(10))];
            ichar=unique([1 ichar ichar(end)+1]);
            cartline=unique([min(cartline) max(cartline)]);
            
            if length(cartline)==1
                cartposnew   =[ichar([min(cartline)]) ];
                cartposnew(2)=ichar(min(find(ichar>cartposnew)));
            else
                cartposnew=ichar([min(cartline)  max(cartline)+1 ]);
            end
            cartposnew=unique([min(cartposnew) max(cartposnew)]);
            %         r.repaint;
            %         try
            r.setCaretPosition(cartposnew(1));
            r.setSelectionStart(cartposnew(1));
            r.setSelectionEnd(cartposnew(2)-1);
            
%             jVScroll = jhEdit.getHorizontalScrollBar;
%             jVScroll.setValue(1);
            
%             r.setCaretPosition(cartposnew(1));
%             
%             r.setSelectionStart(cartposnew(1));
%             r.setSelectionEnd(cartposnew(2));
            
            
        end
       
          
          % jVScroll.setValue(cartposnew);
          %jVScroll = jhEdit.getVerticalScrollBar;
          %drawnow;
          %sv=jVScroll.getValue;
          %jVScroll.setValue(sv+300);
          
            %----LISTBOX_TOP-PART2
            hEdit=findobj(HF,'tag','txt');
            jhEdit = findjobj(hEdit);
            jVScroll = jhEdit.getVerticalScrollBar;
            tx= findobj(HF,'tag','txt');
            %scrollDown=jVScroll.getValue;
            r = jhEdit.getComponent(0).getComponent(0);
            height=r.getHeight;
            scrollDown2=round(perc*height);
            %disp({nan scrollDown2 height perc});
            jVScroll.setValue(scrollDown2);
            %----------------------------
            % HORZONTAL SCROLL TO START
            jVScroll = jhEdit.getHorizontalScrollBar;
            jVScroll.setValue(1);
 
          txtline([],[]);
          set( findobj(HF,'tag','txtline'),'backgroundcolor' ,[1 1 0]);
          set(findobj(HF,'tag','copyverticalselection'),'enable','on');
          set(findobj(HF,'tag','copycolumn'),'enable','on');
         r.repaint;
   
    else
        %%  CHANGE TO READMODE
       % change COLORBUTTON + label
        hc=findobj(HF,'tag','EM');
        set(hc,'backgroundcolor',[1 1 1],'string','RM');
        tt= strsplit(get(hc,'tooltipstring'),char(10));
        tt{2}=['current mode: READ-MODE '];
        tt=strjoin(tt,char(10));
        set(hc,'tooltipstring',tt);
        
        
        %----LISTBOX_TOP-PART1
         hEdit=findobj(HF,'tag','txt');
         jhEdit = findjobj(hEdit);
         jVScroll = jhEdit.getVerticalScrollBar;
         tx= findobj(HF,'tag','txt');
         scrollDown=jVScroll.getValue;
         r = jhEdit.getComponent(0).getComponent(0);
         % SELECTED TEXT
         cartline(1)= r.getSelectionStart;
         cartline(2)= r.getSelectionEnd;
         
         
         height=r.getHeight;
         perc=scrollDown/height;
         %disp([scrollDown height perc ]);
         
         
         g=getappdata(tx,'selectionindex');
         if ~isempty(g)
             cartline=[min(g.sel) max(g.sel)];
               height=g.height;
               perc  =g.perc;
         end
         
         txt=char(r.getText);
         %cartline
         
         
         
         
        %----------------------------
          us=get(HF,'userdata');
          if 0
              % TEST_WRITE-LOCKED-MODE
              set(tx,'string',us.e2); %%OLD TEXT
              
          end
          
          % TEST_WRITEABLE-MODE
          e0=strsplit(txt,char(10))';
          e2=htmlcolorize(e0)  ;
           set(tx,'string',e2); %%MODIFIED TEXT
          us.e2=e2;
          us.e0=e0;
          set(HF,'userdata',us);
          
          set(tx,'style','listbox');
          
          
          %---selected text MIMIC
          cartline=sort(cartline);
          ichar=[regexpi(txt,char(10))];
          if isempty(ichar)
              ichar=1;
          end
             
          ichar=unique([1 ichar ichar(end)+10000]);
          value=unique([max(find(ichar<(1+cartline(1)))):max(find(ichar<(1+cartline(2))))]);
          if isempty(value); value=1; end
          set(tx,'value',value);
          %-------
          
            %----LISTBOX_TOP-PART2
               for i=1:2
                pause(0.05);
                 drawnow
                hEdit=findobj(HF,'tag','txt');
                jhEdit = findjobj(hEdit);
                jVScroll = jhEdit.getVerticalScrollBar;
                drawnow;
                tx= findobj(HF,'tag','txt');
                %scrollDown=jVScroll.getValue;
                r = jhEdit.getComponent(0).getComponent(0);
                drawnow;
                height=r.getHeight;
                scrollDown2=round(perc*height);
                %disp({nan scrollDown2 height perc});
                jVScroll.setValue(scrollDown2);
                drawnow;
                r.repaint;
            end
          %----------------------------
          
%           ht=findobj(HF,'tag','txtline');
%           try
%               str=get(ht,'string');
%               %currline=str2num(regexprep(strtok(get(ht,'string'),'/'),'\D','')) ;
%               str_NoHTML = regexprep( str, '<.*?>', '' );
%               currline=str2num(regexprep(str_NoHTML,'[-|/|\.\.].*',''));
%               if isempty(currline); currline=1; end
%               set(tx,'value',currline);
%           catch
%               set(tx,'value',currline);
%           end
          txtline([],[]);
          set( findobj(HF,'tag','txtline'),'backgroundcolor' ,[0.8627    0.8627    0.8628]);
          highlightedcolorLB();
          set(findobj(HF,'tag','copyverticalselection'),'enable','off');
          set(findobj(HF,'tag','copycolumn'),'enable','off');
          
%           %----LISTBOX_TOP-PART2
%           hEdit=findobj(HF,'tag','txt');
%           jhEdit = findjobj(hEdit);
%           jVScroll = jhEdit.getVerticalScrollBar;
%           tx= findobj(HF,'tag','txt');
%           %scrollDown=jVScroll.getValue;
%           r = jhEdit.getComponent(0).getComponent(0);
%           height=r.getHeight;
%           scrollDown2=round(perc*height);
%           %disp({nan scrollDown2 height perc});
%           jVScroll.setValue(scrollDown2);
%           %----------------------------
%           drawnow;


        end

    elseif mode==41 %copy vertical selection
    % ==============================================
    %%   copy vertical/or columnwise selection
    % ===============================================
    if strcmp(get(obj,'tag'),'copycolumn')==1
        iscopycol=1;
    else
        iscopycol=0;
    end
    
    
    he=findobj(HF,'tag','txt');
    if strcmp(get(he,'style'),'edit')~=1; return; end %edit MODE ONLY
    hj=findjobj(he);
    drawnow;
    r2 = hj.getComponent(0).getComponent(0);
    %%   extract text
    range=[get(r2,'SelectionStart') get(r2,'SelectionEnd')];
    tx=char(r2.getText);
    
 
    txdum=regexprep(tx,'\d','v'); 
    if range(1)==0; range(1)=1; end
    if double(txdum(range(1)))~=10
    txdum(range(1))=num2str(1); 
    else
      txdum(range(1)+1)=num2str(1);   
    end
    txdum(range(2))=num2str(2);
    
    tx2=strsplit(tx,char(10))';
    txdum2=strsplit(txdum,char(10))';
    
    cr=[regexpi(txdum2,'1') regexpi(txdum2,'2')];
    
    row=[find(~cellfun('isempty',cr(:,1))) find(~cellfun('isempty',cr(:,2)))];
    lin=[cr{row(1),1} cr{row(2),2}];
    lin=[lin(1)+1 lin(2)];
    s1=[row(1) lin(1)];
    s2=[row(2) lin(2)];
    if s2(2)<s1(2);         s2(2)=s1(2);       end
    if iscopycol==1 %columnwise copy
        s1(1)=1;  s2(1)=size(tx2,1);
    end
    %disp(s1); disp(s2); %DISP
    tx3=char(tx2(s1(1):s2(1)));
    try    ;tx4=tx3(:,s1(2):s2(2));
    catch  ;tx4=tx3(:,s1(2):end);
    end
    
    mat2clip(tx4); %COPY TO CLIPBOARD
%     disp(tx4);
  
elseif mode==42 %copycolumn 
    gcontext(obj, event, 41);
    
end

function Tokens = strsplit2(String, Delim)
Tokens = [];
while (size(String,2) > 0)
    if isempty(Delim)
        [Tok, String] = strtok(String);
    else
        [Tok, String] = strtok(String, Delim);
    end
    Tokens{end+1} = Tok;
end


function e2=htmlcolorize(e2)

col1={...
    'b' 'blue'
    'g' 'green'
    'r' 'red'
    'c' 'aqua'
    'm' 'FF00FF'
    'y' 'FFd700'
    'k' 'black'
    'w' 'white'
    'x' 'A52a2a'
    'l' '00ff00' %lime
    'o' 'FFA500'
    'a' '#C0C0C0'  %antrazit (GRAU)
    'd' '#808080'  %dark (GRAUdunkel)
    };

%
% FS=['<font size="'  num2str(x.fontsize)-2 '">'];

% vorl={};
% vorl(end+1,:)={'§'     ['<b>'   '<font  color="blue">' ]  '</b></font>'  };
% vorl(end+1,:)={'$'     ['<b>' FS '<font  color="red">']   ' </b></font> '  };
% vorl(end+1,:)={'##'     [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'###'    [' <b>' FS '<font  color="blue"> ' ]    ' </b></font> '  };
% vorl(end+1,:)={'####'   [' <b>' FS '<font  color="red"> '  ]   ' </b></font> '  };
% vorl(end+1,:)={'#####'  [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§r'  [' <b>' FS '<font  color="red"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§b'  [' <b>' FS '<font  color="blue"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§g'  [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§k'  [' <b>' FS '<font  color="black"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§m'  [' <b>' FS '<font  color="magenta"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§y'  [' <b>' FS '<font  color="yellow"> ']   ' </b></font> '  };
% vorl(end+1,:)={'#\D'      ['<b>' FS '<font color="white"  bgcolor="A52a2a" size="+1"> ']   ' </b></font></bgcolor></color> '  };
% vorl(end+1,:)={'#\D\D'     [' <b>' FS '<font color="white"  bgcolor="A52a2a" size="+1"> ']   ' </b></font></bgcolor></color> '  };

vorl={};
vorl(end+1,:)={'§'      ['<b>'   '<font  color="blue">'    ]  '</b></font>'  };
vorl(end+1,:)={'$'      ['<b>'   '<font  color="red">'     ]  '</b></font>'  };
vorl(end+1,:)={'##'     ['<b>'   '<font  color="green">'   ]  '</b></font>'  };
vorl(end+1,:)={'###'    ['<b>'   '<font  color="blue">'    ]  '</b></font>'  };
vorl(end+1,:)={'####'   ['<b>'   '<font  color="red">'     ]  '</b></font>'  };
vorl(end+1,:)={'#####'  ['<b>'   '<font  color="green">'   ]  '</b></font>'  };
vorl(end+1,:)={'§r'     ['<b>'   '<font  color="red">'     ]  '</b></font>'  };
vorl(end+1,:)={'§b'     ['<b>'   '<font  color="blue">'    ]  '</b></font>'  };
vorl(end+1,:)={'§g'     ['<b>'   '<font  color="green">'   ]  '</b></font>'  };
vorl(end+1,:)={'§k'     ['<b>'   '<font  color="black">'   ]  '</b></font>'  };
vorl(end+1,:)={'§m'     ['<b>'   '<font  color="magenta">' ]  '</b></font>'  };
vorl(end+1,:)={'§y'     ['<b>'   '<font  color="yellow">'  ]  '</b></font>'  };
vorl(end+1,:)={'§w'     ['<b>'   '<font  color="white">'   ]  '</b></font>'  };
% vorl(end+1,:)={'#n'     [' <b>'   '<font  color="black">'   ]  '</b></font>'  };

%NORMAL MODE ()
vorl(end+1,:)={'#n'     ['</b>'  ' <font color="black">']                       '</b></b> </font>'  };

vorl(end+1,:)={'#\D'    ['<b>'   ' <font color="white"  bgcolor="A52a2a">']   ' </b></font></bgcolor></color>'  };
vorl(end+1,:)={'#\D\D'  ['<b>'   ' <font color="white"  bgcolor="A52a2a">']   ' </b></font></bgcolor></color>'  };


vorl(end+1,:)={'%'      ['<b>    <font  color="green">']  ''   }; %remove comment %%
% vorl(end+1,:)={'%'      ['<font  color="green">']  ''   }; %remove comment %%


% yellow aqua=cyan color="DC143C"

%% html for tag '#yg'-type
% vorl2=[ ' </b>' FS '<font color="white">'];
% vorl3=[ ' </b>' FS '<font bgcolor="white">'];

vorl2=[ ' <b>'   '<font color="white">'];
vorl3=[ ' <b>'   '<font bgcolor="white">'];

% regexp( ' www www wwww ww wwwww' ,'\<www\>')
% regexp( ' www www wwww wwwww' ,'\<www\>')

veclin=[];
for v=1:size(vorl,1)%vpatter
    kpat=v;
    %     pat=char(regexprep(vorl(kpat,1),'\^','\\^'));
    %  pat=char(regexprep(vorl(kpat,1),'\^','\\^'));
    
    pat=char(vorl(kpat,1));
    pat2=[' \<' pat '\> ' ];
    ix=regexp(e2 ,pat2);
    lin=find(~cellfun('isempty',ix));
    veclin=[veclin; lin(:)];
    for j=1:length(lin);
        q=e2(lin(j));
        for npat=1:length( ix{lin(j)});
            %             speccol=find(cellfun('isempty',strfind(col1(:,1),   pat2(regexpi(pat2,'#')+2) ))==0)
            
            %             speccol=find(cellfun('isempty',strfind(col1(:,1), q{1}(regexp(q{1},pat2,'once')+2) ))==0);
            %             q{1}(regexp(q{1},pat2,'once')+2)
            speccol=find(cellfun('isempty',regexpi(col1(:,1), q{1}(regexp(q{1},pat2,'once')+2) ))==0);
            
            if isempty(speccol)
                if mod(npat,2)==1
                    q= regexprep(q,pat2, vorl(v,2) ,'once');
                    %            q= regexprep(q,pat2,'*','once')
                else
                    q=  regexprep(q,pat2, vorl(v,3)   ,'once');
                    %            q=  regexprep(q,pat2,'+','once')
                end
            else
                
                %                 speccol2=find(cellfun('isempty',strfind(col1(:,1),...
                %                     q{1}(regexp(q{1},pat2,'once')+3) ))==0);
                speccol2=find(cellfun('isempty',regexpi(col1(:,1),...
                    q{1}(regexp(q{1},pat2,'once')+3) ))==0);
                
                ds=regexprep(vorl2,'white', col1(speccol,2));
                if ~isempty(speccol2)
                    ds=[ds regexprep(vorl3,'white', col1(speccol2,2))] ;
                end
                q= regexprep(q,pat2, ds ,'once');
                
                
            end
            
            
        end
        %q={['<html>' q{1}]};
        %        q={['<html><pre>' q{1}   '</pre>' ]};
        e2(lin(j))  =q;
    end
    
end%v
% 'r'
veclin=unique(veclin);
for i=1:length(veclin)
    e2{veclin(i)}=[  '<html><pre>' e2{veclin(i)} '</pre>'  ];
end

htmlline=regexpi2(e2,'<html>');
if ~isempty(htmlline); %underscore
   % e2=regexprep( e2  ,'_','<u>_</u>');
   e2(htmlline)=regexprep( e2(htmlline)  ,'_','<u>_</u>');
end


function caretmoved(e,e2)
% 'blub'
% txtline([],[]);

function id=regexpi2(cells, str,varargin)
%same as regexpi but jelds indizes of mathing cells , instead of empty cells ('I'm tired to code this again and again)
id=regexpi(cells,str,varargin{:});
id=find(cellfun('isempty',id)==0);



function finder_ini()

w(:,:,1) =...
   [ 0    0  154  156  151  144  144  128  119   87   45    0    0    0    0    0
    0    0  157  255  255  245  222  196  170  126   68   65    0    0    0    0
    0    0  154  255  255  255  250  234  217  161  131  175   49    0    0    0
    0    0  154  223   99  100   99   99   99   61  153  208  155   65    0    0
    0    0  146  255  255  255  250  194  182  154  158  240  208  109   29    0
    0    0  145  227  105  123  127   79   99  119  108   45   81  136   24    0
    0    0  128  255  255  104   82  169  174  161  161   98  205  181   16    0
    0    0  124  231  108   85  171  255  191  187  211  152  125  215   11    0
    0    0  103  255  184   90  172  190  208  222  227  209  177  238    8    0
    0    0   96  225   74   98  154  176  218  222  255  206  117  242    6    0
    0    0   96  255  249  113  158  192  217  253  255   75  235  231    5    0
    0    0   83  222  110   58   53  159  197  253   76  151  222  198    5    0
    0    0   83  255  245  255  247  113  113   76  235  145  255  222   33    0
    0    0   83  238   97   96  103  111  116  107  100   75  145  255  222    0
    0    0   59  255  255  255  255  255  255  255  255  255  246  145  255  222
    0    0   59   59   59   59   59   59   59   59   59   59   59   36  145  145];
w(:,:,2) =...
    [0    0  184  184  180  175  174  167  160  135  101    0    0    0    0    0
    0    0  186  255  255  246  229  213  194  165  123  119    0    0    0    0
    0    0  184  255  255  255  252  237  229  192  168  197  109    0    0    0
    0    0  184  230  133  134  133  133  132   98  186  225  182  119    0    0
    0    0  177  255  255  255  251  198  181  161  186  248  225  151   90    0
    0    0  177  232  138  142  137  113  140  157  120   75  122  172   85    0
    0    0  161  255  255  118  137  224  218  217  217  106  209  205   80    0
    0    0  159  237  125  116  222  255  222  224  253  188  135  229   76    0
    0    0  145  255  182  131  216  218  234  248  253  228  176  246   74    0
    0    0  144  233   91  137  198  210  248  245  255  208  136  249   71    0
    0    0  144  255  249  119  214  235  250  255  255   97  223  251   70    0
    0    0  132  227  144   81   69  208  245  255   91  112   95  192   70    0
    0    0  132  255  248  255  241  119  119   91  228   91  251   95   59    0
    0    0  132  238  131  129  135  145  150  139  143   75   91  255   95    0
    0    0  113  255  255  255  255  255  255  255  255  255  209   91  255   95
    0    0  113  113  113  113  113  113  113  113  113  113  113   62   91   91];
w(:,:,3) =...
   [0    0  200  204  198  195  194  191  187  159  141    0    0    0    0    0
    0    0  200  255  255  248  240  222  213  190  154  157    0    0    0    0
    0    0  200  255  255  255  252  237  235  211  185  212  148    0    0    0
    0    0  200  242  189  190  188  187  191  156  205  229  204  156    0    0
    0    0  196  255  252  255  248  207  198  179  204  249  229  179  134    0
    0    0  198  245  194  185  176  184  204  208  160  135  173  192  129    0
    0    0  186  255  255  165  214  251  242  246  246  142  220  217  125    0
    0    0  177  252  167  186  252  255  241  242  255  204  172  237  122    0
    0    0  172  255  195  196  246  240  248  254  255  233  190  250  120    0
    0    0  173  249  141  196  242  236  254  250  255  219  191  248  120    0
    0    0  173  255  243  152  248  251  255  255  255  169  210  255  117    0
    0    0  163  243  200  143  114  220  246  255  146   89    0  184  117    0
    0    0  163  255  248  255  236  152  152  146  217   47  174    0   84    0
    0    0  163  250  185  184  188  197  200  190  204  113   47  182    0    0
    0    0  148  255  255  255  255  255  255  255  255  255  194   47  193    0
    0    0  148  148  148  150  150  150  150  150  150  148  148   93   47   47];

hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'CData',w./255,    'BackgroundColor','w');
set(hb,'units','norm'); 
set(hb,'position',[.405 0 .027 .03]);
set(hb,'callback',{@finder_MAIN_OpenPanel});
set(hb,'tooltipstring','find string');
set(hb,'units','pixel');


function  finder_MAIN_OpenPanel(e,e2)
% uhelp('mean.m',1);
%=======================
hfig=Huhelp;
figure(hfig);
delete(findobj(hfig,'userdata','ipn1')); 
delete(findobj(hfig,'userdata','ipn2')); 
delete(findobj(hfig,'userdata','ipn3'));  
delete(findobj(hfig,'tag','mission'))

units=get(hfig,'units');
set(hfig,'units','norm');
pos=[.6 .05];
finder_makepanel(1,[pos ]);

function keypressfinder(e,e2)
% e
% e2
% if strcmp(e2.Key,'escape')
%    finder_cb_removefinder([],[],'ipn1');
% end

function finder_makepanel(ipn,tp)
% set(gcf,'WindowKeyPressFcn',@keypressfinder);
hfig=Huhelp;
hm=findobj(hfig,'tag','mission');
p=get(hm,'userdata');

id=['ipn'  num2str(ipn)];

v=uint8(finder_geticon('hand'));
v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;
%% ________________________________________________________________________________________________
s=v; n=0;        % HAND
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'CData',s,'tag','move',...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2)+pos(4) pos(3:4)];  set(hb,'position',pos2);
set(hb,'tooltipstring','move floating panel to another position ');


% TEXT
hb=uicontrol('Style','text', 'Position',[25 25 16, 16], ...
    'string',['find string'],'fontsize',6,'tag','finderMSG',...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*1 tp(2)+pos(4)*1.5 .1 pos(4)];  set(hb,'position',pos2);
set(hb,'foregroundcolor',[0.8706    0.4902  0],'fontweight','bold');
%% ===============================================

v=uint8(finder_geticon('arrow'));
s=v; n=n+1;

%%   edit
s=v;
hb=uicontrol('Style','edit', 'Position',[25 25 16, 16], ...
    'fontsize',7,       'tag','ed_findstring',...
    'BackgroundColor','w','userdata',id,'string', '' );
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2)+pos(4) pos(3)*10  pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@finder_cb_find,1},'horizontalalignment','left');
hedit=hb;

posedit=get(hb,'position');
%% REMOVE FINDER
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'fontsize',10,       'tag','ed_clear',...
    'BackgroundColor','w','userdata',id,'string', 'x' );
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[sum(posedit([1 3])) posedit(2) pos(3)  pos(4)];  set(hb,'position',pos2);
set(hb,'callback',{@finder_cb_removefinder,id},'horizontalalignment','left');
set(hb,'tooltipstring','close finder');
set(hb,'FontName','courier','string','X');

wid=pos(3);
s=v;
%% ____________________DOWN____________________________________________________________________________
s=rot90(v);n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@finder_cb_find,1});
set(hb,'tooltipstring','find next');

%% __________________UP______________________________________________________________________________
s=flipud(rot90(v));n=n+1;
% s=double(imread(fullfile(matlabroot,'/toolbox/matlab/icons/view_zoom_in.gif')));
% s=s./max(s(:));
% s=repmat(s,[1 1 3]);
% s=load(fullfile(matlabroot,'/toolbox/matlab/icons/zoom.mat'));
% s=imread('iconfinder_Text_preview_132630.png');
% s=s.zoomCData;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]), 'CData',s,...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@finder_cb_find,-1});
set(hb,'tooltipstring','find previous');


%% __________________all______________________________________________________________________________
s=flipud(rot90(v));n=n+1;
hb=uicontrol('Style','pushbutton', 'Position',[25 25 16, 16], ...
    'Callback',@(a,b)disp(['+1 smiley' num2str(i)]),  ...
    'BackgroundColor','w','userdata',id);
set(hb,'units','norm'); pos=get(hb,'position');
pos2=[tp(1)+pos(3)*n tp(2) pos(3:4)];  set(hb,'position',pos2);
set(hb,'callback',{@finder_cb_find,0});
set(hb,'tooltipstring','highlight all found entries', 'string','A');

%% ________________________________________________________________________________________________

hp=findobj(hfig,'tag','move');
je = findjobj(hp); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',{@finder_motio,id}  );
set(findobj(hfig,'userdata',id),'units','pixels');

uicontrol(hedit);%focus

function finder_cb_removefinder(e,e2,id)
hp  =findobj(Huhelp,'userdata',id);
delete(hp);
% set(gcf,'WindowKeyPressFcn',@keyx);

function finder_cb_find(e,e2,par)
hf=Huhelp;
hed=findobj(hf,'tag','ed_findstring');
string=get(hed,'string');
hs=findobj(hf,'tag','txt');
type=get(hs,'style');
if strcmp(type,'listbox')  % 'lb';
    tx=get(hs,'string');
    iv=regexpi2(tx,string);
    Nfound=length(iv);
    if isempty(Nfound); Nfound=0; end
    set(findobj(hf,'tag','finderMSG'),'string',['found: ' num2str(Nfound) '' ]);
    
    if isempty(iv)
        set(hed,'backgroundcolor',[1.0000    0.8431         0]);
        set(hed,'string',['"' string '"' ' NOT FOUND !!!' ]);
        pause(.1);
        set(hed,'string',[ string   ]);
        set(hed,'backgroundcolor',[1 1 1]);
        return
    end
   
    
    sel=get(hs,'value');
    if length(sel)>1; sel=sel(1); end
    
    if par==1
         sel=get(hs,'value');
        if length(sel)>1; sel=sel(1)-1; end
        if sel>=max(iv);
            if   strcmp(get(e,'tag'),'ed_findstring'); % if in editbox, cursor ends..go back to begin
                sel=0;
            else
                return
                sel=0;
            end
        end
       
        sel=iv(min(find(iv>sel)));
        set(hs,'value',sel);
    elseif par==-1
        sel=get(hs,'value');
        if length(sel)>1; sel=sel(end)+1; end
        if sel<=min(iv);
            return
            sel=max(iv)+1;
        end
        sel=iv(max(find(iv<sel)));
        set(hs,'value',sel);
    elseif par==0
        set(hs,'value',iv);
    end
elseif strcmp(type,'edit')
    tx=get(hs,'string');
    jhEdit = findjobj(hs);
    r = jhEdit.getComponent(0).getComponent(0);
    txt=char(r.getText);
    sel=r.getSelectionStart;
    
    uicontrol(hs);
    iv=cell2mat(regexpi(cellstr(txt),string));
    
    Nfound=length(iv);
    if isempty(Nfound); Nfound=0; end
    set(findobj(hf,'tag','finderMSG'),'string',['found: ' num2str(Nfound) '' ]);
    
    if isempty(iv)
        set(hed,'backgroundcolor',[1.0000    0.8431         0]);
        set(hed,'string',['"' string '"' ' NOT FOUND !!!' ]);
        pause(.1);
        set(hed,'string',[ string   ]);
        set(hed,'backgroundcolor',[1 1 1]);
        return
    end
    if par==1 %select forward
        if sel>=max(iv)
            return
            sel=0;
        end
        sel=iv(min(find(iv>sel+1)));
        if isempty(sel);
            if strcmp(get(e,'tag'),'ed_findstring')==1
                sel=min(iv);
            else
                return;
            end
        end
        r.select(sel-1,sel-1+length(string));
        if strcmp(get(e,'tag'),'ed_findstring')==1
            %uicontrol(e);
        end
    elseif par==-1 %select backward
        if sel<=min(iv);
            return
            sel=max(iv)+1;
        end
        sel=iv(max(find(iv<sel)));
        r.select(sel-1,sel-1+length(string));
    elseif par==0 %SELECT ALL
        drawnow
        jEditbox = findjobj(hs);
        jEditbox = handle(jEditbox.getViewport.getView, 'CallbackProperties');
        highlighter = jEditbox.getHighlighter;
        thehighlighter=jEditbox.getHighlighter();
        Ncolored=thehighlighter.getHighlights;
        length(Ncolored);
        if length(Ncolored)>1
            thehighlighter.removeAllHighlights;
            return
        end
        if isempty(iv); return; end
        col=java.awt.Color( 0.9294,0.6941,0.1255);%(.8,.9,.9);
        %col=java.awt.Color.gray;
        yellowHighlighter = javaObject(...
            'javax.swing.text.DefaultHighlighter$DefaultHighlightPainter', col);
        thehighlighter.removeAllHighlights;
        for i=1:length(iv)
            thehighlighter.addHighlight(iv(i)-1,iv(i)-1+length(string),yellowHighlighter);
        end
    end
end


function finder_motio(e,e2,id)
hf=Huhelp;
set(findobj(hf,'userdata',id),'units','norm');
try
    units=get(0,'units');
    set(0,'units','norm');
    mp=get(0,'PointerLocation');
    set(0,'units',units);
    fp  =get(hf,'position');
    hp  =findobj(hf,'tag','move', '-and' ,'userdata',id);
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
end
set(findobj(hf,'userdata',id),'units','pixels');

function v=finder_geticon(name)
if strcmp(name,'arrow')
    v(:,:,1) =[
        0    0    0    0    1    6   56   97   97   57    8    1    0    0    0    0
        0    0    0   10  127  207  177  149  145  156  176  117   12    0    0    0
        0    0   18  189  138   90   94   90  125  162   92  103  145   22    0    0
        0    9   81   85   79  117  255  254   78   81   81   78   81  117   11    0
        1   99   72   66  106  255  255  254   64   72   72   65   72   71   69    1
        4  141   53   82  255  255  255  254   50   58   58   50   58   58   72    6
        33   96   72  255  255  255  255  255  254  254  254  254  253   45   46   25
        50   61  255  255  255  255  255  255  255  255  255  255  254   32   33   20
        43   44  209  255  255  255  255  255  255  255  255  255  254   19   20   12
        22   37    1  209  255  255  255  255  208  208  208  208  207    5    6    5
        1   44    0    2  209  255  255  254    0    1    1    1    1    0    0    3
        0   29    0    0    2  209  255  254    0    0    0    0    0    0    1    0
        0    0    0    0    0    2  238  207    0    0    0    0    0    0    0    0
        0    0    0   10    0    0    1    1    1   69    0    0    0    0    0    0
        0    0    0    0    4    1    0    0    0    0    0    0    0    0    0    0
        0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0];
    v(:,:,2) =[
        0    0    0    0    8   44  113  147  147  113   44    8    0    0    0    0
        0    0    0   61  173  241  241  233  232  236  233  169   60    0    0    0
        0    0   76  226  227  210  210  209  219  229  211  218  212   75    0    0
        0   56  202  204  202  213  255  255  202  205  205  202  205  201   56    0
        7  162  196  194  207  255  255  255  193  196  196  193  196  199  147    7
        36  225  186  195  255  255  255  255  184  188  188  185  188  188  191   37
        93  211  188  255  255  255  255  255  255  255  255  255  254  178  183   89
        123  192  255  255  255  255  255  255  255  255  255  255  255  171  174  104
        117  183  242  255  255  255  255  255  255  255  255  255  255  163  166   98
        84  179  114  242  255  255  255  255  241  242  242  242  241  154  159   76
        28  176  148  114  242  255  255  254  113  113  113  113  113  151  152   29
        5  122  151  149  114  242  255  255  146  151  151  147  151  154  116    5
        0   35  152  151  149  114  248  241  147  152  152  147  152  147   38    0
        0    0   46  145  154  151  151  149  150  179  147  154  147   50    0    0
        0    0    0   35  103  149  156  154  154  154  153  113   36    0    0    0
        0    0    0    0    5   24   64   82   83   66   24    4    0    0    0    0];
    v(:,:,3) =[
        0    0    0    0    0    0   32   77   77   33    0    0    0    0    0    0
        0    0    0    0  110  203  174  144  140  152  171  100    0    0    0    0
        0    0    1  183  133   84   88   84  119  159   87   99  138    2    0    0
        0    0   76   80   73  112  255  254   73   76   76   73   76  109    0    0
        0   85   68   62  103  255  255  254   60   68   68   61   68   68   56    0
        1  136   49   79  255  255  255  254   45   53   53   46   53   54   66    0
        19   92   68  255  255  255  255  255  254  254  254  254  253   42   44   13
        39   57  255  255  255  255  255  255  255  255  255  255  254   30   32    9
        34   43  205  255  255  255  255  255  255  255  255  255  254   18   19    4
        14   36    1  205  255  255  255  255  204  204  204  204  203    4    5    0
        0   41    0    2  205  255  255  254    0    1    1    1    1    0    0    0
        0   26    0    0    2  205  255  254    0    0    0    0    0    0    0    0
        0    0    0    0    0    2  238  203    0    0    0    0    0    0    0    0
        0    0    0    9    0    0    1    1    1   69    0    0    0    0    0    0
        0    0    0    0    3    1    0    0    0    0    0    0    0    0    0    0
        0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0];
    
elseif strcmp(name,'hand')
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
end





% #############################################################
%----------------------------------
% cofig is written HERE
%----------------------------------
function x=setup(x)
%***setup-start  %ANCHOR- DO NOT REMOVE THIS
x.colbg=[1 1 1];
x.fontsize=[8];
x.FontName='Courier New';
x.FontAngle='normal';
x.FontWeight='normal';
x.fgpos=[0.3049      0.4189      0.3889      0.4667];
x.aot=[0];
%***setup-end   %ANCHOR-DO NOT REMOVE THIS












