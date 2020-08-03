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
% [sort Results]          (chckbox)  : if selected, results will be sorted by p-value.
% [reverse contrast]      (chckbox)  : Default group-comparison is A>B, if selected B>A comparison is
%                                      done (changes the sign of the test statistic, usefull for DTI-visulaization)
% [noSeeds]               (edit)     : Number of seeds.  #r For "DTI connectivities" only.
%                                      Connectivity-matrizes (weights) will be normalized by noSeeds
%                                      prior calculation of connectivity metrics.
% #b __________CALCULATION_________________________________________________________________________
% [stat DTI parameter]    (button)   : Calculate statistic for DTI-PARAMETER.
%                                      FILES (DTI-PARAMETER FILES must be loaded before.
%                                      #r For "DTI parameter" only.
% [stat Connectivity]     (button)   : Calculate statistic for DTI-CONNECTIVITY FILES. 
%                                      DTI-CONNECTIVITY FILES must be loaded before.
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
% dtistat('showresult');                           % #g show results
% dtistat('export','_testExport3.xlsx');           % #g export results
% dtistat('export4xvol3d');                        % #g export connection for xvol3d-visualization; with GUI. #g For silent mode
%                                                  % #g  see example below,
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
% % #k For silent mode: set x.gui to [0];
% x=[];
% x.ano        =  'F:\data1\DTI_mratrix\dti_mratrix_simulation2_multiGRP\templates\ANO.nii';	   % #g select Atlas (Nifti); such as "ANO.nii"
% x.hemi       =  'F:\data1\DTI_mratrix\dti_mratrix_simulation2_multiGRP\templates\AVGThemi.nii';  % #g select Hemisphere Mask (Nifti); such as "AVGThemi.nii"
% x.cs         =  'diff';	         % #g connection strength (cs) or other parameter to export/display via xvol3d
% x.outputname =  'DTIconnections';	 % #g output name string
% x.contrast   =  'A > B';	         % #g constrast to save (see list (string) or numeric index/indices)
% x.keep       =  'all';	         % #g connections to keep in file {'all' 'FDR' 'uncor'}
% x.underscore =  [0];               % #g underscores in atlas labels:  {0} remove or {1} keep
% x.LRtag      =  [0];               % #g left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
% x.gui        =  [1];               % #g show paramter GUi;  {1}silent mode (no GUI); {0} show gui
% dtistat('export4xvol3d',x);        % #g export data for xvol3d with GUI with pre-selected parameter
% 
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
            set(hc,'value' ,find(strcmp(li,p.test )) );
        end
    end
  % --FDR----------------------------------------------
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
        % --sort results----------------------------------------------
    if isfield(p,'rc')
        hc=findobj(hf,'tag','reversecontrast');
        set(hc,'value' ,p.rc );
    end
            % --sort results----------------------------------------------
    if isfield(p,'nseeds')
        hc=findobj(hf,'tag','noSeeds');
        set(hc,'string' , num2str(p.nseeds ));
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
 redisplay();
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
us.props=props;


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
    'tooltipstring',...
    ['load excel-file with the group-assignment' char(10)...
    '<font color="black">command: <b><font color="green">group</font>'...
    ]);
% ==============================================
%%   DTI parameter &  DTI connectities
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0 .8 .2 .05],...
    'string','load DTI parameter','tag','loaddata','callback',@loadDTIparameter,...
    'tooltipstring',...
    ['load mouse-specific DTI-parameter files' char(10)...
    'This data deal with parameter such as: FA, ADC, AXIAL/RADIAL DIFFUSIVITY.' char(10)...
    '<font color="black">command: <b><font color="green">paramfiles</font>'...
    ]);

h=uicontrol('style','pushbutton','units','norm','position',[0.2 .8 .2 .05],...
    'string','load DTI connectivities','tag','loaddata','callback',@loadDTIConnectivity,...
    'tooltipstring',...
    ['load mouse-specific DTI-connectivity files' char(10)...
    'This data deal with connections between regions.' char(10)...
    '<font color="black">command: <b><font color="green">confiles</font>'...
    ]);

