% close all mricron windows (win,mac,linux)
function rclosemricron

try
    if ispc
        evalc('!TASKKILL /F /IM mricron.exe /T');
    elseif ismac
        evalc('!killall MRIcroGL &');
    else
        evalc('!pkill mricron &');
    end
end