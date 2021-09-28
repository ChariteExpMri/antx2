function [t,sts] = cfg_getfile2(varargin)
% File selector2
% FORMAT [t,sts] = cfg_getfile2(n,typ,mesg,sel,wd,filt,frames)
%     n    - Number of files
%            A single value or a range.  e.g.
%            1       - Select one file
%            Inf     - Select any number of files
%            [1 Inf] - Select 1 to Inf files
%            [0 1]   - select 0 or 1 files
%            [10 12] - select from 10 to 12 files
%     typ  - file type
%           'any'   - all files
%           'batch' - SPM batch files (.m, .mat and XML)
%           'dir'   - select a directory
%           'image' - Image files (".img" and ".nii")
%                     Note that it gives the option to select
%                     individual volumes of the images.
%           'mat'   - Matlab .mat files or .txt files (assumed to contain
%                     ASCII representation of a 2D-numeric array)
%           'mesh'  - Mesh files (".gii" and ".mat")
%           'nifti' - NIfTI files without the option to select frames
%           'xml'   - XML files
%           Other strings act as a filter to regexp.  This means
%           that e.g. DCM*.mat files should have a typ of '^DCM.*\.mat$'
%      mesg - a prompt (default 'Select files...')
%      sel  - list of already selected files
%      wd   - Directory to start off in
%      filt - value for user-editable filter (default '.*')
%      frames - Image frame numbers to include (default '1')
%
%      t    - selected files
%      sts  - status (1 means OK, 0 means window quit)
%
% FORMAT [t,ind] = cfg_getfile2('Filter',files,typ,filt,frames)
% filter the list of files (cell array) in the same way as the
% GUI would do. There is an additional typ 'extimage' which will match
% images with frame specifications, too. The 'frames' argument
% is currently ignored, i.e. image files will not be filtered out if
% their frame numbers do not match.
% When filtering directory names, the filt argument will be applied to the
% last directory in a path only.
% t returns the filtered list (cell array), ind an index array, such that
% t = files(ind).
%
% FORMAT cpath = cfg_getfile2('CPath',path,cwd)
% function to canonicalise paths: Prepends cwd to relative paths, processes
% '..' & '.' directories embedded in path.
% path     - string matrix containing path name
% cwd      - current working directory [default '.']
% cpath    - conditioned paths, in same format as input path argument
%
% FORMAT [files,dirs]=cfg_getfile2('List',direc,filt)
% Returns files matching the filter (filt) and directories within dire
% direc    - directory to search
% filt     - filter to select files with (see regexp) e.g. '^w.*\.img$'
% files    - files matching 'filt' in directory 'direc'
% dirs     - subdirectories of 'direc'
% FORMAT [files,dirs]=cfg_getfile2('ExtList',direc,filt,frames)
% As above, but for selecting frames of 4D NIfTI files
% frames   - vector of frames to select (defaults to 1, if not
%            specified). If the frame number is Inf, all frames for the
%            matching images are listed.
% FORMAT [files,dirs]=cfg_getfile2('FPList',direc,filt)
% FORMAT [files,dirs]=cfg_getfile2('ExtFPList',direc,filt,frames)
% As above, but returns files with full paths (i.e. prefixes direc to each)
% FORMAT [files,dirs]=cfg_getfile2('FPListRec',direc,filt)
% FORMAT [files,dirs]=cfg_getfile2('ExtFPListRec',direc,filt,frames)
% As above, but returns files with full paths (i.e. prefixes direc to
% each) and searches through sub directories recursively.
%
% FORMAT cfg_getfile2('prevdirs',dir)
% Add directory dir to list of previous directories.
% FORMAT dirs=cfg_getfile2('prevdirs')
% Retrieve list of previous directories.
%
% This code is based on the file selection dialog in SPM5, with virtual
% file handling turned off.
%____________________________________________________________________________

%% addit struct as 8th. input
%% [1] search recoursively only in specified  paths
% w. recpaths: {2x1 cell}  : search recoursively only in this paths
% [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii' ,[],w);
% -->hack in subfct: "select_rec"




%% optional STRUCT INPUT =8th. variable
clear global glob_guiselect
if length(varargin)==8
    global glob_guiselect;
    glob_guiselect=varargin{8};
    
    if isempty(varargin{7}) ; vardel=1; else; vardel=0; end
    varargin(8-vardel:8)=[]; %clear variable again
    
end




t = {};
sts = false;
if nargin > 0 && ischar(varargin{1})
    switch lower(varargin{1})
        case {'addvfiles', 'clearvfiles', 'vfiles'}
            cfg_message('matlabbatch:deprecated:vfiles', ...
                'Trying to use deprecated ''%s'' call.', ...
                lower(varargin{1}));
        case 'cpath'
            cfg_message(nargchk(2,Inf,nargin,'struct'));
            t = cpath(varargin{2:end});
            sts = true;
        case 'filter'
            filt    = mk_filter(varargin{3:end});
            t       = varargin{2};
            if numel(t) == 1 && isempty(t{1})
                sts = 1;
                return;
            end;
            t1 = cell(size(t));
            if any(strcmpi(varargin{3},{'dir','extdir'}))
                % only filter last directory in path
                for k = 1:numel(t)
                    t{k} = cpath(t{k});
                    if t{k}(end) == filesep
                        [p n] = fileparts(t{k}(1:end-1));
                    else
                        [p n] = fileparts(t{k});
                    end
                    if strcmpi(varargin{3},'extdir')
                        t1{k} = [n filesep];
                    else
                        t1{k} = n;
                    end
                end
            else
                % only filter filenames, not paths
                for k = 1:numel(t)
                    [p n e] = fileparts(t{k});
                    t1{k} = [n e];
                end
            end
            [t1,sts1] = do_filter(t1,filt.ext);
            [t1,sts2] = do_filter(t1,filt.filt);
            sts = sts1(sts2);
            t = t(sts);
        case {'list', 'fplist', 'extlist', 'extfplist'}
            if nargin > 3
                frames = varargin{4};
            else
                frames = 1; % (ignored in listfiles if typ==any)
            end;
            if regexpi(varargin{1}, 'ext') % use frames descriptor
                typ = 'extimage';
            else
                typ = 'any';
            end
            filt    = mk_filter(typ, varargin{3}, frames);
            [t sts] = listfiles(varargin{2}, filt); % (sts is subdirs here)
            sts = sts(~(strcmp(sts,'.')|strcmp(sts,'..'))); % remove '.' and '..' entries
            if regexpi(varargin{1}, 'fplist') % return full pathnames
                direc = cfg_getfile2('cpath', varargin{2});
                % remove trailing path separator if present
                direc = regexprep(direc, [filesep '$'], '');
                if ~isempty(t)
                    t = strcat(direc, filesep, t);
                end
                if nargout > 1
                    % subdirs too
                    sts = cellfun(@(sts1)cpath(sts1, direc), sts, 'UniformOutput',false);
                end
            end
        case {'fplistrec', 'extfplistrec'}
            % list directory
            [f1 d1] = cfg_getfile2(varargin{1}(1:end-3),varargin{2:end});
            f2 = cell(size(d1));
            d2 = cell(size(d1));
            for k = 1:numel(d1)
                % recurse into sub directories
                [f2{k} d2{k}] = cfg_getfile2(varargin{1}, d1{k}, ...
                    varargin{3:end});
            end
            t = vertcat(f1, f2{:});
            if nargout > 1
                sts = vertcat(d1, d2{:});
            end
        case 'prevdirs',
            if nargin > 1
                prevdirs(varargin{2});
            end;
            if nargout > 0 || nargin == 1
                t = prevdirs;
                sts = true;
            end;
        otherwise
            cfg_message('matlabbatch:usage','Inappropriate usage.');
    end
else
    [t,sts] = selector2(varargin{:});
end

end
%=======================================================================

%=======================================================================
function [t,ok] = selector2(n,typ,mesg,already,wd,filt,frames,varargin)
if nargin<1 || ~isnumeric(n) || numel(n) > 2
    n = [0 Inf];
else
    if numel(n)==1,   n    = [n n];    end;
    if n(1)>n(2),     n    = n([2 1]); end;
    if ~isfinite(n(1)), n(1) = 0;        end;
end

if nargin<2 || ~ischar(typ), typ     = 'any';   end;

if nargin<3 || ~(ischar(mesg) || iscellstr(mesg))
    mesg    = 'Select files...';
elseif iscellstr(mesg)
    mesg = char(mesg);
end

if nargin<4 || isempty(already) || (iscell(already) && isempty(already{1}))
    already = {};
else
    % Add folders of already selected files to prevdirs list
    pd1 = cellfun(@(a1)strcat(fileparts(a1),filesep), already, ...
        'UniformOutput',false);
    prevdirs(pd1);
end

if nargin<5 || isempty(wd) || ~ischar(wd)
    if isempty(already)
        wd      = pwd;
    else
        wd = fileparts(already{1});
        if isempty(wd)
            wd = pwd;
        end
    end;
end

if nargin<6 || ~ischar(filt), filt    = '.*';    end;

if nargin<7 || ~(isnumeric(frames) || ischar(frames))
    frames  = '1';
elseif isnumeric(frames)
    frames = char(gencode_rvalue(frames(:)'));
elseif ischar(frames)
    try
        ev = eval(frames);
        if ~isnumeric(ev)
            frames = '1';
        end
    catch
        frames = '1';
    end
end
ok  = 0;

t = '';
sfilt = mk_filter(typ,filt,eval(frames));

[col1,col2,col3,lf,bf] = colours;

% lf=c2struct(lf); %SPM12
% bf=c2struct(bf);



% delete old selector2, if any
fg = findobj(0,'Tag',mfilename);
if ~isempty(fg)
    delete(fg);
end
% create figure
if  size(mesg,1)>1
    mesg2=mesg(1,:);
else
    mesg2=mesg;
end

fg = figure('IntegerHandle','off',...
    'Tag',mfilename,...
    'Name',mesg2,...
    'NumberTitle','off',...
    'Units','Pixels',...
    'MenuBar','none',...
    'DefaultTextInterpreter','none',...
    'DefaultUicontrolInterruptible','on',...
    'Visible','off');

cfg_onscreen(fg);
set(fg,'Visible','on');

sellines = min([max([n(2) numel(already)]), 4]);
[pselp pcntp pfdp pdirp] = panelpositions(fg, sellines+1);

uicontrol(fg,...
    'style','text',...
    'units','normalized',...
    'position',posinpanel([0 sellines/(sellines+1) 1 1/(sellines+1)],pselp),...
    lf,...
    'BackgroundColor',get(fg,'Color'),...
    'ForegroundColor',col3,...
    'HorizontalAlignment','left',...
    'string','',...%mesg
    'tag','msg');

% Selected Files
sel = uicontrol(fg,...
    'style','listbox',...
    'units','normalized',...
    'Position',posinpanel([0 0 1 sellines/(sellines+1)],pselp),...
    lf,...
    'Callback',@unselect,...
    'tag','selected',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'Max',10000,...
    'Min',0,...
    'String',already,...
    'Value',1);
c0 = uicontextmenu('Parent',fg);
set(sel,'uicontextmenu',c0);
uimenu('Label','Unselect All', 'Parent',c0,'Callback',@unselect_all);

% get cwidth for buttons
tmp=uicontrol('style','text','string',repmat('X',[1,50]),bf,...
    'units','normalized','visible','off');
fnp = get(tmp,'extent');
delete(tmp);
cw = 3*fnp(3)/50;

if strcmpi(typ,'image'),
    uicontrol(fg,...
        'style','edit',...
        'units','normalized',...
        'Position',posinpanel([0.61 0 0.37 .45],pcntp),...
        'Callback',@update_frames,...
        'tag','frame',...
        lf,...
        'BackgroundColor',col1,...
        'String',frames,'UserData',eval(frames));
    % 'ForegroundGolor',col3,...
end;

% Help
uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',posinpanel([0.02 .5 cw .45],pcntp),...
    bf,...
    'Callback',@heelp,...
    'tag','?',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','?',...
    'ToolTipString','Show Help');

uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',posinpanel([0.03+cw .5 cw .45],pcntp),...
    bf,...
    'Callback',@editwin,...
    'tag','Ed',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Ed',...
    'ToolTipString','Edit Selected Files');

uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',posinpanel([0.04+2*cw .5 cw .45],pcntp),...
    bf,...
    'Callback',@select_rec,...
    'tag','Rec',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Rec',...
    'ToolTipString',['Recursively Select Files with Current Filter from ' char(10) ...
    'cuurent folder and all subfolders']);

% Done
dne = uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',posinpanel([0.05+3*cw .5 0.45-3*cw .45],pcntp),...
    bf,...
    'Callback',@(h,e)delete(h),...
    'tag','D',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Done',...
    'Enable','off',...
    'DeleteFcn',@null);

if numel(already)>=n(1) && numel(already)<=n(2),
    set(dne,'Enable','on');
end;

% Filter Button
uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',posinpanel([0.51 .5 0.1 .45],pcntp),...
    bf,...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'Callback',@clearfilt,...
    'String','Filt');

% Filter
uicontrol(fg,...
    'style','edit',...
    'units','normalized',...
    'Position',posinpanel([0.61 .5 0.37 .45],pcntp),...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    lf,...
    'Callback',@(ob,ev)update(ob),...
    'tag','regexp','tooltipstr',['filter edit field' char(10) 'hit enter to evaluate this filter'],...
    'String',filt,...
    'UserData',sfilt);

% Directories
db = uicontrol(fg,...
    'style','listbox',...
    'units','normalized',...
    'Position',posinpanel([0.02 0 0.47 1],pfdp),...
    lf,...
    'Callback',@click_dir_box,...
    'tag','dirs',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'Max',1,...
    'Min',0,...
    'String','',...
    'UserData',wd,...
    'Value',1);

% Files
tmp = uicontrol(fg,...
    'style','listbox',...
    'units','normalized',...
    'Position',posinpanel([0.51 0 0.47 1],pfdp),...
    lf,...
    'Callback',@click_file_box,...
    'tag','files',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'UserData',n,...
    'Max',10240,...
    'Min',0,...
    'String','',...
    'Value',1);
c0 = uicontextmenu('Parent',fg);
set(tmp,'uicontextmenu',c0);
uimenu('Label','Select All', 'Parent',c0,'Callback',@select_all);

% Drives
if strcmpi(computer,'PCWIN') || strcmpi(computer,'PCWIN64'),
    % get fh for lists
    tmp=uicontrol('style','text','string','X',lf,...
        'units','normalized','visible','off');
    fnp = get(tmp,'extent');
    delete(tmp);
    fh = 2*fnp(4); % Heuristics: why do we need 2*
    sz = get(db,'Position');
    sz(4) = sz(4)-fh-2*0.01;
    set(db,'Position',sz);
    uicontrol(fg,...
        'style','text',...
        'units','normalized',...
        'Position',posinpanel([0.02 1-fh-0.01 0.10 fh],pfdp),...
        'HorizontalAlignment','left',...
        lf,...
        'BackgroundColor',get(fg,'Color'),...
        'ForegroundColor',col3,...
        'String','Drive');
    uicontrol(fg,...
        'style','popupmenu',...
        'units','normalized',...
        'Position',posinpanel([0.12 1-fh-0.01 0.37 fh],pfdp),...
        lf,...
        'Callback',@setdrive,...
        'tag','drive',...
        'BackgroundColor',col1,...
        'ForegroundColor',col3,...
        'String',listdrives(false),...
        'Value',1);
end;

[pd,vl] = prevdirs([wd filesep]);

% Previous dirs
uicontrol(fg,...
    'style','popupmenu',...
    'units','normalized',...
    'Position',posinpanel([0.12 .05 0.86 .95*1/3],pdirp),...
    lf,...
    'Callback',@click_dir_list,...
    'tag','previous',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'String',pd,...
    'Value',vl);
uicontrol(fg,...
    'style','text',...
    'units','normalized',...
    'Position',posinpanel([0.02 0 0.10 .95*1/3],pdirp),...
    'HorizontalAlignment','left',...
    lf,...
    'BackgroundColor',get(fg,'Color'),...
    'ForegroundColor',col3,...
    'String','Prev');

% Parent dirs
uicontrol(fg,...
    'style','popupmenu',...
    'units','normalized',...
    'Position',posinpanel([0.12 1/3+.05 0.86 .95*1/3],pdirp),...
    lf,...
    'Callback',@click_dir_list,...
    'tag','pardirs',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'String',pardirs(wd));
uicontrol(fg,...
    'style','text',...
    'units','normalized',...
    'Position',posinpanel([0.02 1/3 0.10 .95*1/3],pdirp),...
    'HorizontalAlignment','left',...
    lf,...
    'BackgroundColor',get(fg,'Color'),...
    'ForegroundColor',col3,...
    'String','Up');

% Directory
uicontrol(fg,...
    'style','edit',...
    'units','normalized',...
    'Position',posinpanel([0.12 2/3 0.86 .95*1/3],pdirp),...
    lf,...
    'Callback',@edit_dir,...
    'tag','edit',...
    'BackgroundColor',col1,...
    'ForegroundColor',col3,...
    'String','');
uicontrol(fg,...
    'style','text',...
    'units','normalized',...
    'Position',posinpanel([0.02 2/3 0.10 .95*1/3],pdirp),...
    'HorizontalAlignment','left',...
    lf,...
    'BackgroundColor',get(fg,'Color'),...
    'ForegroundColor',col3,...
    'String','Dir');

resize_fun(fg);
set(fg, 'ResizeFcn',@resize_fun);
update(sel,wd)

%% paul HACK
%=====================
units=get(gcf,'units');
set(gcf,'units','normalized');
set(gcf,'position',[0.0336    0.1299    0.6070    0.7334]);

%% fontsize
% screensize=get(0,'screensize');
% if screensize(4)<=1024
%     fs=8;
% else
%     fs=14;
% end
fs=8;
ch=get(gcf,'children');
for i=1:length(ch)
    try; set(ch(i),'fontsize',fs);end
end

%%larger selection range
hh=findobj(gcf,'string','Filt');
pos=get(hh,'position');
set(hh,'position',[.01 .32 .1 .02]);

hh=findobj(gcf,'tag','regexp');
pos=get(hh,'position');
set(hh,'position',[.11 .38 .3 .02],'backgroundcolor',[  0.8392    0.9098    0.8510]);


hh=findobj(gcf,'tag','files');
pos=get(hh,'position');
set(hh,'position',[ 0.5100    0.315    0.4700    0.53]);

%% chnge arangement uf UIcontrols
p=uicontrol('style','edit','max',10,'units','normalized',...
    'position',[0.001 .69 .5 .09 ],'style','edit','backgroundcolor',[.8 .8 .8],'foregroundcolor',[0 .6 0],...
    'string',cellstr(mesg),'fontsize',14,'fontweight','bold','tag','pmsgbox','horizontalalignment','left'    );


set(p,'position',[.001 .59 .5 .19])
hdirs=findobj(gcf,'tag','dirs');  set(hdirs,'position',[0.0200    0.37    0.4700    0.2216]);
hhelp=findobj(gcf,'string','?');   set(hhelp,'position',[  0.0100    0.325    0.0316    0.0394],'visible','off');


hed=findobj(gcf,'string','Ed');    set(hed,'position',[  0.00    0.325    0.0316    0.0394]);


hrec=findobj(gcf,'string','Rec'); set(hrec,'position',[  0.1434    0.325    0.0316    0.0394]);
hre=findobj(gcf,'string','Filt');    set(hre,'position',  [  0.175     0.325   0.05    0.0394]);
hre=findobj(gcf,'tag','regexp'); set(hre,'position', [ 0.22 0.31    0.2    0.033]);
hre=findobj(gcf,'string','Done'); set(hre,'position',[   0.42      0.325    0.1    0.0394],'backgroundcolor',[0 .6 0]);

hmsg=findobj(gcf,'tag','msg');   set(hmsg,'position',[0 .25 1 .075])


%% get rec. all filenames-Button
p=uicontrol('style','pushbutton','units','normalized',...
    'position',[.088 .325 .056 .0394 ],'backgroundcolor',[1 1 1],'foregroundcolor',[0 .6 0],...
    'string', 'RecList'  ,'fontsize',12,'fontweight','bold','tag','pmsgbox','horizontalalignment','left', ...
    'tooltip',...
    [   'list all unique files from subfolders (not current folder) matching the filter characteristics' char(10) ...
        'You can select the desired file(s) from this list.' char(10) ...
    '   The OUTPUT can be used as fileFilter again: After selection of files from the list' char(10) ...
    '   click [Rec]-Button to apply this narrowed filter and recursively find all files' char(10) ...
    '   ' char(10) ...
    '..IMPORTANT, the FILELIST works only for subfolders and not the current path'],...
    'callback' ,@p_findrecfiles);

set(gcf,'units',units);
set(findobj(gcf,'style','pushbutton'),'fontsize',8);
set(findobj(gcf,'tag','pmsgbox'),'fontsize',8);

ContextMenu=uicontextmenu;
uimenu('Parent',ContextMenu, 'Label','show help in external figure', 'callback', {@cmenuInfo,'showInfo',cellstr(mesg) } ,'ForegroundColor',[0 .5 0]);
set(findobj(gcf,'tag','pmsgbox'),'UIContextMenu',ContextMenu);

% --------
hp=uicontrol('style','radio','units','normalized',...
    'position',[0.001 .69 .5 .09 ],'backgroundcolor',[ 0.9400    0.9400    0.9400],'foregroundcolor',[0 .6 0],...
    'string','4D only','fontsize',7,'fontweight','bold','tag','show4Donly','horizontalalignment','left'    );
set(hp,'position',[0.9262 0.28864 0.07 0.025],'tooltipstring','show 4D NIFTI files only');
set(hp,'callback',@update);

% pulldown-memory
persistent lastfiltertoken


if isempty(lastfiltertoken)
    regexplist={'.' '.*.nii' '.*xlsx|.*nii' '^startStr.*endStr$' '\.(doc|txt)$'   '^((?!notStr).)*$'};
    lastfiltertoken =[lastfiltertoken; regexplist];
end



p=uicontrol('style','popupmenu','units','normalized',...
    'position',[.0934 .325 .05 .0394 ],'backgroundcolor',[1 1 1],'foregroundcolor',[0 .6 0],...
    'string', lastfiltertoken ,'fontsize',12,'fontweight','bold','tag','regexphistory','horizontalalignment','left', 'tooltip',...
    ['regexp history ' char(10) 'select a filter string to send it to the filter edit field' char(10) ...
    'modify this string in the edit field and hit enter to evaluate this fiter'  char(10) ...
    'handle: regexphistory'],...
    'callback' ,@p_regexpHistory);
set(p,'position',[0.22 0.346 0.16 0.025],'fontsize',8);
p_regexpHistoryListUpdate

% regexp-help
if 1
p=uicontrol('style','pushbutton','units','normalized',...
    'backgroundcolor',[1 1 1],'foregroundcolor',[0 .6 0],...
    'string', 'RE Help' ,'fontsize',8,'fontweight','bold','tag','regexphelp','horizontalalignment','left', 'tooltip',...
    ['regexp Help ' char(10) 'handle: regexphelp'],...
    'callback' ,@p_regexphelp);
set(p,'position',[0.38 0.346 0.042 0.025],'fontsize',7);
end

% % button : use history-selection
% p=uicontrol('style','pushbuttom','units','normalized',...
%     'position',[.0934 .325 .05 .0394 ],'backgroundcolor',[1 1 1],'foregroundcolor',[0 .6 0],...
%     'string', ''}  ,'fontsize',12,'fontweight','bold','tag','regexphistory','horizontalalignment','left', 'tooltip',...
%     ['regexp history ' char(10) 'handle: regexphistory'],...
%     'callback' ,@p_regexpHistory);
% set(p,'position',[0.22 0.346 0.16 0.025],'fontsize',8);

%===============paul end======

% set(fg,'windowstyle', 'modal');

