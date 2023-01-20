
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
% 
% #gy ___OTHER COMANDLINE OPTIONS___
% #b  DELETE csv/lut-FILES
% dti_changeMatrix('delete')               ;% DELETE via GUI
% dti_changeMatrix('delete','gui',1)       ;% same as above     
% dti_changeMatrix('delete','gui',1,'files',files)  ;% % DELETE files defined in files via OPEN GUI...files is a cell with fullpath-filenames
% dti_changeMatrix('delete','gui',1,'files',files)  ;% same but without GUI
% 
% #b REDUCE MATRIX using only specific CONNECTIONS 
% specific CONNECTIONS are defined in an excelfile (COI-file)
% % Here: 'LF' is the LUTfile (labels): 'atlas_lut.txt'
% %       'MF' is the Matrixfile      :'connectome_di_sy.csv'
% %       'path' is the fullpath to the main-folder containing the 'LF' and 'MF'
% %       'COI' is the COI-file with connections to keep: here 'reducedCONS.xlsx'
%    dti_changeMatrix('run','LF','atlas_lut.txt','MF','connectome_di_sy.csv','path',fullfile(pwd,'dat'),'COI',fullfile(pwd,'reducedCONS.xlsx'))
% %% THIS IS IDENTICAL TO: 
%     z.LF  ='atlas_lut.txt';
%     z.MF  ='connectome_di_sy.csv';
%     z.path=fullfile(pwd,'dat');
%     z.COI =fullfile(pwd,'reducedCONS.xlsx');
%     dti_changeMatrix('run',z);
% 
% 


function dti_changeMatrix(w,varargin)

if 0
    %% ===============================================
    
   w=[] 
   w.lutfile={'F:\data4\sarahDTI_stat\_testMerge_HC\atlas_lut.txt'} 
   w.dtifile={'F:\data4\sarahDTI_stat\_testMerge_HC\connectome_di_sy__Level2.csv'}
   w.source =1; %mrtrix
   w.type   ='select&merge';
   dti_changeMatrix(w)
    
    %% ===============================================
    
end

if 0
    
  z.LF  ='atlas_lut.txt';
  z.MF  ='connectome_di_sy.csv';
  z.path=fullfile(pwd,'dat');
  z.COI =fullfile(pwd,'reducedCONS.xlsx');
  dti_changeMatrix('run',z);

end

% ==============================================
%%   spec. evaluations
% ===============================================
if exist('w')==1
    if strcmp(w,'delete')
        deletefiles(varargin);
        return
    elseif strcmp(w,'run')
        prep4commandline(varargin);
        return
    end
end




% ==============================================
%%   input
% =============================================== 
u.argin=0;%inputargs
makefig(u);


    
    


if exist('w')==1
    if isfield(w,'source') && ~isempty(intersect([1 2],w.source)) 
       
        
        if isfield(w,'source');
            set(findobj(gcf,'tag','inputsource'),'value',w.source);
        end
        if isfield(w,'dtifile');
            u.files=cellstr(w.dtifile);
        end
        if isfield(w,'lutfile')
            u.labelfile=char(w.lutfile);
        end
        
        if isfield(w,'dtifile') || isfield(w,'lutfile')
           
            u.argin=1;
             v=get(gcf,'userdata');
            u=catstruct(v,u);
            set(gcf,'userdata',u);
            getData([],[]);
        end
        
        if isfield(w,'keeplabels')
          u=get(gcf,'userdata');
          u.keeplabels=w.keeplabels;
          set(gcf,'userdata',u);
        end
        
        
    else
        msgbox('"source"-field in input-struct must be (1)MRtrix or (2)DSIstudio');
    end
    
    if isfield(w,'type')
        hs=findobj(gcf,'tag','modifType');
        isel=find(strcmp(hs.String,'select&merge' ));
        if ~isempty(isel);
            set(hs,'Value',isel);
            hgfeval( get(hs,'callback'),hs);
        end
        
    end
        
end



