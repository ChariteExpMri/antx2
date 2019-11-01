
function labsinstall(task)
% LABS installer/updater of newer version
% to install type labsinstall
% to deinstall and remove labs type "labsinstall(2)"

if exist('task')==0
    task=1;
else
    task=task;
end


% task
if task==1 %INSTALL


     
    warning off;
    close all; clear all;
    clear global;

 %%UNZIP   
%     pathLABS=strrep(which(mfilename),[mfilename '.m'] ,[ 'labs.zip']);
%     pathLABS2=strrep(pathLABS ,[ 'labs.zip'],[  'labs']) ;
%     try; rmdir(pathLABS2,'s' ); end %try delete folder
%     unzip(pathLABS);
%     disp('...unpacking LABS');

pathLABS2=strrep(which(mfilename),[mfilename '.m'] ,'');


    if exist(pathLABS2)~=7
        error('could not find unzipped folder "labs"');
        return
    end

    pathSPM=strrep(which('spm'),'spm.m',[  'toolbox' filesep]);
    if exist(pathSPM)~=7
        error('could not find SPM in matlab path');
        return
    end

if ~isempty(strfind(pathLABS2,pathSPM))
   disp('LABS is already installed...') ;
   disp('..to install a newer version, execute "labsinstall" from the folder with the newer version');
      return
end


    target=fullfile(pathSPM,'labs');
    try; rmdir(target,'s' ); end %try delete folder LABS in  SPM
    try ;           rmpath(target)  ;    end
    
    copyfile(pathLABS2,target);
    disp(['...copy folder LABS to "'  target  '"']);
    
    addpath(target);
    setpath;
    disp(['...set matlab path to "'  target  '"']);
    disp('••• labs succesfully installed •••');

    disp('    NOTE: to deinstall and remove labs type "labsinstall(2)"  ');
    

% % % %     try; rmdir(pathLABS2,'s' ); end %try delete folder labsunpacked

elseif task ==2 %UNINSTALL

    
    if 1
        warning off;
        close all; clear all;
        clear global;

        pathSPM=strrep(which('spm'),'spm.m',[  'toolbox' filesep]);
        target=fullfile(pathSPM,'labs');
        try; rmdir(target,'s' ); end %try delete folder LABS in  SPM
        try ;           rmpath(target)  ;    end
        
        disp('••• labs succesfully de-installed and removed •••');
    end

    
%       pathSPM=strrep(which('spm'),'spm.m',[  'toolbox' filesep]);
%     
%     klabs=which('labs','-all' )
%     if ischar(klabs); klabs={klabs};end
%     for i=1:length(klabs)
%         fold=strrep(klabs{i},[filesep 'labs.m'],'')
%          rmpath(fold);
%         try; rmdir(fold,'s' ); end %try delete folder
%     end
%     
    
 

end


















