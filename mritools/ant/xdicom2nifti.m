

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
    
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xdicom2nifti.m]
    % % #b info :              converting dicom2nifti
    % % ������������������������������������������������������
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


%�����������������������������������������������
%%   PARAMS
%�����������������������������������������������
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=[]  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%����������������������������������������������������������������������������������������������������
%%  PARAMETER-gui
%����������������������������������������������������������������������������������������������������
if exist('x')~=1;        x=[]; end

outdirconstrlist={...
    '@0   -use all upper Dirs (default, same as empty) for DirName'
    '@1   -use Dicom-Dir for DirName',
    '@2   -use 2nd. (upper) Directory of Dicom-Dir for DirName'
    '@3   -use 3rd. (upper) Directory of Dicom-Dir for DirName'
    '@4   -use 4th. (upper) Directory of Dicom-Dir for DirName'
    '@1-2 -use lowest two directories for DirName (Dicom-Dir + 2nd. Directory)'
    '@1-3 -use lowest three directories for DirName (Dicom-Dir + 2nd + 3rd Directories)'
    '@1-4 -use lowest four directories for DirName (Dicom-Dir + 2nd + 3rd + 4th upper Directories)'
    };
p={...
    'inf1'      '��� dicom2nifit using MRICRON   ���             '                         '' ''
    'dirs'             {''}     'Input DICOM folders. Select main dicom folder or several dicom folders'   {@selectDir,pa}
    'name'             {''}     'output NIFTI filename. If empty, use name generated from dicom-fields'    ''
    'prefix'           {''}     'adds a prefix to the output NIFTI-filename'    ''
    'outdirMain'       {''}     'output MAIN folder. Niftis will be saved to this location.'   {@selectoutdirMain,pa}
    'outdirName'      outdirconstrlist{1}   'Constructor for animal folder name. If empty, folder name is constructed from all upper folders (prefered). '   outdirconstrlist
    'flatHierarchy'   [1]      '[1] Make flat sub-folder hierarchy (prefered); [0] no, keep nested folders' {'b'}
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

% ==============================================
%%   explicitely find all dicoms
% ===============================================
sourcedir ={};
keepsubdir={};
temppath2save={};

for j=1:length(z.dirs)
    [files,dirs2] = spm_select('FPListRec',z.dirs{j},'');
    dirs2=cellstr(dirs2);
    
    for i=1:length(dirs2)
        [fis] = spm_select('FPList',dirs2{i},'.*');
        fis=cellstr(fis);
        fis=fis(find(cellfun('isempty',(strfind(fis, [filesep '.']))))); %remove filsep-dot object (hidden file)
        fis=char(fis);
        if ~isempty(fis) && length(cellstr(fis))>3
            fis=cellstr(fis);
            isdcm=0;
            dcmnum=0;
            idx=1;
            while dcmnum<3  ;%isdcm==0
                try
                    s=dicominfo(fis{idx});
                    if isfield(s,'Filename')
                        isdcm=1;
                        dcmnum=dcmnum+1;
                        
                        if dcmnum==3 % at least 3dicoms
                            sourcedir(end+1,1)=dirs2(i);  % sourceDIR
                            
                            pax=fileparts(z.dirs{j}); %
                            dum=strrep(dirs2(i),[pax filesep],'');
                            dum=regexprep([dum],{'\s+' },{'' });
                            dum=regexprep([dum '* @'],'^[\w-]+\.[\w]+$',''); %illegal CHars
                            keepsubdir(end+1,1)    =dum(1);
                            temppath2save(end+1,1) =z.dirs(j);
                        end
                    end
                end
                idx=idx+1;
                %disp(['idx=' num2str(idx) ';dcmnum=' num2str(dcmnum) ]);
            end
        end
    end
end






% ==============================================
%%   new
% ===============================================
for j=1:length(sourcedir)
    padc    =sourcedir{j}     ;%z.dirs{j};
    temppath=temppath2save{j} ;%z.dirs{j};
    
    str=[exec ' -g n -o '''  temppath  ''' ' '"' padc  '"'  ];
    [st mes]=system(str);
    mes=strsplit(mes,char(10))';
    
    ix=regexpi2(mes,'SAVING');
    li=mes(ix,:);
    li=regexprep(li,'Saving ',''); %list of generated niftis
    
    outdir=keepsubdir{j};
    % for each nifti
    for i=1:size(li,1)
        [pa fi ext]=fileparts(li{i});
        
        %% get subfolder-structire
        paseq=strsplit(outdir,filesep);
        str= regexprep(z.outdirName,{'-use.*' '@'},{'' ''});
        if isempty(str)
            isub=0;
        else
            eval(['isub=' str ';']);
        end
        
        
        if isempty(isub) || isub==0  %entiry subfolder
            mdir=paseq;
        else
            paseqflip=fliplr(paseq);
            mdir=fliplr(paseqflip(isub));
        end
        mdir=strjoin(mdir,filesep);
         
%         %newdir=z.outdirMain;
%         if ~isempty(regexpi(z.outdirName,'@1'))
%             mdir=paseq{end};
%         elseif  ~isempty(regexpi(z.outdirName,'@2'))
%             mdir=paseq{end-1};
%         elseif  ~isempty(regexpi(z.outdirName,'@3'))
%            mdir=paseq{end-2};
%         else
%            mdir=outdir; 
%         end
        
       %newdir  = fullfile(z.outdirMain,mdir)
       % folder_name gets subDirName
       if z.flatHierarchy==1
           newdir  = fullfile(z.outdirMain,regexprep([mdir],{filesep},{ '_'}));
       else
            newdir  = fullfile(z.outdirMain,mdir);
       end
        
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








% ==============================================
%%   old
% ===============================================
if 0
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
end


























