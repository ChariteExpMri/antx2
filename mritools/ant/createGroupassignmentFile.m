% create group-assignment file (excel-file)
% group-column has to be specified manually afterwards
% this groupassigment file can be used for voxel-wise statistic or dtistatistic
% #wb ___PARAMETER___
% 'groupfile'      name of the groupassignment-file (excelfile), DEFAULT: 'groupassignment.xlsx' 
% 'outdir'         output-directory where 'groupfile' is stored, default: "group"-dir located in the current study-folder'  
% 'stat'           statistical model:
%                     'unpaired'          :two-sample-ttest
%                     'paired'            :paired-sample-ttest
%                     'regression'        :single/multi-regression
%                     '1xANOVA'           :1-way ANOVA for independent groups
%                     '1xANOVAwithin'     :within 1-way ANOVA (dependent groups, such as time-points)
%                     'fullfactorialANOVA':independent groups, several factors A,B,(C), each with levels                   
% 'addTimeStamp'    0                       'add timestamp as suffix to the groupfile-name {0|1}'        'b'
% 'addComment'      1                       'add excel-comment with additional information {0|1}'        'b'
% 'NIFTI'             <optional> you can specify one/more potential NIFTIfile(s)
%                      If specified, the existence of those file(s) is checked across animal-folders and
%                      respective columns are written to the excelfile indicating whether the image exists
%                     -this might be usefull to find missing files before running voxelwise statistic using
%                      the filled groupassignment file. In case of missings, the groupassignment file has to be pruned
%                     -multiple file selection possible, default: empty
% 'NIFTI_write2column' if the 'NIFTI' parameter is specified, this value indicates the starting column-index in excel-file
%                       where the existence of NIFTI(s) is written to: default: 10  (i.e column-10)
% 
%
%
%% EXAMPLE: with GUI
% createGroupassignmentFile(1)
% or
% f1=createGroupassignmentFile(1,z);  % where f1 is the createx excel-file

%% EXAMPLE: with GUI and predefinitions
%% create exelfile for 'unpaired' (two-sample-ttestwithin-one-way-ANOVA) statistic.
% z=[];                                                                                                                                                                                        
% z.groupfile          = 'groupassignment.xlsx';     % % name of the groupassignment-file (excelfile)                                                                     
% z.outdir             = 'F:\data6\voxwise\groups';        % % output-directory: default "group"-dir in current study-dir                                                       
% z.stat               = 'unpaired';                                 % % statistical group-scenario (unpaired|paired|regression|1xANOVA|1xANOVAwithin|fullfactorialANOVA)                 
% createGroupassignmentFile(1,z);
% 
%% EXAMPLE: with GUI and predefinitions
%% create exelfile for within-one-way-ANOVA. Additionally, the files 'svimg.nii' & 'vimg.nii'
%% are checked for each animal and the stored in the excelsheet (starting with column-12)
% z=[];                                                                                                                                                                                        
% z.groupfile          = '_test__groupassignment_1xANOVAwithin.xlsx';     % % name of the groupassignment-file (excelfile)                                                                     
% z.outdir             = 'F:\data6\voxwise\groupassignment_tests';        % % output-directory: default "group"-dir in current study-dir                                                       
% z.stat               = '1xANOVAwithin';                                 % % statistical group-scenario (unpaired|paired|regression|1xANOVA|1xANOVAwithin|fullfactorialANOVA)                 
% z.addTimeStamp       = [0];                                             % % add timestamp as suffix to the groupfile-name {0|1}                                                              
% z.addComment         = [1];                                             % % add excel-comment with additional information {0|1}                                                              
% z.NIFTI              = { 'svimg.nii'                                    % % check existence of potential NIFTIfile(s) in animal-folders;multiple file selection possible, default: empty     
%                          'vimg.nii' };                                                                                                                                                       
% z.NIFTI_write2column = [12];                                            % % starting column-index in excel-file where existence of NIFTI(s) is written to                                    
% createGroupassignmentFile(1,z); 
% 
%% EXAMPLE: EXTERNAL mdirs, NO GUI and predefinitions
%% create exelfile for 'paired statistic (paired-sample-ttest)
% padat='F:\data6\voxwise\dat';
% mdirs=antcb('getsubdirs', padat);
%
% z=[];
% z.groupfile    = 'groupassignment3.xlsx';       % % name of the groupassignment-file (excelfile)
% z.outdir       = 'F:\data6\voxwise\group3';     % % output-directory: default "group"-dir in current study-dir
% z.stat         = 'unpaired';                    % % statistical group-scenario (unpaired|paired|regression|1xANOVA|1xANOVAwithin|fullfactorialANOVA)                                   
% z.addTimeStamp = [1];                           % % add timestamp as suffix to the groupfile-name
% createGroupassignmentFile(0,z,mdirs);

