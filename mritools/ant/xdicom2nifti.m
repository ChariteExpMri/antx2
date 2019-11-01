

%% #wg function to convert dicoms to nifti
%% this function uses mricron (CT-problem..)
% -runs without an open ANTX-project
% #wo RUN
%  xdicom2nifti or xdicom2nifti(1) to run with gui without parameters
%  xdicom2nifti(1,z)  run with parmameters
%  xdicom2nifti(1,[],'I:\Oelschlegel\antx_ct\');% USING predefined path
%
% #wo HISTORY
%  after running type anth or char(anth) or uhelp(anth) to get the parameter
%
% ______________________________________________________________________________
% #wo EXAMPLE
%% example1 : convert all dicoms specified in z.dirs, converted niftis obtain the prefix 't2_' (z.prefix)
%% i.e. will not be renamed (z.name). Niftis will be written in z.outdirMain within the folder that is named
%% after the the lowest dicom-folder-name (z.outdirName)
%     z=[];
%     z.dirs       = { 'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_075M_wt'        % % input DICOM folders
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_076M_wt'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_077M_wt'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_078M_tg'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_079M_tg'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_080M_wt'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_081M_tg'
%         'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_083M_tg' };
%     z.name       = { '' };                                                                % % output NIFTI name
%     z.prefix     = { 't2_' };                                                             % % adds a prefxx to the output NIFTI name
%     z.outdirMain = 'I:\Oelschlegel\antx_ct\out';                                          % % output MAIN folder
%     z.outdirName = '@1 - Dicom-Dir name';                                                 % % output subject folder,
%     xdicom2nifti(1,z);                                                                    % % run function with GUI,
    


function xdicom2nifti(showgui,x,pa)


if 0
    
%     example 1 predefine path
%     xdicom2nifti(1,[],'I:\Oelschlegel\antx_ct\');
    
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xdicom2nifti.m]
    % % #b info :              converting dicom2nifti
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.dirs       = { 'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_075M_wt'        % % input DICOM folders
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_076M_wt'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_077M_wt'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_078M_tg'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_079M_tg'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_080M_wt'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_081M_tg'
        'I:\Oelschlegel\antx_ct\MRs_Bruker_original\Max_SP18_083M_tg' };
    z.name       = { '' };                                                                % % output NIFTI name
    z.prefix     = { 't2_' };                                                             % % adds a prefxx to the output NIFTI name
    z.outdirMain = 'I:\Oelschlegel\antx_ct\out';                                          % % output MAIN folder
    z.outdirName = '@1 - Dicom-Dir name';                                                 % % output subject folder,
    xdicom2nifti(1,z);
    
    
    
    
end


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=[]  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• dicom2nifit using MRICRON   •••             '                         '' ''
    'dirs'      {''}                'input DICOM folders'   {@selectDir,pa}
    'name'      {''}                'output NIFTI name'    ''
    'prefix'    {''}                'adds a prefxx to the output NIFTI name'    ''
    'outdirMain'    {''}                'output MAIN folder'   {@selectoutdirMain,pa}
    'outdirName'    {''}                'output subject folder, '   {'@1 - Dicom-Dir name','@2 - 2nd. upper Directory of Dicom-Dir','@3 - 3rd. upper Directory of Dicom-Dir'}
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .3 ],...
        'title','***dicom2nifti***','info',{@uhelp,[ mfilename '.m']});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

xmakebatch(z,p, mfilename);
process(z);


function out=selectoutdirMain(pa)
out='';

[v v2]=paramgui('getdata');
if ~isempty( (char(v2.dirs)))
    px=fileparts(v2.dirs{1});
else
    if isempty(pa)
        px=pwd;
    else
        px=char(pa);
    end
end
out=uigetdir(px, 'Pick a Directory for output');

function out=selectDir(pa)
out='';

% return
if isempty(pa)
    px=pwd;
else
    px=char(pa);
end
% px='I:\Oelschlegel\antx_ct\MRs_Bruker_original';
[t,sts] = spm_select(inf,'dir','select folders with dicoms','', px,'.*','');
if isempty(t);out=''; return; end

t=cellstr(t);
% for i=1:length(t)
%     [pa fi ext]=fileparts(t{i});
%     t{i}=pa;
% end
out=t;
return
% paramgui('setdata','x.dirs',t)





%=========================================================================

function process(z)

warning off;
% keyboard
pacron=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron');
exec=fullfile(pacron,'dcm2nii.exe');

if ischar(z.dirs);          z.dirs=cellstr(z.dirs); end
if iscell(z.outdirMain);    z.outdirMain=char(z.outdirMain); end
if iscell(z.name);           z.name=char(z.name); end
if iscell(z.prefix);        z.prefix=char(z.prefix); end


if exist(z.outdirMain)~=7;     mkdir(z.outdirMain); end

for j=1:length(z.dirs)
    padc=z.dirs{j};
    
    str=[exec ' -g n -o '''  padc  ''' ' '"' padc  '"'  ];
    [st mes]=system(str);
    mes=strsplit(mes,char(10))';
    
    ix=regexpi2(mes,'SAVING');
    li=mes(ix,:); 
    li=regexprep(li,'Saving ',''); %list of generated niftis
    
    
    % for each nifti
    for i=1:size(li,1)
        [pa fi ext]=fileparts(li{i});
        
        %newdir=z.outdirMain;
        if ~isempty(regexpi(z.outdirName,'@1'))
              [p0 mdir]=fileparts(padc);
        elseif  ~isempty(regexpi(z.outdirName,'@2'))
               [p0 ~]=fileparts(padc);
                [p0 mdir]=fileparts(p0);
        elseif  ~isempty(regexpi(z.outdirName,'@3'))
              [p0 ~]=fileparts(padc);
              [p0 ~]=fileparts(p0);
              [p0 mdir]=fileparts(p0);
        end
        newdir  =fullfile(z.outdirMain,mdir); 
        
        %% more files generated
        numtag='';
        if size(li,1)>1
            numtag=pnum(i,3);
        end
        
        if ~isempty(z.name)
           outfile=[z.prefix z.name   numtag     ext ] ;
        else
           outfile=[z.prefix fi      numtag ext]   ;
        end
       newfile=fullfile(newdir,outfile);
        
        
        warning off;
        mkdir(newdir);
        movefile(li{i},  newfile  ,'f'); 
        
        disp([' nifti: <a href="matlab: explorerpreselect(''' newfile ''')">' newfile '</a>']);
        
            
    end
  
end



























