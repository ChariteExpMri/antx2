
%% #b ant-callbacks
%%
% #yk EXAMPLES
% antcb('getsubjects')    % get selected subjects-->only those selected from [ANT] Mouse-listbox
% antcb('getallsubjects') % get all subjects  --> all from list
%
% antcb('countfiles', flt); % search and count specific files in animal-folders
%                           % HELP: antcb('countfiles?')
% antcb('getstudypath')     %get path of current study
%                           ->for HELP type antcb('getstudypath?') 
%
% antcb('makeproject')    % create a new project -->for HELP type antcb('makeproject','?')
% antcb('saveproject')    % save/modify projectfile -->for HELP type antcb('saveproject?')
% antcb('set')            % set specifc parameters of projectfile -->for HELP type antcb('set?')
%
% antcb('getpreorientation');  %get HTML with preorientations for trafo to standard space
%                               -->for HELP type antcb('getpreorientation?')
% antcb('setpreorientation');  % Change preorientation (paramter: 'orientType') via comandline.
%                               -->for HELP type antcb('setpreorientation?')
%
% antcb('getlabels');     %get atlas IDs & labels from xyz-coordinates (as 'mm' or 'indices')
%                               -->for HELP type antcb('getlabels?');
% antcb('loop')           % perform a small task over animal dirs -->for HELP type antcb('loop?')
% 
% antcb('load','proj_Harms3_lesionfill_20stack.m')   %load this project
% antcb('reload')         % reload gui with project and previous mice-selection
% antcb('version');       % get the last package version (1st output arg)
% antcb('versionupdate'); % updates last package version string in ant-gui (used after github-update)
% antcb('fontsize',8)              % set fontsize
% antcb('status',1,'copy Images'); % change status-message :  antcb('status',0,'coffeTime')     statusUpdate
% antcb('update');                 % update mouse directories
% antcb('quit')/antcb('close')     % close gui
% antcb('watchfile');              % make list of watching files, for HELP type antcb('watchfile?');
% antcb('selectdirs')              % SELECT MOUSE DIRECTORIES in ANT-GUI
%                                  %   HELP: antcb('selectdirs?')
% antcb('copytemplates')           % copy templates from reference to studies template folder
%                                  %   HELP: antcb('copytemplates?')
% [tb tbh v]=antcb('getuniquefiles',pa)  ;% get table (tb)+header(tbh) of all unique file over mouseDirs (pa),
%                                   [v] is a struct with tb and tbh
% antcb('getsubdirs', x.datapath);  % get subdirs of a directory
% antcb('studydir')               ;%obtain current ANT-study-directory'
%                                 ..for help: antcb('studydir?');
%
% antcb('selectimageviagui', mypath, 'single');  %select an image from upperDatapath via gui
% antcb('selectimageviagui', mypath, 'multi');   %select several images from upperDatapath via gui
%
%
% -----------------
% antcb('cwcol',[1 .94 .87]);           % change command-window background color
% antcb('cwcol');                       % ..selection via color-palette
% antcb('cwname','klaus works here');   % define command-window title
% antcb('cwname');                      % ..selection via command window input
%
% antcb('versionupdate'),


%====================================================================================================
%%                  UICALLBACKS
%====================================================================================================
%====================================================================================================

function varargout=antcb(h,emp,do,varargin)
warning off;
if exist('h')==0; help antcb; return; end

input2={};
if exist('h')==1     ;  input2{end+1}=h ; end
if exist('emp')==1   ;  input2{end+1}=emp ; end
if exist('do')==1    ;  input2{end+1}=do ; end
if ~isempty(varargin);  input2=[input2 varargin] ; end  % GENERAL INPUT


warning off;

if ~ishandle(h)
    try; input=[emp do varargin];
    catch;
        try;  input=[emp varargin];
        catch; input=[ varargin];
        end
    end
    %     if exist('do')==1 && ~isempty(varargin)
    %       varargin=  [do varargin];
    %       do=h;
    %     else
    do=h;
    try; varargin=emp;end
    %     end
    
end

hfig=findobj(0,'tag','ant');
%====================================================================================================
%           LOAD CONFIG
%====================================================================================================


%% ===============================================
if strcmp(do, 'watchfile');     watchfile(input2); end
if strcmp(do, 'watchfile?');
    %watchfile('?')  ; end
    help watchfile
end
%% ===============================================


% if strcmp(do,'sel')  ;          varargout=selectdirs(input2,nargout);  end
if strcmp(do,'selectdirs')  ||  strcmp(do,'sel')
    varargout=selectdirs(input2,nargout);
end
if strcmp(do,'selectdirs?')  || strcmp(do,'sel?');
    %varargout=selectdirs('?');
    disp(help(['antcb' filemarker 'selectdirs']));
end

if strcmp(do,'helpfun') ;       helpfun(input2{2});    end

if strcmp(do,'studydir')  || strcmp(do,'studydir?')
    [o1 o2 ]=studydir(input2);
    %     if ~isempty(o1);         varargout{1}=o1;    end
    %     if ~isempty(o2);         varargout{2}=o2;    end
    varargout{1}=o1;
    varargout{2}=o2;
end
if strcmp(do,'studydir?')  ;   disp(help(['antcb' filemarker 'studydir'])); end
%% ===============================================
if strcmp(do,'load_guiparameter') ;
    o1=load_guiparameter(input);
    varargout{1}=o1;
    return;
end

if strcmp(do,'checkProjectfile') ;varargout=checkProjectfile;return; end
%% ===============================================
if strcmp(do,'figlet')   ;figlet;return; end
if strcmp(do,'figlet?')  ;   disp(help(['antcb' filemarker 'figlet'])); end
%% ===============================================
if strcmp(do,'copytemplates'  )  ;
    copytemplates(input2);
end
if strcmp(do, 'copytemplates?')  ;
    disp(help(['antcb' filemarker 'copytemplates']));
    %     varargout{1}=[];
end %copytemplates('?')  ; end
%% ===============================================

if strcmp(do, 'getuniquefiles')
    if isempty(char(emp))
        cprintf([1 0 0],[' no directory selected \n']);
        return
    end
    %pa=emp;
    %v=getuniquefiles(pa);
    v=getuniquefiles(input2);
    varargout{1}=v.tb;
    varargout{2}=v.tbh;
    varargout{3}=v;
end
if strcmp(do, 'getuniquefiles?')
    disp(help(['antcb' filemarker 'getuniquefiles']));
end
%% ===============================================
if strcmp(do, 'getsubdirs')
    varargout{1}=getsubdirs(emp);
end
if strcmp(do, 'getsubdirs?')
    disp(help(['antcb' filemarker 'getsubdirs']));
end
%% ===============================================
if strcmp(do,'getpreorientation')
    try ;    varargout{1}=getpreorientation(input);
    catch;   disp('* type    antcb(''getpreorientation'',''?'')     for help');
    end
end
if strcmp(do,'getpreorientation?');    help antcb>getpreorientation;end
%% ===============================================
if strcmp(do,'setpreorientation')
    try ;    varargout{1}=setpreorientation(input);
    catch;   disp('* type    antcb(''setpreorientation'',''?'')     for help');
    end
end
if strcmp(do,'setpreorientation?');    help antcb>setpreorientation;end
%% ===============================================
if strcmp(do,'getstudypath')
    try ;    varargout{1}=getstudypath(input);
    catch;   disp('* type    antcb(''getstudypath'',''?'')     for help');
    end
end
if strcmp(do,'getstudypath?');    help antcb>getstudypath;end
%% ===============================================
if strcmp(do,'getlabels')
    try ;    varargout{1}=getlabels(input);
    catch;   disp('* type    antcb(''getlabels'',''?'')     for help');
    end
end
if strcmp(do,'getlabels?');    help antcb>getlabels;end
%% ===============================================

if strcmp(do,'saveproject')
    try ;    varargout{1}=saveproject(input);
    catch;   disp('* type    antcb(''saveproject'',''?'')     for help');
    end
end
if strcmp(do,'saveproject?');    help antcb>saveproject;end
%% ===============================================
if strcmp(do,'makeproject')
    try ;    varargout{1}=makeproject(input);
    catch;   disp('* type    antcb(''makeproject'',''?'')     for help');
    end
end
if strcmp(do,'makeproject?')
    help makeproject
end
%% ===============================================
if strcmp(do, 'selectimageviagui')
    varargout{1}=selectimageviagui(input);
end

if strcmp(do, 'loadprojectfile') || strcmp(do, 'load')
    if exist('input')==1;     loadprojectfile(input);
    else;                     loadprojectfile();
    end
    
    
end
if strcmp(do, 'loadprojectfile?') || strcmp(do, 'load?')  ;
    disp(help(['antcb' filemarker 'loadprojectfile']));
end
% if strcmp(do,'load?');    help antcb>load;end
if strcmp(do,'load?');    help antcb>loadprojectfile;end
%% ===============================================

if strcmp(do, 'fontsize');
    fontsize(input);
end
if strcmp(do, 'fontsize?')
    disp(help(['antcb' filemarker 'fontsize']));
end

%% ===============================================
if strcmp(do,'countfiles')
    try ;    varargout{1}=countfiles(input2);
    catch;
        %disp('* type    antcb(''countfiles'',''?'')     for help');
        do='countfiles?';
    end
end
if strcmp(do,'countfiles?');    help antcb>countfiles;end
%% ===============================================
if strcmp(do,'set')
    try ;    varargout{1}=setparams(input2);
    catch;
        %disp('* type    antcb(''setparams'',''?'')     for help');
        do='setparams?';
    end
end
if strcmp(do,'set?');    help antcb>setparams;end
%% ===============================================
if strcmp(do,'loop')
    try ;    varargout{1}=loop(input2(2:end));
    catch;
        %disp('* type    antcb(''countfiles'',''?'')     for help');
        do='loop?';
    end
end
if strcmp(do,'loop?');    help antcb>loop;end
%% ===============================================
%% ===============================================
if strcmp(do,'gohome')
    try ;    varargout{1}=gohome(input2(2:end));
    catch;
        do='gohome?';
    end
end
if strcmp(do,'gohome?');    help antcb>gohome;end
%% ===============================================

