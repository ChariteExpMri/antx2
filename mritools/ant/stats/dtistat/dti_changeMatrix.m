
% #wb dti_changeMatrix
% This gui allows to reduce the matrix size of existing MAtrix data (*.csv),
% and save as a new reduced MAtrix file. This might be a way to deal with
% the multiple comparison problem (fewer connection tested).
% #yk HOW TO ---------------------
% [select data]: select MAtrix data and the label (*.txt) here. 
% [listbox]    : this listbox displayes the selected data matrices
%
% #r ---------------------------------------------------------------
% #r OPTIONAL: You can save a COIfile (excel-file) with either
%     a) all pairwise connections (will be long) 
%     or ...
%     b) all labels 
%  In the saved excel-file tag the respective connections/labels of interest. 
% When done, select 'excelfile'-item from the 'Type'-pulldown menu
% #r ---------------------------------------------------------------
% 
% ['Type']-pulldown menu
%   reduce Matrix by using the following options:
%      'Left'  : keep only left hemispheric connections
%      'right' : keep only right hemispheric connections
%      'select': interactive mode: select connections/regions interactively
%      'excelfile': load a COIfile... see 'optional' (above)
% [suffix] : output suffix string added to the filename of the stored data-matrix         
% [other dir]: location to store the data
%     [ ] saving directory is the same as input directory  (DEFAULT)
%     [x] saving directory is another directory
% [RUN] use above paramter specifications and create/save a reduced data matrix
% 




function dti_changeMatrix

% ==============================================
%%
% ===============================================

delete(findobj(0,'tag','modmattrix'))
fg;
set(gcf,'units','norm','menubar','none',  'numbertitle','off',...
    'tag','modmattrix');
set(gcf,'name',[ 'changeMatrix' ])
set(gcf,'position',[ 0.4014    0.5289    0.16    0.3122]);


