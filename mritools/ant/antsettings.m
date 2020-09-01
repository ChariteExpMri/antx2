%% #b parameter-settings of [ANT]  (not the function for studiy-project-settings!!)
% #r  be carefull with any modifications here!
% #by CHANGEABLE PARAMETERS 
% settings.show_instant_help      :  show menubar-help on the fly [0,1]
% settings.show_intro             :  show intro [0,1],  ..if [1] intro is shown only when
%                                    ANT is started for the first time 
% 
% #by NOTE
% in some cases [ANT] needs to be updated to execute soome parameter settings :
% to restart-->  type   - ant              - to just load the [ANT]-GUI
%                    or - antcb('reload')  - to re-load the study-project
%                    and previous selected mouse-folders or use shortcut ctrl+r 
%                    to reload project
%               
% 
% #by RESTART IS only NECESSARY FOR CAHNGES OF THE FOLLOWING PARAMETERS:  -none-
% 

function varargout=antsettings

%====================================
%%   MODIFY HERE
%====================================

settings.show_instant_help        =  0          ;%[0,1] displays on-the-fly-function's help
settings.show_intro               =  0          ;%[0,1] shows intro upon ANT-start
settings.show_HTMLprogressReport  =  1          ;%[0,1] shows HTML progress for init./coregistration/segementation/warping



fontsize_PC            =  9           ;%fontsize ANT-GUI..OSdependent
fontsize_MAC           = 12           ;
fontsize_UNIX          = 9            ;



%====================================
%% do not modify 
%====================================

if ispc
    settings.fontsize = fontsize_PC;
elseif ismac
    settings.fontsize = fontsize_MAC;
elseif isunix
    settings.fontsize = fontsize_UNIX;
end

varargout{1}=settings;





