% setup_elastixlinux.m -   SETUP ELASTIX AND MRICRON in LINUX
% If this function fails please install elstix/mricron manually via linus terminal
%
% ==============================================
%%   manual installytion, (if this function fails)
% ===============================================
% (1) ### ELASTIX  ####
% (1.1) copy files
% from folder .../antx2/mritools/elastix/elastix_linux64_v4.7/bin
% copy  'elastix'      to local folder: /usr/bin/
% copy  'transformix'  to local folder: /usr/bin/
% from folder .../antx2/mritools/elastix/elastix_linux64_v4.7/bin
% copy  'libANNlib.so' to local folder: /usr/lib/
% (1.2) set changing file permission rights in terminal
% sudo chmod 777 /usr/bin/elastix
% sudo chmod 777 /usr/bin/transformix
% sudo chmod 777 /usr/lib/libANNlib.so
% (2) ### MRICRON  ####
% in terminal type: sudo apt install mricron
% follow intructions
% ===============================================


function setup_elastixlinux()
clc;
disp(['running function: ' mfilename]);
help setup_elastixlinux

%% SETUP ELASTIX AND MRICRON in LINUX
% ====================================




disp('===========================================');
disp('  SETUP ELASTIX AND MRICRON in LINUX       ');
disp('===========================================');

disp('# The installation of ELASTIX requires admin-rights.' );
disp('  A sudo password is required to copy all necessary elastix-files ');
disp('  and to change the file''s  permissen rights');
disp('# The installation of MRICRON requires an internet connection');
disp('  and will take a couple of minutes');




% ==============================================
%%   yes/no-gui
% ===============================================
msglnx=['Elastix was not found on system path                                      ' char(10) ...
    'INSTALL ELASTIX OR LINUX NOW? ' char(10) ...
    '..Note, this step is mandatory..' char(10)...
    '--------------------------------------------------' char(10) ...
    'The installation of ELASTIX requires admin-rights.' char(10) ...
     '  A sudo password is required to copy all necessary elastix-files.!' char(10) ...
     'The installation of MRICRON requires an internet connection' char(10)...
     '  and will take a couple of minutes.' char(10)...
    ];
button = questdlg(msglnx,'ELASTIX for LINUX','install now','Cancel','str3');

if strcmp(button,'Cancel') || isempty(button)
    disp('..Elastix not installed...installation cancelled...'); return; end



% inp=input('DO YOU WANT TO CONTINUE [y,n]: ' ,'s');
% inp=num2str(inp);
% if isempty(regexpi(inp, 'y'))
%    disp('..canceled..' ) ; return
% end
disp('..continuing..' );

%=======================================================
%% STEPS
tic;
disp('. ');
disp('.. ');
disp('... ');
disp('===================================');
disp('  STEP-1/2: SETUP ELASTIX          ');
disp('===================================');





%% =========================================================
pbin='/usr/bin/';
plib='/usr/lib/';

p0=fullfile(fileparts(fileparts(which('ant.m'))),'elastix','elastix_linux64_v4.7');

f1=fullfile(p0,'bin','elastix');       %SOURCE
f2=fullfile(p0,'bin','transformix');
f3=fullfile(p0,'lib','libANNlib.so');

t1=fullfile(pbin,'elastix');          %TARGET
t2=fullfile(pbin,'transformix');
t3=fullfile(plib,'libANNlib.so');


%% =========================================================
disp('..copying ELASTIX files..');
system(['sudo cp "' f1 '"' ' "' t1 '"' ]);
system(['sudo cp "' f2 '"' ' "' t2 '"' ]);
system(['sudo cp "' f3 '"' ' "' t3 '"' ]);

disp('..wait..');

% disp(['=== PERSMISSION STATUS OF ELASIX FILES ====']);
% [r r2]=system(['stat -c "permission: %n: %a" "' t1 '"']); disp(char(cellstr(r2)));
% [r r2]=system(['stat -c "permission: %n: %a" "' t2 '"']); disp(char(cellstr(r2)));
% [r r2]=system(['stat -c "permission: %n: %a" "' t3 '"']); disp(char(cellstr(r2)));
%% =========================================================
disp('..changing file permissions..');
system(['sudo chmod 777 "' t1 '"']);
system(['sudo chmod 777 "' t2 '"']);
system(['sudo chmod 777 "' t3 '"']);


disp(['=== FINAL PERSMISSION STATUS OF ELASIX FILES ====']);
[r r2]=system(['stat -c "permission: %n: %a" "' t1 '"']); disp(char(cellstr(r2)));
[r r2]=system(['stat -c "permission: %n: %a" "' t2 '"']); disp(char(cellstr(r2)));
[r r2]=system(['stat -c "permission: %n: %a" "' t3 '"']); disp(char(cellstr(r2)));

%% =========================================================
%% CHECK
[r r2]=system('elastix'); 
if r~=0
    disp('### 1/2: ELASTIX setup failed!                ¯\_(ツ)_/¯ ');
    disp([ ' ...' char(cellstr(r2))]);
else
    disp('### 1/2 :ELASTIX setup successful !!!!         (•‿•)');
    disp([ ' ...' char(cellstr(r2))]);
end

%%

%% =========================================================
%% MRICRON
%% =========================================================
disp('===================================');
disp('  STEP-2/2: MRICRON INSTALLATION   ');
disp('===================================');
disp('..please wait this will take some minutes..');

eval('!sudo apt install mricron'); % used this because "system" command fails (due to userInput)
[r r2]=system('sudo apt install mricron');% this ist just to check if installation was succesfull
if r~=0
    disp('### 2/2: MRICRON setup failed!                ¯\_(ツ)_/¯ ');
else
    disp('### 2/2 :MRICRON setup successful !!!!         (•‿•)');
end

%% open erorr
% system('xdg-open /media/psf/AllFiles/Volumes/O/data5/an2_KDEtest_Matlab18/dat/dat/m09/coreg2.jpg')


disp([' ..elapsed time: ' secs2hms(toc)]);
disp('DONE');




