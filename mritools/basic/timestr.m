
% get formated current time , used as filePrefix
% function str=timestr

function str=timestr(sep)
if exist('sep')==1
 str=regexprep(datestr(now),{'-' ' ' ':'},{'' '_' ,'-'})  ; %with - between HH:MM:SS
else
str=regexprep(datestr(now),{'-' ' ' ':'},{'' '_' ,''});
end
