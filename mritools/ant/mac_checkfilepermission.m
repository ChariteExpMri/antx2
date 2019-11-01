
% MAC-only: check and change file permission of elastix, transformix, MRIcroGL files
function mac_checkfilepermission

if ~ismac; return; end

%------------state-----------------

%% change Permission: mac -check permission state of elastix
permstateneeded='755';  % what we need
%permstateneeded='666'; %reset

%------------first global check-----------------
c=elastix4mac;
pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
permisall={};
[~,permisall{1}]=system(['stat -f %A ' pa_mricrongl]);
[~,permisall{2}]=system(['stat -f %A ' c.E]);
[~,permisall{3}]=system(['stat -f %A ' c.T]);

permisOK=zeros(1,length(permisall));
for i=1:length(permisall);
    permisOK(i)=~isempty(strfind(permisall{i},permstateneeded));
end

%------------check and change permission-----------------

if sum(permisOK)~=length(permisOK)
    disp(' MAC-USER !!! ');
    disp('# PERMISSION FOR SOME FILES (ELASTIX,TRANSFORMIX, MRIcroGL) NOT SET..');
    disp('if asked, please enter SUDO PASSWORD to change permission rights of above files');
    disp('..password is hidden..');
    
    %------------ELASTIX-----------------
    [~,permissoctn]=system(['stat -f %A ' c.E]);
    if isempty(strfind(permissoctn,permstateneeded))
        system(['sudo chmod ' permstateneeded ' ' c.E]);
    end
    [~,permissoctn]=system(['stat -f %A ' c.E]);
    if isempty(strfind(permissoctn,permstateneeded))==0
        disp(['..' permstateneeded '-permission for "ELASTIX" set']);
    else
        disp(['..problem with ' permstateneeded '-permission for "ELASTIX" ']);
    end
    %-------------TRANSFORMIX----------------
    
    [~,permissoctn]=system(['stat -f %A ' c.T]);
    if isempty(strfind(permissoctn,permstateneeded))
        system(['sudo chmod ' permstateneeded ' ' c.T]);
    end
    [~,permissoctn]=system(['stat -f %A ' c.T]);
    if isempty(strfind(permissoctn,permstateneeded))==0
        disp(['..' permstateneeded '-permission for "TRANSFORMIX" set']);
    else
        disp(['..problem with ' permstateneeded '-permission for "TRANSFORMIX" ']);
    end
    %-------------MRIcroGL----------------
    [~,permissoctn]=system(['stat -f %A ' c.T]);
    if isempty(strfind(permissoctn,permstateneeded))
        system(['sudo chmod ' permstateneeded ' ' c.T]);
    end
    
    %mricogl
    % pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
    [~,permissoctn]=system(['stat -f %A ' pa_mricrongl]);
    if isempty(strfind(permissoctn,permstateneeded))
        system(['sudo chmod ' permstateneeded ' ' pa_mricrongl]);
    end
    [~,permissoctn]=system(['stat -f %A ' pa_mricrongl]);
    if isempty(strfind(permissoctn,permstateneeded))==0
        disp(['..' permstateneeded '-permission for "MRIcroGL" set']);
    else
        disp(['..problem with ' permstateneeded '-permission for "MRIcroGL" ']);
    end
    
end % change permission