%----inputsource
source={'DSIstudio','MRtrix'};
h=uicontrol('style','popupmenu','units','norm','position',[.22 .85 .18 .05],...
    'string',source ,'tag','inputsource',...
    'tooltipstring',...
    ['select DTI input source' char(10)...
    'Only for DTI-connectivities (not for DTI-parameter).' char(10) ...
    '<font color="black">command: <b><font color="green">inputsource</font>'...
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


%help
h=uicontrol('style','pushbutton','units','norm','position',[.8 .85 .15 .05],...
    'string','help','tag','help','callback',@xhelp,...
    'tooltipstring',['function help']);


%close resultfiles
h=uicontrol('style','pushbutton','units','norm','position',[.8 .8 .15 .05],...
    'string','close result windows','tag','closeresultwindows','callback',@closeresultwindows,'fontsize',6,...
    'tooltipstring','close open result windows');


%--------between vs within
h=uicontrol('style','checkbox','units','norm','position',[.1 .65 .2 .05],'string','within',...
    'tag','F1design','backgroundcolor','w','callback',@call_f1design,...
    'tooltipstring',['testing type:' char(10) ...
    ' [ ] BETWEEN DESIGN: compare independent groups ' char(10) ...
    ' [x] WITHIN DESIGN:  compare same mice at different time points ' char(10) ...
    '<font color="black">command: <b><font color="green">within</font>'...
    ]);

% ==============================================
%%   type of test
% ===============================================
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
    '    ..not implemented so far'    char(10) ...
    '<font color="black">command: <b><font color="green">test</font>'...
    ]);

% ==============================================
%%    FDR
% ===============================================
% FDR
h=uicontrol('style','checkbox','units','norm','position',[.01 .55 .2 .05],'string','use FDR',...
    'tag','isfdr','backgroundcolor','w','value',us.isfdr,'fontsize',7,...
    'tooltipstring',...
    ['use FDR for treatment of multiple comparisons (MCP)' char(10) ...
    '<font color="black">command: <b><font color="green">FDR</font>'...
    ]);

% showSigs
h=uicontrol('style','checkbox','units','norm','position',[.15 .55 .2 .05],'string','show SIGs only',...
    'tag','showsigsonly','backgroundcolor','w','value',us.showsigsonly,'fontsize',7,...
    'tooltipstring',...
    ['show significant results only' char(10) ...
    '<font color="black">command: <b><font color="green">showsigsonly</font>'...
    ]);

%sort
h=uicontrol('style','checkbox','units','norm','position',[.32 .55 .2 .05],'string','sort Results',...
    'tag','issort','backgroundcolor','w','value',us.issort,'fontsize',7,...
    'tooltipstring',...
    ['sort Results according p-value' char(10) ...
    '<font color="black">command: <b><font color="green">sort</font>'...
    ]);

%reverse contrast
h=uicontrol('style','checkbox','units','norm','position',[.47 .55 .2 .05],'string','reverse contrast',...
    'tag','reversecontrast','backgroundcolor','w','value',us.reversecontrast,'fontsize',7,...
    'tooltipstring',['Reverse Contrast/Groups:' char(10) ...
    '  [ ] A>B, where "A" and "B" are the groups to be compared ' char(10) ...
    '  [x] B>A, .. flip contrast ' char(10) ...
    '<font color="black">command: <b><font color="green">rc</font>'...
    ]);



%% qvalue
h=uicontrol('style','edit','units','norm','position',[.01 .52 .05 .03],'string',num2str(us.qFDR),...
    'tag','qFDR','backgroundcolor','w','value',1,'fontsize',7,...
     'tooltipstring',...
     ['desired false discovery rate. {default: 0.05}' char(10) ...
    '<font color="black">command: <b><font color="green">qFDR</font>'...
    ]);

 
