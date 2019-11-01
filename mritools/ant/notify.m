function notify

pax=fileparts(which([mfilename '.m']));
[y, Fs] = audioread(fullfile(pax,'notify.wav'));
soundsc(y,Fs);