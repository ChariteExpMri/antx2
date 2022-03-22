%% #b convert brukerData to nifti-data
%
%% function xbruker2nifti(pain,sequence,trmb)
%% INPUT
% pain  : bruker-Metafolder, this folder contains all mouseFolder (! do not specify  a specific
%         mouseFolder here),
%        OPTIONS for pain  :
%            bruker_metapath        % this is the Bruker-Raw-metafolder <no GUI>
%            []                     % opens a dialog box, the starting folder is the current Dir
%            {'guidir' start_path } % opens a dialog box with the starting folder specified by start_path
%  sequence: which sequence to read  (number, string or empty)
%           [0] all sequences, [1] RARE,  [2] FLASH,  [3] FISP
%           other sequence can be coded as string, (n.b. sequence= 'RARE' is equal to sequence=1)
%                    (case sensitivity (lower/opper letters) is ignored)
%           []        % read all data
%  trmb: filesize lower threshold in mbyte-->ignore files with lower filesize
%            []      : trmb is set to 1 (=0Mb,predefined)
%% examples
% xbruker2nifti;                                                % all inputs provided by guis
% xbruker2nifti( 'O:\harms1\harmsTest_ANT\pvraw', 'Rare' )      % METAFOLDER is explicitly defined, read Rare, trmb is 1Mb
% xbruker2nifti({'guidir' 'O:\harms1\harmsTest_ANT\'}, 'Rare' ) % startfolder for GUI is defined,  read Rare, trmb is 1Mb
%
%% NO GUI (silent mode)
% [1] import all Bruker-rawdata from path fullfile(pwd,'raw_Ernst'), no gui (silent mode)
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'gui',0);


function xbruker2nifti(pain,sequence,trmb,x,varargin)

if exist('pain')==0
    global an
    pain={'guidir' fileparts(an.datpath)};
    sequence=0
end
%% =========Pairwise inputs======================================
p0.gui=1; % [0,1] show guis
if nargin>4
   pin= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p0=catstruct2(p0,pin);
end
%% ===============================================

fprintf('...reading Bruker-data...');

warning off;
format compact;
if 0
    pain='O:\harms1\harmsStaircaseTrial\pvraw'
    pain={'guidir'  'O:\harms1\harmsTest_ANT'}  %PRESELECT PATH for GUI-->this is not the definitive Brukerpath
    
    sequence=1;  % sequence: 0: all sequences,   1:RARE,     , 2:FLASH,  3:FISP,  other sequence coded as string
    trmb     = 1 %lower Mbyte threshold  to skeep datasets for fast recursive file/methods-search [in MB!]
end
%==============================================================================
%% missing inputs
% using defaults
gui1     =0;
prefdir =pwd;  %preDIR for GUI

if    ~exist('pain','var') || isempty(pain)   ||              ( iscell(pain) && strcmp(pain{1},'guidir')    )
    gui1=1;
    try
        if    ( iscell(pain) && strcmp(pain{1},'guidir')    )  %get rough preDIR for GUI
            prefdir=pain{2};
        end
    end
end


if gui1==1
    %     pain=uigetdir2(pwd,'select META-mousePath');
    %    prefdir='c:\'
    msg={'BRUKER-IMPORT',...
        'select the "main"-BRUKER Folder [such as "raw"-dir] that contains the import data'...
        'Note: this folder must contain a folder for each mouse',...
        'alternatively, select one or more mouse folders',...
        '    -use upper fields and lower left panel to navigate',...
        '    -select the "main"-BRUKER Folder or one/several mouse folders from the right panel',...
        '    >>folders in the lower panels will be processed..',...
        '  press [Done]'};
    [pain,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir);
    pain=char(pain);
    
    
    
    if isempty(pain); return; end
    
    ret=ones(size(pain,1),1)
    for i=1:size(pain,1)
        if isdir(pain(i,:))==0
            ret(i)=0
        end
    end
    if ~isempty(find(ret==0))
        if isdir(pain)==0; return;end
    end
    
    
end

if ~exist('paout','var') || isempty(paout)
    global an
    %paout=fullfile(fileparts(pain),'dat');
    paout=an.datpath;
    disp(['META-outfolder: ' paout]);
end

if ~exist('sequence','var') || isempty(sequence)
    sequence=1;
end

if ~exist('trmb','var') || isempty(trmb)
    trmb=0;
end

if size(pain,1)>1
    pain=char(regexprep(cellstr(pain),[filesep filesep '$'],''))
    if strcmp(pain(end),filesep)==1 %remove ending filesep
        pain(end)=[];
    end
end

%==============================================================================
if size(pain,1)>1
    pain0=cellstr(pain)
    files={}; dirs={};
    for i=1:size(pain0,1)
        [files0,dirs0] = spm_select('FPListRec',pain0{i},'^2dseq$');
      files0=cellstr(files0);
      dirs0 =cellstr(dirs0);
      
      
        files=[files; files0];
        dirs =[dirs; dirs0];
    end
else
    [files,dirs] = spm_select('FPListRec',pain,'^2dseq$');
    files=cellstr(files);
    dirs=cellstr(dirs);
end

% sequence: 0: all sequences,   1:RARE,     , 2:FLASH,  3:FISP,  other sequence coded as string
if        sequence==0              sequence='';    %all
elseif sequence==1;             sequence='RARE';
elseif sequence==2      sequence='FLASH';
elseif sequence==3       sequence='FISP';
end

if 0
    try
        %     Stack  = dbstack;
        disp('######## tester: first 30 trials');
        %     disp(['remove this in LINE: ' num2str(Stack.line)]);
        disp(['remove this in LINE: ' num2str(100)]);
        files=files(1:100);
    end
end
%==============================================================================
%% skipp files below Mbyte-threshold (trmb)
for i=1:size(files,1);     k(i)=dir(files{i});end
mbytes=cell2mat({k(:).bytes}')/1e6;
daterec={k(:).date}';

del=find(mbytes<trmb);
mbytes(del)         =[];
files(del)             =[];
daterec(del)       =[];

%==============================================================================
%% get sequence

% seq=cell(length(files),1);
disp('*** READ IN BRUKER DATA ***     ....            ');
disp('....');
tic

ikeep=[];
num=1;
for i=1:length(files)
    [pa fi]=fileparts(files{i});
    pa2=pa(1:strfind(pa,'pdata')-1);
    
    
    S = sprintf('read file %d',i);
    fprintf(repmat('\b',1,numel(S)));
    fprintf(S);
    drawnow;
    
    %     if i==4
    %        keyboard
    %     end
    
    
    try
        %get ExperimentNumber and RECO-Number
        slash   =strfind(pa,filesep);
        expNrA  =pa(slash(end-2)+1:slash(end-1)-1);
        recoNrA =pa(slash(end)+1:end);
        %disp(pa);
        
        
        methodfile=fullfile(pa2,'method');
        
        me=preadfile2(methodfile);
        me2=me{regexpi2(me,'\$Method')};
        
        
        seqA=[num2str(num) '_'  me2];
        visuxA      = readBrukerParamFile(fullfile(pa,'visu_pars'));
        try;         protocolA   = visuxA.VisuAcquisitionProtocol;
        catch;       protocolA   = 'nan';
        end
        
        
        %---------------------
        seq{num,1}      = seqA; %sequence
        visux{num}      = visuxA;%visu-struct
        meth{num}       =me; %methodfile
        protocol{num,1} = protocolA;%protocol-name
        recoNr{num,1} = recoNrA;%recontructionNumber (subfolder after pdata)
        expNr{num,1} = expNrA  ;%ExperimentNumber   (subfolder before pdata)
        
        
        num=num+1;
        ikeep(end+1,1)=i;
        
    end
    % O:\data\brukerImport2\20151126_162717_20151126_TF_LT16_1_1\2\pdata\1
    
    
    
    %     disp([i num]);
    if mod(i,10)==0
        fclose('all');
    end
end
%==============================================================================
%% add parrams
addparanames={
    'VisuSubjectId'
    'VisuStudyNumber'
    'VisuExperimentNumber'
    'VisuProcessingNumber'
    %
    'VisuStudyId'
    'VisuSubjectName'
    'VisuCoreDim'
    };
addparanamesShort=regexprep(addparanames,'^Visu',''); % shortParametername for listbox

addpara=[];
for i=1:length(visux)
    for j=1:length(addparanames);
        try
            dum=getfield(visux{i}, addparanames{j});
            try
                dum=num2str(dum);
            end
        catch
            dum='x';
        end
        addpara{i,j}=dum;
    end
end

%% replace ExpNumber from Path if empty in visu-file
icol  =regexpi2(addparanames,'VisuExperimentNumber');
iempty=regexpi2(addpara(:,icol),'x');
addpara(iempty,icol) =expNr(iempty);

%% replace RecoNumber/ProcessingNumber from Path if empty in visu-file
icol  =regexpi2(addparanames,'VisuProcessingNumber');
iempty=regexpi2(addpara(:,icol),'x');
addpara(iempty,icol) =recoNr(iempty);

% %% add also these parameters
% addpara          =[recoNr    addpara ];
% addparanamesShort=['recoNo' ;addparanamesShort];

addparanamesShort=regexprep(addparanamesShort,'^Study',     'Stud'); % shortParametername for listbox
addparanamesShort=regexprep(addparanamesShort,'^Experiment','Exp'); % shortParametername for listbox
addparanamesShort=regexprep(addparanamesShort,'^Processing','Prc'); % shortParametername for listbox
addparanamesShort=regexprep(addparanamesShort,'Number',     'No'); % shortParametername for listbox


%==============================================================================
%%keep parameters
mbytes = mbytes(ikeep)   ;
files  = files(ikeep)   ;
daterec=daterec(ikeep) ;


%prune seqstring
[dum seq]=strtok(seq,'=');
seq=regexprep(seq,{'=' '<' '>' 'Bruker:' ' '},'');

if ~isempty(sequence)
    id= regexpi2(seq,sequence);
    files           =files(id);
    mbytes      =mbytes(id);
    seq             =seq(id);
    daterec     =daterec(id);
    
    protocol   =protocol(id);
end

%==============================================================================
%% selectionGUI
% tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq];
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');

% tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq protocol];
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence, protocol');

% tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq protocol];
tb=[files cellstr(num2str(mbytes)) daterec seq protocol];

tbhead={'file' 'sizeMB' 'date' 'MRseq' 'protocol'};

if size(tb,1)~=size(addpara,1)
    addpara=addpara(id,:);
end
d =[tb addpara];
dh=[tbhead addparanamesShort(:)'];

%rearange-database for display
is=[ [6] [7 8 9   ] [4 5]     [2 3 1] [ 10 11 12 ] ];
d=d(:,is);
dh=dh(:,is);

% if 1 %% full parameterview
%     id=selector2(d,dh);
% end

%________________________________________________

cc1=['us=get(gcf,''userdata'');'...
    'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,10};'...
    'explorer(fileparts(fname));'  ];
cc2=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'          'fname=us.raw{va,10};'...
    'tx=preadfile(strrep(fname,''2dseq'',''visu_pars''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg VISU_PARS ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc3=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'          'fname=us.raw{va,10};'...
    'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''method''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg METHOD ''}; tx.all  ], 1);  set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc4=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'          'fname=us.raw{va,10};'...
    'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''acqp''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg ACQP ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc5=['us=get(gcf,''userdata'');'...
    'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,10};'...
    'montage2(fname);'  ];


cm={'open folder  [1].[].shortcut', cc1
    'show VISU_PARS [2] ', cc2
    'show METHOD [3]', cc3
    'show ACQP  [4]', cc4
    'show VOLUME  [5]', cc5};
