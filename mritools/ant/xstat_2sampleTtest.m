




%% #b 2-sample t-test
% statistically compare image of two independent groups
% • groups have to be defined via excel-document
% • the output are statistically thresholded images for the contrasts (groupA<groupB) and (groupA>groupB)
% • if the statistical model is calculated (once), it is not necessary to re-calculate the estimation if one wants to change
%  the alpha-correction method/cluster-threshold or significance-level   ..see below
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
% --> the columns can be arbitrarily located in the excelsheet (will be specified in the gui)
% --> note that group-column can contain more than two "group"-ids: this allows to:
%       (a) statistically compare different groups (subsequently) and 
%       (b) pool subgroups, example: pool group-1 & group-2 and compare against group-3
% 
% _______________________________________________________________________________________
%
%% #by  CASE-A "ESTIMATION AND THRESHOLDING"
%%  *GROUPS* 	
% x.excelfile     =  'O:\data\karina\MRTgroups.xlsx'; % EXCELFILE: specify excelfile here containing mouse-folder-names (short names) and a correcponding column for group-assignment (numeric)
% x.sheetno       =  [2]; % specify sheet number or sheet-name here , here the 2nd sheet is loaded
% x.foldercolumn  =  [4]; % specify the column that contains the mouse-folder-names, here it is column 4
% x.groupcolumn   =  [3]; % specify the column that contains the group-membership, here it is column 3
% 
% x.groupIDs      =  [1 2]  % #g specify the groups to compare, here subjects with id=1 are compared against subjects with id=2
% #r alternative TO COMPARE POOLED SUBGROUPS:
% x.groupIDs      =  {'1 2' '3 4 5' };  % here group-A containg subjects with ids 1 and 2 is compared against groupB containg subjects with ids 3,4,5
% 
%%  *PARAMETERS* 	 
% x.image           = 'JD.nii'; % specifiy the NIFITI-image that is statistically compared, here "JD.nii" is compared
% x.brainmask       = 'O:\data\karina\templates\AVGTmask.nii';   % (optional) you may specify a brain-mask, for instance the brainmask in the templatefolder
% x.outputdirectory = 'O:\data\karina\results_ttestJD4';         % specify the outputfolder,  if x.outputdirectory is empty: a new folder with name
%                                                                %  "T_IDsA_vs_IDsB" is created in "--/study/results" (IDsA and IDsB refer to the groupIDs)
% x.corrmeth=        'FWE&FDR&none';    % specity th method to control for multiple testing, options: 'FWE','FDR' or 'none'
%                                       % tags such as "FWE&FDR" produce a FWE and FDR corrections,separately
%                                       % here, for comparison purpose, FWE, FDR and none (uncorrected) methods are used 
% x.thresh=          [0.05];	        % sets the statistical height-threshold
% x.extent=          [0];	            % sets the spatial cluster threshold k (minimum number of "connected", statistically surviving voxel per cluster)
% 
% _______________________________________________________________________________________
%
%% #by  CASE-B "ESTIMATION IS ALREADY PERFORMED BUT ANOTHER THRESHOLDING SHOULD BE USED"
% SCENARIO: the statistical model is already calculated, but another alpha-correction method or other 
%    statistical/cluster thresholds should be used:
% SOLUTION: to prevent the recalulculation of the model, "x.excelfile" must be empty ('') , but
%         at least "x.outputdirectory" must be specified and than...
%             x.corrmeth/x.thresh/x.extent can be changed
% _______________________________________________________________________________________
%
%% #by RUN-def:
% xstat_2sampleTtest(1) or  xstat_2sampleTtest    ... open PARAMETER_GUI
% xstat_2sampleTtest(0,z)             ...NO-GUI,  z is the predefined struct
% xstat_2sampleTtest(1,z)             ...WITH-GUI z is the predefined struct
%
%% #by BATCH EXAMPLE-1   MODELestimation and threshold images
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% BATCH:        [xstat_2sampleTtest.m]
%% descr:       2-sample-t-test
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% z=[]; % empty struct
% z.excelfile='O:\data\karina\MRTgroups.xlsx'; % this excelfile is used
% z.sheetno=[2];               % excelsheet number 2 is used
% z.foldercolumn=[4];          % column-4 in excelsheet contains the mouse-folder-names
% z.groupcolumn=[3];           % column-3 in excelsheet contains the groupIDs
% z.groupIDs={ '1 2' 	'3 4' }; % compare groupA (with ids 1&2) against groupB (ids 3&4) 
% z.image='JD.nii';            % statistically compare 'JD.nii' image 
% z.brainmask='O:\data\karina\templates\AVGTmask.nii';  % template's brain mask is used
% z.outputdirectory='O:\data\karina\results_ttestJD4';  % this is the outputdirectory
% z.corrmeth='FWE&FDR&none';  % subsequenlty ineppendent FWE, FDR or no alpha-correction is applied
% z.thresh=[0.05];            % height-threshold set  to 0.05
% z.extent=[30];              % cluster extent 30 voxels
% xstat_2sampleTtest(1,z);    % RUN this this function, but use GUI
% 
%% #by BATCH EXAMPLE-2:  new THRESHOLD (after calculated model-estimation)
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% BATCH:        [xstat_2sampleTtest.m]
%% descr:       2-sample-t-test
%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% z=[]; % empty struct
% z.outputdirectory='O:\data\karina\results_ttestJD4';  % this is the outputdirectory
% z.corrmeth='none';  % no alpha-correction  applied
% z.thresh=[0.001];            % height-threshold set  to 0.001
% z.extent=[60];              % cluster extent 60 voxels
% xstat_2sampleTtest(1,z);    % RUN this this function, but use GUI
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%




