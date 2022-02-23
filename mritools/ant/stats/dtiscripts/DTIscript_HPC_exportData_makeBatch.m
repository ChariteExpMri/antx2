
%% script to distribute exported data for DTI-processing to HPC-cluster storage
% This script does the following
% 1) transfer data to HPC-cluster storage
% 2) create batch script that can be run on the HPC-cluster
%     -->as copyNpaste version from help window
% 3) <optional> transfers the batch-file to HPC-cluster* (username+password required!)
% 4) <optional> make batch-file executable*
%
% * for 3+4: the user has to provide the hostname, username and password for the HPC-cluster 
% #r TESTED ON WINDOWS ONLY!
% 
% #r NOTE/PREREQUISITES:
% -first use "export-files" from DTI-prep-function to obtain only the necessary
% data for DTI-processing. The data from this export-folder is than transferred to 
% the HPCcluster.
% Example the export-folder "DTI_export4mrtrix" contains the animal-folder, and 
% each animal folder contains the following files (15 files):
%     ANO_DTI.nii      dwi_b100.nii     grad_b100.txt    rc_ix_AVGTmask.nii  
%     ANO_DTI.txt      dwi_b1600.nii    grad_b1600.txt   rc_mt2.nii  
%     atlas_lut.txt    dwi_b3400.nii    grad_b3400.txt   rc_t2.nii
%                      dwi_b6000.nii    grad_b6000.txt   c_t2.nii 
% 
% 
%% ===============================================
%% How to run hte batch-file on HPC-cluster
% [1] The "shellscripts"-folder with the necessary shellscripts must be manually
% copied to HPC-storage, into the study-folder. The study folder ("pastudy")
% will finally contain two folders: 
%   (1) "shellscripts" : folder with all shellscripts (sh-files)
%   (2) "data"         : folder with all animals for DTI-processing
% 
% -ideally the reulting HPC-slurm batch-file will than contain the explicit path 
% to the animals in the "data"-folder
% start slurm-batch on the HPC-cluster: type sbatch <mybatch.sh> 
%% ===============================================

clear; warning off;

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================

% [pastudy]: (TARGET), HPC-storage: windows-based STUDYPATH-containing the data and shellscripts on HPC-storage
pastudy='X:\Daten-2\Imaging\Paul_DTI\Eranet\test123_data4DTIproc';

% [painDat]: (SOURCE), the WINDOWS-folder containing the INPUT-data for DTI-processing (output of DTIprep-"export files ")
painDat=fullfile('H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\Brains_charge2_July2021',...
    'DTI_export4mrtrix','dat');


bash.jobName  ='test124'   ; % arbitrary name of jobname in bashfile (no space, specific characters)
bash.jobTime  ='7-00'       ; % max-limit on total HPC run time: example: "22:00:00" for 22hours;  "7-00" for 7 days
bash.jobCPUs  =100          ; % number of CPUs (50 seems to be ok, 120 seems to be a bit better but maybe you have to wait to obtian the capacity)


p.copydirs     =1           ;% should the data be copied [1] yes, [0] no
p.overwriteDirs=0           ;% force overwrite copyied data [1]yes, [0] no, if folder exist do not copy data

%______ animals to export/to included in batch (use "all" or a numeric vector) ____________
%p.animals     ='all'   ;%animals to copy/process: 'all': all inimals from "painDat"-dir
p.animals     =[1,2,4 ] ;%animals to copy/process: 'all': all inimals from "painDat"-dir, or numeric array ; example [1 2 4]--> process animals 1,2 and 4

%______ <optional> TRANSFER batch-parameter __________________
p.transferBatch    = 1; % [0,1]transfer batch; [0]no just show batch(copy/nPaste); [1]yes, write batch(sh-file) to HPC-cluster
% ----the following applies only if "p.transferBatch" is "1"
p.HPC_hostname     = 's-sc-test4.charite.de'   ;%HPC-cluster hostname
p.makeExecutable   = 1;                        ;%make file executable (chmod sh-file)