if p0.gui==1 %with open gui otherwise import all files
    id=selector2(d,dh,'iswait',1,'contextmenu',cm,'finder',1);
    if isempty(id); return; end
else
    id=[1:size(d,1)]';
end

files=files(id);
seq  =seq{id};
visux=visux{id};
meth=meth{id};
protocol=protocol(id);
dx=d(id,:);


%==============================================================================
%%  PARAMETER-gui
%==============================================================================
if exist('x')~=1;        x=[]; end
% % % showgui=1
p={...
    'inf97'      [repmat('=',[1,100])]                           '' ''
    'inf98'       '              *** BrukerIMPORT  ***              '                        ,'' ''
    'inf99'       ' -define names of output-dirs and imported filenames '                    ,'' ''
    'inf991'      ' -the suffixes for ExperimentNumber (ExpNo_Dir/ExpNo_File) and ProcessingNumber (PrcNo_Dir/PrcNo_File)   will critically determine the existence & location of a generated file ','' ''
    'inf992'      '  CRITICAL-1: if both ExpNo_Dir/ExpNo_File are not specified and the same protocol is used multiple times [ RUNS] in the same mouse (=same SubjectId) ... ', '' ''
    'inf993'      '       .. than the resulting file is overwritten by subsequent runs of the experiment (e.g.: three subsequent MPRAGE-runs --> [..1\pdata\1\2dseq, 2\pdata\1\2dseq, 3\pdata\1\2dseq] ->result: only ONE file generated due to the missing ExperimentNumber-tag in the folder-/filename-->not good!!!!)','' ''
    'inf994'      '    SOLUTION:  (1) if there is only one RUNS/EXPERIMENTNUMBER for the same protocol: ExpNo_Dir/ExpNo_File is not necessary   ','' ''
    'inf995'      '    SOLUTION:  (2) if there are multiple RUNS/EXPERIMENTNUMBERS for the same protocol: either ExpNo_Dir/ExpNo_File is necessary   ','' ''
    'inf996'      '  CRITICAL-2: if both PrcNo_Dir/PrcNo_File are not specified and different [RECONSTRUCTIONS] (i.e. processings) of the same protocol exist for this mouse (=SubjectId), ... ','' ''
    'inf997'      '       .. the the resulting file is overwritten by subsequent reconstructions (e.g: three processingNumbers in experimentNumber-4 [..4\pdata\1\2dseq, 4\pdata\2\2dseq, 4\pdata\3\2dseq]  ->result: only ONE file generated due to the missing ProcessingNumber-tag in the folder-/filename-->not good!!!!) ','' ''
    'inf998'      '    SOLUTION:  (1) if there is only one RECONSTRUCTION for the same protocol: PrcNo_Dir/PrcNo_File is not necessary   ','' ''
    'inf999'      '    SOLUTION:  (2) if there are multiple RECONSTRUCTIONS for the same protocol: either PrcNo_Dir or PrcNo_File is necessary   ','' ''
    %
    %'inf100'      [repmat('=',[1,50])]                           '' ''
    %
    'inf101'      [repmat('=',[1,100])]                                    ''  ''
    'inf1'      '  [1] SUFFIXES of MOUSE DIRECTORY NAME (added to "SubjectId")         '                                    ''  ''
    'inf102'      [repmat('=',[1,100])]                                    ''  ''
    'StudNo_Dir'        0        'VisuStudyNumber (bool)'  'b'
    'ExpNo_Dir'         0        'VisuExperimentNumber (parent folder of "pdata"),(bool)'  'b'
    'PrcNo_Dir'         0        'VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata"),(bool)'  'b'
    %
    'inf103'      '% arrangement of suffixes       '                                    ''  ''
    'delimiter'     '_'        'delimiter between suffixes (cell); e.g: "s20141009_01sr_121" vs "s20141009_01sr_1_2_1" '  {'' '_' }
    'suffixLetter'  0          'add first letter of suffix variable name prior to variable value (bool); e.g: "s20141009_01sr_s1e2p1" vs "s20141009_01sr_1_2_1" '  'b'
    %
    %
    'inf200'      [repmat('=',[1,100])]                                    ''  ''
    'inf22'      ' [2] SUFFIXES of FILENAMES  (added to "protocoll-name")        '                                    ''  ''
    'inf201'      [repmat('=',[1,100])]                                    ''  ''
    'ExpNo_File'     0        'VisuExperimentNumber (parent folder of "pdata"),(bool)'  'b'
    'PrcNo_File'     1        'VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata"),(bool)'  'b'
    'renameFiles'   ''   'rename files   -->via GUI'  {@renamefiles,protocol,[]}
    %
    'inf300'      [repmat('=',[1,100])]                                    ''  ''
    'inf32'      '  [3] ADDITIONAL OPTIONS       '                                    ''  ''
    'inf301'      [repmat('=',[1,100])]               ''  ''
    'origin'       'brukerOrigin'        'define center(origin) of volume'  {'brukerOrigin' 'volumeCenter'}
    };

