%% preselect file in explorer (win,mac,linux)
%% example:
% w= 'O:\harms1\harms3_lesionfill\dat\s20150910_FK_C3M14_1_4_1\x_masklesion.nii'
% explorerpreselect(w)
%% example using hyperlink:
%% to run this, copy&paste from explorerpreselect file directly 
%% w= 'O:\harms1\harms3_lesionfill\dat\s20150910_FK_C3M14_1_4_1\x_masklesion.nii'
%% disp([' image: <a href="matlab: explorerpreselect(''' w ''')">' w '</a>']);
%
% EXAMPLE
% explorerpreselect('mean.m')
% explorerpreselect(which('mean.m'))
% explorerpreselect(fullfile(pwd,'_sample2.nii'))

function explorerpreselect(fi)

[pas fis ext]=fileparts(fi);
if isempty(pas)
    fi=which([fis ext]);
end

if ispc
    system(['explorer.exe /select,"' fi '"']);
elseif ismac
    system(['open "' fi '"' ' -R']);
else
%     system(['nautilus "' fi '"' ' &']);
system(['xdg-open "' fileparts(fi) '"' ' &']);
end
