




%% #b statistic on anatomical labels
% for each anatomical label statistically compare two groups regarding a region-related parameter 
%• currectly implemented statistic:
%      [for TWO-INDEPENDENT-GROUPS] : 'ttest2' (two sample t-test)
%                                     or 'RST' (Wilcoxon Rank sum test (non-parametric))
% • PREREQUISITES:
%      - groups have to be defined via excel-file, see below
%      - normalization and anatomical labeling was performed (another excelfile containing parameters
%        for each anatomical region and mouse)
% _______________________________________________________________________________________
% #by  EXCELFILE (group definition)
% The excelfile must have a sheet with a column containing the mousefolder names (corresponding to ANT-mouse-folders)
% and a corresponding column with numeric group assignments (a number that defines group-membership).
% #g EXAMPLE EXCELSHEET:
% -note that a header in the excelsheet is allowed as long as the header-name of the group-column is non-numeric
% column-4                   column-5
% s20141009_07sr_1_x_x         1
% s20141009_11sr_1_x_x         1
% s20141098_12sr_1_x_x         2
% s2014109_02sr_1_x_x          2
% s2014109_08sr_1_x_x          3
% s2014109_09sr_1_x_x          3
% s2014109_10sr_1_x_x          3
% s20141217RosaHD52eml_1_x_x   3
% --> here column-4 contains the mousefolders and column-5 (group-column) represents the group-membership
% --> the columns can be arbitrarily located in the excelsheet (this will be specified in the gui)
% --> note that group-column can contain more than two "group"-ids: this allows to:
%       (a) statistically compare different groups (subsequently) and
%       (b) pool subgroups, example: pool group-1 & group-2 and compare this with group-3
% _______________________________________________________________________________________
%
%% #by  GUI PARAMETERS  
%%  *GROUPS*
% groupfile     =  'O:\group.xlsx'; % EXCELFILE that specifies the groups (see above)
% sheetno       =  [2]; % specify sheet number or sheet-name (here, 2nd sheet)
% foldercolumn  =  [4]; % specify the column that contains the mouse-folder-names (here 4th column)
% groupcolumn   =  [3]; % specify the column that contains the group-membership (here 3rd column)
%
% groupIDs      =  [1 2]  % specify the groups to compare (here, group-1 is compared against group-2)
% #r alternative TO COMPARE POOLED SUBGROUPS:
% groupIDs      =  {'1 2' '3 4 5' };  % here group-A (subject-IDS 1&2) is compared with group-B(subjects 3&4&5)
%
%%  *PARAMETERS*
% labelfile    = 'O:\results\labels_Both_04Jan2017_13-09-01.xls' ; % EXCELFILE that contains the parameters and anatomical labels for each mouse 
% parameter'   = 'mean'   ; % parameter to read out (e.g. "mean"),   others : 'percOverlapp' 'vol' 'volref' 'mean' 'std' 'median' 'min' 'max'
% method       = 'ttest2' ; % statistic to perform ' use 'ttest2' (two sample t-test) or 'RST' (Wilcoxon Rank sum test (non-parametric))
% sortresult   = 1        ; % sort labels according p-values (ascending order)
% 
%% *SAVE RESULTS*
% saveresult   = 1 ; % '0/1: save Results; (0) display only,(1) yes, save results (standard target folder: "Results"-folder')
% savename     = ''; % NOTE: if "saveresult" is 1, you can speicify an alternative file-output-name:  
%                    % if "savename" contains a valid path, the file with the name specified in "x.savename" is written to this path,
%                    % if "savename" contains a "pathless"-filename, the file with name specified in "savename" is written to the "Results"-folder 
%                    % if "savename" is empty (default), a file with dynamic filename is saved in the "Results"-folder 
%                    % .. "dynamic" means here: the filename contains the investigated parameter, the used statistical test and the compared groups
% _______________________________________________________________________________________
%
%% #by RUN-def:
% xstat_anatomlabels(1) or  xstat_anatomlabels    ... open PARAMETER_GUI
% xstat_anatomlabels(0,z)             ...NO-GUI,  z is the predefined struct
% xstat_anatomlabels(1,z)             ...WITH-GUI z is the predefined struct
%
%% #by BATCH-EXAMPLE
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% BATCH:        [xstat_anatomlabels.m]
%% descr: statistic on anatomical labels
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% z=[];
% z.groupfile='O:\data\karina\MRTgroups.xlsx';  % EXCELFILE with GROUPING DEFINITION
% z.sheetno       =[2];    % sheet-No 2
% z.foldercolumn  =[4];    % 4th column with mouse-folder-names
% z.groupcolumn   =[3];    % 3rd column assigns with mouse belongs to which group
% z.groupIDs      =[1  2]; % test group "1" vs group "2"
% z.labelfile     ='O:\data\karina\results\labels_Both_04Jan2017_13-09-01.xls'; % EXCELFILE with ANATOMICAL LABELS
% z.parameter     ='mean';   % PARAMETER TO test (here "mean" value for each anatomical label)
% z.method        ='ttest2'; % sttistical test applied, here 2-sample ttest (ttest2)
% z.sortresult    =[1];      % yes, sort results accord. p-values
% z.saveresult    =[1];      % yes, save results ..
% z.savename      ='';       % .. with a predifined filename
% xstat_anatomlabels(1,z);   % run this function, but with open GUI
%
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace, or type "uhelp(anth)"
%
%




