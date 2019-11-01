




% open file/path with default application in win,mac or unix, 2nd-arg defines wether to parse code
% as output argument only
% function str=systemopen(file,parsestringonly)
%USAGE:
% str=systemopen(file)                   ; % open file/path with default OS-application
% str=systemopen(file,parsestringonly)   ; % parsestringonly [0,1] to parse code only
%% —————————————————————————————————————————————————————————————————————————————————————————————————

function str=systemopen(file,parsestringonly)


if exist('parsestringonly')
    if isnumeric(parsestringonly)
        parsestringonly=parsestringonly;
    else
        parsestringonly=0;
    end
else
 parsestringonly=0;   
end

% file='https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM'
% ms=[ '"' file '"' ]

ms=[ file ];

if ispc
    
    ms2=[ 'start' ' ' ms];
elseif ismac
    ms2=[ 'open' ' ' ms];
elseif isunix
    ms2=[ 'xdg-open' ' ' ms];
end

ms3=['system([''' ms2  ''']);'];
% clipboard('copy', ms3)

if parsestringonly==0
    evalc(ms3);
end
str=ms3;


% m='system('' start https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM'');';
% m='system('' start https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM'');';