if p0.gui==1
    showgui=1;
else
   showgui=0; 
end

p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .6 ],...
        'title','BrukerImport');
else
    z=param2struct(p);
end
 fn=fieldnames(z);
z=rmfield(z,fn(regexpi2(fn,'^inf\d')));

%==============================================================================
%% RENAME AFTER PROTOCOL
%==============================================================================
% keyboard


% if z.renamefiles==1
%
%     f = fg; set(gcf,'menubar','none');
%     t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .85], 'Data', tbrename,'tag','table');
%     t.ColumnName = {'Protocol name                                            ', '(optional) rename coresponding file to..                         '};
%     t.ColumnEditable = [false true ];
%     t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
%
%     tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],'string','OPTIONAL: RENAME FILES (..otherwise protocol name is used)','fontweight','bold','backgroundcolor','w');
%     pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
%         'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile
%
%
%     h={' #yg  ***RENAME FILES USING PROTOCOL AS IDENTIFIER ***'} ;
%     h{end+1,1}=[' #### **NOTE*** THIS STEP IS OPTIONAL' ];
%     h{end+1,1}=['The 1st column represents the Protocol-name from MRI aquisition (readout from Bruker data ) '];
%     h{end+1,1}=['The 2nd column can ( ### optional! ##### ) be used to rename the protocol-related volumes '];
%     h{end+1,1}=[' which will be imported '];
%     h{end+1,1}=[' if cells in the 2nd column are empty, the import function uses the protocol name '];
%     h{end+1,1}=[' from the 1st column'];
%     %    uhelp(h,1);
%     %    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);
%
%     setappdata(gcf,'phelp',h);
%
%     pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
%         'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);'          );%@renameFile
%     % set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
%     drawnow;
%     waitfor(f, 'userdata');
%     % disp('geht weiter');
%     tbrename=get(f,'userdata');
% %     disp(tbrename);
%     close(f);
% end

