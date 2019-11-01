%%   SMALL VOLUME CORRECTION- SETTINGS
% ===============================================================
%%  FOLDER DEFINITION FOR MASKS <CHANGE THIS!!>
% - only one active folder possible
% - if maskpath is not defined (i.e the maskpath is commented, svc use the
%   current directory (pwd))
% - uncomment non-used folders
% ===============================================================
 

maskpath=  'E:\svc_loop\masks'    ;  %
%   maskpath='c:\'
 %  maskpath=  'C:\Dokumente und Einstellungen\skoch\Desktop\codes\tpm\results'  ;

% maskpath='w:\ddd'


% ===============================================================
% defaults 
% ===============================================================
mask_selectall            = 0  ;  %[1]all mask will be selected (green cross)  or not [0] at startup
report_firstclusterOnly   = 1  ;  %[1]report only first cluster  of a mask;[0] report all clusters  
appendResults             = 1  ;  %[1]append SVR results if 'RUN'-button is pressed again (preserve output)