
%% <b> CHARITE-HPC (16-09-24), exported data to HPC for DTI-processing  storage </b>
% Changes on our HPC: changed the cryptographic algorithms (hmac-sha2-512)
% now works with SLURM-JOB-ARRAY (parallelize processes) due to restricted proc-time (max 48h) 
% <font color="blue"> This script does the following:
%     1) transfer necessary data to HPC-storage
%     2) create bash-file. This is the starter file to run on the HPC-cluster
%     3) {optional} transfers the bash-file to HPC* (username+password required!)
%     4) {optional} make batch-file executable*   </font>
% * for 3+4: the user has to provide the hostname, username and password for the HPC 
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
% The folder "DTI_export4mrtrix" contains the animal-folders and each animal folder contains the 
% following files:
% <code style="display:inline;margin:0;font-size:12px;line-height:.0;padding:0;color:0000FF">
% #one/more dwi-files: such as...                                         
%     dwi_02_3_DTI_EPI_seg_exvivo_b1600_20dir_18_1.nii       
%     dwi_02_5_DTI_EPI_seg_exvivo_b3400_40dir_20_1.nii       
%     dwi_02_7_DTI_EPI_seg_exvivo_b6000_61dir_2_1.nii        
%     dwi_02_9_DTI_EPI_seg_exvivo_b100_6dir_4_1.nii 
%     one/more btable-files: such as... 
%     grad_02_3_DTI_EPI_seg_exvivo_b1600_20dir_18_1.txt      
%     grad_02_5_DTI_EPI_seg_exvivo_b3400_40dir_20_1.txt      
%     grad_02_7_DTI_EPI_seg_exvivo_b6000_61dir_2_1.txt       
%     grad_02_9_DTI_EPI_seg_exvivo_b100_6dir_4_1.txt 
% #deformation fields from standard to native space and back: ix_warpfield_SS.nii/x_warpfield_NS.nii
% #files in DWI-space:  rc_t2.nii, rc_mt2.nii (t2w-image and bias-corrrected t2w-image)
%                       rc_ix_AVGTmask.nii (brain-mask)
%                       rc_c1t2.nii,rc_c2t2.nii,rc_c3t2.nii (tissue compartments)                            
%                       ANO_DTI.nii/ANO_DTI.txt/atlas_lut.txt (a rough parcellated DTI-atlas)
% # files in native-space  : t2.nii 
% # files in standard-space: AVGT.nii (structural template)   
%% ===============================================
% <b><u><font color="fuchsia"> HOW TO RUN BATCH ON HPC? </font></b></u>
% [1] The "shellscripts"-folder with the necessary shellscripts must be manually
% copied to HPC-storage, into the study-folder. The study folder ("paHPCstudy_asW")
% will finally contain two folders: 
%   (1) "shellscripts" : folder with all shellscripts (sh-files)
%   (2) "data"         : folder with all animals for DTI-processing
% 
%% The HPC bash-file (the starter file):
% -contains the path of the animals in the "data"-folder
% -parallelization is done SLURM-JOB-ARRAY and the ARRAY-ID links to the explicit animal-paths
%% Execution
% execute the bash-file on the HPC-cluster using "sbatch mybatch.sh" ..where "mybatch.sh" is the name of your bash-file
%----------------------------------
% Implementation of SLURM-JOB-ARRAY :  https://blog.ronin.cloud/slurm-job-arrays/
% 
% 
%% ===============================================



clear; warning off;

%% ==================================================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==================================================================
%% FOR CHARITE: only the following paramter have to be set:
% -------------
% [1] paHPCstudy_asW          :HPC-TARGET-PATH for this study, such as "X:\Imaging\Paul_DTI\_test_AG_Wulczyn"
% [2] painDat                 :INPUT-DATA-PATH of form ["studypath"+"DTI_export4mrtrix"], such as: "H:\Daten-2\Imaging\AG_Wulczyn\Arpp21_Nov2022\DTI_export4mrtrix"
% [3] bash.jobName            :shortname of the job, such as "wulc"
% [4] p.animals   (check)     :use 'all' to export all animals or use indices for specific animals [1,2,3...] ...animals are copied to HPC-TARGET-PATH
% [5] p.start_shfile          :starting shellscript, check species and inserted the adaquate shellscript
%% ==============================================

%% -------------[HPC-TARGET-PATH]-------------------------------------------------------------
paHPCstudy_asW     = 'X:\Imaging\Paul_DTI\paul_TESTS_2022_exvivo_MPM_DTI'  ;% HPC-TARGET-path as seen from WINDOWS (asW)