waitfor(dne);
drawnow;
if ishandle(sel),
    t  = get(sel,'String');
    if isempty(t)
        t = {''};
    elseif sfilt.code == -1
        % canonicalise non-empty folder selection
        %t = cellfun(@(t1)cpath(t1, pwd), t, 'UniformOutput',false);
        t=get(sel,'String');
        t=cellfun(@(a){[ regexprep(a,{['\\$'],['/$']},{''} )]} ,t);%{'d:\MATLAB\' ;'d:/MATLAB/' }
    end;
    ok = 1;
end;
if ishandle(fg),  delete(fg); end;
drawnow;
return;
%=======================================================================
end

function p_regexphelp(e,e2)


w=fileread(which(mfilename));
w=strsplit(w,char(10))';
ix=[
max(find(cellfun(@(x) any(x),strfind(w,'% #ankerstart: regexphelp')))+2) 
max(find(cellfun(@(x) any(x),strfind(w,'% #ankerend')))-1 )
];
w2=w(ix(1):ix(2));
w2=regexprep(w2,'^%','');
 
uhelp(w2);
end

function p_regexpHistory(e,e2)
e=findobj(gcf,'tag','regexphistory');
hedregexp=findobj(gcf,'tag','regexp');
li=get(e,'string');
va=get(e,'value');
p_regexpHistoryListUpdate;
% oldinreg=get(hedregexp,'string');
% if any(cellfun(@(x)  any(x), regexpi(li,oldinreg) ))==0
%     newlist=[li; oldinreg ];
%     set(e,'string',newlist);
% end
set(hedregexp,'string',li{va});
end

function p_regexpHistoryListUpdate

persistent lastfiltertoken;



e=findobj(gcf,'tag','regexphistory');
hedregexp=findobj(gcf,'tag','regexp');
li=get(e,'string');
oldinreg=get(hedregexp,'string');
if isempty(find(strcmp(li,oldinreg)))
    newlist=[li; oldinreg ];
    
    lastfiltertoken=[lastfiltertoken; newlist];
    lastfiltertoken=unique(lastfiltertoken);
%     if isempty(lastfiltertoken)
%         lastfiltertoken =1
%     end
    
    set(e,'string',lastfiltertoken);
end
end



function cmenuInfo(he,ho,task,arg)

if strcmp(task,'showInfo')
    uhelp(arg);
    set(findobj(gcf,'styl','listbox'),'fontsize',8);
end
end
%=======================================================================
function apos = posinpanel(rpos,ppos)
% Compute absolute positions based on panel position and relative
% position
apos = [ppos(1:2)+ppos(3:4).*rpos(1:2) ppos(3:4).*rpos(3:4)];
end
%=======================================================================

%=======================================================================
function [pselp, pcntp, pfdp, pdirp] = panelpositions(fg, sellines)
if nargin == 1
    na = numel(get(findobj(fg,'Tag','selected'),'String'));
    n  = get(findobj(fg,'Tag','files'),'Userdata');
    sellines = min([max([n(2) na]), 4]);
end
lf = cfg_get_defaults('cfg_ui.lfont');
bf = cfg_get_defaults('cfg_ui.bfont');
% Create dummy text to estimate character height
t=uicontrol('style','text','string','Xg','units','normalized','visible','off',c2struct(lf));
lfh = 1.05*get(t,'extent');
delete(t)
t=uicontrol('style','text','string','Xg','units','normalized','visible','off',c2struct(bf));
bfh = 1.05*get(t,'extent');
delete(t)
% panel heights
% 3 lines for directory, parent and prev directory list
% variable height for dir/file navigation
% 2 lines for buttons, filter etc
% sellines plus scrollbar for selected files
pselh = sellines*lfh(4) + 1.2*lfh(4);
pselp = [0 0 1 pselh];
pcnth = 2*bfh(4);
pcntp = [0 pselh 1 pcnth];
pdirh = 3*lfh(4);
pdirp = [0 1-pdirh 1 pdirh];
pfdh  = 1-(pselh+pcnth+pdirh);
pfdp  = [0 pselh+pcnth 1 pfdh];
end
%=======================================================================

function out=c2struct(in)
if ~isstruct(in)
    out=cell2struct(in(2:2:end),in(1:2:end),2);
end
end
%=======================================================================
function null(varargin)
end
%=======================================================================

%=======================================================================
function omsg = msg(ob,str)
ob = sib(ob,'msg');
omsg = get(ob,'String');
set(ob,'String',str);
if nargin>=3,
    set(ob,'ForegroundColor',[1 0 0],'FontWeight','bold');
else
    set(ob,'ForegroundColor',[0 0 0],'FontWeight','normal');
end;
drawnow;
return;
end
%=======================================================================

%=======================================================================
function setdrive(ob,varargin)
st = get(ob,'String');
vl = get(ob,'Value');
update(ob,st{vl});
return;
end
%=======================================================================

%=======================================================================
function resize_fun(fg,varargin)
% do nothing
return;
[pselp pcntp pfdp pdirp] = panelpositions(fg);
set(findobj(fg,'Tag','msg'), 'Position',pselp);
set(findobj(fg,'Tag','pcnt'), 'Position',pcntp);
set(findobj(fg,'Tag','pfd'), 'Position',pfdp);
set(findobj(fg,'Tag','pdir'), 'Position',pdirp);
return;
end
%=======================================================================

%=======================================================================
function [d,mch] = prevdirs(d)
persistent pd
if ~iscell(pd), pd = {}; end;
if nargin == 0
    d = pd;
else
    if ~iscell(d)
        d = cellstr(d);
    end
    d   = unique(d(:));
    mch = cellfun(@(d1)find(strcmp(d1,pd)), d, 'UniformOutput',false);
    sel = cellfun(@isempty, mch);
    npd = numel(pd);
    pd  = [pd(:);d(sel)];
    mch = [mch{~sel} npd+(1:nnz(sel))];
    d = pd;
end
return;
end
%=======================================================================

%=======================================================================
function pd = pardirs(wd)
if ispc
    fs = '\\';
else
    fs = filesep;
end
pd1 = textscan(wd,'%s','delimiter',fs,'MultipleDelimsAsOne',1);
if ispc
    pd = cell(size(pd1{1}));
    pd{end} = pd1{1}{1};
    for k = 2:numel(pd1{1})
        pd{end-k+1} = fullfile(pd1{1}{1:k},filesep);
    end
else
    pd = cell(numel(pd1{1})+1,1);
    pd{end} = filesep;
    for k = 1:numel(pd1{1})
        pd{end-k} = fullfile(filesep,pd1{1}{1:k},filesep);
    end
end
end
%=======================================================================

%=======================================================================
function clearfilt(ob,varargin)
set(sib(ob,'regexp'),'String','.*');
update(ob);
return;
end
%=======================================================================

%=======================================================================
function click_dir_list(ob,varargin)
vl = get(ob,'Value');
ls = get(ob,'String');
update(ob,deblank(ls{vl}));
return;
end
%=======================================================================

%=======================================================================
function edit_dir(ob,varargin)
update(ob,get(ob,'String'));
return;
end
%=======================================================================

%=======================================================================
function c = get_current_char(lb)
fg = sib(lb, mfilename);
c = get(fg, 'CurrentCharacter');
if ~isempty(c)
    % reset CurrentCharacter
    set(fg, 'CurrentCharacter', char(13));
end
end
%=======================================================================

%=======================================================================
function click_dir_box(lb,varargin)
c = get_current_char(lb);
if isempty(c) || isequal(c,char(13))
    vl  = get(lb,'Value');
    str = get(lb,'String');
    pd  = get(sib(lb,'edit'),'String');
    while ~isempty(pd) && strcmp(pd(end),filesep)
        pd=pd(1:end-1);      % Remove any trailing fileseps
    end
    sel = str{vl};
    if strcmp(sel,'..'),     % Parent directory
        [dr odr] = fileparts(pd);
    elseif strcmp(sel,'.'),  % Current directory
        dr = pd;
        odr = '';
    else
        dr = fullfile(pd,sel);
        odr = '';
    end;
    update(lb,dr);
    if ~isempty(odr)
        % If moving up one level, try to set focus on previously visited
        % directory
        cdrs = get(lb, 'String');
        dind = find(strcmp(odr, cdrs));
        if ~isempty(dind)
            set(lb, 'Value',dind(1));
        end
    end
end
return;
end
%=======================================================================

%=======================================================================
function re = getfilt(ob)
ob  = sib(ob,'regexp');
ud  = get(ob,'UserData');
re  = struct('code',ud.code,...
    'frames',get(sib(ob,'frame'),'UserData'),...
    'ext',{ud.ext},...
    'filt',{{get(sib(ob,'regexp'),'String')}});
return;
end
%=======================================================================

%=======================================================================
function update(lb,dr)



lb = sib(lb,'dirs');
if nargin<2 || isempty(dr) || ~ischar(dr)
    dr = get(lb,'UserData');
end;
if ~(strcmpi(computer,'PCWIN') || strcmpi(computer,'PCWIN64'))
    dr    = [filesep dr filesep];
else
    if strcmp(dr(end),filesep)==0
    dr    = [dr filesep];
    end
end;
% dr(strfind(dr,[filesep filesep])) = [];
[f,d] = listfiles(dr,getfilt(lb));

%% ===============================================

% --------4D only
if get(findobj(gcf,'tag','show4Donly'),'value')==1
    %clc;
    is4d=[];
    for i=1:size(f,1)
        try
            fi=fullfile(dr,f{i});
            fi=regexprep(fi,'.nii,1','.nii');
            hv=spm_vol(fi);
            if length(hv)>1
                is4d=[is4d i];
            end
        end
        %disp(length(hv))
    end
    if ~isempty(is4d)
       f=f(is4d); 
    end
    
end
%% ===============================================

% -------
if isempty(d),
    dr    = get(lb,'UserData');
    [f,d] = listfiles(dr,getfilt(lb));
else
    set(lb,'UserData',dr);
end;
set(lb,'Value',1,'String',d);
set(sib(lb,'files'),'Value',1,'String',f);
set(sib(lb,'pardirs'),'String',pardirs(dr),'Value',1);
[ls,mch] = prevdirs(dr);
set(sib(lb,'previous'),'String',ls,'Value',mch);
set(sib(lb,'edit'),'String',dr);

if numel(dr)>1 && dr(2)==':',
    str = char(get(sib(lb,'drive'),'String'));
    mch = find(lower(str(:,1))==lower(dr(1)));
    if ~isempty(mch),
        set(sib(lb,'drive'),'Value',mch);
    end;
end;

  try
   p_regexpHistoryListUpdate; 
  end

return;
end
%=======================================================================

%=======================================================================
function update_frames(lb,varargin)
str = get(lb,'String');
%r   = get(lb,'UserData');
try
    r = eval(['[',str,']']);
catch
    msg(lb,['Failed to evaluate "' str '".'],'r');
    beep;
    return;
end;
if ~isnumeric(r),
    msg(lb,['Expression non-numeric "' str '".'],'r');
    beep;
else
    set(lb,'UserData',r);
    msg(lb,'');
    update(lb);
end;
end
%=======================================================================

%=======================================================================
function select_all(ob,varargin)
lb = sib(ob,'files');
set(lb,'Value',1:numel(get(lb,'String')));
drawnow;
click_file_box(lb);
return;
end
%=======================================================================

%=======================================================================
function click_file_box(lb,varargin)
c = get_current_char(lb);
if isempty(c) || isequal(c, char(13))
    vlo  = get(lb,'Value');
    if isempty(vlo),
        msg(lb,'Nothing selected');
        return;
    end;
    lim  = get(lb,'UserData');
    ob   = sib(lb,'selected');
    str3 = get(ob,'String');
    str  = get(lb,'String');
    lim1  = min([max([lim(2)-numel(str3),0]),numel(vlo)]);
    if lim1==0,
        msg(lb,['Selected ' num2str(size(str3,1)) '/' num2str(lim(2)) ' already.']);
        beep;
        set(sib(lb,'D'),'Enable','on');
        return;
    end;
    
    vl   = vlo(1:lim1);
    msk  = false(size(str,1),1);
    if vl>0, msk(vl) = true; else msk = []; end;
    str1 = str( msk);
    str2 = str(~msk);
    dr   = get(sib(lb,'edit'), 'String');
    str1 = strcat(dr, str1);
    
    set(lb,'Value',min([vl(1),numel(str2)]),'String',str2);
    r    = (1:numel(str1))+numel(str3);
    str3 = [str3(:);str1(:)];
    set(ob,'String',str3,'Value',r);
    if numel(vlo)>lim1,
        msg(lb,['Retained ' num2str(lim1) '/' num2str(numel(vlo))...
            ' of selection.']);
        beep;
    elseif isfinite(lim(2))
        if lim(1)==lim(2),
            msg(lb,['Selected ' num2str(numel(str3)) '/' num2str(lim(2)) ' files.']);
        else
            msg(lb,['Selected ' num2str(numel(str3)) '/' num2str(lim(1)) '-' num2str(lim(2)) ' files.']);
        end;
    else
        if size(str3,1) == 1, ss = ''; else ss = 's'; end;
        msg(lb,['Selected ' num2str(numel(str3)) ' file' ss '.']);
    end;
    if ~isfinite(lim(1)) || numel(str3)>=lim(1),
        set(sib(lb,'D'),'Enable','on');
    end;
end
return;
end
%=======================================================================

%=======================================================================
function obj = sib(ob,tag)
persistent fg;
if isempty(fg) || ~ishandle(fg)
    fg = findobj(0,'Tag',mfilename);
end
obj = findobj(fg,'Tag',tag);
return;
%if isempty(obj),
%    cfg_message('matlabbatch:usage',['Can''t find object with tag "' tag '".']);
%elseif length(obj)>1,
%    cfg_message('matlabbatch:usage',['Found ' num2str(length(obj)) ' objects with tag "' tag '".']);
%end;
%return;
end
%=======================================================================

%=======================================================================
function unselect(lb,varargin)
vl      = get(lb,'Value');
if isempty(vl), return; end;
str     = get(lb,'String');
msk     = true(numel(str),1);
if vl~=0, msk(vl) = false; end;
str2    = str(msk);
set(lb,'Value',min(vl(1),numel(str2)),'String',str2);
lim = get(sib(lb,'files'),'UserData');
if numel(str2)>= lim(1) && numel(str2)<= lim(2),
    set(sib(lb,'D'),'Enable','on');
else
    set(sib(lb,'D'),'Enable','off');
end;

if numel(str2) == 1, ss1 = ''; else ss1 = 's'; end;
%msg(lb,[num2str(size(str2,1)) ' file' ss ' remaining.']);
if numel(vl) == 1, ss = ''; else ss = 's'; end;
msg(lb,['Unselected ' num2str(numel(vl)) ' file' ss '. ' ...
    num2str(numel(str2)) ' file' ss1 ' remaining.']);
return;
end
%=======================================================================

%=======================================================================
function unselect_all(ob,varargin)
lb = sib(ob,'selected');
set(lb,'Value',[],'String',{},'ListBoxTop',1);
msg(lb,'Unselected all files.');
lim = get(sib(lb,'files'),'UserData');
if lim(1)>0, set(sib(lb,'D'),'Enable','off'); end;
return;
end
%=======================================================================

%=======================================================================
function [f,d] = listfiles(dr,filt)
try
    ob = sib(gco,'msg');
    domsg = ~isempty(ob);
catch
    domsg = false;
end
if domsg
    omsg = msg(ob,'Listing directory...');
end
if nargin<2, filt = '';  end;
if nargin<1, dr   = '.'; end;
de      = dir(dr);
if ~isempty(de),
    d     = {de([de.isdir]).name};
    if ~any(strcmp(d, '.'))
        d = [{'.'}, d(:)'];
    end;
    if filt.code~=-1,
        f = {de(~[de.isdir]).name};
    else
        % f = d(3:end);
        f = d;
    end;
else
    d = {'.','..'};
    f = {};
end;

if domsg
    msg(ob,['Filtering ' num2str(numel(f)) ' files...']);
end
f  = do_filter(f,filt.ext);
f  = do_filter(f,filt.filt);
ii = cell(1,numel(f));
if filt.code==1 && (numel(filt.frames)~=1 || filt.frames(1)~=1),
    if domsg
        msg(ob,['Reading headers of ' num2str(numel(f)) ' images...']);
    end
    for i=1:numel(f),
        try
            ni = nifti(fullfile(dr,f{i}));
            dm = [ni.dat.dim 1 1 1 1 1];
            d4 = (1:dm(4))';
        catch
            d4 = 1;
        end;
        if all(isfinite(filt.frames))
            msk = false(size(filt.frames));
            for j=1:numel(msk), msk(j) = any(d4==filt.frames(j)); end;
            ii{i} = filt.frames(msk);
        else
            ii{i} = d4;
        end;
    end
elseif filt.code==1 && (numel(filt.frames)==1 && filt.frames(1)==1),
    for i=1:numel(f),
        ii{i} = 1;
    end;
end;

if domsg
    msg(ob,['Listing ' num2str(numel(f)) ' files...']);
end

[f,ind] = sortrows(f(:));
ii      = ii(ind);
msk     = true(1,numel(f));
for i=2:numel(f),
    if strcmp(f{i-1},f{i}),
        if filt.code==1,
            tmp      = sort([ii{i}(:) ; ii{i-1}(:)]);
            tmp(~diff(tmp,1)) = [];
            ii{i}    = tmp;
        end;
        msk(i-1) = false;
    end;
end;
f        = f(msk);
if filt.code==1,
    % Combine filename and frame number(s)
    ii       = ii(msk);
    nii      = cellfun(@numel, ii);
    c        = cell(sum(nii),1);
    fi       = cell(numel(f),1);
    for k = 1:numel(fi)
        fi{k} = k*ones(1,nii(k));
    end
    ii = [ii{:}];
    fi = [fi{:}];
    for i=1:numel(c),
        c{i} = sprintf('%s,%d', f{fi(i)}, ii(i));
    end;
    f        = c;
elseif filt.code==-1,
    fs = filesep;
    for i=1:numel(f),
        f{i} = [f{i} fs];
    end;
end;
f        = f(:);
d        = unique(d(:));
if domsg
    msg(ob,omsg);
end
return;
end
%=======================================================================

%=======================================================================
function [f,ind] = do_filter(f,filt)
t2 = false(numel(f),1);
filt_or = sprintf('(%s)|',filt{:});
% t1 = regexp(f,filt_or(1:end-1)); 
  t1 = regexp(f,filt_or(1:end-1)); 
% t1 =regexp(f, filt_or(1:end-1), 'lineanchors', 'once')
% mask = ~cellfun(@isempty, regexp(r, '^[p]', 'lineanchors', 'once'))
%  [class(t1) ' ' num2str(size(t1))]
%  'hihere'
 
 
 
if numel(f)==1 && ~iscell(t1), t1 = {t1}; end;
for i=1:numel(t1),
    t2(i) = ~isempty(t1{i});
end;
ind = find(t2);
f   = f(t2);
return;
end
%=======================================================================

%=======================================================================
function heelp(ob,varargin)
[col1,col2,col3,fn] = colours;
fg = sib(ob,mfilename);
t  = uicontrol(fg,...
    'style','listbox',...
    'units','normalized',...
    'Position',[0.01 0.01 0.98 0.98],...
    fn,...
    'BackgroundColor',col2,...
    'ForegroundColor',col3,...
    'Max',0,...
    'Min',0,...
    'tag','HelpWin',...
    'String','                   ');
c0 = uicontextmenu('Parent',fg);
set(t,'uicontextmenu',c0);
uimenu('Label','Done', 'Parent',c0,'Callback',@helpclear);

str  = cfg_justify(t, {[...
    'File Selection help. You can return to selecting files via the right mouse button (the "Done" option). '],...
    '',[...
    'The panel at the bottom shows files that are already selected. ',...
    'Clicking a selected file will un-select it. To un-select several, you can ',...
    'drag the cursor over the files, and they will be gone on release. ',...
    'You can use the right mouse button to un-select everything.'],...
    '',[...
    'Directories are navigated by editing the name of the current directory (where it says "Dir"), ',...
    'by going to one of the previously entered directories ("Prev"), ',...
    'by going to one of the parent directories ("Up") or by navigating around ',...
    'the parent or subdirectories listed in the left side panel.'],...
    '',[...
    'Files matching the filter ("Filt") are shown in the panel on the right. ',...
    'These can be selected by clicking or dragging.  Use the right mouse button if ',...
    'you would like to select all files.  Note that when selected, the files disappear ',...
    'from this panel.  They can be made to reappear by re-specifying the directory ',...
    'or the filter. '],...
    '',[...
    'Both directory and file lists can also be browsed by typing the leading ',...
    'character(s) of a directory or file name.'],...
    '',[...
    'Note that the syntax of the filter differs from that used by most other file selectors. ',...
    'The filter works using so called ''regular expressions''. Details can be found in the ',...
    'MATLAB help text on ''regexp''. ',...
    'The following is a list of symbols with special meaning for filtering the filenames:'],...
    '    ^     start of string',...
    '    $     end of string',...
    '    .     any character',...
    '    \     quote next character',...
    '    *     match zero or more',...
    '    +     match one or more',...
    '    ?     match zero or one, or match minimally',...
    '    {}    match a range of occurrances',...
    '    []    set of characters',...
    '    [^]   exclude a set of characters',...
    '    ()    group subexpression',...
    '    \w    match word [a-z_A-Z0-9]',...
    '    \W    not a word [^a-z_A-Z0-9]',...
    '    \d    match digit [0-9]',...
    '    \D    not a digit [^0-9]',...
    '    \s    match white space [ \t\r\n\f]',...
    '    \S    not a white space [^ \t\r\n\f]',...
    '    \<WORD\>    exact word match',...
    '',[...
    'Individual time frames of image files can also be selected.  The frame filter ',...
    'allows specified frames to be shown, which is useful for image files that ',...
    'contain multiple time points.  If your images are only single time point, then ',...
    'reading all the image headers can be avoided by specifying a frame filter of "1". ',...
    'The filter should contain a list of integers indicating the frames to be used. ',...
    'This can be generated by e.g. "1:100", or "1:2:100".'],...
    '',[...
    'The recursive selection button (Rec) allows files matching the regular expression to ',...
    'be recursively selected.  If there are many directories to search, then this can take ',...
    'a while to run.'],...
    '',[...
    'There is also an edit button (Ed), which allows you to edit your selection of files. ',...
    'When you are done, then use the menu-button of your mouse to either cancel or accept your changes.'],''});
set(t,'String',str);
return;
end
%=======================================================================

%=======================================================================
function helpclear(ob,varargin)
ob = get(ob,'Parent');
ob = get(ob,'Parent');
ob = findobj(ob,'Tag','HelpWin');
delete(ob);
end
%=======================================================================

%=======================================================================
function t = cpath(t,d)
switch filesep,
    case '/',
        mch = '^/';
        fs  = '/';
        fs1 = '/';
    case '\',
        mch = '^.:\\';
        fs  = '\';
        fs1 = '\\';
    otherwise;
        cfg_message('matlabbatch:usage','What is this filesystem?');
end

if isempty(regexp(t,mch,'once')),
    if (nargin<2)||isempty(d), d = pwd; end;
    t = [d fs t];
end;

% Replace occurences of '/./' by '/' (problems with e.g. /././././././')
re = [fs1 '\.' fs1];
while ~isempty(regexp(t,re, 'once' )),
    t  = regexprep(t,re,fs);
end;
t  = regexprep(t,[fs1 '\.' '$'], fs);

% Replace occurences of '/abc/../' by '/'
re = [fs1 '[^' fs1 ']+' fs1 '\.\.' fs1];
while ~isempty(regexp(t,re, 'once' )),
    t  = regexprep(t,re,fs,'once');
end;
t  = regexprep(t,[fs1 '[^' fs1 ']+' fs1 '\.\.' '$'],fs,'once');

% Replace '//'
t  = regexprep(t,[fs1 '+'], fs);
end
%=======================================================================

%=======================================================================
function editwin(ob,varargin)
[col1,col2,col3,lf,bf] = colours;
fg   = gcbf;
lb   = sib(ob,'selected');
str  = get(lb,'String');
ac   = allchild(fg);
acv  = get(ac,'Visible');
h    = uicontrol(fg,...
    'Style','Edit',...
    'units','normalized',...
    'String',str,...
    lf,...
    'Max',2,...
    'Tag','EditWindow',...
    'HorizontalAlignment','Left',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'Position',[0.01 0.08 0.98 0.9],...
    'Userdata',struct('ac',{ac},'acv',{acv}));
ea   = uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[.01 .01,.32,.07],...
    bf,...
    'Callback',@editdone,...
    'tag','EditWindowAccept',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Accept');
ee   = uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[.34 .01,.32,.07],...
    bf,...
    'Callback',@editeval,...
    'tag','EditWindowEval',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Eval');
ec   = uicontrol(fg,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[.67 .01,.32,.07],...
    bf,...
    'Callback',@editclear,...
    'tag','EditWindowCancel',...
    'ForegroundColor',col3,...
    'BackgroundColor',col1,...
    'String','Cancel');
set(ac,'visible','off');
end
%=======================================================================



%=======================================================================
function editeval(ob,varargin)
ob  = get(ob, 'Parent');
ob  = sib(ob, 'EditWindow');
str = get(ob, 'String');
if ~isempty(str)
    [out,sts] = cfg_eval_valedit(char(str));
    if sts && (iscellstr(out) || ischar(out))
        set(ob, 'String', cellstr(out));
    else
        fgc = get(ob, 'ForegroundColor');
        set(ob, 'ForegroundColor', 'red');
        pause(1);
        set(ob, 'ForegroundColor', fgc);
    end
end
end
%=======================================================================

%=======================================================================
function editdone(ob,varargin)
ob  = get(ob,'Parent');
ob  = sib(ob,'EditWindow');
str = cellstr(get(ob,'String'));
if isempty(str) || isempty(str{1})
    str = {};
else
    dstr = deblank(str);
    if ~isequal(str, dstr)
        c = questdlg(['Some of the filenames contain trailing blanks. This may ' ...
            'be due to copy/paste of strings between MATLAB and the ' ...
            'edit window. Do you want to remove any trailing blanks?'], ...
            'Trailing Blanks in Filenames', ...
            'Remove', 'Keep', 'Remove');
        switch lower(c)
            case 'remove'
                str = dstr;
        end
    end
    filt = getfilt(ob);
    if filt.code >= 0 % filter files, but not dirs
        [p,n,e] = cellfun(@fileparts, str, 'uniformoutput',false);
        fstr = strcat(n, e);
        [fstr1,fsel] = do_filter(fstr, filt.ext);
        str = str(fsel);
    end
end
lim = get(sib(ob,'files'),'UserData');
if numel(str)>lim(2),
    msg(ob,['Retained ' num2str(lim(2)) ' of the ' num2str(numel(str)) ' files.']);
    beep;
    str = str(1:lim(2));
elseif isfinite(lim(2)),
    if lim(1)==lim(2),
        msg(ob,['Selected ' num2str(numel(str)) '/' num2str(lim(2)) ' files.']);
    else
        msg(ob,['Selected ' num2str(numel(str)) '/' num2str(lim(1)) '-' num2str(lim(2)) ' files.']);
    end;
else
    if numel(str) == 1, ss = ''; else ss = 's'; end;
    msg(ob,['Specified ' num2str(numel(str)) ' file' ss '.']);
end;
if ~isfinite(lim(1)) || numel(str)>=lim(1),
    set(sib(ob,'D'),'Enable','on');
else
    set(sib(ob,'D'),'Enable','off');
end;
set(sib(ob,'selected'),'String',str,'Value',[]);
acs = get(ob,'Userdata');
fg = gcbf;
delete(findobj(fg,'-regexp','Tag','^EditWindow.*'));
set(acs.ac,{'Visible'},acs.acv);
end
%=======================================================================

%=======================================================================
function editclear(ob,varargin)
fg = gcbf;
acs = get(findobj(fg,'Tag','EditWindow'),'Userdata');
delete(findobj(fg,'-regexp','Tag','^EditWindow.*'));
set(acs.ac,{'Visible'},acs.acv);
end
%=======================================================================

%=======================================================================
function [c1,c2,c3,lf,bf] = colours
c1 = [1 1 1];
c2 = [1 1 1];
c3 = [0 0 0];
lf = cfg_get_defaults('cfg_ui.lfont');
bf = cfg_get_defaults('cfg_ui.bfont');
if isempty(lf)
    lf = struct('FontName',get(0,'FixedWidthFontName'), ...
        'FontWeight','normal', ...
        'FontAngle','normal', ...
        'FontSize',14, ...
        'FontUnits','points');
end
if isempty(bf)
    bf = struct('FontName',get(0,'FixedWidthFontName'), ...
        'FontWeight','normal', ...
        'FontAngle','normal', ...
        'FontSize',14, ...
        'FontUnits','points');
end

lf=c2struct(lf);
bf=c2struct(bf);
end


%=======================================================================
%% paul HAck
function p_findrecfiles(do,varg)

ob=findobj(gcf,'tag','Rec');
start = get(sib(ob,'edit'),'String');
filt  = get(sib(ob,'regexp'),'Userdata');
filt.filt = {get(sib(ob,'regexp'), 'String')};
fob = sib(ob,'frame');
if ~isempty(fob)
    filt.frames = get(fob,'Userdata');
else
    filt.frames = [];
end;
% flt=struct('code' ,0, 'frames', [], 'ext', {'.*'},    'filt', '{''img|nii''}'  )



if 1
    global glob_guiselect
    if 1%~isempty(glob_guiselect)
        if isfield(glob_guiselect, 'recpaths')
            selx={};
            for i=1:length(glob_guiselect.recpaths)
                selx=[  selx   ; select_rec1(  glob_guiselect.recpaths{i}            , filt)    ];
            end
            
            
        else
            hdirlb=findobj(gcf,'tag','dirs');
            alldirs=get(hdirlb,'string');
            alldirs(1:2)=[];%remove ./..
            pa=get(hdirlb,'userdata');
            recpaths=cellfun(@(fi) {[pa   fi]}, alldirs(:));
            selx={};
            for i=1:length(recpaths)
                selx=[  selx   ; select_rec1(  recpaths{i}            , filt)    ];
            end
            
        end
        % filetags=regexprep(selx,'.*\','')
        
        filetags=repmat({''},length(selx),1);
        for i=1:length(selx)
            [pa fi ext]=fileparts(selx{i});
            [pa2 fi2]=fileparts(pa);
            fi2=regexprep([fi ext],  [fi2 '|' fi2(2:end)],'' );
            filetags{i}=fi2;
        end
        files=sort((filetags));
        %files= ((filetags));
        
        [files2,junk,ind] = unique(files);
        freqs = histc(ind,1:numel(files2));
        freqs=cellstr(num2str(freqs));
        
        try
        files3=cellfun(@(x, y) [ '('  y  ')   '   x                        ],files2,freqs,'un',0);
        
        catch
           return 
        end
        
        files4=files3;
%         [is ix]=sort(freqs); %sort accor frequency
%         files4=flipud(files3(ix));
        
        
        %            ids=selector2(files4);
        ids=selector3(files4,{'files'});
        ids2=regexprep(files4([ids]),'(\s*\d*\)\s*',''); %remove filecounting, i.e. "( 34 ) "
        hflt=  findobj(gcf,'tag','regexp');
        
        if isempty(ids2); 
            set(findobj(gcf,'tag','msg'),'string','..cancelled');
            return; 
        end
        filters=cell2str(ids2,'|^') ;
        filters=['^' filters];
        set(hflt,  'string',  filters );
        %            uhelp(flipud(files3(ix)))  ;
        %uhelp(files3) ;
        
    end
    
end
end





%=======================================================================
function select_rec(ob, varargin)
start = get(sib(ob,'edit'),'String');
filt  = get(sib(ob,'regexp'),'Userdata');
filt.filt = {get(sib(ob,'regexp'), 'String')};
fob = sib(ob,'frame');
if ~isempty(fob)
    filt.frames = get(fob,'Userdata');
else
    filt.frames = [];
end;
ptr    = get(gcbf,'Pointer');
try
    %% PAUL hack
    try
        global glob_guiselect
        if ~isempty(glob_guiselect)
            if isfield(glob_guiselect, 'recpaths')
                selx={};
                for i=1:length(glob_guiselect.recpaths)
                    selx=[  selx   ; select_rec1(  glob_guiselect.recpaths{i}            ,filt)    ];
                end
                sel=selx;
            end
            set(gcbf,'Pointer','watch');
        else
            sel    = select_rec1(start,filt);
            
        end
        
    catch
        
        
        sel    = select_rec1(start,filt);
    end
catch
    set(gcbf,'Pointer',ptr);
    sel = {};
end;
set(gcbf,'Pointer',ptr);
already= get(sib(ob,'selected'),'String');
fb     = sib(ob,'files');
lim    = get(fb,'Userdata');
limsel = min(lim(2)-size(already,1),size(sel,1));
set(sib(ob,'selected'),'String',[already(:);sel(1:limsel)],'Value',[]);
msg(ob,sprintf('Added %d/%d matching files to selection.', limsel, size(sel,1)));
if ~isfinite(lim(1)) || size(sel,1)>=lim(1),
    set(sib(ob,'D'),'Enable','on');
else
    set(sib(ob,'D'),'Enable','off');
end;
end
%=======================================================================

%=======================================================================
function sel=select_rec1(cdir,filt)
sel={};
[t,d] = listfiles(cdir,filt);
if ~isempty(t)
    sel = strcat([cdir,filesep],t);
end;
for k = 1:numel(d)
    if ~any(strcmp(d{k},{'.','..'}))
        sel1 = select_rec1(fullfile(cdir,d{k}),filt);
        sel  = [sel(:); sel1(:)];
    end;
end;
end
%=======================================================================

%=======================================================================
function sfilt=mk_filter(typ,filt,frames)
if nargin<3, frames  = 1;     end;
if nargin<2, filt    = '.*';    end;
if nargin<1, typ     = 'any';   end;
switch lower(typ),
    case {'any','*'}, code = 0; ext = {'.*'};
    case {'image'},   code = 1; ext = {'.*\.nii(,\d+){0,2}$','.*\.img(,\d+){0,2}$','.*\.NII(,\d+){0,2}$','.*\.IMG(,\d+){0,2}$'};
    case {'mesh'},    code = 0; ext = {'.*\.gii$','.*\.GII$','.*\.mat$','.*\.MAT$'};
    case {'nifti'},   code = 0; ext = {'.*\.nii$','.*\.img$','.*\.NII$','.*\.IMG$'};
    case {'gifti'},   code = 0; ext = {'.*\.gii$','.*\.GII$'};
    case {'extimage'},   code = 1; ext = {'.*\.nii(,[0-9]*){0,2}$',...
            '.*\.img(,[0-9]*){0,2}$',...
            '.*\.NII(,[0-9]*){0,2}$',...
            '.*\.IMG(,[0-9]*){0,2}$'};
    case {'xml'},     code = 0; ext = {'.*\.xml$','.*\.XML$'};
    case {'mat'},     code = 0; ext = {'.*\.mat$','.*\.MAT$','.*\.txt','.*\.TXT'};
    case {'batch'},   code = 0; ext = {'.*\.mat$','.*\.MAT$','.*\.m$','.*\.M$','.*\.xml$','.*\.XML$'};
    case {'dir'},     code =-1; ext = {'.*'};
    case {'extdir'},     code =-1; ext = {['.*' filesep '$']};
    otherwise,        code = 0; ext = {typ};
end;
sfilt = struct('code',code,'frames',frames,'ext',{ext},...
    'filt',{{filt}});
end
%=======================================================================

%=======================================================================
function drivestr = listdrives(reread)
persistent mydrivestr;
if isempty(mydrivestr) || reread
    driveLett = strcat(cellstr(char(('C':'Z')')), ':');
    dsel = false(size(driveLett));
    for i=1:numel(driveLett)
        dsel(i) = exist([driveLett{i} '\'],'dir')~=0;
    end
    mydrivestr = driveLett(dsel);
end;
drivestr = mydrivestr;
end
%=======================================================================

%=======================================================================


function varargout = cfg_onscreen(fg)
% Move figure on the screen containing the mouse
%    cfg_onscreen(fg) - move figure fg on the screen containing the mouse
%    pos = cfg_onscreen(fg) - compute position of figure, do not move it
%
% This code is part of a batch job configuration system for MATLAB. See
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_onscreen.m 4033 2010-08-04 15:53:35Z volkmar $

rev = '$Rev: 4033 $';

% save figure units - use pixels here
units = get(fg,'Units');
set(fg,'Units','pixels');
Rect = get(fg,'Position');
S0   = get(0,'MonitorPosition');
if size(S0,1) > 1 % Multiple Monitors
    %-Use Monitor containing the Pointer
    pl = get(0,'PointerLocation');
    w  = find(pl(1)>=S0(:,1) & pl(1)<S0(:,1)+S0(:,3)-1 &...
        pl(2)>=S0(:,2) & pl(2)<S0(:,2)+S0(:,4));
    if numel(w)~=1, w = 1; end
    S0 = S0(w,:);
end
Rect(1) = S0(1) + (S0(3) - Rect(3))/2;
Rect(2) = S0(2) + (S0(4) - Rect(4))/2;
if nargout == 0
    set(fg, 'Position',Rect);
else
    varargout{1} = Rect;
end
set(fg,'Units',units);
end

function varargout = cfg_get_defaults(defstr, varargin)

% function varargout = cfg_get_defaults(defspec, varargin)
% Get/set defaults for various properties of matlabbatch utilities.
% The values can be modified permanently by editing the file
% private/cfg_mlbatch_defaults.m
% or for the current MATLAB session by calling
% cfg_get_defaults(defspec, defval).
%
% This code is part of a batch job configuration system for MATLAB. See
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_get_defaults.m 1862 2008-06-30 14:12:49Z volkmar $

rev = '$Rev: 1862 $'; %#ok

persistent local_def;
if isempty(local_def)
    local_def = cfg_mlbatch_defaults;
end;

% construct subscript reference struct from dot delimited tag string
tags = textscan(defstr,'%s', 'delimiter','.');
subs = struct('type','.','subs',tags{1}');

if nargin == 1
    try
        varargout{1} = subsref(local_def, subs);
    catch
        varargout{1} = [];
    end
else
    local_def = subsasgn(local_def, subs, varargin{1});
end;
end


function cfg_defaults = cfg_mlbatch_defaults

% function cfg_defaults = cfg_mlbatch_defaults
% This file contains defaults that control the behaviour and appearance
% of matlabbatch.
%
% This code is part of a batch job configuration system for MATLAB. See
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_mlbatch_defaults.m 6641 2015-12-11 10:17:11Z volkmar $

rev = '$Rev: 6641 $'; %#ok

try
    % Font definition for cfg_ui user interface
    % cfg_defaults.cfg_ui.Xfont is a param/value list of property values as returned by uisetfont
    % lfont: used in lists, value edit dialogues etc.
    cfg_defaults.cfg_ui.lfont = {'FontAngle','normal',...
        'FontName',get(0,'factoryTextFontName'),...
        'FontSize',12,...
        'FontUnits','points',...
        'FontWeight','normal'};
    % bfont: used for buttons
    cfg_defaults.cfg_ui.bfont = {'FontAngle',get(0, 'factoryUicontrolFontAngle'),...
        'FontName',get(0,'factoryUicontrolFontName'),...
        'FontSize',get(0, 'factoryUicontrolFontSize'),...
        'FontUnits',get(0, 'factoryUicontrolFontUnits'),...
        'FontWeight',get(0, 'factoryUicontrolFontWeight')};
    % Toggle ExpertEdit mode. Value can be 'on' or 'off'
    cfg_defaults.cfg_ui.ExpertEdit = 'off';
catch
    cfg_defaults.cfg_ui = false;
end

% cfg_util
% Parallel execution of independent modules
% Currently, this does not run modules in parallel, but it may reorder
% execution order of modules: all modules without dependencies will be run
% before modules with dependencies will be harvested again. If some modules
% have side effects (e.g. "Change Directory") that are not encoded as
% dependency, this may lead to unwanted results. Disabling parallel
% execution incurs an overhead during job execution because the job
% must be harvested more often.
cfg_defaults.cfg_util.runparallel = false;
% cfg_util('genscript',...) hook to add application specific initialisation
% code to generated scripts. This must be a function handle that takes no
% input arguments and returns two output arguments - the code to be
% inserted as a string array, and a flag indicating whether cfg_util should
% add job execution code (flag == true) or not (flag == false).
% The generated code will be inserted after the for loop which collects the
% input. In the generated code, variables 'jobs' and 'inputs' can be
% referenced. These will hold the jobs and corresponding inputs.
cfg_defaults.cfg_util.genscript_run = [];
% A diary of command window output can be kept for jobs. This is useful for
% debugging various problems related to job execution.
cfg_defaults.cfg_util.run_diary = false;

% Message defaults
cfg_defaults.msgdef.identifier  = 'cfg_defaults:defaultmessage';
cfg_defaults.msgdef.level       = 'info'; % one of 'info', 'warning', 'error'
cfg_defaults.msgdef.destination = 'stdout'; % one of 'none', 'stdout',
% 'stderr', 'syslog'. Errors
% will always be logged to
% the command window, and
% additionally to syslog, if specified
cfg_defaults.msgdef.verbose     = 'off';
cfg_defaults.msgdef.backtrace   = 'off';

cfg_defaults.msgcfg(1)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(1).identifier  = 'matlabbatch:run:jobfailederr';
cfg_defaults.msgcfg(1).level       = 'error';
cfg_defaults.msgcfg(2)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(2).identifier  = 'matlabbatch:cfg_util:addapp:done';
cfg_defaults.msgcfg(2).destination = 'none';
cfg_defaults.msgcfg(3)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(3).identifier  = 'matlabbatch:initialise:invalid';
cfg_defaults.msgcfg(3).level       = 'error';
cfg_defaults.msgcfg(4)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(4).identifier  = 'matlabbatch:fopen';
cfg_defaults.msgcfg(4).level       = 'error';
cfg_defaults.msgcfg(5)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(5).identifier  = 'cfg_getfile:notcolumncell';
cfg_defaults.msgcfg(5).level       = 'error';
cfg_defaults.msgcfg(6)             = cfg_defaults.msgdef;
cfg_defaults.msgcfg(6).identifier  = 'matlabbatch:subsref:cfg_dep:multisubs';
cfg_defaults.msgcfg(6).level       = 'warning';
cfg_defaults.msgcfg(6).backtrace   = 'on';

cfg_defaults.msgtpl( 1)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 1).identifier  = '^matlabbatch:subsasgn';
cfg_defaults.msgtpl( 1).level       = 'error';
cfg_defaults.msgtpl( 2)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 2).identifier  = '^matlabbatch:subsref';
cfg_defaults.msgtpl( 2).level       = 'error';
cfg_defaults.msgtpl( 3)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 3).identifier  = '^matlabbatch:constructor';
cfg_defaults.msgtpl( 3).level       = 'error';
cfg_defaults.msgtpl( 4)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 4).identifier  = '^matlabbatch:deprecated';
cfg_defaults.msgtpl( 4).destination = 'none';
cfg_defaults.msgtpl( 5)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 5).identifier  = '^matlabbatch:usage';
cfg_defaults.msgtpl( 5).level       = 'error';
cfg_defaults.msgtpl( 6)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 6).identifier  = '^matlabbatch:setval';
cfg_defaults.msgtpl( 6).destination = 'none';
cfg_defaults.msgtpl( 7)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 7).identifier  = '^matlabbatch:run:nomods';
cfg_defaults.msgtpl( 7).level       = 'info';
cfg_defaults.msgtpl( 8)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 8).identifier  = '^matlabbatch:cfg_struct2cfg';
cfg_defaults.msgtpl( 8).destination = 'none';
cfg_defaults.msgtpl( 9)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl( 9).identifier  = '^MATLAB:inputdlg';
cfg_defaults.msgtpl( 9).level       = 'error';
cfg_defaults.msgtpl(10)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl(10).identifier  = '^MATLAB:listdlg';
cfg_defaults.msgtpl(10).level       = 'error';
cfg_defaults.msgtpl(11)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl(11).identifier  = '^MATLAB:num2str';
cfg_defaults.msgtpl(11).level       = 'error';
cfg_defaults.msgtpl(12)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl(12).identifier  = '^matlabbatch:ok_subsasgn';
cfg_defaults.msgtpl(12).destination = 'none';
cfg_defaults.msgtpl(13)             = cfg_defaults.msgdef;
cfg_defaults.msgtpl(13).identifier  = 'matlabbatch:checkval:numcheck:transposed';
cfg_defaults.msgtpl(13).destination = 'none';

% value check for cfg_branch/choice/repeat items - set to false after
% configuration has been initialised to speed up job
% initialisation/harvest/run - set this to true if you want to debug some
% configuration or the batch system itself
cfg_defaults.cfg_item.checkval = false;

% verbosity of code generation for cfg_dep objects
% true  - one-line code containing only source information
% false - full code, including source and target specifications
cfg_defaults.cfg_dep.gencode_short = true;
end


%% selectionGUI using multiple cells
% function ids=selector(tb)
% function ids=selector2(tb,colinfo,varargin)

% pairwise varargins
% 'iswait'      :  0/1      : [0] for debugging modus
% 'out'         : 'list'    : first outputargument is the selected list (tb) not the selected indices
% 'out'         : 'col-id'   : first outputargument is the specified column, example 'col-2'-->get column 2

%% IN
% tb is a multiCell of strings
% colinfo <optional>:char with infos, e.g. columnames
%% OUT
% ids: indices of selected objects
% use +/- to change fontsize
% use contextmenu ro de/select all
%% example
% id=selector(tb)
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');%with columnInfo
%% EXAMPLE
% tb={   '20150908_101706_20150908_FK_C1M02_1_1\…'    '4.1943'    '08-Sep-2015 10:45:06'    'RARE'
%        '20150908_102727_20150908_FK_C1M04_1_1\…'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M064_1_1\…'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M043_1_1\…'    '4.1943'    '08-Sep-2010 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M04_1_1\…'    '3.1943'    '08-Sep-2015 10:45:00'    'fl'
% '20150908_102727_20150908_FK_C1M082_1_1\…'    '2.1943'    '08-Sep-2014 10:45:01'    'RARE'
% '20150908_102727_20150908_FK_C1M01_1_1\…'    '77.1943'    '08-Sep-2015 10:45:11'    'fl'}
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');

% id=selector2(strrep(strrep(b,'\\','-'),' ','-'),{'file' 'sizeMB' 'date' 'MRsequence' 'protocol'});


function [ids varargout]=selector3(tb,header,varargin)


[ids]=deal([]);
varargout={};

params.dummy=nan;
if ~isempty(varargin)
    vara=reshape(varargin,[2 length(varargin)/2])';
    params=cell2struct(vara(:,2)',vara(:,1)',2);
end

if ~isfield(params,'selection')
    params.selection='multi';
end
% 0.0778    0.0772    0.6698    0.8644

warning off;

% tb={header(:)';tb};

% us.raw=tb;
us.showinbrowser=0;
us.header=[{'ID'} ; header(:)];
us.tb0=tb;
tb=[header(:)'; tb];


iswait=1;
ids=[];

tb=[ cellstr(num2str([1:size(tb,1)]'-1)) tb ];
us.raw=tb(2:end,:);

% tb=strrep(tb,' ',' ');

% %replace '_' with html-code
% for i=1:size(tb,2)
%     tb(:,i)=regexprep( tb(:,i)  ,'_','<u>_</u>');
% end

% tb=[tb repmat({'_'},size(tb,1),1) ];
%space=repmat('·|·' ,size(tb,1),1 );
space=repmat('  ' ,size(tb,1),1 );
space1=repmat('] ' ,size(tb,1),1 );

%  space2=repmat(' [ ]' ,size(tb,1),1 );
%  space=repmat(']  [' ,size(tb,1),1 );
space2=repmat('' ,size(tb,1),1 );

%space=repmat('|·' ,size(tb,1),1 );
d=[];
for i=1:size(tb,2);
    d=[d char(tb(:,i)) ];
    if i<size(tb,2)
        if i==1
            d=[d repmat(space1,1,1 ) ];
        else
            
            d=[d repmat(space,1,1 ) ];
        end
    else
        d=[d repmat(space2,1,1 ) ];
    end
end
% d2=d(:,1:end-1);
% d2=[d2 char(repmat({'@'},size(d2,1),1)) ];

% if 0
%     k=cellstr(d)
%     cellfun(@(k) {[ k]},k)
% k2=(regexprep(k,'\s+','</b></TD><TD><b>'))
% d=char(d);
% end


tb2=cellstr(d);
tb2=cellfun(@(tb2) {['[_] ' tb2]},tb2);
% tb2=cellfun(@(tb2) {['(_) ' tb2]},tb2);
tb2=cellfun(@(tb2) {[ tb2 repmat(' ',[1 10])]},tb2);

% tb2=regexprep(tb2,'\t',' ');
% tb2=regexprep(tb2,' ','.');
% tb2=regexprep(tb2,' ','&hellip');
% tb2=regexprep(tb2,char(10),'');

clear d;
%  tb2=strrep(tb2,'[','');
% tb2=strrep(tb2,']','');
% tb2=strrep(tb2,'.','');

tb2=strrep(tb2,' ','&nbsp;');

% tb2=strrep(tb2,' ','&emsp;');
% tb2=strrep(tb2,' ','_');
% tb2=strrep(tb2,' ', '&#8230;');
% tb2=strrep(tb2,' ', '&#8230;');

% tb2=strrep(tb2,'_','&#95');
% &#160



mode=2;

if mode==1
    % colortag='<html><div style="background:yellow;">Panel 1'
    colortag='<html><div style="color:red;"> '
    % % colortag='<html><TD BGCOLOR=#40FF68>'
    tbsel=cellfun(@(tb2) [ colortag tb2],tb2,'UniformOutput',0)
elseif mode==2
    %        colergen = @(color,text) ['<html><table border=0 width=500 bgcolor=',color,'><TR><TD><pre><b>',text,'</b></pre></TD></TR> </table></html>'];
    colergen = @(color,text) ['<html><bgcolor=',color,'><b>',text,'</b></html>'];
    
    for i=1:size(tb2,1)
        for j=1:size(tb2,2)
            %             tbsel{i,j}=colergen('#ffcccc',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbsel{i,j}=colergen('#FFD700',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbunsel{i,j}=colergen('#FFFFFF',[tb2{i,j}(1:end-2) ' ]' ] );
            
            tbsel{i,j}=colergen('#FFD700',[ '[x' tb2{i,j}(3:end)  ] );
            tbunsel{i,j}=colergen('#FFFFFF',[ '[ ' tb2{i,j}(3:end)  ] );
        end
    end
    
    %     %orig
    %     colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    %     % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    %     for i=1:size(tb2,1)
    %         for j=1:size(tb2,2)
    %             tb2{i,j}=colergen('#ffffff',tb2{i,j});
    %         end
    %     end
    
end

% data = {  2.7183        , colergen('#FF0000','Red')
%          'dummy text'   , colergen('#00FF00','Green')
%          3.1416         , colergen('#0000FF','Blue')
%          }
% uitable('data',data)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% tbunsel=strrep(tbunsel,'[','')
% tbunsel=strrep(tbunsel',']','')


head=tbunsel{1};
tbunsel=tbunsel(2:end);
tbsel=tbsel(2:end);
tb=tb(2:end);
tb2=tb2(2:end);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


us.row=1;
% us.tb2=tb2;
% us.tb0=tb2;
us.tbsel=tbsel;

us.tbunsel  =tbunsel;
us.tb2      =tbunsel;
us.tb0      =tbunsel;
us.sel=zeros(size(tb2,1),1);

%  tb2=us.tbsel;


try; delete( findobj(0,'TAG','selector'));end

fg; set(gcf,'units','norm','position', [0.0778    0.0772    0.5062    0.8644]);
set(gcf,'name','SELECTOR: use contextmenus for selectrionMode','KeyPressFcn',@keypress);
set(gcf,'userdata',us,'menubar','none','TAG','selector');

t=uicontrol('Style','listbox','units','normalized',         'Position',[0 .1 1 .9]);
set(t,'string',tbunsel,'fontname','courier new','fontsize',14);
set(t,'max',100,'tag','lb1');
% set(t,'Callback',@tablecellselection,'backgroundcolor','w','KeyPressFcn',@keypress);
set(t,'backgroundcolor','w','KeyPressFcn',@keypress);

set(t,'Callback',@buttonDown);
% set(gcf,'ButtonDownFcn',@buttonDown);


% jScrollPane = findjobj(t); % get the scroll-pane object
% jListbox = jScrollPane.getViewport.getComponent(0);
% set(jListbox, 'SelectionBackground',java.awt.Color.yellow); % option #1
% set(jListbox, 'SelectionBackground',java.awt.Color(0.2,0.3,0.7)); % option #2

%______________CONTEXTMENU__________________________________
ctx=uicontextmenu;
uimenu('Parent',ctx,'Label','select this',  'callback',@selecthighlighted);
uimenu('Parent',ctx,'Label','select all',   'callback',@selectall,'separator','on');
uimenu('Parent',ctx,'Label','deselect all', 'callback',@deselectall);
uimenu('Parent',ctx,'Label','find & select','callback',@findAndSelect,'separator','on');
if isfield(params,'contextmenu')
    for i=1:size(params.contextmenu,1)
        uimenu('Parent',ctx,'Label',params.contextmenu{i,1},'callback',params.contextmenu{i,2},...
            'foregroundcolor',[0.4667    0.6745    0.1882],'tag',['cm' num2str(i)]);
    end
end

% Menu3=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 3');
set(t,'UIContextMenu',ctx);
% get(MyListbox,'UIContextMenu')

fontsize=8;

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.85 .05 .1 .02],'tag','pb1');
set(p,'string','OK','callback',@ok,'fontsize',fontsize);

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .05 .1 .02],'tag','pb2');
set(p,'string','select all','callback',{@selectallButton},'fontsize',fontsize);
p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .03 .1 .02],'tag','pb3');
set(p,'string','deselect all','callback',{@deselectallButton},'fontsize',fontsize);
p=uicontrol('Style','popupmenu','units','normalized',         'Position' ,[.55 .01 .1 .02],'tag','pb4','tag','pop');
set(p,'string',cellfun(@(a) {['sort after [' a ']' ]}, ['ID' ; header(:)]) ,'callback',{@sorter},'fontsize',fontsize);

p=uicontrol('Style','checkbox','units','normalized',         'Position' ,[.52 .01 .02  .02],'tag','pb4','backgroundcolor','w',...
    'tooltipstring', '[check this] to descend sorting','tag','cbox1','callback',{@sorter});

% p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .01 .1 .02],'tag','pb4');
% set(p,'string','help','callback',{@help},'fontsize',fontsize);

p=uicontrol('Style','edit','units','normalized',         'Position',[.1 .03 .4 .05],'tag','tx1','max',2);
txtinfo={        ['selected objects   : '  num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ]   };
txtinfo{end+1,1}=[' '];
txtinfo{end+1,1}=['highlighted objects: 1'];
txtinfo{end+1,1}=['selectionType: '  upper(params.selection) '-selection'];



set(p,'position',[0 0 .5 .1]);

if exist('colinfo'); if ischar(colinfo)    txtinfo{2}=colinfo   ;end;end
addi={};
addi{end+1,1}=['––––––––––––– SHORTCUTS & INFO ––––––––––––––––––'];
addi{end+1,1}=[' [+/-] change fontsize'];
addi{end+1,1}=[' [s]      or [f1]   UN/SELECT highlighted objects '];
addi{end+1,1}=[' [return] or [f2]   OK & FINNISH "Ich habe fertig" '];
addi{end+1,1}=[' [d]      or [f3]  DESELECT ALL objects'];
addi{end+1,1}=[' [a]      or [f4]  SELECT ALL objects'];
addi{end+1,1}=[' [doubleclick ] to un/select; [shift&click] for multiselection '];
addi{end+1,1}=[' see also contextmenu'];


txtinfo=[txtinfo; addi];

set(p,'userdata',txtinfo, 'string',    txtinfo   ,'fontsize',6,'backgroundcolor','w');
try;
    set(p,'tooltipstr',sprintf(strjoin('\n',txtinfo)));
end

set(findobj(gcf,'tag','lb1'),'fontsize',8);
set(findobj(gcf,'tag','lb1'),'fontsize',8);



jListbox = findjobj(findobj(gcf,'tag','lb1'));
jListbox=jListbox.getViewport.getComponent(0);
jListbox.setSelectionAppearanceReflectsFocus(0);

drawnow;
jScrollPane = findjobj(findobj(gcf,'tag','lb1')); % get the scroll-pane object
jListbox = jScrollPane.getViewport.getComponent(0);

%%
v=[ 0.4667    0.6745    0.1882];%color
% v=uisetcolor
set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
% set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
set(jListbox, 'SelectionBackground',java.awt.Color(v(1),v(2),v(3))); % option #2


us.jTable=jListbox;
us.Table =findobj(gcf,'tag','lb1');


lb1=findobj(gcf,'style','listbox');
set(lb1,'position',[ 0    0.1000    1.0000    0.88000]);
%
p2=uicontrol('Style','listbox','units','normalized',  ...
    'Position',[ 0    0.98    1.0000    .02],'tag','lb2');
% la=header
% str=get(lb1,'string');
% str=str{1}
%
% for i=1:length(header)
%    str=strrep(str,tb{1,i+1},header{i} )
% end
% head=strrep(head,'[ ]&nbsp;0]&nbsp;' ,repmat('&nbsp;',[1 7 ]));
head=strrep(head,'[ ]' ,repmat('&nbsp;',[1 3 ]));
head=strrep(head,'0]' ,repmat('&nbsp;',[1 2 ]));

set(p2,'string',head);
set(p2,'enable','off');

set(findobj(gcf,'tag','lb1'),'fontname','courier new');
set(findobj(gcf,'tag','lb2'),'fontname','courier new');


if isfield(params,'position')
    set(gcf,'position',params.position);
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

us.lb1=findobj(gcf,'tag','lb1');
us.lb2=findobj(gcf,'tag','lb2');
us.jlb1 = findjobj(us.lb1);
us.jlb2 = findjobj(us.lb2);

% hh = handle(us.jlb1 ,'CallbackProperties')
% set(hh.AdjustmentValueChangedCallback,@sliderx)
us.jlb1.AdjustmentValueChangedCallback=@sliderSinc;
% r=get(us.jlb1,'HorizontalScrollBar')
% set(r,'Value',21)
%
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% set(gcf, 'WindowButtonDownFcn', @(h,e) disp(get(gcf,'CurrentModifier')));

us.params=params;
set(gcf,'userdata',us);
set(gcf,'currentobject',findobj(gcf,'tag','lb1'));
uicontrol(findobj(gcf,'tag','lb1'));%set focus


%% SINGLE/MULTISELECTION
if strcmp(us.params.selection,'single')
    t=findobj(gcf,'tag','lb1');
    set(t,'Max',1);
end
%% WAIT-check
if isfield(params,'iswait')
    iswait=params.iswait;
end

%% wait here
if iswait==1
    uiwait(gcf);
    %    return
    hfig= findobj(0,'TAG','selector');
    if isempty(hfig); return; end
    us=get(gcf,'userdata');
    id=find(us.sel==1);
    if ~isempty(id)
        %[ids isort]=sort(str2num(cell2mat(us.raw(id,1))));
        %varargout{1}=us.raw(isort,2:end);
        
        dm=us.raw(id,:);
        ids=str2num(cell2mat(dm(:,1)));
        dm2=sortrows([ num2cell(ids) dm(:,2:end)],1);
        
        ids                 =cell2mat(dm2(:,1));
        varargout{1}        =dm2(:,2:end);
        
        if isfield(params,'out')
            if strcmp(params.out,'list')
                ids         =dm2(:,2:end);
                varargout{1} =cell2mat(dm2(:,1));
            elseif  strfind(params.out,'col')
                column=str2num(regexprep(params.out,'col-','','ignorecase'));
                ids         =dm2(:,column+1);
                varargout{1} =cell2mat(dm2(:,1));
            end
        end
        
    else
        ids=[];
        varargout={};
    end
    close(gcf);
end
return
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function sliderSinc(h,e)
%%
us=get(gcf,'userdata');
r1=get(us.jlb1,'HorizontalScrollBar');
val=get(r1,'Value');
r2=get(us.jlb2,'HorizontalScrollBar');
set(r2,'Value',val);

end
function buttonDown(h,ev,ro)
us=get(gcf,'userdata');
us.row=get(findobj(gcf,'tag','lb1'),'value');

% double(get(gcf,'CurrentCharacter'))



% val=get(gcf,'CurrentCharacter')
% get(gcf,'CurrentModifier')


% if isempty(val)
%     'mouse'
% else
%     'key'
% end



% return
persistent chk
persistent lbval



if isempty(chk)
    chk = 1;
    lbval=get(findobj(gcf,'tag','lb1'),'value');
    %% update HIGHLIGHTED
    htx=findobj(gcf,'tag','tx1');
    tx=get(htx,'string');
    tx{3}=['highlighted objects: '  num2str(length(lbval))];
    set(htx,'string',tx);
try;    set(htx,'tooltipstr',sprintf(strjoin('\n',tx)));end
    
    pause(0.7); %Add a delay to distinguish single click from a double click
    if chk == 1
        % fprintf(1,'\nI am doing a single-click.\n\n');
        
        
        
        chk = [];
    end
else
    chk = [];
    %     disp(lbval);
    %     disp(get(findobj(gcf,'tag','lb1'),'value'));
    try
        if get(findobj(gcf,'tag','lb1'),'value')==lbval
            %         fprintf(1,'\nI am doing a double-click.\n\n');
            ee=[];
            ee.Key='s';
            ee.Character='';
            keypress([],ee);
        end
    end
end



end



function keypress(h,ev)
% Callback to parse keypress event data to print a figure
if ev.Character == '+'
    lb=findobj(gcf,'tag','lb1');
    lb2=findobj(gcf,'tag','lb2');
    fs= get(lb,'fontsize')+1;
    if fs>1;
        set(lb,'fontsize',fs);
        set(lb2,'fontsize',fs);
    end
elseif ev.Character == '-'
    lb=findobj(gcf,'tag','lb1');
    lb2=findobj(gcf,'tag','lb2');
    fs= get(lb,'fontsize')-1;
    if fs>1;
        set(lb,'fontsize',fs);
        set(lb2,'fontsize',fs);
    end
end
if strcmp(ev.Key,'s') || strcmp(ev.Key,'f1') %SELECTION
    get(findobj(gcf,'tag','lb1'),'value');
    tablecellselection(nan,nan);
elseif strcmp(ev.Key,'d')  || strcmp(ev.Key,'f3')    %DESELECT
    selectthis([],0);
elseif strcmp(ev.Key,'a')  || strcmp(ev.Key,'f4')    %SELECT ALL
    selectthis([],1);
elseif strcmp(ev.Key,'b') %set BROWSER
    us=get(gcf,'userdata');
    if isfield(us,'showinbrowser')==0
        us.showinbrowser=0;
        set(gcf,'userdata',us);
        us=get(gcf,'userdata');
    end
    if     us.showinbrowser==1; us.showinbrowser=0;
    elseif us.showinbrowser==0; us.showinbrowser=1;
    end
    set(gcf,'userdata',us);
    %         us
elseif strcmp(ev.Key,'rightarrow')
    us=get(gcf,'userdata');
    r1=get(us.jlb1,'HorizontalScrollBar');
    val=get(r1,'Value');
    set(r1,'Value',val+150);
    sliderSinc
elseif strcmp(ev.Key,'leftarrow')
    us=get(gcf,'userdata');
    r1=get(us.jlb1,'HorizontalScrollBar');
    val=get(r1,'Value');
    set(r1,'Value',val-150);
    sliderSinc
elseif strcmp(ev.Key,'return') || strcmp(ev.Key,'f2')   %RETURN
    hgfeval(get(findobj(gcf,'tag','pb1'),'callback'));
    
end




for i=1:10
    id=findobj(gcf,'tag', ['cm' num2str(i)]);
    if ~isempty(id)
        if strcmp(ev.Key,num2str(i))
            hgfeval(get(id,'callback'));
        end
    end
end



set(gcf,'currentch',char(71)) ;

end


%% BUTTONS
function selectallButton(dum,dum2)
selectthis([],1);

end
function deselectallButton(dum,dum2)
selectthis([],0);
end

function sorter(dum,dum2)
sortlist

end
function sortlist;

pop=findobj(gcf,'tag','pop');
% sortcol=get(dum,'value');
sortcol=get(pop,'value');
us=get(gcf,'userdata');

cbox=findobj(gcf,'tag','cbox1');
[us.raw ix]=sortrows(us.raw,sortcol);
info='ascending';
if get(cbox,'value')==1
    us.raw=flipud(us.raw);
    ix=flipud(ix);
    info='descending';
else
    
end
us.tbsel   =us.tbsel(ix);
us.tbunsel =us.tbunsel(ix);
us.tb2     =us.tb2(ix);
try
    us.tb     =us.tb(ix);
end
us.sel     =us.sel(ix);
lb1=findobj(gcf,'tag','lb1');
list=get(lb1,'string');
set(lb1,'string',list(ix));
set(gcf,'userdata',us);

tx1=findobj(gcf,'tag','tx1');
str2=get(tx1,'string');
str2{2,1}=['sorting: ['  us.header{sortcol} '] >>' info];
set(tx1,'string',str2);

end
function ok(t,b)
uiresume(gcf);
%% internal funs
end

function findAndSelect_preselect(h,e)

us=get(gcf,'userdata');
hp1=findobj(gcf,'tag','hp1');
va=get(hp1,'value');
li=get(hp1,'string');
col=li{va};
icol=regexpi2(us.header,col);

list2=unique(us.raw(:,icol));
list2=[{''};list2];
hp2=findobj(gcf,'tag','hp2');
set(hp2,'value',1);
set(hp2,'string',list2);
% keyboard

end

function findselect_cb(h,e,task)

if task==4 %close
    delete(findobj(gcf,'tag','hpa'));
elseif task==3%cancel
    delete(findobj(gcf,'tag','hpa'));
elseif task==2 %help
    h={' #yg  ***FIND and SELECT ***'} ;
    h{end+1,1}=[' ## 1. chose the column of interest from upper pulldown menu '];
    h{end+1,1}=[' ## 2a.EXPLICIT SINGLE-SELECTION'];
    h{end+1,1}=[' -select content of this column from lower pulldown menu'];
    h{end+1,1}=['   ... or ...'];
    h{end+1,1}=[' ## 2b. STRING-SEARCH SINGLE OR MULTI-SELECTION'];
    h{end+1,1}=['- type substring or several substrings separated by vertical bar or comma "epi | rare |flash " ...' ];
    h{end+1,1}=['  -EXAMPLE:  search for all Epi , RARE & FLASH sequences:     "  ' ];
    h{end+1,1}=['  - type      :     "epi | rare |flash "      ' ];
    h{end+1,1}=['  -this equals:     " Epi , rare,FLASH     "  ' ];
    h{end+1,1}=[' #### **NOTE***' ];
    h{end+1,1}=['  -case sensitivity and spaces will be IGNORED ! ' ];
    uhelp(h,1);
    %pos=get(gcf,'position');
    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);
