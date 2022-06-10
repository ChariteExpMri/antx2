

%% <b> make subgroups by merging original groups  </b>
% new group-comparisons are defined in a group-comparison list stored in a file
% 
% [groupfile] : the group-assignment file (excel-file) contains two columns:
%              column-1: animal-IDs
%              column-2: groupLabel (which animal belongs to which group)
%  <font color=green><b><u>  *** EXAMPLE of GROUP-ASSIGNMENT FILE *** </b></u>
%               __ANIMAL_ID__                  __GROUP__
%             20210901CH_Exp7_001000     30minMCAO_dMCAO
%             ..
%             202100901CH_Exp7_009989    30minMCAO_sham
%             ..
%             202100901CH_Exp7_009990    sham_dMCAO
%             ..
%             20210902CH_Exp7_010022     sham_sham
%             ..
%    In this truncated example the group-assignment file contains 4 groups.  </font>
% 
% [subgroupfile]: an xlsx/xls-file or txt-file containing a list of new groups assignments
%                (group comparisons list) by joining/merging the original groups
%               - each row is a group-comparison separated by " vs. "
%               - merging groups into one new groups is defined via the " $ "
%   <font color=green><b><u> *** EXAMPLE GROUP COMPARISONS LIST *** </b></u>
%                 30minMCAO_dMCAO vs. 30minMCAO_sham
%                 sham_dMCAO vs. sham_sham
%                 (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_dMCAO
%                 (30minMCAO_dMCAO & 30minMCAO_sham) vs. sham_sham
%                 (30minMCAO_dMCAO & sham_dMCAO) vs. (30minMCAO_sham & sham_sham)
% </font>
% When done, the output-directory ([outdir]) will contain an excelfile for each group-comparsion
% of the group comparisons list. Each new excelfile-file start with prefix 'gr_' ([prefix]) and
% also contain an index-number (prefixindex=[1]) for better discrimination of the files.
% The excelfile-files will be written (simulate=[0]) to disk for all group-comparisons of the
% list (processindex = [inf]). Here we work without GUI(silent mode defined by 1st arg of xnewgroupassignment).
%% ===============================================


pasource='H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI\codes';     % % location of [groupfile] and [subgroupfile]
z=[];                                                                                                                                                                                                                           
z.groupfile    = fullfile(pasource,'2021_Exp7_Exp8_Reinfarkte_groups.xlsx');         % % group-assignment file (excel)                                                                                                          
z.subgroupfile = fullfile(pasource,'groupcomparisons.txt');                          % % file containing a list of group-comparisons (*.txt or excelfile)                                                                       
z.outdir       = 'group';                                                            % % output-directory (shortname)                                                                                                           
z.prefix       = 'gr_';                                                              % % filename-prefix of the new group-comparison file                                                                                       
z.prefixindex  = [1];                                                                % % use numeric index infilename-prefix of the new group-comparison file                                                                   
z.simulate     = [0];                                                                % % simulate output: [1] simulate only, show data in window; [0] write data                                                                
z.processindex = [inf];                                                              % % index to from group-comparison list to process; us [inf, 'all'] to process all otherwise use a vector of indices such as [1] or [1:3 5]
xnewgroupassignment(0,z);  





