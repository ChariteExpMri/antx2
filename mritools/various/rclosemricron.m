% close all mricron windows (win,mac,linux)
function rclosemricron

try
    if ispc
        evalc('!TASKKILL /F /IM mricron.exe /T');
        evalc('!TASKKILL /F /IM MRIcroGL.exe /T');
    elseif ismac
        evalc('!killall MRIcroGL &');
    else
        evalc('!pkill mricron &');
        evalc('!pkill MRIcroGL &');
    end
end