% ==============================================
%%
% ===============================================
function makefig(u);
delete(findobj(0,'tag','modmattrix'))
fg;
set(gcf,'units','norm','menubar','none',  'numbertitle','off',...
    'tag','modmattrix');
set(gcf,'name',[ 'changeMatrix [' mfilename '.m]' ]);
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
    'string',{'[1] connection-wise' '[2] region-wise' '[3] mergeRegions'},...
    'backgroundcolor','w','tag','COItype',...
    'fontsize',7);
set(hb,'position', [0.49076 0.47865 0.4 0.05]);
% set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', ['The type  of COI-file for editing ' char(10) ...
    '1) connections: Excel-file with all possible connections ' char(10) ...
    '2) region-wise: Excelfile with regions only ' char(10) ......
    '3) mergeRegions: Excel-file with regions, regions to be merged can be edited ' char(10) ......
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
    'string',{'Left' 'Right' ,'select', 'select&merge'  'excelfile'},...
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

%% delete
hb=uicontrol('style','pushbutton','units','norm', ...
    'string','delete files',...
    'backgroundcolor',[1 .6 .7],'tag','deletefiles',...
    'fontsize',7);
set(hb,'position', [0.18656 0.0053029 0.25 0.05]);
% set(hb,'HorizontalAlignment','right');
set(hb,'tooltipstring', 'delete CSV-files and lut-files from drive');
set(hb,'callback',@deletefiles_cb);


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
set(gcf,'userdata',u);


% ==============================================
%%   callbacks
% ===============================================
function deletefiles_cb(e,e2)
deletefiles()

function deletefiles(s)
if exist('s')==1
    if iscell(s)
        if ~isempty(s)
            s=cell2struct(s(2:2:end),s(1:2:end),2);
        end
    end
end
p.gui=1;
p.fi ='';
if exist('s')==1
    if isfield(s,'gui')  ==1; p.gui =s.gui ; end
    if isfield(s,'files')==1; p.fi  =s.files; end
end
%% ===============================================
if p.gui==1 || isempty(p.fi)
    fi=cfg_getfile2(inf,'any',{'ss' 'ee'},p.fi,pwd,'.*.csv|.*.txt');
    if isempty(char(fi)); return; end
    fi=cellstr(fi);

    Q = questdlg(['SURE?...DELETE FILES?' char(10) 'Selected files will be permanently deleted! '], ...
        'delete'    , 'Yes' ,'No',    'No'        );
    if strcmp(Q,'Yes')==0; return; end
    p.fi=fi;
end
%% =============delete ==================================
    cprintf([0 0 1],['Deleting files... \n']);
    for i=1:length(p.fi);
       
           delete(p.fi{i})
      
          if  exist(p.fi{i})==0
              %disp(['...file dows not exist: ' p.fi{i} ]);
          else
               disp(['...file exists, but can''t delete, maybe file is open: '  p.fi{i} ]);
          end
    end
    cprintf([0 0 1],['DONE! \n']);

%% ===============================================


function xhelp(e,e2)
uhelp([mfilename '.m']);


function modifType(e,e2)

ht=findobj(gcf,'tag','modifType');
hb=findobj(gcf,'tag','select');
if strcmp(ht.String(ht.Value), 'select') || ...
        strcmp(ht.String(ht.Value), 'select&merge') ||...
       strcmp(ht.String(ht.Value), 'excelfile')
   
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

function c=getData(e,e2,ss)
c=[];
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
if us.argin==1 && isfield(us,'files')
    fi=us.files;
elseif exist('ss')==1 && isfield(ss,'files')==1
    fi=ss.files;
else
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
end
% ==============================================
%%   LABEL-FILE
% ===============================================
if us.argin==1 && isfield(us,'labelfile')
    labelfile=us.labelfile;
elseif exist('ss')==1 && isfield(ss,'labelfile')==1
    labelfile=ss.labelfile;
