
%% #b ant-callbacks
%%
% #yk EXAMPLES
% antcb('getsubjects')    % get selected subjects-->only those selected from [ANT] Mouse-listbox
% antcb('getallsubjects') % get all subjects  --> all from list
% antcb('makeproject')    % create a new project -->for HELP see antcb('makeproject','?')
% antcb('load','proj_Harms3_lesionfill_20stack.m')   %load this project
% antcb('reload')         % reload gui with project and previous mice-selection
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
%
% antcb('selectimageviagui', mypath, 'single');  %select an image from upperDatapath via gui
% antcb('selectimageviagui', mypath, 'multi');   %select several images from upperDatapath via gui
%====================================================================================================
%%                  UICALLBACKS
%====================================================================================================
%====================================================================================================

function varargout=antcb(h,emp,do,varargin)

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
if strcmp(do, 'fontsize');
    fontsize(input);
end
if strcmp(do, 'watchfile');     watchfile(input2); end
if strcmp(do, 'watchfile?');    watchfile('?')  ; end

if strcmp(do,'selectdirs')  ;   varargout=selectdirs(input2);  end
if strcmp(do,'selectdirs?') ;   varargout=selectdirs('?');    end
if strcmp(do,'helpfun') ;       helpfun(input2{2});    end

if strcmp(do,'checkProjectfile') ;varargout=checkProjectfile;return; end


if strcmp(do,'copytemplates'  )  ;   copytemplates(input2);  end
if strcmp(do, 'copytemplates?')  ;   copytemplates('?')  ; end

if strcmp(do, 'getuniquefiles')
    if isempty(char(emp))
        cprintf([1 0 0],[' no directory selected \n']);
        return
    end
    pa=emp;
    v=getuniquefiles(pa);
    varargout{1}=v.tb;
    varargout{2}=v.tbh;
    varargout{3}=v;
end

if strcmp(do, 'getsubdirs')
    varargout{1}=getsubdirs(emp);
end

if strcmp(do,'makeproject')
    try ;    varargout{1}=makeproject(input);
    catch;   disp('* type    antcb(''makeproject'',''?'')     for help');
    end
end

if strcmp(do, 'selectimageviagui')
    varargout{1}=selectimageviagui(input);
end


if strcmp(do, 'load');
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
    if 1
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
    %%
    % ===============================================
    
    antcb('update'); %update subkects
    %     fprintf('[done]\n');
    
    
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
    
    
    color='#33cc33';
    colergen = @(color,text) ['<html><b><font color='  color '   >' text '</html>'  ];
    an.ls{iproject}=colergen('#007700',   an.ls{iproject} );
    set(findobj(0,'tag','ant'),'name' ,['[ant2]' ' ' projectdir ' (' projname '.m)']);
    
    
    
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
    configfile = an.configfile;
    m= antconfig;
    
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
        choices{1},choices{2},choices{3},choices{2});
    
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
    
end
%% %###########################################################


if strcmp(do,'close') || strcmp(do,'quit') ;
    hr=findobj(0,'tag','ant');
    set(hr,'closereq','closereq');
    close(hr);
end

if strcmp(do,'reload')
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
        antcb('load',configfile);
        lb=findobj(gcf,'tag','lb3');
        set(lb,'value',val)
    end
end



if strcmp(do,'getsubjects');
    paths=getsubjects;
    varargout{1}=paths;
end
if strcmp(do,'getallsubjects');
    paths=getallsubjects;
    varargout{1}=paths;
end

if strcmp(do,'close');
    set(findobj(0,'tag','ant'),'closereq','closereq');
end

if strcmp(do,'status');
    if ~iscell(input); input=cell(input);end
    status(input)
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
    
    antcb('status',0);
end

%====================================================================================================
%           koad subjects
%====================================================================================================