function xstat_2sampleTtest(showgui,x,pa)

if 0
    
    x=[]
    x.excelfile=       'O:\data\karina\MRTgroups.xlsx';	% excelfile, this excelfile contains a column with mouse-folders and group-assignment,respectively
    x.sheetno=         [2];	% number of excelsheet or sheetname
    x.foldercolumn=    [4];	% column (numeric) containing the mouse folders
    x.groupcolumn=     [3];	% column (numeric) containing the group assignment
    x.groupIDs=        [1  2];	% group IDs, which will be read out from groupcolumn
    %  parameter
    x.image   ='JD.nii'
    x.brainmask=       'O:\data\karina\templates\AVGTmask.nii';	% (optional) select brain-mask (example: "..templates\AVGTmask.nii")
    x.outputdirectory='O:\data\karina\results_ttestJD3';	% select (create and select) an outputdirectory directory for this analysis
    x.corrmeth=        'FWE&FDR&none'	;% control of multiple testing, (tags such as "FWE&FDR" produce a FWE and FDR correction,separately )
    x.thresh=          [0.05];	% statistical height-threshold
    x.extent=          [0];	% spatial cluster threshold k (minimum number of "connected", statistically surviving voxel per cluster)
    xstat_2sampleTtest(1,x)
end

if 0
    
    x=[]
    x.excelfile=       'O:\data\karina\MRTgroups.xlsx';	% excelfile, this excelfile contains a column with mouse-folders and group-assignment,respectively
    x.sheetno=         [2];	% number of excelsheet or sheetname
    x.foldercolumn=    [4];	% column (numeric) containing the mouse folders
    x.groupcolumn=     [3];	% column (numeric) containing the group assignment
   x.groupIDs=        {'1 2' '3 4'};	% group IDs, which will be read out from groupcolumn
  %    x.groupIDs=        {[1 2]; [ 3 4 5]};	% group IDs, which will be read out from groupcolumn

    %  parameter
    x.image   ='JD.nii'
    x.brainmask=       'O:\data\karina\templates\AVGTmask.nii';	% (optional) select brain-mask (example: "..templates\AVGTmask.nii")
    x.outputdirectory='O:\data\karina\results_ttestJD4';	% select (create and select) an outputdirectory directory for this analysis
    x.corrmeth=        'FWE&FDR&none'	;% control of multiple testing, (tags such as "FWE&FDR" produce a FWE and FDR correction,separately )
    x.thresh=          [0.05];	% statistical threshold
    x.extent=          [0];	% spatial cluster threshold k (minimum number of "connected", statistically surviving voxel per cluster)
    xstat_2sampleTtest(1,x)
