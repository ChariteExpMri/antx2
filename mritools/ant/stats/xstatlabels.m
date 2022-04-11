
%% [xstatlabels.m] statistical analyis of anatomical labels via excelfile
% currently only between-tests implemented
%_________________________________________________________________
%% #wb  GUI 
% [load data]:      select excel-file
% [select sheet]:   select the sheet (example: mean)
% [load aux]     :   load another excel-file with mouse names/ids and group assignment
% [select sheet] :   select the sheet  with mouse names/ids and group assignment
% [ID]           :   select column with mouse names/ids
% [group factor1]:   select the column that indicates the group assignment
% 
% [within]       : check if data bases on within design (repated measure)
% [test]         : select the test
%                  for between-design: ttest2, ranksum, permutation, permutation2
% [tail]         : tail of hypothesis-testing {both|left|right}
% [useFDR]       : to correct for MCP
% [show SIGS only]: shows only the significant results
% [sort results  ]: sort results according the p-value
%                    
% 
% [load regions]: load an additional excelfile with interested anatomical regions
%               - to restore the default,i.e. all regions: click [load regions],and hit [cancel] in the  uigetfile-window
% [regions     ]: select specific anatomical regions for analysis
% [process     ]: run the statistic
% [export      ]: export statistical results (data must be processd before )
% [get batch   ]: get batch with parameters to re-run (if GUI-parameters are not
%                 specified the batch will contain empty fields for those paramters)
%_________________________________________________________________
% #wr REGIONS FILE   -OPTION-1: 
%   -a regions file can be additionally used to test a few specific regions or combinations of regions.
%   -The regionsfile has to be an excelfile, specifically the 1st data sheet is used. In the 1st data sheet
%    the 1st column contains the label of anatomical regions. The 2nd column contains a number.
%  #r - is is assumed that the 1st ROW is a HEADER (label in the header-row are arbitrary) 
% Regions with the same number in the 2nd column will be combined,i.e. data of those regions will be pooled.
% Note: - that the order of the labels (column-1) and the explicit value of the number in column-2 is arbitrary.
%       - Be carefull with the exact spelling of the labels otherwise the region will not be found in the label-column
%         of the datasheet
%       - only regions with a number in the 2nd. column will be parsed to analysis (all other regions defined
%        in column-1 will be neglected)--> Thus the regions file can contain only those regions you want to analyze.
% EXAMPLE: In this example the data of the below Somatomotor areas will be pooled (same value in column-2: 22),
% also the data of the below cingulate area will be pooled (same value in column-2: 5), while the data for 
%     Dorsal auditory area (value: 3) and Olfactory areas (value: 1000) remain unpooled
% #m regions with the same mergeID will be pooled
% #m note: for mergeID=3 there is only one region (this region is not merged/pooled)
%     _____[content of the region file]____(2 colums)__________
%     region                                           mergeID
%     Somatomotor areas, Layer 2/3                         22
%     Somatomotor areas, Layer 5                           22
%     Somatomotor areas, Layer 6a                          22
%     Somatomotor areas, Layer 6b                          22
%     Dorsal auditory area                                 3
%     Anterior cingulate area, ventral part, layer 2/3     5
%     Anterior cingulate area, ventral part, layer 5       5
%     Anterior cingulate area, ventral part, 6a            5
%     Olfactory areas                                     1000
%     ________________________________________________________
%_________________________________________________________________
% #wr REGIONS FILE   -OPTION-2:   ONLY REGIONS that should be used
% #r now the Excelfile contains only one column!!!
% #m each of the regions of the regionfile will be analyzed separately
% 
%     _____[content of the region file]____(1 colum)___________
%     region                                          
%     Somatomotor areas, Layer 2/3                         
%     Somatomotor areas, Layer 5                           
%     Somatomotor areas, Layer 6a                          
%     Somatomotor areas, Layer 6b                          
%     Dorsal auditory area                                 
%     Anterior cingulate area, ventral part, layer 2/3     
%     Anterior cingulate area, ventral part, layer 5       
%     Anterior cingulate area, ventral part, 6a            
%     Olfactory areas                                     
%     ________________________________________________________
% 
% #k this is identical to 2 two-column-file if the mergeIDs are different for all regions ...
%     _____[content of the region file]____(2 colums)__________
%     region                                           mergeID
%     Somatomotor areas, Layer 2/3                         1
%     Somatomotor areas, Layer 5                           2
%     Somatomotor areas, Layer 6a                          3
%     Somatomotor areas, Layer 6b                          4
%     Dorsal auditory area                                 5
%     Anterior cingulate area, ventral part, layer 2/3     6
%     Anterior cingulate area, ventral part, layer 5       7
%     Anterior cingulate area, ventral part, 6a            8
%     Olfactory areas                                      9
%     ________________________________________________________
% 
% 
%_________________________________________________________________
% #wb AUTOMATIZE: examples
%  xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
%         fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','ranksum',...
%         'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',0 ,'showsigsonly',0 ,'issort',0,...
%         'process',1 ));
% 
%     xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
%         fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','ranksum',...
%         'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',0 ,'showsigsonly',0 ,'issort',0,...
%         'process',1,'task','export', 'exportfile',  fullfile(pwd, 'blo.xlsx')   ));
%     
%     xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
%         fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','Ttest2',...
%         'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',1 ,'showsigsonly',1 ,'issort',1,'qFDR',.4));
%     
%%  example  process data
%     px='O:\data2\x01_maritzen'
%     xstatlabels(struct(...
%         'data',fullfile(px,'labels_c_ADC_native_ALL.xls'),...
%         'dataSheet','mean',...
%         'aux',fullfile(px,'#groups_Animal_groups.xlsx'  ),...
%         'f1design',0,'typeoftest1','Ttest2',...
%         'auxSheet','Tabelle1',...
%         'id', 'MRI Animal-ID','f1','type',...
%         'isfdr',1 ,'showsigsonly',1 ,...
%         'issort',1,'qFDR',0.5,'process',1));
%     
%     
%% example - USING additional REGIONSFILE
%         xstatlabels(struct(...
%         'data','O:\data2\x02_maglionesigrist\adc_native_space_ALL.xls',...
%         'dataSheet','mean',...
%         'aux',fullfile(px,'#groups_Aged_mice_MRI_20171023.xlsx'  ),...
%         'f1design',0,'typeoftest1','ttest2',...
%         'auxSheet','Tabelle1',...
%         'id', 'MRI-ID','f1','GROUP',...
%         'isfdr',1 ,'showsigsonly',0 ,...
%         'issort',1,'qFDR',0.05,'process',1,'outvar','sx',...
%         'regionsfile', fullfile(px,'#myRegions_test.xls'  )  ));
%% example - created from batch
% v = [];
% v.data         =  'O:\data2\susanne_atlasstatisticProblem\anatomical_labels_brains_NR1_Apr2018_neu.xls';          % % excel data file
% v.dataSheet    =  'vol_percBrain';          % % sheetname of excel data file
% v.aux          =  'O:\data2\susanne_atlasstatisticProblem\groups_NR1_Apr2018_neu.xls';          % % excel group assignment file
% v.auxSheet     =  'Tabelle1';          % % sheetname of excel group assignment file
% v.id           =  'animal ID';          % % name of the column containing the animal-id in the auxSheet
% v.f1           =  'Group';          % % name of the column containing the group-assignment in the auxSheet
% v.f1design     =  [0];          % % type of test: [0]between, [1]within
% v.typeoftest1  =  'ranksum';          % % applied  statistical test (such as "ranksum" or "ttest2")
% v.regionsfile  =  '';          % % <optional> excelfile containing regions, only this regions will be tested
% v.qFDR         =  [0.04];          % % q-threshold of FDR-correction (default: 0.05)
% v.isfdr        =  [1];          % % use FDR correction: [0]no, [1]yes
% v.showsigsonly =  [1];          % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
% v.issort       =  [1];          % % sort results according the p-value: [0]no, [1]yes,sort 
% v.process      =  [1];          % % calculate statistic [0]no, [1]yes, (simulates pressing the [process]-button) 
% v.task        =   'export';       % % export the result (data must have been processed before)
% v.exportfile   =  fullfile(pwd, '__result123.xlsx'); % %save result as... 
% xstatlabels(v);     % % RUN statistic
%% example2
% v = [];
% v.data         =  'F:\data1\bug_labelbasedStatistic\adc_labels_other_both_28May2020_10-35-56.xlsx';          % % excel data file
% v.dataSheet    =  'median';          % % sheetname of excel data file
% v.aux          =  'F:\data1\bug_labelbasedStatistic\Manuskript_IL6_sham_group_ assignment.xlsx';          % % excel group assignment file
% v.auxSheet     =  'Tabelle1';          % % sheetname of excel group assignment file
% v.id           =  'Animal MRI-ID';          % % name of the column containing the animal-id in the auxSheet
% v.f1           =  'genotype Cx30/FlexIL6';          % % name of the column containing the group-assignment in the auxSheet
% v.f1design     =  [0];          % % type of test: [0]between, [1]within
% v.typeoftest1  =  'ttest2';          % % applied  statistical test (such as "ranksum" or "ttest2")
% v.regionsfile  =  '';          % % <optional> excelfile containing regions, only this regions will be tested
% v.qFDR         =  [0.05];          % % q-threshold of FDR-correction (default: 0.05)
% v.isfdr        =  [1];          % % use FDR correction: [0]no, [1]yes
% v.showsigsonly =  [0];          % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
% v.issort       =  [0];          % % sort results according the p-value: [0]no, [1]yes,sort 
% v.process      =  [0];          % % calculate statistic [0]no, [1]yes, (simulates pressing the [process]-button) 
% xstatlabels(v);     % % RUN statistic
% 
% #ok POSTHOC
%% xstatlabels('run');  % process data (is like pressing the [process]-button) 
%% posthoc:  export results as excelfile
% xstatlabels('export')   % this ask for the filename  
% xstatlabels('export','file',fullfile(pwd,'__export_klaus2.xlsx')); %silent mode
% 
% 

function xstatlabels(varargin)
warning off;

if 0
    xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
        fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','ranksum',...
        'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',0 ,'showsigsonly',0 ,'issort',0,...
        'process',1,'task','export', 'exportfile',  fullfile(pwd, 'blo.xlsx')   ));
    
    xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
        fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','Ttest2',...
        'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',1 ,'showsigsonly',1 ,'issort',1,'qFDR',.4));
    
    %% process data
    px='O:\data2\x01_maritzen'
    xstatlabels(struct(...
        'data',fullfile(px,'labels_c_ADC_native_ALL.xls'),...
        'dataSheet','mean',...
        'aux',fullfile(px,'#groups_Animal_groups.xlsx'  ),...
        'f1design',0,'typeoftest1','Ttest2',...
        'auxSheet','Tabelle1',...
        'id', 'MRI Animal-ID','f1','type',...
        'isfdr',1 ,'showsigsonly',1 ,...
        'issort',1,'qFDR',0.5,'process',1));
    
    
    %% USING additional REGIONSFILE
        xstatlabels(struct(...
        'data','O:\data2\x02_maglionesigrist\adc_native_space_ALL.xls',...
        'dataSheet','mean',...
        'aux',fullfile(px,'#groups_Aged_mice_MRI_20171023.xlsx'  ),...
        'f1design',0,'typeoftest1','ttest2',...
        'auxSheet','Tabelle1',...
        'id', 'MRI-ID','f1','GROUP',...
        'isfdr',1 ,'showsigsonly',0 ,...
        'issort',1,'qFDR',0.05,'process',1,'outvar','sx',...
        'regionsfile', fullfile(px,'#myRegions_test.xls'  )  ));
    
    
end

%% =========dealing with posthoc inputs======================================
if nargin>0
    if ~isstruct(varargin{1})
        processpost(varargin);
        return
    end
end


%% ===============================================

try; delete(findobj(0,'tag','stat')); end



figure;
set(gcf,'tag','stat','color','w','name',['stat [' mfilename ']'],'NumberTitle','off');
set(gcf,'menubar','none','units','normalized','position',[0.5594    0.4122    0.3889    0.4667]);


% panel for Data
h1=uipanel('units','norm');
set(h1,'position',[0 .83 .41 .07]);
%--PB load data
h=uicontrol('style','pushbutton','units','norm','position',[0.0043999 0.84165 0.15 0.05],...
    'string','load data','tag','loaddata','callback',@getdatafile,...
    'TooltipString', '<html><b>load data</b><br>load excelfile containing the data');
% data sheet-selection
h=uicontrol('style','popupmenu','units','norm','position',[.2 0.83927 .2 .05],'string','select sheet','tag','popdatasheet',...
    'callback',@call_datacheet,...
    'TooltipString',   '<html>select the Excel-<b>sheet</b> containing the <font color=red>data');