%% ------------[DTI_export4mrtrix-path]------------------------------------------------------------
% [painDat]: WINDOWS-folder withINPUT-data for DTI-processing ; form ["studypath"+"DTI_export4mrtrix"+"dat"]
painDat  = fullfile( 'H:\Daten-2\Imaging\AG_Paul_Brandt\paul_TESTS_2022_exvivo_MPM_DTI'    ,...
    'DTI_export4mrtrix');

%% ------------[jobname]-------------------------------------
bash.jobName       = 'bum'          ; % arbitrary name of jobname in bashfile (no space, no sepcial characters,short)
% --------------------------------------------------------------------------

%______ animals to export to HPC-CLUSTER and USE in batch(s) (use "all" or a numeric vector) ____________
p.numBatchfiles    = 1        ; %number of batchfiles, each batchfile process a subset of animals (default: 1 )
p.animals          = 'all'    ;%animals to copy to HPC: 'all': all inimals from "painDat"-dir
% p.animals        = [1:2]    ;%animals to copy  to HPC: 'all': all inimals from "painDat"-dir, or numeric array ; examples: [1 2 4], [4] or [4,7:10] 

% ----------------[other batch-parameter]--------
bash.jobTime       = '48:00:00'   ; % max-limit on total HPC run time: example: "22:00:00" for 22hours; NOTE: max-allowd time is restricted to 48h ("48:00:00")  ...The 7 days ("7-00") option does not work anymore on our HPC  
bash.jobCPUs       = 100          ; % number of CPUs (cores) per task'; number of CPUs (50 seems to be ok, 120 seems to be a bit better but maybe you must wait to obtain the ressources)
p.copydirs         = 1            ; % copy the data to HPC: [1] yes, [0] no
p.overwriteDirs    = 0            ; % force to overwrite data on HPC: [1]yes, [0] no, if folder exist do not copy data

% --------OTHER PARAMS--------------
p.showBatch        = 0                                                                ; % show batch in extra MATALB-window: [1]yes,[0]no

% ----the following applies only if "p.transferBatch" is "1"
p.transferBatch    = 1;                                                               ; % [0,1]transfer batchfile to HPC; [0]no just show batch(copy/nPaste); [1]yes, write batch(sh-file) to HPC-cluster
p.HPC_hostname     = 's-sc-frontend2.charite.de'                                      ; % HPC-hostname:  old HOSTNAME: 's-sc-test4.charite.de
p.makeExecutable   = 1;                                                               ; % make shellscript executable ('chmod' starter shellscript)
p.condaEnvironment = '/sc-projects/sc-proj-agtiermrt/Daten-2/condaEnvs/dtistuff'      ; % name of the conda-environment (containing mrtrix,fsl,ants); otherwise leave empty ('')
p.start_shfile     = 'run_mrtrix.sh'                                                  ; % shellscript linked in the HPC-batchfile: this file is executed from the starting shellscript (previously:  'rat_exvivo_complete_7expmri.sh' or 'mouse_dti_complete_7texpmri.sh')


%% =======[FOR CHARITE: DO NOT MODIFY THE FOLLOWING PARAMTERS!!!, otherwise specify 'p.paHPCstudy_asL' ]========================================
p.paHPC            = '/sc-projects/sc-proj-agtiermrt/Daten-2'  ; % MAIN-DIR on HPC to store the data (as seen from LINUX; "asL")
p.paHPCstudy_asL   = []                                        ;% for CHARITE: keep empty otherwise specify the target-folder on HPC ..(as seen from LINUX; "asL")
p.paBackup         = 'H:\Daten-2\Imaging\BACKUP_DTI'           ; % backupfolder: essential data can be stored there after processing
%% ======================================================================





%% ========================================================================
%% #ka  ___ internal stuff ___
%% ========================================================================
[~,subdir]=fileparts(painDat);
if strcmp(subdir,'dat')==0
    painDat=fullfile(painDat,'dat');
end


if isempty(p.paHPCstudy_asL)
    [isplit1 fileseps1]=strsplit(paHPCstudy_asW,  paHPCstudy_asW(min(regexpi(paHPCstudy_asW,'[\\/]'))) ); %split
    [isplit2 fileseps2]=strsplit(p.paHPC,  p.paHPC(min(regexpi(p.paHPC,'[\\/]')))) ;
    p.paHPCstudy_asL=strjoin([p.paHPC isplit1(2:end)], fileseps2{1});
end

% return
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