function xstat_anatomlabels(showgui,x,pa)



%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getallsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%———————————————————————————————————————————————
%%   %% test SOME INPUT
%———————————————————————————————————————————————


%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• Anatomical labels - Statistic   •••'                         '' ''
    'inf2'      'prerequisites: (1) normalization and (2) anatomical labeling (excelfile with parameters for each region) was performed in mice,  '   '' ''
    'inf3'      '               (3) an additional excelfile must exist to specify the subgroups (see below)'                                          '' ''
    'inf10'      [repmat('—',[1,100])]                            '' ''
    
    'inf100'  '% *GROUPS*' '<< which mouse belongs to which group' ''
    'groupfile'     ''        'EXCELFILE-FILENAME(group): with (1) a column with mouse-folders (ANT short names) and (2) column with group-assignment (numeric)'  {'f'}
    'sheetno'        2        'NUMBER/ID or name of the excelsheet where mouse-folders and group-assignment is stored'            ''
    'foldercolumn'   4       'specify the column with mouse-folder-names(id; such as "1" for first column) '  ''
    'groupcolumn'    3       'specify the column with group assignment (id; such as "2" for 2nd column)'      ''
    'groupIDs'      [1 2]     'group IDs, which will be read out from groupcolumn (example: "[1 2]" will assign all mousefolders with groupID-1 to group-1 and groupID-2 to group-2)' ''
    'inf120'       '     '         '                    % NOTE: for pooling subgroups, see help of this function' ''   %  groupIDs: to pool subgroups use cellstring-mode (example: groupIDs is "{''''''1 2 3''''''  ''''''4 5''''''}" assigns subgroups 1,2 and 3 to group-1 and subgroups 4 and 5 to group-2)'  ''
    
    'inf200'  '% *PARAMETERS*' '' ''
    'labelfile'     ''        'EXCELFILE-FILENAME(anatomical labels): this file contains parameters and anatomical labels for each mouse'  {'f'}
    'parameter'     'mean'    'parameter to read out (e.g. "mean")'  {'percOverlapp' 'vol' 'volref' 'mean' 'std' 'median' 'min' 'max'}
    
    
    'method'     'ttest2'    'statistic to perform ' {'ttest2'  'RST'}
    'sortresult' 1           'sort labels according p-values (ascending order)'     'b'
    
    'inf300'  '% *SAVE RESULTS*' '' ''
    'saveresult'  0                 '0/1: save Results; (0) display only,(1) yes, save results in "Results"-folder'     'b'
    'savename'    ''                '(optional), will override the dynamically created filename (saves in "Results-folder"), but only if saveresult is "1"!!!'   ''
    };

% corrmeth={'none' 'FWE' 'FDR'};
% thresh  =0.05;
% extent  =0  ;%spatial clusterSize

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .6 ],...
        'title','***','info',hlp);
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end





%% [A] estimate model &  make thresholded image
%% read from excel
if isempty(z.groupfile); return ; end
v=readgroupfile(z);
v=readanatomlabel(v,z);
v=dostats(v,z);
makebatch(z);





%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••  SUBS ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function v=dostats(v,z)

%WICOXON RANK_SUM_TEST
if strcmp(z.method,'RST')
    s=[];
    p     =nan(1,size(v.d1,1));
    h     =p;
    s.tg  =p;
    s.tgname='WRST';
    for i=1:size(v.d1,1)
        try
            [p0,h0,s0]  = ranksum(v.d1(i,:),[v.d2(i,:)]);
            p(1,i)=p0;
            h(1,i)=h0;
            s.tg(1,i)=s0.ranksum ;
            %         catch
            %             p(1,i)=nan;
            %             h(1,i)=nan;
            %             s.tg(1,i)=nan;
        end
    end
    s.df=nan(size(s.tg));
    
elseif  strcmp(z.method,'ttest2')
    %TTEST
    s=[];
    [h,p,ci,s] = ttest2(v.d1',v.d2');
    s.tg    =s.tstat;
    s.tgname='tstat';
end

%% alpha
% ivalid=find(s.df>0);
ivalid=find(~isnan(s.tg));

h=h(:);
h(isnan(h))=0;
%% FDR
[h2, crit_p, adj_ci_cvrg, adj_p]=fdr_bh( p(ivalid)   ,.05,'pdep','yes'); %FDR
hfdr=zeros(size(h));
hfdr(ivalid)=h2;
%% BONFERONI
hbon=zeros(size(h));
hbon(ivalid)=p(ivalid)<0.05/length(p(ivalid));

