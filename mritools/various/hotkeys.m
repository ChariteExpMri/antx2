function hotkeys
%% start autohotkeys hotkeys
%help: cmd- (cmd & minus)

w=strrep(which('hotkeys.m'),'.m','.ahk');
eval(['!start ' w ]);
% !start hotkeys.ahk
disp(' hotkeys....type:  cmd[-] for help');