p.condaEnvironment ='dtistuff'                 ;%name of the conda-environment (containing mrtrix,fsl,ants); otherwise leave empty ('')
p.pastudyHPC       ='/sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/Eranet' ;% the LINUX-based-STUDYPATH-containing the data and shellscripts on HPC-storage
p.start_shfile     ='rat_exvivo_complete_7expmri.sh'  ;% shellscript-starting file




%% ========================================================================
%% #ka  ___ internal stuff ___                  
%% ========================================================================


p.batchFilename    = ['batch_' bash.jobName '.sh']       ;%filename of the batch-file (sh-file)
[~,studyname]=fileparts(pastudy);


%% =====================================================================
%%  [PART-2] copy data to HPC-storage
%% =====================================================================
[dirs] = spm_select('FPList',painDat,'dir','.*');
dirs=cellstr(dirs);

if ischar(p.animals) && strcmp(p.animals,'all')%
    animal_ids=1:length(dirs);
else%numeric
    animal_ids=p.animals;
end

if p.copydirs==1
    iscoping=0;
    
    mkdir(pastudy);
    for i=1:length(dirs)
        if  ~isempty(find(animal_ids==i)) ;% if animalID is specified
            Sdir=dirs{i};
            [pa,animal]=fileparts(Sdir);
            Tdir=fullfile(pastudy,'data', [ 'a' pnum(i,3)],animal);
            
            if exist(Tdir)~=7 || p.overwriteDirs==1
                disp([ 'copying data: '  '[a' pnum(i,3) '] - "' animal  '"   ...wait..' ]);
                copyfile(Sdir,Tdir,'f');
                iscoping=1;
            end
        end %animalID-match
    end%animal
    if iscoping==1
        disp('copy dirs...DONE!');
    end
end




%% =====================================================================
% BACKUP
% o={...
% '#!/bin/bash'
% '#SBATCH --job-name=test4      # Specify job name'
% '#SBATCH --partition=compute        # Specify partition name'
% '#SBATCH --nodes=1              # Specify number of nodes'
% '#SBATCH --ntasks-per-node=120      #120           # Will request 120 logical CPUs'
% '#SBATCH --time=22:00:00             # Set a limit on the total run time'
% '#SBATCH --output=my_jobTest4.o%j    # File name for standard output'
% '#SBATCH --error=my_jobTest4.e%j     # File name for standard error output'
% ''
% 'eval "$(conda shell.bash hook)" # Connect Conda with the bash shell'
% 'conda activate dtistuff            # Activate conda virtual environment'
% ''
% ''
% };
% ==============================================
%% [PART-3] make animal-batch
% ===============================================
o={...
    '#!/bin/bash'
    ['#SBATCH --job-name='       bash.jobName      '                    # Specify job name'  ]
    '#SBATCH --partition=compute                  # Specify partition name'
    '#SBATCH --nodes=1                            # Specify number of nodes'
    ['#SBATCH --ntasks-per-node='    num2str(bash.jobCPUs)       '                 # Will request 120 logical CPUs']
    ['#SBATCH --time='               bash.jobTime          '                           # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)']
    ['#SBATCH --output=my_job_' bash.jobName   '.o%j           # File name for standard output']
    ['#SBATCH --error=my_job_'  bash.jobName   '.e%j            # File name for standard error output']
    ''
    };
oconda={};
if ~isempty(p.condaEnvironment)
    oconda={
        ['eval "$(conda shell.bash hook)"               # Connect Conda with the bash shell']
        ['conda activate ' p.condaEnvironment  '        # Activate conda virtual environment']
        };
end
o= [o; oconda; {'';''}];
    

% pamainlx='sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/Eranet';
% pastudylx =['/' strrep(fullfile(pamainlx,studyname),filesep ,'/')];

pastudylx=p.pastudyHPC;
padatlx   =[pastudylx '/data'];
pascriptslx =[pastudylx '/shellscripts'];