if strcmp(do, 'load__OLD_vers_21_12_23');
    %     fprintf(' ...(re)loading project..');
    
    %% open ant before, if nonexisting
    if isempty(findobj(0,'tag','ant'))
        ant
    end
    
    try
        
        configfile=varargin;
        if exist(configfile)~=2;  configfile=[]; end
    catch
        configfile=[];
    end
    
    if isempty(configfile)
        [fi pa ]=uigetfile(pwd,'select projectfile [mfile]','*.m');
        if ~ischar(pa);
            pause(2)
            return;
            pause(2)
        end
        projectfile=fullfile(pa,fi);
    else
        [pa fi]=fileparts(configfile);
        if isempty(pa);
            configfile=fullfile(pwd,configfile);
            [pa fi]=fileparts(configfile);
        end
        projectfile=fullfile(pa,[fi]);
    end
    
    if strcmp(pa(end),filesep)
        px=pa(1:end-1);
    else
        px=pa;
    end
    [rest projectdir]=fileparts(px);
    fprintf([' ...loading project: ' '[' [strrep(fi,'.m',''),'.m' ] '] from [' projectdir ']'  '\n']);
    %====================================================================================================
    %% make history of previous projectfiles
    if 0
        antxpath=antpath;
        prevprojects=fullfile(antxpath,'prevprojects.mat');
        run(projectfile);
        if exist(prevprojects)~=2
            pp={'-' '-' '-'};
            save(prevprojects,'pp');
        end
        load(prevprojects);
        [ppath pfi pext]=fileparts(projectfile);
        projectfile2=fullfile(ppath, [pfi '.m']);
        
        if strcmp(pp(:,1),projectfile2)==0 %ADD PROJECTFILE
            if strcmp(pp(:,1),'-')==1     ; %replace empty array
                pp={ projectfile2 , datestr(now)  x.project};
            else
                pp(end+1,:)={ projectfile2 , datestr(now) x.project};
            end
            save(prevprojects,'pp');
        end
        
    end
    %====================================================================================================
    
    clear global an;
    global an;
    run(projectfile);
    cd(fileparts(projectfile));
    an=x;
    antconfig(0);
    
    an.templatepath=fullfile(fileparts(an.datpath),'templates');
    %[pathx s]=antpath;
    % %%%%%%    x= catstruct(x,s);
    %     x= catstruct(s,x);% overwrite defaults with "m-file config"-data
    an.configfile=projectfile;
    %remove from list
    try;       an=rmfield(an,'ls');     end
    try;       an=rmfield(an,'mdirs');     end
    
    % check old-version
    ro=antcb('checkProjectfile');
    
    antcb('updateParameterLB');
    
    % %     try; an=rmfield(an,'ls'); end
    % %     an.ls =struct2list(an); %   ls=fn_structdisp(x);
    % %     an.ls(regexpi2(an.ls,'^\s*an.inf\d'))=[];
    % %     iproject=min(regexpi2(an.ls,'project.*='));
    % %     if iproject==1
    % %         an.ls=[{''}; an.ls];%move project to 2nd line
    % %         iproject=2;
    % %     end
    % %     %        colergen = @(color,text) ['<html><b><font color='  color '  bgcolor="black" size="+2">' text '</html>'  ];
    % %     colergen = @(color,text) ['<html><b><font color='  color '   >' text '</html>'  ];
    % %
    % %     %  colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD><pre>',text,'</pre></TD></TR> </table></html>'];
    % %     % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    % %     %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
    % %     %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
    % %
    % %     an.ls{iproject}=colergen('#007700',   an.ls{iproject} );
    % %     %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
    % %     %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
    % %
    % %     set(findobj(0,'tag','ant'),'name' ,['[ant2]' ' ' projectdir ' (' fi '.m)']);
    % %
    % %
    % %     if ~isempty(an.ls{1})
    % %         an.ls=[{''} ;an.ls];
    % %     end
    % %     try
    % %         msg=makenicer2(an.ls);
    % %     catch
    % %         msg=an.ls;
    % %     end
    % %
    % %     hlb2=findobj(0,'tag','lb2');
    % %     set(hlb2,'string',msg,'FontName','courier');
    % %
    % %     % ==============================================
    % %     %%
    % %     % ===============================================
    % %
    % %     tip=regexprep(msg,{'<html>' '</html>'},'');
    % %     %         tip=cellfun(@(a){['<html><pre>' a '</pre>','</html>' ]},  tip)
    % %     %     tip=cellfun(@(a){['<html><pre>' a '</pre>','</html>' ]},  tip)
    % %     tip{iproject+1}=[ '</b><font color=#000000   >' tip{iproject+1}];
    % %     tip= cellfun(@(a){[ a '<br>' ]},  tip);
    % %     tip2=['<html><pre>' strjoin(tip,' ') '</pre></html>'];
    % %     set(hlb2,'tooltipstring',tip2);
    % %
    % ==============================================
    %% sanity check
    % ===============================================
    % remove ending fileseps
    try; an.datpath         =regexprep(an.datpath     ,['\' filesep '$'],''); end
    try; an.templatepath    =regexprep(an.templatepath,['\' filesep '$'],''); end
    
    % ==============================================
    %%  history
    % ===============================================
    anthistory('update');
    
    % ==============================================
    %%
    % ===============================================
    
    antcb('update'); %update subkects
    %     fprintf('[done]\n');
    
    %% =========special characters in study path =========
    
    studypath=fileparts(an.datpath);
    %   studypath='ddd > ?';
    tes={
        '\s'  'space-character (" ")'
        '<'   'less than (<)-character'
        '>'   'greater than (>)-character'
        '"'   'double quote (")-character'
        '\|'  'vertical bar or pipe (|)-character'
        '\?'  'question mark (?)-character'
        '\*'  'asterisk (*)-character'
        };
    ispecchar=regexpi2(studypath, tes(:,1));
    if ~isempty(ispecchar)
        if usejava('desktop')
            ms=[{''}
                '=============================================='
                'SPECIAL CHARACTERS found in the STUDY-PATH !!!'
                '=============================================='
                ['...found: "' strjoin(tes(ispecchar,2),'", "') '"'  ' in path: ["' studypath  '"]' ]
                'PLEASE REMOVE SPECIAL CHARACTERS FROM PATH..otherwise data processing will not work!'
                'SOLUTION: close the ANT-project+GUI & change matlab path to another directory'
                '..change the name of the study-path & also change the datapath (x.datpath) in the project-file  '
                '..reload project'
                '=============================================='
                ];
            %         warndlg(ms,'WARNING');
            warning on;
            warning(strjoin(ms,char(10)));
            warning off
        else
            warning on;
            warning(strjoin(ms,char(10)));
            warning off
        end
    end
    
    
    %% ===============================================
    
    return
end

%% UPDSATE PARAMETER-LISTBOX
if strcmp(do, 'updateParameterLB');
    global an
    
    [rest projname]=fileparts(an.configfile);
    [rest projectdir]=fileparts(rest);
    
    try; an  = rmfield(an,'ls'); end
    an.ls    =struct2list(an); %   ls=fn_structdisp(x);
    an.ls(regexpi2(an.ls,'^\s*an.inf\d'))=[];
    iproject =min(regexpi2(an.ls,'project.*='));
    if iproject==1
        an.ls =[{''}; an.ls];%move project to 2nd line
        iproject=2;
    end
    
    %%  --remove mdirs from list (an.ls)
    try
        %A = {'cat', 'dog'};
        %B = {'bigdoghouse', 'wildcat123', 'mouse'};
        A =an.mdirs;
        B =an.ls;
        matches = cellfun(@(b) any(cellfun(@(a) ~isempty(strfind(b,a)), A)), B);
        %B(matches)
        an.ls(matches)=[];
    end
    
    %% -----
    
    
    color='#33cc33';
    colergen = @(color,text) ['<html><b><font color='  color '   >' text '</html>'  ];
    an.ls{iproject}=colergen('#007700',   an.ls{iproject} );
    %set(findobj(0,'tag','ant'),'name' ,['[ant2]' ' ' projectdir ' (' projname '.m)']);
    set(findobj(0,'tag','ant'),'name' ,['[ANTx2]' ' ' projectdir ' (' projname '.m)']);
    
    
    
    if ~isempty(an.ls{1});         an.ls=[{''} ;an.ls];     end
    try;         msg=makenicer2(an.ls);        catch;         msg=an.ls;    end
    
    hlb2=findobj(0,'tag','lb2');
    set(hlb2,'string',msg,'FontName','courier');
    
    if 0
        %% TOOLTIP
        tip  =  regexprep(msg,{'<html>' '</html>'},'');
        tip{iproject+1}=[ '</b><font color=#000000   >' tip{iproject+1}];
        tip  =  cellfun(@(a){[ a '<br>' ]},  tip);
        tip2 = ['<html><pre>' strjoin(tip,' ') '</pre></html>'];
        set(hlb2,'tooltipstring',tip2);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

if strcmp(do, 'settings');
    global an
    if isempty(an); msgbox('load a project-file first'); return; end
    configfile = an.configfile;
    m= antconfig;
    drawnow;
    
    if isempty(m); return; end
    
    %     dlgTitle    = 'saving?? ';
    %     dlgQuestion = 'Do you wish to save the parameter file?';
    %     choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'No');
    %
    % ==============================================
    %%
    % ===============================================
    
    choices={'overwrite current configfile','save as..','use only now'};
    choice = questdlg({'*** SAVE CONFIGFILE ****',
        ' -This is a mandatory step to later use modified parameters'
        '<overwrite> : save changes in the current configfile  '
        '<save as>   : save changes in a new configfile (name specified via popUp) '
        '<use now>   : use parameters only in this session'
        ' # NOTE: <overwrite> and <save as> reloads the respective configfile'
        }, ...
        'Dessert Menu', ...
        choices{1},choices{2},choices{3},choices{1});
    
    % ==============================================
    %%
    % ===============================================
    
    ichoice=find(strcmp(choices,choice));
    if ichoice==3;
        global an;
        an.configfile=configfile;
        antcb('updateParameterLB');
        return;
    end
    
    
    if ichoice==2 ;% save as..
        [fi, pa] = uiputfile(fullfile(pwd,'*.m'), 'save as configfile (example "project_study1")');
        if pa~=0
            tmpfile=[strrep(fullfile(pa,fi),'.m','') '.m'];
            pwrite2file(tmpfile,m);
            configfile=tmpfile;
        else
            an.configfile=configfile;
            return
        end
    elseif ichoice==1 ;%overwrite
        configfile= [strrep(configfile,'.m','') '.m'];
        pwrite2file(configfile,m);
    end
    
    
    % reload
    %      global an;
    lb3=findobj(gcf,'tag','lb3');
    try; val3=get(lb3,'value');catch;  val3=1;  end
    
    lb1=findobj(gcf,'tag','lb1');
    try; val1=get(lb1,'value');catch;  val1=1;  end
    
    %
    %     if pa==0; configfile='';
    %     else;    configfile=fullfile(pa,fi);
    %     end
    %antcb('quit');
    %     ant;
    if ~isempty(configfile)
        antcb('load',configfile);
        lb3=findobj(gcf,'tag','lb3');        set(lb3,'value',val3);
        lb1=findobj(gcf,'tag','lb1');        set(lb1,'value',val1);
    end
    
    %antcb('reload');
    %disp('reload');
    drawnow();
    
end
%% ===========[close GUI]====================================
if strcmp(do,'close') || strcmp(do,'quit') ;
    close_gui()
end
if strcmp(do,'close?') || strcmp(do,'quit');
    disp(help(['antcb' filemarker 'close_gui'])) ;
end
%% ===[reload]============================================
if strcmp(do,'reload')
    reload_ant();
end
if strcmp(do,'reload?');
    disp(help(['antcb' filemarker 'reload_ant'])) ;
end
%% ===============================================
if strcmp(do,'getsubjects');
    paths=getsubjects;
    varargout{1}=paths;
end
if strcmp(do,'getsubjects?');
    disp(help(['antcb' filemarker 'getsubjects'])) ;
end
%% ===============================================

if strcmp(do,'getallsubjects');
    paths=getallsubjects;
    varargout{1}=paths;
end
if strcmp(do,'getallsubjects?');
    disp(help(['antcb' filemarker 'getallsubjects'])) ;
end

if strcmp(do,'close');
    set(findobj(0,'tag','ant'),'closereq','closereq');
end
%% ===============================================
if strcmp(do,'status');
    status(input)
end
if strcmp(do,'status?');
    disp(help(['antcb' filemarker 'status'])) ;
end
%% ===============================================


% if strcmp(do,'status');
%     if ~iscell(input); input=cell(input);end
%     status(input)
% end

%% ============change command window color (several matlab-sessions open) =================
if strcmp(do,'cwcol');
    if length(input2)>1 && isnumeric(input2{2}) && length(input2{2})==3
        col=input2{2};
    else
        col=uisetcolor;
    end
    
    cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
    listeners = cmdWinDoc.getDocumentListeners;
    %js = listeners(5);  % or listeners(4) or listeners(5), depending on Matlab release
    for i=1:length(listeners)
        js = listeners(i);
        try
            if strcmp(js.getAccessibleName,'Command Window')
                % Note: a safer way would be to loop on listeners until finding a JTextArea instance, since it is not assured to be the 3rd item in the listeners array.
                % Now you can set the colors (which apply immediately) using several alternative ways:
                
                % js.setBackground(java.awt.Color.yellow);
                js.setBackground(java.awt.Color(col(1),col(2),col(3)));
            end
        end
    end
    return
end
if strcmp(do,'cwname');
    if length(input2)>1 && ischar(input2{2})
        cwname=input2{2};
    else
        %         clear input;
        %         drawnow; rehash path;
        %         cwname=inputdlg('enter new comand window name: ');
        cwname=inputCMD('enter new comand window name: ');
        
    end
    com.mathworks.mlservices.MatlabDesktopServices.getDesktop.getMainFrame.setTitle(cwname);
    return
end
%====================================================================================================
%%                                                                                  RUN-MOUSE FIRST    : OLD
%====================================================================================================
% if strcmp(do, 'run');
%     hfun=findobj(gcf, 'tag','lb1');
%
%     id2exe=get(hfun,'value');
%     funlist=antfun('funlist');
%
%     tasks= funlist(id2exe,2) ; %tasks to perform
%
%     for i=1:length(tasks)
%         antfun(tasks{i});
%     end
%
% end

%====================================================================================================
%%                                                                                  RUN-2 :       FUNCTIONS FIRST
%====================================================================================================

if strcmp(do, 'run2') || strcmp(do, 'run');
    antcb('status',1,'running functions');
    hfun=findobj(gcf, 'tag','lb1');
    id2exe=get(hfun,'value');
    funlist=antfun('funlist');
    
    tasks= funlist(id2exe,2) ; %tasks to perform
    paths=antcb('getsubjects');%MousePaths
    if isempty(paths);
        disp('no project loaded');
        antcb('status',0);
        return
    end
    if ischar(paths)
        paths=cellstr(paths);
    end
    
    
    %% HTML SUMMARY REPORT
    if any(cell2mat(regexpi(tasks,'xwarp')))
        %disp('antcb-HTMLstatus: line 306');
        
        HTMLpath=   fileparts(fileparts(paths{1}));
        ht=xhtmlgr('copyhtml','s' ,which('formgr.html'),'t',fullfile(HTMLpath,'summary.html'));
        xhtmlgr('study','page',ht,'study',HTMLpath);
        xhtmlgr('timer','page',ht,'start',datestr(now));
        
        %% HTML-overview-one page for all animals (HTML-refresh at the end)
        HTMLprocsteps(HTMLpath,struct('refresh',1,'show',0));
        
        settings=antsettings;
        if ~isfield(settings,'show_HTMLprogressReport') || (settings.show_HTMLprogressReport==1)
            %isfield(r,'k')==0 || r.k==1
            xhtmlgr('show','page',ht);
        end
        
        do_deleteSummaryLOG = 1;  % delete Logfile.mat at the end
    else
        do_deleteSummaryLOG = 0;
    end
    
    
    %_================================
    %% run only once, i.e. NOT over subjects
    if any(cell2mat(funlist(id2exe,4))==0)
        
        for i=1:size(tasks,1)
            try
                antcb('status',1,tasks{i});
                antfun(tasks{i},paths);
            catch
                antcb('status',0);
            end
        end
        antcb('status',0);
        
        return
    end
    
    
    
    
    %%  BATCH for XWARP
    if ~isempty(regexpi2(tasks ,'xwarp'))
        tasknum=str2num(char(regexprep(tasks,'\D','')))';
        
        bc_autoreg=1;
        if  ~isempty(find(tasknum==20))%manual reg
            bc_autoreg=0;
            tasknum(find(tasknum==20))=2;
        end
        if  ~isempty(find(tasknum==21))%auto reg
            bc_autoreg=1;
            tasknum(find(tasknum==21))=2;
        end
        tasknum=unique(tasknum);
        if strcmp(do, 'run')
            bc_parallel=1;
        else
            bc_parallel=0;
        end
        
        if bc_autoreg==0 & ~isempty(find(tasknum==2)) ;% manualreg does not allow parallel WS
            do= 'run2';   %non-parallel current proc
            bc_parallel=0; %non-parallel batch
            
        end
        
        hh=({['xwarp3(''batch'',''task'','  '[' regexprep(num2str(tasknum),'\s+',' ') '],''autoreg'',' num2str(bc_autoreg)  ',''parfor'',', num2str(bc_parallel) ' ); %% REGISTRATION' ]});
        % xwarp3('batch','task',[1:2],'autoreg',1,'parfor',1)
        
        try
            v = evalin('base', 'anth');
        catch
            v={};
            assignin('base','anth',v);
            v = evalin('base', 'anth');
        end
        v=[v; hh; {'                '}];
        assignin('base','anth',v);
        %disp(v);
        %return
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% ================================
    %%                           RUN-1 (upper RUN button)
    %% ================================
    
    
    
    if strcmp(do, 'run');
        %disp('_____________________________________________');
        %% perform all tasks within a Mouse first
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-21
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-21
        %%collect xwarpFunctions for withinMouse
        global an
        
        %  bind xwarp-processes
        iwarp=  regexpi2(tasks,'xwarp-');
        if ~isempty(iwarp)
            tasksub=tasks(iwarp);
            procs=str2num(char(regexprep(tasksub,'xwarp-','')))';
            autocoreg=1;
            if length(find(procs==20 | procs==21))==2  ;%remove MANUAL if AUTO & MANU were selected both
                procs(procs==20)=[];
            end
            
            if find(procs==20)
                procs(procs==20)=2;
                autocoreg=0;
            elseif find(procs==21)
                procs(procs==21)=2;
            end
            tasks(iwarp(1),1:3)={'xwarp', procs,  autocoreg};
            tasks(setdiff( iwarp ,1)  ,: )=[];
        end
        
        %====================================================================================================
        useparallel=an.wa.usePCT;
        %useparallel=0;
        %====================================================================================================
        if useparallel~=0
            if isempty(ver('distcomp'))==1 %no PARALLEL-TB
                disp('Parallel Computing Toolbox(PCT) not working, check..licence/validation (preferences)');
                disp('..for now process data without PCT');
                useparallel=0;
            end
        end
        
        
        if useparallel==0 % normal VERSION       ----  1 CORE
            for j=1:length(paths)
                for i=1:size(tasks,1)
                    try
                        antfun(tasks{i},paths{j},tasks{i,2:end},an);
                    catch
                        antfun(tasks{i,1},paths{j});
                    end
                end
            end
        end
        %====================================================================================================
        if useparallel==1 % PARALLE-VERSION----  SPMD
            
            global an
            
            
            startspmd(an, paths,tasks);
            
            
            % %             %             mpools=[4 3 2];
            % %             %             for k=1:length(mpools)
            % %             %                 try;
            % %             %                     matlabpool(mpools(k));
            % %             %                     disp(sprintf('process with %d PARALLEL-CORES (SPMD)',mppols(k)));
            % %             %                     break
            % %             %                 end
            % %             %             end
            % %             createParallelpools;
            % %             disp('..PCT-SPMD used');
            % %
            % %             atime=tic;
            % %             %% SPMD
            % %             global an
            % %             if 1
            % %             %spmd
            % %                 for j = labindex:numlabs:length(paths)   %% j=1:length(paths)
            % %                     for i=1:size(tasks,1)
            % %                         %try
            % %                         %  i,j, paths{j}
            % %
            % %                         try
            % %                             disp(sprintf('%d, %d  -%s',j,i,paths{j} ));
            % %                             antfun(tasks{i},paths{j},tasks{i,2:end},an);
            % %                         end
            % %                         %catch
            % %                         % &antfun(tasks{i,1},paths{j});
            % %                         %end
            % %                     end %i
            % %                 end
            % %             end %spmd
            % %             toc(atime);
        end%SPMD
        %====================================================================================================
        %%  PARALLEL VERSION       ----  PARFOR
        if  useparallel==2
            createParallelpools;
            disp('..PCT-PARFOR used');
            
            %             mpools=[4 3 2];
            %             for k=1:length(mpools)
            %                 try;
            %                     matlabpool(mpools(k));
            %                     disp(sprintf('process with %d PARALLEL-CORES',mppols(k)));
            %                     break
            %                 end
            %             end
            
            %             if 0
            %                 pax=paths;
            %                 job=tasks;
            %                 Njob=size(job,1);
            %                 Npax=length(pax);
            %
            %                 parfor j=1:Npax%length(pax)
            %                     %                 for i=1:Njob%size(tasks,1)
            %                     %                     try
            %                     antfun(job{1},pax{j},job{1,2:end});
            %                     %                     catch
            %                     %                         antfun(job{i,1},pax{j});
            %                     %                     end
            %                     %                 end
            %                 end
            %             end
            
            
            %% change for/parfor here
            atime=tic;
            if size(tasks,1)
                %task2=tasks(1,:);
                mouse=paths;
                Nm=length(mouse);
                
                %---do the initialize-step ones to fill the templates folder
                if strcmp(tasks{1},'xwarp')
                    if ~isempty(find(tasks{2}==1))
                        v=mouse{1};
                        antfun(tasks{1} ,v,  1 ,tasks{3}  ,an);
                    end
                end
                
                %===============================================================================
                % loop across mouse
                %===============================================================================
                
                %screensize=get(0,'ScreenSize');
                %sizwin=[screensize(3)*2./4 screensize(4)*2/20];
                %ppm = ParforProgMon('analysis', Nm ,1, sizwin(1),sizwin(2) );
                
                parfor j=1:Nm
                    
                    v=mouse{j};
                    antfun(tasks{1} ,v,  tasks{2} ,tasks{3}  ,an);
                    
                    %ppm.increment();
                    
                    
                end
                %===============================================================================
                
                %===============================================================================
                
                
            end
            
            cprintf('*black', ['..[DONE] ~' sprintf('%2.2fmin', toc(atime)/60) ' \n' ]);
            %         try;    matlabpool close; end
        end%PARFOR VERSION
        
        %% ================================
        %%                           RUN-2 (LOWER RUN button)
        %% ================================
        %% RUN-2
    else
        %% perform each function first over all mice  [lower BUTTON]
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-21
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-21
        
        atime=tic;
        
        % remove manual registration if auto & manu registration were both selected
        iauto=regexpi2(tasks,'xwarp-21');
        imanu=regexpi2(tasks,'xwarp-20');
        if ~isempty(iauto) && ~isempty(imanu)
            tasks(imanu)=[];
        end
        
        
        % run
        for i=1:size(tasks,1)
            for j=1:length(paths)
                antfun(tasks{i},paths{j});
            end
        end
        cprintf('*black', ['..[DONE] ~' sprintf('%2.2fmin', toc(atime)/60) ' \n' ]);
        antcb('update');
    end
    
    
    %% HTML SUMMARY REPORT
    if  do_deleteSummaryLOG == 1;  % delete Logfile.mat at the end
        HTMLpath=   fileparts(fileparts(paths{1}));
        try
            delete(fullfile(HTMLpath, 'summaryLog.mat'));
        end
    end
    
    
    %% HTML-overview-one page for all animals (HTML-refresh at the end)
    HTMLprocsteps(HTMLpath,struct('refresh',1,'show',0));
    
    %update ANT-gui
    antcb('status',0);
end

%% ===============================================
if strcmp(do, 'version');
    varargout{1}=get_version();
    return
end
if strcmp(do, 'version?');
    hlp=(help(['antcb' filemarker 'get_version']));
    disp(hlp);     varargout{1}=hlp;
    return
end

%====================================================================================================
%          version/versionupdate
%====================================================================================================
if strcmp(do, 'version__old_21-12-23');
    
    
    %get_version()
    gitpath=fileparts(which('antlink.m'));
    w=git([' -C ' gitpath ' log -1 --pretty="format:%ci"']);
    if isempty(strfind(w,'fatal'))
        [w1 w2]=strtok(w,'+');
        %dateLU=['ANTx2 v: ' w1 ];
    else
        vstring=strsplit(help('antver'),char(10))';
        idate=max(regexpi2(vstring,' \w\w\w 20\d\d (\d\d'));
        %dateLU=['ANTx2  vers.' char(regexprep(vstring(idate), {' (.*'  '  #\w\w ' },{''}))];
        w1=datestr(char(regexprep(vstring(idate), {  '(' ')' '#\w\w ' },{''})),'yyyy-mm-dd HH:MM:SS');
        %dateLU=['ANTx2 v: ' w1 ];
    end
    dateLU=['ANTx2-v:' w1 ];
    varargout{1}=dateLU;
    
    return
end


%% ===============================================
if strcmp(do, 'versionupdate');
    varargout{1}=versionupdate();
    return
end
if strcmp(do, 'versionupdate?');
    hlp=(help(['antcb' filemarker 'versionupdate']));
    disp(hlp);     varargout{1}=hlp;
    return
end



% if strcmp(do, 'versionupdate');
%     hc=findobj(findobj(0,'tag','ant'),'tag','txtversion');
%     if isempty(hc); return; end
%     version=antcb('version');
%     set(hc,'string',version);
%     return
% end
%% ===============================================
if strcmp(do, 'update')
    update() ;
end
if strcmp(do, 'update?')
    disp((help(['antcb' filemarker 'update'])));
end
%% ===============================================


%====================================================================================================
% gui-functions
%====================================================================================================
function  update()
% update ANTx-GUI
%-update animal-foldes of ANTx-GUI (similar to [update]-button)
% ..this function does NOT update from GitHUB!!!


fig=findobj(0,'tag','ant');
global an
if isempty(an)
    if ~isempty(findobj(0,'tag','ant'))
        disp('no project loaded');
    end
    return;
end
% [dirx,sts] = spm_select(inf,'dir','select mouse folders',[],an.datpath,'s'); %GUI
%     [sts dirx] = spm_select('FPlist',an.datpath,'s');
%     if isempty(dirx); return; end
%     dirx=cellstr(dirx);
%     try
%         dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')   );
%     catch
%         dirsid=   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')
%     end

[sts dirx] = spm_select('FPlist',an.datpath,'');
if isempty(dirx);
    set(findobj('tag','lb3'),'string',''); %empty listbox
    %          delete(get(findobj('tag','lb3'),'UIContextMenu'));%delete contextMenu
    return;
end
dirx=cellstr(dirx);

%% sort after task-performed
if get(findobj(fig,'tag','rbsortprogress'),'value')==1 && length(dirx)>1
    pa=dirx;
    for i=1:size(pa,1)
        pas=pa{i};
        n=1;
        lg(n)=size(dir(fullfile(pas,'c_*.nii')),1)>0;          n=n+1;
        lg(n)=exist(fullfile(pas,   't2.nii'))==2;            n=n+1;
        lg(n)=exist(fullfile(pas,   'reorient.mat'))==2;      n=n+1;
        lg(n)=exist(fullfile(pas,   'c1t2.nii'))==2;          n=n+1;
        lg(n)=exist(fullfile(pas,   'w_t2.nii'))==2;          n=n+1;
        lg(n)=exist(fullfile(pas,   'x_t2.nii'))==2;          n=n+1;
        %             lg(n)=exist(fullfile(pas,   'cbf.nii'))==2;          n=n+1;
        d(i,:)=lg;
    end
    %d2=sum(d.*repmat([1 2 4 8 16],[size(d,1) 1]),2);
    d2=sum(d.*repmat([2.^([1:length(lg)]-1)],[size(d,1) 1]),2);
    
    [is isor]=sort(d2,'descend');
    dirx=pa(isor);
end

%     try
%         dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')   );
%     catch
dirsid=   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'');
%     end

%% CHECK STATE : make status BULLETS
if 1
    chk=[];
    toolt={};
    chklab={'c_*.nii' 't2.nii' ,'reorient.mat' 'c1t2.nii' 'w_t2.nii' 'x_t2.nii' };
    colundone={'WhiteSmoke'  	'#F5F5F5'}; % color of undone process
    cols={
        'greenlight'        '#99ff99'  '&#9632'
        'Gold'              '#FFD700'  '&#9632'
        'Green'  	        '#008000'  '&#9632'
        'LightSkyBlue'  	'#87CEFA'  '&#9632'
        'Orange'  	        '#FFA500'  '&#9632'
        'OrangeRed'  	    '#FF4500'  '&#9632'
        %'Magenta'  	        '#FF00FF'  '&#9733'
        }; %colors
    
    
    %% run configfile
    clear(an.configfile)
    run(an.configfile)
    if isfield(x,'watchfiles')
        for i=1:size(x.watchfiles,1)
            try
                cols(end+1,:)=['usercolor'  x.watchfiles(i,2:3)];
                chklab(end+1)=x.watchfiles(i,1);
            end
        end
    end
    
    for i=1:length(dirx)
        pa=dirx{i};
        chk0=[];
        %         chk0(end+1,1)=exist(fullfile(pa,'t2.nii'))==2   ;%EXIST t2.nii
        %         chk0(end+1,1)=exist(fullfile(pa,'reorient.mat'))==2  ;%reorient MAT
        %         chk0(end+1,1)=exist(fullfile(pa,'c1t2.nii'))==2  ;%segment (c1)
        %         chk0(end+1,1)=exist(fullfile(pa,'w_t2.nii'))==2  ;%SPM warped
        %         chk0(end+1,1)=exist(fullfile(pa,'x_t2.nii'))==2  ;%ELASTIX warped
        %         chk(end+1,:)=chk0;
        
        tt={};
        for j=1:length(chklab)
            k=dir(fullfile(pa,chklab{j}))   ;
            if size(k,1)
                k=k(1);
            end
            
            if ~isempty(k);            tt{end+1,1}  =sprintf('%s:\t\t%s ,  %2.2fMb', chklab{j}, k.date, k.bytes/1e6)   ;
                chk0(end+1,1)=1;
            else
                tt{end+1,1}  =sprintf('%s:\t %s  ', chklab{j}, '    ---not found---')   ;
                chk0(end+1,1)=0;
            end
        end
        chk(end+1,:)=chk0;
        toolt(end+1,1)={tt};
    end
    
    %% check status
    
    dropoutvec=zeros(size(dirx,1),1);
    for i=1:length(dirx)
        statusfile=fullfile(dirx{i},'status.mat');
        if exist(statusfile)==2
            load(statusfile);
            '###WAT IS THAT-line905'
            dropoutvec(i)= 1;%status.isdropout;
        end
    end
    
    %% check USERDEFINED INFO ('msg.mat' on animal-path)
    msg2=repmat({''},[size(dirx,1),2] );
    for i=1:length(dirx)
        msgfile=fullfile(dirx{i},'msg.mat');
        if exist(msgfile)==2
            msg2temp=load(msgfile);
            msg2(i,:)= {msg2temp.msg.m1 msg2temp.msg.m2};
        end
    end
    
    
    
    
    
    
    
    
    %         colundone={'WhiteSmoke'  	'#F5F5F5'}; % color of undone process
    %         cols={
    %             'greenlight'        '#99ff99'  '&#9632'
    %             'Gold'              '#FFD700'  '&#9632'
    %             'Green'  	        '#008000'  '&#9632'
    %             'LightSkyBlue'  	'#87CEFA'  '&#9632'
    %             'Orange'  	        '#FFA500'  '&#9632'
    %             'OrangeRed'  	    '#FF4500'  '&#9632'
    %             'Magenta'  	        '#FF00FF'  '&#9733'
    %             }; %colors
    %
    %
    %         %% run configfile
    %         run(an.configfile)
    %         if isfield(x,'watchfiles')
    %             for i=1:size(x.watchfiles,1)
    %                 cols(end+1,:)=['usercolor'  x.watchfiles(i,2:3)];
    %             end
    %         end
    
    %MAKE TABLE
    %     coltb=num2cell(double(chk)); %to cell
    %     coltb=cellfun(@(a) [num2str(a)],coltb,'UniformOutput',false); %to cellSTR
    cb=repmat(colundone(1,2),size(chk));
    for j=1:size(chk,2)
        for c=1:size(chk,1)
            if chk(c,j)==1
                cb(c,j)=cols(j,2);
            end
        end
    end
    dirsid2=repmat({''},size(dirsid,1),1);
    
    %% AD SAME SPACE AFTER NAMES
    si=size(char(dirsid),2);
    dirsidHTML=cellfun(@(a) [(a) repmat('&nbsp' ,1,si-length(a)  )],dirsid,'UniformOutput',false);
    
    %     symbol='&#9733'; %STAR
    %     symbol='&#9787'; %SMILEY
    symbol='&#9632';%square
    for i=1:size(dirsid,1)
        
        
        %% listbox-animal identifier --------------------------------
        dum=[ dirsidHTML{i} cb(i,:)];
        %             sw=sprintf(['<html>'     '%s'   repmat(['<font color =%s>'  symbol ] ,1, size(cols,1)) char(183) '</html>'  ] ,dum{:} );
        
        ing=[dum(1) reshape([dum(2:end)' cols(:,3)]',[1 size(cols,1)*2 ])];
        sw=sprintf(['<html>'     '%s' ...
            repmat(['<font color =%s>'  '%s' ] ,1, size(cols,1))  ...
            ['<font color=black>' '<b>' msg2{i,1} '</b>' ] ...  %USERDEFINED-INFO
            '</html>'  ] ,ing{:});
        
        
        dirsid2{i,1}=sw;
        
        %% TOOLTIP --------------------------------
        %             tooltdum=cellfun(@(a) [ '<font color=' (a) '>' symbol  '<font color=black'  '>'],cb(i,:)','UniformOutput',false);
        tooltdum=cellfun(@(a,b) [ '<font color=' (a) '>' b  '<font color=black'  '>'],cols(:,2) ,cols(:,3),'UniformOutput',false);
        
        
        tt= cellfun(@(x,y) [x y ],tooltdum,toolt{i},'un',0);
        if dropoutvec(i)==1
            tt=  [ ['<font color=red>' ' *** REMOVED FROM ANALYSIS '] ; tt];
        end
        %USERDEFINED INFO
        if ~isempty(msg2{i,1})
            tt(end+1,:)={['<b>' 'MSG: ' '</b>['  msg2{i,1} '] ' msg2{i,2} ]};
        end
        
        
        head=['<b><font color="blue"> ' dirx{i} ' </b><br> '];
        tt2=[ '<html>' head   strjoin('<br>',tt)  '</html>' ];
        tooltip{i,1}=tt2;
        %         set(o,'tooltipstr',tt2);
    end
    %     set(hf,'string',dirsid)
    %        s{1}=['<html>'  'I will display <font color =#ADFF2F>&#9733<font color ="Aqua">&#9733<font color ="grey">&#9734'   '</html>'  ]
    dirsid=dirsid2;
end


hf=findobj(0,'tag','ant');
lb=findobj(hf,'tag','lb3');
if isfield(an,'mdirs')==0
    preseldirs=dirx(1);
else
    try
        preseldirs=an.mdirs(lb.Value);
    catch
        
    end
end

set(lb,'userdata', [dirsid dirsid tooltip]);


%% displax dropouts using html color
if any(dropoutvec)==1
    idropout=find(dropoutvec==1);
    dirdrop =dirsid(idropout);
    dirdrop=regexprep(dirdrop,{'<html>' '</html>'},{'<html><s><Font color="red">' '</s>/<html>'});
    dirsid(idropout) =dirdrop;
    
end



%  [id ]
%
%  [files1 filesshort]=deal({});
%  for i=1:length(dirx);
%      kk=rdir(fullfile(dirx{i}, '**/s20*.nii'));
%      files1{i,1}  =kk.name;
%      [~ ,fis]=fileparts(kk.name)
%      nameshort= regexprep(fis,'^\w','');
%      usc= strfind(nameshort,'_');
%      nameshort=nameshort(usc(1)+1:usc(3)-1);
%      filesshort{i,1}=nameshort;
%  end
if ~isempty(dirx)
    lb=findobj(gcf,'tag','lb3');
    set(lb,'string', dirsid);%,'userdata',dirx);
    %         set(lb,'fontsize',12);
    if max(get(lb,'value'))>size(dirsid,1)       %prevent invisble LBstate
        set(lb,'value',size(dirsid,1))
    end
    set(lb,'fontname','courier');
    an.mdirs=dirx;
end

%% SET TOOLTIP
%% TOOLTIP :CASES
if  0
    lb3                  =findobj(gcf,'tag','lb3');
    hfun_jScrollPane_lb3 = java(findjobj(lb3));
    hfun_jListbox_lb3     = hfun_jScrollPane_lb3.getViewport.getView;
    set(hfun_jListbox_lb3, 'MouseMovedCallback', {@tooltip_lb3,lb3, tooltip });
end

if 0
    %% TOOLTIP : functions
    funlist=antfun('funlist');
    lb1=findobj(findobj(0,'tag','ant'),'tag','lb1');
    hfun_jScrollPane_lb1 = java(findjobj(lb1));
    hfun_jListbox_lb1     = hfun_jScrollPane_lb1.getViewport.getView;
    set(hfun_jListbox_lb1, 'MouseMovedCallback', {@tooltip_lb1,lb1, funlist(:,3) });
end

if 0
    funlist=antfun('funlist');
    funlist=antfun('funlist');
    lb1                  =findobj(gcf,'tag','lb1');
    hfun_jScrollPane_lb1 = java(findjobj(lb1));
    hfun_jListbox_lb1     = hfun_jScrollPane_lb1.getViewport.getView;
    set(hfun_jListbox_lb1, 'MouseMovedCallback', {@tooltip_lb1,lb1, funlist(:,3) });
end


%% no FONT-SCALING
set(findobj(gcf,'style','listbox'),'FontUnits','pixels');
set(findobj(gcf,'style','pushbutton'),'FontUnits','pixels');
set(findobj(gcf,'style','text'),'FontUnits','pixels');

sort_progress(preseldirs);


%% ===============================================

% sort progress
function sort_progress(preseldirs);
%% ===============================================
% 'default'
% 'progress_down'
% 'progress_up'
% 'lengthName_up'
% 'lengthName_down'
% 'statusmsg_up'
% 'statusmsg_down'
%% ===============================================
hf=findobj(0,'tag','ant');
hl=findobj(hf,'tag','lb3');
hpop=findobj(hf,'tag','pop_sortprogress');
sorter=hpop.String{hpop.Value};
sorter=strrep(sorter,'sort:','');
% disp(sorter);
% sorter='progress_down'
%  sorter='progress_up'
% sorter='default'
% %  sorter='statusmsg_up'
% %sorter='statusmsg_down'
% sorter='lengthName_up'
% % sorter='lengthName_down'

global an;
mdirs=an.mdirs;
% ==============================================
% hl=findobj(gcf,'tag','lb3')
li=get(hl,'string');
va=get(hl,'value');
% selz=zeros(size(li,1),1);
% selz(va)=1;

li2=regexprep( li, '<.*?>', '' );
li3=regexprep(li2,'&nbsp','');

% =======[sort progress]========================================
if strcmp(sorter,'progress_down') || strcmp(sorter,'progress_up')
    len=zeros(size(li,1),1);
    for i=1:length(li)
        len(i)=length( strfind(li{i},'#F5F5F'));
    end
    if strcmp(sorter,'progress_down')
        [~, isort ]=sort(len,'descend');
    else
        [~, isort ]=sort(len,'ascend');
    end
elseif strcmp(sorter,'statusMsg_up') || strcmp(sorter,'statusMsg_down')
    issue=regexprep(li3,{'#\d\d\d\d','.*&'},{''});
    [~,isort ]=sort(issue);
    if strcmp(sorter,'statusMsg_down')
        
    else
        isort=flipud(isort);
    end
elseif strcmp(sorter,'lengthName_up') || strcmp(sorter,'lengthName_down')
    len=cell2mat(cellfun(@(a){[ length(a)]} ,mdirs));
    if strcmp(sorter,'lengthName_down')
        [~, isort ]=sort(len,'ascend');
    else
        [~, isort ]=sort(len,'descend');
    end
elseif strcmp(sorter,'default')
    [~,isort ]=sort(mdirs);
end
mdirsS=mdirs(isort);
if isempty(li)
    [~,mdirsShort]=fileparts2(mdirsS);
    liS   =mdirsShort;
else
    liS   =li(isort);
end



sel=1;
try
    selC=zeros(size(mdirsS,1) ,1); % find selected files
    for i=1:length(preseldirs)
        is=find(strcmp(mdirsS,preseldirs{i}));
        if ~isempty(is)
            selC(is,1)=1 ;
        end
        sel=find(selC);
    end
catch
    sel=1;
end

tt=get(hl,'userdata'); %sort tooltip
tts=tt(isort,:);
% ----update -----
an.mdirs=mdirsS;
hl.String=liS;
hl.Value =sel;
set(hl,'userdata',tts); %set sorted tooltip


%% ===============================================



%% FUNCTIONS-listbox: Mouse-movement callback-->tooltip
function tooltip_lb1(jListbox, jEventData, hListbox,tooltipscell)
mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% hoverIndex = jListbox.locationToIndex(mousePos) + 1;
hoverIndex=get(mousePos,'Y');
fs=get(hListbox,'fontsize');
[hoverIndex   hoverIndex/fs];
est=fs*2;
re=rem(hoverIndex,est);
va=((hoverIndex-re)/est)+1;
%    t=[hoverIndex    va+1   ]
if     va>0 && va<=length(tooltipscell)
    listValues = get(hListbox,'string');
    hoverValue = listValues{va};
    msgStr = sprintf('<html>   <b>%s</b> %s </html>', hoverValue, tooltipscell{va} );
    
    set(hListbox, 'Tooltip',msgStr);
end



%% FUNCTIONS-listbox: Mouse-movement callback-->tooltip
function tooltip_lb3(jListbox, jEventData, hListbox,tooltipscell)
mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% hoverIndex = jListbox.locationToIndex(mousePos) + 1;
hoverIndex=get(mousePos,'Y');
fs=get(hListbox,'fontsize');
[hoverIndex   hoverIndex/fs];
est=fs*2;
re=rem(hoverIndex,est);
va=((hoverIndex-re)/est)+1;
%    t=[hoverIndex    va+1   ]
if     va>0 && va<=length(tooltipscell)
    %     listValues = get(hListbox,'string');
    %     hoverValue = listValues{va};
    %     msgStr = sprintf('<html>   <b>%s</b> %s </html>', hoverValue, tooltipscell{va} );
    %
    set(hListbox, 'Tooltip',  tooltipscell{va}  );
end



%
% popup=get(findobj(hfig,'tag','rb1'),'value')
%
% if strcmp(do, 'run')
%     id=findobj(hfig,'tag','lb1');
%     ls=get(id,'string');
%     fun=ls(get(id,'value'));
%     starttimer
%     for i=1:length(fun)
%         funi=fun{i}
%         dotask(funi)
%     end
%     delete(timerfind('tag','xboxtimer'));
%     hfig=findobj(0,'tag','xbox');
%     set(findobj(hfig,'tag','status'),'string','status: idle');
%     assignin('base','msgtxt','');
% else
%     doguitask(h,emp,do,varargin)
% end

function doguitask(h,emp,do,varargin)
fig=findobj(0,'tag','xbox');
us=get(fig,'userdata');


if strcmp(do, 'update');    update;end
if strcmp(do, 'clearsubjects');    clearsubjects;end



function dotask(funi)
fig=findobj(0,'tag','xbox');
us=get(fig,'userdata');
if strcmp(funi, 'xcreateproject')
    [pax ls]=  feval('xloadproject', 'create');
    set(findobj(0,'tag','xbox'),'userdata',pax,'name' ,pax.projname);
    set(findobj(0,'tag','lb2'),'string', ls);
elseif strcmp(funi, 'xconvert2nifti')
    xconvert2nifti(us);
elseif strcmp(funi, 'xcoregister auto')
    feval(@xcoregister,getselectedcases(us),0);
    
elseif strcmp(funi, 'xcoregister manu')
    feval(@xcoregister,getselectedcases(us),1);
elseif strcmp(funi, 'xsegment')
    feval(@xsegment,getselectedcases(us));
elseif strcmp(funi, 'xnormalizeElastix')
    feval(@xnormalizeElastix,getselectedcases(us));
elseif strcmp(funi, 'xnormalizeElastixSepHemi')
    feval(@xnormalizeElastixSepHemi,getselectedcases(us));
    
elseif strcmp(funi, 'xnormalizeElastixSepHemiTPM')
    feval(@xnormalizeElastixSepHemiTPM,getselectedcases(us));
    
    
end



%
% %====================================================================================================
% % gui-functions
% %====================================================================================================
% function update
% fig=findobj(0,'tag','ant');
% us=get(fig,'userdata');
% if isempty(us); disp('no project loaded');return;end
% [dirx,sts] = spm_select(inf,'dir','select mouse folders',[],us.datpath,'s');
% if isempty(dirx); return; end
% dirx=cellstr(dirx);
%
% try
%     dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[us.datpath filesep],''),filesep,'')   );
% catch
%     dirsid=   strrep(strrep(dirx,[us.datpath filesep],''),filesep,'')
% end
%
% %  [id ]
% %
% %  [files1 filesshort]=deal({});
% %  for i=1:length(dirx);
% %      kk=rdir(fullfile(dirx{i}, '**/s20*.nii'));
% %      files1{i,1}  =kk.name;
% %      [~ ,fis]=fileparts(kk.name)
% %      nameshort= regexprep(fis,'^\w','');
% %      usc= strfind(nameshort,'_');
% %      nameshort=nameshort(usc(1)+1:usc(3)-1);
% %      filesshort{i,1}=nameshort;
% %  end
% if ~isempty(dirx)
%     lb=findobj(gcf,'tag','lb3');
%     set(lb,'string', dirsid,'userdata',dirx);
%     set(lb,'fontsize',10);
% end