end

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
    'inf1'      '••• TWO-SAMPLE-T-TEST   •••             '                         '' ''
    'inf2'      'note: if other statistical corrections (corrmeth,thresh,extent) are performed afterwards, you dont need to re-run the model-estimation'  '' ''
    'inf3'      '      just set the "excelfile"-parameter empty! but specify  the "outputdirectory","corrmeth","thresh" and "extent"' '' ''
    'inf10'      [repmat('—',[1,100])]                            '' ''
    
    'inf100'  '% *GROUPS*' '<< which mouse belongs to which group' ''
    %
    %
    'excelfile'     ''        'EXCELFILE: wich column containing mouse-folder-names (short names) and a correcponding column for group-assignment (numeric)'  {'f'}
    'sheetno'        2        'number/ID or name of the excelsheet where data is stored'            ''
    'foldercolumn'    4       'specify the column (id; such as "1" for first column) containing the mouse-folder-names'  ''
    'groupcolumn'     3       'specify the column (id; such as "2" for 2nd column) containing the group assignment'  ''
    'groupIDs'      [1 2]     'group IDs, which will be read out from groupcolumn (example: "[1 2]" will assign all mousefolders with groupID-1 to group-1 and groupID-2 to group-2)' ''
    'inf120'       '     '         '                    % NOTE: for pooling subgroups, see help of this function' ''   %  groupIDs: to pool subgroups use cellstring-mode (example: groupIDs is "{''''''1 2 3''''''  ''''''4 5''''''}" assigns subgroups 1,2 and 3 to group-1 and subgroups 4 and 5 to group-2)'  ''
    
    'inf200'  '% *PARAMETERS*' '' ''
    'image'      {''}      'NIFTI-image to compare..statistic is calculated on this image'  {@selector2,li,{'Image'},'out','list','selection','single'}
    'brainmask'            '' '(optional) select a brain-mask (example: "..templates\AVGTmask.nii")'  'f'
    'outputdirectory'      '' 'select (create and select) an outputdirectory directory for this analysis'  'd'
    
    'corrmeth' {'FWE'}    'control for multiple testing, (tags such as "FWE&FDR" produce a FWE and FDR correction,separately ) ' {'FWE' 'FDR' 'none'  'FWE&FDR' 'FWE&none' 'FDR&none' 'FWE&FDR&none'  }
    'thresh'   0.05       'statistical height-threshold'  {0.05 0.01 0.001}
    'extent'  0.00        'spatial cluster threshold k (minimum number of "connected", statistically surviving voxel per cluster)'  ''
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
        'title','***COREGISTRATION***','info',hlp);
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% return
currpath=pwd;
useotherspm(1);

%% [A] estimate model &  make thresholded image
%% read from excel
if ~isempty(z.excelfile)
    v=readexcelfile(z);
    
    %% check file-existence
    [v,z]=checkfiles(v,z);
    
    cprintf([0 0 1],'###############################################\n');
    cprintf([0 0 1],[['T-TEST : groups: ' [v.grouptag{1}  ' vs '  v.grouptag{2} ]] '\n']);
    cprintf([0 0 1],[[' group-size {G1,G2}: ' [ num2str(size(v.f1,1))  ' vs. '  num2str(size(v.f2,1))  ]] '\n']);
    disp('    ');
    
    %% do statistic
    try
        useotherspm(0);
        dostats(v,z);
        
        %% [2] make thresholded image
        threshimage(z);
    catch
        
        cprintf([1 .5 0],'could not run statistic\n');
        cprintf([1 .5 0], ['Test: ' v.grouptag{1} 'vs' v.grouptag{2} '\n']);
        cprintf([1 .5 0],[['group-size {G1,G2}: ' [ num2str(size(v.f1,1))  ' vs '  num2str(size(v.f2,1)) ]] '\n']);
        cd(currpath);
    end
 
