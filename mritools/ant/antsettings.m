%% #b parameter-settings of [ANTx2]  
% ----------------------------
% #ga CHANGEABLE PARAMETERS
% ----------------------------
% settings.show_intro               =  0          ;%[0,1] shows intro when ANT-gui is started
% settings.show_HTMLprogressReport  =  0          ;%[0,1] shows HTML progress for init./coregistration/segementation/warping
% settings.show_instant_help        =  0          ;%[0,1] displays help when hovering over menu-items
% settings.enable_menutooltips      =  0          ;%[0,1] enable tooltips when hovering over ANT-menu
% 
% fontsize_PC                       =  9          ;%fontsize ANT-GUI..OS-dependent for pc
% fontsize_MAC                      = 12          ;%fontsize ANT-GUI..OS-dependent for mac
% fontsize_UNIX                     = 9           ;%fontsize ANT-GUI..OS-dependent for unix
% 
% 
% ----------------------------
%% #ma NOTE
% ----------------------------
% in some cases [ANT] needs to be updated to execute soome parameter settings :
% to restart-->  type   - ant              - to just load the [ANT]-GUI
%                    or - antcb('reload')  - to re-load the study-project
%                    and previous selected mouse-folders or use shortcut ctrl+r 
%                    to reload project
%               
% ====================================================================================

function varargout=antsettings
settings=struct();
%====================================
%%   MODIFY HERE
%====================================
settings.show_intro               =  0          ;%[0,1] shows intro when ANT-gui is started
% settings.show_HTMLprogressReport  =  0          ;%[0,1] shows HTML progress for init./coregistration/segementation/warping
settings.show_instant_help        =  0          ;%[0,1] displays help when hovering over menu-items
settings.enable_menutooltips      =  0          ;%[0,1] enable tooltips when hovering over ANT-menu


fontsize_PC                       =  9          ;%fontsize ANT-GUI..OS-dependent for pc
fontsize_MAC                      = 12          ;%fontsize ANT-GUI..OS-dependent for mac
fontsize_UNIX                     = 9           ;%fontsize ANT-GUI..OS-dependent for unix













%==================================================================================================
%% do not modify 
%==================================================================================================

if ispc
    settings.fontsize = fontsize_PC;
elseif ismac
    settings.fontsize = fontsize_MAC;
elseif isunix
    settings.fontsize = fontsize_UNIX;
end

varargout{1}=settings;





