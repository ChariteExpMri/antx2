%
%% #by DTIstatistik for DSIstudio-RESULTS (DTIparameters & DTIconnectivity)
%
%% #r FUNCTION DEALS WITH ONE OF THE FOLLOWING FILE-TYPES
% DTIparameters   - ascii-file (example: "##_dti_parameter_stat.txt")
% DTIconnectivity - mat-file   (example: "__dti_1000K_seed_rk4_end.mat")
%
%% #r GROUP-ASSIGNMENT
% - an excelfile must be prepared with mouseIDs and group-assignment
% - the excelfile must contain 2 columns (mouse-id & groupassignment) in the first excel-sheet
% - [mouseID]:  1st column contains mouseIDS/names
% - [groupassignment]: 2nd column contains subgroup labels such that each mouse is assigned to a group
% - * the first row is thought to represent the header (column names can be arbitrarily chosen)
%% #g EXAMPLE of the GROUP-ASSIGNMENT with 2 subgroups (1wt2ko,1ko2ko)
%         MRI Animal-ID              GROUP    (1rst row is contains the header)
%         20161215TM_M6590          1wt2ko
%         20170112TM_M6615          1wt2ko
%         20170112TM_M7067          1wt2ko
%         20170113TM_M7070          1wt2ko
%         20170113TM_M7334          1wt2ko
%         20170223TM_M9513          1wt2ko
%         20170223TM_M9533          1wt2ko
%         20170223TM_M9534          1wt2ko
%         20170223TM_M9535          1wt2ko
%         20161215TM_M6591          1ko2ko
%         20170112TM_M6617          1ko2ko
%         20170112TM_M7065          1ko2ko
%         20170113TM_M7068          1ko2ko
%         20170113TM_M7338          1ko2ko
%         20170223TM_M9515          1ko2ko
%         20170224TM_M9536echte     1ko2ko
%         20170224TM_M9536          1ko2ko
%         20170224TM_M9539          1ko2ko
%_________________________________________________________________________________________________
%% #ry GUI (controls and behaviour)
% [load group assignment] (button)   : load excelfile with group assignment
% [load DTI parameter]    (button)   : load DTI-PARAMETER FILES (*.txt files)
% [load DTI connectities] (button)   : load DTI-CONNECTIVITY FILES (*.mat files)
% [load COI file]         (button)   : optional, load Connections of Interest  (excelfile file)
% [make COI file]         (button)   : optional, create an excel file with connections as blanko file
%                                      this file can than be used to make a COI-file (excelfile file), by manually indicating with connections are of interest..   (excelfile file)
% [within]                (checkbox) : [] between-design (2-sample problem), [x] paired-design (repeated measures)
% [tests]                 (pulldown) : select the prefered test here (depends on the design)
%                              # for between-design: select one of the following tests:
%                                    ttest2 (2sample ttest),
%                                    WST(Wilcoxon rank sum test),
%                                    permutation
%                                    permutation2
% [use FDR]               (checkbox) : if selected, FDR correction is performed
% [qFDR]                  (edit)     : desired false discovery rate (default: 0.05)
% [show SIGS only]        (checkbox) : if selected, only significant results will be reported
% [sort Results]          (chckbox)  : if selected, results will be ordered after p-value
% [reverse contrast]      (chckbox)  : default group-comparison is A>B, if selected B>A comparison is done (changes the sign of the test statistic, usefull for DTI-visulaization)
% [noSeeds]               (edit)     : number of seeds,  connectivity-matrizes (weights) will be normalized by noSeeds prior calculation of connectivity metrics
%
% [stat DTI parameter]    (button)   : run statistic for DTI-PARAMETER FILES (DTI-PARAMETER FILES must be loaded before)
% [stat Connectivity]     (button)   : run statistic for DTI-CONNECTIVITY FILES (DTI-CONNECTIVITY FILES must be loaded before)
% [redisplay data]        (button)   : redisplay data without re-calculation of the statistic 
%                                      (usefull for FDR/qFDR/showSigsonly/sortResult)
% [plot data]             (button)   : plot data/results (use right pulldown to select the type of plotting)
% [export data]           (button)   : export results
%_________________________________________________________________________________________________
%% #ry AUTOMATIZATION PARAMETERS
% - use pairwise inputs
% - dtistat(parametername1, parametervalue1,...,...,parameternameN, parametervalueN)
% #b PARAMETERS
% 'groupfile'     : fullpath name of the excelfile with the group assignment
% 'confiles'      : cellarray with fullpath names of connectivity files
% 'paramfiles'    : cellarray with fullpath names of DTI-parameter files
% 'f1design'      : typ of design, [0] between test ,[1] within test
% 'typeoftest1'   : type of test depending  on f1design
%                    -for between-design: ttest2 (2sample ttest), WST(Wilcoxon rank sum test), permutation or permutation2
%                    -for within-design: #r not implemented yet
% 'isfdr'         : use FDR correction ,(0|1)
% 'qFDR'          : q-value (desired false discovery rate) for FDR corection (default: 0.05)
% 'issort'        : sort results according pvalue (0|1)
% 'showsigsonly'  : show only significant results (0|1)
% 'reversecontrast: reverse group contrast (0|1); where [0] is A>B group, while [1] is B>A
% 'noSeeds'       : number of seeds,  connectivity-matrizes (weights) will be normalized by noSeeds prior calculation of connectivity metrics
%
% 'runstat'       : run statistic over:   ('dti') DTI-parameter or ('con')  connectivity data
% 'outvar'        : workspace varable name, this variable contains the results
% 'export'        : fullpath-filename of the excelfile of the results (a gui will open if the parameter value is empty )
% 'reset'         : [1/0]: [1] reset the GUI,set all parameters to default and clear all inputs 
% 'show'          : show/redisplay results again (used after changes of FDR/sorting-parameters )
% 'roifile'       : load a roi/coi file (an excel-file that specifies the connections of interest )
%_________________________________________________________________________________________________
%% #ry AUTOMATIZATION EXAMPLE
%% #b this example investigates two groups using 2sample-Ttest
%% #b here DTIparameter-files (paramfiles) and Connectivity-files (confiles) are loaded but only the Connectivity-files will be analyzed
%% #b to analyze the DTIparameter-files change 'runstat' from 'con' to 'dti'
%
% paramfiles={'O:\data2\x01_maritzen\Maritzen_DTI\M6590_dti_parameter_stat.txt'  % %DTI-PARAMETER FILES
%     'O:\data2\x01_maritzen\Maritzen_DTI\M6591_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M6615_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M6617_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7065_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7067_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7068_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7070_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7334_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M7338_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9513_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9515_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9533_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9534_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9535_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9536_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9536echte_dti_parameter_stat.txt'
%     'O:\data2\x01_maritzen\Maritzen_DTI\M9539_dti_parameter_stat.txt'};
%
% confiles={
%     'O:\data2\x01_maritzen\Maritzen_DTI\20161215TM_M6590_dti_1000K_seed_rk4_end.mat' % %DTI-CONNECTIVITY FILES
%     'O:\data2\x01_maritzen\Maritzen_DTI\20161215TM_M6591__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M6615__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M6617__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M7065__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M7067__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7068__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7070__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7334__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7338__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9513__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9515__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9533__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9534__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9535__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9536__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9536echte__dti_1000K_seed_rk4_end.mat'
%     'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9539__dti_1000K_seed_rk4_end.mat'};
%
% pa='O:\data2\x01_maritzen\Maritzen_DTI'
% dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...% % USE THIS GROUPASSIGNMENT-FILE
%     'confiles',confiles,'paramfiles'  ,  paramfiles ,...       % % USE THIS  DTI-PARAMETER FILES & %DTI-CONNECTIVITY FILES
%     'f1design',       0,'typeoftest1' ,    'Ttest2' ,...       % % BETWEEN DESIGN,  2-sample Ttest
%     'isfdr'   ,       1,'qFDR'        ,       0.05  ,...       % % FDR CORRECTION, USING THIS FDR-Q-THRESHOLD
%     'issort'  ,       1,'showsigsonly',          1  ,...       % % SORT ACCORDING P-VALUES, SHOW ONLY SIGNIFICANT RESULTS
%     'noSeeds' ,     1e6,              ,              ...       % % for NW-metrics only-->normalize connecticity weights by number of seeds
%     'runstat' ,   'con','outvar'      , 'results');            % % RUN STATISTIC FOR CONNECTIVITY data ('con'), results will be stored in workspace variabe 'results'
%
% 
%% #ry other SNIPS
% dtistat('export',fullfile(pwd,'_result3.xlsx')); % % eport results as excelfile
% dtistat('show',1);                               % % show/redisplay results again (used after changes of FDR/sorting-parameters )
% dtistat('reset',1);                              % % reset GUI and Parameters
% dtistat('roifile',fullfile(pwd,'ROI_christian1.xlsx')); % %  load a specified ROI/COI file
% dtistat('roifile','none');  % % reset: no ROIfile is used
% dtistat('reversecontrast',1);  % % reverse group contrast




%_________________________________________________________________________________________________




function dtistat(varargin)




if 0
    dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...% % USE THIS GROUPASIGNMENT-FILE
        'confiles',confiles,'paramfiles',paramfiles        ,...       % % USE THIS  DTI-PARAMETER FILES & %DTI-CONNECTIVITY FILES
        'f1design',  0,        'typeoftest1' ,    'Ttest2' ,...       % % BETWEEN DESIGN,  2-sample Ttest
        'isfdr',     1,        'qFDR'        ,     0.05    ,...       % % FDR CORRECTION, USING THIS FDR-Q-THRESHOLD
        'issort',    1,        'showsigsonly',      1      ,...       % % SORT ACCORDING P-VALUES, SHOW ONLY SIGNIFICANT RESULTS
        'runstat','con')                          % % RUN STATISITC FOR CONNECTIVITY
    
    
    dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...% % USE THIS GROUPASIGNMENT-FILE
        'confiles',confiles,'paramfiles',paramfiles        ,...       % % USE THIS  DTI-PARAMETER FILES & %DTI-CONNECTIVITY FILES
        'f1design',  0,        'typeoftest1' ,    'Ttest2' ,...       % % BETWEEN DESIGN,  2-sample Ttest
        'isfdr',     1,        'qFDR'        ,     0.05    ,...       % % FDR CORRECTION, USING THIS FDR-Q-THRESHOLD
        'issort',    1,        'showsigsonly',      1      ,...       % % SORT ACCORDING P-VALUES, SHOW ONLY SIGNIFICANT RESULTS
        'runstat','con','outvar', 'results')                          % % RUN STATISITC FOR CONNECTIVITY
    
