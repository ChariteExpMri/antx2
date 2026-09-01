
% work with gitbash on windows system


% xbash('','shell',1);               % open shell
% xbash(char('echo e'),'shell',1)    % open shell and send comand 
%
% recursivel find in -files for word "BEGIN" in DIR: /f/data5/nogui
% xbash('grep -rn --include="*.m" "BEGIN" F:\data5\nogui')
% 
% grep -rn --include="*.m" "BEGIN" /f/data5/nogui
% 
% 
% 
% xbash('ls F:\data5\nogui | grep nii')
% xbash('find F:\data5\nogui -name "*.nii" | wc -l')
%  o=xbash('echo 1 2 3 | awk ''{print $3}''')
% xbash('seq 1 5 | awk ''{print $1*10}''')
% xbash('printf "a\nb\nc\n" | awk ''{print NR ":" $1}''')
% xbash('echo 1 2 3 | tr " " "\n" | awk ''{print $1*2}''')
% xbash('cat file.txt | awk ''{print $2,$5}''')
% 
% xbash('ls -R F:\data5\nogui | head') --???
%  xbash('echo -e "abc 123\nxyz 456" | grep "[4]"')
% xbash('find F:\data5\nogui -name "*copy*.nii" | wc -l')
% xbash('find F:\data5\nogui -name "*copy*.nii" )
% 
% xbash('grep -Rl --include="*.m" "old version"')
% xbash(['grep -Rl --include="*.m" "old version"' ' "' pwd '"'])
% xbash(['find /f/data5/nogui -type f -name "*.m" -exec grep -Hl "old version" {} +'])
%
% xbash('/f/data5/nogui/test1.sh')
% xbash('./test1.sh')
% no bc!!!
% xbash('awk "BEGIN {print 2/3}"')
% xbash('echo $(( 3 + 3 ))')
% xbash('a=19;b=21; echo $(($a+$b))')
% xbash('ping 10.32.40.152')
%
%
% xbash([
% 'base="F:\data5\nogui\raw\raw_ANNA\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1"; ' ...
% 'find "$base" -path "*/pdata/*/visu_pars" -print | while read f; do ' ...
% '  proto=$(echo "$f" | awk -F/ ''{for(i=1;i<=NF;i++) if($i=="pdata") print $(i-1)}''); ' ...
% '  rep=$(echo "$f" | awk -F/ ''{for(i=1;i<=NF;i++) if($i=="pdata") print $(i+1)}''); ' ...
% '  p=$(awk ''/VisuAcquisitionProtocol/ {getline; gsub(/[<>]/,"",$0); print; exit}'' "$f"); ' ...
% '  echo "$proto:$rep:$p"; ' ...
% 'done | sort -t: -k1,1n -k2,2n'
% ])
% %%   real:
% % 1_Localizer
% % 03_T2_TurboRARE
% % RARE
% % 07_epi_mre
% % 07_epi_mre
% % B0Map-ADJ_B0MAP
% 
% %% ===============================================
% 
% cmd=[
% 'base="F:\data5\nogui\raw\raw_ANNA\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1"; ' ...
% 'find "$base" -path "*/pdata/*/visu_pars" -print | while read f; do ' ...
% '  proto=$(echo "$f" | awk -F/ ''{for(i=1;i<=NF;i++) if($i=="pdata") print $(i-1)}''); ' ...
% '  rep=$(echo "$f" | awk -F/ ''{for(i=1;i<=NF;i++) if($i=="pdata") print $(i+1)}''); ' ...
% '  p=$(awk ''/VisuAcquisitionProtocol/ {getline; gsub(/[<>]/,"",$0); print; exit}'' "$f"); ' ...
% '  echo "$proto:$rep:$p"; ' ...
% 'done | sort -t: -k1,1n -k2,2n'
% ]
% xbash(char(cmd),'shell',1)


function [out,status] = xbash(cmd, varargin)

p = inputParser;
addParameter(p,'mode','auto');   % auto | bash | direct
addParameter(p,'out','auto');     % raw | win
addParameter(p,'shell',0);     % 0 | 1
addParameter(p,'wd',pwd);     % 0 | 1

parse(p,varargin{:});

mode    = p.Results.mode;
outMode = p.Results.out;
isShell =p.Results.shell;
wd      =p.Results.wd;

if exist('cmd')~=1; cmd=''; end

% ----------------------------------------------------
% locate Git root robustly
% ----------------------------------------------------
[~, gitexe] = system('where git.exe');
gitexe = strtrim(gitexe);
gitroot = fileparts(fileparts(gitexe));

bash   = fullfile(gitroot,'bin','bash.exe');
usrbin = fullfile(gitroot,'usr','bin');
cygpath = fullfile(usrbin,'cygpath.exe');




% ----------------------------------------------------
% AUTO mode detection
% ----------------------------------------------------
useBash = false;

if strcmp(mode,'bash')
    useBash = true;
elseif strcmp(mode,'direct')
    useBash = false;
else
    useBash = contains(cmd, {'|','>','<','&&','$','*',';','('}) || ...
        contains(cmd,'$( ') || ...
        contains(cmd,'.sh') || ~isempty(regexpi(cmd,'^\s*./')==1);
end

% ----------------------------------------------------
% OPTIONAL: convert Windows paths → MSYS paths
% (global + safe via cygpath, not regex hacks)
% ----------------------------------------------------
cmd = convert_paths_to_bash(cmd, cygpath);

if isempty(regexprep(cmd,'\s','')) || isShell==1
    %    disp('empty'); return;
    %system('start "" "C:\Program Files\Git\git-bash.exe"')
    git_bash_exe=fullfile(gitroot, 'git-bash.exe');
    if isempty(cmd) && strcmp(wd,pwd)
        system(['start "" "'  git_bash_exe '"']);
    else
        %       
        prev_dir=pwd;
        cd(wd);
        try
            %system(['start "" "'  git_bash_exe '"']);
             uwd = convert_paths_to_bash(wd,cygpath)  ;
             
            cmd = regexprep(cmd, 'awk\s+"([^"]+)"', 'awk ''$1''');
            cmd = strrep(cmd,'"','\"');
             
             
            system(['cmd /c start "" "' bash '" -lc "' [cmd '; exec bash'] '"'])
        end
        cd(prev_dir);
        

        %system('cmd /c start "" "C:\Program Files\Git\bin\bash.exe" -lc "echo hello; exec bash"')
        
        
        
        
        %         call = sprintf('"%s " -lc %s', git_bash_exe, [''  uwd])
        %         system([  call ])
        %          system(['start '  call ])
        %
        %       call = sprintf('"%s" -lc %s"', git_bash_exe, ['cd "' uwd '"']);
        %        system(['start '  call ])
        %
        %       call = sprintf('"%s" "-lc" "cd ''%s''"', git_bash_exe, uwd );
        %
        %       system([  call ])
    end
    
    return
end

% ----------------------------------------------------
% EXECUTION
% ----------------------------------------------------
if exist(fullfile(usrbin, [cmd '.exe']))==0
    
end


if useBash
    %
    
    %    call = sprintf('"%s" -lc ''%s''', bash, cmd);
    
    %    call = sprintf('"%s" -lc ''%s''', bash, cmd2);
    % call = sprintf('"%s" -lc ''%s''', bash, cmd)
    
    % call = sprintf('cmd /c ""%s" -lc "%s""', bash, cmd)
    % call = sprintf('"%s" -lc "%s"', bash, cmd);
    % call = sprintf('"%s" -lc ''%s''', bash, cmd);
    
    cmd = regexprep(cmd, 'awk\s+"([^"]+)"', 'awk ''$1''');
    cmd2 = strrep(cmd,'"','\"');
    
    call = sprintf('"%s" -lc "%s"', bash, cmd2) ;
    [status,out] = system(call);
    
    %     'a'
    
else
    [status,out] = run_direct(cmd, usrbin);
end

% ----------------------------------------------------
% cleanup
% ----------------------------------------------------
% out = regexprep(out, '[\r\n]+$', '');

if isempty(out)
    out = '';
else
    out = char(out);
    out = regexprep(out, '[\r\n]+$', '');
end

% ----------------------------------------------------
% OPTIONAL: convert output back to Windows paths
% ----------------------------------------------------
if strcmp(outMode,'auto') && ispc==1
    outMode='win';
end


if strcmp(outMode,'win')
    out = convert_paths_to_win(out, cygpath,bash);
end

end

% ====================================================
% DIRECT EXECUTION
% ====================================================
function [out,status] = run_direct(cmd, usrbin)
cmd = strtrim(cmd);
% IMPORTANT FIX: safer tokenization
tokens = regexp(cmd, '\s+', 'split');
exe = tokens{1};
if numel(tokens) > 1
    args = strjoin(tokens(2:end),' ');
else
    args = '';
end

% if exist(fullfile(usrbin, [exe '.exe']))~=0
%
% %     xbatch(cmd)
%
%     return
% end
%


exePath = fullfile(usrbin, [exe '.exe']);

if exist(exePath,'file')
    if isempty(args)
        fullCmd = sprintf('"%s"', exePath);
    else
        fullCmd = sprintf('"%s" %s', exePath, args);
    end
else
    % fallback to system PATH
    if isempty(args)
        fullCmd = exe;
    else
        fullCmd = sprintf('%s %s', exe, args);
    end
end

[out,status] = system(fullCmd);

end

% ====================================================
% WINDOWS → BASH PATH (GLOBAL SAFE)
% ====================================================
% function cmd = convert_paths_to_bash(cmd, cygpath)
%
% % match Windows paths like C:\..., D:\..., F:\...
% expr = '([A-Za-z]:\\[^\s""]*)';
%
% cmd = regexprep(cmd, expr, @(m) win2bash(m{1}, cygpath));
%
% end
%

function p = win2bash(p, cygpath)
cmd = sprintf('"%s" "%s"', cygpath, p);
[~,p] = system(cmd);
p = strtrim(p);
end

function cmd = convert_paths_to_bash(cmd, cygpath)
expr = '([A-Za-z]:\\[^\s""]*)';
tokens = regexp(cmd, expr, 'match');
for i = 1:numel(tokens)
    winPath = tokens{i};
    bashPath = win2bash(winPath, cygpath);
    cmd = strrep(cmd, winPath, bashPath);
end
end

% ====================================================
% BASH → WINDOWS PATH (OPTIONAL)
% ====================================================
% function out = convert_paths_to_win(out, cygpath)
%
% expr = '(/[a-z]/[^\s]*)';
%
% out = regexprep(out, expr, @(m) bash2win(m{1}, cygpath));
%
% end

% function out = convert_paths_to_win(out, cygpath)
% if isempty(out)
%     return
% end
% out = char(out);
% expr = '(/[a-z]/[^\s]*)';
% tokens = regexp(out, expr, 'match');
% for i = 1:numel(tokens)
%     bashPath = tokens{i};
%     winPath = bash2win(bashPath, cygpath);
%     out = strrep(out, bashPath, winPath);
% end
% end

function out = convert_paths_to_win(out, cygpath,bash)

if isempty(out)
    return
end

out = char(out);

% ----------------------------------------------------
% 1. Handle full MSYS paths (/c/something)
% ----------------------------------------------------
expr1 = '(/[a-z]/[^\s]*)';
% tokens1 = regexp(out, expr1, 'match');
% for i = 1:numel(tokens1)
%     bashPath = tokens1{i};
%     winPath = bash2win(bashPath, cygpath);
%     out = strrep(out, bashPath, winPath);
% end

tokens1 = regexp(out, expr1, 'match');
if ~isempty(tokens1)
    uniquePaths = unique(tokens1);
    %     winPaths = bash2win(uniquePaths, cygpath);
    winPaths = bash2win(uniquePaths, cygpath, bash);
    for i = 1:numel(uniquePaths)
        out = strrep(out, uniquePaths{i}, winPaths{i});
    end
end

% ----------------------------------------------------
% 2. Handle DRIVE ROOTS (/c -> C:\)
% ----------------------------------------------------
expr2 = '^/([a-z])$';

tokens2 = regexp(out, expr2, 'tokens');

for i = 1:numel(tokens2)
    drive = tokens2{i}{1};
    winPath = [upper(drive) ':\'];
    out = regexprep(out, ['^/' drive '$'], winPath);
end

end


% function p = bash2win(p, cygpath)
% cmd = sprintf('"%s" -w "%s"', cygpath, p);
% [~,p] = system(cmd);
% p = strtrim(p);
% end

% function out = bash2win(paths, cygpath)
% if isempty(paths)
%     out = paths;
%     return
% end
% if ischar(paths)
%     paths = {paths};
% end
% % build batch command
% cmd = sprintf('"%s" -w %s', cygpath, strjoin(paths, ' '));
% [~,out] = system(cmd);
% out = strsplit(strtrim(out), newline);
% end

% function winPaths = bash2win(paths, cygpath)
function winPaths = bash2win(paths, cygpath, bash)

if length(paths)==1
    
    cmd = sprintf('"%s" -w "%s"', cygpath, paths{1});
    
else
    
    if isempty(paths)
        winPaths = paths;
        return
    end
    if ischar(paths)
        paths = {paths};
    end
    % ---- write temp file ----
    tmp = tempname;
    fid = fopen(tmp,'w');
    for i = 1:numel(paths)
        fprintf(fid,'%s\n', paths{i});
    end
    fclose(fid);
    % ---- batch conversion ----
    % cmd = sprintf('"%s" -w < "%s"', cygpath, tmp);
    % cmd = sprintf( '"%s" -lc "xargs -a ''%s'' cygpath -w"', bash, tmp);
    cmd = sprintf('"%s" -lc "xargs -a ''%s'' cygpath -w"', bash, tmp);
end

[~,raw] = system(cmd);
winPaths = strsplit(strtrim(raw), newline);


try; delete(tmp);end

end