% text-'sheet'
% h=uicontrol('style','text','units','norm',     'position',[0.17761 0.89641 0.2 0.05],'string','sheet','tag','txtsheetnum','backgroundcolor','w');


% panel for GA
h2=uipanel('units','norm');
set(h2,'position',[0 .64 .41 .165]);
%--PB load group assignment (GA)
h=uicontrol('style','pushbutton','units','norm','position',[0.0061855 0.75118 0.15 0.05],...
    'string','load group agmt','tag','loadaux','callback',@getauxfile,...
    'TooltipString', '<html><b>load group assignment (excel-file)</b><br>load excelfile containing mouseID and group assignment');
% GA sheet-selection
h=uicontrol('style','popupmenu','units','norm','position',[.2 .75 .2 .05],'string','select sheet',...
    'tag','popdauxsheet','callback',@call_auxcheet,...
    'TooltipString', '<html>select the Excel-<b>sheet</b> containing <font color=red>mouseID and group assignment');


%text ID-col
h=uicontrol('style','text','units','norm',   'position',[.0 .695 .2 .05],'string','ID','foregroundcolor','b');
set(h,'HorizontalAlignment','right');
%pop ID-col
h=uicontrol('style','popupmenu','units','norm','position',[.2 .7 .2 .05],'string','column','tag','popID',...
    'callback',@call_popID,...
    'TooltipString', '<html>select the Excel-<b>column</b> with <font color=red>mouseIDs (animal names)');

%txt group-col
h=uicontrol('style','text','units','norm',     'position',[.0 .645 .2 .05],'string','group-colum','foregroundcolor','b');
set(h,'HorizontalAlignment','right');
% pop group-col
h=uicontrol('style','popupmenu','units','norm','position',[.2 .65 .2 .05],'string','select column','tag','popgroupF1',...
    'callback',@call_groupFactor1,...
    'TooltipString', '<html>select the Excel-<b>column</b> with the <font color=red>group assignment</font><br>..which animal belongs to which group...');
% ==============================================
%%   
% ===============================================
%between vs within group
h=uicontrol('style','checkbox','units','norm','position',[[0.46689 0.70833 0.2 0.05]],'string','within',...
    'tag','F1design','backgroundcolor','w','callback',@call_f1design,...
    'TooltipString', '<html><b> between vs within groups </b><br>[ ] between/independent groups<br>[x] repeated/within group');

%% groupfactor-2
h=uicontrol('style','text','units','norm',     'position',[.0 .60 .2 .05],'string','groupFactor2','backgroundcolor','w');
set(h,'HorizontalAlignment','right','tag','groupFactor2');
h=uicontrol('style','popupmenu','units','norm','position',[.2 .60 .2 .05],'string','select column','tag','popgroupF2',...
    'callback',@call_groupFactor2);


%between vs within
h=uicontrol('style','checkbox','units','norm','position',[.4 .60 .2 .05],'string','within',...
    'tag','F2design','backgroundcolor','w','callback',@call_f2design);

set(findobj(gcf,'tag','groupFactor2'),'visible','off');
set(findobj(gcf,'tag','popgroupF2'),'visible','off');
set(findobj(gcf,'tag','F2design'),'visible','off');
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% FDR
h=uicontrol('style','checkbox','units','norm','position',[.1 .7 .2 .05],'string','use FDR',...
    'tag','isfdr','backgroundcolor','w','value',1,...
    'tooltipstring','use FDR for treatment of multiple comparisons (MCP)');%,'callback',@call_f2design);
set(h,'position',[.01 .55 .2 .05],'fontsize',7,'callback',@isfdr);
% showSigs
h=uicontrol('style','checkbox','units','norm','position',[.3 .7 .2 .05],'string','show SIGs only',...
    'tag','showsigsonly','backgroundcolor','w','value',1,...
    'tooltipstring','show significant results only');%,'callback',@call_f2design);
set(h,'position',[.15 .55 .2 .05],'fontsize',7,'callback',@showsigsonly);
%sort
h=uicontrol('style','checkbox','units','norm','position',[.45 .7 .2 .05],'string','sort Results',...
    'tag','issort','backgroundcolor','w','value',1,...
    'tooltipstring','sort Results according p-value');%,'callback',@call_f2design);
set(h,'position',[.32 .55 .2 .05],'fontsize',7,'callback',@issort);

%% sided of hypothesis-Testing
%text
h=uicontrol('style','text','units','norm','string','tail','backgroundcolor','w');
set(h,'position',[.45 .54 .09 .05],'fontsize',7);%,'callback',@issort);
% popmenu
tail={'both','left','right'};
h=uicontrol('style','popupmenu','units','norm','position',[.45 .7 .2 .05],'string',tail,...
    'tag','tail','backgroundcolor','w','value',1,...
    'tooltipstring','Type of alternative hypothesis: both(default)|right|left ');%,'callback',@call_f2design);
set(h,'position',[.51 .545 .09 .05],'fontsize',7);%,'callback',@issort);

% 'Tail' — Type of alternative hypothesis
% 'both' (default) | 'right' | 'left'
% Type of alternative hypothesis to evaluate, specified as the comma-separated pair consisting of 'Tail' and one of the following.
% 
% 'both'	Test the alternative hypothesis that the population mean is not m.
% 'right'	Test the alternative hypothesis that the population mean is greater than m.
% 'left'	Test the alternative hypothesis that the population mean is less than m.


%% qvalue
h=uicontrol('style','edit','units','norm','position',[.01 .52 .05 .03],'string','0.05',...
    'tag','qFDR','backgroundcolor','w','value',1,...
    'tooltipstring','desired false discovery rate. {default: 0.05}','fontsize',7,'callback',@qFDR);
h=uicontrol('style','text','units','norm','position',[.06 .52 .05 .03],'string','qFDR',...
    'backgroundcolor','w');


% =====type of test==========================================
h=uicontrol('style','popupmenu','units','norm','position',[0 .45 .2 .05],...
    'string',{'ttest2' 'ranksum' 'permutation','permutation2'},'tag','testsbetween',...
    'callback',@typeoftest1,'position',[0.46689 0.65833 0.1 0.05],'tag','typeoftest1',...
    'tooltipstring','select type of test');



%info
% h=uicontrol('style','listbox','units','norm','position',[0 .9 .5 .1],'string','aux header','tag','fileinfo',...
%     'backgroundcolor','w')



h=uicontrol('style','listbox','units','norm','position',[.6 .6 .4 .4],'string',{'info'},'tag','lbinfo');

% regions

h=uicontrol('style','pushbutton','units','norm','position', [0 .45 .2 .05],'string','load regions',...
    'tag','loadregions','backgroundcolor','w','callback',@loadregions,...
    'TooltipString', 'load excelfile with regions of interest');


h=uicontrol('style','pushbutton','units','norm','position', [0 .4 .2 .05],'string',' select regions',...
    'tag','regions','backgroundcolor','w','callback',@regions,...
    'TooltipString', 'select specific anatomical regions via GUI','fontsize',8);
%process
h=uicontrol('style','pushbutton','units','norm','position',[0.2 .4 .2 .05],'string','process',...
    'tag','process','backgroundcolor','w','callback',@process,'fontweight','bold',...
    'TooltipString', 'RUN STATISTICAL ANALSYSIS');

h=uicontrol('style','pushbutton','units','norm','position',[0.4 .4 .2 .05],'string','export',...
    'tag','export','backgroundcolor','w','callback',@export,...
    'TooltipString', 'export statistical results');



h=uicontrol('style','pushbutton','units','norm','position',[0.6 .4 .2 .05],...
    'string','help','tag','help','callback',@xhelp,'backgroundcolor','w');


h=uicontrol('style','pushbutton','units','norm','position',[0.8 .4 .15 .05],...
    'string','get batch','tag','xbatch','callback',@xbatch,'backgroundcolor','w','tooltipstring','get code to re-run');

%% =======[scripts]========================================

h2=uicontrol('style','pushbutton','units','norm');
set(h2, 'string','scripts','callback',@scripts_call);
set(h2, 'position',[0.8 .35 .15 .05]);
set(h2,'BackgroundColor',[0.9608    0.9765    0.9922],'fontsize',7,'foregroundcolor',[0 0 1]);
set(h2,'tooltipstring',['<html><b>collection of scripts</b><br>' ...
    'open scripts-gui with collection of scripts<br>'...
    '-scripts can be costumized and applied']);



h=uicontrol('style','pushbutton','units','norm','position',[0.9 .5 .1 .025],...
    'string','code snippet','tag','xbatch','callback',@codesnippet,'fontsize',4,...
    'backgroundcolor','w',...
    'tooltipstring',['code snippet to check the result ' char(10) ' ..modify and test the snippet']);



us.dummy       =1;
us.issort      =1;
us.showsigsonly=1;
us.isfdr       =1;
us.f1design    =0;
us.f2design    =0;
us.typeoftest1 =1;
us.qFDR        =.05;
set(gcf,'userdata',us);


if 0
    a1(struct('data','data_cbf_allen_space.xls'))
    %     in=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    
end


if ~isempty(varargin)
    in= varargin{1};
    loadstuff(in);
end


% % FDR
% h=uicontrol('style','checkbox','units','norm','position',[.1 .7 .2 .05],'string','use FDR',...
%     'tag','isfdr','backgroundcolor','w','value',1,...
%     'tooltipstring','use FDR for treatment of multiple comparisons (MCP)');%,'callback',@call_f2design);
% set(h,'position',[.01 .55 .2 .05],'fontsize',7,'callback',@isfdr);
% % showSigs
% h=uicontrol('style','checkbox','units','norm','position',[.3 .7 .2 .05],'string','show SIGs only',...
%     'tag','showsigsonly','backgroundcolor','w','value',1,...
%     'tooltipstring','show significant results only');%,'callback',@call_f2design);
% set(h,'position',[.15 .55 .2 .05],'fontsize',7,'callback',@showsigsonly);
% %sort
% h=uicontrol('style','checkbox','units','norm','position',[.45 .7 .2 .05],'string','sort Results',...
%     'tag','issort','backgroundcolor','w','value',1,...
%     'tooltipstring','sort Results according p-value');%,'callback',@call_f2design);
% set(h,'position',[.32 .55 .2 .05],'fontsize',7,'callback',@issort);


function qFDR(e,e2)
us       = get(gcf,'userdata');
us.qFDR =  str2num(get(findobj(gcf,'tag','qFDR'),'string'))   ;
set(gcf,'userdata',us);



function isfdr(e,e2)
us       = get(gcf,'userdata');
us.isfdr = get(findobj(gcf,'tag','isfdr'),'value');
set(gcf,'userdata',us);

function showsigsonly(e,e2)
us       = get(gcf,'userdata');
us.showsigsonly = get(findobj(gcf,'tag','showsigsonly'),'value');
set(gcf,'userdata',us);

function issort(e,e2)
us       = get(gcf,'userdata');
us.issort = get(findobj(gcf,'tag','issort'),'value');
set(gcf,'userdata',us);


function getdatafile(e,e2,file)
us=get(gcf,'userdata');
if exist('file')==0
    [fi pa]=uigetfile(pwd,'select datafile (excel)','*.xls');
    if pa==0; return; end
    file=fullfile(pa,fi);
end
% us.dataFP    =fullfile(pa,fi);
us.data=file;
[d s fmt]=xlsfinfo(us.data);
us.dataSheets =s;
set(findobj(gcf,'tag','popdatasheet'),'string',us.dataSheets);
set(gcf,'userdata',us);
updatelistbox;

function getauxfile(e,e2,file)
us=get(gcf,'userdata');
if exist('file')==0
    [fi pa]=uigetfile(pwd,'select auxilary data (excel)','*.xls');
    if pa==0; return; end
    file=fullfile(pa,fi);
end
% us.auxFP    =fullfile(pa,fi);
us.aux=file;
[d s fmt]=xlsfinfo(us.aux);
us.auxSheets =s;
set(findobj(gcf,'tag','popdauxsheet'),'string',['select sheet' us.auxSheets]);
set(gcf,'userdata',us);
updatelistbox;

function updatelistbox
us=get(gcf,'userdata');
lb=findobj(gcf,'tag','lbinfo');
us=orderfields(us);
try; us=rmfield(us,'regions'); end
try; us=rmfield(us,'reg'); end
try; us=rmfield(us,'anat'); end


list=struct2list(us);
list=regexprep(list,'^us.','');
ieq=max(cell2mat(cellfun(@(a){regexpi(a,'=','once' )},list)));
list=cellfun(@(a){regexprep(a,'=',[':' repmat(' ' ,1,ieq-1-regexpi(a,'=','once' )  )],'once' )},list);
set(lb,'string',list);
set(lb,'FontName','courier');


