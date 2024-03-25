%% #by DTIstatistik for DSIstudio-RESULTS (DTIparameters & DTIconnectivity)
% This function can be used for post-hoc analysis after processing DTI data
% using #b DSI-studio #n or #b MRtrix.
% Statistical tests can be done for group-differences regarding:
%     (1) DTI-parameters: such as FA, ADC, AXIAL/RADIAL DIFFUSIVITY
%  or (2) DTI-connectivity metrics: i.e. metrics concerning structural links between regions.
% #r ------------------------------------------------------------------------
% #r NOTE: Access via command line has been changed (apologies for this).
% #r ------------------------------------------------------------------------
%
%% #ky INPUT FILE TYPES
% FUNCTION DEALS WITH ONE OF THE FOLLOWING INPUT FILE TYPES:
% DTI parameter   - ascii-files (example: "##_dti_parameter_stat.txt") #b (DSI-studio)
% DTI connectivity - mat-files   (example: "__dti_1000K_seed_rk4_end.mat") #b (DSI-studio)
%                  - csv-filess  (example: connectome_di_sy_length.csv) #b (MRtrix)
%
%% #ky  GROUP-ASSIGNMENT
% - An excelfile must be prepared with mouseIDs and group-assignment.
% - #r The GROUP-ASSIGNMENT excelfile is mandatory for "DTI parameter" and "DTI connectivities".
% - The excelfile must contain 2 columns (mouse-id & groupassignment) in the first excel-sheet
% - [mouseID]        : 1st column contains mouseIDS/names
%                      -The mouseIDs must match animal folders names or must be part of the filename.
% - [groupassignment]: 2nd column contains subgroup labels such that each mouse is assigned to a group.
%                      -The groupassignment label can be arbitrarily chosen.
%                      -Example: "treatment"/"control" or "A"/"B"/"C".
% -  It is possible to assign more than two groups in the Group-column (example: "A","B","C").
% - #r The first row is thought to represent the header (column names can be arbitrarily chosen).
%
%%     #g EXCEL-GROUP-ASSIGNMENT-EXAMPLE with 2 subgroups (1wt2ko,1ko2ko)
%         MRI Animal-ID              GROUP    (1rst row represents the header)
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
%         20170224TM_M9536          1ko2ko
%         20170224TM_M9539          1ko2ko
%
%_________________________________________________________________________________________________
%% #ry HOW TO PROCESS (SEQUENCE OF MANUAL STEPS)
%
% There are two different pipelines (1) DTI-parameters and (2) DTI-connectivity.
% #b  (1) DTI-parameter
% set matlab's current path to the directory of the data
% use [load group assignment] (button) to load the group assignment
% use [load DTI parameter] (button) to select the data files
% modify toggles (within, test, FDR etc.) to adjust the paramter (type of test etc..)
% use [stat DTI parameter] (button) to calculate statistics for DTI-PARAMETER
% use [show Results] (button) to show/redisplay results
% use [plot data] (button) to plot data/results (use right pulldown to select the type of plotting)
% use [export data] (button) to export results (excel-file)
%
% #b  (2) DTI-connectivity
% set matlab's current path to the directory of the data
% use [load group assignment] (button) to load the group assignment
% select from [DTIstudio/MRtrix] (pulldown), depending which processing software was used for DTI connectivity data
% use [load DTI connectivities] (button) to select the  DTI-CONNECTIVITY FILES
% OPTIONAL: use [make COI file] (button) and/or [load COI file](button) to make a COI/load a COI-file
% modify toggles (within, test, FDR etc.) to adjust the paramter (type of test etc..)
% use [stat Connectivity] (button) to calculate the statistics for DTI-CONNECTIVITY FILES.
% OPTIONAL: use [save calculation] (button) to save the calculation (mat-file, for time-consuming jobs)
%          This allows to just start dtistat.m the next time, modify some of the toggles (FDR etc.) and reload
%          a calculation via [load calculation]
% use [show Results] (button) to show/redisplay results
% use [plot data] (button) to plot data/results (use right pulldown to select the type of plotting)
% use [export data] (button) to export results (excel-file)
% use [export4xvol3d] (button) to export connections for xvol3d-visualization
%_________________________________________________________________________________________________
%% #ry GUI (controls and behaviour)
%
% #b ______________GROUP ASSSIGNMENT_______________________________________________________________
%
% [load group assignment] (button)   : Load excelfile with group assignment.
%
% #b _______________DTI parameter or DTI connectivities____________________________________________
% [load DTI parameter]    (button)   : Load DTI-PARAMETER FILES (see INPUT FILE TYPES) via GUI.
% [load DTI connectivities] (button) : Load DTI-CONNECTIVITY FILES (see INPUT FILE TYPES)  via GUI.
% [DTIstudio/MRtrix]    (pulldown)   : Depending on processing software for DTI connectivity data select
%                                       one of the input data:
%                                             "DSIstudio" for DSI studio data, or
%                                             "MRtrix"    for MRtrix data.
%                                      Depending on the input data, the matching item must be selected from
%                                      the pulldown before hitting the [load DTI connectivities] button.
%                                      #r For "DTI connectivities" only.
% #b _____________CONNECTIONS OF INTERESTS_________________________________________________________
% [load COI file]         (button)   : optional, load Connections-of-Interest/COI-file  (excelfile file).
%                                      This file has to be created first, using the [make COI file]-button.
%                                      #r For "DTI connectivities" only.
%                                      #The COI-file can be loaded before, or after calculation.
%                                      Currently, the COI-file is used to reduce the number of region-by-region
%                                       pairs and thus improve the statistical output when dealing with
%                                      multiple comparisons (FDR approach).
%                                      EXAMPLE: 308 seeds/regions produce 47278 region-by-region pairs (i.e. without
%                                      combinations of itself and without redundant reorders such as "A--B" and "B--A").
%                                      In this case it's unlikely that something survives FDR-correction. In this case
%                                      use a COI-file with tagged connections-of-interest. SEE [make COI file].
% [make COI file]         (button)   : optional, create an excel file with connections as blanko file.
%                                      This file can than be used to make a COI-file (excelfile file) by manually
%                                      denoting the connections of interest, see Instructions in the [make COI file]
%                                      excelfile file.
%                                      #r For "DTI connectivities" only.
% #b ______________TOGGLES_________________________________________________________________________
% [within]                (checkbox) : Statisitcal design:
%                                       [ ] between-design (2-sample problem)
%                                       [x] paired-design (repeated measures)
% [tests]                 (pulldown) : Select the prefered test. Tests are design-dependend. So first
%                                      select the Statisitcal design.
%                                      *Tests for between-design: One of the following tests:
%                                          ttest2 (2sample ttest), WST(Wilcoxon rank sum test),
%                                          permutation,permutation2
%                                      *Tests for within-design: #r not implemented yet.
% [use FDR]               (checkbox) : If selected, FDR correction is performed.
% [qFDR]                  (edit)     : The desired false discovery rate (default: 0.05).
% [show SIGS only]        (checkbox) : If selected, only significant results will be shown.
% [sort Results]          (checkbox)  : if selected, results will be sorted by p-value.
% [reverse contrast]      (checkbox)  : Default: group 'A' vs 'B'
%                                      If selected the order is reversed 'B' vs 'A'.
%                                      -This option only changes the sign of the statistical TestValue
%                                       (positive vs negative t-value) and does not change the direction
%                                       (tail) of the test
% [noSeeds]               (edit)     : Number of seeds.  #r For "DTI connectivities" only.
%                                      Connectivity-matrizes (weights) will be normalized by noSeeds
%                                      prior calculation of connectivity metrics.
% [prop thresh]           (checkbox)   : for MRtrix data only, set proportonal threshold
% [threshold]           (edit)         : for MRtrix data only, value to threshold via proportonal threshold
%                                       - can be 'max' to use value with maximal small worldness score
%                                         or a value between 0 and 1
%                                      ---> see tooltip
% [logarithmize]         (checkbox)   : for MRtrix data only, logarithmize data
%
%
%        dtistat('set', 'propthresh',1,'thresh','max','log',1)
%
% #b __________CALCULATION_________________________________________________________________________
% [stat DTI parameter]    (button)   : Calculate statistic for DTI-PARAMETER.
%                                      FILES (DTI-PARAMETER FILES must be loaded before.
%                                      #r For "DTI parameter" only.
% [stat Connectivity]     (button)   : Calculate statistic for DTI-CONNECTIVITY FILES.
%                                      DTI-CONNECTIVITY FILES must be loaded before.
% [parallel proc]     (checkbox)     : use parallel processing for calculation {0|1}; default: 1
%                                      -parallel processing is recommended for larger matrixes & more animals
% 
%                                      #r For "DTI connectivities" only.
% [save calculation]      (button)   : Save a calculation (mat-file). This might be useful if statistical
%                                      calculation for DTI connectivities is very time-consuming.
%                                      (For more than 200 regions/nodes implying metric calculations for 40000
%                                      interconnections.). After calculation, use [save calculation] to
%                                      save the data as mat-file (GUI to select output filename).
%                                      For later usage, open "dtistat" window, hit [load calculation] and select
%                                      the previously saved calculation. If necessary, adjust the toggles (FDR etc.).
%                                      #r Assumed for "DTI connectivities", but works also for "DTI parameter".
% [load calculation]      (button)   : Load an existing calculation (mat-file). See [save calculation].
%
% #b _____________REPORT/EXPORT____________________________________________________________________
% [show Results]          (button)   : Show/redisplay results without re-calculation.
%                                      -Useful when changing the toggle states(FDR/qFDR/showSigsonly/sortResult etc)
%                                       or when using  [load calculation].
% [plot data]             (button)   : plot data/results (use right pulldown to select the type of plotting)
% [export data]           (button)   : Export results (excel-file).
%
% [export4xvol3d]         (button)   : Export (significant) connections as excel-file. Use this option to
%                                      visualize connections via xvol3d.  #r For "DTI connectivities" only.
%__________________________________________________________________________________________________
%% #ry COMMAND LINE OPTIONS
% #r ------------------------------------------------------------------------
% #r NOTE: Access via command line has been changed (apologies for this).
% #r ------------------------------------------------------------------------
% Most commands can be set via command line.
% All available commands must be declared as input argument of "dtistat.m"
% Commands and subcommands are highlighted green in the tooltip of the respective button/checkbox/etc.
%
% #b _____SET COMMAND______________________________________________________________________________
% SET: can be used to change state of toggles/pulldown menues/edit fields. First argument is 'set',
% followed by pairwise inputs. Subcommands of SET can be used in one set-command or splitted in several
% set-commands
% dtistat('set', arg1,val1, arg2,val2 ...); %pattern
% SUBCOMMANDS and VALUES
% 'inputsource'  : define input data        ; {see pulldown} ; #k EXAMPLE: dtistat('set','inputsource','MRtrix');
% 'within'       : define statistical model ; {0,1} no/yes   ; #k EXAMPLE: dtistat('set','within',0);
% 'test'         : used statistical test    ; {see pulldown} ; #k EXAMPLE: dtistat('set','test','WST');
% 'FDR'          : toggle 'FDR'             ; {0,1}no/yes    ; #k EXAMPLE: dtistat('set','FDR',1);
% 'qFDR'         : set the "qFDR" value     ; numeric        ; #k EXAMPLE: dtistat('set','qFDR',0.1);
% 'showsigsonly' : show signif. results only; {0,1} no/yes   ; #k EXAMPLE: dtistat('set','showsigsonly',0);
% 'sort'         : sort results             ; {0,1} no/yes   ; #k EXAMPLE: dtistat('set','sort',0);
% 'rc'           : reverse contrast         ; {0,1}no/yes    ; #k EXAMPLE: dtistat('set','rc',0);
% 'nseeds'       : number of seeds          ; numeric        ; #k EXAMPLE: dtistat('set','nseeds',1000);
%
% #k EXAMPLE TO COMBINE SET-SUBCOMMANDS:
% dtistat('set','within',0,'test','ttest2','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1,'rc',0,'nseeds',1000);
%
% #b _____OTHER COMMANDS___________________________________________________________________________
%
% dtistat('new');                                  % #g new dtistat-window
% dtistat('group',excel-file);                     % #g load a group assignment; excel-file is the filename of the group assignment
% dtistat('confiles',files,'labelfile',labelfile); % #g load connectivity files. #r FOR "DTI-connectivities" only.
%                                                  % #g files is a cell of connectivity-files
%                                                  % #g labelfile is a textfile with regions associated with the connectivity-files
%
% dtistat('paramfiles',files);                     % #g load parameter files. #r FOR "DTI-parameter" only.
%                                                  % #g files is a cell of parameter-files
%
% dtistat('calcconnectivity');                     % #g calculate statistic for DTI-connectivities
% dtistat('calcparameter');                        % #g calculate statistic for DTI-parameter
%
% dtistat('savecalc','__test1.mat');               % #g save calculations as '__test1.mat' in the current folder
% dtistat('loadcalc','__test1.mat');               % #g load a previous calculations, here '__test1.mat' from the current folder as
%
%
% dtistat('showresult');                           % #g show results
% dtistat('showresult','ResultWindow',0);          % #g update setting without showing result-window
%                                                  % can be used when exporting results (without poping windows)
%
% #g EXPORT
% dtistat('export','_testExport3.xlsx');           % #g export results with default export option
% dtistat('set','exportType',1);                   % set export type to '1': EXCEL file, sheet-wise results
% dtistat('export','test1.xlsx','exportType',1)    % #g save as EXCEL file, sheet-wise results
% dtistat('export','test2.xlsx','exportType',2)    % #g save as EXCEL file, results in single sheet
% dtistat('export','test2.txt' ,'exportType',3)    % #g save as TXT-file, all results in single file
%
% #g EXPORT VOR vol3d
% dtistat('export4xvol3d');                        % #g export connection for xvol3d-visualization; with GUI. #g For silent mode
%                                                  % #g  see example below,
% dtistat('export4xvol3d',[],'gui',1);             %default with open gui
% dtistat('export4xvol3d',z,'gui',1);              % using parameter in z-struct with open gui
%
% %r COI-FILES
% dtistat('loadcoi','coi_TEST1.xlsx');             % #g load a COI-file,connection-of-interest-file (excel-file); see GUI for more help
% dtistat('makecoi','__COI_blanko.xlsx');          % #g save a COI-BLANKO-file (excel-file). Here, blanko '__COI_blanko.xlsx' is saved
%                                                  % #g the current folder
%__________________________________________________________________________________________________
%% #ky example command line: DTI-CONNECTIONS
% cd('F:\data1\DTI_mratrix\dti_mratrix_simulation2_multiGRP')            % #g go to the main directory
% dtistat('new');                                                        % #g new dtistat-window
% dtistat('set','inputsource','MRtrix');                                 % #g input data source in MRatrix
% dtistat('set','within',0,'test','ttest2','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1,'rc',0,'nseeds',10000); % #g some toggle sets
% dtistat('group','groupAssign.xlsx');                                   % #g load group-assignment (file 'groupAssign.xlsx' is in current directory)
% [files] = spm_select('FPListRec',pwd,'.*.csv'); files=cellstr(files);  % #g recursively select all csv-files found in this directory
% dtistat('confiles',files,'labelfile','lutSIM.txt');                    % #g load confiles and use label-file (here: 'lutSIM.txt', stored in current directory)
% dtistat('calcconnectivity');                                           % #g calculate statistic for connectivity
% dtistat('savecalc','__test1.mat');                                     % #g save calculation in pwd as '__test1.mat'
%
% dtistat('new');                                                        % #g make new "dtistat"-window
% dtistat('loadcalc','__test1.mat');                                     % #g load previous calculation '__test1.mat' from pwd
% dtistat('set','inputsource','MRtrix','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1); % #g restore some toggle settings
% dtistat('showresult');                                                 % #g show results
%
% dtistat('export','_testExport3.xlsx');                                 % #g export results as '_testExport3.xlsx' in current folder
% dtistat('export4xvol3d');                                              % #g export data for xvol3d with GUI
%__________________________________________________________________________________________________
%% #ky example command line: Export DTI-connections for xvol3d
%
% z=[];
% z.ano           = 'F:\data5\eranet_round2_statistic\DTI\PTSDatlas_01dec20\PTSDatlas.nii';                % % select corresponding DTI-Atlas (NIFTI-file); such as "ANO_DTI.nii"
% z.hemi          = 'F:\data5\eranet_round2_statistic\DTI\templates\AVGThemi.nii';                         % % select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"
% z.cs            = 'diff';                                                                                % % connection strength (cs) or other parameter to export/display via xvol3d
% z.sort          = [1];                                                                                   % % sort connection list: (0)no sorting ; (1)sort after CS-value; (2)sort after p-value;
% z.outDir        = 'F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome_6vsAll';     % % output folder
% z.filePrefix    = 'e_';                                                                                  % % output filename prefix (string)
% z.fileNameConst = '$filePrefix_$cs_$contrast_$keep';                                                     % % resulting fileName is constructed by...
% z.contrast      = 'CTRL vs HR';                                                                          % % constrast to save (see list (string) or numeric index/indices)
% z.keep          = 'FDR';                                                                                 % % connections to keep in file {'all' 'FDR' 'uncor' 'manual selection' 'p<0.001' 'p<0.0001'}
% z.underscore    = [0];                                                                                   % % {0,1} underscores in atlas labels:  {0} remove or {1} keep
% z.LRtag         = [1];                                                                                   % % {0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
% dtistat('export4xvol3d',z,'gui',1);   % export to vol3d with open gui ('gui',1)
%% the output will be an excel-file: 'e__diff_CTRL_vs_HR_FDR.xlsx'
%_________________________________________________________________________________________________
%% #ky example command line: DSIstudio-DTI Parameter
% cd('O:\data2\x01_maritzen\Maritzen_DTI') ;                           % #g go to the main directory
% dtistat('new');                                                      % #g new dtistat-window
% dtistat('set','inputsource','DSIstudio','within',0,'test','ttest2'); % #g set toggle states
% dtistat('group','#groups_Animal_groups.xlsx');                       % #g load group assignment (excel file)
% [files] = spm_select('FPListRec',pwd,'.*.stat.txt'); files=cellstr(files); % #g select DSIstudio DTI-Parameter files
% dtistat('paramfiles',files);                                         % #g load DTI-Parameter files
% dtistat('calcparameter');                                            % #g calculate statistics
% dtistat('showresult');                                               % #g show results
% dtistat('savecalc','__test1.mat');                                   % #g save calculation in pwd as '__test1.mat'
%
% dtistat('new');                                                      % #g make new "dtistat"-window
% dtistat('loadcalc','__test1.mat');                                   % #g load previous calculation '__test1.mat' from pwd
% dtistat('set','inputsource','DSIstudio','within',0,'test','ttest2'); % #g reset some toggle states
% dtistat('showresult');                                               % #g show results again
%
%
%_________________________________________________________________________________________________
%% #ky example command line: MRTRIX
%% short version (connectivity-files will be find within conpath-folder )
% groupingfile = 'F:\data5\stat_Harms2020_Exp7_2020_Exp9_2021_Exp1_IntFasting\export_4stat_DTIconectome\groups\grp_f_alt_VS_m_alt.xlsx'; % % group-assignment File (Excel-file)
% conpath  ='F:\data5\stat_Harms2020_Exp7_2020_Exp9_2021_Exp1_IntFasting\export_4stat_DTIconectome\dat'; % % upper path containing connectivity files (csv)
% confiles ='connectome_di_sy.csv'; % % short-name of the connectivity file (csv)
% lutfile      = 'F:\data5\stat_Harms2020_Exp7_2020_Exp9_2021_Exp1_IntFasting\export_4stat_DTIconectome\dat\20200820CH_Exp7_M125\atlas_lut.txt'; % % LUT-File (txt-file)
%
% dtistat('set','inputsource','MRtrix' );
% dtistat('group', groupingfile);                        % % LOAD groupAssignment (ExcelFile)
% dtistat('conpath', conpath ,'confiles', confiles  ,'labelfile',lutfile); % % LOAD connectivity-Files & LUTfile
% dtistat('set','within',0,'test','ttest2','tail','both' );
% dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1,'rc',0 );
% dtistat('set','nseeds',1000000,'propthresh',1,'thresh','max','log',1 );
% % __processing options___
% % dtistat('calcconnectivity'); % % CALCULATION (uncomment line to execute)
% % dtistat('showresult');       % % SHOW RESULT (uncomment line to execute)
% % dtistat('savecalc','calc_test1.mat');  % %save calculation
% % dtistat('export','test1.xlsx','exportType',1);  % %save Result as ExelFile
%
%
%% b SUBFUNFTIONS
% dti_changeMatrix.m   : change matrix (example: keep only left hemispheric connections)



% ==============================================
%%   TODO's
% ===============================================

%WHY 308*308/2-47278 --->154
% automatize
% xvol3d-link
% ==============================================
%%
% ===============================================


function dtistat(varargin)

hf=findobj(0,'tag','dtistat');
if isempty(hf);     createGui; end

% ==============================================
%%   inputs
% ===============================================

if nargin~=0
    
    if mod(length(varargin),2)==0
        par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    else % odd
        par=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
        par=setfield(par,varargin{1}, varargin{1});
    end
    commandline(par);
    return
else
    createGui();
end

function commandline(p)
% createGui();
hf=findobj(0,'tag','dtistat');

% ==============================================
%%   set
% ===============================================

if isfield(p,'set')
    if isfield(p,'inputsource')
        hc=findobj(hf,'tag','inputsource');
        li=get(hc,'string'); va=get(hc,'value');
        if isnumeric(p.inputsource)
            set(hc,'value' ,p.inputsource );
        else
            set(hc,'value' ,find(strcmp(li,p.inputsource )) );
        end
    end
    % --within----------------------------------------------
    if isfield(p,'within')
        hc=findobj(hf,'tag','F1design');
        set(hc,'value',p.within) ;
        hgfeval(get(hc,'callback'),hc);
    end
    % --test----------------------------------------------
    if isfield(p,'test')
        hc=findobj(hf,'tag','typeoftest1');
        li=get(hc,'string'); va=get(hc,'value');
        if isnumeric(p.test)
            set(hc,'value' ,p.test );
        else
            val=find(strcmp(li,p.test )) ;
            if isempty(val)
                msgbox([ {['Unknown Test : "' p.test '"!' ]};{'Chose one of the following tests: '} ; cellfun(@(a){ [ sprintf('   ') '* ' a '' ]} , li)]);
                return
            end
            set(hc,'value' ,val);
        end
    end
    % --isFDR----------------------------------------------
    if isfield(p,'FDR')
        hc=findobj(hf,'tag','isfdr');
        set(hc,'value' ,p.FDR );
    end
    % --FDR-qvalue----------------------------------------------
    if isfield(p,'qFDR')
        hc=findobj(hf,'tag','qFDR');
        set(hc,'string' ,num2str(p.qFDR) );
    end
    % --showsigsonly----------------------------------------------
    if isfield(p,'showsigsonly')
        hc=findobj(hf,'tag','showsigsonly');
        set(hc,'value' ,p.showsigsonly );
    end
    % --sort results----------------------------------------------
    if isfield(p,'sort')
        hc=findobj(hf,'tag','issort');
        set(hc,'value' ,p.sort );
    end
    % --sort reversecontrast----------------------------------------------
    if isfield(p,'rc')
        hc=findobj(hf,'tag','reversecontrast');
        set(hc,'value' ,p.rc );
    end
    % --sort noSeeds----------------------------------------------
    if isfield(p,'nseeds')
        hc=findobj(hf,'tag','noSeeds');
        set(hc,'string' , num2str(p.nseeds ));
    end
    % --parallel processing----------------------------------------------
    if isfield(p,'isparallel')
        hc=findobj(hf,'tag','isparallel');
        set(hc,'value' ,p.isparallel );
    end
    
    
    
    if isfield(p,'propthresh')
        hc=findobj(hf,'tag','isproportthreshold');
        set(hc,'value' , (p.propthresh ));
    end
    if isfield(p,'thresh')
        hc=findobj(hf,'tag','threshold');
        set(hc,'string' , num2str(p.thresh ));
    end
    if isfield(p,'log')
        hc=findobj(hf,'tag','logarithmize');
        set(hc,'value' , (p.log ));
    end
    if isfield(p,'tail')
        hc=findobj(hf,'tag','tail');
        
        set(hc,'value' , find(strcmp(hc.String,p.tail)));
    end
    
    if isfield(p,'exportType')
        hc=findobj(hf,'tag','exportType');
        set(hc,'value' , (p.exportType ));
    end
    
    
end

% ==============================================
%%   other command line args
% ===============================================
if isfield(p,'group')
    groupfile(p.group);
    return
end
if isfield(p,'confiles')
    confiles(p);
    return
end
if isfield(p,'calcconnectivity')
    runstat(2);
    return
end
if isfield(p,'savecalc')
    run_calcSave(p);
    return
end
if isfield(p,'loadcalc')
    run_calcLoad(p);
    return
end
if isfield(p,'new')
    delete(findobj(0,'tag','dtistat'));
    dtistat();
    return
end
if isfield(p,'showresult')
    redisplay(p);
    return
end
if isfield(p,'export')
    export2excel(p);
    return
end
if isfield(p,'export4xvol3d')
    export4xvol3d(p);
    return
end
if isfield(p,'loadcoi')
    loadroi(p);
    return
end
if isfield(p,'makecoi')
    makeROIfile_run(p);
    return
end

if isfield(p,'plot')
    plotresults(p);
    return
end

if isfield(p,'summaryplot')
    summaryplot(p);
    return
end


%-----------------DTI Paramter addon
if isfield(p,'paramfiles')
    paramfiles(p);
    return
end
if isfield(p,'calcparameter')
    runstat(1);
    return
end


% ==============================================
%%   command LINE TESTS REAL DATA-308 nodes
% ===============================================
if 0
    cd('F:\data1\DTI_mratrix\dti_mratrix');
    dtistat('new');
    dtistat('set','inputsource','MRtrix','within',0,'test','ttest2','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1);
    dtistat('group','Manuskript_IL6_sham_group_ assignment.xlsx');
    [files] = spm_select('FPListRec',pwd,'.*.csv'); files=cellstr(files);
    dtistat('confiles',files,'labelfile','atlas_lut.txt');
    %%% dtistat('calcconnectivity');
    %%% dtistat('savecalc','__test1.mat');
    
    dtistat('new');
    dtistat('loadcalc','test_308nodes.mat');
    dtistat('set','inputsource','MRtrix','within',0,'test','ttest2','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1);
    dtistat('showresult');
    
    %%%% dtistat('export','_testExport3.xlsx');
    %%%% dtistat('export4xvol3d','r');
end

% ==============================================
%%   command LINE TESTS MRtrix
% ===============================================
if 0
    dtistat('new');
    dtistat('set','within',0,'test','ttest2','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1,'rc',0,'nseeds',50);
    dtistat('group','groupAssign.xlsx');
    [files] = spm_select('FPListRec',pwd,'.*.csv'); files=cellstr(files);
    dtistat('confiles',files,'labelfile','lutSIM.txt');
    dtistat('calcconnectivity');
    
    dtistat('savecalc','__test1.mat');
    dtistat('new');
    dtistat('loadcalc','__test1.mat');
    dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',0,'sort',1);
    dtistat('showresult');
    
    dtistat('export','_testExport3.xlsx');
    dtistat('export4xvol3d','r');
    
    
    x=[];
    x.ano        =  'F:\data1\DTI_mratrix\dti_mratrix_simulation2_multiGRP\templates\ANO.nii';	% select corresponding Atlas (Nifti-file); such as "ANO.nii"
    x.hemi       =  'F:\data1\DTI_mratrix\dti_mratrix_simulation2_multiGRP\templates\AVGThemi.nii';	% select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"
    x.cs         =  'diff';	% connection strength (cs) or other parameter to export/display via xvol3d
    % ##
    x.outputname =  'DTIconnections';	% output name string
    x.contrast   =  'A > B';	% constrast to save (see list (string) or numeric index/indices)
    x.keep       =  'all';	% connections to keep in file {'all' 'FDR' 'uncor'}
    x.underscore =  [0];	% {0,1} underscores in atlas labels:  {0} remove or {1} keep
    x.LRtag      =  [0];	% {0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
    x.gui        =  [1];    % {0,1}  show paramter GUi;  {1}silent mode; {0} show gui
    dtistat('export4xvol3d',x);
    
end
% ==============================================
%%   command LINE TESTS DSIstudio-DTI Parameter
% ===============================================
if 0
    cd('O:\data2\x01_maritzen\Maritzen_DTI')
    dtistat('new');
    dtistat('set','inputsource','DSIstudio','within',0,'test','ttest2');
    dtistat('group','#groups_Animal_groups.xlsx');
    [files] = spm_select('FPListRec',pwd,'.*.stat.txt'); files=cellstr(files);
    dtistat('paramfiles',files);
    dtistat('calcparameter');
    dtistat('showresult');
    dtistat('savecalc','__test1.mat');
    
    dtistat('new');
    dtistat('set','inputsource','DSIstudio','within',0,'test','ttest2');
    dtistat('loadcalc','__test1.mat');
    dtistat('showresult');
    
end

function summaryplot(p)

pptfile=p.pptfile;
atlas  =p.atlas  ;
if exist(pptfile)==2; delete(pptfile); end

dtistat('plot','atlas',atlas,'thr',1,'p',0.1   ,'label',1,'value',1,'fs',4,'pptfile',pptfile);
dtistat('plot','atlas',atlas,'thr',2,'p',0.05  ,'label',1,'value',1,'fs',4,'pptfile',pptfile);
dtistat('plot','atlas',atlas,'thr',2,'p',0.01  ,'label',1,'value',1,'fs',4,'pptfile',pptfile);
dtistat('plot','atlas',atlas,'thr',2,'p',0.005 ,'label',1,'value',1,'fs',4,'pptfile',pptfile);
dtistat('plot','atlas',atlas,'thr',2,'p',0.001 ,'label',1,'value',1,'fs',4,'pptfile',pptfile);
dtistat('plot','atlas',atlas,'thr',3,'p',0.05  ,'label',1,'value',1,'fs',4,'pptfile',pptfile);


% plotresults(p);


function createGui
% hf=findobj(0,'tag','dtistat');
% if isempty(hf);     createGui; end
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
us.isparallel  =1;
us.props=props;

us.isproportthreshold=1;
us.threshold         ='max';
us.logarithmize     =1;

% ==============================================
%%     prepare GUI
% ===============================================

delete(findobj(0,'tag','dtistat'));
hf=figure;
set(hf,'units','norm','color','w','tag','dtistat','menubar','none');
set(hf,'position',[0.5892    0.4461    0.3889    0.4667]);
set(hf,'name','dtistat','NumberTitle','off');

set(hf,'userdata',us);

%----GROUP ASSIGNMENT
h=uicontrol('style','pushbutton','units','norm','position',[0 .85 .2 .05],...
    'string','load group assignment','tag','loaddata','callback',@loadgroupassignment,...
    'backgroundcolor',[0.8392    0.9098    0.8510],...
    'tooltipstring',...
    ['<b> Load group-assignment (EXCEL-file) </b>' char(10)...
    ...
    '<b><font color="blue">command: </b>   "group"' char(10) ...
    '<font color="black">dtistat(''group'')                           ;<font color="green">% load group-assignment-via UI' char(10) ...
    '<font color="black">dtistat(''group'',''MyGroupAssignment.xlsx'');<font color="green">% load group-assignment-file "MyGroupAssignment.xlsx"' char(10) ...
    %     '<font color="black">dtistat(''confiles'',LIST);<font color="green">% load connectivity files, specified in LIST(cell-arry with fullpath-names) ' char(10) ...
    
    ]);
% ==============================================
%%   DTI parameter &  DTI connectities
% ===============================================

% h=uicontrol('style','pushbutton','units','norm','position',[0 .8 .2 .05],...
%     'string','load DTI parameter','tag','loaddata','callback',@loadDTIparameter,...
%     'tooltipstring',...
%     ['load mouse-specific DTI-parameter files' char(10)...
%     'This data deal with parameter such as: FA, ADC, AXIAL/RADIAL DIFFUSIVITY.' char(10)...
%     '<font color="black">command: <b><font color="green">paramfiles</font>'...
%     ]);


h=uicontrol('style','pushbutton','units','norm','position',[0.00098569 0.79759 0.2 0.05],...[0.2 .8 .2 .05],...
    'string','load DTI connectivities','tag','loaddata','callback',@loadDTIConnectivity,...
    'backgroundcolor',[0.8392    0.9098    0.8510],...
    'tooltipstring',...
    ['<b>Load DTI-connectivity files </b>' char(10)...
    ...'This data deal with connections between regions.' char(10)...
    ...
    '<b><font color="blue">command: </b>   "confiles"' char(10) ...
    '<font color="black">dtistat(''confiles'');<font color="green">% load connectivity files via UI' char(10) ...
    '<font color="black">dtistat(''confiles'',LIST);<font color="green">% load connectivity files, specified in LIST(cell-arry with fullpath-names) ' char(10) ...
    
    ]);

%----inputsource
source={'DSIstudio','MRtrix'};
h=uicontrol('style','popupmenu','units','norm','position',[0.20277 0.79282 0.18 0.05],...[.22 .85 .18 .05],...
    'string',source ,'tag','inputsource',...
    'tooltipstring',...
    ['<b> Select DTI input source. </b>' char(10)...
    '<font color="black"> Specify the data input type.' char(10) ...
    '<font color="red"> Only for DTI-connectivities data!' char(10) ...
    '<font color="black">' char(10) ...
    ...
    '<b><font color="blue">command: </b>   "inputsource"' char(10) ...
    '<font color="black">dtistat(''set'', ''inputsource'',1);             <font color="green">% use DSIstudio' char(10) ...
    '<font color="black">dtistat(''set'', ''inputsource'',''DSIstudio''); <font color="green">% use DSIstudio' char(10) ...
    '<font color="black">dtistat(''set'', ''inputsource'',2);             <font color="green">% use MRtrix' char(10) ...
    '<font color="black">dtistat(''set'', ''inputsource'',''MRtrix'');    <font color="green">% use MRtrix' char(10) ...
    ]);
set(h,'value',2);

% ==============================================
%%   LOAD COIFILE
% ===============================================
h=uicontrol('style','pushbutton','units','norm','position',[0.45 .8 .12 .05],...
    'string','load COIfile','tag','loadroifile','callback',@loadroifile,...
    'tooltipstring',[...
    'load excel-file with connections of interest (COI)' char(10) ...
    '<font color="black">command: <b><font color="green">loadcoi</font>'...
    ]);
set(h,'visible','off');
% ==============================================
%%   make COIFILE
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0.57 .8 .12 .05],...
    'string','make COIfile','tag','makeROIfile','callback',@makeROIfile,...
    'tooltipstring',[...
    'create excel file with connections (blanko) to manually indicate' char(10) ....
    'the connections of interest (COI  of interest (COI)' char(10) ...
    '<font color="black">command: <b><font color="green">makecoi</font>'...
    ]);
set(h,'visible','off');


roifiletype={'all' 'left connections' 'right connections'};
h=uicontrol('style','popupmenu','units','norm',...
    'position',[0.5724 0.84044 0.12 0.05],...
    'string',roifiletype,'tag','ROIfileType',...
    'tooltipstring',[...
    'DEFINE COIfile-Type ' char(10) ....
    'This file can be stored/changed and used via [loadCOI]-BTN'  char(10) ....
    '..see make COIfile' char(10) ....
    %     'the connections of interest (COI  of interest (COI)' char(10) ...
    %     '<font color="black">command: <b><font color="green">makecoi</font>'...
    ]);
set(h,'visible','off');

% ==============================================
%%   help /close resultfile/batch
% ===============================================

%help
h=uicontrol('style','pushbutton','units','norm','position',[.8 .85 .15 .05],...
    'string','help','tag','Help','callback',@xhelp,...
    'tooltipstring',['function help']);

%close resultfiles
h=uicontrol('style','pushbutton','units','norm','position',[.8 .8 .15 .05],...
    'string','close result windows','tag','closeresultwindows','callback',@closeresultwindows,'fontsize',6,...
    'tooltipstring','close open result windows');

%get Batch
h=uicontrol('style','pushbutton','units','norm','position',[0.80096 0.74997 0.15 0.05],...
    'string','get batch','tag','getbatch','callback',@getbatch,'fontsize',6,...
    'tooltipstring','get batch/code');

%scripts
h=uicontrol('style','pushbutton','units','norm','position',[0.80096 0.70 0.15 0.05],...
    'string','scripts','tag','scripts_show','callback',@scripts_show,'fontsize',6,...
    'tooltipstring','<html><b>collection of scripts</b><br> you can modify and apply these scripts for your purpose ');
set(h,'foregroundcolor',[0 0 01 ],'fontweight','bold');

% ==============================================
%%    -between vs within
% ===============================================
h=uicontrol('style','checkbox','units','norm','position',[0.11348 0.64998 0.2 0.05],...
    'string','within',...
    'tag','F1design','backgroundcolor','w','callback',@call_f1design,...
    'tooltipstring',[...'testing type:' char(10) ...
    '<b> Between vs Within Test-Type. </b>' char(10) ...
    ' [ ] BETWEEN DESIGN: compare independent groups ' char(10) ...
    ' [x] WITHIN DESIGN:  compare within the same anima (different time points) ' char(10) ...
    ...
    '<b><font color="blue">command: </b>   "within"' char(10) ...
    '<font color="black">dtistat(''set'', ''within'',0); <font color="green">% use BETWEEN (two-sample/independent design)>' char(10) ...
    '<font color="black">dtistat(''set'', ''within'',1); <font color="green">% ues WITHIN(dependent design)</font>' char(10) ...
    ]);




% ==============================================
%%   type of test
% ===============================================
h=uicontrol('style','popupmenu','units','norm','position',[.15 .65 .2 .05],...
    'string',{'ttest2' 'WST' 'permutation','permutation2' 'BM'},'tag','testsbetween',...
    'position',[.2 .645 .1 .05],'tag','typeoftest1',...
    'tooltipstring',[...
    '<b>Type of statistical test.:</b>' char(10) ...
    ' <b>*** BETWEEN DESIGN </b>' char(10) ...
    '  * ttest2 (parametric) ' char(10) ...
    '  * WST,aka Wilcoxon rank sum test (non-parmametric) ' char(10) ...
    '  * permutation/permutation2: two different permutation tests' char(10) ...
    '  * Brunner-Munzel (BM) test' char(10) ...
    '<b>-----------------------------------' char(10) ...
    ' <b>*** WITHIN DESIGN </b>'  char(10) ...
    '<font color="red">        ..not implemented so far! </font>' char(10) ...
    '      ' char(10)...
    ...
    '<b><font color="blue">command: </b>   "test"' char(10) ...
    '<font color="black">dtistat(''set'', ''test'',''ttest2''); <font color="green">%use two-sample t-test</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''test'',''WST'');    <font color="green">%use Wilcoxon rank sum test</font>' char(10) ...
    
    ]);


%% TAIL
h=uicontrol('style','popup','units','norm','position',[0.30991 0.66426 0.1 0.03],...[0.43847 0.66664 0.1 0.03],...
    'string',{'both','left','right'},...
    'tag','tail','backgroundcolor','w','value',1,'HorizontalAlignment','left','fontsize',7,...
    'tooltipstring',...
    ['<b>' 'tail of statistical test' '</b>' char(10) ...
    '<b><font color="blue">command: </b>   "tail"' char(10) ...
    '<font color="black">dtistat(''set'',''tail'',''left''); <font color="green">%  set test direction to left-side</font>' char(10) ...
    '<font color="black">dtistat(''set'',''tail'',''both''); <font color="green">%  undirected test</font>' char(10) ...
    ]);

% ==============================================
%%    FDR
% ===============================================
% FDR
h=uicontrol('style','checkbox','units','norm','position',[.01 .55 .2 .05],'string','use FDR',...
    'tag','isfdr','backgroundcolor','w','value',us.isfdr,'fontsize',7,...
    'tooltipstring',...
    ['<b> use FDR for treatment of multiple comparisons (MCP). </b>' char(10) ...
    '<b><font color="blue">command: </b>   "FDR"' char(10) ...
    '<font color="black">dtistat(''set'', ''FDR'',0); <font color="green">%do not use FDR</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''FDR'',1); <font color="green">%       use FDR</font>' char(10) ...
    
    
    ]);

% showSigs
h=uicontrol('style','checkbox','units','norm','position',[.15 .55 .2 .05],'string','show SIGs only',...
    'tag','showsigsonly','backgroundcolor','w','value',us.showsigsonly,'fontsize',7,...
    'tooltipstring',...
    ['<b> Show significant results only. </b>' char(10) ...
    '<b><font color="blue">command: </b>   "showsigsonly"' char(10) ...
    '<font color="black">dtistat(''set'', ''showsigsonly'',0); <font color="green">%show full result</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''showsigsonly'',1); <font color="green">%show significant results</font>' char(10) ...
    
    ]);

%sort
h=uicontrol('style','checkbox','units','norm','position',[.32 .55 .2 .05],'string','sort Results',...
    'tag','issort','backgroundcolor','w','value',us.issort,'fontsize',7,...
    'tooltipstring',...
    ['<b>Sort results according p-value. </b>' char(10) ...
    '<b><font color="blue">command: </b>   "sort"' char(10) ...
    '<font color="black">dtistat(''set'', ''sort'',0); <font color="green">%do not sort result</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''sort'',1); <font color="green">%sort results</font>' char(10) ...
    ]);

%reverse contrast
h=uicontrol('style','checkbox','units','norm','position',[.47 .55 .2 .05],'string','reverse contrast',...
    'tag','reversecontrast','backgroundcolor','w','value',us.reversecontrast,'fontsize',7,...
    'tooltipstring',[...
    '<b> Reverse order of Groups: </b>' char(10) ...
    '  [ ] A vs B, where "A" and "B" are the groups to be compared ' char(10) ...
    '  [x] B vs A, .. flip group order' char(10) ...
    '<b><font color="red"> This changes only the sign of the statistical test-value (t-value)! </font></b>' char(10) ...
    '<b><font color="blue">command: </b>   "rc"' char(10) ...
    '<font color="black">dtistat(''set'', ''rc'',1); <font color="green">%reverse group-order</font>' char(10) ...
    ]);


%% parallel processing
h=uicontrol('style','checkbox','units','norm','position',[0.30276 0.40238 0.2 0.05],'string','parallel proc.',...
    'tag','isparallel','backgroundcolor','w','value',us.isparallel,'fontsize',7,...
    'tooltipstring',...
    ['<b>parallel processing </b>' char(10) ...
    '<b><font color="blue">command: </b>   "isparallel"' char(10) ...
    '<font color="black">dtistat(''set'', ''isparallel'',0); <font color="green">%do not use  parallel processing </font>' char(10) ...
    '<font color="black">dtistat(''set'', ''isparallel'',1); <font color="green">% use  parallel processing</font>' char(10) ...
    ]);


%% qFDR-value
tt=['<b> Desired false discovery rate. {default: 0.05}. </b>' char(10) ...
    '<b><font color="blue">command: </b>   "qFDR"' char(10) ...
    '<font color="black">dtistat(''set'', ''qFDR'',0.01); <font color="green">%set q-FDR to 0.01</font>' char(10) ...
    
    ];
%EDIT
h=uicontrol('style','edit','units','norm','position',[.01 .52 .05 .03],'string',num2str(us.qFDR),...
    'tag','qFDR','backgroundcolor','w','value',1,'fontsize',7,...
    'tooltipstring',tt);
%label
h=uicontrol('style','text','units','norm','position',[.06 .52 .05 .03],'string','qFDR',...
    'backgroundcolor','w','tooltipstring',tt);


%% noSeeds
tt=['<b> Number of seeds (noSeeds)  </b>' char(10) ...
    ' connectivity-matrizes (weights) will be normalized by noSeeds prior calculation of connectivity metrics' char(10) ...
    '<font color="red">not used for MRtrix data!</font>' char(10) ...
    '<b><font color="blue">command: </b>   "nseeds"' char(10) ...
    '<font color="black">dtistat(''set'', ''nseeds'',1e6); <font color="green">%set number of seets to 1e6</font>' char(10) ...
    ];
h=uicontrol('style','edit','units','norm','position',[0.83132 0.6095 0.1 0.03],'string',num2str(us.noSeeds),...
    'tag','noSeeds','backgroundcolor','w','value',1,'HorizontalAlignment','left',...
    'tooltipstring',tt,'fontsize',7);

h=uicontrol('style','text','units','norm','string','noSeeds',...
    'backgroundcolor','w','position',[0.72418 0.6095 0.1 0.03],'HorizontalAlignment','right', 'tooltipstring',tt);


%% proportional threshold
h=uicontrol('style','checkbox','units','norm','position',[0.74739 0.54998 0.2 0.05],...
    'string','proport threshold',...
    'tag','isproportthreshold','backgroundcolor','w','value',us.isproportthreshold,'fontsize',7,...
    'tooltipstring',...
    ['<b>' 'use propotional threshold to threshold data' '</b>' char(10) ...
    '<font color="black">! <b><font color="red">for MRtrix data only !</font></b>' char(10) ...
    ...
    '<b><font color="blue">command: </b>   "propthresh"' char(10) ...
    '<font color="black">dtistat(''set'', ''propthresh'',0); <font color="green">%  no proportional threshold</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''propthresh'',1); <font color="green">%  use proportional threshold</font>' char(10) ...
    ]);

%% threshold-txt
tt= ['threshold value when use propotional threshold to threshold data'  ...
    '<br><font color="black">! <b><font color="red">for MRtrix data only !</font></b>' ...
    '<br>"thresholds" the connectivity matrix by preserving a ' ....
    '<br> proportion p (value between 0 and 1) of the strongest weights. All other weights, and' ...
    '<br>all weights on the main diagonal (self-self connections) are set to 0.'...
    '<br>-----------------------'...
    '<br>if value is set to "max" : a threshold with the maximal small worldness-score is used  '...
    '<br>otherwise set value for example to 0.2 (keep 20% data)  ,0.8 (keep 80% data)...  '...
    '<br>'...
    '<b><font color="blue">command: </b>   "thresh"'  char(10) ... ...
    '<font color="black">dtistat(''set'',''thresh'',''max''); <font color="green">%use threshold with the maximal small worldness-score</font>' char(10) ...
    '<font color="black">dtistat(''set'',''thresh'',0.2); <font color="green">%keep 20% of data</font>' char(10) ...
    
    ];

h=uicontrol('style','text','units','norm','string','threshold',...
    'backgroundcolor','w','position',[0.74561 0.51903 0.1 0.03],'HorizontalAlignment','right', 'tooltipstring',tt);
%% threshold-edit
h=uicontrol('style','edit','units','norm','position',[0.85275 0.5238 0.07 0.03],'string',num2str(us.threshold),...
    'tag','threshold','backgroundcolor','w','value',1,'HorizontalAlignment','left',...
    'tooltipstring',tt,'fontsize',7);

% %% logarithmize
h=uicontrol('style','checkbox','units','norm','position',[0.80453 0.47856 0.13 0.03],...
    'string','logarithmize',...
    'tag','logarithmize','backgroundcolor','w','value',us.logarithmize,'fontsize',7);
set(h,'tooltipstr',...
    ['<b>' 'logarithmize data' '</b>' char(10) ...
    '<b><font color="blue">command: </b>   "log"' char(10) ...
    '<font color="black">dtistat(''set'', ''log'',0); <font color="green">%  use raw data</font>' char(10) ...
    '<font color="black">dtistat(''set'', ''log'',1); <font color="green">%  logarithmize data</font>' char(10) ...
    ]);





% ==============================================
%%   TYPE OF CALCULATION
% ===============================================
h=uicontrol('style','text','units','norm');
set(h,'position',[0.1 .45 .2 .03],'backgroundcolor','w', 'string',' calculate..');


% %DTI-PARAMETER
% h=uicontrol('style','pushbutton','units','norm','position',[0 .4 .2 .05],...
%     'string','stat DTI parameter',...
%     'tag','statDTIparameter','backgroundcolor',[0.8941    0.9412    0.9020],'callback',@statDTIparameter,...
%     'tooltipstring',...
%     ['calculate statistic for DTI parameter' char(10) ...
%     '<font color="black">command: <b><font color="green">calcparameter</font>'...
%     ]);
%DTI-CONNECTIVITIES
h=uicontrol('style','pushbutton','units','norm','position',[0.099197 0.40238 0.2 0.05], ...[0.2 .4 .2 .05],...
    'string','stat Connectivity',...
    'tag','statconnectivity','backgroundcolor',[0.8941    0.9412    0.9020],'callback',@statconnectivity,...
    'tooltipstring',...
    ['<b>' 'calculate statistic for connectivity data' '</b>' char(10) ...
    ...
    '<b><font color="blue">command: </b>   "calcconnectivity"' char(10) ...
    '<font color="black">dtistat(''calcconnectivity''); <font color="green">%  calculate the statistic</font>' char(10) ...
    ]);




% ==============================================
%%   load/save calculation
% ===============================================
% LOADCALC
h=uicontrol('style','pushbutton','units','norm','position',[0.43 .4 .15 .05],...
    'string','load calculation',...
    'tag','calcLoad','backgroundcolor','w','callback',@calcLoad,...
    'tooltipstring',...
    ['<b>' 'load a calculation' char(10) '..useful for timeconsuming calculations'  '</b> ' char(10) ...
    'Calculation must be performed and saved before loading a calculation.' char(10) ...
    ...
    '<b><font color="blue">command: </b>   "loadcalc"' char(10) ...
    '<font color="black">dtistat(''loadcalc''); <font color="green">%  load calculation via userInterface </font>' char(10) ...
    '<font color="black">dtistat(''loadcalc'', ''myCalc.mat''); <font color="green">%  load calculation "myCalc.mat" </font>' char(10) ...
    ]);

%SAVECALC
h=uicontrol('style','pushbutton','units','norm','position',[0.58 .4 .15 .05],...
    'string','save calculation',...
    'tag','calcSave','backgroundcolor','w','callback',@calcSave,...
    'tooltipstring',...
    ['<b>' 'save a calculation' '</b> ' char(10)...
    '..useful for timeconsuming calculations' char(10) ...
    '<b><font color="blue">command: </b>   "savecalc"' char(10) ...
    ...
    '<font color="black">dtistat(''savecalc'',''myCalc.mat''); <font color="green">%  save calculation "myCalc.mat" </font>' char(10) ...
    ]);
% ==============================================
%%   Show results
% ===============================================

h=uicontrol('style','pushbutton','units','norm','string','show Results',...
    'tag','redisplay','backgroundcolor','w','callback',@redisplay,'fontweight','bold');
set(h,'position',[0.13 .35 .14 .05],'backgroundcolor',[1.0000    0.8431         0]);
set(h,'tooltipstring',...
    ['Show tabled results' char(10) ...
    '<b><font color="blue">command: </b>   "showresult"' char(10) ...
    '<font color="black">dtistat(''showresult''); <font color="green">%  show Results in extra window </font>' char(10) ...
    
    ]);
% ==============================================
%%   plot results
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .3 .14 .05],...
    'string','plot Results',...
    'tag','plotdata','backgroundcolor','w','callback',@show,...
    'tooltipstring','visualize results: for type of visulization see right pulldown menu');

h=uicontrol('style','popupmenu','units','norm','position',[0.27 .3 .15 .05],...
    'string',{'matrix' 'matrix_oldversion' 'plot3d'},'tag','menuplot','backgroundcolor','w',...
    'tooltipstring','type of visualization to show');
% ==============================================
%%   export
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .25 .14 .05],...
    'string','export Results',...
    'tag','export','backgroundcolor','w','callback',@export,...
    'tooltipstring',[...
    '<b> EXPORT/Save Results: ' '</b>' char(10) ...
    '<b><font color="blue">command: </b>   "export"' char(10) ...
    '<font color="black">dtistat(''export'',''test1.xlsx''); <font color="green">% use default exportType, save Excelfile "test1.xlsx" </font>' char(10) ...
    '<font color="black">dtistat(''export'',''test1.xlsx'',''exportType'',1); <font color="green">%  use exportType-"1", save Excelfile "test1.xlsx" </font>' char(10) ...
    ]);

list={'EXCEL:separate sheets' 'EXCEL:single sheet (old style)'};
listtt=cellfun(@(a,b){[' '  num2str(a) ')' b ]} ,num2cell(1:length(list)),list);
h=uicontrol('style','popupmenu','units','norm','position',[0.27062 0.24763 0.15 0.05],...
    'string',list,'tag','exportType','backgroundcolor','w',...
    'fontsize',7,    'value',1,...
    'tooltipstring',[...
    '<b> EXPORT OPTION: ' '</b>' char(10) ...
    strjoin(listtt,char(10))  char(10) ...
    '<b><font color="blue">command: </b>   "exportType"' char(10) ...
    '<font color="black">dtistat(''set'',''exportType'',1);<font color="green">%set exportType to "1"</font>' char(10) ...
    '<font color="black">dtistat(''export'',''test1.xlsx'',''exportType'',1);<font color="green">%set exportType to "1" and save Excelfile "test1.xlsx" </font>' char(10) ...
    ...
    ]);

% ==============================================
%%   export volume
% ===============================================


h=uicontrol('style','pushbutton','units','norm','position',[0.13 .20 .14 .05],...
    'string','export4xvol3d','fontsize',7,...
    'tag','export4xvol3d_btn','backgroundcolor','w','callback',@export4xvol3d_btn,...
    'tooltipstring',...
    ['export results for <b>[xvol3d.m]  </b>-visualization' char(10) ...
    'Only for DTI-connectivities (not for DTI-parameter).' char(10) ...
    '<font color="black">command: <b><font color="green">export4xvol3d</font>'...
    ]);

%

% ==============================================
%%   resize matrix
% ===============================================
h=uicontrol('style','pushbutton','units','norm','position',[0.53668 0.85711 0.14 0.05],...[0.004557 0.92853 0.14 0.05],...
    'string','change matrix',...
    'tag','reshapeMatrix','backgroundcolor','w','callback',@cb_reshapeMatrix,...
    'tooltipstring',...
    ['reduce DTI data Matrix:' char(10) ...
    'reduce matrix to connections of interest' char(10) ...
    'and save the reduced data-matrix' char(10) ...
    %'<font color="black">command: <b><font color="green">export</font>'...
    ]);

% ==============================================
%%   separatorLines
% ===============================================
h=uicontrol('style','pushbutton','units','norm','backgroundcolor','r');
set(h,'position',[0.004557 0.71902 0.6 0.005]);

h=uicontrol('style','pushbutton','units','norm','backgroundcolor','r');
set(h,'position',[0.004557 0.49761 0.6 0.005]);


% ==============================================
%%   other stuff pulldown
% ===============================================

% h=uicontrol('style','popupmenu','units','norm',...
%     'string',{...
%     '-info-'
%     'get code'
%     'reload data and parameter'}, 'tag','otherfun','backgroundcolor','w','callback',@otherfun,...
%     'tooltipstring','..other stuff');
% set(h,'position',[.8 .75 .195 .05])



tooltip2html(); %make HTML-tooltips
% ==============================================
%%     inputs
% ===============================================
% ==============================================
%%   HTML tooltips
% ===============================================

function tooltip2html();
%make HTML-tooltips
hf=findobj(0,'tag','dtistat');
ch=get(hf,'children');
for i=1:length(ch)
    tt=get(ch(i),'tooltipstring');
    if ~isempty(tt)
        tt=['<html>' tt  '</html>'];
        tt=regexprep(tt,char(10),'<br>');%replace char(10) using <br>
        set(ch(i),'tooltipstring',tt);
    end
end

% ==============================================
%%   LOAD CALC
% ===============================================
function run_calcLoad(par)
cprintf([.6 .6 .6],['Load an existing calculation [mat-file].\n']);
hf=findobj(0,'tag','dtistat');
% u=get(hf,'userdata');

if exist('par')==1
    if isfield(par,'loadcalc')==1;
        if strcmp(par.loadcalc,'loadcalc')==0
            file=par.loadcalc  ;
        end
    end
end
if exist('file')~=1
    [fi pa]=uigetfile(fullfile(pwd,'*.mat'),'load a calculation [mat-file]');
    if isnumeric(fi); disp('...calculation not loaded..cancelled'); return;end
    file=fullfile(pa,fi);
end
[pax name ext]=fileparts(file);
if isempty(pax); pax=pwd; end
file=fullfile(pax,[name '.mat']);

w=load(file);
set(hf,'userdata',w.u);
% disp(['loaded existing calculation: ' file]);

% update GUI parameter -------------
if isfield(w.u.pw,'z')==1
    z= w.u.pw.z;
    
    
    try;  set(findobj(hf,'tag','issort')       , 'value',  z.issort  );catch; disp(lasterr); end
    try;    set(findobj(hf,'tag','isfdr')        , 'value',  z.isfdr  );catch; disp(lasterr); end
    try;    set(findobj(hf,'tag','showsigsonly') , 'value',  z.showsigsonly  );catch; disp(lasterr); end
    
    try;    set(findobj(hf,'tag','qFDR') , 'string',  num2str(z.qFDR)  );catch; disp(lasterr); end
    try;    set(findobj(hf,'tag','noSeeds') , 'string',  num2str(z.noSeeds)  );catch; disp(lasterr); end
    
    try;     set(findobj(hf,'tag','reversecontrast') , 'value',  z.reversecontrast  );catch; disp(lasterr); end
    
    try;     hb=findobj(hf,'tag','typeoftest1');
        set(hb,'value',find(strcmp(hb.String,z.Test)));
    catch; disp(lasterr); end
    
    
    try;    set(findobj(hf,'tag','inputsource')        , 'value',  z.inputsource  );   catch; disp(lasterr); end
    try;     set(findobj(hf,'tag','isproportthreshold') , 'value',  z.isproportthreshold  );catch; disp(lasterr); end
    try;     set(findobj(hf,'tag','threshold')          , 'string', num2str(z.threshold)  );catch; disp(lasterr); end
    try;     set(findobj(hf,'tag','logarithmize')       , 'value',  z.logarithmize  );catch; disp(lasterr); end
    
    %     vartype=1;
    % % us.typeoftest1=1;  %[1]ttest2,[2]WRS
    % hf=findobj(0,'tag','dtistat');
    % z.issort        =get(findobj(hf,'tag','issort'),'value');
    % z.isfdr         =get(findobj(hf,'tag','isfdr'),'value');
    % z.showsigsonly  =get(findobj(hf,'tag','showsigsonly'),'value');
    % z.qFDR          =str2num(get(findobj(hf,'tag','qFDR'),'string'));
    % z.vartype       =vartype;
    % z.noSeeds       =str2num(get(findobj(hf,'tag','noSeeds'),'string'));
    %
    % hb=findobj(gcf,'tag','typeoftest1');
    % z.Test         =hb.String{hb.Value};
    %
    % z.inputsource         = get(findobj(hf,'tag','inputsource'),'value');
    %
    % z.isproportthreshold  = get(findobj(hf,'tag','isproportthreshold'),'value');
    % z.threshold           = get(findobj(hf,'tag','threshold'),'string');
    % z.logarithmize        = get(findobj(hf,'tag','logarithmize'),'value');
    %
    
    
end

%-----------------------------------

cprintf([1 0 1],['loaded: '  strrep(file,filesep,[filesep filesep])  '\n' ]);
% ==============================================
%%    SAVE CALC
% ===============================================

function run_calcSave(par)
cprintf([.6 .6 .6],['Save a calculation [mat-file].\n']);
hf=findobj(0,'tag','dtistat');
u=get(hf,'userdata');

if exist('par')==1
    if isfield(par,'savecalc')==1;
        if strcmp(par.savecalc,'savecalc')==0
            file=par.savecalc  ;
        end
    end
end
if exist('file')~=1
    [fi pa]=uiputfile(fullfile(pwd,'*.mat'),'save a calculation [mat-file]');
    if isnumeric(fi); disp('...calculation not saved..cancelled'); return;end
    file=fullfile(pa,fi);
end
[pax name ext]=fileparts(file);
if isempty(pax); pax=pwd; end
file=fullfile(pax,[name '.mat']);

if exist(pax)~=7
    mkdir(pax);
end

save(file,'u');
% disp('calculation saved');
showinfo2(['calculation saved: ' ] ,file );

function calcLoad(e,e2)
run_calcLoad();
function calcSave(e,e2)
run_calcSave();

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
        hf=findobj(0,'tag','dtistat');
        figure(hf);
        drawnow;
        us=get(hf,'userdata');
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
hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');
val=get(e,'value');
us.f1design=val;
set(hf,'userdata',us);

htests=findobj(hf,'tag','typeoftest1');
if val==0 %between
    set(htests,'string',{'ttest2' 'WST'  'permutation' 'permutation2' 'BM'});
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
cprintf([1 0 1],['loading group-assignment (xls-file)...wait..' ]);

hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');
ext=[];
try
    [pas fis ext]=fileparts(file);
end
if exist('file')==0 || isempty(ext)
    % ==============================================
    %%  UI: group-assignment
    % ===============================================
    %[fi pa]=uigetfile(pwd,'select group assignment file (excel file)','*.xls');
    msg={...
        'Select the group-assignment file (Excel file).'
        'This excel-file contains: '
        '  1) The animal-names in column-1 '
        '  2) A group-assignment tag (numeric or string) in column-2' };
    [t] = cfg_getfile2(1,'any',msg,[],pwd,'.xls|.xlsx.|txt');
    % ==============================================
    %%
    % ===============================================
    
    file=char(t);
    if file==0
        cprintf([1 0 1],['process aborted.\n' ]);
        return;
    end
end
file=char(file);
[pathx xname ext]=fileparts(file);
if isempty(pathx)
    file=fullfile(pwd,[xname ext]) ;
end

us.groupfile=file;
set(hf,'userdata',us);

%check groupsize
[~,~,a]=xlsread(file);
cprintf([1 0 1],['done.\n' ]);
a(1,:)=[];
if isempty(a); error(['empty group-assignment file: ' file] ); end

idel=find(strcmp(cellfun(@(a){[ num2str(a)]} , a(:,1)),'NaN'));
a(idel,:)=[];
a=cellfun(@(a){[ num2str(a)]},a); % to string
a(regexpi2(a(:,1),'NaN'),:)=[] ; %remove nan
a(regexpi2(a(:,2),'NaN'),:)=[] ;

cprintf([0 .5 0],['==========================================\n' ]);
cprintf([0 .5 0],['       group-assignment\n' ]);
cprintf([.5 .5 .5],['The first two columns constitute the animal name and the group assignment, respectively. \n' ]);
disp(a);
cprintf([0 .5 0],['==========================================\n' ]);


tb=tabulate((a(:,2)));
gp='';
for i=1:size(tb,1)
    gp=[gp ['grp-' tb{i,1} ' (n=' num2str(tb{i,2}) ')' ] ];
    if i<size(tb,1)
        gp=[gp ', '  ];
    end
end

cprintf([0 .5 0],['NOTE: It is assumed that the group-assignment-file (Excelfile) contains a header (1st. row).' '\n']);
cprintf([0 .5 0],['Ncases found: '   num2str(sum(cell2mat(tb(:,2)))) '\n']);
cprintf([0 .5 0],['subgroups   : '   gp '\n']);


function paramfiles(par)
% ==============================================
%%   load DTI-PARAMETER
% ===============================================
hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');

if exist('par')==1
    if isfield(par,'paramfiles')
        if sum(strcmp(par.paramfiles,'paramfiles'))==0
            files=par.paramfiles;
        end
    end
end



if exist('files')~=1
    pa=pwd;
    % [files,dirs] = spm_select('FPListRec',pa,'.*.parameter_stat.txt');
    % if isempty(files);
    %     disp('no DTI-parameter files found');
    %     return
    % end
    % fi=cellstr(files);
    
    msg={...
        'Select DTI-parameter file from DSI-studio (TXTfile).'
        ' -The selected files must be txt-files.'
        ' Select the files (A) manually or do it (B) recursively:'
        '  _____ (B) RECURSIVELY find files _____  '
        '(1): Select the main folder containing all DTI-parameter files.'
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
        
        };
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

cprintf([repmat(.6,[1 3])],['Reading DTI-paramter files ..wait..\n' ]);
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
    
    
    d2(i)=d;
end
cprintf([repmat(.6,[1 3])],['Done.\n' ]);


us.dtiparameter=d2;
set(hf,'userdata',us);


% ==============================================
%%     load connectivity files
% ===============================================
function cb_reshapeMatrix(e,e3)


dti_changeMatrix;
cprintf([0 .5 0],[ 'DONE.' '\n' ]);

% 'a'
%
%
% s=dbstack;
% % line=s(2).line;
% [s.name ': ' num2str(s.line)];
%
% which([mfilename '.m'])
% eval(['edit ' which([mfilename '.m']) ]);
% hEditor = matlab.desktop.editor.getActive;
% hEditor.goToLine(s.line);


% ==============================================
%%     load connectivity files
% ===============================================
function confiles(par)
hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');

% get source
hf=findobj(0,'tag','dtistat');
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
%%  argin
% ===============================================
if exist('par')==1
    if isfield(par,'confiles') ==1;     files    =cellstr(par.confiles);      end
    if isfield(par,'labelfile')==1;     labelfile=cellstr(par.labelfile);      end
    if isfield(par,'conpath')==1;       conpath=cellstr(par.conpath); else; conpath=[] ;    end
end

if exist('files')~=0
    if iscell(files) %
        if isempty(files) || strcmp(files{1},'confiles')==1
            clear files
        end
    else
        clear files
    end
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
    
    if isempty(conpath) %explicit names of each csv-file
        fi=files
    else
        conpath=char(conpath)
        files  =char(files)
        
        if exist(conpath)
            [csvfiles] = spm_select('FPListRec',conpath,['^' files '$']);
            if isempty(csvfiles)
                msgbox(['file "' files  '" not found in "conpath" (main folder containing csv-files)...check spelling  CSV-file']);
                return
            end
            files=cellstr(csvfiles);
            fi=files;
        else
            msgbox('"conpath" (main folder containing csv-files) not specified');
            return
        end
    end
    
    
end

% ==============================================
%%   LABEL-FILE
% ===============================================
if source==2 %mrtrix
    if exist('labelfile')  ~=1
        msg={'select one(!) label-file (*.txt) for MRtrix'};
        [fi2,sts] = cfg_getfile2(1,'any',msg,[],pwd, '.*.txt');
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
    
    % ==============================================
    %%   label
    % ===============================================
    % check path
    if size(char(labelfile),1)==1
        [pal fil extl]=fileparts(char(labelfile));
        if isempty(pal)
            lablist=(stradd(fileparts2(fi),[filesep fil extl],2));
            iuse=min(find(existn(lablist)==2));
            if isempty(iuse)
                error([ 'lutfile: not found ...use fullpath-lutfile or check filename' ]) ;
            else
                labelfile=lablist(iuse);
            end
        end
    end
    
    
    
    try
        t=readtable(char(labelfile));
        t=table2cell(t);
    catch
        t0=preadfile(char(labelfile));
        t0=t0.all;
        
        tt={};
        for i=1:size(t0,1)
            temp=  strsplit(t0{i});
            tt(i, 1:length(temp))=temp;
        end
        if isempty(char(tt(:,1)))==1 %remove 1st-column if empty
            tt(:,1)=[];
        end
        %remove header-row
        if strcmp(tt{1},'#')==1 || ~isempty(strfind(t0{1},'Labelname'))
            tt(1,:)=[];
        end
        t=tt(:,1:6);
    end
    
    
    
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

cprintf([0 .5 0],['selection of DTI data done.\n' ]);


% ==============================================
%%    loading groupassignment
% ===============================================
if isfield(us, 'groupfile') && exist(us.groupfile)==2
    [~,~,a]=xlsread(us.groupfile);
    a(1,:)=[];
    a=cellfun(@(a){[ num2str(a)]},a);
    a=a(:,1:2);
    idel=find(strcmp(cellfun(@(a){[ num2str(a)]} , a(:,1)),'NaN')); %remove NAN
    a(idel,:)=[];
    
    if length(unique(a(:,1)))~=size(a,1)       % __SEARCH for douplicates
        [uniqueA i j] = unique(a(:,1),'first');
        indexToDupes = find(not(ismember(1:numel(a(:,1)),i)));
        mboxp.Interpreter = 'tex';
        mboxp.WindowStyle = 'non-modal';
        msgbox({['\bf Excelfile contains identical animal-names:\rm'];
            ['\color[rgb]{0,0,1} -DOUPLICATES found for: \color[rgb]{0,0,0} ']
            strjoin( strrep(a(indexToDupes,1),'_','\_'), char(10))
            },'ERROR',mboxp);
        return
    end
    
    if exist('namesMRtrix')% keep only animals in "fi" and "namesMRtrix" which are in the ExcelFile
        [isfound ixfound]=ismember(a(:,1), namesMRtrix);
        if length(find(isfound==0))>0
            cprintf('*[1 0 1]',['Excel-file contains the following animals\n...' ...
                'but no corresponding DTI-data found for the following animals: '  '\n']);
            disp(a(find(isfound==0),:));
            cprintf([.6 .6 .6],['..check if this needs to be resolved (these animals are skipped from the process)  ' '\n']);
            
        end
        % sort "fi" and "namesMRtrix" according to excelfile
        ixfound(ixfound==0)=[];
        fi        =fi(ixfound);
        namesMRtrix=namesMRtrix(ixfound);
    end
    
    
    
end
% ==============================================
%%    loading groupassignment
% ===============================================



cprintf('*[0 0 1]',[' .. [reading DTIdata]..'  '\n']);
c={};
con=[];
names={};
for i=1:size(fi,1)
    
    if exist('namesMRtrix')==1
        cprintf([.6 .6 .6],['[reading DTIdata]: '   strrep(fi{i},[filesep],[filesep filesep])  ]);
        cprintf([0 .5 0],[' [Excel]: '   a{i,1}  ' (' a{i,2}  ') '  ]);
        cprintf([.8 .8 .8],['..please check assignment ' '\n']);
    else
        cprintf([.6 .6 .6],['[reading DTIdata]: '   strrep(fi{i},[filesep],[filesep filesep])  '\n']);
    end
    
    if source==1
        a=load(fi{i});
        label=char(a.name);
        label=strsplit(label,char(10))';
        label(find(cellfun(@isempty,label)))=[] ;
        [~,namex]=fileparts(fi{i});  %mousename
        ac=a.connectivity;           %connectMAtrix
    elseif source==2
        try
            ac   =csvread(fi{i});
        catch
            msgbox(['failed to read:' fi{i}]);
            error(['failed to read:' fi{i}]);
        end
        namex=namesMRtrix{i};
        label=t(:,2);
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
cprintf([0 0 1],['Done (N=' num2str(length(names)) ' animals).\n']);

% c={};
c.mousename=names;
c.lutfile  =char(labelfile);
c.files    =files;
c.conlabels=connames;
c.condata  =con;
c.size     =si;
c.index    =ind;
c.labelmatrix=la;
c.label      =label;

us.con=c;

set(hf,'userdata',us);


% ==============================================
%%
% ===============================================



function [out expo]=calc_networkparameter(x,y, us,z)
% out: output as text document
% expo: output for export (cell)
out=[];
noSeeds=z.noSeeds;

% ==============================================
%%    %%   params
% ===============================================
%     z.f1design   =0;
%     z.typeoftest1=1;
%     z.vartype    =1;
%     z.qFDR       =0.05;
%     z.issort    =1;
%     z.showsigsonly=1;
%


% ==============================================
%%   construct matrizes
% ===============================================

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

% ==============================================
%%          get nw-parameter
% ===============================================
if ~isempty(regexpi(us.con.files{1},'.csv$')); %FOR MATRIX: - do not Seed-division
    d=cmat;
    disp('    - no division by number of seeds');
    
else
    d=cmat./noSeeds;     % normalize weights by number of seeds (  %noSeeds=10^6;)
    disp(['    - division by number of seeds ('  num2str(noSeeds) ')']  );
end
% clc;
disp('calc network metrics');
cprintf([1 0 1],[' *** CALC NETWORK METRICS  ***  \n' ]);
cprintf([0.4941    0.4941    0.4941],['..depending of the number of nodes..this process might take a while  \n' ]);
cprintf([0.4941    0.4941    0.4941],['..use [save calculation] to save the calculation connectivity statistic afterwards..   \n' ]);
cprintf([0.4941    0.4941    0.4941],['..use [load calculation] to load an already calculated connectivity statistic (i.e. omit re-calculation)   \n' ]);

cprintf([0 0.45 0],[' ONSET: ' datestr(now,'HH:MM:SS') '; #ANIMAL: ' num2str(size(d,3))  ...
    '; #NODES: '  num2str(size(d,1)) '\n' ]);

%
%==================================== select data /testbed  ===============================================================
% d2=d(1:10,1:10,:); %check
%  d2=d(1:50,1:50,:);%check
%   d2=d(1:100,1:100,:);%check
d2     = d; %FINAL
label2 = us.con.label(1:size(d2,1));

%% ==================================== Parallel PROC if [PCT] available  =============================================
if z.isparallel==1
    try
        cpus=feature('numCores');
        pp = gcp('nocreate');
        if isempty(pp)
            parpool( cpus);
        else
            %poolsize = p.NumWorkers
        end
        % delete(gcp('nocreate'))
    catch
        z.isparallel=0; % parallel proc does not work
    end
end
if  z.isparallel==1
    cprintf([0.4941    0.4941    0.4941],[' parallel processing: yes \n' ]);
else
    cprintf([0.4941    0.4941    0.4941],[' parallel processing: no  \n' ]);
end


%===================================== ================================================
% ==============================================
%%   SMALL WORLDNESS-1
% ===============================================
% % % addpath('C:\Users\skoch\Desktop\mdhumphries-SmallWorldNess-cb091b4');
% % % disp('lin-2458');

if z.inputsource==2
    swtype     =[1 2];
    %     stepsize   = 0.1;
    %     doplot     = 1;
    %     d2=smallwordnesswrapper(d2,swtype,stepsize,doplot);
    swordl=[];
    for i=1:size(d2,3)
        atic=tic;
        [dum  swlabel]=   smallworldness_sub(double(d2(:,:,i)>0),swtype) ;
        swordl(i,:)=dum;
        %disp( [ 't2_(min):' num2str(toc(atic)/60)]);
        
    end
    swordLabel=swlabel ;% {'S_ws' 'S_trans' 'S_ws_MC' 'S_trans_MC'};
end

% return
%===================================== REFERENCE PROGRESSBAR================================================
N  =size(d2,3) ;

tic
cprintf([0 0.45 0],['  TARGET STATE: ' ]);
for i=1:N
    cprintf([0 0.45 0],['.|']);
end
fprintf(1,'\n');
%===================================== PARFOR LOOP================================================
cprintf([0.9294 0.6941 0.1255],[' CURRENT STATE:  ' ]);

% np =[]; npv=[]; % vectorMetriclabel={}; scalarMetriclabel={};
[np npv]                              =deal([]);
[vectorMetriclabel scalarMetriclabel] =deal({});
if z.isparallel==1
    %% ==================[parfor]=============================
    parfor i=1:N
        fprintf('\b.|\n');%fprintf(1,['.|']);
        dx=d2(:,:,i);
        ws= calcConnMetrics(dx);
        np(:,i)    =ws.sc;   %SCALAR
        npv(:,:,i) =ws.vec;  %VEC
        k=i;
        if k==1
            vectorMetriclabel{i} = ws.veclabel;  %vectorMetriclabel
            scalarMetriclabel{i} = ws.sclabel;   %scalarMetricLabel
        end
    end
else
    %% ====================[for]===========================
    for i=1:N
        fprintf('\b.|\n');%fprintf(1,['.|']);
        dx=d2(:,:,i);
        ws= calcConnMetrics(dx);
        np(:,i)    =ws.sc;   %SCALAR
        npv(:,:,i) =ws.vec;  %VEC
        k=i;
        if k==1
            vectorMetriclabel{i} = ws.veclabel;  %vectorMetriclabel
            scalarMetriclabel{i} = ws.sclabel;   %scalarMetricLabel
        end
    end
end
vectorMetriclabel=vectorMetriclabel{1};
scalarMetriclabel=scalarMetriclabel{1}';

cprintf([0 0.45 0],[' calculation DONE (ET: ' sprintf('%2.2f',toc/60)  'min).\n' ]);

% ==============================================
%%   SMALL WORLDNESS-2: update
% ===============================================
if z.inputsource==2
    scalarMetriclabel =[scalarMetriclabel; swordLabel(:) ];
    np         = ([np;swordl']);
end
% ==============================================
%%   to struct
% ===============================================
nw.np        =np                  ;%scalarMetric
nw.nplabel   =scalarMetriclabel   ;
nw.npv       =npv                 ;%vectorMetric
nw.npvlabel  =vectorMetriclabel   ;

nw.label     =label2       ;
nw.grpidx    =iv           ;

% ==============================================
%%   statistic
% ===============================================
% % %%
% % if 1
% %     nw=evalin('base','nw');
% % end
if z.f1design==0
    [out expo]= indepstat_nwparameter(nw,z);
end



function runstat(param)
hf=findobj(0,'tag','dtistat');
figure(hf);
us=get(hf,'userdata');


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

% ==============================================
%%    loading groupassignment
% ===============================================
[~,~,a]=xlsread(us.groupfile);
a(1,:)=[];
a=cellfun(@(a){[ num2str(a)]},a);
a=a(:,1:2);
idel=find(strcmp(cellfun(@(a){[ num2str(a)]} , a(:,1)),'NaN')); %remove NAN
a(idel,:)=[];
% ==============================================
%%   check order
% ===============================================
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


%% ===============================================

disp('__________________________________________________')
cprintf([1 0 1],[' ASSIGNMENT:  EXCEL-DTIdata-matching'  '\n']);
% disp(' ASSIGNMENT columns: [EXCEL-animal | EXCEL-group | DTI-animal]');
disp(' ** check for NANS --> these data will be excluded and might be caused by')
disp('   inconsistent IDS/names  ');
disp('__________________________________________________')
cprintf('*[0 0 1]',[ '       [EXCEL-animal | EXCEL-group | DTI-animal]'  '\n']);
disp(a2);
%% ===============================================

tb=[a a2(:,2)];


% ==============================================
%%   group
% ===============================================

grp=unique(a(:,2));

% ## flip contrast-direction
if get(findobj(hf,'tag','reversecontrast'),'value')==1
    grp=flipud(grp(:));
end

% ==============================================
%%    pairwisecomparisons
% ===============================================
comb   =combnk(grp,2);
combstr=cellfun(@(a,b){[ a ' vs ' b]},comb(:,1),comb(:,2));

grpsize=[];
for i=1:length(grp)
    is=regexpi2(tb(:,2),grp{i}) ;%deal with nan
    grpsize(1,i) =sum(~isnan(cell2mat(tb(is,3))))  ; %length(regexpi2(tb(:,2),comb(i)));
end




% combstr=cellfun(@(a,b){[ a ' > ' b]},comb(:,1),comb(:,2));
us.contrast=[[grp{1} ' vs ' grp{2}]];
us.grpnames=grp ;%comb;
us.grpsize=grpsize;


% ==============================================
%%   display group membership
% ===============================================
% tb(12:18,3)={nan}

gname={};
len=[];
nchar=[];
for i=1:length(grp)
    is=regexpi2(tb(:,2),grp(i));
    % is=find(~isnan(cell2mat(tb(is,3)))); %NANS
    dum=tb(is,1);
    dum=[{['# GROUP-' grp{i} ' # (n=' num2str(length(is)) ')'] }; dum];
    gnames{1,i}=dum;
    
    len(i)=size(gnames{1,i},1);
    nchar(i)=size(char(gnames{1,i}),2);
end

mxchar=max(nchar);
disp('____________________________________________________________________________________________');
disp('  GROUP ASSIGNMENT --> PLEASE CHECK THIS');
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

disp(char(plog([],[{ ['GroupName  (N=' num2str(sum(us.grpsize)) ')' ]   'n'};...
    [us.grpnames(:) num2cell(us.grpsize)']],0,'Sub-groups','s=8')));



% ==============================================
%%      parameter
% ===============================================
z.f1design    = get(findobj(hf,'tag','F1design'),'value');
z.typeoftest1 = get(findobj(hf,'tag','typeoftest1'),'value');


% ==============================================
%%   pairwise tests
% ===============================================

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
z.isparallel    =get(findobj(hfig,'tag','isparallel'),'value');


hb=findobj(gcf,'tag','typeoftest1');
z.Test         =hb.String{hb.Value};
z.reversecontrast        = get(findobj(hfig,'tag','reversecontrast'),'value');


% ==============================================
%%   proportional threshold data
% ===============================================

z.inputsource         = get(findobj(hfig,'tag','inputsource'),'value');

z.isproportthreshold  = get(findobj(hfig,'tag','isproportthreshold'),'value');
z.threshold           = get(findobj(hfig,'tag','threshold'),'string');
z.logarithmize        = get(findobj(hfig,'tag','logarithmize'),'value');

hb= findobj(hfig,'tag','tail');
va=get(hb,'value');
li=get(hb,'string');
z.tail   =li{va};

if z.inputsource==2 && param==2  % MAtrix
    swtype     =[1 2];
    stepsize   = 0.1;
    doplot     = 1;
    
    z2.isproportthreshold=z.isproportthreshold;
    z2.threshold          =z.threshold;
    z2.logarithmize       =z.logarithmize;
    
    z2.swtype     =[1 2];
    z2.stepsize   = 0.1;
    z2.doplot     = 1;
    
    
    %d2=smallwordnesswrapper(xx.mat,swtype,stepsize,doplot)
    if z2.isproportthreshold==1
        d2=smallwordnesswrapper(xx.mat,z2);
    else
        d2=xx.mat;
        
        d2=xx.mat;
        if z2.logarithmize==1
            d2=log(d2);
            d2(isinf(d2))=0;
        end
        
    end
    
    
    for i=1:size(d2,3)
        dum  =d2(:,:,i);
        dum2=dum(xx.ind);
        if i==1
            DP=zeros([numel(dum2)   size(d2,3)] );
        end
        DP(:,i)=dum2;
    end
else
    
    
end
% ==============================================
%%
% ===============================================



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
                if z.inputsource==2
                    x=DP(:,i1);
                    y=DP(:,i2);
                else
                    x=xx.condata(:,i1);
                    y=xx.condata(:,i2);
                end
                groupmembers=  {xx.mousename(i1)' xx.mousename(i2)'};
            end
            grouplabel=comb(i,:);
            
            if z.typeoftest1==1
                stattype='ttest2';
                [h p ci st]=ttest2(x',y','tail',z.tail);
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
                        [p h st]=ranksum(x(j,:),y(j,:),'tail',z.tail);
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
                            [p h st]=ranksum(x(j,:),y(j,:),'tail',z.tail);
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
                [hv px]=ttest2(x',y','tail',z.tail);
                ikeep=find(~isnan(hv));
            elseif z.typeoftest1==4
                stattype='perm2';
                %tic;[pv,to,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05); toc
                if     strcmp(z.tail,'both');  tail= 0;
                elseif strcmp(z.tail,'left');  tail=-1;
                elseif strcmp(z.tail,'right'); tail= 1;
                end
                
                [p,T,cr,al]=mult_comp_perm_t2_nan(x',y',5000,tail,.05);
                p(find(isnan(T)))=1;
                h=p<0.05;
                [out hout]=getMESD(x,y,vartype);
                res    =[ h'  p'  T'  out ] ;
                reshead=['H' 'p' 'T' hout ];
                %reshead={'hyp' 'p' 'T'    'ME' 'SD' 'SE' 'n1' 'n2'   };
                
                [hv px]=ttest2(x',y');
                ikeep=find(~isnan(hv));
                %             [p,T,cr,al]=mult_comp_perm_t2_nan(x(ix,:)',y(ix,:)',5000,0,.05);
            elseif z.typeoftest1==5 %BM
                if 1
                    stattype='BM';
                    
                    if strcmp(z.tail,'both')~=1
                        msgbox( [ 'Brunner-Munzel-test' char(10) ....
                            'This test requires a two-tailed mode!' char(10)...
                            ' ... set "tail" to "both"  ']);
                        return
                        
                    end
                    
                    
                    
                    res=nan(size(x,1),[3]);
                    [out hout]=getMESD(x,y,vartype);
                    
                    
                    %                  [p1 h st]=ranksum(x(1,:),y(1,:),'tail','both'); p1
                    %                  [p2 h st]=ranksum(x(1,:),y(1,:),'tail','left'); p2
                    %                  [p3 h st]=ranksum(x(1,:),y(1,:),'tail','right');p3
                    %
                    %
                    %                  [h p1]=ttest2(x(1,:),y(1,:),'tail','both');p1
                    %                  [h p2]=ttest2(x(1,:),y(1,:),'tail','left');p2
                    %                  [h p3]=ttest2(x(1,:),y(1,:),'tail','right');p3
                    
                    for j=1:size(x,1)
                        try
                            %[p h st]=ranksum(x(j,:),y(j,:),'tail',z.tail);
                            [p SS]=brunner_munzel(x(j,:),y(j,:));
                            res(j,2:3)=[ p SS];
                        end
                    end
                    res(:,1)=double(res(:,2)<0.05);
                    res    =[ res          out];
                    reshead=['H' 'p' 'Z' hout];
                    
                    %reshead={'hyp' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
                    ikeep=find(~isnan(res(:,1)));
                end
                
                %                  if 0
                %                      stattype='BM';
                %                      res=nan(size(x,1),[3]);
                %                      [out hout]=getMESD(x,y,vartype);
                %
                %                      if regexpi(us.props.wst_stat,'Z','ignorecase')==1    % Z-SCORE
                %                          for j=1:size(x,1)
                %
                %                              %                         d1=x(j,:); d2=y(j,:);
                %                              %                         tr=2.5;
                %                              %                         d1( find(d1>(mean(d1)+tr*std(d1)) | d1<(mean(d1)-tr*std(d1))  ) )=[];
                %                              %                         d2( find(d2>(mean(d2)+tr*std(d2)) | d2<(mean(d2)-tr*std(d2))  ) )=[];
                %                              %                        [p h st]=ranksum(d1,d2);
                %                              %                         disp([length(d1)  length(d2)]);
                %                              [p h st]=ranksum(x(j,:),y(j,:),'tail',z.tail);
                %                              try
                %                                  res(j,:)=[h p st.zval];
                %                              catch
                %                                  res(j,:)=[h p nan];
                %                              end
                %                          end
                %                          res    =[ res          out];
                %                          reshead=['H' 'p' 'zval' hout];
                %                      else                                                 % RS-SCORE
                %                          for j=1:size(x,1)
                %                              try
                %                                  [p h st]=ranksum(x(j,:),y(j,:),'tail',z.tail);
                %                                  res(j,:)=[h p st.ranksum];
                %                              end
                %                          end
                %                          res    =[ res          out];
                %                          reshead=['H' 'p' 'RS' hout];
                %                      end
                %
                %                      %reshead={'hyp' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
                %                      ikeep=find(~isnan(res(:,1)));
                %                  end
                
                
                
            end
            
            % ==============================================
            %%   deal with missings
            % ===============================================
            ck1=sum(abs([x y]),2);
            inan   =find(isnan(ck1));
            izeros =find(ck1==0);
            idel=sort([inan(:);izeros(:)]) ;
            ikeep=setdiff( [1:size(x,1)]  , idel  );
            
            if 0 %OLD
                xex =sum(~isnan(x),2)./size(x,2);
                yex =sum(~isnan(y),2)./size(y,2);
                ix=find((xex>.9)&(yex>.9)&(~isnan(h(:)))  );  %90% of data must exist
                ikeep=ix;
                ikeep=1:size(x,1);
            end
            
            
            
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
            
            pw.z=z; %GUI-PARAMETER
            
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
    set(hf,'userdata',us);
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

cprintf([0 .5 0],['Show results ..wait..\n' ]);
% [~,fi]=fileparts(us.data);
%% GET PARAMETERS
hfig=findobj(0,'tag','dtistat');
z.issort        =get(findobj(hfig,'tag','issort'),'value');
z.isfdr         =get(findobj(hfig,'tag','isfdr'),'value');
z.showsigsonly  =get(findobj(hfig,'tag','showsigsonly'),'value');
z.qFDR          =str2num(get(findobj(hfig,'tag','qFDR'),'string'));
z.noSeeds       =str2num(get(findobj(hfig,'tag','noSeeds'),'string'));



z.inputsource         = get(findobj(hfig,'tag','inputsource'),'value');
z.isproportthreshold  = get(findobj(hfig,'tag','isproportthreshold'),'value');
z.threshold           = get(findobj(hfig,'tag','threshold'),'string');
z.logarithmize        = get(findobj(hfig,'tag','logarithmize'),'value');

hb=findobj(hfig,'tag','tail');
va=get(hb,'value');
li=get(hb,'string');
z.tail   =li{va};

%groupsizes
% tab=tabulate(cell2mat(us.tb(:,2)));
%     groupsize=cellfun(  @(a,b)  {['n group-' a ': '  sprintf('%2.0d',b )] }      ,tab(:,1),tab(:,2) );

grp='';
for i=1:length(us.grpnames)
    grp= [grp  [' "' us.grpnames{i} '"' '(n=' num2str(us.grpsize(i))  ')'] ];
end

%% SHOW RESULTS


sz={};
sz{end+1,1}=['_____________________________________________________________________________________________________________________'];
sz{end+1,1}=[' #wr                 '    us.pw(1).mode                              ];
sz{end+1,1}=['_____________________________________________________________________________________________________________________'];


% sz{end+1,1}=['MODE          : '      us.pw(1).mode          ];
sz{end+1,1}        =['Group-fileName:        '    '"'  us.groupfile  '"'  ];

[lutfilePath ,lutfile,ext]=fileparts(us.con.lutfile);
sz{end+1,1}        =['LUT-filePath:          '       '"' [lutfilePath] '"' ];
sz{end+1,1}        =['LUT-fileName:          '       '"' [lutfile ext] '"' ];

[~,connectivityFile,ext]=fileparts(us.con.files{1});
sz{end+1,1}        =['connectivity-fileName: '       '"' [connectivityFile ext] '"' ];


if isfield(us,'coifile') && ~isempty(us.coifile)
    coifile=us.coifile;
    cprintf([ .0745 0.62 1],['using COI-FILE: YES    (FILE: '  strrep(coifile,filesep,[filesep filesep]) ')\n' ]);
else
    coifile='none';
end
% sz{end+1,1}        =['ROI/COI file:           '       coifile];

sz{end+1,1}        =['groups (size):          '      grp];




try
    sz{end+1,1}    =['# number of pairwise connections:       '      num2str(size(us.con.conlabels,1))];
end

try
    sz{end+1,1}    =['# number of pairwise nodes tested:       '      num2str(length(us.pw(1).lab))];
end




sz{end+1,1}        =['pairwise test:          '      us.pw(1).stattype];
sz{end+1,1}        =['FDR-correction:         '      regexprep(num2str(z.isfdr),{'1' '0'},{'yes','no'})];
if z.isfdr==1
    sz{end+1,1}    =['FDR-qValue:             '      num2str(z.qFDR)];
end
sz{end+1,1}        =['sorting:                '      regexprep(num2str(z.issort),{'1' '0'},{'yes','no'})];
sz{end+1,1}        =['showsigsonly:           '      regexprep(num2str(z.showsigsonly),{'1' '0'},{'yes','no'})];

if z.inputsource==1
    if strcmp(us.pw(1).mode,'DTI CONNECTIVITY')
        sz{end+1,1}=['noSeeds:                '      num2str(z.noSeeds)   ' (for NW-metrics only)'];
        sz{end+1,1}=['Devision by NoSeeds:    '     'yes' ' (for NW-metrics only)'];
    end
end
if z.inputsource==2
    sz{end+1,1}   =['Devision by NoSeeds:    '     'no' ' (for NW-metrics only)'];
    sz{end+1,1}   =['proportional threshold: '      num2str(z.isproportthreshold)   ' (MRtrix only)'];
    sz{end+1,1}   =['threshold value:        '      num2str(z.threshold)            ' (MRtrix only)'];
    sz{end+1,1}   =['logarithmize data:      '      num2str(z.logarithmize)         ' (MRtrix only)'];
end

sz{end+1,1}        =['tail (stat. test):     '      z.tail];



sz{end+1,1}       =['DATE:                   '     datestr(now)];
% char(sz)


info2export=sz;


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
    
    
    % -----isFDR ----------------------------
    if z.isfdr==1
        
        ival=find(~isnan(sum(cell2mat(dat(:,2:3)),2)));
        H=zeros(size(dat,1),1);
        % Hx=fdr_bh([dat{ival,3}]',z.qFDR,'pdep','no');
        cprintf([ .0745 0.62 1],['PAIRWISE CONNECTIONS***' '\n' ]);
        [Hx, crit_p, adj_ci_cvrg, adj_p]=fdr_bh([dat{ival,3}]',z.qFDR,'pdep','yes');
        
        
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
    
    % ----- SORT ACCORD p-VALUE  ----------------------------
    %     isort=[1:size(dat,1)]';
    %     if z.issort==1
    %         [dat isort]= sortrows(dat,[3 2]);
    %     end
    if z.issort==1
        ip=find(strcmp(head,'p'));
        [dat isort]= sortrows(dat,ip);
    end
    
    
    % ----- showsigsonly  ----------------------------
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
        
        nettable=us.pw(i).networkmetricsExport;
        lg=networks_readoutput( nettable ,z);
        
        nw=[nw; lg];
        %nw=[nw; us.pw(i).networkmetrics];
    end
    %     uhelp(nw,1);
    sz=[sz;nw];
end

%%  next
hf=findobj(0,'tag','dtistat');
set(hf,'userdata',us);
out=sz;

%% assgin output
if ~isempty(us.outvar)
    assignin('base',us.outvar,out);
end


if doexport~=1
    %     uhelp(plog({},sz,0,[''],'s=0','plotlines=0' ),1);
    if exist('par')==1 & (strcmp(par,'nofig'))
    else
        if exist('par')==1 && isstruct(par) && isfield(par,'ResultWindow') && par.ResultWindow==0
            %do not show result-window
        else
            uhelp(sz,1);
        end
    end
    
    %     assignin('base','stat',sz);
end

if doexport==1
    removexlssheet(file);
    xlsstyle(file);
    disp(['created: <a href="matlab: system('''  [file] ''');">' [file] '</a>']);
end

cprintf([0 .5 0],['Done.\n' ]);



function lg=networks_readoutput( nettable ,z)
%%  concatenate to readable cell
% nettable =
%     'SCALAR NETWORK METRICS'    {10x18 cell}
%     'EFFICIENCY_WEI(DX,1)'      {21x18 cell}
%     'MODULARITY_UND(DX)'        {21x18 cell}
%     'CLUSTERING_COEF_WU(DX)'    {21x18 cell}
%     'DEGREES_UND(DX)'           {21x18 cell}
% netmet=nettable(:,1)
% ==============================================
%%
% ===============================================
if 0
    nettable=us.pw(i).networkmetricsExport
end
lg={};
netmet=nettable(:,1);
for jj=1:length( netmet)
    metric=netmet{jj};
    if jj==1
        str=['SCALAR NETWORK METRICS'];
    else
        str=[ ' #  [' upper(metric) ']' '         ..network metric  '];
    end
    ddum=nettable{jj,2};
    hd  =ddum(1,:);
    d   =ddum(2:end,:);
    reshead2=hd(2:end);
    % ==============================================
    %  sort
    % ===============================================
    if z.issort      ==1;
        d=sortrows(d,[find(strcmp(hd,'p'))])  ; %sort after p-value
        %d=sortrows(d,[4 3])
    else
        d=sortrows(d,[1])  ;
    end
    % ==============================================
    %  showsigsonly
    % ===============================================
    if length(hd)==1 && strcmp(hd,'Result')
        
    else
        if z.showsigsonly==1
            if z.isfdr==1
                icol=find(strcmp(hd,'Hfdr'));
                if isempty(icol);
                    keyboard ;
                end
                
            else
                icol=find(strcmp(hd,'Huncor'));
                if isempty(icol);
                    keyboard ;
                end
            end
            d=d( find(cell2mat(d(:,icol))==1), : );
        end
    end
    if ~isempty(d)
        isnum=cellfun(@isnumeric,d);
        d2      =d;
        reshead3=reshead2;
        for ii=1:size(d,2)
            if isempty(   find(isnum(:,ii) )); continue; end
            if any((sign(cell2mat(d(find(isnum(:,ii) ),ii))))==-1) == 1   %negativ values
                d2(:,ii)= cellfun(@(a){sprintf('% .5g',a)},d2(:,ii));
                reshead3{ii}=[' ' reshead3{ii}];
            else %positiv values
                d2(:,ii)= cellfun(@(a){sprintf('%.5g',a)},d2(:,ii));
            end
        end
        if jj==1
            col1name='PARAMETER ';
        else
            col1name='REGION ';
        end
        ds=[[col1name reshead3];d2 ];
        df=plog([],ds,0,str,'s=0;upperline=0;a=1');
    else
        lin=repmat('=',[1 length(str)+15]);
        df={lin; [str  ' --> ns.'];lin};
        
    end
    lg =[lg; df];%log results
end%ntestchunks







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


function plotresults(pp)%parser for CMD
show([],[],pp);

function show(e,e2,pp)

if exist('pp')~=1
    pp=struct();
end

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
    if type==1    %dti_plotmatrix
        cprintf([1 0 1],['wait... '    '\n' ]);
        
        if isfield(pp,'atlas') && exist(pp.atlas)==2 %cmdline
            us.atlas=pp.atlas;
            hf=findobj(0,'tag','dtistat');
            set(hf,'userdata',us);
        else
            %% ------------get the atlas
            choice='another';
            if isfield(us,'atlas')==1
                [choice] = questdlg(...
                    {'Use this atlas?' ...
                    [us.atlas]}, ...
                    ['select corresponding Atlas (excelfile with color-coding)'  ], ...
                    'Yes','select another atlas','cancel','Yes');
            end
            
            if ~isempty(strfind(choice,'cancel'))
                return
            elseif ~isempty(strfind(choice,'another'))
                [pa fi ext]=fileparts(us.groupfile);
                if isempty(pa); pa=pwd; end
                [t,sts] = spm_select(1,'any','select corresponding Atlas (excelfile with color-coding)' ,'',pa,'.*.xlsx');
                if isempty(t);
                    msgbox('corresponding Atlas (excelfile) not defined ...abort process');
                    return
                end
                us.atlas=t;
                hf=findobj(0,'tag','dtistat');
                set(hf,'userdata',us);
            end
        end
        %% ---
        
        
        
        dti_plotmatrix(us,pp);
        cprintf([1 0 1],['done.'    '\n' ]);
        
        
    elseif type==2 %'matrix'
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
                    ms=[r.stattype '(' r.tbhead{3} ') uncorrectd (matrix-size: ' num2str(si(1)) 'x' num2str(si(1))  ')'];
                elseif k==2
                    val=val.*(r.tb(:,2)<.05);
                    ms=[r.stattype '(' r.tbhead{3} ') using p<0.05   (n=' num2str(sum(val~=0)) '/' num2str(numel(val)) ')'];
                elseif k==3
                    val=val.*r.fdr;
                    ms=[r.stattype '(' r.tbhead{3} ') FDRcorrected   (n=' num2str(sum(val~=0)) '/' num2str(numel(val))  ')'];
                end
                if length(us.con.index)==length(val)
                    s(us.con.index)=val;
                else
                    % ==============================================
                    %%
                    % ===============================================
                    
                    si=us.con.size;
                    s=zeros(prod(si),1);
                    %----------------------
                    %si=size(ac);
                    tria=triu(ones(si));
                    tria(tria==1)=nan;
                    tria(tria==0)=1;
                    ind       =find(tria(:)==1); %index in 2d-Data
                    
                    vz=zeros(size(ind));
                    vz(r.ikeep)=val;
                    
                    s(ind)=vz;
                    
                    %----------------------
                    
                    if 0
                        s2=reshape(s,[si]);
                        fg,imagesc(s2)
                    end
                    % ==============================================
                    %%
                    % ===============================================
                    
                    %                     lab=r.lab;
                    %                     la=repmat({''}, [length(lab)  2]);
                    %                     for i=1:length(lab)
                    %                         la(i,:)= strsplit(lab{i},'--');
                    %                     end
                    %                     unila=unique(la);
                    %
                    %                     so=zeros(length(unila));
                    %
                    %
                    
                    
                    % ==============================================
                    %%
                    % ===============================================
                    
                    
                end
                s=reshape(s,[si]);
                s(isnan(s))=0;
                
                %                 im=imagesc(s);
                %                 if k==1
                %                     clim=caxis;
                %                 else
                %                     caxis(clim);
                %                 end
                
                pval=zeros(prod(si),1);
                
                if length(us.con.index)==length(r.tb(:,2))
                    pval(us.con.index)=r.tb(:,2);
                else
                    zv=zeros(size(us.con.index));
                    zv(r.ikeep)=r.tb(:,2);
                    pval(us.con.index)=zv;
                    
                end
                pval=reshape(pval,[si]);
                
                labelmatrix=us.con.labelmatrix;
                
                % ===========================================================================
                if 1 %REDUCE MATRIX
                    if 1%k==1  %reduce matrix
                        % [ix iy]=find(pval~=0)
                        ix=find(sum(abs(s),1)==0);
                        iy=find(sum(abs(s),2)==0);
                        
                        
                        
                        
                        %                                             te=pdum(:); te(te==0)=[];
                        %                                             te1=pval(:); te1(te1==0)=[];
                        %                                             [length(te) length(te1)]
                    end
                    
                    pdum=pval;
                    pdum(iy,:)=[];
                    pdum(: ,ix)=[];
                    pval=pdum;
                    
                    
                    sdum=s;
                    sdum(iy,:)=[];
                    sdum(: ,ix)=[];
                    s=sdum;
                    
                    
                    dum=labelmatrix;
                    dum(iy,:) =[];
                    dum(: ,ix)=[];
                    labelmatrix=dum;
                    
                end
                % ===========================================================================
                im=imagesc(s);
                if k==1
                    clim=caxis;
                else
                    caxis(clim);
                end
                
                
                sx.pval       =pval;
                sx.labelmatrix=labelmatrix;
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
        set(gcf,'menubar','figure');
        
    elseif type==3
        show3d;
    end %type
    
    
    
end

% ==============================================
%%   motion
% ===============================================
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
    
    %labx=us.con.labelmatrix(po(1),po(2));
    %       disp(labx)
    
    
    ax=findobj(gcf,'tag','ax4');
    tx=findobj(ax,'tag','txt1');
    
    ch=get(gca,'children');
    ch=findobj(ch,'type','image');
    dx=get(ch,'cdata');
    val=num2str(dx(po(2),po(1)));
    
    
    sx=get(ch,'userdata');
    pval =num2str( sx.pval(        po(2),po(1)));
    labx =         sx.labelmatrix( po(2),po(1));
    
    %     pval
    %     return
    
    %     msg=[ labx{1} '\color{magenta} [' val ']' '\color{blue} p[' pval ']'  ];
    %     msg=strrep(msg,'_' ,'\_');
    
    msg={[ labx{1}   ]};
    msg(end+1,1)={['\color{magenta} STAT-score: [' val ']'  '\color{blue}     p-value: [' pval ']'] };
    msg=strrep(msg,'_' ,'\_');
    %     size(msg)
    if isempty(tx)
        axes(ax);
        te=text(0,.5,msg,'fontsize',6,'tag','txt1','interpreter','tex');
        
        
    else
        set(tx,'string',msg);
    end
    
    
    
end


function xhelp(e,e2)
uhelp([mfilename '.m']);


% ==============================================
%%   [subs]
% ===============================================

function [lg expo]=indepstat_nwparameter(nw, z)
hf=findobj(0,'tag','dtistat');
vartype=z.vartype;
us=get(hf,'userdata');



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
        
    elseif z.typeoftest1==5 %BM
        if 1
            stattype='BM';
            res=nan(size(x,1),[3]);
            [out hout]=getMESD(x,y,vartype);
            
            for j=1:size(x,1)
                %[p h st]=ranksum(x(j,:),y(j,:));
                [p SS]=brunner_munzel(x(j,:),y(j,:));
                res(j,2:3)=[ p SS];
            end
            res(:,1)=double(res(:,2)<0.05);
            res    =[res           out];
            reshead=['H' 'p' 'Z' hout];
            inan=isnan(res(:,2));
            res(inan,1)=nan;
            ikeep=find(~isnan(res(:,1)));
        end
        %
        %            if 0
        %                stattype='WRS';
        %                res=nan(size(x,1),[3]);
        %                [out hout]=getMESD(x,y,vartype);
        %
        %                if regexpi(us.props.wst_stat,'Z','ignorecase')==1    % Z-SCORE
        %                    for j=1:size(x,1)
        %                        [p h st]=ranksum(x(j,:),y(j,:));
        %                        try
        %                            res(j,:)=[h p st.zval];
        %                        catch
        %                            res(j,:)=[h p nan];
        %                        end
        %                    end
        %                    res    =[res           out];
        %                    reshead=['H' 'p' 'zval' hout];
        %                else                                                  % RS-SCORE
        %                    for j=1:size(x,1)
        %                        try
        %                            [p h st]=ranksum(x(j,:),y(j,:));
        %                            res(j,:)=[h p st.ranksum];
        %                        end
        %                    end
        %                    res    =[res           out];
        %                    reshead=['H' 'p' 'RS' hout];
        %                    %reshead={'H' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
        %                end
        %
        %                ikeep=find(~isnan(res(:,1)));
        %
        %            end
        
        
        
        
        
    end
    
    
    % FDR
    idxkeep=ikeep;
    res1=res(idxkeep,:);
    if isempty(res1)
        res2=[];
    else
        %idxkeep=find(~isnan(sum(out(:,1:3),2)));
        %     Hfdr=fdr_bh(res(inonan,2) ,z.qFDR,'pdep','yes');
        [Hfdr, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(res1(:,2) ,z.qFDR,'pdep','yes');
        res2      =[Hfdr res1 adj_p];
    end
    reshead2  =[ {'Hfdr' 'Huncor' } reshead(2:end) 'adj_pFDR'] ;
    
    
    
    
    
    
    
    
    if jj==1
        label=nw.nplabel(idxkeep);
        str=['SCALAR NETWORK METRICS'];
        metric=str;
        
    else
        label=nw.label(idxkeep);
        metric=upper( nw.npvlabel{jj-1} );
        str=[ ' #  [' metric ']' '         ..network metric  '];
    end
    
    
    
    %
    % % z.issort       =1
    % % z.showsigsonly =1
    % % dat=res2
    % %
    
    
    d= [label num2cell(res2)];
    if ~isempty(d)
        if z.issort      ==1;
            d=sortrows(d,[4 ]);
        end
        %     if z.showsigsonly==1;
        %         %         d=d(find([d{:,3}]==33),:);
        %         d=d(find([d{:,3}]==1),:);
        %     end
        
        
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

export2excel();





function export2excel(par)
hf=findobj(0,'tag','dtistat');
if exist('par')==1
    if isfield(par,'export')
        if strcmp(par.export,'export')==0
            filename=par.export;
        end
    end
    if isfield(par,'exportType')
        hc=findobj(hf,'tag','exportType');
        set(hc,'value',par.exportType);
        drawnow;
    end
end


us=get(hf,'userdata');



%========== excel filename ===============================================================
if exist('filename')~=1
    [fiout paout]=uiputfile(pwd,'save excelfile as (choose file or type a filenmane) ...' ,'*.xlsx');
    if fiout==0
        cprintf([1 0 1],['.cound not proceed..no file/filename chosen.\n' ]);
        return
    end
    filename=fullfile(paout,fiout);
end
[pax name ext]=fileparts(filename);
if isempty(pax); pax=pwd; end
filename=fullfile(pax,[name '.xlsx']);

% ==============================================
%%  get exportType
% ===============================================
exportType=get(findobj(hf,'tag','exportType'),'value');

if exportType~=3
    cprintf([1 0 1],['exporting results (excelfile) ..wait..' ]);
else
    cprintf([1 0 1],['exporting results (TXTfile) ..wait..' ]);
end

% ==============================================
%%   EXPORT
% ===============================================

if exportType==1 %sheetwise EXCEL
    
    %     hf=findobj(0,'tag','dtistat');
    %     us=get(hf,'userdata');
    %     filename0=fullfile(pwd,'dum2.xlsx')
    
    filename0=filename;
    delete(filename0);
    % ==============================================
    %%   export separate SHEETs
    % ===============================================
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
    
    timex=datestr(now);
    
    
    
    
    %% for each PW   ============================================
    for i=1:pws
        if pws==1
            filename=filename0;
        else
            filename=stradd(filename0,['_' num2str(i)],2)
        end
        
        delete(filename);
        
        % ==============================================
        %%   infos
        % ===============================================
        cprintf([1 0 1],['saving comparison-' num2str(i) ',  sheet: ' '"info"' ' ...'  '\n']);
        
        infox={'INFO-DTI STATISTIC'   ['#DateSaved: ' timex]};
        infox(end+1,:)={'COMPARISON:'  us.pw(i).str};
        infox(end+1,:)={''  ''};
        %infox(end+1,:)={'date Saved'  timex};
        
        dv=us.pw(i).tbexportinfo;
        dv=regexprep(dv,{'\s*'},{' '});
        dv=regexprep(dv,{' #wr '},{''});
        sp={};
        for k=1:size(dv,1)
            ico=regexpi(dv{k},':');
            if isempty(ico)
                if length(unique(double(dv{k})))==1
                    sp(k,:)={'' ''};
                else
                    sp(k,:)={ dv{k} ''};
                end
            else
                sp(k,:)= {dv{k}(1:ico(1)) regexprep(dv{k}(ico(1)+1:end),'^\s*','') };
            end
        end
        sp(cellfun(@isempty,sp(:,1)),:)=[];
        
        %date-issue
        idate=regexpi2(sp(:,1),'date');
        sp(idate,2)=cellfun(@(a){['"' a '"']} ,sp(idate,2));
        
        
        
        infolist=[{'PARAMETER:' 'Value'  }; [sp ]   ];
        infox=[infox; infolist ];
        
        %dum= [us.pw(i).tbexportinfo  cell(length( us.pw(i).tbexportinfo),1)];
        %infox=[infox; dum ];
        
        % groups
        infox=[infox; cell(1,2) ];
        infox=[infox; {'GROUPS:' ''} ];
        
        %     dum0=cellfun(@(a,b){[ [a;[repmat('=',[1,10]); b]] ]} , us.pw(i).grouplabel, us.pw(i).groupmembers );
        dum0=cellfun(@(a,b){[ [a;[repmat('_',[1,10]); b]] ]} , ...
            cellfun(@(a){['GroupName: "' a '"']} ,us.pw(i).grouplabel),...
            us.pw(i).groupmembers );
        dum=cell(max(length(dum0{1}),length(dum0{2})),2);
        dum(1:length(dum0{1}) , 1)  =dum0{1};
        dum(1:length(dum0{2}) , 2)  =dum0{2};
        infox=[infox; dum ];
        
        %     disp(infox);
        
        
        % ==============================================
        %%  save INFO
        % ===============================================
        
        %     xlswrite(filename,infox, 'info' );
        %     xlsAutoFitCol(filename,'info','A:F');
        %     xlscolorizeCells(filename,'info' , [1,1], [1 0 0  ]);
        
        sheetname='info';
        
        if ispc==1
            pwrite2excel(filename,{1 sheetname   },infox(1,:),[],infox(2:end,:));
            
            % COLORIZE
            cols=[...
                1.0000    0.8431         0  %comparison
                0.8549    0.7020    1.0000  %Paramter
                0.8549    0.7020    1.0000  %value
                1 0 0                       %groups
                ];
            icompar =regexpi2(infox(:,1),'COMPARISON:');
            iparam  =regexpi2(infox(:,1),'PARAMETER:');
            igroups =find(strcmp(infox(:,1),'GROUPS:'));
            colorcells=[ icompar 2; iparam 1; iparam 2; igroups 1];
            xlscolorizeCells(filename,sheetname , colorcells, cols);
        else
            d2=infox(2:end,:);
            h2=infox(1,:);
            
            h2new=regexprep(h2,{'(' ,  ')' , ' ' '-' ,'#',':'},{ '_' ,'','','_','','_'});
            T=cell2table(d2,'VariableNames',h2new);
            writetable(T,filename,'Sheet',sheetname );
            
        end
        % ==============================================
        %%   sheets
        % ===============================================
        dat      = us.pw(i).tbexport;
        if isfield(us.pw(i),'networkmetricsExport');
            dat=[dat;us.pw(i).networkmetricsExport];
        end
        for j=1:size(dat,1)
            sheetname=dat{j};
            try
                sheetname= regexprep(sheetname,'.*#','');
            end
            hd=dat{j,2}(1,:);
            try
                d =dat{j,2}(2:end,:);
            catch %n.s.
                d=repmat({''},[ 1 length(hd)]);
            end
            
            cprintf([1 0 1],['saving comparison-' num2str(i) ',  sheet: "' sheetname '" ...'  '\n']);
            if ispc==1
                pwrite2excel(filename,{j+1 sheetname   },hd,[],d);
            else
                d2=d;
                h2=hd;
                
                h2new=regexprep(h2,{'(' ,  ')' , ' ' '-' ,'#',':'},{ '_' ,'','','_','','_'});
                T=cell2table(d2,'VariableNames',h2new);
                writetable(T,filename,'Sheet',sheetname );
            end
        end
        cprintf([1 0 1],['done.\n' ]);
        % fprintf(' [Done]\n ');
        showinfo2('Excelfile',filename);
    end % pws
    
elseif exportType==2 || exportType==3 %[2] SINLGE EXCELsheet %[3] SINLGE TXT-file
    
    if exportType==3 %as TXT-file
        filename= fullfile(pax,[name,'.txt']);
    end
    
    %=========================================================================
    try
        delete(filename);
    end
    if exist(filename)==2 && exportType==2
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
    
    if exportType==2
        if ispc==1
            xlswrite(filename,infox, 'info' );
            xlsAutoFitCol(filename,'info','A:F');
            xlscolorizeCells(filename,'info' , [1,1], [1 0 0  ]);
        else
            d2=infox(2:end,:);
            h2=infox(1,:);
            
            h2new=regexprep(h2,{'(' ,  ')' , ' ' '-' ,'#',':'},{ '_' ,'','','_','','_'});
            T=cell2table(d2,'VariableNames',h2new);
            writetable(T,filename,'Sheet','info' );
        end
    elseif exportType==3 %TXT
        % infox
        
    end
    
    
    %% for each PW   ============================================
    txcell={}; %TXT-cell for exportType=3 (TXT-file)
    
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
        
        if exportType==2
            if ispc==1
                %% write data
                xlswrite(filename,d2, sheetname );
                %  xlsAutoFitCol(filename,sheetname,'A:Z');
                %% colorize cells
                cellcol=lut(cellcolidx,:);
                xlscolorizeCells(filename,sheetname, cellcolpos, cellcol);
            else
                %D2=d2(2:end,:);
                %H2=d2(1,:);
                D2=d2;
                
                %H2new=regexprep(H2,{'(' ,  ')' , ' ' '-' ,'#',':'},{ '_' ,'','','_','','_'});
                %%T=cell2table(D2,'VariableNames',H2new);
                T=cell2table(D2);
                writetable(T,filename,'Sheet',sheetname );
                
            end
        elseif exportType==3 %TXT-file
            hed=repmat({'',},[1 size(d2,2) ]); %header
            hed{1}=sheetname;
            txcell{s,1}=infox;
            txcell{s,2}=hed;
            txcell{s,3}=d2;
        end
        
        
    end
    
    if exportType~=3
        cprintf([0 .5 0],['Done.\n' ]);
        % fprintf(' [Done]\n ');
        %disp([' open xlsfile: <a href="matlab: system(''' filename ''')">' filename '</a>']);
        showinfo2('Excelfile',filename);
    end
end %EXPORTTYPE

%% ====== TXTfile =========================================

if exportType==3
    cprintf([0 .5 0],['...'  '\n' ]);
    for j=1:pws
        tx={};
        tx= plog(tx,[txcell{j,1}],0,['comparsison: ' txcell{j,2}{1}],'d=1;al=1','');
        tx=[tx; {repmat('_',[1 size(tx{1},2)]) }];
        tx=[tx; cellstr(repmat(' ',[2 size(tx{1},2)]))];
        %uhelp(tx,1)
        
        tx2= plog([],[txcell{j,3}],0,[],'d=6;s=0;al=1','');
        tx=[tx;tx2];
        
        suffix=[ '_'  regexprep(txcell{j,2}{1},{'\s+'},{''}) ];
        filename2=stradd(filename, suffix ,2);
        
        pwrite2file(filename2,tx );
        showinfo2('TXTfile',filename2);
        cprintf([0 .5 0],['Done.\n' ]);
    end
    
    
    %         uhelp(plog([],[txcell{1,1}],0,'SELECTION TABLE','d=1;al=1',''),1);
    
    
    
    
end


%% ===============================================





% ==============================================
%%
% ===============================================



function loadroifile(e,e2)
loadroi('gui');

function loadroi(par)
if exist('par')==1
    if isfield(par,'loadcoi')
        if sum(strcmp(par.loadcoi,'loadcoi'))==0
            filename=par.loadcoi;
        end
    end
end

hf=findobj(0,'tag','dtistat');  figure(hf);
hb=findobj(hf,'tag','loadroifile');
us=get(hf,'userdata');    %### critical
us.coifile  =[];
us.coilabels=[];


% ==============================================
%%   SET ZERO CON-data
% ===============================================
if isfield(us,'con_backup')==0
    us.con_backup=us.con; %use backup-file
    set(hf,'userdata',us);
end



if exist('filename')~=1;%strcmp(filename,'gui')
    [fi pa]=uigetfile(fullfile(pwd,'*.xlsx'),'load COI-file (excel-format) or "CANCEL" to use original data');
    
    if isnumeric(fi);
        disp(' no COI-file selected - remove COI dependency');
        try; us.coifile  =[];   end
        try; us.coilabels=[];   end
        try; us.con=us.con_backup ;end
        set(hf,'userdata',us);
        return;
    end
    filename  =fullfile(pa,fi);
end
if strcmp(filename,'none')
    disp(' no COI-file selected - remove COI dependency');
    try; us.coifile  =[];   end
    try; us.coilabels=[];   end
    try; us.con=us.con_backup ;end
    set(hf,'userdata',us);
    return;
else
    cprintf([0   .5 0],['... reading COI-file ..wait..\n' ]);
    [~,~,x]=xlsread(filename);
end

%depending on old or new coi-file
icoi=find(strcmp(x(1,:),'COI'));
if icoi==2 %old COI-file
    coi=x(2:end,1:2); % label/connection x indicators
    coi=cellfun(@(a){[ num2str(a)  ]} , coi  );
    
    coi(regexpi2(coi(:,1),'NaN'),:) =[];
    coi(regexpi2(coi(:,2),'NaN'),:) =[];
    coi(:,2)=cellfun(@(a){[ 1  ]} , coi(:,2)  );  %everything-somehow tagged in cui-column becomes numeric-"1"
elseif icoi==3 %new COI-file : separated regions of connections in coi-file
    coi=x(2:end,[1 2 icoi]);
    coi=cellfun(@(a){[ num2str(a)  ]} , coi  );
    coi(regexpi2(coi(:,1),'NaN'),:) =[];
    coi(regexpi2(coi(:,2),'NaN'),:) =[];
    coi(regexpi2(coi(:,3),'NaN'),:) =[];
    conlabels=cellfun(@(a,b){[a '--' b]}, coi(:,1),coi(:,2));
    coi=[conlabels coi(:,3)];
    coi(:,2)=cellfun(@(a){[ 1  ]} , coi(:,2)  ); %everything-somehow tagged in cui-column becomes numeric-"1"
else
    error('no "COI"-label found in header of COI-file');
end

cprintf([0   .5 0],[' [' num2str(size(coi,1)) ' COIs found]' '\n' ]);


% ==============================================
%%   SET ZERO CON-data
% ===============================================
if isfield(us,'con_backup')==0
    us.con_backup=us.con; %use backup-file
end

us.coifile=filename;

c=us.con_backup;

iuse=zeros(size(coi,1),1);
for i=1:size(coi,1)
    iuse(i,1)=find(strcmp(c.conlabels,coi{i,1}));
end
inouse=setdiff(1:size(c.condata,1),iuse);

c.condata(inouse,:)=0;

inouse_index=c.index(inouse) ; %idx for 2d-data
iuse_index  =c.index(iuse)   ; %idx for 2d-data

si_mat=size(c.mat);
mat =reshape(c.mat,[si_mat(1)*si_mat(2) si_mat(3)]);
mat2=zeros(size(mat));
mat2(iuse_index,:)=mat(iuse_index,:);
mat2=reshape(mat2,[si_mat(1) si_mat(2) si_mat(3)]);


us.con.condata=c.condata;
us.con.mat    =mat2;

set(hf,'userdata',us);
disp('set other connections to zero-value');























% ==============================================
%%   old
% ===============================================
function loadroi_old______(par)

if exist('par')==1
    if isfield(par,'loadcoi')
        if sum(strcmp(par.loadcoi,'loadcoi'))==0
            filename=par.loadcoi;
        end
    end
end

hf=findobj(0,'tag','dtistat');  figure(hf);
hb=findobj(hf,'tag','loadroifile');
us=get(hf,'userdata');    %### critical


if exist('filename')~=1;%strcmp(filename,'gui')
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
    cprintf([0   .5 0],['... reading COI-file ..wait..\n' ]);
    [~,~,x]=xlsread(filename);
end

%% depending on old or new coi-file
icoi=find(strcmp(x(1,:),'COI'));
if icoi==2 %old COI-file
    roi=x(2:end,1:2); % label/connection x indicators
    roi=cellfun(@(a){[ num2str(a)  ]} , roi  );
    
    roi(regexpi2(roi(:,1),'NaN'),:) =[];
    roi(regexpi2(roi(:,2),'NaN'),:) =[];
    roi(:,2)=cellfun(@(a){[ 1  ]} , roi(:,2)  );  %everything-somehow tagged in cui-column becomes numeric-"1"
elseif icoi==3 %new COI-file : separated regions of connections in coi-file
    roi=x(2:end,[1 2 icoi]);
    roi=cellfun(@(a){[ num2str(a)  ]} , roi  );
    roi(regexpi2(roi(:,1),'NaN'),:) =[];
    roi(regexpi2(roi(:,2),'NaN'),:) =[];
    roi(regexpi2(roi(:,3),'NaN'),:) =[];
    conlabels=cellfun(@(a,b){[a '--' b]}, roi(:,1),roi(:,2));
    roi=[conlabels roi(:,3)];
    roi(:,2)=cellfun(@(a){[ 1  ]} , roi(:,2)  ); %everything-somehow tagged in cui-column becomes numeric-"1"
else
    error('no "COI"-label found in header of COI-file');
end

cprintf([0   .5 0],[' [' num2str(size(roi,1)) ' COIs found]' '\n' ]);

us.roilabels=roi;
us.roifile  =filename;
set(hf,'userdata',us);

% ==============================================
%%   old version
% ===============================================

if 0 % calculated already done apply for calculated data
    % line 1760
    %% ROI
    if isfield(us,'roifile')
        if exist(us.roifile)==2
            us=prunebyROIS(us);
            set(hf,'userdata',us);
        end
    end
    
end
cprintf([0   .5 0],['[Done]\n.' ]);

function us=prunebyROIS(us)
%%  find connections of interest
if isfield(us,'pw')==1
    for s=1:length(us.pw)
        px=us.pw(s);
        i_inlab={};
        for i=1:size(us.roilabels,1)
            i_inlab{i,1}=regexpi2(px.lab,['^' us.roilabels{i,1} '$']);
        end
        NmaxAssign=max(cell2mat(cellfun(@(a){[ length(a)  ]} , i_inlab  )));
        %disp([' ['  px.str   ']' repmat('«',[1 50])]);
        cprintf([1 0 1 ], ['---- Apply COI-file on contrast ['  px.str   '] ---- \n']);
        disp(['roifile              : ' us.roifile ]);
        disp(['max doublette nodes  : ' sprintf('%3.2d',NmaxAssign)         ' ; A value >1 is bad (same region-by-region label found more than once!).']);
        disp(['keeping #node pairs  : ' sprintf('%3.2d',length(i_inlab))    ' ; COI-file reduced the number of node-pairs to this value.']);
        
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
else
    cprintf([0 .5 0],['INFO: COI-file not applied yet. Statistics not calculated yet.\n' ]);
end

function redisplay(e,e2)
if isstruct(e)
    showresults(0,e);
else
    showresults(0);
end


function makeROIfile(e,e2)
makeROIfile_run();

function makeROIfile_run(par)


hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');

checklabels=0;
if isfield(us,'con') && isfield(us.con,'conlabels')
    checklabels=1;
end
if checklabels==0
    uiwait(msgbox('some data/label file has to be loaded to make a COI-file', 'ERROR'));
    return
end




if exist('par')==1
    if isfield(par,'makecoi')
        if sum(strcmp(par.makecoi,'makecoi'))==0
            filename=par.makecoi;
        end
    end
end

cprintf([0 .5 0],['creating COI-blanko-file ..wait..' ]);

if exist('filename')~=1
    [file,pa] = uiputfile('*.xlsx','SAVE Connections as blanko (excel file) to create a COI-file!!! specify filename');
    if isnumeric(file)==1;
        cprintf([0 .5 0],['process aborted\n' ]);
        return;
    end
    file= [ strrep(file,'.xlsx','') '.xlsx'];
    filename=fullfile(pa,file);
end
[pax name ext]=fileparts(filename);
if isempty(pax); pax=pwd; end
filename=fullfile(pax,[name '.xlsx']);
% roifile=fullfile(pwd,'_dum.xlsx');




conlab=us.con.conlabels;

% ========== OLD VERSION =================
if 0
    head={'connections' 'COI' 'info'};
    tb=cell(size(conlab,1),3);
    tb(:,1)=conlab;
    tb=[head;tb];
    tb{1,3} = '__INSTRUCTION: '   ;
    tb{2,3} ='set Connection of Interests in column-2 (COI) to [1] ' ;
    tb{3,3} ='do nothing for Connections of no interest!';
    xlswrite(filename,[tb],'COI');
    xlsAutoFitCol(filename,'COI','A:F');
    
    col=[0.7569    0.8667    0.7765
        0.8941    0.9412    0.9020
        0.9922    0.9176    0.7961];
    xlscolorizeCells(filename,'COI', [1 1; 1 2; 1 3], col);
end
% ========== NEW VERSION =================

% tic
% [ca cb]=strtok(conlab,'--');
% toc
% tic
s = regexp(conlab, '--', 'split');
ca = cellfun(@(x)x(:,1), s);
cb = cellfun(@(x)x(:,2), s);
labs = [ca cb];


head={'connectionA' 'connectionB' 'COI' 'INFO'};
tb=cell(size(conlab,1),4);
tb(:,1:2)=labs;

% ==============================================
%%   COItype
% ===============================================
hb=findobj(hf,'tag','ROIfileType');
COItype=get(hb,'value');
%     {'all'              }
%     {'left connections' }
%     {'right connections'}
if COItype==1
    a=tb;
    a(:,3)={1};
    tb=a;
elseif COItype==2
    a=tb;
    idel=regexpi2(a(:,1),'^R_');
    a(idel,:)=[];
    idel=regexpi2(a(:,2),'^R_');
    a(idel,:)=[];
    a(:,3)={1};
    tb=a;
elseif COItype==3
    a=tb;
    idel=regexpi2(a(:,1),'^L_');
    a(idel,:)=[];
    idel=regexpi2(a(:,2),'^L_');
    a(idel,:)=[];
    a(:,3)={1};
    tb=a;
    
end

disp(['COIfile: number of current connection in COIfile: ' num2str(size(tb,1))]);




% ==============================================
%%
% ===============================================

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

xlswrite(filename,[tb],'COI');
xlsAutoFitCol(filename,'COI','A:F');

col=[...
    0.7569    0.8667    0.7765
    0.7569    0.8667    0.7765
    0.8941    0.9412    0.9020
    0.9922    0.9176    0.7961];
xlscolorizeCells(filename,'COI', [1 1; 1 2; 1 3; 1 4], col);

% ==========  =================

cprintf([0 .5 0],['Done.\n' ]);
disp(['COIfile blanko: <a href="matlab: system('''  [filename] ''');">' [filename] '</a>']);



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


function [out]=calcConnMetrics(dx)

%--------- vectorial metric ---------------------------
p.v_effic   = efficiency_wei(dx,1);
p.v_clust   = clustering_coef_wu(dx);
p.v_degre   = degrees_und(dx)';
%---------scalar metric ---------------------------
p.s_assort =assortativity_wei(dx,0)  ;
p.s_transi =transitivity_wu(dx);
p.s_effici =efficiency_wei(dx,0) ;

[~, p.s_modul]=modularity_und(dx);

%---------mean of vectorial metrics--------------------------
p.s_effic_mean= mean(p.v_effic);
p.s_clust_mean= mean(p.v_clust);
p.s_degre_mean= mean(p.v_degre);

% ==============================================
%%   output
% ===============================================
clear out;
out.sc_info='scalar metrics'     ;% SCALARS metrics-----------------------------------
out.sc     =[...
    p.s_assort
    p.s_transi
    p.s_effici
    p.s_modul
    ...
    p.s_effic_mean
    p.s_clust_mean
    p.s_degre_mean
    ]'; %scalar
out.sclabel={...
    'assortativity_wei(dx,0)'
    'transitivity_wu(dx)'
    'efficiency_wei(dx,0)'
    'modularity_und(dx),Q'
    ...
    'efficiency_wei(dx,1),MEAN'
    'clustering_coef_wu(dx),MEAN'
    'degrees_und(dx),MEAN'
    }';

out.vec_info ='vector metrics'     ;% vector metrics -----------------------------------
out.vec      =[    p.v_effic                   p.v_clust               p.v_degre];
out.veclabel ={'efficiency_wei(dx,1)'  'clustering_coef_wu(dx)' 'degrees_und(dx)'};

% ==============================================
%%   old
% ===============================================
if 0
    vec   = ([efficiency_wei(dx,1)  modularity_und(dx) clustering_coef_wu(dx) degrees_und(dx)' ]);
    vecm  = mean(vec);
    sc    = [ assortativity_wei(dx,0)        transitivity_wu(dx)     efficiency_wei(dx,0)   vecm];
    out.sc =sc;
    out.vec=vec;
    
    vecml     ={'efficiency_wei(dx,1)'  'modularity_und(dx)' 'clustering_coef_wu(dx)' 'degrees_und(dx)'};
    paramlabel=['assortativity_wei(dx,0)'      'transitivity_wu(dx)'   'efficiency_wei(dx,0)'  vecml]';
end


function export4xvol3d_btn(e,e2)
export4xvol3d()





function export4xvol3d(x)
% ##HELP_export4dvol3d_on
%HELP
% #wb function to export connection and connection strength that can be used to visualize via xvol3d
% #wb PARAMETER
% 'ano'  : Select the corresponding Atlas (a Nifti-file) here. Mandatory to read the region locations.
%          Example: path of "ANO.nii".
% 'hemi' : Select corresponding Hemisphere Mask (a Nifti-file) here. Mandatory to sepearate regions
%          into left and right hemishere. Example path of "AVGThemi.nii"'.
% 'cs'   : Connection strength (cs) or another parameter to export and display via xvol3d.
%          Default: 'diff' -paramter as this is the mean diff value between two groups.
% 'sort': Sort the connection list in Excel-file
%         (0) no sorting
%         (1) sort after CS-value; ..this is sign-sensitive
%         (2)sort after p-value;
% 'outputname' : A string served as outputname. Default 'DTIconnections'.
% 'contrast' : The contrast to save. Chose one from the list or select 'all' to export all contrasts
%              -also possible to use the index/indices such as [1] or [2 3] depending if contrasts exist
% 'keep'       : Decide which connections should be saved (default: 'all'). Choose from list.
%                options:
%                'all'   : save all connections (independent from its significance).
%                'uncor' : save connections with p-value <0.05
%                'FDR'   : save only connections with FDR corrected significances.
%                'manual': select connections manually
% 'underscore': remove/keep underscores in atlas label strings:  {0} remove or {1} keep underscores
%               in exported labels. Default: 0.
% 'LRtag      : remove/keep left/right hemispheric tag in atlas label strings:  {0} remove or {1} keep
%               left/right hemispheric tag
%
%
% ##HELP_export4dvol3d_off

cprintf([.7 .7 .7],['The exported excelfiles can be used for xvol3d (nodes&links)  .\n' ]);
cprintf([1 0 1],['Export data to excelfile...please wait\n' ]);


he=preadfile(which('dtistat.m'));
he=he.all;
hix=[regexpi2(he,'##HELP_export4dvol3d_on')+1 regexpi2(he,'##HELP_export4dvol3d_off')-1];
hlp_export3dvol=he(hix(1):hix(2));
hlp_export3dvol=regexprep(hlp_export3dvol,'^%','');%remove comment

us=get(findobj(0,'tag','dtistat'),'userdata');
try
    hd=us.pw(1).tbhead;
catch
    cprintf([1 0 1],['DTI connectivities has to be loaded & calculated first ... process aborted\n' ]);
    return
end
cslist={'diff' 'T' 'p'};
cslist=[cslist setdiff(hd,cslist) ];

contrastlist=['all' {us.pw.str}];

% ==============================================
%%   PARAMETER-gui
% ===============================================
showgui=1;
if exist('x')==1
    % USED FOR:  dtistat('export4xvol3d',z,'gui',1)
    if isstruct(x) && isfield(x,'gui')
        showgui=x.gui;
    end
    x=x.export4xvol3d;
    
else
    if isfield(us,'export4xvol3d')% load pre-assigned parameters
        x=us.export4xvol3d;
    end
end


if exist('x')~=1;        x=[]; end
p={...
    'inf1'              '___ EXPORT RESULTS FOR  vISUALIZATION ("xvol3d.m") ___           '                         '' ''
    'ano'     ''        'select corresponding DTI-Atlas (NIFTI-file); such as "ANO_DTI.nii"'  {'f'}
    'hemi'    ''        'select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"'  {'f'}
    'cs'     cslist{1}  'connection strength (cs) or other parameter to export/display via xvol3d'  cslist
    'sort'     0        'sort connection list: (0)no sorting ; (1)sort after CS-value; (2)sort after p-value;'  {0,1,2}
    
    
    'inf2'             '##'   '' ''
    'outDir'           ''                 'output folder' {'d'}
    'filePrefix'        'exp'         'output filename prefix (string)'   {'exp' 'export','DTIconnections'  'DTIoutput' 'DTI4xvol3d'}
    'fileNameConst'     '$filePrefix_$contrast_$keep'     'resulting fileName is constructed by...' {'$filePrefix_$contrast_$keep'  '$filePrefix_$cs_$contrast_$keep' '$contrast_$keep'   }
    'contrast'      contrastlist{2}      'constrast to save (see list (string) or numeric index/indices)' contrastlist
    'keep'       'all'    'connections to keep in file {''all'' ''FDR'' ''uncor'' ''manual selection'' ''p<0.001'' ''p<0.0001''}'  {'all' 'FDR' 'uncor' 'manual' 'p<0.001' 'p<0.0001'}
    
    'underscore'  0   '{0,1} underscores in atlas labels:  {0} remove or {1} keep '                  'b'
    'LRtag'       1   '{0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep '   'b'
    };
p=paramadd(p,x);

% if isfield(x,'gui')==0 || x.gui==1
%     showgui=1;
% else
%     showgui=0;
% end
% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .3 ],...
        'title',['export for xvol3d.m'],'info',{@uhelp,hlp_export3dvol});
    try
        fn=fieldnames(z);
    catch
        return
    end
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

%% =========[batch]======================================
% we want run this: dtistat('export4xvol3d',z,'gui',1)
xmakebatch(z,p, '', 'dtistat(''export4xvol3d'',z,''gui'',1);' );
%% ===============================================

us.export4xvol3d=z;
set(findobj(0,'tag','dtistat'),'userdata',us);




% disp(z);
% return
% ==============================================
%%   export for xvol3d
% ===============================================
us=get(findobj(0,'tag','dtistat'),'userdata');

% ---change numeric contrast-name to readable contrastname
if isnumeric(z.contrast)
    z.contrast=us.pw(z.contrast).str;
end

%---ATLAS
[pa fi ext]=fileparts(z.ano);
if strcmp(ext,'.xlsx')
    z.ano=fullfile(pa , [ fi  '.nii']); %replace with NIfti-format
end


fAno=char(z.ano); %fullfile(pwd,'templates','ANO.nii');
[ha a mm]=rgetnii(fAno);
fAnoxls=strrep(fAno,'.nii','.xlsx');
[~,~,b]=xlsread(fAnoxls);
del=find(strcmp(cellfun(@(a){[num2str(a)]}, b(:,1)),'NaN'));
b(del,:)=[];
b(:,1)=strrep(b(:,1),'''',''); %remove apostrophe
hb      =b(1,:);
b       =b(2:end,:);
%---HEMI
fhemi=z.hemi; %fullfile(fileparts(fAno),'AVGThemi.nii');
[hm m]=rgetnii(fhemi);
m=round(m); %force 0,1 or 2;

%---CONTRAST TO SAVE
npw=length(us.pw);
contrastlist=[ {us.pw.str}];
if isnumeric(z.contrast)
    num=(z.contrast(:)');
else
    num=find(strcmp(contrastlist,z.contrast));
end
if isempty(num)
    if strcmp(z.contrast,'all')
        num=1:npw;
    end
end


for i=num% pws/contrasts
    
    hd=us.pw(i).tbhead;
    d =us.pw(i).tb;
    if isfield(us.pw(i),'fdr')==1
        hd(1)={'Huncor'};
        hd=['Hfdr' hd];
        d=[us.pw(i).fdr(:) d];
    else %NO FDR calculated--> calculate FDR
        hf    =findobj(0,'tag','dtistat');
        HqFDR =findobj(hf,'tag','qFDR');
        qFDR  =str2num(get(HqFDR,'string'));
        
        [Hfdr]=fdr_bh( d(:,strcmp(hd,'p')) ,qFDR,'pdep','no');
        us.pw(i).fdr=double(Hfdr);
        hd(strcmp(hd,'H'))={'Huncor'};
        hd=['Hfdr' hd];
        d=[us.pw(i).fdr(:) d];
    end
    % -------------------------------------
    % conection-strength or other paramter
    % -------------------------------------
    cs=d(:, (strcmp(hd,  z.cs )));
    hd=['cs' hd];
    d =[cs   d ];
    % uhelp(plog([],[hd;num2cell(d)],0,[ '' ]),1)
    % ---------------------------------
    % labels
    % ---------------------------------
    lab=us.pw(i).lab;
    %[Lab1 Lab2] =strtok(lab,'--'); ERRORprone
    
    w1=regexp(lab, '--','split');
    Lab1=cellfun(@(a) a(1) ,w1);
    Lab2=cellfun(@(a) a(2) ,w1);
    
    labm=[Lab1 Lab2];
    % ---------------------------------
    % 'keep' selection
    % ---------------------------------
    isurv=1:size(d,1);
    if strcmp(z.keep,'manual')
        %----- MANUAL SELECTION
        hse  =['Node1' 'Node2'  hd(1:5) ];
        se   =[labm num2cell(d(:,1:5))];
        se   =cellfun(@(a){num2str(a)} ,se);
        titlex='select connections here (use "sort after" option)';
        isurv=selector2(se,hse,'iswait',1,'position',[0.0778  0.0772  0.8  0.8644],'title',titlex);
        d    = d(isurv,:);
        labm = labm(isurv,:);
    elseif strcmp(z.keep(1),'p'   ) && ~isempty(regexpi(z.keep,'<|>')) %p-threshold
        opstr=['res=' strrep(z.keep,'p','pvalue') ';'];
        pvalue=d(:,find(strcmp(hd,'p')));
        eval(opstr);
        isurv=find(res==1);
        
        d    = d(isurv,:);
        labm = labm(isurv,:);
    else
        %---------threshold
        % uncor,Hfdr
        if strcmp(z.keep,'FDR')  % {'all' 'FDR' 'uncor'}
            isurv=find(d(:,find(strcmp(hd,'Hfdr'))));
        elseif strcmp(z.keep,'uncor')
            isurv=find(d(:,find(strcmp(hd,'Huncor'))));
        end
        d    = d(isurv,:);
        labm = labm(isurv,:);
        
    end
    
    % ==============================================
    %%   msgbox if empty
    % ===============================================
    if isempty(d)
        outtag=export3dvol_getOutname(z);
        outname=['_logfile_' outtag '__noSurvivers.s.txt'];
        
        msg={};
        msg{end+1,1}=([  ' for "' z.contrast  '": no results survived..no excel-file written' ]);
        msg{end+1,1}=([  '-logfile written to : ' z.outDir    ]);
        msg{end+1,1}=([  '-logfile: ' outname   ]);
        msg{end+1,1}=([  '-date  : ' timestr(now)]);
        msg{end+1,1}=([  '______________________ ']);
        if showgui==1
            %msgbox(msg);
            
            fg; set(gcf,'units','norm');
            msg2=[{[' <b><font color=blue>"' z.contrast '" ...no surviving results </b>']};
                msg];
            addNote([],'text',msg2',...
                'state',2,'pos',[0 .08 1 .92],'figpos',[0.3799    0.3844    0.4000    0.2500],...
                'IS',1,'dlg',1);
        else
            
            cprintf([0.8706    0.4902         0],[ 'WARNING: for "' z.contrast  '" no results survived..no excel-file written\n'])
            disp(char(msg));
        end
        
        msg2=[msg; {''; '_input-parameter_'}; struct2list2(z,'z')];
        
        pa=z.outDir;
        if isempty(pa); pa=pwd; end
        mkdir(pa);
        pwrite2file(fullfile(pa,outname ), msg2  );
        
        
        return
    end
    
    % ==============================================
    %% get coordinates
    % ===============================================
    a2=a(:); m2=m(:);
    aL=a2.*(m2==1); %LEftt
    aR=a2.*(m2==2); %RIGHT
    
    cords={};
    for j1=1:size(labm,1)
        for j2=1:size(labm,2)
            labthis=labm{j1,j2};
            
            %hemispheric code
            ishemis=[~isempty(regexpi(labthis,'^L_'))  ~isempty(regexpi(labthis,'^R_'))          ];
            labthis2=labthis;
            hem=0;
            if sum(ishemis)
                labthis2=regexprep(labthis,{'^L_' '^R_'},'');
                hem=find(ishemis);
            end
            
            %find  %...problem with PARENTESIS
            %%%il=regexpi2(b(:,1),['^' labthis2 '$|^' strrep(labthis2,'_',' ')  '$' ]);
            
            il=find(strcmp(b(:,1), labthis2) | strcmp(b(:,1), strrep(labthis2,'_',' ')   ));
            
            if isempty(il)
                %%% il=regexpi2(b(:,1),['^' labthis '$|^' strrep(labthis,'_',' ')  '$' ]);
                il=find(strcmp(b(:,1), labthis) | strcmp(b(:,1), strrep(labthis,'_',' ')   ));
                
                if isempty(il)
                    disp('PROBLEM:LABEL NOT FOUND')
                    keyboard
                end
            end
            ID=cell2mat(b(il,4));
            if isnumeric(b{il,5})
                CH=cell2mat(b(il,5));
            else
                CH=str2num(cell2mat(b(il,5)));
            end
            idall=[ID; CH(:)];
            idall(isnan(idall))=[];
            
            %get voxel
            if hem==0
                r=find(ismember(a2,idall));
            else
                if hem==1
                    r=find(ismember(aL,idall));
                else
                    r=find(ismember(aR,idall));
                end
            end
            co=mean(mm(:,r),2)';
            cords{j1,j2}=regexprep(num2str(co),'\s+' ,' ');
        end
    end
    
    % ---------------------------------
    % keep/remove 'LRtag
    % ---------------------------------
    if z.LRtag==0
        labm=regexprep(labm,'^L_|^R_',''); %remove L_/R_ left/right tage
    end
    % ---------------------------------
    % keep/remove inderscore
    % ---------------------------------
    if z.underscore==0
        labm=strrep(labm,'_',' '); %remove underScore
    end
    
    
    
    
    % ==============================================
    %% write2excel
    % ===============================================
    % ---------------------------------
    % data to save
    % ---------------------------------
    h2=['Label1' 'Label2'  'co1' 'co2'    hd        ];
    d2=[labm                  cords      num2cell(d)];
    
    % ---------------------------------
    % sort after cs value
    % ---------------------------------
    
    if z.sort==1  %ascending;
        icolSort=find(strcmp(h2,'cs'));
        d2=sortrows(d2,icolSort);
    elseif z.sort==2 %descending
        icolSort=find(strcmp(h2,'p'));
        d2= (sortrows(d2,icolSort));
    end
    
    
    
    
    % ---------------------------------
    %% output name
    % ---------------------------------
    %pa=fileparts(us.groupfile);
    pa=z.outDir;
    mkdir(pa);
    if isempty(pa)
        pa=pwd;
    end
    
    if 0
        outtag=us.pw(i).str;
        outtag=regexprep(outtag,'<|>','_vs_');
        %     regexprep('AYdede.:-_d012_=3499./()',{'[^a-zA-Z0-9_]'},{''});
        outtag=regexprep(outtag,{'[^a-zA-Z0-9_]'},{''});
    end
    %% ===========[filename]====================================
    
    outtag=export3dvol_getOutname(z);
    if 0
        cons=z.fileNameConst;
        if isempty(cons)
            cons='$filePrefix_$cs_$contrast_$keep';
        end
        
        fn=fieldnames(z);
        idx=zeros(length(fn),1);
        for i=1:length(fn)
            i0=regexpi(cons,['\$' fn{i} ]) ;
            if ~isempty(i0);
                idx(i,1)=i0 ;
            end
        end
        ts=sortrows([fn num2cell(idx)],2);
        vars=ts(find(cell2mat(ts(:,2))>0),1);
        
        outtagc='';
        for i=1:length(vars)
            dx=getfield(z,vars{i});
            if isnumeric(dx);  dx=num2str(dx); end
            outtagc{i}=dx;
        end
        outtag =strjoin(outtagc,'_');
        outtag =regexprep(outtag,{' ' ,'<'},{'_',''});
    end
    
    
    %% ===============================================
    fileout=fullfile(pa,[outtag '.xlsx']);
    
    % ---------------------------------
    %% save
    % ---------------------------------
    try; delete(fileout); end
    if exist(fileout)==2
        [pax name ext]=fileparts(fileout);
        msg=['File seems to be open ..no write permission!' char(10) ...
            'FILE: ' [name ext] char(10) ...
            'PATH: ' pax char(10) ...
            'CLOSE file manually..than hit [OK]']
        
        h=(msgbox(msg,'WARNNG'));
        
        set(h,'units','norm')
        hb=uicontrol(h,'style','edit','units','norm');
        set(hb,'position',[0 0 1 1],'string',msg,'max',inf);
        set(hb,'HorizontalAlignment','left','BackgroundColor',[repmat(0.74,[1 3])]);
        uistack(findobj(h,'Style','pushbutton'),'top');
        waitfor(h);
        
        try; delete(fileout); end
        if exist(fileout)==2
            cprintf([1 0 1],['..file still open.. no write permission..process aborted\n' ]);
            return
        end
        
    end
    
    % ==============================================
    %%   exort EXCEL-file
    % ===============================================
    if ispc==1 %PC
        pwrite2excel(fileout,{1 'nodes'},h2,[],d2);
    else %MAC/UNIX
        h2new=regexprep(h2,{'(' ,  ')' , ' ' },{ '_' ,'',''});
        T=cell2table(d2,'VariableNames',h2new);
        writetable(T,fileout,'Sheet','nodes' );
    end
    showinfo2('saved: ',fileout);
    % ==============================================
    %%
    % ===============================================
    
    
    
end% pws/contrasts
cprintf([1 0 1],['Done.\n' ]);

%% ===============================================

function outtag=export3dvol_getOutname(z);
if 1
    cons=z.fileNameConst;
    if isempty(cons)
        cons='$filePrefix_$cs_$contrast_$keep';
    end
    
    fn=fieldnames(z);
    idx=zeros(length(fn),1);
    for i=1:length(fn)
        i0=regexpi(cons,['\$' fn{i} ]) ;
        if ~isempty(i0);
            idx(i,1)=i0 ;
        end
    end
    ts=sortrows([fn num2cell(idx)],2);
    vars=ts(find(cell2mat(ts(:,2))>0),1);
    
    outtagc='';
    for i=1:length(vars)
        dx=getfield(z,vars{i});
        if isnumeric(dx);  dx=num2str(dx); end
        outtagc{i}=dx;
    end
    outtag =strjoin(outtagc,'_');
    outtag =regexprep(outtag,{' ' ,'<'},{'_',''});
end

% ==============================================
%%   batch
% ===============================================

function getbatch(e,e2)
code=generatCode();

function code=generatCode()

code={};
code{end+1,1}=' ';
code{end+1,1}=['% #bo ---  DTIstatistic(dtistat.m) -----'];





hf=findobj(0,'tag','dtistat');
if isempty(hf);
    dtistat;
    hf=findobj(0,'tag','dtistat');
end
us=get(hf,'userdata');




% ==============================================
%%
% ===============================================


% dtistat('confiles',confiles  ,'labelfile',lutfile(1));
%  dtistat('group','group_#assignment.xlsx');
%

% ==============================================
%%   files (groupassignment,files,lut)
% ===============================================
try; grpfile = us.groupfile; catch; grpfile='UNDEFINED'; end
try; lutfile =us.con.lutfile; catch; lutfile='UNDEFINED'; end
try; confiles=us.con.files; catch; confiles={'''UNDEFINED'''}; end

%% ===============================================

ButtonName = questdlg(['confile: mode-1 or mode-2' char(10) ...
    'mode-1: long list of fullpath connectivity files ' char(10) ...
    'mode-2: path +short name of connectivity file ' char(10)  ...
    '...rerunning the batch should produce the same results for mode-1 and mode-2 '], ...
    'Batch mode for connectivity files', ...
    'mode-1', 'mode-2', 'mode-2');

%% ===============================================
%% ===============================================

d={['groupingfile = ''' char(grpfile) '''; % % group-assignment File (Excel-file) ']};
if size(confiles,1)==1
    e=[ 'confiles     = {'  char(confiles) '}; % % connectivity-Files'];
else
    
    [pa fi ext]=fileparts2(confiles);
    if length(unique(fi))==1
        confile=[fi{1} ext{1}];
        
        e=cellfun(@(a){ [ sprintf('\t') '''' a '''' ]} , pa);
        e=[ 'paths          = {...     % % connectivity-folders '  ;e; [sprintf('\t') '};']];
        
        e{end+1,1}=['confileName  = '  '''' confile  ''';               % % connectivity FileName' ];
        e{end+1,1}=...
            [ 'confiles     = stradd(paths,[filesep confileName],2);  % % fullpath-connectivity-Files '];
    else
        e=cellfun(@(a){ [ sprintf('\t') '''' a '''' ]} , confiles);
        e=[ 'confiles     = {...     % % connectivity-Files '  ;e; [sprintf('\t') '};']];
    end
end
f={['lutfile      = ''' char(lutfile) '''; % % LUT-File (txt-file) ']};
if strcmp(ButtonName, 'mode-1')
    code=  [code;  ;d; e; f;{''}];
else
    
    
    %% ===============================================
    %___conFilename
    confile1=confiles{1};
    [pac namec extc]=fileparts(confile1);
    confileName=[namec extc];
    
    if strcmp(confileName, '''UNDEFINED''')
        conpath='UNDEFINED';
        confileName='UNDEFINED';
    else
        
        % ___conpath
        cx1  =((cellfun(@(a){[ (( double(a)) )]} ,confiles)));
        cxmin=min(cell2mat(cellfun(@(a){[ length(a) ]} ,cx1)));
        cx1=cell2mat(cellfun(@(a){[ a(1:cxmin) ]} ,cx1));
        idiff=min(find(sum(abs(cx1-repmat(cx1(1,:),[size(cx1,1) 1])),1)>0));
        ifilesep=strfind(confile1,filesep);
        idiff2=ifilesep(max(find(ifilesep<=idiff)));
        if strcmp(confile1(idiff2),filesep);
            idiff2=idiff2-1 ;
        end
        conpath=confile1(1:idiff2);
    end
    
    e2={' '};
    e2{end+1,1}=['conpath      = ' '''' conpath      '''; % % upper path containing connectivity files (csv)' ];
    e2{end+1,1}=['confiles     = ' '''' confileName  '''; % % short-name of the connectivity file (csv)' ];
    %%%e2{end+1,1}=['labelfile=' '''' lutfile      '''; % % atlas-label file (txt-file)' ];
    
    
    %     e2={....
    %         ['dtistat(''conpath''  ,''' conpath  ''' ,... ' ]
    %         ['        ''confiles'' ,''' confileName  ''',...']
    %         ['        ''labelfile'','''  lutfile ''');' ]
    %         };
    %     %code=  [code;  ;d; e2; f;{''}];
    code=  [code;  ;d; e2; f;{''}];
    
    % % % dtistat('confiles', confiles,'conpath',conpath  ,'labelfile',lutfile)
end


%% ===============================================


arg={};
h=findobj(hf,'tag','inputsource');
arg{1,1}='inputsource';
arg{1,2}=h.String{h.Value};
code{end+1,1}=makecode(arg);



code{end+1,1}=['dtistat(''group'', groupingfile);                        % % LOAD groupAssignment (ExcelFile)'];
if strcmp(ButtonName, 'mode-1')
    code{end+1,1}=['dtistat(''confiles'', confiles  ,''labelfile'',lutfile); % % LOAD connectivity-Files & LUTfile'];
else
    code{end+1,1}=['dtistat(''conpath'', conpath ,''confiles'', confiles  ,''labelfile'',lutfile); % % LOAD connectivity-Files & LUTfile'];
    
end
% ==============================================
%%   other paramter
% ===============================================


% -----------tests/tail etc----------------------------
arg={};
h=findobj(hf,'tag','F1design');
arg{1,1}='within';
arg{1,2}=(h.Value);

h=findobj(hf,'tag','typeoftest1');
arg{2,1}='test';
arg{2,2}=h.String{h.Value};

h=findobj(hf,'tag','tail');
arg{3,1}='tail';
arg{3,2}=h.String{h.Value};
code{end+1,1}=makecode(arg);
% -----------FDR /sort results etc----------------------------
arg={};
h=findobj(hf,'tag','isfdr');
arg{1,1}='FDR';
arg{1,2}=(h.Value);

h=findobj(hf,'tag','qFDR');
arg{2,1}='qFDR';
arg{2,2}=str2num(h.String);

h=findobj(hf,'tag','showsigsonly');
arg{3,1}='showsigsonly';
arg{3,2}=(h.Value);

h=findobj(hf,'tag','issort');
arg{4,1}='sort';
arg{4,2}=(h.Value);

h=findobj(hf,'tag','reversecontrast');
arg{5,1}='rc';
arg{5,2}=(h.Value);
code{end+1,1}=makecode(arg);

%% -----------Threshold/noSeeds etc----------------------------
arg={};
h=findobj(hf,'tag','noSeeds');
arg{1,1}='nseeds';
arg{1,2}=str2num(h.String);

h=findobj(hf,'tag','isproportthreshold');
arg{2,1}='propthresh';
arg{2,2}=(h.Value);

h=findobj(hf,'tag','threshold');
arg{3,1}='thresh';
arg{3,2}=(h.String);

h=findobj(hf,'tag','logarithmize');
arg{4,1}='log';
arg{4,2}=(h.Value);

code{end+1,1}=makecode(arg);

% ==============================================
%%   calculate
% ===============================================
code{end+1,1}=' ';
% code{end+1,1}='% ---calculate';
code{end+1,1}='% dtistat(''calcconnectivity''); % % CALCULATION (uncomment line to execute) ';
% code{end+1,1}='% ---showResults';
code{end+1,1}='% dtistat(''showresult'');       % % SHOW RESULT (uncomment line to execute) ';
code{end+1,1}='% dtistat(''savecalc'',''calc_test1.mat'');  % %save calculation';
code{end+1,1}='% dtistat(''export'',''test1.xlsx'',''exportType'',1);  % %save Result as ExelFile';


uhelp(code,1,'name','batch');

function code=makecode(arg);
lin='';
for i=1:size(arg,1)
    lin=[lin '''' arg{i,1} '''' ',' ];
    if ischar(arg{i,2})
        lin=[lin '''' num2str(arg{i,2}) ''''  ];
    else
        lin=[lin  num2str(arg{i,2})    ];
    end
    if i<size(arg,1)
        lin=[lin ','];
    end
end
code=['dtistat(''set'',' lin ' );'];


function scripts_show(e,e2)

figtitle='scripts: DTIstat';
close(findobj(0,'name',figtitle));

scripts={
    'STcript_b1_makeSubgroups.m'
    'STcript_b2_DTIstat.m'
    'STscript_subdivideGroups_pairwiseComparisons.m'
    'STscript_subdivideGroups_specific.m'
    'STscript_DTIstatistic_simple.m'
    'STscript_DTIstatistic_simple2.m'
    'STscript_DTIstatistic_diffDTImatrices.m'
    'STscript_DTIstatistic_diffDTImatrices_diffGroups.m'
    'STscript_export4vol3d_simple.m'
    'STscript_export4vol3d_manycalcs.m'
    'DTIscript_plotsummary.m'
    'DTIscript_plotsummary_severalCALCS.m'
    'DTIscript_reduceMatric_viaCOIfile.m'
    'DTIscript_DTIstatisticComplete1.m'
    % 'DTIscript_HPC_exportData_makeBatch.m'
    % 'DTIscript_posthoc_makeHTML_QA.m'
    % 'DTIscript_posthoc_exportData4Statistic.m'
    };


scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name',figtitle,'closefig',1,'scripts',scripts);
% scripts_gui(gcf, 'pos',[0 0 1 1],'name','scripts: voxelwise statistic','closefig',1,'scripts',scripts)


% ==============================================
%%   older
% ===============================================
return

%
% scripts_process([],[],'close');
%
% h=uipanel('units','norm');
% xpos=0.4;
%  set(h,'position',[xpos 0  1-xpos 1 ],'title','scripts','tag','scripts_panel');
% %set(h,'position',[xpos 0.1  1-xpos-.1 .5 ],'title','scripts','tag','scripts_panel');
%
% set(h,'ForegroundColor','b','fontweight','bold');
%
% % ###########################################################################################
% % ==============================================
% %%   script-names
% % ===============================================
%
% scripts={
% 'STscript_subdivideGroups_pairwiseComparisons.m'
% 'STscript_subdivideGroups_specific.m'
% 'STscript_DTIstatistic_simple.m'
% 'STscript_DTIstatistic_simple2.m'
% 'STscript_DTIstatistic_diffDTImatrices.m'
% 'STscript_DTIstatistic_diffDTImatrices_diffGroups.m'
% 'STscript_export4vol3d_simple.m'
% 'STscript_export4vol3d_manycalcs.m'
% % 'DTIscript_HPC_exportData_makeBatch.m'
% % 'DTIscript_posthoc_makeHTML_QA.m'
% % 'DTIscript_posthoc_exportData4Statistic.m'
% };
% % ###########################################################################################
%
% %% ========[controls]=======================================
%
% hb=uicontrol(h,'style','listbox','units','norm','tag','scripts_lbscriptName');
% set(hb,'string',scripts);
% set(hb,'position',[0 0.7 1.2 0.3]);
%
% set(hb,'callback',{@scripts_process, 'scriptname'} );
% set(hb,'tooltipstring',['script/function name']);
%
%
% c = uicontextmenu;
% hb.UIContextMenu = c;
% m1 = uimenu(c,'Label','show script','Callback',{@scripts_process, 'open'});
% m1 = uimenu(c,'Label','<html><font style="color: rgb(255,0,0)">edit file (not prefered)','Callback',{@scripts_process, 'editOrigFile'});
%
% %% ====[addNote]===========================================
% % hb=uicontrol(h,'style','text','units','norm','tag','scripts_TXTscriptHelp');
% % set(hb,'string',{'eeee'},'backgroundcolor','w');
% % set(hb,'position',[[0 0.1 1.01 0.45]]);
% % % set(hb,'callback',{@scripts_process, 'close'} );
% % set(hb,'tooltipstring',['script/function help']);
% NotePos=[xpos .085  1-xpos .58];
% NotePos=[ 0 .085  1 .62];
% msg='select <b>script/function</b> from <u>above</u> to obtain <font color="blue">help.<br>';
% han=addNote(h,'text',msg,'pos',NotePos,'head','scripts/functions','mode','single','fs',20,'IS',1);
%
% %% =======[open script]========================================
% hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_open');
% set(hb,'string','show script');
% set(hb,'position',[-1.21e-16 0.0056 0.25 0.06]);
% set(hb,'callback',{@scripts_process, 'open'} );
% set(hb,'tooltipstring',['<html><b>open scripts/function in HELP window</b><br> '...
%     'the script can be copied and modified']);
% %% =======[edit script]========================================
% hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_edit');
% set(hb,'string','edit script');
% set(hb,'position',[[0.3     0.0056 0.25 0.06]]);
% set(hb,'callback',{@scripts_process, 'edit'} );
% set(hb,'tooltipstring',['<html><b>open scripts/function in EDITOR</b><br> '...
%     'the script can be copied and modified']);
%
% %% =========[close script panel]======================================
% %%
% hb=uicontrol(h,'style','pushbutton','units','norm','tag','scripts_close');
% set(hb,'string','close panel');
% set(hb,'position',[[0.73 0.0056 0.25 0.06]]);
% % set(hb,'position',[[0.94 0.93 0.06 0.07]]);
% set(hb,'callback',{@scripts_process, 'close'} );
% set(hb,'tooltipstring',['close']);
% %% ==============[userdata]=================================
% u.NotePos=NotePos;
% u.han    =han;
% set(h,'userdata',u);
%
%
% addResizebutton(gcf,h,'mode','L','moo',0,'restore',0);
%
%
%
% function scripts_process(e,e2,task)
% hn=findobj(gcf,'tag','scripts_lbscriptName');
% hh=findobj(gcf,'tag','scripts_panel');
% u=get(hh,'userdata');
%
%
% if strcmp(task,'close')
%     delete(findobj(gcf,'tag','scripts_panel'));
%     addNote(gcf,'note','close') ;
%     addResizebutton('remove');
% elseif strcmp(task,'scriptname')
%
%     file=hn.String{hn.Value};
%     hlp=help(file);
%     hlp=strsplit(hlp,char(10));
%     hlp=[hlp repmat('<br>',[1 2])];
%
%
%
%     NotePos=u.NotePos;
%     %NotePos=[0.5 .085  .5 .58];
%
%
%
%     hs=addNote(u.han,'text',hlp);
%     if isempty(hs)
%         addNote(hh,'text',hlp,'pos',NotePos,'mode','single','fs',20,'IS',1);
%     end
%
%
%
% elseif strcmp(task,'open')
%     %% OPEN SCRIPT IN MATLAB-EDITOR
%     file=hn.String{hn.Value};
%
%     cont=preadfile(file);
%     cont=cont.all;
%     uhelp(cont,1,'name',['script: "' file '"']);
%     h=findobj(gcf,'tag','scripts_lbscriptName');
%
%     msg={'-copy script to Matlab editor'
%         '-change parameter accordingly'
%         '-save script somewhere on your path'
%         '-run script'};
%     addNote(gcf,'text',msg,'pos',[0.5 .1  .44 .3],'head','Note','mode','single');
% elseif strcmp(task,'editOrigFile')
%     pw=logindlg('Password','only');
%     pw=num2str(pw);
%     if strcmp(pw,'1')
%         file=hn.String{hn.Value};
%         edit(file);
%     end
% elseif strcmp(task,'edit')
%     file=hn.String{hn.Value};
%
%     %% ===============================================
%     cont=preadfile(file);
%     cont=cont.all;
%
%     str = strjoin(cont,char(10));
%     editorService = com.mathworks.mlservices.MLEditorServices;
%     editorApplication = editorService.getEditorApplication();
%     editorApplication.newEditor(str);
%     %% ===============================================
%
% end