tbrename=repmat(unique(protocol(:)),[1 2]);
if ~isempty(z.renameFiles) && ~isempty(char(z.renameFiles));
    tbrename   =z.renameFiles;
    unchanged =setdiff(unique(protocol), tbrename(:,1));
    rest    =[ [unchanged] unchanged];
    tbrename=[tbrename; rest];
end
tbrename(:,2)=regexprep(tbrename(:,2),{'[\s&$%,\\.;:()[]{}<>"!?=/}@#+*]'},{''});%PRUNE




%==============================================================================
%% BRUKER IMPORT
warning off;
mkdir(paout);

%% loop trhoug all 2dseq-files

if showgui==1
    h = waitbar(0,'Please wait...');
end
for i=1:size(files,1)
    
    try
        
        brukerfile=files{i};
        [pa fi]=fileparts(brukerfile);
        if showgui==1
            waitbar(i/size(files,1),h,[' convert2nifti:  ' num2str(i) '/' num2str(size(files,1)) ]);
        end
        %%===============================================
        %% MAKE DIRS AND FILENAMES
        %%===============================================
        
        %% MAKE MOUSE-FOLDER-name  [mfold outdir]
        delimiter=z.delimiter;
        mfold='';
        mfold=[mfold  dx{i, strcmp( dh,    'SubjectId'  )}];
        
        if z.StudNo_Dir==1;
            if z.suffixLetter==1  ; let='s'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'StudNo'  )}] ;
        end
        if z.ExpNo_Dir==1;
            if z.suffixLetter==1  ; let='e'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'ExpNo'  )}] ;
        end
        if z.PrcNo_Dir==1;
            if z.suffixLetter==1  ; let='p'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'PrcNo'  )}] ;
        end
        
        %delete specialChars in mfolder-name
        mfold=    regexprep(mfold,{'[\s&$%,\\.;:()[]{}<>"!?=/}@#+*]'},{''});
        
        % make MOUSEFOLDR-FOLDER  and FP-filename
        outdir=fullfile(paout,mfold);%% make DIR
        mkdir(outdir);
        
        %==============================================================================
        %% MAKE FILENAME  [fname fpname]
        idrename=find(strcmp(tbrename(:,1),protocol{i}));
        fname=[ tbrename{idrename,2}];
        if z.ExpNo_File==1;
            if z.suffixLetter==1  ; let='e'; else ;let=''; end
            fname=[fname delimiter let dx{i, strcmp( dh,    'ExpNo'  )}]   ;
        end
        if z.PrcNo_File==1;
            if z.suffixLetter==1  ; let='p'; else ;let=''; end
            fname=[fname delimiter let dx{i, strcmp( dh,    'PrcNo'  )}]   ;
        end
        fname=[fname '.nii'];
        
        % FULLPATH-FILENAME
        fpname=fullfile(outdir, fname );
        %disp([pnum(i,4) '] create <a href="matlab: explorer('' ' outdir '  '')">' fpname '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(files{i}) '  '')">' files{i}  '</a>']);% show h<perlink
        
        %==============================================================================
        %%===============================================
        %%   EXTRACT DTA
        %%===============================================
        [ni bh  da]=getbruker(brukerfile);
        
        % BUG -first 2Dims are mixed
        if ndims(ni.d)==3
            dimdiff=size(ni.d)-ni.hd.dim ;
            if dimdiff(1)~=0 && dimdiff(2)~=0  && dimdiff(3)==0 %first 2Dims are mixed
                ni.hd.dim=ni.hd.dim([2 1 3]);
            end
        end
        
        %     %nachtrag
        %     if 1
        %       vecm=  spm_imatrix(ni.hd.mat)
        %         ni.hd.mat=[[diag(vecm(7:9)); 0 0 0] [  vecm(1:3) 1]']
        %     end
        %
        
        
        if strcmp(z.origin,'volumeCenter')
            ni.hd.mat(1:3,4) =-diag(ni.hd.mat(1:3,1:3)).*round(ni.hd.dim(1:3)/2)' ;
        end
        
        
        %     visu          = readBrukerParamFile(fullfile(pa,'visu_pars'));
        %       dtest   = readBruker2dseq(brukerfile,visu);
        
        %%===============================================
        %%   PREPARE NIFTI
        %  hh   = struct('fname',outfile ,...
        %         'dim',   {dim(1:3)},...
        %         'dt',    {[64 spm_platform('bigend')]},...
        %         'pinfo', {[1 0 0]'},...
        %         'mat',   {mat},...
        %         'descrip', {['x']});
        %%===============================================
        hh         = ni.hd;
        hh.fname   = fpname;
        hh.descrip = ['source: ' brukerfile];
        
        % PRECISION
        %hh.dt         = [16 0]  ;%'float32'
        hh.dt         = [64 0]  ;%'float64'
        
        %===============================================
        %%  SAVE NIFTI (3d/4d)
        %%===============================================
        fclose('all');
        
        if 0 %% TEST
            continue
            disp( hh.fname );
        end
        
        if ndims(ni.d)==3
            hh=spm_create_vol(hh);
            hh=spm_write_vol(hh,  ni.d);
        elseif ndims(ni.d)==4
            clear hh2
            for j=1:size(ni.d,4)
                dum=hh;
                dum.n=[j 1];
                hh2(j,1)=dum;
                %if j==1
                %mkdir(fileparts(hh2.fname));
                spm_create_vol(hh2(j,1));
                %end
                spm_write_vol(hh2(j),ni.d(:,:,:,j));
            end
        elseif ndims(ni.d)==2
            hh=spm_create_vol(hh);
            hh=spm_write_vol(hh,  ni.d);
            
            
        end
        
        try
            delete(strrep(fpname,'.nii','.mat')) ; %% delete helper.mat
        end
        fclose('all');
        
        % if 1
        %     w=Visu;g=struct2list(w);uhelp([{[ ' #yg ' fname]}; g],1) ;
        % end
        
        %% SUCCESS
        disp([pnum(i,4) '] create <a href="matlab: explorer('' ' outdir '  '')">' fpname '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(files{i}) '  '')">' files{i}  '</a>']);% show h<perlink
        
    catch
 
        %% ERROR
        try ;      protoc=bh.v.VisuAcquisitionProtocol; catch; protoc='??'; end
        er=[  [' [' dh{1} '] ' dx{i,1}  ]  [' [protocol] ' protoc  ] ];
        for jj=2:length(dh)
            er=[er [' [' dh{jj} '] ' dx{i,jj}  ] ];
        end
        
        try
            cprintf([1 0 1],[pnum(i,4) '] ERROR: ' ]);
            cprintf([.8 .5 0],[ strrep(er,filesep,[filesep filesep])  '\n']);
        catch
            disp([pnum(i,4) '] ERROR: '  er]) ;
        end
        disp('       ...could not import this data');
        
        
        try
            delete(strrep(fpname,'.nii','.mat')) ; %% delete helper.mat
        end
        fclose('all');
    end
    
    
    
    
end%i
if showgui==1
    close(h)
end

makebatch(z,pain,trmb,sequence)
pause(.5)
drawnow;
try; antcb('update');end
fprintf('[BrukerImport Done!]\n');

%==============================================================================
%%  SUBS
%==============================================================================


function makebatch(z,pain,trmb,sequence)




if isempty(num2str(sequence));  sequence=0;    end
if isempty(num2str(trmb));      trmb=0;       end
if size(cellstr(pain),1)==1
    call=[mfilename '(' ['{' '''guidir'''  ' '  ''''  fileparts(pain) ''''  '}' ]  ' , ' num2str(sequence) ',' num2str(trmb), ',z' ')' ];
else
    pain2=cellstr(pain) ;
    call=[mfilename '(' ['{' '''guidir'''  ' '  ''''  (fileparts(pain2{1})) ''''  '}' ]  ' , ' num2str(sequence) ',' num2str(trmb), ',z' ')' ];
    
end

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('%===================================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('%===================================================');
hh=[hh; struct2list(z)];
hh(end+1,1)={call} ;%{[mfilename '(' { 'guidir'    fileparts(pain)} , sequence,trmb, ',z' ')' ]};
% disp(char(hh));
% uhelp(hh,1);


try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);



















function he=renamefiles(protocol,titlex)
% keyboard




tbrename=[unique(protocol(:)) repmat({''}, [length(unique(protocol(:))) 1])];

f = fg; set(gcf,'menubar','none');
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .85], 'Data', tbrename,'tag','table');
t.ColumnName = {'Protocol name                                            ', '(optional) rename coresponding file to..                         '};
t.ColumnEditable = [false true ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],'string','OPTIONAL: RENAME FILES (..otherwise protocol name is used)','fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***RENAME FILES USING PROTOCOL AS IDENTIFIER ***'} ;
h{end+1,1}=[' #### **NOTE*** THIS STEP IS OPTIONAL' ];
h{end+1,1}=['The 1st column represents the Protocol-name from MRI aquisition (readout from Bruker data ) '];
h{end+1,1}=['The 2nd column can ( ### optional! ##### ) be used to rename the protocol-related volumes '];
h{end+1,1}=[' which will be imported '];
h{end+1,1}=[' -renameing string without file-format (do not add ".nii")'];
h{end+1,1}=[' if cells in the 2nd column are empty, the import function uses the protocol name '];
h{end+1,1}=[' from the 1st column'];
%    uhelp(h,1);
%    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);

setappdata(gcf,'phelp',h);

pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
drawnow;
waitfor(f, 'userdata');
% disp('geht weiter');
tbrename=get(f,'userdata');
he=tbrename(~cellfun('isempty' ,tbrename(:,2)),:);
%     disp(tbrename);
close(f);