t=[ s.df' s.tg' p' h hbon hfdr];
txh={'label' 'df' s.tgname 'p' 'H' 'Hbonf' 'Hfdr'};
tx=[v.aaa(v.labid,1)  num2cell(t)];
%% sort
if z.sortresult==1
    tx2=sortrows(tx,4);
else
    tx2=tx;
end



%% additional infos
infox={' #by ANATOMICAL LABELING : STATISTIC '};
infox{end+1,1}=['TEST          : ' v.grouptag{1} ' vs ' v.grouptag{2}] ;
infox{end+1,1}=['Group-sizes   : [' [ num2str(length(v.f1))  '  ' num2str(length(v.f2))  ] ']' ];
infox{end+1,1}=['N-tests       : ' num2str(size(h,1))];
infox{end+1,1}=['Parameter     : ' char(z.parameter)];
infox{end+1,1}=['Method        : ' char(z.method)];
infox{end+1,1}=['Sorted-results: ' num2str(z.sortresult)];
infox{end+1,1}=['..SourceFile  : ' char(z.groupfile)];
infox{end+1,1}=['______________________________________'];

infox{end+1,1}=['uncor. ntests survived   : ' num2str(nansum(h))];
infox{end+1,1}=['Bonferoni p-crit         : ' num2str(0.05/length(p(ivalid)))];
infox{end+1,1}=['Bonferoni ntests survived: ' num2str(length(find(hbon~=0)))];
infox{end+1,1}=['FDR  p-crit              : ' num2str(crit_p)];
infox{end+1,1}=['FDR  ntests survived     : ' num2str(length(find(hfdr~=0)))];
% disp(char(infox));

%% show results
% uhelp(plog([],[txh;tx2],0,'','s=0'),1);
pl=[infox; plog([],[txh;tx2],0,'','s=0','d=5')];
drawnow;
uhelp(pl,1,'fontsize',5);
drawnow;

if z.saveresult==1
    global an
    paout=fullfile(fileparts(an.datpath),'results\AnatLabelStat');
    mkdir(paout);
    fout=...
        ['AL_'  upper( char(z.method)) '_' 'para{' char(z.parameter) '}' '_' v.grouptag{1} 'vs' v.grouptag{2}];
    
    if ~isempty(z.savename)
        [pax fi ext]=fileparts(z.savename);
        if ~isempty(pax)
            if exist(pax)==7
                paout=pax;
            end
        end
        if ~isempty(fi)
            fout=fi;
        end
    end
    
    outfile=fullfile(paout,[fout '.txt']);
    pwrite2file(outfile,pl)
    disp(['AL-statistic-File: <a href="matlab: explorerpreselect(''' outfile ''')">' outfile '</a>'  ]);
    

end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% #b descr:' hlp];
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; 'z=[];' ];
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '};{'                '}];
assignin('base','anth',v);
disp(['BATCH: <a href="matlab: uhelp(anth,1,''cursor'',''end'')">' 'show history' '</a>'  ]);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


function v=readgroupfile(z)
[a aa aaa]=xlsread(z.groupfile,z.sheetno);

names   = aaa(:,z.foldercolumn);
names   = regexprep(names,'\s','')  ;%remove white space
group   = aaa(:,z.groupcolumn);

%remove header and rows containing strings
idel=find(cellfun(@isnumeric,group)==0);
names(idel)=[];
group(idel)=[];
group=cell2mat(group);

if isnumeric(z.groupIDs)
    g1=names(find(group==z.groupIDs(1)));
    g2=names(find(group==z.groupIDs(2)));
    v.grouptag  ={num2str(z.groupIDs(1)) num2str(z.groupIDs(2))};
else  %multiple subgroups defined in one group
    idg1= str2num(z.groupIDs{1});
    idg2= str2num(z.groupIDs{2});
    g1={};g2={};
    for i=1:length(idg1)
        g1=[g1 ; names(find(group== idg1(i)  )); ];
    end
    for i=1:length(idg2)
        g2=[g2 ; names(find(group== idg2(i)  )); ];
    end
    
    v.grouptag{1,1}= ['{' regexprep(z.groupIDs{1},'\s',',') '}' ];
    v.grouptag{1,2}= ['{' regexprep(z.groupIDs{2},'\s',',') '}' ];
end

v.g1=g1;
v.g2=g2;
v.group=group;
v.names=names;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function  v=readanatomlabel(v,z)
[a aa aaa]=xlsread(z.labelfile,[ '' z.parameter ''])  ;

head=aaa(1,:)';
[id1 id2]=deal([]);
for i=1:size(v.g1,1)
    id1=[id1; find(strcmp(head,v.g1{i})) ];
end
for i=1:size(v.g2,1)
    id2=[id2;find(strcmp(head,v.g2{i}))];
    %     v.g2{i}
    %     find(strcmp(head,v.g2{i}))
end

labid=9:size(aa(:,1),1);
v.labid =labid  ;%range of anat.labels in labelfile [if necessary]
v.aaa   =aaa; % data [if necessary]

v.id1=id1;   %id of valid folders
v.id2=id2;

d1= aaa(labid,id1)   ; %data
d2= aaa(labid,id2)   ;
d1=cell2mat(d1);
d2=cell2mat(d2);
v.d1=d1;
v.d2=d2;

v.f1=head(id1);%foldernames, valid one
v.f2=head(id2);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