end

%% [B] make thresholded image only
if isempty(z.excelfile) && exist(fullfile(z.outputdirectory,'SPM.mat'))==2
    threshimage(z);
end

cd(currpath);
useotherspm(0);

makebatch(z);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••  SUBS ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
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


function v=readexcelfile(z)
[a aa aaa]=xlsread(z.excelfile,z.sheetno);

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

%% check existence of files & remove nonexisting filenames
function [v,z]=checkfiles(v,z)
global an
v.f1=cellfun(@(a) {[an.datpath filesep a  filesep z.image ]},v.g1);
v.f2=cellfun(@(a) {[an.datpath filesep a  filesep z.image ]},v.g2);
v.f1(find(existn(v.f1)~=2))=[];
v.f2(find(existn(v.f2)~=2))=[];

if existn(z.brainmask)~=2
    z.brainmask='';
end

if exist(z.outputdirectory)~=7 %outputfolder
    if isempty(z.outputdirectory)
        newfolder=[strrep(z.image,'.nii','') '_T_' v.grouptag{1} '_vs_' v.grouptag{2}];
       z.outputdirectory =fullfile(fileparts(an.datpath),'results',newfolder) ;
    end
    warning off;
    mkdir(z.outputdirectory);
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function dostats(v,z)
g1     = v.f1;
g2     = v.f2;
outdir ={[z.outputdirectory filesep]};
mask   ={z.brainmask};
outdirSPM={[z.outputdirectory filesep 'SPM.mat']};
name1  = [v.grouptag{1} '>' v.grouptag{2}];
name2  = [v.grouptag{1} '<' v.grouptag{2}];

mbatch{1}.spm.stats.factorial_design.dir            = outdir;%'<UNDEFINED>';
mbatch{1}.spm.stats.factorial_design.des.t2.scans1  = g1;%'<UNDEFINED>';
mbatch{1}.spm.stats.factorial_design.des.t2.scans2  = g2;%'<UNDEFINED>';
mbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
mbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
mbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
mbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
mbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mbatch{1}.spm.stats.factorial_design.masking.im = 1;
mbatch{1}.spm.stats.factorial_design.masking.em =  mask;% {''};
mbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
mbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mbatch{2}.spm.stats.fmri_est.method.Classical = 1;
mbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
mbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
mbatch{3}.spm.stats.con.consess{1}.tcon.name = name1;
mbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
mbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
mbatch{3}.spm.stats.con.consess{2}.tcon.name =  name2;
mbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
mbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
mbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run',mbatch);
% evalc('spm_jobman(''run'',mbatch)');
disp(['Statistic see: <a href="matlab: explorer('' ' outdir{1} '  '')">' outdir{1} '</a>'  ]);
% return

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function threshimage(z);

%% make thresholded images
% if 0 %to be deleted
%     outdirSPM={'O:\data\karina\results_ttestJD2\SPM.mat' }
% end

warning off;
outdirSPM={[z.outputdirectory filesep 'SPM.mat']};
thresh  =z.thresh   ;  %0.05;
extent  =z.extent  ;%=0  ;%spatial clusterSize