%====================================================================================================
% gui-functions
%====================================================================================================
if strcmp(do, 'update')
    fig=findobj(0,'tag','ant');
    global an
    if isempty(an); disp('no project loaded');return;end
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
                dropoutvec(i)= 0;%status.isdropout;
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
            %     sw=sprintf(['<html>'     '%s'   '<font color =%s>&#9733'  '</html>'  ] ,dirsid{i}, cb{i,1} )
            %     sw=sprintf(['<html>'     '%s'   repmat('<font color =%s>&#9733',1, size(cols,1))  '</html>'  ] ,dirsid{i}, cb{i,1} )
            %           symbol=cols{i,3};
            dum=[ dirsidHTML{i} cb(i,:)];
            %             sw=sprintf(['<html>'     '%s'   repmat(['<font color =%s>'  symbol ] ,1, size(cols,1)) char(183) '</html>'  ] ,dum{:} );
            
            ing=[dum(1) reshape([dum(2:end)' cols(:,3)]',[1 size(cols,1)*2 ])];
            sw=sprintf(['<html>'     '%s'   repmat(['<font color =%s>'  '%s' ] ,1, size(cols,1))  '</html>'  ] ,ing{:});
            
            
            dirsid2{i,1}=sw;
            
            %% TOOLTIP
            %             tooltdum=cellfun(@(a) [ '<font color=' (a) '>' symbol  '<font color=black'  '>'],cb(i,:)','UniformOutput',false);
            tooltdum=cellfun(@(a,b) [ '<font color=' (a) '>' b  '<font color=black'  '>'],cols(:,2) ,cols(:,3),'UniformOutput',false);
            
            
            tt= cellfun(@(x,y) [x y ],tooltdum,toolt{i},'un',0);
            if dropoutvec(i)==1
                tt=  [ ['<font color=red>' ' *** REMOVED FROM ANALYSIS '] ; tt];
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
    
    lb=findobj(gcf,'tag','lb3');
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
    
end

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
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');
va=get(lb3,'value');
paths=an.mdirs(va);

%% remove path which are taken out from analysis
li=get(lb3,'string');
pathshtml=li(va);
del=regexpi2(pathshtml,'</s>');
pathshtml(del)=[];
paths(   del)=[];


function paths=getallsubjects
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');

paths=an.mdirs;
% %% remove 'deselected' files
% [pathstr, name, ext] = fileparts2(paths);
% paths(regexpi2(name,'^_'))=[];


function status(input)
% input
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
    
    
end
drawnow
pause(.01);



function fontsize(iput)
% iput
% return

x.defaultFS=0;

if nargin==1
    fs=iput{1};
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
%get subdirs of a directorx


if iscell(pa); pa=char(pa); end

[~,dirs] = spm_select('FPList',pa,['.*']);
if ischar(dirs); dirs=cellstr(dirs); end
v=dirs;


function v=selectimageviagui(inp)
% inp{1} ...dataUpperpath
% inp{2} ... single or multi

sdirs=antcb('getsubdirs', inp{1});
if isempty(char(sdirs))
    v=[];
    cprintf([1 0 0],[' no directory selected \n']);
    return
end
[tb tbh v]=antcb('getuniquefiles',sdirs);
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',inp{2});
v=he;

%%  generate unique list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path


% pa=antcb('getsubjects'); %path

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
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
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];






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



function out=selectdirs(input);
out{1}=[];
if ischar(input) && strcmp(input,'?')
    '###'
    antcb('helpfun', 'selectdirs');
    return
end
% ## selectdirs (anker)
% ================================================================================
% SELECTDIRS - SELECT MOUSE DIRECTORIES in ANT-GUI:
%  specify either (all dirs),(via id),(via existing/nonexisting file within folder) or (from list)
% EXAMPLES:
% [md FPmd matmd matFPmd]=antcb('selectdirs')          ;%select all directories
% antcb('selectdirs','all');                          ;%(same as above )select all directories
% antcb('selectdirs',[1 2]);                          ;%select directories 1 and 2 (selected by index)
% antcb('selectdirs','LWE.nii','find');               ;%select all directories that contains a "LWE.nii" file
% antcb('selectdirs','LWE.nii');                      ;%(same as above) select all directories that contains a "LWE.nii"
% antcb('selectdirs','LWE.nii','not');                ;%select all directories not containing "LWE.nii"
% antcb('selectdirs',{'MMRE_age_20w_mouse5_cage6_13122017'}); %select this directory
% antcb('selectdirs',{'MMRE_age_20w_mouse5_cage6_13122017'
%                     'MMRE_age_20w_mouse5_cage6_13122017'}); %select several directories by list
% ================================================================================
% ## selectdirs (anker)
global an

input=input(2:end);

if  isempty(input)
    input{1}='all'
end
% if isempty(input); input{1}='all'  ; end

hfig=findobj(0,'tag','ant');
lb3=findobj(hfig,'tag','lb3'); %get mouse folder
li=get(lb3,'string');

% md    = regexprep(strrep(li,'<html>',''),'<font.*','');   %mouseDirs
% fp    = stradd(md,[an.datpath filesep],1);                %fullpath mouseDirs

fp=antcb('getallsubjects');
px=fileparts(fp{1});
md=strrep(fp,[px filesep],'');

if strcmp(input{1},'all')
    set(lb3,'value',[1:length(li)])
elseif isnumeric(input{1})
    del=setdiff(input{1},[1:length(li)]);
    isect=intersect(input{1},[1:length(li)]);
    if ~isempty(del)
        disp(['could not found following mouse-indices: ' regexprep(num2str(del(:)'),'\s+',';')]);
    end
    set(lb3,'value',isect);
elseif ~isempty(strfind(input{1},'.nii') )
    
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
        set(lb3,'value',find(is==1)) ;
    else
        
        if length(input)==1; input{2}='find'   ; end
        
        fi=stradd(fp,[filesep input{1}],2);
        is=zeros(size(fi,1),1);
        for i=1:size(fi,1);
            if exist(fi{i})==2;  is(i)=1;end
        end
        
        if     strcmp(input{2}, 'find');   set(lb3,'value',find(is==1))     ;
        elseif strcmp(input{2}, 'not' );   set(lb3,'value',find(is==0))     ;
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



li2=get(lb3,'string');
va2=get(lb3,'value');
md    = regexprep(strrep(li2(va2),'<html>',''),'<font.*','');   %mouseDirs
fp    = stradd(md,[an.datpath filesep],1);                %fullpath mouseDirs
matmd =['{';stradd(stradd(md,'     ''',1),'''',2) ; '};'];%mouseDirs matlabcell
matfp =['{';stradd(stradd(fp,'     ''',1),'''',2) ; '};'];%fullpath mouseDirs matlabcell

% out={md fp matmd matfp};
out={};


function out=checkProjectfile;

%            inf99: '*** CONFIGURATION PARAMETERS   ***              '
%           inf100: '==================================='
%          project: 'fake_oldProjectfile'
%          datpath: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2�'
%          voxsize: [0.0700 0.0700 0.0700]
%             inf2: '% WARPING         '
%               wa: [1x1 struct]
%            inf33: '%TEMPLATES '
%            inf34: '%TRANSFORMED VOLUMES '
%     templatepath: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2�'
%       configfile: 'O:\ant_generateTemplates\atlas_DTIatlasMouse\ant_dti2�'
% 
%           BiasFieldCor: 0
%            fastSegment: 1
%         orientRefimage: 2
%             orientType: 1
%     orientelxParamfile: 'o:\antx\mritools\elastix\paramfiles\trafoeuler5�'
%        elxMaskApproach: 0
%     usePriorskullstrip: 1
%           elxParamfile: {1x2 cell}
%              refsample: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hres�'
%             create_gwc: 1
%         create_anopcol: 1
%                cleanup: 1
%                 usePCT: 2
%                species: 'mouse'
%                refpath: 'o:\antx\mritools\ant\templateBerlin_hres'
%                 refTPM: {3x1 cell}
%                    ano: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hres�'
%                    avg: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hres�'
%                    fib: 'C:\MATLAB\antx\mritools\ant\templateBerlin_hres�'
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



function out=copytemplates(argin)
if length(argin)==1 && strcmp(char(argin),'?')
    antcb('helpfun', 'copytemplates');
    return
end

% ## copytemplates (anker)
% ================================================================================
% COPY files from reference templates to studie's template folder
%    
%     - the respective NIFTIs will be resampled to the voxel size defined in the project-file ("proj*.m")
%     - following files will be created: 
%                   ANO.xlsx      AVGTmask.nii  _b2white.nii  
%                   AVGT.nii      FIBT.nii      _b3csf.nii    
%                   ANO.nii  AVGThemi.nii  _b1grey.nii   
% call: 
% antcb('copytemplates');               % copy nonexisting files to template folder (default) 
% antcb('copytemplates','overwrite,1);  % force to overwrite existing files
% ================================================================================
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








