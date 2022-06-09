
% #lk xnewgroupassignment.m
% create new group assignments by merging/combining different groups  
% the output are new group-assignment-file(s) ..(EXCELFILES!) 
% -the resulting excel-files (new group-assignment files) can be used as group-definition for:
%  [DTIstat.m] --> statistic of DTI-connectome/metric
%  [xstat.m]   --> voxelwise statistic of images
%  [xstatlabels.m] --> regionwise statistic of images
% 
%% #ma ___MANDATORY_INPUT____
% Excelfile containing the animals and group-assignment in the 1st-SHEET
% arbitrary sheetname of the 1st sheet
% with ONE header ROW (arbitrary headerLabels):
% 1st column: animal names
% 2nd column: group to which group belong the animal
%-------------------------------------------------------------------------------
% #g __EXAMPLE group-assignmen-file (EXCELFILE,SHEET-1)
% MRI-ID	                   group                    
% 20210831CH_Exp7_010009	   30minMCAO_dMCAO
% 20210831CH_Exp7_010011	   30minMCAO_dMCAO
% 20210831CH_Exp7_010012	   30minMCAO_dMCAO
% 20210901CH_Exp7_001000	   30minMCAO_dMCAO
% 202100901CH_Exp7_009989	   30minMCAO_sham
% 202100901CH_Exp7_009990	   sham_dMCAO
% 202100901CH_Exp7_009999	   30minMCAO_dMCAO
% 20210901CH_Exp7_010002	   sham_sham
% 20210901CH_Exp7_010013	   30minMCAO_dMCAO
% 20210901CH_Exp7_010017	   30minMCAO_dMCAO
% 20210901CH_Exp7_010018	   sham_dMCAO
% 20210901CH_Exp7_010019	   30minMCAO_sham
% 20210901CH_Exp7_010020	   sham_dMCAO
% 20210902CH_Exp7_009994	   30minMCAO_sham
% 20210902CH_Exp7_009996	   30minMCAO_sham
% 20210902CH_Exp7_009997	   30minMCAO_dMCAO
% 20210902CH_Exp7_009998	   sham_dMCAO
% 20210902CH_Exp7_010006	   sham_sham
% 20210902CH_Exp7_010022	   sham_sham
% 20210902CH_Exp7_010023	   30minMCAO_dMCAO
% 20210902CH_Exp7_010024	   sham_dMCAO
% 20210902CH_Exp7_010021	   30minMCAO_sham
% ...
% 20211217CH_Exp8_010200	   sham_dMCAO
% 20211217CH_Exp8_010207	   30minMCAO_dMCAO
% ...
%-------------------------------------------------------------------------------
% #g This example contains 4 DIFFERENT GROUPS {30minMCAO_dMCAO,30minMCAO_sham,sham_dMCAO sham_sham} 
%
%% #ba __NEW GROUP COMPARISONS___
% The idea here is to create new group-comparisons by merging/joining groups:
% The #r " vs. "  (space+vs.+space) #n is used to split group-1 (left) from group-2 (right)
% Use #r round brackets "(" ")" and &-symbol #n when merging several subgroups into one group
% 
% #g __SUBGROUP-EXAMPLES based on the EXAMPLE-group-assignmen-file:
% 30minMCAO_dMCAO vs. 30minMCAO_sham                  
% 30minMCAO_dMCAO vs. sham_dMCAO
% 30minMCAO_dMCAO vs. sham_sham
% 30minMCAO_sham vs. sham_sham
% 30minMCAO_sham vs. sham_dMCAO
% sham_dMCAO vs. sham_sham
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_dMCAO 
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_sham 
% (30minMCAO_dMCAO & sham_dMCAO) vs. sham_sham       
% (30minMCAO_dMCAO & sham_dMCAO) vs. 30minMCAO_sham
% (30minMCAO_sham & sham_dMCAO) vs sham_sham
% (30minMCAO_sham & sham_dMCAO) vs 30minMCAO_dMCAO
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. (sham_dMCAO & sham_sham)
% (30minMCAO_dMCAO & sham_dMCAO) vs. (30minMCAO_sham & sham_sham)
% (30minMCAO_dMCAO & 30minMCAO_sham & sham_dMCAO) vs. sham_sham      
% 
% #g __example description_
% "30minMCAO_dMCAO vs. 30minMCAO_sham"  
% #g  --> compare 30minMCAO_dMCAO against 30minMCAO_sham
% "(30minMCAO_dMCAO & 30minMCAO_sham & sham_dMCAO) vs. sham_sham"       
% #g  --> compare group-1 consisting of "30minMCAO_dMCAO" and "30minMCAO_sham" and "sham_dMCAO" 
% #g      against  group-2 ("sham_sham")
% 
% 
% -The group-comparison can be stored as txt-file or excelfile (1st sheet, 1st column, header is assumed)
%  and load into the GUI
% 
%% #cb ============================================================
%% #wb [1] WORKING WITH THE GUI ...no inputs                      
%% #cb ============================================================
% #b [load groupfile] #n : Load the group-assignment file ...#m see mandatory input
%                 -this is the first step
% 
% The left listbox displays the available groups (as specified in the group-assignment file)
% Select one/more groups from the left listbox and hit #b [add SG1]-button #n to assing these
% groups to subgroup-1. Do the same for other groups to add these groups to subgroup-2 via
% the #b [add SG1]-button #n
% this step can be sone sequentially.
% 
% #b [clear] #n      : clear list of subgroup-1 or subgroup-2
% #b [clear item] #n : clear selected item(s) in list of subgroup-1 or subgroup-2
% 
% #g EXAMPLE
% First we assign subgroup-1:
% "30minMCAO_dMCAO" was selected from left listbox --> than [add SG1]-button clicked
% "30minMCAO_sham" was selected from left listbox --> than [add SG1]-button clicked
% the listbox for subgroup-1 now contains two items:  "30minMCAO_dMCAO" and "30minMCAO_sham"
% than t we assign subgroup-2:
% "sham_dMCAO" was selected from left listbox --> than [add SG2]-button clicked
% "sham_sham" was selected from left listbox --> than [add SG2]-button clicked
% the listbox for subgroup-2 now contains two items:  "sham_dMCAO" and "sham_sham"
% 
% #b [submit] #n      : submit comparison (subgroup-1 vs subgroup-2) to lower listbox
%           
% #g for our example the lower listbox now contains: "(30minMCAO_dMCAO & 30minMCAO_sham) vs. (sham_dMCAO & sham_sham)"
%
% we can now create new group-comparisons by joining other groups for subgroup-1 and subgroup-2
% and pressing the submit-button
% 
% #b [load groupcomparison] #n : - if we already have such a list #r (see __NEW GROUP COMPARISONS___ above)
%                        this list can be loaded.
%                      -The list must be stored as:
%                          #r excel-file (*.xls or *.xlsx):
%                            -in 1st sheet
%                            -1st column contain the list of comparisons
%                            -each row is a comparison
%                            -header is assumed
%                          #r txt-file (*.txt or *.dat)
%                          -each row is a comparison
%           
% #m PLEASE AVOID SPACES IN THE GROUPNAMES
% #g example: a textfile "group-comparisons.txt" contains the following list of comparisons
% 30minMCAO_sham vs. sham_dMCAO
% sham_dMCAO vs. sham_sham
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_dMCAO 
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_sham 
% (30minMCAO_dMCAO & sham_dMCAO) vs. sham_sham       
% (30minMCAO_dMCAO & sham_dMCAO) vs. 30minMCAO_sham
% (30minMCAO_sham & sham_dMCAO) vs sham_sham
% (30minMCAO_sham & sham_dMCAO) vs 30minMCAO_dMCAO
% (30minMCAO_dMCAO & 30minMCAO_sham) vs. (sham_dMCAO & sham_sham)
% (30minMCAO_dMCAO & sham_dMCAO) vs. (30minMCAO_sham & sham_sham)
% (30minMCAO_dMCAO & 30minMCAO_sham & sham_dMCAO) vs. sham_sham
% 
% -if loaded the group comparisons appear in the lower listbox
% -use #b [clear] or [clear item] #n next to the lower listbox to clear the list or clear selected item(s)
% 
% Use context-menu of the lower listbox (group-comparison list) to save the group-comparison list
%  as text-file. This text-file can be than used to re-load the group-comparisons:
%             - via #b [load groupcomparison] #n  or
%             - file-assigned to field: "z.subgroupfile"
% 
% #b [outdir] #n -(editfield) name of the output-directory (shortname!) where the new group-assignment
%                 files will be stored
%                -default name "group"
%                -if a project is loaded the base-path is the studypath..thus the outputidrectory is: 
%                   .../mystudy/group
%                -if no project is loaded the base-path is pwd..thus the outputidrectory is: 
%                       .../{pwd}/group
% 
% #b [prefix] #n  -(editfield) add prefix to the filename of the new group-assignment files
%                 -default: 'gr_'
%                 -prefix is recommended as this is easier to select the files for later analysis
% 
% #b [prefix index] #n -(radio) add ascending index after prefix to the filename of the new group-assignment files
%                      -this is usefull if you have more than one group-comparison in the list
%                 -default: [x]
% #b [all compariosns] #n -(radio) create new group-comparison files for ...
%                           [x] all comparisons in lower listbox or
%                           [ ] current selected items
%                 -default: [x]
%                 
% #b [simulate] #n -just simulate ..i.e do not write results, but show results
%                [0] excelfiles will be written
%                [1] group-comparison (animals+counts) displayed in help-window
%                    excelfiles are not written
%       
% #b [Proceed] #n - Process.. i.e create group-assignment files from items in lower listbox
%              if [simulate] is [ ]: store group-assignment files as xls-files in the "outdir" folder
%              if [simulate] is [x]: display content of group-assignment files
% 
% #b [Close] #n - close GUI 
% 
%               
% 
% 
%% #cb ============================================================
%% #wb [2] WORKING WITH THE GUI ...with inputs                      
%% #cb ============================================================
% 
% xnewgroupassignment(1,z);  where z is a struct with optional input-arguments
% 
%% #g ____example-1 _____
% z=[];
% z.groupfile                = fullfile(pwd,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx'); % % group-assignment file to load
% xnewgroupassignment(1,z);          ; % %  open GUI with sessings, all other changes then via GUI 
% 
% 
%% #g ____example-2 _____
% z=[];
% z.groupfile    = fullfile(pwd,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx'); % % group-assignment file to load
% z.subgroupfile = 'F:\data5\makeSubgroups\subgroupList.xlsx'; % %  a file containing group-comparisons
% z.prefix       = 'gr_'       ; % % change file-prefix
% z.outdir       = 'group'     ; % % change outdir
% z.prefixindex  = 1           ; % % yes, use index in filename-prefix
% z.processindex = 2           ; % % indices of comparisons to process: ['all' or inf] or vecor/index
% z.simulate     = 0           ; % % simulate: [1] yes; [0] no write data
% xnewgroupassignment(1,z);    ; % % open GUI with settings --> only need is to hit [OK]-button 
% 
%% #g ____example-3: group-comparison list is defined on the fly (subgrouplist), files for allcomparisons created
% z=[];                                                                                                                                                                                                                                
% z.groupfile    = 'F:\data5\makeSubgroups\2021_Exp7_Exp8_Reinfarkte_groups.xlsx';          % % group-assignment file (excel)                                                                                                          
% z.outdir       = 'group';                                                                 % % output-directory (shortname)                                                                                                           
% z.prefix       = 'gr_';                                                                   % % filename-prefix of the new group-comparison file                                                                                       
% z.prefixindex  = [1];                                                                     % % use numeric index infilename-prefix of the new group-comparison file                                                                   
% z.processindex = [Inf];                                                                   % % index to from group-comparison list to process; us [inf, 'all'] to process all otherwise use a vector of indices such as [1] or [1:3 5]
% z.simulate     = [0];                                                                     % % simulate output: [1] simulate only, show data in window; [0] write data                                                                
% z.subgrouplist = { '30minMCAO_dMCAO vs. 30minMCAO_sham'                                   % % list of group comparisons                                                                                                              
%                  '30minMCAO_dMCAO vs. sham_dMCAO'                                                                                                                                                                                    
%                  '(30minMCAO_dMCAO & 30minMCAO_sham) vs. (sham_dMCAO & sham_sham)' };                                                                                                                                                
% xnewgroupassignment(1,z); 
% 
%% #cb ============================================================
%% #wb [3] COMMANDLINE
%% #cb ============================================================
% 
% xnewgroupassignment(0,z);  where z is a struct with optional input-arguments
% 
% 
%% #g ____example-1: create files for the first two group-comparions from list _____
% z=[];
% z.groupfile    = fullfile(pwd,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx'); % % group-assignment file to load
% z.subgroupfile = 'F:\data5\makeSubgroups\subgroupList.xlsx' ; % %  a file containing group-comparisons
% z.prefix       = 'gr_'       ; % %  change file-prefix
% z.outdir       = 'group'     ; % %  change outdir
% z.prefixindex  = 1           ; % %  yes, use index in filename
% z.processindex = [1 2]       ; % %  indices of comparisons to process: ['all' or inf] or vecor/index
% z.simulate     = 0           ; % %  simulate: [1] yes; [0] no write data
% xnewgroupassignment(0,z);    ; % %  without GUI  
% 
%% #g ____example-2: create files for the  all group-comparions from list _____
% z=[];
% z.groupfile    = fullfile(pwd,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx'); % % group-assignment file to load
% z.subgroupfile = 'F:\data5\makeSubgroups\subgroupList.xlsx' ; % %  a file containing group-comparisons
% z.prefix       = 'gr_'       ; % %  change file-prefix
% z.outdir       = 'group'     ; % %  change outdir
% z.prefixindex  = 1           ; % %  yes, use index in filename
% z.processindex = inf         ; % %  indices of comparisons to process: ['all' or inf] or vecor/index
% z.simulate     = 0           ; % %  simulate: [1] yes; [0] no write data
% xnewgroupassignment(0,z);    ; % %  without GUI  
% 
%% #g ____example-3: group-comparison list is defined on the fly (subgrouplist), files for allcomparisons created
% z=[];                                                                                                                                                                                                                                
% z.groupfile    = 'F:\data5\makeSubgroups\2021_Exp7_Exp8_Reinfarkte_groups.xlsx';          % % group-assignment file (excel)                                                                                                          
% z.outdir       = 'group';                                                                 % % output-directory (shortname)                                                                                                           
% z.prefix       = 'gr_';                                                                   % % filename-prefix of the new group-comparison file                                                                                       
% z.prefixindex  = [1];                                                                     % % use numeric index infilename-prefix of the new group-comparison file                                                                   
% z.processindex = [Inf];                                                                   % % index to from group-comparison list to process; us [inf, 'all'] to process all otherwise use a vector of indices such as [1] or [1:3 5]
% z.simulate     = [0];                                                                     % % simulate output: [1] simulate only, show data in window; [0] write data                                                                
% z.subgrouplist = { '30minMCAO_dMCAO vs. 30minMCAO_sham'                                   % % list of group comparisons                                                                                                              
%                  '30minMCAO_dMCAO vs. sham_dMCAO'                                                                                                                                                                                    
%                  '(30minMCAO_dMCAO & 30minMCAO_sham) vs. (sham_dMCAO & sham_sham)' };                                                                                                                                                
% xnewgroupassignment(0,z); 



function xnewgroupassignment(isGui,z)

warning off;
% clc;

%% ===============================================
if 0
    %% ===============================================
    z=struct();
    z.groupfile=fullfile(pwd,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx');
    z.prefix='gr_';
    z.outdir='group'
%     z.subgroupfile='F:\data5\makeSubgroups\subgroupList.xlsx';
%     z.subgroupfile=fullfile(pwd,'groupcomparisons.txt');
    z.prefixindex=1;
    z.processindex=2 % [all or inf] or vecor/index
    z.simulate=0;
    xnewgroupassignment(1,z);
    %% ===============================================
    
end

%% ======= [input]================================
if exist('isGui')~=1; isGui=1; end
if usejava('desktop')==0; isGui=0;; end %no graphics support


if any(ismember([1 0],isGui))==0
    error('"isGui" must be either [1] or [0];');
    return
end

% ==============================================
%%   merge parameter
% ===============================================
p.prefixindex=1;
p.prefix     ='gr_';
p.outdir     ='group';
p.processindex=inf;
p.simulate    =0;
% ----internal-
p.iswait      =0;  %  [1] busy state..wait for clickint [ok/cancel],  [0]no wait-state
p.isdesktop   = usejava('desktop');

if nargin==2
    z=catstruct(p,z);
else
    z=p;
end


%% ===============================================



u.dummy=1;
if isGui==1
    makefig(u);
    if exist('z')==1
        prepgui(z);
    end
elseif isGui==0
    z.isGui=0;
    process(z);
end

% ==============================================
%%   prepare gui
% ===============================================
function prepgui(z)
hf=findobj(0,'tag','makeSubgroups');
if isfield(z,'groupfile') && exist(z.groupfile)==2
    loadgroupassignment_cb([],[],z.groupfile);
end
if isfield(z,'prefix') && isempty(char(z.prefix))==0
    set(findobj(hf,'tag','prefix'),'string',z.prefix);
end
if isfield(z,'outdir') && isempty(char(z.outdir))==0
    set(findobj(hf,'tag','outdir'),'string',z.outdir);
end

if isfield(z,'subgroupfile') && isempty(char(z.subgroupfile))==0 && exist(z.subgroupfile)==2
    z=load_subgroupfile(z);
    hb=findobj(hf,'tag','lb_final');
    set(hb,'string',z.subgrouplist);
end
if isfield(z,'subgrouplist') && isempty(char(z.subgrouplist))==0
    hb=findobj(hf,'tag','lb_final');
    set(hb,'string',z.subgrouplist);
end

if isfield(z,'prefixindex') && isnumeric(z.prefixindex)
    hb=findobj(hf,'tag','prefixnum');
    set(hb,'value',z.prefixindex);
end

if isfield(z,'processindex')
    selall=1;
    hb=findobj(hf,'tag','allcomparisons');
    if isnumeric(z.processindex)
        if ~isinf(z.processindex)
            selall=0;
        end
    end
    set(hb,'value',selall);
    
end

if isfield(z,'simulate')
    hb=findobj(hf,'tag','simulate');
    set(hb,'value',z.simulate);
    
end


u=get(hf,'userdata');
if isfield(z,'subgroupfile')
    u.subgroupfile=z.subgroupfile;
end
set(hf,'userdata',u);


finalLB_countcomparisons();
%% =====wait gui==========================================
if z.iswait==1
   uiwait(gcf); 
end

function makefig(u);

%===================================================================================================
% ==============================================
%%   make subgroups
% ===============================================



delete(findobj(0,'tag','makeSubgroups'));
hf=figure('color','w','tag','makeSubgroups','name',[mfilename '.m' ],'menubar','none',...
    'units','norm','position',[0.3285    0.3389    0.3826    0.3367],...
    'numbertitle','off');

% =========[load groupfile]======================================
hp=uicontrol('style','pushbutton','string','load groupfile','units','norm');
set(hp,'position',[[0.0090027 0.94542 0.15 0.05]]);
set(hp,'callback',{@loadgroupassignment_cb,[]});
set(hp,'fontweight','bold');
set(hp,'tooltipstring',['<html><b>load group-assignment file (excel)</b><br>'...
    ' excelfile contains: <br>'...
    '   column-1: animal-IDS <br>'...
    '   column-2: group-names ' ]);


% =========[load groupcomparisons]======================================
hp=uicontrol('style','pushbutton','string','load groupcomparison','units','norm');
set(hp,'position',[[0.0090027 0.52632 0.23 0.05]]);
set(hp,'tooltipstring',['optional: load groupcomparisons excelfile or txt-file' ]);
set(hp,'callback',{@loadgroupcomarisons_cb,[]});
set(hp,'fontweight','bold');

set(hp,'tooltipstring',['<html><b>load group-comparisons</b><br>'...
    'This file contains a list of group-comparisons'...
    ' *.txt/*.dat-file or excel-file <br>'...
    ' -if  excel-file  use column-1: each row is a group-comparison <br>'...);
    ' -if  *.txt/*.dat-file  each row is a group-comparison <br>']);

% =========[group-listbox]======================================
hb=uicontrol('style','listbox','string',{'empty'},'units','norm');
set(hb,'position',[0.0054 0.60 0.4 0.34],'tag','lb_groups','max',100);
% set(hp,'callback',{@loadgroupassignment_cb,[]});
set(hb,'enable','on');
set(hb,'tooltipstring',['<html><b>available groups</b><br>'...
    'obtained from group-assignment file']);


% =========[add group1-pb]======================================
hb=uicontrol('style','pushbutton','string','add G1','units','norm');
set(hb,'tooltipstring',['load excelfile with animals and groupassignment' ]);
set(hb,'callback',{@add_group,1});
set(hb,'position',[0.40832 0.94542 0.1 0.05]);
set(hb,'tooltipstring',['add to new group-1' ]);

% =========[add group2-PB]======================================
hb=uicontrol('style','pushbutton','string','add G2','units','norm');
set(hb,'tooltipstring',['load excelfile with animals and groupassignment' ]);
set(hb,'callback',{@add_group,2});
set(hb,'position',[0.40832 0.69462 0.1 0.05]);
set(hb,'tooltipstring',['add to new group-2' ]);

% =========[sg1-listbox]======================================
hb=uicontrol('style','listbox','string',{'empty'},'units','norm','tag','lb_sg1');
set(hb,'position',[0.50996 0.74742 0.4 0.25]);
set(hb,'tooltipstring',['subgroup-1' ]);
% set(hp,'callback',{@loadgroupassignment_cb,[]});
set(hb,'enable','on','max',100);
set(hb,'tooltipstring',['<html><b>Group1-list</b><br>groups in this list will be merge (joined)']);

% =========[sg2-listbox]======================================
hb=uicontrol('style','listbox','string',{'empty'},'units','norm','tag','lb_sg2');
set(hb,'position', [0.50996 0.54282 0.4 0.2] );
set(hb,'tooltipstring',['subgroup-2' ]);
% set(hp,'callback',{@loadgroupassignment_cb,[]});
set(hb,'enable','on','max',100);
set(hb,'tooltipstring',['<html><b>Group2-list</b><br>groups in this list will be merge (joined)']);

% =========[submit-pb]======================================
hb=uicontrol('style','pushbutton','string','submit','units','norm');
set(hb,'tooltipstring',['submit subgroups to list' ]);
set(hb,'callback',{@submit,1});
set(hb,'position',[0.40832 0.52962 0.1 0.07],'backgroundcolor',[.9 .7 .1]);

set(hb,'tooltipstring',['<html><b>submit and make a group-comparison</b><br>'...
    'groups from G1-list and G2-list will be merged independently <br>'...
    'the group-comparison apprears in the lower listbox']);


% =========[clear sg1]======================================
hb=uicontrol('style','pushbutton','string','clear','units','norm');
set(hb,'tooltipstring',['clear Group1-list' ]);
set(hb,'callback',{@xclear,1});
set(hb,'position',[0.90928 0.94872 0.06 0.05],'backgroundcolor',[1 0 0]);
set(hb,'fontsize',7);

% =========[clear sg2]======================================
hb=uicontrol('style','pushbutton','string','clear','units','norm');
set(hb,'tooltipstring',['clear Group2-list' ]);
set(hb,'callback',{@xclear,2});
set(hb,'position',[0.90928 0.69762 0.06 0.05],'backgroundcolor',[1 0 0]);

% =========[clear-item sg1]======================================
hb=uicontrol('style','pushbutton','string','clear item','units','norm');
set(hb,'tooltipstring',['clear selected item(s) from Group1-list' ],'fontsize',7);
set(hb,'callback',{@xclear,3});
set(hb,'position',[0.91109 0.83322 0.08 0.05],'backgroundcolor',[1 .8 .8]);

% =========[clear-item sg2]======================================
hb=uicontrol('style','pushbutton','string','clear item','units','norm');
set(hb,'tooltipstring',['clear selected item(s) from Group2-list' ],'fontsize',7);
set(hb,'callback',{@xclear,4});
set(hb,'position',[0.90928 0.60222 0.08 0.05],'backgroundcolor',[1 .8 .8]);


% =========[clear final]======================================
hb=uicontrol('style','pushbutton','string','clear','units','norm');
set(hb,'tooltipstring',['clear group-comparison list' ]);
set(hb,'callback',{@xclear,5});
set(hb,'position',[[0.0090027 0.067617 0.06 0.05]],'backgroundcolor',[1 0 0]);

% =========[clear-item final]======================================
hb=uicontrol('style','pushbutton','string','clear item','units','norm');
set(hb,'tooltipstring',['clear selected item(s) group-comparison list' ],'fontsize',7);
set(hb,'callback',{@xclear,6});
set(hb,'position',[[0.0090027 0.018117 0.08 0.05]],'backgroundcolor',[1 .8 .8]);

% =========[final-listbox]======================================
hb=uicontrol('style','listbox','string',{'empty'},'units','norm','tag','lb_final');
set(hb,'position',[[0.010818 0.11712 0.98 0.41]]);
set(hb,'tooltipstring',['subgroup-2' ]);
set(hb,'callback',{@lb_final_cb});
set(hb,'enable','on','max',100);
set(hb,'tooltipstring',['<html><b>group-comparison list</b><br>this list contains all group-comparisons']);



c = uicontextmenu;
m1 = uimenu(c,'Label','save group-comparisonList as txt-file','Callback',{@lb_final_context,'saveTXT'});
set(hb,'uicontextmenu',c);

% =========[ok-pb]======================================
hb=uicontrol('style','pushbutton','string','Proceed','units','norm');
set(hb,'tooltipstring',['ok...move on..' ]);
set(hb,'callback',{@ok_cb,1});
set(hb,'position',[0.7913 0.008217 0.1 0.08],'backgroundcolor',[0.7569    0.8667    0.7765]);
set(hb,'tooltipstring',['<html><b>OK..proceed</b><br>write new groupassignment-file(s)']);

% =========[Cancel-pb]======================================
hb=uicontrol('style','pushbutton','string','Close','units','norm');
set(hb,'tooltipstring',['cancel...close gui' ]);
set(hb,'callback',{@ok_cb,0});
set(hb,'position',[0.89476 0.008217 0.1 0.08]);
set(hb,'tooltipstring',['<html><b>cancel</b><br>close gui']);


% =========[help-pb]======================================
hb=uicontrol('style','pushbutton','string','Help','units','norm');
set(hb,'tooltipstring',['get some Help' ]);
set(hb,'callback',{@xhelp,[]});
set(hb,'position',[0.1651 0.94542 0.06 0.05],'backgroundcolor',[1 1 0]);

% =========[outdir]======================================
hb=uicontrol('style','text','string','outdir','units','norm');
set(hb,'fontsize',7);
set(hb,'position', [0.25771 0.061056 0.08 0.05]   ,'backgroundcolor',[1 1 1]);
hb.HorizontalAlignment='right';
set(hb,'tooltipstring',['<html><b>file output directory</b><br>short-name']);

% ---------------------
hb=uicontrol('style','edit','string','groups','units','norm');
set(hb,'fontsize',7,'tag','outdir');
set(hb,'position',  [0.34301 0.064356 0.08 0.05]   ,'backgroundcolor',[1 1 1]);
set(hb,'tooltipstring',['<html><b>file output directory</b><br>short-name']);


% =========[PREFIX]======================================
hb=uicontrol('style','text','string','prefix','units','norm');
set(hb,'tooltipstring',['file output prefix' ],'fontsize',7);
set(hb,'position',[0.42831 0.057756 0.08 0.05],'backgroundcolor',[1 1 1]);
hb.HorizontalAlignment='right';
set(hb,'tooltipstring',['<html><b>use filename-prefix for the resulting file </b><br>..']);

% ---------------------
hb=uicontrol('style','edit','string','gr_','units','norm');
set(hb,'tooltipstring',['file output prefix' ],'fontsize',7,'tag','prefix');
set(hb,'position',  [0.5118 0.064356 0.08 0.05]    ,'backgroundcolor',[1 1 1]);

set(hb,'tooltipstring',['<html><b>use filename-prefix for the resulting file </b><br>..']);


% =========[radio: numerator index]======================================
hb=uicontrol('style','radio','string','prefix index','units','norm');
set(hb,'tooltipstring',['use prefix number' ],'fontsize',7,'tag','prefixnum');
set(hb,'position',    [0.4755 0.0049505 0.15 0.05]          ,'backgroundcolor',[1 1 1]);
set(hb,'value',1);
set(hb,'tooltipstring',['<html><b>use an ascending index within the filename-prefix for the resulting file </b><br>'...
    'this might to improve finding the file<br>'...
    '[0]no<br>[1]yes']);

% =========[radio: all comparisons]======================================
hb=uicontrol('style','radio','string','all comparisons','units','norm');
set(hb,'fontsize',7,'tag','allcomparisons');
set(hb,'position',     [0.63158 0.061056 0.15 0.05]     ,'backgroundcolor',[1 1 1]);
set(hb,'value',1);
set(hb,'tooltipstring',['<html><b>create comparisons</B><br>  [0]selected from listbox<br>[1]all comparisons ' ]);

% =========[radio: do SIMULATE]======================================
hb=uicontrol('style','radio','string','simulate','units','norm');
set(hb,'fontsize',7,'tag','simulate');
set(hb,'position',    [0.63339 0.011517 0.15 0.05]    ,'backgroundcolor',[1 1 1]);
set(hb,'value',0);
set(hb,'tooltipstring',['<html><b>simulate n</B><br>  [0]write comparisons<br>[1]simulate...write no output ' ]);




% =========[items selected/comparisons]======================================
hb=uicontrol('style','text','string',['comparisons: 0/0'],'units','norm');
set(hb,'tooltipstring',['number of group comparisons: selected/total' ],'fontsize',7);
set(hb,'position',  [0.092496 0.064317 0.15 0.05] ,'backgroundcolor',[1 1 1],...
    'foregroundcolor',[0 .5 0],'tag','tx_selected');
hb.HorizontalAlignment='left';
set(hb,'tooltipstring',['<html><b>number of group comparisons</b><br>'...'
    'selected/total' ]);

%% ========= userdata ======================================
set(hf,'userdata',u);


function lb_final_context(e,e2,task)
if strcmp(task,'saveTXT');
  hf=findobj(0,'tag','makeSubgroups');
  hb=findobj(hf,'tag','lb_final');
  li=get(hb,'string');
  li(strcmp(li,'empty'))=[];
  if isempty(li)
      msgbox('group comparison list is empty');
      return
  end
  
  [fi pa]= uiputfile(fullfile(pwd,'*.txt'),'save comparison-list as *.txt-file');
  f2=fullfile(pa,fi);
  
  pwrite2file(f2,li)
  showinfo2('group-comparison list saved',f2); 
end


function lb_final_cb(e,e2)
finalLB_countcomparisons();


function loadgroupcomarisons_cb(e,e2,argin)

%% ===============================================

[fi pa]=uigetfile(fullfile(pwd,'*.xlsx;*.xls;*.txt;*.dat'),'load group-comparison file') ;
f1=fullfile(pa,fi);
if isnumeric(fi); return;end
hf=findobj(0,'tag','makeSubgroups');

z.subgroupfile=f1;
z=load_subgroupfile(z);

hf=findobj(0,'tag','makeSubgroups');
if ~isempty(hf)
    u=get(hf,'userdata');
    u.subgroupfile=z.subgroupfile
    set(hf,'userdata',u);
end


hb=findobj(hf,'tag','lb_final');
set(hb,'string',z.subgrouplist,'value',1);
finalLB_countcomparisons;

%% ===============================================

function z=load_subgroupfile(z);
%% ===============================================
[pa fi ext]=fileparts(z.subgroupfile);
if strcmp(ext,'.xlsx') || strcmp(ext,'.xls')
    [~,~,a0]=xlsread(z.subgroupfile);
    ha=a0(1,:);
    a =a0(2:end,:);
    a=cellfun(@(a){[num2str(a)]} ,a ); %to string
    idelrow=find(strcmp(a(:,1),'NaN')>0);
    a(idelrow,:)=[];%remove empty cells
elseif strcmp(ext,'.txt') || strcmp(ext,'.dat')
    a=preadfile(z.subgroupfile);
    a=a.all;
    iuse=regexpi2(a,' VS. | VS ');
    a=a(iuse);
end

a=regexprep(a,{'^\s+' '\s+$'},''); %remove spaces add begin & end
z.subgrouplist=a(:,1);

%% ===============================================

function loadgroupassignment_cb(e,e2,groupfile)
hf=findobj(0,'tag','makeSubgroups');

isUI=1;
if exist('groupfile')==1 && exist(groupfile)==2
    isUI=0;
end

if isUI==1
    [fi pa]=uigetfile(fullfile(pwd,'*.xlsx;*.xls'),'load grouassignment file') ;
    f1=fullfile(pa,fi);
else
    f1=groupfile;
end
u=get(hf,'userdata');
u.groupfile=f1;
set(hf,'userdata',u);


[ha a grouplabels]=read_groupfile(u);
%======[read excel-file]=========================================

% [~,~,a0]=xlsread(f1);
% ha=a0(1,:);
% a =a0(2:end,:);
% a=cellfun(@(a){[num2str(a)]} ,a ); %to string
% idelrow=find(sum([strcmp(a(:,1),'NaN') strcmp(a(:,2),'NaN')],2)>0);
% a(idelrow,:)=[];%remove empty cells
% grouplabels=unique(a(:,2))

hb=findobj(hf,'tag','lb_groups');
set(hb,'string',grouplabels);
set(hb,'enable','on');


function [ha a grouplabels]=read_groupfile(u);
% [~,~,a0]=xlsread(f1);
% [pa fi ext]=fileparts(u.groupfile);
% if strcmp(ext,'.xlsx') || strcmp(ext,'.xls')
    [~,~,a0]=xlsread(u.groupfile);
    ha=a0(1,:);
    a =a0(2:end,:);
    a=cellfun(@(a){[num2str(a)]} ,a ); %to string
    idelrow=find(sum([strcmp(a(:,1),'NaN') strcmp(a(:,2),'NaN')],2)>0);
    a(idelrow,:)=[];%remove empty cells
% elseif strcmp(ext,'.txt') || strcmp(ext,'.dat')
%     a=preadfile(u.groupfile);
%     a=a.all;
%     iuse=regexpi2(a,' VS. | VS ');
    
    
    
% end

grouplabels=unique(a(:,2));




function xhelp(e,e2,argin)
uhelp([mfilename '.m']);
% ==============================================
%%   add to subgroup
% ===============================================
function add_group(e,e2,argin)
hf=findobj(0,'tag','makeSubgroups');
hb=findobj(hf,'tag','lb_groups');

sel=hb.String(hb.Value);

if argin==1
    hl=findobj(hf,'tag','lb_sg1');
    ho=findobj(hf,'tag','lb_sg2');
    
elseif argin==2
    hl=findobj(hf,'tag','lb_sg2');
    ho=findobj(hf,'tag','lb_sg1');
end
set(hl,'enable','on');

%compare lists & beware of including group in two lists
ix=find(ismember(ho.String,sel)~=0);
if ~isempty(ix)
    %ho.String(ix)
    msgbox([['The following group(s) already assigned to subgroup-'...
        num2str(setdiff([1 2],argin)) ];ho.String(ix)],'warning','warn','replace');
    return
end



pres=cellstr(hl.String);
pres(regexpi2(pres,'empty'))=[];

pres=[pres; sel];
pres=unique(pres,'stable');
set(hl,'value',1,'string',pres);


% ==============================================
%%   clear list/item
% ===============================================

function xclear(e,e2,argin)
hf=findobj(0,'tag','makeSubgroups');
if argin==1 || argin==3
    hl=findobj(hf,'tag','lb_sg1');
elseif argin==2 || argin==4
    hl=findobj(hf,'tag','lb_sg2');
elseif argin==5 || argin==6
    hl=findobj(hf,'tag','lb_final');
end

if argin==1 || argin==2 || argin==5 %clear listbox
    set(hl,'string',{'empty'})
else
    pres=cellstr(hl.String);
    sel=hl.Value;
    pres(sel)=[];
    if isempty(pres); pres={'empty'};end
    set(hl,'value',1,'string',pres);
    
end
finalLB_countcomparisons();

% ==============================================
%%   function final listbox counter
% ===============================================
function finalLB_countcomparisons
%% ===============================================


hf=findobj(0,'tag','makeSubgroups');
hb=findobj(hf,'tag','lb_final');
li=hb.String;
li(strcmp(li,'empty'))=[];
ncomps=length(li);
va=length(hb.Value);

if va==1
    if strcmp(hb.String(va),'empty')==1
        va=0;
    end
end
ht=findobj(hf,'tag','tx_selected');
set(ht,'string',[ 'comparisons: ' num2str(va) '/' num2str(ncomps)]);



% ==============================================
%%  submit
% ===============================================
function submit(e,e2,argin)
%% ===============================================

hf=findobj(0,'tag','makeSubgroups');
h1=findobj(hf,'tag','lb_sg1');
h2=findobj(hf,'tag','lb_sg2');

s1=h1.String;
s2=h2.String;

ix=find(strcmp([s1;s2],'empty'));
if ~isempty(ix)
    msgbox(['Can''t submit.. one of the subgroups is empty! '...
        ],'warning','warn','replace');
    return
end
% ==============================================
%  make string
% ===============================================
v1=strjoin(s1,' & ');
v2=strjoin(s2,' & ');

if length(s1)>1;     v1=['(' v1 ')']; end
if length(s2)>1;     v2=['(' v2 ')']; end

gc=[  v1 ' vs. ' v2];

% ==============================================
%%   add to list
% ===============================================
hb=findobj(hf,'tag','lb_final');
set(hb,'enable','on');
m=[hb.String; gc];
m(regexpi2(m,'empty'))=[];
m=unique(m,'stable');
set(hb,'string',m);
finalLB_countcomparisons();
%% ===============================================

function ok_cb(e,e2,argin)
hf=findobj(0,'tag','makeSubgroups');
if argin==0
    close(hf);
    return
end

%% =======[ok was pressed]========================================
if argin==1
    
    hf=findobj(0,'tag','makeSubgroups');
    u=get(hf,'userdata');
    if isfield(u,'groupfile')==0
       
        msgbox('group-file not loaded');
        return
    else
        s.groupfile     =u.groupfile;
    end
    
    
    hb=findobj(hf,'tag','lb_final');
    s.subgrouplist  =hb.String;
    s.subgrouplist(strcmp(s.subgrouplist,'empty'))=[];
    
    if isempty(s.subgrouplist)
         msgbox('list of group comparisons is empty');
         return
    end
    %% ===============================================
    % ---check if other contrast where added than use list otherwise use file
    u=get(hf,'userdata');
    if isfield(u,'subgroupfile')
        L1=s.subgrouplist;
        
        zt.subgroupfile=u.subgroupfile;
        zt=load_subgroupfile(zt);
        L2=zt.subgrouplist;
        
        L1s=L1;
        for i=1:length(L2)
            L1s(strcmp(L1s,L2(i)))=[];
            %             disp('---');
            %             disp(L1s);
        end
        if isempty(L1s) && length(L1)==length(L2) %identical ...thus using the file
           s=rmfield(s,'subgrouplist');
           s.subgroupfile=u.subgroupfile;
        end
        
    end
    %% ===============================================
    
    
    s.outdir        =get(findobj(hf,'tag','outdir'),'string');
    s.prefix        =get(findobj(hf,'tag','prefix'),'string');
    s.prefixindex   =get(findobj(hf,'tag','prefixnum'),'value');
    s.simulate      =get(findobj(hf,'tag','simulate'),'value');
    s.isGui         =1;
    
    %which comparisons to process
    rd_processindex=get(findobj(hf,'tag','allcomparisons'),'value');
    if rd_processindex==0
        s.processindex  =hb.Value;
    else
        s.processindex   =inf;
    end
    %close(hf);
    process(s);
end





% ==============================================
%%   function process
% ===============================================

function process(z)

% ==============================================
%%   batch
% ===============================================
z2=z;
try;z2=rmfield(z2,'iswait'); end
try;z2=rmfield(z2,'isdesktop'); end
try;z2=rmfield(z2,'isGui'); end
isGUI=z.isGui;
% ===============================================
p={...
 'groupfile' '' 'group-assignment file (excel)'
 'subgroupfile' '' 'file containing a list of group-comparisons (*.txt or excelfile)'
 'subgrouplist' '' 'list of group comparisons'
 'outdir'    '' 'output-directory (shortname)'
 'prefix' '' 'filename-prefix of the new group-comparison file'
 'prefixindex' ''  'use numeric index infilename-prefix of the new group-comparison file '
 'processindex' '' 'index to from group-comparison list to process; us [inf, ''all''] to process all otherwise use a vector of indices such as [1] or [1:3 5]'
 'simulate' ''  'simulate output: [1] simulate only, show data in window; [0] write data'
 };

v=xmakebatch(z2,p, mfilename,[mfilename '(' num2str(isGUI) ',z);' ]);
% char(v)

%% ===============================================



% return


hf=findobj(0,'tag','makeSubgroups');
%% ======[spinner]=========================================
if ~isempty(hf)
    figure(hf)
    waitspin(1,'BUSY','','position',[75 4  30 30],'color',[1 .5 0]);
end
%% ===============================================
[ha a grouplabels]=read_groupfile(z);
%% ===============================================
if isfield(z,'subgroupfile') && isempty(char(z.subgroupfile))==0 && exist(z.subgroupfile)==2
    z=load_subgroupfile(z);
    
end

z.subgrouplist=cellstr( z.subgrouplist);
z.subgrouplist(strcmp(z.subgrouplist,'empty'))=[];
if isempty(char(z.subgrouplist))==1
    msg=(['lower listbox (list of group comparisons") must contain at least one item']);
    if usejava('desktop')==1
        msgbox(msg);
        waitspin(0);
    else
        error(msg);
    end
    return
end

%% ===[check]============================================

% newlabel='combine'
newlabel=1;
groups=unique(a(:,2));
groups=flipud(groups);
groupID=cellfun(@(a){['g' num2str(a)]} ,num2cell([1:length(groups)]') );



index2process=z.processindex; %which index to process
if isinf(z.processindex)
    index2process=1:length(z.subgrouplist);
end
tb2={};
for i=1:length(z.subgrouplist)
    % for i=index2process;
    %             disp(i);
    %             continue
    % ===============================================
    
    m=z.subgrouplist{i};
    %m2=strsplit(m,' vs ')
    m2=regexpi(m,' vs | vs. ','split'); %slit into two groups
    if length(m2)~=2
        disp('___subgroups___');
        disp(char(m2));
        error('does not work---more than two groups not allowed') ;
    end
    m2=regexprep(m2,{'(' ')' '\s+'},{''}); % remove brackest and spaces
    
    
    g1=strsplit(m2{1},'&'); %split subgroups
    g2=strsplit(m2{2},'&');
    
    g1=strrep(g1,'&','');% in case...remove "&" in singular group
    g2=strrep(g2,'&','');
    
    % ===============================================
    
    [~, ig1]=intersect(groups,g1);
    g1ID= groupID(ig1);
    
    [~, ig2]=intersect(groups,g2);
    g2ID= groupID(ig2);
    
    if 0
        disp('-----all groups-----');
        disp([groups groupID]);
        disp('___1st group____');
        disp([g1(:) g1ID]);
        disp('___2nd group____');
        disp([g2(:) g2ID]);
    end
    
    % ===============================================
    tb={};
    compNames={};
    nsubs={};
    ngroups={};
    info={};
    for k=1:2
        if k==1
            dv=g1;
            newID=g1ID;
        else
            dv=g2;
            newID=g2ID;
        end
        
        n=0;
        for j=1:length(dv)
            is=find(strcmp(a(:,2),dv{j}));
            if newlabel==0
                label    =strjoin(dv,'&');
            else
                label   =strjoin(sort(newID),'_');
            end
            labelvec =repmat({label},[length(is) 1]);
            sgrp= repmat({k},[length(is) 1]);
            reflabel=repmat(newID(j),[length(is) 1]);
            tb=[tb;[sgrp  a(is,1)   labelvec   a(is,2)  reflabel]];
            nsubs(end+1,:)={ [  newID{j} ' (' dv{j} '): ']   num2str( length(is) )};
            n=n+length(is);
        end
        compNames{k,1}=label;
        ngroups(end+1,:)={label n};
        
    end
    
    comparison=strjoin(compNames,'__vs__');
    
    info(end+1,:) ={'DATE: ' [' '  datestr(now) ]};
    info(end+1,:) ={'FILE: ' z.groupfile};
    info(end+1,:) ={'COMPARISON: ' m};
    info(end+1,:) ={''  ''};
    info(end+1,:) ={'_NEWGroups__________' '_NumberOfAnimals__________'};
    info          = [info; ngroups];
    info(end+1,:) ={'_ORIGGroups__________' '_NumberOfAnimals__________'};
    info          =[info; ngroups];
    
    
    
    tb2{i}= {comparison tb  info m   [groups groupID ]};
    % ===============================================
end
% tb
%
%
% disp('--------------')
% disp(info)


% ==============================================
%%   write to excel
% ===============================================
warning off;
index='';
prefix='';
if ~isempty(z.prefix)
    prefix=z.prefix;
end


if z.simulate==0
    iswrite=1;
else
    iswrite=0;
end

tsim={};

for i=index2process;
    % for i=15%1:2%length(tb2)
    % for i=index2process;
    %                 disp(i);
    %                 continue
    % ===============================================
    
    %_____prefix_____________
    if z.prefixindex==1
        index=pnum(i,2);
    end
    
    [w1 uscore]=strtok(prefix,'_');
    if isempty(uscore);
        uscore='_';
    end
    if isempty(prefix) && isempty(index); uscore='';end
    namepre=[w1 index uscore];
    
    %____outputdir_____________
    [maindir dirx ext]=fileparts(z.outdir);
    if isempty(maindir)
        global an
        if isempty(an)
            maindir=pwd;
        else
            maindir=fileparts(an.datpath);
        end
    end
    outdir=fullfile(maindir,z.outdir);
    if iswrite==1
        cprintf('*[0 0 1]',['target-Dir:"' strrep(outdir,filesep,[filesep filesep]) '"\n']);
    end
    
    if exist(outdir)~=7
        mkdir(outdir);
    end
    %% ===============================================
    
    %____write excel_____________
    t=tb2{i};
    label=t{1};
    f1name=[namepre label '.xlsx'];
    f1=fullfile(outdir,f1name);
    
    d=t{2};
    grp=cell2mat(d(:,1));
    d=d(:,2:end);
    hd={'animal' 'newGroup' 'oldGroup' 'origin'};
    
    %---info
    ifo=t{3};
    ifo2={'___origGroupsNames__' '_NewGroupNames__'};
    ifo2=[ifo2;  t{5}];
    infox=[ifo;ifo2];
    
    if exist(f1)==2;
        delete(f1);
    end
    
    if iswrite==1
        cprintf('*[0 .5 1]',[ '[' num2str(i) '/' num2str(length(tb2)) '] writing file: "' f1name '" ...wait...\n']);
        
        pwrite2excel(f1,{1 t{1}},hd,{},d);
        pwrite2excel(f1,{2 'info'},{'info'},{},infox);
        try % try colorizing
            row=[num2str(find(grp'==1)+1)];
            xlscolorizeCells(f1,1,['[' row '],[1:2]'],[ 0.8706    0.9216    0.9804 ] );
            row=[num2str(find(grp'==2)+1)];
            xlscolorizeCells(f1,1,['[' row '],[1:2]'],[1.0000    0.9490    0.8667] );
        end
        showinfo2('new grp-file',f1);
    else
        cprintf('*[.7 .7 .7]',[ '[' num2str(i) '/' num2str(length(tb2)) '] simulate: "' f1name '" ...wait...\n']);
        
        
        [~,tsim ]= plog(tsim,[hd;d],0,['#ko  [' num2str(i) '] #lk       '  t{1}  ],'al=1;plotlines=1');
        tsim(end+1,1)={[ ' #kc theoretical outputfile: ' f1name]};
        tsim(end+1,1)={' '};
        tsim(end+1,1)={' ***info *** '};
        [~,tsim ]= plog(tsim,[infox],0,[' #lk '  t{1}  ],'al=1;plotlines=0');
        
        
    end
    %% ===============================================
    
end
cprintf('*[0 .5 1]',[ 'DONE!\n']);

if ~isempty(hf)
    figure(hf)
    waitspin(0,'Done');
end

%% ===show simulation============================================

if z.simulate==1
    uhelp([tsim; repmat({' '},[5 1])],1,'name','simulated group comparisons');
elseif z.simulate==2
    tsim=regexprep(tsim,{' #kc' '#lk' '#ko'},{''}); %remove colorcode;
    disp('=====================================');
    disp(['*** GROUP-COMPARISONS  ***']);
    disp('=====================================');
    disp(char(tsim));
end