h=uicontrol('style','text','units','norm','position',[.06 .52 .05 .03],'string','qFDR',...
    'backgroundcolor','w');


%% noSeeds
tt=[' number of seeds (noSeeds)' char(10) ...
    ' connectivity-matrizes (weights) will be normalized by noSeeds prior calculation of connectivity metrics' char(10) ...
    '<font color="black">command: <b><font color="green">nseeds</font>'...
    ];
h=uicontrol('style','edit','units','norm','position',[.8 .52 .1 .03],'string',num2str(us.noSeeds),...
    'tag','noSeeds','backgroundcolor','w','value',1,'HorizontalAlignment','left',...
    'tooltipstring',tt,'fontsize',7);

h=uicontrol('style','text','units','norm','string','noSeeds',...
    'backgroundcolor','w','position',[.7 .52 .1 .03],'HorizontalAlignment','right', 'tooltipstring',tt);

% ==============================================
%%   TYPE OF CALCULATION
% ===============================================
h=uicontrol('style','text','units','norm');
set(h,'position',[0.1 .45 .2 .03],'backgroundcolor','w', 'string',' calculate..');


%DTI-PARAMETER
h=uicontrol('style','pushbutton','units','norm','position',[0 .4 .2 .05],...
    'string','stat DTI parameter',...
    'tag','statDTIparameter','backgroundcolor',[0.8941    0.9412    0.9020],'callback',@statDTIparameter,...
    'tooltipstring',...
    ['calculate statistic for DTI parameter' char(10) ...
    '<font color="black">command: <b><font color="green">calcparameter</font>'...
    ]);
%DTI-CONNECTIVITIES
h=uicontrol('style','pushbutton','units','norm','position',[0.2 .4 .2 .05],...
    'string','stat Connectivity',...
    'tag','statconnectivity','backgroundcolor',[0.8941    0.9412    0.9020],'callback',@statconnectivity,...
    'tooltipstring',...
    ['calculate statistic for connectivity data' char(10) ...
    '<font color="black">command: <b><font color="green">calcconnectivity</font>'...
    ]);




% ==============================================
%%   load/save calculation
% ===============================================
% LOADCALC
h=uicontrol('style','pushbutton','units','norm','position',[0.43 .4 .15 .05],...
    'string','load calculation',...
    'tag','calcLoad','backgroundcolor','w','callback',@calcLoad,...
    'tooltipstring',...
    ['load a calculation' char(10) '..useful for timeconsuming calculations' char(10) ...
    '<font color="black">command: <b><font color="green">loadcalc</font>'...
    ]);

%SAVECALC
h=uicontrol('style','pushbutton','units','norm','position',[0.58 .4 .15 .05],...
    'string','save calculation',...
    'tag','calcSave','backgroundcolor','w','callback',@calcSave,...
    'tooltipstring',...
    ['save a calculation' char(10) '..useful for timeconsuming calculations' char(10) ...
    '<font color="black">command: <b><font color="green">savecalc</font>'...
    ]);
% ==============================================
%%   Show results
% ===============================================

h=uicontrol('style','pushbutton','units','norm','string','show Results',...
    'tag','redisplay','backgroundcolor','w','callback',@redisplay,'fontweight','bold');
set(h,'position',[0.13 .35 .14 .05],'backgroundcolor','w');
set(h,'tooltipstring',...
    ['Show tabled results' char(10) ...
    '<font color="black">command: <b><font color="green">show</font>'...
    ]);
% ==============================================
%%   plot results
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .3 .14 .05],...
    'string','plot Results',...
    'tag','plotdata','backgroundcolor','w','callback',@show,...
    'tooltipstring','visualize results: for type of visulization see right pulldown menu');

h=uicontrol('style','popupmenu','units','norm','position',[0.27 .3 .15 .05],...
    'string',{'matrix' 'plot3d'},'tag','menuplot','backgroundcolor','w',...
    'tooltipstring','type of visualization to show');
