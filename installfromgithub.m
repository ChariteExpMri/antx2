
% this installs/updates ANTx2-TBX


function installfromgithub(varargin)

 
if nargin==1
    if strcmp(varargin{1},'install')
        installer
        return
    end
elseif nargin==0
    clear global antupd
end

if strcmp(mfilename,'installfromgithub')
    
    %--------------------------------------------------------------------
    %% first try to download the m-file from github
    try
        fiout=fullfile(fileparts(which('installfromgithub.m')), 'installfromgithub0.m') ;
        url = 'https://raw.githubusercontent.com/ChariteExpMri/antx2/master/installfromgithub.m';
        try
            websave(fiout,url);
        catch
            urlwrite(url,fiout);
        end
        if exist(fiout) %replace file with downloaded version
            pause(.2);
            k=dir(fiout);
            if k.bytes>1000
                disp('get "installfromgithub.m" from github...');
                movefile(which('installfromgithub0.m'),which('installfromgithub.m'),'f');
                pause(.1);
            end
        end
    end
    % ------------------------------------------------------------------------
    
    
    try
        copyfile(which('installfromgithub.m'), fullfile(fileparts(which('installfromgithub.m')),'temp_installfromgithub.m'),'f');
        %         global antupd;
        %         antupd.tempfile=fullfile(fileparts(which('installfromgithub.m')),'temp_installfromgithub.m');
        %try; delete(which('installfromgithub.m')); end
    end
    temp_installfromgithub;
    return
end

initialize();
mkgui();



end

%% installer
function installer
% keyboard

atime=tic;
mkgui();
fprintf(['installation..please wait..\n']);
setstatus(1,'fresh installation..');

global antupd;
if isempty(antupd.patempup);   error('global "antupd" is empty');end

%% ========== [1] [antx2]-folder exists ==================
% disp(which('installfromgithub.m'));

isPrevANTXdir=0;  % previous ANTX dir exist
if exist(fullfile(antupd.patempup,'antx2'))==7
     isPrevANTXdir=1;  
    % keyboard
    disp('..[antx2]-folder exist ..folder will be renamed & removed');
    cd(antupd.patempup); drawnow;
    pause(1);
    
    %disp(fullfile(antupd.patempup,'antx2'));
    %disp(fullfile(antupd.patempup,'_antx2'));
    
    if isunix && ~ismac
        pa2=fullfile(antupd.patempup, 'antx2');
        system(['sudo rm -r ' pa2]);
    else
        try;     rmdir(fullfile(antupd.patempup,'antx2'),'s'); end
    end
    %try; disp(pwd);    end
    drawnow;
end
    
    
    
%     if 1
% %         try
% %             Editor = com.mathworks.mlservices.MLEditorServices;
% %             Editor.getEditorApplication.closeNoPrompt;
% %         end
%         
%         disp(fullfile(antupd.patempup,'antx2'));
%         disp(fullfile(antupd.patempup,'_antx2'));
%         if isunix && ~ismac
%             pa2=fullfile(antupd.patempup, 'antx2');
%             system(['sudo rm -r ' pa2]);
%         else
%             try;     rmdir(fullfile(antupd.patempup,'antx2'),'s'); end
%         end
%         try; disp(pwd);    end
%         drawnow;
%         disp('..cloning repository from GITHUB..please wait..');
%         %git clone https://github.com/pstkoch/antx2
%         %git(['clone ' gitrepository]);
%         git(['clone --depth=1 ' gitrepository]);
%         
%         %fprintf(['installation..done t=%2.3f min\n'],toc(atime)/60);
%         cd(fullfile(antupd.patempup,'antx2'));
%     end
%     
%     if isfield(antupd, 'patempup')
%         if exist(fullfile(antupd.patempup,'installfromgithub.m'))
%             %disp('..deleting "installfromgithub.m" from upper directory ');
%             try; delete(fullfile(antupd.patempup,'installfromgithub.m'));   end
%             try; delete(fullfile(antupd.patempup,'temp_installfromgithub.m'));   end
%         end
%     end
%     try; fprintf(['installation..done t=%2.3f min\n'],toc(atime)/60);end
    
%===============================================================    
%% ========== [2] clone REPO ==================

if 1  
    
     
    if 1
        disp('..cloning repository from GITHUB..please wait...');
        %git clone https://github.com/pstkoch/antx2
        %git(['clone ' gitrepository]);
        [msg]=git(['clone --depth=1 ' gitrepository]);
        if ~isempty(strfind(msg,'unable to access')) || (exist(fullfile(antupd.patempup,'antx2','.git'))~=7)
               installLinux(antupd,gitrepository);
            if isunix && ~ismac
                %system(['sudo git clone --depth=1 ' gitrepository])
                installLinux(antupd,gitrepository);
            elseif ismac
                error('mac issue -cloning');
            elseif ispc
               error('PC issue -cloning');
            end
            
        end
        fprintf(['installation..done t=%2.3f min\n'],toc(atime)/60);
    end
    if 0 % not needed..git creates the antx2-folder
        mkdir(fullfile(antupd.patempup,'antx2'))
        copyfile(fullfile(antupd.patempup,'installfromgithub.m'),fullfile(antupd.patempup,'antx2','installfromgithub.m'),'f')
    end
    cd(fullfile(antupd.patempup,'antx2'));
    
% % % % %     if isfield(antupd, 'patempup')
% % % % %         if exist(fullfile(antupd.patempup,'installfromgithub.m'))
% % % % %             % disp('..deleting "installfromgithub.m" from upper directory ');
% % % % % %             try;
% % % % % %                 
% % % % % %                 %% [QUESTION] DELETE "installfromgithub" -
% % % % % %                 warning off;
% % % % % %                 answer = questdlg(...
% % % % % %                     ['\bf Delete used installtion file "installfromgithub.m" ?  \rm'  char(10) ...
% % % % % %                     '  \diamondsuit If download/installation was successfull you don''t need ' char (10) ...
% % % % % %                     '      the file anymore. Note that the folder "antx2" contains the file' char (10) ...
% % % % % %                     '      "installfromgithub.m (used for updates and new installation)" ' char(10)...
% % % % % %                     ' \diamondsuit If download/installation failed..you may keep that file.  ' ...
% % % % % %                     ], ...
% % % % % %                     'Delete installtion file' ,...
% % % % % %                     'Yes,delete','No, keep file',struct('Interpreter','tex','Default',''));
% % % % % %                 %% QUESTION off
% % % % % %                 if ~isempty(strfind(answer,'Yes'))
% % % % % %                    try;      delete(fullfile(antupd.patempup,'installfromgithub.m')); 
% % % % % %                    catch;    disp(['failed to delete: ' fullfile(antupd.patempup,'installfromgithub.m')]) ;                  
% % % % % %                    end
% % % % % %                 end 
% % % % % %             end
% % % % %         end
% % % % %     end
    try;    delete(fullfile(antupd.patempup,'temp_installfromgithub.m')); 
    catch;  disp(['failed to delete: ' fullfile(antupd.patempup,'temp_installfromgithub.m')]);
    end
    try; delete(antupd.tempfile);   end
    try; fprintf(['installation..done t=%2.3f min\n'],toc(atime)/60);end
