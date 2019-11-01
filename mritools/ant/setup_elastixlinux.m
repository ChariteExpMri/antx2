% setup_elastixlinux.m -   SETUP ELASTIX AND MRICRON in LINUX
function setup_elastixlinux()


%% SETUP ELASTIX AND MRICRON in LINUX
% ====================================
clc;
disp('===========================================');
disp('  SETUP ELASTIX AND MRICRON in LINUX       ');
disp('===========================================');

disp('# The installation of ELASTIX requires admin-rights.' );
disp('  A sudo password is required to copy all necessary elastix-files ');
disp('  and to change the file''s  permissen rights');
disp('# The installation of MRICRON requires an internet connection');
disp('  and will take a couple of minutes');


inp=input('DO YOU WANT TO CONTINUE [y,n]: ' ,'s');
inp=num2str(inp);
if isempty(regexpi(inp, 'y'))
   disp('..canceled..' ) ; return
end
disp('..continuing..' );

%=======================================================

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

[r r2]=system('sudo apt install mricron');
if r~=0
    disp('### 2/2: MRICRON setup failed!                ¯\_(ツ)_/¯ ');
else
    disp('### 2/2 :MRICRON setup successful !!!!         (•‿•)');
end

%% open erorr
% system('xdg-open /media/psf/AllFiles/Volumes/O/data5/an2_KDEtest_Matlab18/dat/dat/m09/coreg2.jpg')


disp([' ..elapsed time: ' secs2hms(toc)]);
disp('DONE');




