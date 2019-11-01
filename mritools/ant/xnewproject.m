

%% create a new Project for a study
% #yg GUI-NOTE
% for some parameters exist #r "interactive selectors" #w (this selectors appear on the very left side of the parameter as icon)
%       to use the "interactive selectors" move coursor to the line of the parameter, if an "interactive selectors" exists
%        for this parameter, click it or use [f1]  and follow the instructions
%
% #yg PARAMETERS
% #r MANDATORY SPECIFICATIONS:
% specify the projectName:  [x.project]  : this is an arbitray project-name  (example "studyXY")
% specify the data-path  :  [x.datpath]  : this is an existing fullpath-name , the terminal folder-name must be "dat", e.g. "c:\b\study1\dat"
% specifiy thex voxelsize:  [x.voxsize]  : this is the x,y,z-voxel-resolution  (default is [.07 .07 .07])
% 
% #b Problem: to work with external data drives on different machines the drive-letter may change
% #b Solution: if there are no explicit changes with respect to the templates and Elastix-parameter-files,
% #b           than delete all path-"pointers" (delete, x.wa.refTPM,x.wa.ano ... x.wa.elxParamfile)
% #b           -->note: missing parameters will be filled with the defaults
% 
% #b if there are no further changes, and you accept the defaults (besides of [x.project,x.datpath,x.voxsize]): 
% #b           than you can delete all stuff below  the x.voxsize -parameter
% #b           -->note: missing parameters will be filled with the defaults
%
% #yg  SAVE PROJECTFILE
% -(as m-file): hit [ok]  --> it is recommended to save the project-file on the upper level of the "dat"-folder
%    example: studyfolder is "c:\b\study1"  
%               thus: datafolder must be  "c:\b\study1\dat" 
%                     projectfile can be  "c:\b\study1\projectXY.m" 
% #yg  LOAD PROJECT
%   if the projectfile is created, you can decide to immediately to load the projectfile 


function xnewproject


%% make new project
[m z]=antconfig(1,'parameter','default','savecb','no');

if isempty(m) && isempty(z); return; end


pat=z.datpath;
[pa fi ext]=fileparts(pat);
if strcmp(fi,'dat')~=1;
    errordlg('"datpath" folder must terminate to a folder namd "dat", such as "c:\study-1\dat" ','File Error');
    return
end

%% make dir and UI for projectName
if exist(pat)==0
    mkdir(pat);
end
[fi pa]=uiputfile('*.m','save configfile (example "project_study1")' ,fullfile(fileparts(pat),'proj.m'));


if pa~=0
    pwrite2file(fullfile(pa,fi),m);
end

try;
    %explorer(pa) ;
%     disp(['open folder with new project <a href="matlab: explorer('' ' pa '  '')">' pa '</a>']);% show h<perlink
     disp(['open folder with new project <a href="matlab: ' systemopen(fullfile(pwd,'t2.nii'),1)  '">' pa '</a>']);% show h<perlink
end



%% questDLG
dlgTitle    = '';
dlgQuestion = ['load the new project: ' fullfile(pa,fi) ' now' ];
choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');

if strcmp(choice,'Yes')
    cd(pa)
    ant; antcb('load',fullfile(pa,fi)) ;
end



