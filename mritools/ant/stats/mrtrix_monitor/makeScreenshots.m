
function makeScreenshots(varargin)

% makeScreenshots
% makeScreenshots('overwrite',0)
% makeScreenshots('overwrite',1)
%% ===============================================

p.overwrite=0;
if ~isempty(varargin)
   pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end



%% =====[study-path on 'x' ]==========================================
v=update_monitor();
pastudy       = v.pastudy;% fullfile(fileparts(fileparts(pwd)));
pain          = fullfile(pastudy, 'data');                       
[~,studyname] = fileparts(pastudy);
%% =====[linux-path ]==========================================
% pa_lnx_main = '/mnt/sc-project-agtiermrt/Daten-2/Imaging/Paul_DTI' ;
% pa_lnx_data = [pa_lnx_main '/' studyname '/' 'data'];

pa_lnx_data=strrep([v.HPCtargetdirUnix '/' 'data'],'/sc-projects/sc-proj-agtiermrt/' ,'/mnt/sc-project-agtiermrt/');

%% ======[credentials]=========================================
p.host   = 's-mfz-csb-cpu02'   ;%LINUX-server.charite.de'
p.uname  = 'expmrtuser'        ;%
p.pw     = 'spintop'           ; 
%% ===============================================
% cmd='ls'
% o = ssh2_simple_command(p.host,p.uname,p.pw,cmd)
% if 0
%     cmd={['cd' pa_lnx_data];
%         '#ls ./../shellscripts'
%         '#./../shellscripts/qa_otherMachine.sh'
%         './../shellscripts/qa_otherMachine.sh 1 a027'}
%     % cmd=strjoin(cmd,';')
%     cmd=strjoin(cmd,char(10))
%     
%     o = ssh2_simple_command(p.host,p.uname,p.pw,cmd)
% end



%% ==============================================
%%   [create/write/send & chmod shellscript]
%% ==============================================




g={'#!/bin/bash'
    [['cd ' pa_lnx_data]]
    'rm done.txt; #delete "done"-file'
    ''
    '#./../shellscripts/qa_otherMachine.sh 1 a027'
    ['./../shellscripts/qa_otherMachine.sh ' num2str(p.overwrite)]
    ''
    'echo DONE!'
    'cd /home/expmrtuser'
    'touch done.txt #writ txt-file to know that job is finished'
    'echo DONE2!'};

batchName      ='make_screenshots.sh';
batchfilename  = fullfile(pwd,batchName);
[batchPath]    = fileparts(batchfilename);

%write shellscript
pwrite2file(batchfilename,g);
% send shell-script to linux-workspace
msg = sftp_simple_put(p.host,p.uname,p.pw,batchName,'',batchPath);
% CHMOD script
cmd = ['chmod 777 ' batchName];
o   = ssh2_simple_command(p.host,p.uname,p.pw,cmd);

%% ==============================================
%%   run mobaXterm, open specific session & run shellscript
%% ==============================================

% s=['"C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe" ' ...
%     '-bookmark "s-mfz-csb-cpu02 (screenshots)'];

s=['"D:\software\MobaXterm_Portable_v25.3\MobaXterm_Personal_25.3.exe" ' ...
    '-bookmark "s-mfz-csb-cpu02 (screenshots)'];
system(s);

% ==============================================
%%   next step: find mobaxterm in systemPath
% ===============================================

if 0
    %% ===============================================
    %% recursively search for mobaxterm
    tic
    disp(['..recursively search for mobaxterm'])
    % cmd = 'powershell -command "Get-ChildItem C:\,D:\ -Filter ''*MobaXterm*.exe'' -Recurse -EA SilentlyContinue | Select-Object -ExpandProperty FullName"';
    
    cmd = 'powershell -command "Get-ChildItem C:\,D:\ -Filter ''*MobaZZZterm*.exe'' -Recurse -EA SilentlyContinue | Select-Object -ExpandProperty FullName"';
    [status, result] = system(cmd);
    if isempty(result)
        msgbox('"MobaXterm*.exe not found in drive C:\ or D:\"..process terminated') ;
        return
    end
    % ===============================================
    result=strsplit(result,char(10))';
    result(cellfun(@isempty,result))=[];
    disp(result)
    
    toc
    
    %% ===============================================
end

%% ===============================================
%%   busy mode--> while.. check if "done.txt"-exists
%% ===============================================
cprintf('*[0 0 1]',[ '..BUSY: creating screenshots! '  '\n']);
o={};
while isempty(find(strcmp(o,'done.txt')))
    o= ssh2_simple_command(p.host,p.uname,p.pw,'ls');
end

% ==============================================
%%  remove 'done.txt'-file 
% ===============================================
o= ssh2_simple_command(p.host,p.uname,p.pw,'rm done.txt');

% ==============================================
%%   clear content of bashscript "make_screenshots.sh"
% ===============================================
g2={'#!/bin/bash'
    ''
    };
%write shellscript
pwrite2file(batchfilename,g2);
% send shell-script to linux-workspace
msg = sftp_simple_put(p.host,p.uname,p.pw,batchName,'',batchPath);

%delete loeal shellscript
try; delete(batchfilename); end


cprintf('*[0 .5 0]',[ 'Done! '  '\n']);