else
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
        splitmat={};
        for i=1:size(fi)
            r=strsplit(fi{i},filesep);
            try
                namesMRtrix{i,1}=r{find(strcmp(r,'dat'))+1};
            catch
                try
                    splitmat(i,:)=r;
                catch
                    error('files must have different names or must be located in the studie''s animal-folders (dat/animalfolder_xyz) or dti-data must be located on the same  hierarchical level in different folders') ;
                end
            end
        end
        if ~isempty(splitmat)
            ndiffvec=[];
            for i=size(splitmat,2):-1:1
                ndiffvec(1,i)=length(unique(splitmat(:,i)));
            end
            ianimaltag  =max(find(ndiffvec>1));
            if isempty(ianimaltag) % single animal
                
            end
            namesMRtrix=splitmat(:,ianimaltag);
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
labelID={};
sizemat=[];%size of dtimatrix
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
        if i==1
            sizemat=size(ac);
        end
        %check matSize
        if sum(abs(size(ac)-sizemat))~=0
            %% ===============================================
            
            [pan,name,ext]=fileparts(fi{i});
            [~,animal]=fileparts(pan);
            msg={'<h2>mismatching matrix size</h2> '
                ['<b>file:</b>    ' num2str(i) ')']
                [ '<b>file:</b>   ' [name,ext]  ]
                [ '<b>animal:</b> '    animal   ]
                [ '<b>path:</b>   ' pan   ]
                ['<b>problem:</b> ' sprintf('matrix-size: [%d %d]',size(ac)) ' but size of first animal is: '  sprintf('[%d %d]',sizemat)   ]
                };
            %char(msg)
            %msgbox(msg)
            
            % ===============================================
            hf2=figure;
            addNote([hf2],'text',msg,'state',3,'dlg', 1,'fs',20,'wait',1,'headcol',[0 1 1]);
            error('mismatching matrix-sizes');
            %% ===============================================
            return
        else
          %disp('same matrixSize as 1st matrix');  
        end
        
        namex=namesMRtrix{i};
        label  =t(:,2);
        labelID=t(:,1);
    end
    
    % check
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
    
    
    
    % check
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
c.labelID    =labelID;


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
    
    hs=findobj(gcf,'tag','modifType');
    
    if strcmp(hs.String(hs.Value),'select&merge')==1
        %% ===============================================
        %%  SELECT AND MERGE
        %% ===============================================

        %% ===============================================
        % load merging-table
        choi={'[YES] load DTI-mergingTable (Excelfile)' '[NO] select Clusters via GUI' }
        q=questdlg({'Do you want to load an existing DTI-mergingTable? (Excelfile)' 
            '[YES] load existing DTI-mergingTable'
            '[NO] let me select the Clusters via GUI'}, ...
            'load  DTI-mergingTable', ...
            choi{1},choi{2},choi{2});
%         
%         
       if strcmp(q,choi{1}) %EXCEL_FILE_______________
            [fi pa] =uigetfile(fullfile(pwd,'merginTable_.xlsx') , 'select mergingTable (EXCELFILE)...');
            if isnumeric(fi)
                tb2=[];
            else
                %HEADER:
                %'ID'    'Region'    'included'    'sameClusterID'    'DonorCLUSTERLabel'
                %--------------------
                [~,~,r]=xlsread(fullfile(pa,fi));
                htb1=r(1,1:5);
                tb1=r(2:end,1:5);
                col1=cellfun(@(a){[  num2str(a)]} ,tb1(:,1));
                idel=regexpi2(col1,'NaN|^$','emptymatch');
                tb1(idel,:)=[];
                
               dum=cellfun(@(a){[  num2str(a)]} ,tb1(:,3:end));
               dum=regexprep(dum,'NaN','');
               tb1(:,3:end)=dum;
               
               
               % labelDOnator
               vlabdon=zeros(size(tb1,1),1);
               vlabdon(find(~cellfun(@isempty, tb1(:,5))))=1;
               tb1(:,5)=num2cell(vlabdon);
               
               % filter only "included" regions
              i_included =find(~cellfun(@isempty, tb1(:,3)));
               tb2=tb1(i_included,:);
               tb2=tb2(:,[1 2   4 5]); %remove included column
               
               
