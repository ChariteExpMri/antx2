



if 1
  
   
    
    paramfiles={'O:\data2\x01_maritzen\Maritzen_DTI\M6590_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M6591_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M6615_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M6617_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7065_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7067_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7068_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7070_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7334_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M7338_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9513_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9515_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9533_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9534_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9535_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9536_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9536echte_dti_parameter_stat.txt'
        'O:\data2\x01_maritzen\Maritzen_DTI\M9539_dti_parameter_stat.txt'}
    
    
    confiles={
        'O:\data2\x01_maritzen\Maritzen_DTI\20161215TM_M6590_dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20161215TM_M6591__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M6615__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M6617__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M7065__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170112TM_M7067__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7068__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7070__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7334__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170113TM_M7338__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9513__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9515__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9533__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9534__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170223TM_M9535__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9536__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9536echte__dti_1000K_seed_rk4_end.mat'
        'O:\data2\x01_maritzen\Maritzen_DTI\20170224TM_M9539__dti_1000K_seed_rk4_end.mat'}
    
    
    
    
    
    pa='O:\data2\x01_maritzen\Maritzen_DTI'
    dtistat('groupfile', fullfile(pa,'#groups_Animal_groups.xlsx'),...
        'confiles',confiles,'paramfiles',paramfiles, 'f1design',0,'typeoftest1','WST',...
        'isfdr',1 ,'showsigsonly',1 ,...
        'issort',1,'qFDR',0.05,'runstat','con')

end

if 0
      dtistat(struct('groupfile', fullfile(pwd,'#groups_Animal_groups.xlsx')))
      
      dtistat('groupfile', fullfile(pwd,'#groups_Animal_groups.xlsx'),...
    'confiles',confiles,'paramfiles',paramfiles)
end
