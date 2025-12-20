
% ==============================================
%%   
% ===============================================



z.rec      = [1];                             % % find recursively in all subfolders {0,1}                   
z.mdirs    = { 'F:\data6\voxwise\sub1' };     % % DIRs to search (keep empty to use selected from listbox)   
z.flt      = 's1.nii';                        % % [SELECT] files to zipp/unzipp                              
z.keep     = [1];                             % % keep original file {0,1}                                   
z.parallel = [0];                             % % use parallel processinf {0,1}                              
z.sim      = [2];                             % % simulate to show which file will be zipped/unzipped {0,1,2}
zipfile(1,z); 

%% [for all mdirs ]===============================================
z=[];                                                                                                        
z.rec      = [0];            % % find recursively in all subfolders {0,1}                                    
z.mdirs    = 'all';          % % DIRs to search (keep empty to use selected from listbox)                    
z.flt      = 'vimg.nii';     % % [SELECT] files to zipp/unzipp                                               
z.keep     = [1];            % % keep original file {0,1}                                                    
z.parallel = [0];            % % use parallel processinf {0,1}                                               
z.sim      = [2];            % % simulate to show which file will be zipped/unzipped {0,1,2}                 
zipfile(0,z);  
%% [only selected mdirs ]= ===============================================
z=[];                                                                                                        
z.rec      = [0];            % % find recursively in all subfolders {0,1}                                    
z.mdirs    = '';          % % DIRs to search (keep empty to use selected from listbox)                    
z.flt      = 'vimg.nii';     % % [SELECT] files to zipp/unzipp                                               
z.keep     = [1];            % % keep original file {0,1}                                                    
z.parallel = [0];            % % use parallel processinf {0,1}                                               
z.sim      = [2];            % % simulate to show which file will be zipped/unzipped {0,1,2}                 
zipfile(0,z);   
%% [specific dirs + recursively]= ===============================================
z=[];                                                                                                                       
z.rec      = [1];                                            % % find recursively in all subfolders {0,1}                   
z.mdirs    = { 'F:\data6\voxwise\dat\animal_grp1_001'        % % DIRs to search (keep empty to use selected from listbox)   
               'F:\data6\voxwise\dat\animal_grp2_007' };                                                                    
z.flt      = 'vimg.nii';                                       % % [SELECT] files to zipp/unzipp                              
z.keep     = [1];                                            % % keep original file {0,1}                                   
z.parallel = [0];                                            % % use parallel processinf {0,1}                              
z.sim      = [2];                                            % % simulate to show which file will be zipped/unzipped {0,1,2}
zipfile(1,z); 