end

if ~isempty(findobj(0,'tag','ant'))
    disp('..linking paths');
    thispa=pwd;
    cd(antupd.updatepath);
    antlink(1);
    cd(thispa);
    antcb('update');
end


setstatus(0);
installfromgithub;


end
%% ________________________________________________________________________________________________

function https=gitrepository
https='https://github.com/ChariteExpMri/antx2.git';
end
%% ________________________________________________________________________________________________

function initialize
p.pwd        = pwd;
p.updatepath = fileparts(which(mfilename));
p.antxpath   = which('ant.m');
global antupd;
antupd=p;
cd(p.updatepath);
if ~isempty(p.antxpath); antlink(0);end
end

function pbclose(e,e2)
% keyboard
global antupd;
cd(antupd.updatepath);
tmpfile=fullfile(antupd.updatepath,'temp_installfromgithub.m');
try; delete(tmpfile);
    disp('.."temp_installfromgithub.m" removed');
catch
    disp('..could not delete "temp_installfromgithub.m", please do it manually later');
end
if ~isempty(antupd.antxpath); antlink(1);
    disp('..set antx2-path again');
    if ~isempty(findobj(0,'tag','ant'))
        global an
        try
            antcb('load',[regexprep(an.configfile,'.m$','') '.m']);
        catch
        antcb('reload');
        end
        disp('..reopen antgui..reloading project');
    end
end
rehash path;
disp('..rehashing paths');
cd(antupd.pwd);
disp(['  current working directory: ' antupd.pwd]);
delete(findobj(gcf,'tag','fupd')); %close WINDOW

if isfield(antupd,'patempup')
   % keyboard
    if exist(fullfile(antupd.patempup,'installfromgithub.m'))==2
      if 1 %show  QUESTION and ask
        try
            %% [QUESTION] DELETE "installfromgithub" -
            warning off;
            answer = questdlg(...
                ['\bf Delete used installtion file "installfromgithub.m" ?  \rm'  char(10) ...
                '  \diamondsuit If download/installation was successfull you don''t need ' char (10) ...
                '      the file anymore. Note that the folder "antx2" contains the file' char (10) ...
                '      "installfromgithub.m (used for updates and new installation)" ' char(10)...
                ' \diamondsuit If download/installation failed..you may keep that file.  ' ...
                ], ...
                'Delete installtion file' ,...
                'Yes,delete','No, keep file',struct('Interpreter','tex','Default',''));
            %% QUESTION off
            if ~isempty(strfind(answer,'Yes'))
                try;
                    delete(fullfile(antupd.patempup,'installfromgithub.m'));
                    disp('..removed temporary "installfromgithub"-file from upper dir');
                catch;    disp(['failed to delete: ' fullfile(antupd.patempup,'installfromgithub.m')]) ;
                end
            end
        end
    end% 
        % delete temp-files
        try; delete(fullfile(antupd.patempup,'temp_installfromgithub.m'));   end
    end
end
try; delete(fullfile(antupd.tempfile));   end
disp('DONE');

end

function pbinstallfromgithubcall(e,e2,updatecode)

pbinstallfromgithub(updatecode);

end

% --------- MESSAGE what is modified
function [msg st]=antx_gitstatus(message)
% [msg st]=git('diff --name-only');

[msg st]=git('diff --name-only origin');
msg=strsplit(msg,char(10))';
msg=msg(cellfun('isempty',strfind(msg,'prevprojects.mat'))); % without 'prevprojects.mat' in list 
msg=strjoin(msg,char(10));



if ~isempty(msg)
    if strcmp(message,'check')
        cprintf([ 1 0 1],'-----------------------------\n');
        cprintf([ 1 0 1],'  MODIFIED GITHUB FILES      \n');
        cprintf([ 1 0 1],'-----------------------------\n');
        cprintf([ 0 0 0],'The following files have been created or modified in GITHUB.\n');
        cprintf([ 0 0 0],'Note that the list might contain also locally modified or deleted files.\n');
        cprintf([ .5 .5 .5],msg);
        cprintf([ .5 .5 .5],'\n');
    elseif strcmp(message,'recheck')
        cprintf([0.9294    0.6902    0.1294],'-----------------------------\n');
        cprintf([0.9294    0.6902    0.1294],'  ERRONEOUS UPDATE           \n');
        cprintf([0.9294    0.6902    0.1294],'-----------------------------\n');
        cprintf([ 0 0 0],'The following files were not updated successfully.\n');
        cprintf([ 0 0 0],'..REASONS: local files have been modified/deleted.\n');
        cprintf([ 0 0 0],'Please hit '); 
        cprintf([ 1 0 1],'[rebuild] '); 
        cprintf([ 0 0 0],'button to update those files.\n');
        cprintf([ .5 .5 .5],msg);
        cprintf([ .5 .5 .5],'\n');
    end
    
else
    cprintf([ 0.4667    0.6745    0.1882],'------------------------------------------------\n');
    cprintf([ 0.4667    0.6745    0.1882],' ::.STATUS: UP-TO-DATE. NO NEWER UPDATES FOUND      \n');
    cprintf([ 0.4667    0.6745    0.1882],'------------------------------------------------\n');
end

end

function pbinstallfromgithub(updatecode)

global antupd;
atime=tic;
% prevdir    =p.pwd;
% updatepath =p.updatepath;
% antxpath   =p.antxpath;

if exist('.git','dir')~=7
    disp('version control (".git") folder has been removed previously');
    disp('set [keepVersionControl] to true and re-clone repository');
end



if updatecode==1 %check before
    setstatus(1,'checking updates');
    git fetch
    %git diff master origin/master
    %     git diff --compact-summary master origin/master
    %[msg st]=git('diff --compact-summary master origin/master');
    % [msg st]=git('diff --stat master origin/master');
%     [msg st]=git(' diff --name-only master origin/master');
    %     git diff --name-only
    [msg st]=antx_gitstatus('check');
    
    if isempty(msg);
        %disp('no changes/no updates found');
        setstatus(2,'no updates found');
        return
    else
        %disp(['####### CHANGES #######']);
        %disp(msg);
        button = questdlg(['updates where found' char(10) 'Update toolbox now? '],'',...
            'YES, update now','Cancel','canel');
        if ~isempty(regexpi(button,'yes'))
            updatecode=2;
        else
            %disp('nothing updated');
            cprintf([ 1 0 1],' local package was not updated  \n');
            return
        end
    end
end
if updatecode==2
    setstatus(1,'updating..');
    fprintf(['updating using version control (".git")..please wait..\n']);
    if exist(fullfile(pwd,'.git'))~=7
        button = questdlg(['".git-dir" not found, but mandatory for update' char(10)...
            'Create/Recreate ".git"-dir? ' char(10) ...
            '    ..this might take a while..'],'',...
            'YES, do it','Cancel','canel');
        git reset --hard HEAD;
        if ~isempty(regexpi(button,'yes'))
            updatecode=3;
        else
            disp('..".git"-not found, .git not restored');
            return
        end
    else
        git pull;
         
    end
    [msg st]=antx_gitstatus('recheck');
    try; antcb('versionupdate'); end
    if isempty(msg)
        fprintf(['updating..done t=%2.3f min\n'],toc(atime)/60);
        setstatus(2,'updates finished');
    else
        setstatus(3,'updaiting failed..press [rebuild] button');
    end
    return
    