%                 idel=find(strcmp(cellfun(@(a){[  num2str(a)]} ,tb2(:,1)),'NaN'));
%                 tb2(idel,:)=[];
%                 idel=find(strcmp(cellfun(@(a){[  num2str(a)]} ,tb2(:,1)),''));
%                 tb2(idel,:)=[];
            end
        
       else
        %% ===============================================
        %%  SELECT AND MERGE:  [ PART-1]    select all regions
        %% ===============================================
        msg={' #lk select&merge [PART-1] SELECT ALL REGIONS'
            'Select #r all #r the regions you want to keep, i.e.'
            'select all regions which should be merged and also'
            'the regions that should not not be merged but are kept'
            'In the upcoming GUI you can assign regions that should be merged'
            'and assign a new label for the merged region(s)'
            };
       
         N=length(us.label);
        tbh={    'Region-ID' 'anatomical Regions' 'included-IDs'  };
        tb=[us.labelID           us.label          repmat({false},[ N 1 ])  ];
        
        tb1=uitable_checklist(tb,tbh,'editable',[ 3 ],'title','PART1: included Regions',...'tooltip' ,['xx' char(10) 'yy'],...
            'pos', [.2 .2 .5 .6],'iswait',1,'help',msg,'autoresize',1,...
            'rowcolorcol',3,'issortable',1);%,'postab', [0 0  1 1]);
        if isempty(tb1); return, end
        drawnow;
   
        
        
        %% ===============================================
        %%  SELECT AND MERGE:  [ PART-2]    select regions to be merged
        %% ===============================================
        msg={...
            ' #lk select&merge [PART-2] SELECT the REGIONS that should be merged'
            ' #b __"Merging-IDs"__ '
            'If regions should be merged: enter a number in "Merging-IDs" column for those regions'
            'regions with an identical number in "Merging-IDs" will be merged'
            '--> see context menu to set several regions at the same time'
            ''
            ' #b __"Donor of Merging label"__ '
            '"Donor of Merging label" [CHECKBOX] select here the region how is the label donor'
            ' #r PLease set only ONE region as label Donor per merging cluster'
            'of the merged regions...the merged region needs a name  '
            '--> see context menu to set several regions at the same time'
            ''
            ''
            '.. merging cluster: several regions can be merged ...to one merging cluster'
            '..several merging clusters can be created here'
            '..each region can only be part of one region-cluster (not several)!'
            };
        
        
        isel=find(cell2mat(tb1(:,3))==1);
        N=length(isel);
        tbh={    'Region-ID' 'anatomical Regions'     'Merging-IDs'          'Donor of Merging label'  };
        tb=[us.labelID(isel)           us.label(isel)  repmat({''},[ N 1 ])    repmat({false},[ N 1 ])       ];
        
        tb2=uitable_checklist(tb,tbh,'editable',[ 3 4],'title','PART2:merging regions',...'tooltip' ,['xx' char(10) 'yy'],...
            'pos', [.2 .15 .5 .6],'iswait',1,'help',msg,'autoresize',1,...
            'rowcolorcol',3,'issortable',1);%,'postab', [0 0  1 1]);
  
       end
        
       %% ====obtaining index ===========================================
        if isempty(tb2); 
            msgbox('no merging obtained...');
            return;
        end
        id=tb2; %just write inside...care later
        
     
        
        %% ===============================================
        
    else
        id=selector2(tb,{'Regions' },'iswait',1,...
            'position',[0.0778  0.0772  0.3510  0.8644],...
            'finder',1,'help',{' #lk select' 'select regions here'},...
            'title','select: select regions to keep');
    end
    if length(id)==1 && id==-1
        id=[];
    end
    
    if isnumeric(id) && ~isempty(id)
        us.keeplabels=tb(id);
        set(gcf,'userdata',us);
    elseif iscell(id)  %SELECT & merge
        us.keeplabels=id;
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
elseif strcmp(ht.String{ht.Value},'select')==1           %SELECT
    s.type='select';
    if isfield(us,'keeplabels')==1
        s.keeplabels=us.keeplabels ;
    else
        errordlg(['Select regions first!'  char(10) ' regions can be selected via [Select]-Btn.'],'');
        return
    end
