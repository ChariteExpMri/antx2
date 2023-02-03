
%% <b> exported data to HPC-cluster for DTI-processing  storage </b>
% <font color="blue"> This script does the following:
%     1) transfer necessary data to HPC-cluster storage
%     2) create batch script that can be run on the HPC-cluster
%         -->as copyNpaste version from help window
%     3) {optional} transfers the batch-file to HPC-cluster* (username+password required!)
%     4) {optional} make batch-file executable*   </font>
% * for 3+4: the user has to provide the hostname, username and password for the HPC-cluster 
% <font color="fuchsia"><b>- TESTED ON WINDOWS ONLY! </font> <font color="#FC0539";size="5">
% 
% _________ [ CHARITE ] ____________________________
% <font color="red"> For CHARITE: only the following paramter have to be set:</font></b></font><code style="display:inline;background-color:D9D9D9;margin:0;font-size:15px;line-height:.0;padding:0;color:000000";><b>
% [1] paHPCstudy_asW      :HPC-TARET-PATH for this study, such as "X:\Imaging\Paul_DTI\_test_AG_Wulczyn"                                                                  
% [2] painDat             :INPUT-DATA-PATH of form ["studypath"+"DTI_export4mrtrix"+"dat"], such as: "H:\Daten-2\Imaging\AG_Wulczyn\Arpp21_Nov2022\DTI_export4mrtrix\dat"
% [3] bash.jobName        :shortname of the job, such as "wulc"                                                                                                                  
% [4] p.animals   (check) :use 'all' to export all animals or use indices for specific animals [1,2,3...] ...animals are copied to HPC-TARGET-PATH                       
% [5] p.start_shfile      :starting shellscript, check species and inserted the adaquate shellscript </code> 
% 
% <b><u><font color="fuchsia"> PREREQUISITES </font></b></u>
% - standard registration to atlas has to be done before
% - all DTIprep-steps have to be done before 
% - The DTIprep-step "export-files" is necessary to create the export-folder "DTI_export4mrtrix" with necessary files!
% - The data from "DTI_export4mrtrix"-folder is than transferred to the HPC-cluster.
%   <b> EXAMPLE FOR MULTISHELL-APPROACH </b>
% The folder "DTI_export4mrtrix" contains the animal-folder
% and each animal folder contains the following files (15 files):       <code style="display:inline;margin:0;font-size:12px;line-height:.0;padding:0;color:0000FF">
%    "c_t2.nii"            "rc_t2.nii"           "rc_mt2.nii"
%    "dwi_b100.nii"        "dwi_b900.nii"        "dwi_b1600.nii"    "dwi_b2500.nii"
%    "grad_b100.txt"       "grad_b900.txt"       "grad_b1600.txt"   "grad_b2500.txt"
%    "ANO_DTI.nii"         "rc_ix_AVGTmask.nii"  "ANO_DTI.txt"      "atlas_lut.txt"  </code>
%% ===============================================
% <b><u><font color="fuchsia"> HOW TO RUN BATCH ON HPC? </font></b></u>
% [1] The "shellscripts"-folder with the necessary shellscripts must be manually
% copied to HPC-storage, into the study-folder. The study folder ("paHPCstudy_asW")
% will finally contain two folders: 
%   (1) "shellscripts" : folder with all shellscripts (sh-files)
%   (2) "data"         : folder with all animals for DTI-processing
% 
% -ideally the resulting HPC-slurm batch-file will than contain the explicit path 
% to the animals in the "data"-folder
% start slurm-batch on the HPC-cluster using "sbatch mybatch.sh" ..where "mybatch.sh" is the name of your batch-file
%% ===============================================

clear; warning off;

%% ==================================================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==================================================================
%% FOR CHARITE: only the following paramter have to be set:
% -------------
% [1] paHPCstudy_asW          :HPC-TARET-PATH for this study, such as "X:\Imaging\Paul_DTI\_test_AG_Wulczyn"
% [2] painDat                 :INPUT-DATA-PATH of form ["studypath"+"DTI_export4mrtrix"+"dat"], such as: "H:\Daten-2\Imaging\AG_Wulczyn\Arpp21_Nov2022\DTI_export4mrtrix\dat"
% [3] bash.jobName            :shortname of the job, such as "wulc"
% [4] p.animals   (check)     :use 'all' to export all animals or use indices for specific animals [1,2,3...] ...animals are copied to HPC-TARGET-PATH
% [5] p.start_shfile          :starting shellscript, check species and inserted the adaquate shellscript
%% ==============================================

%[paHPCstudy_asW]: TARGET-HPC-PATH: Target folder on HPC (use path as seen from WINDOWS (asW))
paHPCstudy_asW     = 'X:\Imaging\Paul_DTI\_test_AG_Wulczyn'  ;% HPC-TARGET-path as seen from WINDOWS (asW)

% [painDat]: WINDOWS-folder withINPUT-data for DTI-processing ; form ["studypath"+"DTI_export4mrtrix"+"dat"]
painDat            = fullfile( 'H:\Daten-2\Imaging\AG_Wulczyn\Arpp21_Nov2022'    ,...
                     'DTI_export4mrtrix','dat');