% ;%{'none' 'FWE' 'FDR'};
corrmeth=z.corrmeth;
corrmeth= regexprep(strsplit2(corrmeth,'&')','\s','');
if ischar(corrmeth); corrmeth=cellstr(corrmeth); end

for i=1:2 %contrast
    for j=1:length(corrmeth) %correctionmethod
        
        % spm fmri
        % spmmouse
        if i==1 && j==1
            useotherspm(1);
            spmmouse('load',which('mouse-C57.mat'));
        end
        
        mbatch=[];
        mbatch{1}.spm.stats.results.spmmat = outdirSPM;%{'O:\data\karina\results_ttestJD2\SPM.mat'};
        mbatch{1}.spm.stats.results.conspec.titlestr = '';
        mbatch{1}.spm.stats.results.conspec.contrasts =i;
        mbatch{1}.spm.stats.results.conspec.threshdesc = corrmeth{j} ;%'FWE';
        mbatch{1}.spm.stats.results.conspec.thresh = thresh;
        mbatch{1}.spm.stats.results.conspec.extent = extent;
        mbatch{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
        mbatch{1}.spm.stats.results.units = 1;
        mbatch{1}.spm.stats.results.print = false;
        evalc('spm_jobman(''run'',mbatch)');
        
        
        % xSPM.u
       
        
        xSPM = evalin('base','xSPM;');
        XYZ  = xSPM.XYZ;
        
        xtitle=xSPM.title;
        xtitle=[ 'T_' strrep(strrep(xtitle,'<' , 'ls'),'>','gt' ) ];
        xtitle=[xtitle '_' corrmeth{j}];
        xtitle=[xtitle '_' strrep(sprintf('%5.3f',xSPM.u),'.','.')];
        xtitle=[xtitle '_k'  sprintf('%d',xSPM.k) ];
        xtitle=[xtitle '_surv' strrep(sprintf('%d',size(XYZ,2)),'.','d')];
        outfile=fullfile(fileparts(outdirSPM{1}),[xtitle '.nii'  ]);
        outfile=regexprep(outfile,'\s',''); %no-space
        
        % thresholded spm --> see "spm_results_ui.m" line- 1245   case 'thresh'
        Z = xSPM.Z;
%                 spm_write_filtered(Z, XYZ, xSPM.DIM, xSPM.M,...
%                     sprintf('SPM{%c}-filtered: u = %5.3f, k = %d',xSPM.STAT,xSPM.u,xSPM.k),outfile);
       evalc('spm_write_filtered(Z, XYZ, xSPM.DIM, xSPM.M,sprintf(''SPM{%c}-filtered: u = %5.3f, k = %d'',xSPM.STAT,xSPM.u,xSPM.k),outfile)');
        
        
        
        disp(['threshIMG: <a href="matlab: explorerpreselect(''' outfile ''')">' outfile '</a>'  ]);
        
    end
end
useotherspm(0);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% return
% %% bla
% 
% mbatch{1}.spm.stats.factorial_design.dir =                      outdir ;%••• {'O:\harms1\codes_special\TTmcaosham_spm\'};
% mbatch{1}.spm.stats.factorial_design.des.t2.scans1 =            g1  ;   %•••
% mbatch{1}.spm.stats.factorial_design.des.t2.scans2 =            g2  ;   %•••
% mbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
% mbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
% mbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
% mbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
% mbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
% mbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% mbatch{1}.spm.stats.factorial_design.masking.im = 1;
% % mbatch{1}.spm.stats.factorial_design.masking.em = {''};
% mbatch{1}.spm.stats.factorial_design.masking.em =         mask; %•••{'O:\data\karina\templates\ANO.nii,1'};
% mbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% mbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% mbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% 
% 
% mbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
% mbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
% mbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
% mbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
% mbatch{2}.spm.stats.fmri_est.method.Classical = 1;
% 
% spm_jobman('run',mbatch)
% 
% clear mbatch
% mbatch{1}.spm.stats.con.spmmat =                    outdirSPM  ;%••• {'O:\harms1\codes_special\TTmcaosham_spm\SPM.mat'};
% mbatch{1}.spm.stats.con.consess{1}.tcon.name =      name1      ;%•••  'mcao>sham';
% mbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
% mbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% mbatch{1}.spm.stats.con.consess{2}.tcon.name =      name2     ;%•••'mcao<sham';
% mbatch{1}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
% mbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% mbatch{1}.spm.stats.con.delete = 0;
% spm_jobman('run',mbatch)
% 
% disp(['Statistic see: <a href="matlab: explorer('' ' outdir{1} '  '')">' outdir{1} '</a>'  ]);