function f1=createGroupassignmentFile(showgui,x,mdirs)


f1=[];

%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end

% if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%———————————————————————————————————————————————
%%   ant-animal-dirs
%———————————————————————————————————————————————
isExtPath=0; % external path
if exist('mdirs')==0      || isempty(mdirs)      ;
    antcb('update')
    global an;
    pa=antcb('getallsubjects')  ;
    padat=an.datpath; %backup if dat-folde ris empty
else
    pa=cellstr(mdirs);
    isExtPath=1;
    padat=fileparts(mdirs{1});
end


outir=fullfile(fileparts(padat),'group');

stats={
    'unpaired'
    'paired'
    'regression'
    '1xANOVA'
    '1xANOVAwithin'
    'fullfactorialANOVA'
    };

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'groupfile'      'groupassignment.xlsx' 'name of the groupassignment-file (excelfile)' ''
    'outdir'          outir                 'output-directory: default "group"-dir in current study-dir' 'd'
    'stat'           'unpaired'             ['statistical group-scenario (' strjoin(stats,'|') ')' ]  stats
    'addTimeStamp'    0                       'add timestamp as suffix to the groupfile-name {0|1}'        'b'
    'addComment'      1                       'add excel-comment with additional information {0|1}'        'b'
    'inf1' '' '' ''
    'inf2' 'OPTIONAL' '' ''
    'NIFTI'                ''   'check existence of potential NIFTIfile(s) in animal-folders;multiple file selection possible, default: empty' {@selectNIFTIS, padat}
    'NIFTI_write2column'   12   'starting column-index in excel-file where existence of NIFTI(s) is written to ' {10,5,3}
    };