bash.jobName       = 'WulcTest'   ; % arbitrary name of jobname in bashfile (no space, specific characters)
bash.jobTime       = '7-00'       ; % max-limit on total HPC run time: example: "22:00:00" for 22hours;  "7-00" for 7 days
bash.jobCPUs       = 100          ; % number of CPUs (50 seems to be ok, 120 seems to be a bit better but maybe you have to wait to obtian the capacity)

p.copydirs         = 1            ; % copy the data to HPC: [1] yes, [0] no
p.overwriteDirs    = 0            ; % force to overwrite data on HPC: [1]yes, [0] no, if folder exist do not copy data

%______ animals to export/to included in batch (use "all" or a numeric vector) ____________
p.animals          = 'all'    ;%animals to copy to HPC: 'all': all inimals from "painDat"-dir
%p.animals         = [1 2 3 ] ;%animals to copy  to HPC: 'all': all inimals from "painDat"-dir, or numeric array ; example [1 2 4]

%______ <optional> TRANSFER batch-parameter __________________
p.transferBatch    = 1; % [0,1]transfer batch; [0]no just show batch(copy/nPaste); [1]yes, write batch(sh-file) to HPC-cluster

% ----the following applies only if "p.transferBatch" is "1"
p.HPC_hostname     = 's-sc-frontend2.charite.de'       ; % HPC-hostname:  old HOSTNAME: 's-sc-test4.charite.de
p.makeExecutable   = 1;                                ; % make shellscript executable ('chmod' starter shellscript)
p.condaEnvironment = 'dtistuff'                        ; % name of the conda-environment (containing mrtrix,fsl,ants); otherwise leave empty ('')
p.start_shfile     = 'mouse_dti_complete_7texpmri.sh'  ; % shellscript-starting file: either 'rat_exvivo_complete_7expmri.sh' or 'mouse_dti_complete_7texpmri.sh'

%% =======[FOR CHARITE: DO NOT MODIFY THE FOLLOWING PARAMTERS!!!, otherwise specify 'p.paHPCstudy_asL' ]========================================
p.paHPC            = '/sc-projects/sc-proj-agtiermrt/Daten-2'  ; % MAIN-DIR on HPC to store the data (as seen from LINUX; "asL")
p.paHPCstudy_asL   = [];                                         % for CHARITE: keep empty otherwise specify the target-folder on HPC ..(as seen from LINUX; "asL")








%% ========================================================================
%% #ka  ___ internal stuff ___                  
%% ========================================================================
if isempty(p.paHPCstudy_asL)
    [isplit1 fileseps1]=strsplit(paHPCstudy_asW,  paHPCstudy_asW(min(regexpi(paHPCstudy_asW,'[\\/]'))) ); %split
    [isplit2 fileseps2]=strsplit(p.paHPC,  p.paHPC(min(regexpi(p.paHPC,'[\\/]')))) ;
    p.paHPCstudy_asL=strjoin([p.paHPC isplit1(2:end)], fileseps2{1});
end

% return
p.batchFilename    = ['batch_' bash.jobName '.sh']       ;%filename of the batch-file (sh-file)
[~,studyname]=fileparts(paHPCstudy_asW);


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
    
    mkdir(paHPCstudy_asW);
    for i=1:length(dirs)
        if  ~isempty(find(animal_ids==i)) ;% if animalID is specified
            Sdir=dirs{i};
            [pa,animal]=fileparts(Sdir);
            Tdir=fullfile(paHPCstudy_asW,'data', [ 'a' pnum(i,3)],animal);
            
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
% '#SBATCH --output=my_jobTest4.o    # File name for standard output' % .o%j
% '#SBATCH --error=my_jobTest4.e     # File name for standard error output' e%j
% ''
% 'eval "$(conda shell.bash hook)" # Connect Conda with the bash shell'
% 'conda activate dtistuff            # Activate conda virtual environment'
% ''
% ''
% };
% ==============================================
%% [PART-3] make animal-batch
% ===============================================
space=repmat(' ',[1 10]);
bash.partition='compute';
bash.nodes    =1;
o={...
    '#!/bin/bash'
    ['#SBATCH --job-name='           bash.jobName           '        # Specify job name'  ]
    ['#SBATCH --output='             bash.jobName   '.o'    '        # File name for standard output       (alternative: .o%j)']
    ['#SBATCH --error='              bash.jobName   '.e'    '         # File name for standard error output (alternative: .e%j)']
    ['#SBATCH --partition='          bash.partition         '    # Specify partition name']
    ['#SBATCH --nodes='              num2str(bash.nodes)    '              # Specify number of nodes']
    ['#SBATCH --ntasks-per-node='    num2str(bash.jobCPUs)  '  # Will request 120 logical CPUs']
    ['#SBATCH --time='               bash.jobTime           '            # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)']
  ''
    };

%% ===============================================

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

pastudylx=p.paHPCstudy_asL;
padatlx   =[pastudylx '/data'];
pascriptslx =[pastudylx '/shellscripts'];


% =====get animal folders==========================================
padat=fullfile(paHPCstudy_asW,'data');
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