elseif task==1 %ok
    us=get(gcf,'userdata');
    
    hp1=findobj(gcf,'tag','hp1') ;
    hp2=findobj(gcf,'tag','hp2');
    hp3=findobj(gcf,'tag','hp3');
    %COLUMN
    va=get(hp1,'value');
    li=get(hp1,'string');
    col=li{va};
    icol=regexpi2(us.header,col);
    %VALUE
    va=get(hp2,'value');
    li=get(hp2,'string');
    str=li{va};
    %FREEVALUE
    str2=get(hp3,'string');
    str2=regexprep(regexprep(str2,'\s',''),',','|');
    
    if ~isempty(str2)
        str=str2;
    end
    
    
    
    id2sel= regexpi2(us.raw(:,icol), str);
    lb1=findobj(gcf,'tag','lb1');
    set(lb1,'value',id2sel);
    selectthis([],2);
    
    % set(gcf,'userdata',us);
    %     tablecellselection(nan,nan);
    
    
end
set(findobj(gcf,'tag','lb1'),'enable','on');

end

function findAndSelect(t,b)
% set(findobj(gcf,'tag','lb1'),'enable','off');
us=get(gcf,'userdata');


hpa=uipanel('title','find&select','units','normalized','position',    [.2 .5 .6 .2],'tag','hpa');



