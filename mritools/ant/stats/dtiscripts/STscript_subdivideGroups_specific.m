
%% <b> script to create <u>specific</u> pairwise comparison files (excel-files) for DTI-comparison  </b>
% - you have an excelfile with group-assignment with more than 2 groups (see example below)
%  -<b><font color=fuchsia>  you want compare specifc groups/ merged sub-groups
%    - merge specific subgroups and compare with other subgroups..
%    - you have to define the group-comparisons (p.comps-variable)
%    - see p.comp and example below
%
% </font>
% -<b><font color=red> This script performes the following steps </b>
%    (a) splits the sample into defined pairwise soubgroups
%    (b) save these pairwise subgroup-compariosns to files (excel-files)
%
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
% p.comps          -cellstring containing the comparisons with 2 cells per row:
%                   -cell-1 with group-names for group1
%                   -cell-2 with group-names for group2
%                   (i.e. each cell contains the groups that should be merged)
%                  -example:
%                     {{'g1'  'g2'}     {'g3'  'g4' 'g5' }} % compare group {'g1' & 'g2'} Versus ('g3' & 'g4' & 'g5')
%                  -see example below for another example
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
%         '20200311PBS_ERANET_brain1…'    'g1'
%         '20200312PBS_ERANET_brain1…'    'g1'
%         '20200227PBS_ERANET_brain1…'    'g1'
%          ...
%         '20200310PBS_ERANET_brain1…'    'g2'
%         '20210713PBS_ERANET_151_LR'      'g2'
%          ...
%         '20210716PBS_ERANET_158_LR'      'g3'
%         '20210716PBS_ERANET_404_CTRL'    'g3'
%         ...
%         '20210721PBS_ERANET_407_CTRL'    'g4'
%         '20210722PBS_ERANET_289_HR'      'g4'
%         ...
%         '20210727PBS_ERANET_410_CTRL'    'g5'
%         '20210802PBS_ERANET_412_CTRL'    'g5'
%         ...
%         '20210818PBS_ERANET_413_CTRL'    'g5'

%% ===============================================

clear; warning off;

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================

p.xlsfile      =fullfile(pwd,'_example_groupAssignment.xlsx')   ; % % the group-assignment file (see help)
p.sheetNumber  = 1                                              ; % % the sheetNUmber
p.name_colidx  = 1                                              ; % % animal name column index
p.group_colidx = 2                                              ; % % group column index
p.isheader     = 1                                              ; % % is header-column used ? [0]no header, data start in row-1,[1] 1st row is the header

p.writeXLS     = 1                                             ; % % [0/1]  write excle-files [0] no, do not write..just test the group-assignment,[1] yes, write group-comparison files
p.outdir       =fullfile(pwd,'groups');                         ; % % output-folder for resulting group-comparison-files (excel-files)

p.comps={...                    %specific comparisons
    {'g1'  'g2'}   {'g3'  }            % compare group ('g1' & 'g2') Versus 'g3'
    {'g1'  'g2'}   {'g3'  'g4' 'g5' }  % compare group {'g1' & 'g2'} Versus ('g3' & 'g4' & 'g5')
    {'g2'}         {'g5'}              % comparegroup 'g2' Versus 'g5'
    {'g1'  }       {'g2' 'g3'  'g4' 'g5' }  % compare group {'g1'} Versus ('g2' &  'g3' & 'g4' & 'g5')
    };


%% ========================================================================
%% #ka  ___ internal stuff ___
%% ========================================================================
cprintf([0 0 1],'Subdivide groups specific comparisons\n');
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


comp=p.comps;


% ==============================================
%%   build subgroup-comparisons
% ===============================================

tb2={' #wk      *** PAIRWISE-COMPARISONS *** ' };
tb2=[tb2;{' #k CHECKLIST... '}];
for i=1:size(comp,1)
    thiscomp=comp(i,:); %this comparison
    comp_string=[ strjoin(thiscomp{1},'_') '_VS_' strjoin(thiscomp{2},'_') '']; %string used for output
    
    %% =========get animals ======================
    
    tb1={};
    infos={[' #ko comparison: '  comp_string ]};
    for k=1:2
        gs1=thiscomp{k};
        newgroupName=strjoin(thiscomp{k},'_');
        groupcases=0;
        infos(end+1,1)={[' #b  group-' num2str(k) ': "<u>'  newgroupName '"' ] };
        for j=1:length(gs1)
            gname=gs1{j};
            ix=find(strcmp(groups, gname));
            dx=[names(ix,1)  repmat({newgroupName},[ length(ix) 1])  groups(ix,1) ];
            tb1=[tb1; dx];
            infos(end+1,1)={['  n of "' gname '": ' num2str(length(ix)) ]};
            groupcases=groupcases+length(ix);
        end
        infos(end+1,1)={['   #g N_total : ' num2str(groupcases) ]};
    end
    %     disp(char(infos));
    %% ===============================================
    
    
    inf01=[infos repmat({' '},[size(infos,1) 2])];
    dinfo= infos;
    dtab=plog([],[{'animalName' 'groupName' 'originalGroup'} ;tb1  ],0,'','plotlines=0');
    tb2=[tb2;dinfo; dtab ; {''}];
    
    
    %         tb2=[tb2;...
    %             [...
    %             {[ ' #ko comparison-' num2str(i)  ']: '  comp_string ] ['']}  ;...
    %             {[' #b no animals "' thiscomp{1} '" : ' ] num2str(length(ix1))};...
    %             {[' #b no animals "' thiscomp{2} '" : ' ] num2str(length(ix1))};...
    %             {' #k animal-Name','  group-Name' 'checkColum'}; tb1 ];...
    %             {'' ''};...
    %             ];
    if p.writeXLS ==1
        %% ============[write xlsfile]=====================
        mkdir(p.outdir);
        nameout=['gc_' comp_string '.xlsx'];
        fileout=fullfile(p.outdir ,nameout);
        %fileout=fullfile(p.outdir ,'_dum.xlsx');
        cprintf([0.9294    0.6941    0.1255],['...writing group-comparison (gc.*) file: '  strrep(fileout,filesep,[filesep filesep])]);
        
        htb1={'animalName' 'groupName' 'originalGroup'};
        pwrite2excel(fileout,{1 'comparison'   },htb1,[],tb1);
        fprintf('Done\n');
        showinfo2('new group-assignment file',fileout);
        %% ===============================================
        
    end
end

% ==============================================
%%  just show the output
% ===============================================
tb2=[tb2; repmat({''},[5,1])];
uhelp(tb2,1,'name','subgroups');


cprintf([0 0 1],'Done!\n');