% ==============================================
%%   export
% ===============================================

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .25 .14 .05],...
    'string','export Results',...
    'tag','export','backgroundcolor','w','callback',@export,...
    'tooltipstring',...
    ['export results (excelfile)' char(10) ...
    '<font color="black">command: <b><font color="green">export</font>'...
    ]);

h=uicontrol('style','pushbutton','units','norm','position',[0.13 .20 .14 .05],...
    'string','export4xvol3d','fontsize',7,...
    'tag','export4xvol3d_btn','backgroundcolor','w','callback',@export4xvol3d_btn,...
    'tooltipstring',...
    ['export results for xvol3d-visualization' char(10) ...
    'Only for DTI-connectivities (not for DTI-parameter).' char(10) ...
    '<font color="black">command: <b><font color="green">export4xvol3d</font>'...
    ]);

% 


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
hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');
cprintf([1 0 1],['loading group-assignment (xls-file)...wait..' ]);
if exist('file')==0
    
    [fi pa]=uigetfile(pwd,'select group assignment file (excel file)','*.xls');
    if pa==0;
        cprintf([1 0 1],['process aborted.\n' ]);
        return;
    end
    file=fullfile(pa,fi);
end


us.groupfile=file;
set(hf,'userdata',us);

%check groupsize
[~,~,a]=xlsread(file);
cprintf([1 0 1],['done.\n' ]);
a(1,:)=[];
cprintf([0 .5 0],['==========================================\n' ]);
cprintf([0 .5 0],['       group-assignment\n' ]);
cprintf([.5 .5 .5],['The first two columns constitute the animal name and the group assignment, respectively. \n' ]);
disp(a);
cprintf([0 .5 0],['==========================================\n' ]);


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
    
    
    
    %% check
    % s=zeros(prod(si),1);s(ind)=val; s=reshape(s,[si]); s= s+s'
end
cprintf([0 0 1],['Done.\n']);

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

set(hf,'userdata',us);



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
            
            % ==============================================
            %%   deal with missings
            % ===============================================
            
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
        nw=[nw; us.pw(i).networkmetrics];
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
        uhelp(sz,1);
    end
    
    %     assignin('base','stat',sz);
end