ht1=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .8 .35 .2],'tag','ht1','string','In column ..',...
    'HorizontalAlignment','right');
hp1=uicontrol('parent',hpa,'style','popupmenu','units','normalized','position',[.4 .8 .6 .2],'tag','hp1','string',us.header,...
    'callback',@findAndSelect_preselect);


ht2=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .5 .35 .2],'tag','ht2','string','..either choose and select ..',...
    'HorizontalAlignment','right');
hp2=uicontrol('parent',hpa,'style','popupmenu','units','normalized','position',[.4 .5 .6 .2],'tag','hp2','string',{'a','s','f'});


ht3=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .4 .35 .15],'tag','ht3','string','..or type substring(s)->see help.',...
    'HorizontalAlignment','right');
hp3=uicontrol('parent',hpa,'style','edit',     'units','normalized','position',[.4 .4 .6 .15],'tag','hp3','string','');



% jCombo = findjobj(hp2);
% jCombo.setEditable(true);
pb1=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.0 .15 .2 .15],'tag','hpb1','string','OK & select','callback',{@findselect_cb,1});
pb2=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.4 .15 .2 .15],'tag','hpb2','string','Help','callback',{@findselect_cb,2});
pb3=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.8 .15 .2 .15],'tag','hpb3','string','Cancel','callback',{@findselect_cb,3});
pb4=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.0 .0  .2 .15],'tag','hpb4','string','Close','callback',{@findselect_cb,4});



findAndSelect_preselect;

end
function selecthighlighted(t,b)
selectthis(t,2);

end
function deselectall(t,b)
selectthis(t,0);

end
function selectall(t,b)
selectthis(t,1);

end
function tablecellselection(t,b)
selectthis(t,2);

end
function selectthis(t,mode)

t=findobj(gcf,'tag','lb1');
us=get(gcf,'userdata');



% value=get(t,'value');
value=get(t,'value');
if mode==0
    idx=1:size(get(t,'string'),1);
elseif mode==2  %..highlighted in listbox
    idx=value;%get(t,'value');
elseif mode==1
    idx=1:size(get(t,'string'),1);
end

if strcmp(us.params.selection,'single')
    if mode~=0
        idx=value(1);
    end
end




if mode==2
    
    for i=1:length(idx)
        this=idx(i);
        if us.sel(this)==0  %selected for process NOW
            us.sel(this)=1;
            us.tb2(this,:)=us.tbsel(this,:);
        else%deSelect
            us.sel(this)=0;
            %us.tb2(this,:)=us.tb0(this,:);
            us.tb2(this,:)=us.tbunsel(this,:);
        end
    end
elseif mode==1
    us.sel=us.sel.*0+1;
    us.tb2=us.tbsel;
elseif mode==0
    us.sel=us.sel.*0;
    us.tb2=us.tb0;
end

if strcmp(us.params.selection,'single') && mode~=0
    us.sel=us.sel.*0;
    us.tb2=us.tb0;
    
    for i=1:length(idx)
        this=idx(i);
        if us.sel(this)==0  %selected for process NOW
            us.sel(this)=1;
            us.tb2(this,:)=us.tbsel(this,:);
        else%deSelect
            us.sel(this)=0;
            %us.tb2(this,:)=us.tb0(this,:);
            us.tb2(this,:)=us.tbunsel(this,:);
        end
    end
end

set(gcf,'userdata',us);


%% infobox
tx=findobj(gcf,'tag','tx1') ;
txinfo=get(tx,'userdata');
txinfo(1) ={ [ 'selected objects   :  ' num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ' objects selected']   };
set(tx,'string',txinfo,'value',[]);

try;
    set(tx,'tooltipstr',sprintf(strjoin('\n',txinfo)));
end

% ---------remember scrolling--------------------
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
try
    
    %hTable=findobj(gcf,'tag','lb1');
    %jTable=us.jTable    % = findjobj(hTable); % hTable is the handle to the uitable object
    hTable=findobj(gcf,'tag','lb1');
    jTable = findjobj(hTable); % hTable is the handle to the uitable object
    jScrollPane = jTable.getComponent(0);
    javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    currentViewPos = jScrollPane.getViewPosition; % save current position
end
% -----------------------------
set(t,'string',us.tb2);

% ---------remember scrolling-II--------------------
try
    drawnow; % without this drawnow the following line appeared to do nothing
    jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
end














%     pause(.2);
set(t,'value',value);
us.row=value;
set(gcf,'userdata',us);


if 1
    % ---------remember scrolling-I--------------------
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
    try
        hTable=t;
        jTable = findjobj(hTable); % hTable is the handle to the uitable object
        jScrollPane = jTable.getComponent(0);
        javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
        currentViewPos = jScrollPane.getViewPosition; % save current position
    end
    
    %     set(gcf,'userdata',us);
    %     set(t,'string',us.tb2);
    
    
    % ---------remember scrolling-II--------------------
    try
        drawnow; % without this drawnow the following line appeared to do nothing
        jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
    end
end

end

function varargout=fg(varargin)

hf=figure('color','w');
if nargout>0
    varargout{1}=hf;
end
if ~isempty(varargin)
    set(hf, varargin{:});
end

end



function b=cell2str(a,sep)


if ~exist('sep') ; sep=''; end

if length(a)==1
    b=char(a);
else
    b='';
    for i=1:length(a)-1
        b=[b a{i} sep ];
    end
    b=[b a{i+1}  ];
    
end
end


function [val, sts] = cfg_eval_valedit(varargin)
% Helper function to evaluate GUI inputs in MATLAB workspace
% FORMAT [val, sts] = cfg_eval_valedit(str)
% Evaluates GUI inputs in MATLAB 'base' workspace. Results are returned
% in val. Expressions in str can be either a pure rhs argument, or a set
% of commands that assign to a workspace variable named 'val'. If
% unsuccessful, sts is false and a message window is displayed.
%
% This code is part of a batch job configuration system for MATLAB. See
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_eval_valedit.m 5678 2013-10-11 14:58:04Z volkmar $

rev = '$Rev: 5678 $';

val = [];
sts = false;
try
    % 1st, try to convert into numeric matrix without evaluation
    % This converts expressions like '1 -1' into [1 -1] instead of
    % evaluating them
    [val, sts] = str2num(varargin{1}); %#ok<ST2NM>
    if ~sts
        % try to evaluate str as rvalue
        val = evalin('base', varargin{1});
        sts = true;
    end
catch
    everr = lasterror;
    if strcmp(everr.identifier, 'MATLAB:m_invalid_lhs_of_assignment')
        try
            evalin('base', varargin{1});
            val = evalin('base','val');
            % test if val variable exists
            if ~exist('val','var')
                cfg_message('cfg_ui:local_eval_valedit:noval','No variable ''val'' assigned.');
            end;
            sts = true;
        catch
            sts = false;
            val = [];
            everr = lasterror;
            msgbox(everr.message,'Evaluation error','modal');
        end;
    end;
end;
end