elseif strcmp(ht.String{ht.Value},'select&merge')==1       %SELECT&merge 
     s.type='select&merge';
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



if 0
    disp('us--------');
    disp(us);
    disp('s--------');
    disp(s);
end
changematrix(s);


function prep4commandline(r)
if 0
    dti_changeMatrix('run','LF','atlas_lut.txt','MF','connectome_di_sy.csv','path',fullfile(pwd,'dat'),'COI',fullfile(pwd,'reducedCONS.xlsx'))
end
if iscell(r)
    if isstruct(r{1})
        r=r{1};
    else
        r=cell2struct(r(2:2:end),r(1:2:end),2);
    end
end

%% ===============================================
s=struct();

 [files] = spm_select('FPListRec',r.path,'^connectome_di_sy.csv$');
 mfiles=cellstr(files);
 if isempty(char(mfiles)); 
     disp('matrix-files (MF) such as "connectome_di_sy.csv" not specified...');
     return
 end
  [file] = spm_select('FPListRec',r.path,'^atlas_lut.txt$');
 lfile=cellstr(file);
 lfile=lfile{1};
 if isempty(char(lfile)); 
     disp('LUTfile-files (LF) such as "atlas_lut.txt" not specified...');
     return
 end
 s.files=    mfiles;
 s.labelfile =lfile;
 if isfield(s,'suffix')==0   ; s.suffix='_reduction1'; end
 if isfield(s,'outdir')==0   ; s.outdir='same'       ; end

 
 hf=findobj(0,'tag','modmattrix');
 if isempty(hf)
     dti_changeMatrix();
     hf=findobj(0,'tag','modmattrix'); set(hf,'visible','off');
     
 end
 c=getData([],[],s);
 if isfield(c,'mousename');   s.mousename   = c.mousename; end
 if isfield(c,'mat');         s.mat         = c.mat; end
 if isfield(c,'label');       s.label       = c.label; end

 if isfield(r,'COI');        
     s.keeplabels       = r.COI;
     s.type             ='excelfile';
 end 
 
%  s
% 's'
 changematrix(s);
 delete(findobj(0,'tag','modmattrix'));

%% ===============================================

function changematrix(s)

% ==============================================
%%   mandatory inputs: example
% ===============================================

%           type: 'excelfile'
%     keeplabels: 'F:\data6\DTI_thomas_reduceMatrix\reduced.xlsx'
%          files: {26x1 cell}
%      mousename: {1x26 cell}
%            mat: [64x64x26 double]
%          label: {64x1 cell}
%      labelfile: 'f:\data6\DTI_thomas_reduceMatrix\dat\2022092…'
%         suffix: '_REDUCED1'
%         outdir: 'same'
% 
% ==============================================
%%   
% ===============================================


% for i=1:length(s.keeplabels)
if strcmp(s.type,'excelfile')
    [~,~,a0]=xlsread(s.keeplabels);
    a=a0;
    ha=a(1,:);
    a =a(2:end,:);
    if numel(a)==0
       msgbox({'COIFILE-error:' char(10) 'check excel-sheet: 1st sheet is empty (data expected)!'}) ;
       return
    end
    %% ===============================================
    %scenario-THOMAS: somebody used the excelfile from DTI-output and used those connections (A--B; C--D) in
    %reduced form, such as:
%         'R_Field_CA1--L_Field_CA1'      [1]
%         'R_Field_CA3--L_Field_CA1'      [1]
%         'R_Field_CA3--L_Ammons_ho…'     [1]
    if length(regexpi2(a(:,1),'--'))~=0
        a(:,2)=cellfun(@(a){[num2str(a)]} ,a(:,2) );
        a(:,2)=regexprep(a(:,2),'\s+','');
        iuse=regexpi2(a(:,2),'^1$');
        if isempty(iuse);
            a(:,2)=repmat({'1'},[size(a,1) 1]);
        end
        a(  find(cell2mat(cellfun(@(a){[isempty(a)]} ,a(:,1) ))) , : )=[]; %del empty ROWs
        a=a(regexpi2(a(:,2),'^1$'),:); %keep only those connections that were indicated by [1]
        
        a(:,2)=(cellfun(@(a){[str2num(a)]} ,a(:,2) )) ;%back to numeric
        %-----split into convential COI-file
        %as=regexp(a(:,2), '--','split')
        as={};
        for i=1:size(a,1)
            as(i,:)=strsplit(a{i,1},'--');
        end
        as(:,3)=a(:,2);
        %----overwrite vars
        ha={'connectionA' 'connectionB' 'COI'};
        a=as(:,1:3);  
    end


    
    
    %% ===============================================
    
    
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
% % elseif strcmp(s.type,'select')
   