function clearsubjects
fig=findobj(0,'tag','ant');
us=get(fig,'userdata');
if isempty(us); disp('no project loaded');return;end
lb=findobj(gcf,'tag','lb3');
set(lb,'userdata',[],'string',[],'value',1);

function us=getselectedcases(us)
hfig=findobj(0,'tag','ant');
figure(hfig);
usecases=get(findobj(hfig,'tag','rb1'),'value');
lb=findobj(hfig,'tag','lb3');
files=get(lb,'userdata');
if usecases==1
    if isempty(files)==0
        files=files.fi;
        files=files((get(lb,'value')));
        us.runfiles=files;
        %           feval(@xcoregister,us,0);
    end
end

function starttimer
try; delete(timerfind('tag','xboxtimer')); end
t = timer('TimerFcn',@timercallback, 'Period', 10,'tag','xboxtimer','ExecutionMode', 'FixedRate');
start(t);

function timercallback(u1,u2)
try
    txt=evalin('base','msgtxt');
    hfig=findobj(0,'tag','xbox');
    %     set(findobj(hfig,'tag','status'),'string',[txt ' ' datestr(now,'HH:MM:SS (dd-mmm)')]);
    set(findobj(hfig,'tag','status'),'string',[txt.tag ' ' sprintf('dt %2.1fmin', etime(clock, txt.time)/60 )  ]);
    
    %       [txt.tag ' ' sprintf('dt %2.1fmin', etime(clock, txt.time)/60 )  ]
    