function [handles,levels,parentIdx,listing] = findjobj(container,varargin) %#ok<*CTCH,*ASGLU,*MSNU,*NASGU>
%findjobj Find java objects contained within a specified java container or Matlab GUI handle
%
% Syntax:
%    [handles, levels, parentIds, listing] = findjobj(container, 'PropName',PropValue(s), ...)
%
% Input parameters:
%    container - optional handle to java container uipanel or figure. If unsupplied then current figure will be used
%    'PropName',PropValue - optional list of property pairs (case insensitive). PropName may also be named -PropName
%         'position' - filter results based on those elements that contain the specified X,Y position or a java element
%                      Note: specify a Matlab position (X,Y = pixels from bottom left corner), not a java one
%         'size'     - filter results based on those elements that have the specified W,H (in pixels)
%         'class'    - filter results based on those elements that contain the substring  (or java class) PropValue
%                      Note1: filtering is case insensitive and relies on regexp, so you can pass wildcards etc.
%                      Note2: '-class' is an undocumented findobj PropName, but only works on Matlab (not java) classes
%         'property' - filter results based on those elements that possess the specified case-insensitive property string
%                      Note1: passing a property value is possible if the argument following 'property' is a cell in the
%                             format of {'propName','propValue'}. Example: FINDJOBJ(...,'property',{'Text','click me'})
%                      Note2: partial property names (e.g. 'Tex') are accepted, as long as they're not ambiguous
%         'depth'    - filter results based on specified depth. 0=top-level, Inf=all levels (default=Inf)
%         'flat'     - same as specifying: 'depth',0
%         'not'      - negates the following filter: 'not','class','c' returns all elements EXCEPT those with class 'c'
%         'persist'  - persist figure components information, allowing much faster results for subsequent invocations
%         'nomenu'   - skip menu processing, for "lean" list of handles & much faster processing;
%                      This option is the default for HG containers but not for figure, Java or no container
%         'print'    - display all java elements in a hierarchical list, indented appropriately
%                      Note1: optional PropValue of element index or handle to java container
%                      Note2: normally this option would be placed last, after all filtering is complete. Placing this
%                             option before some filters enables debug print-outs of interim filtering results.
%                      Note3: output is to the Matlab command window unless the 'listing' (4th) output arg is requested
%         'list'     - same as 'print'
%         'debug'    - list found component positions in the Command Window
%
% Output parameters:
%    handles   - list of handles to java elements
%    levels    - list of corresponding hierarchy level of the java elements (top=0)
%    parentIds - list of indexes (in unfiltered handles) of the parent container of the corresponding java element
%    listing   - results of 'print'/'list' options (empty if these options were not specified)
%
%    Note: If no output parameter is specified, then an interactive window will be displayed with a
%    ^^^^  tree view of all container components, their properties and callbacks.
%
% Examples:
%    findjobj;                     % display list of all javaelements of currrent figure in an interactive GUI
%    handles = findjobj;           % get list of all java elements of current figure (inc. menus, toolbars etc.)
%    findjobj('print');            % list all java elements in current figure
%    findjobj('print',6);          % list all java elements in current figure, contained within its 6th element
%    handles = findjobj(hButton);                                     % hButton is a matlab button
%    handles = findjobj(gcf,'position',getpixelposition(hButton,1));  % same as above but also return hButton's panel
%    handles = findjobj(hButton,'persist');                           % same as above, persist info for future reuse
%    handles = findjobj('class','pushbutton');                        % get all pushbuttons in current figure
%    handles = findjobj('class','pushbutton','position',123,456);     % get all pushbuttons at the specified position
%    handles = findjobj(gcf,'class','pushbutton','size',23,15);       % get all pushbuttons with the specified size
%    handles = findjobj('property','Text','not','class','button');    % get all non-button elements with 'text' property
%    handles = findjobj('-property',{'Text','click me'});             % get all elements with 'text' property = 'click me'
%
% Sample usage:
%    hButton = uicontrol('string','click me');
%    jButton = findjobj(hButton,'nomenu');
%      % or: jButton = findjobj('property',{'Text','click me'});
%    jButton.setFlyOverAppearance(1);
%    jButton.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
%    set(jButton,'FocusGainedCallback',@myMatlabFunction);   % some 30 callback points available...
%    jButton.get;   % list all changeable properties...
%
%    hEditbox = uicontrol('style','edit');
%    jEditbox = findjobj(hEditbox,'nomenu');
%    jEditbox.setCaretColor(java.awt.Color.red);
%    jEditbox.KeyTypedCallback = @myCallbackFunc;  % many more callbacks where this came from...
%    jEdit.requestFocus;
%
% Technical explanation & details:
%    http://undocumentedmatlab.com/blog/findjobj/
%    http://undocumentedmatlab.com/blog/findjobj-gui-display-container-hierarchy/
%
% Known issues/limitations:
%    - Cannot currently process multiple container objects - just one at a time
%    - Initial processing is a bit slow when the figure is laden with many UI components (so better use 'persist')
%    - Passing a simple container Matlab handle is currently filtered by its position+size: should find a better way to do this
%    - Matlab uipanels are not implemented as simple java panels, and so they can't be found using this utility
%    - Labels have a write-only text property in java, so they can't be found using the 'property',{'Text','string'} notation
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab functionality.
%    It works on Matlab 7+, but use at your own risk!
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2015-01-12: Differentiate between overlapping controls (for example in different tabs); fixed case of docked figure
%    2014-10-20: Additional fixes for R2014a, R2014b
%    2014-10-13: Fixes for R2014b
%    2014-01-04: Minor fix for R2014a; check for newer FEX version up to twice a day only
%    2013-12-29: Only check for newer FEX version in non-deployed mode; handled case of invisible figure container
%    2013-10-08: Fixed minor edge case (retrieving multiple scroll-panes)
%    2013-06-30: Additional fixes for the upcoming HG2
%    2013-05-15: Fix for the upcoming HG2
%    2013-02-21: Fixed HG-Java warnings
%    2013-01-23: Fixed callbacks table grouping & editing bugs; added hidden properties to the properties tooltip; updated help section
%    2013-01-13: Improved callbacks table; fixed tree refresh failure; fixed: tree node-selection didn't update the props pane nor flash the selected component
%    2012-07-25: Fixes for R2012a as well as some older Matlab releases
%    2011-12-07: Fixed 'File is empty' messages in compiled apps
%    2011-11-22: Fix suggested by Ward
%    2011-02-01: Fixes for R2011a
%    2010-06-13: Fixes for R2010b; fixed download (m-file => zip-file)
%    2010-04-21: Minor fix to support combo-boxes (aka drop-down, popup-menu) on Windows
%    2010-03-17: Important release: Fixes for R2010a, debug listing, objects not found, component containers that should be ignored etc.
%    2010-02-04: Forced an EDT redraw before processing; warned if requested handle is invisible
%    2010-01-18: Found a way to display label text next to the relevant node name
%    2009-10-28: Fixed uitreenode warning
%    2009-10-27: Fixed auto-collapse of invisible container nodes; added dynamic tree tooltips & context-menu; minor fix to version-check display
%    2009-09-30: Fix for Matlab 7.0 as suggested by Oliver W; minor GUI fix (classname font)
%    2009-08-07: Fixed edge-case of missing JIDE tables
%    2009-05-24: Added support for future Matlab versions that will not support JavaFrame
%    2009-05-15: Added sanity checks for axes items
%    2009-04-28: Added 'debug' input arg; increased size tolerance 1px => 2px
%    2009-04-23: Fixed location of popupmenus (always 20px high despite what's reported by Matlab...); fixed uiinspect processing issues; added blog link; narrower action buttons
%    2009-04-09: Automatic 'nomenu' for uicontrol inputs; significant performance improvement
%    2009-03-31: Fixed position of some Java components; fixed properties tooltip; fixed node visibility indication
%    2009-02-26: Indicated components visibility (& auto-collapse non-visible containers); auto-highlight selected component; fixes in node icons, figure title & tree refresh; improved error handling; display FindJObj version update description if available
%    2009-02-24: Fixed update check; added dedicated labels icon
%    2009-02-18: Fixed compatibility with old Matlab versions
%    2009-02-08: Callbacks table fixes; use uiinspect if available; fix update check according to new FEX website
%    2008-12-17: R2008b compatibility
%    2008-09-10: Fixed minor bug as per Johnny Smith
%    2007-11-14: Fixed edge case problem with class properties tooltip; used existing object icon if available; added checkbox option to hide standard callbacks
%    2007-08-15: Fixed object naming relative property priorities; added sanity check for illegal container arg; enabled desktop (0) container; cleaned up warnings about special class objects
%    2007-08-03: Fixed minor tagging problems with a few Java sub-classes; displayed UIClassID if text/name/tag is unavailable
%    2007-06-15: Fixed problems finding HG components found by J. Wagberg
%    2007-05-22: Added 'nomenu' option for improved performance; fixed 'export handles' bug; fixed handle-finding/display bugs; "cleaner" error handling
%    2007-04-23: HTMLized classname tooltip; returned top-level figure Frame handle for figure container; fixed callbacks table; auto-checked newer version; fixed Matlab 7.2 compatibility issue; added HG objects tree
%    2007-04-19: Fixed edge case of missing figure; displayed tree hierarchy in interactive GUI if no output args; workaround for figure sub-menus invisible unless clicked
%    2007-04-04: Improved performance; returned full listing results in 4th output arg; enabled partial property names & property values; automatically filtered out container panels if children also returned; fixed finding sub-menu items
%    2007-03-20: First version posted on the MathWorks file exchange: <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317">http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317</a>
%
% See also:
%    java, handle, findobj, findall, javaGetHandles, uiinspect (on the File Exchange)

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.46 $  $Date: 2015/01/12 13:54:47 $

    % Ensure Java AWT is enabled
    error(javachk('awt'));

    persistent pContainer pHandles pLevels pParentIdx pPositions

    try
        % Initialize
        handles = handle([]);
        levels = [];
        parentIdx = [];
        positions = [];   % Java positions start at the top-left corner
        %sizes = [];
        listing = '';
        hg_levels = [];
        hg_handles = handle([]);  % HG handles are double
        hg_parentIdx = [];
        nomenu = false;
        menuBarFoundFlag = false;
        hFig = [];

        % Force an EDT redraw before processing, to ensure all uicontrols etc. are rendered
        drawnow;  pause(0.02);

        % Default container is the current figure's root panel
        if nargin
            if isempty(container)  % empty container - bail out
                return;
            elseif ischar(container)  % container skipped - this is part of the args list...
                varargin = {container, varargin{:}};
                origContainer = getCurrentFigure;
                [container,contentSize] = getRootPanel(origContainer);
            elseif isequal(container,0)  % root
                origContainer = handle(container);
                container = com.mathworks.mde.desk.MLDesktop.getInstance.getMainFrame;
                contentSize = [container.getWidth, container.getHeight];
            elseif ishghandle(container) % && ~isa(container,'java.awt.Container')
                container = container(1);  % another current limitation...
                hFig = ancestor(container,'figure');
                origContainer = handle(container);
                if isa(origContainer,'uimenu')
                    % getpixelposition doesn't work for menus... - damn!
                    varargin = {'class','MenuPeer', 'property',{'Label',strrep(get(container,'Label'),'&','')}, varargin{:}};
                elseif ~isa(origContainer, 'figure') && ~isempty(hFig) && ~isa(origContainer, 'matlab.ui.Figure')
                    % See limitations section above: should find a better way to directly refer to the element's java container
                    try
                        % Note: 'PixelBounds' is undocumented and unsupported, but much faster than getpixelposition!
                        % ^^^^  unfortunately, its Y position is inaccurate in some cases - damn!
                        %size = get(container,'PixelBounds');
                        pos = fix(getpixelposition(container,1));
                        %varargin = {'position',pos(1:2), 'size',pos(3:4), 'not','class','java.awt.Panel', varargin{:}};
                    catch
                        try
                            figName = get(hFig,'name');
                            if strcmpi(get(hFig,'number'),'on')
                                figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
                            end
                            mde = com.mathworks.mde.desk.MLDesktop.getInstance;
                            jFig = mde.getClient(figName);
                            if isempty(jFig), error('dummy');  end
                        catch
                            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                            jFig = get(get(hFig,'JavaFrame'),'FigurePanelContainer');
                        end
                        pos = [];
                        try
                            pxsize = get(container,'PixelBounds');
                            pos = [pxsize(1)+5, jFig.getHeight - (pxsize(4)-5)];
                        catch
                            % never mind...
                        end
                    end
                    if size(pos,2) == 2
                        pos(:,3:4) = 0;
                    end
                    if ~isempty(pos)
                        if isa(handle(container),'uicontrol') && strcmp(get(container,'style'),'popupmenu')
                            % popupmenus (combo-box dropdowns) are always 20px high
                            pos(2) = pos(2) + pos(4) - 20;
                            pos(4) = 20;
                        end
                        %varargin = {'position',pos(1:2), 'size',size(3:4)-size(1:2)-10, 'not','class','java.awt.Panel', varargin{:}};
                        varargin = {'position',pos(1:2)+[0,pos(4)], 'size',pos(3:4), 'not','class','java.awt.Panel', 'nomenu', varargin{:}};
                    end
                elseif isempty(hFig)
                    hFig = handle(container);
                end
                [container,contentSize] = getRootPanel(hFig);
            elseif isjava(container)
                % Maybe a java container obj (will crash otherwise)
                origContainer = container;
                contentSize = [container.getWidth, container.getHeight];
            else
                error('YMA:findjobj:IllegalContainer','Input arg does not appear to be a valid GUI object');
            end
        else
            % Default container = current figure
            origContainer = getCurrentFigure;
            [container,contentSize] = getRootPanel(origContainer);
        end

        % Check persistency
        if isequal(pContainer,container)
            % persistency requested and the same container is reused, so reuse the hierarchy information
            [handles,levels,parentIdx,positions] = deal(pHandles, pLevels, pParentIdx, pPositions);
        else
            % Pre-allocate space of complex data containers for improved performance
            handles = repmat(handles,1,1000);
            positions = zeros(1000,2);

            % Check whether to skip menu processing
            nomenu = paramSupplied(varargin,'nomenu');

            % Traverse the container hierarchy and extract the elements within
            traverseContainer(container,0,1);

            % Remove unnecessary pre-allocated elements
            dataLen = length(levels);
            handles  (dataLen+1:end) = [];
            positions(dataLen+1:end,:) = [];
        end

        % Process persistency check before any filtering is done
        if paramSupplied(varargin,'persist')
            [pContainer, pHandles, pLevels, pParentIdx, pPositions] = deal(container,handles,levels,parentIdx,positions);
        end

        % Save data for possible future use in presentObjectTree() below
        allHandles = handles;
        allLevels  = levels;
        allParents = parentIdx;
        selectedIdx = 1:length(handles);
        %[positions(:,1)-container.getX, container.getHeight - positions(:,2)]

        % Debug-list all found compponents and their positions
        if paramSupplied(varargin,'debug')
            for origHandleIdx = 1 : length(allHandles)
                thisObj = handles(origHandleIdx);
                pos = sprintf('%d,%d %dx%d',[positions(origHandleIdx,:) getWidth(thisObj) getHeight(thisObj)]);
                disp([repmat(' ',1,levels(origHandleIdx)) '[' pos '] ' char(toString(thisObj))]);
            end
        end

        % Process optional args
        % Note: positions is NOT returned since it's based on java coord system (origin = top-left): will confuse Matlab users
        processArgs(varargin{:});

        % De-cell and trim listing, if only one element was found (no use for indented listing in this case)
        if iscell(listing) && length(listing)==1
            listing = strtrim(listing{1});
        end

        % If no output args and no listing requested, present the FINDJOBJ interactive GUI
        if nargout == 0 && isempty(listing)

            % Get all label positions
            hg_labels = [];
            labelPositions = getLabelsJavaPos(container);

            % Present the GUI (object tree)
            if ~isempty(container)
                presentObjectTree();
            else
                warnInvisible(varargin{:});
            end

        % Display the listing, if this was specifically requested yet no relevant output arg was specified
        elseif nargout < 4 && ~isempty(listing)
            if ~iscell(listing)
                disp(listing);
            else
                for listingIdx = 1 : length(listing)
                    disp(listing{listingIdx});
                end
            end
        end

        % If the number of output handles does not match the number of inputs, try to match via tooltips
        if nargout && numel(handles) ~= numel(origContainer)
            newHandles = handle([]);
            switchHandles = false;
            handlesToCheck = handles;
            if isempty(handles)
                handlesToCheck = allHandles;
            end
            for origHandleIdx = 1 : numel(origContainer)
                try
                    thisContainer = origContainer(origHandleIdx);
                    if isa(thisContainer,'figure') || isa(thisContainer,'matlab.ui.Figure')
                        break;
                    end
                    try
                        newHandles(origHandleIdx) = handlesToCheck(origHandleIdx); %#ok<AGROW>
                    catch
                        % maybe no corresponding handle in [handles]
                    end

                    % Assign a new random tooltip to the original (Matlab) handle
                    oldTooltip = get(thisContainer,'Tooltip');
                    newTooltip = num2str(rand,99);
                    set(thisContainer,'Tooltip',newTooltip);
                    drawnow;  % force the Java handle to sync with the Matlab prop-change
                    try
                        % Search for a Java handle that has the newly-generated tooltip
                        for newHandleIdx = 1 : numel(handlesToCheck)
                            testTooltip = '';
                            thisHandle = handlesToCheck(newHandleIdx);
                            try
                                testTooltip = char(thisHandle.getToolTipText);
                            catch
                                try testTooltip = char(thisHandle.getTooltipText); catch, end
                            end
                            if isempty(testTooltip)
                                % One more attempt - assume it's enclosed by a scroll-pane
                                try testTooltip = char(thisHandle.getViewport.getView.getToolTipText); catch, end
                            end
                            if strcmp(testTooltip, newTooltip)
                                newHandles(origHandleIdx) = thisHandle;
                                switchHandles = true;
                                break;
                            end
                        end
                    catch
                        % never mind - skip to the next handle
                    end
                    set(thisContainer,'Tooltip',oldTooltip);
                catch
                    % never mind - skip to the next handle (maybe handle doesn't have a tooltip prop)
                end
            end
            if switchHandles
                handles = newHandles;
            end
        end

        % Display a warning if the requested handle was not found because it's invisible
        if nargout && isempty(handles)
            warnInvisible(varargin{:});
        end

        return;  %debug point

    catch
        % 'Cleaner' error handling - strip the stack info etc.
        err = lasterror;  %#ok
        err.message = regexprep(err.message,'Error using ==> [^\n]+\n','');
        if isempty(findstr(mfilename,err.message))
            % Indicate error origin, if not already stated within the error message
            err.message = [mfilename ': ' err.message];
        end
        rethrow(err);
    end

    %% Display a warning if the requested handle was not found because it's invisible
    function warnInvisible(varargin)
        try
            if strcmpi(get(hFig,'Visible'),'off')
                pos = get(hFig,'Position');
                set(hFig, 'Position',pos-[5000,5000,0,0], 'Visible','on');
                drawnow; pause(0.01);
                [handles,levels,parentIdx,listing] = findjobj(origContainer,varargin{:});
                set(hFig, 'Position',pos, 'Visible','off');
            end
        catch
            % ignore - move on...
        end
        try
            stk = dbstack;
            stkNames = {stk.name};
            OutputFcnIdx = find(~cellfun(@isempty,regexp(stkNames,'_OutputFcn')));
            if ~isempty(OutputFcnIdx)
                OutputFcnName = stkNames{OutputFcnIdx};
                warning('YMA:FindJObj:OutputFcn',['No Java reference was found for the requested handle, because the figure is still invisible in ' OutputFcnName '()']);
            elseif ishandle(origContainer) && isprop(origContainer,'Visible') && strcmpi(get(origContainer,'Visible'),'off')
                warning('YMA:FindJObj:invisibleHandle','No Java reference was found for the requested handle, probably because it is still invisible');
            end
        catch
            % Never mind...
        end
    end

    %% Check existence of a (case-insensitive) optional parameter in the params list
    function [flag,idx] = paramSupplied(paramsList,paramName)
        %idx = find(~cellfun('isempty',regexpi(paramsList(cellfun(@ischar,paramsList)),['^-?' paramName])));
        idx = find(~cellfun('isempty',regexpi(paramsList(cellfun('isclass',paramsList,'char')),['^-?' paramName])));  % 30/9/2009 fix for ML 7.0 suggested by Oliver W
        flag = any(idx);
    end

    %% Get current figure (even if its 'HandleVisibility' property is 'off')
    function curFig = getCurrentFigure
        oldShowHidden = get(0,'ShowHiddenHandles');
        set(0,'ShowHiddenHandles','on');  % minor fix per Johnny Smith
        curFig = gcf;
        set(0,'ShowHiddenHandles',oldShowHidden);
    end

    %% Get Java reference to top-level (root) panel - actually, a reference to the java figure
    function [jRootPane,contentSize] = getRootPanel(hFig)
        try
            contentSize = [0,0];  % initialize
            jRootPane = hFig;
            figName = get(hFig,'name');
            if strcmpi(get(hFig,'number'),'on')
                figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
            end
            mde = com.mathworks.mde.desk.MLDesktop.getInstance;
            jFigPanel = mde.getClient(figName);
            jRootPane = jFigPanel;
            jRootPane = jFigPanel.getRootPane;
        catch
            try
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                jFrame = get(hFig,'JavaFrame');
                jFigPanel = get(jFrame,'FigurePanelContainer');
                jRootPane = jFigPanel;
                jRootPane = jFigPanel.getComponent(0).getRootPane;
            catch
                % Never mind
            end
        end
        try
            % If invalid RootPane - try another method...
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
            jFrame = get(hFig,'JavaFrame');
            jAxisComponent = get(jFrame,'AxisComponent');
            jRootPane = jAxisComponent.getParent.getParent.getRootPane;
        catch
            % Never mind
        end
        try
            % If invalid RootPane, retry up to N times
            tries = 10;
            while isempty(jRootPane) && tries>0  % might happen if figure is still undergoing rendering...
                drawnow; pause(0.001);
                tries = tries - 1;
                jRootPane = jFigPanel.getComponent(0).getRootPane;
            end

            % If still invalid, use FigurePanelContainer which is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
            if isempty(jRootPane)
                jRootPane = jFigPanel;
            end
            contentSize = [jRootPane.getWidth, jRootPane.getHeight];

            % Try to get the ancestor FigureFrame
            jRootPane = jRootPane.getTopLevelAncestor;
        catch
            % Never mind - FigurePanelContainer is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
        end
    end

    %% Traverse the container hierarchy and extract the elements within
    function traverseContainer(jcontainer,level,parent)
        persistent figureComponentFound menuRootFound

        % Record the data for this node
        %disp([repmat(' ',1,level) '<= ' char(jcontainer.toString)])
        thisIdx = length(levels) + 1;
        levels(thisIdx) = level;
        parentIdx(thisIdx) = parent;
        handles(thisIdx) = handle(jcontainer,'callbackproperties');
        try
            positions(thisIdx,:) = getXY(jcontainer);
            %sizes(thisIdx,:) = [jcontainer.getWidth, jcontainer.getHeight];
        catch
            positions(thisIdx,:) = [0,0];
            %sizes(thisIdx,:) = [0,0];
        end
        if level>0
            positions(thisIdx,:) = positions(thisIdx,:) + positions(parent,:);
            if ~figureComponentFound && ...
               strcmp(jcontainer.getName,'fComponentContainer') && ...
               isa(jcontainer,'com.mathworks.hg.peer.FigureComponentContainer')   % there are 2 FigureComponentContainers - only process one...

                % restart coordinate system, to exclude menu & toolbar areas
                positions(thisIdx,:) = positions(thisIdx,:) - [jcontainer.getRootPane.getX, jcontainer.getRootPane.getY];
                figureComponentFound = true;
            end
        elseif level==1
            positions(thisIdx,:) = positions(thisIdx,:) + positions(parent,:);
        else
            % level 0 - initialize flags used later
            figureComponentFound = false;
            menuRootFound = false;
        end
        parentId = length(parentIdx);

        % Traverse Menu items, unless the 'nomenu' option was requested
        if ~nomenu
            try
                for child = 1 : getNumMenuComponents(jcontainer)
                    traverseContainer(jcontainer.getMenuComponent(child-1),level+1,parentId);
                end
            catch
                % Probably not a Menu container, but maybe a top-level JMenu, so discard duplicates
                %if isa(handles(end).java,'javax.swing.JMenuBar')
                if ~menuRootFound && strcmp(class(java(handles(end))),'javax.swing.JMenuBar')  %faster...
                    if removeDuplicateNode(thisIdx)
                        menuRootFound = true;
                        return;
                    end
                end
            end
        end

        % Now recursively process all this node's children (if any), except menu items if so requested
        %if isa(jcontainer,'java.awt.Container')
        try  % try-catch is faster than checking isa(jcontainer,'java.awt.Container')...
            %if jcontainer.getComponentCount,  jcontainer.getComponents,  end
            if ~nomenu || menuBarFoundFlag || isempty(strfind(class(jcontainer),'FigureMenuBar'))
                lastChildComponent = java.lang.Object;
                child = 0;
                while (child < jcontainer.getComponentCount)
                    childComponent = jcontainer.getComponent(child);
                    % Looping over menus sometimes causes jcontainer to get mixed up (probably a JITC bug), so identify & fix
                    if isequal(childComponent,lastChildComponent)
                        child = child + 1;
                        childComponent = jcontainer.getComponent(child);
                    end
                    lastChildComponent = childComponent;
                    %disp([repmat(' ',1,level) '=> ' num2str(child) ': ' char(class(childComponent))])
                    traverseContainer(childComponent,level+1,parentId);
                    child = child + 1;
                end
            else
                menuBarFoundFlag = true;  % use this flag to skip further testing for FigureMenuBar
            end
        catch
            % do nothing - probably not a container
            %dispError
        end

        % ...and yet another type of child traversal...
        try
            if ~isdeployed  % prevent 'File is empty' messages in compiled apps
                jc = jcontainer.java;
            else
                jc = jcontainer;
            end
            for child = 1 : jc.getChildCount
                traverseContainer(jc.getChildAt(child-1),level+1,parentId);
            end
        catch
            % do nothing - probably not a container
            %dispError
        end

        % TODO: Add axis (plot) component handles
    end

    %% Get the XY location of a Java component
    function xy = getXY(jcontainer)
            % Note: getX/getY are better than get(..,'X') (mem leaks),
            % ^^^^  but sometimes they fail and revert to getx.m ...
            % Note2: try awtinvoke() catch is faster than checking ismethod()...
            % Note3: using AWTUtilities.invokeAndWait() directly is even faster than awtinvoke()...
            try %if ismethod(jcontainer,'getX')
                %positions(thisIdx,:) = [jcontainer.getX, jcontainer.getY];
                cls = getClass(jcontainer);
                location = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getLocation',[]),[]);
                x = location.getX;
                y = location.getY;
            catch %else
                try
                    x = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getX',[]),[]);
                    y = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getY',[]),[]);
                catch
                    try
                        x = awtinvoke(jcontainer,'getX()');
                        y = awtinvoke(jcontainer,'getY()');
                    catch
                        x = get(jcontainer,'X');
                        y = get(jcontainer,'Y');
                    end
                end
            end
            %positions(thisIdx,:) = [x, y];
            xy = [x,y];
    end

    %% Get the number of menu sub-elements
    function numMenuComponents  = getNumMenuComponents(jcontainer)

        % The following line will raise an Exception for anything except menus
        numMenuComponents = jcontainer.getMenuComponentCount;

        % No error so far, so this must be a menu container...
        % Note: Menu subitems are not visible until the top-level (root) menu gets initial focus...
        % Try several alternatives, until we get a non-empty menu (or not...)
        % TODO: Improve performance - this takes WAY too long...
        if jcontainer.isTopLevelMenu && (numMenuComponents==0)
            jcontainer.requestFocus;
            numMenuComponents = jcontainer.getMenuComponentCount;
            if (numMenuComponents == 0)
                drawnow; pause(0.001);
                numMenuComponents = jcontainer.getMenuComponentCount;
                if (numMenuComponents == 0)
                    jcontainer.setSelected(true);
                    numMenuComponents = jcontainer.getMenuComponentCount;
                    if (numMenuComponents == 0)
                        drawnow; pause(0.001);
                        numMenuComponents = jcontainer.getMenuComponentCount;
                        if (numMenuComponents == 0)
                            jcontainer.doClick;  % needed in order to populate the sub-menu components
                            numMenuComponents = jcontainer.getMenuComponentCount;
                            if (numMenuComponents == 0)
                                drawnow; %pause(0.001);
                                numMenuComponents = jcontainer.getMenuComponentCount;
                                jcontainer.doClick;  % close menu by re-clicking...
                                if (numMenuComponents == 0)
                                    drawnow; %pause(0.001);
                                    numMenuComponents = jcontainer.getMenuComponentCount;
                                end
                            else
                                % ok - found sub-items
                                % Note: no need to close menu since this will be done when focus moves to the FindJObj window
                                %jcontainer.doClick;  % close menu by re-clicking...
                            end
                        end
                    end
                    jcontainer.setSelected(false);  % de-select the menu
                end
            end
        end
    end

    %% Remove a specific tree node's data
    function nodeRemovedFlag = removeDuplicateNode(thisIdx)
        nodeRemovedFlag = false;
        for idx = 1 : thisIdx-1
            if isequal(handles(idx),handles(thisIdx))
                levels(thisIdx) = [];
                parentIdx(thisIdx) = [];
                handles(thisIdx) = [];
                positions(thisIdx,:) = [];
                %sizes(thisIdx,:) = [];
                nodeRemovedFlag = true;
                return;
            end
        end
    end

    %% Process optional args
    function processArgs(varargin)

        % Initialize
        invertFlag = false;
        listing = '';

        % Loop over all optional args
        while ~isempty(varargin) && ~isempty(handles)

            % Process the arg (and all its params)
            foundIdx = 1 : length(handles);
            if iscell(varargin{1}),  varargin{1} = varargin{1}{1};  end
            if ~isempty(varargin{1}) && varargin{1}(1)=='-'
                varargin{1}(1) = [];
            end
            switch lower(varargin{1})
                case 'not'
                    invertFlag = true;
                case 'position'
                    [varargin,foundIdx] = processPositionArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'size'
                    [varargin,foundIdx] = processSizeArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'class'
                    [varargin,foundIdx] = processClassArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'property'
                    [varargin,foundIdx] = processPropertyArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'depth'
                    [varargin,foundIdx] = processDepthArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'flat'
                    varargin = {'depth',0, varargin{min(2:end):end}};
                    [varargin,foundIdx] = processDepthArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case {'print','list'}
                    [varargin,listing] = processPrintArgs(varargin{:});
                case {'persist','nomenu','debug'}
                    % ignore - already handled in main function above
                otherwise
                    error('YMA:findjobj:IllegalOption',['Option ' num2str(varargin{1}) ' is not a valid option. Type ''help ' mfilename ''' for the full options list.']);
            end

            % If only parent-child pairs found
            foundIdx = find(foundIdx);
            if ~isempty(foundIdx) && isequal(parentIdx(foundIdx(2:2:end)),foundIdx(1:2:end))
                % Return just the children (the parent panels are uninteresting)
                foundIdx(1:2:end) = [];
            end
            
            % If several possible handles were found and the first is the container of the second
            if length(foundIdx) == 2 && isequal(handles(foundIdx(1)).java, handles(foundIdx(2)).getParent)
                % Discard the uninteresting component container
                foundIdx(1) = [];
            end

            % Filter the results
            selectedIdx = selectedIdx(foundIdx);
            handles   = handles(foundIdx);
            levels    = levels(foundIdx);
            parentIdx = parentIdx(foundIdx);
            positions = positions(foundIdx,:);

            % Remove this arg and proceed to the next one
            varargin(1) = [];

        end  % Loop over all args
    end

    %% Process 'print' option
    function [varargin,listing] = processPrintArgs(varargin)
        if length(varargin)<2 || ischar(varargin{2})
            % No second arg given, so use the first available element
            listingContainer = handles(1);  %#ok - used in evalc below
        else
            % Get the element to print from the specified second arg
            if isnumeric(varargin{2}) && (varargin{2} == fix(varargin{2}))  % isinteger doesn't work on doubles...
                if (varargin{2} > 0) && (varargin{2} <= length(handles))
                    listingContainer = handles(varargin{2});  %#ok - used in evalc below
                elseif varargin{2} > 0
                    error('YMA:findjobj:IllegalPrintFilter','Print filter index %g > number of available elements (%d)',varargin{2},length(handles));
                else
                    error('YMA:findjobj:IllegalPrintFilter','Print filter must be a java handle or positive numeric index into handles');
                end
            elseif ismethod(varargin{2},'list')
                listingContainer = varargin{2};  %#ok - used in evalc below
            else
                error('YMA:findjobj:IllegalPrintFilter','Print filter must be a java handle or numeric index into handles');
            end
            varargin(2) = [];
        end

        % use evalc() to capture output into a Matlab variable
        %listing = evalc('listingContainer.list');

        % Better solution: loop over all handles and process them one by one
        listing = cell(length(handles),1);
        for componentIdx = 1 : length(handles)
            listing{componentIdx} = [repmat(' ',1,levels(componentIdx)) char(handles(componentIdx).toString)];
        end
    end

    %% Process 'position' option
    function [varargin,foundIdx] = processPositionArgs(varargin)
        if length(varargin)>1
            positionFilter = varargin{2};
            %if (isjava(positionFilter) || iscom(positionFilter)) && ismethod(positionFilter,'getLocation')
            try  % try-catch is faster...
                % Java/COM object passed - get its position
                positionFilter = positionFilter.getLocation;
                filterXY = [positionFilter.getX, positionFilter.getY];
            catch
                if ~isscalar(positionFilter)
                    % position vector passed
                    if (length(positionFilter)>=2) && isnumeric(positionFilter)
                        % Remember that java coordinates start at top-left corner, Matlab coords start at bottom left...
                        %positionFilter = java.awt.Point(positionFilter(1), container.getHeight - positionFilter(2));
                        filterXY = [container.getX + positionFilter(1), container.getY + contentSize(2) - positionFilter(2)];

                        % Check for full Matlab position vector (x,y,w,h)
                        %if (length(positionFilter)==4)
                        %    varargin{end+1} = 'size';
                        %    varargin{end+1} = fix(positionFilter(3:4));
                        %end
                    else
                        error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                    end
                elseif length(varargin)>2
                    % x,y passed as separate arg values
                    if isnumeric(positionFilter) && isnumeric(varargin{3})
                        % Remember that java coordinates start at top-left corner, Matlab coords start at bottom left...
                        %positionFilter = java.awt.Point(positionFilter, container.getHeight - varargin{3});
                        filterXY = [container.getX + positionFilter, container.getY + contentSize(2) - varargin{3}];
                        varargin(3) = [];
                    else
                        error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                    end
                else
                    error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                end
            end

            % Compute the required element positions in order to be eligible for a more detailed examination
            % Note: based on the following constraints: 0 <= abs(elementX-filterX) + abs(elementY+elementH-filterY) < 7
            baseDeltas = [positions(:,1)-filterXY(1), positions(:,2)-filterXY(2)];  % faster than repmat()...
            %baseHeight = - baseDeltas(:,2);% -abs(baseDeltas(:,1));
            %minHeight = baseHeight - 7;
            %maxHeight = baseHeight + 7;
            %foundIdx = ~arrayfun(@(b)(invoke(b,'contains',positionFilter)),handles);  % ARGH! - disallowed by Matlab!
            %foundIdx = repmat(false,1,length(handles));
            %foundIdx(length(handles)) = false;  % faster than repmat()...
            foundIdx = (abs(baseDeltas(:,1)) < 7) & (abs(baseDeltas(:,2)) < 7); % & (minHeight >= 0);
            %fi = find(foundIdx);
            %for componentIdx = 1 : length(fi)
                %foundIdx(componentIdx) = handles(componentIdx).getBounds.contains(positionFilter);

                % Search for a point no farther than 7 pixels away (prevents rounding errors)
                %foundIdx(componentIdx) = handles(componentIdx).getLocationOnScreen.distanceSq(positionFilter) < 50;  % fails for invisible components...

                %p = java.awt.Point(positions(componentIdx,1), positions(componentIdx,2) + handles(componentIdx).getHeight);
                %foundIdx(componentIdx) = p.distanceSq(positionFilter) < 50;

                %foundIdx(componentIdx) = sum(([baseDeltas(componentIdx,1),baseDeltas(componentIdx,2)+handles(componentIdx).getHeight]).^2) < 50;

                % Following is the fastest method found to date: only eligible elements are checked in detailed
            %    elementHeight = handles(fi(componentIdx)).getHeight;
            %    foundIdx(fi(componentIdx)) = elementHeight > minHeight(fi(componentIdx)) && ...
            %                                 elementHeight < maxHeight(fi(componentIdx));
                %disp([componentIdx,elementHeight,minHeight(fi(componentIdx)),maxHeight(fi(componentIdx)),foundIdx(fi(componentIdx))])
            %end

            varargin(2) = [];
        else
            foundIdx = [];
        end
    end

    %% Process 'size' option
    function [varargin,foundIdx] = processSizeArgs(varargin)
        if length(varargin)>1
            sizeFilter = lower(varargin{2});
            %if (isjava(sizeFilter) || iscom(sizeFilter)) && ismethod(sizeFilter,'getSize')
            try  % try-catch is faster...
                % Java/COM object passed - get its size
                sizeFilter = sizeFilter.getSize;
                filterWidth  = sizeFilter.getWidth;
                filterHeight = sizeFilter.getHeight;
            catch
                if ~isscalar(sizeFilter)
                    % size vector passed
                    if (length(sizeFilter)>=2) && isnumeric(sizeFilter)
                        %sizeFilter = java.awt.Dimension(sizeFilter(1),sizeFilter(2));
                        filterWidth  = sizeFilter(1);
                        filterHeight = sizeFilter(2);
                    else
                        error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                    end
                elseif length(varargin)>2
                    % w,h passed as separate arg values
                    if isnumeric(sizeFilter) && isnumeric(varargin{3})
                        %sizeFilter = java.awt.Dimension(sizeFilter,varargin{3});
                        filterWidth  = sizeFilter;
                        filterHeight = varargin{3};
                        varargin(3) = [];
                    else
                        error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                    end
                else
                    error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                end
            end
            %foundIdx = ~arrayfun(@(b)(invoke(b,'contains',sizeFilter)),handles);  % ARGH! - disallowed by Matlab!
            foundIdx(length(handles)) = false;  % faster than repmat()...
            for componentIdx = 1 : length(handles)
                %foundIdx(componentIdx) = handles(componentIdx).getSize.equals(sizeFilter);
                % Allow a 2-pixel tollerance to account for non-integer pixel sizes
                foundIdx(componentIdx) = abs(handles(componentIdx).getWidth  - filterWidth)  <= 3 && ...  % faster than getSize.equals()
                                         abs(handles(componentIdx).getHeight - filterHeight) <= 3;
            end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end

    %% Process 'class' option
    function [varargin,foundIdx] = processClassArgs(varargin)
        if length(varargin)>1
            classFilter = varargin{2};
            %if ismethod(classFilter,'getClass')
            try  % try-catch is faster...
                classFilter = char(classFilter.getClass);
            catch
                if ~ischar(classFilter)
                    error('YMA:findjobj:IllegalClassFilter','Class filter must be a java object, class or string');
                end
            end

            % Now convert all java classes to java.lang.Strings and compare to the requested filter string
            try
                foundIdx(length(handles)) = false;  % faster than repmat()...
                jClassFilter = java.lang.String(classFilter).toLowerCase;
                for componentIdx = 1 : length(handles)
                    % Note: JVM 1.5's String.contains() appears slightly slower and is available only since Matlab 7.2
                    foundIdx(componentIdx) = handles(componentIdx).getClass.toString.toLowerCase.indexOf(jClassFilter) >= 0;
                end
            catch
                % Simple processing: slower since it does extra processing within opaque.char()
                for componentIdx = 1 : length(handles)
                    % Note: using @toChar is faster but returns java String, not a Matlab char
                    foundIdx(componentIdx) = ~isempty(regexpi(char(handles(componentIdx).getClass),classFilter));
                end
            end

            varargin(2) = [];
        else
            foundIdx = [];
        end
    end

    %% Process 'property' option
    function [varargin,foundIdx] = processPropertyArgs(varargin)
        if length(varargin)>1
            propertyName = varargin{2};
            if iscell(propertyName)
                if length(propertyName) == 2
                    propertyVal  = propertyName{2};
                    propertyName = propertyName{1};
                elseif length(propertyName) == 1
                    propertyName = propertyName{1};
                else
                    error('YMA:findjobj:IllegalPropertyFilter','Property filter must be a string (case insensitive name of property) or cell array {propName,propValue}');
                end
            end
            if ~ischar(propertyName)
                error('YMA:findjobj:IllegalPropertyFilter','Property filter must be a string (case insensitive name of property) or cell array {propName,propValue}');
            end
            propertyName = lower(propertyName);
            %foundIdx = arrayfun(@(h)isprop(h,propertyName),handles);  % ARGH! - disallowed by Matlab!
            foundIdx(length(handles)) = false;  % faster than repmat()...

            % Split processing depending on whether a specific property value was requested (ugly but faster...)
            if exist('propertyVal','var')
                for componentIdx = 1 : length(handles)
                    try
                        % Find out whether this element has the specified property
                        % Note: findprop() and its return value schema.prop are undocumented and unsupported!
                        prop = findprop(handles(componentIdx),propertyName);  % faster than isprop() & enables partial property names

                        % If found, compare it to the actual element's property value
                        foundIdx(componentIdx) = ~isempty(prop) && isequal(get(handles(componentIdx),prop.Name),propertyVal);
                    catch
                        % Some Java classes have a write-only property (like LabelPeer with 'Text'), so we end up here
                        % In these cases, simply assume that the property value doesn't match and continue
                        foundIdx(componentIdx) = false;
                    end
                end
            else
                for componentIdx = 1 : length(handles)
                    try
                        % Find out whether this element has the specified property
                        % Note: findprop() and its return value schema.prop are undocumented and unsupported!
                        foundIdx(componentIdx) = ~isempty(findprop(handles(componentIdx),propertyName));
                    catch
                        foundIdx(componentIdx) = false;
                    end
                end
            end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end

    %% Process 'depth' option
    function [varargin,foundIdx] = processDepthArgs(varargin)
        if length(varargin)>1
            level = varargin{2};
            if ~isnumeric(level)
                error('YMA:findjobj:IllegalDepthFilter','Depth filter must be a number (=maximal element depth)');
            end
            foundIdx = (levels <= level);
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end

    %% Convert property data into a string
    function data = charizeData(data)
        if isa(data,'com.mathworks.hg.types.HGCallback')
            data = get(data,'Callback');
        end
        if ~ischar(data) && ~isa(data,'java.lang.String')
            newData = strtrim(evalc('disp(data)'));
            try
                newData = regexprep(newData,'  +',' ');
                newData = regexprep(newData,'Columns \d+ through \d+\s','');
                newData = regexprep(newData,'Column \d+\s','');
            catch
                %never mind...
            end
            if iscell(data)
                newData = ['{ ' newData ' }'];
            elseif isempty(data)
                newData = '';
            elseif isnumeric(data) || islogical(data) || any(ishandle(data)) || numel(data) > 1 %&& ~isscalar(data)
                newData = ['[' newData ']'];
            end
            data = newData;
        elseif ~isempty(data)
            data = ['''' data ''''];
        end
    end  % charizeData

    %% Prepare a hierarchical callbacks table data
    function setProp(list,name,value,category)
        prop = eval('com.jidesoft.grid.DefaultProperty();');  % prevent JIDE alert by run-time (not load-time) evaluation
        prop.setName(name);
        prop.setType(java.lang.String('').getClass);
        prop.setValue(value);
        prop.setEditable(true);
        prop.setExpert(true);
        %prop.setCategory(['<html><b><u><font color="blue">' category ' callbacks']);
        prop.setCategory([category ' callbacks']);
        list.add(prop);
    end  % getTreeData

    %% Prepare a hierarchical callbacks table data
    function list = getTreeData(data)
        list = java.util.ArrayList();
        names = regexprep(data,'([A-Z][a-z]+).*','$1');
        %hash = java.util.Hashtable;
        others = {};
        for propIdx = 1 : size(data,1)
            if (propIdx < size(data,1) && strcmp(names{propIdx},names{propIdx+1})) || ...
               (propIdx > 1            && strcmp(names{propIdx},names{propIdx-1}))
                % Child callback property
                setProp(list,data{propIdx,1},data{propIdx,2},names{propIdx});
            else
                % Singular callback property => Add to 'Other' category at bottom of the list
                others(end+1,:) = data(propIdx,:);  %#ok
            end
        end
        for propIdx = 1 : size(others,1)
            setProp(list,others{propIdx,1},others{propIdx,2},'Other');
        end
    end  % getTreeData

    %% Get callbacks table data
    function [cbData, cbHeaders, cbTableEnabled] = getCbsData(obj, stripStdCbsFlag)
        % Initialize
        cbData = {'(no callbacks)'};
        cbHeaders = {'Callback name'};
        cbTableEnabled = false;
        cbNames = {};

        try
            try
                classHdl = classhandle(handle(obj));
                cbNames = get(classHdl.Events,'Name');
                if ~isempty(cbNames) && ~iscom(obj)  %only java-based please...
                    cbNames = strcat(cbNames,'Callback');
                end
                propNames = get(classHdl.Properties,'Name');
            catch
                % Try to interpret as an MCOS class object
                try
                    oldWarn = warning('off','MATLAB:structOnObject');
                    dataFields = struct(obj);
                    warning(oldWarn);
                catch
                    dataFields = get(obj);
                end
                propNames = fieldnames(dataFields);
            end
            propCbIdx = [];
            if ischar(propNames),  propNames={propNames};  end  % handle case of a single callback
            if ~isempty(propNames)
                propCbIdx = find(~cellfun(@isempty,regexp(propNames,'(Fcn|Callback)$')));
                cbNames = unique([cbNames; propNames(propCbIdx)]);  %#ok logical is faster but less debuggable...
            end
            if ~isempty(cbNames)
                if stripStdCbsFlag
                    cbNames = stripStdCbs(cbNames);
                end
                if iscell(cbNames)
                    cbNames = sort(cbNames);
                    if size(cbNames,1) < size(cbNames,2)
                        cbNames = cbNames';
                    end
                end
                hgHandleFlag = 0;  try hgHandleFlag = ishghandle(obj); catch, end  %#ok
                try
                    obj = handle(obj,'CallbackProperties');
                catch
                    hgHandleFlag = 1;
                end
                if hgHandleFlag
                    % HG handles don't allow CallbackProperties - search only for *Fcn
                    %cbNames = propNames(propCbIdx);
                end
                if iscom(obj)
                    cbs = obj.eventlisteners;
                    if ~isempty(cbs)
                        cbNamesRegistered = cbs(:,1);
                        cbData = setdiff(cbNames,cbNamesRegistered);
                        %cbData = charizeData(cbData);
                        if size(cbData,2) > size(cbData(1))
                            cbData = cbData';
                        end
                        cbData = [cbData, cellstr(repmat(' ',length(cbData),1))];
                        cbData = [cbData; cbs];
                        [sortedNames, sortedIdx] = sort(cbData(:,1));
                        sortedCbs = cellfun(@charizeData,cbData(sortedIdx,2),'un',0);
                        cbData = [sortedNames, sortedCbs];
                    else
                        cbData = [cbNames, cellstr(repmat(' ',length(cbNames),1))];
                    end
                elseif iscell(cbNames)
                    cbNames = sort(cbNames);
                    %cbData = [cbNames, get(obj,cbNames)'];
                    cbData = cbNames;
                    oldWarn = warning('off','MATLAB:hg:JavaSetHGProperty');
                    warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
                    for idx = 1 : length(cbNames)
                        try
                            cbData{idx,2} = charizeData(get(obj,cbNames{idx}));
                        catch
                            cbData{idx,2} = '(callback value inaccessible)';
                        end
                    end
                    warning(oldWarn);
                else  % only one event callback
                    %cbData = {cbNames, get(obj,cbNames)'};
                    %cbData{1,2} = charizeData(cbData{1,2});
                    try
                        cbData = {cbNames, charizeData(get(obj,cbNames))};
                    catch
                        cbData = {cbNames, '(callback value inaccessible)'};
                    end
                end
                cbHeaders = {'Callback name','Callback value'};
                cbTableEnabled = true;
            end
        catch
            % never mind - use default (empty) data
        end
    end  % getCbsData

    %% Get relative (0.0-1.0) divider location
    function divLocation = getRalativeDivlocation(jDiv)
        divLocation = jDiv.getDividerLocation;
        if divLocation > 1  % i.e. [pixels]
            visibleRect = jDiv.getVisibleRect;
            if jDiv.getOrientation == 0  % vertical
                start = visibleRect.getY;
                extent = visibleRect.getHeight - start;
            else
                start = visibleRect.getX;
                extent = visibleRect.getWidth - start;
            end
            divLocation = (divLocation - start) / extent;
        end
    end  % getRalativeDivlocation

    %% Try to set a treenode icon based on a container's icon
    function setTreeNodeIcon(treenode,container)
        try
            iconImage = [];
            iconImage = container.getIcon;
            if ~isempty(findprop(handle(iconImage),'Image'))  % get(iconImage,'Image') is easier but leaks memory...
                iconImage = iconImage.getImage;
            else
                a=b; %#ok cause an error
            end
        catch
            try
                iconImage = container.getIconImage;
            catch
                try
                    if ~isempty(iconImage)
                        ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment;
                        gd = ge.getDefaultScreenDevice;
                        gc = gd.getDefaultConfiguration;
                        image = gc.createCompatibleImage(iconImage.getIconWidth, iconImage.getIconHeight);  % a BufferedImage object
                        g = image.createGraphics;
                        iconImage.paintIcon([], g, 0, 0);
                        g.dispose;
                        iconImage = image;
                    end
                catch
                    % never mind...
                end
            end
        end
        if ~isempty(iconImage)
            iconImage = setIconSize(iconImage);
            treenode.setIcon(iconImage);
        end
    end  % setTreeNodeIcon

    %% Present the object hierarchy tree
    function presentObjectTree()
        persistent lastVersionCheck
        if isempty(lastVersionCheck),  lastVersionCheck = now-1;  end

        import java.awt.*
        import javax.swing.*
        hTreeFig = findall(0,'tag','findjobjFig');
        iconpath = [matlabroot, '/toolbox/matlab/icons/'];
        cbHideStd = 0;  % Initial state of the cbHideStdCbs checkbox
        if isempty(hTreeFig)
            % Prepare the figure
            hTreeFig = figure('tag','findjobjFig','menuBar','none','toolBar','none','Name','FindJObj','NumberTitle','off','handleVisibility','off','IntegerHandle','off');
            figIcon = ImageIcon([iconpath 'tool_legend.gif']);
            drawnow;
            try
                mde = com.mathworks.mde.desk.MLDesktop.getInstance;
                jTreeFig = mde.getClient('FindJObj').getTopLevelAncestor;
                jTreeFig.setIcon(figIcon);
            catch
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                jTreeFig = get(hTreeFig,'JavaFrame');
                jTreeFig.setFigureIcon(figIcon);
            end
            vsplitPaneLocation = 0.8;
            hsplitPaneLocation = 0.5;
        else
            % Remember cbHideStdCbs checkbox & dividers state for later
            userdata = get(hTreeFig, 'userdata');
            try cbHideStd = userdata.cbHideStdCbs.isSelected; catch, end  %#ok
            try
                vsplitPaneLocation = getRalativeDivlocation(userdata.vsplitPane);
                hsplitPaneLocation = getRalativeDivlocation(userdata.hsplitPane);
            catch
                vsplitPaneLocation = 0.8;
                hsplitPaneLocation = 0.5;
            end

            % Clear the figure and redraw
            clf(hTreeFig);
            figure(hTreeFig);   % bring to front
        end

        % Traverse all HG children, if root container was a HG handle
        if ishghandle(origContainer) %&& ~isequal(origContainer,container)
            traverseHGContainer(origContainer,0,0);
        end

        % Prepare the tree pane
        warning('off','MATLAB:uitreenode:MigratingFunction');  % R2008b compatibility
        warning('off','MATLAB:uitreenode:DeprecatedFunction'); % R2008a compatibility
        tree_h = com.mathworks.hg.peer.UITreePeer;
        try tree_h = javaObjectEDT(tree_h); catch, end
        tree_hh = handle(tree_h,'CallbackProperties');
        hasChildren = sum(allParents==1) > 1;
        icon = [iconpath 'upfolder.gif'];
        [rootName, rootTitle] = getNodeName(container);
        try
            root = uitreenode('v0', handle(container), rootName, icon, ~hasChildren);
        catch  % old matlab version don't have the 'v0' option
            root = uitreenode(handle(container), rootName, icon, ~hasChildren);
        end
        setTreeNodeIcon(root,container);  % constructor must accept a char icon unfortunately, so need to do this afterwards...
        if ~isempty(rootTitle)
            set(hTreeFig, 'Name',['FindJObj - ' char(rootTitle)]);
        end
        nodedata.idx = 1;
        nodedata.obj = container;
        set(root,'userdata',nodedata);
        root.setUserObject(container);
        setappdata(root,'childHandle',container);
        tree_h.setRoot(root);
        treePane = tree_h.getScrollPane;
        treePane.setMinimumSize(Dimension(50,50));
        jTreeObj = treePane.getViewport.getComponent(0);
        jTreeObj.setShowsRootHandles(true)
        jTreeObj.getSelectionModel.setSelectionMode(javax.swing.tree.TreeSelectionModel.DISCONTIGUOUS_TREE_SELECTION);
        %jTreeObj.setVisible(0);
        %jTreeObj.getCellRenderer.setLeafIcon([]);
        %jTreeObj.getCellRenderer.setOpenIcon(figIcon);
        %jTreeObj.getCellRenderer.setClosedIcon([]);
        treePanel = JPanel(BorderLayout);
        treePanel.add(treePane, BorderLayout.CENTER);
        progressBar = JProgressBar(0);
        progressBar.setMaximum(length(allHandles) + length(hg_handles));  % = # of all nodes
        treePanel.add(progressBar, BorderLayout.SOUTH);

        % Prepare the image pane
%disable for now, until we get it working...
%{
        try
            hFig = ancestor(origContainer,'figure');
            [cdata, cm] = getframe(hFig);  %#ok cm unused
            tempfname = [tempname '.png'];
            imwrite(cdata,tempfname);  % don't know how to pass directly to BufferedImage, so use disk...
            jImg = javax.imageio.ImageIO.read(java.io.File(tempfname));
            try delete(tempfname);  catch  end
            imgPanel = JPanel();
            leftPanel = JSplitPane(JSplitPane.VERTICAL_SPLIT, treePanel, imgPanel);
            leftPanel.setOneTouchExpandable(true);
            leftPanel.setContinuousLayout(true);
            leftPanel.setResizeWeight(0.8);
        catch
            leftPanel = treePanel;
        end
%}
        leftPanel = treePanel;

        % Prepare the inspector pane
        classNameLabel = JLabel(['      ' char(class(container))]);
        classNameLabel.setForeground(Color.blue);
        updateNodeTooltip(container, classNameLabel);
        inspectorPanel = JPanel(BorderLayout);
        inspectorPanel.add(classNameLabel, BorderLayout.NORTH);
        % TODO: Maybe uncomment the following when we add the HG tree - in the meantime it's unused (java properties are un-groupable)
        %objReg = com.mathworks.services.ObjectRegistry.getLayoutRegistry;
        %toolBar = awtinvoke('com.mathworks.mlwidgets.inspector.PropertyView$ToolBarStyle','valueOf(Ljava.lang.String;)','GROUPTOOLBAR');
        %inspectorPane = com.mathworks.mlwidgets.inspector.PropertyView(objReg, toolBar);
        inspectorPane = com.mathworks.mlwidgets.inspector.PropertyView;
        identifiers = disableDbstopError;  %#ok "dbstop if error" causes inspect.m to croak due to a bug - so workaround
        inspectorPane.setObject(container);
        inspectorPane.setAutoUpdate(true);
        % TODO: Add property listeners
        % TODO: Display additional props
        inspectorTable = inspectorPane;
        try
            while ~isa(inspectorTable,'javax.swing.JTable')
                inspectorTable = inspectorTable.getComponent(0);
            end
        catch
            % R2010a
            inspectorTable = inspectorPane.getComponent(0).getScrollPane.getViewport.getComponent(0);
        end
        toolTipText = 'hover mouse over the red classname above to see the full list of properties';
        inspectorTable.setToolTipText(toolTipText);
        jideTableUtils = [];
        try
            % Try JIDE features - see http://www.jidesoft.com/products/JIDE_Grids_Developer_Guide.pdf
            com.mathworks.mwswing.MJUtilities.initJIDE;
            jideTableUtils = eval('com.jidesoft.grid.TableUtils;');  % prevent JIDE alert by run-time (not load-time) evaluation
            jideTableUtils.autoResizeAllColumns(inspectorTable);
            inspectorTable.setRowAutoResizes(true);
            inspectorTable.getModel.setShowExpert(1);
        catch
            % JIDE is probably unavailable - never mind...
        end
        inspectorPanel.add(inspectorPane, BorderLayout.CENTER);
        % TODO: Add data update listeners

        % Prepare the callbacks pane
        callbacksPanel = JPanel(BorderLayout);
        stripStdCbsFlag = true;  % initial value
        [cbData, cbHeaders, cbTableEnabled] = getCbsData(container, stripStdCbsFlag);
        %{
        %classHdl = classhandle(handle(container));
        %eventNames = get(classHdl.Events,'Name');
        %if ~isempty(eventNames)
        %    cbNames = sort(strcat(eventNames,'Callback'));
        %    try
        %        cbData = [cbNames, get(container,cbNames)'];
        %    catch
        %        % R2010a
        %        cbData = cbNames;
        %        if isempty(cbData)
        %            cbData = {};
        %        elseif ~iscell(cbData)
        %            cbData = {cbData};
        %        end
        %        for idx = 1 : length(cbNames)
        %            cbData{idx,2} = get(container,cbNames{idx});
        %        end
        %    end
        %    cbTableEnabled = true;
        %else
        %    cbData = {'(no callbacks)',''};
        %    cbTableEnabled = false;
        %end
        %cbHeaders = {'Callback name','Callback value'};
        %}
        try
            % Use JideTable if available on this system
            %callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);  %#ok
            %callbacksTable = eval('com.jidesoft.grid.PropertyTable(callbacksTableModel);');  % prevent JIDE alert by run-time (not load-time) evaluation
            try
                list = getTreeData(cbData);  %#ok
                model = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation

                % Auto-expand if only one category
                if model.getRowCount==1   % length(model.getCategories)==1 fails for some unknown reason...
                    model.expandFirstLevel;
                end

                %callbacksTable = eval('com.jidesoft.grid.TreeTable(model);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                callbacksTable = eval('com.jidesoft.grid.PropertyTable(model);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation

                %callbacksTable.expandFirstLevel;
                callbacksTable.setShowsRootHandles(true);
                callbacksTable.setShowTreeLines(false);
                %callbacksTable.setShowNonEditable(0);  %=SHOW_NONEDITABLE_NEITHER
                callbacksPane = eval('com.jidesoft.grid.PropertyPane(callbacksTable);');  % prevent JIDE alert by run-time (not load-time) evaluation
                callbacksPane.setShowDescription(false);
            catch
                callbacksTable = eval('com.jidesoft.grid.TreeTable(cbData,cbHeaders);');  % prevent JIDE alert by run-time (not load-time) evaluation
            end
            callbacksTable.setRowAutoResizes(true);
            callbacksTable.setColumnAutoResizable(true);
            callbacksTable.setColumnResizable(true);
            jideTableUtils.autoResizeAllColumns(callbacksTable);
            callbacksTable.setTableHeader([]);  % hide the column headers since now we can resize columns with the gridline
            callbacksLabel = JLabel(' Callbacks:');  % The column headers are replaced with a header label
            callbacksLabel.setForeground(Color.blue);
            %callbacksPanel.add(callbacksLabel, BorderLayout.NORTH);

            % Add checkbox to show/hide standard callbacks
            callbacksTopPanel = JPanel;
            callbacksTopPanel.setLayout(BoxLayout(callbacksTopPanel, BoxLayout.LINE_AXIS));
            callbacksTopPanel.add(callbacksLabel);
            callbacksTopPanel.add(Box.createHorizontalGlue);
            jcb = JCheckBox('Hide standard callbacks', cbHideStd);
            set(handle(jcb,'CallbackProperties'), 'ActionPerformedCallback',{@cbHideStdCbs_Callback,callbacksTable});
            try
                set(jcb, 'userdata',callbacksTable, 'tooltip','Hide standard Swing callbacks - only component-specific callbacks will be displayed');
            catch
                jcb.setToolTipText('Hide standard Swing callbacks - only component-specific callbacks will be displayed');
                %setappdata(jcb,'userdata',callbacksTable);
            end
            callbacksTopPanel.add(jcb);
            callbacksPanel.add(callbacksTopPanel, BorderLayout.NORTH);
        catch
            % Otherwise, use a standard Swing JTable (keep the headers to enable resizing)
            callbacksTable = JTable(cbData,cbHeaders);
        end
        cbToolTipText = 'Callbacks may be ''strings'', @funcHandle or {@funcHandle,arg1,...}';
        callbacksTable.setToolTipText(cbToolTipText);
        callbacksTable.setGridColor(inspectorTable.getGridColor);
        cbNameTextField = JTextField;
        cbNameTextField.setEditable(false);  % ensure that the callback names are not modified...
        cbNameCellEditor = DefaultCellEditor(cbNameTextField);
        cbNameCellEditor.setClickCountToStart(intmax);  % i.e, never enter edit mode...
        callbacksTable.getColumnModel.getColumn(0).setCellEditor(cbNameCellEditor);
        if ~cbTableEnabled
            callbacksTable.getColumnModel.getColumn(1).setCellEditor(cbNameCellEditor);
        end
        hModel = callbacksTable.getModel;
        set(handle(hModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,container,callbacksTable});
        %set(hModel, 'UserData',container);
        try
            cbScrollPane = callbacksPane; %JScrollPane(callbacksPane);
            %cbScrollPane.setHorizontalScrollBarPolicy(cbScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        catch
            cbScrollPane = JScrollPane(callbacksTable);
            cbScrollPane.setVerticalScrollBarPolicy(cbScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        end
        callbacksPanel.add(cbScrollPane, BorderLayout.CENTER);
        callbacksPanel.setToolTipText(cbToolTipText);

        % Prepare the top-bottom JSplitPanes
        vsplitPane = JSplitPane(JSplitPane.VERTICAL_SPLIT, inspectorPanel, callbacksPanel);
        vsplitPane.setOneTouchExpandable(true);
        vsplitPane.setContinuousLayout(true);
        vsplitPane.setResizeWeight(0.8);

        % Prepare the left-right JSplitPane
        hsplitPane = JSplitPane(JSplitPane.HORIZONTAL_SPLIT, leftPanel, vsplitPane);
        hsplitPane.setOneTouchExpandable(true);
        hsplitPane.setContinuousLayout(true);
        hsplitPane.setResizeWeight(0.6);
        pos = getpixelposition(hTreeFig);

        % Prepare the bottom pane with all buttons
        lowerPanel = JPanel(FlowLayout);
        blogUrlLabel = '<a href="http://UndocumentedMatlab.com">Undocumented<br>Matlab.com</a>';
        jWebsite = createJButton(blogUrlLabel, @btWebsite_Callback, 'Visit the UndocumentedMatlab.com blog');
        jWebsite.setContentAreaFilled(0);
        lowerPanel.add(jWebsite);
        lowerPanel.add(createJButton('Refresh<br>tree',        {@btRefresh_Callback, origContainer, hTreeFig}, 'Rescan the component tree, from the root down'));
        lowerPanel.add(createJButton('Export to<br>workspace', {@btExport_Callback,  jTreeObj, classNameLabel}, 'Export the selected component handles to workspace variable findjobj_hdls'));
        lowerPanel.add(createJButton('Request<br>focus',       {@btFocus_Callback,   jTreeObj, root}, 'Set the focus on the first selected component'));
        lowerPanel.add(createJButton('Inspect<br>object',      {@btInspect_Callback, jTreeObj, root}, 'View the signature of all methods supported by the first selected component'));
        lowerPanel.add(createJButton('Check for<br>updates',   {@btCheckFex_Callback}, 'Check the MathWorks FileExchange for the latest version of FindJObj'));

        % Display everything on-screen
        globalPanel = JPanel(BorderLayout);
        globalPanel.add(hsplitPane, BorderLayout.CENTER);
        globalPanel.add(lowerPanel, BorderLayout.SOUTH);
        [obj, hcontainer] = javacomponent(globalPanel, [0,0,pos(3:4)], hTreeFig);
        set(hcontainer,'units','normalized');
        drawnow;
        hsplitPane.setDividerLocation(hsplitPaneLocation);  % this only works after the JSplitPane is displayed...
        vsplitPane.setDividerLocation(vsplitPaneLocation);  % this only works after the JSplitPane is displayed...
        %restoreDbstopError(identifiers);

        % Refresh & resize the screenshot thumbnail
%disable for now, until we get it working...
%{
        try
            hAx = axes('Parent',hTreeFig, 'units','pixels', 'position',[10,10,250,150], 'visible','off');
            axis(hAx,'image');
            image(cdata,'Parent',hAx);
            axis(hAx,'off');
            set(hAx,'UserData',cdata);
            set(imgPanel, 'ComponentResizedCallback',{@resizeImg, hAx}, 'UserData',lowerPanel);
            imgPanel.getGraphics.drawImage(jImg, 0, 0, []);
        catch
            % Never mind...
        end
%}
        % If all handles were selected (i.e., none were filtered) then only select the first
        if (length(selectedIdx) == length(allHandles)) && ~isempty(selectedIdx)
            selectedIdx = 1;
        end

        % Store handles for callback use
        userdata.handles = allHandles;
        userdata.levels  = allLevels;
        userdata.parents = allParents;
        userdata.hg_handles = hg_handles;
        userdata.hg_levels  = hg_levels;
        userdata.hg_parents = hg_parentIdx;
        userdata.initialIdx = selectedIdx;
        userdata.userSelected = false;  % Indicates the user has modified the initial selections
        userdata.inInit = true;
        userdata.jTree = jTreeObj;
        userdata.jTreePeer = tree_h;
        userdata.vsplitPane = vsplitPane;
        userdata.hsplitPane = hsplitPane;
        userdata.classNameLabel = classNameLabel;
        userdata.inspectorPane = inspectorPane;
        userdata.callbacksTable = callbacksTable;
        userdata.jideTableUtils = jideTableUtils;
        try
            userdata.cbHideStdCbs = jcb;
        catch
            userdata.cbHideStdCbs = [];
        end

        % Update userdata for use in callbacks
        try
            set(tree_h,'userdata',userdata);
        catch
            setappdata(handle(tree_h),'userdata',userdata);
        end
        try
            set(callbacksTable,'userdata',userdata);
        catch
            setappdata(callbacksTable,'userdata',userdata);
        end
        set(hTreeFig,'userdata',userdata);

        % Select the root node if requested
        % Note: we must do so here since all other nodes except the root are processed by expandNode
        if any(selectedIdx==1)
            tree_h.setSelectedNode(root);
        end

        % Set the initial cbHideStdCbs state
        try
            if jcb.isSelected
                drawnow;
                evd.getSource.isSelected = jcb.isSelected;
                cbHideStdCbs_Callback(jcb,evd,callbacksTable);
            end
        catch
            % never mind...
        end

        % Set the callback functions
        set(tree_hh, 'NodeExpandedCallback', {@nodeExpanded, tree_h});
        set(tree_hh, 'NodeSelectedCallback', {@nodeSelected, tree_h});

        % Set the tree mouse-click callback
        % Note: default actions (expand/collapse) will still be performed?
        % Note: MousePressedCallback is better than MouseClickedCallback
        %       since it fires immediately when mouse button is pressed,
        %       without waiting for its release, as MouseClickedCallback does
        handleTree = tree_h.getScrollPane;
        jTreeObj = handleTree.getViewport.getComponent(0);
        jTreeObjh = handle(jTreeObj,'CallbackProperties');
        set(jTreeObjh, 'MousePressedCallback', {@treeMousePressedCallback,tree_h});  % context (right-click) menu
        set(jTreeObjh, 'MouseMovedCallback',   @treeMouseMovedCallback);    % mouse hover tooltips

        % Update userdata
        userdata.inInit = false;
        try
            set(tree_h,'userdata',userdata);
        catch
            setappdata(handle(tree_h),'userdata',userdata);
        end
        set(hTreeFig,'userdata',userdata);

        % Pre-expand all rows
        %treePane.setVisible(false);
        expandNode(progressBar, jTreeObj, tree_h, root, 0);
        %treePane.setVisible(true);
        %jTreeObj.setVisible(1);

        % Hide the progressbar now that we've finished expanding all rows
        try
            hsplitPane.getLeftComponent.setTopComponent(treePane);
        catch
            % Probably not a vSplitPane on the left...
            hsplitPane.setLeftComponent(treePane);
        end
        hsplitPane.setDividerLocation(hsplitPaneLocation);  % need to do it again...

        % Set keyboard focus on the tree
        jTreeObj.requestFocus;
        drawnow;

        % Check for a newer version (only in non-deployed mode, and only twice a day)
        if ~isdeployed && now-lastVersionCheck > 0.5
            checkVersion();
            lastVersionCheck = now;
        end

        % Reset the last error
        lasterr('');  %#ok
    end

    %% Rresize image pane
    function resizeImg(varargin)  %#ok - unused (TODO: waiting for img placement fix...)
        try
            hPanel = varargin{1};
            hAx    = varargin{3};
            lowerPanel = get(hPanel,'UserData');
            newJPos = cell2mat(get(hPanel,{'X','Y','Width','Height'}));
            newMPos = [1,get(lowerPanel,'Height'),newJPos(3:4)];
            set(hAx, 'units','pixels', 'position',newMPos, 'Visible','on');
            uistack(hAx,'top');  % no good...
            set(hPanel,'Opaque','off');  % also no good...
        catch
            % Never mind...
            dispError
        end
        return;
    end

    %% "dbstop if error" causes inspect.m to croak due to a bug - so workaround by temporarily disabling this dbstop
    function identifiers = disableDbstopError
        dbStat = dbstatus;
        idx = find(strcmp({dbStat.cond},'error'));
        identifiers = [dbStat(idx).identifier];
        if ~isempty(idx)
            dbclear if error;
            msgbox('''dbstop if error'' had to be disabled due to a Matlab bug that would have caused Matlab to crash.', 'FindJObj', 'warn');
        end
    end

    %% Restore any previous "dbstop if error"
    function restoreDbstopError(identifiers)  %#ok
        for itemIdx = 1 : length(identifiers)
            eval(['dbstop if error ' identifiers{itemIdx}]);
        end
    end

    %% Recursively expand all nodes (except toolbar/menubar) in startup
    function expandNode(progressBar, tree, tree_h, parentNode, parentRow)
        try
            if nargin < 5
                parentPath = javax.swing.tree.TreePath(parentNode.getPath);
                parentRow = tree.getRowForPath(parentPath);
            end
            tree.expandRow(parentRow);
            progressBar.setValue(progressBar.getValue+1);
            numChildren = parentNode.getChildCount;
            if (numChildren == 0)
                pause(0.0002);  % as short as possible...
                drawnow;
            end
            nodesToUnExpand = {'FigureMenuBar','MLMenuBar','MJToolBar','Box','uimenu','uitoolbar','ScrollBar'};
            numChildren = parentNode.getChildCount;
            for childIdx = 0 : numChildren-1
                childNode = parentNode.getChildAt(childIdx);

                % Pre-select the node based upon the user's FINDJOBJ filters
                try
                    nodedata = get(childNode, 'userdata');
                    try
                        userdata = get(tree_h, 'userdata');
                    catch
                        userdata = getappdata(handle(tree_h), 'userdata');
                    end
                    %fprintf('%d - %s\n',nodedata.idx,char(nodedata.obj))
                    if ~ishghandle(nodedata.obj) && ~userdata.userSelected && any(userdata.initialIdx == nodedata.idx)
                        pause(0.0002);  % as short as possible...
                        drawnow;
                        if isempty(tree_h.getSelectedNodes)
                            tree_h.setSelectedNode(childNode);
                        else
                            newSelectedNodes = [tree_h.getSelectedNodes, childNode];
                            tree_h.setSelectedNodes(newSelectedNodes);
                        end
                    end
                catch
                    % never mind...
                    dispError
                end

                % Expand child node if not leaf & not toolbar/menubar
                if childNode.isLeafNode

                    % This is a leaf node, so simply update the progress-bar
                    progressBar.setValue(progressBar.getValue+1);

                else
                    % Expand all non-leaves
                    expandNode(progressBar, tree, tree_h, childNode);

                    % Re-collapse toolbar/menubar etc., and also invisible containers
                    % Note: if we simply did nothing, progressbar would not have been updated...
                    try
                        childHandle = getappdata(childNode,'childHandle');  %=childNode.getUserObject
                        visible = childHandle.isVisible;
                    catch
                        visible = 1;
                    end
                    visible = visible && isempty(findstr(get(childNode,'Name'),'color="gray"'));
                    %if any(strcmp(childNode.getName,nodesToUnExpand))
                    %name = char(childNode.getName);
                    if any(cellfun(@(s)~isempty(strmatch(s,char(childNode.getName))),nodesToUnExpand)) || ~visible
                        childPath = javax.swing.tree.TreePath(childNode.getPath);
                        childRow = tree.getRowForPath(childPath);
                        tree.collapseRow(childRow);
                    end
                end
            end
        catch
            % never mind...
            dispError
        end
    end

    %% Create utility buttons
    function hButton = createJButton(nameStr, handler, toolTipText)
        try
            jButton = javax.swing.JButton(['<html><body><center>' nameStr]);
            jButton.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
            jButton.setToolTipText(toolTipText);
            try
                minSize = jButton.getMinimumSize;
            catch
                minSize = jButton.getMinimumSize;  % for HG2 - strange indeed that this is needed!
            end
            jButton.setMinimumSize(java.awt.Dimension(minSize.getWidth,35));
            hButton = handle(jButton,'CallbackProperties');
            set(hButton,'ActionPerformedCallback',handler);
        catch
            % Never mind...
            a= 1;
        end
    end

    %% Flash a component off/on for the specified duration
    % note: starts with 'on'; if numTimes is odd then ends with 'on', otherwise with 'off'
    function flashComponent(jComps,delaySecs,numTimes)
        persistent redBorder redBorderPanels
        try
            % Handle callback data from right-click (context-menu)
            if iscell(numTimes)
                [jComps,delaySecs,numTimes] = deal(numTimes{:});
            end

            if isempty(redBorder)  % reuse if possible
                redBorder = javax.swing.border.LineBorder(java.awt.Color.red,2,0);
            end
            for compIdx = 1 : length(jComps)
                try
                    oldBorder{compIdx} = jComps(compIdx).getBorder;  %#ok grow
                catch
                    oldBorder{compIdx} = [];  %#ok grow
                end
                isSettable(compIdx) = ismethod(jComps(compIdx),'setBorder');  %#ok grow
                if isSettable(compIdx)
                    try
                        % some components prevent border modification:
                        oldBorderFlag = jComps(compIdx).isBorderPainted;
                        if ~oldBorderFlag
                            jComps(compIdx).setBorderPainted(1);
                            isSettable(compIdx) = jComps(compIdx).isBorderPainted;  %#ok grow
                            jComps(compIdx).setBorderPainted(oldBorderFlag);
                        end
                    catch
                        % do nothing...
                    end
                end
                if compIdx > length(redBorderPanels)
                    redBorderPanels{compIdx} = javax.swing.JPanel;
                    redBorderPanels{compIdx}.setBorder(redBorder);
                    redBorderPanels{compIdx}.setOpaque(0);  % transparent interior, red border
                end
                try
                    redBorderPanels{compIdx}.setBounds(jComps(compIdx).getBounds);
                catch
                    % never mind - might be an HG handle
                end
            end
            for idx = 1 : 2*numTimes
                if idx>1,  pause(delaySecs);  end  % don't pause at start
                visible = mod(idx,2);
                for compIdx = 1 : length(jComps)
                    try
                        jComp = jComps(compIdx);

                        % Prevent Matlab crash (java buffer overflow...)
                        if isa(jComp,'com.mathworks.mwswing.desk.DTSplitPane') || ...
                           isa(jComp,'com.mathworks.mwswing.MJSplitPane')
                            continue;

                        % HG handles are highlighted by setting their 'Selected' property
                        elseif isa(jComp,'uimenu')
                            if visible
                                oldColor = get(jComp,'ForegroundColor');
                                setappdata(jComp,'findjobj_oldColor',oldColor);
                                set(jComp,'ForegroundColor','red');
                            else
                                oldColor = getappdata(jComp,'findjobj_oldColor');
                                set(jComp,'ForegroundColor',oldColor);
                                rmappdata(jComp,'ForegroundColor');
                            end

                        elseif ishghandle(jComp)
                            if visible
                                set(jComp,'Selected','on');
                            else
                                set(jComp,'Selected','off');
                            end

                        else %if isjava(jComp)

                            jParent = jComps(compIdx).getParent;

                            % Most Java components allow modifying their borders
                            if isSettable(compIdx)
                                if visible
                                    jComp.setBorder(redBorder);
                                    try jComp.setBorderPainted(1); catch, end  %#ok
                                else %if ~isempty(oldBorder{compIdx})
                                    jComp.setBorder(oldBorder{compIdx});
                                end
                                jComp.repaint;

                            % The other Java components are highlighted by a transparent red-border
                            % panel that is placed on top of them in their parent's space
                            elseif ~isempty(jParent)
                                if visible
                                    jParent.add(redBorderPanels{compIdx});
                                    jParent.setComponentZOrder(redBorderPanels{compIdx},0);
                                else
                                    jParent.remove(redBorderPanels{compIdx});
                                end
                                jParent.repaint
                            end
                        end
                    catch
                        % never mind - try the next component (if any)
                    end
                end
                drawnow;
            end
        catch
            % never mind...
            dispError;
        end
        return;  % debug point
    end  % flashComponent

    %% Select tree node
    function nodeSelected(src, evd, tree)  %#ok
        try
            if iscell(tree)
                [src,node] = deal(tree{:});
            else
                node = evd.getCurrentNode;
            end
            %nodeHandle = node.getUserObject;
            nodedata = get(node,'userdata');
            nodeHandle = nodedata.obj;
            try
                userdata = get(src,'userdata');
            catch
                try
                    userdata = getappdata(java(src),'userdata');
                catch
                    userdata = getappdata(src,'userdata');
                end
                if isempty(userdata)
                    try userdata = get(java(src),'userdata'); catch, end
                end
            end
            if ~isempty(nodeHandle) && ~isempty(userdata)
                numSelections  = userdata.jTree.getSelectionCount;
                selectionPaths = userdata.jTree.getSelectionPaths;
                if (numSelections == 1)
                    % Indicate that the user has modified the initial selection (except if this was an initial auto-selected node)
                    if ~userdata.inInit
                        userdata.userSelected = true;
                        try
                            set(src,'userdata',userdata);
                        catch
                            try
                                setappdata(java(src),'userdata',userdata);
                            catch
                                setappdata(src,'userdata',userdata);
                            end
                        end
                    end

                    % Update the fully-qualified class name label
                    numInitialIdx = length(userdata.initialIdx);
                    thisHandle = nodeHandle;
                    try
                        if ~ishghandle(thisHandle)
                            thisHandle = java(nodeHandle);
                        end
                    catch
                        % never mind...
                    end
                    if ~userdata.inInit || (numInitialIdx == 1)
                        userdata.classNameLabel.setText(['      ' char(class(thisHandle))]);
                    else
                        userdata.classNameLabel.setText([' ' num2str(numInitialIdx) 'x handles (some handles hidden by unexpanded tree nodes)']);
                    end
                    if ishghandle(thisHandle)
                        userdata.classNameLabel.setText(userdata.classNameLabel.getText.concat(' (HG handle)'));
                    end
                    userdata.inspectorPane.dispose;  % remove props listeners - doesn't work...
                    updateNodeTooltip(nodeHandle, userdata.classNameLabel);

                    % Update the data properties inspector pane
                    % Note: we can't simply use the evd nodeHandle, because this node might have been DE-selected with only one other node left selected...
                    %nodeHandle = selectionPaths(1).getLastPathComponent.getUserObject;
                    nodedata = get(selectionPaths(1).getLastPathComponent,'userdata');
                    nodeHandle = nodedata.obj;
                    %identifiers = disableDbstopError;  % "dbstop if error" causes inspect.m to croak due to a bug - so workaround
                    userdata.inspectorPane.setObject(thisHandle);

                    % Update the callbacks table
                    try
                        stripStdCbsFlag = getappdata(userdata.callbacksTable,'hideStdCbs');
                        [cbData, cbHeaders, cbTableEnabled] = getCbsData(nodeHandle, stripStdCbsFlag);  %#ok cbTableEnabled unused
                        try
                            % Use JideTable if available on this system
                            list = getTreeData(cbData);  %#ok
                            callbacksTableModel = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                            
                            % Expand if only one category
                            if length(callbacksTableModel.getCategories)==1
                                callbacksTableModel.expandFirstLevel;
                            end
                        catch
                            callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);
                        end
                        set(handle(callbacksTableModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,nodeHandle,userdata.callbacksTable});
                        %set(callbacksTableModel, 'UserData',nodeHandle);
                        userdata.callbacksTable.setModel(callbacksTableModel)
                        userdata.callbacksTable.setRowAutoResizes(true);
                        userdata.jideTableUtils.autoResizeAllColumns(userdata.callbacksTable);
                    catch
                        % never mind...
                        %dispError
                    end
                    pause(0.005);
                    drawnow;
                    %restoreDbstopError(identifiers);

                    % Highlight the selected object (if visible)
                    flashComponent(nodeHandle,0.2,3);

                elseif (numSelections > 1)  % Multiple selections

                    % Get the list of all selected nodes
                    jArray = javaArray('java.lang.Object', numSelections);
                    toolTipStr = '<html>';
                    sameClassFlag = true;
                    for idx = 1 : numSelections
                        %jArray(idx) = selectionPaths(idx).getLastPathComponent.getUserObject;
                        nodedata = get(selectionPaths(idx).getLastPathComponent,'userdata');
                        try
                            if ishghandle(nodedata.obj)
                                if idx==1
                                    jArray = nodedata.obj;
                                else
                                    jArray(idx) = nodedata.obj;
                                end
                            else
                                jArray(idx) = java(nodedata.obj);
                            end
                        catch
                            jArray(idx) = nodedata.obj;
                        end
                        toolTipStr = [toolTipStr '&nbsp;' class(jArray(idx)) '&nbsp;'];  %#ok grow
                        if (idx < numSelections),  toolTipStr = [toolTipStr '<br>'];  end  %#ok grow
                        try
                            if (idx > 1) && sameClassFlag && ~isequal(jArray(idx).getClass,jArray(1).getClass)
                                sameClassFlag = false;
                            end
                        catch
                            if (idx > 1) && sameClassFlag && ~isequal(class(jArray(idx)),class(jArray(1)))
                                sameClassFlag = false;
                            end
                        end
                    end
                    toolTipStr = [toolTipStr '</html>'];

                    % Update the fully-qualified class name label
                    if sameClassFlag
                        classNameStr = class(jArray(1));
                    else
                        classNameStr = 'handle';
                    end
                    if all(ishghandle(jArray))
                        if strcmp(classNameStr,'handle')
                            classNameStr = 'HG handles';
                        else
                            classNameStr = [classNameStr ' (HG handles)'];
                        end
                    end
                    classNameStr = [' ' num2str(numSelections) 'x ' classNameStr];
                    userdata.classNameLabel.setText(classNameStr);
                    userdata.classNameLabel.setToolTipText(toolTipStr);

                    % Update the data properties inspector pane
                    %identifiers = disableDbstopError;  % "dbstop if error" causes inspect.m to croak due to a bug - so workaround
                    if isjava(jArray)
                        jjArray = jArray;
                    else
                        jjArray = javaArray('java.lang.Object', numSelections);
                        for idx = 1 : numSelections
                            jjArray(idx) = java(jArray(idx));
                        end
                    end
                    userdata.inspectorPane.getRegistry.setSelected(jjArray, true);

                    % Update the callbacks table
                    try
                        % Get intersecting callback names & values
                        stripStdCbsFlag = getappdata(userdata.callbacksTable,'hideStdCbs');
                        [cbData, cbHeaders, cbTableEnabled] = getCbsData(jArray(1), stripStdCbsFlag);  %#ok cbHeaders & cbTableEnabled unused
                        if ~isempty(cbData)
                            cbNames = cbData(:,1);
                            for idx = 2 : length(jArray)
                                [cbData2, cbHeaders2] = getCbsData(jArray(idx), stripStdCbsFlag);  %#ok cbHeaders2 unused
                                if ~isempty(cbData2)
                                    newCbNames = cbData2(:,1);
                                    [cbNames, cbIdx, cb2Idx] = intersect(cbNames,newCbNames);  %#ok cb2Idx unused
                                    cbData = cbData(cbIdx,:);
                                    for cbIdx = 1 : length(cbNames)
                                        newIdx = find(strcmp(cbNames{cbIdx},newCbNames));
                                        if ~isequal(cbData2,cbData) && ~isequal(cbData2{newIdx,2}, cbData{cbIdx,2})
                                            cbData{cbIdx,2} = '<different values>';
                                        end
                                    end
                                else
                                    cbData = cbData([],:);  %=empty cell array
                                end
                                if isempty(cbData)
                                    break;
                                end
                            end
                        end
                        cbHeaders = {'Callback name','Callback value'};
                        try
                            % Use JideTable if available on this system
                            list = getTreeData(cbData);  %#ok
                            callbacksTableModel = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                            
                            % Expand if only one category
                            if length(callbacksTableModel.getCategories)==1
                                callbacksTableModel.expandFirstLevel;
                            end
                        catch
                            callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);
                        end
                        set(handle(callbacksTableModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,jArray,userdata.callbacksTable});
                        %set(callbacksTableModel, 'UserData',jArray);
                        userdata.callbacksTable.setModel(callbacksTableModel)
                        userdata.callbacksTable.setRowAutoResizes(true);
                        userdata.jideTableUtils.autoResizeAllColumns(userdata.callbacksTable);
                    catch
                        % never mind...
                        dispError
                    end

                    pause(0.005);
                    drawnow;
                    %restoreDbstopError(identifiers);

                    % Highlight the selected objects (if visible)
                    flashComponent(jArray,0.2,3);
                end

                % TODO: Auto-highlight selected object (?)
                %nodeHandle.requestFocus;
            end
        catch
            dispError
        end
    end

    %% IFF utility function for annonymous cellfun funcs
    function result = iff(test,trueVal,falseVal)  %#ok
        try
            if test
                result = trueVal;
            else
                result = falseVal;
            end
        catch
            result = false;
        end
    end

    %% Get an HTML representation of the object's properties
    function dataFieldsStr = getPropsHtml(nodeHandle, dataFields)
        try
            % Get a text representation of the fieldnames & values
            undefinedStr = '';
            hiddenStr = '';
            dataFieldsStr = '';  % just in case the following croaks...
            if isempty(dataFields)
                return;
            end
            dataFieldsStr = evalc('disp(dataFields)');
            if dataFieldsStr(end)==char(10),  dataFieldsStr=dataFieldsStr(1:end-1);  end

            % Strip out callbacks
            dataFieldsStr = regexprep(dataFieldsStr,'^\s*\w*Callback(Data)?:[^\n]*$','','lineanchors');

            % Strip out internal HG2 mirror properties
            dataFieldsStr = regexprep(dataFieldsStr,'^\s*\w*_I:[^\n]*$','','lineanchors');
            dataFieldsStr = regexprep(dataFieldsStr,'\n\n+','\n');

            % Sort the fieldnames
            %fieldNames = fieldnames(dataFields);
            try
                [a,b,c,d] = regexp(dataFieldsStr,'(\w*): ');
                fieldNames = strrep(d,': ','');
            catch
                fieldNames = fieldnames(dataFields);
            end
            try
                [fieldNames, sortedIdx] = sort(fieldNames);
                s = strsplit(dataFieldsStr, sprintf('\n'))';
                dataFieldsStr = strjoin(s(sortedIdx), sprintf('\n'));
            catch
                % never mind... - ignore, leave unsorted
            end

            % Convert into a Matlab handle()
            %nodeHandle = handle(nodeHandle);
            try
                % ensure this is a Matlab handle, not a java object
                nodeHandle = handle(nodeHandle, 'CallbackProperties');
            catch
                try
                    % HG handles don't allow CallbackProperties...
                    nodeHandle = handle(nodeHandle);
                catch
                    % Some Matlab class objects simply cannot be converted into a handle()
                end
            end

            % HTMLize tooltip data
            % First, set the fields' font based on its read-write status
            for fieldIdx = 1 : length(fieldNames)
                thisFieldName = fieldNames{fieldIdx};
                %accessFlags = get(findprop(nodeHandle,thisFieldName),'AccessFlags');
                try
                    hProp = findprop(nodeHandle,thisFieldName);
                    accessFlags = get(hProp,'AccessFlags');
                    visible = get(hProp,'Visible');
                catch
                    accessFlags = [];
                    visible = 'on';
                    try if hProp.Hidden, visible='off'; end, catch, end
                end
                %if isfield(accessFlags,'PublicSet') && strcmp(accessFlags.PublicSet,'on')
                if (~isempty(hProp) && isprop(hProp,'SetAccess') && isequal(hProp.SetAccess,'public')) || ...  % isequal(...'public') and not strcmpi(...) because might be a cell array of classes
                   (~isempty(accessFlags) && isfield(accessFlags,'PublicSet') && strcmpi(accessFlags.PublicSet,'on'))
                    % Bolden read/write fields
                    thisFieldFormat = ['<b>' thisFieldName '</b>:$2'];
                %elseif ~isfield(accessFlags,'PublicSet')
                elseif (isempty(hProp) || ~isprop(hProp,'SetAccess')) && ...
                       (isempty(accessFlags) || ~isfield(accessFlags,'PublicSet'))
                    % Undefined - probably a Matlab-defined field of com.mathworks.hg.peer.FigureFrameProxy...
                    thisFieldFormat = ['<font color="blue">' thisFieldName '</font>:$2'];
                    undefinedStr = ', <font color="blue">undefined</font>';
                else % PublicSet=='off'
                    % Gray-out & italicize any read-only fields
                    thisFieldFormat = ['<font color="#C0C0C0">' thisFieldName '</font>:<font color="#C0C0C0">$2</font>'];
                end
                if strcmpi(visible,'off')
                    %thisFieldFormat = ['<i>' thisFieldFormat '</i>']; %#ok<AGROW>
                    thisFieldFormat = regexprep(thisFieldFormat, {'(.*):(.*)','<.?b>'}, {'<i>$1:<i>$2',''}); %'(.*):(.*)', '<i>$1:<i>$2');
                    hiddenStr = ', <i>hidden</i>';
                end
                dataFieldsStr = regexprep(dataFieldsStr, ['([\s\n])' thisFieldName ':([^\n]*)'], ['$1' thisFieldFormat]);
            end
        catch
            % never mind... - probably an ambiguous property name
            %dispError
        end

        % Method 1: simple <br> list
        %dataFieldsStr = strrep(dataFieldsStr,char(10),'&nbsp;<br>&nbsp;&nbsp;');

        % Method 2: 2-column <table>
        dataFieldsStr = regexprep(dataFieldsStr, '^\s*([^:]+:)([^\n]*)\n^\s*([^:]+:)([^\n]*)$', '<tr><td>&nbsp;$1</td><td>&nbsp;$2</td><td>&nbsp;&nbsp;&nbsp;&nbsp;$3</td><td>&nbsp;$4&nbsp;</td></tr>', 'lineanchors');
        dataFieldsStr = regexprep(dataFieldsStr, '^[^<]\s*([^:]+:)([^\n]*)$', '<tr><td>&nbsp;$1</td><td>&nbsp;$2</td><td>&nbsp;</td><td>&nbsp;</td></tr>', 'lineanchors');
        dataFieldsStr = ['(<b>documented</b>' undefinedStr hiddenStr ' &amp; <font color="#C0C0C0">read-only</font> fields)<p>&nbsp;&nbsp;<table cellpadding="0" cellspacing="0">' dataFieldsStr '</table>'];
    end

    %% Update tooltip string with a node's data
    function updateNodeTooltip(nodeHandle, uiObject)
        try
            toolTipStr = class(nodeHandle);
            dataFieldsStr = '';

            % Add HG annotation if relevant
            if ishghandle(nodeHandle)
                hgStr = ' HG Handle';
            else
                hgStr = '';
            end

            % Prevent HG-Java warnings
            oldWarn = warning('off','MATLAB:hg:JavaSetHGProperty');
            warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
            warning('off','MATLAB:hg:Root');

            % Note: don't bulk-get because (1) not all properties are returned & (2) some properties cause a Java exception
            % Note2: the classhandle approach does not enable access to user-defined schema.props
            ch = classhandle(handle(nodeHandle));
            dataFields = [];
            [sortedNames, sortedIdx] = sort(get(ch.Properties,'Name'));
            for idx = 1 : length(sortedIdx)
                sp = ch.Properties(sortedIdx(idx));
                % TODO: some fields (see EOL comment below) generate a Java Exception from: com.mathworks.mlwidgets.inspector.PropertyRootNode$PropertyListener$1$1.run
                if strcmp(sp.AccessFlags.PublicGet,'on') % && ~any(strcmp(sp.Name,{'FixedColors','ListboxTop','Extent'}))
                    try
                        dataFields.(sp.Name) = get(nodeHandle, sp.Name);
                    catch
                        dataFields.(sp.Name) = '<font color="red">Error!</font>';
                    end
                else
                    dataFields.(sp.Name) = '(no public getter method)';
                end
            end
            dataFieldsStr = getPropsHtml(nodeHandle, dataFields);
        catch
            % Probably a non-HG java object
            try
                % Note: the bulk-get approach enables access to user-defined schema-props, but not to some original classhandle Properties...
                try
                    oldWarn3 = warning('off','MATLAB:structOnObject');
                    dataFields = struct(nodeHandle);
                    warning(oldWarn3);
                catch
                    dataFields = get(nodeHandle);
                end
                dataFieldsStr = getPropsHtml(nodeHandle, dataFields);
            catch
                % Probably a missing property getter implementation
                try
                    % Inform the user - bail out on error
                    err = lasterror;  %#ok
                    dataFieldsStr = ['<p>' strrep(err.message, char(10), '<br>')];
                catch
                    % forget it...
                end
            end
        end

        % Restore warnings
        try warning(oldWarn); catch, end

        % Set the object tooltip
        if ~isempty(dataFieldsStr)
            toolTipStr = ['<html>&nbsp;<b><font color="blue">' char(toolTipStr) '</font></b>' hgStr ':&nbsp;' dataFieldsStr '</html>'];
        end
        uiObject.setToolTipText(toolTipStr);
    end

    %% Expand tree node
    function nodeExpanded(src, evd, tree)  %#ok
        % tree = handle(src);
        % evdsrc = evd.getSource;
        evdnode = evd.getCurrentNode;

        if ~tree.isLoaded(evdnode)

            % Get the list of children TreeNodes
            childnodes = getChildrenNodes(tree, evdnode);

            % Add the HG sub-tree (unless already included in the first tree)
            childHandle = getappdata(evdnode.handle,'childHandle');  %=evdnode.getUserObject
            if evdnode.isRoot && ~isempty(hg_handles) && ~isequal(hg_handles(1).java, childHandle)
                childnodes = [childnodes, getChildrenNodes(tree, evdnode, true)];
            end

            % If we have a single child handle, wrap it within a javaArray for tree.add() to "swallow"
            if (length(childnodes) == 1)
                chnodes = childnodes;
                childnodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
                childnodes(1) = java(chnodes);
            end

            % Add child nodes to the current node
            tree.add(evdnode, childnodes);
            tree.setLoaded(evdnode, true);
        end
    end

    %% Get an icon image no larger than 16x16 pixels
    function iconImage = setIconSize(iconImage)
        try
            iconWidth  = iconImage.getWidth;
            iconHeight = iconImage.getHeight;
            if iconWidth > 16
                newHeight = fix(iconHeight * 16 / iconWidth);
                iconImage = iconImage.getScaledInstance(16,newHeight,iconImage.SCALE_SMOOTH);
            elseif iconHeight > 16
                newWidth = fix(iconWidth * 16 / iconHeight);
                iconImage = iconImage.getScaledInstance(newWidth,16,iconImage.SCALE_SMOOTH);
            end
        catch
            % never mind... - return original icon
        end
    end  % setIconSize

    %% Get list of children nodes
    function nodes = getChildrenNodes(tree, parentNode, isRootHGNode)
        try
            iconpath = [matlabroot, '/toolbox/matlab/icons/'];
            nodes = handle([]);
            try
                userdata = get(tree,'userdata');
            catch
                userdata = getappdata(handle(tree),'userdata');
            end
            hdls = userdata.handles;
            nodedata = get(parentNode,'userdata');
            if nargin < 3
                %isJavaNode = ~ishghandle(parentNode.getUserObject);
                isJavaNode = ~ishghandle(nodedata.obj);
                isRootHGNode = false;
            else
                isJavaNode = ~isRootHGNode;
            end

            % Search for this parent node in the list of all nodes
            parents = userdata.parents;
            nodeIdx = nodedata.idx;

            if isJavaNode && isempty(nodeIdx)  % Failback, in case userdata doesn't work for some reason...
                for hIdx = 1 : length(hdls)
                    %if isequal(handle(parentNode.getUserObject), hdls(hIdx))
                    if isequal(handle(nodedata.obj), hdls(hIdx))
                        nodeIdx = hIdx;
                        break;
                    end
                end
            end
            if ~isJavaNode
                if isRootHGNode  % =root HG node
                    thisChildHandle = userdata.hg_handles(1);
                    childName = getNodeName(thisChildHandle);
                    hasGrandChildren = any(parents==1);
                    icon = [];
                    if hasGrandChildren && length(hg_handles)>1
                        childName = childName.concat(' - HG root container');
                        icon = [iconpath 'figureicon.gif'];
                    end
                    try
                        nodes = uitreenode('v0', thisChildHandle, childName, icon, ~hasGrandChildren);
                    catch  % old matlab version don't have the 'v0' option
                        try
                            nodes = uitreenode(thisChildHandle, childName, icon, ~hasGrandChildren);
                        catch
                            % probably an invalid handle - ignore...
                        end
                    end

                    % Add the handler to the node's internal data
                    % Note: could also use 'userdata', but setUserObject() is recommended for TreeNodes
                    % Note2: however, setUserObject() sets a java *BeenAdapter object for HG handles instead of the required original class, so use setappdata
                    %nodes.setUserObject(thisChildHandle);
                    setappdata(nodes,'childHandle',thisChildHandle);
                    nodedata.idx = 1;
                    nodedata.obj = thisChildHandle;
                    set(nodes,'userdata',nodedata);
                    return;
                else  % non-root HG node
                    parents = userdata.hg_parents;
                    hdls    = userdata.hg_handles;
                end  % if isRootHGNode
            end  % if ~isJavaNode

            % If this node was found, get the list of its children
            if ~isempty(nodeIdx)
                %childIdx = setdiff(find(parents==nodeIdx),nodeIdx);
                childIdx = find(parents==nodeIdx);
                childIdx(childIdx==nodeIdx) = [];  % faster...
                numChildren = length(childIdx);
                for cIdx = 1 : numChildren
                    thisChildIdx = childIdx(cIdx);
                    thisChildHandle = hdls(thisChildIdx);
                    childName = getNodeName(thisChildHandle);
                    try
                        visible = thisChildHandle.Visible;
                        if visible
                            try visible = thisChildHandle.Width > 0; catch, end  %#ok
                        end
                        if ~visible
                            childName = ['<HTML><i><font color="gray">' char(childName) '</font></i></html>'];  %#ok grow
                        end
                    catch
                        % never mind...
                    end
                    hasGrandChildren = any(parents==thisChildIdx);
                    try
                        isaLabel = isa(thisChildHandle.java,'javax.swing.JLabel');
                    catch
                        isaLabel = 0;
                    end
                    if hasGrandChildren && ~any(strcmp(class(thisChildHandle),{'axes'}))
                        icon = [iconpath 'foldericon.gif'];
                    elseif isaLabel
                        icon = [iconpath 'tool_text.gif'];
                    else
                        icon = [];
                    end
                    try
                        nodes(cIdx) = uitreenode('v0', thisChildHandle, childName, icon, ~hasGrandChildren);
                    catch  % old matlab version don't have the 'v0' option
                        try
                            nodes(cIdx) = uitreenode(thisChildHandle, childName, icon, ~hasGrandChildren);
                        catch
                            % probably an invalid handle - ignore...
                        end
                    end

                    % Use existing object icon, if available
                    try
                        setTreeNodeIcon(nodes(cIdx),thisChildHandle);
                    catch
                        % probably an invalid handle - ignore...
                    end

                    % Pre-select the node based upon the user's FINDJOBJ filters
                    try
                        if isJavaNode && ~userdata.userSelected && any(userdata.initialIdx == thisChildIdx)
                            pause(0.0002);  % as short as possible...
                            drawnow;
                            if isempty(tree.getSelectedNodes)
                                tree.setSelectedNode(nodes(cIdx));
                            else
                                newSelectedNodes = [tree.getSelectedNodes, nodes(cIdx).java];
                                tree.setSelectedNodes(newSelectedNodes);
                            end
                        end
                    catch
                        % never mind...
                    end

                    % Add the handler to the node's internal data
                    % Note: could also use 'userdata', but setUserObject() is recommended for TreeNodes
                    % Note2: however, setUserObject() sets a java *BeenAdapter object for HG handles instead of the required original class, so use setappdata
                    % Note3: the following will error if invalid handle - ignore
                    try
                        if isJavaNode
                            thisChildHandle = thisChildHandle.java;
                        end
                        %nodes(cIdx).setUserObject(thisChildHandle);
                        setappdata(nodes(cIdx),'childHandle',thisChildHandle);
                        nodedata.idx = thisChildIdx;
                        nodedata.obj = thisChildHandle;
                        set(nodes(cIdx),'userdata',nodedata);
                    catch
                        % never mind (probably an invalid handle) - leave unchanged (like a leaf)
                    end
                end
            end
        catch
            % Never mind - leave unchanged (like a leaf)
            %error('YMA:findjobj:UnknownNodeType', 'Error expanding component tree node');
            dispError
        end
    end

    %% Get a node's name
    function [nodeName, nodeTitle] = getNodeName(hndl,charsLimit)
        try
            % Initialize (just in case one of the succeding lines croaks)
            nodeName = '';
            nodeTitle = '';
            if ~ismethod(hndl,'getClass')
                try
                    nodeName = class(hndl);
                catch
                    nodeName = hndl.type;  % last-ditch try...
                end
            else
                nodeName = hndl.getClass.getSimpleName;
            end

            % Strip away the package name, leaving only the regular classname
            if ~isempty(nodeName) && ischar(nodeName)
                nodeName = java.lang.String(nodeName);
                nodeName = nodeName.substring(nodeName.lastIndexOf('.')+1);
            end
            if (nodeName.length == 0)
                % fix case of anonymous internal classes, that do not have SimpleNames
                try
                    nodeName = hndl.getClass.getName;
                    nodeName = nodeName.substring(nodeName.lastIndexOf('.')+1);
                catch
                    % never mind - leave unchanged...
                end
            end

            % Get any unique identifying string (if available in one of several fields)
            labelsToCheck = {'label','title','text','string','displayname','toolTipText','TooltipString','actionCommand','name','Tag','style'}; %,'UIClassID'};
            nodeTitle = '';
            strField = '';  %#ok - used for debugging
            while ((~isa(nodeTitle,'java.lang.String') && ~ischar(nodeTitle)) || isempty(nodeTitle)) && ~isempty(labelsToCheck)
                try
                    nodeTitle = get(hndl,labelsToCheck{1});
                    strField = labelsToCheck{1};  %#ok - used for debugging
                catch
                    % never mind - probably missing prop, so skip to next one
                end
                labelsToCheck(1) = [];
            end
            if length(nodeTitle) ~= numel(nodeTitle)
                % Multi-line - convert to a long single line
                nodeTitle = nodeTitle';
                nodeTitle = nodeTitle(:)';
            end
            if isempty(char(nodeTitle))
                % No title - check whether this is an HG label whose text is gettable
                try
                    location = hndl.getLocationOnScreen;
                    pos = [location.getX, location.getY, hndl.getWidth, hndl.getHeight];
                    %dist = sum((labelPositions-repmat(pos,size(labelPositions,1),[1,1,1,1])).^2, 2);
                    dist = sum((labelPositions-repmat(pos,[size(labelPositions,1),1])).^2, 2);
                    [minVal,minIdx] = min(dist);
                    % Allow max distance of 8 = 2^2+2^2 (i.e. X&Y off by up to 2 pixels, W&H exact)
                    if minVal <= 8  % 8=2^2+2^2
                        nodeTitle = get(hg_labels(minIdx),'string');
                        % Preserve the label handles & position for the tooltip & context-menu
                        %hg_labels(minIdx) = [];
                        %labelPositions(minIdx,:) = [];
                    end
                catch
                    % never mind...
                end
            end
            if nargin<2,  charsLimit = 25;  end
            extraStr = regexprep(nodeTitle,{sprintf('(.{%d,%d}).*',charsLimit,min(charsLimit,length(nodeTitle)-1)),' +'},{'$1...',' '},'once');
            if ~isempty(extraStr)
                if ischar(extraStr)
                    nodeName = nodeName.concat(' (''').concat(extraStr).concat(''')');
                else
                    nodeName = nodeName.concat(' (').concat(num2str(extraStr)).concat(')');
                end
                %nodeName = nodeName.concat(strField);
            end
        catch
            % Never mind - use whatever we have so far
            %dispError
        end
    end

    %% Strip standard Swing callbacks from a list of events
    function evNames = stripStdCbs(evNames)
        try
            stdEvents = {'AncestorAdded',  'AncestorMoved',    'AncestorRemoved', 'AncestorResized', ...
                         'ComponentAdded', 'ComponentRemoved', 'ComponentHidden', ...
                         'ComponentMoved', 'ComponentResized', 'ComponentShown', ...
                         'FocusGained',    'FocusLost',        'HierarchyChanged', ...
                         'KeyPressed',     'KeyReleased',      'KeyTyped', ...
                         'MouseClicked',   'MouseDragged',     'MouseEntered',  'MouseExited', ...
                         'MouseMoved',     'MousePressed',     'MouseReleased', 'MouseWheelMoved', ...
                         'PropertyChange', 'VetoableChange',   ...
                         'CaretPositionChanged',               'InputMethodTextChanged', ...
                         'ButtonDown',     'Create',           'Delete'};
            stdEvents = [stdEvents, strcat(stdEvents,'Callback'), strcat(stdEvents,'Fcn')];
            evNames = setdiff(evNames,stdEvents)';
        catch
            % Never mind...
            dispError
        end
    end

    %% Callback function for <Hide standard callbacks> checkbox
    function cbHideStdCbs_Callback(src, evd, callbacksTable, varargin)  %#ok
        try
            % Store the current checkbox value for later use
            if nargin < 3
                try
                    callbacksTable = get(src,'userdata');
                catch
                    callbacksTable = getappdata(src,'userdata');
                end
            end
            if evd.getSource.isSelected
                setappdata(callbacksTable,'hideStdCbs',1);
            else
                setappdata(callbacksTable,'hideStdCbs',[]);
            end

            % Rescan the current node
            try
                userdata = get(callbacksTable,'userdata');
            catch
                userdata = getappdata(callbacksTable,'userdata');
            end
            nodepath = userdata.jTree.getSelectionModel.getSelectionPath;
            try
                ed.getCurrentNode = nodepath.getLastPathComponent;
                nodeSelected(handle(userdata.jTreePeer),ed,[]);
            catch
                % ignore - probably no node selected
            end
        catch
            % Never mind...
            dispError
        end
    end

    %% Callback function for <UndocumentedMatlab.com> button
    function btWebsite_Callback(src, evd, varargin)  %#ok
        try
            web('http://UndocumentedMatlab.com','-browser');
        catch
            % Never mind...
            dispError
        end
    end

    %% Callback function for <Refresh data> button
    function btRefresh_Callback(src, evd, varargin)  %#ok
        try
            % Set cursor shape to hourglass until we're done
            hTreeFig = varargin{2};
            set(hTreeFig,'Pointer','watch');
            drawnow;
            object = varargin{1};

            % Re-invoke this utility to re-scan the container for all children
            findjobj(object);
        catch
            % Never mind...
        end

        % Restore default cursor shape
        set(hTreeFig,'Pointer','arrow');
    end

    %% Callback function for <Export> button
    function btExport_Callback(src, evd, varargin)  %#ok
        try
            % Get the list of all selected nodes
            if length(varargin) > 1
                jTree = varargin{1};
                numSelections  = jTree.getSelectionCount;
                selectionPaths = jTree.getSelectionPaths;
                hdls = handle([]);
                for idx = 1 : numSelections
                    %hdls(idx) = handle(selectionPaths(idx).getLastPathComponent.getUserObject);
                    nodedata = get(selectionPaths(idx).getLastPathComponent,'userdata');
                    try
                        hdls(idx) = handle(nodedata.obj,'CallbackProperties');
                    catch
                        if idx==1  % probably due to HG2: can't convert object to handle([])
                            hdls = nodedata.obj;
                        else
                            hdls(idx) = nodedata.obj;
                        end
                    end
                end

                % Assign the handles in the base workspace & inform user
                assignin('base','findjobj_hdls',hdls);
                classNameLabel = varargin{2};
                msg = ['Exported ' char(classNameLabel.getText.trim) ' to base workspace variable findjobj_hdls'];
            else
                % Right-click (context-menu) callback
                data = varargin{1};
                obj = data{1};
                varName = data{2};
                if isempty(varName)
                    varName = inputdlg('Enter workspace variable name','FindJObj');
                    if isempty(varName),  return;  end  % bail out on <Cancel>
                    varName = varName{1};
                    if isempty(varName) || ~ischar(varName),  return;  end  % bail out on empty/null
                    varName = genvarname(varName);
                end
                assignin('base',varName,handle(obj,'CallbackProperties'));
                msg = ['Exported object to base workspace variable ' varName];
            end
            msgbox(msg,'FindJObj','help');
        catch
            % Never mind...
            dispError
        end
    end

    %% Callback function for <Request focus> button
    function btFocus_Callback(src, evd, varargin)  %#ok
        try
            % Request focus for the specified object
            object = getTopSelectedObject(varargin{:});
            object.requestFocus;
        catch
            try
                object = object.java.getPeer.requestFocus;
                object.requestFocus;
            catch
                % Never mind...
                %dispError
            end
        end
    end

    %% Callback function for <Inspect> button
    function btInspect_Callback(src, evd, varargin)  %#ok
        try
            % Inspect the specified object
            if length(varargin) == 1
                object = varargin{1};
            else
                object = getTopSelectedObject(varargin{:});
            end
            if isempty(which('uiinspect'))

                % If the user has not indicated NOT to be informed about UIInspect
                if ~ispref('FindJObj','dontCheckUIInspect')

                    % Ask the user whether to download UIINSPECT (YES, no, no & don't ask again)
                    answer = questdlg({'The object inspector requires UIINSPECT from the MathWorks File Exchange. UIINSPECT was created by Yair Altman, like this FindJObj utility.','','Download & install UIINSPECT?'},'UIInspect','Yes','No','No & never ask again','Yes');
                    switch answer
                        case 'Yes'  % => Yes: download & install
                            try
                                % Download UIINSPECT
                                baseUrl = 'http://www.mathworks.com/matlabcentral/fileexchange/17935';
                                fileUrl = [baseUrl '?controller=file_infos&download=true'];
                                %file = urlread(fileUrl);
                                %file = regexprep(file,[char(13),char(10)],'\n');  %convert to OS-dependent EOL

                                % Install...
                                %newPath = fullfile(fileparts(which(mfilename)),'uiinspect.m');
                                %fid = fopen(newPath,'wt');
                                %fprintf(fid,'%s',file);
                                %fclose(fid);
                                [fpath,fname,fext] = fileparts(which(mfilename));
                                zipFileName = fullfile(fpath,'uiinspect.zip');
                                urlwrite(fileUrl,zipFileName);
                                unzip(zipFileName,fpath);
                                rehash;
                            catch
                                % Error downloading: inform the user
                                msgbox(['Error in downloading: ' lasterr], 'UIInspect', 'warn');  %#ok
                                web(baseUrl);
                            end

                            % ...and now run it...
                            %pause(0.1); 
                            drawnow;
                            dummy = which('uiinspect');  %#ok used only to load into memory
                            uiinspect(object);
                            return;

                        case 'No & never ask again'   % => No & don't ask again
                            setpref('FindJObj','dontCheckUIInspect',1);

                        otherwise
                            % forget it...
                    end
                end
                drawnow;

                % No UIINSPECT available - run the good-ol' METHODSVIEW()...
                methodsview(object);
            else
                uiinspect(object);
            end
        catch
            try
                if isjava(object)
                    methodsview(object)
                else
                    methodsview(object.java);
                end
            catch
                % Never mind...
                dispError
            end
        end
    end

    %% Callback function for <Check for updates> button
    function btCheckFex_Callback(src, evd, varargin)  %#ok
        try
            % Check the FileExchange for the latest version
            web('http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317');
        catch
            % Never mind...
            dispError
        end
    end

    %% Check for existence of a newer version
    function checkVersion()
        try
            % If the user has not indicated NOT to be informed
            if ~ispref('FindJObj','dontCheckNewerVersion')

                % Get the latest version date from the File Exchange webpage
                baseUrl = 'http://www.mathworks.com/matlabcentral/fileexchange/';
                webUrl = [baseUrl '14317'];  % 'loadFile.do?objectId=14317'];
                webPage = urlread(webUrl);
                modIdx = strfind(webPage,'>Updates<');
                if ~isempty(modIdx)
                    webPage = webPage(modIdx:end);
                    % Note: regexp hangs if substr not found, so use strfind instead...
                    %latestWebVersion = regexprep(webPage,'.*?>(20[\d-]+)</td>.*','$1');
                    dateIdx = strfind(webPage,'class="date">');
                    if ~isempty(dateIdx)
                        latestDate = webPage(dateIdx(end)+13 : dateIdx(end)+23);
                        try
                            startIdx = dateIdx(end)+27;
                            descStartIdx = startIdx + strfind(webPage(startIdx:startIdx+999),'<td>');
                            descEndIdx   = startIdx + strfind(webPage(startIdx:startIdx+999),'</td>');
                            descStr = webPage(descStartIdx(1)+3 : descEndIdx(1)-2);
                            descStr = regexprep(descStr,'</?[pP]>','');
                        catch
                            descStr = '';
                        end

                        % Get this file's latest date
                        thisFileName = which(mfilename);  %#ok
                        try
                            thisFileData = dir(thisFileName);
                            try
                                thisFileDatenum = thisFileData.datenum;
                            catch  % old ML versions...
                                thisFileDatenum = datenum(thisFileData.date);
                            end
                        catch
                            thisFileText = evalc('type(thisFileName)');
                            thisFileLatestDate = regexprep(thisFileText,'.*Change log:[\s%]+([\d-]+).*','$1');
                            thisFileDatenum = datenum(thisFileLatestDate,'yyyy-mm-dd');
                        end

                        % If there's a newer version on the File Exchange webpage (allow 2 days grace period)
                        if (thisFileDatenum < datenum(latestDate,'dd mmm yyyy')-2)

                            % Ask the user whether to download the newer version (YES, no, no & don't ask again)
                            msg = {['A newer version (' latestDate ') of FindJObj is available on the MathWorks File Exchange:'], '', ...
                                   ['\color{blue}' descStr '\color{black}'], '', ...
                                   'Download & install the new version?'};
                            createStruct.Interpreter = 'tex';
                            createStruct.Default = 'Yes';
                            answer = questdlg(msg,'FindJObj','Yes','No','No & never ask again',createStruct);
                            switch answer
                                case 'Yes'  % => Yes: download & install newer file
                                    try
                                        %fileUrl = [baseUrl '/download.do?objectId=14317&fn=findjobj&fe=.m'];
                                        fileUrl = [baseUrl '/14317?controller=file_infos&download=true'];
                                        %file = urlread(fileUrl);
                                        %file = regexprep(file,[char(13),char(10)],'\n');  %convert to OS-dependent EOL
                                        %fid = fopen(thisFileName,'wt');
                                        %fprintf(fid,'%s',file);
                                        %fclose(fid);
                                        [fpath,fname,fext] = fileparts(thisFileName);
                                        zipFileName = fullfile(fpath,[fname '.zip']);
                                        urlwrite(fileUrl,zipFileName);
                                        unzip(zipFileName,fpath);
                                        rehash;
                                    catch
                                        % Error downloading: inform the user
                                        msgbox(['Error in downloading: ' lasterr], 'FindJObj', 'warn');  %#ok
                                        web(webUrl);
                                    end
                                case 'No & never ask again'   % => No & don't ask again
                                    setpref('FindJObj','dontCheckNewerVersion',1);
                                otherwise
                                    % forget it...
                            end
                        end
                    end
                else
                    % Maybe webpage not fully loaded or changed format - bail out...
                end
            end
        catch
            % Never mind...
        end
    end

    %% Get the first selected object (might not be the top one - depends on selection order)
    function object = getTopSelectedObject(jTree, root)
        try
            object = [];
            numSelections  = jTree.getSelectionCount;
            if numSelections > 0
                % Get the first object specified
                %object = jTree.getSelectionPath.getLastPathComponent.getUserObject;
                nodedata = get(jTree.getSelectionPath.getLastPathComponent,'userdata');
            else
                % Get the root object (container)
                %object = root.getUserObject;
                nodedata = get(root,'userdata');
            end
            object = nodedata.obj;
        catch
            % Never mind...
            dispError
        end
    end

    %% Update component callback upon callbacksTable data change
    function tbCallbacksChanged(src, evd, object, table)
        persistent hash
        try
            % exit if invalid handle or already in Callback
            %if ~ishandle(src) || ~isempty(getappdata(src,'inCallback')) % || length(dbstack)>1  %exit also if not called from user action
            if isempty(hash), hash = java.util.Hashtable;  end
            if ~ishandle(src) || ~isempty(hash.get(src)) % || length(dbstack)>1  %exit also if not called from user action
                return;
            end
            %setappdata(src,'inCallback',1);  % used to prevent endless recursion   % can't use getappdata(src,...) because it fails on R2010b!!!
            hash.put(src,1);

            % Update the object's callback with the modified value
            modifiedColIdx = evd.getColumn;
            modifiedRowIdx = evd.getFirstRow;
            if modifiedRowIdx>=0 %&& modifiedColIdx==1  %sanity check - should always be true
                %table = evd.getSource;
                %object = get(src,'userdata');
                modifiedRowIdx = table.getSelectedRow;  % overcome issues with hierarchical table
                cbName = strtrim(table.getValueAt(modifiedRowIdx,0));
                try
                    cbValue = strtrim(char(table.getValueAt(modifiedRowIdx,1)));
                    if ~isempty(cbValue) && ismember(cbValue(1),'{[@''')
                        cbValue = eval(cbValue);
                    end
                    if (~ischar(cbValue) && ~isa(cbValue, 'function_handle') && (~iscell(cbValue) || iscom(object(1))))
                        revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, '');
                    else
                        for objIdx = 1 : length(object)
                            obj = object(objIdx);
                            if ~iscom(obj)
                                try
                                    try
                                        if isjava(obj)
                                            obj = handle(obj,'CallbackProperties');
                                        end
                                    catch
                                        % never mind...
                                    end
                                    set(obj, cbName, cbValue);
                                catch
                                    try
                                        set(handle(obj,'CallbackProperties'), cbName, cbValue);
                                    catch
                                        % never mind - probably a callback-group header
                                    end
                                end
                            else
                                cbs = obj.eventlisteners;
                                if ~isempty(cbs)
                                    cbs = cbs(strcmpi(cbs(:,1),cbName),:);
                                    obj.unregisterevent(cbs);
                                end
                                if ~isempty(cbValue) && ~strcmp(cbName,'-')
                                    obj.registerevent({cbName, cbValue});
                                end
                            end
                        end
                    end
                catch
                    revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, lasterr)  %#ok
                end
            end
        catch
            % never mind...
        end
        %setappdata(src,'inCallback',[]);  % used to prevent endless recursion   % can't use setappdata(src,...) because it fails on R2010b!!!
        hash.remove(src);
    end

    %% Revert Callback table modification
    function revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, errMsg)  %#ok
        try
            % Display a notification MsgBox
            msg = 'Callbacks must be a ''string'', or a @function handle';
            if ~iscom(object(1)),  msg = [msg ' or a {@func,args...} construct'];  end
            if ~isempty(errMsg),  msg = {errMsg, '', msg};  end
            msgbox(msg, ['Error setting ' cbName ' value'], 'warn');

            % Revert to the current value
            curValue = '';
            try
                if ~iscom(object(1))
                    curValue = charizeData(get(object(1),cbName));
                else
                    cbs = object(1).eventlisteners;
                    if ~isempty(cbs)
                        cbs = cbs(strcmpi(cbs(:,1),cbName),:);
                        curValue = charizeData(cbs(1,2));
                    end
                end
            catch
                % never mind... - clear the current value
            end
            table.setValueAt(curValue, modifiedRowIdx, modifiedColIdx);
        catch
            % never mind...
        end
    end  % revertCbTableModification

    %% Get the Java positions of all HG text labels
    function labelPositions = getLabelsJavaPos(container)
        try
            labelPositions = [];

            % Ensure we have a figure handle
            try
                h = hFig;  %#ok unused
            catch
                hFig = getCurrentFigure;
            end

            % Get the figure's margins from the Matlab properties
            hg_labels = findall(hFig, 'Style','text');
            units = get(hFig,'units');
            set(hFig,'units','pixels');
            outerPos = get(hFig,'OuterPosition');
            innerPos = get(hFig,'Position');
            set(hFig,'units',units);
            margins = abs(innerPos-outerPos);

            figX = container.getX;        % =outerPos(1)
            figY = container.getY;        % =outerPos(2)
            %figW = container.getWidth;   % =outerPos(3)
            figH = container.getHeight;   % =outerPos(4)

            % Get the relevant screen pixel size
            %monitorPositions = get(0,'MonitorPositions');
            %for monitorIdx = size(monitorPositions,1) : -1 : 1
            %    screenSize = monitorPositions(monitorIdx,:);
            %    if (outerPos(1) >= screenSize(1)) % && (outerPos(1)+outerPos(3) <= screenSize(3))
            %        break;
            %    end
            %end
            %monitorBaseY = screenSize(4) - monitorPositions(1,4);

            % Compute the labels' screen pixel position in Java units ([0,0] = top left)
            for idx = 1 : length(hg_labels)
                matlabPos = getpixelposition(hg_labels(idx),1);
                javaX = figX + matlabPos(1) + margins(1);
                javaY = figY + figH - matlabPos(2) - matlabPos(4) - margins(2);
                labelPositions(idx,:) = [javaX, javaY, matlabPos(3:4)];  %#ok grow
            end
        catch
            % never mind...
            err = lasterror;  %#ok debug point
        end
    end

    %% Traverse an HG container hierarchy and extract the HG elements within
    function traverseHGContainer(hcontainer,level,parent)
        try
            % Record the data for this node
            thisIdx = length(hg_levels) + 1;
            hg_levels(thisIdx) = level;
            hg_parentIdx(thisIdx) = parent;
            try
                hg_handles(thisIdx) = handle(hcontainer);
            catch
                hg_handles = handle(hcontainer);
            end
            parentId = length(hg_parentIdx);

            % Now recursively process all this node's children (if any)
            %if ishghandle(hcontainer)
            try  % try-catch is faster than checking ishghandle(hcontainer)...
                allChildren = allchild(handle(hcontainer));
                for childIdx = 1 : length(allChildren)
                    traverseHGContainer(allChildren(childIdx),level+1,parentId);
                end
            catch
                % do nothing - probably not a container
                %dispError
            end

            % TODO: Add axis (plot) component handles
        catch
            % forget it...
        end
    end

    %% Debuggable "quiet" error-handling
    function dispError
        err = lasterror;  %#ok
        msg = err.message;
        for idx = 1 : length(err.stack)
            filename = err.stack(idx).file;
            if ~isempty(regexpi(filename,mfilename))
                funcname = err.stack(idx).name;
                line = num2str(err.stack(idx).line);
                msg = [msg ' at <a href="matlab:opentoline(''' filename ''',' line ');">' funcname ' line #' line '</a>']; %#ok grow
                break;
            end
        end
        disp(msg);
        return;  % debug point
    end

    %% ML 7.0 - compatible ischar() function
    function flag = ischar(data)
        try
            flag = builtin('ischar',data);
        catch
            flag = isa(data,'char');
        end
    end

    %% Set up the uitree context (right-click) menu
    function jmenu = setTreeContextMenu(obj,node,tree_h)
          % Prepare the context menu (note the use of HTML labels)
          import javax.swing.*
          titleStr = getNodeTitleStr(obj,node);
          titleStr = regexprep(titleStr,'<hr>.*','');
          menuItem0 = JMenuItem(titleStr);
          menuItem0.setEnabled(false);
          menuItem0.setArmed(false);
          %menuItem1 = JMenuItem('Export handle to findjobj_hdls');
          if isjava(obj), prefix = 'j';  else,  prefix = 'h';  end  %#ok<NOCOM>
          varname = strrep([prefix strtok(char(node.getName))], '$','_');
          varname = genvarname(varname);
          varname(2) = upper(varname(2));  % ensure lowerCamelCase
          menuItem1 = JMenuItem(['Export handle to ' varname]);
          menuItem2 = JMenuItem('Export handle to...');
          menuItem3 = JMenuItem('Request focus (bring to front)');
          menuItem4 = JMenuItem('Flash component borders');
          menuItem5 = JMenuItem('Display properties & callbacks');
          menuItem6 = JMenuItem('Inspect object');

          % Set the menu items' callbacks
          set(handle(menuItem1,'CallbackProperties'), 'ActionPerformedCallback', {@btExport_Callback,{obj,varname}});
          set(handle(menuItem2,'CallbackProperties'), 'ActionPerformedCallback', {@btExport_Callback,{obj,[]}});
          set(handle(menuItem3,'CallbackProperties'), 'ActionPerformedCallback', {@requestFocus,obj});
          set(handle(menuItem4,'CallbackProperties'), 'ActionPerformedCallback', {@flashComponent,{obj,0.2,3}});
          set(handle(menuItem5,'CallbackProperties'), 'ActionPerformedCallback', {@nodeSelected,{tree_h,node}});
          set(handle(menuItem6,'CallbackProperties'), 'ActionPerformedCallback', {@btInspect_Callback,obj});

          % Add all menu items to the context menu (with internal separator)
          jmenu = JPopupMenu;
          jmenu.add(menuItem0);
          jmenu.addSeparator;
          handleValue=[];  try handleValue = double(obj); catch, end;  %#ok
          if ~isempty(handleValue)
              % For valid HG handles only
              menuItem0a = JMenuItem('Copy handle value to clipboard');
              set(handle(menuItem0a,'CallbackProperties'), 'ActionPerformedCallback', sprintf('clipboard(''copy'',%.99g)',handleValue));
              jmenu.add(menuItem0a);
          end
          jmenu.add(menuItem1);
          jmenu.add(menuItem2);
          jmenu.addSeparator;
          jmenu.add(menuItem3);
          jmenu.add(menuItem4);
          jmenu.add(menuItem5);
          jmenu.add(menuItem6);
    end  % setTreeContextMenu

    %% Set the mouse-press callback
    function treeMousePressedCallback(hTree, eventData, tree_h)  %#ok hTree is unused
        if eventData.isMetaDown  % right-click is like a Meta-button
            % Get the clicked node
            clickX = eventData.getX;
            clickY = eventData.getY;
            jtree = eventData.getSource;
            treePath = jtree.getPathForLocation(clickX, clickY);
            try
                % Modify the context menu based on the clicked node
                node = treePath.getLastPathComponent;
                userdata = get(node,'userdata');
                obj = userdata.obj;
                jmenu = setTreeContextMenu(obj,node,tree_h);

                % TODO: remember to call jmenu.remove(item) in item callback
                % or use the timer hack shown here to remove the item:
                %    timerFcn = {@menuRemoveItem,jmenu,item};
                %    start(timer('TimerFcn',timerFcn,'StartDelay',0.2));

                % Display the (possibly-modified) context menu
                jmenu.show(jtree, clickX, clickY);
                jmenu.repaint;

                % This is for debugging:
                userdata.tree = jtree;
                setappdata(gcf,'findjobj_hgtree',userdata)
            catch
                % clicked location is NOT on top of any node
                % Note: can also be tested by isempty(treePath)
            end
        end
    end  % treeMousePressedCallback

    %% Remove the extra context menu item after display
    function menuRemoveItem(hObj,eventData,jmenu,item) %#ok unused
        jmenu.remove(item);
    end  % menuRemoveItem

    %% Get the title for the tooltip and context (right-click) menu
    function nodeTitleStr = getNodeTitleStr(obj,node)
        try
            % Display the full classname and object name in the tooltip
            %nodeName = char(node.getName);
            %nodeName = strrep(nodeName, '<HTML><i><font color="gray">','');
            %nodeName = strrep(nodeName, '</font></i></html>','');
            nodeName = char(getNodeName(obj,99));
            [objClass,objName] = strtok(nodeName);
            objName = objName(3:end-1);  % strip leading ( and trailing )
            if isempty(objName),  objName = '(none found)';  end
            nodeName = char(node.getName);
            objClass = char(obj.getClass.getName);
            nodeTitleStr = sprintf('<html>Class name: <font color="blue">%s</font><br>Text/title: %s',objClass,objName);

            % If the component is invisible, state this in the tooltip
            if ~isempty(strfind(nodeName,'color="gray"'))
                nodeTitleStr = [nodeTitleStr '<br><font color="gray"><i><b>*** Invisible ***</b></i></font>'];
            end
            nodeTitleStr = [nodeTitleStr '<hr>Right-click for context-menu'];
        catch
            % Possible not a Java object - try treating as an HG handle
            try
                handleValueStr = sprintf('#: <font color="blue"><b>%.99g<b></font>',double(obj));
                try
                    type = '';
                    type = get(obj,'type');
                    type(1) = upper(type(1));
                catch
                    if ~ishandle(obj)
                        type = ['<font color="red"><b>Invalid <i>' char(node.getName) '</i>'];
                        handleValueStr = '!!!</b></font><br>Perhaps this handle was deleted after this UIInspect tree was<br>already drawn. Try to refresh by selecting any valid node handle';
                    end
                end
                nodeTitleStr = sprintf('<html>%s handle %s',type,handleValueStr);
                try
                    % If the component is invisible, state this in the tooltip
                    if strcmp(get(obj,'Visible'),'off')
                        nodeTitleStr = [nodeTitleStr '<br><center><font color="gray"><i>Invisible</i></font>'];
                    end
                catch
                    % never mind...
                end
            catch
                % never mind... - ignore
            end
        end
    end  % getNodeTitleStr

    %% Handle tree mouse movement callback - used to set the tooltip & context-menu
    function treeMouseMovedCallback(hTree, eventData)
          try
              x = eventData.getX;
              y = eventData.getY;
              jtree = eventData.getSource;
              treePath = jtree.getPathForLocation(x, y);
              try
                  % Set the tooltip string based on the hovered node
                  node = treePath.getLastPathComponent;
                  userdata = get(node,'userdata');
                  obj = userdata.obj;
                  tooltipStr = getNodeTitleStr(obj,node);
                  set(hTree,'ToolTipText',tooltipStr)
              catch
                  % clicked location is NOT on top of any node
                  % Note: can also be tested by isempty(treePath)
              end
          catch
              dispError;
          end
          return;  % denug breakpoint
    end  % treeMouseMovedCallback

    %% Request focus for a specific object handle
    function requestFocus(hTree, eventData, obj)  %#ok hTree & eventData are unused
        % Ensure the object handle is valid
        if isjava(obj)
            obj.requestFocus;
            return;
        elseif ~ishandle(obj)
            msgbox('The selected object does not appear to be a valid handle as defined by the ishandle() function. Perhaps this object was deleted after this hierarchy tree was already drawn. Refresh this tree by selecting a valid node handle and then retry.','FindJObj','warn');
            beep;
            return;
        end

        try
            foundFlag = 0;
            while ~foundFlag
                if isempty(obj),  return;  end  % sanity check
                type = get(obj,'type');
                obj = double(obj);
                foundFlag = any(strcmp(type,{'figure','axes','uicontrol'}));
                if ~foundFlag
                    obj = get(obj,'Parent');
                end
            end
            feval(type,obj);
        catch
            % never mind...
            dispError;
        end
    end  % requestFocus


end  % FINDJOBJ


%% TODO TODO TODO
%{
- Enh: Improve performance - esp. expandNode() (performance solved in non-interactive mode)
- Enh: Add property listeners - same problem in MathWork's inspect.m
- Enh: Display additional properties - same problem in MathWork's inspect.m
- Enh: Add axis (plot, Graphics) component handles
- Enh: Group callbacks according to the first word (up to 2nd cap letter)
- Enh: Add figure thumbnail image below the java tree (& indicate corresponding jObject when selected)
- Enh: scroll initially-selected node into view (problem because treenode has no pixel location)
- Fix: java exceptions when getting some fields (com.mathworks.mlwidgets.inspector.PropertyRootNode$PropertyListener$1$1.run)
- Fix: use EDT if available (especially in flashComponent)
%}



% #ankerstart: regexphelp 
% 
% #yg [1]Regexp for shortpaths file list
% #b Find String starting with ‘results’ ,  #r '^results',   
% #g Use ’^’ to indicate starting anchor
% ic=regexpi(fis2,'^results');           char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String ending with ‘.xlsx’,  #r '.*xlsx$' #b  thus ic=regexpi(fis2,'.*xlsx$');
% Use ’$’ to indicate ending anchor
% ic=regexpi(fis2,'.*xlsx$');                 char(fis2(cellfun(@(x) any(x),ic)))  
% 
% #b Find String containing  string ‘pO2’,  #r  'pO2'
% ic=regexpi(fis2,'pO2');                  char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String containing ‘HALLO’ or ‘100’, #r  'HALLO|100'
% ic=regexpi(fis2,'HALLO|100');          char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String ending with ‘doc’ or ‘txt’,  #r  'doc|txt'
% #g Use ’\.’ to indicate the dot ‘.’ , such to find files such “readme.txt” but not “readmetxt”
% #g Use  ’|’ to make an “or”-command, ’$’ to indicate ending anchor
% ic=regexpi(fis2,'\.(doc|txt)$');          char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’ #r '^((?!pO).)*$'
% ic=regexpi(fis2,'^((?!pO).)*$');char(fis2(cellfun(@(x) any(x),ic))),     '^((?!pO).)*$'
% 
% #b String not containing ‘pO’ and ending with ‘.xlsx’  
% #r  '^((?!pO).)*.xlsx$'
% ic=regexpi(fis2,'^((?!pO).)*.xlsx$');char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’, with starting filename prefix ‘results’  and ending with ‘.xlsx’, 
% #r '^(?!.*pO).*^results.*xlsx$' 
% #g Use ’^’ to indicate starting anchor, Use ’$’ to indicate ending anchor
% ic=regexpi(fis2,'^(?!.*pO).*^results.*xlsx$') ;   char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’, with filename prefix ‘results’, containing string “_30” and ending with ‘.xlsx’, 
% #r  '^(?!.*pO).*^results.*_30.*xlsx$'
% ic=regexpi(fis2,'^(?!.*pO).*^results.*_30.*xlsx$') ;   char(fis2(cellfun(@(x) any(x),ic)))
% 
% 
% #yg [2] Regexp for fullpaths file list
% #b Find String starting with drive \S ,  ,'^\\S',  thus ic=regexpi(fis2,'^\\S');
% #g Use ’^’ to indicate starting anchor
% #g Use ‘\\’ for indicating this ‘\’ fileseparator
% ic=regexpi(fis2,'^\\S');char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String ending with ‘.xlsx’,  '.*xlsx$'   thus ic=regexpi(fis2,'.*xlsx$');
% #g Use ’$’ to indicate ending anchor
% ic=regexpi(fis2,'.*xlsx$');                         char(fis2(cellfun(@(x) any(x),ic)))  
% 
% #b Find String containing ‘pO2’,  'pO2'
% ic=regexpi(fis2,'pO2');                         char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String containing ‘HALLO’ or ‘100’,  'HALLO|100'
% ic=regexpi(fis2,'HALLO|100');            char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b Find String ending with ‘doc’ or ‘txt’,  'doc|txt'
% #g Use ’\.’ to indicate the dot ‘.’ , ’|’ to make an “or”-command, ’$’ to indicate ending anchor
% ic=regexpi(fis2,'\.(doc|txt)$');            char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’
% ic=regexpi(fis2,'^((?!pO).)*$');              char(fis2(cellfun(@(x) any(x),ic))),     '^((?!pO).)*$'
% 
% #b String not containing ‘pO’ and ending with ‘.xlsx’ , '^((?!pO).)*.xlsx$'
% ic=regexpi(fis2,'^((?!pO).)*.xlsx$');           char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’, with starting filename ‘result’ (with regexp term ‘\\’ for fileseparator ‘\’ ? thus ‘\\results’) and ending with ‘.xlsx’, '^(?!.*pO).*.*\\results.*xlsx$' 
% ic=regexpi(fis2,'^(?!.*pO).*.*\\results.*xlsx$');         char(fis2(cellfun(@(x) any(x),ic)))
% 
% #b String not containing ‘pO’, with starting drive letter ‘’\S (using  ‘^\\S’), starting filename ‘results’ (with regexp term ‘\\’ for file separator ‘\’, thus ‘\\results’) and ending with ‘.xlsx’ '^(?!.*pO).*^\\S.*\\results.*xlsx$' 
% ic=regexpi(fis2,'^(?!.*pO).*^\\S.*\\results.*xlsx$');          char(fis2(cellfun(@(x) any(x),ic)))
% 
%
%
% #ankerend 
% 
% 