end

hf=findobj(0,'tag','dtistat');
if isempty(hf)
    createGui;
end
inputs(varargin);

function createGui

%% properties
 props.wst_stat ='z'  ; %WST-statistic:  'z' (z-statistic) or 'rs' (ranksum )




us=[];
us.issort      =1;
us.showsigsonly=1;
us.isfdr       =1;
us.f1design    =0;
us.f2design    =0;
us.typeoftest1 =1;
us.qFDR        =0.05;
us.outvar      =[];
us.noSeeds     = 10^6;
us.reversecontrast =0;
us.props=props;




%———————————————————————————————————————————————
%%   prepare GUI
%———————————————————————————————————————————————

delete(findobj(0,'tag','dtistat'));
hf=figure;
set(hf,'units','norm','color','w','tag','dtistat','menubar','none');
set(hf,'position',[0.5892    0.4461    0.3889    0.4667]);
set(hf,'name','dtistat','NumberTitle','off');

set(gcf,'userdata',us);

h=uicontrol('style','pushbutton','units','norm','position',[0 .85 .2 .05],...
    'string','load group assignment','tag','loaddata','callback',@loadgroupassignment,...
    'tooltipstring',['load excel-file with the group-assignment']);
%•••••••• DTI parameter &  DTI connectities ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

h=uicontrol('style','pushbutton','units','norm','position',[0 .8 .2 .05],...
    'string','load DTI parameter','tag','loaddata','callback',@loadDTIparameter);
h=uicontrol('style','pushbutton','units','norm','position',[0.2 .8 .2 .05],...
    'string','load DTI connectities','tag','loaddata','callback',@loadDTIConnectivity,...
    'tooltipstring',['load mouse-specific matfiles with the connectivities ']);


%••••••••  LOAD COIFILE ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
h=uicontrol('style','pushbutton','units','norm','position',[0.45 .8 .12 .05],...
    'string','load COIfile','tag','loadroifile','callback',@loadroifile,...
    'tooltipstring','load excel-file with connections of interest (COI)');

%••••••••  make COIFILE ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
h=uicontrol('style','pushbutton','units','norm','position',[0.57 .8 .12 .05],...
    'string','make COIfile','tag','makeROIfile','callback',@makeROIfile,...
    'tooltipstring','create excel file with connections (blanko) to manually indicate the connections of interest (COI  of interest (COI)');


%help
h=uicontrol('style','pushbutton','units','norm','position',[.8 .85 .15 .05],...
    'string','help','tag','help','callback',@xhelp,...
    'tooltipstring',['function help']);


%close resultfiles
h=uicontrol('style','pushbutton','units','norm','position',[.8 .8 .15 .05],...
    'string','close result windows','tag','closeresultwindows','callback',@closeresultwindows,'fontsize',6,...
    'tooltipstring','close open result windows');


%between vs within
h=uicontrol('style','checkbox','units','norm','position',[.1 .65 .2 .05],'string','within',...
    'tag','F1design','backgroundcolor','w','callback',@call_f1design,...
    'tooltipstring',['testing type:' char(10) ...
    ' [ ] BETWEEN DESIGN: compare independent groups ' char(10) ...
    ' [x] WITHIN DESIGN:  compare same mice at different time points ' char(10) ...
    ]);

%••••••••  type of test ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
h=uicontrol('style','popupmenu','units','norm','position',[.15 .65 .2 .05],...
    'string',{'ttest2' 'WST' 'permutation','permutation2'},'tag','testsbetween',...
    'position',[.2 .645 .1 .05],'tag','typeoftest1',...
    'tooltipstring',['Type of test type:' char(10) ...
    ' *** BETWEEN DESIGN ' char(10) ...
    '   ttest2 (parametric) ' char(10) ...
    '   WST,aka Wilcoxon rank sum test (non-parmametric) ' char(10) ...
    '   permutation/permutation2: two different permutation tests' char(10) ...
    '      ' char(10)...
    ' *** WITHIN DESIGN ' char(10) ...
    '    ..not implemented so far'     ]);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% FDR
h=uicontrol('style','checkbox','units','norm','position',[.1 .7 .2 .05],'string','use FDR',...
    'tag','isfdr','backgroundcolor','w','value',us.isfdr,...
    'tooltipstring','use FDR for treatment of multiple comparisons (MCP)');%,'callback',@call_f2design);
set(h,'position',[.01 .55 .2 .05],'fontsize',7);
% showSigs
h=uicontrol('style','checkbox','units','norm','position',[.3 .7 .2 .05],'string','show SIGs only',...
    'tag','showsigsonly','backgroundcolor','w','value',us.showsigsonly,...
    'tooltipstring','show significant results only');%,'callback',@call_f2design);
set(h,'position',[.15 .55 .2 .05],'fontsize',7);
%sort
h=uicontrol('style','checkbox','units','norm','position',[.45 .7 .2 .05],'string','sort Results',...
    'tag','issort','backgroundcolor','w','value',us.issort,...
    'tooltipstring','sort Results according p-value');%,'callback',@call_f2design);
set(h,'position',[.32 .55 .2 .05],'fontsize',7);

%reverse contrast
h=uicontrol('style','checkbox','units','norm','position',[.6 .7 .2 .05],'string','reverse contrast',...
    'tag','reversecontrast','backgroundcolor','w','value',us.reversecontrast,...
    'tooltipstring',['Reverse Contrast/Groups:' char(10) ...
    '  [ ] A>B, where "A" and "B" are the groups to be compared ' char(10) ...
    '  [x] B>A, .. flip contrast ' char(10) ...
   ]);
set(h,'position',[.47 .55 .2 .05],'fontsize',7);


%% qvalue
h=uicontrol('style','edit','units','norm','position',[.01 .52 .05 .03],'string',num2str(us.qFDR),...
    'tag','qFDR','backgroundcolor','w','value',1,...
    'tooltipstring','desired false discovery rate. {default: 0.05}','fontsize',7);
h=uicontrol('style','text','units','norm','position',[.06 .52 .05 .03],'string','qFDR',...
    'backgroundcolor','w');


%% Node
tt=[' number of seeds (noSeeds)' char(10) ' connectivity-matrizes (weights) will be normalized by noSeeds prior calculation of connectivity metrics'];
h=uicontrol('style','edit','units','norm','position',[.8 .52 .1 .03],'string',num2str(us.noSeeds),...
    'tag','noSeeds','backgroundcolor','w','value',1,'HorizontalAlignment','left',...
    'tooltipstring',tt,'fontsize',7);
h=uicontrol('style','text','units','norm','string','noSeeds',...
    'backgroundcolor','w','position',[.7 .52 .1 .03],'HorizontalAlignment','right', 'tooltipstring',tt);


%••••••••  TYPE OF CALCULATION ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
h=uicontrol('style','text','units','norm');
set(h,'position',[0.1 .45 .2 .03],'backgroundcolor','w', 'string',' calculate..');
 

%process
h=uicontrol('style','pushbutton','units','norm','position',[0 .4 .2 .05],...
    'string','stat DTI parameter',...
    'tag','statDTIparameter','backgroundcolor','w','callback',@statDTIparameter,...
    'tooltipstring','calculate statistic for DTI parameter');

h=uicontrol('style','pushbutton','units','norm','position',[0.2 .4 .2 .05],...
    'string','stat Connectivity',...
    'tag','statconnectivity','backgroundcolor','w','callback',@statconnectivity,...
    'tooltipstring','calculate statistic for connectivity data');

%••••••••  redisplay data ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

h=uicontrol('style','pushbutton','units','norm','string','redisplay data',...
    'tag','redisplay','backgroundcolor','w','callback',@redisplay,'fontweight','bold');
set(h,'position',[0.13 .35 .14 .05],'backgroundcolor','w');

%••••••••  plot ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .3 .14 .05],...
    'string','plot Results',...
    'tag','plotdata','backgroundcolor','w','callback',@show,...
    'tooltipstring','visualize results: for type of visulization see right pulldown menu');

h=uicontrol('style','popupmenu','units','norm','position',[0.27 .3 .15 .05],...
    'string',{'matrix' 'plot3d'},'tag','menuplot','backgroundcolor','w',...
    'tooltipstring','type of visualization to show');

%••••••••  export ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .25 .14 .05],...
    'string','export Results',...
    'tag','export','backgroundcolor','w','callback',@export,...
    'tooltipstring','export results (excelfile)');


%••••••••  other stuff pulldown ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

h=uicontrol('style','popupmenu','units','norm',...
    'string',{...
    '-info-'
    'get code'  
    'reload data and parameter'}, 'tag','otherfun','backgroundcolor','w','callback',@otherfun,...
     'tooltipstring','..other stuff');
set(h,'position',[.8 .75 .195 .05])