if doexport==1
    removexlssheet(file);
    xlsstyle(file);
    disp(['created: <a href="matlab: system('''  [file] ''');">' [file] '</a>']);
end

cprintf([0 .5 0],['Done.\n' ]);



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
d=cmat./noSeeds;     % normalize weights by number of seeds (  %noSeeds=10^6;)
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

%==================================== Parallel PROC if [PCT] available  =============================================
try
    cpus=feature('numCores');
    pp = gcp('nocreate');
    if isempty(pp)
        parpool( cpus);
    else
        %poolsize = p.NumWorkers
    end
    % delete(gcp('nocreate'))
end
%===================================== REFERENCE PROGRESSBAR================================================
np =[];
npv=[];
tic
N=size(d2,3) ;
cprintf([0 0.45 0],['  TARGET STATE: ' ]);
for i=1:N
    cprintf([0 0.45 0],['.|']);
end
fprintf(1,'\n');

%===================================== PARFOR LOOP================================================
cprintf([0.9294 0.6941 0.1255],[' CURRENT STATE:  ' ]);
parfor i=1:N
    fprintf('\b.|\n');%fprintf(1,['.|']);
    dx=d2(:,:,i);
    ws= calcConnMetrics(dx);
    np(:,i)    =ws.sc;   %SCALAR
    npv(:,:,i) =ws.vec;  %VEC
end
vecml     ={'efficiency_wei(dx,1)'  'modularity_und(dx)' 'clustering_coef_wu(dx)' 'degrees_und(dx)'};
paramlabel=['assortativity_wei(dx,0)'      'transitivity_wu(dx)'   'efficiency_wei(dx,0)'  vecml]';
cprintf([0 0.45 0],[' calculation DONE (ET: ' sprintf('%2.2f',toc/60)  'min).\n' ]);

% ==============================================
%%  OLD - slow
% ===============================================
if 0
    % metricCommand={'output=efficiency_wei(W,0)','output=efficiency_wei(W,1)','[~,output]=modularity_und(W)',...
    %     'output=assortativity_wei(W,0)','output=clustering_coef_wu(W)','output=degrees_und(W)',...
    %     'output=transitivity_wu(W)'};
    np=[];
    
    parfor i=1:size(d,3)
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
end
% ==============================================
%%   to struct
% ===============================================
nw.np        =np           ;
nw.nplabel   =paramlabel   ;
nw.npv       =npv          ;
nw.npvlabel  =vecml        ;

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

export2excel();


% us      : userdata of dtistat
% filename: optional use FP-filename otherwise gui opens ; example: fullfile(pwd,'_result.xlsx');
function export2excel(par)

if exist('par')==1
    if isfield(par,'export')
        if strcmp(par.export,'export')==0
            filename=par.export;
        end
        
    end
end

hf=findobj(0,'tag','dtistat');
us=get(hf,'userdata');

% fprintf(' ... exporting results.. ');
cprintf([1 0 1],['exporting results (excelfile) ..wait..' ]);


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

cprintf([1 0 1],['done.\n' ]);
% fprintf(' [Done]\n ');
disp([' open xlsfile: <a href="matlab: system(''' filename ''')">' filename '</a>']);





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


if 1 % calculated already done apply for calculated data
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
showresults(0);


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

vec   = ([efficiency_wei(dx,1)  modularity_und(dx) clustering_coef_wu(dx) degrees_und(dx)' ]);
vecm  = mean(vec);
sc    = [ assortativity_wei(dx,0)        transitivity_wu(dx)     efficiency_wei(dx,0)   vecm];
out.sc =sc;
out.vec=vec;





function export4xvol3d_btn(e,e2)
 export4xvol3d()





function export4xvol3d(x)
% ##HELP_export4dvol3d_on
%HELP
% #wb function to export connection and connection strength that can be used to visualize via xvol3d
% #wb PARAMETER
% 'ano'  : Select the corresponding Atlas (a Nifti-file) here. Mandatory to read the region locations.
%          Example: path of "ANO.nii".
% 'hemi' : Sselect corresponding Hemisphere Mask (a Nifti-file) here. Mandatory to sepearate regions
%          into left and right hemishere. Example path of "AVGThemi.nii"'.
% 'cs'   : Connection strength (cs) or another parameter to export and display via xvol3d.
%          Default: 'diff' -paramter as this is the mean diff value between two groups.
% 'outputname' : A string served as outputname. Default 'DTIconnections'.
% 'contrast' : The contrast to save. Chose one from the list or select 'all' to export all contrasts
%              -also possible to use the index/indices such as [1] or [2 3] depending if contrasts exist
% 'keep'       : Decide which connections should be saved (default: 'all'). Choose from list.
%                options:
%                'all'   : save all connections (independent from its significance).
%                'uncor' : save connections with p-value <0.05
%                'FDR'   : save only connections with FDR corrected significances.
% 'underscore': remove/keep underscores in atlas label strings:  {0} remove or {1} keep underscores
%               in exported labels. Default: 0.
% 'LRtag      : remove/keep left/right hemispheric tag in atlas label strings:  {0} remove or {1} keep
%               left/right hemispheric tag
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
if exist('x')==1
    x=x.export4xvol3d;
else
    if isfield(us,'export4xvol3d')% load pre-assigned parameters
        x=us.export4xvol3d;
    end   
end


if exist('x')~=1;        x=[]; end
p={...
    'inf1'              'Importer for "xvol3d.m"            '                         '' ''
    'ano'     ''        'select corresponding Atlas (Nifti-file); such as "ANO.nii"'  {'f'}
    'hemi'    ''        'select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"'  {'f'}
    'cs'     cslist{1}  'connection strength (cs) or other parameter to export/display via xvol3d'  cslist
    
    
    'inf2'              '##'   '' ''
    'outputname'    'DTIconnections'   'output name string'   {'DTIconnections'  'DTIoutput' 'DTI4xvol3d'}
    'contrast'      contrastlist{2}   'constrast to save (see list (string) or numeric index/indices)' contrastlist
    
    'keep'       'all'    'connections to keep in file {''all'' ''FDR'' ''uncor''}'  {'all' 'FDR' 'uncor'}
    
    'underscore' 0   '{0,1} underscores in atlas labels:  {0} remove or {1} keep '                  'b'
    'LRtag' 0   '{0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep '   'b'
    };
p=paramadd(p,x);

if isfield(x,'gui')==0 || x.gui==1
    showgui=1;
else
    showgui=0;
end
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

us.export4xvol3d=z;
set(findobj(0,'tag','dtistat'),'userdata',us);


% disp(z);
% return
% ==============================================
%%   export for xvol3d
% ===============================================
us=get(findobj(0,'tag','dtistat'),'userdata');


%---ATLAS
fAno=char(z.ano); %fullfile(pwd,'templates','ANO.nii');
[ha a mm]=rgetnii(fAno);
fAnoxls=strrep(fAno,'.nii','.xlsx');
[~,~,b]=xlsread(fAnoxls);
del=find(strcmp(cellfun(@(a){[num2str(a)]}, b(:,1)),'NaN'));
b(del,:)=[];
hb      =b(1,:);
b       =b(2:end,:);
%---HEMI
fhemi=z.hemi; %fullfile(fileparts(fAno),'AVGThemi.nii');
[hm m]=rgetnii(fhemi);

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
    [Lab1 Lab2] =strtok(lab,'--');
    Lab2=regexprep(Lab2,'^--','');
    labm=[Lab1 Lab2];
    % ---------------------------------
    % 'keep' selection
    % ---------------------------------
    isurv=1:size(d,1);
    if strcmp(z.keep,'FDR')  % {'all' 'FDR' 'uncor'}
        isurv=find(d(:,find(strcmp(hd,'Hfdr'))));
    elseif strcmp(z.keep,'uncor')
        isurv=find(d(:,find(strcmp(hd,'Huncor'))));
    end
    d    = d(isurv,:);
    labm = labm(isurv,:);
    
    
   
    
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
            ishemis=[~isempty(regexpi(labthis,'^R_'))         ~isempty(regexpi(labthis,'^L_'))  ];
            labthis2=labthis;
            hem=0;
            if sum(ishemis)
                labthis2=regexprep(labthis,{'^L_' '^R_'},'');
                hem=find(ishemis);
            end
            
            %find label
            il=regexpi2(b(:,1),['^' labthis2 '$|^' strrep(labthis2,'_',' ')  '$' ]);
            if isempty(il)
                disp('PROBLEM:LABEL NOT FOUND')
                keyboard
            end
            ID=cell2mat(b(il,4));
            CH=str2num(cell2mat(b(il,5)));
            idall=[ID; CH(:)];
            
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
    % output name
    % ---------------------------------
    pa=fileparts(us.groupfile);
    if isempty(pa)
        pa=pwd;
    end
    outtag=us.pw(i).str;
    outtag=regexprep(outtag,'<|>','_vs_');
    %     regexprep('AYdede.:-_d012_=3499./()',{'[^a-zA-Z0-9_]'},{''});
    outtag=regexprep(outtag,{'[^a-zA-Z0-9_]'},{''});
    fileout=fullfile(pa,[z.outputname '_' outtag '.xlsx']);
    
    % ---------------------------------
    % save
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
    
    pwrite2excel(fileout,{1 'nodes'},h2,[],d2);
    showinfo2('saved: ',fileout);
    
    
end% pws/contrasts
cprintf([1 0 1],['Done.\n' ]);



