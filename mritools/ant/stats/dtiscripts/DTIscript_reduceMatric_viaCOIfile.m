

%%   create reduced con-matrix via COI-file
% 
% ===============================================
paStudy='f:\data6\DTI_thomas_reduceMatrix';  %study-folder
              
z.LF  ='atlas_lut.txt';                %atlas-look-up-table (lut-file)
z.MF  ='connectome_di_sy.csv';         %MRtrix-output: connectivity matrix (CSV-file)
z.path=fullfile(paStudy,'dat');        %data path
z.COI =fullfile(paStudy,'reducedCONS.xlsx');  %path of COI-file
z.suffix='_RED1'                       %suffix to add to new lut-file & CSV-file
dti_changeMatrix('run',z);             %run function