end

if updatecode==3
    setstatus(1,'create ".git" & updating..');
    % need to initialize a new Git repository in your machine:
    fprintf(['creating/restore ".git"..please wait..\n']);
    git init
    %Add your remote repository (published on GitHub):
    %git remote add origin https://github.com/pstkoch/antx2
    git(['remote add origin ' gitrepository]);
    git pull origin master
    
    %Or you can simply clone the existing remote repository as suggested in the above comments:
    %git clone https://your_repot_url
     try; antcb('versionupdate'); end
    fprintf(['..done t=%2.3f min\n'],toc(atime)/60);
end
if updatecode==5 %hard reset
    setstatus(1,'hard reset..');
    fprintf(['hard reset,updating..please wait..\n']);
    %if exist(fullfile(pwd,'.git'))~=7
    %git clean -df
    git reset --hard HEAD;
    git init
    %Add your remote repository (published on GitHub):
    %git remote add origin https://github.com/pstkoch/antx2
    git(['remote add origin ' gitrepository]);
    git pull origin master
    
    [msg st]=antx_gitstatus('recheck');
    
    
    if ~isempty(findobj(0,'tag','ant'))
        disp('..linking paths');
        thispa=pwd;
        cd(antupd.updatepath);
        antlink(1);
        cd(thispa);
        antcb('update');
        try; antcb('versionupdate'); end
    end
    
    fprintf(['updating..done t=%2.3f min\n'],toc(atime)/60);
end

%% FRESH INSTALLATION
if updatecode==4
    
    global antupd;
    antupd.tempfile=which('temp_installfromgithub.m');%fullfile(fileparts(which('installfromgithub.m')),'temp_installfromgithub.m');
    
    disp('====== FRESH INSTALLATION =====================================================');
    msg_uigetdir=['# Please select the local destination path for "antx2"'];
    disp([msg_uigetdir ]);
    pa=uigetdir(pwd,msg_uigetdir );
    if isnumeric(pa);        return ;    end
    
    [pa2 pa1]=fileparts(pa);
    if strcmp(pa1,'antx2');%antx2-path selected
        patempup=pa2;  %..than use upper folder of antx2
%     elseif exist(fullfile(pa,'antx2'))==7
%         patempup=pa2; %..than use upper folder of antx2
    else
        patempup=pa;
    end
    antupd.patempup=patempup;