p=paramadd(p,x);%add/replace parameter
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.2687    0.3656    0.4625    0.2233],...
        'title',['create group assignment excel-file [' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end


% ==============================================
%%   proc
% ===============================================
cprintf('*[0 .5 0]',['.. create group-assignment file (type: ' z.stat ') ...wait' '\n']);
f1=proc(z,pa);
cprintf('*[0 .5 0]',['Done!' '\n']);



% ==============================================
%%   snip_createGroupassignmentFile
% ===============================================
function f1=proc(z,pa);

%% ===============================================
paout=z.outdir;                     %___make DIR
if exist(paout)~=7
    mkdir(paout);
end
[~,fis,ext]=fileparts(z.groupfile) ;%___add timeStamp
if z.addTimeStamp==1
    fileshort=[fis '__' regexprep(datestr(now),{'-',' ',':'},{'','_',''}) '.xlsx'];
else
    fileshort=[fis  '.xlsx'];
end

f1=fullfile(paout,fileshort);

%----animal-table
[pax, animals]=fileparts2(pa);
hb={'animal' 'group'};
b=[animals repmat({''},[length(animals) 1])];
if strcmp(z.stat,'regression')
    hb={'animal' 'regresssionValues'};
    b=[animals repmat({''},[length(animals) 1])];
elseif strcmp(z.stat,'fullfactorialANOVA')
    hb={'animal' 'factorA' 'factorB'};
    b=[animals repmat({''},[length(animals) 2])];
end


%% ============[add columns if NIFTIs should be checked]===================================
if isfield(z,'NIFTI')
    if ~isempty(char(z.NIFTI))
        z.NIFTI=cellstr(z.NIFTI);
        
        isexist=zeros(length(pa),length(z.NIFTI));
        for i=1:length(z.NIFTI)
            isexist(:,i) =existn(stradd(pa,[filesep z.NIFTI{i}],2));
        end
        isexist(isexist==2)=1; %convert to [1] from [2]-exist code
        isexist=num2cell(isexist);
        
        icol2write=z.NIFTI_write2column;%10;
        if isempty(icol2write)
            icol2write=10;
        end
        ivec=(icol2write:icol2write+size(isexist,2)-1);
        
        %hb(ivec)=z.NIFTI2check(:)';
        hb(ivec)=stradd(z.NIFTI(:)','[EXIST]',1);
        b(:,ivec)=isexist;
        
    end
end



%% ============[write xls-file]===================================
try;  delete(f1); end
pwrite2excel(f1,{1 'group'},hb,{},b);


% ==============================================
%%   add comment
% ===============================================
cm2={'MISSING VALUES'
    'This sheet can be used for the VOXELWISE STATISTIC as group-assignment file.'
    'However, voxwise statistic with missing data was not fully checked'
    'Thus,it is recommended to remove animals with missing data (i.e entire row) from this sheet'
    'if the analysis-image or ,if used, covariate-values are missing for those animals'
    'NOTE: for "WITHIN 1-WAY-ANOVA" and "paired-sample-t-test" all repeated entries of the same'
    '      animal must be removed (respective rows) in case of missing data'};

if z.addComment==1
    xlsinsertComment(f1,cm2, 1, [3], 5 ,[0.9843    0.9373    0.8667]);
end

%% ============[add modell-specific comment]===================================



col=[0.7569    0.8667    0.7765   %green   -unpaired
    0.9255    0.8392    0.8392   %pink    -paired
    0.7294    0.8314    0.9569   %blue    -regression
    0.7490         0    0.7490   %fuchsia -1xAnova independent
    0.9294    0.6941    0.1255   %brown   -within-1xAnova dependent
    0.9059    0.9059    0.9059   %gray    -fullfactorialANOVA
    ];
if 0
    fg,imagesc(1:5); colormap(col)
end

if strcmp(z.stat,'regression')
    cm2={...
        'STATISTICAL SCENARIO: REGRESSION'
        'please add the values in the "regresssionValues"-column'
        '___ For voxelwise statistic ___:'
        '"HEADER": please give the "regressionValues"-header a usefull name'
        'use underscores (avoid spaces) & avoid special characters'
        'FOR MULTIPLE REGRESSION: JUST ADD ADDITIONAL COLUMNS RIGHT TO THE "regresssionValues"-column'
        '                       : DONT FORGET TO rename the header of the addiontla regression-columns'
        '  Example: to insert three regression-variables (age,temperature, weight):'
        '  the header might look as follows (4 columns)'
        '            [animal]    [age] [bodyTemperature] [bodyWeight]'
        '            animal_01    10       36              20.5      '
        '            animal_02    10.5     37              19        '
        '            animal_03     9.5     36.5            21.2       '
        '..etc'
        'Use NUMERIC VALUES for regression-columns!'
        'Note that the header-names will be used for voxelwise statistic!'
        ''
        };
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 5,col(3,:));
    end
elseif strcmp(z.stat,'fullfactorialANOVA')
    cm2={...
        'STATISTICAL SCENARIO: FULLFACTORIAL ANOVA (independent groups)'
        'Please fill the columns of [factorA] and [factorB]:'
        'use underscores (avoid spaces) & avoid special characters'
        'you can also add a [factorC] next to the [factorB]-column.'
        'If you like, you can change the name of the  header, i.e. rename the factor-names '
        '"factorA" and "factorB" to something more usefull (without quoation marks)'
        'COVARIATES (optional):'
        'Right to the last [factor]-column you can insert single/multiple covariate-columns'
        'When using covariates: please give the covariate(s) (header) usefull name(s)'
        'keep header-names (factors, covariates) short, use underscores, avoid spaces and special characters'
        'Note that the factor-names, factor-level names and covariate-names will be used for voxelwise statistic!'
        ''
        };
    
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 5,col(6,:));
    end
    
elseif strcmp(z.stat,'unpaired')
    cm2={...
        'STATISTICAL SCENARIO: UNPAIRED/INDEPENDENT GROUPS (two-sample-t-test)'
        '[group]-column: please specify which animal belongs to which group'
        'use strings as group-names (example: "control" "drugA" ..without quoation marks)'
        'use underscores (avoid spaces) & avoid special characters'
        'example: "control" for "control"-animals; "ABC" for animals from "ABC-group" (without quoation marks)'
        'COVARIATES (optional):'
        'Right to the [group]-column you can insert single/multiple covariate-columns'
        'When using covariates: please give the covariate(s) (header) usefull name(s)'
        'keep covariates-names short, use underscores, avoid spaces and special characters'
        'Note that group-names in group-column and covariates-names will be used for voxelwise statistic!'
        ''
        };
    
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 3,col(1,:));
    end
    
