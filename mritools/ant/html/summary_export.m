
%export HTML-summary (ini/coreg/segm/warp) structure to exporting folder
% can be used for documentation...zip & send per email
% 
%USAGE
% summary_export,  % studypath determined using using global an (otherwise pwd) and exportdir via gui
% summary_export( studypath)
%   where studypath; is a current study path (this path contains 'dat' and 'template' folder)
%  export-directory determined via window
% summary_export( studypath ,exportdir)
%   exportdir is also defined: destination folder for export of summary
% examples
% summary_export()
% summary_export('F:\data1\oelschlaegel_warpProblem')
% summary_export('F:\data1\oelschlaegel_warpProblem','F:\data1\oelschlaegel_warpProblem\export5')


function summary_export( studypath ,exportdir)

if exist('studypath')==0; studypath=[];end
if exist('exportdir'  )==0; exportdir  =[];end

% ant-line 180



% ==============================================
%%   studypath 
% ===============================================
if isempty(studypath)
    global an;
    if isfield(an,'datpath')
        studypath=fileparts(an.datpath);
    else
        studypath=pwd;
    end
end
% ==============================================
%%    get export path
% ===============================================
warning off

if isempty(exportdir)
    testpath=0;
    if testpath==1
        exportdir=fullfile(pwd,'export2');
    else
        ps=uigetdir(pwd,'select destination folder to export HTML-summary' );
        if isnumeric(ps) && ps==0
            disp('..cancelled: no destination folder selected to export HTML-summary') ;
            return
        else
            exportdir=ps;
        end
    end
end
mkdir(exportdir);

% ==============================================
%%   export summary
% ===============================================

w=struct();
w.pa_index   =studypath;

k=dir(fullfile(studypath,'dat'));
k([k.isdir]~=1)=[]; %rem files
k(strcmp({k(:).name}',{'.'}))=[];
k(strcmp({k(:).name}',{'..'}))=[];

w.pa_animals = stradd({k(:).name}', [w.pa_index,filesep,'dat',filesep],1);

% w.pa_animals =cellstr(antcb('getallsubjects'));
w.pa_dat=fullfile(fullfile(w.pa_index),'dat');
w.pa_export = exportdir;

%copy INDEX.html
fS1=fullfile(w.pa_index,'summary.html');
fT1=fullfile(w.pa_export,'summary.html');
if exist(fS1)~=2
    error([fS1 ' .. does not exist']);
end
copyfile(fS1,fT1,'f');
%Exporting summary subdir for each animal
cprintf([0 .5 0], [  '..Exporting summaries of animals (n=' num2str(length(w.pa_animals)) ') \n'    ]);


for j=1:length(w.pa_animals)
    fS=fullfile(w.pa_animals{j},'summary');
    [~,mdir]=fileparts(w.pa_animals{j});
    fT=fullfile(w.pa_export,'dat',mdir ,'summary');
    try
        mkdir(fT); % linux needs this
        copyfile(fS,fT,'f');
        cprintf([0 .5 0], [ '  .. [' num2str(j) ']' mdir '\n']);
    catch
        cprintf([1 .5 0], [ '  .. [' num2str(j) ']' mdir ' - failed, check existence/unlocked files/dirs !\n']);
    end
end

% return
disp(['new exported folder: ' w.pa_export]);
showinfo2('exported summary', fT1);