function call_datacheet(e,e2)
us=get(gcf,'userdata');
li=get(e,'string');
val=get(e,'value');
us.dataSheet=li{val};
set(gcf,'userdata',us);
set(e,'backgroundcolor',[0.8392    0.9098    0.8510]);
updatelistbox;

function call_auxcheet(e,e2)
li=get(e,'string');
sheet=li{get(e,'value')};
if strcmp(sheet,'select sheet');
    return
end


us=get(gcf,'userdata');
[~,collab]=xlsread(us.aux,sheet,'A1:Z1');
us.auxcol  =collab;
us.auxSheet=sheet;

set(gcf,'userdata',us);
set(findobj(gcf,'tag','popID'),'string',collab);
set(findobj(gcf,'tag','popgroupF1'),'string',collab);
set(findobj(gcf,'tag','popgroupF2'),'string',[collab '*none*']);
set(e,'backgroundcolor',[0.8392    0.9098    0.8510]);

updatelistbox;


function call_popID(e,e2)
us=get(gcf,'userdata');
li=get(e,'string');
val=get(e,'value');
us.id=li{val};
set(gcf,'userdata',us);
set(e,'backgroundcolor',[0.8392    0.9098    0.8510]);

updatelistbox;

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function call_groupFactor1(e,e2)
us=get(gcf,'userdata');
li=get(e,'string');
val=get(e,'value');
us.f1=li{val};
set(gcf,'userdata',us);
set(e,'backgroundcolor',[0.8392    0.9098    0.8510]);

updatelistbox;

function call_f1design(e,e2)
us=get(gcf,'userdata');
val=get(e,'value');
us.f1design=val;
set(gcf,'userdata',us);

htests=findobj(gcf,'tag','typeoftest1');
if val==0 %between
    set(htests,'string',{'ttest2' 'ranksum' 'permutation' 'permutation2'});
else
    set(htests,'string',{'ttest' 'xx' 'yy'});
end

updatelistbox;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function typeoftest1(e,e2)
htests=findobj(gcf,'tag','typeoftest1');
val=get(htests,'value');
% get(htests,'string')
us=get(gcf,'userdata');
us.typeoftest1=val;
set(gcf,'userdata',us);
updatelistbox;



function call_groupFactor2(e,e2)
us=get(gcf,'userdata');
li=get(e,'string');
val=get(e,'value');
us.f2=li{val};
set(gcf,'userdata',us);
updatelistbox;

function call_f2design(e,e2)
us=get(gcf,'userdata');
val=get(e,'value');
us.f2design=val;
set(gcf,'userdata',us);
updatelistbox;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function process(e,e2)
disp('..wait...');
hfig=findobj(0,'tag','stat');
us=get(hfig,'userdata');
% figure(hfig);
loadExcelatlas();
% save('us','us');
us=get(hfig,'userdata');
a2_sub(us)




function loadExcelatlas
warning off;
fig1=findobj(0,'tag','stat');
us=get(fig1,'userdata');