elseif strcmp(s.type,'select&merge')  
    
    %keyboard
    %% ===============================================
    d0=s.mat;
    tb=s.keeplabels;
    ikeep=cell2mat(tb(:,1));
    %l=s.label
    
    
    d1=d0(ikeep,ikeep,:); %reduze matrix to used regions

    for i=1:size(d1,3) %LOOP OVER 3rddim (animals)
        [dx tb2 in]=mergeDTImatrix(d1(:,:,i),tb, 0);
        if i==1
            d2=zeros( [size(dx)  size(d1,3)] ); %PREALLOC
        end
        d2(:,:,i)=dx;
    end
    
    
    v.mat  = d2;
    v.label= tb2(:,2);
    

     %% =============================================== 
     % save merging-table
     q=questdlg({'OPTIONAL: Save selected DTI-mergingTable?' ...
         '--can be used for sanityChecks or modifed and used as merging input'}, ...
         'save merging table', ...
         'YES','NO','YES');
     if strcmp(q,'YES')
        [fi pa] =uiputfile(fullfile(pwd,'merginTable_.xlsx') , 'save mergingTable as...');
         if ~isnumeric(fi)
             F_mergTable=fullfile(pa,fi);
             %% ----
             htt={'ID'    'Region'    'included'    'sameClusterID'    'DonorCLUSTERLabel'};
             u=get(gcf,'userdata');
             
             tt=[u.labelID u.label ...  %make full-table
                 repmat({''},[length(u.label) 1]) ...
                 repmat({''},[length(u.label) 1]) ...
                 repmat({''},[length(u.label) 1]) ...
                 ];
             tin=[tb(:,1:2)   repmat({'1'},[size(tb,1) 1])   tb(:,3) ]; %add: included colum
             
             %donator-label
             tin(:,5)=repmat({''},[size(tb,1) 1]) ;
             tin(find(cell2mat(tb(:,4))),5)={'1'} ;
             
             tt(ikeep,:)=tin;%insert table in the included column
             
             
             %% ----
             htt={'ID' 'Region', 'MergingCluster' 'ClusterName'};
             pwrite2excel(F_mergTable,{  1 'mergingTableDTI'}, htt,[],tt);
             showinfo2(['mergingTableDTI: '],F_mergTable) ;
             
             
    
             
         end
         
     end
     
    
    %% ===============================================
    
    
    
else
    idx=find(ismember(s.label,s.keeplabels));
    v.mat  =s.mat(idx ,idx,:);
    v.label=s.label(idx);
    
end

% disp(v);
% ==============================================
%%   Label
% ===============================================
%w=textread(s.labelfile,'%s')
[q1 q2 q3 q4 q5 q6]=textread(s.labelfile,'%s\t%s\t%s\t%s\t%s\t%s');
w=[q1 q2 q3 q4 q5 q6];

s.preserveIDs=1; 