% =====get animal folders==========================================
padat=fullfile(pastudy,'data');
[dirs] = spm_select('List',padat,'dir','^a.*');
animals=cellstr(dirs);

animalsExplicitName={};
for i=1:length(animals)
    animalpath=fullfile(padat, animals{i});
    [dirs] = spm_select('List',animalpath,'dir','^20.*');
    animalsExplicitName{i,1}=dirs;
end

% =====loop==========================================
% scriptname ='_test_listdir.sh';
% scriptname = 'rat_exvivo_complete_7expmri.sh';
scriptname =p.start_shfile;

r={};
for i=1:length(animals)
    
    animalIDtrunk=regexprep(animals{i},'^a',''); %truncated animalID
    if ~isempty(find( animal_ids==str2num(animalIDtrunk) )); %use only this animals
        
        r{end+1,1}=['# ___ animal ['  animals{i} ']: "'  animalsExplicitName{i} '" ___'];
        
        %====[go to animal-path ]======
        g=['cd ' padatlx '/' animals{i}];
        r{end+1,1}=g;
        %clipboard('copy',g); %check
        
        
        %c=['. ' pascriptslx '/' scriptname ];
        c=['./../../shellscripts/' scriptname];
        r{end+1,1}=c;
        % clipboard('copy',c); %check
        
        r{end+1,1}='';
    end
end
s=[o; r];
% display batch
uhelp(s);
msg={...
    '-you can copy the content of this window to a file on the HPC cluster'
    '- make it executable: cmod +x "mybatch.sh"'
    '- and run it via: sbatch "mybatch.sh"'
    'on the HPC-cluster'
    '<br>'
    };
addNote(gcf,'text',msg,'pos',[0.1 .05  .85 .2],'head','Note: HPC-batch','mode','single');

% return
% ==============================================
%%  [4] write batch-file local 
% ===============================================
if p.transferBatch==0; return; end

batchfilename=fullfile(pwd,p.batchFilename);
disp(['..writing batch-file to local,current working Dir']);
pwrite2file(batchfilename,s);


% ==============================================
%%  [4] transfer batch-file to HPC 
% via SSH/SFTP/SCP For Matlab (v2)-package
% ===============================================
%e=which('scp_simple_put');
%if isempty(e) % add package to path
%    addpath(genpath('_paul_temp_doNotDelete'));
%end
[batchPath bathNameTmp batchExt]=fileparts(batchfilename);
batchName=[bathNameTmp batchExt];

% --------------------------------
% [4.1] get username and password
[p.login p.password] = logindlg('Title','HPC-cluster');
if isempty(p.login) | isempty(p.password)
    cprintf('*[1 0 0]',['transfering batchfile to HPC aborted (no username/password provided)' '\n']);
    return
end

% --------------------------------
% [4.2] transfer batchfile
% delete file
cmd=['rm ' batchName];
command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
% transfer file
msg=scp_simple_put(p.HPC_hostname,p.login,p.password,batchName,'',batchPath);

% --------------------------------
% [4.3] verify tranfer
cmd=['[ -f ' batchName  ' ] && echo "File exist" || echo "File does not exist"'];
command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
if strfind(strjoin(command_output,char(10)),'File exist')
    cprintf('*[0 .5 0]',['file "' batchName '" successfully transfered to HPC-cluster ' '\n']);
else
   cprintf('*[1 0 0]',['failed to transfer file "' batchName '" to HPC-cluster! ' '\n']);
end
% --------------------------------
% [4.4] make executable
if p.makeExecutable==1
    % command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,['ls -la ' batchName]);
    cmd=['chmod +x ' batchName ';' ['ls -la ' batchName]  ];
    command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    if length(strfind(command_output{1}(1:10),'x'))>0
        cprintf('*[0 .5 0]',['file "' batchName '" now is executable  ' '\n']);
        disp([' info: ' strjoin(command_output,char(10))]);
    else
        cprintf('*[1 0 0]',['failed to make file "' batchName '" executable!  ' '\n']);
    end
end

disp('Done!');