if isfield(us,'anat')==0
    disp('load labels...');
    
    try
        xl = actxserver('excel.application'); %open activex server
        xl.visible = 0; %make things invisible
        wb = xl.Workbooks.Open(us.data); %open specified xlsx file
        wbSheet1 = wb.Sheets.Item(us.dataSheet); %specify sheet
        sizsheet=size(get(wbSheet1.UsedRange,'Value'));
        rowlab=cellfun(@(a){[ 'A' num2str(a) ]},num2cell(1:sizsheet(1))');
        
        colhex={};%repmat('0',length(rowlab),6);
        for i=1:length(rowlab)
            r = wbSheet1.Range(rowlab{i});
            cx=get(r.interior,'Color');
            labx{i,1}=get(r,'text');
            rgb=mod([cx floor(cx/256) floor((cx)/256^2)],256);
            colhex{i,1}=reshape(sprintf('%02X',rgb.'),6,[]).';
            % uhelp(plog({},{['<html><body bgcolor="#' hex '">Hello<']},0,[''],'s=0'),1);
        end
        wb.Close( false ); % Close workbook (false = no prompt?)
        xl.Quit % Quit Excel
        xl.delete % Not s
    catch
        
        
        keyboard
        
        
        
        
        
       [~,~,tb]=xlsread( us.data, us.dataSheet);
       av    =tb(:,1)
       rowlab=cellfun(@(a){[ num2str(a) ]},av);
        idel=regexpi(rowlab,'^NaN$')
       idel=regexpi2(rowlab,'NaN')
       rowlab(regexpi2(rowlab,'NaN'))=[]
        
    end
    
    iuse=find(~cellfun(@isempty,labx));
    us.anat.labels =labx(iuse);
    us.anat.colhex =colhex(iuse);
    
    us.anat.labels =us.anat.labels(2:end);
    us.anat.colhex =us.anat.colhex(2:end);
 
    set(fig1,'userdata',us);
end


function regions(e,e2)
disp('...select specific regions ...loading labels..wait...');
warning off;
fig1=findobj(0,'tag','stat');
us=get(fig1,'userdata');
if isfield(us,'regionsfile')
    us=rmfield(us,'regionsfile'); %
    try; 
        us=rmfield(us,'regions');
    end
    set(fig1,'userdata',us);
end

loadExcelatlas;


us=get(fig1,'userdata');

o=a3_listbox(us.anat.labels,us.anat.colhex,'iswait',0,'submit',1);

% ADD regions on right side, if selected before
if isfield(us,'regions')
    regions2addRight=us.regions;
    if ~isempty(regions2addRight)
        lb1=findobj(findobj(0,'tag','listselect'),'tag','lb1');
        
        %---move IDS to right LB
         ix=[];
        for i=1:size(regions2addRight,1)
            try
            tp=cell2mat(regions2addRight(i,2)); tp=tp(:);
            catch
             tp=cell2mat(regions2addRight{i,2}); tp=tp(:);   
            end
            ix=[ix;tp];
        end
        set(lb1,'value',ix);
        b1=findobj(findobj(0,'tag','listselect'),'tag','b1');
        hgfeval(get(b1,'callback'));
        
        % find combined labels
        lb2=findobj(findobj(0,'tag','listselect'),'tag','lb2');
        s0=get(lb2,'string');
        s1=s0;
        for i=1:size(regions2addRight,1)
            if isempty(strfind(regions2addRight{i,1},'@')) %single
                lab=regions2addRight{i,1};
                ix=unique([...
                        regexpi2(s0,[lab '&nbsp;'])
                        regexpi2(s0,[lab '$'])
                        ]);
                s1(ix)=s0(ix)  ;  
            else %combined region
                lab=regions2addRight{i,3};
                ix=[];
                for j=1:length(lab)
                    is=unique([...
                        regexpi2(s0,[lab{j} '&nbsp;'])
                        regexpi2(s0,[lab{j} '$'])
                        ]);
                    ix=[ix is(:)'];
                end
               s1(ix)=regexprep(s1(ix),['<html>'],['<html>' regions2addRight{i,1}]);
                
            end
        end
        set(lb2,'string',s1);
        
        
%         
%         
%         
%         
%         for i=1:size(regions2addRight,1)
%             if isempty(strfind(regions2addRight{i,1},'@'))
%                 ix=regions2addRight{i,2};
%                 set(lb1,'value',ix);
%                 b1=findobj(findobj(0,'tag','listselect'),'tag','b1');
%                 hgfeval(get(b1,'callback'));
%             else %combined regions
%                try; 
%                    ix=cell2mat(regions2addRight{i,2}); 
%                end
%                 
%             end
%             
%             
%         end
%         
%         
%         
%         
%         
%         lb1=findobj(findobj(0,'tag','listselect'),'tag','lb1');
%         
%         ix=[];
%         for i=1:size(regions2addRight,1)
%             try
%             tp=cell2mat(regions2addRight(i,2)); tp=tp(:);
%             catch
%              tp=cell2mat(regions2addRight{i,2}); tp=tp(:);   
%             end
%             ix=[ix;tp];
%         end
%         
%         set(lb1,'value',ix);
%         
%         b1=findobj(findobj(0,'tag','listselect'),'tag','b1');
%         hgfeval(get(b1,'callback'));
    end
end

% if isempty(o)
%     try;  us=rmfield(us.reg,'regions');end
%     try;  us=rmfield(us,'regions');end
% else
%     us.regions=o;
% end
% set(gcf,'userdata',us);

function export(e,e2)

a2_sub([],'task','export');



function loadstuff(in)

hfig=findobj(0,'tag','stat');


if isfield(in,'data');     getdatafile([],[],in.data) ; end
if isfield(in,'dataSheet');
    hh=findobj(hfig,'tag','popdatasheet');
    set(hh,'value',  regexpi2(get(hh,'string'),in.dataSheet));
    hgfeval( get(hh,'callback')  ,hh);
end
if isfield(in,'aux');     getauxfile([],[],in.aux) ; end
if isfield(in,'auxSheet');
    hh=findobj(hfig,'tag','popdauxsheet');
    set(hh,'value',  regexpi2(get(hh,'string'),in.auxSheet));
    hgfeval( get(hh,'callback')  ,hh);
end

ss={'id' 'popID'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value', regexpi2(get(hh,'string'),['^' getfield(in,ss{1}) '$'  ])  );
    hgfeval( get(hh,'callback')  ,hh);
end
ss={'f1' 'popgroupF1'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  regexpi2(get(hh,'string'),['^' getfield(in,ss{1}) '$'  ]) );
    hgfeval( get(hh,'callback')  ,hh);
end

ss={'f1design' 'F1design'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  getfield(in,ss{1}) );
    hgfeval( get(hh,'callback')  ,hh);
end

ss={'typeoftest1' 'typeoftest1'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  regexpi2(get(hh,'string'),['^' getfield(in,ss{1}) '$'  ]) );
    hgfeval( get(hh,'callback')  ,hh);
end

ss={'tail' 'tail'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  regexpi2(get(hh,'string'),['^' getfield(in,ss{1}) '$'  ]) );
    % hgfeval( get(hh,'callback')  ,hh);
end




ss={'isfdr' 'isfdr'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  getfield(in,ss{1}) );
    hgfeval( get(hh,'callback')  ,hh);
end
ss={'showsigsonly' 'showsigsonly'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value', getfield(in,ss{1}) );
    hgfeval( get(hh,'callback')  ,hh);
end
ss={'issort' 'issort'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'value',  getfield(in,ss{1}) );
    hgfeval( get(hh,'callback')  ,hh);
end

ss={'qFDR' 'qFDR'};
if isfield(in,ss{1});
    hh=findobj(hfig,'tag',ss{2});
    set(hh,'string',  num2str(getfield(in,ss{1})) );
    figure(findobj(0,'tag','stat'))
    hgfeval( get(hh,'callback')  ,hh);
end


% % % % % 
% % % % % if 0
% % % % % 
% % % % %     xstatlabels(struct(...
% % % % %         'data',file,...
% % % % %         'dataSheet',param{k},...
% % % % %         'aux',fullfile(px,'#groups_Aged_mice_MRI_20171023.xlsx'  ),...
% % % % %         'f1design',0,'typeoftest1',tests{j},...
% % % % %         'auxSheet','Tabelle1',...
% % % % %         'id', 'MRI-ID','f1','GROUP',...
% % % % %         'isfdr',1 ,'showsigsonly',0 ,...
% % % % %         'issort',1,'qFDR',0.05,'process',1,'outvar','sx',...
% % % % %         'regionsfile', fullfile(px,'#myRegions_test.xls'  )  ));
% % % % % end


if isfield(in, 'regionsfile')
    if ~isempty(char(in.regionsfile))
    us=get(gcf,'userdata');
    us.regionsfile=in.regionsfile;
    set(gcf,'userdata',us);
    end
end




drawnow
ss={'process',1};
if isfield(in,ss{1});
    drawnow;
    hh=findobj(hfig,'tag',ss{1});
    if getfield(in,ss{1})==1;          hgfeval( get(hh,'callback')  ,hh);           end
end

ss={'export',1 };
if isfield(in,'task') && strcmp(in.task,'export')
    figure(hfig);drawnow;
    hh=findobj(hfig,'tag',ss{1});
    % a2_sub([],'export',fullfile(pwd,'KK.xlsx'));
    a2_sub([],'task','export','exportfile',in.exportfile  );
end



if isfield(in,'outvar')
    if ischar(in.outvar)
        out=showresults(0,'nofig');
        assignin('base',in.outvar,out);
    end
end



if 0
    
    xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
        fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','Ttest2',...
        'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',1 ,'showsigsonly',1 ,'issort',1,'qFDR',.3));
    
    
    
    xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
        fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','ranksum',...
        'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',0 ,'showsigsonly',0 ,'issort',0,...
        'process',1,'task','export', 'exportfile',  fullfile(pwd, 'blo.xlsx')   ));
    
    xstatlabels(struct('data',fullfile(pwd,'data_cbf_allen_space.xls'),'dataSheet','mean','aux',...
        fullfile(pwd,'aux_Aged_mice_MRI_20171023.xlsx'  ),'f1design',0,'typeoftest1','ranksum',...
        'auxSheet','Tabelle1','id', 'MRI-ID','f1','GROUP','isfdr',0 ,'showsigsonly',0 ,'issort',0,...
        'process',1,'task','export', 'exportfile',  fullfile(pwd, 'blo.xlsx')   ));
    
end


% ==============================================
%%   a2_sub
% ===============================================


function a2_sub(us,varargin)
% clear;

% load us
% load us
% load us1
%  load us2


par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
if ~isfield(par,'task')    ; par.task=''; end


if strcmp(par.task,'export')
    exportfun(par);
    return
    
end



if ~isfield(us,'f1design'); us.f1design=0; end
if ~isfield(us,'f2'); us.f2=''; end
%———————————————————————————————————————————————
%%   read groupAssignment
%———————————————————————————————————————————————
[a  aa aaa]=xlsread(us.aux, us.auxSheet);
he=aaa(1,:);
he=cellfun(@(a){[ num2str(a)]},he);
us.cid=regexpi2(he,['^' char( us.id) '$']);
us.cf1=regexpi2(he,['^' char( us.f1) '$']);
us.cf2=regexpi2(he,['^' char( us.f2) '$']);



us.idf1=aaa(2:end,[us.cid us.cf1 us.cf2]);
try;
    us.idf1=strtrim(us.idf1);
catch
    us.idf1=cellfun(@(a){[  num2str(a)]} ,us.idf1);
end

us.idf1=cellfun(@(a){[ num2str(a)]} ,us.idf1); %1st column (animal-name) to string
us.idf1(find(strcmp(us.idf1(:,1),'NaN')),:)=[]; %remove NAN-rows
%———————————————————————————————————————————————
%%   read data
%———————————————————————————————————————————————
[a  aa aaa]=xlsread(us.data, us.dataSheet);
he=aaa(1,:);
ids=cellfun(@(a){[ num2str(a)]},he);

aaa(strcmp(cellfun(@(a) {[num2str(a)]}, aaa(:,1) ),'NaN'),:)=[]; %remove ending NAN-rows
aaa(1,:)=[];%remove Header


if 0
    
    xl = actxserver('excel.application'); %open activex server
    xl.visible = 0; %make things invisible
    wb = xl.Workbooks.Open(us.dataFP); %open specified xlsx file
    wbSheet1 = wb.Sheets.Item(us.dataSheet); %specify sheet
    sizsheet=size(get(wbSheet1.UsedRange,'Value'));
    rowlab=cellfun(@(a){[ 'A' num2str(a) ]},num2cell(1:sizsheet(1))');
    
    colhex={};%repmat('0',length(rowlab),6);
    for i=1:length(rowlab)
        r = wbSheet1.Range(rowlab{i});
        cx=get(r.interior,'Color');
        labx{i,1}=get(r,'text');
        rgb=mod([cx floor(cx/256) floor((cx)/256^2)],256);
        colhex{i,1}=reshape(sprintf('%02X',rgb.'),6,[]).';
        % uhelp(plog({},{['<html><body bgcolor="#' hex '">Hello<']},0,[''],'s=0'),1);
    end
    wb.Close( false ); % Close workbook (false = no prompt?)
    xl.Quit % Quit Excel
    xl.delete % Not s
    
end



%———————————————————————————————————————————————
%%   find ids of auxdata in data
%———————————————————————————————————————————————
tb=us.idf1;
tb2=tb; %copy for check
colfound=size(tb,2)+1;
imiss=zeros(size(tb,1),1);
for i=1:size(us.idf1,1)
    ixdata=find(strcmp(ids,  us.idf1{i}));
    if isempty(ixdata);
        ixdata=nan;
        imiss(i)=1;
    end
    tb(i, colfound)={ixdata};
    if ~isnan(ixdata)
        tb2(i,2) =ids(ixdata);
    else
        tb2(i,2) ={'-'};
    end
end


miss=tb(imiss==1,:);

% WORK WITH WHIS DATA
tb=tb(imiss==0,:);
% tb

%% how the data
cprintf([0 .5 0],['FILENAMES AUXDATA'  '\t']);
cprintf([0 0 1],['FILENAMES DATA'  '\n']);
cprintf([0 0 1],['====================================' '\n']);
for i=1:size(tb2)
    cprintf([0 .5 0],[tb2{i,1}  '\t']);
    cprintf([0 0 1],[tb2{i,2}  '\n']);
end

if ~isempty(miss)
    cprintf([1 0 1],['**FOLLOWING FILES WERE NOT FOUND --> (check correctness of names)' '\n']);
    cprintf([1 0 1],['=================================================================' '\n']);
    for i=1:size(miss)
        cprintf([1 0 1],[miss{i,1}  '\n']);
    end
    
end



%———————————————————————————————————————————————
%%   classes
%———————————————————————————————————————————————
if isnumeric(tb{1,2})
    tb(:,2)= cellfun(@(a){[ num2str(a)]},tb(:,2));
end
us.f1classnames =unique( (tb(:,2)'));

if size(tb,2)==4  % second factor
    if isnumeric(tb{1,3})
        tb(:,3)= cellfun(@(a){[ num2str(a)]},tb(:,3));
    end
    us.f2classnames =unique( (tb(:,3)'));
end



%———————————————————————————————————————————————
%%   pairwisecomparisons
%———————————————————————————————————————————————
comb   =combnk(us.f1classnames,2);
combstr=cellfun(@(a,b){[ a ' vs ' b]},comb(:,1),comb(:,2));


%———————————————————————————————————————————————
%%   label
%———————————————————————————————————————————————
laball=aaa(:,1);
laball=cellfun(@(a){[ num2str(a)]},laball);

if 0
%without fibretracts
ifibr=find(strcmp(laball,'fiber tracts'));
laball=laball(1:ifibr-1);
end


ilab=find(cellfun(@isempty,regexpi(laball,['NaN']))==1);


%test finding retroplenial
% ilab=find(cellfun('isempty',regexpi(laball,'Retrosplenial'))==0);
% ilab=find(cellfun('isempty',regexpi(laball,'stratum'))==0);




lab =laball(ilab);

% ==============================================
%%   load regionfile
% ===============================================
if isfield(us,'regionsfile')
    if exist(us.regionsfile)==2
        [~,~,rf]=xlsread(us.regionsfile);
        rf=cellfun(@(a){[ num2str(a)]} ,rf);
        %remove NAN-rows
        idel=find(strcmp(cellfun(@(a){[ num2str(a) ]} ,rf(:,1)),'NaN'));
        rf(idel,:)=[];
        %remove NAN-columns
        idel=find(strcmp(cellfun(@(a){[ num2str(a) ]} ,rf(1,:)),'NaN'));
        rf(:,idel)=[];
        
        %% only regions given
        if size(rf,2)==1 %
            rf(1,2)={'regionmergeID'}
            mergeID=cellfun(@(a){[ num2str(a)]} ,num2cell([1:size(rf,1)-1]'))
            rf(2:end,2)=mergeID
        end
        rf=rf(:,1:2);
        
        temp=cellfun(@(a) {[ num2str(a)]}, rf(:,1)); %determine&REMOVE NAN and empty-row
        iuse=cellfun(@isempty, regexpi(temp,'NaN')) & cellfun(@isempty, regexp(temp,'^$','emptymatch'))        ;
        rf=rf(iuse,:);
        rf(1,:)=[] ;%remove HEADER;
        
        rf=cellfun(  @(a)  {num2str(a)}      ,rf );
       % rf(find(cellfun('isempty',regexpi(rf(:,1),'Nan'))==0),:)=[];%del nans
        rf(:,2)=(cellfun(  @(a)  {str2num(a)}      ,rf(:,2) ));
        
        reg=cell2mat(rf(:,2));
        reg(isnan(reg))=0;
        ix=find(reg>0);
        uni=unique(reg); uni(uni==0)=[];
  
        % old version        
        %         regs={};       igr=1;
        %         for i=1:length(uni)
        %             idx =find(reg==uni(i))';
        %             labx=rf(idx,1);
        %             if length(idx)>1
        %                regs= [regs;  { [ '@' pnum(igr,3) ]  idx  labx}];
        %                igr=igr+1;
        %             else
        %                regs= [regs;  { labx{1}   idx  []}]; 
        %             end
        %         end
        %         us.regions=regs;
        
        % improved version
        regs={};  igr=1;
        for i=1:length(uni)
            idx0 =find(reg==uni(i))';
            
            %find label
            laboutputvec={};
            idxInDatavec=[];
            for j=1:length(idx0)
                labinput=rf(idx0(j),1);
                idxInData=find(strcmp(laball,labinput));
                laboutput=laball(idxInData);
                idxInDatavec=[idxInDatavec idxInData];
            end
            laboutputvec=laball(idxInDatavec);
            idxInDatavec=idxInDatavec(:);
            
            if ~isempty(laboutputvec)
                if length(idxInDatavec)>1
                    regs= [regs;  { [ '@' pnum(igr,3) ]  num2cell(idxInDatavec)  laboutputvec}];
                    igr=igr+1;
                else
                    regs= [regs;  { laboutputvec{1}   idxInDatavec  []}];
                end
            end
        end
        us.regions=regs;
        
        
        
        
        
    end
    
end




if isfield(us,'regions') && ~isempty(us.regions)
    lab =us.regions(:,1) ;
    try
        ilab=cell2mat(us.regions(:,2));
    catch
        ilab=(us.regions(:,2));
    end
    
    
end

us.tb=tb;
set(gcf,'userdata',us);


%———————————————————————————————————————————————
%%   display group membership
%———————————————————————————————————————————————

% tb(12:18,3)={nan}
grp=us.f1classnames;
gname={};
len=[];
nchar=[];
for i=1:length(grp)
    is=regexpi2(tb(:,2),grp(i));
    is=is(find(~isnan(cell2mat(tb(is,3)))))    ; %NANS
    dum=[tb(is,1) tb(is,2) ];
    dum=cellfun(@(a,b){[a ' (' b ')']},dum(:,1),dum(:,2));
    dum=[{['# GROUP-' grp{i} ' # (n=' num2str(length(is)) ')'] }; dum];
    gnames{1,i}=dum;
 
    len(i)=size(gnames{1,i},1);
    nchar(i)=size(char(gnames{1,i}),2);
end

ga={};
mxchar=max(nchar);
ga{end+1,1}=('____________________________________________________________________________________________');
ga{end+1,1}=('  GROUP ASSIGNMENT --> PLEASE CHECK THIS');
ga{end+1,1}=('____________________________________________________________________________________________');


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
    ga{end+1,1}=sv;
end
ga{end+1,1}=('____________________________________________________________________________________________');
disp(char(ga));

us.groupassign=ga;
set(gcf,'userdata',us);





%———————————————————————————————————————————————
%%   pairwise tests
%———————————————————————————————————————————————
htail=findobj(gcf,'tag','tail');
tail=htail.String{htail.Value}; %get Tail

% us.typeoftest1=1;  %[1]ttest2,[2]WRS
vartype=1;
us.pw={};
if us.f1design==0 %between
    
    for i=1:size(comb,1)
        
        i1=regexpi2(tb(:,2),comb(i,1));
        i2=regexpi2(tb(:,2),comb(i,2));
        str=combstr{i};
        % disp(sprintf(['groupsize ' ': %d vs %d'],[length(i1) length(i2)]));
        
        labsgrouped=repmat({''},[length(ilab) 1]) ; 

        
        if isnumeric(ilab)
            x=cell2mat(aaa(ilab,cell2mat(tb(i1,end)))) ;
            y=cell2mat(aaa(ilab,cell2mat(tb(i2,end))));
            
            %__singleData2export_____
            sid={};
            sid.info  ='single animal Data for DataExport';
            sid.dat   =num2cell([x y]);
            sid.reg   =aaa(ilab,1);
            sid.animal=[he(cell2mat(tb(i1,end))) he(cell2mat(tb(i2,end)))];
            sid.grp=[repmat(comb(i,1),[ 1 length(i1)]) repmat(comb(i,2),[ 1 length(i2)])];
            sid.tb =[ sid.grp' sid.animal' sid.dat'];
            sid.htb=['group' 'animal' sid.reg'] ;
        else
            
            %% =================merging region to be merged==============================
            x=zeros(size(ilab,1), length(i1));
            y=zeros(size(ilab,1), length(i2));
            for j=1:size(ilab,1)
                ids=ilab{j};
                
                %                 disp('-------------');
                %                 disp(aaa(ids,1));
                
                if ~isnumeric(ids);
                    ids=cell2mat(ids) ;
                end
                
                if length(ids)==1;
                    x(j,:)=cell2mat(aaa(ids,  cell2mat(tb(i1,end))));
                    y(j,:)=cell2mat(aaa(ids,  cell2mat(tb(i2,end))));
                    if isnumeric(ilab{j})
                        labsgrouped{j,1}=[''];
                    else
                        labsgrouped{j,1}=[  strjoin(aaa(ids,1),' ,')  ];% single region but addressed as "combined"-->to obtain the label in the output
                    end
                    
                else
                    
                    x(j,:)= nanmean(cell2mat(  (aaa(ids,  cell2mat(tb(i1,end))))    ),1)  ;
                    y(j,:)= nanmean(cell2mat(  (aaa(ids,  cell2mat(tb(i2,end))))    ),1)  ;
                    labsgrouped{j,1}=[  strjoin(aaa(ids,1),' ,')  ];
                end
            end
            %__singleData2export_____
            sid={};
            sid.info  ='single animal Data for DataExport';
            sid.dat   =num2cell([x y]);
            sid.reg   =us.regions(:,1) ;%aaa(ilab,1);
            sid.animal=[he(cell2mat(tb(i1,end))) he(cell2mat(tb(i2,end)))];
            sid.grp=[repmat(comb(i,1),[ 1 length(i1)]) repmat(comb(i,2),[ 1 length(i2)])];
            sid.tb =[ sid.grp' sid.animal' sid.dat'];
            sid.htb=['group' 'animal' sid.reg'] ;
            
            %% ===============================================


        end
        %disp(sprintf(['groupsize ' ': %d vs %d'],[size(x,2) size(y,2)]));
        
        if us.typeoftest1==1
            us.pw(i).type='ttest2';
            [h p ci st]=ttest2(x',y','tail',tail);
            [out outh]=getMESD(x,y,vartype);
            res=[h' p' st.tstat'  out  st.df'    ] ;
            reshead=['hyp' 'p' 'T' outh 'df'];
            %reshead={'hyp' 'p' 'T' 'ME' 'SD' 'SE'  'n1' 'n2' 'df'};
            ikeep=find(~isnan(res(:,1)));
        elseif us.typeoftest1==2
            us.pw(i).type='WRS';
            res=nan(size(x,1),[3]);
            [out outh]=getMESD(x,y,vartype);
            for j=1:size(x,1)
                try
                    [p h st]=ranksum(x(j,:),y(j,:),'tail',tail);
                    res(j,:)=[h p st.ranksum];
                end
            end
            res=[res out];
            reshead=['hyp' 'p' 'RS' outh ];
            %reshead={'hyp' 'p' 'RS' 'ME' 'SD' 'SE' 'n1' 'n2'};
            ikeep=find(~isnan(res(:,1)));
        elseif us.typeoftest1==3
            us.pw(i).type='perm';
            px= permtestmat(x',y',1000,'approximate');
            cprintf([1 0 1] ,[  'tail: only two-sided (both) hyothesis-testing supported' '\n']);
            
            [out outh]=getMESD(x,y,vartype);
            h=px<0.05;
            res=[h px out];
            reshead=['hyp' 'p'   outh ];
            %reshead={'hyp' 'p' 'ME' 'SD' 'SE' 'n1' 'n2'};
            [hv px]=ttest2(x',y');
            ikeep=find(~isnan(hv));
        elseif us.typeoftest1==4
            us.pw(i).type='perm2';
            %tic;[pv,to,cr,al]=mult_comp_perm_t2_nan(x',y',5000,0,.05); toc
            
            if strcmp(tail,'both')
                tailnum=0;
            elseif strcmp(tail,'left')
                tailnum=-1;
            elseif strcmp(tail,'right')
                tailnum=+1;
            end
            
            [p,T,cr,al]=mult_comp_perm_t2_nan(x',y',5000, tailnum  ,.05);
            h=p<0.05;
            
            [out outh]=getMESD(x,y,vartype);
            res=[h' p' T'  out       ] ;
            reshead=['hyp' 'p' 'T' outh  ];
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
          
          
%           %SHOW ALL VALUES
%           if get(findobj(findobj(gcf,'tag','stat'),'tag','showsigsonly'),'value') ==0
%               ikeep=[1:length(xex)]';
%           else %REMOVE NANS
%               ikeep=ix;
%           end
        
        
        res2=res(ikeep,:);
        us.pw(i).str   =str;
        us.pw(i).tb    =res2;
        us.pw(i).ikeep =ikeep;
        
        us.pw(i).tbhead    =reshead;
        us.pw(i).lab =lab(ikeep);
        us.pw(i).labsgrouped =labsgrouped(ikeep);
        if exist('sid')==1
        us.pw(i).sid=sid;
        end
        
    end
    set(gcf,'userdata',us);
    showresults(0);
    
end

function exportfun(par)

showresults('export',par);

function out=showresults(task, par)
warning off;
out=[];
hfig=findobj(0,'tag','stat');
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
        [pam fil ext]=fileparts(file);
        if isempty(pam); pam=pwd; end
        file=fullfile(pam,[fil '.xlsx']);
    end
    disp('..exporting.. ');
else
    doexport=0;
end

[~,fi]=fileparts(us.data);


%groupsizes
tab=tabulate(cellfun(@(a){num2str(a)}, us.tb(:,2)));
%tab=tabulate(cell2mat(us.tb(:,2)));
%     groupsize=cellfun(  @(a,b)  {['n group-' a ': '  sprintf('%2.0d',b )] }      ,tab(:,1),tab(:,2) );

grp='';
for i=1:size(tab,1)
    grp= [grp  [' "' tab{i,1} '"' '(n=' num2str(tab{i,2})  ')'] ];
end

htail=findobj(hfig,'tag','tail');
tail=htail.String{htail.Value}; %get Tail

%% SHOW RESULTS
% sz={'__________________________________________________________________________________________'};
sz={};
sz{end+1,1}=['_____________________________________________________________________________________________________________________'];
sz{end+1,1}=[' #wr                 **** [ '   fi       ' ] ****'                      ];
sz{end+1,1}=['_____________________________________________________________________________________________________________________'];


sz{end+1,1}=['FILE          : '      fi          ];
sz{end+1,1}=['Parameter     : '      us.dataSheet];
sz{end+1,1}=['groups (size) : '      grp];

sz{end+1,1}=['PAIRWISE TEST : '      us.pw(1).type];
sz{end+1,1}=['TAIL          : '      tail         ];


sz{end+1,1}=['FDR-correction: '      regexprep(num2str(us.isfdr),{'1' '0'},{'yes','no'})];

if us.isfdr==1
    sz{end+1,1}=['FDR-qValue: '      num2str(us.qFDR)];
end

% number of tests 
 for i=1:length(us.pw)
   sz{end+1,1}=  ['No of tests   : '      num2str(length(us.pw(i).ikeep))   ' for "' us.pw(i).str '"' ];
 end

sz{end+1,1}=['sorting       : '      regexprep(num2str(us.issort),{'1' '0'},{'yes','no'})];
sz{end+1,1}=['showsigsonly  : '      regexprep(num2str(us.showsigsonly),{'1' '0'},{'yes','no'})];
sz{end+1,1}='abbreviations : [p]         pvalue                          [t|RS] test-dependent test-statistic/parameter ';
sz{end+1,1}='                [Me1|Me2]   mean of group1|2                [diff] mean difference            '  ;
sz{end+1,1}='                [SD1|SD2]   standard deviation of group1|2  [SE1|SE2]   standard error of group1|2 ' ;
sz{end+1,1}='                [Med1|Med2] median of group1|2              [range1|range2] range of group1|2 ';
sz{end+1,1}='                [pVar]      pooled variance                 [SEpVar] standard error of pooled variance ';
sz{end+1,1}='                [n1|n2]     groupsize of group1|2           [df] degrees of freedom '   ;

% regionsfile
if isfield(us,'regionsfile') && ~isempty(us.regionsfile)
    sz{end+1,1}=['regionsfile   : '     '"' us.regionsfile '"'];
else
    sz{end+1,1}=['regionsfile   :      none'];
end

if isfield(us,'regions')
    igroup=regexpi2(us.regions(:,1),'@');
    if isempty(igroup)
       regsused=[us.regions(:,1)];
       if ~isempty(regsused)
           regsused=cellstr(regsused);
           sz{end+1,1}=['  .. statistic performed for the following regions only: '];
           sz=[sz; cellfun(@(a){[repmat(' ',[1 5]) '"' num2str(a) '"']} ,regsused)];
       end
    else
        for i=1:length(igroup)
            sz{end+1,1}= ['region ' us.regions{igroup(i),1}   ' -with subregions: ' us.pw(1).labsgrouped{igroup(i)}];
        end
    end
end

sz=[sz; us.groupassign];

%     sz{end+1,1}=['********************************************************************************'];
if doexport==1
    if exist(file)==2
        try;
            %!taskkill /f /im excel.exe
            evalc('system(''taskkill /f /im excel.exe'')');
        end
        try delete(filename); end
    end
     try ; delete(file); end
    xlswrite( file, sz(2:end), 'info');
end

for i=1:size(us.pw,2)
    %  i=1
    %         issort=1;
    %         showsignificantonly=1;
    %         isfdr=1;
    
    dat=[[ us.pw(i).lab] num2cell(us.pw(i).tb) ];
    head=['Label' us.pw(i).tbhead];
    
    
    if us.isfdr==1
        H=fdr_bh([dat{:,3}]',us.qFDR,'pdep','no');
        dat(:,2)=num2cell(H);
        head(2)={'hypFDR'};
    end
    
    dat(:,2)=num2cell(double(cell2mat(dat(:,2))));
    isort=[1:size(dat,1)]';
    if us.issort==1
        %             [~,isort]=sort(cell2mat(dat(:,3))) ;%sort(us.pw(i).tb(:,2));
        %             dat=dat(isort,:);
        
        [dat isort]= sortrows(dat,[3 2]);
    end
    
    if us.showsigsonly==1
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
        
        % [2] write statistic
        xlswrite( file, sx, us.pw(i).str);
        xlsAutoFitCol(file,us.pw(i).str,'A:Z');
         % [4] remove default-sheets
        try
          %  xlsremovdefaultsheets(file);
        end
        
%         % [3] write single Data
%         if isfield(us.pw(i),'sid')
%             try
%                 drawnow
%                 HT1=us.pw(i).sid.htb;
%                 T1 =us.pw(i).sid.tb;
%                 %pwrite2excel(file,{5 'singleData'}, HT1,[],T1);
%                 
%                xlswrite( file,  [HT1; T1], 'singleData');
%                xlsAutoFitCol(file,'singleData','A:Z');
%                drawnow;
%             end
%         end
       
        
    else
        
        sy=plog({},{repmat('_',[ 1 50]) ; [us.pw(i).str];repmat('_',[ 1 50]) ;},'s=0','plotlines=0');
        if isempty(dat)
            sz=[sz;sy;'ns.'];
        else
            sz=[sz;sy ];
            
            
            sx(2:end,3)=  cellfun(@(a){sprintf(' %1.4g',a)},sx(2:end,3)); % p-values other format
            
            
            
            %[~,sz]=plog(sz,sx,0,[us.pw(i).str],'s=0','plotlines=0');
            [~,sz]=plog(sz,sx,0,[us.pw(i).str],'s=0;d=5;al=1','plotlines=0');
            sz=[sz;{'  '}];
        end
        
        %         uhelp(plog({},sx,0,[us.pw(i).str],'s=0'),1);
        %sz=sz(1:end-1,:);
    end  
end

% ==============================================
%%   write xls-singleData
% ===============================================
% [3] write single Data
warning off;
%clc
if doexport==1
    T2={};
    for i=1:size(us.pw,2)
        
        if isfield(us.pw(i),'sid')
            
            try
                drawnow
                HT1=us.pw(i).sid.htb;
                T1 =us.pw(i).sid.tb;
                %pwrite2excel(file,{5 'singleData'}, HT1,[],T1);
                %disp('-----');
                %disp(T1(:,1:2));
                
                %xlswrite( file,  [HT1; T1], ['singleData ' us.pw(i).str]);
                %xlsAutoFitCol(file,'singleData','A:Z');
                drawnow;
                T2=[T2;T1 ];
                %disp(i)
            end
        end 
    end
    if ~isempty(T2)
        [~,ix]=unique(T2(:,2),'stable');
        T3=T2(ix,:);
        xlswrite( file,  [HT1; T3], ['singleData']);
        xlsAutoFitCol(file,'singleData','A:BBB');
    end
%     try
%     [~,sheetnames]=xlsfinfo(file)
%     catch
%         sheetnames=''
%     end
%     pwrite2excel(file,{length(sheetnames)+1 'singleData'},...
%         HT1,[],T3);
end
% ==============================================
%%   show table
% ===============================================

out=sz;
if doexport~=1
    %     uhelp(plog({},sz,0,[''],'s=0','plotlines=0' ),1);
    if exist('par')==1 & (strcmp(par,'nofig'))
    else
        drawnow;
        uhelp(sz,1);
    end
    
    %     assignin('base','stat',sz);
end

if doexport==1
    removexlssheet(file);
    xlsstyle(file);
    disp(['created: <a href="matlab: system('''  [file] ''')">' [file] '</a>']);
end


% x=[10 11 12 13 20];y=[11 12 15 28]
% [hh pp ci ss]=ttest2(x,y)

function [out outh]=getMESD(x,y,vartype)

% vartype=1

s2x = nanvar(x,[],2);
s2y = nanvar(y,[],2);

mx=nanmean(x,2);  %MEAN
my=nanmean(y,2);

sdx=nanstd(x,[],2); %STD
sdy=nanstd(y,[],2);

nx=sum(~isnan(x),2);% No of cases
ny=sum(~isnan(y),2);

sex=sdx./(sqrt( nx)); %SEM
sey=sdy./(sqrt( ny));

% difference = nanmean(x,2) - nanmean(y,2);
difference =mx-my; %DIFFERENCE

medx=nanmedian(x,2);%MEDIAN
medy=nanmedian(y,2);

rax=range(x,2);
ray=range(y,2);



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
    ratio = difference ./ se;
end
% out=[difference sPooled se  sum(~isnan(x),2) sum(~isnan(y),2)];

% nxv=repmat(nx(1),[length(mx) 1]); %no of cases vectorized
% nyv=repmat(nx(),[length(my) 1]);

nxv=sum(~isnan(x),2);
nyv=sum(~isnan(y),2);

outh ={'Me1' 'Me2' 'diff'  'SD1' 'SD2' 'SE1' 'SE2' 'Med1' 'Med2' 'range1' 'range2'...
    'pVar' 'SEpVar' 'ratio(diff/SEpVar)' 'n1' 'n2'};
out  =[ [mx my difference]  [sdx sdy] [sex sey] [medx medy rax ray ] [ sPooled se ratio] [nxv nyv]  ];

 


function xlsAutoFitCol(filename,sheetname,varargin)

%set the column to auto fit
%

%xlsAutoFitCol(filename,sheetname,range)
% Example:
%xlsAutoFitCol('filename','Sheet1','A:F')

options = varargin;

range = varargin{1};

[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);


sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');

ExAct = Excel.Activesheet;

ExActRange = get(ExAct,'Range',range);
ExActRange.Select;

invoke(Excel.Selection.Columns,'Autofit');

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);


function removexlssheet(filename)

% filename=[outfile '.xls']


sheetName = 'Tabelle'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)

% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(filename); % Full path is necessary!

% Delete sheets.

% Throws an error if the sheets do not exist.
try    objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;end
try   objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;end
try   objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;end

% if exist('thissheetName')
% % try
%     objExcel.ActiveWorkbook.Worksheets.Item([thissheetName]).Delete;
% % end


% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;


function xlsstyle(filename)

%

% filename='V:\Impact2Analyse\conv\exp_i2_001_all.xlsx';

% % % % [~ , sh]=xlsfinfo(filename);
% % % % e.delete;


% ==============================================
%%   xls-letter (extended, for singleTable)
% ===============================================
% ========OLD version =======================================
% let=cellstr(char(65:65+25)');
% lx=[let];
% for i=1:3
%     %cellfun(@(a,b){[a b]},let,let)
%     lx=[lx ; cellfun(@(a){[ let{i} a ]},let)       ];
% end

let=cellstr(char(65:65+25)');
lx1=[let];
for i=1:length(let)
    %cellfun(@(a,b){[a b]},let,let)
    lx1=[lx1 ; cellfun(@(a){[ let{i} a ]},let)       ];
end
twoletter=lx1(length(let)+1:end);
lx2=[];
for i=1:3
    lx2=[lx2 ; cellfun(@(a){[ let{i} a ]},twoletter)     ];
end
lx=[lx1; lx2];

% ==============================================
%%   open sheet
% ===============================================


% sheetName = 'Tabelle'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
% Open Excel file.
e = actxserver('Excel.Application');
e.Workbooks.Open(filename); % Full path is necessary!

% % % arrayfun(@(1) e.Workbooks.Sheets.Item.Name, 1:Workbooks.Sheets.Count, 'UniformOutput', false)
% % % e.Worksheets.get('Item',x).Name
% % % 1:e.Worksheets.Count

sh=arrayfun(@(x)e.Worksheets.get('Item',x).Name,  [1:e.Worksheets.Count] ,'UniformOutput', false);

% C = double(R) * 256^0 + double(G) * 256^1 + double(B) * 256^2;
% colf=@(r,g,b)double(r) * 256^0 + double(g) * 256^1 + double(b) * 256^2;

colf = @(r,g,b) r*1+g*256+b*256^2;

% c= [0.7569    0.8667    0.7765
%     1.0000    0.8000    0.8000];
% c=[1 0 0
%    0 0 1]
% c=[ 0.7294    0.8314    0.9569
%     0.8706    0.9216    0.9804];

c=[ 0.9529    0.8706    0.7333
    0.7569    0.8667    0.7765];

c=[  0    0.8000    1.0000
    0.6784    0.9216    1.0000 ];

c=c*255;
c2=[colf(c(1,1),c(1,2),c(1,3))
    colf(c(2,1),c(2,2),c(2,3))];



for i=1:length(sh)
    
    hh=sh{i};
    sheet1=e.Worksheets.get('Item', hh);
    %     sheet1=e.Worksheets.get('Item', 'RT');
    sheet1.Activate;
    % sheet1.PageSetup.Zoom = 20
    
    e.ActiveWindow.Zoom = 80;
    
    icol =sheet1.UsedRange.Columns.Count;
    irows=sheet1.UsedRange.Rows.Count;
    cells = e.ActiveSheet.Range([lx{1} '1:' lx{icol} '1']);
    % cells = e.ActiveSheet.Range('A1');
    
    set(cells.Font, 'Bold', true);
    set(cells.Interior,'Color', -4165632);
    
    for j=1:2: icol
        set(e.ActiveSheet.Range([lx{j}   num2str(1)]).Interior,'Color',c2(1,:))  ;
    end
    
    for j=2:2: icol
        set(e.ActiveSheet.Range([lx{j}   num2str(1)]).Interior,'Color',c2(2,:))  ;
    end
    
    
    if 0
        %
        %     for j=1:2: icol
        %         set(e.ActiveSheet.Range([lx{j} num2str(1)]).Interior,'Color',c2(1,:))  ;
        %     end
        for j=2:2: icol
            %         set(e.ActiveSheet.Range([lx{j} num2str(1)]).Interior,'Color',c2(2,:))  ;
            set(e.ActiveSheet.Range([lx{j} '1' ':'  lx{j} num2str(irows)  ]).Interior,'Color',c2(2,:))  ;
            %          e.Range('2:2').Select;
            %          set(e.ActiveSheet.Range([lx{j} '1' ':'  lx{j} num2str(irows)  ]).Borders.Item('xlEdgeLeft'),'LineStyle',1);
            %      set(e.ActiveSheet.Range(['c2'  ]).Borders.Item('xlEdgeLeft'),'LineStyle',1);
            set(e.ActiveSheet.Range(['c5'  ]).Borders,'Linestyle',1)
        end
        
    end
    
    %     ihead=[lx{1} '1:' lx{icol} '1'];
    %     cells.Select;
    % %  Range('A10').Select
    % % e.ActiveWindow.FreezePanes = 1;
    % set(Sheets(sheet1).range('C10'),'FreezePanes',1)
    
    e.ActiveWindow.FreezePanes = 0;
    e.Range('2:2').Select;
    e.ActiveWindow.FreezePanes = 1;
    
    %
    % e.Range(ihead).Borders.Item('xlEdgeLeft').LineStyle = 1;
    % e.Range(ihead).Borders.Item('xlEdgeLeft').Weight = -4138;
    
    
    % Delete sheets.
    
    % Throws an error if the sheets do not exist.
    % try    e.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;end
    % try   e.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;end
    % try   e.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;end
    
    
    % Save, close and clean up.
    
    
end%sheets

e.ActiveWorkbook.Save;

e.ActiveWorkbook.Close;
e.Quit;
e.delete;


%
%
%
% e = actxserver ('Excel.Application');
% e.Visible = 1;
% %eWorkbook = e.Workbooks;
% e.Workbooks.Add;
% sheet1=e.Worksheets.get('Item', 'Sheet1');
% range1 = get(sheet1,'Range','A1:EM671');
% range1.Value = arr;
% range1 = get(sheet1,'Range','C4');
% range1.Select;
% e.ActiveWindow.FreezePanes = 1;
% range1 = get(sheet1,'Range','3:3');
% range1.Select;range1.AutoFilter




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%
%  a3_listbox
%
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••



function out=a3_listbox(labx,colhex,varargin)

p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
if isfield(p,'iswait')==0; p.iswait=1; end
if isfield(p,'submit')==0; p.submit=''; end

%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————

is=find(cellfun('isempty',labx));
for i=1:length(is)
    labx(is(i))={repmat('#',[1 i])};
end

fs=7;

% ==============================================
%%   
% ===============================================

out=[];
delete(findobj(0,'tag','listselect'));
figure;
set(gcf,'menubar','none','units','norm','tag','listselect','color','w');
set(gcf,'name','Region selection','NumberTitle','off');
set(gcf,'position',[ 0.0049    0.0800    0.4000    0.8844]);
h1=uicontrol('style','listbox','units','norm','position',[0    .1 .48 .9],...
    'string','','tag','lb1','fontsize',fs);
h2=uicontrol('style','listbox','units','norm','position',[.52   .1 .48 .9],...
    'string','','tag','lb2','fontsize',fs);



% r2=cellfun(@(a,b){[['<html><body bgcolor="#' b ';fontcolor=red">' a repmat('&nbsp;',[1 size(char(labx),2)+0-length(a)] ) ]   ]},labx,colhex);
% r2=cellfun(@(a,b){[['<html><body bgcolor="#' b ';">  <p style="color:red"> &#9830 ' a repmat('&nbsp;',[1 size(char(labx),2)+0-length(a)] ) ]   ]},labx,colhex);

% r2=cellfun(@(a,b){[['<html><font color="black"> &#9830 ' ' <font color="black"> ' a repmat('&nbsp;',[1 size(char(labx),2)+0-length(a)] ) ]   ]},labx,colhex);
r2=cellfun(@(a,b){[['<html><font color="' b '"> &#9632 <font color="black"> ' a repmat('&nbsp;',[1 size(char(labx),2)+0-length(a)] ) ]   ]},labx,colhex);


set(h1,'string',r2)
% set(h1,'fontname','courier new')
% set(h1,'fontsize',10)
set(h1,'Max',2);
set(h2,'max',2);
% ==============================================
%%   
% ===============================================


% drawnow;
if 0
    jScrollPane = findjobj(h1); % get the scroll-pane object
    jListbox = jScrollPane.getViewport.getComponent(0);
    jListbox.setSelectionAppearanceReflectsFocus(0);
    %
    v2=[ 0 0 0];%color
    %         v=[ 0.98    0.98    0.98];
    v=[0.9451    0.9686    0.9490];
    % v=uisetcolor
    set(jListbox, 'SelectionForeground',java.awt.Color(v2(1),v2(2),v2(3))); % java.awt.Color.brown)
    % set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
    set(jListbox, 'SelectionBackground',java.awt.Color(v(1),v(2),v(3))); % option #2
end

set(gcf,'WindowKeyPressFcn', @keys);


b1=uicontrol('style','pushbutton','units','norm','position',[.48 .05 .1 .05],...
    'string','>','tag','b1','callback',@add,'TooltipString','add selected items');
set(b1,'position',[.48 .5 .04 .2]);

b2=uicontrol('style','pushbutton','units','norm','position',[.48 .05 .1 .05],...
    'string','<','tag','b2','TooltipString','remove selected items');
set(b2,'position',[.48 .3 .04 .2],'callback',@remove);

% b3=uicontrol('style','pushbutton','units','norm','position',[.48 .2 .05 .05],...
%     'string','cl','tag','b3');
% set(b3,'position',[.48 .2 .04 .05],'TooltipString','clear','callback',@clear);

%counters
te=uicontrol('style','text','units','norm','position',[  0  .08 .15 .02],...
    'tag','count1','string','0/0','HorizontalAlignment','left','backgroundcolor','w','foregroundcolor',[0 .5 0]);
te=uicontrol('style','text','units','norm','position',[.52  .08 .15 .02],...
    'tag','count2' ,'string','0/0','HorizontalAlignment','left','backgroundcolor','w','foregroundcolor',[0 .5 0]);

% find
te=uicontrol('style','text','units','norm','position',[0    0.06 .15 .02],...
    'string','search','HorizontalAlignment','right','backgroundcolor','w');
ed=uicontrol('style','edit','units','norm','position',[0.15 0.06 .3 .02],...
    'string','','tag','ed1','callback',@findstrx);

%OK/cancel
ed=uicontrol('style','pushbutton','units','norm','position',[.85 0.01 .1 .025],...
    'string','OK','tag','ok','callback',@ok,...
      'tooltipstr',...
      ['submit region selection' char(10) ...
          'after pressing [submit button] select [process] button in main window to analyze selected regions']);
ed=uicontrol('style','pushbutton','units','norm','position',[.6 0.01 .1 .025],...
    'string','Cancel','tag','cancel','callback',@cancel,...
      'tooltipstr','close window');

ed=uicontrol('style','pushbutton','units','norm','position', [.7 0.08 .08 .02],...
    'string','clear list','tag','clearList','callback',@clearList, 'fontsize',7,...
    'tooltipstr','clear selected list (..right panel)');

ed=uicontrol('style','pushbutton','units','norm','position', [.3 0.01 .1 .025],...
    'string','help','tag','Help_regselect','callback',@Help_regselect, 'fontsize',7,...
    'tooltipstr','help region selection');
% set(ed,'position', [.3 0.01 .1 .025]);


% 'a'
% v.labx  =labx;
% v.colhex=colhex;
v.r2    =r2;
v.id    =[1:size(labx)]';

s=v;
s.p=p;
set(gcf,'userdata',s);
set(h1,'userdata',v);


% lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');

ContextMenu=uicontextmenu;
uimenu('Parent',ContextMenu, 'Label','group objects',   'callback', {@contextfun,'group' });% ,'ForegroundColor',[0 .5 0]);
uimenu('Parent',ContextMenu, 'Label','ungroup objects',   'callback', {@contextfun,'ungroup' });% ,'ForegroundColor',[0 .5 0]);

set(h2,'UIContextMenu',ContextMenu);
counterupdate;

%% SUBMIT
if ~isempty(p.submit)
    set(findobj(findobj(0,'tag','listselect'),'tag','ok'),'string','SUBMIT');
    set(findobj(findobj(0,'tag','listselect'),'tag','cancel'),'string','close');
end


if p.iswait==1
    uiwait;
    s=get(gcf,'userdata');
    if s.isok==1
        out=3;
        out=prepareoutput;
        %           close(gcf);
    else
        out=[];
        %           close(gcf);
    end
    
end

%———————————————————————————————————————————————
%%   subs
%———————————————————————————————————————————————

function out=prepareoutput
h2=findobj(gcf,'tag','lb2');
w=get(h2,'userdata');


%find regular regions
str=get(h2,'string');

% try
s0=str;
if isempty(s0)
    out={};
else
    s0=regexprep(s0,'.*#8592','');
    t0=[regexprep(s0,{'.*>' '&nbsp;' '^\s*'},{'' '' ''})  num2cell(w.id)];
    
    
    grp=regexpi(str,'>@\d+');
    invigrp=find(cellfun('isempty',grp)==1);
    t=t0(invigrp,:);
    
    %find grouping regions
    igrp=find(cellfun('isempty',grp)==0);
    
    m=regexpi(str(igrp),'@\d+','match');
    uni=unique(cellfun(@(a){(a{1})}, m));
    tb=zeros(size(str,1),2);
    for i=1:length(uni)
        ix=find(cellfun('isempty',regexpi(str,uni(i)))==0);
        t(end+1,1:2)=[ uni(i)  {num2cell( w.id(ix)')} ];
        t(end,3)={t0(ix)};
    end
    
    out=t;
    out(find(cellfun(@isempty,regexpi(out(:,1),'^#{1,}'))==1),:);
    % catch
    %     out={};
end


function clearList(e,e2)

lb2=findobj(findobj(0,'tag','listselect'),'tag','lb2');
set(lb2,'value',[1:size(get(lb2,'string'),1)])
b2=findobj(findobj(0,'tag','listselect'),'tag','b2');
hgfeval(get(b2,'callback'));

hok=findobj(findobj(0,'tag','listselect'),'tag','ok');
hgfeval(get(hok,'callback'));


function ok(e,e2)
uiresume(gcf);
s=get(gcf,'userdata');
s.isok=1;
set(gcf,'userdata',s);

%%parse data
if ~isempty(s.p.submit)
    out=prepareoutput;
    
    hfig=findobj(0,'tag','stat');
    us=get(hfig,'userdata');
    if isempty(out)
        try
            us=rmfield(us,'regions');
        end
        try
          nregions=[ '(Nregions=' num2str(length(us.anat.labels)) ')' ] ;
        catch
          nregions='';  
        end   
        disp(['all regions deleted from selection-list .. using original List ' nregions]);
        
    else
        us.regions=out;
       
         try
          nregions=[ '(Nregions=' num2str(size(us.regions,1)) ')' ] ;
        catch
          nregions='';  
        end   
        disp(['using selection-list ' nregions]);
        
        
    end
    set(hfig,'userdata',us);
end

% disp('check:ok.function line 153');
get(findobj(0,'tag','stat'),'userdata');
disp('..hit [process] button to proceed');


% s.p.submit=['']


function  cancel(e,e2)
uiresume(gcf);
s=get(gcf,'userdata');
s.isok=0;
set(gcf,'userdata',s);

%%parse data
if ~isempty(s.p.submit)
    close(findobj(0,'tag','listselect'));
end


function counterupdate
h1=findobj(gcf,'tag','lb1');    nc1=size(h1.String,1);
h2=findobj(gcf,'tag','lb2');    nc2=size(h2.String,1);
set(findobj(gcf,'tag','count1'),'string',['# ' num2str(nc1) '/' num2str(nc1+nc2)]);
set(findobj(gcf,'tag','count2'),'string',['# ' num2str(nc2) '/' num2str(nc1+nc2)]);





function contextfun(e,e2,task)

if strcmp(task,'group')
    h2=findobj(gcf,'tag','lb2');
    va=get(h2,'value');
    li=get(h2,'string');
    symbol='&#9632';
    
    x = inputdlg('Enter Grouping Number',             'Sample', [1 50]);
    if isempty(x); return; end
    
    grp = str2num(x{:});
    if isempty(grp)
        return
%         keyboard
%         liva=li(va);
%         liva=regexprep(liva,['">@\d+' '&#9632'],'">');
    else
        liva=li(va);
        liva= regexprep(liva,['<html>@\d+'],['<html>']); %remove NUMBER
        liva= regexprep(liva,['<html>'],['<html>' '@' pnum(grp,2)]); %add NUMBER
        
    end
    li(va)=liva;
    set(h2,'string',li);
elseif strcmp(task,'ungroup')
    h2=findobj(gcf,'tag','lb2');
    va=get(h2,'value');
    li=get(h2,'string');
    liva=li(va);
        liva= regexprep(liva,['<html>@\d+'],['<html>']); %remove NUMBER
    li(va)=liva;
    set(h2,'string',li);  
end

% liva=regexprep(liva,'">@\d+_','">')

function findstrx(e,e2)
h1=findobj(gcf,'tag','lb1');
str=get(e,'string');
v=get(h1,'userdata');
if isempty(str)
    
    set(h1,'string',v.r2);
    
    return
end
li=v.r2;%get(h1,'string')
ids=find(cellfun('isempty',regexpi(li,str))==0);
tb=li(ids);
set(h1,'string',tb);
set(h1,'value',size(tb,1));


function remove(e,e2)

h2  =findobj(gcf,'tag','lb2');
val =get(h2,'value');
if isempty(val); return; end
w=get(h2,'userdata');
h1=findobj(gcf,'tag','lb1');
v=get(h1,'userdata');
if isempty(v)
    v.id=[]; v.r2={};
end
v.id = [v.id  ; w.id(val)];
v.r2 = [v.r2  ; w.r2(val)];
[~,isort]=sort(v.id);
v.id = v.id(isort);
v.r2 = v.r2(isort);

dv=w.r2(val);
% dv=dv(end)
ishow=[];
for i=1:size(dv,1)
    %    ishow(i) =find(cellfun('isempty',regexpi(v.r2,dv(i)))==0);
    ishow(i) =find(cellfun('isempty',strfind(v.r2,dv(i)))==0);
end

v.r2=regexprep(v.r2,['">@\d+' '&#8592'],'">');
set(h1,'userdata',v);
set(h1,'string',v.r2);

% newval1=find(cellfun('isempty',regexpi(v.r2,dv))==0);
% newval1=max(get(h1,'value'))
% set(h1,'value',newval1);%size(w.r2,1));
set(h1,'value',ishow);

%remove
li=get(h2,'string');
w.r2=li;
w.r2(val)    =[];
w.id(val)    =[];
set(h2,'userdata',w);
set(h2,'string',w.r2);

valnew2=val(end)+1;
if valnew2>size(w.r2,1); valnew2=size(w.r2,1);end
set(h2,'value',valnew2);
counterupdate;
uicontrol(h1);


function add(e,e2)

ed1=findobj(gcf,'tag','ed1');
if isempty(get(ed1,'string'))==0
    h1  =findobj(gcf,'tag','lb1');
    valx=get(h1,'value');
    lix=get(h1,'string');
    tb=lix(valx);
    v=get(h1,'userdata');
    set(h1,'string',v.r2);
    isel=[];
    for i=1:size(tb,1)
        isel(i)=find(cellfun('isempty',regexpi(v.r2,tb(i)))==0);
    end
    set(h1,'value',isel);
    
end


h1  =findobj(gcf,'tag','lb1');
val =get(h1,'value');
v=get(h1,'userdata');
h2=findobj(gcf,'tag','lb2');
w=get(h2,'userdata');
if isempty(w)
    w.id=[]; w.r2={};
end
w.id = [w.id  ; v.id(val)];
% w.r2 = [w.r2  ; v.r2(val)];
w.r2 = [get(h2,'string')  ; v.r2(val)];
[~,isort]=sort(w.id);
w.id = w.id(isort);
w.r2 = w.r2(isort);

dv=v.r2(val);
ishow=[];
for i=1:size(dv,1)
    %    ishow(i) =find(cellfun('isempty',regexpi(w.r2,dv(i)))==0);
    ishow(i) =find(cellfun('isempty',strfind(w.r2,dv(i)))==0);
end

set(h2,'userdata',w);
set(h2,'string',w.r2);
set(h2,'value',size(w.r2,1));

v.r2(val)    =[];
v.id(val)    =[];
set(h1,'userdata',v);
set(h1,'string',v.r2);

valnew=val(end)+1;
if valnew>size(v.r2,1); valnew=size(v.r2,1);end
set(h1,'value',valnew);


set(h2,'value',ishow);
counterupdate;
uicontrol(h2);



function keys(e,e2)



% if strcmp(e2.Key,'g')
%     contextfun([],[],1);
% elseif strcmp(e2.Key,'f')
%     uicontrol(findobj(gcf,'tag','ed1'));
% end

if strcmp(e2.Character,'+')
    h1=findobj(gcf,'tag','lb1'); fs=get(h1,'fontsize'); set(h1,'fontsize',fs+1);
    h2=findobj(gcf,'tag','lb2'); set(h2,'fontsize',fs+1);
elseif strcmp(e2.Character,'-')
    h1=findobj(gcf,'tag','lb1'); fs=get(h1,'fontsize');if fs>2; fs=fs-1; end ;set(h1,'fontsize',fs);
    h2=findobj(gcf,'tag','lb2'); set(h2,'fontsize',fs);
end





function loadregions(e,e2)
us=get(gcf,'userdata');
[fi pa]=uigetfile(pwd,'select regionsfile (excel)','*.xls');
if pa==0; 
  try; us=rmfield(us,'regions');end
  try; us=rmfield(us,'regionsfile');end
  set(gcf,'userdata',us);
    return; 
end
regionsfile=fullfile(pa,fi);

% us.dataFP    =fullfile(pa,fi);
us.regionsfile=regionsfile;
set(gcf,'userdata',us);




function xhelp(e,e2)
uhelp(mfilename);

function Help_regselect(e,e2)
w=preadfile('xstatlabels.m'); w=w.all;
i1=max(regexpi2(w,'anker_Help_regselect_start'));
i2=max(regexpi2(w,'anker_Help_regselect_stop'));
w=w(i1+1:i2-1);
uhelp(w,1);


return
%% anker_Help_regselect_start
% #bo REGION SELECTION
% select regions from left listbox (LB) via [>] button
% selected regions appear in the right LB
% deselect regions via [<] button
% #r GROUP REGIONS
% (1) select regions in right LB ..use right context menu-> "group regions"
% (2) enter a number (1-99) as indicator for the grouped regions
% #r UNGROUP REGIONS
% (1) select regions in right LB ..use right context menu-> "ungroup regions"
% #b SUBMIT
% Use [SUBMIT] button (main window) to submit the selected regions. 
% Thereafter, click [Prosess]-button to analyze the selected regions.
%
% #b Clear LIST
% clears the selected list
% #m If you want to analyze the original regions instead of selected regions, 
% #m hit the [Clear LIST] button or 
% #m clear the right LB manually and hit the [submit]-button.
 

%
%% anker_Help_regselect_stop




function codesnippet(e,e2)

w=preadfile('xstatlabels.m'); w=w.all;
i1=max(regexpi2(w,'anker_codesnippet_start'));
i2=max(regexpi2(w,'anker_codesnippet_stop'));
w=w(i1+1:i2-1);
uhelp(w,1);


return
%% anker_codesnippet_start

% #ry CODE SNIPPET to validate the OUTPUT of a region or a combination of regions
%% % copy the below lines and modify the "MUST BE MODIFIED" inputs accordingly
% ================================================================

clear

%% % DATA ======================================
dfile      ='adc_labels_other_both_28May2020_10-35-56.xlsx'; % MUST BE MODIFIED: THE DATA-FILE
sheet2read ='median';                    % MUST BE MODIFIED: THE SHEETNAME
[~,~,dx]   =xlsread(dfile,sheet2read );
dx(strcmp(cellfun(@(a) {[num2str(a)]}, dx(:,1) ),'NaN'),:)=[]; %remove empty rows
hd =dx(1,:);    %header
d  =dx(2:end,:); %data

%% % AUX-FILE ======================================
auxfile='Manuskript_IL6_sham_group_ assignment.xlsx'; % MUST BE MODIFIED: THE NAME OF THE GROUP-FILE (EXCEL-FILE)
[a asheet]=xlsfinfo(auxfile);
[~,~,ax]=xlsread(auxfile,'Tabelle1' );    % MUST BE MODIFIED: THE SHEETNAME

%% % GROUP DEFINITION ======================================
ig1=find(strcmp(ax(:,2),'A'));     % MUST BE MODIFIED: THE COLUMN AND CLASS-LABEL IN EXCELFILE 
ig2=find(strcmp(ax(:,2),'B'));     % MUST BE MODIFIED: THE COLUMN AND CLASS-LABEL IN EXCELFILE 
s.g1=ax(ig1,1);
s.g2=ax(ig2,1);
s.info={'g1..A; g2..B'};
s.length=[ length(s.g1)  length(s.g2) ];

% get groupassignment of animals
s.ic='grp-columIDX in d/hd'
s.ic1=find(ismember(hd,s.g1));
s.ic2=find(ismember(hd,s.g2));

%% % LABEL ======================================
%% #yk use either option-A: single region or option-B: combination of region

% OPTION-A: GET DATA FROM SINGLE LABEL (chose either option-A or option-B)
label='R_Globus_pallidus_external_segment';     % MUST BE MODIFIED: THE REGION-NAME TO TEST

% OPTION-B: GET DATA FROM COMBINED LABELS (chose either option-A or option-B)
if 0
    label={ ...
        'R_Central_amygdalar_nucleus'
        'R_Medial_amygdalar_nucleus'};             % MUST BE MODIFIED: THE REGION-NAME TO TEST
end
   
label=cellstr(label);
if size(label)==1
    il=find(strcmp(d(:,1),label));
    labeltag=['SINGLE REGION: ' label{1}];
else
    il=find(ismember(d(:,1),label));
    labeltag=['AVERAGE OVER REGIONS: ' strjoin(label,' & ')];
end


% get data (average )
d1= mean(cell2mat(d(il,s.ic1))',2);
d2= mean(cell2mat(d(il,s.ic2))',2);

disp('--------------------------------------------------------');
disp(['file   : '  dfile]);
disp(['sheet  : '  sheet2read ]);
disp('--------------------------------------------------------');
disp(['label  : ' labeltag]);
disp(['N  1,2 : '   num2str([length(d1)    length(d2)]) ]);
disp(['ME 1,2 : '   num2str([mean(d1,1)    mean(d2,1)]) ]);
disp(['SD 1,2 : '   num2str([std(d1,[],1) std(d2,[],1)]) ]);

% [h,p,~,st]=ttest(d1,d2);%pared-Ttest
[h,p,~,st]=ttest2(d1,d2);%2sample-Ttest
disp(['2sampleTtest(g1,g2) p,T: '   num2str([ p st.tstat ]) ]);

%% % ============================================================
%% % EXAMPLE OUTPUT: SINGLE REGION
%% % --------------------------------------------------------
% file   : adc_labels_other_both_28May2020_10-35-56.xlsx
% sheet  : median
% --------------------------------------------------------
% label  : SINGLE REGION: R_Globus_pallidus_external_segment
% N  1,2 : 6  7
% ME 1,2 : 0.00066861   0.0006667
% SD 1,2 : 1.0519e-05  9.3157e-06
% 2sampleTtest(g1,g2) p,T: 0.73414     0.34837

%% % ============================================================
%% % EXAMPLE OUTPUT: AVERAGE OF COMBINED REGIONS
%% % --------------------------------------------------------
% file   : adc_labels_other_both_28May2020_10-35-56.xlsx
% sheet  : median
% --------------------------------------------------------
% label  : AVERAGE OVER REGIONS: R_Central_amygdalar_nucleus & R_Medial_amygdalar_nucleus
% N  1,2 : 6  7
% ME 1,2 : 0.00071718  0.00070321
% SD 1,2 : 1.6064e-05  1.5781e-05
% 2sampleTtest(g1,g2) p,T: 0.14288      1.5779


%% anker_codesnippet_stop



function xbatch(e,e2)

h=findobj(0,'tag','stat');
u=get(h,'userdata');

v=[];
try; v.data = char(u.data)           ;catch v.data=''      ; end

d=findobj(h,'tag','popdatasheet'); li=get(d,'string'); va= get(d,'value');
try ; v.dataSheet = li{va}           ;catch v.dataSheet = ''; end

try; v.aux = char(u.aux)             ;catch    ;v.aux = ''  ; end 

d=findobj(h,'tag','popdauxsheet'); li=get(d,'string'); va= get(d,'value');
try v.auxSheet = li{va}             ;catch;   v.auxSheet =''; end

d=findobj(h,'tag','popID'); li=get(d,'string'); va= get(d,'value');
try; v.id = li{va}                  ;catch;   v.id =''; end  ;

d=findobj(h,'tag','popgroupF1'); li=get(d,'string'); va= get(d,'value');
try; v.f1 = li{va}                  ;catch;   v.f1 =''; end  ;


v.f1design= get(findobj(h,'tag','F1design'),'value');

d=findobj(h,'tag','typeoftest1'); li=get(d,'string'); va= get(d,'value');
v.typeoftest1 = li{va}      ;

d=findobj(h,'tag','tail'); li=get(d,'string'); va= get(d,'value');
v.tail = li{va}      ;

try
v.regionsfile=char(u.regionsfile);
catch
v.regionsfile='';
end
    


v.qFDR         = str2num(get(findobj(h,'tag','qFDR'),'string'));
v.isfdr        =        (get(findobj(h,'tag','isfdr'),'value'));
v.showsigsonly =        (get(findobj(h,'tag','showsigsonly'),'value'));
v.issort       =        (get(findobj(h,'tag','issort'),'value'));

v.process   = 0;
% v.dums='%commment"'
% v.dum2='erde="heute=9"'

v2=struct2list(v);
iq=regexpi(v2,'=');

ip=cell2mat(cellfun(@(a){min(a)},iq));
imax=max(ip);

helps={...
    'data'        '% % excel data file'
    'dataSheet'   '% % sheetname of excel data file'
    'aux'         '% % excel group assignment file'
    'auxSheet'    '% % sheetname of excel group assignment file'
    'id'          '% % name of the column containing the animal-id in the auxSheet'
    'f1'          '% % name of the column containing the group-assignment in the auxSheet'
    'f1design'    '% % type of test: [0]between, [1]within'
    'typeoftest1' '% % applied  statistical test (such as "ranksum" or "ttest2")'
     'tail'        '% %  Type of alternative hypothesis: both|left|right '
    'regionsfile' '% % <optional> excelfile containing regions, only this regions will be tested'
    'qFDR'        '% % q-threshold of FDR-correction (default: 0.05)'
    'isfdr'       '% % use FDR correction: [0]no, [1]yes'
    'showsigsonly' '% % show significant results only:  [0]no, show all, [1]yes, show signif. results only' 
    'issort'      '% % sort results according the p-value: [0]no, [1]yes,sort '
    'process'     '% % calculate statistic [0]no, [1]yes, (simulates pressing the [process]-button) '
    };   

if 1 %remove "process"
    idel=regexpi2(helps(:,1),'process');
    helps(idel,:)=[];
    v2(idel)=[];
    
end

v3=v2;
for i=1:size(v2,1)
    ipo=regexpi(v2{i},'=','once');
   v3{i}= regexprep(v2{i},'=',[repmat(' ',1,(imax+1)-ip(i)) '=  '],'once' );
end
nwid=size(char(v3),2);
for i=1:size(v2,1)
   v3{i}=[v3{i}   repmat(' ',[1 nwid-length(v3{i})+1]) helps{i,2}];
end

% v4=['% #by [xstatlabels.m] '; 'v = [];' ; v3;  'xstatlabels(v);     % % RUN statistic';];
%  uhelp(v4,1);
%% ===============================================

code=[...
    {'% #by [xstatlabels.m] '}
    'v = [];'
    v3
    'xstatlabels(v);      % % SET all Parameter   ';
    'xstatlabels(''run'');  % % RUN statistic';
    ' '
    '% % OPTTIONAL: export results as excelfile:'
    '% xstatlabels(''export'',''file'',''myFILENAME.xlsx''); % % Export excelfile (enter proper filename for "myFILENAME" such as fullfile(pwd,''result_123.xlsx'')) ';
    ];
uhelp(code,1);
%% ===============================================






%         xstatlabels(struct(...
%         'data','O:\data2\x02_maglionesigrist\adc_native_space_ALL.xls',...
%         'dataSheet','mean',...
%         'aux',fullfile(pwd,'#groups_Aged_mice_MRI_20171023.xlsx'  ),...
%         'f1design',0,'typeoftest1','ttest2',...
%         'auxSheet','Tabelle1',...
%         'id', 'MRI-ID','f1','GROUP',...
%         'isfdr',1 ,'showsigsonly',0 ,...
%         'issort',1,'qFDR',0.05,'process',1,'outvar','sx',...
%         'regionsfile', fullfile(pwd,'#myRegions_test.xls'  )  )  );


% pp=struct(...
%         'data','O:\data2\x02_maglionesigrist\adc_native_space_ALL.xls',...
%         'dataSheet','mean',...
%         'aux',fullfile(pwd,'#groups_Aged_mice_MRI_20171023.xlsx'  ),...
%         'f1design',0,'typeoftest1','ttest2',...
%         'auxSheet','Tabelle1',...
%         'id', 'MRI-ID','f1','GROUP',...
%         'isfdr',1 ,'showsigsonly',0 ,...
%         'issort',1,'qFDR',0.05,'process',1,'outvar','sx',...
%         'regionsfile', fullfile(pwd,'#myRegions_test.xls'  )  )  


function processpost(varargin)
argin=['task' varargin{1}];
p=cell2struct(argin(2:2:end),argin(1:2:end),2);

if strcmp(p.task,'export') %export data
    if isfield(p,'file')
        p.exportfile=p.file;
        p=rmfield(p,'file');
    end
    
    if isfield(p,'sigonly')
        hf=findobj(0,'tag','stat');
        hb=findobj(hf,'tag','showsigsonly');
        set(hb,'value',p.sigonly);
        
        u=get(hf,'userdata');
        u.showsigsonly=p.sigonly;
        set(hf,'userdata',u)
    end
    out=showresults('export', p);
elseif strcmp(p.task,'run') || strcmp(p.task,'process') %
    process();
end


function  scripts_call(e,e2)


scripts={...
    'sc_regionbasedStatistic.m'
    'sc_regionbasedStatistic_severalImages.m'
    'sc_regionbasedStatistic_severalImages_ROI.m'
    };
scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name','scripts: region-based statistic','closefig',1,'scripts',scripts)
% scripts_gui(gcf, 'pos',[0 0 1 1],'name','scripts: region-based statistic','closefig',1,'scripts',scripts)



