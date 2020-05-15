
% elastix_checkinstallation: check installation of elastix-program
% this function checks whether ELASTIX is properly installed. Specifically it checks whether a 
% message is returned which states 'Use "elastix --help" for information about elastix-usage.'
% if this messag is returned it is assumed that elastix works properly

function elastix_checkinstallation(moreinfo)

help elastix_checkinstallation;



% ==============================================
%%   check elastix
% ===============================================
% clc;
if ispc
    elastix = which('elastix.exe');
    [h h2]=system(elastix);
elseif ismac
    % MAC
    pa0=pwd;
    ela=elastix4mac;
    elastix=ela.E;
    [pa fi]=fileparts(elastix);
    cd(pa);
    [h h2]=system([ './' fi]);
    cd(pa0);
    
    %     ela=elastix4mac;
    %     elastix=ela.E;
    %     [h h2]=system([ './' elastix])
else
    %LINUX
    [h h2]=system('elastix');
    %arg=evalc('!elastix');
    %     if regexpi2(cellstr(h2),' "elastix --help" for information') ~=1
    %         disp('ELASTIX FOR LINUX NOT FOUND/INSTALLED');
    %         disp('INSTALL ELASTIX FOR LINUX');
    %         disp('see: https://www.youtube.com/watch?v=spo6UA3PFsU');
    %         disp('1) in terminal type: sudo apt-get install elastix');
    %         disp('- if this does not work, type: ');
    %         disp('   1a) type: sudo dpkg --configure -a');
    %         disp('   1b) type: sudo apt-get install elastix');
    %         disp('2) check: type: elastix --help  ');
    %         error('ELASTIX FOR LINUX ..elastix not installed ');
    %     end
    %     elastix='elastix';
end

if exist('moreinfo')==1
    printmessage(h2,1);
    
else
    printmessage(h2,0);
end


function printmessage(h2,force2print)

if isempty(strfind(h2, 'elastix --help" for information')) || force2print==1
    
    
    
    
    % ==============================================
    %%   message
    % ===============================================
    if isempty(strfind(h2, 'elastix --help" for information'))
        cprintf([1 0 1],['============================================================ ','\n']);
        cprintf([1 0 1],['ELASTIX NOT PROPERLY INSTALLED' '\n']);
        cprintf([1 0 1],['============================================================ ','\n']);
    else
        cprintf([0 .5 0],['============================================================ ','\n']);
        cprintf([0 .5 0],['ELASTIX SEEM TO BE PROPERLY INSTALLED' '\n']);
        cprintf([0 .5 0],['============================================================ ','\n']);
    end
    
    
    cprintf([0 0 1],['expected output message      : ' ]);
    cprintf([0 0 0],['Use "elastix --help" for information about elastix-usage.' '\n']);
    cprintf([0 0 1],['but current output message is: ' ]);
    cprintf([0 0 0],[h2 '\n']);
    cprintf([0 0 1],[' please inspect deviations in output message\n' ]);
    cprintf([0 0 1],[' see also whether some files are missing\n' ]);
    
    
    disp('ADDITIONAL INFORMATION:');
    
    cprintf([1 0 1],['...','\n']);
    cprintf([1 0 1],['============================================================ ','\n']);
    cprintf([1 0 1],['WINDOOWS SYSTEM ','\n']);
    cprintf([1 0 1],['============================================================ ','\n']);
    disp('[1] Problem we had with window-server after installing MATLAB-19b' );
    disp('Note that the problem might also occur with previous MATLAB versions (v17 and v18).');
    disp('In this case try the same to solve the problem.');
    disp('Problem description: elastix does not start using matlabv19b.. Missing dlls');
    disp('reason: missing file(s) such as "VCOMP100.DLL"');
    disp('Solution: most likely some c++ dlls are missing');
    disp('Inspect and google the missing files');
    disp('see: https://www.youtube.com/watch?v=PuJnlnsuOfE');
    disp('Link: https://www.youtube.com/redirect?redir_token=4AlV-JzkvKDajriZNtgCy8dBqNh8MTU3ODQ4NDAzM0AxNTc4Mzk3NjMz&q=https%3A%2F%2Fwww.microsoft.com%2Fen-us%2Fdownload%2Fdetails.aspx%3Fid%3D14632&event=video_description&v=PuJnlnsuOfE');
    disp('other solutions, see here:');
    disp('Download and install: vcredist_x64.exe');
    disp('https://www.microsoft.com/en-us/download/details.aspx?id=14632');
    disp('--');
    disp('### FASTEST WAY TO CHECK WHETHER ELASTICS WORKS (indirect mode) ###');
    disp('type: system([which(''elastix.exe'')])  in Matlab command window');
    disp('The expected output message shoud be: "Use "elastix --help" for information about elastix-usage." ');
    disp('If you see this output masssge than ELASTIXS most likely works');
    
    
    
    cprintf([1 0 1],['============================================================ ','\n']);
    cprintf([1 0 1],['UNIX SYSTEMS ','\n']);
    cprintf([1 0 1],['============================================================ ','\n']);
    disp('ELASTIX FOR LINUX NOT FOUND/INSTALLED');
    disp('SOLUTION: INSTALL ELASTIX FOR LINUX');
    disp('run: setup_elastixlinux from command line' );
    disp('--other potential solutions ---')
    disp('see: https://www.youtube.com/watch?v=spo6UA3PFsU');
    disp('1) in terminal type: sudo apt-get install elastix');
    disp('- if this does not work, type: ');
    disp('   1a) type: sudo dpkg --configure -a');
    disp('   1b) type: sudo apt-get install elastix');
    disp('2) check: type: elastix --help  ');
    
    disp('### FASTEST WAY TO CHECK WHETHER ELASTICS WORKS (indirect mode) ###');
    disp('type: system(''elastix'')  in Matlab command window');
    disp('The expected output message shoud be: "Use "elastix --help" for information about elastix-usage." ');
    disp('If you see this output masssge than ELASTIXS most likely works');
    
else
    
    cprintf([0 .5 0],['ELASTIX most likely works.','\n']);
    disp('see <a href="matlab: elastix_checkinstallation(1)">more information</a>!');
end