end

%       set(findobj(hfig,'tag','status'),'string',[txt.tag ' ' sprintf('dt %2.2fs', etime(clock, txt.time))/60  ]);


function paths=getsubjects
% get selected animals, selected from the ANTx-listbox

global an
if isempty(an);
    paths=[];
    disp('no project loaded');
    return;
end
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');
va=get(lb3,'value');
% if ~isempty(findobj(0,'tag','ant'))
if isfield(an,'mdirs')
    paths=an.mdirs(va);
else
    [dirs] = spm_select('FPList',an.datpath,'dir');
    if ~isempty(dirs)
        an.mdirs=cellstr(dirs) ;
        paths=an.mdirs(va);
    end
end
% elseif isempty(findobj(0,'tag','ant')) && isfield(an,'sel')
%     paths=an.sel;
% end

%% remove path which are taken out from analysis
try
    li=get(lb3,'string');
    pathshtml=li(va);
    if ~isempty(pathshtml)
        del=regexpi2(pathshtml,'</s>');
    else
        del=[];
    end
    pathshtml(del)=[];
    paths(   del)=[];
end


function paths=getallsubjects
%obtain all animals from dat-folder
% output: cell containing the fullpath-dirs of all animals
% exammple: mdirs=antcb('getallsubjects');
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');

if isfield(an,'mdirs')==1
    paths=an.mdirs;
else
    tempdir = spm_select('FPList',an.datpath,'dir');
    if isempty(tempdir)
        an.mdirs=[];
    else
        an.mdirs=cellstr(tempdir);
    end
    paths=an.mdirs;
end
% %% remove 'deselected' files
% [pathstr, name, ext] = fileparts2(paths);
% paths(regexpi2(name,'^_'))=[];

function cb_anima(e,e2)
antcb('status',0);
function showanima(arg)
%% ===============================================

hf= findobj(0,'tag','ant');
hs=findobj(hf,'tag','status');
ha=findobj(hf,'tag','showanimation');
if arg==1
    if isempty(findobj(hf,'tag','anima'))
        hr=findobj(hf,'tag','pbloadsubjects');
        pos=get(hr,'position');
        hb=uicontrol(hf,'style','pushbutton','units','norm','tag','anima',...
            'backgroundcolor','w','callback',@cb_anima,'tooltipstring','<html><b>busy</b><br>hit me to hide',...
            'visible',ha.Checked);
        
        fac=[1 1];
        try
            [S1 S2]=getscreensize();%
            fac=S2(1,3:4)./S1(1,3:4);
        end
        
        si=pos(4);
        pos2=[0 pos(2)+pos(4) 0.03 0.03 ];
        set(hb,'pos',pos2);
        %set(hb, 'string',['<html><img src="file:' which('anim4.gif') '"/></html>'],'value',1);
        set(hb, 'string',['<html><img src="file:' which('anim6.gif') '" width="' num2str(22*fac(1)) '" height="' num2str(22*fac(2)) '"></html>'],'value',1);
        %set(hb, 'string',['<html><img src="file:/'   'C:\Users\skoch\Favorites\Downloads\ezgif.com-gif-maker (1).gif' '"/></html>'],'value',1);
        
        set(hb,'units','pixels');
        pos3=get(hb,'pos');
        set(hb,'pos',[pos3(1) pos3(2)+1 22 22]);
        set(hb,'units','norm');
    else
        hb=findobj(hf,'tag','anima');
        hb=hb(1);
        set(hb,'visible',ha.Checked)  ;
    end
    posA=get(hs,'pos');
    if strcmp(ha.Checked,'off')
        set(hs,'pos',[0 posA(2:end)]);
    else
        pos4=get(hb,'pos');
        set(hs,'pos',[pos4(1)+pos4(3)+0.001 posA(2:end)]);
    end
else
    hb=findobj(hf,'tag','anima');
    set(hb,'visible','off')  ;
    posA=get(hs,'pos');
    set(hs,'pos',[0 posA(2:end)]);
end

%% ===============================================

function status(input)
% change status-bar of ANTx-GUI
% example:
% antcb('status',1,'filter data')
% antcb('status',0)
if ~iscell(input); input=cell(input);end
bool=input{1};
try;
    msg=input{2};
end
if exist('msg')==0; msg='';else; msg=['..' msg]; end
hr=findobj(findobj(0,'tag','ant'),'tag','status');
if bool ==1
    set(hr,'string',['status: BUSY!' msg],'foregroundcolor','r');
    set(hr,'TooltipString',['<html><b><font color=red>BUSY since: <font color k>' datestr(now,'HH:MM:SS')]);
    set(hr,'userdata',datestr(now,'HH:MM:SS'));
    
    showanima(1);
    
elseif bool==0
    set(hr,'string',['status: IDLE' msg],'foregroundcolor','b');
    lastprocess=get(hr,'userdata');
    if isempty(lastprocess);
        idlemsg=['<html><b><font color=green>IDLE since: <font color="black">' datestr(now,'HH:MM:SS') '</font></html>'];
    else
        idlemsg=...
            ['<html><pre><font color=gray >last process ended: <font color="black">' lastprocess  '<br>'...
            '<font color=green><b>IDLE since:         <font color="black">' datestr(now,'HH:MM:SS')] ;
        % sprintf(['<html><b>line #1</b><br /><i><font color="red">line#2</font></i></html>']
    end
    set(hr,'TooltipString',idlemsg);
    
    showanima(0);
end
drawnow
pause(.01);



function fontsize(arg)
% temporary change fontsize of ANTx-GUI
% example:
%    antcb('fontsize',5)
%    antcb('fontsize',12)
if exist('arg')~=1
    disp(help(['antcb' filemarker 'fontsize']));
    return
end

x.defaultFS=0;

if nargin==1
    fs=arg{1};
    if ischar(fs)
        if strcmp(fs,'default')
            x.defaultFS=1;
        end
    end
end

% ScreenPixelsPerInch=get(0,'ScreenPixelsPerInch');
if 1%ScreenPixelsPerInch<100
    %     ant
    %     antcb('load','O:\harms1\harms4\proj_Harms4.m');
    hfig=findobj(0,'tag','ant');
    %ch= get(hfig,'children');
    
    %pushbuttons
    ci= findobj(hfig,'tag','pb1');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        s=get(ci,'string');
        set(ci,'string',regexprep(s,'<h\d>','<h0>'),'fontsize',fs-1);
    end
    set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','pb2');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        s=get(ci,'string');
        set(ci,'string',regexprep(s,'<h\d>','<h0>'),'fontsize',fs-1);
    end
    set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','pbload');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','pbloadsubjects');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','pixels');
    
    
    %     ci= findobj(hfig,'tag','status');
    %     set(ci,'fontunits','pixels');
    %     if x.defaultFS==0
    %         set(ci,'fontsize',fs) ;
    %     end
    %     set(ci,'fontunits','pixels');
    
    %      ci= findobj(hfig,'tag','tx_dirsselected');
    %     set(ci,'fontunits','pixels');
    %     if x.defaultFS==0
    %         set(ci,'fontsize',fs) ;
    %     end
    %     set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','lb1');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','lb2');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','pixels');
    
    
    ci= findobj(hfig,'tag','lb3');
    set(ci,'fontunits','pixels');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','pixels');
    return
    %html tag path in infolLB
    ci= findobj(hfig,'tag','lb2');
    set(ci,'fontunits','pixels');
    s=get(ci,'string');
    if x.defaultFS==0
        set(ci,'string',regexprep(s,'+\d"','+0"'));
    end
    set(ci,'fontunits','pixels');
end


function watchfile(input)
if ischar(input) && strcmp(input,'?')
    antcb('helpfun', 'watchfile');
    return
end
% ## watchfile (anker)
% ================================================================================
% WATCHFILES
% watch progress (existence/nonexistence) of one/more files across mousefolders
% the mouse-directory listbox shows the progress of watched files (colored star, right to the mouse name)
% The function just opens a gui. You can select/deselect files across folders,
% you can also chose the color of the icon.
% If a watched file is created, the respective icon of the repsective mouse folder will change the color
% also, if the file is removed, the color of the icon becoms gray
% ================================================================================
% ## watchfile (anker)


watchfiles;


function v=getsubdirs(pa)
%get subdirs of mdirs (mdirs is of type char or cell)
%
%% ==[example-1]=============================================
% mdirs={'F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_12-4_DTI_T2_MPM'
%     'F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_18-9_DTI_T2_MPM'}
% subs=antcb('getsubdirs',mdirs);

if iscell(pa); pa=char(pa); end

[~,dirs] = spm_select('FPList',pa,['.*']);
if ischar(dirs); dirs=cellstr(dirs); end
v=dirs;


function v=selectimageviagui(inp)
% inp{1} ...dataUpperpath
% inp{2} ... single or multi

[o o2]=fileparts2(fileparts2(inp));
if strcmp(o2{1},'dat')   % input are animal-folders
    sdirs=inp;
else                     %input is dat-path
    sdirs=antcb('getsubdirs', inp{1});
    if isempty(char(sdirs))
        v=[];
        cprintf([1 0 0],[' no directory selected \n']);
        return
    end
end
[tb tbh v]=antcb('getuniquefiles',sdirs);
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',inp{2});
v=he;

%%  generate unique list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(agi)
% get unique files in folders 'mdirs' (cell-array)
% output: [tb] ...table of files  [tbh]: header ot table
%
% [tb tbh v]=antcb('getuniquefiles',mdirs);
% EXAMPLE: get all NIFTIs
% mdirs={'F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_12-4_DTI_T2_MPM'
%     'F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_18-9_DTI_T2_MPM'};
% [tb tbh v]=antcb('getuniquefiles',mdirs);
%% ===============================================
% EXAMPLE: get all files
% [tb tbh v]=antcb('getuniquefiles',mdirs,'flt','.*');
%% ===============================================
% EXAMPLE: get all text-files
% [tb tbh v]=antcb('getuniquefiles',mdirs,'flt','.txt');
%% ===============================================


% pa=antcb('getsubjects'); %path
p.flt=['.*.nii*$'];
pin=cell2struct(agi(2:2:end),agi(1:2:end),2);
p=catstruct(p,pin);
pa=p.getuniquefiles;


li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},p.flt);
    %[files,~] = spm_select('FPListRec',pa{i},['.*.nii*$']); % SUSANNE_ different folders
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
%REMOVE FILE if empty folder found
idel        =find(cell2mat(cellfun(@(a){[ isempty(a)]},fifull)));
fifull(idel)=[];
fi2(idel)   =[];

li=unique(fi2);
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    try
        ha=spm_vol(fifull2{i});
        ha0=ha;
        ha=ha(1);
        if length(ha0)==1
            tb{i,1}='3';
            tag='';
        else
            tb{i,1}='4' ;
            tag= length(ha0);
        end
        tb{i,2}=sprintf('%i ',[ha.dim tag]);
        tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
        tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
    catch
        tb{i,2}='-';
        tb{i,3}='-';
        tb{i,4}='-';
    end
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];




%% ===============================================
function  o=gohome(pp)
%% ===============================================

ch=get(0,'children');
set(ch,'CloseRequestFcn','closereq')
cf;

if ispc
    try; evalc('!TASKKILL /F /IM explorer.exe'); end
    try; evalc('!start explorer '); end
elseif ismac
    system('osascript -e ''tell application "Finder" to close windows''');
else %LINUX
    try
        [r1 r2]=system(['xdg-mime query default inode/directory']);
        system([strtok(r2,'.') ' -q']);
        system([strtok(r2,'-') ' -q']);
    end
end

try; system('taskkill /F /IM AutoHotkey.exe');
end


rclosemricron;