%% =====[write source-file to HPC]==========================================
sf.source=fullfile(fileparts(fileparts(painDat)),'dat');
l={};
l{end+1,1}=['[source]'   sf.source  ];
l{end+1,1}=['[backup]'   p.paBackup ];
l{end+1,1}=['[hostname]' p.HPC_hostname ];
l{end+1,1}=['[HPCtargetdirWin]' paHPCstudy_asW ];
l{end+1,1}=['[HPCtargetdirUnix]' p.paHPCstudy_asL ];
sourcefile=fullfile(paHPCstudy_asW,'source.txt' );
pwrite2file(sourcefile,l);
%% =====[write source-file to study's DTI-folder]======================================
dtipath      =fullfile(fileparts(sf.source),'DTI');
sourcefileDTI=fullfile(dtipath,'source.txt' );
pwrite2file(sourcefileDTI,l);
%% =====================================================================
% EXAMPLE BATCH
% #!/bin/bash
% #SBATCH --job-name=newdire     # Specify job name
% #SBATCH --output=newdire.o%A_%a   # File name for standard output       (alternative: .o%j)
% #SBATCH --error=newdire.e%A_%a    # File name for standard error output (alternative: .e%j)
% #SBATCH --partition=compute    # Specify partition name
% #SBATCH --nodes=1              # Specify number of nodes
% 
% # ____SBATCH --ntasks-per-node=100  # Will request 120 logical CPUs
% 
% #SBATCH --cpus-per-task=100     # Specify number of CPUs (cores) per task  (with 24cpus-->14h)
% #SBATCH --time=22:00:00        # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)
% #SBATCH --array=1-4            # Specify array elements
% 
% eval "$(conda shell.bash hook)"               # Connect Conda with the bash shell
% conda activate dtistuff        # Activate conda virtual environment
% 
% animalID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)
% # ___ animal [a001]: "20191029CH_Exp8_M01" ___
% cd /sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/newHPC_directive_AG_Mundlos/data/a$animalID
% ./../../shellscripts/run_mrtrix.sh


% ==============================================
%% [PART-3] make animal-batch
% ===============================================
space=repmat(' ',[1 10]);
bash.partition='compute';
bash.nodes    =1;

% =====get animal folders==========================================
padat=fullfile(paHPCstudy_asW,'data');
[dirs] = spm_select('List',padat,'dir','^a.*');
animals=cellstr(dirs);
if length(animals)<p.numBatchfiles
    error('more batchfiles than animals...reduce "p.numBatchfiles" ');
end

%% =====get number of animals per charge =============================

chargeIndex=[1:length(animals)]';
n = ceil(numel(animals)/p.numBatchfiles);
p.chargeIndex = reshape([chargeIndex;nan(mod(-numel(chargeIndex),n),1)],n,[]);
%% ===============================================

for ss=1:p.numBatchfiles
    if p.numBatchfiles==1
        addnum='';
    else
        addnum=num2str(ss);
    end
    p.batchFilename    = ['batch_' bash.jobName addnum '.sh']       ;%filename of the batch-file (sh-file)

    % create arrayID
    ChargeIDX=unique(p.chargeIndex(:,ss));
    ChargeIDX(isnan(ChargeIDX))=[];
    ChargeIDX=intersect(ChargeIDX,animal_ids);
    if length(ChargeIDX)==1
        bash.array=[num2str(ChargeIDX) ];
    else
        if any(diff(ChargeIDX)~=1) % not-consecutive numbers
            bash.array= regexprep(strjoin(cellstr(num2str(ChargeIDX)),','),'\s+','');
        else %consecutive numbers
            bash.array=[num2str(min(ChargeIDX)) '-' num2str(max(ChargeIDX))];
        end
    end

    
    o={...
        '#!/bin/bash'
        ['#SBATCH --job-name='           [bash.jobName addnum       ]           '        #Specify job name'  ]
        ['#SBATCH --output='             [bash.jobName addnum  '.o%A_%a' ]   '        #FileName of output with %A(jobID) and %a(array-index);(alternative: .o%j)']
        ['#SBATCH --error='              [bash.jobName addnum  '.e%A_%a' ]   '         #FileName of error with %A(jobID) and %a(array-index);alternative: .e%j)']
        ['']
        ['#SBATCH --partition='          bash.partition         '         # Specify partition name']
        ['#SBATCH --nodes='              num2str(bash.nodes)    '                   # Specify number of nodes']
        ['#SBATCH --cpus-per-task='      num2str(bash.jobCPUs)     '         # Specify number of CPUs (cores) per task' ]
        ['#SBATCH --time='               bash.jobTime           '             # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)']
        ['#SBATCH --array='              bash.array             '                 # Specify array elements (indices), i.e. indices of of parallel processed dataSets  ' ]
        ''
        
        };
    
    %  ['#SBATCH --nodes='              num2str(bash.nodes)    '              # Specify number of nodes']
    %  ['#SBATCH --ntasks-per-node='    num2str(bash.jobCPUs)  '  # Will request 120 logical CPUs']
    %  #SBATCH --array=1-4            # Specify array elements
    
    %% ===============================================