%     disp(patempup);
    
    
    cd(patempup);
    try
        copyfile(fullfile(antupd.updatepath,'installfromgithub.m'), fullfile(antupd.patempup,'installfromgithub.m'),'f');
    end
    
    msgpafinal=[' DESTINATION PATH: ' fullfile(antupd.patempup,'antx2') ] ;
    if ispc==1
       msgpafinal=strrep(msgpafinal,filesep,[filesep filesep]);
    end
    cprintf([0 .5 0], [msgpafinal  '\n']);
    
    
    %disp(['..selected path: "' fullfile(antupd.patempup,'antx2')  '"']);
  
    disp([' Click hyperlink to install from GITHUB": <a href="matlab: cd(''' antupd.patempup ''');installfromgithub(''install'');">install</a>']);
    
end




setstatus(0);
end

function posthoc
global antupd;

if ~isempty(p.antxpath);
    antlink(1);
    rehash path;
end
cd(p.prevdir);
disp('..updated');


% edit(fullfile(paantx,'README.txt'));

end


function mkgui()

% ==============================================
%%   
% ===============================================
butwid=.75;
butx  =.1;

% global antpd
% figpos=[0.3750    0.3544    0.2896    0.2289];
figpos=[0.5111    0.3567    0.1271    0.2289];
try;  delete(findobj(0,'tag','fupd')); end
figure; set(gcf,'color','w','units','normalized','menubar','none',...
    'position',figpos,'tag','fupd',...
    'name', [mfilename],'NumberTitle','off');
set(gcf,'CloseRequestFcn',{@pbclose});

% HEAD
hp=uicontrol('style','text','units','norm','string','Update from GITHUB repository',...
    'fontsize',9,'fontweight','bold');
set(hp,'position',[.01 0.8 .99 .17],'tag','txinfo','foregroundcolor',[0 0 1],'backgroundcolor',[1 1 1]);

% STATUS-WARNING SIGN
hp=uicontrol('style','text','units','norm','string','!','fontsize',9);
set(hp,'position',[.01 0.6 .05 .2],'tag','msgwarn','foregroundcolor',[.4 .4 .4],'backgroundcolor',[1 1 1]);
set(hp,'horizontalalignment','left');
set(hp,'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],'fontweight','bold','fontsize',20)

% STATUS
hp=uicontrol('style','text','units','norm','string','status: -unknown-','fontsize',9);
set(hp,'position',[butx 0.6 1.0 .2],'tag','msg','foregroundcolor',[.4 .4 .4],'backgroundcolor',[1 1 1]);
set(hp,'horizontalalignment','left');
setstatus(0);

% UPDATE/UPDATE WITHOUT CHECK

hp=uicontrol('style','pushbutton','units','norm','string','check for updates','fontsize',9);
set(hp,'position',[butx .5 butwid .1],'callback',{@pbinstallfromgithubcall,1});
set(hp,'tooltipstring',['..checks for updates from repository only']);

hp=uicontrol('style','pushbutton','units','norm','string','update without check','fontsize',9);
set(hp,'position',[butx .4 butwid .1],'callback',{@pbinstallfromgithubcall,2});
set(hp,'tooltipstring',['..updates from repository without checking ' char(10) ...
    '        [duration]: fast (secs) ']);


%REBUILD
hp=uicontrol('style','pushbutton','units','norm','string','rebuild','fontsize',9);
set(hp,'position',[butx .3 butwid .1],'callback',{@pbinstallfromgithubcall,5});
set(hp,'tooltipstring',['..rebuild toolbox' char(10) ...
    ' * USED WHEN: '                        char(10) ...
    '   - files are missing / not updated' char(10)' ...
    '   - ".git"-folder is lost '          char(10)' ...
    '        [duration]: fast (secs) ']);

%FRESH INSTALL
hp=uicontrol('style','pushbutton','units','norm','string','fresh installation','fontsize',9);
set(hp,'position',[butx .2 butwid .1],'callback',{@pbinstallfromgithubcall,4},'foregroundcolor','r');
set(hp,'tooltipstring',['..make FRESH INSTALLATION' char(10) ...
    ' * USED WHEN: '                                char(10) ...
    '   - toolbox was never installed before'       char(10)' ...
    '   - files are missing / not updated'          char(10)' ...
    '   - ".git"-folder is lost '                   char(10)' ...
    '        [duration]: slow (mins) ']);


hp=uicontrol('style','pushbutton','units','norm','string','Close','fontsize',9);
set(hp,'position',[.01 .01 .3 .1],'callback',{@pbclose},'foregroundcolor','k');
set(hp,'tooltipstring',['..close window']);


% WEB
% hp=uicontrol('style','text','units','norm','string','visit Github','fontsize',7);
% set(hp,'position',[.5 .01 .3 .1],'callback',{@pbvisitGithub},'backgroundcolor','w','foregroundcolor','b');
% set(hp,'tooltipstring',['..visit GitHub repositiory online']);
% set(hp,'string','<html><a href="">visit Github</a></html>','fontsize',5)
% 
% 
% 



url = 'https://github.com/ChariteExpMri/antx2';
labelStr = ['<html>visit <a href="">' 'GitHUB' '</a></html>'];
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[hjLabel,hContainer] = javacomponent(jLabel, [10,10,250,20], gcf);
set(hContainer,'units','norm','position',[.5 .02 6 .1]);%,'backgroundcolor',[0  1 1])
%  http://undocumentedmatlab.com/articles/javacomponent-background-color

% Modify the mouse cursor when hovering on the label
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
hjLabel.setBackground(java.awt.Color(1,1,1));

jFont = java.awt.Font('Tahoma', java.awt.Font.PLAIN, 12);
hjLabel.setFont(jFont);
drawnow;
 
% Set the label's tooltip
hjLabel.setToolTipText(['Visit Github repository ' url ' ']);
 
% Set the mouse-click callback
set(hjLabel, 'MouseClickedCallback', @(h,e)web([url], '-browser'));



% ==============================================
%%   
% ===============================================

end

function pbvisitGithub(e,e2)
web('https://github.com/ChariteExpMri/antx2','-browser');
end

function setstatus(arg,msg)
if arg==0
    set(findobj( findobj(0,'tag','fupd') ,'tag','msg'),'foregroundcolor',[.4 .4 .4],'string','[idle] ');
elseif arg==1
    set(findobj( findobj(0,'tag','fupd') ,'tag','msg'),'foregroundcolor',[1 0 1],'string',['[busy] ' msg]);
elseif arg==2
    set(findobj( findobj(0,'tag','fupd') ,'tag','msg'),'foregroundcolor',[ 0.4667    0.6745    0.1882],'string',['[idle] ' msg]);
elseif arg==3
    set(findobj( findobj(0,'tag','fupd') ,'tag','msg'),'foregroundcolor',[ 1 0 0],'string',['[idle] ' msg]);
end
drawnow
end



function installLinux(antupd,gitrepository)

%% proxy+port problem: Connection timed out while accessing
% source:
% https://stackoverflow.com/questions/12117957/global-git-file-location-linux/23134785

% find out the IP of our proxy server
% declare the proxy corporate to git. Depending on whether you need to authenticate or not you should add this information to the global configuration of git :
% git config --global http.proxy http://proxyuser:proxypwd@proxy.server.com:8080
% or
% git config --global http.proxy http://proxy.server.com:8080



if ispc || ismac==1; return; end

clc
dowhile=1;
% disp(['..']);
% disp('=============================================');
%disp('LINUX USER - get ANTX repository from GITHUB');
cprintf(-[1,0,1], '                                            \n');
cprintf(-[1,0,1], 'LINUX USER - get ANTX repository from GITHUB\n');
disp('..PROBLEMS with GIT proxy/port settings and/or SUDO PERMISSION ..');
disp(' step-1: modify proxy/port settings () ');
disp(' step-2: clone repository with sudo permission');
disp(' Do step-2 if you think that proxy/port settings is ok');
disp(' Otherwise do step-1 followed by step-2');
cprintf( [ 0.8294    0.4902    0.1294], '..sudo passwort is needed (password request via command window)\n');

while dowhile==1
    
    if 1
        %disp('====== USERINPUT ==============================================');
        cprintf(-[1,0,1], '====== USERINPUT =========================\n');
        disp(' select [1] to modify the proxy/port settings. than..select [2]');
        disp(' select [2] to (try to) clone the repository');
        disp(' select [0] to proceed (at this point it is assumed that cloning of repository was succesfull (see message above)');
        %answer=input('## What do you want to do select [1],[2], or [0]: ','s');
        cprintf( [0 0 1], '## What do you want to do select [1],[2], or [0]: ');
        answer=input('  ','s');
        
        
        
    end
    if strcmp(char(answer),'0')
        dowhile=0;
    end
    
    if strcmp(char(answer),'1')
        clc;
        %disp('step[1]===================================================');
        cprintf(-[1,0,1], 'step[1]===================================================\n');
        disp(['please provide your/department''s proxy address and port' ]);
        disp(['..see "gitconfig"-document in Matlab editor']);
        disp([' Please enter a new line with your proxy and port below the "[http]"-tag' ]);
        disp([' If necessary, remove all other proxies/ports from this file.' ]);
        disp('------------------------------------------------------------');
        disp(['  Here is an example how the file might look like.']);
        disp('------------------------------------------------------------');
        disp(['[http]']);
        disp(['   proxy = http://proxy.YOURPROXYSERVER:8080/']);
        disp(['[https]']);
        disp('------------------------------------------------------------');
        disp(['..where "http://proxy.YOURPROXYSERVER" is an examplatory proxy server' ]);
        disp(['..where "8080" is the PORT for HTTP protocol  (http)' ]);
        disp([' ..CLICK SAVE BUTTON TO SAVE THIS FILE..' ]);
        disp([' ..ENTER [2] in COMMAND WINDOW TO CHECK WHETHER GIT CLONING WORKS' ]);
        disp('===============================================================');
        
        %         disp(['proxy = http://proxy.charite.de:8080/ ' ]);
        % msg
        if exist('~/.gitconfig')==2
            
            %system('sudo xdg-open ~/.gitconfig');
            system('sudo chmod 777 ~/.gitconfig'); %compare with 755
            edit('~/.gitconfig');
        end
    end
    %   [~,gitconfig ]=system('readlink -f ~/.gitconfig')
    %   gitconfig=regexprep(gitconfig,char(10),'')
    %   ef = matlab.desktop.editor.openDocument(gitconfig);  % opens the file in the editor
    %   waitfor(ef,'Opened',0);  % this line waits for the editor property 'Opened' to change from a 1 to a 0 when the file is closed
    %
    
    %===================================
    % now clone it
    if strcmp(char(answer),'2')
        
        % git clone <repo> <directory>
        pa2=fullfile(antupd.patempup, 'antx2');
        system(['sudo rm -r ' pa2]);
        mkdir(pa2);
        %gitrepository='https://github.com/ChariteExpMri/antx2.git'; %temp
        disp('..please wait');
        [r1 r2]=system(['sudo git clone --depth=1 -v ' gitrepository ' ' pa2 ]);
        clc;
        cprintf(-[1,0,1], 'step[2]===================================================\n');
        %disp('step[2]===================================================');
        if isempty(strfind(r2,'done'))
            
            cprintf([1.0000    0.4118    0.1608], ['..git clone PROPLEM:\n']);
            cprintf([1.0000    0.4118    0.1608], r2);
            cprintf([1.0000    0.4118    0.1608], '  ');
            %disp('### ..git clone PROPLEM: ###');
            %disp(r2);
        else
            cprintf([0 .5 0], '### ..git clone SUCCESSFULL..select [0] to proceed.. ###\n');
            %disp('### ..git clone SUCCESSFULL..select [0] to proceed.. ###');
        end
        %         proxy = http://proxy.charite.de:8080/
    end
    
end %while
disp('..');

end

































































function [cmdout, statout] =  git(varargin)
% A thin MATLAB wrapper for Git.
%
%   Short instructions:
%       Use this exactly as you would use the OS command-line verison of Git.
%
%   Long instructions are:
%       This is not meant to be a comprehensive guide to the near-omnipotent
%       Git SCM:
%           http://git-scm.com/documentation
%
%       Common MATLAB workflow:
%
%       % Creates initial repository tracking all files under some root
%       % folder
%       >> cd ~/
%       >> git init
%
%       % Shows changes made to all files in repo (none so far)
%       >> git status
%
%       % Create a new file and add some code
%       >> edit foo.m
%
%       % Check repo status, after new file created
%       >> git status
%
%       % Stage/unstage files for commit
%       >> git add foo.m          % Add file to repo or to stage
%       >> git reset HEAD .       % To unstage your files from current commit area
%
%       % Commit your changes to a new branch, with comments
%       >> git commit -m 'Created new file, foo.m'
%
%       % Other useful commands (replace ellipses with appropriate args)
%       >> git checkout ...       % To restore files to last commit
%       >> git branch ...         % To create or move to another branch
%       >> git diff ...           % See line-by-line changes
%
%   Useful resources:
%       1. GitX: A visual interface for Git on the OS X client
%       2. Github.com: Remote hosting for Git repos
%       3. Git on Wikipedia: Further reading
%
% v0.1,     27 October 2010 -- MR: Initial support for OS X & Linux,
%                               untested on PCs, but expected to work
%
% v0.2,     11 March 2011   -- TH: Support for PCs
%
% v0.3,     12 March 2011   -- MR: Fixed man pages hang bug using redirection
%
% v0.4,     20 November 2013-- TN: Searching for git in default directories,
%                               returning results as variable
%
% v0.5,     22 January 2015 -- TP: Suppressed printing of ans before
%                                  git command output
%
% v0.6,     26 January 2015 -- HG: Add path to git
%
% v0.7      09 April 2015   -- VF: If user requests it, return Git results
%                              as a variable instead of displaying them.
%
% v0.8      24 Juli 2015    -- MvdL: Return status output
%
%
% Contributors: (MR) Manu Raghavan
%               (TH) Timothy Hansell
%               (TN) Tassos Natsakis
%               (TP) Tyler Parsons
%               (HG) Han Geerligs
%               (VF) Vadim Frolov
%               (MvdL) Marcel van der Linden
%
orgpath=getenv('PATH');
quit_function=0;
try
    % Test to see if git is installed
    [status,~] = system('git --version');
    % if git is in the path this will return a status of 0
    % it will return a 1 only if the command is not found
    
    % git command output
    result = '';
    
    if status
        % Checking if git exists in the default installation folders (for
        % Windows)
        if ispc
            search = ~isempty(dir('c:\Program Files\Git\bin\git.exe'));
            searchx86 = ~isempty(dir('c:\Program Files (x86)\Git\bin\git.exe'));
        else
            search = 0;
            searchx86 = 0;
        end
        
        if ~(search||searchx86)
            % If git is NOT installed, then this should end the function.
            result = sprintf('git is not installed\n%s\n',...
                'Download it at http://git-scm.com/download');
            quit_function=1; % set quit_function flag: only result is displayed
        end
    end
    
    % if quit_function then only display message
    if ~quit_function
        % If git exists but the status is 1, then it means that it is
        % not in the path. We should add the path
        if status
            if search
                gitpath='c:\Program Files\Git\bin';
            else if searchx86
                    gitpath='c:\Program Files (x86)\Git\bin';
                end
            end
            setenv('PATH',[gitpath pathsep orgpath]); % add path to git
        end
        
        % We can call the real git with the arguments
        arguments = parse(varargin{:});
        if ispc
            prog = '';
        else
            prog = ' | cat';
        end
        if strcmp(arguments, 'commit ')
            answer = inputdlg('Comments:','Commit''s comments');
            arguments = [arguments '-m"' char(answer) '"'];
        end
        [status,result] = system(['git ',arguments,prog]);
    end
    if nargout >= 1
        cmdout = strtrim(result);
        statout = status;
    else
        % Display result instead of returning it
        % to suppress output of ans
        disp(result);
    end
    
    % restore the original path
    setenv(orgpath);
catch
    % restore the original path
    setenv(orgpath);
end
end

function space_delimited_list = parse(varargin)
space_delimited_list = cell2mat(...
    cellfun(@(s)([s,' ']),varargin,'UniformOutput',false));
end




function count = cprintf(style,format,varargin)
% CPRINTF displays styled formatted text in the Command Window
%
% Syntax:
%    count = cprintf(style,format,...)
%
% Description:
%    CPRINTF processes the specified text using the exact same FORMAT
%    arguments accepted by the built-in SPRINTF and FPRINTF functions.
%
%    CPRINTF then displays the text in the Command Window using the
%    specified STYLE argument. The accepted styles are those used for
%    Matlab's syntax highlighting (see: File / Preferences / Colors / 
%    M-file Syntax Highlighting Colors), and also user-defined colors.
%
%    The possible pre-defined STYLE names are:
%
%       'Text'                 - default: black
%       'Keywords'             - default: blue
%       'Comments'             - default: green
%       'Strings'              - default: purple
%       'UnterminatedStrings'  - default: dark red
%       'SystemCommands'       - default: orange
%       'Errors'               - default: light red
%       'Hyperlinks'           - default: underlined blue
%
%       'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White'
%
%    STYLE beginning with '-' or '_' will be underlined. For example:
%          '-Blue' is underlined blue, like 'Hyperlinks';
%          '_Comments' is underlined green etc.
%
%    STYLE beginning with '*' will be bold (R2011b+ only). For example:
%          '*Blue' is bold blue;
%          '*Comments' is bold green etc.
%    Note: Matlab does not currently support both bold and underline,
%          only one of them can be used in a single cprintf command. But of
%          course bold and underline can be mixed by using separate commands.
%
%    STYLE also accepts a regular Matlab RGB vector, that can be underlined
%    and bolded: -[0,1,1] means underlined cyan, '*[1,0,0]' is bold red.
%
%    STYLE is case-insensitive and accepts unique partial strings just
%    like handle property names.
%
%    CPRINTF by itself, without any input parameters, displays a demo
%
% Example:
%    cprintf;   % displays the demo
%    cprintf('text',   'regular black text');
%    cprintf('hyper',  'followed %s','by');
%    cprintf('key',    '%d colored', 4);
%    cprintf('-comment','& underlined');
%    cprintf('err',    'elements\n');
%    cprintf('cyan',   'cyan');
%    cprintf('_green', 'underlined green');
%    cprintf(-[1,0,1], 'underlined magenta');
%    cprintf([1,0.5,0],'and multi-\nline orange\n');
%    cprintf('*blue',  'and *bold* (R2011b+ only)\n');
%    cprintf('string');  % same as fprintf('string') and cprintf('text','string')
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab
%    functionality. It works on Matlab 7+, but use at your own risk!
%
%    A technical description of the implementation can be found at:
%    <a href="http://undocumentedmatlab.com/blog/cprintf/">http://UndocumentedMatlab.com/blog/cprintf/</a>
%
% Limitations:
%    1. In R2011a and earlier, a single space char is inserted at the
%       beginning of each CPRINTF text segment (this is ok in R2011b+).
%
%    2. In R2011a and earlier, consecutive differently-colored multi-line
%       CPRINTFs sometimes display incorrectly on the bottom line.
%       As far as I could tell this is due to a Matlab bug. Examples:
%         >> cprintf('-str','under\nline'); cprintf('err','red\n'); % hidden 'red', unhidden '_'
%         >> cprintf('str','regu\nlar'); cprintf('err','red\n'); % underline red (not purple) 'lar'
%
%    3. Sometimes, non newline ('\n')-terminated segments display unstyled
%       (black) when the command prompt chevron ('>>') regains focus on the
%       continuation of that line (I can't pinpoint when this happens). 
%       To fix this, simply newline-terminate all command-prompt messages.
%
%    4. In R2011b and later, the above errors appear to be fixed. However,
%       the last character of an underlined segment is not underlined for
%       some unknown reason (add an extra space character to make it look better)
%
%    5. In old Matlab versions (e.g., Matlab 7.1 R14), multi-line styles
%       only affect the first line. Single-line styles work as expected.
%       R14 also appends a single space after underlined segments.
%
%    6. Bold style is only supported on R2011b+, and cannot also be underlined.
%
% Change log:
%    2015-06-24: Fixed a few discoloration issues (some other issues still remain)
%    2015-03-20: Fix: if command window isn't defined yet (startup) use standard fprintf as suggested by John Marozas
%    2012-08-09: Graceful degradation support for deployed (compiled) and non-desktop applications; minor bug fixes
%    2012-08-06: Fixes for R2012b; added bold style; accept RGB string (non-numeric) style
%    2011-11-27: Fixes for R2011b
%    2011-08-29: Fix by Danilo (FEX comment) for non-default text colors
%    2011-03-04: Performance improvement
%    2010-06-27: Fix for R2010a/b; fixed edge case reported by Sharron; CPRINTF with no args runs the demo
%    2009-09-28: Fixed edge-case problem reported by Swagat K
%    2009-05-28: corrected nargout behavior suggested by Andreas G�b
%    2009-05-13: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>
%
% See also:
%    sprintf, fprintf
% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.10 $  $Date: 2015/06/24 01:29:18 $
  persistent majorVersion minorVersion
  if isempty(majorVersion)
      %v = version; if str2double(v(1:3)) <= 7.1
      %majorVersion = str2double(regexprep(version,'^(\d+).*','$1'));
      %minorVersion = str2double(regexprep(version,'^\d+\.(\d+).*','$1'));
      %[a,b,c,d,versionIdStrs]=regexp(version,'^(\d+)\.(\d+).*');  %#ok unused
      v = sscanf(version, '%d.', 2);
      majorVersion = v(1); %str2double(versionIdStrs{1}{1});
      minorVersion = v(2); %str2double(versionIdStrs{1}{2});
  end
  % The following is for debug use only:
  %global docElement txt el
  if ~exist('el','var') || isempty(el),  el=handle([]);  end  %#ok mlint short-circuit error ("used before defined")
  if nargin<1, showDemo(majorVersion,minorVersion); return;  end
  if isempty(style),  return;  end
  if all(ishandle(style)) && length(style)~=3
      dumpElement(style);
      return;
  end
  % Process the text string
  if nargin<2, format = style; style='text';  end
  %error(nargchk(2, inf, nargin, 'struct'));
  %str = sprintf(format,varargin{:});
  % In compiled mode
  try useDesktop = usejava('desktop'); catch, useDesktop = false; end
  if isdeployed | ~useDesktop %#ok<OR2> - for Matlab 6 compatibility
      % do not display any formatting - use simple fprintf()
      % See: http://undocumentedmatlab.com/blog/bold-color-text-in-the-command-window/#comment-103035
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/1390a26e7ef4aa4d
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/13a6ed3223333b21
      count1 = fprintf(format,varargin{:});
  else
      % Else (Matlab desktop mode)
      % Get the normalized style name and underlining flag
      [underlineFlag, boldFlag, style, debugFlag] = processStyleInfo(style);
      % Set hyperlinking, if so requested
      if underlineFlag
          format = ['<a href="">' format '</a>'];
          % Matlab 7.1 R14 (possibly a few newer versions as well?)
          % have a bug in rendering consecutive hyperlinks
          % This is fixed by appending a single non-linked space
          if majorVersion < 7 || (majorVersion==7 && minorVersion <= 1)
              format(end+1) = ' ';
          end
      end
      % Set bold, if requested and supported (R2011b+)
      if boldFlag
          if (majorVersion > 7 || minorVersion >= 13)
              format = ['<strong>' format '</strong>'];
          else
              boldFlag = 0;
          end
      end
      % Get the current CW position
      cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
      lastPos = cmdWinDoc.getLength;
      % If not beginning of line
      bolFlag = 0;  %#ok
      %if docElement.getEndOffset - docElement.getStartOffset > 1
          % Display a hyperlink element in order to force element separation
          % (otherwise adjacent elements on the same line will be merged)
          if majorVersion<7 || (majorVersion==7 && minorVersion<13)
              if ~underlineFlag
                  fprintf('<a href=""> </a>');  %fprintf('<a href=""> </a>\b');
              elseif format(end)~=10  % if no newline at end
                  fprintf(' ');  %fprintf(' \b');
              end
          end
          %drawnow;
          bolFlag = 1;
      %end
      % Get a handle to the Command Window component
      mde = com.mathworks.mde.desk.MLDesktop.getInstance;
      cw = mde.getClient('Command Window');
      % Fix: if command window isn't defined yet (startup), use standard fprintf()
      if (isempty(cw))
         count1 = fprintf(format,varargin{:});
         if nargout
             count = count1;
         end
         return;
      end
      
      xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
      % Store the CW background color as a special color pref
      % This way, if the CW bg color changes (via File/Preferences), 
      % it will also affect existing rendered strs
      com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);
      % Display the text in the Command Window
      % Note: fprintf(2,...) is required in order to add formatting tokens, which
      % ^^^^  can then be updated below (no such tokens when outputting to stdout)
      count1 = fprintf(2,format,varargin{:});
      % Repaint the command window
      %awtinvoke(cmdWinDoc,'remove',lastPos,1);   % TODO: find out how to remove the extra '_'
      drawnow;  % this is necessary for the following to work properly (refer to Evgeny Pr in FEX comment 16/1/2011)
      xCmdWndView.repaint;
      %hListeners = cmdWinDoc.getDocumentListeners; for idx=1:numel(hListeners), try hListeners(idx).repaint; catch, end, end
      docElement = cmdWinDoc.getParagraphElement(lastPos+1);
      if majorVersion<7 || (majorVersion==7 && minorVersion<13)
          if bolFlag && ~underlineFlag
              % Set the leading hyperlink space character ('_') to the bg color, effectively hiding it
              % Note: old Matlab versions have a bug in hyperlinks that need to be accounted for...
              %disp(' '); dumpElement(docElement)
              setElementStyle(docElement,'CW_BG_Color',1+underlineFlag,majorVersion,minorVersion); %+getUrlsFix(docElement));
              %disp(' '); dumpElement(docElement)
              el(end+1) = handle(docElement);  % #ok used in debug only
          end
          % Fix a problem with some hidden hyperlinks becoming unhidden...
          fixHyperlink(docElement);
          %dumpElement(docElement);
      end
      % Get the Document Element(s) corresponding to the latest fprintf operation
      while docElement.getStartOffset < cmdWinDoc.getLength
          % Set the element style according to the current style
          if debugFlag, dumpElement(docElement); end
          specialFlag = underlineFlag | boldFlag;
          setElementStyle(docElement,style,specialFlag,majorVersion,minorVersion);
          if debugFlag, dumpElement(docElement); end
          docElement2 = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
          if isequal(docElement,docElement2),  break;  end
          docElement = docElement2;
      end
      if debugFlag, dumpElement(docElement); end
      % Force a Command-Window repaint
      % Note: this is important in case the rendered str was not '\n'-terminated
      xCmdWndView.repaint;
      % The following is for debug use only:
      el(end+1) = handle(docElement);  %#ok used in debug only
      %elementStart  = docElement.getStartOffset;
      %elementLength = docElement.getEndOffset - elementStart;
      %txt = cmdWinDoc.getText(elementStart,elementLength);
  end
  if nargout
      count = count1;
  end
  return;  % debug breakpoint
% Process the requested style information
end

function [underlineFlag,boldFlag,style,debugFlag] = processStyleInfo(style)
  underlineFlag = 0;
  boldFlag = 0;
  debugFlag = 0;
  % First, strip out the underline/bold markers
  if ischar(style)
      % Styles containing '-' or '_' should be underlined (using a no-target hyperlink hack)
      %if style(1)=='-'
      underlineIdx = (style=='-') | (style=='_');
      if any(underlineIdx)
          underlineFlag = 1;
          %style = style(2:end);
          style = style(~underlineIdx);
      end
      % Check for bold style (only if not underlined)
      boldIdx = (style=='*');
      if any(boldIdx)
          boldFlag = 1;
          style = style(~boldIdx);
      end
      if underlineFlag && boldFlag
          warning('YMA:cprintf:BoldUnderline','Matlab does not support both bold & underline')
      end
      % Check for debug mode (style contains '!')
      debugIdx = (style=='!');
      if any(debugIdx)
          debugFlag = 1;
          style = style(~debugIdx);
      end
      % Check if the remaining style sting is a numeric vector
      %styleNum = str2num(style); %#ok<ST2NM>  % not good because style='text' is evaled!
      %if ~isempty(styleNum)
      if any(style==' ' | style==',' | style==';')
          style = str2num(style); %#ok<ST2NM>
      end
  end
  % Style = valid matlab RGB vector
  if isnumeric(style) && length(style)==3 && all(style<=1) && all(abs(style)>=0)
      if any(style<0)
          underlineFlag = 1;
          style = abs(style);
      end
      style = getColorStyle(style);
  elseif ~ischar(style)
      error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')
  % Style name
  else
      % Try case-insensitive partial/full match with the accepted style names
      matlabStyles = {'Text','Keywords','Comments','Strings','UnterminatedStrings','SystemCommands','Errors'};
      validStyles  = [matlabStyles, ...
                      'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White', ...
                      'Hyperlinks'];
      matches = find(strncmpi(style,validStyles,length(style)));
      % No match - error
      if isempty(matches)
          error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')
      % Too many matches (ambiguous) - error
      elseif length(matches) > 1
          error('YMA:cprintf:AmbigStyle','Ambiguous style name - supply extra characters for uniqueness')
      % Regular text
      elseif matches == 1
          style = 'ColorsText';  % fixed by Danilo, 29/8/2011
      % Highlight preference style name
      elseif matches <= length(matlabStyles)
          style = ['Colors_M_' validStyles{matches}];
      % Color name
      elseif matches < length(validStyles)
          colors = [0,0,0; 0,1,1; 1,0,1; 0,0,1; 0,1,0; 1,0,0; 1,1,0; 1,1,1];
          requestedColor = colors(matches-length(matlabStyles),:);
          style = getColorStyle(requestedColor);
      % Hyperlink
      else
          style = 'Colors_HTML_HTMLLinks';  % CWLink
          underlineFlag = 1;
      end
  end
% Convert a Matlab RGB vector into a known style name (e.g., '[255,37,0]')
end
function styleName = getColorStyle(rgb)
  intColor = int32(rgb*255);
  javaColor = java.awt.Color(intColor(1), intColor(2), intColor(3));
  styleName = sprintf('[%d,%d,%d]',intColor);
  com.mathworks.services.Prefs.setColorPref(styleName,javaColor);
% Fix a bug in some Matlab versions, where the number of URL segments
% is larger than the number of style segments in a doc element
end
function delta = getUrlsFix(docElement)  %#ok currently unused
  tokens = docElement.getAttribute('SyntaxTokens');
  links  = docElement.getAttribute('LinkStartTokens');
  if length(links) > length(tokens(1))
      delta = length(links) > length(tokens(1));
  else
      delta = 0;
  end
% fprintf(2,str) causes all previous '_'s in the line to become red - fix this
end
function fixHyperlink(docElement)
  try
      tokens = docElement.getAttribute('SyntaxTokens');
      urls   = docElement.getAttribute('HtmlLink');
      urls   = urls(2);
      links  = docElement.getAttribute('LinkStartTokens');
      offsets = tokens(1);
      styles  = tokens(2);
      doc = docElement.getDocument;
      % Loop over all segments in this docElement
      for idx = 1 : length(offsets)-1
          % If this is a hyperlink with no URL target and starts with ' ' and is collored as an error (red)...
          if strcmp(styles(idx).char,'Colors_M_Errors')
              character = char(doc.getText(offsets(idx)+docElement.getStartOffset,1));
              if strcmp(character,' ')
                  if isempty(urls(idx)) && links(idx)==0
                      % Revert the style color to the CW background color (i.e., hide it!)
                      styles(idx) = java.lang.String('CW_BG_Color');
                  end
              end
          end
      end
  catch
      % never mind...
  end
% Set an element to a particular style (color)
end
function setElementStyle(docElement,style,specialFlag, majorVersion,minorVersion)
  %global tokens links urls urlTargets  % for debug only
  global oldStyles
  if nargin<3,  specialFlag=0;  end
  % Set the last Element token to the requested style:
  % Colors:
  tokens = docElement.getAttribute('SyntaxTokens');
  try
      styles = tokens(2);
      oldStyles{end+1} = cell(styles);
      % Correct edge case problem
      extraInd = double(majorVersion>7 || (majorVersion==7 && minorVersion>=13));  % =0 for R2011a-, =1 for R2011b+
      %{
      if ~strcmp('CWLink',char(styles(end-hyperlinkFlag))) && ...
          strcmp('CWLink',char(styles(end-hyperlinkFlag-1)))
         extraInd = 0;%1;
      end
      hyperlinkFlag = ~isempty(strmatch('CWLink',tokens(2)));
      hyperlinkFlag = 0 + any(cellfun(@(c)(~isempty(c)&&strcmp(c,'CWLink')),cell(tokens(2))));
      %}
      jStyle = java.lang.String(style);
      if numel(styles)==4 && isempty(char(styles(2)))
          % Attempt to fix discoloration issues - NOT SURE THAT THIS IS OK! - 24/6/2015
          styles(1) = jStyle;
      end
      styles(end-extraInd) = java.lang.String('');
      styles(end-extraInd-specialFlag) = jStyle;  % #ok apparently unused but in reality used by Java
      if extraInd
          styles(end-specialFlag) = jStyle;
      end
      oldStyles{end} = [oldStyles{end} cell(styles)];
  catch
      % never mind for now
  end
  
  % Underlines (hyperlinks):
  %{
  links = docElement.getAttribute('LinkStartTokens');
  if isempty(links)
      %docElement.addAttribute('LinkStartTokens',repmat(int32(-1),length(tokens(2)),1));
  else
      %TODO: remove hyperlink by setting the value to -1
  end
  %}
  % Correct empty URLs to be un-hyperlinkable (only underlined)
  urls = docElement.getAttribute('HtmlLink');
  if ~isempty(urls)
      urlTargets = urls(2);
      for urlIdx = 1 : length(urlTargets)
          try
              if urlTargets(urlIdx).length < 1
                  urlTargets(urlIdx) = [];  % '' => []
              end
          catch
              % never mind...
              a=1;  %#ok used for debug breakpoint...
          end
      end
  end
  
  % Bold: (currently unused because we cannot modify this immutable int32 numeric array)
  %{
  try
      %hasBold = docElement.isDefined('BoldStartTokens');
      bolds = docElement.getAttribute('BoldStartTokens');
      if ~isempty(bolds)
          %docElement.addAttribute('BoldStartTokens',repmat(int32(1),length(bolds),1));
      end
  catch
      % never mind - ignore...
      a=1;  %#ok used for debug breakpoint...
  end
  %}
  
  return;  % debug breakpoint
% Display information about element(s)
end
function dumpElement(docElements)
  %return;
  disp(' ');
  numElements = length(docElements);
  cmdWinDoc = docElements(1).getDocument;
  for elementIdx = 1 : numElements
      if numElements > 1,  fprintf('Element #%d:\n',elementIdx);  end
      docElement = docElements(elementIdx);
      if ~isjava(docElement),  docElement = docElement.java;  end
      %docElement.dump(java.lang.System.out,1)
      disp(docElement)
      tokens = docElement.getAttribute('SyntaxTokens');
      if isempty(tokens),  continue;  end
      links = docElement.getAttribute('LinkStartTokens');
      urls  = docElement.getAttribute('HtmlLink');
      try bolds = docElement.getAttribute('BoldStartTokens'); catch, bolds = []; end
      txt = {};
      tokenLengths = tokens(1);
      for tokenIdx = 1 : length(tokenLengths)-1
          tokenLength = diff(tokenLengths(tokenIdx+[0,1]));
          if (tokenLength < 0)
              tokenLength = docElement.getEndOffset - docElement.getStartOffset - tokenLengths(tokenIdx);
          end
          txt{tokenIdx} = cmdWinDoc.getText(docElement.getStartOffset+tokenLengths(tokenIdx),tokenLength).char;  %#ok
      end
      lastTokenStartOffset = docElement.getStartOffset + tokenLengths(end);
      try
          txt{end+1} = cmdWinDoc.getText(lastTokenStartOffset, docElement.getEndOffset-lastTokenStartOffset).char; %#ok
      catch
          txt{end+1} = ''; %#ok<AGROW>
      end
      %cmdWinDoc.uiinspect
      %docElement.uiinspect
      txt = strrep(txt',sprintf('\n'),'\n');
      try
          data = [cell(tokens(2)) m2c(tokens(1)) m2c(links) m2c(urls(1)) cell(urls(2)) m2c(bolds) txt];
          if elementIdx==1
              disp('    SyntaxTokens(2,1) - LinkStartTokens - HtmlLink(1,2) - BoldStartTokens - txt');
              disp('    ==============================================================================');
          end
      catch
          try
              data = [cell(tokens(2)) m2c(tokens(1)) m2c(links) txt];
          catch
              disp([cell(tokens(2)) m2c(tokens(1)) txt]);
              try
                  data = [m2c(links) m2c(urls(1)) cell(urls(2))];
              catch
                  % Mtlab 7.1 only has urls(1)...
                  data = [m2c(links) cell(urls)];
              end
          end
      end
      disp(data)
  end
end
% Utility function to convert matrix => cell
function cells = m2c(data)
  %datasize = size(data);  cells = mat2cell(data,ones(1,datasize(1)),ones(1,datasize(2)));
  cells = num2cell(data);
end
% Display the help and demo
function showDemo(majorVersion,minorVersion)
  fprintf('cprintf displays formatted text in the Command Window.\n\n');
  fprintf('Syntax: count = cprintf(style,format,...);  click <a href="matlab:help cprintf">here</a> for details.\n\n');
  url = 'http://UndocumentedMatlab.com/blog/cprintf/';
  fprintf(['Technical description: <a href="' url '">' url '</a>\n\n']);
  fprintf('Demo:\n\n');
  boldFlag = majorVersion>7 || (majorVersion==7 && minorVersion>=13);
  s = ['cprintf(''text'',    ''regular black text'');' 10 ...
       'cprintf(''hyper'',   ''followed %s'',''by'');' 10 ...
       'cprintf(''key'',     ''%d colored'',' num2str(4+boldFlag) ');' 10 ...
       'cprintf(''-comment'',''& underlined'');' 10 ...
       'cprintf(''err'',     ''elements:\n'');' 10 ...
       'cprintf(''cyan'',    ''cyan'');' 10 ...
       'cprintf(''_green'',  ''underlined green'');' 10 ...
       'cprintf(-[1,0,1],  ''underlined magenta'');' 10 ...
       'cprintf([1,0.5,0], ''and multi-\nline orange\n'');' 10];
   if boldFlag
       % In R2011b+ the internal bug that causes the need for an extra space
       % is apparently fixed, so we must insert the sparator spaces manually...
       % On the other hand, 2011b enables *bold* format
       s = [s 'cprintf(''*blue'',   ''and *bold* (R2011b+ only)\n'');' 10];
       s = strrep(s, ''')',' '')');
       s = strrep(s, ''',5)',' '',5)');
       s = strrep(s, '\n ','\n');
   end
   disp(s);
   eval(s);
%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%
% - Fix: Remove leading space char (hidden underline '_')
% - Fix: Find workaround for multi-line quirks/limitations
% - Fix: Non-\n-terminated segments are displayed as black
% - Fix: Check whether the hyperlink fix for 7.1 is also needed on 7.2 etc.
% - Enh: Add font support
end