% ===============================================
% if 0
%     fclose('all');        % alle offenen Dateien schließen
%     clear java;           % falls Java-Handles (z.B. for dir listing) offen sind
%     cd('C:\');            % weg vom zu entfernenden Laufwerk
%     
%     
%     drive = 'F:';
%     
%     % Powershell-Befehl zum sicheren Entfernen
%     % cmd = sprintf('powershell -command "gwmi Win32_Volume -Filter ''DriveLetter = ''\\''%s\\'''' | ForEach-Object { $_.Dismount($true, $true) }"', drive);
%     
%     cmd = sprintf(['powershell -command "Get-WmiObject Win32_Volume -Filter \\"DriveLetter = ''%s''\\" ' ...
%         '| ForEach-Object { $_.Dismount($true, $true) }"'], drive);
%     % Ausführen
%     [status, msg] = system(cmd)
%     if status == 0
%         disp('Laufwerk erfolgreich sicher entfernt');
%     else
%         warning('Fehler beim Entfernen: %s', msg);
%     end
% end

exit;

%% ===============================================



%% ===============================================
function  o=loop(pp)
%% loop over animals and perform task
%% 'mdirs': optional , otherwise use over selected animals
%   -cellstring of animal names: example: ..'mdirs',{ '1001_a2'   , '1001_copy'},...
%   -empty: use preselected animals
%   -'all': using all animals
%   -numeric vec , using animals by ID , example use firest 3 animals:..'mdirs',[1:3],...
%% 'task': task to perform, use either as single string or list of input-parameters
% single STRING:
% antcb('loop','mdirs',[1:3],'task','a(i,1)=exist(''t2.nii'')');
% list of input-parameters
% antcb('loop','mdirs',[1:3],'task','exist','t2.nii');
%% output:
%  variable(s) as specified in the single-string mode
%  'err'-variable containing animal-specific errors (column: "animalName" "error" (0|1) "errorType"  "animalPath" )
%__________________________________________________
%% internal vars:
%    "i" used for loop across animals --> can be used to slice output
%  if mdirs is set  to 'all' : using all animals
%__________________________________________________
%% EXAMPLES
%_ check if file exist
%   antcb('loop','mdirs',[1:3],'task','a(i,1)=exist(''t2.nii'');');
%_ obtain dim of NIFTI-header
%   antcb('loop','mdirs',[1:3],'task','h=spm_vol(''t2.nii''); a(i,:)=h.dim;');
%_ get length of files
%   antcb('loop','mdirs',[1:3],'task','h=dir;a(i,1)=length(h);');
%_ load t2-file into 4D array
%   antcb('loop','task','[ha a]=rgetnii(''t2.nii'');a2(:,:,:,i)=a;');
%_ make 2d-slice plots of t2.nii
%   antcb('loop','task','slice2png(fullfile(''$mdir'',''t2.nii''),''dim'',1,''showonly'',1);' );
%_ get volume of ABA-caudoputamen
%   antcb('loop','task','vol(i,1)=getvolume(''ANO.nii'',''==672''); ');
%_ show coreg-jpg
%   antcb('loop','task','system(''coreg2.jpg'');');
%_ create new file with caudoputamen as mask
%   antcb('loop','task','[ha a]=rgetnii(''x_t2.nii'');[hm m]=rgetnii(''ANO.nii'');v=a.*(m==672); rsavenii(''_m672.nii'',ha,v );showinfo2([''new file''],fullfile(''$mdir'', ''_m672.nii''));');
%_ append NIFTI-headers to cellarray
% antcb('loop','task','h=spm_vol(''t2.nii''); h2=struct2list(h); if exist(''h3'')~=1; h3={};end; h3=[h3;h2];clear h h2');


% mdirs0='all';
mdirs0='';
task=[];
im=find(strcmp(pp,'mdirs'));
if ~isempty(im);
    mdirs0=pp{im+1};
end
if ischar(mdirs0) && strcmp(mdirs0,'all')
    mdirs=antcb('getallsubjects');
elseif iscell(mdirs0) || ischar(mdirs0)
    mdirs0=cellstr(mdirs0);
    if ~isempty(char(mdirs0))
        antcb('selectdirs',mdirs0) ;
    end
    mdirs=antcb('getsubjects');
elseif isnumeric(mdirs0)
    if isempty(mdirs0)
        mdirs=antcb('getsubjects');
    else
        antcb('selectdirs',mdirs0) ;
        mdirs=antcb('getsubjects');
    end
end
if isempty(char(mdirs)); disp('no animal-dirs selected'); end

it=find(strcmp(pp,'task'));
% if ~isempty(it); task=pp{it+1}; end
task=pp(it+1:length(pp));


[pam animals]=fileparts2(mdirs);
err=[animals num2cell( zeros( length(animals),1 ))   repmat({''}, [length(animals) 1])    mdirs  ];
if isempty(task); return; end
pw=pwd;
pathall=path; pathall=strsplit(pathall,';')';
removepath=0;
if isempty(find(strcmp(pathall,pw)))
    removepath=1;
    addpath(pw);
    drawnow
end


for i=1:length(mdirs)
    disp([' *running: ' mdirs{i}]);
    tt=task;
    if ischar(tt)
        tt=strrep(tt,'$mdir',mdirs{i});
    elseif iscell(tt)
        tt=cellfun(@(a) {[ strrep(a,'$mdir',mdirs{i})]}, tt);
    end
    if length(tt)==1
        cd(mdirs{i});
        if i==1;         fn=who; end
        try
            eval(tt{1});
        catch ME
            disp(lasterr);
            err{i,2}=1;
            %err{i,3}=lasterr;
            err{i,3}=getReport(ME, 'extended', 'hyperlinks', 'off');
        end
        cd(pw);
        %         disp(w);
    else
        cd(mdirs{i});
        if i==1;         fn=who; end
        try
            w222=feval(tt{:});
            try
                g(i,1)=w222;
            end
        catch
            disp(lasterr);
        end
        
        try; disp(w222); end
        cd(pw);
    end
end

%% ===============================================
% fn={'ans','df','im','it' 'mdirs' 'mdirs0','pp' 'pw' ,'task' ,'fn','fn2','i','tt'}
fn=[fn'  'fn' 'fn2' 'df' 'ans' 'w222','ME' ];
fn(strcmp(fn,'err'))=[];
% if any(cell2mat(err(:,2))==1)
%    err
% end
fn2=who;
df=setdiff(fn2,fn);
% assignin('base','a',a)
if ~isempty(df)
    for i=1:length(df);
        eval(['assignin(''base'', ''' df{i} '''  , ' df{i} ' )']);
    end
    disp(['..check vars: '  ['"' strjoin(df,'","') '"']]);
end

%% ===============================================

if  removepath==1;
    rmpath(pw);
end



o=[];

function  o=setparams(pp)
% set specific antx-parameters in parameter-file(proj-file),
% Note that the proj-file is changed accordingly!
% USAGE:
% antcb('set',<PARAMETER>,<VALUE>, <PARAMETER>,<VALUE>, ...); %
% EXAMPLES:
% [1]: change name of the ANTx-project
%    antcb('set','project','project_123');
% [2]: change preorientiation ('orienttype'-parameter)
%    antcb('set','wa.orientType',12);
% [3]: change skullstripping method
%    antcb('set','wa.usePriorskullstrip',6);
% [4]: change preorientiation anf skullstripping method
%    antcb('set','wa.orientType',1,'wa.usePriorskullstrip',7);

o=[];

global an
if isempty(an)
    disp('..no project loaded...load projectfile first..');
end
%% ===============================================

p=pp(2:end);
if isempty(p)
    disp('..input needs parameter to change .. TYPE: antcb(''set?'') for help ');
end
% % p(1:2:end)=cellfun(@(a) {[ 'an.'  a]},p(1:2:end))
% % p = { 'an.wa.orientType'  2   'an.wa.fastSegment'  2 };
% S = struct();
% % ______MAKE NESTED STRUCT FROM CELL
% for k = 1:2:numel(p)
%     parts = strsplit(p{k}, '.');
%     expr = 'S';
%     for j = 1:numel(parts)-1
%         expr = sprintf('%s.(%s)', expr, ['''' parts{j} '''']);
%     end
%     % assign value
%     eval([expr '.(parts{end}) = p{k+1};']);
% end

S=cell2structnested(p);
%_____MERGE STRUCTS
an=mergeStructs2(an,S);



%SAVE PROJECT
% antcb('saveproject') ;% save projfile
evalc('antcb(''saveproject'');');
antcb('updateParameterLB');
if 0
    antcb('reload')      ;% reload projfile
end
%% ============================================


function S=cell2structnested(p)

S = struct();
% ______MAKE NESTED STRUCT FROM CELL
for k = 1:2:numel(p)
    parts = strsplit(p{k}, '.');
    expr = 'S';
    for j = 1:numel(parts)-1
        expr = sprintf('%s.(%s)', expr, ['''' parts{j} '''']);
    end
    % assign value
    eval([expr '.(parts{end}) = p{k+1};']);
end

%% ===============================================
function A = mergeStructs2(A, B)
% Recursively merge struct B into struct A
%
% If fields overlap:
%   - If both are structs, merge them recursively
%   - Otherwise, values from B overwrite values in A

fn = fieldnames(B);
for k = 1:numel(fn)
    f = fn{k};
    if isfield(A, f)
        if isstruct(A.(f)) && isstruct(B.(f))
            % Recursive merge for substructs
            A.(f) = mergeStructs2(A.(f), B.(f));
        else
            % Overwrite with B's value
            A.(f) = B.(f);
        end
    else
        % Add new field from B
        A.(f) = B.(f);
    end
end




%% ===============================================
function  o=countfiles(pp)
% # search and count specific files in animal-folders
% o=antcb('countfiles', flt);
% o=antcb('countfiles', flt,'disp');  %display in cmd
% o=antcb('countfiles', flt,'win');   %display in extra window
%
%-INPUT---
% flt   : filter (string or cell) files based on filename
%         use regular expressions such as: ^,$,.*
% 'disp': display animals with found files in cmd-window
% 'win': display animals with found files in separate-window (figure)
%
%-OUTPUT---
% vector with filecounts (length:  mdirs x 1)
% vector corresponds to animal-dirs ..see: mdirs=antcb('getallsubjects');
%
% #examples
% -- count all nifti-files containing 'MPM_3D_0p15'
% o=antcb('countfiles','MPM_3D_0p15.*.nii');
% ---same but show in cmd-window
% o=antcb('countfiles','MPM_3D_0p15.*.nii', 'disp');
% -- count all niftis that are 'c1t2.nii', c2t2.nii, and c3t2.nii and display in cmd-window
% o=antcb('countfiles',{'^c1t2.nii$' '^c2t2.nii$' '^c3t2.nii$'},'disp');
% -- count all *.png or *.jpg-files and display in cmd-window
% [o ]=antcb('countfiles','.*.png|.*.jpg','disp');
% -- count all nifti-files
% [o ]=antcb('countfiles','.*.nii');
% -- count all nifti-files and display in extra window
% [o ]=antcb('countfiles','.*.nii','win');

o=[];
%% ===============================================
pp=pp(2:end);
flt=pp{1};   flt=cellstr(flt);
displayfile=0;
if length(pp)>1
    if ~isempty(regexpi2(pp(2:end),'disp'))
        displayfile=1;
    elseif ~isempty(regexpi2(pp(2:end),'win'))
        displayfile=2;
    end
end

mdirs=antcb('getallsubjects');
% flt='MPM_3D_0p15.*.nii';
% flt={'^c1t2.nii$' '^c2t2.nii$' '^c3t2.nii$'};
nc=zeros(length(mdirs),1);
g={};
g{end+1,1}=['filter: ' strjoin(flt,',')];
g{end+1,1}='=============================';
g{end+1,1}='  found files ';
g{end+1,1}='=============================';

for i=1:length(mdirs)
    md=mdirs{i};
    [fis] = spm_select('List',md,flt);
    if isempty(fis);
        n=0;
    else
        fis=cellstr(fis);
        n=length(fis);
        if displayfile==1;
            % showinfo2('animal', md);
            % disp([   '  ..contains: "'  strjoin(fis,'" , "') '"']);
            showinfo2([ pnum(i,3) ') ' ], md,'','', '..contains:');
            disp(char(cellfun(@(a) {[  repmat(' ',[1 10]) a ]},fis)));
        elseif displayfile==2;
            [~,animal]=fileparts(md);
            g{end+1,1}= [[ pnum(i,3) ') [' animal ']  ..fullpath:"' md  '"'  ]];
            g=[g; cellfun(@(a) {[  repmat(' ',[1 10]) a ]},fis)];
        end
    end
    nc(i,1)=n;
end
o=nc;

if displayfile==2;
    uhelp(g,0,'name','found files');
end

%% ===============================================
function  o=getlabels(pin)
%% ===============================================
% get atlas IDs & labels from xyz-coordinates (as 'mm' or 'indices')
% INPUTS:
% xyz        xyz-data  (n x 3) as  'mm' or 'indices' 
% optional: 
% units      xyz-input as: 'mm' or 'indices' ; default: 'mm'
% file       fullpath-atlasfile (nifti), if emtpy take 'ANO.nii' from study's templates-path
% getlabels  get region labels; [0,1]; default:[1]
% show       show output; [0,1] ; default:[1]
% 
% EXAMPLES:
% get labels using mm-cordinates
% antcb('getlabels','xyz',[-3 -2 -1; 3 0 -4; 2 -3 -1]);
% antcb('getlabels','xyz',[-3 -2 -1; 3 0 -4; 2 -3 -1],'show',1);
% 
% get labels using  using indices:
% antcb('getlabels','xyz',[109 87 106],'units','indices');
% antcb('getlabels','xyz',[109 87 106; 71 181 92],'units','indices');
% 
% use a specific atlas
% antcb('getlabels','xyz',[-3 -2 -1; 3 0 -4; 2 -3 -1],'file', 'F:\data5\nogui\templates\ANO.nii');




o=[];
p.file      =''   ;% fullpath-atlasfile (nifti), if emtpy take 'ANO.nii'
p.units     ='mm' ; % xyz-input as: 'mm' or 'indices'
p.getlabels =1    ; % get region labesl [0,1]
p.show      =1    ; % show output [0,1] 
p.xyz       =0    ; % xyz-data  (n x 3) as  'mm' or 'indices' 



if ~isempty(pin)
    p2=cell2struct(pin(2:2:end),pin(1:2:end),2);
    p=catstruct(p,p2);
end
if isempty(p.file)
    pas   =antcb('getstudypath');
    patemp=fullfile(pas,'templates');
    
    p.file=fullfile(patemp,'ANO.nii');
end
if exist(p.file)~=2; error('atlas-file does not exist'); end
%% ===============================================
v = spm_vol(p.file);
ids=zeros(size(p.xyz,1),1);
if strcmp(p.units,'mm')
    for i=1:size(p.xyz,1)
        ijk = round(inv(v.mat) * [p.xyz(i,:) 1]'); % mm -> voxel
        if all(ijk(1:3) >= 1) && all(ijk(1:3)' <= v.dim) % bounds check
            id = spm_get_data(v, ijk(1:3));
        else
            id = NaN;
        end
        ids(i,1)=id;
    end
elseif strcmp(p.units,'indices')
    %p.xyz=[109 87 106]
    for i=1:size(p.xyz,1)
        ijk = p.xyz(i,:)';
        if all(ijk(1:3) >= 1) && all(ijk(1:3)' <= v.dim) % bounds check
            id = spm_get_data(v, ijk(1:3));
        else
            id = NaN;
        end
        ids(i,1)=id;
    end
end
% ids
%% =====[read excelfile]==========================================
if p.getlabels==1
    [patemp name ext]=fileparts(p.file);
    f2=fullfile(patemp,[name '.xlsx']);
    if exist(f2)==2
        [~,~,a0]=xlsread(f2);
        a=xlsprunesheet(a0);
        ha=a(1,:);
        a=a(2:end,:);
        idlist=cell2mat(a(:,4));
        idlabels=repmat({'-'},[size(ids,1)  1]);
        for i=1:size(ids,1)
            ix=find(idlist==ids(i));
            if ~isempty(ix)
                idlabels(i,1)=a(ix,1);
            end
        end
        t1=[num2cell(ids) idlabels ];
    end
    t2=cell2table(t1,'VariableNames',{'ID','region'} );
else
    t2=[(ids) ];
end

if p.show==1
    disp(t2);
end
o=t2;




%% ===============================================



%% ===============================================
function  o=getstudypath(par0)
% get path of current study
% output is empty, if no ANTx-project is loaded
% USAGE___
% studypath=antcb('getstudypath')
% 

% 

o=[];
global an
if isempty(an);
    disp('no ANTx-study loaded');
    return;
end
o=fileparts(an.datpath);


%% ===============================================
function  o=setpreorientation(par0)
% Change preorientation (paramter: 'orientType') via comandline.
% Changes of the 'orientType'-parameter will be also update the project-file!
% USAGE___
% set preorientation (orientType, value)  ;% value refers to a rotation-table index (example: [1])
% set preorientation (orientType, string) ; string contains the 3 angles in radions (example: 'pi/2 pi pi')
% EXAMPLE___
% antcb('setpreorientation',12);           %sets preorientation to [12]
% antcb('setpreorientation','pi/2 pi pi'); %sets preorientation to 'pi/2 pi pi'
% 

o=[];

global an
an.wa.orientType=par0{1}            ;% set orientType to [1]
evalc('antcb(''saveproject'')')     ;% save projfile
% antcb('reload')  ;  % evalc('antcb(''reload'')');% reload projfile

ls=an.ls;
ir=~cellfun(@isempty, regexpi(ls,'an.wa.orientType'));
if isnumeric(par0{1});
lin=['an.wa.orientType=[' num2str(par0{1}) '];'];
else
  lin=['an.wa.orientType='''  (par0{1}) ''';'] ;
end
ls{ir}=lin;
msg=makenicer2(ls);       
hf=findobj(0,'tag','ant');
hlb2=findobj(hf,'tag','lb2');
set(hlb2,'string',msg);

disp(['preorientation (orientType) set to: ' num2str(an.wa.orientType) ' ..proj-file was updated..']);


% clear an



%% ===============================================
function  o=getpreorientation(par0)
% # obtain HTML-file with possible pre-orientations of 't2.nii' to 'AVGT.nii' from 'templates'-folder
% this is a shortcut of 'xgetpreorientationHTML'
% templates must be already imported to study-folder
% per default the 1st animal is used to obtain the pre-orientations
% Use the best-matching rotation index from the HTML file to update the orientType variable
% in the project file.
% USAGE:
% antcb('getpreorientation');               %get the pre-orientation (use implicitly 1st animal)
% antcb('getpreorientation','selectdirs',1); %use 1st animal from animal-listbox to get the pre-orientation
% antcb('getpreorientation','selectdirs',3); %use 3rd animal from animal-listbox to get the pre-orientation
% antcb('getpreorientation','selectdirs','20250318MO_SCI_Ko02_exvivo');  %use this animal to get the pre-orientation
%
%
o=[];
par=par0;
if length(par)==1  && strcmp(par{1},'?');         help antcb>getpreorientation;     return    ;     end
if isempty(par)
    s=struct();
else
    s=cell2struct(par(2:2:end),par(1:2:end),2);
end
%% ===============================================
if isfield(s,'selectdirs')==1
    antcb('selectdirs',s.selectdirs)
else
    antcb('selectdirs',1) ; %select first animal
end
mdirs= antcb('getsubjects'); %get path of this animal
global an
z=[];
z.target       = fullfile(fileparts(an.datpath), 'templates' ,'AVGT.nii')    ;% target-image                                             % % reference image
z.source       = fullfile(mdirs{1}, 't2.nii')                                ;% source image
z.outputstring = 'Reorient'                                                  ;%prefix of HTML-fileName

if exist(z.target)~=2
    %% COPY TEMPLATES TO STUDY-FOLDER
    antcb('copytemplates');  %copy templates
end
if exist(z.source)~=2
    msg={['[t2.nii] not found in: "' z.source '"']
        ['..rename file to "t2.nii" before running this function' ]};
    error( strjoin(msg,char(10)));
end

xgetpreorientationHTML(0,z);



%% ===============================================
function  projectfile=saveproject(par0)
% # MODIFY AND SAVE CURRENT CONFIG-FILE (AKA PROJECT-FILE/projfile)
% projfile=antcb('saveproject') ; overwrite current projfile
% projfile=antcb('saveproject','saveas',<fullfpath to projfile>);
% ________________________________________________________________________________
% EXAMPLE: save project as 'projC1.m'
% antcb('saveproject','saveas',fullfile(pwd,'projC1.m'));
% ________________________________________________________________________________
% EXAMPLE: MODIFY AND OVERWRITE currcent project
% global an
% an.wa.orientType=3   ;% set orientType to [2]
% antcb('saveproject') ;% save projfile
% antcb('reload')      ;% reload projfile
% ________________________________________________________________________________
% EXAMPLE: MODIFY AND OVERWRITE currcent project
% global an
% an.project='projectA'   ;% set orientType to [2]
% antcb('saveproject') ;% save projfile
% antcb('reload')      ;% reload projfile


%% ===============================================
projectfile=[];
par=par0;
if length(par)==1  && strcmp(par{1},'?');         help antcb>saveproject;     return    ;     end
%% ===============================================
global an;
x=an;
configfile0=x.configfile;

try; x=rmfield(x,'configfile'  ); end
try; x=rmfield(x,'templatepath'); end
try; x=rmfield(x,'mdirs'       ); end
try; x=rmfield(x,'ls'          ); end
fn=fieldnames(x);
x=rmfield(x,fn(regexpi2(fn,'^inf\d+')));
w2=struct2list(x);
w2=makenicer2(w2);
w2=[w2; repmat({''},[5 1])];

if isempty(par)
    s=struct();
else
    s=cell2struct(par(2:2:end),par(1:2:end),2);
end
if isfield(s,'saveas')==1
    configfile=s.saveas;
else
    configfile=configfile0;
end
[pa name ext]=fileparts(configfile);
if isempty(pa) ;  pa  =pwd      ; end
if isempty(ext);  ext ='.m'     ; end
if isempty(ext);  name ='proj.m'; end
configfile=fullfile(pa,[name ext]);

pwrite2file(configfile,w2);
projectfile=configfile;
fprintf(['.. save/update project file [' [name ext] ']  ']);
disp(['<a href="matlab:edit('''  projectfile ''')">'  'inspect'     '</a>']);
%% ===============================================

% makeproject('projectname',fullfile(pwd,'projC.m'), w(:) );
%

%% ===============================================


%% ===============================================


function  projectfile=makeproject(par0);
fprintf('.. create project file ...');
projectfile=[];
par=par0;
if length(par)==1 | isempty(par0);           helpfun('makeproject');     return    ;     end

%% check wheter a saving name is given
ixsave=regexpi2(par,'^saveas$');
if isempty(ixsave)
    disp('..cannot save the project file "saveas" (fullpathname or name) is undefined ');
    return
else
    savename=par{ixsave+1};
    par(ixsave:ixsave+1)=[];
end

%% get defaults
[m2 z2]=antconfig(0,'parameter','default','savecb','no');
% z2bk=z2;

%% add parameters
par(1:2:end)=cellfun(@(a){[ 'z2.' (a)]},par(1:2:end));
for i=1:2:length(par)
    eval( [par{i}  '=par{' num2str(i) '+1}'  ';' ]  );
end


%% make list
x=z2;
x=rmfield(x,'ls');
fn=fieldnames(x);
x=rmfield(x,fn(regexpi2(fn,['^inf'])));
l=struct2list(x);
l=['%  DEFAULTS     ' ;l];

%% save
[px fi et]=fileparts(savename);
if isempty(px); px=pwd; end
savename=fullfile(px,[fi '.m'])   ;
pwrite2file(savename,l);

projectfile=savename;
fprintf('.. \b\b\b done\n');


function helpfun(subfun)

h=preadfile('antcb.m'); h=h.all;
ix=regexpi2(h, ['##.*' subfun]);
try
    disp(char(h(ix(1)+1:ix(2)-1)));
end
% ##  saveproject
% save modified project file
% bla
% ##  saveproject
%
%
% ##  makeproject
% creates a new project file (*.m)
% antcb('makeproject',pariwaise parameters...)
%  additonal parameters must come in pairs
%  mandatory parameters pairs:
%    - 'saveas'   'xx', ..where xx is the name or fullpath name to save the project file (m-file)
%                       -if no fullpath name is provided, the project file is stored in the current directory
%    - 'datpath'  'xx', ..where xx the fullpath  pointing to "dat"-folder
%
% -----for other parameters: see example project below :
% *** CONFIGURATION PARAMETERS - EXAMPLE  ***
% ===================================
% %  DEFAULTS
% x.project=               'NEW PROJECT';	% PROJECTNAME OF THE STUDY (arbitrary tag)
% x.datpath=               'O:\data2\analyzeProblem\dat';	% studie's datapath, MUST BE be specified, and named "dat", such as "c:\b\study1\dat"
% x.voxsize=               [0.07  0.07  0.07];	% voxelSize (default is [.07 .07 .07])
%
% %  WARPING
% x.wa.refTPM=             { 'o:\antx\mritools\ant\templateBerlin_hres\_b1grey.nii' 	% c1/c2/c3-compartiments (reference)
%                            'o:\antx\mritools\ant\templateBerlin_hres\_b2white.nii'
%                            'o:\antx\mritools\ant\templateBerlin_hres\_b3csf.nii' };
% x.wa.ano=                'o:\antx\mritools\ant\templateBerlin_hres\ANO.nii';	% reference anotation-image
% x.wa.avg=                'o:\antx\mritools\ant\templateBerlin_hres\AVGT.nii';	% reference structural image
% x.wa.fib=                'o:\antx\mritools\ant\templateBerlin_hres\FIBT.nii';	% reference fiber image
% x.wa.refsample=          'o:\antx\mritools\ant\templateBerlin_hres\_sample.nii';	% a sample image in reference space
% x.wa.create_gwc=         [1];	% create overlay gray-white-csf-image (recommended for visualization)
% x.wa.create_anopcol=     [1];	% create pseudocolor anotation file (recommended for visualization)
% x.wa.cleanup=            [1];	% delete unused files in folder
% x.wa.usePCT=             [2];	% use Parallel Computing toolbox (0:no/1:SPMD/2:parfor)
% x.wa.usePriorskullstrip=[1];	% use a priori skullstripping
% x.wa.elxParamfile=       { 'o:\antx\mritools\elastix\paramfiles\Par0025affine.txt' 	% ELASTIX Parameterfile
%                            'o:\antx\mritools\elastix\paramfiles\Par0033bspline_EM2.txt' };
% x.wa.elxMaskApproach=    [1];	% currently the only approach available (will be more soon)
% x.wa.tf_ano=             [1];	% create "ix_ANO.nii" (template-label-image)                       in MOUSESPACE (inverseTrafo)
% x.wa.tf_anopcol=         [1];	% create "ix_ANOpcol.nii" (template-pseudocolor-label-image label) in MOUSESPACE (inverseTrafo)
% x.wa.tf_avg=             [1];	% create "ix_AVGT.nii" (template-structural-image)                 in MOUSESPACE (inverseTrafo)
% x.wa.tf_refc1=           [1];	% create "ix_refIMG.nii" (template-grayMatter-image)               in MOUSESPACE (inverseTrafo)
% x.wa.tf_t2=              [1];	% create "x_t2.nii" (mouse-t2-image)                         in TEMPLATESPACE (forwardTrafo)
% x.wa.tf_c1=              [1];	% create "x_c1t2.nii" (mouse-grayMatter-image)               in TEMPLATESPACE (forwardTrafo)
% x.wa.tf_c2=              [1];	% create "x_c2t2.nii" (mouse-whiteMatter-image)              in TEMPLATESPACE (forwardTrafo)
% x.wa.tf_c3=              [1];	% create "x_c3t2.nii" (mouse-CSF-image)                      in TEMPLATESPACE (forwardTrafo)
% x.wa.tf_c1c2mask=        [1];	% create "x_c1c2mask.nii" (mouse-gray+whiteMatterMask-image) in TEMPLATESPACE (forwardTrafo)
% ================================================================================
% EXAMPLE
%% create a new project and save it as project1.m in the current folder, the data-path (datpath!) must be set!
%    antcb('makeproject',  'saveas','project1',  'datpath', 'O:\data2\jing\dat' )
% ## makeproject



function out=selectdirs(input, nargoutCaller);
% ## selectdirs (anker)
% ================================================================================
% SELECTDIRS - SELECT MOUSE DIRECTORIES in ANT-GUI:
%  specify either (all dirs),(via id),(via existing/nonexisting file within folder) or (from list)
% use "selectdirs" or "sel" to select directories
% EXAMPLES:
% antcb('sel')                 ;%select all directories
% antcb('selectdirs')          ;%select all directories
% antcb('selectdirs','all');                          ;%(same as above )select all directories
% antcb('selectdirs','none');                         ;%select no animal folder (deselect all)
% antcb('selectdirs',[1 2]);                          ;%select directories 1 and 2 (selected by index)
%
%% select dirs by string in animal-name
% antcb('selectdirs','dirs','bad|data' )          ; %select all animals with string "bad" or "data" in animal name
% antcb('selectdirs','dirs',{'Dev' 'cha' 'k33'} ) ; %select all animals with string 'Dev','cha' or 'k33' in animal name
% antcb('selectdirs','dirs','^bad|^1001' )        ; %select all animals starting with string "bad" or "1001" in animal name
% antcb('selectdirs','dirs','8$|195$' )           ; %select all animals ending with string "8" or "195" in animal name
% antcb('selectdirs','dirs','^bad.*195$' )
%
%% select dirs containing or not containing specific files
% 1st arg: 'selectdirs'
% 2nd arg: 'file'
% 3rd arg: one or more filenames; as cell for multiple files to search, otherwise char
% 4rd arg: optional, the operator
%         'and'    (or '&')     all files must exist in folder
%         'or'     (or '|')     one of the files must exist in folder
%         'andnot' (or '~&')    all files must not exist in folder
%         'or'     (or '~|')    one of the files must not exist in folder
% -----------[ SLECT DIRS BY FILENAMES]-------
% antcb('selectdirs','file',{'t2.nii'});          % select all dirs containing the file"t2.nii"
% antcb('selectdirs','file',{'x_t2.nii'},'not');  % select all dirs not containing the file"x_t2.nii
%
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'and');   %select all dirs containing both 't2.nii' and 'x_t2.nii'
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'&');     %same as previous line
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'andnot');%select all dirs not containing both 't2.nii' and 'x_t2.nii'
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'~&');    %same as previous line
%
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'or');  %select all dirs containing either 't2.nii' or 'x_t2.nii'
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'|');   %same as previous line
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'ornot'); %select all dirs not containing either 't2.nii' or 'x_t2.nii'
% antcb('selectdirs','file',{'t2.nii' 'x_t2.nii'},'~|');    %same as previous line
% antcb('sel','file','mag.nii|wer.nii|t2.nii')             % select all dirs containing 'mag.nii' or 'wer.nii' or 't2.nii'
%
% -----------[ SLECT DIRS BY STATUS-MESSAGE]----------------------------------------------------
% note status has be be set in advance!
%% select all animals with status-tag "charge1"
%  antcb('selectdirs','status','charge1');
%% select all animals with status-tag "charge2"
%  antcb('selectdirs','status','charge2');
%% select all animals with status-tag "charge1" or "charge2"
% antcb('selectdirs','status',{'charge1' 'charge2'});
% same as with explicit 'or'-operator
% antcb('selectdirs','status',{'charge1' 'charge2'},'or');
%
%% example: select only those animals tha contain all of the following files: 'NI_b100.nii','NI_b900.nii','NI_b1600.nii' and 'NI_b2500.nii'
% antcb('selectdirs','file',{'NI_b100.nii' 'NI_b900.nii' 'NI_b1600.nii' 'NI_b2500.nii'},'and');
%
% -----------[OTHER EXAMPLES] ----------------------------------------------------
% by ANIMAL-NAME
% antcb('selectdirs',{'MMRE_age_20w_mouse5_cage6_13122017'}); %select this directory
% antcb('selectdirs',{'MMRE_age_20w_mouse5_cage6_13122017'
%                     'MMRE_age_20w_mouse5_cage6_13122017'}); %select several directories by list
%-------------
%% OPTIONAL OUTPUTS arguments (up to 4)
% 1st out-arg: fullpath list of selected animal-folders {cell}
% 2nd out-arg: list of selected animals {cell}
% 3rd out-arg: fullpath list of selected animal-folders {cell}, Matlab-style with curlies
% 4th out-arg: list of selected animals {cell}, Matlab-style with curlies
% example: select the 1st two animals and obtain output variab\s
% [r1 r2 r3 r4]=antcb('selectdirs',[1 2])
% r1 =
%     'F:\data5\nogui\dat\1001_a1'
%     'F:\data5\nogui\dat\1001_a2'
% r2 =
%     '1001_a1'
%     '1001_a2'
% r3 =
%     '{'
%     '  'F:\data5\nogui\dat\1001_a1''
%     '  'F:\data5\nogui\dat\1001_a2''
%     '};'
% r4 =
%     '{'
%     '  '1001_a1''
%     '  '1001_a2''
%     '};
% ================================================================================
% ## selectdirs (anker)


% if ischar(input) && strcmp(input,'?')
%     '###'
%     antcb('helpfun', 'selectdirs');
%     return
% end
out{1}=[];
global an

input=input(2:end);

if  isempty(input)
    input{1}='all';
end
% if isempty(input); input{1}='all'  ; end

hfig=findobj(0,'tag','ant');
lb3=findobj(hfig,'tag','lb3'); %get mouse folder
li=get(lb3,'string');

usegui=1;
if isempty(hfig) && isempty(lb3)
    usegui=0;
    if isfield(an,'mdirs')==0
        [li] = spm_select('FPList',an.datpath,'dir','.*');
        li=cellstr(li);
    else
        li=an.mdirs;
    end
end

% md    = regexprep(strrep(li,'<html>',''),'<font.*','');   %mouseupDirs
% fp    = stradd(md,[an.datpath filesep],1);                %fullpath mouseDirs

fp=antcb('getallsubjects');
px=fileparts(fp{1});
md=strrep(fp,[px filesep],'');

if strcmp(input{1},'all')
    iselect=[1:length(li)];
    set(lb3,'value',iselect);
elseif strcmp(input{1},'none')
    iselect=[];
    set(lb3,'value',iselect);
    
elseif isnumeric(input{1})
    del=setdiff(input{1},[1:length(li)]);
    isect=intersect(input{1},[1:length(li)]);
    if ~isempty(del)
        disp(['could not found following mouse-indices: ' regexprep(num2str(del(:)'),'\s+',';')]);
    end
    iselect=isect;
    set(lb3,'value',iselect);
    % elseif ~isempty(strfind(char(input{1}),'.nii') )
elseif all(strcmp(input{1},'file')) || all(strcmp(input{1},'status')) || all(strcmp(input{1},'files'))
    %% =================find file(s) in folder ===========
    if strcmp(input{1},'status')
        hb=findobj(findobj(0,'tag','ant'),'tag','lb3');
        lis=get(hb,'string');
        lisstatus=(regexprep( lis, {'<.*?>','.*;'}, '' ));
        %searchtok=input{2};
        if ischar(input{2})
            searchtok={input{2}};
        else
            searchtok=input{2};
        end
        
        %isexist=zeros(size(fp,1), 1);
        %isexist=strcmp(lisstatus, searchtok);
        
        isexist=zeros(size(fp,1), length(searchtok));
        for i=1:length(fp)
            for j=1:length(searchtok)
                if strcmp(lisstatus{i},searchtok{j})==1
                    isexist(i,j)=1;
                end
            end
        end
        
        
    else
        if ischar(input{2})
            files={input{2}};
        else
            files=input{2};
        end
        % in case of "|"-tags ('mag.nii|klaus.nii') --> split
        or_char=0;
        if ~isempty(regexpi2(files,'\|'))
            dum0={};
            for i=1:length(files)
                dum=strsplit(char(files(i)),'|');
                dum0=[dum0; (dum(:))];
            end
            files=dum0;
            or_char=1;
        end
        
        isexist=zeros(size(fp,1), length(files));
        for i=1:length(fp)
            for j=1:length(files)
                if exist(fullfile(fp{i},files{j}))==2
                    isexist(i,j)=1;
                end
            end
        end
    end
    t_and=sum(isexist,2)==size(isexist,2);
    t_or =any(isexist,2);
    
    t_andnot= sum(isexist,2)==0;
    t_ornot= sum(isexist,2)<size(isexist,2);
    
    try
        oper=input{3};
    catch
        if strcmp(input{1},'status')
            oper='or';
        else
            oper='and';
            if or_char==1
                oper='or' ;
            end
        end
    end
    
    iselect=[];
    if strcmp(oper,'and')        || strcmp(oper,'&')
        iselect=find(t_and);
    elseif strcmp(oper,'or')     || strcmp(oper,'|')
        iselect=find(t_or);
    elseif strcmp(oper,'andnot') || strcmp(oper,'~&') || strcmp(oper,'not')
        iselect=find(t_andnot);
    elseif strcmp(oper,'ornot')  || strcmp(oper,'~|')
        iselect=find(t_ornot);
    end
    
    %disp(sel)
    set(lb3,'value',iselect);
    
    %% ===============================================
elseif all(strcmp(input{1},'dirs')) || all(strcmp(input{1},'dir'))
    %% ===============================================
    
    input{2};
    str=cellstr(input{2});
    ix=[];
    for i=1:length(str)
        ixn=regexpi2(md,str{i});
        ix=[ix; ixn(:)];
    end
    ix=unique(ix);
    if ~isempty(ix)
        set(lb3,'value',ix);
    else
        set(lb3,'value',[]);
    end
    
    %% ===============================================
    
else
    % short-SEARCH FOR ANIMAL-FOLDERS ... such as:
    %antcb('selectdirs',{'animalName2','animalName2'})
    %antcb('selectdirs',[1 2])
    %--------------------------------------------------
    if ischar(input{1})==1
        input{1}=cellstr(input{1});
    end
    
    if iscell(input{1})            %FULLPATH SEARCH
        dirin=input{1};
        dirin=dirin(:);
        
        if isdir(fileparts(dirin{1}))==0
            is=zeros(size(dirin,1),1);
            for i=1:size(dirin,1);
                is(find(strcmp(md,dirin{i})))=1;
            end
        else
            is2=zeros(size(dirin,1),1);   % MOUSENAME SEARCH
            for i=1:size(dirin,1);
                [pax  name ext]=fileparts(dirin{i});
                is2(find(strcmp(md, name )))=1;
            end
            is=is2;
        end
        iselect=find(is==1);
        set(lb3,'value',iselect) ;
    else
        
        if length(input)==1; input{2}='find'   ; end
        
        fi=stradd(fp,[filesep input{1}],2);
        is=zeros(size(fi,1),1);
        for i=1:size(fi,1);
            if exist(fi{i})==2;  is(i)=1;end
        end
        
        if     strcmp(input{2}, 'find');
            iselect=find(is==1);
            set(lb3,'value',iselect)     ;
        elseif strcmp(input{2}, 'not' );
            iselect=find(is==0);
            set(lb3,'value',iselect)     ;
        end
    end
    % elseif iscell(input{2})
    %     dirin=input{2};
    %     is=zeros(size(dirin,1),1);
    %     for i=1:size(dirin,1);
    %        is(find(strcmp(md,dirin{i})))=1;
    %     end
    %     set(lb3,'value',find(is==1)) ;
    
end

if usegui==1;
    li2=get(lb3,'string');
    va2=get(lb3,'value');
    drawnow;
    index=va2;
else %using NOGUI
    index=iselect;
end
% md    = regexprep(strrep(li2(va2),'<html>',''),'<font.*','');   %mouseDirs
% fp    = stradd(md,[an.datpath filesep],1);                %fullpath mouseDirs
% matmd =['{';stradd(stradd(md,'     ''',1),'''',2) ; '};'];%mouseDirs matlabcell
% matfp =['{';stradd(stradd(fp,'     ''',1),'''',2) ; '};'];%fullpath mouseDirs matlabcell

%% ============[output]===================================


sel_mdirFP=fp(index);
[~,sel_mdir]=fileparts2(sel_mdirFP);
sel_mdirFPcell=[{'{'}; cellfun(@(a){['  ''' a  '''' ]} ,sel_mdirFP)  ;{'};'}];
sel_mdircell=[{'{'}; cellfun(@(a){['  ''' a  '''' ]} ,sel_mdir)  ;{'};'}];


out={sel_mdirFP sel_mdir sel_mdirFPcell sel_mdircell};
if nargoutCaller==0
    out={};
else
    out=out(1:nargoutCaller);
end
%% ===============================================


hgfeval(get(lb3,'callback'),lb3);
drawnow;
% hl=findobj(findobj(0,'tag','ant'),'tag','lb3')
% hgfeval(get(hl,'callback'),hl)
% hgfeval(hc,hl)

% out={md fp matmd matfp};
% out={};


function out=checkProjectfile;

%            inf99: '*** CONFIGURATION PARAMETERS   ***              '
%           inf100: '==================================='
%          project: 'fake_oldProjectfile'
%          datpath: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2ï¿½'
%          voxsize: [0.0700 0.0700 0.0700]
%             inf2: '% WARPING         '
%               wa: [1x1 struct]
%            inf33: '%TEMPLATES '
%            inf34: '%TRANSFORMED VOLUMES '
%     templatepath: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2ï¿½'
%       configfile: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2ï¿½'
%
%           BiasFieldCor: 0
%            fastSegment: 1
%         orientRefimage: 2
%             orientType: 1
%     orientelxParamfile: 'o:\antx\mritools\elastix\paramfiles\trafoeuler5ï¿½'
%        elxMaskApproach: 0
%     usePriorskullstrip: 1
%           elxParamfile: {1x2 cell}
%              refsample: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hresï¿½'
%             create_gwc: 1
%         create_anopcol: 1
%                cleanup: 1
%                 usePCT: 2
%                species: 'mouse'
%                refpath: 'o:\antx\mritools\ant\templateBerlin_hres'
%                 refTPM: {3x1 cell}
%                    ano: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hresï¿½'
%                    avg: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hresï¿½'
%                    fib: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hresï¿½'
%


out(1)={1};  %update

global an

do_msg=0;

refpath_ok =  0  ; %  (b)refpath  is ok?
refpath_err ='"refpath" not specified..create new projectfile';
if isfield(an.wa,'refpath')
    refpath1=char(an.wa.refpath  );
    if exist(refpath1)==7
        if isempty(   strfind(refpath1,'templateBerlin_hres') )
            refpath_ok=1 ; refpath_err={''};
        else
            refpath_err ='"refpath" is outdated/likned to old templatrs(''templateBerlin_hres'')..specify refpath ';
        end
    else
        refpath_err ='"refpath" is not found/paths are outdated..create new projectfile';
    end
end


if  refpath_ok==0
    do_msg=1;
    
    % ===============================================
    
    ms=getinfomessage('##msgprojectfile');
    ms2=[{' ';[' #r WARNING: ' refpath_err]}; ms];
    % ms2=strjoin(ms,char(10))
    %  ms2=cellstr(ms2)
    % ms2=cellstr(['<html>' ms2 '</html>' ])
    uhelp(ms2,1,'position',[0.4    0.4600    0.55   0.3600]);
    set(gcf,'NumberTitle','off','name','version changes');
    try; smart_scrollbars; end
    
    labelStr = '<html><center><a href="https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM">googledrive';
    %cbStr = 'system('' start https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM'');';
    cbStr=systemopen('https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM',1);
    hb = uicontrol('string',labelStr,'units','norm','pos',[.3 0 .15 .05],'callback',cbStr,'backgroundcolor','w');
    jButton = findjobj(hb);  % get FindJObj from the File Exchange
    jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
    jButton.setContentAreaFilled(0);  % or: jButton.setBorder([]);
    
    % set(hb,'units','pixels')
    
    hbok= uicontrol('string','OK','units','norm','pos',[.5 0 .15 .07],'callback','close(gcf)','backgroundcolor','w');
    
    set(hb,'units','pixels');
    set(hbok,'units','pixels');
    
    uiwait(gcf);
    uiresume;
    % system('start https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM')
    % lb=findobj(gcf,'tag','txt')
    % wt = textwrap(lb,get(lb,'string'))
    % set(lb,'string',wt)
    % ==============================================
    
    
end

% if do_msg==1






return


% bla
function out=copytemplates(argin)
% ================================================================================
% COPY files from reference templates to study's template folder
%     - the respective NIFTIs will be resampled to the voxel size defined in the project-file ("proj*.m")
%     - following files will be created:
%                   ANO.xlsx      AVGTmask.nii  _b2white.nii
%                   AVGT.nii      FIBT.nii      _b3csf.nii
%                   ANO.nii  AVGThemi.nii  _b1grey.nii
% call:
% antcb('copytemplates');               % copy nonexisting files to template folder (default)
% antcb('copytemplates','overwrite',1);  % force to overwrite existing files
% ================================================================================


% bla2
% if length(argin)==1 && strcmp(char(argin),'?')
%     antcb('helpfun', 'copytemplates');
%     return
% end

% ## copytemplates (anker)
% ## copytemplates (anker)

out(1)={[]};
if length(argin)>1; argin=argin(2:end); end
if length(argin)>1
    param=cell2struct(argin(2:2:end),argin(1:2:end),2);
    
end
if exist('param')~=1;    param=struct();end
if isfield(param,'overwrite')==0;  param.overwrite=0; end

% disp(param);

global an
s.templatepath=fullfile(fileparts(an.datpath),'templates');
s.refpath     =an.wa.refpath;
s.voxsize     =an.voxsize;

[~,refsystem]=fileparts(s.refpath);
disp(['..create study templates using "' refsystem  '"-reference system'   ]);
t=xcreatetemplatefiles2(s,param.overwrite);


disp('..done');
% fprintf('done.\n ');




function [o1 o2]=studydir(argin)
%% ===============================================
%  sdir=antcb('studydir');%obtain current ANT-study-directory'
%  output: sdir...path of the study-directory
%
% [sdir sinfo]=antcb('studydir','info'); %obtain info of current ANT-study-directory'
%
%
% the info-output is displayd example:
%         study-dir    : "F:\data5\nogui"
%         creation time: 18-Mrz-2022 13:32:37
%         dir size     : 6.41 TB
%         no files     : 1106
%         No animals   : 8
% ..sinfo: is a struct with some information
% __OBTAIN INFO FOR ANOTHER DIRECTORY__
%[sdir sinfo]=antcb('studydir','sdir','F:\data5\klaus','info'); %obtain info for another directory
%
%% ===============================================



% ## studydir (anker)

% if strcmp(argin{1}, 'studydir?')
% ## studydir (anker)


%     antcb('helpfun', 'studydir');
%     return
% end

[o1 o2]=deal([]);
iotherStudyPath=regexpi2(argin,'sdir');
if ~isempty(iotherStudyPath);        %another path
    sdir=argin{iotherStudyPath+1};
else                                 % rely on global "an"-struct
    global an
    sdir=[];
    try
        sdir=fileparts(an.datpath);
    end
end

o1=sdir;
if exist(sdir)~=7
    o1='folder not found ';
    disp(['folder not found: "' sdir '"!']);
    return
end
%% ===============================================

if ~isempty(regexpi2(argin,'info'));
    [pau sdirshort]=fileparts(sdir);
    k=dir(pau) ;
    uppderdirs={k(:).name};
    is=find(strcmp(uppderdirs,sdirshort));
    try
        cprintf('*[0 .5 .8]',['study-dir    : "' strrep(sdir,filesep, [filesep filesep])   '"\n']);
    catch
        disp(['study-dir    : ' sdir]);
    end
    disp(['creation time: '  k(is).date ]);
    
    %get dir-size
    [dirsize_MB nfiles]= DirSize(sdir);
    dirsize_MB=dirsize_MB./((1024*1024));
    if dirsize_MB<1000
        dirsize_str=sprintf('%2.2f MB',dirsize_MB);
    else
        dirsize_str=sprintf('%2.2f TB',dirsize_MB/1024);
    end
    disp(['dir size     : '  dirsize_str ]);
    disp(['no files     : '  num2str(nfiles) ]);
    % no animals
    padat=fullfile(sdir,'dat');
    [mdirs] = spm_select('FPList',padat,'dir');
    mdirs=cellstr(mdirs); % % get all animals
    nanimals=size(char(mdirs),1);
    disp(['No animals   : '  num2str(nanimals)]);
    
    
    o2.sdir=sdir;
    o2.ctime=k(is).date;
    o2.size=dirsize_str;
    o2.nanimals=nanimals;
    o2.mdirs  =mdirs;
    
end
%% ===============================================


function [out nfiles] = DirSize(dirIn)
%DirSize Determine the size of a directory in bytes.
%   bytes = DirSize(dirIn) Recursively searches the directory indicated by
%   the string dirIn and all of its subdirectories, summing up the file
%   sizes as it goes.
%
%   Example:
%   ________
%       DirSize(pwd)./(1024*1024)  %Returns size of the current directory
%       in megabytes.
%Richard Moore
%April 17, 2013
originDir = pwd;
cd(dirIn);
a = dir;
out = 0;
nfiles=sum(~[a.isdir]);
for x = 1:1:numel(a)
    %Check to make sure that this part of 'a' is an actual file or
    %subdirectory.
    if ~strcmp(a(x).name,'.')&&~strcmp(a(x).name,'..')
        %Add up the sizes.
        out = out + a(x).bytes;
        if a(x).isdir
            %Ooooooh, recursive!  Fancy!
            [outmb outn] =DirSize([dirIn '\' a(x).name]);
            out=out+outmb;
            nfiles=nfiles+outn;
            %out = out + DirSize([dirIn '\' a(x).name]);
        end
    end
end
cd(originDir);

% ==============================================
%%
% ===============================================

function out=load_guiparameter(argin)
out={};
settings=antsettings;


p.forcedefault=0;
if nargin>0
    if isstruct(argin)
        pin=argin;
    else
        pin=cell2struct(argin(2:2:end),argin(1:2:end),2);
    end
    p=catstruct(p,pin);
end


%% ===============use local settings================
if p.forcedefault==0
    f1=make_localantsettingsFile('findfile');
    
    if exist(f1)==2
        thispa=pwd;
        cd(fileparts(f1));
        settings=localantsettings;
        cd(thispa);
    end
end

%% ===============================================


try
    
    
    hf=findobj(0,'tag','ant');
    
    hradio    =findobj(hf,'style','radio');
    set(hradio,'fontsize',settings.fontsize-2);
    
    hradiohelp=findobj(hf,'tag','radioshowhelp');
    set(hradiohelp,'value', settings.show_instant_help);
    if get(hradiohelp,'value')==1
        drawnow;
        %showfunctionhelp
        % ant('showfunctionhelp');
    end
    
    hprogress=findobj(hf,'tag','radioshowHTMLprogress'); %HTML progress
    if ~isempty(hprogress)
        try; set(hprogress,'value',settings.show_HTMLprogressReport); end
    end
    
    if settings.show_intro==1
        try
            antintro
        end
    end
    % set tooltips
    % menubar_setTooltips(settings.enable_menutooltips);
    ant('menubar_setTooltips','value',settings.enable_menutooltips);
    
catch
    disp('failed to load settings from "localantsettings.m"');
    disp(['..please make a new "localantsettings.m"-file ']);
    disp(' ...loading default settings...');
    out=load_guiparameter(struct('forcedefault',1));
end



function  o=inputCMD(msg)
o=input(msg,'s');

function figlet
% disp ANTx1-figlet in cmd-window
v=randi(7,1,1);
if v==1
    o=...
        {
        '      _/       _///     _//_/// _//////                    '
        '     _/ //     _/ _//   _//     _//               _// _/   '
        '    _/  _//    _// _//  _//     _//    _//   _// _/     _//'
        '   _//   _//   _//  _// _//     _//      _/ _//       _//  '
        '  _////// _//  _//   _/ _//     _//       _/        _//    '
        ' _//       _// _//    _/ //     _//     _/  _//   _//      '
        '_//         _//_//      _//     _//    _//   _// _//////// '
        };
elseif v==2
    o=...
        {
        '  ___   _   _ _____     _____ '
        ' / _ \ | \ | |_   _|   / __  \'
        '/ /_\ \|  \| | | |_  __`. / / '
        '|  _  || . ` | | \ \/ /  / /  '
        '| | | || |\  | | |>  < ./ /___'
        '\_| |_/\_| \_/ \_/_/\_\\_____/'
        };
elseif v==3
    o=...
        {
        '      ___           ___           ___           ___     '
        '     /\  \         /\__\         /\  \         |\__\    '
        '    /::\  \       /::|  |        \:\  \        |:|  |   '
        '   /:/\:\  \     /:|:|  |         \:\  \       |:|  |   '
        '  /::\~\:\  \   /:/|:|  |__       /::\  \      |:|__|__ '
        ' /:/\:\ \:\__\ /:/ |:| /\__\     /:/\:\__\ ____/::::\__\'
        ' \/__\:\/:/  / \/__|:|/:/  /    /:/  \/__/ \::::/~~/~   '
        '      \::/  /      |:/:/  /    /:/  /       ~~|:|~~|    '
        '      /:/  /       |::/  /     \/__/          |:|  |    '
        '     /:/  /        /:/  /                     |:|  |    '
        '     \/__/         \/__/                       \|__| '
        };
    
elseif v==4
    o=...
        {
        '   _        __  _____       ____  '
        '  /_\    /\ \ \/__   \__  _|___ \ '
        ' //_\\  /  \/ /  / /\/\ \/ / __) |'
        '/  _  \/ /\  /  / /    >  < / __/ '
        '\_/ \_/\_\ \/   \/    /_/\_\_____|'
        };
elseif v==5
    o=...
        {
        '       ___ _  '
        ' /\ |\ ||   ) '
        '/--\| \||></_ '
        '              '
        };
elseif v==6
    o=...
        {
        '+-+-+-+-+-+'
        '|A|N|T|x|2|'
        '+-+-+-+-+-+'
        };
elseif v==7
    o=...
        {
        ' _______ _______ _______         ______ '
        '|   _   |    |  |_     _|.--.--.|__    |'
        '|       |       | |   |  |_   _||    __|'
        '|___|___|__|____| |___|  |__.__||______|'
        };
    
end

% w=antcb('version');
% % o{end}=[o{end} w  ];
% o{end+1}=[w  ];

disp(char(o));



function loadprojectfile(varargin)
% load a projectfile (proj.m) , i.e. load a study into ANT-GUI
% usage use:     antcb('load', <projFilename>);
%           or   antcb('loadprojectfile', <projFilename>);
%       'p'/'print'   : print project-files in path as loadable hyperlinks in CMD-window
%       'n'/'newest'  : load newest/last modified projectfile in path
%       'l'/'last'    : show list of last modified projectfiles (across studies)
% ------------------------------------------------------------------------
% EXAMPLES:
% # load specific project
%    antcb('load','proj.m')
%    antcb('load',fullfile(pwd,'proj.m'))
%
% # load project via GUI
%    antcb('load
%
% # print project-files in path as loadable hyperlinks in CMD-window
%    antcb('load','p');                %same as: antcb('load','print')
%
% # load newest/last modified projectfile in path
%    antcb('load','n');                %same as: antcb('load','newest')
%
% # show last 10 modified projectfile across all studies --> use hyperlink to load a project
%     antcb('load','l');                %same as: antcb('load','last')
% 
% 

%% open ant before, if nonexisting
if isempty(findobj(0,'tag','ant'))
    ant
end

try
    
    configfile=varargin{1}{1};
    [pa fi ext]=fileparts(configfile);
    if strcmp(fi,'p') || strcmp(fi,'print') || strcmp(fi,'n') || strcmp(fi,'newest')  %load local project-file
        %% =======================[print projectfiles in path]========================
        %antcb('load','p')
        %antcb('load','print')
        %antcb('load','F:\data5\nogui\p')
        %antcb('load','F:\data5\nogui\print')
        %% =======================[load newest projectfile in path]========================
        %antcb('load','n')
        %antcb('load','newest')
        %antcb('load','F:\data5\nogui\n')
        %antcb('load','F:\data5\nogui\newest')
        
        
        t={};
        if isempty(pa); pa=pwd; end
        k=dir(fullfile(pa,'*.m'));
        files={k.name}';
        % Extract modification dates
        dates = [k.datenum]';
        
        % Sort by modification date (newest first)
        [~, idx] = sort(dates, 'descend');
        files=files(idx);
        dates=dates(idx);
        nowtime=(now);
        for k = 1:numel(files)
            fname =fullfile(pa, files{k});
            %mtime = datestr(dates(k), 'yyyy-mm-dd HH:MM:SS')
            %fprintf('%-30s  %s\n', fname, mtime); % Display filename and modification time
            
            % Open file for reading
            fid = fopen(fname, 'r');
            if fid == -1
                warning('Could not open %s', fname);
                continue;
            end
            
            found = false;
            for i = 1:3
                tline = fgetl(fid);
                if ~ischar(tline), break; end
                if ~isempty(strfind(tline, 'x.project'))
                    found = true;
                    dt_days = nowtime - dates(k);% Time difference in days
                    % Convert to h/m/s
                    dt_seconds = dt_days * 24*3600;
                    days = floor(dt_seconds / 86400);
                    hours = floor(mod(dt_seconds, 86400) / 3600);
                    minutes = floor(mod(dt_seconds, 3600) / 60);
                    seconds = floor(mod(dt_seconds, 60));
                    mtime = datestr(dates(k), 'yyyy-mm-dd HH:MM:SS');
                    % Display result
                    %fprintf('Elapsed time: %d days %02d:%02d:%02d\n', days, hours, minutes, seconds);
                    timstr=sprintf('lastmodif:%d days+%02d:%02d:%02d', days, hours, minutes, seconds);
                    t(end+1,:)={ files{k}, mtime timstr fname   };
                end
            end
            fclose(fid);
        end
        
        if isempty(t); disp('no projectfile found '); end
        if strcmp(fi,'p') || strcmp(fi,'print')
            for k=1:size(t,1)
                % fprintf('<a href="matlab: edit(''myScript.m'')">Open myScript.m</a>\n');
                mfilelong=strrep(t{k,4},filesep,[filesep filesep]);
                fprintf(['<a href="matlab: antcb(''load'' ,''' mfilelong ''')'  '">load ['  t{k,1}  ']</a>'...
                    repmat(' ', [1 size(char(t(:,1)),2)+1-length(  t{k,1})])   t{k,2}...
                    ' ' t{k,3}....
                    '\n']);
            end
            return
        elseif strcmp(fi,'n') || strcmp(fi,'newest')
            configfile=t{1,4};
        end
        
        
        %% ===============================================
    elseif strcmp(fi,'last')| strcmp(fi,'l')
        try
            a=preadfile2(fullfile(prefdir,'matlab.settings'));
            i0=regexpi2(a,'<settings name="currentfolder">');
            i1=regexpi2(a,' <key name="History">');
            i2=regexpi2(a,' </key>');
            i2=i2(min(find(i1<i2)));
            ip=regexpi2(a,'<value><![CDATA[');
            ps=find(ip>i1 & ip<i2);
            pw=a(ip(ps));
            pw=regexprep(pw,{'.*[CDATA[',']]></value>'}, '');
        catch
            s = settings;
            cf = s.matlab.desktop.currentfolder;
            pw = cf.History.ActiveValue(:); % history is a cell array of char
            
        end
        
        pw(regexpi2(pw, 'antx2'))=[];
        % pwlast=pw{1};
        t={};
        nowtime=(now);
        for j=1:length(pw)
            [files] = spm_select('FPList',pw{j},'.*.m$');
            files=cellstr(files);
            if isempty(char(files)) continue; end
            for k = 1:numel(files)
                fname =files{k};
                %mtime = datestr(dates(k), 'yyyy-mm-dd HH:MM:SS')
                %fprintf('%-30s  %s\n', fname, mtime); % Display filename and modification time
                
                % Open file for reading
                fid = fopen(fname, 'r');
                if fid == -1
                    warning('Could not open %s', fname);
                    continue;
                end
                found = false;
                for i = 1:3
                    tline = fgetl(fid);
                    if ~ischar(tline), break; end
                    if ~isempty(strfind(tline, 'x.project'))
                        found = true;
                        kk=dir(fname);
                        dates=kk.datenum;
                        dt_days = nowtime - dates;% Time difference in days
                        % Convert to h/m/s
                        dt_seconds = dt_days * 24*3600;
                        days = floor(dt_seconds / 86400);
                        hours = floor(mod(dt_seconds, 86400) / 3600);
                        minutes = floor(mod(dt_seconds, 3600) / 60);
                        seconds = floor(mod(dt_seconds, 60));
                        mtime = datestr(dates, 'yyyy-mm-dd HH:MM:SS');
                        % Display result
                        %fprintf('Elapsed time: %d days %02d:%02d:%02d\n', days, hours, minutes, seconds);
                        timstr=sprintf('lastmodif:%d days+%02d:%02d:%02d', days, hours, minutes, seconds);
                        t(end+1,:)={ files{k}, mtime timstr fname   };
                        %t(end+1,:)={fname}
                    end
                end
                fclose(fid);
            end
        end
%         if size(t,1)>10
%             t=t(1:10,:);
%         end
        for k=1:size(t,1)
            % fprintf('<a href="matlab: edit(''myScript.m'')">Open myScript.m</a>\n');
            mfilelong=strrep(t{k,4},filesep,[filesep filesep]);
            [pax name]=fileparts(t{k,4});
            [~, study]=fileparts(pax);
            short=[ study '/' name '.m' ];
            
            fprintf(['<a href="matlab: antcb(''load'' ,''' mfilelong ''')'  '">load ['  mfilelong ']</a>'...
                repmat(' ', [1 size(char(t(:,1)),2)+1-length(  t{k,1})])   t{k,2}...
                ' ' t{k,3}....
                '\n']);
        end
        return
        
        
        
        
        
    end
    %% ===============================================
    
    
    [pa fi ext]=fileparts(configfile);
    if isempty(pa); pa=pwd; end
    configfile=fullfile(pa,[fi ext]);
    
    if exist(configfile)~=2;  configfile=[]; end
catch
    configfile=[];
end

if isempty(configfile)
    [fi pa ]=uigetfile(pwd,'select projectfile [mfile]','*.m');
    if ~ischar(pa);
        pause(2)
        return;
        pause(2)
    end
    projectfile=fullfile(pa,fi);
else
    [pa fi]=fileparts(configfile);
    if isempty(pa);
        configfile=fullfile(pwd,configfile);
        [pa fi]=fileparts(configfile);
    end
    projectfile=fullfile(pa,[fi]);
end

if strcmp(pa(end),filesep)
    px=pa(1:end-1);
else
    px=pa;
end
[rest projectdir]=fileparts(px);
fprintf([' ...loading project: ' '[' [strrep(fi,'.m',''),'.m' ] '] from [' projectdir ']'  '\n']);
%====================================================================================================
%% make history of previous projectfiles
if 0
    antxpath=antpath;
    prevprojects=fullfile(antxpath,'prevprojects.mat');
    run(projectfile);
    if exist(prevprojects)~=2
        pp={'-' '-' '-'};
        save(prevprojects,'pp');
    end
    load(prevprojects);
    [ppath pfi pext]=fileparts(projectfile);
    projectfile2=fullfile(ppath, [pfi '.m']);
    
    if strcmp(pp(:,1),projectfile2)==0 %ADD PROJECTFILE
        if strcmp(pp(:,1),'-')==1     ; %replace empty array
            pp={ projectfile2 , datestr(now)  x.project};
        else
            pp(end+1,:)={ projectfile2 , datestr(now) x.project};
        end
        save(prevprojects,'pp');
    end
    
end
%====================================================================================================

clear global an;
global an;
run(projectfile);
cd(fileparts(projectfile));
an=x;
antconfig(0);

an.templatepath=fullfile(fileparts(an.datpath),'templates');
%[pathx s]=antpath;
% %%%%%%    x= catstruct(x,s);
%     x= catstruct(s,x);% overwrite defaults with "m-file config"-data
an.configfile=projectfile;
%remove from list
try;       an=rmfield(an,'ls');     end
try;       an=rmfield(an,'mdirs');     end

% check old-version
ro=antcb('checkProjectfile');

antcb('updateParameterLB');

% %     try; an=rmfield(an,'ls'); end
% %     an.ls =struct2list(an); %   ls=fn_structdisp(x);
% %     an.ls(regexpi2(an.ls,'^\s*an.inf\d'))=[];
% %     iproject=min(regexpi2(an.ls,'project.*='));
% %     if iproject==1
% %         an.ls=[{''}; an.ls];%move project to 2nd line
% %         iproject=2;
% %     end
% %     %        colergen = @(color,text) ['<html><b><font color='  color '  bgcolor="black" size="+2">' text '</html>'  ];
% %     colergen = @(color,text) ['<html><b><font color='  color '   >' text '</html>'  ];
% %
% %     %  colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD><pre>',text,'</pre></TD></TR> </table></html>'];
% %     % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
% %     %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
% %     %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
% %
% %     an.ls{iproject}=colergen('#007700',   an.ls{iproject} );
% %     %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
% %     %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
% %
% %     set(findobj(0,'tag','ant'),'name' ,['[ant2]' ' ' projectdir ' (' fi '.m)']);
% %
% %
% %     if ~isempty(an.ls{1})
% %         an.ls=[{''} ;an.ls];
% %     end
% %     try
% %         msg=makenicer2(an.ls);
% %     catch
% %         msg=an.ls;
% %     end
% %
% %     hlb2=findobj(0,'tag','lb2');
% %     set(hlb2,'string',msg,'FontName','courier');
% %
% %     % ==============================================
% %     %%
% %     % ===============================================
% %
% %     tip=regexprep(msg,{'<html>' '</html>'},'');
% %     %         tip=cellfun(@(a){['<html><pre>' a '</pre>','</html>' ]},  tip)
% %     %     tip=cellfun(@(a){['<html><pre>' a '</pre>','</html>' ]},  tip)
% %     tip{iproject+1}=[ '</b><font color=#000000   >' tip{iproject+1}];
% %     tip= cellfun(@(a){[ a '<br>' ]},  tip);
% %     tip2=['<html><pre>' strjoin(tip,' ') '</pre></html>'];
% %     set(hlb2,'tooltipstring',tip2);
% %
% ==============================================
%% sanity check
% ===============================================
% remove ending fileseps
try; an.datpath         =regexprep(an.datpath     ,['\' filesep '$'],''); end
try; an.templatepath    =regexprep(an.templatepath,['\' filesep '$'],''); end

% ==============================================
%%  history
% ===============================================
anthistory('update');

% ==============================================
%%
% ===============================================

antcb('update'); %update subkects
%     fprintf('[done]\n');

%% =========special characters in study path =========

studypath=fileparts(an.datpath);
%   studypath='ddd > ?';
tes={
    '\s'  'space-character (" ")'
    '<'   'less than (<)-character'
    '>'   'greater than (>)-character'
    '"'   'double quote (")-character'
    '\|'  'vertical bar or pipe (|)-character'
    '\?'  'question mark (?)-character'
    '\*'  'asterisk (*)-character'
    };
ispecchar=regexpi2(studypath, tes(:,1));
if ~isempty(ispecchar)
    if usejava('desktop')
        ms=[{''}
            '=============================================='
            'SPECIAL CHARACTERS found in the STUDY-PATH !!!'
            '=============================================='
            ['...found: "' strjoin(tes(ispecchar,2),'", "') '"'  ' in path: ["' studypath  '"]' ]
            'PLEASE REMOVE SPECIAL CHARACTERS FROM PATH..otherwise data processing will not work!'
            'SOLUTION: close the ANT-project+GUI & change matlab path to another directory'
            '..change the name of the study-path & also change the datapath (x.datpath) in the project-file  '
            '..reload project'
            '=============================================='
            ];
        %         warndlg(ms,'WARNING');
        warning on;
        warning(strjoin(ms,char(10)));
        warning off
    else
        warning on;
        warning(strjoin(ms,char(10)));
        warning off
    end
end


%% ===============================================
function reload_ant()
% reload ANT-GUI and readin the current but potentially modified project-file
% no input/output
global an;
lb=findobj(gcf,'tag','lb3');
try
    configfile=an.configfile;
    val=get(lb,'value');
catch
    configfile='';
    val=1;
end

antcb('quit');
ant;
if ~isempty(configfile)
    [pa fi ext]=fileparts(configfile);
    configfile=fullfile(pa,[fi '.m']);
    
    antcb('load',configfile);
    lb=findobj(gcf,'tag','lb3');
    set(lb,'value',val)
end

%% ===============================================
function varargout=get_version()
%display current local ANTx-version
gitpath=fileparts(which('antlink.m'));
w=git([' -C ' gitpath ' log -1 --pretty="format:%ci"']);
if isempty(strfind(w,'fatal'))
    [w1 w2]=strtok(w,'+');
    %dateLU=['ANTx2 v: ' w1 ];
else
    vstring=strsplit(help('antver'),char(10))';
    idate=max(regexpi2(vstring,' \w\w\w 20\d\d (\d\d'));
    %dateLU=['ANTx2  vers.' char(regexprep(vstring(idate), {' (.*'  '  #\w\w ' },{''}))];
    w1=datestr(char(regexprep(vstring(idate), {  '(' ')' '#\w\w ' },{''})),'yyyy-mm-dd HH:MM:SS');
    %dateLU=['ANTx2 v: ' w1 ];
end
dateLU=['ANTx2-v:' w1 ];
varargout{1}=dateLU;
%% ===============================================
function varargout=versionupdate()
%update version-string in ANT-GUI
hc=findobj(findobj(0,'tag','ant'),'tag','txtversion');
if isempty(hc); return; end
version=antcb('version');
set(hc,'string',version);
varargout{1}=version;
%% ===============================================
function close_gui()
% This command closes the ANTx-GUI
% CMD: antcb('close')
% type antcb('reload')  to open ANTx-GUI again
hr=findobj(0,'tag','ant');
set(hr,'closereq','closereq');
close(hr);