lut=[];
for i=1:length(v.label)
    tp=w(find(strcmp(w(:,2),v.label{i})),:);
    if s.preserveIDs==0
        tp{1}=num2str(i);
    end
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
        
        %---write checkFile
        if strcmp(s.type,'select&merge')
            nameout=fullfile(pa, ['CHK_' name  '_' s.suffix  '.dat'] );
            
            hTT={'ID' 'Region', 'MergingCluster' 'ClusterName'};
            % ____WRITE CSF_________
            %TT=cell2table(tb,'VariableNames',hTT);
            %writetable(TT,nameout,'filetype','text');
            
            % ____WRITE PLAIN-TXT_________
            tx=cellfun(@(a){[  num2str(a)]} ,tb);
            tx(:,3)=regexprep(tx(:,3),'^$','0','emptymatch'); %rempve empty cells
            TT=plog([], [hTT;tx],0,'','s=1;plotlines=0');
            pwrite2file(nameout ,TT );
            
            showinfo2(['     CHECK-->'],nameout) ;
            
            %-----CHECK READ FILE AGAIN
            if 0
                q=preadfile(nameout); q=q.all;
                %q=importdata(nameout)
                q2 = cellfun(@(a) strsplit(a,' ')',q,'UniformOutput',false);
                q2 = [q2{:}]';
                q2(:,1)=[];
            end
            %-----
            
        end
        
    end
    
end
       







function pb_saveCOI(e,e2)

us=get(gcf,'userdata');

%% coi-type
ht=findobj(gcf,'tag','COItype');
if ~isempty(strfind(ht.String{ht.Value},'connection-wise'))
    COItype=1;
elseif ~isempty(strfind(ht.String{ht.Value},'region-wise'))
    COItype=2;
elseif ~isempty(strfind(ht.String{ht.Value},'mergeRegions'))
    COItype=3;
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
elseif  COItype==3
    %% ===============================================
    
    cprintf([0 0 1],['..prepare data....\n']);
    
    
    htb={'ID' 'Region' 'included' 'sameClusterID'   'DonorCLUSTERLabel'};
    col_strEmpty=repmat({''},[ length(us.label) 1]);
    col_empty   =repmat({[]},[ length(us.label) 1]);
    tb=[us.labelID us.label col_empty col_strEmpty  col_empty];
    
    pwrite2excel(filename,{  1 'mergingRegions'}, htb,[],tb);
    xlsremovdefaultsheets(filename)
    showinfo2(['mergingRegions_BLANKO: '],filename) ;
    
    
    %% ===============================================
    
    msg={['INFO-columns:']
        ['ID: id of the region.........PLEASE do not change this !' ] 
        ['Region: name of the region...PLEASE do not change this!' ]
        ''
        ['included: should this region be included in analysis?:' ]
        ['  -enter: numeric value 1 if the region should be included in analysis ' ]
        ['  -leave empty if this region never occurs in the analysis ' ]
        ['  -Regions that should be merged (combined) must obtain the value 1 here !!! ' ]
        ''
        ['sameClusterID:  enter the same(!) numeric value for regions that should be merged ' ]
        '   -regions with the same value will be merged! (but must be also set in the "included"-column )'
        '   -leave empty for those regions that should not be merged'
        '   -IMPORTANT: clusters for left and right hemispheric regions must obtain different values here '
        '    otherwise left and right clusters will be merged'
        '      Example: say you want to obtain two merged clusters: "left vis. cortex" & "right vis. cortex" '
        '       -for this you have to give all visual regions for the left cortex a clusterID of "1" while '
        '        all visual regions of the right cortex obtain a clusterID of "2" (or any other string but not "1")'
        ''
        ' DonorCLUSTERLabel: For each Cluster specify one (!) labelDonator.       '
        '       -In the above example the left and right V1-areas could be the labelDonator for the respective Clusters  ' 
        '       -just enter a numeric value "1" here for the region which is the label-donator for a respective cluster'
        '       -do not enter several regions as labelDonators for the SAME cluster'        
        '       -leave empty for regions which belong to no cluster (not specified in "sameClusterID" )'
        '       -Reason for "DonorCLUSTERLabel": (1) give the cluster a label (2) preserve label and with this'
        '          preserve atlas coordinates of this label...might be useful for displaying the result'
        };
    try
      xlsinsertComment(filename,msg, 1, 1, 6);
    end
    %% ===============================================
    
end


cprintf([0 .5 0],['Done.\n' ]);
disp(['COIfile blanko: <a href="matlab: system('''  [filename] ''');">' [filename] '</a>']);