elseif strcmp(z.stat,'paired')
    cm2={...
        'STATISTICAL SCENARIO: PAIRED/DEPENDENT GROUPS (paired-sample-t-test)'
        'group-1 and group-2 must have the same length'
        '[group]-column: please specify which animal belongs to which group'
        'use strings as group-names (example: "time1" "time2" ..without quoation marks)'
        'use underscores (avoid spaces) & avoid special characters'
        'IMPORTANT: for pairwise tests it is assumed that:'
        'the 1st animal of group-1 corresponds to the 1st animal of group-2 (i.e is the same animal)'
        'the 2nd animal of group-1 corresponds to the 2nd animal of group-2 (i.e is the same animal)'
        'the 3rd animal of group-1 corresponds to the 3rd animal of group-2 (i.e is the same animal)'
        'etc...'
        'PLEASE CHECK THE CORRESPONDENCE OF The Animals!!! '
        'COVARIATES (optional):'
        'Right to the [group]-column you can insert single/multiple covariate-columns'
        'When using covariates: please give the covariate(s) (header) usefull name(s)'
        'keep covariates-names short, use underscores, avoid spaces and special characters'
        'Note that group-names in group-column and covariates-names will be used for voxelwise statistic!'
        ''
        };
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 3,col(2,:));
    end
elseif strcmp(z.stat,'1xANOVA')
    cm2={...
        'STATISTICAL SCENARIO: 1-WAY-ANOVA (INDEPENDENT GROUPS)'
        '[group]-column: please specify which animal belongs to which group'
        'use strings as group-names (example: "control","drugA","drugB" ..without quoation marks)'
        'use underscores (avoid spaces) & avoid special characters'
        'example: "control" for "control"-animals; "drugA" for animals from "drugA-group" '
        '         "drugB" for animals from "drugB-group" (without quoation marks)'
        'COVARIATES (optional):'
        'Right to the [group]-column you can insert single/multiple covariate-columns'
        'When using covariates: please give the covariate(s) (header) usefull name(s)'
        'keep covariates-names short, use underscores, avoid spaces and special characters'
        'Note that group-names in group-column and covariates-names will be used for voxelwise statistic!'
        ''
        };
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 3,col(4,:));
    end
elseif strcmp(z.stat,'1xANOVAwithin')
    cm2={...
        'STATISTICAL SCENARIO: WITHIN 1-WAY-ANOVA (DEPENDENT GROUPS)'
        '[group]-column: please specify which animal belongs to which group'
        'use strings as group-names (example: "time1","time2","time3" ..without quoation marks)'
        'use underscores (avoid spaces) & avoid special characters'
        'IMPORTANT: for WITHIN 1-WAY-ANOVA it is assumed that:'
        'The 1st animal in the subgroups (example: "time1","time2","time3")  is the same animal'
        'The 2nd animal in the subgroups (example: "time1","time2","time3")  is the same animal ...etc...'
        'EXAMPLE'
        ['[animal]     [group]']
        ['animal01     time1']
        ['animal02     time1']
        ['animal03     time1']
        ['animal01     time2']
        ['animal02     time2']
        ['animal03     time2']
        ['animal01     time3']
        ['animal02     time3']
        ['animal03     time3']
        'Alternatively the animal order can be changed to:'
        ['[animal]     [group]']
        ['animal01     time1']
        ['animal01     time2']
        ['animal01     time3']
        ['animal02     time1']
        ['animal02     time2']
        ['animal02     time3']
        ['animal03     time1']
        ['animal03     time2']
        ['animal03     time3']
        'PLEASE CHECK THE CORRESPONDENCE OF The Animals!!! '
        'COVARIATES (optional):'
        'Right to the [group]-column you can insert single/multiple covariate-columns'
        'When using covariates: please give the covariate(s) (header) usefull name(s)'
        'keep covariates-names short, use underscores, avoid spaces and special characters'
        'Note that group-names in group-column and covariates-names will be used for voxelwise statistic!'
        ''
        };
    if z.addComment==1
        xlsinsertComment(f1,cm2, 1, [4], 3,col(5,:));
    end
    
end



%  showinfo2('new group-file ',f1);

%% ============[info-sheet]===================================

t={'info'
    ['study: '  paout ]
    ['date:  '  datestr(now) ]
    ['animals: '  num2str(size(animals,1))]};

pwrite2excel(f1,{2 'info'},{'information'},{},t);

%% ===============================================

showinfo2('new group-file ',f1);




function he=selectNIFTIS(padat)
he=[];
w=antcb('selectimageviagui', padat, 'multi');
if isempty(w) || isnumeric(w)
    w='<empty>';
end
he=w;