%———————————————————————————————————————————————
%%   inputs
%———————————————————————————————————————————————
function inputs(args)
% if nargin >0
if ~isempty(args)    
    %p=varargin{1}
    if isstruct(args{1})
        p=args{1};
    else
        p={};
        for i=1:2:length(args)
            p=setfield(p,args{i},args{i+1});
        end
    end
    
    if isfield(p,'reset') && p.reset==1  %reset GUI: dtistat('reset',1)
        createGui;
    end
    
    
    if isfield(p,'groupfile');        groupfile(  p.groupfile)   ;   end
    if isfield(p,'confiles');         confiles(   p.confiles)    ;   end
    if isfield(p,'paramfiles');       paramfiles( p.paramfiles)  ;   end
    
    
    
    hfig=findobj(0,'tag','dtistat');
    ss={'f1design' 'F1design'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value',  getfield(p,ss{1}) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    
    ss={'typeoftest1' 'typeoftest1'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value',  regexpi2(get(hh,'string'),['^' getfield(p,ss{1}) '$'  ]) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    
    ss={'isfdr' 'isfdr'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value',  getfield(p,ss{1}) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    ss={'showsigsonly' 'showsigsonly'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value', getfield(p,ss{1}) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    ss={'issort' 'issort'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value',  getfield(p,ss{1}) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    
    %reverse contrast
    ss={'reversecontrast' 'reversecontrast'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'value',  getfield(p,ss{1}) );
        %hgfeval( get(hh,'callback')  ,hh);
    end
    
    ss={'qFDR' 'qFDR'};
    if isfield(p,ss{1});
        hh=findobj(hfig,'tag',ss{2});
        set(hh,'string',  num2str(getfield(p,ss{1})) );
        
        %hgfeval( get(hh,'callback')  ,hh);
    end
    
    if isfield(p,'outvar')   %% OUTPUT VARIABLE
        ux=get(hfig,'userdata');
        ux.outvar=p.outvar;
        set(hfig,'userdata',ux);
    end
    %
    
    if isfield(p,'noSeeds')   %% OUTPUT VARIABLE
        ux=get(hfig,'userdata');
        ux.noSeeds=p.noSeeds;
        set(hfig,'userdata',ux);
        set(findobj(hfig,'tag','noSeeds') ,'string',num2str(ux.noSeeds));
    end
    
     if isfield(p,'roifile')
         loadroi(p.roifile);
     end
    
    
    figure(hfig);
    drawnow;
    
    if isfield(p,'runstat')
        runstat(p.runstat);
    end
    
    if isfield(p,'export');
        figure(findobj(0,'tag','dtistat'));
        drawnow;
        us=get(gcf,'userdata');
        export2excel(us,p.export) ;
    end
    
    if isfield(p,'show');
       showresults(0) ;
    end
    
    
end


if 0
    dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...% % USE THIS GROUPASIGNMENT-FILE
        'confiles',confiles,'paramfiles',paramfiles        ,...       % % USE THIS  DTI-PARAMETER FILES & %DTI-CONNECTIVITY FILES
        'f1design',  0,        'typeoftest1' ,    'Ttest2' ,...       % % BETWEEN DESIGN,  2-sample Ttest
        'isfdr',     1,        'qFDR'        ,     0.05    ,...       % % FDR CORRECTION, USING THIS FDR-Q-THRESHOLD
        'issort',    1,        'showsigsonly',      1      ,...       % % SORT ACCORDING P-VALUES, SHOW ONLY SIGNIFICANT RESULTS
        'runstat','con')                          % % RUN STATISITC FOR CONNECTIVITY
    
    dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...% % USE THIS GROUPASIGNMENT-FILE
        'confiles',confiles,'paramfiles',paramfiles        ,...       % % USE THIS  DTI-PARAMETER FILES & %DTI-CONNECTIVITY FILES
        'f1design',  0,        'typeoftest1' ,    'Ttest2' ,...       % % BETWEEN DESIGN,  2-sample Ttest
        'isfdr',     1,        'qFDR'        ,     0.05    ,...       % % FDR CORRECTION, USING THIS FDR-Q-THRESHOLD
        'issort',    1,        'showsigsonly',      1      ,...       % % SORT ACCORDING P-VALUES, SHOW ONLY SIGNIFICANT RESULTS
        'runstat','con','outvar', 'results')
    
end

commandwindow;

% function stat(param)
% runstat(param);


function closeresultwindows(e,e2)
delete(findobj(0,'tag','uhelp'));


function statDTIparameter(e,e2)
runstat(1);
function statconnectivity(e,e2)
runstat(2);



function call_f1design(e,e2)
us=get(gcf,'userdata');
val=get(e,'value');
us.f1design=val;
set(gcf,'userdata',us);

htests=findobj(gcf,'tag','typeoftest1');
if val==0 %between
    set(htests,'string',{'ttest2' 'WST' 'permutation' 'permutation2'});
else
    set(htests,'string',{'ttest' 'xx' 'yy'});
end


function loadgroupassignment(e,e2)
groupfile
function loadDTIparameter(e,e2)
paramfiles

function loadDTIConnectivity(e,e2)
confiles






function groupfile(file)


us=get(gcf,'userdata');
if exist('file')==0
    [fi pa]=uigetfile(pwd,'select group assignment file (excel file)','*.xls');
    if pa==0; return; end
    file=fullfile(pa,fi);
end

us.groupfile=file;
set(gcf,'userdata',us);

%check groupsize
[~,~,a]=xlsread(file);
a(1,:)=[]
a=cellfun(@(a){[ num2str(a)]},a); % to string
a(regexpi2(a(:,1),'NaN'),:)=[] ; %remove nan
a(regexpi2(a(:,2),'NaN'),:)=[] ;
tb=tabulate((a(:,2)));
gp='';
for i=1:size(tb,1)
    gp=[gp ['grp-' tb{i,1} ' (n=' num2str(tb{i,2}) ')' ] ];
    if i<size(tb,1)
        gp=[gp ', '  ];
    end
end
cprintf([0 .5 0],['Ncases found: '   num2str(sum(cell2mat(tb(:,2)))) '\n']);
cprintf([0 .5 0],['subgroups   : '   gp '\n']);


function paramfiles(files)
%———————————————————————————————————————————————
%%   load DTI-PARAMETER
%———————————————————————————————————————————————
us=get(gcf,'userdata');
if isempty(files); return; end
if exist('files')==0
    pa=pwd
    % [files,dirs] = spm_select('FPListRec',pa,'.*.parameter_stat.txt');
    % if isempty(files);
    %     disp('no DTI-parameter files found');
    %     return
    % end
    % fi=cellstr(files);
    
    msg={'select DTI-parameter file (TXTfile)'
        'select DTI-parameter file from DSI-studio'
        ' -this data should be txt-files'
        ' -select the folder that contains the DTI-parameter files'
        ' -click [rec] to recursively find all files in the subdirs of the selected folder'};
    [fi,sts] = cfg_getfile2(inf,'any',msg,[],pa,'.*.parameter_stat.txt');
    if isempty(char(fi))
        disp('no DTI-parameter files selected');
        return
    end
else
    fi=files;
end

params={'Name' ...
    'fa mean' 'adc mean' 'axial_dif mean' 'radial_dif mean' ...
    'radial_dif1 mean'      'radial_dif2 mean'};


clear d2;
for i=1:size(fi,1)
    cprintf([0 0 1],['[reading]: '   strrep(fi{i},[filesep],[filesep filesep])  '\n']);
    a=preadfile(fi{i});
    a=a.all;
    d={};
    % read parameters
    for j=1:length(params)
        ix=  regexpi2(a,params{j});
        str=regexprep(a{ix},['^' params{j}],'');
        if strcmp(params{j}, 'Name')
            [~,namex]=fileparts(fi{i});
            d.mousename=namex;
            d.file=fi{i};
            
            str=strsplit((str),'\t')';
            str(find(cellfun(@isempty,str)))=[];
            % d= setfield(d,params{j},str)
            d.regions=str;
            
            dx=zeros( size(params,2)-1   ,length(str));
            param=params(2:end);
        else
            val=str2num(str);
            dx(j-1,:)=val;
        end
    end
    
    d.paramname=param';
    d.data     =dx;
    
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    d2(i)=d;
end


us.dtiparameter=d2;
set(gcf,'userdata',us);


%———————————————————————————————————————————————
%%   load connectivity files
%———————————————————————————————————————————————
function confiles(files)
us=get(gcf,'userdata');
if exist('files')==0
    msg={'select connectivity data (MATfile)'
        'select connectivity data from DSI-studio'
        ' -this data should be mat-files'
        ' -select the folder that contains the connectivity data'
        ' -click [rec] to recursively find all files in the subdirs of the selected folder'};
    [fi,sts] = cfg_getfile2(inf,'mat',msg,[],pwd,'.*rk4_end.mat|.*_connectivities.mat');
    if isempty(char(fi))
        disp('no files selected');
        return
    end
else
    fi=files;
end


con=[];
names={};
for i=1:size(fi,1)
    cprintf([0 0 1],['[reading]: '   strrep(fi{i},[filesep],[filesep filesep])  '\n']);
    a=load(fi{i});
    label=char(a.name);
    label=strsplit(label,char(10))';
    label(find(cellfun(@isempty,label)))=[] ;
    
    [~,namex]=fileparts(fi{i});  %mousename
    ac=a.connectivity;           %connectMAtrix
    
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
    
    
    
    %% check
    % s=zeros(prod(si),1);s(ind)=val; s=reshape(s,[si]); s= s+s'
end

c={};
c.mousename=names;
c.files    =files;
c.conlabels=connames;
c.condata  =con;
c.size     =si;
c.index    =ind;
c.labelmatrix=la;
c.label      =label;

us.con=c;

set(gcf,'userdata',us);



function runstat(param)
us=get(gcf,'userdata');


if ischar(param)
    switch(param)
        case{'dti' 'DTI' };
            param=1;
        case{'con' 'CON' 'Con' 'connectivity'};
            param=2;
        otherwise
            return
    end
end


%———————————————————————————————————————————————
%%   loading groupassignment
%———————————————————————————————————————————————
[~,~,a]=xlsread(us.groupfile);
a(1,:)=[];
a=cellfun(@(a){[ num2str(a)]},a);
a=a(:,1:2);

%———————————————————————————————————————————————
%%   check order
%———————————————————————————————————————————————
if param==1
    xx=us.dtiparameter;
    ids={xx(:).mousename}';
    ids=strrep(ids,'_dti_parameter_stat','');
else
    xx=us.con;
    ids=xx.mousename';
    ids=regexprep(ids,'__dti.*','');
    ids=regexprep(ids,'_dti.*','');
    ids=regexprep(ids,'_Con.*|_con.*|_CON.*','');
    
end


%% check
% delete some files/ids and reorder
if 0
    xx(5:8)=[];
    a(10:15,:)=[];
    a=flipud(a);
end






a2=a(:,1);
a2(:,2:3)={nan};
for i=1:length(ids)
    ix=regexpi2(a(:,1), [ids{i} '$' ]);
    
    if length(ix)>1
        cprintf([1 0 1],['more than one assignment found for mouse [' ids{i} '] *** '  '\n']);
        for j=1:length(ix)
            cprintf([1 0 1],['[ douplicates?]: '   strrep(a{ix(j)},[filesep],[filesep filesep])  '\n']);
        end
        disp('.. first entry is used !!! ');
        ix=ix(1);
    end
    if ~isempty(ix)
        a2(ix,2:3)= {i ids{i}} ;
    end
end

idel=find(isnan(cell2mat(a2(:,2))));
if ~isempty(idel)
    %     cprintf([1 0 1],['PROBLEM with assignment [matfiles]: '  '\n']);
    %     disp(a2(idel,1));
    %      cprintf([1 0 1],['PROBLEM with assignment [excelfile]: '  '\n']);
    %     disp(a);
    
    cprintf([1 0 1],['PROBLEM with string assignment [names in excelfile and matfiles deviate]: '  '\n']);
    cprintf([1 0 1],['check that names in excelfile and matfiles have the same spelling.. '  '\n']);
    cprintf([1 0 1],['left column shows only those names in the excel file that have not been found '  '\n']);
    cprintf([1 0 1],['right column shows names of all! matfiles'  '\n']);
    tbx=repmat({''},[max([size(a2(idel,1),1) length(ids) ])  2]);
    tbx(1:size(a2(idel,1),1),1) =a2(idel,1);
    tbx(1:length(ids),2)         =  ids;
    disp([{'NAME IN XLSFILE NOT FOUND'  'NAME OF MATFILE';...
        '=======================' '======================='};...
        tbx]);
end


if 0
    a2(idel,:)=[];
    a(idel,:) =[];
    if param==1
        xx(idel) =[];
    elseif param==2
        xx.mousename(idel)=[];
        xx.condata(:,idel)=[];
    end
end


%% check
% a(1:6 ,2)  ={'v1'}
% a(7:12,2)  ={'v2'}
% a(13:end,2)={'v3'}

disp('__________________________________________________')
disp(' ASSIGNMENT (assignment-ID, DTI-idx, DTI-id)');
disp(' ** check for NANS --> these data will be excluded and might be caused by')
disp('   inconsistent IDS/names  ');
disp('__________________________________________________')
disp(a2);

tb=[a a2(:,2)];
%———————————————————————————————————————————————
%%   group
%———————————————————————————————————————————————


grp=unique(a(:,2));

% ## flip contrast-direction
if get(findobj(gcf,'tag','reversecontrast'),'value')==1
    grp=flipud(grp(:));
end
%———————————————————————————————————————————————
%%   pairwisecomparisons
%———————————————————————————————————————————————
comb   =combnk(grp,2);
combstr=cellfun(@(a,b){[ a ' > ' b]},comb(:,1),comb(:,2));

grpsize=[];
for i=1:length(grp)
    is=regexpi2(tb(:,2),grp{i}) ;%deal with nan
    grpsize(1,i) =sum(~isnan(cell2mat(tb(is,3))))  ; %length(regexpi2(tb(:,2),comb(i)));
end




% combstr=cellfun(@(a,b){[ a ' > ' b]},comb(:,1),comb(:,2));
us.contrast=[[grp{1} '>' grp{2}]];
us.grpnames=grp ;%comb;
us.grpsize=grpsize;


%———————————————————————————————————————————————
%%   display group membership
%———————————————————————————————————————————————

% tb(12:18,3)={nan}

gname={};
len=[];
nchar=[];
for i=1:length(grp)
    is=regexpi2(tb(:,2),grp(i));
    is=find(~isnan(cell2mat(tb(is,3)))); %NANS
    dum=tb(is,1);
    dum=[{['# GROUP-' grp{i} ' # (n=' num2str(length(is)) ')'] }; dum];
    gnames{1,i}=dum;
    
    len(i)=size(gnames{1,i},1);
    nchar(i)=size(char(gnames{1,i}),2);
end

mxchar=max(nchar);
disp('____________________________________________________________________________________________');
disp('  GRPUP ASSIGNMENT --> PLEASE CHECK THIS');
disp('____________________________________________________________________________________________');

for i=1:max(len)
    sv='';
    for j=1:size(gnames,2)
        try
            sd=char(gnames{j}(i));
        catch
            sd='';
        end
        sd=[sd repmat(' ', [1 mxchar-length(sd)+5])];
        sv=[sv sd];
    end
    disp(sv);
end
disp('____________________________________________________________________________________________');






%———————————————————————————————————————————————
%%   parameter
%———————————————————————————————————————————————
z.f1design    = get(findobj(gcf,'tag','F1design'),'value');
z.typeoftest1 = get(findobj(gcf,'tag','typeoftest1'),'value');



%———————————————————————————————————————————————
%%   pairwise tests
%———————————————————————————————————————————————

if param==1
    nparams= xx(1).paramname;
elseif param==2
    nparams=1;
end





vartype=1;
% us.typeoftest1=1;  %[1]ttest2,[2]WRS
hfig=findobj(0,'tag','dtistat');
z.issort        =get(findobj(hfig,'tag','issort'),'value');
z.isfdr         =get(findobj(hfig,'tag','isfdr'),'value');
z.showsigsonly  =get(findobj(hfig,'tag','showsigsonly'),'value');
z.qFDR          =str2num(get(findobj(hfig,'tag','qFDR'),'string'));
z.vartype       =vartype;
z.noSeeds       =str2num(get(findobj(hfig,'tag','noSeeds'),'string'));



n=1;
try; us=rmfield(us,'pw');end
if z.f1design==0 %between
    
    for i=1:size(comb,1)
        for k=1:length(nparams)
            
            s1=regexpi2(tb(:,2),comb(i,1)); % index of groubmembers in table "tb"
            s2=regexpi2(tb(:,2),comb(i,2));
            
            %remove nans
            s1( isnan(cell2mat(tb(s1,3)))  )=[];
            s2( isnan(cell2mat(tb(s2,3)))  )=[];
            
            i1=cell2mat(tb(s1,3)); % % index of groubmembers in list of fullpath-parmfiles/confiles
            i2=cell2mat(tb(s2,3));
            
            %sanitiy check
            if 0
                sancheck={};
                sancheck{end+1,1}=['## ' comb{i,1} ' ####'] ;
                sancheck=[sancheck; [ {xx(i1).mousename}']];
                sancheck{end+1,1}=['## ' comb{i,2} ' ####'] ;
                sancheck=[sancheck; [ {xx(i2).mousename}']];
            end
            
            
            str=combstr{i};
            % disp(sprintf(['groupsize ' ': %d vs %d'],[length(i1) length(i2)]));
            if param==1
                paramname=xx(1).paramname{k};
                [x y]=deal([]);
                for j=1:length(i1)
                    d=xx(i1(j)).data;
                    x(:,j)=d(k,:);
                end
                for j=1:length(i2)
                    d=xx(i2(j)).data;
                    y(:,j)=d(k,:);
                end
                groupmembers={'##tobe implemented yet' 'soon'};
            elseif param==2
                paramname='connectivity';
                x=xx.condata(:,i1);
                y=xx.condata(:,i2);
                groupmembers=  {xx.mousename(i1)' xx.mousename(i2)'};
            end
            grouplabel=comb(i,:);
            
            if z.typeoftest1==1
                stattype='ttest2';
                [h p ci st]=ttest2(x',y');
                [out hout]=getMESD(x,y,vartype);
                res    =[ h'   p'  st.tstat'   out   st.df'     ] ;
                reshead=['H'  'p'    'T'      hout     'df'     ];
                % reshead={'hyp' 'p' 'T' 'ME' 'SD' 'SE'  'n1' 'n2' 'df'};
                ikeep=find(~isnan(res(:,1)));
            elseif z.typeoftest1==2
                stattype='WRS';
                res=nan(size(x,1),[3]);
                [out hout]=getMESD(x,y,vartype);
                
                if regexpi(us.props.wst_stat,'Z','ignorecase')==1    % Z-SCORE
                   for j=1:size(x,1)
                        
%                         d1=x(j,:); d2=y(j,:);
%                         tr=2.5;
%                         d1( find(d1>(mean(d1)+tr*std(d1)) | d1<(mean(d1)-tr*std(d1))  ) )=[];
%                         d2( find(d2>(mean(d2)+tr*std(d2)) | d2<(mean(d2)-tr*std(d2))  ) )=[];
%                        [p h st]=ranksum(d1,d2);
%                         disp([length(d1)  length(d2)]);
                          [p h st]=ranksum(x(j,:),y(j,:));
                       try
                           res(j,:)=[h p st.zval];
                       catch
                            res(j,:)=[h p nan];
                       end
                    end
                    res    =[ res          out];
                    reshead=['H' 'p' 'zval' hout];  
                else                                                 % RS-SCORE
                    for j=1:size(x,1)
                        try
                            [p h st]=ranksum(x(j,:),y(j,:));
                            res(j,:)=[h p st.ranksum];
                        end
                    end
                    res    =[ res          out];
                    reshead=['H' 'p' 'RS' hout];
                end
                
                %reshead={'hyp' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
                ikeep=find(~isnan(res(:,1)));
            elseif z.typeoftest1==3
                stattype='perm';
                px= permtestmat(x',y',1000,'approximate');
                h=px<0.05;
                [out hout]=getMESD(x,y,vartype);
                res    =[ h  px    out];
                reshead=['H' 'p'  hout];
                %reshead={'H' 'p' 'ME' 'SD' 'SE' 'n1' 'n2'};
                [hv px]=ttest2(x',y');
                ikeep=find(~isnan(hv));
            elseif z.typeoftest1==4
                stattype='perm2';
                %tic;[pv,to,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05); toc
                [p,T,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05);
                p(find(isnan(T)))=1;
                h=p<0.05;
                [out hout]=getMESD(x,y,vartype);
                res    =[ h'  p'  T'  out ] ;
                reshead=['H' 'p' 'T' hout ];
                %reshead={'hyp' 'p' 'T'    'ME' 'SD' 'SE' 'n1' 'n2'   };
                
                [hv px]=ttest2(x',y');
                ikeep=find(~isnan(hv));
                
                
                
                
                %             [p,T,cr,al]=mult_comp_perm_t2_nan(x(ix,:)',y(ix,:)',5000,0,.05);
                
            end
            %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
            %% deal with missings
            xex =sum(~isnan(x),2)./size(x,2);
            yex =sum(~isnan(y),2)./size(y,2);
            ix=find((xex>.9)&(yex>.9)&(~isnan(h(:)))  );  %90% of data must exist
            ikeep=ix;
            ikeep=1:size(x,1);
            
            
            
            res2=res(ikeep,:);
            pw.str       =str;
            pw.parameter =paramname;
            pw.stattype  =stattype;
            pw.tb        =res2;
            pw.ikeep     =ikeep;
            
            pw.groupmembers=groupmembers;
            pw.grouplabel=grouplabel;
            %pw.groupsize =[size(x,1) size(y,1)];
            
            pw.tbhead    =reshead;
            if param==1
                pw.lab =xx(1).regions(ikeep);
                pw.mode ='DTI PARAMETERS';
            elseif param==2
                pw.lab =  xx.conlabels(ikeep);
                pw.mode ='DTI CONNECTIVITY';
                
                % CALC NETWORKPARAMETER
                [out expo]=calc_networkparameter(x,y, us,z);
                pw.networkmetrics     =out;
                pw.networkmetricsExport=expo;
            end
            
            us.pw(n)=pw;
            
            %% ROI
            if isfield(us,'roifile')
                if exist(us.roifile)==2
                    us=prunebyROIS(us);
                    
                end
                
            end
            
            
            n=n+1;
        end %params
    end %combs
    set(gcf,'userdata',us);
    drawnow;
    showresults(0);
    
end





function out=showresults(task, par)
out=[];
hfig=findobj(0,'tag','dtistat');
us=get(hfig,'userdata');
if exist('task') && strcmp(task,'export')
    
    doexport=1;
    if isfield(par,'exportfile')==0
        [file,pa] = uiputfile('*.xlsx','SAVING!!! specify filename');
        
        if file==0; return; end
        file= [ strrep(file,'.xlsx','') '.xlsx'];
        file=fullfile(pa,file);
    else
        file=par.exportfile;
    end
    disp('..exporting ');
else
    doexport=0;
end

% [~,fi]=fileparts(us.data);
%% GET PARAMETERS
hfig=findobj(0,'tag','dtistat');
z.issort        =get(findobj(hfig,'tag','issort'),'value');
z.isfdr         =get(findobj(hfig,'tag','isfdr'),'value');
z.showsigsonly  =get(findobj(hfig,'tag','showsigsonly'),'value');
z.qFDR          =str2num(get(findobj(hfig,'tag','qFDR'),'string'));
z.noSeeds       =str2num(get(findobj(hfig,'tag','noSeeds'),'string'));

%groupsizes
% tab=tabulate(cell2mat(us.tb(:,2)));
%     groupsize=cellfun(  @(a,b)  {['n group-' a ': '  sprintf('%2.0d',b )] }      ,tab(:,1),tab(:,2) );

grp='';
for i=1:length(us.grpnames)
    grp= [grp  [' "' us.grpnames{i} '"' '(n=' num2str(us.grpsize(i))  ')'] ];
end

%% SHOW RESULTS


sz={};
% sz{end+1,1}=['                           '];
% sz{end+1,1}=[' § *********************************************************************************************'];
% sz{end+1,1}=[' §                 '    us.pw(1).mode                              ];
% sz{end+1,1}=[' § *********************************************************************************************'];

sz{end+1,1}=['_____________________________________________________________________________________________________________________'];
sz{end+1,1}=[' #wr                 '    us.pw(1).mode                              ];
sz{end+1,1}=['_____________________________________________________________________________________________________________________'];


% sz{end+1,1}=['MODE          : '      us.pw(1).mode          ];
sz{end+1,1}=['Group file:        '      us.groupfile];


if isfield(us,'roifile')
    roifile=us.roifile;
else
    roifile='none';
end
sz{end+1,1}=['ROI/COI file:      '       roifile];
 
sz{end+1,1}=['groups (size):     '      grp];

try
sz{end+1,1}=['# pairwise nodes:  '      num2str(length(us.pw(1).lab))];
end




sz{end+1,1}=['pairwise test:     '      us.pw(1).stattype];
sz{end+1,1}=['FDR-correction:    '      regexprep(num2str(z.isfdr),{'1' '0'},{'yes','no'})];
if z.isfdr==1
sz{end+1,1}=['FDR-qValue:        '      num2str(z.qFDR)];
end
sz{end+1,1}=['sorting:           '      regexprep(num2str(z.issort),{'1' '0'},{'yes','no'})];
sz{end+1,1}=['showsigsonly:      '      regexprep(num2str(z.showsigsonly),{'1' '0'},{'yes','no'})];

if strcmp(us.pw(1).mode,'DTI CONNECTIVITY')
sz{end+1,1}=['noSeeds:           '      num2str(z.noSeeds)   ' (for NW-metrics only)'];
end

% char(sz)


info2export=sz;


%     sz{end+1,1}=['********************************************************************************'];
if doexport==1
    if exist(file)==2
        try;
            %!taskkill /f /im excel.exe
            evalc('system(''taskkill /f /im excel.exe'')');
        end
        try delete(filename); end
    end
    
    xlswrite( file, sz, 'info');
end

for i=1:size(us.pw,2)
    
    dat=[[ us.pw(i).lab] num2cell(us.pw(i).tb) ];
    head=['Label' us.pw(i).tbhead];
    
    
    if z.isfdr==1
        
        ival=find(~isnan(sum(cell2mat(dat(:,2:3)),2)));
        H=zeros(size(dat,1),1);
        % Hx=fdr_bh([dat{ival,3}]',z.qFDR,'pdep','no');
        [Hx, crit_p, adj_ci_cvrg, adj_p]=fdr_bh([dat{ival,3}]',z.qFDR,'pdep','no');
        
        
        H(ival)=Hx;
        adj_pFDR=nan(size(H));
        adj_pFDR(ival)=adj_p;
        dat = [dat(:,1)  num2cell(H)    dat(:,2)    dat(:,3:end)  num2cell(adj_pFDR)    ];
        head= [head(1)    'Hfdr'       'Huncor'     head(3:end)        'adj_pFDR'       ];
        
        %         H=fdr_bh([dat{:,3}]',z.qFDR,'pdep','no');
        %         dat(:,2)=num2cell(H);
        %         head(2)={'H_FDR'};
        us.pw(i).fdr=H;
        %     else
        %         us.pw(i).fdr=us.pw.tb(:,1);
    end
    
    dat(:,2)=num2cell(double(cell2mat(dat(:,2))));
    isort=[1:size(dat,1)]';
    if z.issort==1
        [dat isort]= sortrows(dat,[3 2]);
    end
    
    if z.showsigsonly==1
        dat= dat(find([dat{:,2}]==1),:);
    end
    
    sx=[[head;dat]];
    if isempty(dat);
        sx=[us.pw(i).str ' :  - '];
        sx={'ns.' };
    end
    
    
    %     try%ADD ANOTTIONS (regiongroups)
    %        sx= [sx [ 'ro';us.pw(i).labsgrouped(isort)] ];
    %     end
    
    if doexport==1
        
        xlswrite( file, sx, us.pw(i).str);
        xlsAutoFitCol(file,us.pw(i).str,'A:Z');
    else
        
        sy=plog({},{repmat('_',[ 1 50]) ; ...
            [' #bo ' us.pw(i).str  ' ***  ' us.pw(i).parameter ];...
            repmat('_',[ 1 50]) ...
            },'s=0','plotlines=0');
        if isempty(dat)
            sz=[sz;sy;'ns.'];
            
            %% export data  (data do not exist)
            us.pw(i).tbexport={[us.pw(i).str  ' #'  us.pw(i).parameter] {'Result'; 'ns.'}};
        else
            sz=[sz;sy ];
            dexport =sx;
            
            sx(2:end,3)=cellfun(@(a){sprintf('%1.4g',a)},sx(2:end,3)); % p-values other format
            
            %sx(2:end,:)=reformat( sx(2:end,:) ,'%.5g');
            % [~,sz]=plog(sz,sx,0,[us.pw(i).str],'s=1','plotlines=0');
            
            
            reshead =sx(1,:);
            d       =sx(2:end,:);
            isnum=cellfun(@isnumeric,d);
            d2      =d;
            reshead2=reshead;
            for col=1:size(d,2)
                if isempty(   find(isnum(:,col) )); continue; end
                if any((sign(cell2mat(d(find(isnum(:,col) ),col))))==-1) == 1   %negativ values
                    d2(:,col)= cellfun(@(a){sprintf('% .5g',a)},d2(:,col));
                    reshead2{col}=[' ' reshead2{col}];
                else %positiv values
                    d2(:,col)= cellfun(@(a){sprintf('%.5g',a)},d2(:,col));
                end
            end
            sx2=[reshead2;d2];
            [~,sz]=plog(sz,sx2,0,[us.pw(i).str],'s=1','plotlines=0');
            
            %% export data  (data exist)
            us.pw(i).tbexport={[us.pw(i).str  ' #'  us.pw(i).parameter] dexport};
            
            
        end
        
        us.pw(i).tbexportinfo=info2export;
        %         uhelp(plog({},sx,0,[us.pw(i).str],'s=0'),1);
        %sz=sz(1:end-1,:);
    end
    
    
    
end

%% PLOT NETWORKPARAMETER
if strcmp(us.pw(1).parameter,'connectivity')
    nw=repmat({'   '},[2 1]);
    for i=1:size(us.pw,2)
        nw=[nw ; repmat('_',[1 100] )];
        nw=[nw; [' #yk NETWORK METRICS:  '        us.pw(i).str ]];
        nw=[nw ; repmat('_',[1 100] )];
        nw=[nw; us.pw(i).networkmetrics];
    end
    %     uhelp(nw,1);
    sz=[sz;nw];
end

%%  next

set(gcf,'userdata',us);
out=sz;

%% assgin output
if ~isempty(us.outvar)
    assignin('base',us.outvar,out);
end


if doexport~=1
    %     uhelp(plog({},sz,0,[''],'s=0','plotlines=0' ),1);
    if exist('par')==1 & (strcmp(par,'nofig'))
    else
        uhelp(sz,1);
    end
    
    %     assignin('base','stat',sz);
end

if doexport==1
    removexlssheet(file);
    xlsstyle(file);
    disp(['created: <a href="matlab: system('''  [file] ''');">' [file] '</a>']);
end





function [out head]=getMESD(x,y,vartype)

% vartype=1

s2x = nanvar(x,[],2);
s2y = nanvar(y,[],2);
% difference = nanmean(x,2) - nanmean(y,2);

M1  =nanmean(x,2) ;
M2  =nanmean(y,2);
sd1 =nanstd(x,[],2) ;
sd2 =nanstd(y,[],2);
diffxy=M1-M2;

Med1  =nanmedian(x,2);
Med2  =nanmedian(y,2);

xnans = isnan(x);
if any(xnans(:))
    nx = sum(~xnans,2);
else
    nx = size(x,2); % a scalar, => a scalar call to tinv
end
ynans = isnan(y);
if any(ynans(:))
    ny = sum(~ynans,2);
else
    ny = size(y,2); % a scalar, => a scalar call to tinv
end

if vartype == 1 % equal variances
    dfe = nx + ny - 2;
    sPooled = sqrt(((nx-1) .* s2x + (ny-1) .* s2y) ./ dfe);
    se = sPooled .* sqrt(1./nx + 1./ny);
    %ratio = difference ./ se;
end
out =[diffxy   M1    M2    sd1 sd2     sPooled   se        sum(~isnan(x),2) sum(~isnan(y),2)  Med1 Med2];
head={'diff'  'ME1' 'ME2'  'SD1' 'SD2' 'Var(p)' 'SE(p)'    'n1' 'n2'                         'Med1' 'Med2' };


function show(e,e2)
hf=findobj(0,'tag','dtistat');
type=get(findobj(hf,'tag','menuplot'),'value');
us=get(hf,'userdata');



if strcmp(us.pw(1).parameter,'connectivity')==0
    
    %% ra
    params=us.dtiparameter(1).paramname;
    is=regexpi2({us.pw(:).parameter},params{1});
    
    for j=1:length(is)
        ix=is(j):is(j)+length(params)-1;
        
        val=[];
        pval=[];
        for i=1:length(ix)
            val(i,:)  =us.pw(ix(i)).tb(:,3);
            pval(i,:) =us.pw(ix(i)).tb(:,2);
            param{i,1}=us.pw(ix(i)).parameter;
            fdr(i,:)  =us.pw(ix(i)).fdr;
        end
        lab =us.pw(ix(i)).lab;
        cond=us.pw(ix(i)).str;
        stattype=us.pw(ix(i)).stattype;
        
        
        fg
        px=[ 0.15    0.1100    0.2    0.8150];
        hu=uicontrol('style','text','units','norm','position',[0 .9 .5 .05]);
        set(hu,'string',['comparison [' cond '] (stat:' stattype ')' ],'position',[0 .95 .5 .03],'backgroundcolor','w');
        set(hu,'foregroundcolor','b','fontweight','bold');
        for i=1:3
            ps=px;
            vx=val;
            if i==1
                ms='DTI uncorr';
            elseif i==2
                ps(1)=.35+.01;
                vx=vx.*(pval<0.05);
                ms='DTI p<0.05';
            elseif i==3
                ps(1)=(.55)+(.01*2);
                vx=vx.*(fdr);
                ms='DTI FDRcorr';
            end
            ha(i)=axes('position',ps);
            imagesc(vx');
            jet2=jet;
            jet2(32:34,:)=1;
            
            ti=title(ms); set(ti,'fontsize',8);
            
            if i==1
                clim=caxis;
                cl=max(abs(clim));
                clim=[-cl cl];
                caxis(clim);
                colormap(jet)
            else
                colormap(jet2)
                caxis(clim);
            end
            
            
        end
        
        
        axes(ha(1))
        labs=strrep(lab,'_' ,'\_');
        set(gca,'ytick',[1:length(lab)],'yticklabels',labs);
        set(gca,'fontsize',5);
        
        param2=strrep(param,' mean','');
        param2=strrep(param2,'_' ,'\_');
        set(gca,'xtick',[1:length(param2)],'xticklabels',param2);
        set(gca,'xTickLabelRotation',30);
        
        axes(ha(2)); set(gca,'xtick',[]);
        set(gca,'xtick',[1:length(param2)],'xticklabels',param2);
        set(gca,'xTickLabelRotation',30);
        set(gca,'fontsize',5);
        
        axes(ha(3));  set(gca,'xtick',[]);
        set(gca,'xtick',[1:length(param2)],'xticklabels',param2);
        set(gca,'xTickLabelRotation',30);
        set(gca,'fontsize',5);
        set(gca,'ytick',[1:length(lab)],'yticklabels',labs);
        set(gca,'YAxisLocation','right');
        
        
        cb=colorbar;
        px=get(cb,'position');
        set(cb,'position', [ .96 .1 .01 .35] ,'fontsize',6,'fontweight','bold');
        
    end %params
    %% ro
end




if strcmp(us.pw(1).parameter,'connectivity')
    if type==1
        
        for j=1:size(us.pw,2)
            r=us.pw(j);
            
            
            %% bl
            f=figure;
            set(f,'units','norm','color','w','menubar','none')
            ha = tight_subplot(2,2,[.05 .05],[.05 .05],[.05 .05]);
            %set(ha,'tag','myax');
            
            val=r.tb(:,3);
            for k = 1:3
                axes(ha(k));
                set(ha(k),'tag','myax');
                
                % s=zeros(prod(si),1);s(ind)=val; s=reshape(s,[si]); s= s+s'
                si=us.con.size;
                s=zeros(prod(si),1);
                val=r.tb(:,3);
                if k==1
                    ms=[r.stattype '(' r.tbhead{3} ') uncorrectd'];
                elseif k==2
                    val=val.*(r.tb(:,2)<.05);
                    ms=[r.stattype '(' r.tbhead{3} ') using p<0.05'];
                elseif k==3
                    val=val.*r.fdr;
                    ms=[r.stattype '(' r.tbhead{3} ') FDRcorrected'];
                end
                s(us.con.index)=val;
                s=reshape(s,[si]);
                s(isnan(s))=0;
                
                im=imagesc(s);
                if k==1
                    clim=caxis;
                else
                    caxis(clim);
                end
                
                pval=zeros(prod(si),1);
                pval(us.con.index)=r.tb(:,2);
                pval=reshape(pval,[si]);
                
                
                sx.pval=pval;
                set(im,'userdata',sx)
                ht=title(ms,'fontsize',8);
                set(gca,'fontsize',6);
                
            end
            %delete(ha(4))
            axes(ha(4)); axis off
            set(ha(4),'tag','ax4');
            ms=['[' r.str ']' '  (test: ' r.stattype ')' ];
            te=text(0,.8,ms,'fontsize',6,'tag','txt0','interpreter','tex','color',[0 0 1],'fontweight','bold');
            
            set(gcf,'WindowButtonMotionFcn',{@motion,'1'});
            
            set(ha(1:k),'tag','myax');
            
            axes(ha(1));
            cb=colorbar;
            pos=get(cb,'position');
            set(cb,'position', [.46 pos([ 2]) .01 pos(4)] );
            px=get(ha(1),'position');
            set(ha(1),'position',[px(1) px(2) .4 px(4)]);
            
        end%pw
        
    elseif type==2
        show3d;
    end %type
    
    
    
end


function motion(e,e2,para)

ha=(gca);
if strcmp(get(ha,'tag'),'ax4')
    ha=findobj(gcf,'tag','myax');
    axes(ha(1));
end

set(gca,'YColor','r','xColor','r','linewidth',1);
ha=findobj(gcf,'tag','myax');
noax=setdiff(ha,gca);
for i=1:length(noax)
    set(noax(i),'YColor',[.5 .5 .5],'xColor',[.5 .5 .5],'linewidth',0.5);
end


po=get(gca,'CurrentPoint');
po=round(po(1,[1 2]));

% return

hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');

try
    
    labx=us.con.labelmatrix(po(1),po(2));
    %       disp(labx)
    
    
    ax=findobj(gcf,'tag','ax4');
    tx=findobj(ax,'tag','txt1');
    
    ch=get(gca,'children');
    ch=findobj(ch,'type','image');
    dx=get(ch,'cdata');
    val=num2str(dx(po(2),po(1)));
    
    
    sx=get(ch,'userdata');
    pval=num2str(sx.pval(po(2),po(1)));
    
    %     pval
    %     return
    
    msg=[ labx{1} '\color{magenta} [' val ']' '\color{blue} p[' pval ']'  ];
    msg=strrep(msg,'_' ,'\_');
    if isempty(tx)
        axes(ax);
        te=text(0,.5,msg,'fontsize',6,'tag','txt1','interpreter','tex');
    else
        set(tx,'string',msg);
    end
    
    
    
end


function xhelp(e,e2)
uhelp([mfilename '.m']);





%% 828 line
% pairwise tests in dtistat: 770
function [out expo]=calc_networkparameter(x,y, us,z)
% out: output as text document
% expo: output for export (cell)
out=[];

noSeeds=z.noSeeds;
%     hf=findobj(0,'tag','dtistat');
%     us=get(hf,'userdata');

%
%
%     %———————————————————————————————————————————————
%     %%   params
%     %———————————————————————————————————————————————
%
%     z.f1design   =0;
%     z.typeoftest1=1;
%     z.vartype    =1;
%     z.qFDR       =0.05;
%     z.issort    =1;
%     z.showsigsonly=1;
%




if 1
    %———————————————————————————————————————————————
    %%   %% construc matrizes
    %———————————————————————————————————————————————
    iv=[ones(1,size(x,2))   2*ones(1,size(y,2))];
    su=[x y];
    
    si=us.con.size;
    cmat=zeros([si length(iv)]);
    for i=1:length(iv)
        v=su(:,i);
        s=zeros(prod(si),1);
        s(us.con.index)=v;
        s=reshape(s,[si]);
        s2=s+s';
        s2(isnan(s2))=0;
        cmat(:,:,i)  =s2;
    end
    
    %———————————————————————————————————————————————
    %%   get nw-parameter
    %———————————————————————————————————————————————
    d=cmat./noSeeds;     % normalize weights by number of seeds (  %noSeeds=10^6;)
    
    
    
    % metricCommand={'output=efficiency_wei(W,0)','output=efficiency_wei(W,1)','[~,output]=modularity_und(W)',...
    %     'output=assortativity_wei(W,0)','output=clustering_coef_wu(W)','output=degrees_und(W)',...
    %     'output=transitivity_wu(W)'};
    np=[];
    disp('calc network metrics');
    for i=1:size(d,3)
        fprintf(1,' %d ',i);
        dx=d(:,:,i);
        
        vec   = ([efficiency_wei(dx,1)  modularity_und(dx) clustering_coef_wu(dx) degrees_und(dx)' ]);
        vecm  = mean(vec);
        
        sc    = [ assortativity_wei(dx,0)        transitivity_wu(dx)     efficiency_wei(dx,0)   vecm];
        if i==1
            vecml ={'efficiency_wei(dx,1)'  'modularity_und(dx)' 'clustering_coef_wu(dx)' 'degrees_und(dx)'};
            paramlabel=['assortativity_wei(dx,0)'      'transitivity_wu(dx)'   'efficiency_wei(dx,0)'  vecml]';
            np=zeros(length(sc),size(d,3)); %PREALLOC
        end
        np(:,i)    =sc;   %SCALAR
        npv(:,:,i) =vec;  %VEC
    end
    fprintf(1,'\n');
    %———————————————————————————————————————————————
    %%   struct
    %———————————————————————————————————————————————
    nw.np       =np           ;
    nw.nplabel  =paramlabel   ;
    nw.npv      =npv          ;
    nw.npvlabel  =vecml       ;
    
    nw.label     =us.con.label;
    nw.grpidx    =iv         ;
    
    
end

%———————————————————————————————————————————————
%%   statistic
%———————————————————————————————————————————————

% % %%
% % if 1
% %     nw=evalin('base','nw');
% % end





if z.f1design==0
    [out expo]= indepstat_nwparameter(nw,z);
end

%••••••••••••••••••••••••••	   [subs]      •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function [lg expo]=indepstat_nwparameter(nw, z)

vartype=z.vartype;
us=get(gcf,'userdata');



i1=find(nw.grpidx==1);
i2=find(nw.grpidx==2);
% x=nw.np(:,i1)
% y=nw.np(:,i2)


ntestchunks= [size(nw.npv,2)+1 ];
lg={};
for jj=1:ntestchunks
    if jj==1
        dr    =nw.np  ; % nw-parameters scalar
        %         label =nw.nplabel;
        %         para  ='scalar parameter'
    else   % nw-parameters vector
        %          para  ='vector parameter'
        dr=squeeze((nw.npv(:,jj-1 ,:)) ) ; %data label x pbn
        %         region =
        %         head=nw.npvlabel{jj-1}
        
    end
    
    
    
    
    x=dr(:,i1);
    y=dr(:,i2);
    
    
    if z.typeoftest1==1
        stattype='ttest2';
        [h p ci st]=ttest2(x',y');
        [out hout]=getMESD(x,y,vartype);
        res=    [h'   p' st.tstat'   out  st.df'  ] ;
        reshead=['H' 'p' 'T'        hout    'df'  ];
        %reshead={'H' 'p' 'T' 'ME' 'SD' 'SE'  'n1' 'n2' 'df'};
        ikeep=find(~isnan(res(:,1)));
        
    elseif z.typeoftest1==2
        stattype='WRS';
        res=nan(size(x,1),[3]);
        [out hout]=getMESD(x,y,vartype);
         
        if regexpi(us.props.wst_stat,'Z','ignorecase')==1    % Z-SCORE
            for j=1:size(x,1)
                [p h st]=ranksum(x(j,:),y(j,:));
                try
                    res(j,:)=[h p st.zval];
                catch
                    res(j,:)=[h p nan];
                end
            end
            res    =[res           out];
            reshead=['H' 'p' 'zval' hout];
        else                                                  % RS-SCORE
            for j=1:size(x,1)
                try
                    [p h st]=ranksum(x(j,:),y(j,:));
                    res(j,:)=[h p st.ranksum];
                end
            end
            res    =[res           out];
            reshead=['H' 'p' 'RS' hout];
            %reshead={'H' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
        end
        
        ikeep=find(~isnan(res(:,1)));
    elseif z.typeoftest1==3
        stattype='perm';
        px= permtestmat(x',y',1000,'approximate');
        
        [out hout]=getMESD(x,y,vartype);
        h=px<0.05;
        res    =[ h   px  out ];
        reshead=['H' 'p' hout ];
        %reshead={'H' 'p' 'ME' 'SD' 'SE' 'n1' 'n2'};
        [hv px]=ttest2(x',y');
        ikeep=find(~isnan(hv));
    elseif z.typeoftest1==4
        stattype='perm2';
        %tic;[pv,to,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05); toc
        [p,T,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05);
        p(find(isnan(T)))=1;
        
        h=p<0.05;
        
        [out hout]=getMESD(x,y,vartype);
        res    =[ h'  p'  T'    out  ] ;
        reshead=['H' 'p' 'T'   hout  ];
        %reshead={'H' 'p' 'T'    'ME' 'SD' 'SE' 'n1' 'n2'   };
        
        [hv px]=ttest2(x',y');
        ikeep=find(~isnan(hv));
        
        %             [p,T,cr,al]=mult_comp_perm_t2_nan(x(ix,:)',y(ix,:)',5000,0,.05);
        
    end
    
    
    % FDR
    inonan=find(~isnan(sum(out(:,1:3),2)));
    %     Hfdr=fdr_bh(res(inonan,2) ,z.qFDR,'pdep','yes');
    [Hfdr, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(res(inonan,2) ,z.qFDR,'pdep','yes');
    res2      =[Hfdr res adj_p];
    reshead2  =[ {'Hfdr' 'Huncor' } reshead(2:end) 'adj_pFDR'] ;
    
    
    
    
    
    
    
    
    if jj==1
        label=nw.nplabel;
        str=['SCALAR NETWORK METRICS'];
        metric=str;
        
    else
        label=nw.label;
        metric=upper( nw.npvlabel{jj-1} );
        str=[ ' #  [' metric ']' '         ..network metric  '];
    end
    
    
    
    %
    % % z.issort       =1
    % % z.showsigsonly =1
    % % dat=res2
    % %
    
    
    d= [label num2cell(res2)];
    
    if z.issort      ==1;           d=sortrows(d,[4 3])            ;end
    if z.showsigsonly==1;
        %         d=d(find([d{:,3}]==33),:);
        d=d(find([d{:,3}]==1),:);
    end
    if ~isempty(d)
        
        %% SIGN
        %d(:,4)=cellfun(@(a){sprintf(' %5.4g',a)},d(:,4)) ;   % p-values other format
        isnum=cellfun(@isnumeric,d);
        d2      =d;
        reshead3=reshead2;
        for i=1:size(d,2)
            if isempty(   find(isnum(:,i) )); continue; end
            if any((sign(cell2mat(d(find(isnum(:,i) ),i))))==-1) == 1   %negativ values
                d2(:,i)= cellfun(@(a){sprintf('% .5g',a)},d2(:,i));
                reshead3{i}=[' ' reshead3{i}];
            else %positiv values
                d2(:,i)= cellfun(@(a){sprintf('%.5g',a)},d2(:,i));
            end
        end
        
        % d= [d(:,1)  cellfun(@(a){sprintf('% .5g',a)},d(:,2:end))];
        
        if jj==1
            col1name='PARAMETER ';
            %             ds=[['PARAMETER ' reshead3];d2 ];
        else
            col1name='REGION ';
            
            %             ds=[['REGION ' reshead3];d2 ];
        end
        ds=[[col1name reshead3];d2 ];
        
        df=plog([],ds,0,str,'s=0;upperline=0;a=1');
        
        
        %% export NWdata (data exist)
        expo(jj,:)={metric   [col1name reshead2; d ]   };
    else
        lin=repmat('=',[1 length(str)+15]);
        df={lin; [str  ' --> ns.'];lin};
        
        %% export NWdata (data do not exist)
        expo(jj,:)={metric  {'Result';'ns.'}};
    end
    
    % uhelp(df,1);
    % [~,sz]=plog(sz,sx,0,[us.pw(i).str],'s=0','plotlines=0');
    %
    lg =[lg; df];%log results
    
    %% export
    
    
end%ntestchunks
% function  [log2 logthis]=listresults(res2,reshead2, nw,j, z, log2)



%% REDUNDATNT
% function out=getMESD(x,y,vartype)
%
% % vartype=1
%
% s2x = nanvar(x,[],2);
% s2y = nanvar(y,[],2);
% difference = nanmean(x,2) - nanmean(y,2);
%
% xnans = isnan(x);
% if any(xnans(:))
%     nx = sum(~xnans,2);
% else
%     nx = size(x,2); % a scalar, => a scalar call to tinv
% end
% ynans = isnan(y);
% if any(ynans(:))
%     ny = sum(~ynans,2);
% else
%     ny = size(y,2); % a scalar, => a scalar call to tinv
% end
%
% if vartype == 1 % equal variances
%     dfe = nx + ny - 2;
%     sPooled = sqrt(((nx-1) .* s2x + (ny-1) .* s2y) ./ dfe);
%     se = sPooled .* sqrt(1./nx + 1./ny);
%     %ratio = difference ./ se;
% end
% out=[difference sPooled se  sum(~isnan(x),2) sum(~isnan(y),2)];







function out=reformat(in,fmt)
% fmt: '%.5g'
% a2=num2cell(a);
a2 = cellfun(@(a){sprintf(fmt,a)},in);
out=a2;
for i=1:size(a2,2)
    a3=a2(:,i);
    ci=regexpi(a3,'\.');
    id=~cellfun('isempty',ci);
    vc=zeros(size(a3,1),1);
    vc(id)=cell2mat(ci(id));
    le=cell2mat(cellfun(@length,a3,'uniform',false));
    
    l=le+1;
    l(id)=vc(id);
    
    mx=max(l);
    l2=num2cell(l);
    
    out(:,i)=cellfun(@(a,b){[repmat(' ',[1 mx-b]) a]},a3,l2);
end


function export(e,e2)
us=get(gcf,'userdata');
export2excel(us);


% us      : userdata of dtistat
% filename: optional use FP-filename otherwise gui opens ; example: fullfile(pwd,'_result.xlsx');
function export2excel(us,filename)

fprintf(' ... exporting results.. ');



%========== excel filename ===============================================================
try
    if isempty(filename) ; clear filename, end
end
if exist('filename')==0
    [fiout paout]=uiputfile(pwd,'save excelfile as (choose file or type a filenmane) ...' ,'*.xlsx');
    if fiout==0
        disp('..cound not save to excelfile..no file/name chosen..');
        return
    end
    filename=fullfile(paout,fiout);
end


[pa fi ]=fileparts(filename); %force xlsx-format
filename=fullfile(pa,[ fi '.xlsx']);
%=========================================================================
try
    delete(filename);
end
if exist(filename)==2
    error('process canceled...excel document is still open');
end
%=========================================================================



pws=length(us.pw);
%% colorize cells
lut=[...
    1.0000         0         0
    1.0000    0.8431         0
    0    1.0000         0
    0    1.0000    1.0000
    1.0000    1.0000         0
    1.0000         0    1.0000
    0.6000    0.2000         0
    0.9255    0.8392    0.8392
    0.7569    0.8667    0.7765
    0.9529    0.8706    0.7333
    1.0000    0.6000    0.6000];

%% INFO  ============================================
infox={'INFO-DTI STATISTIC'   ['#Date: ' datestr(now)]};
for i=1:pws
    dum= [us.pw(i).tbexportinfo  cell(length( us.pw(i).tbexportinfo),1)];
    infox=[infox; dum ];
    
    % groups
    infox=[infox; cell(1,2) ];
    infox=[infox; {' GROUPS: ' []} ];
    dum0=cellfun(@(a,b){[ [a;[repmat('#',[1,10]); b]] ]} , us.pw(i).grouplabel, us.pw(i).groupmembers );
    dum=cell(max(length(dum0{1}),length(dum0{2})),2);
    dum(1:length(dum0{1}) , 1)  =dum0{1};
    dum(1:length(dum0{2}) , 2)  =dum0{2};
    infox=[infox; dum ];
    
end

xlswrite(filename,infox, 'info' );
xlsAutoFitCol(filename,'info','A:F');
xlscolorizeCells(filename,'info' , [1,1], [1 0 0  ]);

%% for each PW   ============================================

for s=1:pws
    dat      = us.pw(s).tbexport;
    sheetname= us.pw(s).str;
    if isfield(us.pw(s),'networkmetricsExport');
        dat=[dat;us.pw(s).networkmetricsExport];
    end
    
    
    d2={};
    ncoltot=1+max(cell2mat(cellfun(@(a){size(a,2)},dat(:,2))));
    i_head=[];
    npara=1;
    cellcolpos=[];  %cellposition to colorize
    cellcolidx=[];  % index of color used
    for j=1:size(dat,1)
        par=dat(j,1);
        dx=dat{j,2};
        
        nrow=max([size(par,1) size(dx,1)]);
        ncol=[size(par,2)+size(dx,2)];
        dt=cell(nrow, ncol);
        dt(1:size(par,1),1)=par;
        dt(:,            2:end)=dx;
        dt(end);
        dt=[dt   repmat(cell(1,ncoltot-size(dt,2)),[size(dt,1)  1])];
        
        dt=[dt;cell(1,size(dt,2) )];
        i_head(end+1,1) =size(d2,1)+1;
        d2=[d2; dt];
        
        %% colorize  ==================================
        
        %% colorize header
        cellcolpos=[  cellcolpos;    [ [repmat( i_head(end),[ncoltot  1])]  [1: ncoltot]']];
        cellcolidx=[cellcolidx;      repmat(npara,[ncoltot 1]) ];
        
        %% colorize 1st col
        cellcolpos=[cellcolpos;      [   [i_head(end):size(d2,1)-1]'   repmat(1,[size(dt,1)-1 1]) ]];
        cellcolidx=[cellcolidx;      repmat(npara,[size(dt,1)-1 1])];
        
        
        npara=npara+1;
    end
    
    %% write data
    xlswrite(filename,d2, sheetname );
    %  xlsAutoFitCol(filename,sheetname,'A:Z');
    
    
    %% colorize cells
    cellcol=lut(cellcolidx,:);
    xlscolorizeCells(filename,sheetname, cellcolpos, cellcol);
    
end

fprintf(' [Done]\n ');
disp([' open xlsfile: <a href="matlab: system(''' filename ''')">' filename '</a>']);


function loadroifile(e,e2)
 loadroi('gui');
function loadroi(filename)
hf=findobj(0,'tag','dtistat');  figure(hf);
hb=findobj(hf,'tag','loadroifile');
us=get(hf,'userdata');    %### critical

if isempty(filename); return; end

if strcmp(filename,'gui')
    [fi pa]=uigetfile(fullfile(pwd,'*.xlsx'),'load ROI file (excel-format)');
    
    if isnumeric(fi); 
        disp(' no file selected - remove ROI dependency');
       try; us=rmfield(us,'roifile')    ; end
       try; us=rmfield(us,'roilabels')  ; end
        set(hf,'userdata',us);
        return;
    end
    filename  =fullfile(pa,fi);
end
if strcmp(filename,'none')
    disp(' no file selected - remove ROI dependency');
    try; us=rmfield(us,'roifile')    ; end
    try; us=rmfield(us,'roilabels')  ; end
    set(hf,'userdata',us);
    return;
else
    fprintf(' ... reading ROI/COI file ');
    [~,~,x]=xlsread(filename);
end

roi=x(2:end,1:2); % label/connection x indicators
roi=cellfun(@(a){[ num2str(a)  ]} , roi  );

roi(regexpi2(roi(:,1),'NaN'),:) =[];
roi(regexpi2(roi(:,2),'NaN'),:) =[];
roi(:,2)=cellfun(@(a){[ 1  ]} , roi(:,2)  );

fprintf([' [' num2str(size(roi,1)) ' COIs found]' ]);

us.roilabels=roi;
us.roifile  =filename;
set(hf,'userdata',us);
fprintf(' [Done]\n ');


function us=prunebyROIS(us)
 
%%  find connections of interest
for s=1:length(us.pw)
    % «¬­®¯
    px=us.pw(s);
    i_inlab={};
    for i=1:size(us.roilabels,1)
        i_inlab{i,1}=regexpi2(px.lab,['^' us.roilabels{i,1} '$']);
    end
    NmaxAssign=max(cell2mat(cellfun(@(a){[ length(a)  ]} , i_inlab  )));
    disp([' ['  px.str   ']' repmat('«',[1 50])]);
    disp(['roifile        : ' us.roifile ]);
    disp(['max node degree: ' num2str(NmaxAssign)]);
    disp(['# node pairs   : ' num2str(length(i_inlab))]);
    
    %% prune data and labels
    if NmaxAssign~=1
        disp('Problem: several similar node-pairs found');
        keyboard
    end
    iuse=cell2mat(i_inlab);
    px.lab=px.lab(iuse);
    px.tb =px.tb(iuse,:);
    
    us.pw(s)=px;
end

function redisplay(e,e2)
showresults(0);


function makeROIfile(e,e2)

[file,pa] = uiputfile('*.xlsx','SAVE Connections as blanko (excel file) to create a COI-file!!! specify filename');
if file==0; return; end
file= [ strrep(file,'.xlsx','') '.xlsx'];
roifile=fullfile(pa,file);
% roifile=fullfile(pwd,'_dum.xlsx');


hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');
head={'connections' 'COI' 'info'};
conlab=us.con.conlabels;

tb=cell(size(conlab,1),3);
tb(:,1)=conlab;
tb=[head;tb];
tb{1,3} = '__INSTRUCTION: '   ;
tb{2,3} ='set Connection of Interests in column-2 (COI) to [1] ' ;
tb{3,3} ='do nothing for Connections of no interest!';



xlswrite(roifile,[tb],'COI');
xlsAutoFitCol(roifile,'COI','A:F');

col=[0.7569    0.8667    0.7765
    0.8941    0.9412    0.9020
    0.9922    0.9176    0.7961];
xlscolorizeCells(roifile,'COI', [1 1; 1 2; 1 3], col);

disp(['COIfile blanko: <a href="matlab: system('''  [roifile] ''');">' [roifile] '</a>']);

function otherfun(e,e2)
task=get(e,'value');
out=run_otherfun(task);

function out=run_otherfun(task)
out=[];

if task==1
    disp(char({...
        '# -info- : this shows the info'
        '# get code: extract data and parameter to r-run; usage: dtistat(p), where p-struct contains all data and parameter settingss'
        '# reload data and parameter: reload gui using the same data and parameter'})) ;
elseif task==2
    
    %% generate code
    hf=findobj(0,'tag','dtistat');
    us=get(hf,'userdata');
    
    p=[];
    p.groupfile  =us.groupfile;
    ht = findobj(hf,'tag','typeoftest1');
    va = get(ht,'value'); li=get(ht,'string');
    p.typeoftest1    =li{va};
    
    p.f1design       =   get(findobj(hf,'tag','F1design'),'value');
    p.confiles= us.con.files;
    if isfield(us, 'paramfiles');     p.paramfiles =us.paramfiles; else;    p.paramfiles=[];end
    if isfield(us, 'roifile');        p.roifile =us.roifile; else;    p.roifile=[];end
    p.isfdr =   get(findobj(hf,'tag','isfdr'),'value');
    p.qFDR  =   str2num(get(findobj(hf,'tag','qFDR'),'string'));
    p.issort=   get(findobj(hf,'tag','issort'),'value');
    p.showsigsonly =   get(findobj(hf,'tag','showsigsonly'),'value');
    p.noSeeds      =   get(findobj(hf,'tag','noSeeds'),'value');
    
    pstr=struct2list2(p,'p');
    pstr=[{'p=[];'} ; pstr; {'dtistat(p);'}];
    disp('..code copied to clipboard');
    mat2clip(pstr);
    out=pstr;

    
     
elseif task==3
    
    out=run_otherfun(2); %get code
    disp('--re-loading data and parameters');
    eval(strjoin(out,char(10)));
    
end
    
    