% ==============================================
% controls
% ===============================================
% select data
hb=uicontrol('style','pushbutton','units','norm','position',[0.004557 0.92853 0.14 0.05],...
    'string','?',...
    'tag','xhelp','backgroundcolor',[ 0.8392    0.9098    0.8510],'callback',@xhelp,...
    'tooltipstring',...
    ['get some help' char(10) ...
    '' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position',[0.013562 0.0053029 0.07 0.07]);



% select data
hb=uicontrol('style','pushbutton','units','norm','position',[0.004557 0.92853 0.14 0.05],...
    'string','select data',...
    'tag','getData','backgroundcolor',[ 0.8392    0.9098    0.8510],'callback',@getData,...
    'tooltipstring',...
    ['getData: select data here' char(10) ...
    '' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position',[0.004557 0.92853 0.5 0.07])


%----inputsource
source={'MRtrix' 'DSIstudio' };
hb=uicontrol('style','popupmenu','units','norm','position',[.22 .85 .18 .05],...
    'string',source ,'tag','inputsource',...
    'tooltipstring',...
    ['select DTI data input source' char(10)...
    'Only for DTI-connectivities (not for DTI-parameter).' char(10) ...
    %'<font color="black">command: <b><font color="green">inputsource</font>'...
    ]);
set(hb,'value',1);
set(hb,'position',[0.50894 0.92352 0.4 0.07]);


%% listbox input data
hb=uicontrol('style','listbox','units','norm','position',[0.004557 0.92853 0.14 0.05],...
    'string','<empty>',...
    'tag','lb_inputdata','backgroundcolor',[ 1.0000    0.9490    0.8667],...%'callback',@getData,...
    'tooltipstring',...
    ['input data' char(10) ...
    '' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position',[[0 0.6  1  .32]]);

% ------------------------------

%% save COIFIE-optional-string
hb=uicontrol('style','text','units','norm',...
    'string','optional',...
    'tag','saveCOI_title','backgroundcolor','w','fontsize',7);
set(hb,'position', [[0.013562 0.48576 0.2 0.041179]],'horizontalalignment','left');


%% make COIfile
hb=uicontrol('style','pushbutton','units','norm',...
    'string','save COIfile',...
    'tag','pb_saveCOI','backgroundcolor',[ 0.8392    0.9098    0.8510],...
    'callback',@pb_saveCOI,...
    'tooltipstring',...
    ['save COIfile' char(10) ...
    'The COI-file (excel file can be modified and reloaded)' char(10) ...
    'save COI-file, than tag the rows (connections or labels) of interest' char(10)
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.1999 0.45729 0.27269 0.071179]);
% set(hb,'visible','on');

%% COIfileType
hb=uicontrol('style','popupmenu','units','norm', ...
    'string',{'[1] connection-wise' '[2] region-wise'},...
    'backgroundcolor','w','tag','COItype',...
    'fontsize',7);
set(hb,'position', [0.49076 0.47865 0.4 0.05]);
% set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', ['The type  of COI-file for editing ' char(10) ...
    '1) connections: Excel-file with all possible connections ' char(10) ...
    '2) region-wise: Excelfile with regions only ' char(10) ......
    ]);






%% modifType-tx
tx=['modification type' char(10) ...
    'select from listbox' char(10)...
    %%'[1] output stored in another flat! directory' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ];

hb=uicontrol('style','text','units','norm',    'string','Type',...
    'backgroundcolor','w',...%'callback',@outdir,...
    'fontsize',7);
set(hb,'position', [-0.040976 0.20105 0.3 0.05]);
set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', tx);

%% modifType-pop
hb=uicontrol('style','popupmenu','units','norm', ...
    'string',{'Left' 'Right' ,'select','excelfile'},...
    'backgroundcolor','w','tag','modifType',...
    'fontsize',7);
set(hb,'position', [0.28625 0.21172 0.4 0.05]);
% set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', tx);
set(hb,'callback',@modifType);
% ------------------------------
%% select connections
hb=uicontrol('style','pushbutton','units','norm','position',[0.004557 0.92853 0.14 0.05],...
    'string','select',...
    'tag','select','backgroundcolor',[ 0.8392    0.9098    0.8510],'callback',@select,...
    'tooltipstring',...
    ['select connections' char(10) ...
    '' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.7 0.19751 0.2 0.07]);
set(hb,'visible','off');


%% suffix-txt
tx=['output suffix string' char(10) ...
    'type string here..this string is added to the output file' char(10)...
    %%'[1] output stored in another flat! directory' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ];

hb=uicontrol('style','text','units','norm',    'string','suffix',...
    'backgroundcolor','w',...%'callback',@outdir,...
    'fontsize',7);
set(hb,'position', [-0.027341 0.1441 0.3 0.05]);
set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', tx);

%% suffix-ed
hb=uicontrol('style','edit','units','norm',    'string','resized',...
    'backgroundcolor','w','tag','suffix',...%'callback',@outdir,...
    'fontsize',7);
set(hb,'position', [0.29534 0.15478 0.4 0.05]);
% set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', tx);




%% output dir -radio
hb=uicontrol('style','radio','units','norm',    'string','other DIR',...
    'tag','rd_outdir','backgroundcolor','w','callback',@rd_outdir,...
    'fontsize',7,...
    'tooltipstring', ['output directory' char(10) ...
    '[] output stored in input directory' char(10) ...
    '[1] output stored in another flat! directory' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.0090169 0.090718 0.3 0.05]);
set(hb,'value',0);

%% output dir -button
hb=uicontrol('style','push','units','norm',    'string','selDIR',...
    'tag','pb_outdir','backgroundcolor',[ 0.8392    0.9098    0.8510],'callback',@pb_outdir,...
    'fontsize',7,...
    'tooltipstring', ['select output directory' char(10) ...
    %     '[] output stored in input directory' char(10) ...
    %     '[1] output stored in another flat! directory' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.29988 0.090718 0.15 0.05]);

%% output dir edit
hb=uicontrol('style','edit','units','norm',    'string','<empty>',...
    'tag','ed_outdir','backgroundcolor','w','callback',@ed_outdir,...
    'fontsize',7,...
    'tooltipstring', ['the output directory' char(10) ...
    %     '[] output stored in input directory' char(10) ...
    %     '[1] output stored in another flat! directory' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.46 0.090718 0.54 0.05]);


%% run
hb=uicontrol('style','pushbutton','units','norm','position',[0.004557 0.92853 0.14 0.05],...
    'string','RUN',...
    'tag','proceed','backgroundcolor',[ 0.8392    0.9098    0.8510],'callback',@proceed,...
    'tooltipstring',...
    ['proceed change data' char(10) ...
    '' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);
set(hb,'position', [0.78163 0.01598 0.2 0.07]);



set(findobj(gcf,'tag','ed_outdir'),'visible','off');
set(findobj(gcf,'tag','pb_outdir'),'visible','off');


% ==============================================
%%   callbacks
% ===============================================
function xhelp(e,e2)
uhelp([mfilename '.m']);


function modifType(e,e2)

ht=findobj(gcf,'tag','modifType');
hb=findobj(gcf,'tag','select');
if strcmp(ht.String(ht.Value), 'select') || strcmp(ht.String(ht.Value), 'excelfile')
    set(hb,'visible','on');
    if strcmp(ht.String(ht.Value), 'select')
        set(hb,'tooltipstring','select connections' );
    elseif strcmp(ht.String(ht.Value), 'excelfile')
        set(hb,'tooltipstring','select excelfile' );
    end
else
    set(hb,'visible','off');
end

function rd_outdir(e,e2)
hb=findobj(gcf,'tag','rd_outdir');
if hb.Value==1  %same
    set(findobj(gcf,'tag','ed_outdir'),'visible','on');
    set(findobj(gcf,'tag','pb_outdir'),'visible','on');
else
    set(findobj(gcf,'tag','ed_outdir'),'visible','off');
    set(findobj(gcf,'tag','pb_outdir'),'visible','off');
end

function pb_outdir(e,e2)
us=get(gcf,'userdata');
pa=pwd;
paout=uigetdir(pwd,'select output directory');
if ~isnumeric(paout)
    set(findobj(gcf,'tag','ed_outdir'),'string',paout);
end

function getData(e,e2)
hf=findobj(0,'tag','modmattrix');
us=get(hf,'userdata');

% get source
hsource=findobj(hf,'tag','inputsource');
li=get(hsource,'string');
va=get(hsource,'value');
sourceinput=lower(li{va});

if ~isempty(strfind(sourceinput,'dsi'));
    source=1;
else ~isempty(strfind(sourceinput,'trix'));
    source=2;
end

% ==============================================
%%  CONFILES
% ===============================================
if exist('files')==0
    cprintf([1 0 1],['Select DTI data..wait..' ]);
    if  source==1; %DSI
        msg1={...
            'Select connectivity data processded by DSI-studio (MAT-files).'
            '  This data should be mat-files (filter: "*.mat").'
            };
        dtype='mat';
        flt  ='.*rk4_end.mat|.*_connectivities.mat';
    elseif source==2 %mrtrix
        msg1={...
            'Select connectivity data processded by MRtrix (CSV-files)'
            ' This data should be csv-files (filter: "*.csv").'
            };
        dtype='any';
        flt  ='.*csv|connectome.*.csv';
    end
    
    msg2={ '        '
        ' Select the files (A) manually or do it (B) recursively:'
        '  _____ (B) RECURSIVELY find files _____  '
        '(1): Select the main folder containing all connectivity data.'
        '(2): Check/adjust the filter string in the filter edit field.'
        '(3a): Click [Rec] button to recursively find all files with matching filter '
        '     The found files will be listed in the lower listbox...examine the list carefully.. '
        '     ..If needed prune the list (click onto file to remove it from selection). '
        '____ If it''s more complicated follow steps below____'
        '(3b): Click [RecList] button to obtain a list of all matching files recursively found in the main folder.'
        '(4): In this SELECTOR window select the requested files from the list...hit [OK].'
        '(5): Hit [Rec] button to recursively find all matching files.'
        '(6): Check lower listbox. If needed prune the list (click onto file to remove it from selection).'
        '(7): If needed, add other files using steps from (A) or (C).'
        ''};
    msg=[msg1; msg2];
    
    % [fi,sts] = cfg_getfile2(inf,'mat',msg,[],pwd,'.*rk4_end.mat|.*_connectivities.mat');
    [fi,sts] = cfg_getfile2(inf,dtype,msg,[],pwd, flt);
    
else
    fi=files;
end

% ==============================================
%%   LABEL-FILE
% ===============================================
if source==2 %mrtrix
    if exist('labelfile')  ~=1
        msg={'select one(!) label-file (*.txt) for MRtrix'};
        pa_label=fileparts(fi{1});
        [fi2,sts] = cfg_getfile2(1,'any',msg,[],pa_label, '.*.txt');
        labelfile=char(fi2);
        if isempty(char(fi))
            cprintf([1 0 1],['process aborted\n' ]);
            return
        end
    end
end

% ==============================================
%%   MRtrix-stuff
% ===============================================
if source==2
    %%   label
    t=readtable(char(labelfile));
    t=table2cell(t);
    
    
    
    % ==============================================
    %%   get name tags MRtrix-files have the same name
    % ===============================================
    endtag={};
    for i=1:size(fi)
        r=strsplit(fi{i},filesep);
        endtag{i,1}=r{end};
    end
    if size(unique(endtag),1)==length(fi) ;%all files have different names
        namesMRtrix=regexprep(endtag,'.csv','');  %remove FMT
    else
        namesMRtrix={};
        for i=1:size(fi)
            r=strsplit(fi{i},filesep);
            try
                namesMRtrix{i,1}=r{find(strcmp(r,'dat'))+1};
            catch
                error('files must have different names or must be located in the studie''s animal-folders (dat/animalfolder_xyz)') ;
            end
        end
    end
end
cprintf([1 0 1],['selection of DTI data done.\n' ]);

% ==============================================
%%
% ===============================================

c={};
con=[];
names={};
for i=1:size(fi,1)
    cprintf([0 0 1],['[reading]: '   strrep(fi{i},[filesep],[filesep filesep])  '\n']);
    
    if source==1
        a=load(fi{i});
        label=char(a.name);
        label=strsplit(label,char(10))';
        label(find(cellfun(@isempty,label)))=[] ;
        [~,namex]=fileparts(fi{i});  %mousename
        ac=a.connectivity;           %connectMAtrix
    elseif source==2
        ac   =csvread(fi{i});
        namex=namesMRtrix{i};
        label=t(:,2);
    end
    
    %% check
    %     ac=[0  1  2  3  4
    %         0  0  5  6  7
    %         0  0  0  8  9
    %         0  0  0  0 10
    %         0  0  0  0  0
    %         ]  ;  ac=ac+ac'
    %
    
    si=size(ac);
    tria=triu(ones(si));
    tria(tria==1)=nan;
    tria(tria==0)=1;
    
    ind       =find(tria(:)==1); %index in 2d-Data
    val      =ac(ind);
    con(:,i) =val;
    names{i} =namex;
    files{i,1}=fi{i};
    
    if i==1  % CONECTIVITY labls
        la=repmat({''},si);
        for j=1:size(la,1)
            for k=1:size(la,2)
                la(j,k)={  [label{j} '--' label{k}] };
            end
        end
        connames=la(ind)  ;
    end
    
    % adding entire matrix for proport threshold
    c.info_mat_ind={'mat: matrices' 'ind:index for condata "condatat=mat(ind) "'};
    c.mat(:,:,i)=ac;
    c.ind       =ind;
    
    
    %% check
    % s=zeros(prod(si),1);s(ind)=val; s=reshape(s,[si]); s= s+s'
end
cprintf([0 0 1],['Done.\n']);

% c={};
c.mousename=names;
c.files    =files;
c.conlabels=connames;
c.condata  =con;
c.size     =si;
c.index    =ind;
c.labelmatrix=la;
c.labelfile=char(labelfile);
c.label      =label;



% merge struct
f = fieldnames(c);
for i = 1:length(f)
    us.(f{i}) = c.(f{i});
end

% us.con=c;
set(hf,'userdata',us);
set(findobj(gcf,'tag','lb_inputdata'),'string',us.files,'tooltipstring',strjoin(us.files,char(10)));



% ==============================================
%%
% ===============================================

function select(e,e2)
% ==============================================
%%
% ===============================================
us=get(gcf,'userdata');
ht=findobj(gcf,'tag','modifType');

if strcmp(ht.String(ht.Value),'excelfile')
    [fi pa]= uigetfile(fullfile(pwd,'*.xls*'),'select COI-file (excelfile)');
    if isnumeric(fi);
        disp('..');
        return;
    end
    
    us.keeplabels=fullfile(pa,fi);
    set(gcf,'userdata',us);
else
    tb=us.label;
    
    id=selector2(tb,{'Regions' },'iswait',1,...
        'position',[0.0778  0.0772  0.3510  0.8644],...
        'finder',1,'help',{'select regions here';'the combination of selected regions is kept'},...
        'title','select regions');
    if length(id)==1 && id==-1
        id=[];
    end
    
    if ~isempty(id)
        us.keeplabels=tb(id);
        set(gcf,'userdata',us);
    end
end

% ==============================================
%%
% ===============================================
function proceed(e,e2)


us=get(gcf,'userdata');
ht=findobj(gcf,'tag','modifType');
if ~isempty(strfind(ht.String{ht.Value},'Left'))
    s.type='L';
    s.keeplabels=us.label(regexpi2(us.label,'^L_'));
elseif ~isempty(strfind(ht.String{ht.Value},'Right'))
    s.type='R';
    s.keeplabels=us.label(regexpi2(us.label,'^R_'));
elseif ~isempty(strfind(ht.String{ht.Value},'select'))
    s.type='select';
    if isfield(us,'keeplabels')==1
        s.keeplabels=us.keeplabels ;
    else
        errordlg(['Select regions first!'  char(10) ' regions can be selected via [Select]-Btn.'],'');
        return
    end
elseif ~isempty(strfind(ht.String{ht.Value},'excelfile'))
    s.type='excelfile';
    if isfield(us,'keeplabels')==1 && exist(us.keeplabels)==2
        s.keeplabels=us.keeplabels ;
    else
        errordlg(['Select excelfile first!'  char(10) ' COI-file can be selected via [Select]-Btn.'],'');
        return
    end
end
% type

s.files    =us.files;
s.mousename=us.mousename;
s.mat      =us.mat;
s.label    =us.label;
s.labelfile =us.labelfile;

s.suffix   =get(findobj(gcf,'tag','suffix'),'string');
%------------------[same outdir]
if get(findobj(gcf,'tag','rd_outdir'),'value')==1 %other dir
    s.outdir=get(findobj(gcf,'tag','ed_outdir'),'string');
    if exist(s.outdir)~=7
        errordlg(['You indicated to use another output-directory, but no output-DIR was specified.'  char(10) ...
            ' ...use [SelDir]-Btn to specify the output directory.'],'');
    end
else
    s.outdir  ='same';
end



if 1
    disp('us--------');
    disp(us);
    disp('s--------');
    disp(s);
end
changematrix(s)


function changematrix(s)


% for i=1:length(s.keeplabels)
if strcmp(s.type,'excelfile')
    [~,~,a0]=xlsread(s.keeplabels);
    a=a0;
    ha=a(1,:);
    a =a(2:end,:);
    iCOI=find(strcmp(ha,'COI'));
    if iCOI==3 %connections
        iuse=find(cell2mat(a(:,iCOI   ))==1);
        a=a(iuse,:);
    elseif iCOI==2 %regions
        iuse=find(~isnan(cell2mat(a(:,iCOI))));
        a2=a(iuse,:);
        c=[];
        for i=1:size(a2,1)
            if a2{i,2}==1  %direct connection
                t1=a2(i,1);
                t2=a2(setdiff(1:size(a2(:,1),1),i),1);
                t1=repmat(t1,[size(t2,1) 1]);
                dx=[t1 t2];
                c=[c; dx];
            elseif a2{i,2}==2 %connection with all other regions
                t1=a2(i,1);
                t2=s.label(find(~ismember(s.label,t1)));
                t1=repmat(t1,[size(t2,1) 1]);
                dx=[t1 t2];
                c=[c; dx]; 
            end    
        end
        a=c;
    end
    
    msk=zeros(size(s.mat,1),size(s.mat,2));
    for i=1:size(a,1)
        i1=find(strcmp(s.label,a{i,1}));
        i2=find(strcmp(s.label,a{i,2}));
        
        msk(i1,i2)=1;
        msk(i2,i1)=1;
    end
    idx=find(sum(msk,1)~=0);
    
    v.msk  =msk(idx ,idx,:);
    v.mat  =s.mat(idx ,idx,:);
    v.label=s.label(idx);
    v.mat=v.mat.*repmat(v.msk,[1 1 size(v.mat,3)]); %set other Connections to ZERO
else
    idx=find(ismember(s.label,s.keeplabels));
    
    v.mat  =s.mat(idx ,idx,:);
    v.label=s.label(idx);
end

disp(v);
% ==============================================
%%   Label
% ===============================================
%w=textread(s.labelfile,'%s')
[q1 q2 q3 q4 q5 q6]=textread(s.labelfile,'%s\t%s\t%s\t%s\t%s\t%s');
w=[q1 q2 q3 q4 q5 q6];

lut=[];
for i=1:length(v.label)
    tp=w(find(strcmp(w(:,2),v.label{i})),:);
    tp{1}=num2str(i);
    lut=[lut;    tp ];
end
lut2=plog([],[ w(1,:); lut],0,'','plotlines=0');
% pwrite2file('test.txt' ,lut2 );

% ==============================================
%%   save
% ===============================================
if strcmp(s.outdir,'same')
    for i=1:size(s.files,1)
        source=s.files{i};
        [pa name ext]=fileparts(source);
        nameout=fullfile(pa, [name  '_' s.suffix  ext] );
        b=squeeze(v.mat(:,:,i));
        dlmwrite(nameout, b, 'delimiter', ',', 'precision', 15);
        %--------Label-----------
        nameout_Lut=fullfile(pa, ['LUT_' name  '_' s.suffix  '.txt'] );
        pwrite2file(nameout_Lut ,lut2 );
        %----INFO------------
        cprintf([1 0 1],['[NEW MATRIX]: '   strrep(nameout,[filesep],[filesep filesep])  '\n']);
        showinfo2(['  Matrix-->'],nameout) ;
        showinfo2(['     LUT-->'],nameout_Lut) ;
    end
    
end
       







function pb_saveCOI(e,e2)

us=get(gcf,'userdata');

%% coi-type
ht=findobj(gcf,'tag','COItype');
if ~isempty(strfind(ht.String{ht.Value},'connection'))
    COItype=1;
else
    COItype=2;
end
cprintf([0 0 1],['..COI-Type: ' ht.String{ht.Value} '\n']);

% COItype
% return
cprintf([0 0 1],['..Please WAIT....\n']);

%% OUTPUTName
[fi pa]=uiputfile(fullfile(pwd,'*.xlsx'),'save COIfile as...');
if isnumeric(fi);
    disp('user-abort...could not save COI-file');
    return;
end
filename=fullfile(pa,fi);

try; delete(filename); end






% ==============================================
%%   type 1: combinations
% ===============================================
if COItype==1
    cprintf([0 0 1],['..prepare data....\n']);
    lab=[];
    for i=1:size(us.label,1)
        t1=us.label(i);
        t2=us.label(setdiff(1:size(us.label,1),i));
        
        t1=repmat(t1,[size(t2,1) 1]);
        
        to=cellfun(@(a,b) {[a '--' b]},t1,t2);
        lab=[lab; to];
    end
    
    
    v = regexp(lab, '--', 'split');
    ca = cellfun(@(x)x(:,1), v);
    cb = cellfun(@(x)x(:,2), v);
    labs = [ca cb];
    
    
    head={'connectionA' 'connectionB' 'COI' 'INFO'};
    tb=cell(size(labs,1),4);
    tb(:,1:2)=labs;
    
    tb=[head;tb];
    msg={...
        'This COI-file is used denote the connections of Interest (COIs) and thereby reduces the number'
        'of statistically tested connections. "dtistat.m" can read the COI-file and handle the'
        'multiple comparisons problem (lots of tests reduced to fewer tests).'
        ''
        '___INSTRUCTION___'
        '# The first two columns represent the connection between two regions (read it row-wise),'
        '   i.e. fibre connections between "connectionA" (column-1) and "connectionB" (column-2).'
        '# Please denote Connections of Interests in column-3 ("COI") by inserting the number "1" (without quote signs).'
        '# Leave all other cells in column-3 ("COI") blank, i.e. "connections of no interest" are not denoted!'
        '# Rows can be reordered/sorted, but content of each row must be preserved (i.e. when sorting according column-A'
        '   all other columns must be ordered in the same way.'
        '# You can also delete some or even all rows that represent "connections of no interest", i.e. connections you'
        '   are not interested in. In any case, "connections of interest" has to be marked in column-3 ("COI").'
        };
    tb(2:size(msg,1)+1,4)=msg;
    
    cprintf([0 0 1],['..write data....\n']);
    xlswrite(filename,[tb],'COI');
    xlsAutoFitCol(filename,'COI','A:F');
    col=[...
        0.7569    0.8667    0.7765
        0.7569    0.8667    0.7765
        0.8941    0.9412    0.9020
        0.9922    0.9176    0.7961];
    xlscolorizeCells(filename,'COI', [1 1; 1 2; 1 3; 1 4], col);
    
    % ==========  =================
    
    
    
    % ==============================================
    %%
    % ===============================================
elseif  COItype==2
     head={'Region' 'COI' 'INFO'};
     tb=cell(size(us.label,1),3);
     tb(:,1)=us.label;
    tb=[head;tb];
      msg={...
        'Connections of Interest (COIs) are constructed using selected regions.'
        'This COI-file is used to indicate those regions '
        'With this the number of statistical tests can be reduced.'
        'multiple comparisons problem (lots of tests reduced to fewer tests).'
        ''
        '___INSTRUCTION___'
        '# The first column represent the regions'
        '# Please denote regions of Interests in column-2 ("COI") by inserting the number "1" (without quote signs).'
        'Connections will be derived by the combination of selected regions'
        '# Leave all other cells in column-2 ("COI") blank, i.e. those regions are not used'
        '# Rows can be reordered/sorted, but content of each row must be preserved (i.e. when sorting according column-A'
        '   all other columns must be ordered in the same way.'
        '# You can also delete some or even all rows that represent "regions of no interest", i.e. regions you'
        '   are not interested in. In any case, "region of interest" has to be marked in column-2 ("COI").'
        };
    tb(2:size(msg,1)+1,3)=msg;
    
    cprintf([0 0 1],['..write data....\n']);
    xlswrite(filename,[tb],'COI');
    xlsAutoFitCol(filename,'COI','A:F');
    col=[...
        0.7569    0.8667    0.7765
        0.7569    0.8667    0.7765
        0.8941    0.9412    0.9020
        0.9922    0.9176    0.7961];
    xlscolorizeCells(filename,'COI', [1 1; 1 2; 1 3; 1 4], col);
    
end


cprintf([0 .5 0],['Done.\n' ]);
disp(['COIfile blanko: <a href="matlab: system('''  [filename] ''');">' [filename] '</a>']);






