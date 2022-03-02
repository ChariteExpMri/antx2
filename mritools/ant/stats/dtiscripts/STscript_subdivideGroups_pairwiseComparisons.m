
%% <b> script to create all pairwise comparison bases on a 
% group-assignment file (excel-file) for DTI-comparison  </b>
% PROBLEM:
% - you have an excelfile with group-assignment with more than 2 groups (see example below)
%   and you want to compare all these groups in a pairwise fashion
% 
% -<b><font color=red> This script performes the following steps </b> 
%    (a) splits the sample into all pairwise soubgroups  
%    (b) save these pairwise subgroup-comparisons to files (excel-files)
% 
% - These new pairwise group-assignments (excel-files) can be than used
%   for pairwise comparisons for the DTI-statistic ("dtistat.m")
% 
% ========================================================
% -<b><font color=blue> VARIABLE PARAMETER   </b>
% ========================================================
% <pre>
% p.xlsfile        - FULLPATH NAME of the group-assignment file
%                  - see example below
%                  - example: fullfile(pwd,'group_assignment_24feb22.xlsx') ;
% p.sheetNumber    - the sheetNUmber  
%                  - default: 1
% p.name_colidx    - animal name column index
%                  - default: 1
% p.group_colidx   - group column index
%                  - default: 2
% p.isheader       - is header-column used: 
%                  - [0]no header, data start in row-1
%                  - [1] 1st row is the header;  
%                  - default: 1
% p.writeXLS       - [0/1]  write excle-files
%                  - [0] no, do not write..just test the group-assignment
%                  - [1] yes, write group-comparison files  
%                  -(default: 1) 
% p.outdir         - output-folder for resulting group-comparison-files (excel-files); 
%                  - example:  p.outdir=fullfile(pwd,'groups');                  
% 
% 
%% =================================================================
% -<b><font color=green> EXAMPLE-INPUT: group-assignment excel-file
%% =================================================================
% <pre>
% -this is an excelfile with a sheet containing two rows:
% column-1: animal-IDs (names) as used in the dat-folder
%           (containing the DTI-data)
% column-2: -group-assignment (numeric or char) names
%          -splitting the sample into subgroups 
%          
% example-content of the excel-sheet:
% 
%         NAMES                        GROUPS
%         20210723PBS_ERANET_165_LR      LR
%         20210713PBS_ERANET_151_LR      LR
%         20210725_PBS_ERANET_409_CTRL   CTRL
%         20210726PBS_ERANET_279_HR      HR 
%         20210720PBS_ERANET_301_HR      HR
%         20210727PBS_ERANET_410_CTRL    CTRL
%         ..                             ..
%         20210818PBS_ERANET_413_CTRL   CTRL

%% ===============================================

clear; warning off;

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================

p.xlsfile      =fullfile(pwd,'group_assignment_24feb22.xlsx')   ; % % the group-assignment file (see help) 
p.sheetNumber  = 1                                              ; % % the sheetNUmber
p.name_colidx  = 1                                              ; % % animal name column index 
p.group_colidx = 2                                              ; % % group column index 
p.isheader     = 1                                              ; % % is header-column used ? [0]no header, data start in row-1,[1] 1st row is the header

p.writeXLS     = 1                                              ; % % [0/1]  write excle-files [0] no, do not write..just test the group-assignment,[1] yes, write group-comparison files 
p.outdir       =fullfile(pwd,'groups');                         ; % % output-folder for resulting group-comparison-files (excel-files)

%% ========================================================================
%% #ka  ___ internal stuff ___                  
%% ========================================================================
cprintf([0 0 1],'Subdivide groups all pairwise comparisons\n');
[~,~,a]=xlsread(p.xlsfile,p.sheetNumber);
idel=strcmp(cellfun(@(a){[ num2str(a) ]} ,a(:,p.name_colidx)),'NaN'); %delete nan/empty-rows
a(idel,:)=[];
if p.isheader==1
    ha=a(1,:);
    a=a(2:end,:);
end
a=cellfun(@(a){[ num2str(a) ]} ,a); %convert entire table to string
groups  =a(:,p.group_colidx);  %group
names   =a(:,p.name_colidx);   %names
 % ==============================================
%%   group-comparisons/contrasts
% ===============================================

% HERE WE USE ALL COMBINATIONS
comp=allcomb(unique(groups),unique(groups));
comp(find(cell2mat(cellfun(@(a,b){[ strcmp(a, b)]} ,comp(:,1),comp(:,2)))),:)=[]; % remove groups comparing with itself
comp=sort(comp')'  ;
[~,ix]=unique(cellfun(@(a,b){[ a '_' b ]} ,comp(:,1),comp(:,2))); % use identical comparisons only ones

comp=comp(ix,:);


% ==============================================
%%   build subgroup-comparisons 
% ===============================================

tb2={' #wk      *** PAIRWISE-COMPARISONS *** ' ' '};
tb2=[tb2;{' #k CHECKLIST... ' ''; '' ''}];
for i=1:size(comp,1)
    thiscomp=comp(i,:); %this comparison
    comp_string=[thiscomp{1} '_VS_' thiscomp{2}]; %string used for output
    ix1=find(strcmp(groups, thiscomp{1})); %idx of group-1
    ix2=find(strcmp(groups, thiscomp{2})); %idx of group-2
    %---
    tb1=[];
    tb1=[tb1; [[names(ix1,1) groups(ix1,1) ]] ];% collect subgroups
    tb1=[tb1; [[names(ix2,1) groups(ix2,1) ]] ];%
    
    if p.writeXLS ==0
        tb2=[tb2;...
            [...
            {[ ' #ko comparison-' num2str(i)  ']: '  comp_string ] ['']}  ;...
            {[' #b no animals "' thiscomp{1} '" : ' ] num2str(length(ix1))};...
            {[' #b no animals "' thiscomp{2} '" : ' ] num2str(length(ix1))};...
            {' #k animal-Name','  group-Name' }; tb1 ];...
            {'' ''};...
            ];
    elseif p.writeXLS ==1
        %% ============[write xlsfile]=====================
        mkdir(p.outdir);
        nameout=['gc_' comp_string '.xlsx'];
        fileout=fullfile(p.outdir ,nameout);
        cprintf([0.9294    0.6941    0.1255],['...writing group-comparison (gc.*) file: '  strrep(fileout,filesep,[filesep filesep])]);
        
        htb1={'animalName' 'groupName'};
        pwrite2excel(fileout,{1 'comparison'   },htb1,[],tb1);
        fprintf('Done\n');
        showinfo2('new group-assignment file',fileout);
        %% ===============================================
        
    end
end

% ==============================================
%%  just show the output
% ===============================================
if p.writeXLS ==0
    uhelp(plog([],[tb2],0,'','al=1'),1,'name','subgroups');
end

cprintf([0 0 1],'Done!\n');

    
    
    
    
    
    
    
    
    
    
    