%     ['eval "$(conda shell.bash hook)"               # Connect Conda with the bash shell']
    oconda={};
    if ~isempty(p.condaEnvironment)
        oconda={
            ['eval "$(/opt/conda/bin/conda shell.bash hook)" # Conda initialization in the bash shell']
            ['conda activate ' p.condaEnvironment  '        # Activate conda virtual environment']
            };
    end
    o= [o; oconda; {'';''}];
    
    
    % pamainlx='sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/Eranet';
    % pastudylx =['/' strrep(fullfile(pamainlx,studyname),filesep ,'/')];
    
    pastudylx=p.paHPCstudy_asL;
    padatlx   =[pastudylx '/data'];
    pascriptslx =[pastudylx '/shellscripts'];
    
    
    %     % =====get animal folders==========================================
    %     padat=fullfile(paHPCstudy_asW,'data');
    %     [dirs] = spm_select('List',padat,'dir','^a.*');
    %     animals=cellstr(dirs);
    
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
    r{end+1,1}=['animalID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)'     '                #obtain SLURM-array-ID ']; % extract
    
    
    ChargeIDX=p.chargeIndex(:,ss);
    ChargeIDX(isnan(ChargeIDX))=[];
    
    r{end+1,1}=['cd ' padatlx '/' 'a$animalID' ];
    r{end+1,1}=['./../../shellscripts/' scriptname]; %eval script

    r{end+1,1}='';
    r{end+1,1}='';
    r{end+1,1}=['# ===================================================='];
    r{end+1,1}=['#   INFOS:    DIRS   &   ANIMAL NAMES   '];
    r{end+1,1}=['# ===================================================='];

    
    for i=1:length(ChargeIDX)
        
        animalIDtrunk=regexprep(animals{ChargeIDX(i)},'^a',''); %truncated animalID
        if ~isempty(find( animal_ids==str2num(animalIDtrunk) )); %use only this animals
            
            r{end+1,1}=['# ___ animal ['  animals{ChargeIDX(i)} ']: "'  animalsExplicitName{ChargeIDX(i)} '" ___'];
            
            %====[go to animal-path ]======
            %g=['cd ' padatlx '/' animals{ChargeIDX(i)} ];
            %r{end+1,1}=g;
            %clipboard('copy',g); %check
            %c=['. ' pascriptslx '/' scriptname ];
            %c=['./../../shellscripts/' scriptname];
            %r{end+1,1}=c;
            % clipboard('copy',c); %check
            
            %r{end+1,1}='';
        end
    end
    s=[o; r];

   
    % display batch
    if p.showBatch==1
        if p.numBatchfiles==1;         uhelp(s);
        else                 ;         uhelp(s,1);
        end
            
        msg={...
            '-you can copy the content of this window to a file on the HPC cluster'
            '- make it executable: cmod +x "mybatch.sh"'
            '- and run it via: sbatch "mybatch.sh"'
            'on the HPC-cluster'
            '<br>'
            };
        addNote(gcf,'text',msg,'pos',[0.1 .05  .85 .2],'head','Note: HPC-batch','mode','single');
    end
 
    
    % ==============================================
    %%  [4] write batch-file local
    % ===============================================
    batchfilename=fullfile(pwd,p.batchFilename);
    disp(['..writing batch-file to local,current working Dir']);
    pwrite2file(batchfilename,s);
    
    if p.transferBatch==0; return; end
    
     %continue
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
    if ss==1
        [p.login p.password] = logindlg('Title','HPC-cluster');
        if isempty(p.login) | isempty(p.password)
            cprintf('*[1 0 0]',['transfering batchfile to HPC aborted (no username/password provided)' '\n']);
            return
        end
        global mpw
        mpw.login =p.login;
        mpw.password=p.password;
    end
    
    % --------------------------------
    % [4.2] transfer batchfile
    % delete file
    cmd=['rm ' batchName];
    command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    % transfer file via sftp_simple_put
    msg=sftp_simple_put(p.HPC_hostname,p.login,p.password,batchName,'',batchPath);
    
    % --------------------------------
    % [4.3] verify tranfer
    cmd=['[ -f ' batchName  ' ] && echo "File exist" || echo "File does not exist"'];
    command_output = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    if strfind(strjoin(command_output,char(10)),'File exist')
        cprintf('*[0 .5 0]',['file(' num2str(ss) ') "' batchName '" successfully transfered to HPC-cluster ' '\n']);
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
            cprintf('*[0 .5 0]',['file(' num2str(ss) ') "' batchName '" now is executable  ' '\n']);
            disp([' info: ' strjoin(command_output,char(10))]);
        else
            cprintf('*[1 0 0]',['failed to make file "' batchName '" executable!  ' '\n']);
        end
    end
    
    
end %ss several shell-files
disp('Done!');



