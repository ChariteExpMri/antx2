
%% make_localantsettingsFile
% make a local antsettings-file that is located for instance in Matlab's-defined userpath
% -the settinfs will override the local settings
% #lk _____USAGE______
% make_localantsettingsFile   : 
%                           -if not exist, make a local antsettings-file "localantsettings.m"
%                           - show "localantsettings.m" in editor to allow modifying the content
% make_localantsettingsFile(delete): delete existing local "localantsettings.m"-file
% o=make_localantsettingsFile('showpath'); display path of "localantsettings.m"-file
% o=make_localantsettingsFile('getsettings'); obtain settings parameter


function out=make_localantsettingsFile(task)
out=[];
if exist('task')
    if strcmp(task,'delete')
        delete_file();
    elseif strcmp(task,'findfile')
        out=find_file(); 
    elseif strcmp(task,'showpath')
        showpath
     elseif strcmp(task,'getsettings')
         out=getsettings();
    end
    return
end


% % F:\antx2\mritools\ant
% fileName='localantsettings.m';
% f1=which(fileName);
% %% =================[check dirs]==============================
% if isempty(f1)
%     rehash path
%     upath=regexprep(userpath,';','');
%     checkpa={
%         fullfile(upath,'antx2_userdef',fileName)
%         fullfile(upath,fileName)
%         };
%     for i=1:length(upath)
%        if exist(checkpa{i}) ==2
%            f1=checkpa{i};
%            break
%        end
%     end
% end

% 'fi'
% return

f1=find_file();


%% ===============================================
if isempty(f1)
    % =========[questdlg]========================
    opt=struct('Interpreter','tex','Default','OK');
    msg={'A local settings file "localantsettings.m" does not exist',...
        '\color{blue} \bf Create settingsfile in Matlab''s  userpath   or any other path? \rm'...
        '\color[rgb]{0,0.5,0.5} The path of "localantsettings.m" must be visible from inside Matlab.'...
        '-In most cases the "userpath" (type: "userpath" to examine..) is visible inside Matlab.' ...
        '-Otherwise select another path and add the path manually.' ...
        'Please don''t save the "localantsettings.m"-file within the ant-tbx!'};
    button = questdlg(msg,'local antsetting','OK','Cancel',opt) ;
    if strcmp(button,'Cancel')==1;  return; end
    % =========[get path via GUI]========================
    upath=userpath;
    if isempty(upath);
        upath=pwd;
    end
    upath=regexprep(upath,';','');
    udir=uigetdir(upath,'select path to store "localantsettings.m" ');
    if isnumeric(udir); return; end
    
    % ===================[write into "antx2_userdef"-folder ]============================
    if exist(fullfile(udir,'antx2_userdef'))==7
        udir=fullfile(udir,'antx2_userdef');
    end
    %% ===============================================
    f0=which('antsettings.m');
    f1=fullfile(udir, 'localantsettings.m');
    copyfile(f0,f1,'f');
    if exist(f1)~=2
        cprintf('*[1 0 1]',['could not create file "localantsettings.m"' '\n']);
        disp(['  path: ' udir]);
        disp(['  hint: check path or user-rights']);
    end
    if exist(f1)==2
        edit_file(f1);
    end
elseif exist(f1)
    edit_file(f1);
end
%% ===============================================

function edit_file(f1)

cprintf('[0 .5 0]',['you can now change the paramters in "localantsettings.m in the editor"' '\n']);
cprintf('[0 .5 0]',['..press save-button afterwards"' '\n']);
cprintf('[0 .5 0]',['..to update type: antcb(''reload'')  ' '\n']);

edit(f1);


function delete_file();

f1=find_file();
if exist(f1)==2
    
    
    
    % ==============================================
    %%   close in editor
    % ===============================================
    try
        edtSvc  = com.mathworks.mlservices.MLEditorServices;
        edtList = edtSvc.getEditorApplication.getOpenEditors.toArray;
        shortnames={};
        for i=1:length(edtList)
            shortnames{i,1} = char(edtList(i).getShortName);
        end
        ifound=find(strcmp(shortnames, 'localantsettings.m'));
        if ~isempty(ifound)
            for i=1:length(ifound)
                try;
                    edtList(ifound(i)).close
                end
            end
        end
    end
    % ==============================================
    %%   close in editor
    % ===============================================
    
    delete(f1);
    if exist(f1)==2
        cprintf('[1 0 1]',['..could not delete "localantsettings.m"\n']);
        disp(['   path: ' fileparts(f1) ]);
        disp(['   hint: restricted user-rights or file might be open?' ]);
    else
        cprintf('[0 .5 0]',['The file "localantsettings.m" was deleted!\n']);
        disp(['previous path: ' fileparts(f1) ]);
    end
else
    cprintf('[1 0 1]',['file not found: "localantsettings.m" \n']);
    disp(['  hint: first create a "localantsettings.m"-file']);
    disp(['        .. go to MENU: Extras/"local antsettings"/"create/open local ant-settings"']);
    
end

function showpath()
f1=find_file();
if isempty(f1)
     cprintf('[1 0 1]',['file not found: "localantsettings.m" \n']);
    disp(['  hint: first create a "localantsettings.m"-file']);
    disp(['        .. go to MENU: Extras/"local antsettings"/"create/open local ant-settings"']);
else
%% ===============================================
    [pax,shortname, ext]=fileparts(f1);
    shortname=[shortname, ext];
   hlpfun=f1;
   cprintf('*[0 .5 0]',['*** "localantsettings.m" ***\n']);
    cprintf('[0 .5 0]',['PATH: '  strrep(pax,filesep,[filesep filesep])  '\n']);
    disp([...
        ' [' shortname ']:'...
        ' <a href="matlab: help(''' f1 ''');">' 'help'     '</a>' ...
        ',<a href="matlab: type(''' f1 ''');">' 'disp content' '</a>' ... ...
        ',<a href="matlab: explorerpreselect(''' f1 ''');">' 'explorer' '</a>'  ...
        ',<a href="matlab: edit(''' f1 ''');">' 'edit' '</a>']);
%% ===============================================

end


function f1=find_file()
f1='';
% F:\antx2\mritools\ant
fileName='localantsettings.m';
f1=which(fileName);
%% =================[check dirs]==============================
if isempty(f1)
    %rehash path
    upath=regexprep(userpath,';','');
    checkpa={
        fullfile(upath,'antx2_userdef',fileName)
        fullfile(upath,fileName)
        };
    for i=1:length(checkpa)
        if exist(checkpa{i}) ==2
            f1=checkpa{i};
            break
        end
    end
end

function settings=getsettings()
settings=[];
f1=find_file();
if isempty(f1)
    settings=antsettings;
    settings.source=which('antsettings');
elseif exist(f1)==2
    try
        thispa=pwd;
        pa=fileparts(f1);
        cd(pa);
        settings=localantsettings;
        settings.source=which('localantsettings');
        cd(thispa);
    catch
        settings=antsettings;
        settings.source=which('antsettings');
    end
    
end





