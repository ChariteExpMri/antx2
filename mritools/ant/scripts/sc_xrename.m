

% <b> xrename examples   </b>          
% <font color=fuchsia><u>select from below examples:</u></font>
% - create a copy of 't2_orig.nii' and save as 't2.nii'  
% - set intensity of 't2_orig.nii' above zero and add value 100; save as 't2.nii' 
% - change voxelsize of 't2_orig.nii' to 0.12 ; save as 't2.nii'



%% ======================================================================================
%%  create a copy of 't2_orig.nii' and save as 't2.nii'                                                            
%% ======================================================================================
z=[];                                                                                           
z.files={ 't2_orig.nii' 	't2.nii' 	':' };                                        
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) ); 

%% ======================================================================================
%%  set intensity of 't2_orig.nii' above zero and add value 100; save as 't2.nii'                                                                  
%% ======================================================================================
z=[];                                                                                           
z.files={ 't2_orig.nii' 	't2.nii' 	'mo:o=i-min(i(:))+100;' };                                        
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );  

%% ======================================================================================
%%  change voxelsize of 't2_orig.nii' to 0.12 ; save as 't2.nii'                                                               
%% ======================================================================================                                      
z=[];                                                                                           
z.files={ 't2_orig.nii' 	't2.nii' 	'vr: 0.12' };                                                       
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );  


